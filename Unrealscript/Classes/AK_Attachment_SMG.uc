class AK_Attachment_SMG extends UTWeaponAttachment;

DefaultProperties
{
	Begin Object Name=SkeletalMeshComponent0
 		SkeletalMesh = SkeletalMesh'AK_SMG.AK_SMG_Mesh_01'
		Rotation = ( Yaw = 0 )	
		Translation = ( Y = 20 )
		Scale = 0.8
	 End Object
 
 	MuzzleFlashSocket = Muzzle
 	WeaponClass=class'AK_Weapon_SMG'
}
