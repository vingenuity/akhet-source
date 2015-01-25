class AK_Stockpile_ScoreZone_Ra extends AK_Stockpile_ScoreZone
	placeable;

DefaultProperties
{
	DefenderTeamIndex = 0
	pedestalMaterial = MaterialInstanceConstant'AK_Flags.Textures.AK_FlagStand_MAT_Yellow_01_CONST'

	Begin Object Name=SiphonTunnelMeshComponent
		StaticMesh=StaticMesh'AK_Decoration_Pieces.Siphon_Circle.AK_SiphonCircle_Mesh_Yellow_01'
	End Object
}
