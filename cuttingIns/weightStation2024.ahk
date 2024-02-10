
#Requires Autohotkey v2
#SingleInstance Force
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2
#Include <GuiResizer>
#Include <utils>

gu := Gui(, "Test - List"), gu.Opt("+Resize +MinSize250x150")

gu.SetFont("s20 cWhite")
TL := gu.Add("GroupBox", "x5 y5 w200 h200 Section", "GroupBox")

Radio1 := gu.Add("Radio", "XP+15 YP+55 ", "Cow")
Radio2 := gu.Add("Radio", "Xp Y+15 ", "Pig")
Radio3 := gu.Add("Radio", "Xp Y+15 ", "Lamb")


gu.Add("GroupBox", "x+100 ys+5 w300 h200", "Weight")
Edit1 := gu.Add("Edit", "xp+10 y72 w318 h117")


gu.Add("GroupBox", "x24 y288 w310 h223", "Sex/Age")
Radio4 := gu.Add("Radio", "x50 y341 w236 h23", "Radio Button")
Radio5 := gu.Add("Radio", "x49 y403 w262 h23", "Radio Button")
CheckBox1 := gu.Add("CheckBox", "x48 y456 w120 h23", "CheckBox")
gu.Add("GroupBox", "x376 y296 w521 h216", "Parts")
CheckBox2 := gu.Add("CheckBox", "x409 y350 w120 h23", "CheckBox")
CheckBox3 := gu.Add("CheckBox", "x408 y400 w120 h23", "CheckBox")
CheckBox4 := gu.Add("CheckBox", "x402 y460 w120 h23", "CheckBox")
CheckBox5 := gu.Add("CheckBox", "x648 y360 w120 h23", "CheckBox")
CheckBox6 := gu.Add("CheckBox", "x652 y438 w120 h23", "CheckBox")
Edit2 := gu.Add("Edit", "x56 y576 w838 h184", "comments")
gu.OnEvent('Close', (*) => ExitApp())
gu.Title := "Window"
gu.BackColor := "Black"
darkMode(gu)
gu.Show("w1068 h799")

; OnEventHandler(*)
; {
; 	ToolTip("Click! This is a sample action.`n"
; 	. "Active GUI element values include:`n"  
; 	. "Radio1 => " Radio1.Value "`n" 
; 	. "Radio2 => " Radio2.Value "`n" 
; 	. "Radio3 => " Radio3.Value "`n" 
; 	. "Edit1 => " Edit1.Value "`n" 
; 	. "Radio4 => " Radio4.Value "`n" 
; 	. "Radio5 => " Radio5.Value "`n" 
; 	. "CheckBox1 => " CheckBox1.Value "`n" 
; 	. "CheckBox2 => " CheckBox2.Value "`n" 
; 	. "CheckBox3 => " CheckBox3.Value "`n" 
; 	. "CheckBox4 => " CheckBox4.Value "`n" 
; 	. "CheckBox5 => " CheckBox5.Value "`n" 
; 	. "CheckBox6 => " CheckBox6.Value "`n" 
; 	. "Edit2 => " Edit2.Value "`n", 77, 277)
; 	SetTimer () => ToolTip(), -3000 ; tooltip timer
; }
