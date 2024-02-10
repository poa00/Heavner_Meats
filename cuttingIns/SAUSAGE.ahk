#Requires Autohotkey v2
#SingleInstance Force
#Include <ButtonStyle> 
#Include <darkMode>
#Include <GuiResizer>
#Include <cJson>
Persistent

dir := A_MyDocuments "\ahk_log\", logfile := "sausage.txt"
sausage_log := dir logfile
DirCreate(dir)

if A_LineFile = A_ScriptFullPath
	displaySausage()

displaySausage()
{
	sausageMenu := SausageGUI()
	sausageMenu.Show("x0 y0 w1100 h850")
	DarkMode(sausageMenu)
	
	while !SausageGUI.complete
		Sleep(100)
}
init()
{
	SausageGui.storage := Map()
	if FileExist(sausage_log)
		; try
		 ;{
			contents := Json.Load(FileOpen(sausage_log, "r").Read())
			for k, v in contents[1]
			{
				SausageGUI.storage[A_Index] := v
			}
			SausageGui.update_LV(GuiCtrlFromHwnd(SausageGUI.LVhwnd))
		 ;}
}
class SausageGUI
{
	static unit := "lb"
	static storage := Map()
	static row := 0
	static priority := ""
	; * if sausage saved
	static complete := false
	static hwnd := 0
	static lvhwnd := 0
	
	static Call()
	{
		myGui := Gui("-DPIScale +Resize +MinSize550x250 +AlwaysOnTop")

		SausageGUI.hwnd := myGui.hwnd
		; AutoResizer(mygui)
		myGui.SetFont("s18 cWhite")
		myGui.OnEvent("Size", GuiResizer)
		pushToResizer(x := myGui.Add("GroupBox", "", "Add Sausage"), .01, .01, .97, .36)
		flavor := myGui.Add("DropDownList", "Choose1", ["Flavor", "Unseasoned Ground Pork", "T&E Classic", "Sage Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo"])
		format_ := myGui.Add("DropDownList", " Choose1", ["Format", "Loose", "1 oz Links", "2 oz Links", "4 oz Links", "Patties"])

		pushToResizer(flavor, .03, .08, .44, .03)
		pushToResizer(format_, .49, .08, .44, .03)

		myGui.SetFont("s16 cWhite")
		quantity := myGui.Add("Edit", "", "50")
		unit_label := myGui.Add("Text", "", "lb")
		priority := myGui.Add("Checkbox", "", "Priority")
		pushToResizer(quantity, .03, .19, .22, .07)
		pushToResizer(unit_label, .26, .2, .03, .07)
		pushToResizer(priority, .31, .18, .13, .09)
		myGui.SetFont("s14")
		changeUnit := myGui.Add("DropDownList", "  Choose1", ["Change Units (`%/lb)", "Percentage", "Weight", "Priority"])
		more := myGui.Add("Button", " BackgroundBlack", "More+").Style("success-outline")
		less := myGui.Add("Button", " BackgroundBlack", "Less-").Style("warning-outline")
		more.SetFont("s13")
		less.SetFont("s13")
		pushToResizer(changeUnit, .49, .19, .44, .03)
		pushToResizer(less, .18, .28, .14, .07)
		pushToResizer(more, .03, .28, .14, .07)

		addToOrder := myGui.Add("Button", "", "Add to Order").Style("success")
		pushToResizer(addToOrder, .49, .28, .44, .07)
		myGui.SetFont("s14")
		;myGui.Add("GroupBox", "x5 y216 w325 h292", "Items set to Grind")
		;LB := myGui.Add("ListBox", "xp+10 yp+35 w309 h284", ["Items"])

		pushToResizer(x := myGui.Add("GroupBox", "", "Sausage for this order"), .01, .41, .97, .45)
		LV := myGui.Add("ListView", " ", ["Order", "", "", "", "Priority", ""]) ; -Hdr
		pushToResizer(LV, .02, .47, .74, .37)

		remove := myGui.Add("Button", "", "Remove").Style("critical")
		pushToResizer(remove, .80, .47, .13, .06)
		editctrl := myGui.Add("Button", "", "Edit").Style("warning")
		pushToResizer(editctrl, .80, .53, .13, .06)
		pushToResizer(myGui.Add("GroupBox", "", "Priority"), .8, .6, .14, .23)
		up_priority := myGui.Add("Button", "", "↑")
		pushToResizer(up_priority, .81, .66, .12, .075)
		down_priority := myGui.Add("Button", "", "↓")
		pushToResizer(down_priority, .81, .74, .12, .08)

		ButtonCancel := myGui.Add("Button", "", "Cancel")
		pushToResizer(ButtonCancel, .40, .89, .18, .09)
		viewGrind := myGui.Add("Button", "", "View Grind")
		pushToResizer(viewGrind, .59, .89, .18, .09)
		Finished := myGui.Add("Button", "", "Finished")
		pushToResizer(Finished, .78, .89, .18, .09)


		LV.OnEvent("ItemSelect", LV_Change)
		more.OnEvent("Click", updnValue)
		less.OnEvent("Click", updnValue)
		up_priority.OnEvent("Click", priorityChange)
		down_priority.OnEvent("Click", priorityChange)
		flavor.OnEvent("Change", OnEventHandler)
		format_.OnEvent("Change", OnEventHandler)
		quantity.OnEvent("Change", OnEventHandler)
		; changeUnit.OnEvent("Change", (myGui, *) => setUnit(myGui))
		changeUnit.OnEvent("Change", setUnits)
		addToOrder.OnEvent("Click", addToOrder_click)
		Finished.OnEvent("Click", writeLog)
		remove.OnEvent("Click", removeClick)
		editctrl.OnEvent("Click", editClick)
		ButtonCancel.OnEvent("Click", cancel)
		myGui.OnEvent('Close', (*) => writeLog())
		myGui.Title := "Window (Clone)"
		SausageGUI.lvhwnd := LV.hwnd
		init()


		LV_Change(LV, row, *)
		{
			LVrow(row)
		}

		editClick(*)
		{
			lineMap := Map()
			row := LVrow()
			if !row
				return
			lineMap := SausageGUI.storage[row]
			; Map("quantity", quantity.text, "unit", unit_label.text,
			; "style", flavor.text, "size", format_.text, "priority-binary",
			; 	priority.Value, "priority-int", 0)
			quantity.text := lineMap['quantity']
			unit_label.text := lineMap['unit']
			flavor.text := lineMap['style']
			format_.text := lineMap['size']
			priority.Value := lineMap['priority-binary']
			SausageGUI.storage.Delete(row)
			indexLV()
			updateLV()
			SetTimer () => _tooltip("This item has been removed, to complete editing, you must`nAdd the item back into the order before continuing."), -100
		}
		; * Function: updateLV
		; * Description: Updates the contents of the GUI listview control with the data from SausageGUI.storage.
		; * Parameters: None
		; * Returns: None
		updateLV()
		{
			SausageGUI.update_LV(LV)
		}
		addToOrder_click(*)
		{
			if (flavor.text = "" || format_.text = "" || flavor.text = "Flavor" || format_.text = "Format" || SausageGUI.storage.Count > 9)
			{
				
			SetTimer () => _tooltip("Error; You didn't fill out either the Flavor, Format or `nreached maximum number of orders and need to remove some. "), -100
				return
			}
			LV.Opt("-Redraw")
			SausageGUI.storage[SausageGUI.storage.Count + 1] := Map("quantity", quantity.text, "unit", unit_label.text, 
																  "style", flavor.text, "size", format_.text, "priority-binary", priority.Value, "priority-int", 0)
			updateLV()
			LV.Opt("+Redraw")
			
		}
		
		priorityChange(ctrl, *)
		{
			row := LVrow()
			if !row
				return
			indexLV()
			
			if ctrl.text = "↑" && row != 1
			{
				LV.Opt("-Redraw")
				Selected := Map()
				toSwap := Map()
				Selected := SausageGUI.storage[row]
				toSwap := SausageGUI.storage[row-1]
				SausageGUI.storage[row-1] := Selected
				SausageGUI.storage[row] := toSwap 
				indexLV()
				updateLV()
				if SausageGUI.storage.Count >= (row-1)
					LV.Modify(row-1, "Select"),  LV.Modify(row-1, "Focus")
			}
			else if ctrl.text = "↓" && row+1 <= SausageGUI.storage.Count
			{
				LV.Opt("-Redraw")
				Selected := Map()
				toSwap := Map()
				Selected := SausageGUI.storage[row]
				toSwap := SausageGUI.storage[row + 1]
				SausageGUI.storage[row + 1] := Selected
				SausageGUI.storage[row] := toSwap
				indexLV()
				updateLV()
				if SausageGUI.storage.Count >= (row + 1)
					LV.Modify(row + 1, "Select"), LV.Modify(row+1, "Focus")
			}
				LV.Opt("+Redraw")
			
		}
		
		checkPriority(ctrl, *)
		{
			SausageGUI.priority := ctrl.Value = 1 ? "| Priority: " : ""
			updateLV()
		}
		
		removeClick(*)
		{
			indexLV()
			row := LVrow()
			if !row
				return
			LV.Delete(row)
			SausageGUI.storage.Delete(row)
			indexLV()
			updateLV()
			if SausageGUI.storage.Count > (row-1)
				LV.Modify(row, "Select" ),  LV.Modify(row, "Focus")
				
		}

		setUnits(ctrl, *)
		{
			if ctrl.Text = "Percentage"
			{
				SausageGUI.unit := "`%"
				unit_label.Value := "`%"
				quantity.value := 10
			}
			if ctrl.Text = "Weight"
			{
				SausageGUI.unit := "lb"
				unit_label.Value := "lb"
				quantity.value := 50
			}
			if ctrl.Text = "Priority"
			{
				SausageGUI.unit := ""
				unit_label.Value := ""
				quantity.value := ""
			}
			Sleep 1100
			changeUnit.Value := 1
			SetTimer () => _tooltip("Unit of measurement has been update."), -1000
			
		}
		
        ; * * Function: LVrow
        ; * * Description: Retrieves the row number of the currently focused row in the GUI listview control.
        ; * * Parameters:
        ; * *   - row (optional): The row number to set as the last row. Default is 0.
        ; * Returns: The row number of the currently focused row.
		LVrow(row:=0)
		{
			static lastRow := row
			static index := 0
			index += 1
			local cancel := false
			FocusedRowNumber := LV.GetNext(0, "F")
			if FocusedRowNumber = lastRow && lv.focused = 1
				lastRow := FocusedRowNumber, cancel := true
			if cancel && index != 1 || FocusedRowNumber = 0
				return false
			lastRow := FocusedRowNumber
			SausageGUI.row := focusedRowNumber
			return SausageGUI.row
		}
		
        ; * Function: indexLV
        ; * Description: Index the SausageGUI.storage object with priority values.
        ; * Parameters: None
        ; * Returns: None
		indexLV(){
			temp := Map()
			for k, v in SausageGUI.storage
			{
				v['priority-int'] := A_Index
				temp[A_Index] := v
			}
			SausageGUI.Storage := temp
		}
		
		;  *Function: updnValue
		;  *Description: Adjusts the value of the quantity based on the button clicked (+ or -) and the unit of measurement.
		;  *Parameters:
		;  *  - ctrl: The button control that was clicked.
		;  *  - g: Not used in the code snippet.
		;  *  - param* (optional): Additional parameters, not used in the code snippet.
		;  *Returns: None
		updnValue(ctrl, g, param*)
		{
			if SausageGUI.unit = "lb"
			{
				if InStr(ctrl.text, "+") && quantity.value < '250'
					quantity.value := quantity.value + "50"
				else if InStr(ctrl.text, "-") && quantity.value >= '50'
					quantity.value := quantity.value = 50 ? 0 : quantity.value - "50"
				Round(quantity.value)
			}
			else if SausageGUI.unit = "`%"
			{
				if InStr(ctrl.text, "+") && quantity.value <= '90'
					quantity.value := quantity.value + "10"
				else if InStr(ctrl.text, "-") && quantity.value >= '10'
					quantity.value := quantity.value = 10 ? 0 : quantity.value - "10"
				Round(quantity.value)
			}
		}
		
		_tooltip(str)
		{
			ToolTip str
			SetTimer () => ToolTip(), -4000
		}

		LV_DoubleClick(LV, RowNum)
		{
			if not RowNum
				return
			ToolTip(LV.GetText(RowNum), 77, 277)
			SetTimer () => ToolTip(), -3000
		}
		writeLog(*)
		{
			FileOpen(sausage_log, "w").Write(Json.Dump([SausageGUI.storage]))
			cancel()
		}
		
		cancel(*)
		{
			SausageGUI.complete := true
			myGui.Destroy()
		}

		OnEventHandler(*)
		{
			ToolTip("Click! This is a sample action.`n"
				. "Active GUI element values include:`n"
				. "DropDownList1 => " flavor.Text "`n"
				. "DropDownList2 => " format_.Text "`n"
				. "Edit1 => " quantity.Value "`n"
				. "ButtonChangeValueietolb => " changeUnit.Text "`n"
				. "ButtonAddtoOrder => " addToOrder.Text "`n"
				. "ButtonCancel => " ButtonCancel.Text "`n", 77, 277)
			SetTimer () => ToolTip(), -100 ; tooltip timer
		}
		return myGui
	}
	static update_LV(LV)
	{
		LV.Delete()
		local temp := Map()
		for k, v in SausageGUI.storage
		{
			LV.Add(, v['quantity'] " " v['unit'], v['style'], v['size'], , v['priority-binary'] = 1 ? "✔ " A_Index : "")
			temp[A_Index] := v
		}
		SausageGUI.Storage := temp
		LV.ModifyCol()
		LV.ModifyCol(5, 200)
		LV.ModifyCol(1, 100)
	}
}

pushToResizer(ctrl, xp, yp, wp, hp)
{
	ctrl.xp := xp
	ctrl.yp := yp
	ctrl.wp := wp
	ctrl.hp := hp
}
delayedSize(sausageMenu)  {
	WinMove(, , A_ScreenWidth * .9, A_ScreenHeight * 0.9, 'ahk_id ' SausageGUI.hwnd)
	GuiResizer.Now(sausageMenu)
}

setUnit(parent) {
	myGui := Gui("+owner" parent.hwnd)
	myGui.SetFont("s16 cWhite")
	myGui.BackColor := "0x303030"
	hRadRadioButton := myGui.Add("Radio", "x24 y24 w232 h31", "Priority")
	hRadRadioButton.Opt("Background303030")
	Radio1 := myGui.Add("Radio", "x24 y72 w232 h31", "LBs")
	Radio2 := myGui.Add("Radio", "x24 y120 w232 h31", "Percentage")
	Radio3 := myGui.Add("Radio", "x24 y168 w189 h33", "Radio Button")
	OKhBtnOk1 := myGui.Add("Button", "x24 y224 w195 h37", "&OK")
	OKhBtnOk1.Opt("Background303030")
	hRadRadioButton.OnEvent("Click", OnEventHandler)
	Radio1.OnEvent("Click", OnEventHandler)
	Radio2.OnEvent("Click", OnEventHandler)
	Radio3.OnEvent("Click", OnEventHandler)
	OKhBtnOk1.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	myGui.Show("w267 h306")

	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
			. "Active GUI element values include:`n"
			. "hRadRadioButton => " hRadRadioButton.Value "`n"
			. "Radio1 => " Radio1.Value "`n"
			. "Radio2 => " Radio2.Value "`n"
			. "Radio3 => " Radio3.Value "`n"
			. "OKhBtnOk1 => " OKhBtnOk1.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}

	return myGui
}