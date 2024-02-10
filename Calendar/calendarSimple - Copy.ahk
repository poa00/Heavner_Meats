#SingleInstance Force

wnd := Gui()
mcColors := mcCo()
wnd.BackColor := "0x373737"
wnd.SetFont("c0x254426")
MonthCal := wnd.AddMonthCal('4 R4 W-3') ; wnd.AddMonthCal('4 R3 W-4')
SendMessage WM_SETFONT := 0x30, GetFont('s24 bold', 'Tahoma'), true, MonthCal
DllCall('UxTheme\SetWindowTheme', 'Ptr', MonthCal.hwnd, 'Ptr', 0, 'Str', ';')
darkMode()
wnd.Show("h900")

; Week := SubStr(A_YWeek, -2)

/*
ToolTip("Click! This is a sample action.`n"
. "Active GUI element values include:`n"  
. "MonthCal1 => " MonthCal1.Value "`n", 77, 277)
SetTimer () => ToolTip(), -3000 ; tooltip timer
*/



mcCo(){
    return mcColors := {
        MCSC_BACKGROUND  : 0,
        MCSC_TEXT        : 1,
        MCSC_TITLEBK     : 2,
        MCSC_TITLETEXT   : 3,
        MCSC_MONTHBK     : 4,
        MCSC_TRAILINGTEXT: 5
    }
}
GetFont(options, fontName) {
    wnd := Gui()
    wnd.SetFont(options, fontName)
    hFont := SendMessage(WM_GETFONT := 0x31,,, wnd.AddText())
    wnd.Destroy()
    return hFont
}
SetMonthCalFont(options, fontName, ctrl) {
    DllCall('UxTheme\SetWindowTheme', 'Ptr', ctrl.hwnd, 'Ptr', 0, 'Str', '')
    SendMessage WM_SETFONT := 0x30, GetFont(options, fontName), true, ctrl

    GetFont(options, fontName) {
        wnd := Gui()
        wnd.SetFont(options, fontName)
        hFont := SendMessage(WM_GETFONT := 0x31,,, wnd.AddText())
        wnd.Destroy()
        return hFont
    }
}

AdjustMonthCal(rows, columns, ctrl) {
    rect := Buffer(16, 0)
    SendMessage MCM_GETMINREQRECT := 0x1009,, rect, ctrl
    width := NumGet(rect, 8, 'Int') * 96 // A_ScreenDPI
    height := NumGet(rect, 12, 'Int') * 96 // A_ScreenDPI
    ctrl.Move(,, width * columns, height * (0.91 * (rows - 1) + 1))
}

SetMonthCalColor(colorRGB, part, ctrl) {
    colorBGR := colorRGB >> 16 | colorRGB & 0xFF00 | (colorRGB & 0xFF) << 16
    SendMessage MCM_SETCOLOR := 0x100A, part, colorBGR, ctrl
}


darkMode(){
    if (VerCompare(A_OSVersion, "10.0.17763") >= 0)
        {
            DWMWA_USE_IMMERSIVE_DARK_MODE := 19
            if (VerCompare(A_OSVersion, "10.0.18985") >= 0)
            {
                DWMWA_USE_IMMERSIVE_DARK_MODE := 20
            }
            DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", wnd.hWnd, "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", true, "Int", 4)
            ; listView => SetExplorerTheme(LV1.hWnd, "DarkMode_Explorer"), SetExplorerTheme(LV2.hWnd, "DarkMode_Explorer")
            uxtheme := DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr")
            DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr"), "Int", 2) ; ForceDark
            DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr"))
        }
        ;else
            ;SetExplorerTheme(LV1.hWnd), SetExplorerTheme(LV2.hWnd)
    
}
