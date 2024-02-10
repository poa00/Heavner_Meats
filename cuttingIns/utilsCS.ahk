setRefMap()
{
    global refMeatCuts
    if !IsSet(refMeatCuts)
    {
        refMeatCuts := Json.Load(FileOpen(A_ScriptDir "\beef.json", "r").Read())
    }
}
resetCutsheetVars()
{
    global
    Primary := {}
    Primary.value := 0
    cut := ""
    Customer.InitHandler()
    Customer.recipient := Map()
    if gui_.HasProp("csCRUD")
    {
        gui_.csCRUD.details.Delete()
        gui_.csCRUD.comments.Delete()
    }
    gui_.Wiz.main.Header2.Text := ""
    gui_.Wiz.main.Header3.Text := ""
    processFunc := {}
    OptionChain := Map()
    OrderMap := Map()
    combinedOptions := ""
    specialMenu := {}
    x := SysGet(16)
    y := SysGet(17)
    anchorBoxiesX := 0.02
    listboxTopLeftH := 0.35
    darkModeColor := "Black"
    Opt1Selection := ""
    for key, arr in OrderMap
    {
        gui_.Primary.LV.SetCell(A_Index, 2, "")
    }
    for key in refMeatCuts.keys()
    {
        OrderMap[key] := Map('details', [])
    }
    orderMap['Sausage'] := Map('details', Map("", ""))
    orderMap['Sausage'] := Map('comment', Map("", ""))
}
lastOrder := A_MyDocuments "\lastCutsheet.json"

; Check if 
checkSavedCutsheet()
{
    global OrderMap
    if Customer.event.map['saved_cutsheet'] != ""
    {
        OrderMap := Customer.event.map['saved_cutsheet']['cutsheet']
        Customer.recipient['id'] := Customer.event.map['saved_cutsheet']['recipient']
        loadSavedCutsheet(1)
        return true
    } else {
        return false
    }
}


setAllMenusInvisible()
{
    global gui_
    gui_.order.ToggleVisible()
    gui_.Wiz.main.ToggleVisible()
    gui_.Primary.ToggleVisible()
    gui_.Nav.ToggleVisible()
}

setBackgroundColors()
{
    global gui_
    gui_.myPopup := {}
    darkmode(gui_)
    gui_.myPopup.Enabled := 0
    SetWinDelay(5)
    ; * gui_.Opt("+E0x02000000 +E0x00080000")
    gui_.backcolor := "121d30"
    gui_.Wiz.main.Header.NoBack := 1
    try
    {
        gui_.Wiz.main.Header.Opt("Background121d30")
        gui_.Wiz.main.GB.Opt("Background121d30")
        gui_.Primary.GB.Opt("Background121d30")
        gui_.Wiz.main.Header2.Opt("Background313131")
        gui_.Wiz.main.Header3.Opt("Background313131")
        gui_.order.GB.Opt("Background121d30")
    }
    try
    {
        gui_.csCRUD.LTabs.Opt('Background121d30')
        gui_.csCRUD.RTabs.Opt('Background121d30')
        gui_.csCRUD.Event.Opt("Background121d30")
        gui_.csCRUD.CurrentCS.Opt("Background071122")
        gui_.csCRUD.details.Opt("Background050b15")
        gui_.csCRUD.comments.Opt("Background050b15")
    }
    try {
        gui_.cust.Header2.Opt("Background121d30")
        gui_.cust.Header.Opt("Background121d30")
        gui_.cust.LV.Opt("Background121d30")
    }
        setGBBackgroundColor(gui_, "Background121d30")

    ;gui_.Nav.Box.Opt("Background121d30")
}

setGBBackgroundColor(selfObj, bgColor)
{
    status := 0
    for index, value in selfObj.OwnProps() {
        if !IsSet(value)
            continue
        else if IsObject(value)
        {
            if not InStr(value.__Class, "Gui.")
                status := setGBBackgroundColor(value, bgColor)
            else if HasMethod(value, "Opt") && InStr(value.__Class, "Gui.GroupBox")
            {
                value.Opt(bgColor)
            }
        }
    }
    return status
}


listBoxUnselect()
{
    global gui_
    isFirstboxSelected := false
}

; getCustomers()
; {
;     try {
;         return requests.Get(, "customers")
;     } catch as e {
;         return e.Message
;     }
; }

deleteLB(params*)
{
    for ctrl in params
    {
        ctrl.Choose(0)
        ctrl.Delete
    }
}

/*
    :param str: The string to shorten.
    :return: The shortened string.

    if StrLen(str) > 10
        return SubStr(str, 1, 10) "... Options"
*/
ShortenKey(str)
{
    if StrLen(str) > 10
        return SubStr(str, 1, 12) "... Options"
    else
        return str " Options"
}


getDate(yweek)
{
    date := Map()
    date['week'] := SubStr(yweek, 5, 2)
    date['year'] := SubStr(yweek, 1, 4)
    return date
}