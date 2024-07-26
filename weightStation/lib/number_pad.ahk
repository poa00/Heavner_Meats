#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>




/**
 * @file number_pad_converted_compiled.ahk
 * @class Numpad
 * @classdesc Represents a number pad GUI for inputting numbers.
 */
Class Numpad
{
	static hwnd := 0
	static lastWindow := 0
	static ctrl_hwnd := 0
	static winActive := False
	/**
	 * @constructor
	 * @memberof Numpad
	 * @param {number} target_ctrl_hwnd - The target control hwnd.
	 * @description Creates an instance of the Numpad class.
	 */
	__New(target_ctrl_hwnd)
	{
		if Numpad.checkActive()
			return
		local storage := Numpad.Build()
		this.controls := Map(), this.Gui := Map()
		this.controls := storage['controls']
		Numpad.winActive := false
		this.Gui := storage['gui']
		Numpad.hwnd := this.Gui.hwnd
		this.lastWindow := 0
		Numpad.ctrl_hwnd := target_ctrl_hwnd
		storage := ""
		this.assignEvents(this.controls)
	}
	static checkActive()
	{
		if WinExist('ahk_id ' Numpad.hwnd)
			return True
		return False
	}
	show()
	{
		Numpad.winActive := True
		this.gui.Show('w450 h550 x200 y200')
		try this.darkmode(this.gui)
		WinActivate("ahk_id" GuiCtrlFromHwnd(Numpad.ctrl_hwnd).Gui.Hwnd)
		return this
	}
	destroy()
	{
		Numpad.winActive := False
		this.Gui.OnEvent("Size", GuiReSizer, 0)
		this.Gui.Destroy()
	}
	static destroyer(*)
	{
		G := GuiFromHwnd(Numpad.hwnd)
		Numpad.winActive := False
		G.OnEvent("Size", GuiReSizer, 0)
		Sleep 100
		G.Destroy()
	}
	/**
	 * Builds the number pad GUI.
	 * @static
	 * @memberof Numpad
	 * @returns {Object} The storage object containing the GUI and controls.
	 */
	static Build()
	{
		myCtrls := {}
		myGui := Gui(), myGui.Opt("+Resize +MinSize250x150 +AlwaysOnTop +E0x8000000")
		myGui.OnEvent("Size", GuiReSizer)
		controls := Map(), storage := Map()
		myGui.SetFont('s20 cWhite', "Arial")
		x := {}
		x := myGui.Add("Button", "", "1")
		controls[x.hwnd] := "1"
		pushToResizer(x, 0.045, 0.039, 0.264, 0.181)
		x := myGui.Add("Button", "", "2")
		controls[x.hwnd] := "2"
		pushToResizer(x, 0.364, 0.039, 0.264, 0.181)
		x := myGui.Add("Button", "", "3")
		controls[x.hwnd] := "3"
		pushToResizer(x, 0.659, 0.039, 0.264, 0.181)
		x := myGui.Add("Button", "", "4")
		controls[x.hwnd] := "4"
		pushToResizer(x, 0.045, 0.237, 0.264, 0.181)
		x := myGui.Add("Button", "", "5")
		controls[x.hwnd] := "5"
		pushToResizer(x, 0.364, 0.237, 0.264, 0.181)
		x := myGui.Add("Button", "", "6")
		controls[x.hwnd] := "6"
		pushToResizer(x, 0.668, 0.237, 0.264, 0.181)
		x := myGui.Add("Button", "", "7")
		controls[x.hwnd] := "7"
		pushToResizer(x, 0.045, 0.435, 0.264, 0.181)
		x := myGui.Add("Button", "", "8")
		controls[x.hwnd] := "8"
		pushToResizer(x, 0.364, 0.435, 0.264, 0.181)
		x := myGui.Add("Button", "", "9")
		controls[x.hwnd] := "9"
		pushToResizer(x, 0.665, 0.435, 0.264, 0.181)
		x := myGui.Add("Button", "", "Remove")
		controls[x.hwnd] := "{LCtrl Down}A{LCtrl Up}{Backspace}"
		pushToResizer(x, 0.045, 0.673, 0.264, 0.171)
		x := myGui.Add("Button", "", "0")
		controls[x.hwnd] := "0"
		pushToResizer(x, 0.364, 0.673, 0.264, 0.171)
		
		x := myGui.Add("Button", "", "(.)")
		controls[x.hwnd] := "."
		pushToResizer(x, 0.665, 0.673, 0.264, 0.171)
		
		x := myGui.Add("Button", "", "Finished")
		controls['Submit'] := x
		controls['Submit'].OnEvent('Click', Numpad.destroyer)
		pushToResizer(x, 0.045, 0.873, 0.884, 0.121)
		Numpad.hwnd := myGui.hwnd
		local storage := Map()
		storage['gui'] := myGui
		storage['controls'] := controls
		pushToResizer(ctrl, xp, yp, wp, hp)
		{
			ctrl.xp := xp
			ctrl.yp := yp
			ctrl.wp := wp
			ctrl.hp := hp
		}
		return storage
	}

	mcColorFunc()
	{
		return mcColors := {
			MCSC_BACKGROUND: 0,
			MCSC_TEXT: 1,
			MCSC_TITLEBK: 2,
			MCSC_TITLETEXT: 3,
			MCSC_MONTHBK: 4,
			MCSC_TRAILINGTEXT: 5
		}
	}
	GetFont(options, fontName)
	{
		myGUI := Gui()
		myGUI.SetFont(options, fontName)
		hFont := SendMessage(WM_GETFONT := 0x31, , , myGUI.AddText())
		myGUI.Destroy()
		return hFont
	}
	

	darkmode(myGUI, color?)
	{
		color := "191919"
		myGUI.BackColor := IsSet(color) ? color : darkMode.color
		if (VerCompare(A_OSVersion, "10.0.17763") >= 0)
		{
			DWMWA_USE_IMMERSIVE_DARK_MODE := 19
			if (VerCompare(A_OSVersion, "10.0.18985") >= 0)
			{
				DWMWA_USE_IMMERSIVE_DARK_MODE := 20
			}
			DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", myGUI.hWnd, "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", true, "Int", 4)
			; listView => SetExplorerTheme(LV1.hWnd, "DarkMode_Explorer"), SetExplorerTheme(LV2.hWnd, "DarkMode_Explorer")
			uxtheme := DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr")
			DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr"), "Int", 2) ; ForceDark
			DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr"))
		}
		for ctrlHWND, ctrl in myGUI
		{
			if ctrl.HasProp("NoBack")
				continue
			blackGuiCtrl(myGUI[ctrlHWND])
		}
		blackGuiCtrl(params*)
		{
			if params[1].gui.backcolor
			{
				bg := params[1].gui.backcolor
			} else {
				bg := "12121a"
			}
			for ctrl in params
			{
				try
				{
					ctrl.Opt("Background" bg)
				} catch as e {
					continue
				}
				try
				{
					ctrl.SetFont("cWhite")
				} catch as e {
					continue
				}
			}
		}
	}
	assignEvents(controls)
	{
		for ctrl_hwnd, key in controls
		{
			if ctrl_hwnd != "Submit"
			{
					
				ctrl := GuiCtrlFromHwnd(ctrl_hwnd)
				ctrl.OnEvent("Click", numpad.HandleSend.Bind(ctrl_hwnd, key))
				
			}
		}
	}
	static HandleSend(key, ctrl, *)
	{
		ControlSend(
			key, , "ahk_id" Numpad.ctrl_hwnd ;implement shift case activation here
		)
	}
	static lowerCase(Haystack)
	{
		NeedleRegEx := "[A-Z]" ; Regular expression to find a single uppercase letter.
		Replacement := "$l0" ; Replacement pattern to change the matching uppercase letter to lowercase.
		; Call the RegExReplace function with the provided parameters.
		NewStr := RegExReplace(Haystack, NeedleRegEx, Replacement, &OutputVarCount, 1) ; Limit is set to 1 to replace the first occurrence only.
		; Display the original and modified strings.
		return NewStr
	}
}


enum()
{
	try active := WinExist("A")
	if !(IsSet(active))
		return
	if Numpad.hwnd != active
		Numpad.lastWindow := active
}

class _GuiResizer extends GuiReSizer
{
	static resizeCalltime := 0
	static Call(guiobj, params*)
	{
		_GuiResizer.resizeCalltime := A_TickCount
		GuiReSizer.Call(guiobj, params*)
		gu := _GuiResizer.redraw.Bind(guiobj)
		SetTimer gu, -400
	}
	static redraw(guiobj?)
	{
		if _GuiResizer.resizeCalltime + 400 < A_TickCount
			for k, ctrl in this
			{
				try ctrl.redraw()
			}
	}
}