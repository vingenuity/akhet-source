class AK_Message_Kills extends UTLocalMessage
	dependson(AK_Localizer);

var string localizationSection;

var SoundNodeWave KillSound[7];

enum StockpileSituations
{
	/* 0*/SITUATION_Level1Streak<DisplayName = Level 1 Streak>,
	/* 1*/SITUATION_Level2Streak<DisplayName = Level 2 Streak>,
	/* 2*/SITUATION_Level3Streak<DisplayName = Level 3 Streak>,
	/* 3*/SITUATION_Level4Streak<DisplayName = Level 4 Streak>,
	/* 4*/SITUATION_Level5Streak<DisplayName = Level 5 Streak>,
	/* 5*/SITUATION_Level6Streak<DisplayName = Level 6 Streak>,
	/* 6*/SITUATION_FirstKill<DisplayName = First Kill>
};

//Taken directly from UTKillingSpreeMessage
static function int GetFontSize( int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer )
{
	local Pawn ViewPawn;
	local int Size;

	if ( RelatedPRI2 == None )
	{
		Size = Default.FontSize;

		// If this is regarding the local player, then increase the size to make it more visible
		if ( LocalPlayer == RelatedPRI1 )
		{
			Size = (Switch > 3) ? 4 : 3;
		}
		else if ( (LocalPlayer != None) && LocalPlayer.bOnlySpectator )
		{
			ViewPawn = Pawn(PlayerController(LocalPlayer.Owner).ViewTarget);
			if ( (ViewPawn != None) && (ViewPawn.PlayerReplicationInfo == RelatedPRI1) )
			{
				Size = 3;
			}
		}
		return size;
	}
	return Default.FontSize;
}

static function string GetString(
	optional int Switch,
	optional bool bPRI1HUD,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_2 == None)
	{
		if ( bPRI1HUD )
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SelfStreakNote[" $ Switch $ "]" );
		if (RelatedPRI_1 == None)
			return "";

		if (RelatedPRI_1.PlayerName != "")
			return RelatedPRI_1.PlayerName@class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "StreakNote[" $ Switch $ "]" );
	}
	else
	{
		if (RelatedPRI_1 == None)
		{
			if (RelatedPRI_2.PlayerName != "")
			{
				if ( UTPlayerReplicationInfo(RelatedPRI_2).bIsFemale )
					return RelatedPRI_2.PlayerName@class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "EndStreakFemale" );
				else
					return RelatedPRI_2.PlayerName@class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "EndStreakMale" );
			}
		}
		else
		{
			return RelatedPRI_1.PlayerName $ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "EndStreakNote" ) @ RelatedPRI_2.PlayerName @ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "EndStreakNoteTrailer" );
		}
	}
	return "";
}

static simulated function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

	if (RelatedPRI_2 != None)
		return;

	if ( (RelatedPRI_1 == P.PlayerReplicationInfo)
		|| (P.PlayerReplicationInfo.bOnlySpectator && (Pawn(P.ViewTarget) != None) && (Pawn(P.ViewTarget).PlayerReplicationInfo == RelatedPRI_1)) )
	{
		UTPlayerController(P).PlayAnnouncement( default.class,Switch );
		//if ( Switch == 0 )
		//	UTPlayerController(P).ClientMusicEvent(8);
		//else
		//	UTPlayerController(P).ClientMusicEvent(10);
	}
	else
		P.PlayBeepSound();
}

static function SoundNodeWave AnnouncementSound(int MessageIndex, Object OptionalObject, PlayerController PC)
{
	return Default.KillSound[ MessageIndex ];
}

defaultproperties
{
	localizationSection = "AK_Message_Kills"

	MessageArea=3
	Fontsize=2
	bBeep=False
	DrawColor=(R=255,G=0,B=0)
	AnnouncementPriority=9

	KillSound(SITUATION_Level1Streak) = SoundNodeWave'AK_AmbNoise.Silence'
	KillSound(SITUATION_Level2Streak) = SoundNodeWave'AK_AmbNoise.Silence'
	KillSound(SITUATION_Level3Streak) = SoundNodeWave'AK_AmbNoise.Silence'
	KillSound(SITUATION_Level4Streak) = SoundNodeWave'AK_AmbNoise.Silence'
	KillSound(SITUATION_Level5Streak) = SoundNodeWave'AK_AmbNoise.Silence'
	KillSound(SITUATION_Level6Streak) = SoundNodeWave'AK_AmbNoise.Silence'
	KillSound(SITUATION_FirstKill) = SoundNodeWave'AK_AmbNoise.Silence'
}