`define GetAll(Class, ListVar, IterVar) ForEach AllActors(class'`Class', `IterVar) { `ListVar.AddItem(`IterVar); }

class AK_Game extends UTCTFGame;

var const int NUMBER_OF_FLAGS;
var const int NUMBER_OF_SCORE_ZONES;

var AK_Game_ScoreZone scoreZones[ 2 ];

//"States" of the game
var bool gameHasStarted;
var bool gameIsRestarting;
var float secondsToWaitBeforeRestartingGame;

//Stockpile timers
var int timeBetweenScoresSeconds;
var int secondsBeforeFlagResets;

var int defaultNumberOfScoresToWin;

//--------------------------------------------- Clocks and Timers ---------------------------------------------//
function Timer()
{
	local int i;

	if( !gameHasStarted || gameIsRestarting )
		return;


	if( AK_GameReplicationInfo( GameReplicationInfo ).timeLeftUntilScoringSeconds <= 0 )
	{
		CheckFlagsAndScore();
		if( CheckEndGame( None, "" ) == true )
		{
			EndTheGame();
		}
		else
		{
			ResetFlagsAndBases();
			TriggerGlobalEventClass(class'AK_Kismet_FlagReset',self, 0);        //RW: Code added to trigger Kismet event
		}
	}

	for( i = 0; i < NUMBER_OF_SCORE_ZONES; ++i )
	{
		if( !scoreZones[ i ].hostingFlag )
			continue;
		CheckAndMaybeTickFlagTimer( scoreZones[ i ], AK_GameReplicationInfo( GameReplicationInfo ) );
	}
}

function CheckAndMaybeTickFlagTimer( AK_Game_ScoreZone scoreZone, AK_GameReplicationInfo timerOwner )
{
	local int i;
	local AK_Pawn pawnIterator;
	local array< AK_Pawn > allPawnsInLevel;
	local bool enemyTeamInZone;
	local AK_Pawn enemyPawn;

	enemyTeamInZone = false;
	`GetAll( AK_Pawn, allPawnsInLevel, pawnIterator )
	for( i = 0; i < allPawnsInLevel.Length; ++i )
	{
		//If the pawn is too far away, we don't care
		if( vsize( scoreZone.Location - allPawnsInLevel[ i ].Location ) > scoreZone.radiusOfScoreZone )
			continue;

		//If defenders are in the zone, then reset the timer and don't do anything else
		if( allPawnsInLevel[ i ].GetTeamNum() == scoreZone.DefenderTeamIndex )
		{
			timerOwner.timeLeftUntilFlagIsReturned[ scoreZone.DefenderTeamIndex ] = secondsBeforeFlagResets;
			return;
		}

		enemyTeamInZone = true;
		enemyPawn = allPawnsInLevel[ i ];
	}

	if( enemyTeamInZone )
	{
		`log( "TICK");
		--timerOwner.timeLeftUntilFlagIsReturned[ scoreZone.DefenderTeamIndex ];
	}

	if( timerOwner.timeLeftUntilFlagIsReturned[ scoreZone.DefenderTeamIndex ] <= 0 )
	{
		`log( "SENDING FLAG HOME");
		scoreZone.SendHostedFlagHome( enemyPawn );
		timerOwner.timeLeftUntilFlagIsReturned[ scoreZone.DefenderTeamIndex ] = secondsBeforeFlagResets;
	}
}








//---------------------------------------------- Game State Handling ----------------------------------------------//
//These are in order of their usage!
function InitGameReplicationInfo()
{
	Super.InitGameReplicationInfo();

	AK_GameReplicationInfo( GameReplicationInfo ).timeBetweenFlagScoresSeconds = timeBetweenScoresSeconds;
	AK_GameReplicationInfo( GameReplicationInfo ).timeLeftUntilScoringSeconds = timeBetweenScoresSeconds;
	AK_GameReplicationInfo( GameReplicationInfo ).timeLeftUntilFlagIsReturned[ 0 ] = secondsBeforeFlagResets;
	AK_GameReplicationInfo( GameReplicationInfo ).timeLeftUntilFlagIsReturned[ 1 ] = secondsBeforeFlagResets;
	AK_GameReplicationInfo( GameReplicationInfo ).goalScore = defaultNumberOfScoresToWin;
}

function PostBeginPlay()
{
	local int i;
	local AK_Game_ScoreZone zoneIterator;
	local array< AK_Game_ScoreZone > allScoreZonesInLevel;

	Super.PostBeginPlay();

	`GetAll( AK_Game_ScoreZone, allScoreZonesInLevel, zoneIterator )
	`assert( allScoreZonesInLevel.Length == NUMBER_OF_SCORE_ZONES );

	for( i = 0; i < allScoreZonesInLevel.Length; ++i )
	{
		scoreZones[ allScoreZonesInLevel[ i ].DefenderTeamIndex ] = allScoreZonesInLevel[ i ];
	}
}

function StartMatch()
{
	Super.StartMatch();
	gameHasStarted = true;
}

function bool CheckEndGame( PlayerReplicationInfo Winner, string Reason )
{
	local UTCTFFlag winningTeamsFlag;
	local Controller gameController;

	if( Teams[ 0 ].Score < GoalScore && Teams[ 1 ].Score < GoalScore )
		return false;
	//Check against mutator win conditions. If they say we can't win, we can't win.
	if ( CheckModifiedEndGame(Winner, Reason) )
		return false;

	//-----Past this point, we are assuming the game is over -----//
	if ( Teams[1].Score > Teams[0].Score )
	{
		GameReplicationInfo.Winner = Teams[1];
	}
	else if( Teams[1].Score < Teams[0].Score )
	{
		GameReplicationInfo.Winner = Teams[0];
	}
	else
	{
		GameReplicationInfo.Winner = Teams[0];
	}

	//Find the winning team's flag and focus the camera on it
	winningTeamsFlag = UTCTFTeamAI(UTTeamInfo(GameReplicationInfo.Winner).AI).FriendlyFlag;
	EndGameFocus = winningTeamsFlag.HomeBase;

	//Tell all players the game is over and to focus their camera on the winning team.
	EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
	foreach WorldInfo.AllControllers(class'Controller', gameController)
	{
		gameController.GameHasEnded( EndGameFocus, (gameController.PlayerReplicationInfo != None) && (gameController.PlayerReplicationInfo.Team == GameReplicationInfo.Winner) );
	}
	winningTeamsFlag.HomeBase.SetHidden(False);

	return true;
}

function EndTheGame()
{
	gameIsRestarting = true;
	setTimer( secondsToWaitBeforeRestartingGame, false, nameof( PerformEndGameHandling ) );
}

function PerformEndGameHandling()
{
	super.PerformEndGameHandling();
	RestartGame();
}

function Reset()
{
	AK_GameReplicationInfo( GameReplicationInfo ).timeBetweenFlagScoresSeconds = timeBetweenScoresSeconds;
	AK_GameReplicationInfo( GameReplicationInfo ).timeLeftUntilScoringSeconds = timeBetweenScoresSeconds;
}





//---------------------------------------------- Score Checking ----------------------------------------------//
simulated function CheckFlagsAndScore()
{
	local int i;

	for( i = 0; i < NUMBER_OF_FLAGS; ++i )
	{
		if( Flags[ i ].IsInState( 'Home' ) )
			Teams[ i ].Score += 1;
		else if( Flags[ i ].IsInState( 'PlacedInZone' ) )
			Teams[ 1 - i ].Score += 1;
	}
}

simulated function ResetFlagsAndBases()
{
	local int i;

	for( i = 0; i < NUMBER_OF_FLAGS; ++i )
	{
		Flags[ i ].SendHome( None );
	}

	for( i = 0; i < NUMBER_OF_SCORE_ZONES; ++i )
	{
		scoreZones[ i ].hostingFlag = false;
	}
}

DefaultProperties
{
	NUMBER_OF_FLAGS = 2
	NUMBER_OF_SCORE_ZONES = 2

	Acronym = "AK"
	MapPrefixes(0)="AK"

	MaxPlayersAllowed = 8

	gameHasStarted = false
	gameIsRestarting = false
	secondsToWaitBeforeRestartingGame = 15;

	timeBetweenScoresSeconds = 60			//DH: Changed from 40
	secondsBeforeFlagResets = 5
	defaultNumberOfScoresToWin = 10

	DefaultPawnClass=class'AKHET.AK_Pawn'
    DefaultInventory(0)=class'AKHET.AK_Weapon_WristGun'
    PlayerControllerClass=class'AKHET.AK_PlayerController'
	Hudtype=class'AKHET.AK_Hud_UI'
	GameReplicationInfoClass=class'AKHET.AK_GameReplicationInfo'
    PlayerReplicationInfoClass=class'AKHET.AK_PlayerReplicationInfo'
	bUseClassicHud = true
}
