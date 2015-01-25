/** This is an exact copy of UTVoice_Robot, except with all sounds replaced with silence, unless we want otherwise. */
class AK_Voice_Servant extends UTVoice
	abstract;

static function bool SendLocationUpdate(Controller Sender, PlayerReplicationInfo Recipient, Name Messagetype, UTGame G, Pawn StatusPawn, optional bool bDontSendMidfield)
{
	return false;
}

defaultproperties
{
	LocationSpeechOffset=3

	AckSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'
	AckSounds(1) = SoundNodeWave'AK_AmbNoise.Silence'

	FriendlyFireSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'
	FriendlyFireSounds(1) = SoundNodeWave'AK_AmbNoise.Silence'

	NeedOurFlagSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'

	GotYourBackSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'
	GotYourBackSounds(1) = SoundNodeWave'AK_AmbNoise.Silence'
	GotYourBackSounds(2) = SoundNodeWave'AK_AmbNoise.Silence'

	SniperSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'

	InPositionSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'

	IncomingSound = SoundNodeWave'AK_AmbNoise.Silence'
	EnemyFlagCarrierSound = SoundNodeWave'AK_AmbNoise.Silence'
	MidFieldSound = SoundNodeWave'AK_AmbNoise.Silence'

	EnemyFlagCarrierHereSound = SoundNodeWave'AK_AmbNoise.Silence'
	EnemyFlagCarrierHighSound = SoundNodeWave'AK_AmbNoise.Silence'
	EnemyFlagCarrierLowSound = SoundNodeWave'AK_AmbNoise.Silence'

	HaveFlagSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'

	AreaSecureSounds(0) = SoundNodeWave'AK_AmbNoise.Silence'

	GotOurFlagSound = SoundNodeWave'AK_AmbNoise.Silence'
}