
#Requires Autohotkey v2
class a
{
    static b := {}
    static Call(*)
    {
        a.b.c := "str"
    }    
}


myGui := Gui()
ogcButtonOK := myGui.Add("Button", "x127 y71 w80 h23", "&OK")
ogcButtonOK.OnEvent("Click", (*) => a())
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "Window"
myGui.Show("w620 h420")

OnEventHandler(*)
{
    ToolTip("Click! This is a sample action.`n"
        . "Active GUI element values include:`n"
        . "ogcButtonOK => " ogcButtonOK.Text "`n", 77, 277)
    SetTimer () => ToolTip(), -3000 ; tooltip timer
}
