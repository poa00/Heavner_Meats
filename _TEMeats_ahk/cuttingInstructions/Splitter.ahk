#Requires Autohotkey v2
#SingleInstance Force
#Include <darkmode>
#Include <ButtonStyle>
#Include <AHKpy>
#Include <cJson>

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
    split := {}
    split.cut := 'Ribeye'
    split.map := JSON.Load(FileRead(A_ScriptDir '\beef.json'))[split.cut]
    split.amount := 2
    split.animal := "cows"
    split_Menu := gMenu(split)
    darkMode(split_Menu)
}

/*
    Class: gMenu

    Description:
    This class represents a graphical menu for splitting animals into left and right halves.
    It provides functionality for selecting options, displaying the selected options, and processing the selected options.

    Properties:
    - hwnd: The handle of the GUI window.
    - selectedText: The currently selected text in the GUI.
    - row: The index of the currently selected row in the GUI.
    - _map: The initial map of options for splitting animals.
    - Order: A map that stores the selected options for each animal.

    Methods:
    - Call(splitMap, animals): Creates and displays the GUI menu for splitting animals.
    - _endCutLine(): Handles the "Finished" button click event.
    - reset(): Resets the GUI menu to its initial state.
    - splitAnimals(): Generates an array of options for splitting animals.
    - nextButtonClick(): Handles the "Next" button click event.
    - LVClick(row?, RowNum?): Handles the ListView item select event.
    - firstProcess(): Performs the initial setup of the GUI menu.
    - processMap(): Processes the selected options and updates the GUI menu accordingly.
*/
class gMenu
{
    static hwnd := 0
    static selectedText := ""
    static row := 0
    static _map := Map()
    static cancel := false
    static submit := false
    static Order := []
    static optionString := []
    static amount := 0
    static animal := ""
    static total := 0
    static baseMap := Map("Half", 0.5, "Whole", 1, "Two Wholes", 2, "Three Wholes", 3, "Four Wholes", 4, "Five Wholes", 5)

    static Call(split)
    {
        gMenu._map := split.Map, gMenu.amount := split.amount,
            gMenu.cut := split.cut, gMenu.animal := split.animal
        myGui := {}
        myGui := Gui()
        myGui.SetFont("cWhite")
        myGui.Options := {}
        w := A_ScreenWidth
        h := A_ScreenHeight
        myGui.SetFont("s22")
        if A_ScreenWidth <= 1080
            myGui.Opt("-DPIScale")
        header := myGui.Add("Text", "x16 y14 w486 h112", "There are " . split.amount * 2 . " cuts, set options by setting total wholes for the given options. Click NEXT or NEW to navigate.")
        header.SetFont("s17 cWhite", "Segoe UI")
        myGui.SetFont("s14")
        myGui.Add("GroupBox", "x8 y116 w156 h84", "Cut")
        myGui.SetFont("s11", "Microsoft Sans Serif")
        myGui.DDL := myGui.Add("Text", "XP+20 yp+32 w88 h40", "" gMenu.cut)

        myGui.Add("GroupBox", "x180 y116 w212 h84 -Wrap", "Cuts")
        myGui.Add("Text", "XP+20 yp+36 w24 h24 +0x200", "x").SetFont("s20")
        myGui.SetFont("s11", "Microsoft Sans Serif")
        myGui.amount := myGui.Add("Edit", "x+6 yp w120 h36", "1")
        myGui.amount.SetFont("s20")
        myGui.updn := myGui.Add("UpDown", "x+0 yp w36 h36 -16", "1")

        myGui.Add("GroupBox", "x416 y116 w152 h84", "Total Wholes")
        myGui.SetFont("s16 w600 Italic", "Segoe UI")
        myGui.total := myGui.Add("Edit", "XP+20 yp+32 w116 h40", "0.5")
        myGui.total.SetFont("s20")
        myGui.Tabs := {}
        myGui.Tabs := myGui.Add("Tab3", "x16 y208 w392 h408", ["Options", "Comments"])
        myGui.Tabs.UseTab(1)
        myGui.Options := myGui.Add("ListView", "xp+12 yp+52 w357 h345 -Hdr Background000000", ["main"])
        myGui.multi := []
        myGui.Tabs.UseTab()
        myGui.multi := myGui.Add("Tab3", "x16 y208 w392 h408", [1, 2, 3, 4])
        myGui.multi.LBs := []
        loop 4
        {
            myGui.multi.UseTab(A_Index)
            if A_Index = 1
                myGui.multi.LBs.Push(myGui.Add("ListView", "xp+12 yp+52 w357 h345 -Hdr Background000000", [A_Index]))
                    , myGui.multi.LBs[A_Index].Visible := 0
            else
                myGui.multi.LBs.Push(myGui.Add("ListView", "xp yp w357 h345 -Hdr Background000000", [A_Index]))
                    , myGui.multi.LBs[A_Index].Visible := 0
        }
        myGui.multi.UseTab()
        myGui.multi.Visible := 0
        myGui.Order := myGui.Add("ListView", "x616 y16 w505 h585 Background000000", ["Orders"])
        myGui.DDL.SetFont('s20 cWhite')
        myGui.Order.SetFont("s15")
        myGui.Options.OptionChain := []
        myGui.Options.SetFont("s25")
        myGui.Options.NextMap := split.Map

        myGui.SetFont("s15", "Microsoft Sans Serif")
        myGui.Add("GroupBox", "x430 y244 w168 h346", "Options")
        myGui.SetFont("s15 w600 Italic", "Segoe UI")

        remove := myGui.Add("Button", "xp+10 y280 w143 h45", "Remove >").Style("critical")
        new := myGui.Add("Button", "xp y+12 w143 h45", "+New").Style("info")
        next := myGui.Add("Button", "xp y+12 w143 h45", "Next").Style("warning")
        submit := myGui.Add("Button", "xp y+12 w143 h45", "Submit").Style("success")
        cancel := myGui.Add("Button", "xp y+12 w143 h45", "Cancel").Style("critical")

        submit.OnEvent("Click", (*) => gMenu.submitClick())
        remove.OnEvent("Click", (*) => gMenu.remove())
        new.OnEvent("Click", (*) => gMenu.newClick())
        next.OnEvent("Click", (*) => gMenu.nextButtonClick())
        cancel.OnEvent("Click", (*) => gMenu.cancel_click())
        myGui.updn.OnEvent("Change", (*) => gMenu.updnChange(myGui.updn))
        myGui.Options.OnEvent("ItemSelect", gMenu.LVClick)
        myGui.Options.OnEvent("Click", gMenu.LVClick)
        myGui.Options.OnEvent("DoubleClick", (*) => gMenu.nextButtonClick())
        gMenu.hwnd := myGui.hwnd
        gMenu.firstProcess()
        myGui.Order.ModifyCol(1, 800)
        myGui.Title := "Window"
        myGui.Show("w1165 h619")
        return myGui
    }
    /*
        Method: _endCutLine
        Description: Finalizes the cutting process and closes the GUI.
        Returns: None
    */
    static _endCutLine(*)
    {
        global finished
        if finished
            return
        split_Menu := GuiFromHwnd(gMenu.hwnd)
        split_Menu.Options.OptionChain[1] := Trim(split_Menu.total.Value)
        gMenu.order.Push(split_Menu.Options.OptionChain)
        split_Menu.Order.Delete()
        gMenu.iterate(split_Menu)
        finished := true
        split_Menu.Options.OptionChain := []
    }
    /*
        Method: iterate
        Description: Iterates over the order list to create a string representation of each order.
        Parameters:
        - split_Menu (object): The GUI object containing the order list.
        Returns: None
    */
    static iterate(split_Menu)
    {
        gMenu.optionString := []
        for optionChain in gMenu.order
        {
            options := ""
            for i, chainItem in optionChain
                if i > 1
                    options .= Trim(chainItem) " "
                else
                    options .= InStr(chainItem, ".5") ? Round(chainItem * 2) " " gMenu.cut ": " : Round(chainItem) " Whole(s): "
            split_Menu.Order.add(, options)
            gMenu.optionString.Push(options)
        }
    }
    /*
        Method: cancel_click
        Description: Sets the cancel flag to true and retrieves the GUI object from its window handle.
        Parameters: None
        Returns: None
    */
    static cancel_click(*)
    {
        gMenu.cancel := true
        split_Menu := GuiFromHwnd(gMenu.hwnd)
    }
    /*
        Method: clear
        Description: Clears all properties of the gMenu class, resetting it to its initial state.
        Returns: None
    */
    static clear()
    {
        gMenu._map := Map()
        gMenu.Order := []
        gMenu.amount := 0
        gMenu.animal := ""
        gMenu.total := 0
        gMenu.submit := false
        gMenu.cancel := false
        gMenu.optionString := ""
    }
    /*
        Method: remove
        Description: Removes the selected order from the GUI and updates the order list accordingly.
        Parameters: None
        Returns: None
    */
    static remove(*)
    {
        split_Menu := GuiFromHwnd(gMenu.hwnd)
        R := split_Menu.Order.GetNext(0, "F")
        if !R
            return
        split_Menu.Order.Delete(R)
        gMenu.Order.Delete(R)
        temparr := []
        for i in gMenu.Order
        {
            if IsSet(i)
                temparr.Push(i)
        }
        gMenu.Order := []
        gMenu.Order := temparr
    }
    /*
        Method: submitClick
        Description: Sets the submit flag based on whether there are any orders in the list.
        Parameters: None
        Returns: None
    */
    static submitClick(*)
    {
        split_Menu := GuiFromHwnd(gMenu.hwnd)
        if gMenu.Order.Length = 0
            gMenu.cancel := true
        else
            gMenu.submit := true
    }
    /*
        Method: newClick
        Description: Calls the firstProcess method to initialize the GUI with the first set of options.
        Parameters: None
        Returns: None
    */
    static newClick(*)
    {
        gMenu.firstProcess()
    }
    /*
        Method: updnChange
        Description: Handles changes in the UpDown control and updates the amount and total values in the GUI.
        Parameters:
        - ctrl (object): The UpDown control object.
        Returns: None
    */
    static updnChange(ctrl, *)
    {
        split_Menu := GuiFromHwnd(gMenu.hwnd)
        if (gMenu.amount < (ctrl.Value / 2))
        {
            ctrl.Value := gMenu.amount * 2
            return
        }
        split_Menu.amount.Value := split_Menu.UpDn.Value
        split_Menu.total.Value := (split_Menu.amount.Value / 2)
    }
    /*
        Method: nextButtonClick
        Description: Calls the processMap method to update the GUI with the next set of options.
        Parameters: None
        Returns: None
    */
    static nextButtonClick(*)
    {
        gMenu.processMap()
    }
    /*
        Method: LVClick
        Description: Handles the event when a ListView row is clicked and updates the selected text and row properties.
        Parameters:
        - row (integer, optional): The index of the clicked row.
        - RowNum (integer, optional): The number of the row that was clicked.
        Returns: The selected text from the clicked row.
    */
    static LVClick(row?, RowNum?, *)
    {
        if !IsSet(row)
            Try row := GuiFromHwnd(gMenu.hwnd).Options.GetNext()
        if !row
            return
        gMenu.selectedText := GuiFromHwnd(gMenu.hwnd).Options.GetText(row)
        gMenu.row := row
        return gMenu.selectedText
    }
    /*
        Method: firstProcess
        Description: Initializes the GUI with the first set of options based on the type of the NextMap property.
        Returns: None
    */
    static firstProcess()
    {
        global finished
        finished := false
        split_Menu := GuiFromHwnd(gMenu.hwnd)
        split_Menu.Options.Delete()
        split_Menu.Options.NextMap := gMenu._map
        t := Type(split_Menu.Options.NextMap)
        if t = "Map"
        {
            for k, _ in split_Menu.Options.NextMap
            {
                split_Menu.Options.Add(, k)
            }
        } else if t = "Array" {
            for v in split_Menu.Options.NextMap
            {
                split_Menu.Options.Insert(A_Index, , v)
            }
        }
        gMenu.selectedText := ""
        gMenu.row := 0
    }
    /*
        Function: processMap
        Description: This function processes the selected text from the GUI menu and updates the menu options accordingly.
        Parameters: None
        Returns: None
    */
    static processMap()
    {
        global finished, tempLVs
        if !IsSet(finished)
            finished := false 
        if splitMulti.active
        {
            splitMulti.activate()
            return
        }
        if gMenu.selectedText = "" || finished
            return
        split_Menu := GuiFromHwnd(gMenu.hwnd)

        if !IsObject(split_Menu) || !split_Menu.HasProp('Options')
            return

        if (gMenu.selectedText != "" && split_Menu.Options.OptionChain.Length >= 1)
        {
            selectedType := Type(split_Menu.Options.NextMap)
            if (selectedType = "Map" && split_Menu.Options.NextMap.Has(gMenu.selectedText)) {
                split_Menu.Options.NextMap := split_Menu.Options.NextMap[gMenu.selectedText]
            }
            if (selectedType = "Array") {
                indx := split_Menu.Options.NextMap.Contains(gMenu.selectedText)
                if indx
                    split_Menu.Options.NextMap := split_Menu.Options.NextMap[indx]
            }
        }
        split_Menu.Options.OptionChain.Push(gMenu.selectedText)

        split_Menu.Options.Delete()

        finished := false
        switch Type(split_Menu.Options.NextMap)
        {
            case "Map":
                {
                    if split_Menu.Options.NextMap.Count = 1
                    {
                        _ := [split_Menu.Options.NextMap.__Enum(2).Bind(&category, &v)*]
                        split_Menu.Options.OptionChain.Push(category)
                        if InStr(category, "multi")
                            tempLVs := splitMulti.launchMulti(v, split_Menu)
                        else
                            split_Menu.Options.NextMap := v
                        for category in split_Menu.Options.NextMap
                            split_Menu.Options.Insert(A_Index, , category)
                    }
                    else
                        for category, v in split_Menu.Options.NextMap
                            split_Menu.Options.Add(, category)
                    gMenu.LVClick(1, 1)
                }
            case "Array":
                {
                    for v in split_Menu.Options.NextMap
                        split_Menu.Options.Insert(A_Index, , v)
                }
            case "String":
                {
                    gMenu.finalize(split_Menu)
                }
        }
        if split_Menu.Options.OptionChain.Length = 0
            split_Menu.Options.OptionChain.Push(0)

        split_Menu.Options.Modify(1, "Select")
    }
    static finalize(split_Menu) {
        split_Menu.Options.Add(, "Finished")
        gMenu._endCutLine()
        finished := true
    }
}

class splitMulti
{
    static active := false
    
    static launchMulti(multiMap, splitMenuGui)
    {
        global tempLVs
        tempLVs := Map()
        splitMulti.active := true
        splitMenuGui.tabs.Visible := 0
        splitMenuGui.multi.Delete()
        outerIndex := 0
        innerIndex := 0
        for category, mapV in multiMap
        {
            outerIndex += 1
            splitMenuGui.multi.Add([category])
            if (Type(mapV) = "Array")
            {
                splitMenuGui.multi.LBs[outerIndex].Delete()
                tempLVs.Set(category, splitMenuGui.multi.LBs[outerIndex])
                for i in mapV
                {
                    innerIndex += 1
                    splitMenuGui.multi.LBs[outerIndex].Add(, i)
                }
                splitMenuGui.multi.LBs[outerIndex].Visible := 1
            }
        }
        splitMenuGui.multi.Visible := 1
        return tempLVs
    }
    static processMulti() {
        global tempLVs
        values := Map()
        for key, LV in tempLVs
        {
            FocusedRowNumber := LV.GetNext(0, "F")  ; Find the focused row.
            if !FocusedRowNumber  ; No row is focused.
                return [false, key]
            value := LV.GetText(FocusedRowNumber)
            if value = "" || value = 0
                return [false, key]
            values.Set(key, value)
        }
        return [true, values]
    }
    static activate() 
    {
        ret := splitMulti.processMulti()
        if ret[1] = false
        {
            MsgBox("Please select a value for " ret[2] " before continuing.")
            return
        } else {
            split_Menu := GuiFromHwnd(gMenu.hwnd)
            split_Menu.tabs.Visible := 1
            split_Menu.multi.Visible := 0
            split_Menu.options.Delete()
            for k, v in ret[2]
            {
                split_Menu.multi.Delete()
                split_Menu.Options.OptionChain.Push(Format("{}:{};", k, v))
            }
            indx := split_Menu.Options.OptionChain.Contains("multi")
            if indx
                split_Menu.Options.OptionChain.RemoveAt(indx)
            gMenu.finalize(split_Menu)
            split_Menu.Options.NextMap := gMenu._map
            splitMulti.active := false
            return
        }
    }
}
