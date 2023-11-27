#Requires AutoHotkey v2.0
; DarkMode credit: https://github.com/jNizM/DllExport

MainGui := Gui()
MainGui.Show("w500 h500")

MainGui.SetFont("s32 cWhite")
darkMode(MainGui)
MainGUi.backcolor := "Black"
WinSetTransparent 222, "ahk_id " MainGui.hwnd
MainGui.Show


blackGuiCtrl(params*)
{
    for ctrl in params
    {
        ctrl.Opt("Background000000")
    }
}

mcColorFunc()
{
    return mcColors := {
        MCSC_BACKGROUND: 0,
        MCSC_TEXT: 1,
        MCSC_TITLEBK: 2,
        MCSC_TITLETEXT: 3,
        MCSC_MONTHBK: 4,
        MCSC_TRAILINGTEXT: 5
    }
}
darkMode(myGUI)
{
    if (VerCompare(A_OSVersion, "10.0.17763") >= 0)
    {
        DWMWA_USE_IMMERSIVE_DARK_MODE := 19
        if (VerCompare(A_OSVersion, "10.0.18985") >= 0)
        {
            DWMWA_USE_IMMERSIVE_DARK_MODE := 20
        }
        DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", myGUI.hWnd, "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", true, "Int", 4)
        ; listView => SetExplorerTheme(LV1.hWnd, "DarkMode_Explorer"), SetExplorerTheme(LV2.hWnd, "DarkMode_Explorer")
        uxtheme := DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr")
        DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr"), "Int", 2) ; ForceDark
        DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr"))
    }
    for ctrlHWND, ctrl in myGUI
    {
        blackGuiCtrl(myGUI[ctrlHWND])
    }
    ;else
    ;SetExplorerTheme(LV1.hWnd), SetExplorerTheme(LV2.hWnd)

}