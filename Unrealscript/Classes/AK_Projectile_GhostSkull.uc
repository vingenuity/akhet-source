class AK_Projectile_GhostSkull extends UTProjectile;

DefaultProperties
{
	ProjFlightTemplate=ParticleSystem'AK_WeaponParticles.Gauntlet_SkullBullet.AK_SkullBullet_PS_01'
	ProjExplosionTemplate=ParticleSystem'AK_Particle.ImpactParticle.AK_BulletImpact_PS_01'

	AmbientSound = SoundCue'AK_Weapon_Sounds.AK_Weap_Guantlet.AK_Weap_SkullHiss_Cue' 
	//ExplosionSound = SoundCue'AK_Weapon_Sounds.AK_Weap_Guantlet.AK_Weap_GuantletPri_Cue'

	//Damage
	MyDamageType = class'Akhet.AK_DamageType_Skull'
	Damage=20;			//JL: Changed from 3
	DamageRadius=10 
	MomentumTransfer=50

	//Speed
	Speed=1700			//JL: Changed from 1000
	MaxSpeed=3000		//JL: Changed from 1000
	AccelRate=10
}
