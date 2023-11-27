#Requires autohotkey v2
#SingleInstance force
#Include requests/utils.ahk
#Include GuiResizer.ahk
#Include variable.ahk
#Include meatParsed.ahk

; ---------------------------------------------------------
; Overview: This script creates a GUI for selecting options
; and managing orders. It dynamically generates options
; based on user selections and accumulates orders.
; ---------------------------------------------------------

x := SysGet(16)
y := SysGet(17)
anchorBoxiesX := 0.02
listboxTopLeftH := 0.35
darkModeColor := "Black"
Opt1Selection := ""

; ---------------------------------------------------------
; GUI Initialization
; ---------------------------------------------------------
gui__ := Gui(, "Test - List"), gui__.Opt("+Resize +MinSize250x150 -DPIScale")
gui__.OnEvent("Size", GuiReSizer) ; assign GuiReSizer to handle all size changes for this Gui
gui__.SetFont("s37 cWhite")
PrimarySelection := { value: False, type: false }
anchorBoxiesX := 0.02
listboxTopLeftH := 0.35
;Relative Positioning:
gui__.ListBox := {}
Opt3Selection := ""
Opt2Selection := ""
Opt1Selection := ""
Opt4Selection := ""
combinedOptions := ""
specialMenu := {}
orderMap := Map()

; ---------------------------------------------------------
; GUI Components - List Boxes, Group Boxes, Buttons
; ---------------------------------------------------------
gui__.LB_Primary := gui__.Add("ListBox", "w" 400 "", loopBeef())
gui__.LB_Primary.WidthP := 0.45
gui__.LB_Primary.YP := 0.02
gui__.LB_Primary.XP := anchorBoxiesX ; 10 from Left Margin
gui__.LB_Primary.WidthP := 0.25
gui__.LB_Primary.HeightP := 0.987
gui__.LB_Primary.OnEvent("Change", onFirstListboxChange)
;gui__.ListBox.Two := gui__.add("button", ,"hello world")
;gui__.ListBox.Two.XP := anchorBoxiesX ; 10 from Left Margin

optionsGroupBox_XP := -0.71
optionsGroupBox_YP := 0.02
optionsGroupBox_WP := 0.69
optionsGroupBox_HP := 0.43
gui__.optionsGroupBox := gui__.Add("GroupBox", "Background162135", "Select from one of the below options")
gui__.optionsGroupBox.XP := optionsGroupBox_XP ; 20% from Left Margin
gui__.optionsGroupBox.YP := optionsGroupBox_YP ; 45% from Top Margin
gui__.optionsGroupBox.WidthP := optionsGroupBox_WP ; Right Edge maintain 50% from Right Margin
gui__.optionsGroupBox.HeightP := optionsGroupBox_HP ; Bottom Edge maintain 30% from Bottom Margin
gui__.optionsGroupBox.SetFont("s12")
gui__.optionsGroupBox.backcolor := "cGrey"


optionText_YP := 0.06  
optionText_XP := -0.70
optionText_WP := 0.17


gui__.LBOption1__Text := gui__.Add("Text", "r1", "Option 1")
gui__.LBOption1__Text.XP := optionText_XP
gui__.LBOption1__Text.YP := optionText_YP
gui__.LBOption1__Text.WidthP := optionText_WP
gui__.LBOption1__Text.HeightP := 0.03
gui__.LBOption1__Text.SetFont("s14")


option_XP := -0.70
option_YP := 0.095
option_WP := 0.16
option_HP := 0.365


gui__.LB_Option1__ := gui__.Add("ListBox", "", [""])
gui__.LB_Option1__.SetFont("s20")
gui__.LB_Option1__.XP := option_XP ; 20% from Left Margin
gui__.LB_Option1__.YP := option_YP  ; 45% from Top Margin
gui__.LB_Option1__.WP := option_WP + 0.02
gui__.LB_Option1__.HP := option_HP


gui__.LB_Option2__ := gui__.Add("ListBox", "", [""])
gui__.LB_Option2__.SetFont("s20")
gui__.LB_Option2__.XP := option_XP + option_WP + 0.02 ; 20% from Left Margin
gui__.LB_Option2__.YP := option_YP  ; 45% from Top Margin
gui__.LB_Option2__.WP := option_WP
gui__.LB_Option2__.HP := option_HP


gui__.LB_Option3__ := gui__.Add("ListBox", "", [""])
gui__.LB_Option3__.SetFont("s20")
gui__.LB_Option3__.XP := option_XP + option_WP * 2 + 0.02 ; 20% from Left Margin
gui__.LB_Option3__.YP := option_YP  ; 45% from Top Margin
gui__.LB_Option3__.WP := option_WP
gui__.LB_Option3__.HP := option_HP


gui__.LB_Option4__ := gui__.Add("ListBox", "", [""])
gui__.LB_Option4__.SetFont("s20")
gui__.LB_Option4__.XP := option_XP + option_WP * 3 + 0.02 ; 20% from Left Margin
gui__.LB_Option4__.YP := option_YP  ; 45% from Top Margin
gui__.LB_Option4__.WP := option_WP
gui__.LB_Option4__.HP := option_HP


order_X := 0.55
order_Y := 0.47
order_W := 0.44
order_H := 0.49
gui__.orderGroupBox := gui__.Add("GroupBox", "Background19212f", "Order Details")
gui__.orderGroupBox.XP := order_X ; 20% from Left Margin
gui__.orderGroupBox.YP := order_Y ; 45% from Top Margin
gui__.orderGroupBox.WidthP := order_W ; Right Edge maintain 50% from Right Margin
gui__.orderGroupBox.HeightP := order_H ; Bottom Edge maintain 30% from Bottom Margin
gui__.orderGroupBox.SetFont("s16")
;SimpleNameForEdit.XP := 0.1
;SimpleNameForEdit.YP := -0.45
;gui__.GroupBox
;gui__.LB_Orders
gui__.LB_Orders := gui__.Add("ListBox", "Background162235", [])
gui__.LB_Orders.SetFont("s16")
gui__.LB_Orders.XP := order_X + 0.01 ; 20% from Left Margin
gui__.LB_Orders.YP := order_Y + 0.04 ; 45% from Top Margin
gui__.LB_Orders.WP := order_W - 0.02
gui__.LB_Orders.HP := order_H - 0.05


buttonGroup_X := -0.71
buttonGroup_Y := 0.47
buttonGroup_W := 0.23
buttonGroup_H := 0.49
gui__.buttonGroupBox__ := gui__.Add("GroupBox", , "Buttons")

gui__.buttonGroupBox__.XP := buttonGroup_X
gui__.buttonGroupBox__.YP := buttonGroup_Y
gui__.buttonGroupBox__.WP := buttonGroup_W + 0.02
gui__.buttonGroupBox__.HP := buttonGroup_H
gui__.buttonGroupBox__.SetFont("s16")

gui__.buttonGroupBox__.add := gui__.Add("Button", , "Add")
gui__.buttonGroupBox__.add.XP := buttonGroup_X + 0.01
gui__.buttonGroupBox__.add.YP := buttonGroup_Y + 0.05
gui__.buttonGroupBox__.add.WP := buttonGroup_W - 0.005
gui__.buttonGroupBox__.add.HP := buttonGroup_H / 6
gui__.buttonGroupBox__.add.SetFont("s15")

gui__.buttonGroupBox__.remove := gui__.Add("Button", , "Remove")
gui__.buttonGroupBox__.remove.XP := buttonGroup_X + 0.01
gui__.buttonGroupBox__.remove.YP := buttonGroup_Y + 0.05 + buttonGroup_H / 6
gui__.buttonGroupBox__.remove.WP := buttonGroup_W - 0.005
gui__.buttonGroupBox__.remove.HP := buttonGroup_H / 6
gui__.buttonGroupBox__.remove.SetFont("s15")

gui__.buttonGroupBox__.toggle := gui__.Add("Button", , "Toggle")
gui__.buttonGroupBox__.toggle.XP := buttonGroup_X + 0.01
gui__.buttonGroupBox__.toggle.YP := buttonGroup_Y + 0.05 + buttonGroup_H / 6 * 2
gui__.buttonGroupBox__.toggle.WP := buttonGroup_W - 0.005
gui__.buttonGroupBox__.toggle.HP := buttonGroup_H / 6
gui__.buttonGroupBox__.toggle.SetFont("s15")


listBoxUnselect()
gui__.backcolor := "121d30"
darkmode(gui__)

; ---------------------------------------------------------
; Event Handlers
; ---------------------------------------------------------
gui__.LB_Primary.OnEvent("Change", LB_PrimaryChange)
gui__.LB_Option1__.OnEvent("Change", LB_Opt1Change)
gui__.LB_Option2__.OnEvent("Change", LB_Opt2Change)
gui__.LB_Option3__.OnEvent("Change", LB_Opt3Change)
gui__.LB_Option4__.OnEvent("Change", LB_Opt4Change)
gui__.buttonGroupBox__.add.OnEvent("Click", addButtonClick)
gui__.buttonGroupBox__.remove.OnEvent("Click", removeButtonClick)
gui__.buttonGroupBox__.toggle.OnEvent("Click", toggleSubMenu)

gui__.Show("h" 800 " w" 1500)
gui__.Maximize()
WinSetTransparent 240, "ahk_id " gui__.hwnd


; ---------------------------------------------------------
; Functions
; ---------------------------------------------------------

; Function: onFirstListboxChange
; Description: Sets a flag when the primary list box is first selected.
onFirstListboxChange(*)
{
    if not IsSet(isFirstboxSelected)
        isFirstboxSelected := true
}

; Function: listBoxUnselect
; Description: Resets the selection state for list boxes.
listBoxUnselect()
{
    isFirstboxSelected := false
    gui__.LB_Primary.Value := 0
}

loopBeef()
{
    global BeefMap
    TEMP := []
    for i, l in BeefMap {
        TEMP.Push(i)
    }
    return TEMP
}

processMap(subOptionNext, NextLB)
{
    NextLB.Delete
    if subOptionNext is Map
    {
        for key, val in subOptionNext
        {
            NextLB.Add([key])
        }
    }
    else if subOptionNext is Array
    {
        for val in subOptionNext
        {
            NextLB.Add([val])
        }
    }
    else
    {
        NextLB.Add([subOptionNext])
    }
}

LB_PrimaryChange(GuiCtrl, *)
{
    global Opt3Selection, Opt1Selection, Opt2Selection, Opt4Selection, PrimarySelection
    if GuiCtrl.Text = ""
        return
    deleteLB(gui__.LB_Option2__, gui__.LB_Option3__, gui__.LB_Option4__, gui__.LB_Option1__)
    Opt1Selection := ""
    Opt2Selection := ""
    Opt3Selection := ""
    Opt4Selection := ""
    gui__.LBOption1__Text.Value := ShortenKey(GuiCtrl.Text)
        PrimarySelection.value := GuiCtrl.Text
    PrimarySelection.type := Type(BeefMap[PrimarySelection.value])
    processMap(BeefMap[PrimarySelection.value], gui__.LB_Option1__)
}

; This function is triggered when the primary selection in the GUI is changed.
; It updates the global variables Opt1Selection, Opt2Selection, Opt3Selection, Opt4Selection, and PrimarySelection based on the new selection.
; It also calls the processMap function to update the options in the GUI based on the new primary selection.


LB_Opt1Change(GuiCtrl, *)
{
    global Opt3Selection, Opt1Selection, Opt2Selection, Opt4Selection, PrimarySelection
    if GuiCtrl.Text = ""
        return
    deleteLB(gui__.LB_Option2__, gui__.LB_Option3__, gui__.LB_Option4__)
    Opt1Selection := GuiCtrl.Text
    Opt2Selection := ""
    Opt3Selection := ""
    Opt4Selection := ""
    ; if PrimarySelection.value = "Ribeye"
    ; {
    ;     toggleSubMenu("")
    ;     return
    ; }
    if BeefMap[PrimarySelection.value].Has(Opt1Selection)
    {
        Opt1MeatMap := BeefMap[PrimarySelection.value][Opt1Selection]
        if IsObject(Opt1MeatMap)
        {
            processMap(Opt1MeatMap, gui__.LB_Option2__)
        }
        else
        {
            gui__.LB_Option2__.Add(["Select?"])
        }
    } else
    {
        gui__.LB_Option2__.Add(["Select?"])
    }

}

LB_Opt2Change(GuiCtrl, *)
{
    global Opt3Selection, Opt1Selection, Opt2Selection, Opt4Selection, PrimarySelection
    gui__.LB_Option3__.Delete
    gui__.LB_Option4__.Delete
    Opt3Selection := ""
    Opt4Selection := ""
    if validateCtrl(GuiCtrl.Text) = false
    {
        return
    }
    deleteLB(gui__.LB_Option3__, gui__.LB_Option4__)
    Opt2Selection := GuiCtrl.Text
    if not BeefMap[PrimarySelection.value][Opt1Selection].Has(Opt2Selection)
        return gui__.LB_Option3__.Add(["Select?"])
    processMap(BeefMap[PrimarySelection.value][Opt1Selection][Opt2Selection], gui__.LB_Option3__)
}

LB_Opt3Change(GuiCtrl, *)
{

    global Opt3Selection, Opt1Selection, Opt2Selection, Opt4Selection, PrimarySelection
    if GuiCtrl.Text = ""
        return
    if (Opt2Selection = GuiCtrl.Text or GuiCtrl.Text = "Select?")
        return
    Opt3Selection := GuiCtrl.Text
    Opt4Selection := ""
    deleteLB(gui__.LB_Option4__)
    if not BeefMap[PrimarySelection.value][Opt1Selection][Opt2Selection].Has(Opt3Selection)
    {
        return gui__.LB_Option4__.Add(["Select?"])
    }
    processMap(BeefMap[PrimarySelection.value][Opt1Selection][Opt2Selection][GuiCtrl.Text], gui__.LB_Option4__)
}

LB_Opt4Change(GuiCtrl, *)
{
    global Opt3Selection, Opt1Selection, Opt2Selection, Opt4Selection, PrimarySelection
    Opt4selection := GuiCtrl.Text
}

; Function: validateCtrl
; Description: Validates the control text.
; Parameters:
;   - CtrlText (string): The text of the control.
; Returns:
;   - boolean: True if the control text is valid, false otherwise.
validateCtrl(CtrlText)
{
    global Opt2Selection, Opt3Selection, Opt1Selection
    if CtrlText = ""
        return false
    if (Opt2Selection = CtrlText or CtrlText = "Select?")
        return false
    return true
}

; Function: combineOptions
; Description: Combines selected options into a string.
; Updates the global order map.
; Returns the combined options string.
combineOptions()
{
    global Opt3Selection, Opt1Selection, Opt2Selection, Opt4Selection, PrimarySelection, orderMap
    if PrimarySelection.value = 0
        return

    Opt1Selection := Opt2Selection != "" ? Opt1Selection  ": " : Opt1Selection
    Opt2Selection := Opt3Selection != "" ? Opt2Selection " => " : Opt2Selection
    Opt3Selection := Opt4Selection != "" ? Opt3Selection ": " : Opt3Selection
    combinedOptions := Trim(PrimarySelection.value " => " Opt1Selection " " Opt2Selection " " Opt3Selection " " Opt4Selection)
    StrReplace(combinedOptions, "Select?", "")
    if not Trim(Opt1Selection) = ""
    {
        orderMap.Set(PrimarySelection.value, Opt1Selection)
        if not Trim(Opt2Selection) = ""
        {
            orderMap[PrimarySelection.value] := Map(Opt1Selection, Opt2Selection)
            if not Trim(Opt3Selection) = ""
            {
                orderMap[PrimarySelection.value][Opt1Selection] := Map(Opt2Selection, Opt3Selection)
                if not Trim(Opt4Selection) = ""
                {
                    orderMap[PrimarySelection.value][Opt1Selection][Opt2Selection] := Map(Opt3Selection, Opt4Selection)
                }
            }
        }
    }
    return combinedOptions
}

; Function: addButtonClick
; Description: Triggered when the "Add" button is clicked.
; Combines options and adds them to the Order List Box.
addButtonClick(*)
{
    combinedOptions := combineOptions()
    gui__.LB_Orders.Add([combinedOptions])
}

; Function: removeButtonClick
; Description: Triggered when the "Remove" button is clicked.
; Removes the selected order from the Order List Box.
removeButtonClick(*)
{
    if gui__.LB_Orders.Text = ""
        return
    combinedOptions := combineOptions()
    gui__.LB_Orders.Delete(gui__.LB_Orders.Value)
}

; Function: toggleSubMenu
; Description: Toggles the visibility of a sub-menu in the GUI.
; Returns the position of the sub-menu group box before toggling.
toggleSubMenu(*)
{
    global gui__, GuiReSizer
    static toggleSubMenuStatus := 0
    GbPos := {}
    if toggleSubMenuStatus = 0 {
        gui__.orderGroupBox.GetPos(&x, &y, &w, &h)
        specialcaseMenu(x, y, w, h)
        gui__.LB_Orders.Visible := 0
        toggleSubMenuStatus := 1
        gui__.orderGroupBox.Text := "Multi-Option Select"
        return GbPos
        ;gui__.Radios2.Opt("x" order_X " ym" order_Y " w" w/6 " h" h/4)
    } else {
        gui__.orderGroupBox.Text := "Order Details"
        gui__.LB_Orders.Visible := 1
        toggleSubMenuStatus := 0
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
    Else
        return str "... Options"
}

specialcaseMenu(x, y, w, h, hide := 0)
{
    global specialMenu
    order_X := x + 25
    order_Y := y + 45
    order_W := 0.44
    order_H := 0.49
    
    specialMenu.Radios.Radio1 := gui__.Add("Radio", "x" order_X " y" order_Y " ", "2hello this is ribeye") 
    gui__.Radios1.SetFont("s16")
    ; gui__.Radios1.Opt("x" order_X " y" order_Y) ; 20% from Left Margin
    ;gui__.Radios1.YP := order_Y ; 45% from Top Margin
    specialMenu.Radios.Radio2 :=  gui__.Add("Radio", "x" order_X " y" order_Y + 75 " ", "3hello this is ribeye")
    gui__.Radios2.SetFont("s16")
}

deleteLB(params*)
{
    for ctrl in params
    {
        ctrl.Delete
    }
}

CrudOrder(GuiCtrl, *)
{
    ; Your CRUD order logic...
}