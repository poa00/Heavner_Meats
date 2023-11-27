#Requires autohotkey v2
#SingleInstance force
#Include requests/utils.ahk

mygui := Gui()

mygui.show("w300 h300")

WinSetTransparent 170, "ahk_id " mygui.hwnd 
WinMove 0,0,,, "ahk_id " mygui.hwnd

button1 := mygui.add("button", ,"hello world")

mygui.Opt("+AlwaysOnTop")
mygui.backcolor := "Black"
darkmode(mygui)