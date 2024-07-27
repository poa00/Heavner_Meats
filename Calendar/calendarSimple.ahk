/*
This script is a simple calendar application written in AutoHotkey. It includes a GUI with a calendar and a list of events for each week. Users can add new events to the calendar and view details of existing events. The application reads and writes event data to a JSON file.

The script includes several classes, including GUIs and Json, which are used to create and manage the GUI and handle JSON data, respectively.

The script also includes several functions, including show_calendar, show_addevent, and show_details, which are used to display the appropriate GUI based on user actions.

To use the script, run it in AutoHotkey and interact with the GUI to add and view events.
*/

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;    get debug val from NEW CALENDAR EVENT api route
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


#SingleInstance Force
#Include customers.ahk
#Include JSONS.ahk
#Include addEvent.ahk
#Include calendarUtil.ahk
#Include requests/request.ahk
#Include searchCustomers.ahk
port := 5613
ip := "localhost"
app := "calendar"

;constants
a := A_ScriptDir
eventsFile := a "\events.json"
pendingEventFile := A_MyDocuments "\pendingEvent.json"
calendarLog := A_MyDocuments "\util\calendar_log.txt"
config := a "\util\config.json"
message := a "\util\message.json"

x := SysGet(16)
y := SysGet(17)
calendarParentGUI := Gui("-DPIScale")
calendarParentGUISetup()
calendarParentGUI.Show("h" y " w" x "")
calendarChild := calendarChildSetup(calendarParentGUI)
addEventGUI := createAddEvent(calendarParentGUI)

darkMode(calendarChild)
calendarChild.Show()
calendarChild.Maximize()
initEvents()

show_calendar()
{
    ;DISPLAY CALENDAR CHILD GUI
    calendarChild.Show()
    addEventGUI.Hide()
}

show_addevent(currentWeek)
{
    ;DISPLAY ADD EVENT CHILD GUI
    ; FocusedRowNumber := eventMenu.GetNext(0, "F")  ; Find the focused row.
    calendarChild.Hide()
    insertData(currentWeek)
    addEventGUI.Show("")
}

show_details()
{
    ;DISPLAY DETAILS CHILD GUI
    FocusedRowNumber := eventMenu.GetNext(0, "F")  ; Find the focused row.
    if not FocusedRowNumber  ; No row is focused.
        return
    else
        msgbox(eventMenu.GetText(FocusedRowNumber,))
    calendarChild.Hide()
    addEventGUI.Show()
}


/*
gui container
*/
calendarParentGUISetup()
{

    darkMode(calendarParentGUI)
    calendarParentGUI.BackColor := "0x373737"
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
    selectWeekNumber := calendarChild.Add("Text", "x" xPos + 60 " y" yPos + 90 " w" focusDetailsWidth - 150 " h" calH / 5, 'Selected Week')

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
    DetailsButton.OnEvent("Click", Click_Add)
    DeleteButton.OnEvent("Click", Click_Delete)
    return calendarChild
}
/*
change day of the month, retreive week, and update list of events based on weeks
*/
Click_MonthCal(*)
{
    global selectWeekNumber, currentWeek, year
    yearWeek := FormatTime(MonthCal.Value, "YWeek")
    selectedWeek := SubStr(yearWeek, -2)
    selectWeekNumber.Text := selectedWeek
    year := FormatTime(MonthCal.Value, "yyyy")
    if (selectedWeek != currentWeek)
    {
        currentWeek := selectedWeek
        setWeekEvents(selectedWeek+1)
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
Click_Delete(*)
{
    FocusedRowNumber := eventMenu.GetNext(0, "F")
    if not FocusedRowNumber  ; No row is focused.
        return
    else
        requests.Del(eventMenu.GetText(FocusedRowNumber, 5))
}
Click_Details(*)
{
    show_details()
}

initEvents()
{
    global currentWeek, selectWeekNumber, year
    yearWeek := FormatTime(MonthCal.Value, "YWeek")
    year := FormatTime(MonthCal.Value, "yyyy")
    currentWeek := SubStr(yearWeek, -2)
    ; Load Events from JSON / SQL
    selectWeekNumber.Text := currentWeek

    setWeekEvents(currentWeek+1)
}


/*
    This function sets the events for a given week in the eventMenu.
    It loads events from a JSON file and adds them to the eventMenu if they match the setWeek parameter.
    If there are any errors while creating the event, it displays an error message.
    Parameters:
        setWeek (string): The week for which events need to be set.
        eventMenu (object): The menu object to which events need to be added.
*/
setWeekEvents(setWeek)
{
    global eventMenu
    try
    {
        obj := requests.Get()
    } catch as e {
        MsgBox("error getting events from api")
        return
    }
    static errorMsg := False
    eventMenu.Delete
    errors := ""
    if not IsObject(obj)
        return
    for eventMap in obj
    {
        if IsObject(eventMap)
        {
            week := SubStr(eventMap["yweek"], 5, 2)
            if (week == setWeek - 1)
            {
                customer := requests.Get(eventMap["customer"], appName := "customers")
                eventMenu.Add(, customer["full_name"], eventMap["cows"], eventMap["pigs"], eventMap["customer"], eventMap["id"])
                eventMenu.ModifyCol(1, "500")
                ;eventMenu.ModifyCol(2, "99")
                ;eventMenu.ModifyCol(3, "99")
                eventMenu.ModifyCol(4)
                eventMenu.ModifyCol(5, "99")
            }
        }
        ; } catch as e {
        ;     errors .= "error creating event due to columns or rows at line " A_Index "`n" e.message
        ; }
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