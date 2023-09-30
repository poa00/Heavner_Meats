
class addEvent
{
    static editValues := {}

    static GUI(mainGUI)
    {
        addEventGUI := Gui("+Parent" mainGUI.hwnd " -Caption -DPIScale")
        addEventGUI.SetFont("s20 c0xBBE9FF", "Segoe UI")
        addEventGUI.BackColor := "0x232323"
        ogcButtonCONFIRM := addEventGUI.Add("Button", "x40 y312 w205 h67", "CONFIRM")
        ogcButtonCANCEL := addEventGUI.Add("Button", "x296 y312 w205 h67", "CANCEL")
        addEventGUI.SetFont("s20 cBlack")
        addEventGUI.SetFont("s20 c0xBBE9FF", "Segoe UI")
        customerName := addEventGUI.Add("Edit", "x576 y32 w235 ", "FARM 123")
        customerID := addEventGUI.Add("Edit", "x576 y112 w461 ", "CUSTOMER ID 12312312")
        addEventGUI.SetFont("s20 c0xBBE9FF", "Segoe UI")
        eventID := addEventGUI.Add("Edit", "x576 y184 w461 ", "EVENT ID 321323")
        customerAddress := addEventGUI.Add("Edit", "x824 y32 w213 ", "FARM 123")
        notes := addEventGUI.Add("Edit", "x576 y280 w459 h96", "Notes`n")
        animalCount1 := addEventGUI.Add("Edit", "x272 y32 w211 h49", "0")
        addEventGUI.Add("UpDown", "x480 y32 w18 h49", "1")
        animalCount2 := addEventGUI.Add("Edit", "x272 y112 w211 h48", "0")
        addEventGUI.Add("UpDown", "x480 y112 w18 h48", "1")
        animalCount3 := addEventGUI.Add("Edit", "x272 y192 w209 h48", "0")
        addEventGUI.Add("UpDown", "x480 y112 w18 h48", "1")
        
        addEvent.editValues := {
            customerName: customerName,
            customerID: customerID,
            customerAddress: customerAddress,
        }
        DropDownList1 := addEventGUI.Add("DropDownList", "x40 y32 w218 Choose1", ["None", "Cows", "Pigs", "Lambs"])
        DropDownList2 := addEventGUI.Add("DropDownList", "x40 y116 w218 Choose1", ["None", "Cows", "Pigs", "Lambs"])
        DropDownList3 := addEventGUI.Add("DropDownList", "x40 y192 w218 Choose1", ["None", "Cows", "Pigs", "Lambs"])
        ogcButtonCONFIRM.OnEvent("Click", showCal)
        ogcButtonCANCEL.OnEvent("Click", OnEventHandler)
        customerName.OnEvent("Change", OnEventHandler)
        customerID.OnEvent("Change", OnEventHandler)
        eventID.OnEvent("Change", OnEventHandler)
        customerAddress.OnEvent("Change", OnEventHandler)
        blackBG(customerName, customerID, eventID, customerAddress, animalCount1, animalCount2, notes, animalCount3)
        notes.OnEvent("Change", OnEventHandler)
        animalCount1.OnEvent("Change", OnEventHandler)
        animalCount2.OnEvent("Change", OnEventHandler)
        animalCount3.OnEvent("Change", OnEventHandler)
        DropDownList1.OnEvent("Change", OnEventHandler)
        DropDownList2.OnEvent("Change", OnEventHandler)
        DropDownList3.OnEvent("Change", OnEventHandler)
        addEventGUI.OnEvent('Close', (*) => ExitApp())
        addEventGUI.Title := "calendarSimple.ahk (Clone)"
        ;addEventGUI.Show("x0 y0 hide")
        ;addEventGUI.Show()
        addEventGUI.Hide()
        OnEventHandler(*)
        {
            ToolTip("Click! This is a sample action.`n"
            . "Active GUI element values include:`n"  
            . "ogcButtonCONFIRM => " ogcButtonCONFIRM.Text "`n" 
            . "ogcButtonCANCEL => " ogcButtonCANCEL.Text "`n" 
            . "customerName => " customerName.Value "`n" 
            . "customerID => " customerID.Value "`n" 
            . "eventID => " eventID.Value "`n" 
            . "customerAddress => " customerAddress.Value "`n" 
            . "notes => " notes.Value "`n" 
            . "animalCount1 => " animalCount1.Value "`n" 
            . "animalCount2 => " animalCount2.Value "`n" 
            . "animalCount3 => " animalCount3.Value "`n" 
            . "DropDownList1 => " DropDownList1.Text "`n" 
            . "DropDownList2 => " DropDownList2.Text "`n" 
            . "DropDownList3 => " DropDownList3.Text "`n", 77, 577)
            SetTimer () => ToolTip(), -3000 ; tooltip timer
        }


        showCal(*)
        {
            show_calendar()
        }
        return addEventGUI
    }
}



insertData(currentWeek)
{
    str := reader(A_ScriptDir "\data.json")
    dict := Jsons.loads(&str)
    addEvent.editValues.customerID.Value := dict["customerID"] 
    addEvent.editValues.customerName.Value := dict["full_name"] 
    addEvent.editValues.customerAddress.Value := dict["billing_street"] 
}