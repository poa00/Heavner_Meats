#Requires autohotkey v2
#SingleInstance force
#Include requests/utils.ahk
#Include GuiResizer.ahk
#Include variable.ahk
#Include meatParsed.ahk
x := SysGet(16)
y := SysGet(17)
gui__ := Gui(, "Test - List"), gui__.Opt("+Resize +MinSize250x150 -DPIScale")
gui__.OnEvent("Size", GuiReSizer) ; assign GuiReSizer to handle all size changes for this Gui
gui__.SetFont("s37 cWhite")
firstSelection := { value: False, type: false }
anchorBoxiesX := 0.02
listboxTopLeftH := 0.35
;Relative Positioning:
gui__.ListBox := {}
thirdSelection:= ""

gui__.LB_Primary := gui__.Add("ListBox", "w" 400 "", loopBeef())
gui__.LB_Primary.WidthP := 0.45
gui__.LB_Primary.YP := 0.02
gui__.LB_Primary.XP := anchorBoxiesX ; 10 from Left Margin
gui__.LB_Primary.WidthP := 0.25
gui__.LB_Primary.HeightP := 0.987
gui__.LB_Primary.OnEvent("Change", onFirstListboxChange)
;gui__.ListBox.Two := gui__.add("button", ,"hello world")
;gui__.ListBox.Two.XP := anchorBoxiesX ; 10 from Left Margin

groupBox_XP := -0.70
groupBox_YP := 0.02
groupBox_WP := 0.67
groupBox_HP := 0.44
gui__.GroupBox := gui__.Add("GroupBox", , "Select from one of the below options")
gui__.GroupBox.XP := groupBox_XP ; 20% from Left Margin
gui__.GroupBox.YP := groupBox_YP ; 45% from Top Margin
gui__.GroupBox.WidthP := groupBox_WP ; Right Edge maintain 50% from Right Margin
gui__.GroupBox.HeightP := groupBox_HP ; Bottom Edge maintain 30% from Bottom Margin
gui__.GroupBox.SetFont("s12")

option_XP := -0.69
option_YP := 0.02
option_WP := 0.21
option_HP := 0.39

gui__.LB_Options1__ := gui__.Add("ListBox", "", [""])
gui__.LB_Options1__.SetFont("s22")
gui__.LB_Options1__.XP := option_XP ; 20% from Left Margin
gui__.LB_Options1__.YP := option_YP + 0.04 ; 45% from Top Margin
gui__.LB_Options1__.WP := option_WP + 0.02
gui__.LB_Options1__.HP := option_HP


gui__.LB_Options2__ := gui__.Add("ListBox", "", [""])
gui__.LB_Options2__.SetFont("s22")
gui__.LB_Options2__.XP := option_XP + option_WP + 0.02 ; 20% from Left Margin
gui__.LB_Options2__.YP := option_YP + 0.04 ; 45% from Top Margin
gui__.LB_Options2__.WP := option_WP
gui__.LB_Options2__.HP := option_HP


gui__.LB_Options3__ := gui__.Add("ListBox", "", [""])
gui__.LB_Options3__.SetFont("s22")
gui__.LB_Options3__.XP := option_XP + option_WP + option_WP + 0.02 ; 20% from Left Margin
gui__.LB_Options3__.YP := option_YP + 0.04 ; 45% from Top Margin
gui__.LB_Options3__.WP := option_WP
gui__.LB_Options3__.HP := option_HP


order_X := 0.55
order_Y := 0.52
order_W := 0.44
order_H := 0.45
gui__.GroupBox := gui__.Add("GroupBox", , "Order")
gui__.GroupBox.XP := order_X ; 20% from Left Margin
gui__.GroupBox.YP := order_Y ; 45% from Top Margin
gui__.GroupBox.WidthP := order_W ; Right Edge maintain 50% from Right Margin
gui__.GroupBox.HeightP := order_H ; Bottom Edge maintain 30% from Bottom Margin
gui__.GroupBox.SetFont("s16")
;SimpleNameForEdit := gui__.Add("Button", , "In the Box") ; do not need to use an Object structure for naming, 'guiList.Edit' would just be my preferred convention
;SimpleNameForEdit.XP := 0.1
;SimpleNameForEdit.YP := -0.45

buttonGroup_X := -0.70
buttonGroup_Y := 0.52
buttonGroup_W := 0.21
buttonGroup_H := 0.44
gui__.buttonGroupBox := gui__.Add("GroupBox", , "Buttons")

gui__.buttonGroupBox.XP := buttonGroup_X
gui__.buttonGroupBox.YP := buttonGroup_Y
gui__.buttonGroupBox.WP := buttonGroup_W
gui__.buttonGroupBox.HP := buttonGroup_H
gui__.buttonGroupBox.SetFont("s16")

gui__.LB_Orders := gui__.Add("ListBox", "", [])
gui__.LB_Orders.SetFont("s16")
gui__.LB_Orders.XP := order_X + 0.01 ; 20% from Left Margin
gui__.LB_Orders.YP := order_Y + 0.04 ; 45% from Top Margin
gui__.LB_Orders.WP := order_W - 0.02
gui__.LB_Orders.HP := order_H - 0.05

listBoxUnselect()
gui__.backcolor := "Black"
darkmode(gui__)

gui__.LB_Primary.OnEvent("Change", LB_PrimaryChange)
gui__.LB_Options1__.OnEvent("Change", LB_Option1Change)
gui__.LB_Options2__.OnEvent("Change", LB_Option2Change)
gui__.LB_Options3__.OnEvent("Change", LB_Option3Change)

gui__.Show("h" 800 " w" 1500)
gui__.Maximize()
WinSetTransparent 240, "ahk_id " gui__.hwnd

onFirstListboxChange(*)
{
    global isFirstboxSelected
    if isFirstboxSelected = 0
    {
        isFirstboxSelected := 1
    }
}

listBoxUnselect()
{
    global isFirstboxSelected
    isFirstboxSelected := 0
    gui__.LB_Primary.Value := 0
}

loopBeef()
{
    global BeefMap
    PrimaryKeys := []

    for key, objectMap in BeefMap
    {
        PrimaryKeys.Push(key)
    }
    return PrimaryKeys
}

processMap(subOptionNext, NextLB, SecondaryLB?)
{
    NextLB.Delete
    if IsObject(subOptionNext) {
        if subOptionNext is Array
        {
            for item in subOptionNext
            {
                NextLB.Add([item])
            }
        } else if subOptionNext is Map
        {
            for key, val in subOptionNext
            {
                NextLB.Add([key])
            }
        }
    } else {
        try {
            NextLB.Add([subOptionNext])
        }
    }
    return true
}
LB_PrimaryChange(GuiCtrl, *)
{
    /*
    roasts and shanks and thickness, need to recursively loop through the map
    */
    global BeefMap, firstSelection
    gui__.LB_Options2__.Delete
    gui__.LB_Options1__.Delete
    firstSelection.value := GuiCtrl.Text
    firstSelection.type := Type(BeefMap[GuiCtrl.Text])
    ProcessMap(BeefMap[GuiCtrl.Text], gui__.LB_Options1__)
}

LB_Option1Change(GuiCtrl, *)
{
    global BeefMap, firstSelection, secondSelection, thirdSelection, gui__
    gui__.LB_Options2__.Delete
    secondSelection := GuiCtrl.Text
    if BeefMap[firstSelection.Value] is Map or BeefMap[firstSelection.Value] is Array
    {
        option1MeatMap := BeefMap[firstSelection.value]
        if option1MeatMap.Has(secondSelection)
        {
            if option1MeatMap[secondSelection] is Array
            {
                if option1MeatMap[secondSelection].Length > 1
                {
                    ProcessMap(option1MeatMap[secondSelection], gui__.LB_Options2__)
                }
                else
                {
                    gui__.LB_Options2__.Add(["Select?"])
                }
            }
            else if option1MeatMap[secondSelection] is Map
            {
                if option1MeatMap[secondSelection].Count > 1
                {
                    ProcessMap(option1MeatMap[secondSelection], gui__.LB_Options2__)
                }
            }
            else
            {
                ProcessMap(option1MeatMap[secondSelection], gui__.LB_Options2__)
            }
        }
    } else {
        gui__.LB_Options2__.Add(["Select?"])
    }
}

LB_Option2Change(GuiCtrl, *)
{
    global BeefMap, firstSelection, gui__, secondSelection, thirdSelection
    if secondSelection = GuiCtrl.Text or GuiCtrl.Text = "Select?"
    {
        return
    }
    thirdSelection := GuiCtrl.Text
    if firstSelection.type = "Map"
    {
        BeefMapSubSection := BeefMap[firstSelection.value]
        if BeefMapSubSection.Has(GuiCtrl.Text)
        {
            if BeefMapSubSection[GuiCtrl.Text] is Map or BeefMapSubSection[GuiCtrl.Text] is Array
            {
                ProcessMap(BeefMapSubSection[GuiCtrl.Text], gui__.LB_Options3__)
            }
        } else {
            gui__.LB_Options3__.Add(["Select?"])
        }
    }
}

LB_Option3Change(GuiCtrl, *)
{
    global BeefMap, firstSelection, gui__, secondSelection, thirdSelection
    if secondSelection = GuiCtrl.Text
    {
        return
    }
    if firstSelection.type = "Map"
    {
        BeefMapSubSection := BeefMap[firstSelection.value]
        if BeefMapSubSection.Has(GuiCtrl.Text)
        {
            if BeefMapSubSection[GuiCtrl.Text] is Map or BeefMapSubSection[GuiCtrl.Text] is Array
            {
                ProcessMap(BeefMapSubSection[GuiCtrl.Text], gui__.LB_Options3__)
            }
        } else {
            gui__.LB_Options3__.Add(["Select?"])
        }
    }
}

keywords_to_skip := ["Thickness", "Weight", "No./Pack"]


CrudOrder(GuiCtrl, *)
{

}