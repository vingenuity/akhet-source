class AK_Projectile_BattleStaff extends UTProjectile;

DefaultProperties
{
	
	Speed=4000				//KK: Changed from 10000
	MaxSpeed=5000			//KK: Changed from 15000
	AccelRate=1500			//KK: Changed from 3000

	Damage=20				//DH: CHanged from 26
	MyDamageType = class'AKHET.AK_DamageType_Staffshot'

	ProjFlightTemplate=ParticleSystem'AK_WeaponParticles.battlestaff_bullet.AK_BattleStaffBullet_PS_01'
	ProjExplosionTemplate=ParticleSystem'AK_Particle.ImpactParticle.AK_BulletImpact_PS_01'
}
