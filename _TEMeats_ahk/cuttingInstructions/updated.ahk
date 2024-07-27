
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Gui()
#Include <AutoResizer>
AutoResizer(myGui)
myGui.Opt("+Resize")
DropDownList1 := myGui.Add("DropDownList", "x32 y48 w383", ["Style", "Unseasoned Ground Pork", "T&E Classic", "Sage Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo", ""])
DropDownList2 := myGui.Add("DropDownList", "x472 y48 w382", ["Size", "Loose", "1 oz Links", "2 oz Links", "4 oz Links", "Patties"])
myGui.Add("GroupBox", "x334 y272 w558 h202", "Sausage for this order")
myGui.Add("GroupBox", "x24 y272 w296 h200", "Items set to Grind")
myGui.Add("ListBox", "x48 y320 w250 h129", ["Items"])
ListView := myGui.Add("ListView", "x344 y320 w531 h133")
Edit1 := myGui.Add("Edit", "x32 y112 w201 h39", "50")
ButtonAddCurrent := myGui.Add("Button", "x472 y184 w383 h44", "Add Current")
myGui.Add("Text", "x248 y120 w75 h24", "lb")
ButtonFinished := myGui.Add("Button", "x728 y488 w166 h33", "Finished")
ButtonCancel := myGui.Add("Button", "x536 y488 w166 h33", "Cancel")
ButtonChangeValue := myGui.Add("Button", "x472 y112 w381 h45", "Change Value")
myGui.Add("GroupBox", "x8 y8 w883 h245", "GroupBox")
ButtonAddCurrent.OnEvent("Click", OnEventHandler)
ButtonFinished.OnEvent("Click", OnEventHandler)
ButtonCancel.OnEvent("Click", OnEventHandler)
ButtonChangeValue.OnEvent("Click", OnEventHandler)
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window (Clone)"
myGui.Show("w934 h574")

OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "ButtonAddCurrent => " ButtonAddCurrent.Text "`n" 
	. "ButtonFinished => " ButtonFinished.Text "`n" 
	. "ButtonCancel => " ButtonCancel.Text "`n" 
	. "ButtonChangeValue => " ButtonChangeValue.Text "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}
