class AK_Weapon_BattleStaff extends AK_Weapon_Base;

var class<UTDamageType> HeadShotDamageType;
var float HeadShotDamageMult;
var Texture2D HudMaterial;
var array<MaterialInterface> TeamSkins;
var float SlowHeadshotScale;
var float RunningHeadshotScale;
var bool bAbortZoom;
var audiocomponent ZoomLoop;
var soundcue ZoomLoopCue;
var bool bDisplayCrosshair;
var int ZoomCount;
var float	FadeTime;
var bool bBurstFireTimerActive;
var float burstTimer;
var float burstTime;
var int currentBurstCount;
var int burstCount;
var ParticleSystemComponent Eye;

simulated function PostBeginPlay()
{
	Eye = new(Outer) class'ParticleSystemComponent';
	Eye.bAutoActivate = true;
	Eye.SetTemplate(ParticleSystem'AK_WeaponParticles.Eye.AK_EyeEffect_PS');
	SkeletalMeshComponent(Mesh).AttachComponentToSocket(Eye,'Eye of Ra');

	Eye.SetDepthPriorityGroup( SDPG_Foreground );
	Eye.SetTranslation(vect(9,-4,-2));
	Super.PostBeginPlay();
}    

simulated function BeginFire(byte FireModeNum)
{
	if(FireModeNum == 0)
	{
		ProcessBurst();
	}
}

simulated function ProcessBurst()
{
	if(currentBurstCount == 0)
	{
		currentBurstCount = burstCount;
		burstTimer = 0.1;
	}
	
}

simulated function FireAmmo()
{
	if(AmmoCount != 0)
	{
		super.FireAmmunition();
	}
}

simulated function Tick(float dt)
{
	//local Vector testLoc;

	super.Tick(dt);
	if(currentBurstCount > 0 && burstTimer < 0)
	{
		currentBurstCount--;
		burstTimer = burstTime;
		FireAmmo();
	}
	else
	{ 
		burstTimer -= dt;
	}

	//SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation( 'Eye of Ra', testLoc );
	//DrawDebugSphere( testLoc, 3.f, 10, 255, 60, 0 );
}

/** Called when zooming starts
 * @param PC - cast of Instigator.Controller for convenience
 */
simulated function StartZoom(UTPlayerController PC)
{
	if(AmmoCount != 0)
	{
		ZoomCount++;
	}
	
	if (ZoomCount == 1 && !IsTimerActive('Gotozoom') && HasAmmo(0) && Instigator.IsFirstPerson())
	{
		bDisplayCrosshair = false;
		PlayWeaponAnimation('WeaponZoomIn',0.3);
		bAbortZoom = false;
		SetTimer(0.3, false, 'Gotozoom');
	}
}

/** Called when zooming ends
 * @param PC - cast of Instigator.Controller for convenience
 */
simulated function EndZoom(UTPlayerController PC)
{
	PlaySound(ZoomOutSound, true);
	bAbortZoom = false;
	if (IsTimerActive('Gotozoom'))
	{
		ClearTimer('Gotozoom');
	}
	SetTimer(0.001,false,'LeaveZoom');

}
simulated function LeaveZoom()
{
	local UTPlayerController PC;

	bAbortZoom = false;
	PC = UTPlayerController(Instigator.Controller);
	if (PC != none)
	{
		PC.EndZoom();
	}
	ZoomCount = 0;
	if(Instigator.IsFirstPerson())
	{
		ChangeVisibility(true);
	}

	PlayWeaponAnimation('WeaponZoomOut',0.3);
	PlayArmAnimation('WeaponZoomOut',0.3);
	SetTimer(0.3,false,'RestartCrosshair');

}
simulated function ChangeVisibility(bool bIsVisible)
{
	super.Changevisibility(bIsvisible);
	if(bIsVisible)
	{
		PlayArmAnimation('WeaponZoomOut',0.00001); // to cover zooms ended while in 3p
	}
	if(!Instigator.IsFirstPerson()) // to be consistent with not allowing zoom from 3p
	{
		LeaveZoom();
	}

}
simulated function RestartCrosshair()
{
	bDisplayCrosshair = true;
}

simulated function PutDownWeapon()
{
	ClearTimer('GotoZoom');
	ClearTimer('StopZoom');
	LeaveZoom();
	super.PutDownWeapon();
}

simulated function bool DenyClientWeaponSet()
{
	//witch while zoomed
	return (GetZoomedState() == ZST_NotZoomed);
}

simulated function Gotozoom()
{
	local UTPlayerController PC;

	PC = UTPlayerController(Instigator.Controller);
	if (GetZoomedState() == ZST_NotZoomed)
	{
		//PC.FOVAngle = 40;
		Super.StartZoom(PC);
		ChangeVisibility(false);
		if (bAbortZoom) // stop the zoom after 1 tick
		{
			SetTimer(0.0001, false, 'StopZoom');
		}
		else
		{
			if(ZoomLoop == none)
			{
				ZoomLoop = CreateAudioComponent(ZoomLoopCue, false, true);
			}
			if(ZoomLoop != none)
			{
				ZoomLoop.Play();
			}
		}
	}

}
simulated function PlayWeaponPutDown()
{
	ClearTimer('GotoZoom');
	ClearTimer('StopZoom');
	if(UTPlayerController(Instigator.Controller) != none)
	{
		UTPlayerController(Instigator.Controller).EndZoom();
	}
	super.PlayWeaponPutDown();
}

simulated function StopZoom()
{
	local UTPlayerController PC;

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		PC = UTPlayerController(Instigator.Controller);
		if (PC != None && LocalPlayer(PC.Player) != none)
		{
			PC.StopZoom();
		}
	}
}

/**
 * returns true if this weapon is currently lower priority than InWeapon
 * used to determine whether to switch to InWeapon
 * this is the server check, so don't check clientside settings (like weapon priority) here
 */
simulated function bool ShouldSwitchTo(UTWeapon InWeapon)
{
	// if we should, but can't right now, tell InventoryManager to try again later
	if (IsFiring() || DenyClientWeaponSet())
	{
		LeaveZoom();
		//Gotozoom();
		return false;
	}
	else
	{
		return true;
	}
}

simulated event CauseMuzzleFlash()
{
	if(GetZoomedState() == ZST_NotZoomed)
	{
		super.CauseMuzzleFlash();
	}
}

simulated function vector GetEffectLocation()
{
	// tracer comes from center if zoomed in
	return (GetZoomedState() != ZST_NotZoomed) ? Instigator.Location : Super.GetEffectLocation();
}

DefaultProperties
{
	localizationSection = "AK_Weapon_BattleStaff"

	CrosshairImage=Texture2D'AK_hud.AK_HUD_Reticles'
	CrossHairCoordinates=( U=512, V=0, UL=256, VL=256 )
	
	InventoryGroup=4 //Key to press to switch to weapon
	FireInterval(0)=+1.0                                   //JL: Changed from 2.7
	FireInterval(1)=+0.7
	AmmoCount=60
	burstCount = 3;
	burstTime = .1;
	maxAmmoRechargedPerSecond = 4
	secondsBeforeStartingRecharge = 3
	bAutoCharge=true

	GroupWeight=0.5
	AimError=600

	HeadShotDamageMult=2.0
	SlowHeadshotScale=1.75
	RunningHeadshotScale=0.8

	// Configure the zoom

	bZoomedFireMode(0)=0
	bZoomedFireMode(1)=1

	ZoomedTargetFOV=60.0
	ZoomedRate=300.0

	EquipTime=+0.6
	PutDownTime=+0.45
	bDisplaycrosshair = true;

	// Weapon SkeletalMesh
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
		bCauseActorAnimEnd=true
	End Object



	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'AK_BattleStaff.AK_BattleStaff_Mesh_02'
		AnimSets(0)=AnimSet'AK_BattleStaff.AK_BattleStaff_AnimSet_02'
		Animations=MeshSequenceA
		Translation = (X=30.0,Y=5.0,Z=2.0)
		Rotation=(Yaw=-16384)
		FOV=60.0
		DepthPriorityGroup=SDPG_Foreground
	End Object

	//WeaponFireAnim(0)=WeaponFire

	TeamMaterials(0) = MaterialInstanceConstant'AK_BattleStaff.Textures.AK_BattleStaff_MAT_Ra_INST'
	TeamMaterials(1) = MaterialInstanceConstant'AK_BattleStaff.Textures.AK_BattleStaff_MAT_Anubis_INST'

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'AK_BattleStaff.AK_BattleStaff_Mesh_02'
	End Object

	WeaponFireTypes(0)=EWFT_InstantHit
	//WeaponProjectiles(0)=class'AK_Projectile_BattleStaff'
	InstantHitDamage(0)=10
	InstantHitDamageTypes(0)=class'AK_DamageType_StaffShot'
	bInstantHit = true;


	WeaponFireSnd[0] = SoundCue'AK_Weapon_Sounds.AK_Weap_Staff.AK_Weap_StaffPri_Cue' //XS:AK_Weapon_Sounds.Battle_Staff.Staff_Shooting 
	//WeaponFireSnd[1] = SoundCue'AK_Weapon_Sounds.Battle_Staff.Staff_Shooting' --Shouldn't have a sound BAKA!
	//WeaponEquipSnd=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_RaiseCue'
	//WeaponPutDownSnd=SoundCue'A_Weapon_ShockRifle.Cue.A_Weapon_SR_LowerCue'
	//PickupSound=SoundCue'A_Pickups.Weapons.Cue.A_Pickup_Weapons_Shock_Cue'

	//Overwriting vars
	ZoomInSound=SoundCue'AK_Weapon_Sounds.AK_Weap_Staff.AK_Weap_SnipeZoom_Cue'
	ZoomOutSound=SoundCue'AK_Weapon_Sounds.AK_Weap_Staff.AK_Weap_SnipeZoom_Cue'

	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=1
 
	ShotCost(0)=1
	ShotCost(1)=0

	FireOffset=(X=20,Y=5)
	PlayerViewOffset=(X=17,Y=5.0,Z=-8.0)


	LockerAmmoCount=60
	MaxAmmoCount=60

	FireCameraAnim(1)=CameraAnim'Camera_FX.ShockRifle.C_WP_ShockRifle_Alt_Fire_Shake'

	AttachmentClass = class'AK_Attachment_BattleStaff'
	MuzzleFlashSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01
	MuzzleFlashAltPSCTemplate=AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01
	MuzzleFlashColor=(R=200,G=120,B=255,A=255)
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'UTGame.UTShockMuzzleFlashLight'
	LockerRotation=(Pitch=32768,Roll=16384)

	IconX=400
	IconY=129
	IconWidth=22
	IconHeight=48

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformShooting1
		Samples(0)=(LeftAmplitude=90,RightAmplitude=40,LeftFunction=WF_Constant,RightFunction=WF_LinearDecreasing,Duration=0.1200)
	End Object
	WeaponFireWaveForm=ForceFeedbackWaveformShooting1

}
