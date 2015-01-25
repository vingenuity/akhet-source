class AK_DamageType_StaffShot extends AK_DamageType_Base
	abstract;

DefaultProperties
{
	localizationSection = "AK_DamageType_StaffShot";

	// Information about weapon causing this damage
	DamageWeaponClass=class'AK_Weapon_BattleStaff'
	DamageWeaponFireMode = 0

	headshotDamageMultiplier = 2.0
}