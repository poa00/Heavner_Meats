
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := animalManager()
	myGui.Show("w1241 h1009")
	myGui.Maximize()
}

class animalManager
{
	static Call()
	{

		myCtrls := {}
		myGui := Gui(), myGui.Opt("+Resize +MinSize250x150")
		myGui.SetFont('s22')
		myGui.OnEvent("Size", GuiReSizer)
		myCtrls.ListView1 := myGui.Add("ListView", "",[" "])
		pushToResizer(myCtrls.ListView1, .032, .140, .659, .833)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, .032, .026, .250, .091)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, .730, .149, .250, .091)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, .730, .298, .250, .091)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, .717, .877, .250, .091)


	pushToResizer(ctrl, xp, yp, wp, hp)
	{
		ctrl.xp := xp 
		ctrl.yp := yp 
		ctrl.wp := wp 
		ctrl.hp := hp 
	}

	myGui.Show()
	myGui.Maximize()
	}


}	
if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w1241 h1009")
	myGui.Maximize()
}

/**
Constructor()
{	
	myGui := Gui('-DPIScale')
	myGui.SetFont("s20", "Segoe UI")
	myGui.BackColor := "0x525252"
	LV_ := myGui.Add("ListView", "x40 y128 w817 h760 +LV0x4000", ["ListView"])
	myGui.SetFont("s20 Italic", "Segoe UI")
	ButtonOK := myGui.Add("Button", "x40 y24 w310 h83", "&OK")
	myGui.SetFont("s20", "Segoe UI")
	myGui.SetFont("s20 Italic", "Segoe UI")
	ButtonOK := myGui.Add("Button", "x904 y136 w310 h83", "&OK")
	myGui.SetFont("s20", "Segoe UI")
	myGui.SetFont("s20 Italic", "Segoe UI")
	ButtonOK := myGui.Add("Button", "x904 y272 w310 h83", "&OK")
	myGui.SetFont("s20", "Segoe UI")
	myGui.SetFont("s20 Italic", "Segoe UI")
	ButtonOK := myGui.Add("Button", "x888 y800 w310 h83", "&OK")
	LV_.Add(,"Sample1")
	LV_.OnEvent("DoubleClick", LV_DoubleClick)
	ButtonOK.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	
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
		. "ButtonOK => " ButtonOK.Text "`n" 
		. "ButtonOK => " ButtonOK.Text "`n" 
		. "ButtonOK => " ButtonOK.Text "`n" 
		. "ButtonOK => " ButtonOK.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}
*/