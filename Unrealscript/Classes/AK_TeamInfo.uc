class AK_TeamInfo extends UTTeamInfo
	dependson(AK_Localizer);

var string localizationSection;

simulated function string GetHumanReadableName()
{
	return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "TeamColorNames[" $ TeamIndex $ "]" );
}

DefaultProperties
{
	localizationSection = "AK_TeamInfo"

	DesiredTeamSize=4
	BaseTeamColor(0) = ( R=228, G=178, B=24,  A=255 )
	BaseTeamColor(1) = ( R=154, G=22,  B=211, A=255 )
	BaseTeamColor(2) = ( R=255, G=255, B=255, A=255 )
	BaseTeamColor(3) = ( R=0,   G=0,   B=0,   A=255 )
}