class AK_Attachment_BattleStaff extends UTWeaponAttachment;

var ParticleSystemComponent Eye;
var ParticleSystem BeamTemplate;
var class<UDKExplosionLight> ImpactLightClass;
var int CurrentPath;

simulated function PostBeginPlay()
{
	Eye = new(Outer) class'ParticleSystemComponent';
	Eye.bAutoActivate = true;
	Eye.SetTemplate( ParticleSystem'AK_WeaponParticles.Eye.AK_EyeEffect_PS' );
	Mesh.AttachComponentToSocket( Eye,'Eye of Ra' );
	Eye.SetTranslation( vect( 45, -2.5, 0 ) );
	Super.PostBeginPlay();
}  

simulated function SpawnBeam(vector Start, vector End, bool bFirstPerson)
{
	local ParticleSystemComponent E;
	local actor HitActor;
	local vector HitNormal, HitLocation;

	if ( End == Vect(0,0,0) )
	{
		if ( !bFirstPerson || (Instigator.Controller == None) )
		{
	    	return;
		}
		// guess using current viewrotation;
		End = Start + vector(Instigator.Controller.Rotation) * class'UTWeap_ShockRifle'.default.WeaponRange;
		HitActor = Instigator.Trace(HitLocation, HitNormal, End, Start, TRUE, vect(0,0,0),, TRACEFLAG_Bullet);
		if ( HitActor != None )
		{
			End = HitLocation;
		}
	}

	E = WorldInfo.MyEmitterPool.SpawnEmitter(BeamTemplate, Start);
	E.SetVectorParameter('ShockBeamEnd', End);
	if (bFirstPerson && !class'Engine'.static.IsSplitScreen())
	{
		E.SetDepthPriorityGroup(SDPG_Foreground);
	}
	else
	{
		E.SetDepthPriorityGroup(SDPG_World);
	}
}

simulated function FirstPersonFireEffects(Weapon PawnWeapon, vector HitLocation)
{
	local vector EffectLocation;

	if (Instigator.FiringMode == 0 || Instigator.FiringMode == 3)
	{
		EffectLocation = UTWeapon(PawnWeapon).GetEffectLocation();
		SpawnBeam(EffectLocation, HitLocation, true);
		
		
		if (!WorldInfo.bDropDetail && Instigator.Controller != None)
		{
			UDKEmitterPool(WorldInfo.MyEmitterPool).SpawnExplosionLight(ImpactLightClass, HitLocation);
			
		}
	}

	Super.FirstPersonFireEffects(PawnWeapon, HitLocation);
}

simulated function ThirdPersonFireEffects(vector HitLocation)
{
	Super.ThirdPersonFireEffects(HitLocation);

	if ((Instigator.FiringMode == 0 || Instigator.FiringMode == 3))
	{
		SpawnBeam(GetEffectLocation(), HitLocation, false);
	}
}

simulated function bool AllowImpactEffects(Actor HitActor, vector HitLocation, vector HitNormal)
{
	return (HitActor != None && UTProj_ShockBall(HitActor) == None && Super.AllowImpactEffects(HitActor, HitLocation, HitNormal));
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
	local float PathValues[3];
	local int NewPath;
	Super.SetMuzzleFlashparams(PSC);
	if (Instigator.FiringMode == 0)
	{
		NewPath = Rand(3);
		if (NewPath == CurrentPath)
		{
			NewPath++;
		}
		CurrentPath = NewPath % 3;

		PathValues[CurrentPath % 3] = 1.0;
		PSC.SetFloatParameter('Path1',PathValues[0]);
		PSC.SetFloatParameter('Path2',PathValues[1]);
		PSC.SetFloatParameter('Path3',PathValues[2]);
//			CurrentPath++;
	}
	else if (Instigator.FiringMode == 3)
	{
		PSC.SetFloatParameter('Path1',1.0);
		PSC.SetFloatParameter('Path2',1.0);
		PSC.SetFloatParameter('Path3',1.0);
	}
	else
	{
		PSC.SetFloatParameter('Path1',0.0);
		PSC.SetFloatParameter('Path2',0.0);
		PSC.SetFloatParameter('Path3',0.0);
	}

}



DefaultProperties
{
	    // Weapon SkeletalMesh
 Begin Object Name=SkeletalMeshComponent0
 SkeletalMesh=SkeletalMesh'AK_BattleStaff.AK_BattleStaff_Mesh_02'
		Rotation=(Yaw=-819) //32768
		Translation = (Y = 30 )
		Scale=0.9
 End Object
 
	MuzzleFlashSocket=MuzzleFlashSocket	
	MuzzleFlashPSCTemplate=AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01
	MuzzleFlashAltPSCTemplate=AK_Particle.Muzzle_Flashes.AK_GenericMuzzleFlash_PS_01
	MuzzleFlashColor=(R=200,G=120,B=255,A=255)
	MuzzleFlashDuration=0.33
	MuzzleFlashLightClass=class'UTGame.UTShockMuzzleFlashLight'
	DefaultImpactEffect=(ParticleTemplate=ParticleSystem'AK_Particle.ImpactParticle.AK_BulletImpact_PS_01')
	BeamTemplate=ParticleSystem'AK_WeaponParticles.battlestaff_bullet.AK_BattleStaff_Beam_PS_01'
 	WeaponClass=class'AK_Weapon_BattleStaff'
	ImpactLightClass=class'UTShockImpactLight'
}
