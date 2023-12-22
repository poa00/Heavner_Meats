#Requires autohotkey v2
#SingleInstance force
#Include requests/utils.ahk
#Include GuiResizer.ahk
#Include meatParsed.ahk
#Include util_cut_sheet.ahk
#Include CtrlObjs.ahk
#Include pyAr.ahk
#Include submenuTab.ahk
#Include popupSubmenu.ahk

; * ---------------------------------------------------------
; * Overview: This script creates a GUI for selecting options
; * and managing orders. It dynamically generates options
; * based on user selections and accumulates orders.
; * ---------------------------------------------------------


; * ---------------------------------------------------------
; * GUI Initialization
; * ---------------------------------------------------------
gui__ := constructGUI()

gui__.myPopup := {}
gui__.myPopup.Enabled := 0
SetWinDelay(1)
; * gui__.Opt("+E0x02000000 +E0x00080000")
listBoxUnselect()
gui__.backcolor := "121d30"
darkmode(gui__)
gui__.Main.Header.NoBack := 1
gui__.Main.Header.Opt("Background121d30")
gui__.optionWiz.GB.Opt("Background121d30")
gui__.PrimaryGP.Opt("Background121d30")
gui__.optionWiz.Header2.Opt("Background313131")
gui__.Main.LB_OrdersBox.Opt("Background121d30")
; * ---------------------------------------------------------
; * Event Handlers
; ; * ---------------------------------------------------------
gui__.Primary.LB.OnEvent("Change", LB_PrimaryChange)
gui__.optionWiz.Next.OnEvent("Click", OptNextButton)
gui__.optionWiz.Back.OnEvent("Click", OptBackButton)
gui__.optionWiz.Restart.OnEvent("Click", finishButtonClick)
gui__.optionWiz.Finished.OnEvent("Click", finishButtonClick)

gui__.Show("h" 1400 " w" 2100)
gui__.Maximize()



; WinSetTransparent 240, "ahk_id " gui__.hwnd

; * ---------------------------------------------------------
; * Functions
; * ---------------------------------------------------------

/**
 * Sets a flag when the primary list box is first selected.
 * 
 * @param {*} * 
 * @return {void}
 */
onFirstListboxChange(*)
{
    if not IsSet(isFirstboxSelected)
        isFirstboxSelected := true
}


/**
 * Function: loopBeef
 * Description: Retrieves keys from the global BeefMap variable.
 * @returns {Array}
 */
loopBeef()
{
    global BeefMap
    TEMP := []
    for i, l in BeefMap {
        TEMP.Push(i)
    }
    return TEMP
}


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
* Finally, it calls the processMap function with the display, gui__.optionWiz.LB, and PrimarySelect as arguments.

Parameters:
- GuiCtrl: The ListBox control whose value has changed.

Returns: None
*/
LB_PrimaryChange(GuiCtrl, *)
{
    global PrimarySelect, Opt, display, OptionChain, OrderMap
    display.depth := 2
    if gui__.myPopup.Enabled = 1
    {
        toggleOptionWiz()
        gui__.myPopup.Enabled := 0
    }
    if GuiCtrl.Text = ""
        return
    ; deleteLB(gui__.LB_Option2__, gui__.LB_Option3__, gui__.LB_Option4__, gui__.LB_Option1__)
    PrimarySelect.value := GuiCtrl.Text
    display.map := Map()
    display.map[display.depth] := BeefMap[PrimarySelect.value]
    display.lastSelect := ""
    OptionChain := Map()
    setWizHeaderText(PrimarySelect.value)
    ; gui__.LBOption1__Text.Value := ShortenKey(GuiCtrl.Text)
    display.type := Type(BeefMap[PrimarySelect.value])
    processMap(&display, gui__.optionWiz.LB, PrimarySelect.value)
}


; Function: OptNextButton
; Description: Handles the logic for the next button in the option wizard.
; Parameters:
;   - GuiCtrl: The GUI control object.
;   - *: Optional parameters.
; 
; Global Variables:
;   - PrimarySelect: The primary selection.
;   - Opt: The options.
;   - display: The display object.
;   - OptionChain: The option chain.
;   - OrderMap: The order map.
OptNextButton(GuiCtrl, *)
{
    global PrimarySelect, Opt, display, OptionChain, OrderMap
    if gui__.optionWiz.LB.Text = "" or display.lastSelect = gui__.optionWiz.LB.Text
        return
    display.lastSelect := gui__.optionWiz.LB.Text
    if Type(display.map[display.depth]) = "Map"
    {
        if display.map[display.depth].Has(gui__.optionWiz.LB.Text)
        {
            addToWizHeader(gui__.optionWiz.LB.Text)
            display.depth := display.depth + 1
            display.map[display.depth] := display.map[display.depth - 1][gui__.optionWiz.LB.Text]
            processMap(&display, gui__.optionWiz.LB, lastCtrlText := gui__.optionWiz.LB.Text)
        }
    } else if Type(display.map[display.depth]) = "Array" {
        if display.map[display.depth].Contains(gui__.optionWiz.LB.Text)
        {
            addToWizHeader(gui__.optionWiz.LB.Text)
            display.depth := display.depth + 1
            display.map[display.depth] := display.map[display.depth - 1][display.map[display.depth - 1].Contains(gui__.optionWiz.LB.Text)]
            processMap(&display, gui__.optionWiz.LB, lastCtrlText := gui__.optionWiz.LB.Text)
        }
    } else {
        treeComplete()
    }
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
    global PrimarySelect, Opt, display, OptionChain
    if display.HasOwnProp("depth") && display.HasOwnProp("map")
    {
        if display.depth > 2
        {
            if display.map.Has(display.depth)
                display.map.Delete(display.depth)
            if OptionChain.Has(display.depth)
                OptionChain.Delete(display.depth)
            display.depth := display.depth - 1
            display.type := Type(display.map[display.depth])
            processMap(&display, gui__.optionWiz.LB)
            setWizHeaderText()
        }
    }
}

; Function: finishButtonClick
; Description: Handles the logic for the finish button in the option wizard.
; Parameters:
;   - *: Optional parameters.
; Global Variables:
;   - PrimarySelect: The primary selection.
;   - Opt: The options.
;   - display: The display object.
;   - OptionChain: The option chain.
;   - OrderMap: The order map.
finishButtonClick(*)
{
    global PrimarySelect, Opt, display, OptionChain, OrderMap
    if OptionChain != Map()
    {
        gui__.LB_Orders.Delete
        if OrderMap[PrimarySelect.value] != []
            OrderMap[PrimarySelect.value] := []
        for depthkey, stringVal in OptionChain
        {
            OrderMap[PrimarySelect.value].Push(stringVal)
        }
        for category, Arr in OrderMap
        {
            gui__.LB_Orders.Add([category])
            for val in Arr
            {
                if category = val
                    continue
                gui__.LB_Orders.Add(["  - " val])
            }
        }
    }
}


treeComplete()
{

}


/*
    Function: processMap

    Description:
    This function processes a map object and populates a GUI listbox control with the keys or values from the map, depending on the type of the map object. It also sets the wizard header text and handles special cases for string values.

    Parameters:
    - display (object): The display object containing the map and depth information.
    - NextLB_GuiCtrlObj (object): The GUI listbox control object to populate.
    - lastCtrlText (string, optional): The last control text value.

    Returns:
    None
*/
processMap(&display, NextLB_GuiCtrlObj, lastCtrlText?)
{
    global gui__

    display.type := Type(display.map[display.depth])

    if IsSet(lastCtrlText)
        OptionChain.Set(display.depth, lastCtrlText)

    NextLB_GuiCtrlObj.Delete
    setWizHeaderText()

    if Type(display.map[display.depth]) = "Map"
    {
        for key, popupMap in display.map[display.depth]
        {
            if not key = "See sub-menu"
                NextLB_GuiCtrlObj.Add([key])
            else 
                buildPopup(popupMap)
        }
    }
    else if Type(display.map[display.depth]) = "Array"
    {
        for val in display.map[display.depth]
        {
            NextLB_GuiCtrlObj.Add([val])
        }
    }
    else if Type(display.map[display.depth]) = "String"
    {
        if IsSet(lastCtrlText)
        {
            if display.map[display.depth] = lastCtrlText
            {
                NextLB_GuiCtrlObj.Add(["Finished."])
                return
            }
        }

        if display.map[display.depth] = "Finished."
            NextLB_GuiCtrlObj.Add(["Finished."])
        else
            NextLB_GuiCtrlObj.Add([display.map[display.depth]])
    }
    else
    {
        try
            NextLB_GuiCtrlObj.Add([display.map[display.depth]])
        catch as e
            Msgbox e.Message "`nError trying to add to listbox at the end of processMap function."
    }
}

populateOrder()
{
    global OrderMap
    for category, Arr in OrderMap
    {

    }
}

setWizHeaderText(str?)
{
    global gui__, display, OptionChain
    gui__.optionWiz.Header2.Text := ""
    linebreak := "`n - "
    for key, val in OptionChain
    {
        if (A_Index = 1)
        {
            if IsSet(val) && Trim(val) != ""
            {
                gui__.optionWiz.Header2.Text .= Trim("Set options for " val ":")
            }
        }
        else if IsSet(val) and Trim(val) != ""
        {
            gui__.optionWiz.Header2.Text .= "`n  - " Trim(val)
        }
    }
}

; /**
;  * Function: combineOptions
;  * 
;  * Description: Combines selected options into a string.
;  * 
;  * Updates the global order map.
;  * @returns {string} - The combined options string.
;  */
; combineOptions()
; {
;     global Primary, display
;     if Primary = {} or Opt1 = {}
;     {
;         return 0
;     }
;     if Primary.value = 0
;         return
;     Opt1.Combined := Opt2.value != "" ? Opt1.value ": " : Opt1.value
;     Opt2.Combined := Opt3.value != "" ? Opt2.value " => " : Opt2.value
;     Opt3.Combined := Opt4.value != "" ? Opt3.value ": " : Opt3.value
;     combinedOptions := Trim(Primary.value " =>   " Opt1.Combined " " Opt2.Combined " " Opt3.Combined " " Opt4.Value)
;     combinedOptions := StrReplace(combinedOptions, "Add?", "")
;     if not Trim(Opt1.Combined) = ""
;     {
;         orderMap.Set(Primary.value, Opt1.Combined)
;         if not Trim(Opt2.Combined) = ""
;         {
;             orderMap[Primary.value] := Map(Opt1.Combined, Opt2.Combined)
;             if not Trim(Opt3.Combined) = ""
;             {
;                 orderMap[Primary.value][Opt1.Combined] := Map(Opt2.Combined, Opt3.Combined)
;                 if not Trim(Opt4.Value) = ""
;                 {
;                     orderMap[Primary.value][Opt1.Combined][Opt2.Combined] := Map(Opt3.Combined, Opt4.Value)
;                 }
;             }
;         }
;     }
;     return combinedOptions
; }


/**
 * Function: addButtonClick
 * 
 * Description: Triggered when the "Add" button is clicked.
 * 
 * Combines options and adds them to the Order List Box.
 * @param {*} *
 * @returns {void}
 */
; addButtonClick(*)
; {
;     global Opt3, Opt1, Opt2, Opt4, Primary
;     if Opt1.value = ""
;         return
;     combinedOptions := combineOptions()
;     gui__.LB_Orders.Add([combinedOptions])
; }


/**
 * Function: removeButtonClick
 * * Description: Triggered when the "Remove" button is clicked. * 
 * Removes the selected order from the Order List Box.
 * @param {*} *
 * @returns {void}
 */
; removeButtonClick(*)
; {
;     if gui__.LB_Orders.Text = ""
;         return
;     combinedOptions := combineOptions()
;     gui__.LB_Orders.Delete(gui__.LB_Orders.Value)
; }


/**
 * Function: toggleSubMenu
 * 
 * Description: Toggles the visibility of a sub-menu in the GUI.
 * 
 * Returns the position of the sub-menu group box before toggling.
 * @param {*} *
 * @returns {Object} - The position of the sub-menu group box before toggling.
 */
toggleSubMenu(*)
{
    global gui__, GuiReSizer, specialMenu
    static toggleSubMenuStatus := 0
    GbPos := {}
    if toggleSubMenuStatus = 0 {
        gui__.Main.orderGroupBox.GetPos(&x, &y, &w, &h)
        specialcaseMenu(x, y, w, h)
        gui__.Main.orderGroupBox.Text := "Multi-Option Select"
        gui__.LB_Orders.Visible := 0
        toggleSubMenuStatus := 1
        return GbPos
        ;gui__.Radios2.Opt("x" order_X " ym" order_Y " w" w/6 " h" h/4)
    } else {
        gui__.Main.orderGroupBox.Text := "Order Details"
        gui__.LB_Orders.Visible := 1
        toggleSubMenuStatus := 0
        for k, v in specialMenu.OwnProps()
        {
            v.Visible := 0
        }
    }
}


/**
 * Function: specialcaseMenu
 * 
 * Description: Sets up a special case menu in the GUI.
 * @param {number} x - X-coordinate position.
 * @param {number} y - Y-coordinate position.
 * @param {number} w - Width of the menu.
 * @param {number} h - Height of the menu.
 * @param {number} hide - Flag to hide the menu.
 * @returns {void}
 */
specialcaseMenu(x, y, w, h, hide := 0)
{
    global specialMenu, gui__
    order_X := x + 25
    order_Y := y + 45
    order_W := 0.44
    order_H := 0.49

    specialMenu.Radio1 := gui__.Add("Radio", "x" order_X " y" order_Y " ", "2hello this is ribeye")
    specialMenu.Radio1.SetFont("s16")
    ; * gui__.Radios1.Opt("x" order_X " y" order_Y) ; * 20% from Left Margin
    ;gui__.Radios1.YP := order_Y ; * 45% from Top Margin
    specialMenu.Radio2 := gui__.Add("Radio", "x" order_X " y" order_Y + 75 " ", "3hello this is ribeye")
    specialMenu.Radio2.SetFont("s16")
}