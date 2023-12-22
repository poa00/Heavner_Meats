

/**
 * Displays a sub-menu in the GUI based on the given sub-option map.
 * 
 * @param {Object} [subOptionNext] - The sub-option map to display as a sub-menu.
 * @returns {void}
 * @example
 * displaySubMenu({ "See sub-menu": { "Option1": ["Value1", "Value2"], "Option2": ["Value3", "Value4"] } })
 */
displaySubMenu(subOptionNext?)
{
    global gui__, SubMenuMap
    if IsSet(subOptionNext)
    {
        SubMenuMap := subOptionNext["See sub-menu"]
    }
    else if !IsSet(SubMenuMap)
    {
        return
    }
    gui__.Tabs.Choose(2)
    gui__.SM.LB.keys.Delete
    gui__.SM.LB.values.Delete
    ctrlObj := gui__.SM.LB.keys
    for key, value in SubMenuMap
    {
        ctrlObj.Add([key])
    }
}



/**
 * Event handler for the change event of the sub-menu keys.
 * 
 * @param {GuiCtrl} GuiCtrl - The GUI control that triggered the change event.
 * @returns {void}
 * @example
 * clickSM_key(guiCtrl)
 */
clickSM_key(GuiCtrl, *)
{
    global gui__, SubMenuMap, subMenuValuesArray, lastKey
    if GuiCtrl.Text = "" or GuiCtrl.Text = "Option Categories"
    {
        return
    }
    if IsSet(lastKey)
    {
        if lastKey = GuiCtrl.Text
        {
            return 
        }
    }
    lastKey := GuiCtrl.Text
    gui__.SM.LB.values.Delete
    subMenuValuesArray := SubMenuMap[GuiCtrl.Text]
    if SubMenuMap[GuiCtrl.Text] is array
    {
        for v in SubMenuMap[GuiCtrl.Text]
        {
            gui__.SM.LB.values.Add([v])
        }
    }
}



/**
 * Confirms the selected key and values in the sub-menu.
 * 
 * @param {*} * 
 * @returns {void}
 * @example
 * clickSM_confirm()
 */
clickSM_confirm(*)
{
    global finishedMap
    key := gui__.SM.LB.keys.Text
    values := gui__.SM.LB.values.Text
    if !IsSet(finishedMap)
    {
        finishedMap := Map()
    }
    finishedMap.Set(key, values)
    gui__.SM.LB.confirmed.Add(,key, values)
    gui__.SM.LB.values.Delete
}



/**
 * Finishes the sub-menu interaction, removing the confirmed entry.
 * 
 * @param {*} * 
 * @returns {void}
 * @example
 * clickSM_finished()
 */
clickSM_finished(*)
{
    row := gui__.SM.LB.confirmed.GetNext()
    gui__.SM.LB.confirmed.Delete(row)
    gui__.SM.LB.values.Delete
    displaySubMenu()
}


/**
 * Deletes the selected entry in the sub-menu.
 * 
 * @param {*} * 
 * @returns {void}
 * @example
 * clickSM_delete()
 */
clickSM_delete(*)
{
    row := gui__.SM.LB.confirmed.GetNext()
    gui__.SM.LB.confirmed.Delete(row)
}


/**
 * Resets the sub-menu, clearing keys, values, and confirmed entries.
 * 
 * @returns {void}
 * @example
 * reset_SM()
 */
reset_SM()
{
    gui__.SM.LB.confirmed.Delete
    gui__.SM.LB.values.Delete
    gui__.SM.LB.keys.Delete
}