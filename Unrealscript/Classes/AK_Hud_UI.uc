class AK_Hud_UI extends UTHUD;

var AK_GFxHUD HudMovie;

 singular event Destroyed()
 {
 	if(HudMovie != none)
 	{  
 		HudMovie.Close(true);
 		HudMovie = none;
 	}
 }

 simulated function PostBeginPlay()
 {
 	super.PostBeginPlay();

 	HudMovie = new class'AK_GfxHUD';

 	HudMovie.SetTimingMode(TM_Real);

 	HudMovie.Init(LocalPlayer(PlayerOwner.Player));
 }

 event PostRender()
 {
	local AK_Pawn AkhetPawn;

 	//super.PostRender();
	HudMovie.TickHUD();


	AkhetPawn = AK_Pawn( PlayerController( Owner ).Pawn );
	if( AkhetPawn != None )
	{
		UTWeapon( AkhetPawn.Weapon ).ActiveRenderOverlays( self );
	}
 }

/*UT's function for displaying the red damage corona. We don't want it.*/
function DisplayHit(vector HitDir, int Damage, class<DamageType> damageType)
{
}

DefaultProperties 
{
	//bNoCrosshair = true
	bCrosshairShow = true
}