class AK_Weapon_Base extends UTWeapon
	dependson(AK_Localizer)
	abstract;

var string localizationSection;

var MaterialInstanceConstant TeamMaterials[2];

var ParticleSystem AmmoEmptyParticle;
var ParticleSystemComponent AmmoEmptyParticleComponent;

var int maxAmmoRechargedPerSecond;
var int secondsBeforeStartingRecharge;
var bool bAutoCharge;
var SoundCue RechargeBeginSound;
var SoundCue OngoingRechargeSound;
var AudioComponent RechargeSoundComponent;

simulated event ReplicatedEvent ( name eventName )
{
	if( eventName == 'AmmoCount' )
	{
		Super.ReplicatedEvent( eventName );

		UpdateEmissivesWithAmmoPercentage();
		UpdateAmmoEmptyEffects();
	}
	else
	{
		Super.ReplicatedEvent( eventName );
	}
}

simulated function PostBeginPlay()
{
	AmmoEmptyParticleComponent = new(Outer) class'ParticleSystemComponent';
	AmmoEmptyParticleComponent.bAutoActivate = true;
	AmmoEmptyParticleComponent.SetTemplate( AmmoEmptyParticle );
	AmmoEmptyParticleComponent.SetDepthPriorityGroup( SDPG_Foreground );
	SkeletalMeshComponent( Mesh ).AttachComponentToSocket( AmmoEmptyParticleComponent, MuzzleFlashSocket );

	rechargeSoundComponent = CreateAudioComponent( OngoingRechargeSound, false, true );
	Super.PostBeginPlay();
}

//Taken from base class; removed automatic weapon switching on empty
simulated function WeaponEmpty()
{
	// If we were firing, stop
	if ( IsFiring() )
	{
		GotoState('Active');
	}
}

function int AddAmmo( int Amount )
{
	local int returnVal;
	returnVal = Super.AddAmmo( Amount );

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		UpdateEmissivesWithAmmoPercentage();
		UpdateAmmoEmptyEffects();
	}

	return returnVal;
}

//------------------------------------------------ Appearance ------------------------------------------------//
//Change team materials based upon player's team.
simulated function AttachWeaponTo( SkeletalMeshComponent MeshCpnt, optional Name SocketName )
{
	local int teamNumber;

	Super.AttachWeaponTo( MeshCpnt, SocketName );

	teamNumber = Pawn( InvManager.Owner ).GetTeamNum();
	SetSkinInstance( TeamMaterials[ teamNumber ] );

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		UpdateEmissivesWithAmmoPercentage();
		UpdateAmmoEmptyEffects();
	}

	if( AmmoCount < MaxAmmoCount )
		ResetAmmoRecharging();
}

simulated function PutDownWeapon()
{
	EndAmmoRecharging();
	super.PutDownWeapon();
}

simulated function SetSkinInstance( MaterialInstanceConstant NewMaterial )
{
	local int i,Cnt;

	if ( NewMaterial == None )
	{
		// Clear the materials
		if ( default.Mesh.Materials.Length > 0 )
		{
			Cnt = Default.Mesh.Materials.Length;
			for (i=0;i<Cnt;i++)
			{
				Mesh.SetMaterial( i, Default.Mesh.GetMaterial(i) );
			}
		}
		else if (Mesh.Materials.Length > 0)
		{
			Cnt = Mesh.Materials.Length;
			for ( i=0; i < Cnt; i++ )
			{
				Mesh.SetMaterial(i, none);
			}
		}
	}
	else
	{
		// Set new material
		if ( default.Mesh.Materials.Length > 0 || Mesh.GetNumElements() > 0 )
		{
			Cnt = default.Mesh.Materials.Length > 0 ? default.Mesh.Materials.Length : Mesh.GetNumElements();
			for ( i=0; i < Cnt; i++ )
			{
				Mesh.SetMaterial( i , NewMaterial );
			}
		}
	}
}

simulated function UpdateAmmoEmptyEffects()
{
	if( AmmoCount < ShotCost[ 0 ] )
	{
		AmmoEmptyParticleComponent.ActivateSystem();
	}
	else
	{
		AmmoEmptyParticleComponent.DeactivateSystem();
	}
}

simulated function UpdateEmissivesWithAmmoPercentage()
{
	TeamMaterials[0].SetScalarParameterValue( 'AmmoRatio', CalculateRatioOfCurrentToMaxAmmo( AmmoCount, MaxAmmoCount ) );
	TeamMaterials[1].SetScalarParameterValue( 'AmmoRatio', CalculateRatioOfCurrentToMaxAmmo( AmmoCount, MaxAmmoCount ) );
}


//-------------------------------------------- Ammo Regeneration --------------------------------------------//
function ConsumeAmmo( byte FireModeNum )
{
	ResetAmmoRecharging();

	super.ConsumeAmmo(FireModeNum);

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		UpdateEmissivesWithAmmoPercentage();
		UpdateAmmoEmptyEffects();
	}
}

function BeginAmmoRecharging()
{
	SetTimer( 1, true, 'RechargeAmmo' );
	if ( RechargeBeginSound != None )
	{
		PlaySound( RechargeBeginSound );
	}
	if( rechargeSoundComponent != None )
	{
		//rechargeSoundComponent.FadeIn( 0.1f, 1.0f );
		rechargeSoundComponent.Play();
	}
}

function ResetAmmoRecharging()
{
	EndAmmoRecharging();

	if ( bAutoCharge && (Role == ROLE_Authority) )
	{
		SetTimer( secondsBeforeStartingRecharge, false, 'BeginAmmoRecharging' );
	}
}

function EndAmmoRecharging()
{
	SetTimer( 0, false, 'RechargeAmmo' );
	if( rechargeSoundComponent != None )
	{
		//rechargeSoundComponent.FadeOut( 0.1f, 0.0f );
		rechargeSoundComponent.Stop();
	}
}

function RechargeAmmo()
{
	//Use Square relationship to charge ammo
	local int rechargeRateThisSecond;
	local float ratioOfAmmoToMax;

	ratioOfAmmoToMax = float( ammoCount ) / MaxAmmoCount;
	ratioOfAmmoToMax = ratioOfAmmoToMax * ratioOfAmmoToMax;
	rechargeRateThisSecond = FMax( maxAmmoRechargedPerSecond * ( 1.0 - ratioOfAmmoToMax ), 1.0 );
	
	AmmoCount += rechargeRateThisSecond;

	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		UpdateEmissivesWithAmmoPercentage();
		UpdateAmmoEmptyEffects();
	}

	if ( AmmoCount >= MaxAmmoCount )
	{
		EndAmmoRecharging();
	}
}

simulated function float CalculateRatioOfCurrentToMaxAmmo( int currentAmmo, int maxAmmo )
{
	local float ratio;
	ratio = float( currentAmmo ) / float( maxAmmo );
	ratio = ratio * ratio;
	return ratio;
}

//---------------------------------------------- Localization -----------------------------------------------//
simulated function String GetHumanReadableName()
{
	return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "ItemName" );
}

static function string GetLocalString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	return class'AK_Localizer'.static.GetLocalizedStringWithName( Default.localizationSection, "PickupMessage" );
}




DefaultProperties
{
	CrosshairImage=Texture2D'AK_hud.Ak_crosshair_hud_02'
	CrossHairCoordinates=(U=0,V=0,UL=64,VL=64)

	localizationSection = "AK_Weapon_Base"
	secondsBeforeStartingRecharge = 2;
	maxAmmoRechargedPerSecond = 1;

	AmmoEmptyParticle = ParticleSystem'AK_WeaponParticles.Weapons_LowEnergy.AK_LowEnergy_PS_01'
	WeaponPutDownSnd = SoundCue'AK_Weapon_Sounds.AK_Weap_Equip_Cue';
	WeaponEquipSnd = SoundCue'AK_Weapon_Sounds.AK_Weap_Pickup_Cue';
	RechargeBeginSound = SoundCue'AK_AmbNoise.Silence_Cue'
	OngoingRechargeSound = SoundCue'AK_AmbNoise.Silence_Cue'
}
