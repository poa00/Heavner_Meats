#SingleInstance force
#Requires Autohotkey v2

customers := Map()


/*
	Class: CustomerSearch

	Description:
	This class represents a customer search functionality. It provides a GUI window with an input field to enter search criteria for customers. The search results are displayed in a ListView control. The user can select a customer from the list and confirm the selection.

	Methods:
	- Call(): Initializes and displays the GUI window for customer search. Handles events such as button clicks and search field changes.
*/
class CustomerSearch
{
	static ID := ""
	static hwnd := ""
	static profile := Map()
	
	static Call()
	{
		global customers
		customerGui := Gui("-DPIScale")
		
		CustomerSearch.hwnd := customerGui.Hwnd
		customers := getCustomers()
		if customers is String
			MsgBox customers
		customerGui.SetFont("s13", "Arial")
		customerGui.SetFont("cWhite")
		customerGui.BackColor := "0x212121"
		darkMode(customerGui)
		
		customerGui.Add("Text", "", "Use the box on the next line to search for a customer:")
		Edit1 := customerGui.Add("Edit", "x32 y74 w528 h41", "Enter Search Criteria for Customer")
		buttonClear := customerGui.Add("Button", "x+20 w380 h40 BackgroundBlack", "Clear")
		LV := customerGui.Add("ListView", "x32 y132 w931 h771 +LV0x4000", ["Customer Name", "Email Address", "Address", "ID"])
		LV.SetFont("cBlack")
		
		ButtonConfirmSelection := customerGui.Add("Button", "x1050 y132 w380 h90 BackgroundBlack", "Confirm Selection")
		LV.OnEvent("DoubleClick", (*) => clickConfirm())
		ButtonConfirmSelection.OnEvent("Click", clickConfirm)
		Edit1.OnEvent("Focus", searchFieldChange)
		Edit1.OnEvent("Change", searchFieldChange)
		Edit1.SetFont("cBlack")
		buttonClear.OnEvent("Click", (*) => Edit1.Value := "")
		customerGui.OnEvent('Close', (*) => clickClose())
		customerGui.Title := "Window"
		LV.ModifyCol(3, 420)
		LV.ModifyCol(2, 320)
		LV.ModifyCol(1, 220)
		; customerGui.Show("w1006 h582")
		customerGui.Show("w1506 h882")
		OnMessage(0x0200, On_WM_MOUSEMOVE)
		
		importCustomer(LV)
		Sleep(1000)
		clickClose(*){
			CustomerSearch.hwnd := ""
		}
		clickConfirm(*)
		{
			RowNumber := LV.GetNext()
			if not RowNumber  ; The above returned zero, so there are no more selected rows.
				return
			cID := LV.GetText(RowNumber, 4)
			customerSearch.Profile := getCustomers()[cID]
			customerSearch.ID := cID
			customers := Map()
			for _, ctrl_hwnd in addEvent.checkbox.OwnProps()
			{
				GuiCtrlFromHwnd(ctrl_hwnd).Enabled := true
			}
		}

		OnEventHandler(*)
		{
			ToolTip("Click! This is a sample action.`n"
				. "Active GUI element values include:`n"
				. "ButtonConfirmSelection => " ButtonConfirmSelection.Text "`n", 77, 277)
			SetTimer () => ToolTip(), -3000 ; tooltip timer
		}
		
		searchFieldChange(guiCtrl, *)
		{
			static lastValue := ""
			if lastValue = guiCtrl.Value
				return
			if guiCtrl.Focused = 1
			{
				if guiCtrl.Value != lastValue && guiCtrl.Value != ""
				{
					importCustomer(LV, guiCtrl.Value)
					lastValue := guiCtrl.Value
					; do something
				}
				else if guiCtrl.Value = ""
				{
					importCustomer(LV)
					lastValue := guiCtrl.Value
				}
			}
			else if guiCtrl.Value != lastValue && guiCtrl.Value = ""
			{
				importCustomer(LV)
				lastValue := guiCtrl.Value
				; do something
			}
		}
		return customerGui
	}
}


importCustomer(LV, searchVal?)
{
	global customers
	if IsSet(searchVal) {
		LV.Delete()
	}
	
	for k, v in customers
	{
		if v.Has("full_name")
		{
			if IsSet(searchVal)
			{
				try
				{
					if !InStr(v["full_name"], searchVal) && !InStr(v["email"], searchVal) && !InStr(v["billing_street"], searchVal)
						continue
				}
			}
			try {
				LV.Add(, v["full_name"], v["email"], v["billing_street"], v["id"])
			} catch as e {
				continue
			}
		}
	}
}

On_WM_MOUSEMOVE(wParam, lParam, msg, Hwnd)
{
	static PrevHwnd := 0
	if (Hwnd != PrevHwnd)
	{
		CurrControl := GuiCtrlFromHwnd(Hwnd)
		if CurrControl.HasProp("Value")
		{
			if CurrControl.Value = "Enter Search Criteria for Customer"
			{
				CurrControl.Value := ""
			}
		}
		PrevHwnd := Hwnd
	}
}
getCustomers()
{
	global customers
	try {
		temp := requests.Get(, "customers")
	} catch as e {
		if FileExist("log.json")
			customers := Jsons.Loads(&x := FileOpen("log.json", "r").Read())
		return e.Message
	}
	return temp
}

keyCustomers(temp)
{
	global customers
	if temp
	{
		for k in temp
		{
			customers[k["customerID"]] := k
		}
		FileOpen("log.json", "w").Write(Jsons.Dumps(customers))
		return customers
	}
}