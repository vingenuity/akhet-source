// extend UIEvent if this event should be UI Kismet Event instead of a Level Kismet Event
class AK_Kismet_MatchTimes extends SequenceEvent;

event Activated()
{

}

DefaultProperties
{
	bPlayerOnly = false;
	OutputLinks[0]=(LinkDesc="Seconds Left: 5")
	OutputLinks[1]=(LinkDesc="4")
	OutputLinks[2]=(LinkDesc="3")
	OutputLinks[3]=(LinkDesc="2")
	OutputLinks[4]=(LinkDesc="1")
	ObjName = "AK Match Times"
	ObjCategory = "AK Events"
	Name = "Default__AK_Kismet_MatchTimes"
	ObjectArchetype=SequenceEvent'Engine.Default__SequenceEvent'
}
