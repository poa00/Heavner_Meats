/*
This script is a simple calendar application written in AutoHotkey. It includes a GUI with a calendar and a list of events for each week. Users can add new events to the calendar and view details of existing events. The application reads and writes event data to a JSON file.
The script includes several classes, including GUIs and Json, which are used to create and manage the GUI and handle JSON data, respectively.
The script also includes several functions, including show_calendar, show_addevent, and show_details, which are used to display the appropriate GUI based on user actions.
To use the script, run it in AutoHotkey and interact with the GUI to add and view events.
*/
#SingleInstance Force
#Include util\customers.ahk
#Include util\AddorDetailsEvent.ahk
#Include util\calendarUtil.ahk
#Include util\searchCustomers.ahk
#Include <cJson>
#Include <Dark_MsgBox_v2>
#Include <request>

port := 5613
ip := "localhost"
app := "calendar"
returnFile := false
;constants

x := 1380
y := 720
calendarParentGUI := Gui("")
calendarParentGUISetup()
calendarParentGUI.Show("h" y " w" x "")
calendarChild := calendarChildSetup(calendarParentGUI)
addEventGUI := createAddEvent(calendarParentGUI)

darkMode(calendarChild)
calendarChild.Show()
initEvents()

;@@@@@@@@@@@@@@@@@@@@@@@@@@
#Include baseClasses.ahk 
;@@@@@@@@@@@@@@@@@@@@@@@@@@

show_calendar()
{
    ;DISPLAY CALENDAR CHILD GUI
    calendarChild.Show()
    addEventGUI.Hide()
}
/**
 * Displays the add event child GUI and sets the mode to "create".
 * 
 * @param {currentWeek} currentWeek - The current week.
 */
show_addevent(currentWeek)
{
    addEvent.mode := "create"
    ;DISPLAY ADD EVENT CHILD GUI
    ; FocusedRowNumber := eventMenu.GetNext(0, "F")  ; Find the focused row.
    calendarChild.Hide()
    if insertData(currentWeek)
        addEventGUI.Show("")
}

/**
 * The show_details function is designed to display detailed information about a specific event and its associated customer.
 * This function is likely triggered by some user interaction, such as selecting an event from a list.
 * 
 * @global {number} returnfile - A global variable used elsewhere in the script.
 * @global {number} currentWeek - A global variable representing the current week.
 * @param {...any} params - Additional parameters passed to the function.
 */
show_details(params*)
{
    global returnfile, currentWeek
    ;DISPLAY DETAILS CHILD GUI
    addEvent.mode := "update"
    FocusedRowNumber := eventMenu.GetNext(0, "F")  ; Find the focused row.
    if not FocusedRowNumber  ; No row is focused.
        return
    returnFile := 0
    customers := getCustomers()
    cid := eventMenu.GetText(FocusedRowNumber, 4)
    customer := requests.GetUrl("customers/" cid)
    eid := eventMenu.GetText(FocusedRowNumber, 5)
    event := requests.GetUrl("events/" eid)
    sendDatatoAddEvent(currentWeek, customer, event)
    calendarChild.Hide()

    addEvent.customer := customer
    addEvent.event := event
    addEventGUI.Show()
}