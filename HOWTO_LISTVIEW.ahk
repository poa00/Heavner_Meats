; Create a new GUI window
MyGui := Gui()

; Add a ListView to the GUI and create some columns
LV := MyGui.Add("ListView", "r20 w300", ["ID", "Name", "Status"])

; Populate the ListView with some example data
LV.Add(, 1, "Item 1", "Available")
LV.Add(, 2, "Item 2", "Busy")
LV.Add(, 3, "Item 3", "Unavailable")

; Register the ItemSelect event for the ListView
LV.OnEvent("ItemSelect", OnItemSelect)

; Display the GUI
MyGui.Show()

; Function executed when an item is either selected or deselected
OnItemSelect(LV, *)
{
    ; Get the number of the first selected row
    RowNumber := LV.GetNext(0)
    
    ; Continue retrieving and processing selected rows
    While (RowNumber)
    {
        ; Retrieve the text of the first cell in the selected row
        Text := LV.GetText(RowNumber, 1)
        
        ; Display a message to indicate the selected item
        MsgBox("Item selected: #" RowNumber " with ID: " Text)

        ; Get the next selected row (if any)
        RowNumber := LV.GetNext(RowNumber)
    }
}
