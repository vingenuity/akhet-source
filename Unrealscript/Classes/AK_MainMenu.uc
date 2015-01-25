class AK_MainMenu extends GFxMoviePlayer
    dependson(AK_Localizer)
    config(SystemSettings);

//Localization Files
var string localizationSection;

//Buttons
var GFxObject menuButtonText_Start;
var GFxObject menuButtonText_Controls;
var GFxObject menuButtonText_Options;
var GFxObject menuButtonText_Credits;
var GFxObject menuButtonText_Exit;
var GFxObject menuButtonText_Back;
var GFxObject menuButtonText_Host;
var GFxObject menuButtonText_Join;
var GFxObject menuButtonText_Go;
var GFxObject menuButtonText_Refresh;
var GFxObject menuButtonText_Apply;

//Text
var GFxObject menuText_Host_EnterServerName;
var GFxObject menuText_Host_ServerName;
var GFxObject menuText_Join_PickServer;
var GFxObject dropdown_Join_ServerList;
var GFXObject menuText_Option_Name;
var GFXObject menuText_Option_Resolution;
var GFXObject menuText_Option_FullScreen;
var GFXObject menuText_Option_Language;
var GFXObject menuText_Option_Gamma;
var GFXObject menuText_Option_GammaBrighter;
var GFXObject menuText_Option_GammaDarker;
var GFXObject menuText_Option_ResetToDefaults;

//Options Text
var GFXObject textBox_Join_HostIP;
var GFXObject checkbox_ShowFullScreen;
var GFXObject dropdown_SetLanguage;
var GFXObject dropdown_SetResolution;
var GFXObject textBox_PlayerName;
var GFXObject slider_Gamma;

//Options Items
var array< string > languageList;
var array< string > screenResolutionList;
var config int ResX;
var config int ResY;
var config bool Fullscreen;

//Server Browser
var OnlineSubsystem OnlineSub;
var OnlineGameInterface GameInterface;
var AK_OnlineGameSettings currentGameSettings;
var AK_OnlineSearchSettings SearchSetting;
var array< OnlineGameSearchResult > searchResults;

var string creditsLevelName;
var string gameTypeToLoad;
var string levelToLoad;
var string roomName;



function bool Start(optional bool startPaused = false) 
{
    InitOnlineSubSystem();
    super.Start();
    
    Advance(0.f);
    //SetViewScaleMode( SM_ExactFit );
    LocalizeMainMenuFrame();

    return true;
}



//--------------------------------------------------------------- Localization ---------------------------------------------------------------//
function LocalizeMainMenuFrame()
{
    menuButtonText_Start = GetVariableObject( "_root.start_txt" );
    menuButtonText_Start.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Start" ) );

    menuButtonText_Controls = GetVariableObject( "_root.controls_txt" );
    menuButtonText_Controls.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Controls" ) );

    menuButtonText_Options = GetVariableObject( "_root.options_txt" );
    menuButtonText_Options.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Options" ) );

    menuButtonText_Credits = GetVariableObject( "_root.credits_txt" );
    menuButtonText_Credits.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Credits" ) );

    menuButtonText_Exit = GetVariableObject( "_root.exit_txt" );
    menuButtonText_Exit.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Exit" ) );
}

function LocalizeStartFrame()
{
    menuButtonText_Host = GetVariableObject( "_level1.host_txt" );
    menuButtonText_Host.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Host" ) );

    menuButtonText_Join = GetVariableObject( "_level2.join_txt" );
    menuButtonText_Join.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Join" ) );

    menuButtonText_Back = GetVariableObject( "_root.back_txt" );
    menuButtonText_Back.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Back" ) );
}

function LocalizeControlsFrame()
{
    menuButtonText_Back = GetVariableObject( "_root.back_txt" );
    menuButtonText_Back.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Back" ) );
}

function LocalizeOptionsFrame()
{
    menuText_Option_Name = GetVariableObject( "root.OptionsPopout.name_txt" );
    menuText_Option_Name.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_Name" ) );

    menuText_Option_Resolution = GetVariableObject( "_root.OptionsPopout.resolution_txt" );
    menuText_Option_Resolution.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_Resolution" ) );

    menuText_Option_FullScreen = GetVariableObject( "_root.OptionsPopout.fullscreen_txt" );
    menuText_Option_FullScreen.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_FullScreen" ) );

    menuText_Option_Language = GetVariableObject( "_root.OptionsPopout.language_txt" );
    menuText_Option_Language.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_Language" ) );

    menuText_Option_Gamma = GetVariableObject( "_root.OptionsPopout.gamma_txt" );
    menuText_Option_Gamma.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_Gamma" ) );

    menuText_Option_GammaBrighter = GetVariableObject( "_root.OptionsPopout.brighter_txt" );
    menuText_Option_GammaBrighter.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_GammaBrighter" ) );

    menuText_Option_GammaDarker = GetVariableObject( "_root.OptionsPopout.darker_txt" );
    menuText_Option_GammaDarker.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_GammaDarker" ) );

    menuText_Option_ResetToDefaults = GetVariableObject( "_root.OptionsPopout.default_txt" );
    menuText_Option_ResetToDefaults.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Option_ResetToDefaults" ) );

    menuButtonText_Apply = GetVariableObject( "_root.apply_txt" );
    menuButtonText_Apply.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Apply" ) );

    menuButtonText_Back = GetVariableObject( "_root.back_txt" );
    menuButtonText_Back.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Back" ) );
}

function LocalizeCreditsFrame()
{
    menuButtonText_Back = GetVariableObject( "_root.back_txt" );
    menuButtonText_Back.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Back" ) );
}

function LocalizeHostFrame()
{
    menuText_Host_EnterServerName = GetVariableObject( "_root.IP_label_txt" );
    menuText_Host_EnterServerName.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_EnterServerName" ) );

    menuText_Host_ServerName = GetVariableObject( "_root.IP_host_txt" );
    menuText_Host_ServerName.SetText( roomName );

    menuButtonText_Go = GetVariableObject( "_root.go_txt" );
    menuButtonText_Go.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Go" ) );

    menuButtonText_Back = GetVariableObject( "_root.back_txt" );
    menuButtonText_Back.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Back" ) );

}

function LocalizeJoinFrame()
{
    menuText_Join_PickServer = GetVariableObject( "_root.pickserver_txt" );
    menuText_Join_PickServer.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Join_PickServer" ) );

    menuButtonText_Refresh = GetVariableObject( "_root.refresh_txt" );
    menuButtonText_Refresh.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Refresh" ) );

    menuButtonText_Go = GetVariableObject( "_root.go_txt" );
    menuButtonText_Go.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Go" ) );
    
    menuButtonText_Back = GetVariableObject( "_root.back_txt" );
    menuButtonText_Back.SetText( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuButtonString_Back" ) );

    dropdown_Join_ServerList = GetVariableObject( "_root.server_combobox" );
}


//--------------------------------------------------------------- Options ---------------------------------------------------------------//
function GFxObject CreateDataProviderFromArray( GFxObject array )
{
     return ActionScriptConstructor( "fl.data.DataProvider" );
}

function PopulateComboBox( GFxObject comboBoxObject, array< string > listOfItems )
{
    local int i;
    local GFxObject dataProviderArray, dataProvider;

    dataProviderArray = CreateArray();

    for( i = 0; i < listOfItems.Length; ++i ) 
    {
        dataProviderArray.SetElementString( i, listOfItems[ i ] );
    }

    comboBoxObject.SetFloat( "rowCount", listOfItems.Length );

    dataProvider = CreateDataProviderFromArray( dataProviderArray );

    comboBoxObject.SetObject( "dataProvider", dataProvider );
}

function int GetSelectionIndexFromList( array< string > stringList, string selection )
{
    local int i;

    for( i = 0; i < stringList.Length; ++i )
    {
        if( stringList[ i ] == selection )
            return i;
    }
    return 0;
}

function PopulateOptionsDialogs()
{
    local PlayerReplicationInfo playerInfo;
    local string currentResolution;

    //Player Name
    playerInfo = GetPC().PlayerReplicationInfo;
    textBox_PlayerName = GetVariableObject( "_root.OptionsPopout.playername_txt" );
    textBox_PlayerName.SetText( playerInfo.PlayerName );

    //Resolution
    dropdown_SetResolution = GetVariableObject( "_root.OptionsPopout.resolution_combobox" );
    PopulateComboBox( dropdown_SetResolution, screenResolutionList );

    currentResolution = ResX $ "x" $ ResY;
    `log( currentResolution );
    dropdown_SetResolution.SetInt( "selectedIndex", GetSelectionIndexFromList( screenResolutionList, currentResolution ) );

    //Fullscreen
    checkbox_ShowFullScreen = GetVariableObject( "_root.OptionsPopout.fullscreen_checkbox" );
    checkbox_ShowFullScreen.SetBool( "selected", Fullscreen );

    //Language
    dropdown_SetLanguage = GetVariableObject( "_root.OptionsPopout.language_combobox" );
    PopulateComboBox( dropdown_SetLanguage, languageList );
    dropdown_SetLanguage.SetInt( "selectedIndex", int( class'AK_Localizer'.static.GetLocalizationLanguage() ) );

    //Gamma
    slider_Gamma = GetVariableObject( "_root.OptionsPopout.gamma_slider" );
    slider_Gamma.SetFloat( "value", class'Client'.default.DisplayGamma );
}



//----------------------------------------------------- Actionscript Function Handles -----------------------------------------------------//
function SendConsoleCommand( string command ) 
{
    `log( "CONSOLE COMMAND: " $ command );
     ConsoleCommand( command );
}

function ApplySettings()
{
    SetPlayerName( textBox_PlayerName.GetText() );

    SetResolutionFromComboAndCheckBox();

    class'AK_Localizer'.static.SetLocalizationLanguage( Language( dropdown_SetLanguage.GetInt( "selectedIndex" ) ) );

    SetGamma( slider_Gamma.GetFloat( "value" ) );

    //Refresh
    LocalizeOptionsFrame();
    PopulateOptionsDialogs();
}

function ResetSettingsToDefaults()
{
    local PlayerReplicationInfo playerInfo;
    playerInfo = GetPC().PlayerReplicationInfo;
    playerInfo.PlayerName = "Player";

    dropdown_SetResolution.SetInt( "selectedIndex", 0 );
    checkbox_ShowFullScreen.SetBool( "selected", false );
    SetResolutionFromComboAndCheckBox();

    class'AK_Localizer'.static.SetLocalizationLanguage( LANGUAGE_ENG );

    SetGamma( 2.5 );
    
    //Refresh
    LocalizeOptionsFrame();
    PopulateOptionsDialogs();
}

//This function thanks to: http://eliotvu.com/news/view/38/reading-and-writing-the-gamma-display-setting-in-udk
function SetGamma( float newGamma )
{
    // Change Run-Time Gamma
    ConsoleCommand( "Gamma" @ newGamma );
    
    // Change Save-Time Gamma
    class'Client'.default.DisplayGamma = newGamma;
    class'Client'.static.StaticSaveConfig();
}

function SetPlayerName( string newPlayerName )
{
    local PlayerReplicationInfo playerInfo;

    playerInfo = GetPC().PlayerReplicationInfo;
    `log( "Current Player Name is " $ playerInfo.PlayerName );
    
    playerInfo.PlayerName = newPlayerName;
    `log( "New Player Name is " $ playerInfo.PlayerName );
}

function SetResolutionFromComboAndCheckBox()
{
    local bool screenModeSelection;
    local string selectedResolution;
    local int xLocation;
    local int selectedXResolution, selectedYResolution;

    selectedResolution = screenResolutionList[ dropdown_SetResolution.GetInt( "selectedIndex" ) ];
    xLocation = InStr( selectedResolution, "x" );
    selectedXResolution = int( Mid( selectedResolution, 0, xLocation ) );
    selectedYResolution = int( Mid( selectedResolution, xLocation + 1 ) );

    screenModeSelection = checkbox_ShowFullScreen.GetBool( "selected" );

    if( selectedXResolution != ResX || selectedYResolution != ResY || screenModeSelection != Fullscreen )
    {
        `log( selectedXResolution @ selectedYResolution );
        ResX = selectedXResolution;
        ResY = selectedYResolution;
        Fullscreen = screenModeSelection;
        SaveConfig();

        SetResolution( selectedResolution, screenModeSelection );
    }
}

function SetResolution( string resolution, bool isFullscreen )
{
    local string screenMode;

    if( isFullscreen )
        screenMode = "f";
    else
        screenMode = "w";

    `log( "Setting Resolution to: " $ resolution );
    SendConsoleCommand( "setres " $ resolution $ screenMode );
}

function RefreshFoundServers()
{
    SearchOnlineGames();
    //Boxes will be automatically updated by callback
}

function JoinSelectedOnlineGame()
{
    //Pick active game from dialog box
    JoinOnlineGame( dropdown_Join_ServerList.GetInt( "selectedIndex" ) );
}

function JoinActiveGameAtIP( string ipAddress )
{
    //Take IP address from ActionScript and use it to connect
    `log( "Attempting to join Game..." );
    SendConsoleCommand( "open " $ ipAddress );
}

function HostAkhetGameAsListenServer()
{
    `log( "Attempting to Host Game..." );
    //SendConsoleCommand( "open " $ levelToLoad $ "?Listen=true" );
    
    roomName = menuText_Host_ServerName.GetText();
    `log( "Server Name:" @ roomName );
    CreateOnlineGame();
}

function ShowCreditsScreen()
{
    `log( "Opening Credits Screen" );
    SendConsoleCommand( "open " $ creditsLevelName );
}

function ExitGame()
{
    `log( "Exiting Game..." );
    SendConsoleCommand( "exit" );
}



//------------------------------------------------------------ Server Browser ------------------------------------------------------------//
function InitOnlineSubSystem() 
{
    // Figure out if we have an online subsystem registered
    OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();

    if (OnlineSub == None) {
        `Log("CreateOnlineGame - No OnlineSubSystem found.");
        return;
    }

    GameInterface = OnlineSub.GameInterface;

    if (GameInterface == None) {
        `Log("CreateOnlineGame - No GameInterface found.");
    }
}

/**
 * Creates the OnlineGame with the Settings we want
 */
function CreateOnlineGame() 
{
    // Create the desired GameSettings
    currentGameSettings = new class'AK_OnlineGameSettings';
    currentGameSettings.bShouldAdvertise = true;
    currentGameSettings.NumPublicConnections = 32;
    currentGameSettings.NumPrivateConnections = 32;
    currentGameSettings.NumOpenPrivateConnections = 32;
    currentGameSettings.NumOpenPublicConnections = 32;
    currentGameSettings.bIsLanMatch = false;
    currentGameSettings.setServerName(roomName);

    // Create the online game
    // First, set the delegate thats called when the game was created (cause this is async)
    GameInterface.AddCreateOnlineGameCompleteDelegate(OnGameCreated);

    // Try to create the game. If it fails, clear the delegate
    // Note: the playerControllerId == 0 is the default and noone seems to know what it actually does...
    if (GameInterface.CreateOnlineGame(class'UIInteraction'.static.GetPlayerControllerId(0), 'Game', currentGameSettings) == FALSE ) 
    {
        GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);
        `Log("CreateOnlineGame - Failed to create online game.");
    }
}

/**
 * Delegate that gets called when the OnlineGame has been created.
 * Actually sends the player to the game
 */
function OnGameCreated(name SessionName, bool bWasSuccessful) 
{
    local string TravelURL;
    local Engine Eng;
    local PlayerController PC;

    // Clear the delegate we set.
    GameInterface.ClearCreateOnlineGameCompleteDelegate(OnGameCreated);

    if (bWasSuccessful) 
    {
        Eng = class'Engine'.static.GetEngine();
        PC = Eng.GamePlayers[0].Actor;

        // Creation was successful, so send the player on the host to the level
        // Build the URL
        currentGameSettings.BuildURL(TravelURL);

        TravelURL = "open " 
            $ levelToLoad
            $ "?game=" $ gameTypeToLoad
            $ TravelURL $ "?listen?steamsockets";
        // Do the server travel.
        PC.ConsoleCommand(TravelURL);
    } 
    else 
    {
        `Log("OnGameCreated: Creation of OnlineGame failed!");
    }
}

function SearchOnlineGames() 
{
    SearchSetting = new class'AK_OnlineSearchSettings';
    SearchSetting.bIsLanQuery = false;
    SearchSetting.MaxSearchResults = 50;
    // Cancel the Search first...cause there may be a former search still in progress
    GameInterface.CancelFindOnlineGames();
    GameInterface.AddFindOnlineGamesCompleteDelegate(OnServerQueryComplete);
    GameInterface.FindOnlineGames(class'UIInteraction'.static.GetPlayerControllerId(0), SearchSetting);
}

// Delegate that gets called when the ServerSearch is finished
function OnServerQueryComplete(bool bWasSuccessful) 
{
    local int i;
    local AK_OnlineGameSettings gs;
    local array< string > serverNames;

    searchResults = SearchSetting.Results;
    if (bWasSuccessful) 
    {
        `Log( SearchSetting.Results.Length @ "Results Found.");
        for (i = 0; i < SearchSetting.Results.Length; i++) 
        {
            gs = AK_OnlineGameSettings(SearchSetting.Results[i].GameSettings);
            // Here you can do something with the GameSettings for each result that was found

            serverNames.AddItem( gs.getServerName() );
            `log( i @ gs.getServerName() );
        }
        if( serverNames.Length == 0 )
        {
            serverNames.AddItem( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Join_NoResultsFound" ) );
        }

        PopulateCombobox( dropdown_Join_ServerList, serverNames );
    } 
    else 
    {
        `log("No Results Found.");

        serverNames.AddItem( class'AK_Localizer'.static.GetLocalizedStringWithName( localizationSection, "menuString_Join_NoResultsFound" ) );
        PopulateCombobox( dropdown_Join_ServerList, serverNames );
    }

    GameInterface.ClearFindOnlineGamesCompleteDelegate(OnServerQueryComplete);
}

// Joins the game with given index from the searchResults
public function JoinOnlineGame(int gameIdx) 
{
    `Log( "Joining Game..." );
    // Set the delegate for notification
    GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinGameComplete);
    GameInterface.JoinOnlineGame(0, 'Game', SearchSetting.Results[gameIdx]);
}

// Delegate that gets called when joinGame completes.
private function OnJoinGameComplete(name SessionName, bool bSuccessful) 
{
    local AK_OnlineGameSettings myGameSettings;
    local string travelURL;
    local Engine Eng;
    local PlayerController PC;
    
    if (bSuccessful == false) 
    {
        `log("Failed to join game!");
        return;
    }
    
    Eng = class'Engine'.static.GetEngine();
    PC = Eng.GamePlayers[0].Actor;

    class'GameEngine'.static.GetOnlineSubsystem().GameInterface.GetResolvedConnectString('Game', travelURL);

    myGameSettings = AK_OnlineGameSettings( OnlineGameInterfaceImpl( class'GameEngine'.static.GetOnlineSubsystem().GameInterface ).GameSettings );

    if (myGameSettings != none && myGameSettings.SteamServerId != "") 
    {
        PC.ConsoleCommand("open "$"steam."$myGameSettings.SteamServerId);
    }
    else 
    {
        PC.ConsoleCommand("open "@travelURL);
    }
}



DefaultProperties
{
    bCaptureInput = true;
    localizationSection  = "AK_MainMenu"

    creditsLevelName = "CreditsMenu.udk"
    levelToLoad = "AS-Persistent.udk"
    gameTypeToLoad = "AK_Stockpile_Game"
    roomName = "Akhet Server"
    languageList = ( "English", "Espanol" )
    screenResolutionList = ( "1280x720", "1280x1024","1920x1080" )
}
