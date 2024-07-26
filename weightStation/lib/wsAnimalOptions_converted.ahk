#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>

myCtrls := {}
myGui := Gui(), myGui.Opt("+Resize +MinSize250x150")
myGui.OnEvent("Size", GuiReSizer)
myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
pushToResizer(myCtrls.ButtonOK, .03, .03, .53, .27)
myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
pushToResizer(myCtrls.ButtonOK, .03, .35, .53, .27)
myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
pushToResizer(myCtrls.ButtonOK, .03, .67, .53, .27)
myCtrls.Edit1 := myGui.Add("Edit", "", "NoValue")
pushToResizer(myCtrls.Edit1, .59, .49, .39, .11)
myCtrls.ButtonOK := myGui.Add("Button", "", "&OK")
pushToResizer(myCtrls.ButtonOK, .59, .67, .39, .27)


pushToResizer(ctrl, xp, yp, wp, hp)
{
	ctrl.xp := xp 
	ctrl.yp := yp 
	ctrl.wp := wp 
	ctrl.hp := hp 
}

myGui.Show()
