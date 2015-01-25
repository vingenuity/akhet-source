class AK_Game_Flag extends UTCTFFlag
	abstract;

//----------------------------------------- States -----------------------------------------//
auto state Home
{
	ignores SendHome, Score, Drop;

	function BeginState( Name PreviousStateName )
	{
		Super.BeginState( PreviousStateName );
	}

	function EndState( Name NextStateName )
	{
		Super.EndState( NextStateName );
	}

	function SameTeamTouch( Controller C )
	{
		//Touching the flag with the enemy flag or not does nothing!
	}
}

//---------------------------------------------------------------------------------
state PlacedInZone
{
	ignores Touch, Drop;

	function BeginState( Name PreviousStateName )
	{

	}

	function EndState( Name NextStateName )
	{

	}

	function SameTeamTouch( Controller C )
	{
		//Touching the flag in this state does nothing!
	}
}


//----------------------------------------- State Changing Functions -----------------------------------------//
function PlaceFlag( AK_Game_ScoreZone scoreZone )
{
	SetFlagPropertiesToStationaryFlagState();

	OldHolder = Holder;

	SetLocation( scoreZone.Location );
	SetRotation( rot( 0, 0, 0 ) );

	GotoState( 'PlacedInZone' );
}






DefaultProperties
{
	//Direction to translate flag object from origin when attached to player.
	GameObjOffset3P=(X=-20,Y=20,Z=0)
}
