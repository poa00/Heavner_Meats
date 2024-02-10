
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Gui()
myGui.SetFont("s16")
myGui.Add("ListBox", "x312 y48 w225 h196", ["Option Values"])
ogcButtonConfirmcurrentselection := myGui.Add("Button", "x320 y264 w220 h43", "Confirm current selection")
myGui.Add("Text", "x312 y8 w213 h33 +0x200", "Currently Showing")
myGui.Add("ListBox", "x24 y48 w223 h100", ["Option Keys"])
myGui.Add("ListBox", "x24 y176 w223 h100", ["Option Keys"])
ogcButtonConfirmcurrentselection.OnEvent("Click", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w589 h364")

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "ogcButtonConfirmcurrentselection => " ogcButtonConfirmcurrentselection.Text "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
