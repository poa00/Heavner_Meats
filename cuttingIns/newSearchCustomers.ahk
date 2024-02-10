#Include <GuiReSizer>
#SingleInstance Force
#Requires AutoHotkey v2

Cust := {}
gui_ := Gui()
;gui_ := Gui("+Parent" Customer.gui_hwnd " -DPIScale +AlwaysOnTop ")
;gui_.Opt("+Owner" Customer.gui_hwnd)
hX := 0.01, hY := 0.01, hW := 0.98, hH := 0.1
gui_.Opt("+Resize +MinSize800x600")
gui_.SetFont("s18")
gui_.cust.Header := gui_.Add("Text", "", "Select an Order")
gui_.cust.Header.SetFont('s30')
GuiReSizer.FormatOpt(gui_.cust.Header, hX, hY, hW, hH)
gui_.cust.Header2 := gui_.Add("Text", "", "Use the box on teh next line to search for a customer:")
GuiReSizer.FormatOpt(gui_.cust.Header2, hX, hY += 0.1, hW / 1.1, hH)
gui_.cust.Search := gui_.Add("Edit", "r1", "Search")
GuiReSizer.FormatOpt(gui_.cust.Search, hX, hY += 0.1, 0.8, hH-0.02)
gui_.cust.LV := gui_.Add("Listview", "", ["Customer Name", "Email", "ID"])
GuiReSizer.FormatOpt(gui_.cust.LV, hX, hY += 0.1, 0.8, 0.65)

gui_.cust.Button := gui_.Add("Button", "", "Confirm")
GuiReSizer.FormatOpt(gui_.cust.Button, hX+=0.81, hY, 0.17, 0.1)
gui_.OnEvent("Size", GuiResizer)
gui_.show()