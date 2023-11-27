#SingleInstance force
#Requires Autohotkey v2
#Include requests/request.ahk
#Include requests/jsons.ahk
#Include requests/utils.ahk
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;    get debug val from NEW CALENDAR EVENT api route
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
appsJson := A_MyDocuments "\files.json"

BS_CHECKBOX := 0x2
myGui := Gui()
myGui.SetFont("s20")
Radio1 := myGui.Add("Radio", "x104 y40 w409 h94 r5", "Radio Button")
Radio1.OnEvent("Click", OnEventHandler)
Radio1.Opt()
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w1618 h697")

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "Radio1 => " Radio1.Value "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
