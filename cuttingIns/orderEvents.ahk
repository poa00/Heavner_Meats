/*
LB_PrimaryChange(GuiCtrl, *)

* This function is called when the value of a ListBox control (GuiCtrl) is changed.
* It updates the global variables PrimarySelect, Opt, display, OptionChain, and OrderMap.
* If the ListBox control's text is empty, the function returns without performing any actions.
* Otherwise, it sets the value of PrimarySelect to the text of the ListBox control.
* It updates the display.map variable with the corresponding value from the BeefMap based on the PrimarySelect value.
* It sets the display.lastSelect variable to an empty string.
* It initializes the OptionChain variable as an empty Map.
* It calls the setWizHeaderText function with the PrimarySelect value as an argument.
* It sets the display.type variable based on the Type of the BeefMap value for the PrimarySelect.
* Finally, it calls the processMap function with the display, gui_.Wiz.main.LB, and PrimarySelect as arguments.

Parameters:
- GuiCtrl: The ListBox control whose value has changed.

Returns: None
*/
LB_PrimaryChange(GuiCtrl, *)
{
    global cut, processFunc, OptionChain, OrderMap, depth, refMeatCuts, multi
    if !IsSet(multi)
        multi := false
    if multi
        hideMultiTab(), multi := false
    str := ""
    rowNum := GuiCtrl.GetNext(0, "F")
    if not rowNum
        return 0
    cut := GuiCtrl.GetRow(1)
    if cut = "Cut" or cut = false or cut = "Im a listbox"
        return
    depth := 2
    if GuiCtrl.Focused = ""
        return
    processFunc.map := Map()
    OptionChain := Map()
    processFunc.map[depth] := refMeatCuts[cut]
    processFunc.lastSelect := ""
    processFunc.type := Type(refMeatCuts[cut])
    pushToLB(&x := processFunc.map[depth], gui_.Wiz.main.LB, cut)
    setWizHeaderText(cut)

    gui_.Wiz.main.comments.Value := OrderMap[cut].Has("comment") ? OrderMap[cut]['comment'] : ""
    if !OrderMap.Has(cut) || !orderMap[cut].Has("details")
        return
    if OrderMap[cut]["details"].Length != 0
    {
        for item in OrderMap[cut]["details"]
        {
            if A_Index > 1
            {
                addToWizHeader(item)
            }
        }
        ; depth := OrderMap[PrimarySelect.value].Length + 1
    }
    if OrderMap.Has("Sausage")  
        if OrderMap['Sausage'].Has("details")
            FileOpen(sausage_log, "w").Write(JSON.Dump(OrderMap['Sausage']['details']))
}

hideMultiTab()
{
    global gui_
    gui_.Wiz.multi.tab.Visible := 0
    gui_.Wiz.multi.tab.Enabled := 0
    gui_.Wiz.multi.tab.Delete()
    gui_.Wiz.main.tab.Delete()
    gui_.Wiz.main.tab.Add(["options", "comments"])
    gui_.Wiz.main.tab.Visible := 1
    gui_.Wiz.main.tab.Enabled := 1
    gui_.Wiz.main.LB.enabled := 1
    gui_.Wiz.main.LB.visible := 1
    gui_.Wiz.main.LB.Redraw()
    gui_.Wiz.main.tab.Redraw()
    GuiResizer.Now(gui_)
    setBackgroundColors()
    ButtonStyle.Refresh()
}

; Function: OptNextButton
; Description: Handles the logic for the next button in the option wizard.
; Parameters:
;   - GuiCtrl: The GUI control object.
;   - *: Optional parameters.
;
OptNextButton(GuiCtrl, *)
{
    global cut, processFunc, OptionChain, OrderMap, depth, multi
    guiText := gui_.Wiz.main.LB.Text

    if multi
        SwitchTabs()
    if (guiText = "" || !IsSet(cut) || guiText = processFunc.lastSelect || guiText = "Confirmed." || guiText = "Im a listbox") {
        return
    }
    processFunc.lastSelect := guiText
    currentMap := processFunc.map[depth]
    mapType := Type(processFunc.map[depth])
    nextMap := IncreaseDepthIfNeeded(currentMap, guiText)
    PasstoProcess(nextMap, gui_.Wiz.main.LB, guiText)
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    SwitchTabs()
    {
        global gui_
        Try {
            gui_.Wiz.multi.tab.Value := (gui_.Wiz.multi.tab.Value + 1)
        }
    }
}
PasstoProcess(nextMap, GuiCtrl, guiText)
{
    OptionChain.Set(depth, GuiCtrl.Text)
    if guiText = "Click confirm to save options." or InStr(guiText, "Yes") {
        ConfirmButtonClick()
    } else {
        addToWizHeader(GuiCtrl.Text)
        pushToLB(&nextMap, GuiCtrl, guiText)
    }
}
IncreaseDepthIfNeeded(currentMap, guiText) {
    global processFunc, depth
    ; Handle incrementing depth for Map or Array types
    if IsObject(currentMap) {
        depth++
        if currentMap is Map && currentMap.Has(guiText) {
            processFunc.map[depth] := currentMap[guiText]
        } else if currentMap.Contains(guiText) {
            processFunc.map[depth] := currentMap[currentMap.Contains(guiText)]
        }
        return processFunc.map[depth]
    }
    return false
}

/*
    Function: processMap

    Description:
    This function processes a map object and populates a GUI listbox control with the keys || values from the map, depending on the type of the map object. It also sets the wizard header text and handles special cases for string values.

    Parameters:
    - display (object): The display object containing the map and depth information.
    - NextLB_GuiCtrlObj (object): The GUI listbox control object to populate.
    - lastCtrlText (string, optional): The last control text value.

    Returns:
    None
*/
pushToLB(&newMap, NextLB_GuiCtrlObj, lastCtrlText?)
{
    global gui_, depth, wizT, multi
    finalText := "Click confirm to save options."
    processFunc.type := Type(newMap)

    if IsSet(lastCtrlText)
        OptionChain.Set(depth, lastCtrlText)
    NextLB_GuiCtrlObj.Delete
    setWizHeaderText()
    switch Type(newMap) {
        case "Map":
            {
                if newMap.Count = 1 && !newMap.Has("multi")
                {
                    for k, v in newMap
                    {
                        IncreaseDepthIfNeeded(newMap, k)
                        PasstoProcess(v, gui_.Wiz.main.LB, k)
                    }
                }
                else
                    for key, popupMap in newMap
                    {
                        if not key = "multi"
                            NextLB_GuiCtrlObj.Add([key])
                        else {
                            multi := true, displaySubmenuTabs(popupMap)
                        }
                    }
            }
        case "Array":
            for val in newMap
                NextLB_GuiCtrlObj.Add([val])
        case "String":
            {
                if IsSet(lastCtrlText)
                {
                    if newMap = lastCtrlText
                    {
                        NextLB_GuiCtrlObj.Add([finalText])
                        return
                    } }
                if newMap = "Finished."
                    NextLB_GuiCtrlObj.Add([finalText])
                else
                    NextLB_GuiCtrlObj.Add([newMap])
            }
        default:
            {
                try
                    NextLB_GuiCtrlObj.Add([newMap])
                catch as e
                    Msgbox e.Message "`nError trying to add to listbox at the end of processMap function."
            }
    }
}

displaySubMenuTabs(popupMap)
{
    global gui_
    gui_.Wiz.main.LB.enabled := 0
    gui_.Wiz.main.LB.Visible := 0
    gui_.Wiz.main.tab.enabled := 0
    gui_.Wiz.main.tab.Visible := 0
    gui_.Wiz.multi.tab.Delete()
    gui_.Wiz.multi.tab.Add(popupMap.Keys())
    gui_.Wiz.multi.tab.Visible := 1
    gui_.Wiz.multi.tab.Enabled := 1
    gui_.Wiz.multi.tabNames := Map()
    for tab, submap in popupMap
    {
        gui_.Wiz.multi.tabNames[A_Index] := tab
        gui_.Wiz.multi.LB[A_Index].Visible := 1
        gui_.Wiz.multi.LB[A_Index].Enabled := 1
        gui_.Wiz.multi.LB[A_Index].Redraw()
        gui_.Wiz.multi.LB[A_Index].Delete()
        gui_.Wiz.multi.LB[A_Index].Add(submap)
    }
    GuiResizer.Now(gui_)
    gui_.Wiz.multi.tab.Redraw()
    setBackgroundColors()
    ButtonStyle.Refresh()
    setWizHeaderText(" **Important**`n Fill out all tabs`n on the right.", true)
    multi := true
}

; Function: OptBackButton
; Description: Handles the logic for the back button in the option wizard.
; Parameters:
;   - *: Optional parameters.
; Global Variables:
;   - PrimarySelect: The primary selection.
;   - Opt: The options.
;   - display: The display object.
;   - OptionChain: The option chain.
OptBackButton(*)
{
    global cut, processFunc, OptionChain, depth
    if processFunc.HasOwnProp("depth") && processFunc.HasOwnProp("map")
    {
        if depth > 2
        {
            if processFunc.map.Has(depth)
                processFunc.map.Delete(depth)
            if OptionChain.Has(depth)
                OptionChain.Delete(depth)
            depth := depth - 1
            processFunc.type := Type(processFunc.map[depth])
            pushToLB(&processFunc, gui_.Wiz.main.LB)
            setWizHeaderText()
        }
    }
}

; Function: ConfirmButtonClick
; Description: Handles the logic for the finish button in the option wizard.
; Parameters:
;   - *: Optional parameters.
; Global Variables:
;   - PrimarySelect: The primary selection.
;   - Opt: The options.
;   - display: The display object.
;   - OptionChain: The option chain.
;   - OrderMap: The order map.
ConfirmButtonClick(*)
{
    global cut, processFunc, OptionChain, OrderMap, multi, depth
    if OptionChain.Count != 0
    {
        if multi
        {
            initDepth := 0
            initDepth := depth
            tempOrder := Map()
            tempOrder := OrderMap
            tempOption := Map()
            tempOption := OptionChain
            Loop gui_.Wiz.multi.tabNames.Count
            {
                if gui_.Wiz.multi.LB.Has(A_Index)
                {
                    if gui_.Wiz.multi.LB[A_Index].Text = "" {
                        Msgbox "Error, please fill out all tabs."
                        return
                    }
                    option := gui_.Wiz.multi.tabNames[A_Index] ": " gui_.Wiz.multi.LB[A_Index].Text
                    tempOrder[cut]["details"].Push(option)
                    tempOption.Set(depth += 1, option)
                }
            }
            hideMultiTab()
            multi := false
            orderMap := tempOrder
            OptionChain := tempOption
        }
        gui_.Wiz.main.LB.Delete()
        gui_.Wiz.main.LB.Add(["Confirmed."])
        gui_.order.LV.Delete()
        if OrderMap.Has(cut) || OrderMap[cut].Has("details")
            if OrderMap[cut]["details"] != []
                OrderMap[cut]["details"] := []
        for depthkey, stringVal in OptionChain
        {
            OrderMap[cut]["details"].Push(stringVal)
        }
        OrderMap[cut]['comment'] := gui_.Wiz.main.comments.Value
        gui_.Primary.LV.SetCell(gui_.Primary.LV.GetNext(), 2, "✓")
        orderMapToOrderLV(gui_.order.LV)
        orderMapToOrderLV(gui_.order.comments, , 1)
    }
}


class Sausage
{
    static Call(*)
    {
        global orderMap
        gui_.wiz.main.LB.Delete()
        displaySausage()
        if !FileExist(sausage_log)
            return
        orderMap['Sausage'] := Map('details', Json.Load(FileOpen(sausage_log, "r").Read()))
        orderMap['Sausage']['comment'] := ""
    }
}

/*
   Function: TabNav

   Description:
   This function is used to navigate between tabs in a GUI based on the text of the selected control.
   If the text contains the word "Order", it will show the "order" tab and hide the "Wizard" tab.
   Otherwise, it will show the "Wizard" tab and hide the "order" tab.

   Parameters:
   - GuiCtrl: The control object representing the selected control.
   - *: Optional parameter, not used in this function.

   Returns: None
*/
TabNav(GuiCtrl, *)
{
    global gui_, OrderMap
    if InStr(GuiCtrl.Text, "Review")
    {
        if not gui_.order.VisibleStatus()
        {
            gui_.order.ToggleVisible()
            gui_.Primary.ToggleVisible()
            gui_.Wiz.main.ToggleVisible()
            GuiResizer.Now(gui_)
        }
    }
    else if InStr(GuiCtrl.Text, "Wizard")
    {
        if not gui_.Wiz.main.VisibleStatus()
        {
            gui_.order.ToggleVisible()
            gui_.Primary.ToggleVisible()
            gui_.Wiz.main.ToggleVisible()
            GuiResizer.Now(gui_)
        }
    }
    else if InStr(GuiCtrl.Text, "Save")
    {
        tempMap := Map()
        tempMap['order'] := OrderMap
        tempMap["customer"] := Customer.Profile
        tempMap["animals"] := Customer.event.animals
        Writer(lastOrder, Jsons.Dumps(tempMap))
        requests.appName := "events"
        requests.tier := 1
        content := saveSheet()
        postReq := requests.Put(Customer.event.map['id'], Map('saved_cutsheet', content))
        IsObject(postReq) ? postReq.Has("message") ? MsgBox(postReq["message"]) : MsgBox(postReq) : MsgBox(postReq)
    }
}

setAnimalsfromOrder(*)
{
    global gui_
    gui_.Nav.ToggleVisible(0)
    gui_.order.ToggleVisible(0)
    gui_.Wiz.main.ToggleVisible(0)
    gui_.Primary.ToggleVisible(0)
    if !gui_.HasProp("howMany")
        howManyAnimals()
    else
    {
        howManyAnimalsState()
        gui_.howMany.ToggleVisible(1)
    }
}

changeCommentField(ctrl, *)
{
    global OrderMap, cut
    OrderMap[cut]['comment'] := ctrl.Value
}

SelectRecipient(*)
{
    global gui_
    Customer.ID := ""
    if gui_.HasProp("Nav")
        gui_.Nav.ToggleVisible(0)
    if gui_.HasProp("order")
        gui_.order.ToggleVisible(0)
    if gui_.HasProp("wiz")
        gui_.Wiz.main.ToggleVisible(0)
    Customer.ID := ""
    Customer()
    loop
    {
        Sleep(100)
        if Customer.ID = ""
        {
            continue
        }
        else
        {
            Customer.ID := ""
            break
        }
    }
    Customer.Recipient := Customer.profile
    gui_.order.Recipient.Value := Customer.Recipient["full_name"]
    gui_.order.Recipient.Enabled := 0
    gui_.Nav.ToggleVisible(1)
    gui_.order.ToggleVisible(1)
    gui_.cust := {}
    return Customer.Recipient
}

EnableCommentsField(*)
{
    global gui_, cut
    RowNumber := gui_.Primary.LV.GetNext(0)
    if not RowNumber
        return false
    cut := gui_.Primary.LV.GetRow(1)
    if (cut = "Cut")
    {
        return
    }
    commentField(&gui_)
    gui_.Wiz.main.LB.Visible := 0
    gui_.Wiz.main.Header2.Visible := 0
    gui_.Comment.edit.Visible := 1
    gui_.Comment.edit.Enabled := 1
    GuiResizer.Now(gui_)

    ButtonStyle(gui_.Comment.Confirm, 0, "success")
    ButtonStyle(gui_.Comment.Cancel, 0, "warning")
    gui_.Wiz.main.buttons.ToggleVisible()
    gui_.primary.ToggleEnabled()
    gui_.Nav.ToggleEnabled()
}


commentConfirmClick(*)
{
    global cut, OrderMap
    OrderMap[cut]["comment"] := gui_.Comment.edit.Value
    orderMapToOrderLV(gui_.order.comments, , 1)
    gui_.Comment.ToggleVisible()
    gui_.Wiz.main.LB.Visible := 1
    gui_.Wiz.main.Header2.Visible := 1
    gui_.Wiz.main.buttons.ToggleVisible()
    gui_.primary.ToggleEnabled()
    gui_.Nav.ToggleEnabled()
    LB_PrimaryChange(gui_.Primary.LV)
}

commentCancelClick(*)
{
    gui_.Comment.ToggleVisible()
    gui_.Wiz.main.LB.Visible := 1
    gui_.Wiz.main.Header2.Visible := 1
    gui_.Wiz.main.buttons.ToggleVisible()
    gui_.primary.ToggleEnabled()
    gui_.Nav.ToggleEnabled()
}

FinalizeCutsheet(GuiCtrl, *)
{
    global cutsheetID
    if !checkSausage()
        return
    Customer.event.animals.remaining := Customer.event.animals.HasProp("temp_remaining") ? Customer.event.animals.temp_remaining : Customer.event.animals.remaining
    requests.appName := "cutsheets"
    if InStr(GuiCtrl.Text, "Update")
    {
        content := updateSheet()
        postReq := requests.Put(cutsheetID, content)
        GuiCtrl.Text := "Save Cutsheet"
    }
    else
    {
        content := saveSheet()
        postReq := requests.Post(content)
    }
    if checkResponse(&postReq)
    {
        requests.appName := "events"
        requests.tier := 1
        postReq := requests.Put(Customer.event.map['id'], Map('cutsheet_remainder', Customer.event.animals.remaining))
        checkResponse(&postReq, 1)
    }
    else
    {
        MsgBox(postReq "`n`nError occured saving cutsheet, unable to save event.")
    }

    checkResponse(&postReq, msg?)
    {
        global gui_
        static msgStr := ""
        if IsObject(postReq)
        {
            if postReq.Has("message")
            {
                msgStr .= postReq["message"] "`n`n"
                if IsSet(msg)
                {
                    MsgBox msgStr
                    msgStr := ""
                    gui_.order.ToggleVisible(0)
                    gui_.Wiz.main.ToggleVisible(0)
                    gui_.nav.ToggleVisible(0)
                    gui_.primary.ToggleVisible(0)
                    resetCutsheetVars()
                    cutsheetState()
                    gui_.csCRUD.ToggleVisible(1)
                }
                return true
            }
        } else {
            if postReq is String ? Msgbox(postReq) : MsgBox(postReq["message"])
                return true
        }
    }
}

checkSausage()
{
    global orderMap
    if FileExist(sausage_log)
    {
        content := FileOpen(sausage_log, "r").Read()
        if content = ""
        {
            userResponse := MsgBox("Sausage has not been accounted for, are you sure you'd like to continue?", "Sausage has not been accounted for, are you sure you'd like to continue?", "4")
            if (userResponse = "Yes") {
                return true
            } else if (userResponse = "No") {
                return false
            }
        }
    }
    return true
}

updateSheet()
{
    global orderMap
    requests.tier := 1
    content := Map("cutsheet", OrderMap,
        "yweek", A_YWeek, "amount", Customer.event.animals.amount)
    if Customer.recipient.Has('id')
        content["recipient_id"] := Customer.recipient['id']
    return content
}
saveSheet()
{
    requests.tier := 1
    content := Map("event_id", Customer.event.map['id'],
        "event", Customer.event.map['id'],
        "producer", Customer.Producer["id"],
        "cutsheet", OrderMap,
        "yweek", A_YWeek,
        "animal", Customer.event.animals.animal,
        "amount", Customer.event.animals.amount
    )
    Customer.recipient.Has('id') ? content["recipient"] := Customer.recipient['id'] : content
    return content
}