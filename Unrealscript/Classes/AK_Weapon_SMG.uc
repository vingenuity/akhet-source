class AK_Weapon_SMG extends AK_Weapon_Base;

var float shotSpreadConeAngle;

//--------------------------------------------- Firing Modes -----------------------------------------------//
simulated function CustomFire()
{
   	local vector positionWhereWeaponFired;
   	local Rotator instigatorAimRotation;
   	local vector instigatorAimDirectionX, instigatorAimDirectionY, instigatorAimDirectionZ;
	local class< Projectile > projectileClass;

	local Projectile firedProjectile;
	local vector randomizedYVector, randomizedZVector;

	IncrementFlashCount();

	if (Role == ROLE_Authority)
	{
		// fire position is where the projectile will be spawned
		positionWhereWeaponFired = GetPhysicalFireStartLoc();

		// get direction our instigator is aiming
		instigatorAimRotation = GetAdjustedAim( positionWhereWeaponFired );
		GetAxes( instigatorAimRotation, instigatorAimDirectionX, instigatorAimDirectionY, instigatorAimDirectionZ );

		// get the projectile we are firing 
		projectileClass = GetProjectileClass();

		firedProjectile = Spawn( projectileClass, /*ownerOfSpawnedActor*/, /*stringNameOfSpawnedActor*/, positionWhereWeaponFired, /*rotationOfSpawnedActor*/, /*actorTemplateForSpawnedActor*/, /*boolShouldSpawnFailIfColliding*/);
				
		//Offset the projectile's direction by a set amount
		if( firedProjectile != None )
		{
			//Set Projectile's direction to the player's direction plus a little bit of randomness because BUG BULLETS
			randomizedYVector = ( ( 2 * FRand() ) -1) * shotSpreadConeAngle * instigatorAimDirectionY;
			randomizedZVector = ( ( 2 * FRand() ) -1) * shotSpreadConeAngle * instigatorAimDirectionZ;

			firedProjectile.Init( instigatorAimDirectionX + randomizedYVector + randomizedZVector );
		}
	}
}



DefaultProperties
{
	localizationSection = "AK_Weapon_SMG"

	CrosshairImage=Texture2D'AK_hud.AK_HUD_Reticles'
	CrossHairCoordinates=( U=256, V=0, UL=256, VL=256 )
	
	//Key to press to switch to weapon
	InventoryGroup=2

	//--------------------------- Firing Mode ---------------------------//
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'AK_Projectile_SMG'
	WeaponFireTypes(1)=EWFT_Projectile
	WeaponProjectiles(1)=class'AK_Projectile_SMGSticky'

	WeaponFireSnd[0] = SoundCue'AK_Weapon_Sounds.AK_Weap_SMG.AK_Weap_SMGPri_2_Cue' //XS:Added sound cue
	WeaponFireSnd[1] = SoundCue'AK_Weapon_Sounds.AK_Weap_SMG.AK_Weap_SMGSec_Cue' //XS:Sound cue added

	//----------------------- Fire Spread and Rate -----------------------//
	shotSpreadConeAngle = 0.03;			//JL: Changed from 0.05
	FireInterval(0)=+0.1	
	FireInterval(1)=+0.8
	


	//---------------------------- Ammunition ----------------------------//
	ShotCost(0)=2
	ShotCost(1)=15

	AmmoCount=180
	LockerAmmoCount=180
	MaxAmmoCount=180
	maxAmmoRechargedPerSecond = 10
	secondsBeforeStartingRecharge = 2
	bAutoCharge=true


	//---------------------------- Appearance ----------------------------//
	// Mesh and animations used in player's view
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	TeamMaterials(0) = MaterialInstanceConstant'AK_SMG.Textures.AK_SMG_MAT_RA_INST'
	TeamMaterials(1) = MaterialInstanceConstant'AK_SMG.Textures.AK_SMG_MAT_ANUBIS_INST'

	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'AK_SMG.AK_SMG_Mesh_01'
		AnimSets(0)=AnimSet'AK_SMG.AK_SMG_ANIMSET_01'
		Animations=MeshSequenceA
		Translation = (X=70.0,Y=20.0,Z=-20.0)
		Rotation=(Yaw=-16384)
		Scale = 3.0
		FOV=60.0
	End Object

	WeaponFireAnim(0)=WeaponFire
	WeaponFireAnim(1)=WeaponAltFire

	InstantHitDamage(0)=100
	InstantHitDamage(1)=100
	InstantHitDamageTypes(0)=class'AK_DamageType_SmgSpray'
	InstantHitDamageTypes(1)=class'AK_DamageType_SmgSticky'


	//Fire offset determines where the projectiles will be spawned.
	//X = how far down the barrel ( positive = out of the screen )
	//Y = where it is spawned left/right ( positive = right )
	//Z = where it is spawned up/down ( positive = up )
	FireOffset = ( X = 7, Y = 15, Z = -12.0 )
	PlayerViewOffset=(X=16.0,Y=-5,Z=-3.0)

	// Mesh and animations used in 3rd person view
	AttachmentClass = class'AK_Attachment_SMG'

	MuzzleFlashSocket=Muzzle
	MuzzleFlashPSCTemplate=ParticleSystem'AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01'
	MuzzleFlashAltPSCTemplate=ParticleSystem'AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01'
	// Mesh used in the inventory pickup zone
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'AK_SMG.AK_SMG_Mesh_01'
	End Object
	PivotTranslation = ( Y = 15.0 )
}
