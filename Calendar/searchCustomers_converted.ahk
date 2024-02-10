#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>

myCtrls := {}
myGui := Gui(), myGui.Opt("+Resize +MinSize250x150")
myGui.OnEvent("Size", GuiReSizer)
myCtrls.ctrl1 := myGui.Add("Text", "", "")
pushToResizer(myCtrls.ctrl1, .01, .01, .24, .02)
myCtrls.ctrl2 := myGui.Add("Edit", "", "")
myCtrls.ctrl2.Value := "Enter Search Criteria for Customer"
pushToResizer(myCtrls.ctrl2, .03, .09, .52, .05)
myCtrls.buttonClear := myGui.Add("Button", "", "")
myCtrls.buttonClear.Text := "Clear"
pushToResizer(myCtrls.buttonClear, .57, .09, .37, .05)
myCtrls.ListView4 := myGui.Add("ListView", "",[""])
myCtrls.ListView4.GetNext := ""
pushToResizer(myCtrls.ListView4, .03, .16, .91, .94)
myCtrls.ButtonConfirmSelection := myGui.Add("Button", "", "")
myCtrls.ButtonConfirmSelection.Text := "Confirm Selection"
pushToResizer(myCtrls.ButtonConfirmSelection, 1.03, .16, .37, .11)


pushToResizer(ctrl, xp, yp, wp, hp)
{
	ctrl.xp := xp 
	ctrl.yp := yp 
	ctrl.wp := wp 
	ctrl.hp := hp 
}

myGui.Show()
