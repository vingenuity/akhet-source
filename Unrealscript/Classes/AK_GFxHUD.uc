class AK_GFxHUD extends GFxMoviePlayer;

var float LastHealthPercentage;
var int   LastAmmoCount;

var GFxObject HealthMC;
var GFxObject HealthBarMC;
var GFxObject AmmoMC;
var GFxObject AmmoBarMC;
var GFxObject MatchTimerMC;
var GFxObject SiphonTimerBar;
var GFxObject TextField_AmmoCount;
var GFxObject TextField_HealthPercentage;
var GFxObject TextField_ScoreRa;
var GFxObject TextField_ScoreAnubis;
var GFxObject TextField_TimeLeftInMatch;
var GFxObject TextField_TimeUntilSiphon;

//---------------------------------------------- Output Formatting ------------------------------------------------//
function string FormatTimeIntoString( int timeInSeconds )
{
	local string minutesString, secondsString;
	local int secondsLeftInThisMinute, SECONDS_IN_MINUTE;
	SECONDS_IN_MINUTE = 60;
	
	minutesString = string( timeInSeconds / SECONDS_IN_MINUTE );

	secondsLeftInThisMinute = timeInSeconds % SECONDS_IN_MINUTE;
	secondsString = string( secondsLeftInThisMinute );

	if( ( secondsLeftInThisMinute % 10 == 0 ) && ( secondsLeftInThisMinute != 0 ) )
		secondsString $= "0";
	if( secondsLeftInThisMinute < 10 )
		secondsString = "0" $ secondsString;

	return minutesString $ ":" $ secondsString;
}

function int CalculatePercentOfMaximumValue( int val, int max )
{
	return Round( (float( val ) / float( max ) ) * 100.0f);
}



//---------------------------------------------- Lifetime Functions ------------------------------------------------//
function bool Start( optional bool StartPaused = false )
{
	super.Start();
	return true;
}

function Init( optional LocalPlayer playerController )
{
	Start();
	Advance(0.f);

	LastHealthPercentage = -1337;
	LastAmmoCount = -1337;

	HealthMC = GetVariableObject("_root.HealthAndAmmoBG");
	HealthBarMC = GetVariableObject("_root.HealthBar");
	TextField_HealthPercentage = GetVariableObject("_root.HealthText");

	AmmoMC = GetVariableObject("_root.HealthAndAmmoBG");
	AmmoBarMC = GetVariableObject("_root.AmmoBar");
	TextField_AmmoCount = GetVariableObject("_root.AmmoText");

	MatchTimerMC = GetVariableObject("_root.TimeAndScoreBG");
	TextField_TimeLeftInMatch = GetVariableObject("_root.TimeText");
	
	SiphonTimerBar = GetVariableObject("_root.SiphonBar");
	TextField_TimeUntilSiphon = GetVariableObject("_root.SiphonText");
			
	TextField_ScoreRa = GetVariableObject("_root.RaScore");
	TextField_ScoreAnubis = GetVariableObject("_root.AnubisScore");
}

function TickHUD()
{
	local AK_Pawn AkhetPawn;
	local AK_GameReplicationInfo AkhetGRI;
	local float currentHealthPercentage;

	AkhetPawn = AK_Pawn( GetPC().Pawn );
	AkhetGRI  = AK_GameReplicationInfo( GetPC().WorldInfo.GRI );
	
	if( AkhetPawn == None || AkhetGRI == None )
	{
		//`log( "CANNOT FIND DATA FROM PLAYER FOR HUD!" );
		return;
	}

	currentHealthPercentage = CalculatePercentOfMaximumValue( AkhetPawn.Health, AkhetPawn.HealthMax );
	if ( LastHealthPercentage != currentHealthPercentage )
	{
		LastHealthPercentage = currentHealthPercentage;

		HealthBarMC.SetFloat("_xscale", ( LastHealthPercentage > 100) ? 100.0f : LastHealthPercentage );

		TextField_HealthPercentage.SetString("text", round( LastHealthPercentage )$"");
	}

	if (LastAmmoCount != UTWeapon(AkhetPawn.Weapon).AmmoCount)
	{
		LastAmmoCount = UTWeapon(AkhetPawn.Weapon).AmmoCount;

		AmmoBarMC.GotoAndStopI( (LastAmmoCount > 10) ? 10 : LastAmmoCount );

		TextField_AmmoCount.SetString( "text", string( LastAmmoCount ) );
	}
		
	 TextField_ScoreRa.SetString("text", string( int( AkhetGRI.Teams[0].Score ) ) );
	 TextField_ScoreAnubis.SetString("text", string( int( AkhetGRI.Teams[1].Score ) ) );	

	 TextField_TimeLeftInMatch.SetString("text", FormatTimeIntoString( AkhetGRI.RemainingTime ) );
	 TextField_TimeUntilSiphon.SetString("text", FormatTimeIntoString( AkhetGRI.timeLeftUntilScoringSeconds ) );
}

DefaultProperties
{
	bDisplayWithHudoff = false
	MovieInfo= SwfMovie'AK_hud.AK_hud'
}
