#Requires Autohotkey v2
#Include <darkmode>  
#Include <GuiReSizer>
#SingleInstance Force
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
    myGui := moreAnimalBinary()
    myGui.Show("w551 h202")
}
/**
 * @class moreAnimalBinary
 * @description Represents a class for handling binary animal responses.
 */
class moreAnimalBinary
{
    /**
     * @static
     * @type {boolean}
     * @description Indicates whether the animal response has been finished.
     */
    static finished := false
    
    /*
     * @static
     * @type {boolean}
     * @description Indicates the response to the animal question.
     */
    static response := false
    
    /**
     * @method Call
     * @returns {boolean} The response to the animal question.
     * @description Displays a GUI window with YES and NO buttons to get the user's response to the animal question.
     */
    static Call()
    {
        moreAnimalBinary.finished := false
        myGui := Gui()
        myGui.SetFont("s16")
        ButtonYES := myGui.Add("Button", "x72 y88 w160 h77", "YES")
        myGui.SetFont("s16")
        ButtonNO := myGui.Add("Button", "x304 y88 w160 h77", "NO")
        myGui.SetFont("s20")
        myGui.Add("Text", "x64 y24 w398 h43 +0x200", "ANOTHER ANIMAL?")
        ButtonYES.OnEvent("Click", OnEventHandler)
        ButtonNO.OnEvent("Click", OnEventHandler)
        myGui.OnEvent('Close', (*) => ExitApp())
        myGui.Title := "Window"
        myGui.Show("w551 h202")

        while moreAnimalBinary.finished = false 
            Sleep(100)
        myGui.Destroy()
        
        OnEventHandler(ctrl, *)
        {
            if ctrl.Text = "YES"
                moreAnimalBinary.response := true
            else if ctrl.Text = "NO"
                moreAnimalBinary.response := false
            moreAnimalBinary.finished := true
        }
        return moreAnimalBinary.response
    }
}