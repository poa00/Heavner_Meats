; constant
#Include calendarUtil.ahk
/*
This code defines a class called "addEvent" that creates a GUI for adding events to a calendar. The GUI contains various input fields such as customer name, address, and notes, as well as checkboxes for selecting the type of animal involved in the event (cow, pig, or lamb) and corresponding count fields. The GUI also includes "CONFIRM" and "CANCEL" buttons for submitting or canceling the event, respectively.

The class includes various methods for handling events such as checkbox clicks and button clicks, as well as updating the GUI with the values of the input fields.

The code also includes a "writer" function for writing to a log file and a "show_calendar" function for displaying the calendar GUI.
*/
class addEvent
{
    static editValues := {}
    static checkboxMap := Map()
    static mode := "create"
    static event := Map()
    static customer := Map()
    static checkBox := { cow_hwnd: 0, pig_hwnd: 0, lamb_hwnd: 0 }
    static GUI(calendarParentGUI)
    {
        addEventGUI := Gui("+Parent" calendarParentGUI.hwnd " -Caption ")
        addEventGUI.SetFont("s26 c0xBBE9FF", "Segoe UI")
        addEventGUI.BackColor := "0x232323"
        addEventGUI.SetFont("s27")

        CowCheckBox := addEventGUI.Add("CheckBox", "x10 y32 w180 h43", "Cow")
        CowCountCtrl := addEventGUI.Add("Edit", "x200 y32 w211 h48", "0")
        addEventGUI.Add("UpDown", " y32 w28 h48", "0")

        PigCheckBox := addEventGUI.Add("CheckBox", "x10 y112 w180 h63", "Pig")
        PigCountCtrl := addEventGUI.Add("Edit", "x200 y112 w211 h48", "0")
        addEventGUI.Add("UpDown", " y112 w28 h48", "0")

        LambCheckBox := addEventGUI.Add("CheckBox", "x10 w180 y192 h43", "Lamb")
        LambCountCtrl := addEventGUI.Add("Edit", "x200 y192 w209 h48", "0")
        addEventGUI.Add("UpDown", " y192 w28 h48", "0")

        ogcButtonCONFIRM := addEventGUI.Add("Button", "x10 y+50 w185 h67", "CONFIRM")
        ogcButtonCANCEL := addEventGUI.Add("Button", "x+50 yp w185 h67", "CANCEL")

        addEventGUI.SetFont("s26 cBlack")
        addEventGUI.SetFont("s26 c0xBBE9FF", "Segoe UI")

        customerName := addEventGUI.Add("Edit", "x576 y32 w500 h48", "customerName")
        customerName.Enabled := 0
        customerID := addEventGUI.Add("Edit", "xp y+20 wp h48", "customerID 123")
        customerAddress := addEventGUI.Add("Edit", "x576 y+20 wp h48", "customerAddress")
        customerAddress.Enabled := 0
        addEventGUI.SetFont("s26 c0xBBE9FF", "Segoe UI")
        customerID.Enabled := 0

        weekNumber := addEventGUI.Add("Edit", "x576 y+20 wp ", "Week Number")
        weekNumber.Enabled := 0
        notes := addEventGUI.Add("Edit", "x576 y+20 wp h96", "Notes`n")
        notes.SetFont("s14")
        addEvent.editValues := {
            customerName: customerName,
            customerID: customerID,
            customerAddress: customerAddress,
            weekNumber: weekNumber,
            notes: notes,
            cows: CowCountCtrl,
            pigs: PigCountCtrl,
            lambs: LambCountCtrl
        }
        CowCountCtrl.Enabled := 0
        PigCountCtrl.Enabled := 0
        LambCountCtrl.Enabled := 0

        addEvent.checkboxMap.Set(CowCheckBox.hwnd, CowCountCtrl.hwnd, PigCheckBox.hwnd, PigCountCtrl.hwnd, LambCheckBox.hwnd, LambCountCtrl.hwnd)
        ; when check box is ticked for animal, the edit field is enabled

        addEvent.checkbox.cow_hwnd := CowCheckBox.hwnd
        addEvent.checkbox.pig_hwnd := PigCheckBox.hwnd
        addEvent.checkbox.lamb_hwnd := LambCheckBox.hwnd
        CowCheckBox.OnEvent("Click", invertCountBoxEnabled)
        PigCheckBox.OnEvent("Click", invertCountBoxEnabled)
        LambCheckBox.OnEvent("Click", invertCountBoxEnabled)

        ogcButtonCONFIRM.OnEvent("Click", ButtonCONFIRM)

        ogcButtonCANCEL.OnEvent("Click", cancelClick)
        customerName.OnEvent("Change", OnEventHandler)
        customerID.OnEvent("Change", OnEventHandler)
        weekNumber.OnEvent("Change", OnEventHandler)
        customerAddress.OnEvent("Change", OnEventHandler)

        blackBG(customerName, customerID, weekNumber, customerAddress, CowCountCtrl, PigCountCtrl, notes, LambCountCtrl, ogcButtonCONFIRM, ogcButtonCANCEL)

        notes.OnEvent("Change", OnEventHandler)
        CowCountCtrl.OnEvent("Change", OnEventHandler)
        PigCountCtrl.OnEvent("Change", OnEventHandler)
        LambCountCtrl.OnEvent("Change", OnEventHandler)
        addEventGUI.OnEvent('Close', (*) => ExitApp())
        addEventGUI.Title := "calendarSimple.ahk"
        ;addEventGUI.Show("x0 y0 hide")
        ;addEventGUI.Show()
        addEventGUI.Hide()

        invertCountBoxEnabled(thisCtrl, *)
        {
            ; when check box is ticked for animal, the edit field is enabled
            addEventGUI[addEvent.checkboxMap[thisCtrl.hwnd]].Enabled := !addEventGUI[addEvent.checkboxMap[thisCtrl.hwnd]].Enabled
        }

        OnEventHandler(*)
        {
            ToolTip("Click! This is a sample action.`n"
                . "Active GUI element values include:`n"
                . "PigCountCtrl => " PigCountCtrl.Value "`n"
                . "LambCountCtrl => " LambCountCtrl.Value "`n", 77, 577)
            SetTimer () => ToolTip(), -3000 ; tooltip timer
        }


        ButtonCONFIRM(*)
        {
            global returnFile
            if CowCheckBox.Enabled
                cowCount := CowCountCtrl.Value
            else
                cowCount := 0
            if PigCheckBox.Enabled
                PigCount := PigCountCtrl.Value
            else
                PigCount := 0
            if LambCheckBox.Enabled
                LambCount := LambCountCtrl.Value
            else
                LambCount := 0
            if addEvent.mode = "create"
                Msgbox processNewEvent(cowCount, PigCount, LambCount, notes, weekNumber.Value, customerID.Value)
            if addEvent.mode = "update"
                Msgbox processUpdate(cowCount, PigCount, LambCount, notes, weekNumber.Value, customerID.Value)
            ; ONLY UNCOMMENTED FOR TESTING
            ; writer(pendingEventFile, "")
            ; ONLY UNCOMMENTED FOR TESTING
            show_calendar()
        }

        cancelClick(*)
        {
            show_calendar()
        }

        return addEventGUI
    }
}

sendDatatoAddEvent(currentWeek, dict, event?) 
{
    addEvent.editValues.customerID.Value := dict["id"]
    addEvent.editValues.customerName.Value := dict["full_name"]
    addEvent.editValues.weekNumber.Value := currentWeek
    addEvent.editValues.customerAddress.Value := dict["billing_street"]
    
    if IsSet(event)
    {
        try addEvent.editValues.notes.Value := event["notes"]
        catch as e
            addEvent.editValues.notes.Value := "notes here..."
        try addEvent.editValues.Cows.Value := event["cows"], addEvent.editValues.Cows.Enabled := event["cows"] = 0 ? 0 : 1
        catch as e
            addEvent.editValues.Cows.Value := 0, addEvent.editValues.Cows.Enabled := 0

        try addEvent.editValues.Pigs.Value := event["pigs"], addEvent.editValues.Pigs.Enabled := event["pigs"] = 0 ? 0 : 1
        catch as e
            addEvent.editValues.Pigs.Value := 0, addEvent.editValues.Pigs.Enabled := 0

        try addEvent.editValues.Lambs.Value := event["lambs"], addEvent.editValues.Lambs.Enabled := event["lambs"] = 0 ? 0 : 1
        catch as e
            addEvent.editValues.Lambs.Value := 0, addEvent.editValues.Lambs.Enabled := 0
            
        setCheckBox(GuiCtrlFromHwnd(addEvent.checkbox.cow_hwnd), 
                    addEvent.editValues.Cows.Value = 0 ? 0 : 1)
        setCheckBox(GuiCtrlFromHwnd(addEvent.checkbox.pig_hwnd), 
                    addEvent.editValues.Pigs.Value = 0 ? 0 : 1)
        setCheckBox(GuiCtrlFromHwnd(addEvent.checkbox.lamb_hwnd), 
                    addEvent.editValues.Lambs.Value = 0 ? 0 : 1)
        setCheckBox(ctrl, state) {
            ctrl.Enabled := state, ctrl.Value := state
        }
    }
    else {
        GuiCtrlFromHwnd(addEvent.checkbox.cow_hwnd).Enabled := 1
        GuiCtrlFromHwnd(addEvent.checkbox.pig_hwnd).Enabled := 1
        GuiCtrlFromHwnd(addEvent.checkbox.lamb_hwnd).Enabled := 1
    }
}
/*
insertData(currentWeek)

This function reads data from a JSON file and inserts it into the addEvent form.
The function takes one parameter:
- currentWeek: the current week number to be inserted into the form.

The function reads the data from the file specified in the 'pendingEventFile' variable.
It then loads the data into a dictionary using the Jsons library.
Finally, the function sets the values of the addEvent form fields using the data from the dictionary.

*/
insertData(currentWeek)
{
    global returnFile
    str := ""
    try str := reader(pendingEventFile)
    if str = "" or str = false
    {
        returnFile := 0
        CustomerSearch.ID := ""
        calendarChild.Hide()
        tempGui := CustomerSearch()
        loop
        {
            Sleep(100)
            if CustomerSearch.ID = ""
            {
                continue
            }
            else
            {
                if CustomerSearch.ID = false
                    calendarChild.Show()
                else
                    dict := CustomerSearch.profile
                CustomerSearch.ID := ""
                tempGui.Destroy()
                break
            }
        }
    }
    else
    {
        returnFile := 1
        dict := jsons.Loads(&str)
    }
    if dict
    {
        addEvent.customer := dict
        sendDatatoAddEvent(currentWeek, dict)
        return true
    } else
        return false
}

/*
    processNewEvent - Adds a new event to the calendar and sends a POST request to the API to create the event.

    Parameters:
        cowcount (int): The number of cows for the event.
        pigcount (int): The number of pigs for the event.
        lambcount (int): The number of lambs for the event.
        weekNumber (int): The week number for the event.
        custID (str): The customer ID for the event.

    Returns:
        str: The response from the API POST request.
*/
processNewEvent(cowcount, pigcount, lambcount, notes, weekNumber, custID)
{
    global eventsFile, returnFile, year
    ; if returnFile  the request to schedule came from the customerPythonGui
    if returnFile = 1
    {
        jdata := Json.LoadEvents()
        jdata.push(eventArrayPush(cowcount, pigcount, lambcount, weekNumber))
        Json.SaveEvents(eventsFile, jdata)
    }
    returnedMap := requests.Post(m := Map(
        "customerID", custID,
        "yweek", year String(weekNumber),
        "cows", cowCount,
        "pigs", PigCount,
        "lambs", LambCount,
        "notes", notes,
        "cutsheet_remainder", cowCount + pigCount + lambCount
    ))
    if returnFile = 1
    {
        writer(calendarLog, "true")
        writer(pendingEventFile, "")
    }
    if returnedMap is String
        return returnedMap
    return Jsons.Dumps(returnedMap)
}

processUpdate(cowcount, pigcount, lambcount, notes, weekNumber, custID)
{
    global eventsFile, returnFile, year
    ; if returnFile  the request to schedule came from the customerPythonGui
    requests.appName := "events"
    if returnFile = 1
    {
        jdata := Json.LoadEvents()
        jdata.push(eventArrayPush(cowcount, pigcount, lambcount, weekNumber))
        Json.SaveEvents(eventsFile, jdata)
    }
    returnedMap := requests.Put(addEvent.event['id'], m := Map(
        "customerID", custID,
        "yweek", year String(weekNumber),
        "cows", cowCount,
        "pigs", PigCount,
        "lambs", LambCount,
        "notes", notes.Value,
        "cutsheet_remainder", cowCount + pigCount + lambCount
    ))
    if returnFile = 1
    {
        writer(calendarLog, "true")
        writer(pendingEventFile, "")
    }
    if returnedMap is String
        return returnedMap
    return Jsons.Dumps(returnedMap)
}