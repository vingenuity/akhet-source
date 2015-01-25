class AK_Projectile_SMG extends UTProjectile;

var vector initialFlightVector;
var float timeSinceLaunch;

function Init(vector Direction)
{
	timeSinceLaunch = 0.0;
	SetRotation(rotator(Direction));
	initialFlightVector = Direction;
	Velocity = Speed * Direction;
	Acceleration = AccelRate * Normal(Velocity);
}

DefaultProperties
{
	Speed=2000			//DH: Changed from 1400
	MaxSpeed=6000		//DH: Changed from 5000
	AccelRate=1500		//DH: Changed from 3000

	MyDamageType = class'AKHET.AK_DamageType_SmgSpray'
	Damage=12			//DH: Changed from 10
	DamageRadius=0
	MomentumTransfer=0
	//AmbientSound = SoundCue'AK_Weapon_Sounds.SMG.SMG_Alt_Fire_Cue'
	ProjFlightTemplate = ParticleSystem'AK_WeaponParticles.SMG_Bullet.AK_SMG_Bullet_PS_01'
	ProjExplosionTemplate=ParticleSystem'AK_Particle.ImpactParticle.AK_BulletImpact_PS_01'
	LifeSpan=3.0

	RemoteRole=ROLE_SimulatedProxy
	bNetTemporary=false
}