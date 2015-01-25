class AK_Game_FlagStand extends UTCTFBase
	abstract;

DefaultProperties
{
	bStatic=false
	bTickIsDisabled=false
	bHidden=false

	bAlwaysRelevant=true
	NetUpdateFrequency=1
	RemoteRole=ROLE_SimulatedProxy

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0060.000000
		CollisionHeight=+0060.000000
	End Object

	// define here as lot of sub classes which have moving parts will utilize this
	Begin Object Class=DynamicLightEnvironmentComponent Name=FlagBaseLightEnvironment
	    bDynamic=FALSE
		bCastShadows=FALSE
	End Object
	Components.Add(FlagBaseLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AK_Pickups.StaticMeshes.AK_PickupBase_Mesh_Placeholder'
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightingChannels=(BSP=TRUE,Dynamic=TRUE,Static=TRUE,CompositeDynamic=TRUE)
		LightEnvironment=FlagBaseLightEnvironment

		CollideActors=false
		MaxDrawDistance=7000
		Translation=(X=0.0,Y=0.0,Z=-58.0)
		Scale = 2.5
	End Object
	FlagBaseMesh=StaticMeshComponent0
 	Components.Add(StaticMeshComponent0)

	FlagBaseMaterial = MaterialInstanceConstant'AK_Pickups.Materials.AK_PickupBase_mat_Placeholder_INST'
}