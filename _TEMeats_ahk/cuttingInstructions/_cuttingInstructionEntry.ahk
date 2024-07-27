#Requires Autohotkey v2
#SingleInstance force

#Include <AHKpy>
#Include <ButtonStyle>
#Include <request>
#Include <cJson>
#Include <darkmode>
#Include <AutoResizer>
#Include <ButtonIcon>
#Include <LBCSTools>
#Include beefParsed.ahk
#Include porkParsed.ahk
; SearchCustomers
#Include searchCustomers.ahk
; CSCrud
#Include csCRUD.ahk
#Include csCRUDEvents.ahk
; HowManyAnimals
#Include HowManyAnimals.ahk
; Order
#Include orderWizEvents.ahk
#Include OrderFinalize_andNav.ahk
#Include orderReviewEvents.ahk
#Include Ctrls.ahk
; subMenusOrder => Split and Sausage
#Include species.ahk
#Include Splitter.ahk
#Include Sausage.ahk
#Include utilsCS.ahk
; Assign animals to cutsheet
#Include assign.ahk
#Include <Request>

Persistent

/*
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; * Overview: This script creates a GUI for selecting options
; * and managing orders. It dynamically generates options
; * based on user selections and accumulates orders.
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

1. Search Custommers
2. Cutsheet Crud
3. howManyAnimals
4. Wizard/Order

; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; * GUI Initialization
; @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
*/
animalMaps := Map()
animalMaps["cows"] := beefParsed, animalMaps["pigs"] := porkParsed
gui_ := constructGUI(Gui(, "Find your customer"))
gui_.Opt("+Resize +MinSize550x350 -DPIScale")
CreateImageButton("SetDefGuiColor", 0x000000)
setAllMenusInvisible()
gui_.Show("h" 1080 " w" 1920)
gui_.Maximize()
GuiResizer.Now(gui_)
ButtonStyle.Refresh()
resetCutsheetVars()
/**
 * PLACEHOLDER FOR PASSING ARGS
 */
args()
setBackgroundColors()
ButtonStyle.Refresh()

howManyAnimals()
gui_.howMany.ToggleVisible(0)

/**
 * *************************************
 *   CUTSHEET CRUD GUI INITIALIZATION
 * *************************************
 */
if cutsheetCRUD() = false
{
    ExitApp()
} else {
    gui_.csCRUD.Edit.OnEvent("Click", editCutSheet)
    gui_.csCRUD.New.OnEvent("Click", NewCutsheet)
    gui_.csCRUD.duplicate.OnEvent("Click", dupeCutsheet)
    gui_.csCRUD.return.OnEvent("Click", (*) => Reload())
    gui_.csCRUD.Delete.OnEvent("Click", delCutsheet)
}
/**
 * Function: listBoxUnselect
 * Description: Unselects all items in the list box of the GUI.
 */
listBoxUnselect()
setBackgroundColors()
GuiReSizer.Now(gui_)


args()
{
    if A_Args.Length > 0
    {
        requests.appName := "customers"
        x := requests.GetUrl("customers/" A_Args[1])
        Customer.Producer := requests.GetUrl("customers/" A_Args[1])
    } else {
        InitSearchCustomers()
    }
}


/**
 * *************************************
 * Primary Functions Perm. Moved
 * *************************************
 */
#Include primaryFunctions.ahk