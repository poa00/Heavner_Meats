/*
    Function: buildPopup
    Description: This function builds a popup GUI with radio buttons, text, list boxes, and buttons.
    It sets event handlers for the radio buttons and buttons, and displays tooltips with the values of the GUI elements when clicked.
    Parameters: None
    Returns: None
*/
buildPopup(popupMap)
{
    global gui__
    gui__.myPopup.Enabled := 1
    local Pos := {}
    Pos.x := gui__.PopupPos.XP, Pos.y := gui__.PopupPos.YP, pos.w := gui__.PopupPos.WP
    yPos := 0.04
    gui__.myPopup.Header := gui__.Add("Text", "r2", "Complete all, use Next to confirm each:")
    GuiResizer.FormatOpt(gui__.myPopup.Header, Pos.x, Pos.y - 0.01, pos.w,)
    for radio, subOptions in popupMap
    {
        gui__.myPopup.radios%A_Index% := gui__.Add("Radio", "r1 Background0f192a", radio)
        gui__.myPopup.radios%A_Index%.OnEvent("Click", radioClick)
        gui__.myPopup.radios%A_Index%.SetFont("s22")
        GuiResizer.FormatOpt(gui__.myPopup.radios%A_Index%, Pos.x, Pos.y + yPos, pos.w,)
        yPos += 0.04
    }
    yPos += 0.01
    gui__.myPopup.LB := gui__.Add("ListBox", "r5", ["ListBox"])
    gui__.myPopup.LB.SetFont("s21")
    GuiResizer.FormatOpt(gui__.myPopup.LB, Pos.x, Pos.y + yPos, pos.w,)
    yPos += 0.16
    gui__.myPopup.Confirm := gui__.Add("Button", "", "Confirm")
    GuiResizer.FormatOpt(gui__.myPopup.Confirm, Pos.x, Pos.y + yPos, pos.w,)
    yPos += 0.03
    gui__.myPopup.Cancel := gui__.Add("Button", "", "Cancel")
    GuiResizer.FormatOpt(gui__.myPopup.Confirm, Pos.x, Pos.y + yPos, pos.w,)

    ; gui__.myPopup.Confirm.OnEvent("Click", ClosePopup)
    ; gui__.myPopup.Cancel.OnEvent("Click", ClosePopup)
    hidePopup()
    toggleOptionWiz()
    gui__.myPopup.Header.Opt("Background121d30")
    gui__.myPopup.LB.Opt("Background121d30")
    GuiReSizer.Now(gui__)
    /*
        Function: OnEventHandler
        Description: Event handler function for the radio buttons and buttons.
        Displays a tooltip with the values of the GUI elements when clicked.
        Parameters: None
        Returns: None
    */
    radioClick(GuiRadio, *)
    {
        gui__.myPopup.LB.Delete
        popupMap[GuiRadio.Text] is Array ? gui__.myPopup.LB.Add(popupMap[GuiRadio.Text]) : gui__.myPopup.LB.Add([popupMap[GuiRadio.Text]])
        gui__.myPopup.LB.Add([])
    }
}

/*
    Function: howManyAnimals
    
    Description:
    This function displays a GUI window that prompts the user to enter the number of animals for a specific cut sheet. 
    It also provides options for the type of cow (Whole Cow, Half Cow, Quarter Cow) and buttons to increase or decrease the animal count.
    When the user clicks the "Continue" button, the GUI window is hidden and other GUI windows are toggled visible.
    
    Parameters:
    - animalObj: An object containing information about the animal (e.g., animal type, count).
    - gui__: A reference to the GUI object.
*/
howManyAnimals(animalObj, &gui__)
{
    bx := 0.1
    by := 0.05
    bw := 0.8
    bh := 0.08
    gui__.OrderCount := {}
    gui__.OrderCount.Header := gui__.Add("Text", "", "How many animals for this Cut Sheet?")
    gui__.OrderCount.Header.SetFont("s30")
    GuiResizer.FormatOpt(gui__.OrderCount.Header, bx, by, bw, bh)
    gui__.OrderCount.AnimalText := gui__.Add("Text", "", Format("There are ~{2} {1} unaccounted for.", animalObj.animal, animalObj.count))
    gui__.OrderCount.AnimalText.SetFont("s30")
    GuiResizer.FormatOpt(gui__.OrderCount.AnimalText, bx, by + bh + 0.01, bw, bh)
    gui__.OrderCount.Edit := gui__.Add("Edit", "", "0")
    gui__.OrderCount.Edit.SetFont("s40")
    
    GuiResizer.FormatOpt(gui__.OrderCount.Edit, bx, by := by+ bh * 2 +0.01, 0.1, bh)
    gui__.OrderCount.Up := gui__.Add("Button", "", "+")
    GuiResizer.FormatOpt(gui__.OrderCount.Up, bx  +0.1, by, 0.04, bh)
    gui__.OrderCount.Down := gui__.Add("Button", "", "-")
    GuiResizer.FormatOpt(gui__.OrderCount.Down, bx + 0.1 + 0.04, by, 0.04, bh)
    gui__.OrderCount.Combo := gui__.Add("ComboBox", "Choose1", ["Whole Cow", "Half Cow", "Quarter Cow"])
    GuiResizer.FormatOpt(gui__.OrderCount.Combo, bx + 0.1 + 0.04+0.05, by, 0.25, bh)
    gui__.OrderCount.Combo.SetFont("s30")
    gui__.OrderCount.Continue := gui__.Add("Button", "", "Continue")
    GuiResizer.FormatOpt(gui__.OrderCount.Continue, bx, by := by + bh +0.02, 0.14, bh)
    gui__.OrderCount.Submit := gui__.Add("Button", "", "Submit Cutsheet")
    GuiResizer.FormatOpt(gui__.OrderCount.Submit, bx+0.14+0.01, by, 0.17, bh)
    
    GuiResizer.Now(gui__)
    gui__.OrderCount.Up.OnEvent("Click", OrderCountUpDn)
    gui__.OrderCount.Down.OnEvent("Click", OrderCountUpDn)
    gui__.OrderCount.Continue.OnEvent("Click", ContinueToCutsheet)
    ; gui__.OrderCount
    
    OrderCountUpDn(GuiCtrl, *)
    {
        if GuiCtrl.Text = "+"
            gui__.OrderCount.Edit.Text := gui__.OrderCount.Edit.Text != animalObj.count ? gui__.OrderCount.Edit.Text + 1 : gui__.OrderCount.Edit.Text
        else
            gui__.OrderCount.Edit.Text := gui__.OrderCount.Edit.Text != 0 ? gui__.OrderCount.Edit.Text - 1 : gui__.OrderCount.Edit.Text
    }
    
    ContinueToCutsheet(*)
    {
        gui__.OrderCount.ToggleVisible()
        gui__.optionWiz.ToggleVisible()
        gui__.Primary.ToggleVisible()
        gui__.Menu.ToggleVisible()
    }
}


hidePopup()
{
    for k, v in gui__.myPopup.OwnProps()
    {
        if IsObject(v)
            v.Visible := 0
    }
    GuiReSizer.Now(gui__)
}
toggleOptionWiz()
{
    global gui__
    for k, v in gui__.optionWiz.OwnProps()
    {
        if IsObject(v)
            v.Visible := !v.Visible
    }
    for k, v in gui__.myPopup.OwnProps()
    {
        if IsObject(v)
            v.Visible := !v.Visible
    }
    GuiReSizer.Now(gui__)
}