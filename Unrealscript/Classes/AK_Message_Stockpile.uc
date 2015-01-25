class AK_Message_Stockpile extends UTLocalMessage
	dependson(AK_Localizer);

var string localizationSection;

var color AnubisColor, RaColor;

enum StockpileSituations
{
	/* 0*/SITUATION_RaScored1<DisplayName = Ra Scored 1>,
	/* 1*/SITUATION_RaScored2<DisplayName = Ra Scored 2>,
	/* 2*/SITUATION_RaScored3<DisplayName = Ra Scored 3>,
	/* 3*/SITUATION_AnubisScored1<DisplayName = Anubis Scored 1>,
	/* 4*/SITUATION_AnubisScored2<DisplayName = Anubis Scored 2>,
	/* 5*/SITUATION_AnubisScored3<DisplayName = Anubis Scored 3>,
	/* 6*/SITUATION_RaIsOverwhelming<DisplayName = Ra Is Overwhelming>,
	/* 7*/SITUATION_AnubisIsOverwhelming<DisplayName = Anubis Is Overwhelming>,
	/* 8*/SITUATION_FlagStolenFromRa<DisplayName = Flag Stolen From Ra>,
	/* 9*/SITUATION_FlagStolenFromAnubis<DisplayName = Flag Stolen From Anubis>,
	/*10*/SITUATION_0SecondsLeftUntilSiphon<DisplayName = 0 Seconds Until Siphon>,
	/*11*/SITUATION_1SecondsLeftUntilSiphon<DisplayName = 1 Second  Until Siphon>,
	/*12*/SITUATION_2SecondsLeftUntilSiphon<DisplayName = 2 Seconds Until Siphon>,
	/*13*/SITUATION_3SecondsLeftUntilSiphon<DisplayName = 3 Seconds Until Siphon>
};




//-------------------------------------- Message Reception Behavior --------------------------------------//
static function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
							   optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	UTPlayerController(P).PlayAnnouncement( default.class,Switch );
	
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}




//------------------------------------------- Message Parameters -------------------------------------------//
static function byte AnnouncementLevel(byte MessageIndex)
{
	return 2;
}

static function bool ShouldBeRemoved(UTQueuedAnnouncement MyAnnouncement, class<UTLocalMessage> NewAnnouncementClass, int NewMessageIndex)
{
	return false;
	//return super.ShouldBeRemoved(MyAnnouncement, NewAnnouncementClass, NewMessageIndex);
}




//--------------------------------------------- Message Outputs ---------------------------------------------//
static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	switch (MessageIndex)
	{
		//XS: Gents, these sounds are not playing; not sure why. Perhaps you can enlighten me.
		case SITUATION_AnubisScored1: 
			return SoundNodeWave'AK_AmbNoise.ak_music_noise.AK_Amb_ScoreTemp';
		case SITUATION_RaScored1:
			return SoundNodeWave'AK_AmbNoise.ak_music_noise.AK_Amb_ScoreTemp';
		default: 
			return SoundNodeWave'AK_AmbNoise.Silence';
	}

	/*return SoundNodeWave'AK_AmbNoise.Silence';*/
}

static function color GetColor( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
								optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	switch (Switch)
	{
		case SITUATION_RaScored1:
		case SITUATION_RaScored2:
		case SITUATION_RaScored3:
		case SITUATION_RaIsOverwhelming:
		case SITUATION_FlagStolenFromAnubis:
			return default.RaColor;
			break;

		case SITUATION_AnubisScored1:
		case SITUATION_AnubisScored2:
		case SITUATION_AnubisScored3:
		case SITUATION_AnubisIsOverwhelming:
		case SITUATION_FlagStolenFromRa:
			return default.AnubisColor;
			break;
	}

	return Default.DrawColor;
}

static function string GetString( optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, 
								  optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	switch ( Switch )
	{
	case SITUATION_RaScored1:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "RaScoreString[" $ 0 $ "]" );
		break;

	case SITUATION_AnubisScored1:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "AnubisScoreString[" $ 0 $ "]" );
		break;

	case SITUATION_RaScored2:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "RaScoreString[" $ 1 $ "]" );
		break;

	case SITUATION_AnubisScored2:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "AnubisScoreString[" $ 1 $ "]" );
		break;

	case SITUATION_RaScored3:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "RaScoreString[" $ 2 $ "]" );
		break;

	case SITUATION_AnubisScored3:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "AnubisScoreString[" $ 2 $ "]" );
		break;



	case SITUATION_RaIsOverwhelming:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "RaOverwhelming" );
		break;

	case SITUATION_AnubisIsOverwhelming:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "AnubisOverwhelming" );
		break;



	case SITUATION_FlagStolenFromRa:
		if (RelatedPRI_1 == None)
			return "";

		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "FlagStolenFromRaString" );
		break;

	case SITUATION_FlagStolenFromAnubis:
		if (RelatedPRI_1 == None)
			return "";

		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "FlagStolenFromAnubisString" );
		break;



	case SITUATION_0SecondsLeftUntilSiphon:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SiphonTimeString[" $ 0 $ "]" );
		break;

	case SITUATION_1SecondsLeftUntilSiphon:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SiphonTimeString[" $ 1 $ "]" );
		break;

	case SITUATION_2SecondsLeftUntilSiphon:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SiphonTimeString[" $ 2 $ "]" );
		break;

	case SITUATION_3SecondsLeftUntilSiphon:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SiphonTimeString[" $ 3 $ "]" );
		break;
	}
	return "";
}




DefaultProperties
{
	localizationSection = "AK_Message_Stockpile"

	//Appearance and Location
	FontSize=1
	MessageArea=1
	RaColor     = ( R=228, G=178, B=24,  A=255 )
	AnubisColor = ( R=154, G=22,  B=211, A=255 )

	//How message is displayed
	bIsUnique=False
	AnnouncementPriority=4

	bBeep=false
}
