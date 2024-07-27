#Requires Autohotkey v2
#Include <darkMode>
#SingleInstance Force
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := SpeciesSelection(['Cows', 'Pigs', 'Lambs'])
	myGui.Show("")
	Darkmode(myGui)
	while !SpeciesSelection.finished
		Sleep 100
	GuiFromHwnd(SpeciesSelection.hwnd).Destroy()
	if SpeciesSelection.selection = ""
		Reload()
}

class SpeciesSelection
{
	static finished := false
	static selection := ""
	static hwnd := 0
	
	static Call(species := ['cows', 'pigs', 'lambs'])
	{
		myGui := Gui('-DPIScale')
		myGui.SetFont("s15 cWhite", "Verdana ")
		myGui.Add("Text", "x24 y4 w564 ", "The selected customer has multiple species for `nthe upcoming order- Select which you'd like to set cutsheets for. Cow, Pigs, or Lambs (that apply).")
		myGui.SetFont("s25 cWhite", "Verdana ")
		for animal in species
		{
			dims := "x24 y+10 w391"
			if animal = "cows"
				Cows := myGui.Add("Radio", dims, "cows").OnEvent("Click", (*) => (SpeciesSelection.selection := "cows"))
			else if animal = "pigs"
				Pigs := myGui.Add("Radio", dims, "pigs").OnEvent("Click", (*) => (SpeciesSelection.selection := "pigs"))
			else if animal = "lambs"
				Lambs := myGui.Add("Radio", dims, "lambs").OnEvent("Click", (*) => (SpeciesSelection.selection := "lambs"))
		}
		ButtonOK := myGui.Add("Button", "x24 y+50 y+30 h110 w300", "&OK")
		ButtonCANCEL := myGui.Add("Button", "x+25 yp w220 h110 w300", "CANCEL")
		ButtonOK.OnEvent("Click", (*) => (SpeciesSelection.finished := true))
		ButtonCANCEL.OnEvent("Click", (*) => (SpeciesSelection.selection := "", SpeciesSelection.finished := true))
		myGui.OnEvent('Close', (*) => ExitApp())
		myGui.Title := "Window"
		SpeciesSelection.hwnd := myGui.hwnd


		return myGui
	}
}