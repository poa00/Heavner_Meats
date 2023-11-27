
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Gui()
myGui.SetFont("s16")
myGui.Add("GroupBox", "x8 y8 w322 h468", "Ribeye Options - Main")
Radio1 := myGui.Add("Radio", "x32 y56 w245 h34", "Bone-in")
Radio2 := myGui.Add("Radio", "x32 y120 w245 h34", "Boneless")
Radio3 := myGui.Add("Radio", "x32 y184 w245 h34", "Grind")
ogcButtonNextOptions := myGui.Add("Button", "x32 y240 w250 h39", "Next Options")
myGui.Add("Text", "x32 y320 w254 h217 r5", "Ribeye has a select many or all options, please use the checkboxes then select `"Next`" until complete")
myGui.Add("GroupBox", "x352 y16 w607 h109", "Select One")
Radio4 := myGui.Add("Radio", "x408 y64 w120 h23", "Steaks")
Radio5 := myGui.Add("Radio", "x640 y64 w120 h23", "Roasts")
tabStorage := myGui.Add("Tab3", "x352 y144 w607 h341", [" Thickness ", " Tomahawk ", " Size "])
myGui.Add("Text", "x392 y200 w243 h33 +0x200", "Thickness options")
CheckBox1 := myGui.Add("CheckBox", "x392 y264 w120 h23", "1.5in")
CheckBox2 := myGui.Add("CheckBox", "x392 y312 w120 h23", "1in")
yLoop := 185
radioLoop := "x392 y" yLoop " w120 h23"
tabStorage.UseTab(3)
loopRadio(loopRadios:=["radioLoop1", "radioLoop2","radioLoop2","radioLoop2"], yLoop)

tabStorage.UseTab(2)

loopRadio(loopRadios:=["radioLoop1", "radioLoop2"], yLoop)
Radio1.OnEvent("Click", OnEventHandler)
Radio2.OnEvent("Click", OnEventHandler)
Radio3.OnEvent("Click", OnEventHandler)
ogcButtonNextOptions.OnEvent("Click", OnEventHandler)
Radio4.OnEvent("Click", OnEventHandler)
Radio5.OnEvent("Click", OnEventHandler)
CheckBox1.OnEvent("Click", OnEventHandler)
CheckBox2.OnEvent("Click", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w1013 h560")
Sleep(100)

loopRadio(loopRadios, yLoop := 150)
{
	radioLoop := "x392 y" yLoop " w120 h23"
	x := myGui.Add("CheckBox", radioLoop, "1.5in")
	for i in loopRadios
	{
		yLoop := yLoop+50
		x := myGui.Add("CheckBox", "x392 y" yLoop " w120 h23", "1.5in")
		x.OnEvent("click", OnEventHandler)
	}
}

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "Radio1 => " Radio1.Value "`n" 
	. "Radio2 => " Radio2.Value "`n" 
	. "Radio3 => " Radio3.Value "`n" 
	. "ogcButtonNextOptions => " ogcButtonNextOptions.Text "`n" 
	. "Radio4 => " Radio4.Value "`n" 
	. "Radio5 => " Radio5.Value "`n" 
	. "CheckBox1 => " CheckBox1.Value "`n" 
	. "CheckBox2 => " CheckBox2.Value "`n" 
	. "Radio7 => "  "`n", 577, 777)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
