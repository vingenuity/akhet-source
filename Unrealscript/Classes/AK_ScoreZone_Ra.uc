class AK_ScoreZone_Ra extends AK_Game_ScoreZone
	placeable;

simulated function Tick( float DeltaTime )
{
	local vector topOfCylinder;

	topOfCylinder = self.location;
	topOfCylinder.Z += 200.0;

	DrawDebugCylinder( self.Location, topOfCylinder, radiusOfScoreZone, 30.0, 0, 255, 0, true );
}

DefaultProperties
{
	DefenderTeamIndex = 0
}
