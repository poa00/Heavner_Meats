
#Requires Autohotkey v2
#SingleInstance Force
#Include <darkMode>
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := initSausage()
DarkMode(myGui)

initSausage() {
	w := A_ScreenWidth 
	h := A_ScreenHeight
	mW := w / 2 - (w/5)
	mH := h / 15
	Msgbox h w
	myGui := Gui()
	myGui.Opt("+0x80000000 +E0x1 +E0x81 +E0x181 -DPIScale +AlwaysOnTop")
	myGui.SetFont("s14 cWhite", "Verdana ")
	myGui.Add("GroupBox", "x10 y10 w909 h238", "Add Sausage")
	Style := myGui.Add("DropDownList", "xp+25 y+65 w395 Section Choose1", ["Style", "Unseasoned Ground Pork", "T&E Classic", "Sage Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo", ""])
	Size := myGui.Add("DropDownList", "x+15  w393 Choose1", ["Size", "Loose", "1 oz Links", "2 oz Links", "4 oz Links", "Patties"])
	myGui.SetFont("s16 cWhite", "")
	myGui.SetFont("s14 cWhite", "Verdana cWhite")
	Edit1 := myGui.Add("UpDown", "xs y+15 w150 h44 +0x2", )
	Edit1 := myGui.Add("UpDown", "x+20 w150 h44 +0x2",)
	txt := myGui.Add("Text", "x+10 y+3 w78 h28 +0x200", "lb")
	myGui.SetFont("s14 cWhite", "Verdana cWhite")
	ButtonChangeValueietolb := myGui.Add("Button", "x568 y120 w331 h47", "Change Value (ie. `% to lb)")
	ButtonAddCurrent := myGui.Add("Button", "x32 y184 w399 h38", "Add Current")
	myGui.Add("GroupBox", "xs y+15 w572 h218", "Sausage for this order")
	myGui.SetFont("s12 cWhite", "cWhite")
	myGui.Add("GroupBox", "x24 y264 w304 h225", "Items set to Grind")
	myGui.SetFont("s14 cWhite", "Verdana cWhite")
	myGui.Add("ListBox", "x48 y320 w257 h144", ["Items"])	
	LV_ := myGui.Add("ListView", "x352 y320 w546 h150 +LV0x4000", ["ListView"])
	myGui.SetFont("s14 cWhite", "Verdana cWhite")

	ButtonFinished := myGui.Add("Button", "x744 y512 w171 h38", "Finished")
	ButtonCancel := myGui.Add("Button", "x544 y512 w171 h38", "Cancel")
	LV_.Add(,"Sample1")
	LV_.OnEvent("DoubleClick", LV_DoubleClick)
	Style.OnEvent("Change", OnEventHandler)
	Size.OnEvent("Change", OnEventHandler)
	Edit1.OnEvent("Change", OnEventHandler)
	ButtonChangeValueietolb.OnEvent("Click", OnEventHandler)
	ButtonAddCurrent.OnEvent("Click", OnEventHandler)
	ButtonFinished.OnEvent("Click", OnEventHandler)
	ButtonCancel.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	myGui.Show("w934 h574")
	
	LV_DoubleClick(LV, RowNum)
	{
		if not RowNum
			return
		ToolTip(LV.GetText(RowNum), 77, 277)
		SetTimer () => ToolTip(), -3000
	}
	
	OnEventHandler(*)
	{
		ToolTip("Click! This is a sample action.`n"
		. "Active GUI element values include:`n"  
		. "DropDownList1 => " Style.Text "`n" 
		. "DropDownList2 => " Size.Text "`n" 
		. "Edit1 => " Edit1.Value "`n" 
		. "ButtonChangeValueietolb => " ButtonChangeValueietolb.Text "`n" 
		. "ButtonAddCurrent => " ButtonAddCurrent.Text "`n" 
		. "ButtonFinished => " ButtonFinished.Text "`n" 
		. "ButtonCancel => " ButtonCancel.Text "`n", 77, 277)
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}
	
	return myGui
}