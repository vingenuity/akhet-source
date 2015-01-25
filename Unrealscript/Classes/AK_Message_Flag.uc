class AK_Message_Flag extends UTLocalMessage
	dependson(AK_Localizer);

var string localizationSection;

enum FlagSituations
{
	FLAG_Taken  <DisplayName = Player has taken flag>,
	FLAG_Dropped<DisplayName = Player has dropped flag>,
	FLAG_Placed <DisplayName = Player has placed flag>
};



//-------------------------------------- Message Reception Behavior --------------------------------------//
static function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
							   optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}




//------------------------------------------- Message Parameters -------------------------------------------//
static function byte AnnouncementLevel(byte MessageIndex)
{
	return 8;
}

static function bool ShouldBeRemoved(UTQueuedAnnouncement MyAnnouncement, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
	return false;
	//return super.ShouldBeRemoved(MyAnnouncement, NewAnnouncementClass, NewMessageIndex);
}




//--------------------------------------------- Message Outputs ---------------------------------------------//
static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return SoundNodeWave'AK_AmbNoise.Silence';
}

static function color GetColor( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
								optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	return Default.DrawColor;
}

static function string GetString( optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, 
								  optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	switch ( Switch )
	{
	case FLAG_Taken:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "TakenFlagString" );
		break;
	case FLAG_Dropped:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "DroppedFlagString" );
		break;
	case FLAG_Placed:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "PlacedFlagString" );
		break;
	}
	return "";
}




DefaultProperties
{
	localizationSection = "AK_Message_Flag"
	//Appearance and Location
	FontSize=1
	MessageArea=1

	//How message is displayed
	bIsUnique=False
	AnnouncementPriority=4

	bBeep=false
}