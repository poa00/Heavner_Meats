
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2
calendarParentGUI := Gui()
calendarParentGUI.Show("w500 h400")

childOne := Gui("+Parent" calendarParentGUI.hwnd " -Caption")
childOneNextButton := childOne.Add("Button", "w100 h60", "Click for gui 2")
childOne.Add("Edit", "w250 h300", "lorem ipsum")
childOne.Add("Button", "x+10 w100 h30", "Button1 1")
childOne.Add("Button", "w100 h30", "Button1 2")
childOne.Add("Button", "w100 h30", "Button1 3")


childTwo := Gui("+Parent" calendarParentGUI.hwnd " -Caption")    
childTwo.Add("Picture", "x-216 y-120 w1024 h1024", "C:\Users\dower\Downloads\118531657_10213893034880343_6938662191855010778_n.jpg")
childTwo.Show("x0 y0")

childOne.Show("x0 y0") ; position relative to parent gui
WinSetTransparent 245, "ahk_id " childOne.hwnd 
WinSetTransparent 245, "ahk_id " calendarParentGUI.hwnd 
WinSetTransColor  "Black", "ahk_id " childTwo.hwnd 
WinMove 0,0,,, "ahk_id " childOne.hwnd

calendarParentGUI.backcolor := "Black"
