#SingleInstance force
#Requires Autohotkey v2

customers := Map()

DirCreate(dir := A_MyDocuments "\ahk_log")

class Customer
{
	static ID := ""
	static customerLogFile := dir "\customers.json"
	static hwnd := ""
	static gui_hwnd := ""
	static gui := {}
	static event := {}
	static event.map := Map()
	static future_events := Map()
	static events := Map()
	static recipient_search := 0
	static profile := Map()
	static recipient := Map()
	static producer := Map()
	static edit_hwnd := ""
	static event.animals := {
		animal: "",
		total: 0.00,
		remaining: 0.00,
		amount: 0.00,
		temp_remaining: 0.00
	}

	static Call(filter := false, header?)
	{
		global customers, gui_, customersById
		requests.appName := "customers"
		gui_.cust := {}
		w := SysGet(16)
		h := SysGet(17)
		Customer.ID := ""
		Customer.profile := Map()
		if customers is String
			MsgBox customers
		hX := 0.01, hY := 0.01, hW := 0.98, hH := 0.1
		gui_.SetFont("s15", "Arial")
		gui_.SetFont("cWhite")
		gui_.BackColor := "0x212121"
		if IsSet(header)
		{
			gui_.cust.Header := gui_.Add("Text", "", header)
			GuiReSizer.FormatOpt(gui_.cust.Header, hX, hY, hW, hH)
			gui_.cust.Header.SetFont("s40")
		}
		gui_.cust.Header2 := gui_.Add("Text", "", "Use the box on the next line to search for a customer:")
		GuiReSizer.FormatOpt(gui_.cust.Header2, hX, hY += 0.1, hW / 1.1, hH)
		gui_.cust.Search := gui_.Add("Edit", "", "Enter Search Criteria for Customer")
		GuiReSizer.FormatOpt(gui_.cust.Search, hX, hY += 0.1, 0.8, hH - 0.02)
		gui_.cust.Search.SetFont("s30")

		gui_.cust.LV := gui_.Add("ListView", "xm+20 y+20 w" w / 3 * 2 " h" h - 180 " +LV0x4000 BackgroundBlack", ["Customer Name", "Farm", "Animals", "ID"])
		gui_.cust.LV.SetFont("cWhite")
		GuiReSizer.FormatOpt(gui_.cust.LV, hX, hY += 0.1, 0.8, 0.65)
		gui_.cust.Button := gui_.Add("Button", "", "Confirm").Icon()
		GuiReSizer.FormatOpt(gui_.cust.Button, hX += 0.81, hY, 0.17, 0.1)

		gui_.cust.details := gui_.Add("Listbox", "", ["Customer Details"])
		GuiReSizer.FormatOpt(gui_.cust.details, hX, hY + 0.11, 0.17, 0.3)

		gui_.cust.LV.OnEvent("DoubleClick", clickConfirm)
		gui_.cust.LV.OnEvent("Click", clickLV)
		gui_.cust.LV.BackColor := "0x212121"

		gui_.cust.Button.OnEvent("Click", clickConfirm)

		gui_.cust.Search.OnEvent("Focus", searchFieldChange)
		gui_.cust.Search.OnEvent("Change", searchFieldChange)
		gui_.cust.Search.SetFont("cWhite")

		gui_.OnEvent('Close', (*) => ExitApp())

		gui_.Title := "Search for Customer"
		gui_.cust.LV.ModifyCol(3, w / 6)
		gui_.cust.LV.ModifyCol(2, w / 6)
		gui_.cust.LV.ModifyCol(1, w / 6)
		; customerGui.Show("w1006 h582")
		OnMessage(0x0201, WM_LBUTTONDOWN)
		gui_.cust.LV.SetFont("s20")
		if filter = "events"
		{
			customers := customersWithFutureEvents(customers)
			gui_.cust.LV.SetFont("s22")
			gui_.cust.LV.ModifyCol(1, w / 4)
			Customer.recipient_search := 0
		} else {
			Customer.recipient_search := 1
			customers := getCustomers()
		}
		darkMode(gui_)
		Customer.importCustomers2LV(gui_.cust.LV, , customers)
		customers := Map()
		GuiResizer.Now(gui_)
		setBackgroundColors()

		clickLV(LV, Row, *)
		{
			if !Row
				return
			ID := gui_.cust.LV.GetText(Row, 4)
			gui_.cust.details.Delete()
			eventDetails := requests.GetUrl("events/" ID "/future-events")
			if !eventDetails is String
				yweek := eventDetails[1]['yweek'], y := SubStr(yweek, 1, 4), w := SubStr(yweek, 5, 2), gui_.cust.details.Add(["Week " w, "Year " y])
			customers := readCustomers()
			cust := customers[ID]
		}

		searchFieldChange(guiCtrl, *)
		{
			static lastValue := ""
			gui_.cust.details.Delete()
			if lastValue = guiCtrl.Value
				return
			if guiCtrl.Focused = 1
			{
				if guiCtrl.Value != ""
				{
					Customer.importCustomers2LV(gui_.cust.LV, guiCtrl.Value)
					lastValue := guiCtrl.Value
					; do something
				}
				else if guiCtrl.Value = ""
				{
					Customer.importCustomers2LV(gui_.cust.LV)
					lastValue := guiCtrl.Value
				}
			}
			else if guiCtrl.Value != lastValue && guiCtrl.Value = ""
			{
				Customer.importCustomers2LV(gui_.cust.LV)
				lastValue := guiCtrl.Value
				; do something
			}
		}
		clickConfirm(*)
		{
			global customers
			RowNumber := gui_.cust.LV.GetNext()
			if not RowNumber  ; The above returned zero, so there are no more selected rows.
				return
			cID := gui_.cust.LV.GetText(RowNumber, 4)
			if not Integer(cID) is Number
			{
				return
			}
			f := FileOpen(Customer.customerLogFile, "r")
			{
				customersById := Json.Load(f.read())
			}
			Customer.profile := customersById[cID]
			Customer.ID := cID
			OnMessage(0x0201, WM_LBUTTONDOWN, 0)
			gui_.cust.ToggleVisible(0)
			Customer.ID := cID
		}

		OnEventHandler(*)
		{
			ToolTip("Click! This is a sample action.`n"
				. "Active GUI element values include:`n"
				. "ButtonConfirmSelection => " gui_.cust.Button.Text "`n", 77, 277)
			SetTimer () => ToolTip(), -3000 ; tooltip timer
		}

		getCustomers()
		{
			requests.appName := "customers"
			try {
				customers := requests.Get(, "customers")
			} catch as e {
				if FileExist(Customer.customerLogFile)
					customers := Jsons.Loads(&x := FileOpen(Customer.customerLogFile, "r").Read())
				return e.Message
			}
			FileOpen(Customer.customerLogFile, "w").Write(Json.Dump(customers))


			;customers := keyCustomers(temp)
			return customers
		}
		readCustomers()
		{

			customers := Jsons.Loads(&x := FileOpen(Customer.customerLogFile, "r").Read())
			return customers
		}
		WM_LBUTTONDOWN(wParam, lParam, msg, Hwnd)
		{
			global gui_
			static PrevHwnd := 0
			if (Hwnd != PrevHwnd) && (gui_.cust.Search.hwnd = Hwnd)
			{
				CurrControl := GuiCtrlFromHwnd(Hwnd)
				PrevHwnd := Hwnd
				if CurrControl.HasProp("Value")
				{
					if CurrControl.Value = "Enter Search Criteria for Customer"
					{
						CurrControl.Value := ""
					}
				}
			}
		}
				
		getEvents()
		{
			events := Map()
			requests.appName := "events"
			try {
				temp := requests.Get(, "events")
			} catch as e {
				Msgbox e.Message "`n`nAPI's down. Exiting..."
				exitapp()
				return
			}
			for index, event in temp
			{
				if !events.Has(event['customer'])
					events[event['customer']] := Map()
				events[event['customer']][event['id']] := event
			}
			return events
		}

		customersWithFutureEvents(customers)
		{
			global customersById
			requests.appName := "customers"
			customersWithEvents := Map()
			customersById := Map()
			customersWithEvents := requests.GetUrl("customers/future-events")
			if customersWithEvents is String
			{
				Msgbox customersWithEvents
				ExitApp()
			}
			FileOpen(Customer.customerLogFile, "w").Write(Json.Dump(customersWithEvents))
			return customersWithEvents
		}

		keyCustomers(temp)
		{
			global customers
			customers := []
			if temp
			{
				for k, v in temp
				{
					customers.Set(temp[k]['id'], v)
				}
				return customers
			}
		}
	}
	static InitHandler()
	{
		return true
	}
	
	static importCustomers2LV(LV, searchVal?, customers?)
	{
		LV.Delete()
		if !IsSet(customers)
		{
			f := FileOpen(Customer.customerLogFile, "r")
			{
				customers := Json.Load(f.read())
			}
		}
		for k, v in customers
		{
			if A_Index > 50
				break
			if v.Has("full_name")
			{
				if IsSet(searchVal)
					if searchVal != ""
					{
						try
						{
							if !InStr(v["full_name"], searchVal) && !InStr(v["company_name"], searchVal) && !InStr(v["billing_street"], searchVal)
								continue
						}
					}
				str := ""
				if Customer.recipient_search = 0
				{
					if v.Has("id")
					{
						requests.appName := "events"
						event := requests.GetUrl("events/" v['id'] "/future-events")
					}
					str := ""
					if event.Has(1)
						if event[1].Has("cows")
						{
							str := (event[1]['cows'] != 0) ? event[1]['cows'] " cows"
								: event[1]["pigs"] != 0 ? event[1]['pigs'] " pigs"
									: (event[1]["lambs"] != 0) ? event[1]['lambs'] " lambs" : ""
						}
				}
				try {
					LV.Add(, v["full_name"], v["company_name"], str, v["id"])
				} catch as e {
					continue
				}
			}
		}
	}
}



