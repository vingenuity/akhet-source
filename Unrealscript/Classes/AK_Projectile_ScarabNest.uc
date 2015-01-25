class AK_Projectile_ScarabNest extends UTProjectile;


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
		ProjEffects.SetScale( 1.2 );
		AttachComponent(ProjEffects);
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    if ( Other != Instigator )
    {
        Other.TakeDamage( Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType, /*TraceHitInfo hitInfo*/, self );
        Destroy();
    }
}
 
simulated event Landed (Object.Vector HitNormal, Actor FloorActor)
{
	Spawn( class'AK_Trap_ScarabSwarm' );
	Destroy();
}

DefaultProperties
{
	ProjFlightTemplate = ParticleSystem'AK_WeaponParticles.Scarab_Jar.AK_ScarabJar_PS_01'
	ProjExplosionTemplate=ParticleSystem'AK_WeaponParticles.Scarab_Jar.AK_JarExplosion_PS_01'
	ImpactSound = SoundCue'AK_Weapon_Sounds.AK_Weap_Scarab.AK_Weap_JarBreak_Cue'

	MyDamageType = class'AKHET.AK_DamageType_Jar'
	Damage=50
	DamageRadius=10
	MomentumTransfer=50000

	speed = 1500

	TossZ = 100
	Physics=PHYS_Falling
	CustomGravityScaling=0.70					//JL: Changed from 0.80
}