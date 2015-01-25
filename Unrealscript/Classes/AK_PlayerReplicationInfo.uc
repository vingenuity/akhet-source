class AK_PlayerReplicationInfo extends UTPlayerReplicationInfo;

//This fixes the "Double Kill!" message popping up all of the time by not tracking multikills
function IncrementKills(bool bEnemyKill )
{
	MultiKillLevel = 0;

	if ( bEnemyKill )
	{
		LastKillTime = WorldInfo.TimeSeconds;

		spree++;
		if ( spree > 4 )
		{
			UTGame(WorldInfo.Game).NotifySpree(self, spree);
		}
	}
}

DefaultProperties
{
	//Default character class; This will be overwritten by calls in AK_PlayerController.
	CharClassInfo = class'AKHET.AK_FamilyInfo_Servant'

	GameMessageClass = class'AKHET.AK_Message_Metagame'
}
