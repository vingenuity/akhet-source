class AK_Weapon_WristGun extends AK_Weapon_Base;

var float burstTimer;
var float burstTime;
var int currentBurstCount;
var int burstCount;

simulated function BeginFire(byte FireModeNum)
{
	if(FireModeNum == 0)
	{
		SetCurrentFireMode(0);
		RemoveSpamOfSecondary();
	}
	if(FireModeNum == 1)
	{
		SetCurrentFireMode(1);
		super.BeginFire(FireModeNum);
	}
		
}

simulated function RemoveSpamOfSecondary()
{
	if(currentBurstCount == 0)
	{
		burstTimer = 0.1;
		currentBurstCount = burstCount;
	}
}

simulated function FireAmmo()
{
	if(AmmoCount != 0)
	{
		super.FireAmmunition();
	}
}

simulated function Tick(float deltaTime)
{
	super.Tick(deltaTime);
	if(currentBurstCount > 0 && burstTimer < 0)
	{
		currentBurstCount--;
		FireAmmo();
		burstTimer = burstTime;
	}
	else
	{
		burstTimer -= deltaTime;
	}
}


DefaultProperties
{
	localizationSection = "AK_Weapon_WristGun"

	//Don't drop this weapon on death
	bCanThrow = false
	
	CrosshairImage=Texture2D'AK_hud.AK_HUD_Reticles'
	CrossHairCoordinates=( U=768, V=0, UL=256, VL=256 )


	InventoryGroup=1 //Key to press to switch to weapon
	FireInterval(0)=+0.7	
	FireInterval(1)=+0.5
	AmmoCount=40
	WeaponFireTypes(0)=EWFT_Projectile
	WeaponFireTypes(1)=EWFT_Projectile
	WeaponProjectiles(0)=class'AK_Projectile_GhostSkull'
	WeaponProjectiles(1)=class'AK_Projectile_WristGun'

	TeamMaterials(0) = MaterialInstanceConstant'ak_gauntletgun.Textures.AK_GauntletGun_MAT_RA_INST'
	TeamMaterials(1) = MaterialInstanceConstant'ak_gauntletgun.Textures.AK_GauntletGun_MAT_ANUBIS_INST'

	LockerAmmoCount=40
	MaxAmmoCount=40
	WeaponRange=100
	burstCount = 1
	burstTime = 0.3
	maxAmmoRechargedPerSecond = 3
	secondsBeforeStartingRecharge = 2
	bAutoCharge=true

	FireOffset=(X=60,Y=5,Z=-5)
	PlayerViewOffset=(X=16.0,Y=-18,Z=-18.0)

	
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
		bCauseActorAnimEnd=true
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'ak_gauntletgun.Meshes.ak_sk_gauntletgun_mesh_02'
		AnimSets(0)=AnimSet'ak_gauntletgun.Meshes.AK_GauntletGun_AnimSet_01'
		Animations=MeshSequenceA
		Scale=1
		Translation=(x=0,y=15,z=12)
		Rotation=(Yaw=-16384)
		FOV=60.0
	End Object

	WeaponFireAnim(0)=WeaponFire
	WeaponFireAnim(1)=WeaponAltFire


	AttachmentClass=class'AK_Attachment_WristGun'

	// Pickup staticmesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'ak_gauntletgun.Meshes.ak_sk_gauntletgun_mesh_02'
	End Object

	
	WeaponPutDownSnd = SoundCue'AK_Weapon_Sounds.AK_Weap_Equip_Cue';
	WeaponEquipSnd = SoundCue'AK_Weapon_Sounds.AK_Weap_Pickup_Cue';
	WeaponFireSnd(0)=SoundCue'AK_Weapon_Sounds.AK_Weap_Guantlet.AK_Weap_GuantletPri_Cue'
	WeaponFireSnd(1)=SoundCue'AK_Weapon_Sounds.AK_Weap_Guantlet.AK_Weap_GuantletSec_Cue' //XS: SoundCue'AK_Weapon_Sounds.AK_Weap_Guantlet.AK_Weap_GuantletFire_Cue'

	InstantHitDamage(0)=100
	InstantHitDamage(1)=100
	InstantHitDamageTypes(0)=class'AK_DamageType_Skull'
	InstantHitDamageTypes(1)=class'AK_DamageType_Hand'

	MuzzleFlashSocket=Barrel
	MuzzleFlashPSCTemplate=ParticleSystem'AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01'
	MuzzleFlashAltPSCTemplate=ParticleSystem'AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01'
	MuzzleFlashLightClass=class'UTGame.UTLinkGunMuzzleFlashLight'

	bShowAltMuzzlePSCWhenWeaponHidden=TRUE

	//BeamTemplate[1]=ParticleSystem'AK_WeaponParticles.Gauntlet_HandBuildParticle.AK_HandBuilder_PS_01'

}
