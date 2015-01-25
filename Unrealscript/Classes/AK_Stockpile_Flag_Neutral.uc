class AK_Stockpile_Flag_Neutral extends AK_Stockpile_Flag;

DefaultProperties
{
	//Direction to translate flag object from origin when attached to player.
	GameObjOffset3P=(X=20,Y=20,Z=0)

	Begin Object Name=CollisionCylinder
		CollisionRadius=+14.0
		CollisionHeight=+27.0
		Translation=(X=0.0,Y=0.0,Z=-15.0)
		CollideActors=true
	End Object

	Begin Object Name=TheFlagSkelMesh
	 	SkeletalMesh = SkeletalMesh'AK_Flags.Meshes.AK_FlagJar_Mesh'
	 	PhysicsAsset=PhysicsAsset'AK_Flags.Meshes.AK_FlagJar_Mesh_Physics'
	 	Materials(1) = Material'AK_Flags.Textures.AK_FlagJar_MAT_01'
	 	Translation=(X=0.0,Y=0.0,Z=-45.0)  // this is needed to make the flag line up with the flag base
	End Object

	Begin Object Name=OverlayMeshComponent
		SkeletalMesh = SkeletalMesh'AK_Flags.Meshes.AK_FlagJar_Mesh'
		PhysicsAsset=PhysicsAsset'AK_Flags.Meshes.AK_FlagJar_Mesh_Physics'
		Materials(0) = Material'AK_Flags.FlagOccludedOverlay'
		Translation=(X=0.0,Y=0.0,Z=-45.0)  // this is needed to make the flag line up with the flag base
	End Object

	OverlayMaterial(0) = MaterialInstanceConstant'AK_Flags.FlagOccludedOverlay_Neutral_INST'
	OverlayMaterial(1) = MaterialInstanceConstant'AK_Flags.FlagOccludedOverlay_Neutral_INST'

	PickupSound   = SoundCue'AK_AmbNoise.AK_Jar_Pickup_Cue';
	DroppedSound  = SoundCue'AK_AmbNoise.ak_music_noise.AK_Amb_FlagLoss_Cue';
	ReturnedSound = SoundCue'AK_AmbNoise.ak_music_noise.AK_Amb_FlagCap_Cue';
}