class AK_Stockpile_FlagSpawn extends UTGameObjective
	placeable;

//Flag
var		AK_Stockpile_Flag			myFlag;
var		class< AK_Stockpile_Flag >	flagType;

//Appearance
var StaticMeshComponent 	 flagBaseMesh;
var MaterialInstanceConstant flagBaseMaterial;
var MaterialInstanceConstant flagBaseColor;




//---------------------------------------------- Game State Handling ----------------------------------------------//
//These are in order of their usage!
simulated function PostBeginPlay()
{
	local AK_Stockpile_Game game;
	game = AK_Stockpile_Game( WorldInfo.Game );

	Super.PostBeginPlay();

	if ( Role < ROLE_Authority )
		return;

	if ( game != None )
	{
		myFlag = Spawn( flagType, self );

		if ( myFlag == None )
		{
			`warn( Self$ " could not spawn flag of type '"$FlagType$"' at "$location );
			return;
		}
		else
		{
			game.RegisterStockpileFlag( myFlag );
			myFlag.HomeBase = self;
		}
	}

	flagBaseColor = new(Outer) class'MaterialInstanceConstant';
	flagBaseColor.SetParent( flagBaseMaterial );
	flagBaseMesh.SetMaterial( 0, flagBaseColor );
}




//------------------------------------------------- Interface -------------------------------------------------//
function UTCarriedObject GetFlag()
{
	return myFlag;
}

simulated event bool IsActive()
{
	return true;
}




DefaultProperties
{
	FlagType=class'AKHET.AK_Stockpile_Flag_Neutral'
	DefenderTeamIndex = 2

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
		StaticMesh=StaticMesh'AK_Flags.Meshes.AK_FlagStand_Mesh_01'
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightingChannels=(BSP=TRUE,Dynamic=TRUE,Static=TRUE,CompositeDynamic=TRUE)
		LightEnvironment=FlagBaseLightEnvironment

		CollideActors=false
		MaxDrawDistance=7000
		Translation=(X=0.0,Y=0.0,Z=-58.0)
		Scale = 1.0
	End Object
	FlagBaseMesh=StaticMeshComponent0
 	Components.Add(StaticMeshComponent0)

	FlagBaseMaterial = MaterialInstanceConstant'AK_Flags.Textures.AK_FlagStand_MAT_Nuetral_01_CONST'
}