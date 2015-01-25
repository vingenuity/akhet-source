// extend UIEvent if this event should be UI Kismet Event instead of a Level Kismet Event
class AK_Kismet_FlagReset extends SequenceEvent;

event Activated()
{
       //`log("Flag Return Kismet activated.");
}

defaultproperties
{
	bPlayerOnly=false
	OutputLinks[0]=(LinkDesc="Activated")
	ObjName="Flag Reset"
	ObjCategory="AK Events"
	Name="AK_Kismet_FlagReset"
}
