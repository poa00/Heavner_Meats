wnd := Gui()
MonthCal := wnd.AddMonthCal('4 R4 W-3') ; wnd.AddMonthCal('4 R3 W-4')
DllCall('UxTheme\SetWindowTheme', 'Ptr', MonthCal.hwnd, 'Ptr', 0, 'Str', ';')
SendMessage WM_SETFONT := 0x30, GetFont('s24 bold', 'Tahoma'), true, MonthCal
wnd.Show("w800 h900")

GetFont(options, fontName) {
    wnd := Gui()
    wnd.SetFont(options, fontName)
    hFont := SendMessage(WM_GETFONT := 0x31,,, wnd.AddText())
    wnd.Destroy()
    return hFont
}