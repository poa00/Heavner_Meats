; ---------------------------------------------------------
; GUI Initialization
; ---------------------------------------------------------
constructGUI()
{
    global gui__
    gui__ := Gui(, "Test - List"), gui__.Opt("+Resize +MinSize550x350 -DPIScale")
    gui__.OnEvent("Size", GuiReSizer) ; assign GuiReSizer to handle all size changes for this Gui
    gui__.SetFont("s37 cWhite")
    Primary := { value: False, type: false }
    anchorBoxiesX := 0.02
    listboxTopLeftH := 0.35
    ;Relative Positioning:

    ; ---------------------------------------------------------
    ; GUI Components - List Boxes, Group Boxes, Buttons
    ; ---------------------------------------------------------
    gui__.LB_Primary := gui__.Add("ListBox", "w" 400 "", loopBeef())
    gui__.LB_Primary.WidthP := 0.45
    gui__.LB_Primary.YP := 0.02
    gui__.LB_Primary.XP := anchorBoxiesX ; 10 from Left Margin
    gui__.LB_Primary.WidthP := 0.25
    gui__.LB_Primary.HeightP := 0.987
    gui__.LB_Primary.OnEvent("Change", onFirstListboxChange)
    ;gui__.ListBox.Two := gui__.add("button", ,"hello world")
    ;gui__.ListBox.Two.XP := anchorBoxiesX ; 10 from Left Margin

    optionsGroupBox_XP := -0.71
    optionsGroupBox_YP := 0.02
    optionsGroupBox_WP := 0.69
    optionsGroupBox_HP := 0.43
    gui__.optionsGroupBox := gui__.Add("GroupBox", "Background162135", "Select from one of the below options")
    gui__.optionsGroupBox.XP := optionsGroupBox_XP ; 20% from Left Margin
    gui__.optionsGroupBox.YP := optionsGroupBox_YP ; 45% from Top Margin
    gui__.optionsGroupBox.WidthP := optionsGroupBox_WP ; Right Edge maintain 50% from Right Margin
    gui__.optionsGroupBox.HeightP := optionsGroupBox_HP ; Bottom Edge maintain 30% from Bottom Margin
    gui__.optionsGroupBox.SetFont("s12")
    gui__.optionsGroupBox.backcolor := "cGrey"


    optionText_YP := 0.06
    optionText_XP := -0.70
    optionText_WP := 0.17


    gui__.LBOption1__Text := gui__.Add("Text", "r1", "Option 1")
    gui__.LBOption1__Text.XP := optionText_XP
    gui__.LBOption1__Text.YP := optionText_YP
    gui__.LBOption1__Text.WidthP := optionText_WP
    gui__.LBOption1__Text.HeightP := 0.03
    gui__.LBOption1__Text.SetFont("s14")


    option_XP := -0.70
    option_YP := 0.095
    option_WP := 0.16
    option_HP := 0.365


    /*
    4 Listboxes are Left to right,
    */
    gui__.LB_Option1__ := gui__.Add("ListBox", "", [""])
    gui__.LB_Option1__.SetFont("s20")
    gui__.LB_Option1__.XP := option_XP ; 20% from Left Margin
    gui__.LB_Option1__.YP := option_YP  ; 45% from Top Margin
    gui__.LB_Option1__.WP := option_WP + 0.02
    gui__.LB_Option1__.HP := option_HP


    gui__.LB_Option2__ := gui__.Add("ListBox", "", [""])
    gui__.LB_Option2__.SetFont("s20")
    gui__.LB_Option2__.XP := option_XP + option_WP + 0.02 ; 20% from Left Margin
    gui__.LB_Option2__.YP := option_YP  ; 45% from Top Margin
    gui__.LB_Option2__.WP := option_WP
    gui__.LB_Option2__.HP := option_HP


    gui__.LB_Option3__ := gui__.Add("ListBox", "", [""])
    gui__.LB_Option3__.SetFont("s20")
    gui__.LB_Option3__.XP := option_XP + option_WP * 2 + 0.02 ; 20% from Left Margin
    gui__.LB_Option3__.YP := option_YP  ; 45% from Top Margin
    gui__.LB_Option3__.WP := option_WP
    gui__.LB_Option3__.HP := option_HP


    gui__.LB_Option4__ := gui__.Add("ListBox", "", [""])
    gui__.LB_Option4__.SetFont("s20")
    gui__.LB_Option4__.XP := option_XP + option_WP * 3 + 0.02 ; 20% from Left Margin
    gui__.LB_Option4__.YP := option_YP  ; 45% from Top Margin
    gui__.LB_Option4__.WP := option_WP
    gui__.LB_Option4__.HP := option_HP
    buttonGroup_X := -0.71
    buttonGroup_Y := 0.47
    buttonGroup_W := 0.23
    buttonGroup_H := 0.49
    gui__.centerButtons := gui__.Add("GroupBox", , "Buttons")

    /*
    Centered Buttons at bottom of GUI
    */
    gui__.centerButtons.XP := buttonGroup_X
    gui__.centerButtons.YP := buttonGroup_Y
    gui__.centerButtons.WP := buttonGroup_W + 0.02
    gui__.centerButtons.HP := buttonGroup_H
    gui__.centerButtons.SetFont("s16")

    gui__.centerButtons.add := gui__.Add("Button", , "Add")
    gui__.centerButtons.add.XP := buttonGroup_X + 0.01
    gui__.centerButtons.add.YP := buttonGroup_Y + 0.05
    gui__.centerButtons.add.WP := buttonGroup_W - 0.005
    gui__.centerButtons.add.HP := buttonGroup_H / 6
    gui__.centerButtons.add.SetFont("s15")

    gui__.centerButtons.remove := gui__.Add("Button", , "Remove")
    gui__.centerButtons.remove.XP := buttonGroup_X + 0.01
    gui__.centerButtons.remove.YP := buttonGroup_Y + 0.05 + buttonGroup_H / 6
    gui__.centerButtons.remove.WP := buttonGroup_W - 0.005
    gui__.centerButtons.remove.HP := buttonGroup_H / 6
    gui__.centerButtons.remove.SetFont("s15")

    gui__.centerButtons.toggle := gui__.Add("Button", , "Toggle - SubMenu - View")
    gui__.centerButtons.toggle.XP := buttonGroup_X + 0.01
    gui__.centerButtons.toggle.YP := buttonGroup_Y + 0.05 + buttonGroup_H / 6 * 2
    gui__.centerButtons.toggle.WP := buttonGroup_W - 0.005
    gui__.centerButtons.toggle.HP := buttonGroup_H / 6
    gui__.centerButtons.toggle.SetFont("s15")


    /*
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@ TABS/Group Box to Replace @@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    */
    tabSection(gui__)

    listBoxUnselect()
    gui__.backcolor := "121d30"
    darkmode(gui__)


    gui__.Show("h" 800 " w" 1500)
    gui__.Maximize()
    ; WinSetTransparent 240, "ahk_id " gui__.hwnd
    return gui__
}

tabSection(gui__)
{
    /*
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@ TABS/Group Box to Replace @@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    */
    order_X := 0.55
    order_Y := 0.47
    order_W := 0.44
    order_H := 0.49
    gui__.Tabs := gui__.Add("Tab", "Background19212f", ["Order Details", "Second Tab", "Second Tab"])
    gui__.Tabs.XP := order_X
    gui__.Tabs.YP := order_Y
    gui__.Tabs.WidthP := order_W
    gui__.Tabs.HeightP := order_H
    gui__.Tabs.SetFont("s22")

    gui__.Tabs.UseTab(1)
    ;gui__.GroupBox
    gui__.LB_Orders := gui__.Add("ListBox", "Background162235", [])
    gui__.LB_Orders.SetFont("s16")
    gui__.LB_Orders.XP := order_X + 0.01 ; 20% from Left Margin
    gui__.LB_Orders.YP := order_Y + 0.06 ; 45% from Top Margin
    gui__.LB_Orders.WP := order_W - 0.02
    gui__.LB_Orders.HP := order_H - 0.07
    gui__.Tabs.UseTab()
}