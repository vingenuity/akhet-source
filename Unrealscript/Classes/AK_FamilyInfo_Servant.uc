class AK_FamilyInfo_Servant extends UTFamilyInfo
	abstract;

/** We don't have first person arms */ 
function static SkeletalMesh GetFirstPersonArms()
{
	return None;
}

/** We don't have a first person arms material */
function static MaterialInterface GetFirstPersonArmsMaterial(int TeamNum)
{
   return None;
}

DefaultProperties
{
	VoiceClass=class'AKHET.AK_Voice_Servant'
	SoundGroupClass=class'AKHET.AK_PawnSoundGroup'

	CharacterMesh = SkeletalMesh'AK_Characters.Meshes.ak_sk_character_base01'
	
	CharacterTeamHeadMaterials[0]=MaterialInterface'AK_Characters.Textures.ak_ra_mat_01'
	CharacterTeamHeadMaterials[1]=MaterialInterface'AK_Characters.Textures.AK_Anubis_MAT_PlaceHolder'
	CharacterTeamBodyMaterials[0]=None
	CharacterTeamBodyMaterials[1]=None

	PhysAsset = PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
	AnimSets(0) = AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
}