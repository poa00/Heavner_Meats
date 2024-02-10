
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Construct()
myGui.B.OnEvent("Click", (*) => X.Y)


Construct() 
{
	myGui := {}
	myGui.g := Gui()
	myGui.B := myGui.g.Add("Button", "x101 y43 w80 h23", "&OK")
	myGui.g.OnEvent('Close', (*) => ExitApp())
	myGui.g.Title := "Window"
	myGui.B.OnEvent("Click", (*) => X.Y(myGui.B))
	myGui.g.Show("w275 h141")
	
	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
		. "Active GUI element values include:`n"  
		. "ButtonOK => " myGui.g.B.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}

class X
{
	static y(ctrl, *)
	{
		Msgbox "X" ctrl.text
	}
}