


Primary := {}
Primary.value := 0
PrimarySelect := {}
PrimarySelect.value := ""

Opt := {}
display := {}
OptionChain := Map()
OrderMap := Map()
for key in BeefMap.keys()
{
    OrderMap.Set(key, [])
}
combinedOptions := ""
specialMenu := {}
x := SysGet(16)
y := SysGet(17)

anchorBoxiesX := 0.02
listboxTopLeftH := 0.35
darkModeColor := "Black"
Opt1Selection := ""
; * Function: listBoxUnselect
; * Description: Resets the selection state for list boxes.

deleteLB(params*)
{
    for ctrl in params
    {
        ctrl.Choose(0)
        ctrl.Delete
    }
}

/*
    :param str: The string to shorten.
    :return: The shortened string.

    if StrLen(str) > 10
        return SubStr(str, 1, 10) "... Options"
*/
ShortenKey(str)
{
    if StrLen(str) > 10
        return SubStr(str, 1, 12) "... Options"
    Else
        return str " Options"
}



#Include requests\CreateImageButton.ahk
#Include requests\UseGDIP.ahk 