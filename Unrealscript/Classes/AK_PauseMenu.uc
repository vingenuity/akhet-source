class AK_PauseMenu extends UTGFxTweenableMoviePlayer;

var GFxObject RootMC, PauseMC, OverlayMC, Btn_Resume_Wrapper, Btn_Exit_Wrapper;
var GFxClikWidget Btn_ResumeMC, Btn_ExitMC;

// Localized strings to use as button labels
var localized string ResumeString, ExitString;

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0);

	RootMC = GetVariableObject("_root");
   // PauseMC = RootMC.GetObject("pausemenu");    

	Btn_Resume_Wrapper = RootMC.GetObject("resume_button");
	Btn_Exit_Wrapper = RootMC.GetObject("exit_button");

    //Btn_ResumeMC = GFxClikWidget(Btn_Resume_Wrapper.GetObject("btn", class'GFxClikWidget'));
	PlayOpenAnimation();
    //Btn_ExitMC = GFxClikWidget(Btn_Exit_Wrapper.GetObject("btn", class'GFxClikWidget'));

	Btn_ExitMC.SetString("label", ExitString);
	Btn_ResumeMC.SetString("label", ResumeString);

	//Btn_ExitMC.AddEventListener('CLIK_press', OnPressExitButton);
	//Btn_ResumeMC.AddEventListener('CLIK_press', OnPressResumeButton);

	//AddCaptureKey('XboxTypeS_A');
	//AddCaptureKey('XboxTypeS_Start');
	//AddCaptureKey('Enter');
	
    return TRUE;
}

//function OnPressResumeButton(GFxClikWidget.EventData ev)
//{
//    PlayCloseAnimation();
//}

//function OnPressExitButton(GFxClikWidget.EventData ev)
//{
//	UTPlayerController(GetPC()).QuitToMainMenu();	
//}

function PlayOpenAnimation()
{
    RootMC.GotoAndPlayI(1);
}

function PlayCloseAnimation()
{
    RootMC.GotoAndPlayI(16);
}

function ResumeGame()
{
	UTHUDBase(GetPC().MyHUD).CompletePauseMenuClose();
	Close(false);
}

function ExitGame()
{
	UTPlayerController(GetPC()).QuitToMainMenu();
}

defaultproperties
{
    bEnableGammaCorrection=FALSE
	bPauseGameWhileActive=TRUE
	bCaptureInput=true
}
