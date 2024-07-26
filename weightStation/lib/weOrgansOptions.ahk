#Requires Autohotkey v2
#Include <darkmode>
#SingleInstance Force
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if (A_LineFile = A_ScriptFullPath) && !A_IsCompiled
{
	G := {}
	X := {}
	myGui := organOptions(&G, &X)
	myGui.Show("w914 h694")
	darkmode(myGui)
}

class organOptions
{
	static finished := false
	static hwnd := 0
	static animal := false
	static animalObj := {}
	static Num := {}
	static numpad_hwnds := {}
	static onScreenNumActive := False
	static genderMap := Map(
		'Cow', ['Steer', 'Heffer', 'Bull'],
		'Pig', ['MHog', 'Sow', 'Boar']
		; animalOptions.genders['Cows'] := ['Steer', 'Heffer', 'Bull']
	)
	static genderCtrls := []

	static Call(&G, &animalObj, wait := True)
	{
		organOptions.animalObj := animalObj
		organOptions.finished := false
		organOptions.genderCtrls := []
		if G.HasOwnProp('organOptions')
			organOptions.reloadChild(&G)
		else
			organOptions.gender(&G)
		organOptions.injectGender(&animalObj)
		if wait
		{
			while !organOptions.finished
				Sleep 100
			return organOptions.animalObj
		}
	}
	static Constructor()
	{
		myGui := Gui()
		myGui.SetFont("s14", "Ms Shell Dlg cWhite")
		myGui.SetFont("s15 cWhite")
		myGui.Add("GroupBox", "x16 y8 w217 h659", "GroupBox")
		myGui.SetFont("s14", "Ms Shell Dlg")
		CheckBox1 := myGui.Add("CheckBox", "x32 y56 w176 h23", "CheckBox")
		; CheckBox1.OnEvent("Click", OnEventHandler)
		myGui.OnEvent('Close', (*) => ExitApp())
		myGui.Title := "Window"

		return myGui
	}
}