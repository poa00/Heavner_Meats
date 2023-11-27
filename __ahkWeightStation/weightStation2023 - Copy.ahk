
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Gui()
Radio1 := myGui.Add("Radio", "x32 y48 w187 h47", "Radio Button")
myGui.Add("GroupBox", "x16 y8 w308 h237", "GroupBox")
Radio2 := myGui.Add("Radio", "x32 y112 w187 h47", "Radio Button")
Radio3 := myGui.Add("Radio", "x32 y176 w187 h47", "Radio Button")
Edit1 := myGui.Add("Edit", "x376 y72 w318 h117")
myGui.Add("GroupBox", "x328 y16 w441 h217", "Weight")
myGui.Add("GroupBox", "x24 y288 w310 h223", "Sex/Age")
Radio4 := myGui.Add("Radio", "x50 y341 w236 h23", "Radio Button")
Radio5 := myGui.Add("Radio", "x49 y403 w262 h23", "Radio Button")
CheckBox1 := myGui.Add("CheckBox", "x48 y456 w120 h23", "CheckBox")
myGui.Add("GroupBox", "x376 y296 w521 h216", "Parts")
CheckBox2 := myGui.Add("CheckBox", "x409 y350 w120 h23", "CheckBox")
CheckBox3 := myGui.Add("CheckBox", "x408 y400 w120 h23", "CheckBox")
CheckBox4 := myGui.Add("CheckBox", "x402 y460 w120 h23", "CheckBox")
CheckBox5 := myGui.Add("CheckBox", "x648 y360 w120 h23", "CheckBox")
CheckBox6 := myGui.Add("CheckBox", "x652 y438 w120 h23", "CheckBox")
Edit2 := myGui.Add("Edit", "x56 y576 w838 h184", "comments")
Radio1.OnEvent("Click", OnEventHandler)
Radio2.OnEvent("Click", OnEventHandler)
Radio3.OnEvent("Click", OnEventHandler)
Edit1.OnEvent("Change", OnEventHandler)
Radio4.OnEvent("Click", OnEventHandler)
Radio5.OnEvent("Click", OnEventHandler)
CheckBox1.OnEvent("Click", OnEventHandler)
CheckBox2.OnEvent("Click", OnEventHandler)
CheckBox3.OnEvent("Click", OnEventHandler)
CheckBox4.OnEvent("Click", OnEventHandler)
CheckBox5.OnEvent("Click", OnEventHandler)
CheckBox6.OnEvent("Click", OnEventHandler)
Edit2.OnEvent("Change", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w1068 h799")

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "Radio1 => " Radio1.Value "`n" 
	. "Radio2 => " Radio2.Value "`n" 
	. "Radio3 => " Radio3.Value "`n" 
	. "Edit1 => " Edit1.Value "`n" 
	. "Radio4 => " Radio4.Value "`n" 
	. "Radio5 => " Radio5.Value "`n" 
	. "CheckBox1 => " CheckBox1.Value "`n" 
	. "CheckBox2 => " CheckBox2.Value "`n" 
	. "CheckBox3 => " CheckBox3.Value "`n" 
	. "CheckBox4 => " CheckBox4.Value "`n" 
	. "CheckBox5 => " CheckBox5.Value "`n" 
	. "CheckBox6 => " CheckBox6.Value "`n" 
	. "Edit2 => " Edit2.Value "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
