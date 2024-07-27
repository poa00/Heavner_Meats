; constant
#Include CLR.ahk
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
        
        addEvent.editValues := {
            customerName: customerName,
            customerID: customerID,
            customerAddress: customerAddress,
            weekNumber: weekNumber,
            notes: notes
        }
        CowCountCtrl.Enabled := 0
        PigCountCtrl.Enabled := 0
        LambCountCtrl.Enabled := 0

        addEvent.checkboxMap.Set(CowCheckBox.hwnd, CowCountCtrl.hwnd, PigCheckBox.hwnd, PigCountCtrl.hwnd, LambCheckBox.hwnd, LambCountCtrl.hwnd)
        ; when check box is ticked for animal, the edit field is enabled

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
            
            Msgbox processNewEvent(cowCount, PigCount, LambCount, weekNumber.Value, customerID.Value)
            
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
processNewEvent(cowcount, pigcount, lambcount, weekNumber, custID)
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
        "cutsheet_remainder", cowCount+pigCount+lambCount
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
