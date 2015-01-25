class AK_Message_Timer extends UTTimerMessage
	dependson(AK_Localizer);

var string localizationSection;

static function string GetString( optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1,
					optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "Announcements[" $ Switch $ "]" );
}

DefaultProperties
{
	localizationSection = "AK_Message_Timer"

	Announcements[1]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[2]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[3]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[4]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[5]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[6]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[7]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[8]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[9]  = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[10] = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[12] = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[13] = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[14] = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[15] = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[16] = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
	Announcements[17] = ( AnnouncementSound = SoundNodeWave'AK_AmbNoise.Silence' )
}