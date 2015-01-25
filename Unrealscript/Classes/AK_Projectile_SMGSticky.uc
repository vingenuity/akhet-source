class AK_Projectile_SMGSticky extends UTProjectile;

var float timeBeforeBoom;
var Vector projectileHitlocation;
var Vector projectileHitNormal;
var Actor  otherPlayer;

//This function is almost directly copied from the base UTProjectile.
//The only change is we are slightly scaling down the particle.
simulated function SpawnFlightEffects()
{
	if (WorldInfo.NetMode != NM_DedicatedServer && ProjFlightTemplate != None)
	{
		ProjEffects = WorldInfo.MyEmitterPool.SpawnEmitterCustomLifetime(ProjFlightTemplate);
		ProjEffects.SetAbsolute(false, false, false);
		ProjEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
		ProjEffects.OnSystemFinished = MyOnParticleSystemFinished;
		ProjEffects.bUpdateComponentInTick = true;
		ProjEffects.SetScale( 0.4 );
		AttachComponent(ProjEffects);
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if ( Other != Instigator )
    {
        Velocity = vect( 0, 0, 0 );
		SetPhysics(PHYS_Projectile);
        SetBase(Other);
		SetTimer(timeBeforeBoom,false,'Explode');
		LifeSpan=timeBeforeBoom;
		projectileHitlocation=HitLocation;
		projectileHitNormal=HitNormal;
		otherPlayer=Other;
		
    }
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
	if (Damage > 0 && DamageRadius > 0)
	{
		if ( Role == ROLE_Authority )
		{
			MakeNoise(1.0);
		}
	}	
	Destroy();

	if( otherPlayer != None ) //If we successfully attached to a player
		otherPlayer.TakeDamage( Damage, InstigatorController, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType, /*TraceHitInfo hitInfo*/, self );
}



DefaultProperties
{
	MyDamageType = class'AKHET.AK_DamageType_SmgSticky'
	Damage=80;
	DamageRadius=1000 

	Speed = 1500;
	MomentumTransfer=2000
	timeBeforeBoom=1

	ProjFlightTemplate = ParticleSystem'AK_WeaponParticles.SMG_Sticky.AK_SMG_Sticky_PS_01'
	ProjExplosionTemplate=ParticleSystem'AK_WeaponParticles.SMG_Sticky.AK_StickyExplosion_PS_01'
	AmbientSound = SoundCue'AK_Weapon_Sounds.SMG.SMG_Alt_Fire_Cue'
}
