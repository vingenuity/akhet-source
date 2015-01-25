class AK_Stockpile_ScoreZone_Anubis extends AK_Stockpile_ScoreZone
	placeable;

DefaultProperties
{
	DefenderTeamIndex = 1
	pedestalMaterial = MaterialInstanceConstant'AK_Flags.Textures.AK_FlagStand_MAT_Purple_01_CONST'

	Begin Object Name=SiphonTunnelMeshComponent
		StaticMesh=StaticMesh'AK_Decoration_Pieces.Siphon_Circle.AK_SiphonCircle_Mesh_Purple_01'
	End Object
}
