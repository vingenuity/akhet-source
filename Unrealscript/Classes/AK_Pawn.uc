class AK_Pawn extends UTPawn;

var float timeSinceSwarmHitSeconds;
var float swarmLifetimeSeconds;
var float swarmDamagePerSecond;
var float secondsBetweenSwarmDamage;

var int maxHealthRegenerationPerSecond;
var int secondsAfterHitToStartRegenerating;
var SoundCue RegenerationBeginSound;
var SoundCue OngoingRegenerationSound;
var AudioComponent RegenerationSoundComponent;

simulated event PostBeginPlay()
{
	RegenerationSoundComponent = CreateAudioComponent( OngoingRegenerationSound, false, true );
	super.PostBeginPlay();
}

//-------------------------------------------- Health Regeneration ----------------------------------------------//
function BeginHealthRegeneration()
{
	SetTimer( 1, true, 'RegenerateHealth' );
	if ( RegenerationBeginSound != None )
	{
		PlaySound( RegenerationBeginSound );
		//RegenerationSoundComponent.FadeIn( 0.1f, 1.0f );
		RegenerationSoundComponent.Play();
	}
}

function EndHealthRegeneration()
{
	SetTimer( 0, false, 'RegenerateHealth' );
	//RegenerationSoundComponent.FadeOut( 0.1f, 0.0f );
	RegenerationSoundComponent.Stop();
}

function RegenerateHealth()
{
	//Use Cubic relationship to regenerate health
	local int regenerationRateThisSecond;
	local float ratioOfHealthToMax;

	ratioOfHealthToMax = float( Health ) / float( HealthMax );
	ratioOfHealthToMax = ratioOfHealthToMax * ratioOfHealthToMax * ratioOfHealthToMax;
	regenerationRateThisSecond = FMax( maxHealthRegenerationPerSecond * ( 1.0 - ratioOfHealthToMax ), 1.0 );
	
	Health += regenerationRateThisSecond;

	if ( Health >= HealthMax )
	{
		EndHealthRegeneration();
	}
}


//---------------------------------------------- General Damage ------------------------------------------------//
event TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );

	//Stop health regeneration and restart the timer until we begin regeneration
	EndHealthRegeneration();
	SetTimer( secondsAfterHitToStartRegenerating, false, 'BeginHealthRegeneration' );
}

simulated function TakeFallingDamage()
{
	//Do nothing. Fall infinitely with no consequences!
}

function AdjustDamage(out int InDamage, out vector Momentum, Controller InstigatedBy, vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
	local name nameOfClosestBoneToImpact;
	local class< AK_DamageType_Base > akhetDamageBaseClass;


	akhetDamageBaseClass = class< AK_DamageType_Base >( DamageType );
	if( akhetDamageBaseClass == None )
		return;

	//If we are closest to the head, it's a headshot
	nameOfClosestBoneToImpact = Mesh.FindClosestBone( HitLocation );
	if( nameOfClosestBoneToImpact == 'b_head')
	{
		InDamage *= akhetDamageBaseClass.static.GetHeadshotDamageMultiplier();
		//`log( "HEADSHOT!!! Total Damage: " $ string( InDamage ) );
	}
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	EndHealthRegeneration();
	return super.Died( Killer, DamageType, HitLocation );
}




//--------------------------------------------- Damage Over Time -----------------------------------------------//
simulated function SwarmWithScarabs()
{
	SetTimer( secondsBetweenSwarmDamage, true, 'SwarmDamageOverTime' );
	timeSinceSwarmHitSeconds = 0;

	WorldInfo.MyEmitterPool.SpawnEmitter(
		ParticleSystem'AK_Particle.PawnSwarm',  //Spawn the swarm emitter
		self.Location, 							//at our position
		rot( 0, 0, 0 ),							//with normal rotation
		self ); 								//and attach it to us in case we move
}

function SwarmDamageOverTime()
{
	local float damageThisTick;
	local Controller damageInstigator;
	local vector momentumFromHit;

	damageThisTick = swarmDamagePerSecond * secondsBetweenSwarmDamage;
	damageInstigator = None; //This ideally should come from the original shooter.
	momentumFromHit = vect( 0, 0, 0 ); //Bugs are too small to give momentum!
	TakeDamage( damageThisTick, damageInstigator, self.location, momentumFromHit, class 'UTDmgType_Burning' );

	timeSinceSwarmHitSeconds += secondsBetweenSwarmDamage;
	if( timeSinceSwarmHitSeconds >= swarmLifetimeSeconds )
		ClearTimer( 'SwarmDamageOverTime' );
}





//------------------------------------------------ Movement --------------------------------------------------//
function bool PerformDodge(eDoubleClickDir DoubleClickMove, vector Dir, vector Cross)
{
	return true;
}





//--------------------------------------------- Team Appearance -----------------------------------------------//
simulated function class<UTFamilyInfo> GetFamilyInfo()
{
	local UTPlayerReplicationInfo UTPRI;
	UTPRI = GetUTPlayerReplicationInfo();

	//If we don't have player replication info, pick the default class.
	if (UTPRI == None)
	{
		return CurrCharClassInfo;
	}

	//Otherwise set our replication info based upon the team and player number
	if( UTPRI.Team.GetTeamNum() == 0 ) //Ra's Team
	{
		if( UTPRI.PlayerID % 2 == 0 ) //Player's ID is even
			return class'AKHET.AK_FamilyInfo_Ra_Officer';
		else
			return class'AKHET.AK_FamilyInfo_Ra_Soldier';
	}

	else if( UTPRI.Team.GetTeamNum() == 1 ) //Anubis's Team
	{
		if( UTPRI.PlayerID % 2 == 0 ) //Player's ID is even
			return class'AKHET.AK_FamilyInfo_Anubis_Officer';
		else
			return class'AKHET.AK_FamilyInfo_Anubis_Soldier';
	}

	else //Unknown team?
	{
		return CurrCharClassInfo;
	}
}

//This sets the appearance of the first person arms. We don't have them, so we do nothing.
simulated function SetFirstPersonArmsInfo(SkeletalMesh FirstPersonArmMesh, MaterialInterface ArmMaterial)
{
}

Defaultproperties
{
	SoundGroupClass=class'AKHET.AK_PawnSoundGroup'

	SpawnSound = SoundCue'AK_Player_Sounds.AK_Plyr_Response.AK_Plyr_Arise_Cue'
	FallImpactSound = SoundCue'AK_AmbNoise.Silence_Cue'

	secondsBetweenSwarmDamage = 0.5;
	swarmLifetimeSeconds = 5;
	swarmDamagePerSecond = 3;

	maxHealthRegenerationPerSecond = 5
	secondsAfterHitToStartRegenerating = 5
	RegenerationBeginSound = SoundCue'AK_AmbNoise.Silence_Cue'
	OngoingRegenerationSound = SoundCue'AK_AmbNoise.Silence_Cue'
}
