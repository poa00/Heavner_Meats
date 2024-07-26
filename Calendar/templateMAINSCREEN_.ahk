
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w2880 h1569")
}

Constructor()
{	
	myGui := Gui()
	myGui.Add("Hotkey", "x0 y0 w5760 h3242", "calendarSimple.ahk")
	MonthCal1 := myGui.Add("MonthCal", "x62 y37 w1437 h1498")
	ListView := myGui.Add("ListView", "x1549 y37 w1549 h749")
	myGui.Add("GroupBox", "x1549 y806 w544 h499", "Selected Week")
	myGui.Add("Text", "x1569 y846 w494 h299", "15")
	ButtonADD := myGui.Add("Button", "x2153 y806 w190 h170", "+ ADD")
	ButtonDetails := myGui.Add("Button", "x2343 y806 w190 h170", "Details")
	ButtonDelete := myGui.Add("Button", "x2533 y806 w190 h170", "Delete")
	ListView.Add(,"Sample1")
	ListView.OnEvent("DoubleClick", LV_DoubleClick)
	MonthCal1.OnEvent("Change", OnEventHandler)
	ButtonADD.OnEvent("Click", OnEventHandler)
	ButtonDetails.OnEvent("Click", OnEventHandler)
	ButtonDelete.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "calendarSimple.ahk (Clone)"
	
	LV_DoubleClick(LV, RowNum)
	{
		if not RowNum
			return
		ToolTip(LV.GetText(RowNum), 77, 277)
		SetTimer () => ToolTip(), -3000
	}
	
	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
		. "Active GUI element values include:`n"  
		. "MonthCal1 => " MonthCal1.Value "`n" 
		. "ButtonADD => " ButtonADD.Text "`n" 
		. "ButtonDetails => " ButtonDetails.Text "`n" 
		. "ButtonDelete => " ButtonDelete.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}