class AK_WeaponPedestal extends UTWeaponPickupFactory
	dependsOn(UTWeaponLocker)
	ClassGroup(Pickups,Weapon);


simulated function SetPickupMesh()
{
	Super.SetPickupMesh();
	if ( PickupMesh != none )
	{
		PickupMesh.SetTranslation( vect( 0.0, 0.0, -20.0 ) );
		PickupMesh.SetRotation( rot( 0, 16384, 0 ) );
		PickupMesh.SetScale(PickupMesh.Scale * WeaponPickupScaling);
	}
}

DefaultProperties
{
	bMovable=FALSE
	bStatic=FALSE

	bDoVisibilityFadeIn=FALSE // weapons are all skeletal meshes and don't do the ResIn effect. Also most weapons are always available
	bWeaponStay=true
	bRotatingPickup=false
	bCollideActors=true
	bBlockActors=true
	WeaponPickupScaling=+1.2

	//Appearance
	Begin Object Name=BaseMeshComp
		StaticMesh = StaticMesh'AK_Architecture_Pieces.WeaponPad.AK_weaponpad_SM_01'
		Translation = ( X = 0.0, Y = 0.0, Z = -45.0 )
		Scale = 1
	End Object

	Begin Object Name=GlowEffect
		bAutoActivate=TRUE
		Template=ParticleSystem'Pickups.WeaponBase.Effects.P_Pickups_WeaponBase_Glow'
		Translation=(X=0.0,Y=0.0,Z=-38.0)
		SecondsBeforeInactive=1.0f
	End Object
	BaseGlow=GlowEffect
	Components.Add(GlowEffect)
}