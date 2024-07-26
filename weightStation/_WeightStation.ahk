#Requires Autohotkey v2
#SingleInstance Force
#Include <GuiReSizer>
#Include <cJson>
#Include <darkmode>
#Include <AHKpy>
#Include <Dark_MsgBox_v2>

#Include lib\_baseClasses.ahk
#Include lib\wsUtils.ahk
#Include lib\number_pad.ahk
#Include lib\onscreenKB.ahk
#Include lib\_postAnimal.ahk
#Include <ColorButton>
#Include lib\commentsKB.ahk

#Include lib\_SearchCustomers.ahk
#Include lib\_SelectSpecies.ahk
#Include lib\_genderOptions.ahk
#Include lib\_OrgansOptions.ahk
#Include lib\_captureWeight.ahk
#Include lib\_OrganOptionsBinary.ahk
#Include lib\_moreAnimalsBinary.ahk


wsGUI := {}
wsGUI := Gui("-DPIScale +Resize +MinSize850x500 +OwnDialogs")
wsGUI.OnEvent("Size", GuiResizer)
wsGUI.Show("w1920 h1080")
darkMode(wsGUI)
wsGUI.Maximize()
appRun := true

/**
 * This code snippet represents a loop that runs while the `appRun` variable is true.
 * Within the loop, it performs the following actions:
 * 1. Calls the `selectCustomer` function from the `linearCall` object, passing the `wsGUI` parameter.
 * 2. Calls the `addAnimal` function from the `linearCall` object, passing the `wsGUI` and `animalObj` parameters.
 * 3. Displays the JSON representation of the `animalObj` using the `Msgbox` function.
 * 4. Enters a nested loop while the `moreAnimalBinary` function returns true.
 *    - Within the nested loop, it calls the `addAnimal` function from the `linearCall` object, passing the `wsGUI` and `animalObj` parameters.
 *    - Displays the JSON representation of the `animalObj` using the `Msgbox` function.
 * 
 * After the loop, the script exits by calling the `ExitApp` function.
 */
while appRun
{
    animalObj := appLoop.selectCustomer(&wsGUI)
    appLoop.addAnimal(&wsGUI, &animalObj)
    Msgbox Json.Dump(animalObj, 1)
    while moreAnimalBinary()
    {
        CommentHandler.Clear()
        appLoop.addAnimal(&wsGUI, &animalObj)
        Msgbox(Json.Dump(animalObj, 1))
    }
}
ExitApp()

/**
 * @class linearCall
 * @description Represents a class for handling linear calls in the WeightStation application.
 */
class appLoop
{
    static customerObj := {}
    /** 
     * @method selectCustomer
     * @param {Object} wsGUI - The WeightStation GUI object.
     * @returns {Object} - The selected animal object.
     * @description Selects a customer and returns the selected animal object.
     */
    static selectCustomer(&wsGUI)
    {
        animalObj := selectSpecies(&wsGUI)
        searchCustomers(&wsGUI, &animalObj)
        appLoop.customerObj := animalObj
        return animalObj
    }

    /**
     * @method addAnimal
     * @param {Object} wsGUI - The WeightStation GUI object.
     * @param {Object} animalObj - The animal object to be added.
     * @returns {Object} - The updated animal object.
     * @description Adds an animal to the WeightStation and returns the updated animal object.
     */
    static addAnimal(&wsGUI, &animalObj)
    {
        animalObj := appLoop.customerObj
        genderOptions(&wsGUI, &animalObj)
        captureWeight(&wsGUI, &animalObj)
        if InStr(OrgansBinary(&animalObj), "Customize")
            animalObj.organs['json'] := organOptions.Launch(&animalObj, &wsGUI)
        MsgBox Json.Dump(animalObj)
        MsgBox Json.Dump(API_FinalizeNewAnimal(animalObj.eventID, animalObj))
        return animalObj
    }
    /**
         * Launches the organOptions GUI and sets the organ preferences for the animal object.
         * 
         * @param {HWND} ParentHwnd - The handle of the parent window.
         * @returns {Object} - The updated animal object with organ preferences.
         */
    static moreAnimalsBinary(ParentHwnd)
    {
        animalObj.organs['json'] := organOptions.Launch(&animalObj, &wsGUI)
        return animalObj
    }
}