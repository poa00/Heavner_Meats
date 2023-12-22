
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2
x := Test()
Msgbox x

Test()
{
	myGui := Gui("Modal")	
	Edit1 := myGui.Add("Edit", "x168 y56 w114 h127", "zzzzz")
	ogcButtonOK := myGui.Add("Button", "x12 y69 w80 h23", "&OK")
	ogcButtonOK.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => ExitApp())
	myGui.Title := "Window"
	myGui.Show("w320 h320")

	OnEventHandler(*)
	{
		myGui := Gui()	
		Edit1 := myGui.Add("Edit", "x168 y56 w114 h127", "zzzzz")
		ogcButtonOK := myGui.Add("Button", "x12 y69 w80 h23", "&OK")
		ogcButtonOK.OnEvent("Click", OnEventHandler)
		myGui.OnEvent('Close', (*) => ExitApp())
		myGui.Title := "Window"
		myGui.Show("w320 h320")
		return "False"
	}
	return Edit1.Value

}
