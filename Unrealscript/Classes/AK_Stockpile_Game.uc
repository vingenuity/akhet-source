class AK_Stockpile_Game extends UTTeamGame;

var const int NEUTRAL_TEAM_INDEX;

var array< AK_Stockpile_Flag > flags;
var AK_Stockpile_ScoreZone scoreZones[ 2 ];

//Stockpile timers
var int timeBetweenScoresSeconds;

//"States" of the game
var bool gameHasStarted;
var bool gameIsRestarting;
var float secondsToWaitBeforeRestartingGame;

var class< LocalMessage > killMessageClass;
var class< LocalMessage > stockpileMessageClass;




//--------------------------------------------- Clocks and Timers ---------------------------------------------//
function Timer()
{
	local AK_Stockpile_GRI GRI;
	GRI = AK_Stockpile_GRI( GameReplicationInfo );

	if( !gameHasStarted || gameIsRestarting )
		return;

	//if( GRI.timeLeftUntilScoringSeconds < 4 )
	//{
	//	BroadcastLocalizedMessage( stockpileMessageClass, 10 + GRI.timeLeftUntilScoringSeconds, None, None, None );
	//}

	if( GRI.timeLeftUntilScoringSeconds <= 0 )
	{
		ScoreAndReturnZonedFlags();
		if( CheckEndGame( None, "" ) == true )
		{
			EndTheGame();
		}
		else
		{
			TriggerGlobalEventClass( class'AK_Kismet_FlagReset',self, 0 );        //RW: Code added to trigger Kismet event
		}

		GRI.shouldResetScoringTimer = true;
		GRI.timeLeftUntilScoringSeconds = GRI.timeBetweenFlagScoresSeconds;
	}
	else
	{
		GRI.shouldResetScoringTimer = false;
	}
}




//---------------------------------------------- Game State Handling ----------------------------------------------//
//These are in order of their usage!
function InitGameReplicationInfo()
{
	local AK_Stockpile_GRI GRI;

	Super.InitGameReplicationInfo();

	GRI = AK_Stockpile_GRI( GameReplicationInfo );
	GRI.timeBetweenFlagScoresSeconds = timeBetweenScoresSeconds;
	GRI.timeLeftUntilScoringSeconds = timeBetweenScoresSeconds;
}

function CreateTeam( int TeamIndex )
{
	Teams[TeamIndex] = spawn( class'AKHET.AK_TeamInfo' );
	Teams[TeamIndex].Faction = TeamFactions[TeamIndex];
	Teams[TeamIndex].Initialize(TeamIndex);
	Teams[TeamIndex].AI = Spawn(TeamAIType[TeamIndex]);
	Teams[TeamIndex].AI.Team = Teams[TeamIndex];
	GameReplicationInfo.SetTeam(TeamIndex, Teams[TeamIndex]);
	Teams[TeamIndex].AI.SetObjectiveLists();
}

function StartMatch()
{
	Super.StartMatch();
	AK_Stockpile_GRI( GameReplicationInfo ).totalNumberOfFlags = flags.Length;
	gameHasStarted = true;
}

function bool CheckEndGame( PlayerReplicationInfo Winner, string Reason )
{
	local int winningTeamIndex;
	local AK_Stockpile_ScoreZone winningTeamsZone;
	local Controller gameController;

	if( GameReplicationInfo.RemainingMinute > 0 || GameReplicationInfo.RemainingTime > 0 )
	{
		if( Teams[ 0 ].Score < GoalScore && Teams[ 1 ].Score < GoalScore )
			return false;
		//Check against mutator win conditions. If they say we can't win, we can't win.
		if ( CheckModifiedEndGame(Winner, Reason) )
			return false;
	}

	//-----Past this point, we are assuming the game is over -----//
	if ( Teams[1].Score > Teams[0].Score )
	{
		GameReplicationInfo.Winner = Teams[1];
		winningTeamIndex = 1;
	}
	else if( Teams[1].Score < Teams[0].Score )
	{
		GameReplicationInfo.Winner = Teams[0];
		winningTeamIndex = 0;
	}
	//else
	//{
	//	GameReplicationInfo.Winner = Teams[0];
	//	winningTeamIndex = 0;
	//}
	else if(bOverTime && Teams[1].Score == Teams[0].Score)
	{
		EndTheGame();
	}

	//Find the winning team's flag and focus the camera on it
	winningTeamsZone = scoreZones[ winningTeamIndex ];
	EndGameFocus = winningTeamsZone;

	//Tell all players the game is over and to focus their camera on the winning team.
	EndTime = WorldInfo.RealTimeSeconds + EndTimeDelay;
	foreach WorldInfo.AllControllers(class'Controller', gameController)
	{
		gameController.GameHasEnded( EndGameFocus, (gameController.PlayerReplicationInfo != None) && (gameController.PlayerReplicationInfo.Team == GameReplicationInfo.Winner) );
	}
	winningTeamsZone.SetHidden(False);

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
	local AK_Stockpile_GRI GRI;
	GRI = AK_Stockpile_GRI( GameReplicationInfo );

	GRI.timeBetweenFlagScoresSeconds = timeBetweenScoresSeconds;
	GRI.timeLeftUntilScoringSeconds  = timeBetweenScoresSeconds;
}




//---------------------------------------------- Score Checking ----------------------------------------------//
//Don't do scoring on lives
function bool CheckScore(PlayerReplicationInfo Scorer)
{ }

// This is a direct copy of UTGame's Killed() function, brought here so that we may localize the "first blood!" message.
function Killed( Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType )
{
	local bool		bEnemyKill;
	local UTPlayerReplicationInfo KillerPRI, KilledPRI;
	local UTVehicle V;

	if ( UTBot(KilledPlayer) != None )
		UTBot(KilledPlayer).WasKilledBy(Killer);

	if ( Killer != None )
		KillerPRI = UTPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( KilledPlayer != None )
		KilledPRI = UTPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);

	bEnemyKill = ( ((KillerPRI != None) && (KillerPRI != KilledPRI) && (KilledPRI != None)) && (!bTeamGame || (KillerPRI.Team != KilledPRI.Team)) );

	if ( (KillerPRI != None) && UTVehicle(KilledPawn) != None )
	{
		KillerPRI.IncrementVehicleKillStat(UTVehicle(KilledPawn).GetVehicleKillStatName());
	}
	if ( KilledPRI != None )
	{
		KilledPRI.LastKillerPRI = KillerPRI;

		if ( class<UTDamageType>(DamageType) != None )
		{
			class<UTDamageType>(DamageType).static.ScoreKill(KillerPRI, KilledPRI, KilledPawn);
		}
		else
		{
			// assume it's some kind of environmental damage
			if ( (KillerPRI == KilledPRI) || (KillerPRI == None) )
			{
				KilledPRI.IncrementSuicideStat('SUICIDES_ENVIRONMENT');
			}
			else
			{
				KillerPRI.IncrementKillStat('KILLS_ENVIRONMENT');
				KilledPRI.IncrementDeathStat('DEATHS_ENVIRONMENT');
			}
		}
		if ( KilledPRI.Spree > 4 )
		{
			EndSpree(KillerPRI, KilledPRI);
		}
		else
		{
			KilledPRI.Spree = 0;
		}
		if ( KillerPRI != None )
		{
			KillerPRI.IncrementKills(bEnemyKill);

			if ( bEnemyKill )
			{
				V = UTVehicle(KilledPawn);

				if ( !bFirstBlood )
				{
					bFirstBlood = True;
					BroadcastLocalizedMessage( killMessageClass, 6, KillerPRI );
					KillerPRI.IncrementEventStat('EVENT_FIRSTBLOOD');
				}
			}
		}
	}
    super.Killed(Killer, KilledPlayer, KilledPawn, damageType);

    if ( (WorldInfo.NetMode == NM_Standalone) && (PlayerController(KilledPlayer) != None) )
    {
		// clear telling bots not to get into nearby vehicles
		for ( V=VehicleList; V!=None; V=V.NextVehicle )
			if ( WorldInfo.GRI.OnSameTeam(KilledPlayer,V) )
				V.PlayerStartTime = 0;
	}
}

//This function is taken directly from UTGame; the only thing we have changed are the played messages.
function NotifySpree(UTPlayerReplicationInfo Other, int num)
{
	local PlayerController PC;

	if (num % 5 != 0 || num == 0 || num > 30)
	{
		return;
	}
	num = (num/5) - 1;

	Other.IncrementEventStat(SpreeStatEvents[num]);

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.ReceiveLocalizedMessage( killMessageClass, Num, Other );
	}
	if ( (UTPlayerController(Other.Owner) == None) || UTPlayerController(Other.Owner).bAutoTaunt )
	{
		Controller(Other.Owner).SendMessage(None, 'TAUNT', 10, None);
	}
}

//This function is taken directly from UTGame; the only thing we have changed are the played messages.
function EndSpree(UTPlayerReplicationInfo Killer, UTPlayerReplicationInfo Other)
{
	local PlayerController PC;

	if ( Other == None )
		return;

	Other.Spree = 0;
	if ( Killer != None )
	{
		Killer.IncrementEventStat('EVENT_ENDSPREE');
	}

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		if ( (Killer == Other) || (Killer == None) )
		{
			PC.ReceiveLocalizedMessage( killMessageClass, 1, None, Other );
		}
		else
		{
			PC.ReceiveLocalizedMessage( killMessageClass, 0, Other, Killer );
		}
	}
}

simulated function ScoreAndReturnZonedFlags()
{
	local int pointsScored[ 2 ];
	local int flagIndex, zoneTeamIndex;

	for( flagIndex = 0; flagIndex < flags.Length; ++flagIndex )
	{
		if( flags[ flagIndex ].holdingZone != None )
		{
			zoneTeamIndex = flags[ flagIndex ].holdingZone.DefenderTeamIndex;
			Teams[ zoneTeamIndex ].Score += 1;
			++pointsScored[ zoneTeamIndex ];

			flags[ flagIndex ].SendHome( None );
		}
		else if( vSize( flags[ flagIndex ].Location - scoreZones[ 0 ].Location ) < scoreZones[ 0 ].radiusOfScoreZone )
		{
			Teams[ 0 ].Score += 1;
			++pointsScored[ 0 ];
			flags[ flagIndex ].SendHome( None );
		}
		else if( vSize( flags[ flagIndex ].Location - scoreZones[ 1 ].Location ) < scoreZones[ 1 ].radiusOfScoreZone )
		{
			Teams[ 1 ].Score += 1;
			++pointsScored[ 1 ];

			flags[ flagIndex ].SendHome( None );
		}
		else if( flags[ flagIndex ].Holder == None )
		{
			flags[ flagIndex ].SendHome( None );
		}
	}

	for( zoneTeamIndex = 0; zoneTeamIndex < 2; ++zoneTeamIndex )
	{
		scoreZones[ zoneTeamIndex ].ServerHandleSiphonCircle();
	}
	
	BroadcastTeamScoresToPlayers( Teams, pointsScored );
}





//------------------------------------------ Game Object Interface ------------------------------------------//
function RegisterStockpileFlag( AK_Stockpile_Flag flag )
{
	flag.Team = None;
	flags.AddItem( flag );
	flag.flagIndex = flags.Length - 1;
}

function RegisterScoreZone( AK_Stockpile_ScoreZone zone, int teamIndex )
{
	scoreZones[ teamIndex ] = zone;
}





//------------------------------------------ Messaging Interface ------------------------------------------//
function BroadcastTeamScoresToPlayers( UTTeamInfo scoringTeams[2], int pointsScoredThisRound[2] )
{
	local int teamIndex;

	for( teamIndex = 0; teamIndex < 2; ++teamIndex )
	{
		if( pointsScoredThisRound[ teamIndex ] > 0 )
		{
			//Ra's point message index starts at 0, Anubis's at 3
			// Subtract one from points, since index starts at 0
			BroadcastLocalizedMessage( stockpileMessageClass, ( 3 * teamIndex ) + ( pointsScoredThisRound[ teamIndex ] - 1 )  , None, None, None );

			if( scoringTeams[ teamIndex ].Score > scoringTeams[ 1 - teamIndex ].Score + 3 )
			{
				//6 is the number for Ra's Overwheming message, 7 for Anubis
				BroadcastLocalizedMessage( stockpileMessageClass, 6 + teamIndex, None, None, None );
			}
		}
	}
}




DefaultProperties
{
	NEUTRAL_TEAM_INDEX = 2
	bSpawnInTeamArea=true

	Acronym = "AS"
	MapPrefixes(0)="AS"

	MaxPlayersAllowed = 8

	gameHasStarted = false
	gameIsRestarting = false
	secondsToWaitBeforeRestartingGame = 15;

	timeBetweenScoresSeconds = 60
	bScoreTeamKills = false

	DefaultPawnClass=class'AKHET.AK_Pawn'
    DefaultInventory(0)=class'AKHET.AK_Weapon_WristGun'
    PlayerControllerClass=class'AKHET.AK_PlayerController'
	Hudtype=class'AKHET.AK_Stockpile_HUD_Main'
	GameReplicationInfoClass=class'AKHET.AK_Stockpile_GRI'
    PlayerReplicationInfoClass=class'AKHET.AK_PlayerReplicationInfo'

    killMessageClass = class'AKHET.AK_Message_Kills'
    stockpileMessageClass = class'AKHET.AK_Message_Stockpile'
    GameMessageClass = class'AKHET.AK_Message_Metagame'
	bUseClassicHud = true
}