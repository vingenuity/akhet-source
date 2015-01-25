class AK_GameReplicationInfo extends UTGameReplicationInfo
	config(Game);

var int timeBetweenFlagScoresSeconds;
var int timeLeftUntilScoringSeconds;

var int numberOfEnemiesInScoreZone[ 2 ];
var int numberOfFriendliesInScoreZone[ 2 ];
var int timeLeftUntilFlagIsReturned[ 2 ];

replication
{
	if ( bNetInitial )
		timeLeftUntilScoringSeconds, timeBetweenFlagScoresSeconds;
}

simulated function Timer()
{
	super.Timer();

	if ( bMatchHasBegun )
	{
		TickScoringTimer();
	}
}

simulated function TickScoringTimer()
{
	if( timeLeftUntilScoringSeconds <= 0 )
	{
		timeLeftUntilScoringSeconds = timeBetweenFlagScoresSeconds;
	}
	--timeLeftUntilScoringSeconds;
}

DefaultProperties
{

}
