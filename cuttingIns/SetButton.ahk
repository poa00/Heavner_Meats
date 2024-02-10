﻿DetectHiddenWindows("off")

/*
    Class: StyleButton

    Description:
    This class defines a set of functionalities for configuring and styling buttons. Combining GuiResizer's
    Responsive design and accounting for size changes while applying styles to buttons.

    Requires:
    1. CreateImageButton.ahk
    2. UseGDIP.ahk
    3. GuiResizer.ahk

    Example:
    ButtonOK := myGui.Add("Button", "", "&OK")
    SetButton(ButtonOK, 0, "success") ; success being a map key in IBStyles, any style map should do. 

    Class Functions:
    1. Call(ctrl, offset, style)
        ; see CreateImageButton.ahk for more information
        This function handles the button call and applies styling based on parameters. It gets the position of the button
        and pushes the set function with certain parameters to funcArray based on the button's width and height.

    2. Set(ctrl, style, offset, isEvent?)
       This function sets the button's configuration. It gets the button's position, sets the control size in a map,
       and styles the button by calling the myStyleMap function.

    3. enumButtons(*)
       This function enumerates through the buttons, resets the error flag, and runs each function in the funcArray.

    Nested Functions:
    1. myStyleMap(ctrl, offset, style)
       This defined function styles the button by calling the CreateImageButton function with certain parameters.
*/
class ButtonStyle
{
    static err := 0
    static buttons := []
    
    static Call(ctrl, offset, style)
    {
        ctrl.GetPos(, , &w, &h)
        ButtonStyle.buttons.Push({ctrl: ctrl, offset: offset, style: style, w: w, h: h})
        ctrl.Gui.OnEvent("Size", ButtonStyle.enumButtons)
        if w != 0 && h != 0 && WinActive(ctrl.Gui.hwnd)
        {
            ButtonStyle.Set(ButtonStyle.buttons[ButtonStyle.buttons.Length], offset, style)
        }
    }

    static Set(btn, offset, style)
    {
        btn.ctrl.Gui.GetPos(, , &w, &h)

        if h = 0 or w = 0 or !WinActive(btn.ctrl.Gui.hwnd)
        {
            return
        }
        btn.ctrl.GetPos(, , &w, &h)
        if btn.w < w or btn.h < h
        {
            btn.w := w
            btn.h := h
            btn.ctrl.Opt("w" w " h" h)
        }
        
        UseGDIP()
        if btn.ctrl.gui
            myStyleMap(btn.ctrl, offset, style)
    }

    static enumButtons(*)
    {
        for btn in ButtonStyle.buttons
        {
            ButtonStyle.set(btn, btn.offset, btn.style)
        }
    }
}

myStyleMap(ctrl, offset, style) => CreateImageButton(ctrl, offset, IBStyles[style]*)


IBStyles := Map()
; credit to jNizM
; https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75  

IBStyles["info"] := [[0x80C6E9F4, , , 0, 0x8046B8DA, 1], [0x8086D0E7, , , 0, 0x8046B8DA, 1], [0x8046B8DA, , , 0, 0x8046B8DA, 1], [0xFFF0F0F0, , , 0, 0x8046B8DA, 1]]
IBStyles["success"] := [[0x80C6E6C6, , , 0, 0x805CB85C, 1], [0x8091CF91, , , 0, 0x805CB85C, 1], [0x805CB85C, , , 0, 0x805CB85C, 1], [0xFFF0F0F0, , , 0, 0x805CB85C, 1]]
IBStyles["warning"] := [[0x80FCEFDC, , , 0, 0x80F0AD4E, 1], [0x80F6CE95, , , 0, 0x80F0AD4E, 1], [0x80F0AD4E, , , 0, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 0, 0x80F0AD4E, 1]]
IBStyles["critical"] := [[0x80F0B9B8, , , 0, 0x80D43F3A, 1], [0x80E27C79, , , 0, 0x80D43F3A, 1], [0x80D43F3A, , , 0, 0x80D43F3A, 1], [0xFFF0F0F0, , , 0, 0x80D43F3A, 1]]

IBStyles["info-outline"] := [[0xFFF0F0F0, , , 0, 0x8046B8DA, 1], [0x80C6E9F4, , , 0, 0x8046B8DA, 1], [0x8086D0E7, , , 0, 0x8046B8DA, 1], [0xFFF0F0F0, , , 0, 0x8046B8DA, 1]]
IBStyles["success-outline"] := [[0xFFF0F0F0, , , 0, 0x805CB85C, 1], [0x80C6E6C6, , , 0, 0x805CB85C, 1], [0x8091CF91, , , 0, 0x805CB85C, 1], [0xFFF0F0F0, , , 0, 0x805CB85C, 1]]
IBStyles["warning-outline"] := [[0xFFF0F0F0, , , 0, 0x80F0AD4E, 1], [0x80FCEFDC, , , 0, 0x80F0AD4E, 1], [0x80F6CE95, , , 0, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 0, 0x80F0AD4E, 1]]
IBStyles["critical-outline"] := [[0xFFF0F0F0, , , 0, 0x80D43F3A, 1], [0x80F0B9B8, , , 0, 0x80D43F3A, 1], [0x80E27C79, , , 0, 0x80D43F3A, 1], [0xFFF0F0F0, , , 0, 0x80D43F3A, 1]]

IBStyles["info-round"] := [[0xff91d2ff, , , 8, 0xff46B8DA, 1], [0xff2596be, , , 8, 0xff46B8DA, 1], [0xff090f33, , , 8, 0x8046B8DA, 1], [0xff19225b, , , 8, 0x8046B8DA, 1]]
IBStyles["success-round"] := [[0x80C6E6C6, , , 8, 0x805CB85C, 1], [0x8091CF91, , , 8, 0x805CB85C, 1], [0x805CB85C, , , 8, 0x805CB85C, 1], [0xFFF0F0F0, , , 8, 0x805CB85C, 1]]
IBStyles["warning-round"] := [[0x80FCEFDC, , , 8, 0x80F0AD4E, 1], [0x80F6CE95, , , 8, 0x80F0AD4E, 1], [0x80F0AD4E, , , 8, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 8, 0x80F0AD4E, 1]]
IBStyles["critical-round"] := [[0x80F0B9B8, , , 8, 0x80D43F3A, 1], [0x80E27C79, , , 8, 0x80D43F3A, 1], [0x80D43F3A, , , 8, 0x80D43F3A, 1], [0xFFF0F0F0, , , 8, 0x80D43F3A, 1]]

IBStyles["info-outline-round"] := [[0xFFF0F0F0, , , 8, 0x8046B8DA, 1], [0x80C6E9F4, , , 8, 0x8046B8DA, 1], [0x8086D0E7, , , 8, 0x8046B8DA, 1], [0xFFF0F0F0, , , 8, 0x8046B8DA, 1]]
IBStyles["success-outline-round"] := [[0xFFF0F0F0, , , 8, 0x805CB85C, 1], [0x80C6E6C6, , , 8, 0x805CB85C, 1], [0x8091CF91, , , 8, 0x805CB85C, 1], [0xFFF0F0F0, , , 8, 0x805CB85C, 1]]
IBStyles["warning-outline-round"] := [[0xFFF0F0F0, , , 8, 0x80F0AD4E, 1], [0x80FCEFDC, , , 8, 0x80F0AD4E, 1], [0x80F6CE95, , , 8, 0x80F0AD4E, 1], [0xFFF0F0F0, , , 8, 0x80F0AD4E, 1]]
IBStyles["critical-outline-round"] := [[0xFFF0F0F0, , , 8, 0x80D43F3A, 1], [0x80F0B9B8, , , 8, 0x80D43F3A, 1], [0x80E27C79, , , 8, 0x80D43F3A, 1], [0xFFF0F0F0, , , 8, 0x80D43F3A, 1]]

#Include <CreateImageButton>
#Include <UseGDIP>