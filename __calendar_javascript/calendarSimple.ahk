#SingleInstance Force
#Include customers.ahk
#Include _JSONS.ahk
#Include addEvent.ahk

mainGUI := GUIs.mainGUI()
calendarMain := GUIs.calendarMain(mainGUI)
addEventGUI := GUIs.createAddEvent(mainGUI)



class GUIs
{
    /*
    gui container
    */
    static mainGUI()
    {
        mainGUI := Gui()
        darkMode(mainGUI)
        mainGUI.BackColor := "0x373737"
        mainGUI.Show("h600 w1300")
        return mainGUI
    }
    /*
    gui calendar
    */
    static calendarMain(mainGUI)
    {
        global currentWeek
        calendarMain := Gui("+Parent" mainGUI.hwnd " -Caption -DPIScale")
        mcColors := mcColorFunc()
        calendarMain.BackColor := "0x373737"
        calendarMain.SetFont("c0x254426 s16")
        MonthCal := calendarMain.AddMonthCal('4 R3 WP-3') ; calendarMain.AddMonthCal('4 R3 W-4')
        global eventMenu := calendarMain.Add("ListView", "grid x+m HP-48 w420", ["Customer", "Order", " ID"])

        ; eventMenu := calendarMain.Add("ListBox", "x+m HP-48 w420", ["123 Farms, 300 cows, 2000k lbs","321 Farms, 300 pigs, 1200k lbs","999 Farms, 300 birds, 1000k lbs","abc Farms, 300 eagles, 1000k lbs"])

        eventMenu.SetFont("c0x7165f7")
        AddButton := calendarMain.Add("Button", "w180 h45", "+ ADD")
        DetailsButton := calendarMain.Add("Button", "x+10 w180 h45", "Details")
        
        purpleBG(AddButton, DetailsButton)
        blackBG(eventMenu)
        SendMessage WM_SETFONT := 0x30, GetFont('s24 bold', 'Tahoma'), true, MonthCal
        DllCall('UxTheme\SetWindowTheme', 'Ptr', MonthCal.hwnd, 'Ptr', 0, 'Str', ';')
        darkMode(calendarMain)
        
        MonthCal.OnEvent("Change", Click_MonthCal)
        eventMenu.OnEvent("Click", Click_Menu)
        AddButton.OnEvent("Click", Click_Add)
        DetailsButton.OnEvent("Click", Click_Add)
        initEvents()

        /*
        change day of the month, retreive week, and update list of events based on weeks
        */
        Click_MonthCal(*)
        {
            yearWeek := FormatTime(MonthCal.Value, "YWeek")
            selectedWeek := SubStr(yearWeek, -2)
            if (selectedWeek != currentWeek)
            {
                currentWeek := selectedWeek
                GUIs.setWeekEvents(selectedWeek, &eventMenu)
            }
        }

        Click_Menu(*)
        {
            /*
            eventMenu.Add(, "animalBox.Text" , "cutsBox.Text", "subcut.Text")
            eventMenu.ModifyCol(3)
            eventMenu.ModifyCol(2)
            eventMenu.ModifyCol(1, "200 Auto")
            */
        }

        Click_Add(*)
        {
            global currentWeek
            yearWeek := FormatTime(MonthCal.Value, "YWeek")
            currentWeek := SubStr(yearWeek, -2)
            show_addevent(currentWeek)
        }
        Click_Details(*)
        {
            show_details()
        }

        initEvents()
        {
            global currentWeek
            yearWeek := FormatTime(MonthCal.Value, "YWeek")
            currentWeek := SubStr(yearWeek, -2)
            GUIs.setWeekEvents(currentWeek, &eventMenu)
        }

        calendarMain.Show()
        return calendarMain
    }
    static setWeekEvents(setWeek, &eventMenu)
    {
        obj := LoadEvents.Json()
        for week, events in obj
        {
            if (week == setWeek)
            {
                eventMenu.Delete
                for eventMap in events
                {
                    eventMenu.Add(, eventMap["customer"] , eventMap["details"] "s", eventMap["eventID"])
                    eventMenu.ModifyCol(3)
                    eventMenu.ModifyCol(2)
                    eventMenu.ModifyCol(1, "200 Auto")
                }
                break
            }
        }

    }

    static createAddEvent(mainGUI){
        return addEventGUI := addEvent.GUI(mainGUI)
    }
}

class LoadEvents
{
    static Json(){
        j := FileRead(A_ScriptDir "\events.json")
        obj := Jsons.Loads(&j)
        return obj
    }
}


show_addevent(currentWeek){
    ; FocusedRowNumber := eventMenu.GetNext(0, "F")  ; Find the focused row. 
    calendarMain.Hide()
    insertData(currentWeek)
    addEventGUI.Show()
}

show_details(){
    FocusedRowNumber := eventMenu.GetNext(0, "F")  ; Find the focused row.
    if not FocusedRowNumber  ; No row is focused.
        return
    else 
        msgbox(eventMenu.GetText(FocusedRowNumber))
    calendarMain.Hide()
    addEventGUI.Show()
}

show_calendar(){
    calendarMain.Show()
    addEventGUI.Hide()
}


reader(path, full:=false){
    if full == false
    {
        path := A_ScriptDir "\" path
    }
    F := FileOpen(path, "r")
    str := F.Read()
    F.Close()
    return str
}

writer(path, strToWrite, full:=false){
    if full == false
    {
        path := A_ScriptDir "\" path
    }
    F := FileOpen(path, "w")
    F.Write(strToWrite)
    F.Close()
    return
}








; Week := SubStr(A_YWeek, -2)

/*
ToolTip("Click! This is a sample action.`n"
. "Active GUI element values include:`n"  
. "MonthCal1 => " MonthCal1.Value "`n", 77, 277)
SetTimer () => ToolTip(), -3000 ; tooltip timer
*/

purpleBG(params*){
    for ctrl in params {
        ctrl.Opt("Background5d39c9")
    }
}
blackBG(params*){
    for ctrl in params {
        ctrl.Opt("Background000000")
    }
}

mcColorFunc(){
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
    myGUI := Gui()
    myGUI.SetFont(options, fontName)
    hFont := SendMessage(WM_GETFONT := 0x31,,, myGUI.AddText())
    myGUI.Destroy()
    return hFont
}
SetMonthCalFont(options, fontName, ctrl) {
    DllCall('UxTheme\SetWindowTheme', 'Ptr', ctrl.hwnd, 'Ptr', 0, 'Str', '')
    SendMessage WM_SETFONT := 0x30, GetFont(options, fontName), true, ctrl

    GetFont(options, fontName) {
        myGUI := Gui()
        myGUI.SetFont(options, fontName)
        hFont := SendMessage(WM_GETFONT := 0x31,,, myGUI.AddText())
        myGUI.Destroy()
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


darkMode(myGUI){
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
