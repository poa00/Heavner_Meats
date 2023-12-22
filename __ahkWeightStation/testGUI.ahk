#Requires Autohotkey v2
#SingleInstance force

#Include GuiReSizer.ahk
SetWinDelay(-1)

MainGui := Gui()
MainGui.Show("w500 h500")
childGUI := Gui("+Parent" MainGui.hwnd " -Caption")
MainGui.Opt("+Resize +ToolWindow +MinSize250x150")
MainGui.OnEvent("Size", GuiReSizer)
childGUI.OnEvent("Size", GuiReSizer)
ogcButtonOK := childGUI.Add("Button", "Default", "&OK")

ogcButtonOK.WidthP := 0.48
ogcButtonOK.X := 10 
childGUI.Show("x0 y0")

childGui.Maximize()
MainGui.Child := childGUI
MainGui.OnEvent("Size", childGUISize)
childGUISize(GuiObj, WindowMinMax, GuiW, GuiH)
{
	GuiObj.Child.Move(, , GuiW, GuiH)
}