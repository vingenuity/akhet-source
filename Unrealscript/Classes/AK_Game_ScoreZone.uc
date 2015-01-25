class AK_Game_ScoreZone extends UTGameObjective
	abstract;

var	AK_Game_Flag enemyFlag;
var repnotify bool hostingFlag;

var float radiusOfScoreZone;

var StaticMeshComponent zoneCenterMesh;
var Material zoneCenterMaterial;
var	ParticleSystemComponent	zoneRingParticles;

replication
{
    if ( Role == ROLE_Authority )
		hostingFlag;
}

simulated event ReplicatedEvent ( name eventName )
{
	local vector topOfCylinder, bottomOfCylinder;
	topOfCylinder = self.location;
	topOfCylinder.z += 60.0;
	bottomOfCylinder = self.location;
	bottomOfCylinder.z -= 60.0;

	if( eventName == 'hostingFlag' )
	{
		if( hostingFlag )
		{
			DrawDebugCylinder( bottomOfCylinder, topOfCylinder, radiusOfScoreZone, 40, 255, 255, 255, true );
		}
		else
		{
			FlushPersistentDebugLines();
		}
	}
	else
	{
		Super.ReplicatedEvent( eventName );
	}
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	if( zoneRingParticles != none )
	{
		zoneRingParticles.SetActive(true);
	}
}

simulated function Touch( Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal )
{
	local Pawn stockpilePawn;
	local int teamIndex;
	local bool pawnHasFlag;

	stockpilePawn = Pawn( Other );
    if ( stockpilePawn != None )
    {
    	teamIndex = stockpilePawn.GetTeamNum();
    	pawnHasFlag = UTPlayerReplicationInfo( stockpilePawn.Controller.PlayerReplicationInfo ).bHasFlag;

    	if( pawnHasFlag && ( teamIndex == DefenderTeamIndex ) )
    	{
			enemyFlag = AK_Game_Flag( UTPlayerReplicationInfo( stockpilePawn.Controller.PlayerReplicationInfo ).GetFlag() );
			enemyFlag.PlaceFlag( self );
			hostingFlag = true;
    	}
    }
}

simulated function SendHostedFlagHome( Pawn enemyPawn )
{
	enemyFlag.SendHome( enemyPawn.Controller );
	hostingFlag = false;
}






DefaultProperties
{
	enemyFlag = None
	hostingFlag = false
	bAlwaysRelevant=true
	NetUpdateFrequency=1
	RemoteRole=ROLE_SimulatedProxy

	radiusOfScoreZone = 300.0;

    bCollideActors=true
	Begin Object Name=CollisionCylinder
		CollisionRadius=+30.0
		CollisionHeight=+60.0

        CollideActors=true        
        BlockActors=false
        BlockNonZeroExtent=true
        BlockZeroExtent=true
	End Object

	Begin Object Class=DynamicLightEnvironmentComponent Name=FlagBaseLightEnvironment
	    bDynamic=FALSE
		bCastShadows=FALSE
	End Object
	Components.Add( FlagBaseLightEnvironment )

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		StaticMesh=StaticMesh'AK_Pickups.StaticMeshes.AK_PickupBase_Mesh_Placeholder'
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightingChannels=( BSP=TRUE, Dynamic=TRUE, Static=TRUE, CompositeDynamic=TRUE )

		CollideActors=false
		MaxDrawDistance=7000
		Translation=( X=0.0, Y=0.0, Z=-58.0 )
		Scale = 2.5
	End Object
	zoneCenterMesh=StaticMeshComponent0
 	Components.Add( StaticMeshComponent0 )

	zoneCenterMaterial = Material'AK_Pickups.Materials.AK_PickupBase_mat_Placeholder'
}
