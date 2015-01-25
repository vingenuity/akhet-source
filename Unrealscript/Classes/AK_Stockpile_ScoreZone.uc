class AK_Stockpile_ScoreZone extends UTGameObjective
	abstract;

var array< AK_Stockpile_Flag > hostedFlags;
var repnotify int numberOfHostedFlags;

var const float radiusOfScoreZone;
var const float flagOffsetRadius;

var StaticMeshComponent pedestalMesh;
var MaterialInstanceConstant pedestalMaterial;
var MaterialInstanceConstant pedestalColor;

var StaticMeshComponent outerRingMesh;
var StaticMeshComponent siphonTunnelMesh;

var class< LocalMessage > stockpileMessageClass;

var SoundCue placeFlagSound;
var SoundCue takeFlagSound;

replication
{
    if ( Role == ROLE_Authority )
		numberOfHostedFlags;
}

simulated event ReplicatedEvent ( name eventName )
{
	if( eventName == 'numberOfHostedFlags' )
	{
		SpawnOrDespawnSiphonCircle();
	}
	else
	{
		Super.ReplicatedEvent( eventName );
	}
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if ( Role < ROLE_Authority )
		return;

	siphonTunnelMesh.SetHidden( true );
	AK_Stockpile_Game( WorldInfo.Game ).RegisterScoreZone( self, DefenderTeamIndex );

	pedestalColor = new(Outer) class'MaterialInstanceConstant';
	pedestalColor.SetParent( pedestalMaterial );
	pedestalMesh.SetMaterial( 0, pedestalColor );
}


reliable server function ServerHandleSiphonCircle()
{
	SpawnOrDespawnSiphonCircle();
}

simulated function SpawnOrDespawnSiphonCircle()
{
	//local vector topOfCylinder, bottomOfCylinder;
	//topOfCylinder = self.location;
	//topOfCylinder.z += 60.0;
	//bottomOfCylinder = self.location;
	//bottomOfCylinder.z -= 60.0;

	if( numberOfHostedFlags > 0 )
	{
		//DrawDebugCylinder( bottomOfCylinder, topOfCylinder, radiusOfScoreZone, 40, 255, 255, 255, true );
		siphonTunnelMesh.SetHidden( false );
	}
	else
	{
		//FlushPersistentDebugLines();
		siphonTunnelMesh.SetHidden( true );
	}
}

simulated function Touch( Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal )
{
	local int lastFlagIndex;
	local UTPawn stockpilePawn;
	local bool pawnHasFlag;
	local AK_Stockpile_Flag heldFlag;
	local float fractionOfTotalFlags;
	local vector flagOffsetFromZoneCenter;

	stockpilePawn = UTPawn( Other );
    if ( stockpilePawn != None )
    {
    	pawnHasFlag = stockpilePawn.GetUTPlayerReplicationInfo().bHasFlag;

    	if( stockpilePawn.GetTeamNum() == DefenderTeamIndex )
    	{
	    	if( pawnHasFlag )
	    	{
	    		heldFlag = AK_Stockpile_Flag( stockpilePawn.GetUTPlayerReplicationInfo().GetFlag() );
	    		if ( heldFlag == None )
	    		 	return;
	    		heldFlag.ClearHolder();
	    		hostedFlags.AddItem( heldFlag );

	    		fractionOfTotalFlags = float( numberOfHostedFlags ) / AK_Stockpile_GRI( WorldInfo.GRI ).totalNumberOfFlags;
	    		flagOffsetFromZoneCenter.X = flagOffsetRadius * cos( fractionOfTotalFlags * 2 * PI );
	    		flagOffsetFromZoneCenter.Y = flagOffsetRadius * sin( fractionOfTotalFlags * 2 * PI );
				heldFlag.PlaceFlag( self, self.Location + flagOffsetFromZoneCenter );

				PlaySound( placeFlagSound );

				numberOfHostedFlags += 1;
				if( role == ROLE_Authority )
				{
					ServerHandleSiphonCircle();
				}
	    	}
    	}
    	else
    	{
	    	if( ( numberOfHostedFlags > 0 ) && !pawnHasFlag )
	    	{
	    		lastFlagIndex = hostedFlags.Length - 1;
	    		hostedFlags[ lastFlagIndex ].SetHolder( stockpilePawn.Controller );

	    		PlaySound( takeFlagSound );

	    		hostedFlags.Remove( lastFlagIndex, 1 );
				numberOfHostedFlags -= 1;
				if( role == ROLE_Authority )
				{
					ServerHandleSiphonCircle();

					//Flag stolen messages start at index 8, and you want the opposite team's from yours
					BroadcastLocalizedMessage( stockpileMessageClass, 8 + ( 1 - stockpilePawn.GetTeamNum() ), stockpilePawn.PlayerReplicationInfo );
				}
	    	}
    	}
    }
}




DefaultProperties
{
	bAlwaysRelevant=true
	NetUpdateFrequency=1
	RemoteRole=ROLE_SimulatedProxy
    stockpileMessageClass = class'AKHET.AK_Message_Stockpile'

	radiusOfScoreZone = 300.0;
	flagOffsetRadius = 20.0;

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



	Begin Object Class=StaticMeshComponent Name=PedestalMeshComponent
		StaticMesh=StaticMesh'AK_Flags.Meshes.AK_FlagStand_Mesh_01'
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightingChannels=( BSP=TRUE, Dynamic=TRUE, Static=TRUE, CompositeDynamic=TRUE )

		CollideActors=false
		MaxDrawDistance=7000
		Translation=( X=0.0, Y=0.0, Z=-42.0 )
		Rotation=(Roll=32768)
		Scale = 1.0
	End Object
 	Components.Add( PedestalMeshComponent )
 	pedestalMesh = PedestalMeshComponent
	pedestalMaterial = MaterialInstanceConstant'AK_Flags.Textures.AK_FlagStand_MAT_Nuetral_01_CONST'

	Begin Object Class=StaticMeshComponent Name=OuterRingMeshComponent
		StaticMesh=StaticMesh'AK_Decoration_Pieces.capture_ring.AK_CaptureRing_Mesh_01'
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=FALSE
		bForceDirectLightMap=TRUE
		LightingChannels=( BSP=TRUE, Dynamic=TRUE, Static=TRUE, CompositeDynamic=TRUE )

		CollideActors=false
		MaxDrawDistance=7000
		Translation=( X=0.0, Y=0.0, Z=-44.0 )		    //DH:Z changed from -50
		Scale3D=(X=1.015,Y=1.015,Z=1.0)				//DH: Changed from Scale=1.2
	End Object
 	Components.Add( OuterRingMeshComponent )
 	outerRingMesh = OuterRingMeshComponent

 	
	Begin Object Class=StaticMeshComponent Name=SiphonTunnelMeshComponent
		StaticMesh=StaticMesh'AK_Decoration_Pieces.Siphon_Circle.AK_SiphonCircle_Mesh_Purple_01'
		CastShadow=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsLights=TRUE
		bForceDirectLightMap=TRUE
		LightingChannels=( BSP=TRUE, Dynamic=TRUE, Static=TRUE, CompositeDynamic=TRUE )

		CollideActors=false
		MaxDrawDistance=7000
		Translation=( X=0.0, Y=0.0, Z=-62.0 )
		Scale = 1.0 							//DH: Changed from 1.2
	End Object
 	Components.Add( SiphonTunnelMeshComponent )
 	siphonTunnelMesh = SiphonTunnelMeshComponent

	placeFlagSound = SoundCue'AK_AmbNoise.ak_music_noise.AK_SiphonParticle_Cue'
	takeFlagSound = SoundCue'AK_AmbNoise.AK_Jar_Pickup_Cue' //sames as picking up from original jar loc.
}
