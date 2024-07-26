
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w620 h567")
}

Constructor()
{	
	myGui := Gui()
	myGui.Add("GroupBox", "x16 y8 w588 h217", "GroupBox")
	ButtonOK := myGui.Add("Button", "x32 y40 w175 h55", "&OK")
	ButtonOK := myGui.Add("Button", "x224 y40 w175 h55", "&OK")
	ButtonOK := myGui.Add("Button", "x408 y40 w175 h55", "&OK")
	ButtonOK.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	
	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
		. "Active GUI element values include:`n"  
		. "ButtonOK => " ButtonOK.Text "`n" 
		. "ButtonOK => " ButtonOK.Text "`n" 
		. "ButtonOK => " ButtonOK.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}