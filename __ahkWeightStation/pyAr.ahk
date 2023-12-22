; u/GroggyOtter
Array.Prototype.DefineProp("Contains", { Call: array_contains })

; u/GroggyOtter
array_contains(arr, search, case_sensitive := 0)
{
    for index, value in arr {
        if !IsSet(value)
            continue
        else if InStr(value, search, CaseSense := case_sensitive)
            return index
    }
    return 0
}

; This function defines a property called "ToggleVisible" on the prototype of the Object class.
; When called, it hides or shows all GUI controls from the given object.
; The function returns 1 if any controls were hidden or shown, otherwise it returns 0.
Object.Prototype.DefineProp("ToggleVisible", { Call: HideAll_guiCtrls_fromObj })

; This function hides or shows all GUI controls from the given object.
; It iterates over the properties of the object and checks if they are set and if they are objects with a "Visible" property.
; If a control is found, its "Visible" property is toggled and the status is set to 1.
; The function returns the status indicating if any controls were hidden or shown.

; Example:
; myGui.ParentGui := {}
; myGui.ParentGui.Buttons := {}
; myGui.ParentGui.Buttons.Next := myGui.Add("Button", , "Hello World")
; ...additional buttons may be added to group
; myGui.ParentGui.ToggleVisible()
;
HideAll_guiCtrls_fromObj(selfObj)
{
    status := 0
    for index, value in selfObj.OwnProps() {
        if !IsSet(value)
            continue
        else if IsObject(value)
        {
            if not InStr(value.__Class, "Gui.")
                status := HideAll_guiCtrls_fromObj(value)
            else if value.HasProp("Visible")
            {
                value.Visible := !value.Visible
                status := 1
            }
        }
    }
    return status
}





; This function defines a property called "ToggleVisible" on the prototype of the Object class.
; When called, it hides or shows all GUI controls from the given object.
; The function returns 1 if any controls were hidden or shown, otherwise it returns 0.
Object.Prototype.DefineProp("VisibleStatus", { Call: GuiCtrlVisibleStatus })

; This function hides or shows all GUI controls from the given object.
; It iterates over the properties of the object and checks if they are set and if they are objects with a "Visible" property.
; If a control is found, its "Visible" property is toggled and the status is set to 1.
; The function returns the status indicating if any controls were hidden or shown.

; Example:
; myGui.ParentGui := {}
; myGui.ParentGui.Buttons := {}
; myGui.ParentGui.Buttons.Next := myGui.Add("Button", , "Hello World")
; ...additional buttons may be added to group
; myGui.ParentGui.ToggleVisible()
;
GuiCtrlVisibleStatus(selfObj)
{
    for index, value in selfObj.OwnProps() {
        if IsSet(status) 
            return status
        if !IsSet(value)
            continue
        else if IsObject(value)
        {
            if not InStr(value.__Class, "Gui.")
            {
                temp := GuiCtrlVisibleStatus(value)
                if IsSet(temp)
                    status := temp
            }
            else if value.HasProp("Visible")
            {
                status := value.Visible
            }
        }
    }
    if IsSet(status)
        return status
    else
        return 
}


Array.Prototype.DefineProp("Join", { Call: array_join })


array_join(arr, delimiter)
{
    str := ""
    for index, value in arr {
        if !IsSet(value)
            continue
        else
            str .= value .= delimiter
    }
    return str
}


Map.Prototype.DefineProp("Keys", { Call: get_keys })

get_keys(mp)
{
    mapKeys := []
    for k, v in mp {
        if !IsSet(k)
            continue
        else if k is string or k is number
            mapKeys.Push(k)
    }
    return mapKeys
}

Map.Prototype.DefineProp("Values", { Call: get_values })

get_values(mp)
{
    mapValues := []
    for k, v in mp {
        if !IsSet(v)
            continue
        else if v is string
            mapValues.Push(v)
    }
    return mapValues
}


str(obj, indent := 4) => Jsons.Dumps(obj, indent)