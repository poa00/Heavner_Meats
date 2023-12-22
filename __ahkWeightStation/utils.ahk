#Requires AutoHotkey v2.0
; DarkMode credit: https://github.com/jNizM/DllExport

purpleBG(Ctrlparams*)
{
    for ctrl in Ctrlparams
    {
        ctrl.Opt("Background5d39c9")
    }
}
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
GetFont(options, fontName)
{
    myGUI := Gui()
    myGUI.SetFont(options, fontName)
    hFont := SendMessage(WM_GETFONT := 0x31, , , myGUI.AddText())
    myGUI.Destroy()
    return hFont
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
        if ctrl.HasOwnProp("NoBack")
            continue
        blackGuiCtrl(myGUI[ctrlHWND])
    }
    ;else
    ;SetExplorerTheme(LV1.hWnd), SetExplorerTheme(LV2.hWnd)

}

IBStyles := Map()
IBStyles["info"] := [[0x80C6E9F4, , , 0, 0x8046B8DA, 1], [0x8086D0E7, , , 0, 0x8046B8DA, 1], [0x8046B8DA, , , 0, 0x8046B8DA, 1], [0xFFF0F0F0, , , 0, 0x8046B8DA, 1]]
IBStyles["success"] := [[0x80C6E6C6, , , 0, 0x805CB85C, 1], [0x8091CF91, , , 0, 0x805CB85C, 1], [0x805CB85C, , , 0, 0x805CB85C, 1], [0xFFF0F0F0, , , 0, 0x805CB85C, 1]]
IBStyles["warning"] := [[0x80FCEFDC, , , 0, 0x80F0AD4E, 1], [0x80F6CE95, , , 0, 0x80F0AD4E, 1], [0x80F0AD4E, , , 0, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 0, 0x80F0AD4E, 1]]
IBStyles["critical"] := [[0x80F0B9B8, , , 0, 0x80D43F3A, 1], [0x80E27C79, , , 0, 0x80D43F3A, 1], [0x80D43F3A, , , 0, 0x80D43F3A, 1], [0xFFF0F0F0, , , 0, 0x80D43F3A, 1]]

IBStyles["info-outline"] := [[0xFFF0F0F0, , , 0, 0x8046B8DA, 1], [0x80C6E9F4, , , 0, 0x8046B8DA, 1], [0x8086D0E7, , , 0, 0x8046B8DA, 1], [0xFFF0F0F0, , , 0, 0x8046B8DA, 1]]
IBStyles["success-outline"] := [[0xFFF0F0F0, , , 0, 0x805CB85C, 1], [0x80C6E6C6, , , 0, 0x805CB85C, 1], [0x8091CF91, , , 0, 0x805CB85C, 1], [0xFFF0F0F0, , , 0, 0x805CB85C, 1]]
IBStyles["warning-outline"] := [[0xFFF0F0F0, , , 0, 0x80F0AD4E, 1], [0x80FCEFDC, , , 0, 0x80F0AD4E, 1], [0x80F6CE95, , , 0, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 0, 0x80F0AD4E, 1]]
IBStyles["critical-outline"] := [[0xFFF0F0F0, , , 0, 0x80D43F3A, 1], [0x80F0B9B8, , , 0, 0x80D43F3A, 1], [0x80E27C79, , , 0, 0x80D43F3A, 1], [0xFFF0F0F0, , , 0, 0x80D43F3A, 1]]

IBStyles["info-round"] := [[0x80C6E9F4, , , 8, 0x8046B8DA, 1], [0x8086D0E7, , , 8, 0x8046B8DA, 1], [0x8046B8DA, , , 8, 0x8046B8DA, 1], [0xFFF0F0F0, , , 8, 0x8046B8DA, 1]]
IBStyles["success-round"] := [[0x80C6E6C6, , , 8, 0x805CB85C, 1], [0x8091CF91, , , 8, 0x805CB85C, 1], [0x805CB85C, , , 8, 0x805CB85C, 1], [0xFFF0F0F0, , , 8, 0x805CB85C, 1]]
IBStyles["warning-round"] := [[0x80FCEFDC, , , 8, 0x80F0AD4E, 1], [0x80F6CE95, , , 8, 0x80F0AD4E, 1], [0x80F0AD4E, , , 8, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 8, 0x80F0AD4E, 1]]
IBStyles["critical-round"] := [[0x80F0B9B8, , , 8, 0x80D43F3A, 1], [0x80E27C79, , , 8, 0x80D43F3A, 1], [0x80D43F3A, , , 8, 0x80D43F3A, 1], [0xFFF0F0F0, , , 8, 0x80D43F3A, 1]]

IBStyles["info-outline-round"] := [[0xFFF0F0F0, , , 8, 0x8046B8DA, 1], [0x80C6E9F4, , , 8, 0x8046B8DA, 1], [0x8086D0E7, , , 8, 0x8046B8DA, 1], [0xFFF0F0F0, , , 8, 0x8046B8DA, 1]]
IBStyles["success-outline-round"] := [[0xFFF0F0F0, , , 8, 0x805CB85C, 1], [0x80C6E6C6, , , 8, 0x805CB85C, 1], [0x8091CF91, , , 8, 0x805CB85C, 1], [0xFFF0F0F0, , , 8, 0x805CB85C, 1]]
IBStyles["warning-outline-round"] := [[0xFFF0F0F0, , , 8, 0x80F0AD4E, 1], [0x80FCEFDC, , , 8, 0x80F0AD4E, 1], [0x80F6CE95, , , 8, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 8, 0x80F0AD4E, 1]]
IBStyles["critical-outline-round"] := [[0xFFF0F0F0, , , 8, 0x80D43F3A, 1], [0x80F0B9B8, , , 8, 0x80D43F3A, 1], [0x80E27C79, , , 8, 0x80D43F3A, 1], [0xFFF0F0F0, , , 8, 0x80D43F3A, 1]]

