#Requires Autohotkey v2
#SingleInstance Force
#Include <darkmode> 
#Include <request2>

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Gui(), myGui.Opt("+Resize +MinSize850x550")
	myGui.Show("w1280 h720")
}
/**
 * @static
 * @method Call
 * @param {object} G - The G object.
 * @param {object} animalObj - The animal object.
 * @param {boolean} [wait=True] - Indicates whether to wait for the animal options to finish.
 * @returns {object} The updated animal object.
 * @description Calls the animal options and injects the gender into the animal object.
 */
class genderOptions
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
		; genderWeight.genders['Cows'] := ['Steer', 'Heffer', 'Bull']
	)
	static genderCtrls := []
	/**
	 * @static
	 * @method Call
	 * @param {object} G - The G object.
	 * @param {object} animalObj - The animal object.
	 * @param {boolean} [wait=True] - Indicates whether to wait for the animal options to finish.
	 * @returns {object} The updated animal object.
	 * @description Calls the animal options and injects the gender into the animal object.
	 */
	static Call(&G, &animalObj, wait := True)
	{
		genderOptions.hwnd := G.hwnd
		genderOptions.animalObj := animalObj
		genderOptions.finished := false
		if G.HasOwnProp('genderWeight')
			genderOptions.reloadChild(&G, animalObj.species)
		else
			genderOptions.initGenderGui(&G)
		genderOptions.addGenderSpecificControls(&animalObj)
		if wait
		{
			while !genderOptions.finished
				Sleep 100
		}
		animalObj := genderOptions.animalObj
	}

	static initGenderGui(&G)
	{
		G.ToggleVisible(0)
		G.genderWeight := {}, G.genderWeight.main := {}
		G.SetFont('s55')

		G.genderWeight.main.gender1 := G.Add("Button", "", "&Gender1") ; .BackColor('0xa0dfff')
		pushToResizer(G.genderWeight.main.gender1, 0.03, 0.03, 0.43, 0.27)
		G.genderWeight.main.gender2 := G.Add("Button", "", "&Gender2") ; .BackColor('0xa0ffd3')
		pushToResizer(G.genderWeight.main.gender2, 0.03, 0.35, 0.43, 0.27)
		G.genderWeight.main.gender3 := G.Add("Button", "", "&Gender3") ; .BackColor('0xffa0a0')
		pushToResizer(G.genderWeight.main.gender3, 0.03, 0.67, 0.43, 0.27)

		G.genderWeight.main.comments := G.Add("Button", "", "Comments") ; .BackColor('0xa0dfff')
		pushToResizer(G.genderWeight.main.comments, 0.49, 0.03, 0.43, 0.10)
		G.genderWeight.main.comments.OnEvent("Click", comments_click)
		G.genderWeight.main.Gender := G.Add("Edit", "", "Gender")
		G.genderWeight.main.Gender.SetFont("s42")
		G.genderWeight.main.Gender.Default := "Gender"
		pushToResizer(G.genderWeight.main.Gender, 0.49, 0.49, 0.39, 0.11)

		G.genderWeight.main.Submit := G.Add("Button", "", "&OK").OnEvent("Click", submit_click)
		pushToResizer(G.genderWeight.main.Submit, 0.49, 0.67, 0.39, 0.27)
		
		CowCtrls(&G, 0.49, 0.05, 0.39, 0.17)

		if genderOptions.animalObj.species = "Cow"
			G.genderWeight.Cow.ToggleVisible(1)
		else
			G.genderWeight.Cow.ToggleVisible(0)
		genderOptions.genderCtrls := [G.genderWeight.main.gender1,
			G.genderWeight.main.gender2, G.genderWeight.main.gender3]
		for c in genderOptions.genderCtrls
			genderOptions.genderCtrls[A_Index].OnEvent("Click", ctrl_to_edit)
		
		darkmode(G), GuiResizer.Now(G)
		pushToResizer(ctrl, xp, yp, wp, hp)
		{
			ctrl.xp := xp
			ctrl.yp := yp
			ctrl.wp := wp
			ctrl.hp := hp
		}
		comments_click(*){
			CommentHandler()
		}
		ctrl_to_edit(ctrl, *) => (G.genderWeight.main.Gender.value := ctrl.Text)
		submit_click(*)
		{
			G := GuiFromHwnd(genderOptions.hwnd)
			if G.genderWeight.main.Gender.Value = G.genderWeight.main.Gender.Default || G.genderWeight.main.Gender.Value = ''
			{
				MsgBox('Please select Gender')
				return
			}
			else if genderOptions.animalObj.species = "Cow"
			{
				validationDic := validateCow()
				if validationDic['code'] = false
				{
					Msgbox('Error, please fill out....' validationDic['ctrl'])
					return
				}
				genderOptions.animalObj.TEID := CowCtrls.controls['TEID'].Value
				genderOptions.animalObj.manual_weight := CowCtrls.controls['manualWeight'].Value
				genderOptions.animalObj.Gender := G.genderWeight.main.Gender.Value
				genderOptions.animalObj.is_over_30_months := CowCtrls.controls['30mo'].value
			}
			else if genderOptions.animalObj.species = "Pig"
			{
				genderOptions.animalObj.Gender := G.genderWeight.main.Gender.Value
			}
			genderOptions.finished := true
			MsgBox("Success!")

			validateCow()
			{
				CC := CowCtrls.controls
				for key, ctrl in CC
				{
					try if ctrl.Value = ctrl.Default || ctrl.Value = ''
						return x := Map('code', false, 'ctrl', ctrl.Default)
					catch as e
					{
						if ctrl.Value = ''
							return x := Map('code', false, 'ctrl', ctrl.Default)
					}
				}
				return x := Map('code', true)
			}
		}
	}

	static addGenderSpecificControls(&animalObj)
	{
		for ctrl in genderOptions.genderCtrls
		{
			info := genderOptions.genderMap[animalObj.species]
			val := info[A_Index]
			ctrl.Text := val
		}

	}

	static reloadChild(&G, species)
	{
		G.ToggleVisible(0), G.genderWeight.main.ToggleVisible(1)
		if species = "Cow"
		{
			if G.genderWeight.HasOwnProp('Cow')
				G.genderWeight.Cow.ToggleVisible(1)
			else
				CowCtrls(&G, 0.49, 0.05, 0.39, 0.17)
			teid := genderOptions.grabTEID()
			G.genderWeight.Cow.manualWeight.Value := "Manual Weight"
			G.genderWeight.Cow.TEID.Value := (teid) is Map ? 'TEID:' teid['TEID'] : 'TEID:' TEID
		}
		for c in genderOptions.genderCtrls
			c.Text := genderOptions.genderMap[species][A_Index]
	}

	static grabTEID() => requests2.geturl('animals/teid/')
	; has default property, check then clear if equals
	static ClickClearField(ctrl, *)
	{
		if this.HasOwnProp('Default') && this.Value = this.Default
			this.Value := ''
		else if this.Value = ''
			this.Value := this.Default
	}

	static typeFocus(ctrl, *)
	{
		if IsInteger(this)
			return
		this.OnEvent("LoseFocus", genderOptions.lostFocus, 0)
		this.Value := (this.Value = this.Default) ? '' : this.Value
		if !genderOptions.onScreenNumActive or Numpad.winActive = False
		{
			genderOptions.onScreenNumActive := True
			genderOptions.Num := Numpad(genderOptions.numpad_hwnds), genderOptions.Num.Show()
			Sleep(100)
		}
		this.OnEvent("LoseFocus", genderOptions.lostFocus)
	}

	static lostFocus(ctrl, *)
	{
		static lastCTRL := {}
		static lastCTRLValue := ''
		if lastCTRL = ctrl
			return
		else
			ctrl := lastCTRL
		if this.Value = ''
			this.Default
		else if this.Value = this.Default
			this.Value := ''
	}

	static checkUncheck(ctrl, *)
	{
		if ctrl.Value
			ctrl.SetFont(" cGreen", "")
		else
			ctrl.SetFont(" cWhite", "")
		ctrl.Redraw()
	}
}


/**
 * @class CowCtrls
 * @classdesc Represents a class that handles the cow controls in the animal options.
 */
class CowCtrls
{
	/**
	 * @static
	 * @property {Object} numpadObj - The numpad object.
	 */
	static numpadObj := {}

	/**
	 * @static
	 * @property {Map} controls - A map of control objects.
	 */
	static controls := Map()

	/**
	 * @static
	 * @function Call
	 * @memberof CowCtrls
	 * @description Adds and configures the cow controls in the animal options.
	 * @param {Object} G - The main GUI object.
	 * @param {number} x - The x-coordinate of the controls.
	 * @param {number} y - The y-coordinate of the controls.
	 * @param {number} w - The width of the controls.
	 * @param {number} h - The height of the controls.
	 */
	static Call(&G, x, y, w, h)
	{
		G.genderWeight.Cow := {}

		G.genderWeight.Cow.is_over_30_months := G.Add("DDL", "Choose1", ["OVER 30 MO OLD", "UNDER 30 MO OLD"])
		G.genderWeight.Cow.is_over_30_months.SetFont("s32")
		pushToResizer(G.genderWeight.Cow.is_over_30_months, x, y += 0.1, w, h - 0.1)
		CowCtrls.controls['30mo'] := G.genderWeight.Cow.is_over_30_months

		G.genderWeight.Cow.manualWeight := G.Add("Edit", "", "Manual Weight")
		G.genderWeight.Cow.manualWeight.SetFont("s32 cGreen", "")
		G.genderWeight.Cow.manualWeight.Default := "Manual Weight"
		CowCtrls.controls['manualWeight'] := G.genderWeight.Cow.manualWeight

		G.genderWeight.Cow.editWeight := G.Add('Button', "", "Edit")
		G.genderWeight.Cow.editWeight.SetFont("s32 cGreen", "")
		G.genderWeight.Cow.editWeight.OnEvent("Click", CowCtrls.launchNumpad.Bind(G.genderWeight.Cow.manualWeight))
		pushToResizer(G.genderWeight.Cow.editWeight, x, y += 0.1, 0.08, h - 0.1)
		pushToResizer(G.genderWeight.Cow.manualWeight, x + 0.08, y, w - 0.08, h - 0.1)

		teid := genderOptions.grabTEID()
		G.genderWeight.Cow.TEID := G.Add("Edit", "",
			(teid) is Map ? 'TEID:' teid['TEID'] : 'TEID:' TEID)
		G.genderWeight.Cow.TEID.Default := "Ear Tag Numb"
		G.genderWeight.Cow.TEID.Enabled := false
		G.genderWeight.Cow.TEID.SetFont("s32 cd6fd26", "")
		genderOptions.numpad_hwnds := G.genderWeight.Cow.TEID.hwnd
		CowCtrls.controls['TEID'] := G.genderWeight.Cow.TEID
		pushToResizer(G.genderWeight.Cow.TEID, x, y += 0.1, w, 0.1)
	}

	/**
	 * @static
	 * @function launchNumpad
	 * @memberof CowCtrls
	 * @description Launches the numpad control.
	 * @param {Object} ctrl - The control object.
	 */
	static launchNumpad(ctrl?, *)
	{
		if !this
			return
		if Numpad.winActive = False || !WinExist('ahk_id' Numpad.hwnd)
		{
			CowCtrls.numpadObj := Numpad(this.hwnd), CowCtrls.numpadObj.show(),
				controlShowing := true, this.value := this.default = this.value ? "" : this.value
		}
		Sleep(100)
	}

	/**
	 * @static
	 * @function numpadDestroy
	 * @memberof CowCtrls
	 * @description Destroys the numpad control.
	 */
	static numpadDestroy(*)
	{
		if Numpad.winActive = True
			CowCtrls.numpadObj.Destroy()
	}
}