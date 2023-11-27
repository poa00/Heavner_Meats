calendarParentGUI := Gui()
calendarParentGUI.Show("w500 h400")

childOne := Gui("+Parent" calendarParentGUI.hwnd " -Caption")
childOneNextButton := childOne.Add("Button", "w100 h60", "Click for gui 2")

; a bunch of controls
childOne.Add("Edit", "w250 h300", "lorem ipsum")
childOne.Add("Button", "x+10 w100 h30", "Button1 1")
childOne.Add("Button", "w100 h30", "Button1 2")
childOne.Add("Button", "w100 h30", "Button1 3")

childOne.Show("x0 y0") ; position relative to parent gui

childTwo := Gui("+Parent" calendarParentGUI.hwnd " -Caption")
childOneNextButton.OnEvent("Click", NextGui.Bind(childTwo)) ; when this button is click, go to gui 2.

childTwoNextButton := childTwo.Add("Button", "w100 h60", "Click for gui 1")
LV := childTwo.Add("ListView", "grid r10 w400", ["test"])
loop 10 { ; fill listview with random numbers
    r := Random(1, 100000)
    LV.Add(, r)
}
childTwo.Show("x0 y0 hide")

childTwoNextButton.OnEvent("Click", NextGui.Bind(childOne)) ; go to gui 1.

NextGui(nextGui, guiCtrl, *) {
    guiCtrl.Gui.Hide()
    nextGui.Show()
}
