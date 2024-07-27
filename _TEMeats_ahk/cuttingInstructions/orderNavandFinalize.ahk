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
    nickname := orderMap['nickname']
    orderMap.Delete('nickname')
    requests.tier := 1
    content := Map("event_id", Customer.event.map['id'],
        "event", Customer.event.map['id'],
        "producer", Customer.Producer["id"],
        "cutsheet", OrderMap,
        'nickname', nickname,
        "yweek", A_YWeek,
        "animal", Customer.event.animals.animal,
        "amount", Customer.event.animals.amount
    )
    Customer.recipient.Has('id') ? content["recipient"] := Customer.recipient['id'] : content
    return content
}

FinalizeCutsheet(GuiCtrl, *)
{
    global cutsheetID, orderMap
    if !checkSausage()
        return

    nickname := InputBox("Enter a unique nickname for this cutsheet", "Enter a unique nickname for this cutsheet", , A_DDD ";" A_MM "-" A_DD "@" A_Hour ":" A_Min).value
    if nickname = ""
    {
        MsgBox("Please enter a nickname for the cutsheet")
        return
    }
    ordermap['nickname'] := nickname
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
        try postReq2 := requests.Put(Customer.event.map['id'], Map('cutsheet_remainder', Customer.event.animals.remaining))
        try checkResponse(&postReq2, 1)
        if AssignAnimalsCS.thisOrder
            AssignAnimalsCS.postAssignments(postReq['id'])
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
            gui_.order.ToggleVisible(1)
            gui_.Primary.ToggleVisible(0, 1)
            gui_.Wiz.ToggleVisible(0, "FORCE")
            GuiResizer.Now(gui_)
        }
    }
    else if InStr(GuiCtrl.Text, "Wizard")
    {
        if not gui_.Wiz.main.VisibleStatus()
        {
            gui_.order.ToggleVisible(0)
            gui_.Primary.ToggleVisible(1)
            gui_.Wiz.main.ToggleVisible(1)
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