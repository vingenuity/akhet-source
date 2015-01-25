class AK_ViewportClient extends UTGameViewportClient
	config(Game);

function DrawTransition( Canvas Canvas )
{
	// if we are doing a loading transition, don't draw anything!
	if (Outer.TransitionType == TT_Loading)
	{
		return;
	}
	else
	{
		Super.DrawTransition( canvas );
	}
}
DefaultProperties
{
	HintLocFileName="UTGameUI"
	UIControllerClass=class'UTGame.UTGameInteraction'
	LoadingScreenMapNameFont=MultiFont'UI_Fonts_Final.Menus.Fonts_AmbexHeavyOblique'
	LoadingScreenGameTypeNameFont=MultiFont'UI_Fonts_Final.Menus.Fonts_AmbexHeavyOblique'
	LoadingScreenHintMessageFont=MultiFont'UI_Fonts_Final.HUD.MF_Medium'
}
