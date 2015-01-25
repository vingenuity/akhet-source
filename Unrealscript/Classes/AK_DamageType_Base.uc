class AK_DamageType_Base extends UTDamageType
	dependson(AK_Localizer)
	abstract;

var string localizationSection;

var float headshotDamageMultiplier;

static function float GetHeadshotDamageMultiplier()
{
	return default.headshotDamageMultiplier;
}

//This is a direct copy of UTDamageType's function, except using our new localization system.
static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
	return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "DeathString" );
}

//This is a direct copy of UTDamageType's function, except using our new localization system.
static function string SuicideMessage(PlayerReplicationInfo Victim)
{
	if ( (UTPlayerReplicationInfo(Victim) != None) && UTPlayerReplicationInfo(Victim).bIsFemale )
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "FemaleSuicide" );
	else
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "MaleSuicide" );
}

DefaultProperties
{
	localizationSection = "AK_DamageType_Base";

	headshotDamageMultiplier = 1.0;
}
