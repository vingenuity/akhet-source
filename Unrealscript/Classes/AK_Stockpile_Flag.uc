class AK_Stockpile_Flag extends UTCTFFlag
	abstract;

var AK_Stockpile_ScoreZone holdingZone;
var bool inScoreZone;
var int flagIndex;

var class< LocalMessage > flagMessageClass;

var SkeletalMeshComponent OverlayMesh;
var MaterialInstanceConstant OverlayMaterial[2];

replication
{
	if ( bNetDirty )
		flagIndex;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( Role == NM_DedicatedServer )
		return;

	overlayMesh.SetMaterial( 0, OverlayMaterial[0] );
}


//----------------------------------------- States -----------------------------------------//
auto state Home
{
	ignores SendHome, Score, Drop;

	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		AK_Stockpile_GRI( WorldInfo.GRI ).SetFlagAtSpawn( flagIndex );
		WorldInfo.GRI.bForceNetUpdate = TRUE;
	}

	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );
	}

	function SameTeamTouch( Controller C )
	{
		//Touching the flag with the enemy flag does nothing!
	}
}

state Held
{
	ignores SetHolder;

	function SendHome(Controller Returner)
	{
		super.SendHome( Returner );
	}

	function KismetSendHome()
	{
		super.KismetSendHome();
	}

	function Timer()
	{
		super.Timer();
	}

	function BeginState( Name PreviousStateName )
	{
		super.BeginState( PreviousStateName );

		if( holder.GetTeamNum() == 0 )
			AK_Stockpile_GRI( WorldInfo.GRI ).SetFlagHeldByRa( flagIndex );
		else
			AK_Stockpile_GRI( WorldInfo.GRI ).SetFlagHeldByAnubis( flagIndex );

		WorldInfo.GRI.bForceNetUpdate = TRUE;
	}

	function EndState( Name NextStateName )
	{
		super.EndState( NextStateName );
	}
}

//---------------------------------------------------------------------------------
state Dropped
{
	ignores Drop;

	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );

		AK_Stockpile_GRI( WorldInfo.GRI ).SetFlagDropped( flagIndex );
		WorldInfo.GRI.bForceNetUpdate = TRUE;
	}

	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );
	}

	function SameTeamTouch( Controller C )
	{
		super.SameTeamTouch( C );
	}

	function Timer() // TODO: Look into resetting scalars on endstate too, just in case picked up mid-fade
	{
		super.Timer();
	}
}

//---------------------------------------------------------------------------------
state PlacedInZone
{
	ignores Touch, Drop;

	function BeginState( Name PreviousStateName )
	{
		if( holdingZone.DefenderTeamIndex == 0 )
			AK_Stockpile_GRI( WorldInfo.GRI ).SetFlagPlacedInRaZone( flagIndex );
		else
			AK_Stockpile_GRI( WorldInfo.GRI ).SetFlagPlacedInAnubisZone( flagIndex );

		SetFlagPropertiesToStationaryFlagState();

		SetRotation( holdingZone.Rotation );
		SetBase( holdingZone );
		SetPhysics(PHYS_None);
		inScoreZone = true;
		holdingZone.bForceNetUpdate = true;
		bForceNetUpdate = true;
	}

	function EndState( Name NextStateName )
	{
		inScoreZone = false;
	}

	function SameTeamTouch( Controller C )
	{
		//Touching the flag in this state does nothing!
	}
}




//----------------------------------------- State Changing Functions -----------------------------------------//
function PlaceFlag( AK_Stockpile_ScoreZone scoreZone, Vector locationToPlace )
{
	local PlayerController playerControl;

	playerControl = PlayerController( holder.Controller );
	if( playerControl != None )
	{
		playerControl.ReceiveLocalizedMessage( flagMessageClass, 2 ); //2 is flag placed message
	}

	ClearHolder();
	holdingZone = scoreZone;

	SetLocation( locationToPlace );

	GotoState( 'PlacedInZone' );
}

function SendHome( Controller Returner )
{
	--holdingZone.numberOfHostedFlags;
	holdingZone = None;

	super.SendHome( Returner );
}

function Drop(optional Controller Killer)
{
	//Note to self: holder variable must not be being set
	if( PlayerController( holder.Controller ) != None )
	{
		PlayerController( holder.Controller ).ReceiveLocalizedMessage( flagMessageClass, 1 ); //1 is flag dropped message
	}

	Super.Drop(Killer);
}

//This function is a direct copy of UTCTFFlag's function of the same name; we just don't need the translation.
function SetFlagPropertiesToStationaryFlagState()
{
	//SkelMesh.SetTranslation( vect(0.0,0.0,-40.0) );
	LightEnvironment.bDynamic = TRUE;
	SkelMesh.SetShadowParent( None );
	SetTimer( 5.0f, FALSE, 'SetFlagDynamicLightToNotBeDynamic' );
}


//Most of this function is copied from UTCTFFlag; we have just removed the translation set because it's bad.
function SetHolder( Controller newHolder )
{
	local UTCTFSquadAI S;
	local UTPawn UTP;
	local UTBot B;

	holdingZone = None;

	if( PlayerController( newHolder ) != None )
	{
		PlayerController( newHolder ).ReceiveLocalizedMessage( flagMessageClass, 0 ); //0 is flag taken message
	}

	// when the flag is picked up we need to set the flag translation so it doesn't stick in the ground
	//SkelMesh.SetTranslation( vect(0.0,0.0,0.0) ); //No we don't.
	UTP = UTPawn( newHolder.Pawn );
	LightEnvironment.bDynamic = TRUE;
	SkelMesh.SetShadowParent( UTP.Mesh );

	ClearTimer( 'SetFlagDynamicLightToNotBeDynamic' );

	// AI Related
	B = UTBot( newHolder );
	if ( B != None )
	{
		S = UTCTFSquadAI(B.Squad);
	}
	else if ( PlayerController( newHolder ) != None )
	{
		S = UTCTFSquadAI(UTTeamInfo(newHolder.PlayerReplicationInfo.Team).AI.FindHumanSquad());
	}

	if ( S != None )
	{
		S.EnemyFlagTakenBy(newHolder);
	}

	Super( UTCarriedObject ).SetHolder( newHolder );
	if ( B != None )
	{
		B.SetMaxDesiredSpeed();
	}
}


function bool ValidHolder( Actor Other )
{
    if ( !Super( UTCarriedObject ).ValidHolder(Other) )
	{
		return false;
	}

	if( UTPlayerReplicationInfo( Pawn( Other ).Controller.PlayerReplicationInfo ).bHasFlag )
	{
		return false;
	}

    return true;
}




DefaultProperties
{
	bAlwaysRelevant = true

	flagMessageClass = class'AK_Message_Flag'

	inScoreZone = false

	//Point light on the flag
	Begin Object name=FlagLightComponent
		Brightness=1.25
		LightColor=(R=255,G=255,B=255)
		Radius=192
		CastShadows=false
		bEnabled=true
		LightingChannels=(Dynamic=FALSE,CompositeDynamic=FALSE)
	End Object
	FlagLight=FlagLightComponent
	Components.Add(FlagLightComponent)

	//Overlay mesh used when flag is not visible
	Begin Object Class=SkeletalMeshComponent Name=OverlayMeshComponent
		bAcceptsDynamicDecals=FALSE
		CastShadow=false
		bUpdateSkelWhenNotRendered=false
		bOverrideAttachmentOwnerVisibility=true
		TickGroup=TG_PostAsyncWork
		bPerBoneMotionBlur=true
		DepthPriorityGroup = SDPG_Foreground
		Scale=1.01
	End Object
	Components.Add( OverlayMeshComponent )
	OverlayMesh = OverlayMeshComponent
}
