

/*
    Function: howManyAnimals

    Description:
    This function displays a GUI window that prompts the user to enter the number of animals for a specific cut sheet.
    It also provides options for the type of cow (Whole Cow, Half Cow, Quarter Cow) and buttons to increase or decrease the animal count.
    When the user clicks the "Continue" button, the GUI window is hidden and other GUI windows are toggled visible.

    Parameters:
    - animalObj: An object containing information about the animal (e.g., animal type, count).
    - gui_: A reference to the GUI object.
*/
howManyAnimals(origin?)
{
    global gui_
    bx := 0.1
    by := 0.05
    bw := 0.8
    bh := 0.08
    if !IsSet(origin)
    {
        Customer.event.animals.remaining := Customer.event.animals.remaining + Customer.event.animals.amount
    }
    gui_.howMany := {}
    gui_.howMany.Header := gui_.Add("Text", "", "How many animals for this Cut Sheet?")
    gui_.howMany.Header.SetFont("s30")
    GuiResizer.FormatOpt(gui_.howMany.Header, bx, by, bw, bh)
    requests.appName := "cutsheets" 
    gui_.howMany.AnimalText := gui_.Add("Text", "", "")
    gui_.howMany.AnimalText.SetFont("s30")
    GuiResizer.FormatOpt(gui_.howMany.AnimalText, bx, by + bh + 0.01, bw, bh)
    
    gui_.howMany.Edit := gui_.Add("Edit", "", "0")
    gui_.howMany.Edit.SetFont("s34")
    gui_.howMany.Edit.Enabled := 0
    GuiResizer.FormatOpt(gui_.howMany.Edit, bx, by := by + bh * 2 + 0.01, 0.1, bh)
    setAmount() 
    gui_.howMany.Up := gui_.Add("Button", "", "+")
    gui_.howMany.Up.SetFont("Bold s50")
    GuiResizer.FormatOpt(gui_.howMany.Up, bx + 0.1, by, 0.04, bh)

    gui_.howMany.Down := gui_.Add("Button", "", "-")
    gui_.howMany.Down.SetFont("Bold s50")
    GuiResizer.FormatOpt(gui_.howMany.Down, bx + 0.1 + 0.04, by, 0.04, bh)

    gui_.howMany.DDL := gui_.Add("DDL", "Choose1", ["Whole Cow", "Half Cow", "Quarter Cow"])
    GuiResizer.FormatOpt(gui_.howMany.DDL, bx + 0.1 + 0.04 + 0.05, by, 0.25, bh)

    gui_.howMany.DDL.SetFont("s30")
    gui_.howMany.Continue := gui_.Add("Button", "", "Continue")
    GuiResizer.FormatOpt(gui_.howMany.Continue, bx, by := by + bh + 0.02, 0.14, bh)

    gui_.howMany.Cancel := gui_.Add("Button", "", "Cancel")
    GuiResizer.FormatOpt(gui_.howMany.Cancel, bx + 0.14 + 0.01, by, 0.14, bh)

    GuiResizer.Now(gui_)
    gui_.howMany.Up.OnEvent("Click", OrderCountUpDn)
    gui_.howMany.Down.OnEvent("Click", OrderCountUpDn)
    gui_.howMany.Continue.OnEvent("Click", ContinueToCutsheet)
    gui_.howMany.Cancel.OnEvent("Click", CancelToCutsheet)

    gui_.howMany.Header.Opt("Background121d30")
    gui_.howMany.AnimalText.Opt("Background121d30")

    setBackgroundColors()
    ButtonStyle.Refresh()
    OrderCountUpDn(GuiCtrl, *)
    {
        if GuiCtrl.Text = "+"
            gui_.howMany.Edit.Text := gui_.howMany.Edit.Text = Customer.event.animals.remaining ? gui_.howMany.Edit.Text : gui_.howMany.Edit.Text + 1
        else
            gui_.howMany.Edit.Text := gui_.howMany.Edit.Text = 0 ? gui_.howMany.Edit.Text : gui_.howMany.Edit.Text - 1
    }
    ContinueToCutsheet(*)
    {
        global OrderMap
        if gui_.howMany.Edit.Value != 0 or gui_.howMany.Edit.Value != "0"
        {
            Customer.event.animals.temp_remaining := Customer.event.animals.remaining - gui_.howMany.Edit.Value
            Customer.event.animals.amount := gui_.howMany.Edit.Value

            gui_.howMany.ToggleVisible(0)
            gui_.Wiz.main.ToggleVisible(1)
            gui_.Primary.ToggleVisible(1)
            gui_.Nav.ToggleVisible(1)
        }
    }
    CancelToCutsheet(*)
    {
        if IsSet(origin)
        {
            if origin = "cutsheetCRUD"
            {
                gui_.howMany.ToggleVisible(0) 
                cutsheetState()
                gui_.csCRUD.ToggleVisible(1)
                return
            }
        }
        gui_.howMany.ToggleVisible(0)
        gui_.Wiz.main.ToggleVisible()
        gui_.Primary.ToggleVisible()
        gui_.Nav.ToggleVisible() 
        return
    }
}

howManyAnimalsState()
{
    setAmount()
    setBackgroundColors()
    ButtonStyle.Refresh()
}

setAmount(){
    global gui_
    gui_.howMany.AnimalText.Value := Format(
        "There are {2} {1} unaccounted for.", Customer.event.animals.animal, Customer.event.animals.remaining)
    gui_.howMany.Edit.Text := 0
}