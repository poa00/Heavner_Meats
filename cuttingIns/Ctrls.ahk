
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
addToWizHeader(str, multi:=false)
{
   if !multi
      gui_.Wiz.main.Header2.Text := gui_.Wiz.main.Header2.Text "`n - " str ""
   else
      gui_.Wiz.main.Header2.Text := gui_.Wiz.main.Header2.Text "`n`n" str ""
}


/*
This file contains the code for constructing the GUI for the weight station application.
The constructGUI function is responsible for creating the GUI and setting up its event handlers.
It also defines the layout and appearance of various controls within the GUI.
*/
constructGUI(gui_)
{
   global refMeatCuts, dims
   dims := {}
   gui_.OnEvent("Size", GuiReSizer)
   gui_.SetFont("s18 cWhite")
   Primary := { value: False, type: false }
   anchorBoxiesX := 0.02
   listboxTopLeftH := 0.35
   ;TypeofAnimalMenu(&gui_, "TypeOfAnimalGuiClick", "Beef", "Pork", "Lamb", "Other")

   ; Primary Controls
   dims.PrimaryXP := anchorBoxiesX
   dims.PrimaryYP := 0.1
   dims.PrimaryWP := 0.25
   dims.PrimaryHP := 0.87
   gui_.Primary := {}
   dims.NavX := 0.02
   dims.NavY := 0.02
   dims.NavW := 0.22
   dims.NavH := 0.07
   dims.wiz_x := -0.71
   dims.wiz_y := dims.PrimaryYP
   dims.wiz_w := 0.69
   dims.wiz_h := dims.PrimaryHP
   primaryCtrls(&gui_)
   Wizard(&gui_)
   orderReview(&gui_)
   NavMenu(&gui_)

   gui_.backcolor := "121d30"
   gui_.Primary.LV.OnEvent("Click", LB_PrimaryChange)

   return gui_
}


/*
   * Function: NavMenu
   * Description: This function creates tab buttons for navigation in the GUI.
   * Parameters:
   *    - gui_ (object): The GUI object to which the tab buttons will be added.
   * Returns: None
*/
NavMenu(&gui_)
{
   global dims
   gui_.Nav := {}

   ; gui_.Nav.Box := gui_.Add("Text", "Background1b335f", "Navigation")
   ; gui_.Nav.Box.SetFont("s16")
   ; GuiResizer.FormatOpt(gui_.Nav.Box, dims.orderX, dims.PrimaryYP, dims.orderW, .13)
   width := dims.NavW - 0.03
   gui_.Nav.Wiz := gui_.Add("Button", "", "Option Wizard")
   gui_.Nav.Wiz.SetFont("s20 q5", "Arial")
   GuiResizer.FormatOpt(gui_.Nav.Wiz, dims.NavX, dims.NavY, width, dims.NavH)

   gui_.Nav.order := gui_.Add("Button", "", "Order Review")
   gui_.Nav.order.SetFont("s20 q5", "Arial")
   GuiResizer.FormatOpt(gui_.Nav.order, dims.NavX + width + 0.02, dims.NavY, width, dims.NavH)

   gui_.Nav.save := gui_.Add("Button", "", "Save Cutsheet")
   gui_.Nav.save.SetFont("s20 q5", "Arial")
   GuiResizer.FormatOpt(gui_.Nav.save, dims.NavX + width * 2 + 0.02 * 2, dims.NavY, width, dims.NavH)


   gui_.Nav.cancel := gui_.Add("Button", "", "Cancel")
   gui_.Nav.cancel.SetFont("s20 q5", "Arial")
   GuiResizer.FormatOpt(gui_.Nav.cancel, dims.NavX + width * 3 + 0.02 * 3, dims.NavY, width, dims.NavH)

   ButtonStyle(gui_.Nav.Wiz, 0, "info-round")
   ButtonStyle(gui_.Nav.order, 0, "warning-round")
   ButtonStyle(gui_.Nav.save, 0, "success-round")
   ButtonStyle(gui_.Nav.cancel, 0, "critical-round")
   gui_.Nav.Wiz.OnEvent("Click", TabNav)
   gui_.Nav.Order.OnEvent("Click", TabNav)
   gui_.Nav.save.OnEvent("Click", FinalizeCutsheet)
   gui_.Nav.cancel.OnEvent("Click", (*) => Reload())
}

/*
   Function: primaryCtrls

   Description:
   This function creates and configures the primary controls for the GUI.

   Parameters:
   - gui_ (object): The GUI object to which the controls will be added.

   Returns:
   None
*/
primaryCtrls(&gui_)
{
   global refMeatCuts
   gui_.Primary.GB := gui_.Add("GroupBox", "Background162135", "Step 1.")
   gui_.Primary.GB.SetFont("s16")
   GuiResizer.FormatOpt(gui_.Primary.GB, dims.PrimaryXP, dims.PrimaryYP, dims.PrimaryWP, dims.PrimaryHP)

   gui_.Primary.LV := gui_.Add("ListView", "w" 400 "", ["Cut", "Set"])
   gui_.Primary.LV.OnEvent("Click", onFirstListboxChange)
   gui_.Primary.LV.SetFont("s18")
   GuiResizer.FormatOpt(gui_.Primary.LV, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.05, dims.PrimaryWP - 0.02, dims.PrimaryHP - 0.06)
   setRefMap()
   for k in refMeatCuts.keys()
   {
      gui_.Primary.LV.Add(, k)
   }
   gui_.Primary.LV.ModifyCol(1, 150)
   gui_.Primary.LV.ModifyCol(2, 50)
   optionsGroupBox_XP := -0.71
   optionsGroupBox_YP := dims.PrimaryYP
   optionsGroupBox_WP := 0.69
   optionsGroupBox_HP := 0.53
   gui_.Wiz := {}
   dims.wiz_x := optionsGroupBox_XP
   dims.wiz_y := dims.PrimaryYP
   dims.wiz_w := 0.69
}


/*
   Function: Wizard

   Description: This function creates a GUI with various controls for an options wizard.

   Parameters:
      - gui_ (object): The GUI object to which the controls will be added.

   Returns: None
*/
Wizard(&gui_)
{
   global wizT
   wizT := {}
   optionsGroupBox_XP := -0.71
   optionsGroupBox_YP := dims.PrimaryYP + 0.04
   optionsGroupBox_WP := 0.69
   optionsGroupBox_HP := 0.51
   gui_.Wiz.main := {}

   optionText_YP := 0.17
   optionText_XP := -0.70
   optionText_WP := 0.17
   option_XP := -0.69
   option_YP := 0.57
   option_WP := 0.22
   option_HP := 0.42

   ;@@@@@@@@@@@@@@@@@@@@@@@@@@
   ;new control layout params

   instrx := 0.31
   instrY := 0.15
   instrw := 0.25
   instrh := 0.18

   wizT.lbX := 0.59
   wizT.lbY := 0.28
   wizT.lbw := 0.37
   wizT.lbh := 0.61

   ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   gui_.Wiz.main.tab := gui_.Add("Tab3", "Background2f5aa8", ["options", "comments"])
   gui_.Wiz.main.tab.SetFont("s18", "cWhite")
   GuiResizer.FormatOpt(gui_.Wiz.main.tab, wizT.lbx, wizT.lby - 0.01, wizT.lbw, wizT.lbh-0.04)
   ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   
   gui_.Wiz.main.tab.UseTab(1)
   gui_.Wiz.main.LB := gui_.Add("ListBox", "", ["Im a listbox"])
   gui_.Wiz.main.LB.SetFont("s28")
   GuiResizer.FormatOpt(gui_.Wiz.main.LB, wizT.lbX + 0.01, wizT.lbY + 0.06, wizT.lbw - 0.02, wizT.lbh - 0.07)
   
   gui_.Wiz.main.tab.UseTab(2)
   gui_.Wiz.main.comments := gui_.Add("Edit", "+Wrap r5", "")  ; comments
   gui_.Wiz.main.comments.SetFont("s22")
   GuiResizer.FormatOpt(gui_.Wiz.main.comments, wizT.lbX + 0.01, wizT.lbY + 0.06, wizT.lbw - 0.02, wizT.lbh - 0.07)
   
   ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   gui_.Wiz.main.tab.UseTab()
   gui_.Wiz.multi := {}
   gui_.Wiz.multi.skip := 1
   gui_.Wiz.multi.tab := gui_.Add("Tab3", "Background2f5aa8", ["", "", "", ""])
   gui_.Wiz.multi.tab.SetFont("s22", "cWhite")
   GuiResizer.FormatOpt(gui_.Wiz.multi.tab, wizT.lbx, wizT.lby - 0.01, wizT.lbw, wizT.lbh- 0.04)
   gui_.Wiz.multi.LB := Map()
   
   loop 4
   {
      gui_.Wiz.multi.tab.UseTab(A_Index)
      gui_.Wiz.multi.LB[A_Index] := gui_.Add("ListBox", , [])
      GuiResizer.FormatOpt(gui_.Wiz.multi.LB[A_Index], wizT.lbX + 0.01, wizT.lbY + 0.1, wizT.lbw - 0.02, .55)
      gui_.Wiz.multi.LB[A_Index].SetFont("s25")
   }
   
   gui_.Wiz.multi.tab.UseTab()
   
   gui_.PopupPos := {}
   textval := "Step 1. Select a Cut on the Left.`n"
   gui_.Wiz.main.Header := gui_.Add("Text", "-Background", textval)
   gui_.Wiz.main.Header.SetFont("s13")
   GuiResizer.FormatOpt(gui_.Wiz.main.Header, instrx, instry, instrw, instrh)

   ; options := StrReplace("yp" dims.wiz_y " xp" dims.wiz_x " wp" dims.wiz_w " hp" dims.wiz_h, "0.", ".")
   gui_.Wiz.main.GB := gui_.Add("GroupBox", "Background1b335f", "Option Wizard")
   gui_.Wiz.main.GB.SetFont("s18 bold italic")
   GuiResizer.FormatOpt(gui_.Wiz.main.GB, dims.wiz_x, dims.wiz_y, dims.wiz_w, dims.wiz_h)
   
   
   gui_.PopupPos.YP := gui_.Wiz.main.Header.YP + gui_.Wiz.main.Header.HeightP
   gui_.PopupPos.XP := gui_.Wiz.main.Header.XP
   gui_.PopupPos.WP := gui_.Wiz.main.Header.WidthP
   gui_.Wiz.main.Header.GetPos(, &y, &h)
   
   gui_.Wiz.main.Header2 := gui_.Add("Text", "r9 XP+10 -Background", "Waiting for a cut to be selected") ; setOptions : 
   gui_.Wiz.main.Header2.SetFont("s19")
   header2width := (dims.wiz_w - 0.04) / 2
   GuiResizer.FormatOpt(gui_.Wiz.main.Header2, instrx, instry+=.11, instrw, instrh+=0.15)
   
   gui_.Wiz.main.Header3 := gui_.Add("Text", "r9 XP+10 -Background", "Comments:`n")
   gui_.Wiz.main.Header3.SetFont("s16")
   GuiResizer.FormatOpt(gui_.Wiz.main.Header3, instrx, instry+=0.37, instrw, instrh -= 0.04)
   
   optionNext_XP := option_XP + option_WP + 0.04 ; 20% from Left Margin
   optionNext_YP := option_YP  ; 45% from Top Margin
   optionNext_WP := option_WP / 2 + 0.03
   optionNext_HP := option_HP / 7
   
   gui_.Wiz.main.Buttons := {}
   gui_.Wiz.main.Buttons.Next := gui_.Add("Button", "", "Next")
   gui_.Wiz.main.Buttons.Next.SetFont("s25")
   
   buttx := 0
   buttx := wizT.lbX
   butty := .18
   buttw := wizT.lbw / 2 - 0.01
   butth := wizT.lbh / 2 - 0.23
   
   GuiResizer.FormatOpt(gui_.Wiz.main.Buttons.Next, buttx, butty, buttw, butth)
   
   gui_.Wiz.main.Buttons.Confirm := gui_.Add("Button", "", "Confirm")
   gui_.Wiz.main.Buttons.Confirm.SetFont("s25")
   GuiResizer.FormatOpt(gui_.Wiz.main.Buttons.Confirm, buttx+buttw+0.02, butty, buttw, butth)

   gui_.Wiz.main.Buttons.Sausage := gui_.Add("Button", "", "Sausage")
   gui_.Wiz.main.Buttons.Sausage.SetFont("s19")
   GuiResizer.FormatOpt(gui_.Wiz.main.Buttons.Sausage, buttx , .86, buttw, butth)
   
   gui_.Wiz.main.Buttons.Back := gui_.Add("Button", "", "Go Back")
   gui_.Wiz.main.Buttons.Back.SetFont("s20")
   GuiResizer.FormatOpt(gui_.Wiz.main.Buttons.Back, buttx + buttw + 0.02, .86, buttw, butth)
   
   ButtonStyle(gui_.Wiz.main.Buttons.Confirm, 0, "success-round")
   ButtonStyle(gui_.Wiz.main.Buttons.Next, 0, "info-round")
   ButtonStyle(gui_.Wiz.main.Buttons.Sausage, 0, "info-outline")
   ButtonStyle(gui_.Wiz.main.Buttons.Back, 0, "warning-outline")

   gui_.Wiz.main.Buttons.Next.OnEvent("Click", OptNextButton)
   gui_.Wiz.main.Buttons.Sausage.OnEvent("Click", Sausage)
   gui_.Wiz.main.LB.OnEvent("DoubleClick", OptNextButton)
   gui_.Wiz.main.Buttons.Back.OnEvent("Click", OptBackButton)
   gui_.Wiz.main.Buttons.Confirm.OnEvent("Click", ConfirmButtonClick)
   gui_.Wiz.main.comments.OnEvent("Change", changeCommentField)
   
   gui_.Wiz.multi.ToggleVisible(0,1)
   
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
   Function: orderReview

   Description:
   This function creates an order screen GUI with a group box and a list box.
   The group box displays the title "Orders" and the list box displays a list of beef items.
   The list box has an event handler for the "Change" event.

   Parameters:
   - gui_ (object): The GUI object to which the order screen will be added.

   Returns:
   None
*/
orderReview(&gui_)
{
   global dims
   gui_.order := {}
   dims.orderX := gui_.Primary.GB.XP + gui_.Primary.GB.WidthP + 0.02
   dims.orderY := 0.15
   dims.orderW := 0.7
   dims.orderH := 0.83

   gui_.order.buttonBox := gui_.Add("GroupBox", "Background1b335f", "Options")
   gui_.order.buttonBox.SetFont("s16")
   GuiResizer.FormatOpt(gui_.order.buttonBox, dims.PrimaryXP, dims.PrimaryYP, dims.PrimaryWP, dims.PrimaryHP)

   gui_.order.Recipient := gui_.Add("Edit", "Background1b335f", "Select Recipient")
   GuiResizer.FormatOpt(gui_.order.Recipient, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.05, dims.PrimaryWP - 0.03, 0.06)
   gui_.order.Recipient.Enabled := 0

   gui_.order.RecipientButton := gui_.Add("Button", "Background1b335f", "Select Recipient")
   GuiResizer.FormatOpt(gui_.order.RecipientButton, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.12, dims.PrimaryWP - 0.03, 0.08)
   ButtonStyle(gui_.order.RecipientButton, 0, "info-outline")

   gui_.order.Producer := gui_.Add("Edit", "Background1b335f", "Producer")
   GuiResizer.FormatOpt(gui_.order.Producer, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.25, dims.PrimaryWP - 0.03, 0.06)
   gui_.order.Producer.enabled := 0
   gui_.order.ProducerButton := gui_.Add("Button", "Background1b335f", "Producer")
   GuiResizer.FormatOpt(gui_.order.ProducerButton, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.32, dims.PrimaryWP - 0.03, 0.08)

   gui_.order.Changeanimal := gui_.Add("Button", "Background1b335f", "Change animal amount")
   GuiResizer.FormatOpt(gui_.order.Changeanimal, dims.PrimaryXP + 0.01, dims.PrimaryYP + 0.45, dims.PrimaryWP - 0.03, 0.08)
   ButtonStyle(gui_.order.Changeanimal, 0, "success-round")
   ButtonStyle(gui_.order.RecipientButton, 0, "info-round")
   ButtonStyle(gui_.order.ProducerButton, 0, "warning-round")

   gui_.order.tabs := gui_.Add("Tab3", "Background1b335f", ["Order", "Comments"])
   gui_.order.tabs.SetFont("s22")
   GuiResizer.FormatOpt(gui_.order.tabs, dims.wiz_x, dims.wiz_y + 0.02, dims.wiz_w, dims.wiz_h - 0.02)

   gui_.order.tabs.UseTab(1)
   gui_.order.LV := gui_.Add("ListView", "w" 400 " r1 +Grid", ["", "", "", "", "", "", ""])
   gui_.order.LV.Opt("+Report +0x4000")
   gui_.order.LV.SetFont("s18")
   GuiResizer.FormatOpt(gui_.order.LV, dims.wiz_x + 0.01, dims.wiz_y + 0.10, (dims.wiz_w - 0.04), dims.wiz_h - 0.05)
   
   gui_.order.tabs.UseTab(2)
   gui_.order.comments := gui_.Add("ListView", "w" 400 " r1 +Grid", ["", ""])
   gui_.order.comments.Opt("+Report +0x4000")
   gui_.order.comments.SetFont("s18")
   GuiResizer.FormatOpt(gui_.order.comments, dims.wiz_x + 0.01, dims.wiz_y + 0.10, (dims.wiz_w - 0.04), dims.wiz_h - 0.05)
   gui_.order.comments.ModifyCol(1, 250)
   gui_.order.comments.ModifyCol(2, 700)
   width := 215
   gui_.order.tabs.UseTab()

   gui_.order.RecipientButton.OnEvent("Click", SelectRecipient)
   gui_.order.Changeanimal.OnEvent("Click", setAnimalsfromOrder)

   refMeatCut := Map()
   refMeatCut := Json.Load(FileRead(A_ScriptDir "\beef.json"))
   for k in refMeatCut.keys()
   {
      gui_.order.LV.Add(, k)
      gui_.order.LV.ModifyCol(A_Index, width := width - 20)
      gui_.order.comments.Add(, k)
   }

   orderSummaryWidth := (dims.orderW - 0.02) / 2

}

commentField(&gui_)
{
   if gui_.HasProp("Comment")
      return 
   gui_.Comment := {}
   gui_.Comment.edit := gui_.Add("Edit", "r1")
   GuiResizer.Duplicate(gui_.Comment.edit, gui_.Wiz.main.LB)
   
   gui_.Comment.Confirm := gui_.Add("Button", "", "Confirm")
   GuiResizer.Duplicate(gui_.Comment.Confirm, gui_.Wiz.main.Buttons.Next)

   gui_.Comment.Cancel := gui_.Add("Button", "", "Cancel")
   GuiResizer.Duplicate(gui_.Comment.Cancel, gui_.Wiz.main.Buttons.Confirm)

   gui_.Comment.Header2 := gui_.Add("Text", "", "Add comment before continuing.")
   gui_.Comment.Header2.SetFont("s30")
   GuiResizer.Duplicate(gui_.Comment.Header2, gui_.Wiz.main.Header2)
   gui_.Comment.Header2.Opt("Background313131")

   gui_.Comment.Confirm.OnEvent("Click", commentConfirmClick)
   gui_.Comment.Cancel.OnEvent("Click", commentCancelClick)
   setBackgroundColors()
   gui_.Comment.edit.Opt("Background070b11")
   gui_.Comment.edit.SetFont("cWhite")
}


hideIntro()
{
   global gui_
   for k, v in gui_.IntroMenu.OwnProps()
   {
      v.Visible := 0
   }
   gui_.IntroMenu := {}
}

DisplayOrder(guiCtrl, *)
{
   global gui_
   hideIntro()
   gui_.Primary.ToggleVisible(0)
   gui_.order.ToggleVisible(1)
   gui_.Nav.ToggleVisible(1)
}

hideOptionsWiz()
{
   for k, v in gui_.Wiz.main.OwnProps()
   {
      v.Visible := !v.Visible
   }
}