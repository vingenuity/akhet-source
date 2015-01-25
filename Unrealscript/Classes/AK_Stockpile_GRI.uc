class AK_Stockpile_GRI extends UTGameReplicationInfo
	config(Game);

var int timeBetweenFlagScoresSeconds;
var int timeLeftUntilScoringSeconds;
var bool shouldResetScoringTimer;
var int totalNumberOfFlags;

enum EStockpileFlagState
{
    FLAG_Home,
    FLAG_HeldByRa,
    FLAG_HeldByAnubis,
    FLAG_Dropped,
    FLAG_PlacedInRaZone,
    FLAG_PlacedInAnubisZone,
};
var EStockpileFlagState NeutralFlagState[ 3 ];

replication
{
	if ( bNetInitial )
		timeLeftUntilScoringSeconds, timeBetweenFlagScoresSeconds;
	if ( bNetDirty )
		shouldResetScoringTimer, totalNumberOfFlags, NeutralFlagState;
}

simulated function Timer()
{
	local byte TimerMessageIndex;
	local PlayerController PC;

	super( GameReplicationInfo ).Timer();

	if ( bMatchHasBegun )
	{
		TickStockpileTimer();
	}

	if ( WorldInfo.NetMode == NM_Client )
	{
		if ( bWarmupRound && RemainingTime > 0 )
			RemainingTime--;
	}

	// check if we should broadcast a time countdown message
	if (WorldInfo.NetMode != NM_DedicatedServer && (bMatchHasBegun || bWarmupRound) && !bStopCountDown && !bMatchIsOver && Winner == None)
	{
		switch (RemainingTime)
		{
			case 300:
				TimerMessageIndex = 16;
				break;
			case 180:
				TimerMessageIndex = 15;
				break;
			case 120:
				TimerMessageIndex = 14;
				break;
			case 60:
				TimerMessageIndex = 13;
				break;
			case 30:
				TimerMessageIndex = 12;
				break;
			default:
				if (RemainingTime <= 10 && RemainingTime > 0)
				{
					TimerMessageIndex = RemainingTime;
				}
				break;
		}
		if (TimerMessageIndex != 0)
		{
			foreach LocalPlayerControllers(class'PlayerController', PC)
			{
				PC.ReceiveLocalizedMessage(class'AK_Message_Timer', TimerMessageIndex);
			}
		}
	}
}

simulated function TickStockpileTimer()
{
	timeLeftUntilScoringSeconds = RemainingTime % timeBetweenFlagScoresSeconds;
}

//RW: function which triggers a kismet event each second for last 5 seconds of match
simulated function KismetTimeEvent( int timeIndex )
{
	switch (timeIndex)
	{
		case 6:
			TriggerGlobalEventClass( class'AK_Kismet_MatchTimes',self, 0 );
			break;
		case 5:
			TriggerGlobalEventClass( class'AK_Kismet_MatchTimes',self, 1 );
			break;
		case 4:
			TriggerGlobalEventClass( class'AK_Kismet_MatchTimes',self, 2 );
			break;
		case 3:
			TriggerGlobalEventClass( class'AK_Kismet_MatchTimes',self, 3 );
			break;
		case 2:
			TriggerGlobalEventClass( class'AK_Kismet_MatchTimes',self, 4 );
			break;
		default:
			break;
	}
}

//----------------------------------- UT Flag States (Not Used, but necessary) -----------------------------------//
function SetFlagHome(int TeamIndex)
{
	FlagState[TeamIndex] = FLAG_Home;
	bForceNetUpdate = TRUE;
}

simulated function bool FlagIsHome(int TeamIndex) { return true; }

simulated function bool FlagsAreHome() { return true; }

function SetFlagHeldFriendly(int TeamIndex) { }

simulated function bool FlagIsHeldFriendly(int TeamIndex) { return false; }

function SetFlagHeldEnemy(int TeamIndex) { }

simulated function bool FlagIsHeldEnemy(int TeamIndex) { return false; }

function SetFlagDown(int TeamIndex) { }

simulated function bool FlagIsDown(int TeamIndex) { return false; }




//-------------------------------------------- Stockpile Flag States --------------------------------------------//
function SetFlagAtSpawn( int flagID )
{
	NeutralFlagState[ flagID ] = FLAG_Home;
	bForceNetUpdate = TRUE;
}

simulated function bool IsFlagAtSpawn( int flagID ) 
{
	return ( NeutralFlagState[ flagID ] == FLAG_Home );
}

function SetFlagHeldByAnubis( int flagID )
{
	NeutralFlagState[ flagID ] = FLAG_HeldByAnubis;
	bForceNetUpdate = TRUE;
}

simulated function bool IsFlagHeldByAnubis( int flagID )
{
	return ( NeutralFlagState[ flagID ] == FLAG_HeldByAnubis );
}

function SetFlagHeldByRa( int flagID )
{
	NeutralFlagState[ flagID ] = FLAG_HeldByRa;
	bForceNetUpdate = TRUE;
}

simulated function bool IsFlagHeldByRa( int flagID )
{
	return ( NeutralFlagState[ flagID ] == FLAG_HeldByRa );
}

function SetFlagDropped( int flagID )
{
	NeutralFlagState[ flagID ] = FLAG_Dropped;
	bForceNetUpdate = TRUE;
}

simulated function bool IsFlagDropped( int flagID )
{
	return ( NeutralFlagState[ flagID ] == FLAG_Dropped );
}

function SetFlagPlacedInAnubisZone( int flagID )
{
	NeutralFlagState[ flagID ] = FLAG_PlacedInAnubisZone;
	bForceNetUpdate = TRUE;
}

simulated function bool IsFlagPlacedInAnubisZone( int flagID )
{
	return ( NeutralFlagState[ flagID ] == FLAG_PlacedInAnubisZone );
}

function SetFlagPlacedInRaZone( int flagID )
{
	NeutralFlagState[ flagID ] = FLAG_PlacedInRaZone;
	bForceNetUpdate = TRUE;
}

simulated function bool IsFlagPlacedInRaZone( int flagID )
{
	return ( NeutralFlagState[ flagID ] == FLAG_PlacedInRaZone );
}

simulated function int CalculateNumberOfFlagsInAnubisZone()
{
	local int i, numberOfFlagsInZone;

	numberOfFlagsInZone = 0;
	for( i = 0; i < 3; ++i )
	{
		if( NeutralFlagState[ i ] == FLAG_PlacedInAnubisZone )
			++numberOfFlagsInZone;
	}
	return numberOfFlagsInZone;
}

simulated function int CalculateNumberOfFlagsInRaZone( )
{
	local int i, numberOfFlagsInZone;

	numberOfFlagsInZone = 0;
	for( i = 0; i < 3; ++i )
	{
		if( NeutralFlagState[ i ] == FLAG_PlacedInRaZone )
			++numberOfFlagsInZone;
	}
	return numberOfFlagsInZone;
}





DefaultProperties
{
	shouldResetScoringTimer = false
}
