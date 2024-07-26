#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>
#Include <WinAPI\Gdi32>
SetTitleMatchMode 2
#Include <darkmode>

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	K := Keyboard()
}


class Keyboard
{
	static hwnd := 0
	static lastWindow := 0
	static edit_hwnd := 0
	static edit_value := ""
	static active := false
	
	__New(ctrl_hwnd := 0, comms := "")
	{
		Keyboard.Active := true
		local storage := this.Build(ctrl_hwnd, comms)
		this.controls := Map(), this.Gui := Map()
		this.controls := storage['controls']
		this.Gui := storage['gui']
		this.lastWindow := 0
		SetTimer(() => Keyboard.enum, 40)
		storage := ""
	}
	
	_Kill() => (Keyboard.active := False, this.Gui.Destroy())
	_UpdateField(Text) => ((GuiCtrlFromHwnd(Keyboard.edit_hwnd).Value := Text), (Keyboard.edit_value := Text))
	
	Build(hwnd := 0, comments := "")
	{
		myCtrls := {}
		myGui := Gui('-DPIScale'), myGui.Opt("+Resize +MinSize250x150 +AlwaysOnTop +E0x8000000")
		myGui.OnEvent("Size", GuiResizer_)
		controls := Map()
		x := {}
		W := SysGet(78)
		H := SysGet(79)
		myCtrls := {}
		myGui.SetFont('s22')
		myCtrls.ButtonEsc := myGui.Add("Button", "", "Esc")
		controls[myCtrls.ButtonEsc.hwnd] := "{Esc}"
		pushToResizer(myCtrls.ButtonEsc, 0.010, 0.042, 0.050, 0.146)
		myCtrls.ButtonEsc.OnEvent("Click", (*) => this._Kill())
		myCtrls.edit := myGui.Add("Edit", "", "")
		myCtrls.edit.OnEvent("Change", (*) => (Keyboard.edit_value := myCtrls.edit.Value))
		myCtrls.edit.Value := comments
		Keyboard.edit_hwnd := (hwnd = 0) ? myCtrls.edit.hwnd : hwnd
		pushToResizer(myCtrls.edit, 0.060, 0.042, 0.90, 0.146)

		myCtrls.Button := myGui.Add("Button", "", "~")
		myCtrls.Button.Send := "{~}"
		pushToResizer(myCtrls.Button, 0.010, 0.221, 0.050, 0.126)
		myCtrls.Button2 := myGui.Add("Button", "", "! 1")
		myCtrls.Button2.Send := "1"
		pushToResizer(myCtrls.Button2, 0.075, 0.221, 0.050, 0.126)
		myCtrls.Button2 := myGui.Add("Button", "", "@ 2")
		myCtrls.Button2.Send := "2"
		pushToResizer(myCtrls.Button2, 0.125, 0.221, 0.050, 0.126)
		myCtrls.Button3 := myGui.Add("Button", "", "# 3")
		myCtrls.Button3.Send := "3"
		pushToResizer(myCtrls.Button3, 0.178, 0.221, 0.050, 0.126)
		myCtrls.Button4 := myGui.Add("Button", "", "$ 4")
		myCtrls.Button4.Send := "4"
		pushToResizer(myCtrls.Button4, 0.231, 0.221, 0.050, 0.126)
		myCtrls.Button5 := myGui.Add("Button", "", "`"")
		myCtrls.Button5.Send := "5"
		pushToResizer(myCtrls.Button5, 0.284, 0.221, 0.050, 0.126)
		myCtrls.Button6 := myGui.Add("Button", "", "^ 6")
		myCtrls.Button6.Send := "6"
		pushToResizer(myCtrls.Button6, 0.338, 0.221, 0.050, 0.126)
		myCtrls.Button7 := myGui.Add("Button", "", "& 7")
		myCtrls.Button7.Send := "7"
		pushToResizer(myCtrls.Button7, 0.390, 0.221, 0.050, 0.126)
		myCtrls.Button8 := myGui.Add("Button", "", "* 8")
		myCtrls.Button8.Send := "8"
		pushToResizer(myCtrls.Button8, 0.443, 0.221, 0.050, 0.126)
		myCtrls.Button9 := myGui.Add("Button", "", "( 9")
		myCtrls.Button9.Send := "9"
		pushToResizer(myCtrls.Button9, 0.492, 0.221, 0.050, 0.126)
		myCtrls.Button0 := myGui.Add("Button", "", ") 0")
		myCtrls.Button0.Send := "0"
		pushToResizer(myCtrls.Button0, 0.543, 0.221, 0.050, 0.126)
		myCtrls.Button1 := myGui.Add("Button", "", "_ -")
		myCtrls.Button1.Send := "{_ -}"
		pushToResizer(myCtrls.Button1, 0.624, 0.224, 0.085, 0.126)
		myCtrls.Button := myGui.Add("Button", "", "+ =")
		myCtrls.Button.Send := "{+ =}"
		pushToResizer(myCtrls.Button, 0.719, 0.224, 0.099, 0.126)
		myCtrls.ButtonBackspace := myGui.Add("Button", "", "Backspace")
		myCtrls.ButtonBackspace.Send := "{Backspace}"
		pushToResizer(myCtrls.ButtonBackspace, 0.830, 0.224, 0.140, 0.180)
		myCtrls.ctrl31 := myGui.Add("Button", "", "Q")
		myCtrls.ctrl31.Send := "Q"
		pushToResizer(myCtrls.ctrl31, 0.009, 0.364, 0.074, 0.126)
		myCtrls.ctrl32 := myGui.Add("Button", "", "W")
		myCtrls.ctrl32.Send := "W"
		pushToResizer(myCtrls.ctrl32, 0.097, 0.364, 0.068, 0.126)
		myCtrls.ctrl33 := myGui.Add("Button", "", "E")
		myCtrls.ctrl33.Send := "E"
		pushToResizer(myCtrls.ctrl33, 0.168, 0.364, 0.060, 0.126)
		myCtrls.ctrl34 := myGui.Add("Button", "", "R")
		myCtrls.ctrl34.Send := "R"
		pushToResizer(myCtrls.ctrl34, 0.234, 0.364, 0.072, 0.126)
		myCtrls.ctrl35 := myGui.Add("Button", "", "T")
		myCtrls.ctrl35.Send := "T"
		pushToResizer(myCtrls.ctrl35, 0.309, 0.364, 0.068, 0.126)
		myCtrls.ctrl36 := myGui.Add("Button", "", "Y")
		myCtrls.ctrl36.Send := "Y"
		pushToResizer(myCtrls.ctrl36, 0.389, 0.364, 0.083, 0.126)
		myCtrls.ctrl37 := myGui.Add("Button", "", "U")
		myCtrls.ctrl37.Send := "U"
		pushToResizer(myCtrls.ctrl37, 0.477, 0.364, 0.072, 0.126)
		myCtrls.ctrl38 := myGui.Add("Button", "", "I")
		myCtrls.ctrl38.Send := "I"
		pushToResizer(myCtrls.ctrl38, 0.556, 0.364, 0.073, 0.126)
		myCtrls.ctrl39 := myGui.Add("Button", "", "O")
		myCtrls.ctrl39.Send := "O"
		pushToResizer(myCtrls.ctrl39, 0.636, 0.364, 0.077, 0.126)
		myCtrls.ctrl40 := myGui.Add("Button", "", "P")
		myCtrls.ctrl40.Send := "P"
		pushToResizer(myCtrls.ctrl40, 0.724, 0.364, 0.087, 0.126)
		myCtrls.ButtonCapsLock := myGui.Add("Button", "", "CapsLock")
		myCtrls.ButtonCapsLock.Send := "CapsLock"
		pushToResizer(myCtrls.ButtonCapsLock, 0.645, 0.644, 0.177, 0.126)
		myCtrls.ctrl42 := myGui.Add("Button", "", "A")
		myCtrls.ctrl42.Send := "A"
		pushToResizer(myCtrls.ctrl42, 0.009, 0.504, 0.079, 0.126)
		myCtrls.ctrl43 := myGui.Add("Button", "", "S")
		myCtrls.ctrl43.Send := "S"
		pushToResizer(myCtrls.ctrl43, 0.106, 0.504, 0.102, 0.126)
		myCtrls.ctrl44 := myGui.Add("Button", "", "D")
		myCtrls.ctrl44.Send := "D"
		pushToResizer(myCtrls.ctrl44, 0.215, 0.504, 0.079, 0.126)
		myCtrls.ctrl45 := myGui.Add("Button", "", "F")
		myCtrls.ctrl45.Send := "F"
		pushToResizer(myCtrls.ctrl45, 0.3, 0.504, 0.079, 0.126)
		myCtrls.ctrl46 := myGui.Add("Button", "", "G")
		myCtrls.ctrl46.Send := "G"
		pushToResizer(myCtrls.ctrl46, 0.395, 0.504, 0.070, 0.126)
		myCtrls.ctrl47 := myGui.Add("Button", "", "H")
		myCtrls.ctrl47.Send := "H"
		pushToResizer(myCtrls.ctrl47, 0.475, 0.504, 0.070, 0.126)
		myCtrls.ButtonJ := myGui.Add("Button", "", "J")
		myCtrls.ButtonJ.Send := "J"
		pushToResizer(myCtrls.ButtonJ, 0.551, 0.504, 0.081, 0.126)
		myCtrls.ctrl49 := myGui.Add("Button", "", "K")
		myCtrls.ctrl49.Send := "K"
		pushToResizer(myCtrls.ctrl49, 0.638, 0.504, 0.083, 0.126)
		myCtrls.ctrl50 := myGui.Add("Button", "", "L")
		myCtrls.ctrl50.Send := "L"
		pushToResizer(myCtrls.ctrl50, 0.725, 0.504, 0.084, 0.126)
		myCtrls.ButtonEnter := myGui.Add("Button", "", "Enter")
		myCtrls.ButtonEnter.Send := "`n"
		pushToResizer(myCtrls.ButtonEnter, 0.830, 0.434, 0.138, 0.210)
		Esc := myGui.Add("Button", "", "Esc")
		pushToResizer(Esc, 0.019, 0.644, 0.084, 0.126)
		Esc.OnEvent("Click", (*) => this._Kill())
		myCtrls.ButtonZ := myGui.Add("Button", "", "Z")
		myCtrls.ButtonZ.Send := "Z"
		pushToResizer(myCtrls.ButtonZ, 0.110, 0.644, 0.092, 0.126)
		myCtrls.ctrl54 := myGui.Add("Button", "", "C")
		myCtrls.ctrl54.Send := "C"
		pushToResizer(myCtrls.ctrl54, 0.212, 0.644, 0.076, 0.126)
		myCtrls.ctrl55 := myGui.Add("Button", "", "V")
		myCtrls.ctrl55.Send := "V"
		pushToResizer(myCtrls.ctrl55, 0.294, 0.644, 0.083, 0.126)
		myCtrls.ctrl56 := myGui.Add("Button", "", "B")
		myCtrls.ctrl56.Send := "B"
		pushToResizer(myCtrls.ctrl56, 0.380, 0.644, 0.077, 0.126)
		myCtrls.ctrl57 := myGui.Add("Button", "", "N")
		myCtrls.ctrl57.Send := "N"
		pushToResizer(myCtrls.ctrl57, 0.459, 0.644, 0.085, 0.126)
		myCtrls.ctrl58 := myGui.Add("Button", "", "M")
		myCtrls.ctrl58.Send := "M"
		pushToResizer(myCtrls.ctrl58, 0.555, 0.644, 0.077, 0.126)

		myCtrls.Close := myGui.Add("Button", "", "Close")
		; myCtrls.edit.OnEvent('Click', (this._UpdateField(), this._Kill()))
		
		myGui.OnEvent('Close', (*) => this._Kill())
		; pushToResizer(myCtrls.edit, 0.830, 0.658, 0.138, 0.259)
		myCtrls.ButtonCtrl := myGui.Add("Button", "", "Ctrl")
		myCtrls.ButtonCtrl.Send := "{Ctrl}"
		pushToResizer(myCtrls.ButtonCtrl, 0.010, 0.799, 0.070, 0.126)
		myCtrls.ButtonWin := myGui.Add("Button", "", "Win")
		myCtrls.ButtonWin.Send := "{Win}"
		pushToResizer(myCtrls.ButtonWin, 0.089, 0.799, 0.070, 0.126)
		myCtrls.ButtonAlt := myGui.Add("Button", "", "Alt")
		myCtrls.ButtonAlt.Send := "{Alt}"
		pushToResizer(myCtrls.ButtonAlt, 0.169, 0.799, 0.070, 0.126)
		myCtrls.ctrl63 := myGui.Add("Button", "", " ")
		myCtrls.ctrl63.Send := " "
		pushToResizer(myCtrls.ctrl63, 0.248, 0.799, 0.248, 0.126)
		myCtrls.ButtonAlt := myGui.Add("Button", "", "Alt")
		myCtrls.ButtonAlt.Send := "{Alt}"
		pushToResizer(myCtrls.ButtonAlt, 0.507, 0.799, 0.070, 0.126)
		myCtrls.ButtonWin := myGui.Add("Button", "", "Win")
		myCtrls.ButtonWin.Send := "{Win}"
		pushToResizer(myCtrls.ButtonWin, 0.586, 0.799, 0.070, 0.126)
		myCtrls.ButtonMenu := myGui.Add("Button", "", "Menu")
		myCtrls.ButtonMenu.Send := "{Menu}"
		pushToResizer(myCtrls.ButtonMenu, 0.666, 0.799, 0.070, 0.126)
		myCtrls.ButtonCtrl := myGui.Add("Button", "", "Ctrl")
		myCtrls.ButtonCtrl.Send := "{Ctrl}"
		pushToResizer(myCtrls.ButtonCtrl, 0.745, 0.799, 0.070, 0.126)

		Send "{LAlt Down}{Tab}{LAlt Up}"
		Keyboard.hwnd := myGui.hwnd
		local storage := Map()
		storage['gui'] := myGui
		storage['controls'] := myCtrls
		if (hwnd = 0)
			assignEvents(myGui)
		; for non comments remove above functions
		myGui.Show("w" A_ScreenWidth " h" A_ScreenHeight / 3 * 2 " x0 y" A_ScreenHeight / 4)
		darkmode(myGui)
		pushToResizer(ctrl, xp, yp, wp, hp)
		{
			ctrl.xp := xp
			ctrl.yp := yp
			ctrl.wp := wp
			ctrl.hp := hp
		}
		assignEvents(G)
		{
			for key, ctrl in G
			{
				if ctrl.HasProp('Send')
				{
					ctrl.OnEvent("Click", HandleSend)
				}
			}
			HandleSend(ctrl, G)
			{
				if not InStr("{", ctrl.Send)
				{
					Edit1 := GuiCtrlFromHwnd(Keyboard.edit_hwnd)
					edit1.value := edit1.value . ctrl.Send
					Keyboard.edit_value := edit1.value
				} else 
				{
					Send ctrl.Send
				}
			}
		}

		return storage
	}

	static enum()
	{
		try active := WinExist("A")
		if !(IsSet(active))
			return
		if keyboard.hwnd != active
			Keyboard.lastWindow := active
	}
	static lowerCase(Haystack) {
		NeedleRegEx := "[A-Z]" ; Regular expression to find a single uppercase letter.
		Replacement := "$l0" ; Replacement pattern to change the matching uppercase letter to lowercase.
		; Call the RegExReplace function with the provided parameters.
		NewStr := RegExReplace(Haystack, NeedleRegEx, Replacement, &OutputVarCount, 1) ; Limit is set to 1 to replace the first occurrence only.
		; Display the original and modified strings.
		return NewStr
	}
}

class GuiResizer_ extends GuiReSizer
{
	static resizeCalltime := 0
	static Call(guiobj, params*)
	{
		GuiResizer_.resizeCalltime := A_TickCount
		GuiReSizer.Call(guiobj, params*)
		gu := GuiResizer_.redraw.Bind(guiobj)
		SetTimer gu, -400
	}
	static redraw(guiobj?)
	{
		if GuiResizer_.resizeCalltime + 400 < A_TickCount
			for k, ctrl in this
			{
				try ctrl.redraw()
			}
	}
}