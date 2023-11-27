MyGui := TabMenu.G()
MyGui.Show("w1200 h800")

class TabMenu
{
    static G()
    {
        MyGui := Gui()
        Tab := MyGui.Add("Tab3",, ["First Tab","Second Tab","Third Tab"])
        MyGui.Add("CheckBox", "vMyCheckBox", "Sample checkbox") 
        Tab.UseTab(3)
        MyGui.Add("Radio", "vMyRadio", "Sample radio1").OnEvent("Click",ProcessUserInput)
        MyGui.Add("Radio",, "Sample radio2").OnEvent("Click",ProcessUserInput)
        Tab.UseTab(2)
        MyGui.Add("Edit", "vMyEdit r5")  ; r5 means 5 rows tall.
        Tab.UseTab(1)  ; i.e. subsequently-added controls will not belong to the tab control.
        Btn := MyGui.Add("Button", "default xm", "OK")  ; xm puts it at the bottom left corner.
        Btn.OnEvent("Click", ProcessUserInput)
        MyGui.OnEvent("Close", ProcessUserInput)
        MyGui.OnEvent("Escape", ProcessUserInput)

        ProcessUserInput(*)
        {
            Saved := MyGui.Submit()  ; Save the contents of named controls into an object.
            MsgBox("You entered:`n" Saved.MyCheckBox "`n" Saved.MyRadio "`n" Saved.MyEdit)
        }
        return MyGui
    }
}
