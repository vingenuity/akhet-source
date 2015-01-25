class AK_Message_Metagame extends GameMessage
	dependson(AK_Localizer);

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
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "OverTimeMessage" );
			break;
		case 1:
			// @todo ib2merge: Chair had commented out this entire case and returned ""
			if (RelatedPRI_1 == None)
                return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "NewPlayerMessage" );

			return RelatedPRI_1.PlayerName $ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "EnteredMessage" );
			break;
		case 2:
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.OldName @ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "GlobalNameChange" ) @ RelatedPRI_1.PlayerName;
			break;
		case 3:
			if (RelatedPRI_1 == None)
				return "";
			if (OptionalObject == None)
				return "";

            return RelatedPRI_1.PlayerName @ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "NewTeamMessage" ) @ TeamInfo(OptionalObject).GetHumanReadableName() $ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "NewTeamMessageTrailer" );
			break;
		case 4:
			if (RelatedPRI_1 == None)
				return "";

			return RelatedPRI_1.PlayerName $ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "LeftMessage" );
			break;
		case 5:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SwitchLevelMessage" );
			break;
		case 6:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "FailedTeamMessage" );
			break;
		case 7:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "MaxedOutMessage" );
			break;
		case 8:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "NoNameChange" );
			break;
        case 9:
            return RelatedPRI_1.PlayerName @ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "VoteStarted" );
            break;
        case 10:
            return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "VotePassed" );
            break;
        case 11:
			return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "MustHaveStats" );
			break;
	case 12:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "CantBeSpectator" );
		break;
	case 13:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "CantBePlayer" );
		break;
	case 14:
		return RelatedPRI_1.PlayerName @ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "BecameSpectator" );
		break;
	case 15:
		return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "KickWarning" );
		break;
	case 16:
            if (RelatedPRI_1 == None)
                return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "NewSpecMessage" );

            return RelatedPRI_1.PlayerName $ class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "SpecEnteredMessage" );
            break;
	}
	return "";
}

DefaultProperties
{
	localizationSection = "AK_Message_Metagame";
}
