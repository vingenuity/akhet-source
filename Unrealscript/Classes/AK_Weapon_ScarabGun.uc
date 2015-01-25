class AK_Weapon_ScarabGun extends AK_Weapon_Base;

var float shotSpreadConeAngle;
var float burstTimer;
var float burstTime;
var int currentBurstCount;
var int burstCount;

//simulated function BeginFire(byte FireModeNum)
//{
//	if(FireModeNum == 0)
//	{
//		SetCurrentFireMode(0);
//		RemoveSpamOfSecondary();
//	}
//	if(FireModeNum == 1)
//	{
//		SetCurrentFireMode(1);
//		super.BeginFire(FireModeNum);
//	}
		
//}

//simulated function RemoveSpamOfSecondary()
//{
//	if(currentBurstCount == 0)
//	{
//		burstTimer = 0.2;
//		currentBurstCount = burstCount;
//	}
//}

//simulated function FireAmmo()
//{
//	if(AmmoCount != 0)
//	{
//		super.FireAmmunition();
//	}
//}

//simulated function Tick(float dt)
//{
//	super.Tick(dt);
//	if(currentBurstCount > 0 && burstTimer < 0)
//	{
//		currentBurstCount--;
//		burstTimer = burstTime;
//		FireAmmo();
//	}
//	else
//	{ 
//		burstTimer -= dt;
//	}
//}

//--------------------------------------------- Firing Modes -----------------------------------------------//
simulated function CustomFire()
{
	local int offsetY, offsetZ;
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

		for ( offsetZ = -1; offsetZ <= 1; ++offsetZ )
		{
			for ( offsetY = -1; offsetY <= 1; ++offsetY )
			{
				firedProjectile = Spawn( projectileClass, /*ownerOfSpawnedActor*/, /*stringNameOfSpawnedActor*/, positionWhereWeaponFired, /*rotationOfSpawnedActor*/, /*actorTemplateForSpawnedActor*/, /*boolShouldSpawnFailIfColliding*/);
				
				//Offset the projectile's direction by a set amount
				if( firedProjectile != None )
				{
					//Set Projectile's direction to the player's direction plus a little bit of randomness because BUG BULLETS
					randomizedYVector = ( 0.2 + 0.8 * FRand() ) * shotSpreadConeAngle * offsetY * instigatorAimDirectionY;
					randomizedZVector = ( 0.2 + 0.8 * FRand() ) * shotSpreadConeAngle * offsetZ * instigatorAimDirectionZ;

					firedProjectile.Init( instigatorAimDirectionX + randomizedYVector + randomizedZVector );
				}
			}
	    }
	}
}

//--------------------------------------------------------------------------------------------------------
simulated function Projectile ProjectileFire()
{
	local vector					positionWhereWeaponFired;
	local AK_Projectile_ScarabNest  SpawnedProjectile;

	// tell remote clients that we fired, to trigger effects
	IncrementFlashCount();

	if( Role == ROLE_Authority )
	{
		// this is the location where the projectile is spawned.
		positionWhereWeaponFired = GetPhysicalFireStartLoc();

		// Spawn projectile
		SpawnedProjectile = Spawn( class'AK_Projectile_ScarabNest',,, positionWhereWeaponFired );
		if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
		{
			SpawnedProjectile.Init( Vector( GetAdjustedAim( positionWhereWeaponFired ) ) );
		}

		// Return it up the line
		return SpawnedProjectile;
	}

	return None;
}



//--------------------------------------------------------------------------------------------------------
DefaultProperties
{
	localizationSection = "AK_Weapon_ScarabGun"
	
	CrosshairImage=Texture2D'AK_hud.AK_HUD_Reticles'
	CrossHairCoordinates=( U=0, V=0, UL=256, VL=256 )

	//Key to press to switch to weapon
	InventoryGroup=3 

	//---------------------------- Firing Mode ----------------------------//
	shotSpreadConeAngle = 0.08				//JL: Changed from 0.1
	WeaponFireTypes(0)=EWFT_Custom
	WeaponProjectiles(0)=class'AK_Projectile_Scarab'
	WeaponFireTypes(1)=EWFT_Projectile
	WeaponProjectiles(1)=class'AK_Projectile_ScarabNest'

	
	WeaponFireSnd[0] = SoundCue'AK_Weapon_Sounds.AK_Weap_Scarab.AK_Weap_ScarabFire_Cue' //This is the sound of the gun firing
	WeaponFireSnd[1] = SoundCue'AK_Weapon_Sounds.AK_Weap_Scarab.AK_Weap_ScarabFire_Cue' //This is the sound of the gun firing

	//---------------------------- Ammunition ----------------------------//
	ShotCost(0)=1
	ShotCost(1)=3

	AmmoCount=12
	LockerAmmoCount=12
	MaxAmmoCount=12
	burstCount = 1
	burstTime = 0.3
	maxAmmoRechargedPerSecond = 2
	secondsBeforeStartingRecharge = 3
	bAutoCharge=true

	FireInterval(0)=+1.2                                 
	FireInterval(1)=+0.7


	//---------------------------- Appearance ----------------------------//
	// Mesh and animations used in player's view
	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'AK_ScarabGun.Meshes.AK_Scarabgun_Mesh_01'
		AnimSets(0)=AnimSet'AK_ScarabGun.AK_ScarabGun_ANIMSET_01'
		Animations=MeshSequenceA
		Translation = (X=70.0,Y=25.0,Z=-30.0)
		Rotation=(Yaw=-16384)
		Scale= 2.5
		FOV=60.0
	End Object

	TeamMaterials(0) = MaterialInstanceConstant'AK_ScarabGun.Textures.AK_ScarabGun_MAT_Ra_INST'
	TeamMaterials(1) = MaterialInstanceConstant'AK_ScarabGun.Textures.AK_ScarabGun_MAT_Anubis_INST'

	//X = how far down the barrel ( positive = out of the screen )
	//Y = where it is spawned left/right ( positive = right )
	//Z = where it is spawned up/down ( positive = up )
	FireOffset = ( X = 7, Y = 12, Z = -5.0 )
	PlayerViewOffset=(X=16.0,Y=-5,Z=-3.0)

	WeaponFireAnim(0)=WeaponFire
	WeaponFireAnim(1)=WeaponAltFire

	InstantHitDamage(0)=100
	InstantHitDamage(1)=100
	InstantHitDamageTypes(0)=class'AK_DamageType_ScarabShot'
	InstantHitDamageTypes(1)=class'AK_DamageType_Jar'

	//Mesh and animations used in 3rd person view
	AttachmentClass = class'AK_Attachment_ScarabGun'

	MuzzleFlashSocket=Muzzle
	MuzzleFlashPSCTemplate=ParticleSystem'AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01'
	MuzzleFlashAltPSCTemplate=ParticleSystem'AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01'
	// Mesh used in the inventory pickup zone
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'AK_ScarabGun.Meshes.AK_Scarabgun_Mesh_01'
	End Object
	PivotTranslation = ( Y = 10.0 )
}
