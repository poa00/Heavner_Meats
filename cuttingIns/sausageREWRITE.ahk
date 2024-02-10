#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>

myCtrls := {}
myGui := Gui(), myGui.Opt("+Resize +MinSize250x150")
myGui.OnEvent("Size", GuiReSizer)
myCtrls.ctrl1 := myGui.Add("GroupBox", "", "")
pushToResizer(myCtrls.ctrl1, .01, .01, .97, .36)
myCtrls.ctrl2 := myGui.Add("DDL", "", [""])
pushToResizer(myCtrls.ctrl2, .03, .08, .44, .03)
myCtrls.ctrl3 := myGui.Add("DDL", "", [""])
pushToResizer(myCtrls.ctrl3, .49, .08, .44, .03)
myCtrls.quantity := myGui.Add("Edit", "", "")
myCtrls.quantity.Value := "50"
pushToResizer(myCtrls.quantity, .03, .19, .22, .07)
myCtrls.units := myGui.Add("Text", "", "")
pushToResizer(myCtrls.units, .26, .19, .03, .07)
myCtrls.priority := myGui.Add("CheckBox", "", "")
pushToResizer(myCtrls.priority, .31, .19, .11, .07)
myCtrls.ctrl7 := myGui.Add("DDL", "", [""])
pushToResizer(myCtrls.ctrl7, .49, .19, .45, .03)
myCtrls.up := myGui.Add("Button", "", "")
myCtrls.up.Text := "More+"
pushToResizer(myCtrls.up, .03, .28, .14, .07)
myCtrls.dn := myGui.Add("Button", "", "")
myCtrls.dn.Text := "Less-"
pushToResizer(myCtrls.dn, .17, .28, .14, .07)
myCtrls.addToOrder := myGui.Add("Button", "", "")
myCtrls.addToOrder.Text := "Add to Order"
pushToResizer(myCtrls.addToOrder, .50, .28, .44, .07)
myCtrls.ctrl11 := myGui.Add("GroupBox", "", "")
pushToResizer(myCtrls.ctrl11, .01, .36, .97, .45)
myCtrls.ListView12 := myGui.Add("ListView", "",[""])
pushToResizer(myCtrls.ListView12, .02, .42, .74, .37)
myCtrls.ButtonCancel := myGui.Add("Button", "", "")
myCtrls.ButtonCancel.Text := "Cancel"
pushToResizer(myCtrls.ButtonCancel, .40, .84, .18, .09)
myCtrls.viewGring := myGui.Add("Button", "", "")
myCtrls.viewGring.Text := "View Grind"
pushToResizer(myCtrls.viewGring, .59, .84, .18, .09)
myCtrls.Finished := myGui.Add("Button", "", "")
myCtrls.Finished.Text := "Finished"
pushToResizer(myCtrls.Finished, .78, .84, .18, .09)
myCtrls.remove := myGui.Add("Button", "", "")
myCtrls.remove.Text := "Remove"
pushToResizer(myCtrls.remove, .79, .42, .15, .08)
myCtrls.priority := myGui.Add("GroupBox", "", "")
pushToResizer(myCtrls.priority, .79, .50, .15, .25)
myCtrls.Button18 := myGui.Add("Button", "", "")
myCtrls.Button18.Text := "?"
pushToResizer(myCtrls.Button18, .81, .56, .12, .08)
myCtrls.Button19 := myGui.Add("Button", "", "")
myCtrls.Button19.Text := "?"
pushToResizer(myCtrls.Button19, .81, .64, .12, .08)


pushToResizer(ctrl, xp, yp, wp, hp)
{
	ctrl.xp := xp 
	ctrl.yp := yp 
	ctrl.wp := wp 
	ctrl.hp := hp 
}

myGui.Show()
