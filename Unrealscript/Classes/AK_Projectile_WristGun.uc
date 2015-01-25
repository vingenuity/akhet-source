class AK_Projectile_WristGun extends UTProjectile;

var float timeAlive;
var float timeBeforeStop;

simulated function Tick(float DeltaTime)
{
	if( timeAlive > timeBeforeStop )
	{
		Velocity *= 0;
	}
	else
	{
		timeAlive += DeltaTime;	
	}
	
}

simulated function Destroyed()
{
	// This function is being overWritten to have the impact particle not show when  not hitting a wall. 
}



DefaultProperties
{
	//AmbientSound=SoundCue'AK_Weapon_Sounds.AK_Weap_Guantlet.AK_Weap_GuantletSec_Cue' //XS: sound of hand in use...
	MyDamageType = class'Akhet.AK_DamageType_Hand'

	LifeSpan=+1.0
	timeBeforeStop = 0.3
	Speed=2000			//DH: Changed from 1000
	MaxSpeed=2000
	AccelRate=10

	Damage=20			//JL: Changed from 1
	DamageRadius=0
	MomentumTransfer=90000.0

	ProjFlightTemplate=ParticleSystem'AK_WeaponParticles.Gauntlet_HandBuildParticle.AK_HandBuilder_PS_01'
	ProjExplosionTemplate=ParticleSystem'AK_Particle.ImpactParticle.AK_BulletImpact_PS_01'
	
}