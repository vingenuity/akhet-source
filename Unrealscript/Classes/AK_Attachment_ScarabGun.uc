class AK_Attachment_ScarabGun extends UTWeaponAttachment;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
 		SkeletalMesh=SkeletalMesh'AK_ScarabGun.Meshes.AK_Scarabgun_Mesh_01'
		Rotation = ( Yaw = 0 )	
		Translation = ( Y = 20 )
		Scale = 0.8
	 End Object
 
 	MuzzleFlashSocket = Muzzle
 	WeaponClass=class'AK_Weapon_ScarabGun'
 	WeapAnimType=EWAT_Default
}
