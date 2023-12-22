
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Gui("-DPIScale")
myGui.SetFont("s18")
Radio1 := myGui.Add("Radio", "x32 y64 w291 h46", "Radio Button")
Radio2 := myGui.Add("Radio", "x32 y128 w291 h46", "Radio Button")
Radio3 := myGui.Add("Radio", "x32 y192 w287 h46", "Radio Button")
myGui.Add("Text", "x32 y10 w641 h43 +0x200", "Set Options for All Directly Below")
myGui.Add("ListBox", "x336 y71 w274 h216", ["ListBox"])
ogcButtonConfirm := myGui.Add("Button", "x648 y66 w169 h55", "Confirm")
myGui.Add("ListBox", "x32 y304 w389 h148", ["ListBox"])
ogcButtonCancel := myGui.Add("Button", "x648 y136 w169 h55", "Cancel")
Radio1.OnEvent("Click", OnEventHandler)
Radio2.OnEvent("Click", OnEventHandler)
Radio3.OnEvent("Click", OnEventHandler)
ogcButtonConfirm.OnEvent("Click", OnEventHandler)
ogcButtonCancel.OnEvent("Click", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w1013 h629")

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "Radio1 => " Radio1.Value "`n" 
	. "Radio2 => " Radio2.Value "`n" 
	. "Radio3 => " Radio3.Value "`n" 
	. "ogcButtonConfirm => " ogcButtonConfirm.Text "`n" 
	. "ogcButtonCancel => " ogcButtonCancel.Text "`n", -177, -377)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
