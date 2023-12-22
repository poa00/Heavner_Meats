
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
    hideOptionWiz()
    myPopup := Gui("-DPIScale +AlwaysOnTop")
    myPopup.SetFont("s16 cWhite")
    myPopup.Opt("+Owner" gui__.Hwnd)  ; Make the GUI owned by OtherGui.
    yPos := 0
    for radio, subOptions in popupMap
    {
        yPos += 64
        radioTemp := myPopup.Add("Radio", "x32 y" yPos " w351 h46", radio)
        radioTemp.OnEvent("Click", radioClick)
    }
    myHeader := myPopup.Add("Text", "x32 y10 w641 h43 +0x200", "Set Options for All Directly Below")
    myCurrentOption := myPopup.Add("ListBox", "x416 y71 w274 h216", ["ListBox"])
    ogcButtonConfirm := myPopup.Add("Button", "x698 y66 w169 h55", "Confirm")
    myPopup.Add("ListBox", "x32 y304 w389 h148", ["ListBox"])
    ogcButtonCancel := myPopup.Add("Button", "x698 y136 w169 h55", "Cancel")
    ogcButtonConfirm.OnEvent("Click", ClosePopup)
    ogcButtonCancel.OnEvent("Click", ClosePopup)
    myPopup.OnEvent('Close', (*) => ExitApp())
    myPopup.Title := "Submenu Popup"
    myPopup.backcolor := "121d30"

    darkMode(myPopup)

    myHeader.Opt("Background121d30")
    myCurrentOption.Opt("Background121d30")
    myHeader.Opt("Background121d30")
    myPopup.Show("w1013 h629")
    /*
        Function: OnEventHandler
        Description: Event handler function for the radio buttons and buttons.
        Displays a tooltip with the values of the GUI elements when clicked.
        Parameters: None
        Returns: None
    */
    OnEventHandler(*)
    {
        ToolTip("Click! This is a sample action.`n"
            . "Active GUI element values include:`n"
            . "ogcButtonConfirm => " ogcButtonConfirm.Text "`n"
            . "ogcButtonCancel => " ogcButtonCancel.Text "`n", -177, -377)
        SetTimer () => ToolTip(), -3000 ; tooltip timer
    }

    radioClick(GuiRadio, *)
    {
        myCurrentOption.Delete
        popupMap[GuiRadio.Text] is Array ? myCurrentOption.Add(popupMap[GuiRadio.Text]) : myCurrentOption.Add([popupMap[GuiRadio.Text]])
        myCurrentOption.Add([])
    }

    ClosePopup(*)
    {
        myPopup.Destroy()
    }
}


hideOptionWiz()
{
    global gui__
    for k, v in gui__.OptionWiz.OwnProps()
    {
        v.Visible := 0
    }
}