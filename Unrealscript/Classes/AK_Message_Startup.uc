class AK_Message_Startup extends UTStartupMessage
	dependson(AK_Localizer);

var string localizationSection;

//This function returns the sound that plays right when the match begins.
static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return SoundNodeWave'AK_AmbNoise.Silence';
}

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local int i, PlayerCount;
	local GameReplicationInfo GRI;

	if ( (RelatedPRI_1 != None) && (RelatedPRI_1.WorldInfo.NetMode == NM_Standalone) )
	{
		  if ( (UTGame(RelatedPRI_1.WorldInfo.Game) != None) && UTGame(RelatedPRI_1.WorldInfo.Game).bQuickstart )
			  return "";
		if ( Switch < 2 )
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SinglePlayer" );
		}
	else if ( Switch == 0 && RelatedPRI_1 != None )
	{
		GRI = RelatedPRI_1.WorldInfo.GRI;
		if (GRI == None)
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "Stage[" $ 0 $ "]" );
		for (i = 0; i < GRI.PRIArray.Length; i++)
		{
			if ( GRI.PRIArray[i] != None && !GRI.PRIArray[i].bOnlySpectator
			     && !GRI.PRIArray[i].bBot && (!GRI.PRIArray[i].bIsSpectator || GRI.PRIArray[i].bWaitingPlayer) )
				PlayerCount++;
		}
		if (UTGameReplicationInfo(GRI).MinNetPlayers - PlayerCount > 0)
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "Stage[" $ 0 $ "]" ) @ "(" $ ( UTGameReplicationInfo(GRI).MinNetPlayers - PlayerCount ) $ ")";
	}
	else if ( switch == 1 )
	{
		if ( (RelatedPRI_1 == None) || !RelatedPRI_1.bWaitingPlayer )
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "Stage[" $ 0 $ "]" );
		else if ( RelatedPRI_1.bReadyToPlay )
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "Stage[" $ 1 $ "]" );
		else
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "NotReady" );
	}
	return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "Stage[" $ Switch $ "]" );
}

DefaultProperties
{
	localizationSection = "AK_Message_Startup"

	DrawColor=(R=255,G=255,B=255)
}