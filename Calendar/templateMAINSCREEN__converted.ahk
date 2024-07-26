#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>

myCtrls := {}
myGui := Gui(), myGui.Opt("+Resize +MinSize250x150")
myGui.OnEvent("Size", GuiReSizer)
myCtrls.Hotkey1 := myGui.Add("Hotkey", "", "")
pushToResizer(myCtrls.Hotkey1, .00, .00, 5.06, 4.89)
myCtrls.MonthCal2 := myGui.Add("MonthCal", "", "")
pushToResizer(myCtrls.MonthCal2, .05, .06, 1.26, 2.26)
myCtrls.ListView3 := myGui.Add("ListView", "",[" "])
pushToResizer(myCtrls.ListView3, 1.36, .06, 1.36, 1.13)
myCtrls.ctrl4 := myGui.Add("GroupBox", "", "Selected Week")
pushToResizer(myCtrls.ctrl4, 1.36, 1.22, .48, .75)
myCtrls.ctrl5 := myGui.Add("Text", "", "15")
pushToResizer(myCtrls.ctrl5, 1.38, 1.28, .43, .45)
myCtrls.ButtonADD := myGui.Add("Button", "", "+ ADD")
pushToResizer(myCtrls.ButtonADD, 1.89, 1.22, .17, .26)
myCtrls.ButtonDetails := myGui.Add("Button", "", "Details")
pushToResizer(myCtrls.ButtonDetails, 2.06, 1.22, .17, .26)
myCtrls.ButtonDelete := myGui.Add("Button", "", "Delete")
pushToResizer(myCtrls.ButtonDelete, 2.23, 1.22, .17, .26)


pushToResizer(ctrl, xp, yp, wp, hp)
{
	ctrl.xp := xp 
	ctrl.yp := yp 
	ctrl.wp := wp 
	ctrl.hp := hp 
}

myGui.Show()