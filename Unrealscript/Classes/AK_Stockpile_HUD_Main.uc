class AK_Stockpile_HUD_Main extends UTHUD;

var AK_Stockpile_HUD_Scaleform HudMovie;
var AK_PauseMenu PauseMenu;

var AK_Stockpile_Flag flagSet[3];
var bool flagSetBuilt;

var Texture flagOverlayTexture;
var Vector2D flagOverlayTextureSize;
var float flagOverlayHiddenDistance;
var float flagOverlayStartFadeDistance;



//------------------------------------------ Canvas Helper Functions -----------------------------------------//
 function DrawTextCenteredAt( string text, float xPosition, float yPosition, float xScale, float yScale )
 {
 	local float textWidth, textHeight;

	Canvas.TextSize( text, textWidth, textHeight );
	Canvas.SetPos( xPosition - ( ( textWidth * xScale ) / 2 ), yPosition - ( ( textHeight * yScale ) / 2 ) );
	Canvas.DrawText( text, true, xScale, yScale );
 }




//-------------------------------------------- Lifecycle Functions -------------------------------------------//
 simulated function PostBeginPlay()
 {
 	super.PostBeginPlay();

 	HudMovie = new class'AK_Stockpile_HUD_Scaleform';

 	HudMovie.SetTimingMode(TM_Real);

 	HudMovie.Init(LocalPlayer(PlayerOwner.Player));
 }

 event PostRender()
 {
 	//super.PostRender();
	HudMovie.TickHUD();

	DisplayLocalMessages();

	ShowWeaponCrosshairUsingCanvas();
	DrawFlagIconAboveFlags();

	//These pieces needed in order for the damage corona to work correctly.
	RenderDelta = WorldInfo.TimeSeconds - LastHUDRenderTime;
	LastHUDRenderTime = WorldInfo.TimeSeconds;
	UpdateDamage();
	DisplayDamage();
 }

 singular event Destroyed()
 {
 	if(HudMovie != none)
 	{  
 		HudMovie.Close(true);
 		HudMovie = none;
 	}
 }

//-------------------------------------------- Display Functions -------------------------------------------//
//This function is directly copied from the superclass, except for a change in the message type used (so we can customize it)
function DisplayHit(vector HitDir, int Damage, class<DamageType> damageType)
{
	local Vector Loc;
	local Rotator Rot;
	local float DirOfHit_L;
	local vector AxisX, AxisY, AxisZ;
	local vector ShotDirection;
	local bool bIsInFront;
	local vector2D	AngularDist;
	local float PositionInQuadrant;
	local float Multiplier;
	local float DamageIntensity;
	local class<UTDamageType> UTDamage;
	local Pawn P;

	if ( (PawnOwner != None) && (PawnOwner.Health > 0) )
	{
		DamageIntensity = PawnOwner.InGodMode() ? 0.5 : (float(Damage)/100.0 + float(Damage)/float(PawnOwner.Health));
	}
	else
	{
		DamageIntensity = FMax(0.2, 0.02*float(Damage));
	}
	UTDamage = class<UTDamageType>(DamageType);

	if ( UTDamage != None && UTDamage.default.bLocationalHit )
	{
		// Figure out the directional based on the victims current view
		PlayerOwner.GetPlayerViewPoint(Loc, Rot);
		GetAxes(Rot, AxisX, AxisY, AxisZ);

		ShotDirection = Normal(HitDir - Loc);
		bIsInFront = GetAngularDistance( AngularDist, ShotDirection, AxisX, AxisY, AxisZ);
		GetAngularDegreesFromRadians(AngularDist);

		Multiplier = 0.26f / 90.f;
		PositionInQuadrant = Abs(AngularDist.X) * Multiplier;

		// 0 - .25  UpperRight
		// .25 - .50 LowerRight
		// .50 - .75 LowerLeft
		// .75 - 1 UpperLeft
		if( bIsInFront )
		{
			DirOfHit_L = (AngularDist.X > 0) ? PositionInQuadrant : -1*PositionInQuadrant;
		}
		else
		{
			DirOfHit_L = (AngularDist.X > 0) ? 0.52+PositionInQuadrant : 0.52-PositionInQuadrant;
		}

		// Cause a damage indicator to appear
		DirOfHit_L = -1 * DirOfHit_L;
		FlashDamage(DirOfHit_L);
	}
	else
	{
		FlashDamage(0.1);
		FlashDamage(0.9);
	}

	// If the owner on the hoverboard, check against the owner health rather than vehicle health
	if (UTVehicle_Hoverboard(PawnOwner) != None)
	{
		P = UTVehicle_Hoverboard(PawnOwner).Driver;
	}
	else
	{
		P = PawnOwner;
	}

	if (DamageIntensity > 0 && HitEffect != None)
	{
		DamageIntensity = FClamp(DamageIntensity, 0.2, 1.0);
		if ( (P == None) || (P.Health <= 0) )
		{
			// long effect duration if killed by this damage
			HitEffectFadeTime = PlayerOwner.MinRespawnDelay * 2.0;
		}
		else
		{
			HitEffectFadeTime = default.HitEffectFadeTime * DamageIntensity;
		}
		HitEffectIntensity = default.HitEffectIntensity * DamageIntensity;
		//MaxHitEffectColor = (UTDamage != None && UTDamage.default.bOverrideHitEffectColor) ? UTDamage.default.HitEffectColor : default.MaxHitEffectColor;
		if( PlayerOwner.Pawn.GetTeamNum() == 0 )
		{
			MaxHitEffectColor = MakeLinearColor( 1.0, 0.54, 0.0, 1.0 );
		}
		else if( PlayerOwner.Pawn.GetTeamNum() == 1 )
		{
			MaxHitEffectColor = MakeLinearColor( 0.37, 0.0, 0.81, 1.0 );
		}

		HitEffectMaterialInstance.SetScalarParameterValue('HitAmount', HitEffectIntensity);
		HitEffectMaterialInstance.SetVectorParameterValue('HitColor', MaxHitEffectColor);
		HitEffect.bShowInGame = true;
		bFadeOutHitEffect = true;
	}
}

 function ShowWeaponCrosshairUsingCanvas()
 {
	local AK_Pawn AkhetPawn;
	local UTWeapon pawnWeapon;

 	AkhetPawn = AK_Pawn( PlayerController( Owner ).Pawn );
	if( AkhetPawn != None )
	{
		pawnWeapon = UTWeapon( AkhetPawn.Weapon );
		if( pawnWeapon != None )
			pawnWeapon.ActiveRenderOverlays( self );
	}
 }

 function Color CalculateFlagOverlayColor( AK_Stockpile_GRI gri, int flagIndex, float distanceToFlag )
 {
 	local Color flagOverlayColor;
 	local float alphaPercentage;

 	//Set RGB from state
	if( gri.IsFlagAtSpawn( flagIndex ) )
	{
		flagOverlayColor.r = 57;
		flagOverlayColor.g = 193;
		flagOverlayColor.b = 189;
	}
	else if( gri.IsFlagHeldByAnubis( flagIndex ) || gri.IsFlagPlacedInAnubisZone( flagIndex ) )
	{
		flagOverlayColor.r = 128;
		flagOverlayColor.g = 33;
		flagOverlayColor.b = 171;
	}
	else if( gri.IsFlagHeldByRa( flagIndex ) || gri.IsFlagPlacedInRaZone( flagIndex ) )
	{
		flagOverlayColor.r = 225;
		flagOverlayColor.g = 188;
		flagOverlayColor.b = 60;
	}
	else
	{
		flagOverlayColor.r = 255;
		flagOverlayColor.g = 255;
		flagOverlayColor.b = 255;
	}

	//Set Alpha from distance
	alphaPercentage = 1.0 - FClamp( ( flagOverlayStartFadeDistance - distanceToFlag ) / (flagOverlayStartFadeDistance - flagOverlayHiddenDistance ), 0.0, 1.0 );
	flagOverlayColor.A = 255 * alphaPercentage;

	return flagOverlayColor;
 }

 function DrawFlagIconAboveFlags()
 {
 	local AK_Stockpile_Flag flag;
 	local int i;
 	local float distanceFromPlayerToFlag;
 	local vector screenPos;
 	local vector directionFromPlayerToFlag, cameraViewDirection;
 	local vector cameraLocation;
 	local Rotator cameraRotation;
	local AK_Pawn AkhetPawn;

 	AkhetPawn = AK_Pawn( PlayerController( Owner ).Pawn );

 	if( AkhetPawn == None )
 		return;

 	if( !flagSetBuilt )
 	{
	 	foreach AllActors( class'AK_Stockpile_Flag', flag ) 
		{
			flagSet[ flag.FlagIndex ] = flag;
		}
	}


	PlayerOwner.GetPlayerViewPoint(CameraLocation, CameraRotation);
	cameraViewDirection = Vector( cameraRotation );
	for( i = 0; i < 3; ++i )
	{
		directionFromPlayerToFlag = Normal( flagSet[ i ].Location - PlayerOwner.Pawn.Location );
		distanceFromPlayerToFlag = vsize( flagSet[ i ].Location - PlayerOwner.Pawn.Location );

        // Check if the pawn is in front of me
        if ( directionFromPlayerToFlag dot cameraViewDirection >= 0.f )
        {
        	Canvas.DrawColor = CalculateFlagOverlayColor( AK_Stockpile_GRI( WorldInfo.GRI ), i, distanceFromPlayerToFlag );
			
			screenPos = Canvas.Project( flagSet[ i ].Location );
			Canvas.SetPos( ScreenPos.X - 20, ScreenPos.Y - 15 );
			Canvas.DrawTile( flagOverlayTexture, 40, 40, 0, 0, flagOverlayTextureSize.X, flagOverlayTextureSize.Y );
		}
	}
 }

 exec function SetShowScores(bool bEnableShowScores)
{
	// keep empty to disable the ability to see the score screen.
}

exec function ShowMenu()
{
	// if using GFx HUD, use GFx pause menu
	TogglePauseMenu();
}

function TogglePauseMenu()
{
	if(PauseMenu != none && PauseMenu.bMovieIsOpen)
	{
		PlayerOwner.SetPause(false);
		PauseMenu.Close(false);
		PauseMenu.PlayCloseAnimation();
		SetVisible(true);
	}
	else
	{
		PlayerOwner.SetPause(true);

		if(PauseMenu == none)
		{
			PauseMenu = new class'AK_PauseMenu';
			PauseMenu.MovieInfo = SwfMovie'AK_PauseMenu.AK_PauseMenu'; // Replace 'UDKHud.udk_pausemenu' with a reference to your own pause menu swf asset
			PauseMenu.bEnableGammaCorrection = False;
			PauseMenu.LocalPlayerOwnerIndex = class'Engine'.static.GetEngine().GamePlayers.Find(LocalPlayer(PlayerOwner.Player));
			PauseMenu.SetTimingMode(TM_Real);
		}

		SetVisible(false);
		PauseMenu.Start();
		PauseMenu.Advance(0);
		PauseMenu.AddFocusIgnoreKey('Escape');

	}
}


DefaultProperties 
{
	//bNoCrosshair = true
	HudFonts(0)=Font'AK_hud.Font.Arabolic_Tiny'
	HudFonts(1)=Font'AK_hud.Font.Arabolic_Small'
	HudFonts(2)=Font'AK_hud.Font.Arabolic_Medium'
	HudFonts(3)=Font'AK_hud.Font.Arabolic_Large'
	bShowScores = false
	bCrosshairShow = true

	flagOverlayTexture = Texture2D'AK_hud.AK_Vase_Icon'
	flagOverlayTextureSize = ( X=128, Y=128 )
	flagOverlayHiddenDistance = 1000.0
	flagOverlayStartFadeDistance = 1100.0
}