

class sJson
{
    static LoadEvents(filepath := eventsFile) {
        j := FileRead(filepath)
        obj := jsons.loads(&j)
        return obj
    }
    static SaveEvents(filepath, obj) {
        jstring := jsons.dumps(obj)
        writer(filepath, jstring)
    }
}





/*
@example
        # calling DLL from CLR with API_Post
            API_post("create",  m := Map(
                                        "customer", custID, 
                                        "week", weekNumber, 
                                        "cows", cowCount,
                                        "pigs", PigCount, 
                                        "lambs", LambCount
                                        )) => 
            MyHttpClient("localhost", "5613", "calendar", "create", config, message, response)
                message.json {"customerID":42893}
*/


/*
API_post(action, preJSONmap)

Sends an HTTP POST request to the calendar API with the specified action and preJSONmap.

Parameters:
- action (string): The action to perform on the calendar API.
- preJSONmap (object): The data to send in the request body as a JSON object.

Returns:
- The response from the calendar API.

Example usage:
response := API_post("create_event", {"title": "Meeting", "start_time": "2022-01-01T10:00:00", "end_time": "2022-01-01T11:00:00"})
*/

; API_post(action, preJSONmap)
; {
;     static a := A_ScriptDir
;     static config := a "\util\config.json"
;     static message := a "\util\message.json"
;     static response := a "\util\response.json"
;     static asm := CLR_LoadLibrary(A_ScriptDir "\util\requests.dll")
;     static obj := CLR_CreateObject(asm, "Program")

;     jdata := jsons.Dumps(preJSONmap)
;     FileOpen(message, "w").Write(jdata)
;     return obj.MyHttpClient("localhost", "5613", "calendar", action, message, response)
; }

/*
    This function creates a new event object with the given parameters and returns it as a map.
    @param cowCount: The number of cows for the event.
    @param pigCount: The number of pigs for the event.
    @param lambCount: The number of lambs for the event.
    @param weekNumber: The week number for the event.
    @return: A map object containing the event details.
*/
eventArrayPush(cowCount, pigCount, lambCount, weekNumber)
{
    m := Map()
    return m.Set(
        "customer", addEvent.editValues.customerID.Value,
        "customer", addEvent.editValues.customerName.Value,
        "customerAddress", addEvent.editValues.customerAddress.Value,
        "cows", cowcount,
        "pigs", pigcount,
        "lambs", lambcount,
        "notes", addEvent.editValues.notes.Value,
        "week", weekNumber
    )
}






purpleBG(params*) {
    for ctrl in params {
        ctrl.Opt("Background5d39c9")
    }
}
blackBG(params*) {
    for ctrl in params {
        ctrl.Opt("Background000000")
    }
}

mcColorFunc() {
    return mcColors := {
        MCSC_BACKGROUND: 0,
        MCSC_TEXT: 1,
        MCSC_TITLEBK: 2,
        MCSC_TITLETEXT: 3,
        MCSC_MONTHBK: 4,
        MCSC_TRAILINGTEXT: 5
    }
}
GetFont(options, fontName) {
    myGUI := Gui()
    myGUI.SetFont(options, fontName)
    hFont := SendMessage(WM_GETFONT := 0x31, , , myGUI.AddText())
    myGUI.Destroy()
    return hFont
}
SetMonthCalFont(options, fontName, ctrl) {
    DllCall('UxTheme\SetWindowTheme', 'Ptr', ctrl.hwnd, 'Ptr', 0, 'Str', '')
    SendMessage WM_SETFONT := 0x30, GetFont(options, fontName), true, ctrl

    GetFont(options, fontName) {
        myGUI := Gui()
        myGUI.SetFont(options, fontName)
        hFont := SendMessage(WM_GETFONT := 0x31, , , myGUI.AddText())
        myGUI.Destroy()
        return hFont
    }
}

AdjustMonthCal(rows, columns, ctrl) {
    rect := Buffer(16, 0)
    SendMessage MCM_GETMINREQRECT := 0x1009, , rect, ctrl
    width := NumGet(rect, 8, 'Int') * 96 // A_ScreenDPI
    height := NumGet(rect, 12, 'Int') * 96 // A_ScreenDPI
    ctrl.Move(, , width * columns, height * (0.91 * (rows - 1) + 1))
}

SetMonthCalColor(colorRGB, part, ctrl) {
    colorBGR := colorRGB >> 16 | colorRGB & 0xFF00 | (colorRGB & 0xFF) << 16
    SendMessage MCM_SETCOLOR := 0x100A, part, colorBGR, ctrl
}


darkMode(myGUI) {
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
    ;else
    ;SetExplorerTheme(LV1.hWnd), SetExplorerTheme(LV2.hWnd)

}