#Include GuiResizer.ahk ; Include the GuiResizer library

; Create a list GUI and set its options
guiList := Gui(, "Test - List"), guiList.Opt("+Resize +MinSize250x150")

; Assign the GuiReSizer function to handle size changes for this Gui
guiList.OnEvent("Size", GuiReSizer)

; Define buttons within the list GUI
guiList.Button := {} ; required because you are going to have Button sub-definitions, i.e., more than one Button
guiList.Button.One := guiList.Add("Button", "Default", "One")
guiList.Button.One.X := 10 ; 10 from Left Margin

; Define another button and set its position relative to the top-left corner
guiList.Button.Two := guiList.Add("Button", "yp", "Two")
guiList.Button.Two.X := 20 ; 20 from Left Margin
guiList.Button.Two.XP := 0.2 ; 20% from Left Margin

; Define another button and set its position relative to the right edge
guiList.Button.Three := guiList.Add("Button", "yp", "Three")
guiList.Button.Three.XP := -0.4 ; 40% from Right Margin

; Define another button and set its position relative to the right edge
guiList.Button.Four := guiList.Add("Button", "yp", "Four")
guiList.Button.Four.X := -10 ; -10 from Right Margin
guiList.Button.Four.OriginXP := 1 ; OriginX is 100% of Width of control, i.e., Right Side

; Create a ListView within the list GUI
guiList.ListView := guiList.Add("ListView", "+Grid -Multi xm r20 w750", ["This", "That", "Other"])

; Call the custom function ListView_Columns to adjust column width
guiList.ListView.Function := ListView_Columns

; Set the ListView's position and size relative to the GUI
guiList.ListView.Width := -10 ; 10 from Left Margin
guiList.ListView.HeightP := -0.60 ; 60% from Bottom Margin

; Create a GroupBox within the list GUI
guiList.GroupBox := guiList.Add("GroupBox", , "Boxxie")
guiList.GroupBox.XP := 0.20 ; 20% from Left Margin
guiList.GroupBox.YP := 0.45 ; 45% from Top Margin
guiList.GroupBox.WidthP := -0.50 ; Right Edge maintain 50% from Right Margin
guiList.GroupBox.HeightP := -0.30 ; Bottom Edge maintain 30% from Bottom Margin

; Create a simple edit control within the list GUI
SimpleNameForEdit := guiList.Add("Edit", , "In the Box")

; Set position and size using GuiReSizer.Opt() method
GuiReSizer.Opt(SimpleNameForEdit, "oCM xp.35 yp.575 y3")

; Define additional buttons with various positioning options
guiList.Button.TopLeft := guiList.Add("Button", "Default", "TopLeft")
guiList.Button.TopLeft.XP := 0.20 ; 20% from Left Margin
guiList.Button.TopLeft.YP := 0.70 ; 70% from Top Margin
guiList.Button.TopLeft.WidthP := 0.20 ; 20% Width of Gui Width
guiList.Button.TopLeft.Height := 20 ; 20 Height of Gui Height

; ... (Continue defining buttons with various positioning options)

; Create a custom function to be called for ListView_Columns
ListView_Columns(CtrlObj, GuiObj)
{
    CtrlObj.ModifyCol(3, "AutoHdr")
}

; Create a tab GUI and set its options
guiTab := Gui(, "Tab 1"), guiTab.Opt("+Resize +MinSize250x150")

; Assign the GuiReSizer function to handle size changes for this Gui
guiTab.OnEvent("Size", GuiReSizer)

; Create a text control within the tab GUI
guiTab.Text := guiTab.Add("Text", , "Tabs ->")
guiTab.Text.XP := 0.02 ; 2% from Left Margin
guiTab.Text.YP := 0.35 ; 35% from Left Margin

; Create a tab control within the tab GUI
guiTab.Tab := guiTab.Add("Tab3", "x100 y100 w500 h500", ["General", "View", "Settings"])
guiTab.Tab.XP := 0.25 ; 25% from Left Margin
guiTab.Tab.YP := 0.35 ; 35% from Top Margin
guiTab.Tab.C := true ; Force Redraw every time with this GUI (usually not needed)
guiTab.Tab.W := -10 ; Adjust Width to maintain 10 from Right Margin
guiTab.Tab.H := -10 ; Adjust Height to maintain 10 from Bottom Margin

; ... (Continue defining buttons within the tab GUI)

; Show the list GUI and tab GUI
guiList.Show("x10 y10 w500 h300")
guiTab.Show("x1000 y100")

; Exit the script when the Escape key is pressed
Esc:: ExitApp
