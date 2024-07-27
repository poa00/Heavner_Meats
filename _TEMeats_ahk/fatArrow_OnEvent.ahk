#Requires AutoHotkey v2.0
#SingleInstance Force  
#Warn all, off
#Include <ahkPy>


if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
    myGui := Constructor()
    myGui.Show("")
}

class Constructor
{   

    static Call()
    {
        myParam := 1
        myGui := Gui()
        ButtonOK := myGui.Add("Button", "x63 y58 w80 h23", "&OK")
        ; ButtonOK.OnEvent("Click",(*) => Constructor.OnEventHandler(&myParam))
        ButtonOK.OnEvent("Click",(*) => Constructor.OnEventHandler(&myParam))
        ButtonOK := myGui.Add("Button", "x63 y158 w80 h23", "&OK")
        ButtonOK.OnEvent("Click", withinFunc)
        myGui.OnEvent('Close', (*) => ExitApp())
        myGui.Title := "Window"

        withinFunc(*)
        {
            Msgbox myParam
        }
        return myGui
    }   
    static OnEventHandler(&myParam)
    {
        Msgbox myParam+=1
    }
}