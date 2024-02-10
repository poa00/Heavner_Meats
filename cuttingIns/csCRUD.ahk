/*
   Function: orderReview

   Description:
   This function creates an order screen GUI with a group box and a list box.
   The group box displays the title "Orders" and the list box displays a list of beef items.
   The list box has an event handler for the "Change" event.

   Parameters:
   - gui_ (object): The GUI object to which the order screen will be added.

   Returns:
   None
*/
cutsheetCRUD()
{
    global dims, cutsheetBI, gui_, cutsheetID
    cutsheetID := 0
    cutsheetBI := "current"
    gui_.Title := "Cutsheet Manager"
    resetCutsheetVars()
    populateOrder()
    if gui_.HasProp("cutsheetcrud")
    {
        gui_.csCRUD.ToggleVisible(0)
    }
    gui_.csCRUD := {}
    dims.orderX := gui_.Primary.GB.XP + gui_.Primary.GB.WidthP + 0.02
    dims.orderY := 0.15
    dims.orderW := 0.7
    dims.orderH := 0.83
    wid := dims.PrimaryWP -0.02
    ; width := 215
    width := dims.NavW - 0.06

    gui_.csCRUD.Title := gui_.Add("Text", "Background16253f", "Cutsheet-Manager")
    gui_.csCRUD.Title.SetFont("s37 bold italic", "Arial")
    GuiResizer.FormatOpt(gui_.csCRUD.Title, dims.PrimaryXP-0.01, dims.wiz_y + 0.02, wid + 0.21, 0.15)
    
    gui_.csCRUD.LTabs := gui_.Add("Tab3", "Background181f2c", ["Current ", "Historic "])
    gui_.csCRUD.LTabs.SetFont("s32", "Calibri")
    GuiResizer.FormatOpt(gui_.csCRUD.LTabs, dims.PrimaryXP, dims.wiz_y + 0.2, wid + 0.2, dims.PrimaryHP - 0.2)

    gui_.csCRUD.LTabs.UseTab(1)
    
    gui_.csCRUD.CurrentCS := gui_.Add("ListView", "Background0b2149 Sort", ["Animals", "Kill-Date", "ID"])
    GuiResizer.FormatOpt(gui_.csCRUD.CurrentCS, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.43, wid + 0.18, dims.PrimaryHP - 0.37)
    gui_.csCRUD.CurrentCS.SetFont("s25")
    gui_.csCRUD.CurrentCS.Opt("+Grid NoSortHdr LV0x8000")

    gui_.csCRUD.LTabs.UseTab(2) 
    gui_.csCRUD.HistoricCS := gui_.Add("ListView", "Background1b335f Sort", ["Animals", "Kill-Date", "ID"])
    GuiResizer.FormatOpt(gui_.csCRUD.HistoricCS, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.43, wid + 0.18, dims.PrimaryHP - 0.37)
    gui_.csCRUD.HistoricCS.SetFont("s25")
    gui_.csCRUD.HistoricCS.Opt(" +Grid NoSortHdr LV0x8000")
    
    gui_.csCRUD.LTabs.UseTab()
    
    gui_.csCRUD.Event := gui_.Add("Text", "Background1b335f r4", "Upcoming Slaughter")
    GuiResizer.FormatOpt(gui_.csCRUD.Event, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.33, wid + 0.18, 0.08)
    gui_.csCRUD.Event.SetFont('cLime s16 italic')
    
    setRemaining()
    
    gui_.csCRUD.RTabs := gui_.Add("Tab3", "Background1b335f", ["Details ", "Comments "])
    gui_.csCRUD.RTabs.SetFont("s32", "Calibri")
    GuiResizer.FormatOpt(gui_.csCRUD.RTabs, dims.wiz_x + 0.17, dims.wiz_y, dims.wiz_w - 0.18, dims.wiz_h)
    
    gui_.csCRUD.RTabs.UseTab(1)
    gui_.csCRUD.details := gui_.Add("ListView", "w" 400 " r1 +Grid", ["", "", "", "", "", "", ""])
    gui_.csCRUD.details.SetFont("s16")
    gui_.csCRUD.details.Opt("+Report +0x4000")
    GuiResizer.FormatOpt(gui_.csCRUD.details, dims.wiz_x + 0.18, dims.wiz_y + 0.12, (dims.wiz_w - 0.2), dims.wiz_h - 0.14)
    
    gui_.csCRUD.RTabs.UseTab(2)
    gui_.csCRUD.comments := gui_.Add("ListView", "w" 400 " r1 +Grid", ["", ""])
    gui_.csCRUD.comments.SetFont("s16")
    gui_.csCRUD.comments.Opt("+Report +0x4000")
    GuiResizer.FormatOpt(gui_.csCRUD.comments, dims.wiz_x + 0.18, dims.wiz_y + 0.12, (dims.wiz_w - 0.2), dims.wiz_h - 0.14)
    
    gui_.csCRUD.RTabs.UseTab()
    
    ;Customer.event.map['something date']
    initCutSheets()

    commentsW := dims.wiz_w - 0.2, commentsX := dims.wiz_x + 0.18, commentsY := dims.wiz_y + 0.06 + dims.wiz_h - 0.25
    commentsH := .17
    
    gui_.csCRUD.CurrentCS.ModifyCol(4, "SortDesc")
    gui_.csCRUD.Edit := gui_.Add("Button", "", "Edit Selected")
    gui_.csCRUD.Edit.SetFont("s15 Bold q5", "Arial")
    GuiResizer.FormatOpt(gui_.csCRUD.Edit, dims.NavX, dims.NavY, width, dims.NavH)

    gui_.csCRUD.New := gui_.Add("Button", "", "New Cutsheet")
    gui_.csCRUD.new.SetFont("s15 Bold q5", "Arial")
    GuiResizer.FormatOpt(gui_.csCRUD.new, dims.NavX + width + 0.02, dims.NavY, width, dims.NavH)

    gui_.csCRUD.Delete := gui_.Add("Button", "", "Delete Cutsheet")
    gui_.csCRUD.Delete.SetFont("s15 Bold q5", "Arial")
    GuiResizer.FormatOpt(gui_.csCRUD.Delete, dims.NavX + width * 2 + 0.02 * 2, dims.NavY, width, dims.NavH)

    gui_.csCRUD.Duplicate := gui_.Add("Button", "", "Duplicate Cutsheet")
    gui_.csCRUD.Duplicate.SetFont("s15 Bold q5", "Arial")
    GuiResizer.FormatOpt(gui_.csCRUD.Duplicate, dims.NavX + width * 3 + 0.02 * 3, dims.NavY, width, dims.NavH)

    gui_.csCRUD.return := gui_.Add("Button", "", "← Return")
    gui_.csCRUD.return.SetFont("s15 Bold q5", "Arial")
    GuiResizer.FormatOpt(gui_.csCRUD.return, dims.NavX + width * 4 + 0.02 * 4, dims.NavY, width, dims.NavH)
    
    
    GuiResizer.Now(gui_)
    ButtonStyle(gui_.csCRUD.Edit, 0, "info-round")
    ButtonStyle(gui_.csCRUD.new, 0, "info-round")
    ButtonStyle(gui_.csCRUD.duplicate, 0, "success-round")
    ButtonStyle(gui_.csCRUD.Delete, 0, "critical-round")
    ButtonStyle(gui_.csCRUD.return, 0, "warning-round")
    
    orderSummaryWidth := (dims.orderW - 0.02) / 2

    setBackgroundColors()
    ButtonStyle.Refresh()
    setLVSizes()
    
    
    gui_.csCRUD.CurrentCS.OnEvent("ItemSelect", CurrentCS_Change)
    gui_.csCRUD.HistoricCS.OnEvent("ItemSelect", CurrentCS_Change)
 
    justToSub()
    {
        return false
    }

    Tab_Click(GuiCrl, *)
    {
        global cutsheetBI
        if InStr(GuiCrl.Text, "Current")
        {
            cutsheetBI := "current"
            gui_.csCRUD.CurrentCS.Visible := 1, gui_.csCRUD.CurrentTab.Enabled := 0
            gui_.csCRUD.HistoricCS.Visible := 0, gui_.csCRUD.HistoricTab.Enabled := 1
        } else if InStr(GuiCrl.Text, "Historic") {
            cutsheetBI := "historic"
            gui_.csCRUD.CurrentCS.Visible := 0, gui_.csCRUD.CurrentTab.Enabled := 1
            gui_.csCRUD.HistoricCS.Visible := 1, gui_.csCRUD.HistoricTab.Enabled := 0
        }
    }
}


initCutSheets()
{
    global gui_
    if gui_.csCRUD.HasProp("CurrentCS")
        gui_.csCRUD.CurrentCS.Delete()
    if gui_.csCRUD.HasProp("HistoricCS")
        gui_.csCRUD.HistoricCS.Delete()

    requests.tier := 1

    if IsObject(Customer.latestCS)
    {
        for cutsheet in Customer.latestCS
        {
            addToLV(gui_.csCRUD.CurrentCS, cutsheet)
        }
    }
    if IsObject(Customer.historicCS)
    {
        for cutsheet in Customer.historicCS
        {
            if cutsheet['event']['id'] != Customer.event.map['id']
            {
                addToLV(gui_.csCRUD.HistoricCS, cutsheet)
            }
        }
    }

    addToLV(LV, cutsheet)
    {
        LV.Add(, cutsheet['amount'] " " cutsheet['animal'],
            "w" SubStr(cutsheet['event']['yweek'], 5, 2) "/" SubStr(cutsheet['event']['yweek'], 1, 4)
            , cutsheet['id']
            ; need to grab event data and set date for slaughter, grab for this field
        )
    } 
}

setLVSizes()
{
    global gui_
    w := 300
    Loop 7
    {
        (A_Index < 4) ? gui_.csCRUD.CurrentCS.ModifyCol(A_Index, 315)
        : gui_.csCRUD.CurrentCS.ModifyCol(A_Index, 400)

        (A_Index < 4) ? gui_.csCRUD.HistoricCS.ModifyCol(A_Index, 275)
            : gui_.csCRUD.HistoricCS.ModifyCol(A_Index, 400)

            gui_.csCRUD.details.ModifyCol(A_Index, w := w - 36)
            (A_Index = 1) ? gui_.csCRUD.comments.ModifyCol(A_Index, 300)
                : gui_.csCRUD.comments.ModifyCol(A_Index, 700)
    }
}

setRemaining()
{
    year := SubStr(Customer.event.map["yweek"], 1, 4)
    week := SubStr(Customer.event.map["yweek"], 5, 2)
    gui_.csCRUD.Event.Text := "Upcoming Slaughter: `tWeek " Round(week) " of " year "`n" remaining()
}
remaining()
{
    if Customer.event.animals.remaining != 0
    {
        return "Unaccounted " Customer.event.animals.animal ": `t" Customer.event.animals.remaining
    } else {
        return "There are no unaccounted " Customer.event.animals.animal " for this event."
    }
}