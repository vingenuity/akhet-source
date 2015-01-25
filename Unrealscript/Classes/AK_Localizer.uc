class AK_Localizer extends Object
	config(Game);

enum Language
{
    /* 0*/LANGUAGE_ENG<DisplayName = English>,
    /* 1*/LANGUAGE_ESM<DisplayName = Espanol>,
    /* 2*/LANGUAGE_XXX<DisplayName = Test Language XX>
};
var config Language GameLanguage;

var string localizationFile_ENG;
var string localizationFile_ESM;
var string localizationFile_XXX;

static function string GetLocalizedStringWithName( string sectionName, string stringName )
{
    local string currentFile;

    switch( Default.GameLanguage )
    {
    case LANGUAGE_ENG:
        currentFile = Default.localizationFile_ENG;
        break;
    case LANGUAGE_ESM:
        currentFile = Default.localizationFile_ESM;
        break;
    case LANGUAGE_XXX:
        default:
        currentFile = Default.localizationFile_XXX;
    }

    return ParseLocalizedPropertyPath( currentFile $ "." $ sectionName $ "." $ stringName );
}

static function Language GetLocalizationLanguage()
{
    return Default.GameLanguage;
}

static function SetLocalizationLanguage( Language newLanguage )
{
	Default.GameLanguage = newLanguage;
	StaticSaveConfig();
}

DefaultProperties
{
    localizationFile_ENG = "Akhet_ENG"
    localizationFile_ESM = "Akhet_ESM"
    localizationFile_XXX = "Akhet_XXX"
}
