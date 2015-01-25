class AK_PawnSoundGroup extends UTPawnSoundGroup;

DefaultProperties
{
	//DrownSound = SoundCue'A_Character_IGMale_Cue.Efforts.A_Effort_IGMale_MaleDrowning_Cue' - XS: N/A for Ahket gameplay
	//GaspSound  = SoundCue'A_Character_IGMale_Cue.Efforts.A_Effort_IGMale_MGasp_Cue'

	//Hit by small amount of damage
	HitSounds[0] = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_BeingHit_Cue'
	//Hit by medium amount of damage
 	HitSounds[1] = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_BeingHit_Cue'
	//Hit by large amount of damage
 	HitSounds[2] = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_BeingHit_Cue'


	BulletImpactSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_BulletImpact_Cue' //XS: Changed from UDK default

	DefaultFootstepSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Footstep_Cue'

	DefaultJumpingSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Fall_Cue'
	DoubleJumpSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Fall_Cue' //SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_DoubleJump_Cue'
	LandSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Jump_Cue'
	DefaultLandingSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Jump_Cue'

	DyingSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Death_Cue'

	//New sounds for new materials should start at the following numbers. Follow this signature.
	FootstepSounds[0]=(MaterialType=Stone,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[1]=(MaterialType=Dirt,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[2]=(MaterialType=Energy,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[3]=(MaterialType=Flesh_Human,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[4]=(MaterialType=Foliage,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[5]=(MaterialType=Glass,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[6]=(MaterialType=Water,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[7]=(MaterialType=ShallowWater,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[8]=(MaterialType=Metal,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[9]=(MaterialType=Snow,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[10]=(MaterialType=Wood,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	FootstepSounds[11] = ( MaterialType = AkhetDef, Sound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Footstep_Cue' )
	FootstepSounds[12] = ( MaterialType = AkhetMetal, Sound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Metalstep_Cue')
	FootstepSounds[13] = ( MaterialType = AkhetSand, Sound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Sandstep_Cue')

	JumpingSounds[0]=(MaterialType=Stone,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[1]=(MaterialType=Dirt,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[2]=(MaterialType=Energy,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[3]=(MaterialType=Flesh_Human,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[4]=(MaterialType=Foliage,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[5]=(MaterialType=Glass,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[6]=(MaterialType=GlassBroken,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[7]=(MaterialType=Grass,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[8]=(MaterialType=Metal,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[9]=(MaterialType=Mud,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[10]=(MaterialType=Metal,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[11]=(MaterialType=Snow,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[12]=(MaterialType=Tile,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[13]=(MaterialType=Water,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[14]=(MaterialType=ShallowWater,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	JumpingSounds[15]=(MaterialType=Wood,Sound=SoundCue'AK_AmbNoise.Silence_Cue')

	LandingSounds[0]=(MaterialType=Stone,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[1]=(MaterialType=Dirt,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[2]=(MaterialType=Energy,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[3]=(MaterialType=Flesh_Human,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[4]=(MaterialType=Foliage,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[5]=(MaterialType=Glass,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[6]=(MaterialType=GlassBroken,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[7]=(MaterialType=Grass,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[8]=(MaterialType=Metal,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[9]=(MaterialType=Mud,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[10]=(MaterialType=Metal,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[11]=(MaterialType=Snow,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[12]=(MaterialType=Tile,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[13]=(MaterialType=Water,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[14]=(MaterialType=ShallowWater,Sound=SoundCue'AK_AmbNoise.Silence_Cue')
	LandingSounds[15]=(MaterialType=Wood,Sound=SoundCue'AK_AmbNoise.Silence_Cue')


	//JumpingSounds[16]  = ( MaterialType = Wood, Sound = SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WoodJumpCue' )
	//LandingSounds[16]  = ( MaterialType = Wood, Sound = SoundCue'A_Character_Footsteps.FootSteps.A_Character_Footstep_WoodLandCue' )
}