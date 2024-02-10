
#Requires Autohotkey v2

;
; HOW TO ADD UNKNOWN CHILDREN TO PROTOTYPE 
;


; LV.Sort(coloumn, direction := "D" or "A")   D = Descending, A = Ascending
Gui.Button.Prototype.DefineProp("Style", { Call: setStyle })
; define the prototype

class setStyle
{
    static Call(ctrl, style := "info")
    {
        Try
        {
            ButtonStyle(ctrl, 0, style)
        } catch as e {
            return ctrl
        }
        return ctrl
    }
}

myGui := Construct()

Construct() {
	myGui := Gui()
	ButtonOK := myGui.Add("Button", "x16 y16 w189 h112", "&OK").Style.Round.Red()
	ButtonOK.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	myGui.Show("w620 h420")
	
	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
		. "Active GUI element values include:`n"  
		. "ButtonOK => " ButtonOK.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}