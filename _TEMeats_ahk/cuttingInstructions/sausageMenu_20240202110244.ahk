
#Requires Autohotkey v2
#SingleInstance Force
#Include <darkMode>
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2
class Animal extends Object
{
	MakeSound()
	{
		MsgBox "this animal makes a sound"
	}
}
class Dog extends Animal
{
	MakeSound()
	{
		MsgBox "hello"
	}
}

dogObj := Dog.MakeSound
dogObj.MakeSound() ; Output: Woof! Woof!