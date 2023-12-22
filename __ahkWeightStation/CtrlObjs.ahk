#Include GuiResizer.ahk
; ---------------------------------------------------------
; GUI Initialization
; ---------------------------------------------------------
/*
   Function: addToWizHeader

   Description:
   Adds the specified string to the wizard header.

   Parameters:
   - str (string): The string to be added to the wizard header.

   Returns:
   None
*/
addToWizHeader(str)
{
   gui__.optionWiz.Header2.Text := gui__.optionWiz.Header2.Text "`n - " str ""
}


/*
This file contains the code for constructing the GUI for the weight station application.
The constructGUI function is responsible for creating the GUI and setting up its event handlers.
It also defines the layout and appearance of various controls within the GUI.
*/
constructGUI(gui__)
{
   global BeefMap, dims
   dims := {}
   gui__.OnEvent("Size", GuiReSizer)
   gui__.SetFont("s18 cWhite")
   Primary := { value: False, type: false }
   anchorBoxiesX := 0.02
   listboxTopLeftH := 0.35
   TypeofAnimalMenu(&gui__, "TypeOfAnimalGuiClick", "Beef", "Pork", "Lamb", "Other")
   
   ; Primary Controls
   dims.PrimaryXP := anchorBoxiesX
   dims.PrimaryYP := 0.01
   dims.PrimaryWP := 0.25
   dims.PrimaryHP := 0.97
   gui__.Primary := {}
   primaryCtrls(&gui__)
   ; Option Wizard
   optionWiz(&gui__)
   ; Order Screen
   orderScreen(&gui__)
   orderNavMenu(&gui__)
   gui__.backcolor := "121d30"
   
   return gui__
}


/*
   Function: TypeofAnimalMenu

   Description:
   This function generates buttons for an AHK GUI. It takes a GUI object, a function name, and optional parameters as input.
   The buttons are created based on the provided parameters and added to the GUI object.
   If a function name is provided, the buttons are assigned the specified function as their click event handler.

   Parameters:
   - gui__ (object): The GUI object to which the buttons will be added.
   - functionName? (string): The name of the function to be assigned as the click event handler for the buttons.
   - params* (array): Optional parameters used to generate the buttons.

   Returns:
   This function does not return any value.
*/
TypeofAnimalMenu(&gui__, functionName?, params*)
{
   bx := 0.2
   by := 0.2
   bw := 0.15
   bh := 0.08
   gui__.IntroMenu := {}
   buttons := []
   for index, value in params
   {
      buttons.Push(gui__.IntroMenu.%value% := gui__.Add("Button", "", value))
      if A_Index != 1
      {
         GuiResizer.FormatOpt(gui__.IntroMenu.%value%, bx := bx + bw + 0.01, by, bw, bh)
      } else {
         GuiResizer.FormatOpt(gui__.IntroMenu.%value%, bx, by, bw, bh)
      }
   }
   for i in buttons
   {
      if IsSet(functionName)
      {
         i.OnEvent("Click", %functionName%)
      }
   }
}

/*
   Function: primaryCtrls

   Description:
   This function creates and configures the primary controls for the GUI.

   Parameters:
   - gui__ (object): The GUI object to which the controls will be added.

   Returns:
   None
*/
primaryCtrls(&gui__)
{
   gui__.Primary.GB := gui__.Add("GroupBox", "Background162135", "Step 1.")
   gui__.Primary.GB.SetFont("s22")
   GuiResizer.FormatOpt(gui__.Primary.GB, dims.PrimaryXP, dims.PrimaryYP, dims.PrimaryWP, dims.PrimaryHP)

   gui__.Primary.LB := gui__.Add("ListBox", "w" 400 "", loopBeef())
   gui__.Primary.LB.OnEvent("Change", onFirstListboxChange)
   gui__.Primary.LB.SetFont("s31")
   GuiResizer.FormatOpt(gui__.Primary.LB, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.14, dims.PrimaryWP - dims.PrimaryYP, dims.PrimaryHP - 0.14)

   optionsGroupBox_XP := -0.71
   optionsGroupBox_YP := dims.PrimaryYP
   optionsGroupBox_WP := 0.69
   optionsGroupBox_HP := 0.53
   gui__.optionWiz := {}
   
   dims.wiz_x := optionsGroupBox_XP
   dims.wiz_y := dims.PrimaryYP
   dims.wiz_w := 0.69
   dims.wiz_h := optionsGroupBox_HP + 0.44
}

/*
   Function: orderScreen
   
   Description:
   This function creates an order screen GUI with a group box and a list box.
   The group box displays the title "Orders" and the list box displays a list of beef items.
   The list box has an event handler for the "Change" event.
   
   Parameters:
   - gui__ (object): The GUI object to which the order screen will be added.
   
   Returns:
   None
*/
orderScreen(&gui__)
{
   global dims
   gui__.order := {}
   dims.orderX := gui__.Primary.GB.XP + gui__.Primary.GB.WidthP + 0.02
   dims.orderY := 0.15
   dims.orderW :=  0.7
   dims.orderH := 0.83
   gui__.order.GB := gui__.Add("GroupBox", "Background1b335f", "Order")
   gui__.order.GB.SetFont("s18")
   GuiResizer.FormatOpt(gui__.order.GB, dims.orderX, dims.orderY, dims.orderW, dims.orderH)
   
   gui__.order.ItemDetails := gui__.Add("ListBox", "w" 400 " r1", ["Click a Cut on Left to see Details"])
   gui__.order.ItemDetails.SetFont("s25")
   GuiResizer.FormatOpt(gui__.order.ItemDetails, dims.orderX + 0.01, dims.orderY + 0.07, (dims.orderW - 0.02) / 2, .5)
   
   
   ; gui__.order.Search := gui__.Add("Edit", "w" 400 " r1", "Search for a recipient")
   ; gui__.order.Search.SetFont("s25")
   ; GuiResizer.FormatOpt(gui__.order.Search, dims.orderX + ((dims.orderW +0.02) / 2), dims.orderY + 0.15, (dims.orderW - 0.02) / 2,)
   
   
   ; gui__.order.Schedule := gui__.Add("Button", , "Schedule Slaughter")
   ; gui__.order.Schedule.OnEvent("Click", onFirstListboxChange)
   ; gui__.order.Schedule.SetFont("s18")
   ; GuiResizer.FormatOpt(gui__.order.Schedule, dims.orderX + 0.01, dims.orderY + 0.14, .18)
   
   gui__.order.SetReceipient := gui__.Add("Button", "", "Set Receipient")
   gui__.order.SetReceipient.OnEvent("Click", onFirstListboxChange)
   gui__.order.SetReceipient.SetFont("s18")
   GuiResizer.FormatOpt(gui__.order.SetReceipient, .8, dims.orderY + 0.07, .18)
}

/*
   * Function: orderNavMenu
   * Description: This function creates tab buttons for navigation in the GUI.
   * Parameters:
   *    - gui__ (object): The GUI object to which the tab buttons will be added.
   * Returns: None
*/
orderNavMenu(&gui__)
{
   global dims
   gui__.Menu := {}
    

   gui__.Menu.Box := gui__.Add("GroupBox", "Background1b335f", "Navigation")
   gui__.Menu.Box.SetFont("s26")
   GuiResizer.FormatOpt(gui__.Menu.Box, dims.orderX, dims.PrimaryYP, dims.orderW, .13)

   dims.NavX := gui__.order.GB.XP+0.01
   dims.NavY := 0.06
   dims.NavW := 0.22
   dims.NavH := 0.07
   gui__.Menu.Order := gui__.Add("Button", "Background1b335f", "Order Review")
   gui__.Menu.Order.SetFont("s25 q5", "Arial")
   GuiResizer.FormatOpt(gui__.Menu.Order, dims.NavX, dims.NavY, dims.NavW, dims.NavH)

   gui__.Menu.Wiz := gui__.Add("Button", "Background1b335f", "Option Wizard")
   gui__.Menu.Wiz.SetFont("s25", "Arial")
   GuiResizer.FormatOpt(gui__.Menu.Wiz, dims.NavX+dims.NavW +0.02, dims.NavY, dims.NavW, dims.NavH)

   gui__.Menu.Wiz.OnEvent("Click", TabNav)
   gui__.Menu.Order.OnEvent("Click", TabNav)
}


/*
   Function: optionWiz
   
   Description: This function creates a GUI with various controls for an options wizard.
   
   Parameters:
      - gui__ (object): The GUI object to which the controls will be added.
      
   Returns: None
*/
optionWiz(&gui__)
{
   optionsGroupBox_XP := -0.71
   optionsGroupBox_YP := dims.PrimaryYP + 0.04
   optionsGroupBox_WP := 0.69
   optionsGroupBox_HP := 0.51
   gui__.optionWiz := {}

   ; dims.orderY := 0.13
   ; dims.orderW := 0.7
   ; dims.orderH := 0.85
   dims.wiz_x := optionsGroupBox_XP
   dims.wiz_y := 0.15
   dims.wiz_w := 0.69
   dims.wiz_h := 0.84
   ;dims.wiz_w := optionsGroupBox_WP / 2 + 0.07
   ;dims.wiz_h := optionsGroupBox_HP + 0.44


   ; options := StrReplace("yp" dims.wiz_y " xp" dims.wiz_x " wp" dims.wiz_w " hp" dims.wiz_h, "0.", ".")
   gui__.optionWiz.GB := gui__.Add("GroupBox", "Background1b335f", "Option Wizard")
   gui__.optionWiz.GB.SetFont("s18")
   GuiResizer.FormatOpt(gui__.optionWiz.GB, dims.wiz_x, dims.wiz_y, dims.wiz_w, dims.wiz_h)

   optionText_YP := 0.17
   optionText_XP := -0.70
   optionText_WP := 0.17
   option_XP := -0.69
   option_YP := 0.58
   option_WP := 0.22
   option_HP := 0.42

   gui__.PopupPos := {}
   textval := "Step 1 is select a Cut on the Left. `n`nStep 2. You'll see a list below of available options. Select one, and click 'Next'.`n`n"
   gui__.optionWiz.Header := gui__.Add("Text", "-Background", textval)
   gui__.optionWiz.Header.SetFont("s18")
   GuiResizer.FormatOpt(gui__.optionWiz.Header, optionText_XP, optionText_YP+0.02, dims.wiz_w-0.05, 0.2)

   gui__.PopupPos.YP := gui__.optionWiz.Header.YP + gui__.optionWiz.Header.HeightP
   gui__.PopupPos.XP := gui__.optionWiz.Header.XP
   gui__.PopupPos.WP := gui__.optionWiz.Header.WidthP
   gui__.optionWiz.Header.GetPos(, &y, &h)

   gui__.optionWiz.Header2 := gui__.Add("Text", "r8 XP+10 -Background", "")
   gui__.optionWiz.Header2.SetFont("s22")
   GuiResizer.FormatOpt(gui__.optionWiz.Header2, optionText_XP, optionText_YP + 0.2, dims.wiz_w - 0.07, 0.2)

   gui__.optionWiz.LB := gui__.Add("ListBox", "", ["Im a listbox"])
   gui__.optionWiz.LB.SetFont("s28")
   GuiResizer.FormatOpt(gui__.optionWiz.LB, optionText_XP, option_YP, dims.wiz_w-0.2, option_HP)

   optionNext_XP := option_XP + option_WP + 0.04 ; 20% from Left Margin
   optionNext_YP := option_YP  ; 45% from Top Margin
   optionNext_WP := option_WP / 2 + 0.03
   optionNext_HP := option_HP / 7

   gui__.optionWiz.Next := gui__.Add("Button", "", "Next")
   gui__.optionWiz.Next.SetFont("s25")
   GuiResizer.FormatOpt(gui__.optionWiz.Next, optionNext_XP+ 0.23, optionNext_YP, optionNext_WP, optionNext_HP)


   gui__.optionWiz.Back := gui__.Add("Button", "", "Go Back")
   gui__.optionWiz.Back.SetFont("s25")
   GuiResizer.FormatOpt(gui__.optionWiz.Back, optionNext_XP+ 0.23, optionNext_YP + optionNext_HP + 0.02, optionNext_WP, optionNext_HP)

   gui__.optionWiz.Restart := gui__.Add("Button", "", "Restart")
   gui__.optionWiz.Restart.SetFont("s25")
   GuiResizer.FormatOpt(gui__.optionWiz.Restart, optionNext_XP+ 0.23, optionNext_YP + optionNext_HP + optionNext_HP + 0.02 + 0.02, optionNext_WP, optionNext_HP)

   gui__.optionWiz.Finished := gui__.Add("Button", "", "Finished")
   gui__.optionWiz.Finished.SetFont("s25")
   GuiResizer.FormatOpt(gui__.optionWiz.Finished, optionNext_XP+ 0.23, optionNext_YP + optionNext_HP * 3 + 0.06, optionNext_WP, optionNext_HP)

   buttonGroup_X := 0.75
   buttonGroup_Y := 0.58
   buttonGroup_W := 0.19
   buttonGroup_H := 0.38

   order_X := buttonGroup_X - 0.03
   order_Y := optionsGroupBox_YP
   order_W := buttonGroup_W + 0.08
   order_H := dims.PrimaryHP

   orderLB_x := order_X + 0.01    ; order_X := 0.55
   orderLB_y := order_Y + 0.04    ; order_Y := 0.47
   orderLB_h := order_H - 0.06    ; order_H := 0.49
   orderLB_w := order_W - 0.02    ; order_W := 0.44
}


/*
   Function: TypeOfAnimalGuiClick
   
   Description:
   This function is called when a control object is clicked in the GUI. It determines the type of animal selected and performs the corresponding action.
   
   Parameters:
   - ctrl: The control object that was clicked.
   - *: Additional parameters (not used in this function).
   
   Global Variables:
   - gui__: The main GUI object.
   
   Returns:
   This function does not return a value.
*/
TypeOfAnimalGuiClick(ctrl, *)
{
   global gui__
   if ctrl.Text = "Beef"
   {
      hideIntro()
      TypeofAnimalMenu(&gui__, "DisplayOrder", "Full Beef", "Half Beef", "Quarter Beef")
      GuiResizer.Now(gui__)
   }
   else
   {
      DisplayOrder(ctrl)
   }
}

hideIntro()
{
   global gui__
   for k, v in gui__.IntroMenu.OwnProps()
   {
      v.Visible := 0
   }
   gui__.IntroMenu := {}
}

DisplayOrder(guiCtrl, *)
{
   global gui__
   hideIntro()
   gui__.Primary.ToggleVisible()
   gui__.order.ToggleVisible()
   gui__.Menu.ToggleVisible()
}

hideOptionsWiz()
{
   for k, v in gui__.optionWiz.OwnProps()
   {
      v.Visible := !v.Visible
   }
}


TabNav(GuiCtrl, *)
{
   global gui__
   if InStr(GuiCtrl.Text, "Order")
   {
      if not gui__.order.VisibleStatus()
      {
         gui__.order.ToggleVisible()
         gui__.optionWiz.ToggleVisible()
         GuiResizer.Now(gui__)
      }
   }
   else
   {
      if not gui__.optionWiz.VisibleStatus()
      {
         gui__.order.ToggleVisible()
         gui__.optionWiz.ToggleVisible()
         GuiResizer.Now(gui__)
      }
   }
}