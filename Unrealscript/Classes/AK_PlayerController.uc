class AK_PlayerController extends UTPlayerController;

var class< LocalMessage > startupMessageClass;
var class< LocalMessage > teamSwitchMessageClass;
var class< LocalMessage > timerMessageClass;

//We aren't going to use these online features, and they are causing warnings, so they are gone.
simulated protected function RegisterCustomPlayerDataStores()
{
}

simulated protected function RegisterStandardPlayerDataStores()
{
}

event KickWarning()
{
	ReceiveLocalizedMessage( class'AKHET.AK_Message_Metagame', 15 );
}

//------------------------------------------ Message Overrides ------------------------------------------//
//This is an exact copy of UTPlayerController's AcknowledgePossession, except using our custom message class to display the message
function AcknowledgePossession(Pawn P)
{
	local rotator NewViewRotation;

	Super( UDKPlayerController ).AcknowledgePossession(P);

	if ( LocalPlayer(Player) != None )
	{
		ClientEndZoom();
		if (bUseVehicleRotationOnPossess && Vehicle(P) != None && UTWeaponPawn(P) == None)
		{
			NewViewRotation = P.Rotation;
			NewViewRotation.Roll = 0;
			SetRotation(NewViewRotation);
		}
		ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference, VehicleControlType);

		if ( (PlayerReplicationInfo != None)
			&& (PlayerReplicationInfo.Team != None)
			&& (IdentifiedTeam != PlayerReplicationInfo.Team.TeamIndex) )
		{
			// identify your team the first time you spawn on it
			IdentifiedTeam = PlayerReplicationInfo.Team.TeamIndex;
			if ( IdentifiedTeam < 2 )
			{
				ReceiveLocalizedMessage( teamSwitchMessageClass, IdentifiedTeam + 1, PlayerReplicationInfo );
			}
		}
	}
}

reliable client function PlayStartupMessage(byte StartupStage)
{
	if ( StartupStage == 7 )
	{
		ReceiveLocalizedMessage( timerMessageClass, 17, PlayerReplicationInfo );
	}
	else
	{
		ReceiveLocalizedMessage( startupMessageClass, StartupStage, PlayerReplicationInfo );
	}
}




//---------------------------------------- Default Properties ----------------------------------------//
DefaultProperties
{
	startupMessageClass = class'AK_Message_Startup'
	teamSwitchMessageClass = class'AK_Message_TeamSelection'
	timerMessageClass = class'AK_Message_Timer'
}
