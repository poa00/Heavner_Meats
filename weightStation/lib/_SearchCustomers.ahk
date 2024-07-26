#Include <request2>
tempLog := A_ScriptDir "\cstmrlog.json"

/**
 * @fileoverview
 * @author Your Name
 * @summary Customers Narrowed down by Gender, then option to select.
 * @namespace SEARCHCUSTOMER__
 */
class searchCustomers
{
    static searchText := "Enter Search Criteria for Customer"
    static finished := false
    static eventID := 0
    static animalObj := {}
    static customersLoaded := False
    /**
     * @function Call
     * @param {object} wsGUI The reference to the wsGUI object.
     * @param {object} animalObj The animal object.
     * @return {object} The modified wsGUI object.
     * @description This method sets up the customer search functionality in the WeightStation GUI.
     */
    static Call(&wsGUI, &animalObj, wait := True)
    {
        searchCustomers.animalObj := animalObj
        searchCustomers.finished := false
        searchCustomers.customersLoaded := false
        if wsGUI.HasOwnProp('CustSrch')
            wsGUI.ToggleVisible(0), wsGUI.CustSrch.ToggleVisible(1), searchCustomers.importCustomers(, animalObj.species)
        else
            searchCustomers.newGui(&wsGUI)
        if wait
        {
            while !searchCustomers.finished
                Sleep 100
        }
        return searchCustomers.animalObj
    }
    static newGui(&wsGUI)
    {
        customers := Map()
        wsGUI.ToggleVisible(0)
        wsGUI.SetFont("s35 cWhite")
        dim := {}, dim.x := 0.02, dim.y := 0.02, dim.w := 0.7, dim.h := 0.8
        wsGUI.CustSrch := {}
        wsGUI.CustSrch.Edit := wsGUI.Add("Edit", "x32 y32 w1117 h48", searchCustomers.searchText)
        wsGUI.CustSrch.LV_ := wsGUI.Add("ListView", "x32 y+10 w1117 h711 +LV0x4000", ["Customer", "Email", "ID"])
        GuiReSizer.FO(wsGUI.CustSrch.Edit, dim.x, dim.y, dim.w, 0.07)
        GuiReSizer.FO(wsGUI.CustSrch.LV_, dim.x, dim.y += 0.1, dim.w, dim.h)
        wsGUI.CustSrch.Edit.OnEvent("Focus", searchCustomers.searchFieldChange)
        wsGUI.CustSrch.Edit.OnEvent("Change", searchCustomers.searchFieldChange)

        wsGUI.CustSrch.Sel := wsGUI.Add("Button", "x512 y24 w211 h36", "Select Order")
        GuiReSizer.FO(wsGUI.CustSrch.Sel, dim.x + dim.w + 0.01, dim.y, 0.26, 0.09)
        wsGUI.CustSrch.Modify := wsGUI.Add("Button", "x512 y24 w211 h36", "Modify Order")
        GuiReSizer.FO(wsGUI.CustSrch.Modify, dim.x + dim.w + 0.01, dim.y += 0.1, 0.26, 0.09)

        wsGUI.CustSrch.Remaining := wsGUI.Add("Listview", "x512 y24 w211 h36", ['Cows Remaining', 'Pigs Remaining', 'Lambs Remaining'])
        GuiReSizer.FO(wsGUI.CustSrch.Remaining, dim.x + dim.w + 0.01, dim.y += 0.1, 0.26, 0.19)
        wsGUI.CustSrch.total := wsGUI.Add("Listview", "x512 y24 w211 h36", ['Cows Total', 'Pigs Total', 'Lambs Total'])
        GuiReSizer.FO(wsGUI.CustSrch.total, dim.x + dim.w + 0.01, dim.y += 0.21, 0.26, 0.19)
        wsGUI.CustSrch.total.SetFont('s14')
        wsGUI.CustSrch.Remaining.SetFont('s14')
        ; wsGUI.CustSrch.LV_.OnEvent("Click",
        ;     searchCustomers.LV_DoubleClick.Bind(wsGUI.CustSrch.LV_))

        wsGUI.CustSrch.Sel.Icon(23)
        wsGUI.Title := "Search Customers"
        GuiResizer.Now(wsGUI)
        darkMode(wsGUI)
        customers := searchCustomers.importCustomers(, searchCustomers.animalObj.species)
        
        wsGUI.CustSrch.Sel.OnEvent("Click", (*) => searchCustomers.LV_DoubleClick(wsGUI.CustSrch.LV_))
        wsGUI.CustSrch.LV_.OnEvent("DoubleClick",(*) => searchCustomers.LV_DoubleClick(wsGUI.CustSrch.LV_))
        wsGUI.CustSrch.LV_.OnEvent("ItemSelect", (*) =>
            searchCustomers.PreviewChange(customers, wsGUI.CustSrch.LV_, wsGUI.CustSrch.Remaining, wsGUI.CustSrch.total))

        Loop 4
        {
            if A_Index = 1
                wsGUI.CustSrch.LV_.ModifyCol(A_Index, 800), wsGUI.CustSrch.Remaining.ModifyCol(A_Index, 200), wsGUI.CustSrch.total.ModifyCol(A_Index, 200)
            else if A_Index < 4
                wsGUI.CustSrch.LV_.ModifyCol(A_Index, 600), wsGUI.CustSrch.Remaining.ModifyCol(A_Index, 200), wsGUI.CustSrch.total.ModifyCol(A_Index, 200)
        }
    }

    static importCustomers(srch?, species?)
    {
        customers := Map()
        wsGUI.CustSrch.LV_.Delete()
        if searchCustomers.customersLoaded = false
            customers_str := Requests2.AHKGet("customers/weight-station" .
                (IsSet(species) ? "?species=" species : "")), customerData := JSON.Load(customers_str),
                FileOpen(tempLog, "w").Write(Json.Dump(customers))
        else
            customerData := Json.Load(FileRead(tempLog))
        searchCustomers.customersLoaded := True
        for event in customerData
        {
            if IsSet(srch)
            {
                try {
                    if !InStr(event['customer']['full_name'], srch) && !InStr(event['event']['customer']['email'], srch) && !InStr(event['eventID'], srch)
                        continue
                }
            }
            try
            {
                customer := _Customer(event['customer']['full_name'], event['animals'], event['customer']['email'], event['eventID'], event['customer']['customer_id'])
                wsGUI.CustSrch.LV_.Add(, customer.full_name, customer.email, customer.eventID)
                customers[customer.eventID] := customer
            }
            catch as e
                Msgbox e.Message
        }
        return Customers
    }
    static LV_DoubleClick(LV?, *)
    {
        RowNum := LV.GetNext(0)
        if not RowNum
            return
        eventid := LV.GetText(RowNum, 3)
        searchCustomers.animalObj.eventID := eventid
        searchCustomers.finished := true
        ; response := requests2.PostUrl("animals/" eventid, AnimalsAPI.convertToJSON(obj))
        ; SetTimer () => ToolTip(), -3000
        ; try Msgbox response
        ; try Msgbox JSON.Dump(response)
    }

    static searchFieldChange(*)
    {
        static lastValue := ""
        if lastValue = wsGUI.CustSrch.Edit.Value
            return
        if wsGUI.CustSrch.Edit.Value = searchCustomers.searchText
            wsGUI.CustSrch.Edit.Value := ""
        if wsGUI.CustSrch.Edit.Focused = 1
        {
            if wsGUI.CustSrch.Edit.Value != "" && wsGUI.CustSrch.Edit.Value != searchCustomers.searchText
            {
                Importer(wsGUI.CustSrch.Edit.Value)
                ; do something
            }
            else if wsGUI.CustSrch.Edit.Value = ""
            {
                Importer()
            }
        }
        else if wsGUI.CustSrch.Edit.Value != lastValue && wsGUI.CustSrch.Edit.Value = ""
        {
            Importer()
        }
        Importer(params*)
        {
            wsGUI.CustSrch.LV_.Delete
            if params
                searchCustomers.importCustomers(params.Has(1) ? params[1] : "")
            else
                searchCustomers.importCustomers()
            lastValue := wsGUI.CustSrch.Edit.Value
        }
    }
    static previewChange(_customers, customerLV, Remaining, total)
    {
        RowNum := customerLV.GetNext(0)
        if not RowNum
            return
        eventid := customerLV.GetText(RowNum, 3)
        Remaining.Delete()
        total.Delete()
        try _customers[Integer(eventid)].retrieveRemaining()
        catch as e 
            return "error"
        Remaining.Add(, _customers[Integer(eventid)].cows['remaining'],
            _customers[Integer(eventid)].pigs['remaining'],
            _customers[Integer(eventid)].lambs['remaining'])
        total.Add(, _customers[Integer(eventid)].cows['total'],
            _customers[Integer(eventid)].pigs['total'],
            _customers[Integer(eventid)].lambs['total'])
    }
}


/**
 * Creates a new instance of the _Customer class.
 * @constructor
 * @param {string} full_name - The full name of the customer.
 * @param {object} animals - The animals associated with the customer.
 * @param {string} email - The email address of the customer.
 * @param {string} eventID - The event ID associated with the customer.
 * @param {number} [customer_id=0] - The customer ID (optional, default value is 0).
 */
class _Customer
{
    __New(full_name, animals, email, eventID, customer_id := 0)
    {
        this.full_name := full_name
        this.animals := animals
        this.email := email
        this.eventID := eventID
        this.customerID := customer_id
        this.cows_remaining := 0
        this.pigs_remaining := 0
        this.lambs_remaining := 0
    
    }
    retrieveRemaining()
    {
        try {
            customers_str := Requests2.AHKGet('animals/event/' this.eventID '/total_remaining/')
            details := JSON.Load(customers_str)['details']
            this.cows := details['cows']
            this.pigs := details['pigs']
            this.lambs := details['lambs']
        }
    }
}