#Requires Autohotkey v2

myGui := Gui( "+LastFound +E0x02000000 +E0x00080000")
myGui.SetFont("s16")


tabStorage := myGui.Add("Tab3", "w607 h341 x0 y0", [" tab1 ", " tab2 ", " tab3 "])
tabStorage.UseTab(1)
myGui.Add("ListBox", "w107 h341 x100 y100", ["text tab 3","2"])
; 						tab Section
tabStorage.UseTab() 
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w1013 h560")
Sleep(100)
WinSetTransparent 230, "ahk_id " myGui.hwnd