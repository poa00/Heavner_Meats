wnd := Gui()
rows := 3
columns := 4
MonthCal := wnd.AddMonthCal('4 R' . rows . ' W-' . columns)
SetMonthCalFont('s20 bold', 'Tahoma', MonthCal)
AdjustMonthCal(rows, columns, MonthCal)

mcColors := {
    MCSC_BACKGROUND  : 0,
    MCSC_TEXT        : 1,
    MCSC_TITLEBK     : 2,
    MCSC_TITLETEXT   : 3,
    MCSC_MONTHBK     : 4,
    MCSC_TRAILINGTEXT: 5
}
SetMonthCalColor(0x0099DD, mcColors.MCSC_TITLEBK, MonthCal)

wnd.Show('AutoSize')

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