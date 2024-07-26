

a := A_ScriptDir
eventsFile := a "\events.json"
pendingEventFile := A_MyDocuments "\pendingEvent.json"
calendarLog := A_MyDocuments "\util\calendar_log.txt"
config := a "\util\config.json"
message := a "\util\message.json"

/*
gui container
*/
calendarParentGUISetup()
{
    darkMode(calendarParentGUI)
    calendarParentGUI.BackColor := "0x575151"
    return calendarParentGUI
}
/*
gui calendar
*/
calendarChildSetup(calendarParentGUI)
{
    global currentWeek, MonthCal, x, y, selectWeekNumber
    calendarChild := Gui("+Parent" calendarParentGUI.hwnd " -Caption -DPIScale")
    mcColors := mcColorFunc()
    calendarChild.BackColor := "0x373737"
    calendarChild.SetFont("c0x254426 s22")
    ;MonthCal := calendarChild.AddMonthCal('4 R5 WP-4') ; calendarChild.AddMonthCal('4 R3 W-4')
    MonthCal := calendarChild.AddMonthCal('4 R5 WP-3') ; calendarChild.AddMonthCal('4 R3 W-4')
    SetMonthCalFont('s19', 'Tahoma', MonthCal)
    MonthCal.GetPos(&calX, &calY, &calW, &calH)
    xPos := calX + calW + 50
    endCal := calY + calH
    focusDetailsWidth := xPos / 2 - 20
    focusDetailsWidth := focusDetailsWidth - 210
    yPos := calY + (calH / 2) + 20

    global eventMenu := calendarChild.Add("ListView", "grid x" xPos " y" calY " w" xPos " h" calH / 2, ["Customer", "Cows", "Pigs", "CustomerID", "ID"])
    GroupBoxselectedWeekOutline := calendarChild.Add("GroupBox", "x" xPos " y" yPos " w" focusDetailsWidth " h" calH / 3, 'Selected Week')
    GroupBoxselectedWeekOutline.SetFont("cWhite")
    selectWeekNumber := calendarChild.Add("Text", "xp+20" " yp+80" " w" focusDetailsWidth - 50 " h" calH / 5, 'Selected Week')

    selectWeekNumber.SetFont("cWhite s100")
    eventMenu.SetFont("c0x7165f7")
    buttonWidth := 190
    buttonX := xPos + focusDetailsWidth
    AddButton := calendarChild.Add("Button", "w" buttonWidth " h170 x" buttonX + 60 " y" yPos, "+ ADD")
    DetailsButton := calendarChild.Add("Button", "w" buttonWidth " h170 x" buttonX + buttonWidth + 60 " y" yPos, "Details")
    DeleteButton := calendarChild.Add("Button", "w" buttonWidth " h170 x" buttonX + buttonWidth * 2 + 60 " y" yPos, "Delete")

    purpleBG(AddButton, DetailsButton, DeleteButton)
    blackBG(eventMenu)
    SendMessage WM_SETFONT := 0x30, GetFont('s22 bold', 'Tahoma'), true, MonthCal
    DllCall('UxTheme\SetWindowTheme', 'Ptr', MonthCal.hwnd, 'Ptr', 0, 'Str', ';')

    MonthCal.OnEvent("Change", Click_MonthCal)
    eventMenu.OnEvent("Click", Click_Menu)
    AddButton.OnEvent("Click", Click_Add)
    DetailsButton.OnEvent("Click", Click_Details)
    DeleteButton.OnEvent("Click", Click_Delete)
    return calendarChild
}
/*
change day of the month, retreive week, and update list of events based on weeks
*/
Click_MonthCal(*)
{
    global selectWeekNumber, currentWeek, year
    static lastSelection := ""
    yearWeek := FormatTime(MonthCal.Value, "YWeek")
    selectedWeek := SubStr(yearWeek, -2)
    if lastSelection = selectedWeek
        return
    lastSelection := selectedWeek
    selectWeekNumber.Text := selectedWeek
    year := FormatTime(MonthCal.Value, "yyyy")
    if (selectedWeek != currentWeek)
    {
        currentWeek := selectedWeek
        setWeekEvents(yearWeek)
    }
}

/*
; This function handles the click event of the menu.
; Parameters:
;   - None
; Returns:
;   - None
*/
Click_Menu(*)
{
}

/*
    Click_Add(*)
    This function is responsible for handling the click event on the "Add" button.
    It retrieves the current week number and calls the show_addevent function to display the add event form.
*/
Click_Add(*)
{
    global currentWeek
    yearWeek := FormatTime(MonthCal.Value, "YWeek")
    currentWeek := SubStr(yearWeek, -2)
    show_addevent(currentWeek)
}
Click_Delete(*)
{
    FocusedRowNumber := eventMenu.GetNext(0, "F")
    if not FocusedRowNumber  ; No row is focused.
        return
    userResponse := MsgBox("Confirm: Would you like to delete? ", "Remove", "262164")
    if (userResponse = "Yes") {
        try response := requests.Del(eventMenu.GetText(FocusedRowNumber, 5))
        try Msgbox response['message']
        catch as e
            Msgbox e.message
        setWeekEvents(year selectWeekNumber.Value)
    } else if (userResponse = "No") {
        return
    }
}

Click_Details(params*) => show_details(params*)

initEvents()
{
    global currentWeek, selectWeekNumber, year
    yearWeek := FormatTime(MonthCal.Value, "YWeek")
    year := FormatTime(MonthCal.Value, "yyyy")
    currentWeek := SubStr(yearWeek, -2)
    ; Load Events from JSON / SQL
    selectWeekNumber.Text := currentWeek

    setWeekEvents(yearWeek)
}


/*
    This function sets the events for a given week in the eventMenu.
    It loads events from a JSON file and adds them to the eventMenu if they match the setWeek parameter.
    If there are any errors while creating the event, it displays an error message.
    Parameters:
        setWeek (string): The week for which events need to be set.
        eventMenu (object): The menu object to which events need to be added.
*/
setWeekEvents(yearWeek)
{
    global eventMenu
    try {
        requests.appName := "events"
        eventMaps := requests.GetUrl("events/by-week/" yearWeek)
    } catch as e {
        MsgBox("error getting events from api")
        return
    }
    static errorMsg := False
    listCount := false
    eventMenu.Delete
    errors := ""
    if not IsObject(eventMaps)
        return
    for eventMap in eventMaps
    {
        if IsObject(eventMap)
        {
            week := SubStr(eventMap["yweek"], 5, 2)
            if (week == SubStr(yearWeek, -2))
            {
                eventMenu.Add(, eventMap['customer']["full_name"], eventMap["cows"], eventMap["pigs"], eventMap["customer"]['id'], eventMap["id"])
                eventMenu.ModifyCol(1, "500")
                ;eventMenu.ModifyCol(2, "99")
                ;eventMenu.ModifyCol(3, "99")
                eventMenu.ModifyCol(4, "25")
                eventMenu.ModifyCol(5, "99")
                listCount := true
            }
        }
        ;
        ;     errors .= "error creating event due to columns or rows at line " A_Index "`n" e.message
        ;
    }
    if listCount
    {
        Settimer () => eventMenu.Modify(1, "Select"), -100
        Settimer () => eventMenu.Modify(1, "Focus"), -100
    }
    if errors != "" && errorMsg == False
    {
        Msgbox(errors)
        errorMsg := True
    }
}

/*
    This function creates an add event dialog box in the calendarParentGUI.
    It allows the user to enter details of a new event and add it to the eventMenu.
    Parameters:
        calendarParentGUI (object): The main GUI object in which the add event dialog box needs to be created.
*/
createAddEvent(calendarParentGUI)
{
    return addEventGUI := addEvent.GUI(calendarParentGUI)
}