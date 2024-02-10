#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Construct()

Construct() {
	myGui := Gui()
	LV_ := myGui.Add("ListView", "x24 y16 w351 h370 +LV0x4000", ["ListView",'2'])
	LV_.Add(,"Sample1","Sample1")
	LV_.Add(,"Sample1","Sample1")
	LV_.Add(,"Sample1","Sample1")
	LV_.Add(,"Sample1","Sample1")
	LV_.OnEvent("Click", LV_Click)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	myGui.Show("w620 h420")
	
	LV_Click(LV, RowNum)
	{
		x := Random(50,90)
		y := Random(200, 300)
		if not RowNum
			return
		ToolTip(LV.GetText(RowNum), x, y)
		SetTimer () => ToolTip(), -3000
	}
	
	return myGui
}