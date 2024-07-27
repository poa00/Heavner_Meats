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
    global cut, processFunc, OptionChain, OrderMap,  refMeatCuts, multi_
    if !IsSet(multi_)
        multi_ := false
    if multi_
        hideMultiTab(), multi_ := false
    gui_.Wiz.main.tab.Choose(1)
    str := ""
    rowNum := GuiCtrl.GetNext(0, "F")
    if not rowNum
        return 0
    cut := GuiCtrl.GetRow(1)
    if cut = "Cut" or cut = false or cut = "Im a listbox"
        return
    if GuiCtrl.Focused = ""
        return
    processFunc.lastSelect := GuiCtrl.Text
    processFunc.map := Map()
    OptionChain := Map()
    processFunc.map := refMeatCuts[cut]
    processFunc.lastSelect := ""
    processFunc.type := Type(refMeatCuts[cut])
    if OrderMap[cut].Has("comment")
        try 
            gui_.Wiz.main.comments.Value := OrderMap[cut]['comment'] 
        catch as e
            gui_.Wiz.main.comments.Value := ""
    if !OrderMap.Has(cut) || !orderMap[cut].Has("details")
        return
    t := Type(OrderMap[cut]["details"])
    if t = "Array" && OrderMap[cut]["details"].Length != 0
    {
        pushToLB(&a := processFunc.map, gui_.Wiz.main.LB, &x := false, cut)
        setWizHeaderText(cut)
        for item in OrderMap[cut]["details"]
        {
            if A_Index > 1
            {
                addToWizHeader(item)
            }
        }
    }
    else if t = "Map" && OrderMap[cut]["details"].Has("split") && OrderMap[cut]["details"].Has("string")
    {
        try setWizHeaderText("_")
        for i in OrderMap[cut]["details"]['string']
            addToWizHeader(i)
    } else
    {
        pushToLB(&a := processFunc.map, gui_.Wiz.main.LB, &x := false, cut)
        setWizHeaderText(cut)
    }

    ; if OrderMap.Has("Sausage")
    ;     if OrderMap['Sausage'].Has("details")
    ;         FileOpen(sausage_log, "w").Write(JSON.Dump(OrderMap['Sausage']['details']))
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
    global cut, processFunc, OptionChain, OrderMap, multi_
    guiText := gui_.Wiz.main.LB.Text
    if multi_
        SwitchTabs()
    if (guiText = "" || !IsSet(cut) || guiText = processFunc.lastSelect || guiText = "Confirmed." || guiText = "Finished." || guiText = "Im a listbox") {
        return
    }
    if IsSet(lastCut) && lastCut != cut || !IsSet(lastCut)
        if OrderMap.Has(cut) && OrderMap[cut].has("details")
            if Type(OrderMap[cut]["details"]) = "Map" && OrderMap[cut]["details"].Has("split") 
                if splitOverwriteYN()
                    OrderMap[cut]["details"] := []
            else
                return
    static lastCut := cut
    processFunc.lastSelect := guiText
    currentMap := processFunc.map
    mapType := Type(currentMap)
    nextMap := setMap(currentMap, guiText)
    PasstoProcess(nextMap, gui_.Wiz.main.LB, guiText)
    
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
    OptionChain.Set(OptionChain.Count+1, GuiCtrl.Text)
    if guiText = "Click confirm to save options." or InStr(guiText, "Yes") {
        ConfirmButtonClick()
    } else {
        addToWizHeader(GuiCtrl.Text)
        pushToLB(&nextMap, GuiCtrl, &currentMap, guiText)
    }
}
setMap(currentMap, guiText) {
    global processFunc, OrderMap
    ; Handle incrementing depth for Map or Array types
    if IsObject(currentMap) { 
        if currentMap is Map && currentMap.Has(guiText) {
            processFunc.map := currentMap[guiText]
        } else if currentMap.Contains(guiText) {
            processFunc.map := currentMap[currentMap.Contains(guiText)]
        }
        return processFunc.map
    }
    return false
}

splitOverwriteYN(){
    userResponse := MsgBox("This cut has an existing split order, would you like to erase this split?`nOtherwise click split option to modify.", "This cut has an existing split order, would you like to erase this split?", "52")
    if (userResponse = "Yes") {
        return true 
    } else if (userResponse = "No") {
        return false
    }
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
pushToLB(&newMap, NextLB_GuiCtrlObj, &lastMap, lastCtrlText?)                
{
    global gui_, wizT, multi_
    processFunc.type := Type(newMap)

    if IsSet(lastCtrlText)
        OptionChain.Set(OptionChain.Count, lastCtrlText)
    indexChain()
    NextLB_GuiCtrlObj.Delete
    setWizHeaderText()
    switch Type(newMap)
    {
        case "Map":
            {
                if newMap.Count = 1 && !newMap.Has("multi")
                {
                    for k, v in newMap
                    {
                        setMap(newMap, k)
                        PasstoProcess(v, gui_.Wiz.main.LB, k)
                    }
                }
                else
                    for key, popupMap in newMap
                    {
                        if not key = "multi"
                            NextLB_GuiCtrlObj.Add([key])
                        else
                        {
                            multi_ := true, displaySubmenuTabs(popupMap)
                        }
                    }
            }
        case "Array":
            for val in newMap
                NextLB_GuiCtrlObj.Add([val])
        case "String":
            {
                if IsSet(lastCtrlText) && newMap = lastCtrlText
                {
                    ConfirmButtonClick()
                    return
                }
                if newMap = "Finished." && newMap != lastCtrlText
                    NextLB_GuiCtrlObj.Add([newMap]), ConfirmButtonClick()
                else if InStr(newMap, "Finished")
                    NextLB_GuiCtrlObj.Add([newMap]), ConfirmButtonClick()
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

SplitClick(*)
{
    global refMeatCuts, cut, OrderMap
    animals := 2
    gMenu.clear()
    if cut = ""
        return
    if OrderMap[cut].Has("details")
        if Type(OrderMap[cut]["details"]) = "Map" && OrderMap[cut]["details"].Has("split")
            gMenu.order := OrderMap[cut]["details"]["split"]
    split := {}
    split.cut := cut
    split.map := refMeatCuts[cut]
    try split.amount := Customer.event.animals.amount
    try split.animal := Customer.event.animals.animal
    split_Menu := gMenu(split)
    darkMode(split_Menu)
    gMenu.iterate(split_Menu)
    while gMenu.submit = 0 && gMenu.cancel = 0
        Sleep(100)
    if gMenu.submit
        OrderMap[cut]['details'] := Map('split', gMenu.Order, "string", gMenu.OptionString), gui_.Primary.LV.SetCell(gui_.Primary.LV.GetNext(), 2, "✓")
    GuiFromHwnd(gMenu.hwnd).Destroy()
    setWizHeaderText()
    return
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
    global cut, processFunc, OptionChain, OrderMap, multi_
    if OptionChain.Count = 0
        return
    if OptionChain.Has("confirm")
        OptionChain.RemoveAt(OptionChain.Contains("confirm"))
    if multi_
    {
        initDepth := 0
        initDepth := OptionChain.count
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
                tempOption.Set(A_Index, option)
            }
        }
        hideMultiTab()
        multi_ := false
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
    gui_.Wiz.main.tab.Choose(1)
}

indexChain()
{
    global OptionChain
    temp := Map()
    if OptionChain.Count = 0
        return
    for _, v in OptionChain
    {
        temp[A_Index] := v
    }
    OptionChain := Map()
    OptionChain := temp
}


class Sausage
{
    static Call(*)
    {
        global orderMap
        gui_.wiz.main.LB.Delete()
        if orderMap.Has('Sausage') && orderMap['Sausage'].Has('details') 
            && orderMap['Sausage']['details'].Has(1)
            displaySausage(orderMap['Sausage']['details'][1])
        else
            displaySausage()
        if !FileExist(sausage_log)
            return
        orderMap['Sausage'] := Map('details', SausageGUI.storage)
        orderMap['Sausage']['comment'] := ""
    }
}

changeCommentField(ctrl, *)
{
    global OrderMap, cut
    if cut != ""
        OrderMap[cut]['comment'] := ctrl.Value
    else
        Msgbox "Select a cut"
}

