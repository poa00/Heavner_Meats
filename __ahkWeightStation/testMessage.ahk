

#Requires Autohotkey v2
#Include GuiReSizer.ahk
#Include requests/guiUtils.ahk
#Include CreateImageButton.ahk
#Include UseGDIP.ahk
MainGui := Gui()
MainGui.Show("w500 h500")
childGUI := Gui("+Parent" MainGui.hwnd " -Caption")

;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2
MainGui.Opt("+Resize +ToolWindow +MinSize250x150")
MainGui.OnEvent("Size", GuiReSizer)
childGUI.OnEvent("Size", GuiReSizer)
childGUI.SetFont("s32 cWhite")
MainGui.Cleanup := True
childGUI.Cleanup := True
ogcButtonOK := childGUI.Add("Button", "Default", "&OK")

ogcButtonOK.OnEvent("Click", OnEventHandler)
childGUI.OnEvent('Close', (*) => ExitApp())
childGUI.Title := "Window"
darkMode(MainGui)
MainGUi.backcolor := "Black"
childGUI.backcolor := "Black"
WinSetTransparent 222, "ahk_id " childGUI.hwnd
WinSetTransparent 222, "ahk_id " MainGui.hwnd
ogcButtonOK.WidthP := 0.48
ogcButtonOK.X := 10

childGUI.Show("x0 y0")

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "ogcButtonOK => " ogcButtonOK.Text "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
