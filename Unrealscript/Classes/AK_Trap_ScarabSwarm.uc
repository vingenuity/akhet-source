class AK_Trap_ScarabSwarm extends Actor;

var float swarmRadius;
var float swarmHeight;
var float swarmLifetimeSeconds;

var SoundCue swarmingSoundEffect;

event PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer( swarmLifetimeSeconds, false, 'DestroySelf' );

	PlaySound( swarmingSoundEffect, true, false, true );

	WorldInfo.MyEmitterPool.SpawnEmitter(
		ParticleSystem'AK_Particle.NestSwarm',  //Spawn the swarm emitter
		self.Location, 							//at our position
		rot( 0, 0, 0 ),							//with normal rotation
		self ); 								//and attach it to us in case we move
}

function DestroySelf()
{
	Destroy();
}

simulated function Touch( Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal )
{
    if ( ( AK_Pawn( Other ) != None ) )
    {
        AK_Pawn( Other ).SwarmWithScarabs();
    }
}

DefaultProperties
{
	swarmRadius = 150.0;
	swarmHeight = 150.0;
	swarmLifetimeSeconds = 8.0;

	bCollideActors=true
	Begin Object class=CylinderComponent Name=CollisionCylinder
		Translation=(Z=75.0)
		CollisionHeight=+150
		CollisionRadius=+150
		bDrawBoundingBox=true
		bDrawNonColliding=true
		CollideActors=true
		BlockActors=false
		BlockRigidBody=false
		BlockZeroExtent=false
		BlockNonZeroExtent=true
	End Object
	CollisionComponent = CollisionCylinder
	Components.Add( CollisionCylinder )

	swarmingSoundEffect = SoundCue'AK_Weapon_Sounds.AK_Weap_Scarab.AK_Weap_ScarabSec_Cue'
}
