#Requires AutoHotkey v2.0
#SingleInstance Force

x := Map(1,2,1,2)
Msgbox ((Sleep(100), ([x.__Enum(2).Bind(&_)*][1]))) 