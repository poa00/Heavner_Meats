#Requires Autohotkey v2
#SingleInstance force
#Include <AHKpy>
#Include <ButtonStyle>
#Include <request>
#Include <cJson>
#Include <darkmode>
#Include <AutoResizer>
        ; SearchCustomers
#Include searchCustomers.ahk
        ; CSCrud
#Include csCRUD.ahk 
#Include csCRUDEvents.ahk
        ; HowManyAnimals
#Include HowManyAnimals.ahk
        ; Order
#Include Ctrls.ahk
#Include orderEvents.ahk
#Include Sausage.ahk 
#Include utilsCS.ahk 
Persistent

/*
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; * Overview: This script creates a GUI for selecting options
; * and managing orders. It dynamically generates options
; * based on user selections and accumulates orders.
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

1. Search  Custommers 
2. Cutsheet Crud
3. howManyAnimals
4. Wizard/Order

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; * GUI Initialization
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*/

gui_ := constructGUI(Gui(, "Find your customer"))
gui_.Opt("+Resize +MinSize850x550 -DPIScale")
CreateImageButton("SetDefGuiColor", 0x000000)

setAllMenusInvisible()

gui_.Show("h" 1080 " w" 1920)
; gui_.OnEvent("Size", (*) => GuiReSizer.Now(gui_))
gui_.Maximize()
GuiResizer.Now(gui_)
ButtonStyle.Refresh()

resetCutsheetVars()
if A_Args.Length > 0 
{
    requests.appName := "customers"
    x:=requests.GetUrl("customers/" A_Args[1])
    Customer.Producer := requests.GetUrl("customers/" A_Args[1]) 
}  else {
    InitSearchCustomers()
}
setBackgroundColors()
ButtonStyle.Refresh()


if cutsheetCRUD() = false
{
    ExitApp()
} else {
    gui_.csCRUD.Edit.OnEvent("Click", editCutSheet)
    gui_.csCRUD.New.OnEvent("Click", NewCutsheet)
    gui_.csCRUD.duplicate.OnEvent("Click", dupeCutsheet)
    gui_.csCRUD.return.OnEvent("Click", (*) => Reload())
    gui_.csCRUD.Delete.OnEvent("Click", delCutsheet)
}


listBoxUnselect()
setBackgroundColors()
GuiReSizer.Now(gui_)



/*
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    Functions
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*/

/*
    Function: selectCustomerDisplay

    Description:
    This function selects a customer display and retrieves the customer's profile and events.

    Returns:
    An object containing the customer's profile and events.
*/
InitSearchCustomers()
{
    if selectProducer() = false
        ExitApp()
    gui_.Wiz.main.GB.Text := "Order for " Customer.producer['full_name']
    GuiReSizer.Now(gui_)
}

selectProducer()
{
    global gui_, setEvent
    setEvent := false
    Customer.ID := ""
    dict := Map()
    lastOrder := Map()
    Customer.gui_hwnd := gui_.hwnd
    Customer("events", "Select an Order")
    While (Customer.ID = "")
    {
        Sleep(100)
    }
    Customer.producer := Customer.profile
    
    ,Customer.ID := ""
    ,animals := false
    setEvent := false
    requests.appName := "events"
    events := requests.GetUrl("events/" Customer.producer["id"] "/future-events")
    if events.length > 1
    {
        selectEvent(events)
        while (setEvent = false)
        {
            Sleep(100)
        }
    } else {
        Customer.event.map := events[1]
    }

    return true
}

populateOrder()
{
    global refMeatCuts
    gui_.cust.ToggleVisible(0)
    gui_.cust := {}
    Customer.event.animals := {}
    animals := false
    for animal, count in Customer.event.map
    {
        if (animal = "cows") || (animal = "pigs") || (animal = "lambs") || (animal = "goats")
        {
            if count != 0 && count is Number
            {
                Customer.event.animals.animal := animal
                Customer.event.animals.total := count
                animals := true
                gui_.order.Producer.Value := Customer.producer['full_name']
            }
        }
    }
    if animals = false {
        ans := Msgbox("No calendar events found for this customer.`nWould you like to try again?", "No animals found.", 4)
        if ans = "Yes"
        {
            Customer("events")
        }
    }
    if Customer.event.animals.animal = "cows"
    {
        path := "\beef.json"
        gui_.Primary.LV.SetFont("s18")
    } else if Customer.event.animals.animal = "pigs" {
        path := "\pork.json"
        gui_.Primary.LV.SetFont("s24")
    }
    refMeatCuts := Map()
    refMeatCuts := Json.Load(FileRead(A_ScriptDir path))
    gui_.Primary.LV.Delete()
   for k in refMeatCuts.keys()
   {
       gui_.Primary.LV.Add(, k)
   }
    requests.appName := "cutsheets"
    Customer.historicCS := historicCutsheets()
    Customer.latestCS := latestEventCutsheets()
    Customer.event.animals.remaining := Customer.event.animals.total
    if IsObject(Customer.latestCS)
    {
        for cutsheet in Customer.latestCS
        {
            Customer.event.animals.remaining := Customer.event.animals.remaining - cutsheet['amount']
        }
    }
}

selectEvent(events)
{
    global setEvent, event
    local myGui := Gui()
    myGui.Opt("+Owner" gui_.hwnd " +AlwaysOnTop +ToolWindow")
    event := false
    myGui.SetFont("s24  cWhite")
    myGui.BackColor := "Black"
    myGui.Add("Text", "x22 y22 ", "There are multiple upcoming `nslaughter dates for " Customer.profile["full_name"] 
              ".`nSelect the week of slaughter `nto make/modify associated cutsheets:")
    Radios := []
    
    for k, v in events
    {
        date := getDate(v['yweek'])
        Radios.Push(myGui.Add("Radio", "y+5 w506 h57", "Week " date['week'] " of " date['year']))
        Radios[A_Index].Name := k
        Radios[A_Index].OnEvent("Click", radioChange)
    }
    myGui.Add("Button", "y+5 ", "Submit").OnEvent("Click", finished)
    myGui.OnEvent('Close', (*) => ExitApp())
    myGui.Title := "Window"
    myGui.Show("")
    darkmode(myGui)
    radioChange(RadioCtrl, *)
    {
        global event
        event := events[Integer(RadioCtrl.Name)]
    }
    finished(GuiCtrl, *)
    {
        global setEvent, event
        Customer.event.map := event
        
        myGui.Destroy()
        setEvent := true
    }
}

setWizHeaderText(str?, multi:=false)
{
    global gui_, processFunc, OptionChain
    gui_.Wiz.main.Header2.Text := ""
    linebreak := "`n - "
    if multi = true
    {
        gui_.Wiz.main.Header2.Text .= str
    }
    else if IsSet(str)
    {
        gui_.Wiz.main.Header2.Text .= Trim("Set options for " str ":")
    }
    else
    {
        for key, val in OptionChain
        {
            if (A_Index = 1)
            {
                if IsSet(val) && Trim(val) != ""
                {
                    gui_.Wiz.main.Header2.Text .= Trim("Set options for " val ":")
                }
            }
            else if IsSet(val) and Trim(val) != ""
            {
                gui_.Wiz.main.Header2.Text .= "`n  - " Trim(val)
            }
        }
    }
}


/**
 * Sets a flag when the primary list box is first selected.
 */
onFirstListboxChange(*)
{
    if not IsSet(isFirstboxSelected)
        isFirstboxSelected := true
}


/**
 * Function: loopBeef
 * Description: Retrieves keys from the global BeefMap variable.
 * @returns Array
 */
loopBeef()
{
    global refMeatCuts
    TEMP := []
    for i, l in refMeatCuts {
        TEMP.Push(i)
    }
    return TEMP
}
