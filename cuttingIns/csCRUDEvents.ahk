
cutsheetState()
{
    global gui_, cutsheetID
    cutsheetID := 0
    Customer.historicCS := historicCutsheets()
    Customer.latestCS := latestEventCutsheets()
    resetCutsheetVars()
    populateOrder()
    initCutSheets()
    Customer.event.animals.remaining := Customer.event.animals.total
    if IsObject(Customer.latestCS)
    {
        for cutsheet in Customer.latestCS
        {
            Customer.event.animals.remaining := Customer.event.animals.remaining - cutsheet['amount']
        }
    }
    setRemaining()
}

CurrentCS_Change(LV, row, *)
{
    global cutsheetID
    static notCounter := 0
    if not isLVSelected(LV)
        return
    local localID := LV.GetText(row, 3)
    if !localID || localID = "" || localID = cutsheetID
        return
    cutsheetID := localID
    ; Msgbox(Format("cutsheetID = {} `nlocalID {} ", cutsheetid, localID))
    CS := CutsheetFinder(localID)
    if not CS is Map 
        return
    if not CS.Has("cutsheet")
        return
    orderMapToOrderLV(gui_.csCRUD.details, CS['cutsheet'])
    orderMapToOrderLV(gui_.csCRUD.comments, CS['cutsheet'], 1)
}

NewCutsheet(*)
{
    global gui_
    if Customer.event.animals.remaining = 0
    {
        Msgbox("There are no animals unaccounted for. Please delete a cutsheet to continue or finalize the cutsheet.")
        return
    }
    resetCutsheetVars()
    gui_.csCRUD.ToggleVisible(0)
    howManyAnimals("cutsheetCRUD")
    ButtonStyle.Refresh()
}

editCutSheet(*)
{
    global gui_
    if not isLVSelected()
        return
    gui_.Nav.Save.Text := "Update Cutsheet"
    ButtonStyle(gui_.Nav.save, 0, "success-round")
    gui_.csCRUD.ToggleVisible(0)
    loadSavedCutsheet(1)
    switchCutsheetCRUDToWizard()
}

dupeCutsheet(*)
{
    global gui_, cutsheetID
    if not isLVSelected()
        return
    if Customer.event.animals.remaining = 0
    {
        Msgbox("There are no animals unaccounted for. Please delete a cutsheet to continue or finalize the cutsheet.")
        return
    }
    gui_.csCRUD.ToggleVisible(0)
    loadSavedCutsheet(1)
    switchCutsheetCRUDToWizard()
    Customer.event.animals.amount := 0
    setAnimalsfromOrder()
}

delCutsheet(*) => DelCutsheetHandler()

switchCutsheetCRUDToWizard()
{
    global gui_
    gui_.Wiz.main.ToggleVisible(1)
    gui_.Wiz.multi.ToggleVisible(0)
    gui_.Primary.ToggleVisible(1)
    gui_.Nav.ToggleVisible(1)
    ;gui_.order.ToggleVisible()
    GuiResizer.Now(gui_)
    ButtonStyle.Refresh()
}


DelCutsheetHandler()
{
    global cutsheetID, gui_
    if not isLVSelected()
        return
    ans := Msgbox("Are you sure you want to delete this cutsheet?", "Delete Cutsheet", 4)
    if ans = "No"
        return
    requests.appName := "cutsheets"
    postReq := requests.Del(cutsheetID) 
    cutsheetState()
}


loadSavedCutsheet(setPrimaryCheckbox?)
{
    global OrderMap, gui_
    if Customer.recipient.Has("id")
    {
        if Customer.recipient['id'] != 0
        {
            requests.appName := "customers"
            Customer.recipient := requests.Get(Customer.recipient['id'])
            gui_.order.recipient.Value := Customer.recipient['full_name']
        }
    }
    
    LB_PrimaryChange(gui_.Primary.LV)
    orderMapToOrderLV(gui_.Order.LV)
    orderMapToOrderLV(gui_.order.comments, , 1)
    
    CS := CutsheetFinder(cutsheetID)
    if !IsObject(CS)
        return 
    Customer.event.animals.amount := CS['amount']
    Customer.event.animals.animal := CS['animal']
    Customer.event.animals.temp_remaining := Customer.event.animals.amount
    if IsSet(setPrimaryCheckbox)
    {
        for key, arr in OrderMap
        {
            if arr.Has("details")
                if arr['details'].Length != 0
                {
                    gui_.Primary.LV.SetCell(A_Index, 2, "✓")
                }
        }
    }
}

orderMapToOrderLV(LV, tempOrderMap?, comments?)
{
    global OrderMap
    LV.Delete()
    if IsSet(tempOrderMap)
    {
        OrderMap := Map()
        OrderMap := tempOrderMap
    }
    for category, _map in OrderMap
    {
        row := A_Index
        LV.Add(, category)
        if _map is Map
        {
            if IsSet(comments)
            {
                if _map.Has("comment")
                {
                    LV.Modify(row, "Col" 2, _map['comment'])
                }
            }
            else if _map.Has('details')
            {
                try
                    if  _map['details'].Length > 0
                    {
                        for indx, item in _map['details']
                        {
                            LV.Modify(row, "Col" indx, item)
                        }
                    }
                catch as e
                    if  _map['details'].Count > 0
                    {
                        for indx, item in _map['details']
                        {
                            LV.Modify(row, "Col" indx, item)
                        }
                    }
            }

        } 
    }
}

CutsheetFinder(localID)
{
    if IsObject(Customer.historicCS)
    {
        if Customer.historicCS.length != 0
        {
            for cutsheet in Customer.historicCS
            {
                if cutsheet['id'] = localID
                {
                    return cutsheet
                }
            }
        }
    }
    if IsObject(Customer.latestCS)
    {
        if Customer.latestCS.length != 0
        {
            for cutsheet in Customer.latestCS
            {
                if cutsheet['id'] = localID
                {
                    return cutsheet
                }
            }
        }
    }
    return false
}

isLVSelected(LV_?)
{
    global gui_
    if !IsSet(LV_)
    {
        if gui_.csCRUD.LTabs.Value = 1
            LV_ := gui_.csCRUD.CurrentCS
        if gui_.csCRUD.LTabs.Value = 2
            LV_ := gui_.csCRUD.historicCS
    }
    
    FocusedRowNumber := LV_.GetNext(0, "F")  ; Find the focused row.
    if !FocusedRowNumber  ; No row is focused.
        return false
    return true
}


hidePopup()
{
    for k, v in gui_.myPopup.OwnProps()
    {
        if IsObject(v)
            v.Visible := 0
    }
    GuiReSizer.Now(gui_)
}

toggleWizard()
{
    global gui_
    for k, v in gui_.Wiz.main.OwnProps()
    {
        if IsObject(v)
            v.Visible := !v.Visible
    }
    for k, v in gui_.myPopup.OwnProps()
    {
        if IsObject(v)
            v.Visible := !v.Visible
    }
    GuiReSizer.Now(gui_)
}


latestEventCutsheets()
{
    requests.appName := "cutsheets"
    return requests.GetUrl("cutsheets/future/" Customer.producer['id'])
}

historicCutsheets()
{
    requests.appName := "cutsheets"
    return requests.GetUrl("cutsheets/historic/" Customer.producer['id'])
}