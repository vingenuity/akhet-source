class AK_Message_TeamSelection extends UTTeamGameMessage;

var string localizationSection;

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{

	switch (Switch)
	{
		case 0:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "RequestTeamSwapPrefix" ) 
						@ RelatedPRI_1.PlayerName @ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "RequestTeamSwapPostfix" );
			break;
		case 1:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "YouAreOnRedMessage" );
			break;
		case 2:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "YouAreOnBlueMessage" );
			break;
	}
	return "";
}

DefaultProperties
{
	localizationSection = "AK_Message_TeamSelection"

	bIsConsoleMessage=true

	RedDrawColor = ( R=228, G=178, B=24,  A=255 )
	BlueDrawColor= ( R=154, G=22,  B=211, A=255 )

	AnnouncerSounds(0) = None
	AnnouncerSounds(1) = None
	MessageArea = 2
	AnnouncementPriority = 19
}