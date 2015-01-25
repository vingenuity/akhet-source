class AK_AhketMenu extends GFxMoviePlayer;

var string titleText;
var string levelToLoad;

function bool Start(optional bool startPaused = false) 
{
    local GFxObject menuTitleText;
    //call the start function from the parent class
    super.Start();

    //Advance() is a core function if GFx
    //similar to gotoAndPlay(0) in AS
    Advance(0);
    
    menuTitleText = GetVariableObject("_root.menuTitle_txt");
    menuTitleText.SetText( titleText );

    //if we got here then everything went well
    //return true, could add error catching and handling to return false
    return true;
}




//---------------- Function Handles Called by ActionScript ----------------//
function SendConsoleCommand( string command ) 
{
    `log( "CONSOLE COMMAND" $ command );
     ConsoleCommand( command );
}

function JoinActiveGameAtIP( string ipAddress )
{
    //Take IP address from ActionScript and use it to connect
    `log( "Attempting to join Game" );
    ConsoleCommand( "open " $ ipAddress );
}

function HostAkhetGameAsListenServer()
{
    `log( "Attempting to host Game" );
    ConsoleCommand( "open " $ levelToLoad $ "?Listen=true" );
}




DefaultProperties
{
    titleText = "Akhet"
    levelToLoad = "AS-Persistent.udk"
}
