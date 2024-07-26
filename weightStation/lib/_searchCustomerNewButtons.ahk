
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w1920 h1080")
}

Constructor()
{	
	myGui := Gui()
	myGui.Opt("+Resize")
	Edit1 := myGui.Add("Edit", "x38 y21 w1344 h75", "Enter Search Criteria for Customer")
	ListView := myGui.Add("ListView", "x38 y129 w1344 h864")
	ButtonSelectOrder := myGui.Add("Button", "x1401 y129 w499 h97", "Select Order")
	LV_ := myGui.Add("ListView", "x1408 y280 w490 h410 +LV0x4000", ["ListView"])
	ButtonOK := myGui.Add("Button", "x1408 y720 w491 h122", "&OK")
	LV_.Add(,"Sample1")
	LV_.OnEvent("DoubleClick", LV_DoubleClick)
	Edit1.OnEvent("Change", OnEventHandler)
	ButtonSelectOrder.OnEvent("Click", OnEventHandler)
	ButtonOK.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window (Clone)"
	
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
		. "Edit1 => " Edit1.Value "`n" 
		. "ButtonSelectOrder => " ButtonSelectOrder.Text "`n" 
		. "ButtonOK => " ButtonOK.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}