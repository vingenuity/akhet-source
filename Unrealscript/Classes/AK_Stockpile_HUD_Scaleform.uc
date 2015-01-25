class AK_Stockpile_HUD_Scaleform extends GFxMoviePlayer;

var float       LastHealthPercentage;
var int         LastAmmoCount;
var int         LastTeam;
var int         LastInvSize;
var int         LastSiphonTime;
var bool        LastFlagPossession;
var bool        LastFlagTeamScore;
var UTWeapon    LastWeapon;
var array<bool> LastInvWeapons;

var GFxObject rootOfHUD;
//var GFxObject HealthMC;
//var GFxObject HealthBarMC;
//var GFxObject AmmoMC;
//var GFxObject AmmoBarMC;
var GFxObject MatchTimerMC;
var GFxObject SiphonTimerBar;
var GFxObject NeutralVasesMC;
var GFxObject RaVasesMC;
var GFxObject AnubisVasesMC;
var GFxObject RaFlagHeldMC;
var GFxObject AnubisFlagHeldMC;
var GFxObject SiphonCircleArray[3];
var GFxObject AnubisUrnMCArray[3];
var GFxObject RaUrnMCArray[3];
var GFxObject NeutralUrnMCArray[3];
var GFxObject WeaponSelectionMC;
//var GFxObject WeaponAmmoIconMC;
var GFxObject WeaponHighlightMC[3];
var GFxObject DamageOverlayMC;
var GFxObject ScopeOverlayMC;
//var GFxObject TextField_AmmoCount;
//var GFxObject TextField_HealthPercentage;
var GFxObject TextField_ScoreRa;
var GFxObject TextField_ScoreAnubis;
var GFxObject TextField_TimeLeftInMatch;
//var GFxObject TextField_TimeUntilSiphon;

//---------------------------------------------- Output Formatting ------------------------------------------------//
function string FormatTimeIntoString( int timeInSeconds )
{
	//This function is a slight spin on UTHUD's FormatTime
	local string NewTimeString;
	local int minutes, seconds, SECONDS_IN_MINUTE;
	SECONDS_IN_MINUTE = 60;
	
	minutes = timeInSeconds / SECONDS_IN_MINUTE;

	seconds = timeInSeconds % SECONDS_IN_MINUTE;

	NewTimeString = "" $ ( minutes > 9 ? String( minutes ) : "0" $ String( minutes ) ) $ ":";
	NewTimeString = NewTimeString $ ( seconds > 9 ? String( seconds ) : "0"$String( seconds ) );
	return NewTimeString;
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
	local int i;

	Start();
	Advance(0.f);

	SetViewScaleMode( SM_ExactFit );

	LastSiphonTime = 0;
	LastHealthPercentage = -1337;
	LastAmmoCount = -1337;

	rootOfHUD = GetVariableObject("_root");

	//HealthMC = GetVariableObject("_root.HealthBarBG");
	//HealthBarMC = GetVariableObject("_root.HealthBar");
	//TextField_HealthPercentage = GetVariableObject("_root.HealthText");

	//AmmoMC = GetVariableObject("_root.AmmoBarBG");
	//AmmoBarMC = GetVariableObject("_root.AmmoBar");
	//TextField_AmmoCount = GetVariableObject("_root.AmmoText");

	MatchTimerMC = GetVariableObject("_root.TimeAndScoreBG");
	TextField_TimeLeftInMatch = GetVariableObject("_root.TimeText");
	
	SiphonTimerBar = GetVariableObject("_root.SiphonBar");
	//TextField_TimeUntilSiphon = GetVariableObject("_root.SiphonText");
			
	TextField_ScoreRa = GetVariableObject("_root.RaScore");
	TextField_ScoreAnubis = GetVariableObject("_root.AnubisScore");

	NeutralVasesMC = GetVariableObject("_root.NeutralUrns");
	RaVasesMC = GetVariableObject("_root.RaUrns");
	AnubisVasesMC = GetVariableObject("_root.AnubisUrns");

	RaFlagHeldMC = GetVariableObject("_root.RaFlagPossession");
	AnubisFlagHeldMC = GetVariableObject("_root.AnubisFlagPossession");

	//Flag Status Display
	RaUrnMCArray[0] = GetVariableObject("_root.RaUrnOne");
	RaUrnMCArray[1] = GetVariableObject("_root.RaUrnTwo");
	RaUrnMCArray[2] = GetVariableObject("_root.RaUrnThree");
	AnubisUrnMCArray[0] = GetVariableObject("_root.AnubisUrnOne");
	AnubisUrnMCArray[1] = GetVariableObject("_root.AnubisUrnTwo");
	AnubisUrnMCArray[2] = GetVariableObject("_root.AnubisUrnThree");
	NeutralUrnMCArray[0] = GetVariableObject("_root.NeutralUrnOne");
	NeutralUrnMCArray[1] = GetVariableObject("_root.NeutralUrnTwo");
	NeutralUrnMCArray[2] = GetVariableObject("_root.NeutralUrnThree");
	SiphonCircleArray[0] = GetVariableObject("_root.SiphonIconOne");
	SiphonCircleArray[1] = GetVariableObject("_root.SiphonIconTwo");
	SiphonCircleArray[2] = GetVariableObject("_root.SiphonIconThree");

	for( i = 0; i < 3; ++i )
	{
		NeutralUrnMCArray[i].SetVisible(false);
		RaUrnMCArray[i].SetVisible(false);
		AnubisUrnMCArray[i].SetVisible(false);
		SiphonCircleArray[i].SetVisible(false);
	}

	//Weapon Inventory Display
	WeaponSelectionMC = GetVariableObject("_root.CurrentWeaponSelection");
	//WeaponAmmoIconMC = GetVariableObject("_root.AmmoIcons");
	WeaponHighlightMC[0] = GetVariableObject("_root.SMGFILL");
	WeaponHighlightMC[1] = GetVariableObject("_root.ScarabFill");
	WeaponHighlightMC[2] = GetVariableObject("_root.BattleStaffFill");

	DamageOverlayMC = GetVariableObject("_root.DamageOverlay");
	ScopeOverlayMC = GetVariableObject("_root.ScopeView");
}

function TickHUD()
{
	local AK_Pawn AkhetPawn;
	local AK_Stockpile_GRI AkhetGRI;
	local AK_PlayerReplicationInfo AkhetPRI;

	AkhetPawn = AK_Pawn( GetPC().Pawn );
	if( AkhetPawn == None)
	{
		rootOfHUD.SetVisible( false );
		return;
	}

	AkhetGRI  = AK_Stockpile_GRI( GetPC().WorldInfo.GRI );
	if( AkhetGRI == None )
	{
		rootOfHUD.SetVisible( false );
		return;
	}

	AkhetPRI = AK_PlayerReplicationInfo( AkhetPawn.GetUTPlayerReplicationInfo() );
	rootOfHUD.SetVisible( true );

	SetHUDPanelColorToTeamColor( AkhetPawn );

	UpdateFlagStatuses( akhetGRI );
	if( LastFlagPossession != AkhetPRI.bHasFlag )
	{
		DisplayFlagHeldIcon( AkhetPRI );
	}

	ShadeInAvailableWeapons();
	HighlightCurrentlySelectedWeaponAndAmmo( AkhetPawn );
	ShowScopeZoom( LastWeapon );


	UpdateHealthBarsAndText( AkhetPawn );
	//UpdateAmmoBarsAndText( AkhetPawn );
	UpdateSiphonBar( AkhetGRI );
		
	TextField_ScoreRa.SetString("text", string( int( AkhetGRI.Teams[0].Score ) ) );
	TextField_ScoreAnubis.SetString("text", string( int( AkhetGRI.Teams[1].Score ) ) );	

	TextField_TimeLeftInMatch.SetString("text", FormatTimeIntoString( AkhetGRI.RemainingTime ) );
	//TextField_TimeUntilSiphon.SetString("text", FormatTimeIntoString( AkhetGRI.timeLeftUntilScoringSeconds ) );

	
}



//------------------------------------------------ General HUD --------------------------------------------------//
function SetHUDPanelColorToTeamColor( AK_Pawn AkhetPawn )
{
	if( LastTeam != AkhetPawn.GetTeamNum() )
	{
		LastTeam = AkhetPawn.GetTeamNum();
		//AmmoMC.GotoAndStopI( LastTeam + 1 );
		//HealthMC.GotoAndStopI( LastTeam + 1 );
		MatchTimerMC.GotoAndStopI( LastTeam + 1 );
	}
}

function UpdateAmmoBarsAndText( AK_Pawn AkhetPawn )
{
	local UTWeapon ourWeapon;

	ourWeapon = UTWeapon(AkhetPawn.Weapon);
	if( ourWeapon == None )
		LastAmmoCount = 0;

	else if (LastAmmoCount != ourWeapon.AmmoCount)
		LastAmmoCount = ourWeapon.AmmoCount;

	//AmmoBarMC.GotoAndStopI( (LastAmmoCount > 10) ? 10 : LastAmmoCount );
	//TextField_AmmoCount.SetString( "text", string( LastAmmoCount ) );
}

function UpdateHealthBarsAndText( AK_Pawn AkhetPawn )
{
	local float currentHealthPercentage;

	currentHealthPercentage = CalculatePercentOfMaximumValue( AkhetPawn.Health, AkhetPawn.HealthMax );
	if ( LastHealthPercentage != currentHealthPercentage )
	{
		LastHealthPercentage = currentHealthPercentage;

		//HealthBarMC.GotoAndStopI( AkhetPawn.HealthMax - LastHealthPercentage );

		//TextField_HealthPercentage.SetString("text", round( LastHealthPercentage )$"");

		DamageOverlayMC.GotoAndStopI(AkhetPawn.HealthMax - LastHealthPercentage);
	}
}

function UpdateSiphonBar( AK_Stockpile_GRI AkhetGRI )
{
	SiphonTimerBar.GotoAndStopI( AkhetGRI.timeBetweenFlagScoresSeconds - AkhetGRI.timeLeftUntilScoringSeconds );
}

//------------------------------------------------ Flag Related --------------------------------------------------//
function DisplayFlagHeldIcon( AK_PlayerReplicationInfo AkhetPRI )
{

	LastFlagPossession = AkhetPRI.bHasFlag;

	if( LastTeam == 0 )
	{
		RaFlagHeldMC.GotoAndStopI( int(LastFlagPossession) + 1 );
	
	}
	else
	{
		AnubisFlagHeldMC.GotoAndStopI( int(LastFlagPossession) + 1 );

	}
}

function UpdateFlagStatuses( AK_Stockpile_GRI AkhetGRI )
{
	//local int numberofFlagsInBase;
	local int i;

	//Two edges that represent placed flags
	//numberofFlagsInBase = AkhetGRI.CalculateNumberOfFlagsInRaZone() + 1; // starts index at 1 because stupid 
	//RaVasesMC.GotoAndStopI(numberofFlagsInBase);

	//numberofFlagsInBase = AkhetGRI.CalculateNumberOfFlagsInAnubisZone() + 1; // starts index at one because stupid
	//AnubisVasesMC.GotoAndStopI(numberofFlagsInBase);


	//Center set showing flags in play
	for( i = 0; i < 3;  ++i )
	{
		if(AkhetGRI.IsFlagHeldByRa(i))
		{
			RaUrnMCArray[i].SetVisible(true);
			AnubisUrnMCArray[i].SetVisible(false);	
			NeutralUrnMCArray[i].SetVisible(false);
			SiphonCircleArray[i].SetVisible(false);
		}
		else if(AkhetGRI.IsFlagHeldByAnubis(i))
		{
			RaUrnMCArray[i].SetVisible(false);
			AnubisUrnMCArray[i].SetVisible(true);
			NeutralUrnMCArray[i].SetVisible(false);
			SiphonCircleArray[i].SetVisible(false);
		}
		else if(AkhetGRI.IsFlagPlacedInRaZone( i ))
		{
			SiphonCircleArray[i].SetVisible(true);
			SiphonCircleArray[i].GotoAndStopI( 1 );
		}
		else if(AkhetGRI.IsFlagPlacedInAnubisZone( i ))
		{
			SiphonCircleArray[i].SetVisible(true);
			SiphonCircleArray[i].GotoAndStopI( 2 );
		}
		else if(AkhetGRI.IsFlagAtSpawn(i) || AkhetGRI.IsFlagDropped(i))
		{
			NeutralUrnMCArray[i].SetVisible(true);
			SiphonCircleArray[i].SetVisible(false);
		}
		else
		{
			RaUrnMCArray[i].SetVisible(false);
			AnubisUrnMCArray[i].SetVisible(false);
			NeutralUrnMCArray[i].SetVisible(false);
			SiphonCircleArray[i].SetVisible(false);
		}
	}
}



//----------------------------------------------- Weapon Display -------------------------------------------------//
function HighlightCurrentlySelectedWeaponAndAmmo( AK_Pawn AkhetPawn )
{
	local UTWeapon Weapon;

	Weapon = UTWeapon( AkhetPawn.Weapon );
	if( LastWeapon != Weapon )
	{
		LastWeapon = Weapon;
		WeaponSelectionMC.GotoAndStopI( LastWeapon.InventoryGroup );
		//WeaponAmmoIconMC.GotoAndStopI( LastWeapon.InventoryGroup );
	}
}

function ShadeInAvailableWeapons()
{
	local int i;
	local array<UTWeapon> WeaponList;
	local UTInventoryManager invManager;

	invManager = UTInventoryManager( GetPC().Pawn.InvManager );
	if( invManager == None )
		return;

	for( i = 0; i < 3; ++i )
	{
		weaponHighlightMC[ i ].SetVisible( false );
	}

	invManager.GetWeaponList( WeaponList );
	for( i = 0; i < WeaponList.Length; ++i )
	{
		if( WeaponList[ i ].InventoryGroup < 2 || WeaponList[ i ].InventoryGroup > 4 )
			continue;
		//The weapon group number will be two above the zero-indexed weapon highlight
		//(guns are 2, 3 and 4; indices are 0, 1, 2)
		weaponHighlightMC[ WeaponList[i].InventoryGroup - 2 ].SetVisible( true );
	}
}

function ShowScopeZoom( UTWeapon TempWeapon )
{
	if( TempWeapon == None )
	{
		ScopeOverlayMC.GotoAndStopI( 1 );
	}
	else if( TempWeapon.GetZoomedState() == ZST_Zoomed )
	{
		ScopeOverlayMC.GotoAndStopI( 2 );
	}
	else
	{
		ScopeOverlayMC.GotoAndStopI( 1 );
	}
}

DefaultProperties
{
	bDisplayWithHudoff = false
	MovieInfo = SwfMovie'AK_hud.AK_hud'

	//Initialize state of inventory weapons at start to prevent log warnings.
	LastInvWeapons = ( false, false, false, false, false )
}
