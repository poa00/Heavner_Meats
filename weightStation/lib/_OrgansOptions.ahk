#Requires Autohotkey v2
#Include <darkmode>  
#Include <GuiReSizer>
#SingleInstance Force
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if (A_LineFile = A_ScriptFullPath) && !A_IsCompiled
{
	organOptions.Launch("Cow")
}

/*
 * @class organOptions
 * @description Represents a class for managing organ options.
*/
class organOptions
{
	/*
	 * @static
	 * @property {boolean} finished - Indicates whether the organ options have been finished.
	*/
	static finished := false
	/*
	 * @static
	 * @property {number} hwnd - The handle of the organ options window.
	*/
	static organAssignment := Map()
	static hwnd := 0
	static organJson := Map()
	static species := {}
	/*
	 * @static
	 * @property {boolean} animal - Indicates whether the organ options are for an animal.
	*/
	static animal := false
	/*
	 * @static
	 * @property {object} animalObj - The animal object containing organ information.
	*/
	static animalObj := {}
	/*
	 * @static
	 * @property {object} Num - The number object.
	*/
	static Num := {}
	/*
	 * @static
	 * @property {array} numpad_hwnds - The array of numpad window handles.
	*/
	static numpad_hwnds := {}
	/*
	 * @static
	 * @property {boolean} onScreenNumActive - Indicates whether the on-screen number is active.
	*/
	static onScreenNumActive := False
	/*
	 * @static
	 * @property {object} organMap - The map of organs for different animals.
	*/
	static organMap := Map(
		'Cow', [
			"Heart", "Liver", "Tongue", "Sweet Bread", "Pizzle", "Pancreas ", "Spleen", "Oxtail", "Kidney", "Head", "Hide"
		],
		'Pig', [
			'Heart', 'Liver', 'Tongue', 'Head'
		]
	)
	/*
	 * @static
	 * @property {array} genderCtrls - The array of gender controls.
	*/
	static genderCtrls := []
	static pagination := {
		CURRENT: 1,
		MULTIPLE: false,
		ORGANS: Map(),
		NEXTBUTTON: {}
	}
	/**
	 * @static
	 * @method Call
	 * @description Calls the organ options.
	 * @param {object} G - The object containing organ options.
	 * @param {object} animalObj - The animal object containing organ information.
	 * @param {boolean} [wait=True] - Indicates whether to wait for the organ options to finish.
	*/
	static Launch(&animalObj, &wsGUI) => organOptions.initItems(&animalObj, &wsGUI)
	static initItems(&animalObj, &wsGUI)
	{
		G2 := {}
		G2 := Gui('+Owner' wsGUI.hwnd), G2.Opt("+Resize +MinSize850x550 -DPIScale")
		G2.OnEvent("Size", GuiReSizer)
		wsGUI.Opt("+Disabled")
		organOptions(animalObj.species, &G2)
		G2.Show()
		G2.Maximize()
		darkmode(G2)
		organOptions.finished := false
		while organOptions.finished = false
			Sleep 100
		wsGUI.Opt("-Disabled")
		G2.Destroy()
		return animalObj.organs['json'] := organOptions.organAssignment
	}
	/*
	 * @static
	 * @method Call
	 * @description Calls the organ options.
	 * @param {object} G - The object containing organ options.
	 * @param {object} animalObj - The animal object containing organ information.
	 * @param {boolean} [wait=True] - Indicates whether to wait for the organ options to finish.
	*/
	static Call(species := "Cow", &G2?)
	{
		organOptions.species := species
		G2.SetFont('s18 c7aff58', "Arial")
		organOptions.GB := G2.Add("GroupBox", "", "Organs to Keep/Reject/Not Requested")
		G2.SetFont('s34 cfcff97', "Arial")
		y := 0.01, y2 := 0.01
		organOptions.DDL := Map()
		G2.SetFont('s35')
		indx := 0
		organOptions.OrgansDDL := Map()
		organOptions.OrgansText := Map()

		if (organOptions.organMap[species].Length > 6)
			organOptions.pagination.MULTIPLE := true
		else
			organOptions.pagination.MULTIPLE := false
		for organ in organOptions.organMap[species]
		{
			indx := A_Index
			if organOptions.pagination.MULTIPLE && A_Index > 6
			{
				organOptions.OrgansDDL[organ] := G2.Add("DDL", "Choose1", ['Accept', 'Reject', 'Not Requested'])
				organOptions.OrgansText[organ] := G2.Add("Text", "", organ)
				pushToResizer(organOptions.OrgansDDL[organ], 0.525, y2 += 0.11, 0.425, 0.092)
				pushToResizer(organOptions.OrgansText[organ], 0.025, y2, 0.425, 0.11)
				organOptions.OrgansText[organ].Visible := 0
				organOptions.OrgansDDL[organ].Visible := 0
			}
			else
			{
				organOptions.OrgansDDL[organ] := (G2.Add("DDL", "Choose1", ['Accept', 'Reject', 'Not Requested']))
				organOptions.OrgansText[organ] := G2.Add("Text", "", organ)
				pushToResizer(organOptions.OrgansDDL[organ], 0.525, y += 0.11, 0.425, 0.092)
				pushToResizer(organOptions.OrgansText[organ], 0.025, y, 0.425, 0.11)
			}
		}
		pushToResizer(organOptions.GB, 0.012, 0.02, 0.944, y += 0.15)
		if organOptions.pagination.MULTIPLE
		{
			organOptions.Next := G2.Add("Button", "", "Next")
			organOptions.Next.OnEvent('Click', pageChange)
			pushToResizer(organOptions.Next, 0.1, 0.8, 0.3, 0.1)
		}

		organOptions.FinishedButton := G2.Add("Button", "", "Finished")
		organOptions.FinishedButton.OnEvent('Click', finished_click)
		pushToResizer(organOptions.FinishedButton, 0.4, 0.8, 0.3, 0.1)
		pageChange(*)
		{
			if organOptions.pagination.CURRENT = 1
			{
				page1 := 0 ; notvisible
				page2 := 1 ; notvisible
				organOptions.Next.Text := "Back"
				organOptions.pagination.CURRENT := 2
			}
			else
			{
				page1 := 1 ; notvisible
				page2 := 0 ; notvisible
				organOptions.Next.Text := "Next"
				organOptions.pagination.CURRENT := 1
			}
			for organ in organOptions.organMap[organOptions.species]
			{
				if A_Index > 6
					organOptions.OrgansDDL[organ].Visible := page2,
						organOptions.OrgansText[organ].Visible := page2
				else if A_Index <= 6
					organOptions.OrgansDDL[organ].Visible := page1,
						organOptions.OrgansText[organ].Visible := page1
			}
		}
		finished_click(ctrlobj, *)
		{
			organMap := Map()
			for organ, ctrl in ctrlobj.gui
			{
				if ctrl.base.__Class = "Gui.Text"
					organMap[ctrl.Text] := organOptions.OrgansDDL[ctrl.Text].Text
			}
			organOptions.organAssignment := organMap
			organMap := ""
			organOptions.finished := true
		}
		pushToResizer(ctrl, xp, yp, wp, hp)
		{
			ctrl.xp := Round(xp, 3)
			ctrl.yp := Round(yp, 3)
			ctrl.wp := Round(wp, 3)
			ctrl.hp := Round(hp, 3)
		}
	}
}