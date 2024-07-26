#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>


if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := AnimalManager()
	myGui.Show("w1241 h1009")
	myGui.Maximize()
}

class AnimalManager
{
	static Call()
	{
		myCtrls := {}
		myGui := Gui(), myGui.Opt("+Resize +MinSize250x150")
		myGui.SetFont('s22')
		myGui.BackColor := 0x3b3b3b
		myGui.OnEvent("Size", GuiReSizer)
		myCtrls.ListView1 := myGui.Add("ListView", "", [" "])
		pushToResizer(myCtrls.ListView1, 0.032, 0.140, 0.659, 0.833)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, 0.032, 0.026, 0.250, 0.091)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, 0.730, 0.149, 0.250, 0.091)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, 0.730, 0.298, 0.250, 0.091)
		myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
		pushToResizer(myCtrls.ButtonOK, 0.717, 0.877, 0.250, 0.091)
		
		myGui.Show()
		myGui.Maximize()
		
		pushToResizer(ctrl, xp, yp, wp, hp)
		{
			ctrl.xp := xp
			ctrl.yp := yp
			ctrl.wp := wp
			ctrl.hp := hp
		}
		return mygui
	}
}