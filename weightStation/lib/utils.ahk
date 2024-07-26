#Requires AutoHotkey v2.0

userPath := A_ScriptDir "\requests\users.json"
responsePath := A_ScriptDir "\requests\response.json"

idleVar := 16

ip := "127.0.0.1"
port := "5613"
/*
    this.username := username
    this.password := pw
    this.tier := tier
*/

/*
    if A_TimeIdle < 300000
    {
        return false
    }  else {
        writer(authpath, "")
        SetTimer(CheckIdleTime, 0)
        MainGui.Restore()
        return true
    }
*/

/*
    user['SessionActive'] := true
    user['LastActive'] := A_TimeIdleKeyboard < A_TimeIdleMouse ? A_TimeIdleKeyboard : A_TimeIdleMouse
    writer(authpath, jsons.dumps(user))

    return user := {user['username'], pin: user['pin'], tier: user['tier']}
*/

purpleBG(params*)
{
    for ctrl in params
    {
        ctrl.Opt("Background5d39c9")
    }
}
darkGuiCtrl(params*)
{
    for ctrl in params
    {
        ctrl.Opt("Background1c1c1c")
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
SetMonthCalFont(options, fontName, ctrl)
{
    DllCall('UxTheme\SetWindowTheme', 'Ptr', ctrl.hwnd, 'Ptr', 0, 'Str', '')
    SendMessage WM_SETFONT := 0x30, GetFont(options, fontName), true, ctrl

    GetFont(options, fontName)
    {
        myGUI := Gui()
        myGUI.SetFont(options, fontName)
        hFont := SendMessage(WM_GETFONT := 0x31, , , myGUI.AddText())
        myGUI.Destroy()
        return hFont
    }
}

AdjustMonthCal(rows, columns, ctrl)
{
    rect := Buffer(16, 0)
    SendMessage MCM_GETMINREQRECT := 0x1009, , rect, ctrl
    width := NumGet(rect, 8, 'Int') * 96 // A_ScreenDPI
    height := NumGet(rect, 12, 'Int') * 96 // A_ScreenDPI
    ctrl.Move(, , width * columns, height * (0.91 * (rows - 1) + 1))
}

SetMonthCalColor(colorRGB, part, ctrl)
{
    colorBGR := colorRGB >> 16 | colorRGB & 0xFF00 | (colorRGB & 0xFF) << 16
    SendMessage MCM_SETCOLOR := 0x100A, part, colorBGR, ctrl
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
    for hwnd, guictrl in myGUI
    {
        darkGuiCtrl(guictrl)
    }
    ;else
    ;SetExplorerTheme(LV1.hWnd), SetExplorerTheme(LV2.hWnd)

}
