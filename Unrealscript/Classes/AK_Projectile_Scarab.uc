class AK_Projectile_Scarab extends UTProjectile;

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

//Every time we get new time, move the projectile a little bit, to simulate the scarabs "flying."
simulated function Tick(float DeltaTime)
{
	local vector newFlightVector;

	timeSinceLaunch += DeltaTime;
	if( timeSinceLaunch < 0.1 )
	{
		initialFlightVector = Normal( Velocity );
		return;
	}

	newFlightVector.X = initialFlightVector.X;
	newFlightVector.Y = initialFlightVector.Y * 2 * FRand();
	newFlightVector.Z = initialFlightVector.Z * 2 * FRand();

	Velocity = Speed * newFlightVector;
}

DefaultProperties
{
	Speed=2500 						//DH: Changed from 1400
	MaxSpeed=5000					//DH: Changed from 5000
	AccelRate=1000 					//DH: Changed from 3000

	MyDamageType = class'AKHET.AK_DamageType_ScarabShot'
	Damage=12						//DH: Changed from 26
	DamageRadius=0
	MomentumTransfer=0

	ProjFlightTemplate=ParticleSystem'AK_WeaponParticles.Scarab_Bullet.AK_ScarabBullet_PS_01'
	ProjExplosionTemplate=ParticleSystem'AK_Particle.ImpactParticle.AK_BulletImpact_PS_01'
	LifeSpan=3.0

	AmbientSound = SoundCue'AK_Weapon_Sounds.AK_Weap_Scarab.AK_Weap_ScarabPri_Cue' //XS:this is the scarab primary projectile sound. 

	RemoteRole=ROLE_SimulatedProxy
	bNetTemporary=false
}