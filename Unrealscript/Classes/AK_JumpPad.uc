class AK_JumpPad extends UDKJumpPad
	placeable;

DefaultProperties
{
	//------------------------------ Appearance ------------------------------//
	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AK_Architecture_Pieces.JumpPad.AK_jumppad_SM_01'
		CollideActors=false
		Scale3D=(X=0.8,Y=0.8,Z=0.8)
		Translation=(X=0.0,Y=0.0,Z=-50.0)

		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightingChannels=(BSP=TRUE,Dynamic=FALSE,Static=TRUE,CompositeDynamic=TRUE)
		LightEnvironment=JumpPadLightEnvironment
	End Object
 	Components.Add(StaticMeshComponent0)

	Begin Object Class=UTParticleSystemComponent Name=ParticleSystemComponent1
		Translation=(X=0.0,Y=0.0,Z=-35.0)
		Scale3D=(X=2.0,Y=2.0,Z=2.0)
		Template=ParticleSystem'AK_Architecture_Pieces.JumpPad.ak_jumppad_lift_ps'
		bAutoActivate=true
		SecondsBeforeInactive=1.0f
	End Object
	Components.Add(ParticleSystemComponent1)



	//-------------------------------- Audio --------------------------------//
	JumpSound=SoundCue'AK_Pickup_Audio.JumpPad.AK_Jump_PadActivate_Cue'

	Begin Object Class=AudioComponent Name=AmbientSound
		SoundCue = SoundCue'AK_Pickup_Audio.JumpPad.Ambient_Hum_Cue'
		bAutoPlay=true
		bUseOwnerLocation=true
		bShouldRemainActiveIfDropped=true
		bStopWhenOwnerDestroyed=true
	End Object
	JumpAmbientSound=AmbientSound
	Components.Add(AmbientSound)
}
