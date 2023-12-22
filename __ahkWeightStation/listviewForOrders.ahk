; Create a GUI window:
MyGui := Gui("+Resize")  ; Allow the user to maximize or drag-resize the window.

; Create some buttons:
B1 := MyGui.Add("Button", "Default", "Add Item")
B2 := MyGui.Add("Button", "x+20", "Delete Item")
B3 := MyGui.Add("Button", "x+20", "Clear List")

; Create the ListView and its columns:
LV := MyGui.Add("ListView", "xm r20 w400", ["Key", "Value"])

; Apply control events:
B1.OnEvent("Click", AddItem)
B2.OnEvent("Click", DeleteItem)
B3.OnEvent("Click", ClearList)

; Display the window:
MyGui.Show()

; Create a Map to store key-value pairs:
MyMap := Map()

AddItem(*)
{
    IB := InputBox("Enter the key for the new item:", "Enter Key", "h100"), NewKey := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
    if ErrorLevel  ; User pressed Cancel
        return
    
    IB := InputBox("Enter the value for " NewKey ":", "Enter Value"), NewValue := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
    if ErrorLevel  ; User pressed Cancel
        return

    ; Add the key-value pair to the Map:
    MyMap[NewKey] := NewValue
    
    ; Add the key-value pair to the ListView:
    LV.Add(, NewKey, NewValue)
}

DeleteItem(*)
{
    IB := InputBox("Enter the key to delete:", "Enter Key"), KeyToDelete := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
    if ErrorLevel  ; User pressed Cancel
        return

    ; Check if the key exists in the Map before deleting:
    if (MyMap.Has(KeyToDelete)) {
        ; Delete the key-value pair from the Map:
        MyMap.Delete(KeyToDelete)

        ; Find the index of the item in the ListView:
        IndexToDelete := LV.Find(KeyToDelete)
        
        ; Delete the item from the ListView:
        LV.Delete(IndexToDelete)
    } else {
        MsgBox("Key not found!")
    }
}

ClearList(*)
{
    ; Clear the Map:
    MyMap := Map()

    ; Clear all items from the ListView:
    LV.Delete()
}
