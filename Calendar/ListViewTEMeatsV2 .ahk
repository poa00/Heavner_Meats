#SingleInstance Force
#Requires Autohotkey v2
;AutoGUI 2.5.8 creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;Easy_AutoGUI_for_AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Gui()
myGui.Opt("-DPIScale")
myGui.SetFont("s16", "Arial")
myGui.BackColor := "0xBCBCBC"
ogcButtonNext := myGui.Add("Button", "x1104 y880 w236 h59", "Next")
ogcButtonBack := myGui.Add("Button", "x1104 y792 w236 h59", "Back") ; Opt("BackgroundBCBCBC")
ogcButtonRemove := myGui.Add("Button", "x1104 y704 w236 h59", "Remove")
ogcButtonNext.Opt("Backgroundababab")
ogcButtonBack.Opt("Background7f7f7f")
ogcButtonRemove.Opt("Background939393")

myGui.SetFont("s16")
animalBox := myGui.Add("ListBox", "x24 y24 w139 h292", ["COW", "PIG", "LAMB"])
cutsBox := myGui.Add("ListBox", "x224 y24 w141 h292", []) ; "<< Select an Animal"
subCut := myGui.Add("ListBox", "x416 y24 w283 h292", ["<< Select a Cut"])

weight := myGui.Add("ListBox", "x720 y96 w189 h220", [])
thickness := myGui.Add("ListBox", "x936 y96 w159 h220", [])

allOptions := [animalBox, cutsBox, subCut, weight, thickness]

cutArray := []
for cut, list in pigProp() {
	cutArray.Push(cut)
}
cutsBox.Add(cutArray)

ogcButtonADD := myGui.Add("Button", "x1120 y270 w171 h45", "ADD +")
ogcButtonADD.Opt("Backgroundababab")

myGui.SetFont("s16", "Arial")
MenuLV := myGui.Add("ListView", "x24 y632 w1065 h308", ["Animal", "Cut", "Sub-Cut", "Weight", "Thickness"])
myGui.SetFont("s12")
myGui.Add("GroupBox", "x8 y608 w1341 h343", "Menu")
myGui.SetFont("s16", "Arial")
myGui.SetFont("s12")
myGui.Add("GroupBox", "x8 y1 w1341 h343", "Cuts")
myGui.SetFont("s16", "Arial")
myGui.SetFont("s20")
myGui.SetFont("s16", "Arial")
myGui.SetFont("s15 cPurple", "Consolas")
myGui.Add("Text", "x176 y152 w31 h23 +0x200", ">>")
myGui.SetFont("s16", "Arial")
myGui.SetFont("s15 cPurple", "Consolas")
myGui.Add("Text", "x376 y152 w31 h23 +0x200", ">>")
myGui.SetFont("s16", "Arial")
myGui.Add("Text", "x728 y48 w120 h23 +0x200", "Weight")
myGui.Add("Text", "x941 y46 w120 h23 +0x200", "Thickness")

ogcButtonNext.OnEvent("Click", OnEventHandler)
cutsBox.OnEvent("Change", cutsBoxClick)
subCut.OnEvent("Change", subCutClick)
ogcButtonBack.OnEvent("Click", OnEventHandler)
ogcButtonRemove.OnEvent("Click", removeItem)
ogcButtonADD.OnEvent("Click", ogcButtonADD_Click)
 
myGui.OnEvent('Close', (*) => ExitApp())
myGui.Title := "cuttingSheatExample.ahk (Clone) (Clone)"
myGui.Show("w1359 h961")

removeItem(*){
	MenuLV.Delete(MenuLV.GetNext())
}

/*
weight := myGui.Add("ListBox", "x720 y96 w189 h220", weightArray)
thickness := myGui.Add("ListBox", "x936 y96 w159 h220", thicknessArray)
animalBox 
cutsBox
subCut
*/
cutsBoxClick(*){
	for cut, subCutlist in pigProp() {
		if (cut = cutsBox.Text) {
			subCut.Delete
			for i in subCutlist {
				subCut.Add([i])
			}
			break
		}
	}
	weight.Delete
	thickness.Delete
}

subCutClick(*){
	R := Random(1, 3)
	weight.Delete
	thickness.Delete
	if (R = 1) {
		weight.Add(["1lb-2lb", "3lb-4lb", "1lb-2lb", "3lb-4lb"])
		thickness.Add(["1/2`"", "1`""])
	}
	if (R = 2) {
		weight.Add(["1lb-2lb", "3lb-4lb", "5lb-10lb", "10lb-40lb"])
		thickness.Add(["1/4`"", "1/2`""])
	}
	if (R = 3) {
		weight.Add(["2oz", "4oz", "1lb-2lb", "3lb-4lb"])
		thickness.Add(["1`"", "2`""])
	}
}


/*
weight := myGui.Add("ListBox", "x720 y96 w189 h220", weightArray)
thickness := myGui.Add("ListBox", "x936 y96 w159 h220", thicknessArray)
animalBox 
cutsBox
subCut
*/
ogcButtonADD_Click(*){
 	MenuLV.Add(, animalBox.Text , cutsBox.Text, subcut.Text, weight.Text "    ", thickness.Text "    ")
	MenuLV.ModifyCol(3)
	MenuLV.ModifyCol(2)
	MenuLV.ModifyCol(4, "200 Auto")

	subCut.Delete
	weight.Delete
	thickness.Delete
	subCut.Add(["<< Select a Cut"])
}
OnEventHandler(*)
{
	ToolTip("Click! This is a sample action.`n"
	. "Active GUI element values include:`n"  
	. "ogcButtonNext => " ogcButtonNext.Text "`n" 
	. "ogcButtonBack => " ogcButtonBack.Text "`n" 
	. "ogcButtonRemove => " ogcButtonRemove.Text "`n", 77, 277)
	SetTimer () => ToolTip(), -3000 ; tooltip timer
}

pigProp(){
	return cuts := Map(
		"SHOULDER", ["Picnic Roast", "Boston Butt Boneless", "Boston Butt Bone-In", "Back Bone", "JOWL" ],
		"LOIN", ["Pork Chops","Boneless Loin Roast","Boneless Loin Slices","Bone-In Loin Roast","Fish Loin"],
		"SIDE", ["Ribs","Side Meat-Whole","Side Meat Sliced","Bacon"],
		"HAMS", ["Fresh Ham: Whole", "Fresh Ham: Roast", "Ham Steaks", "Smoked Ham", "Fresh Ham: Roast"]
	)
}

/*
LVMaker(storageLV){
	storageLV.Add(, "Picnic Roast", "Whole", "Yes", "Phat", "500lbs", "20", "No")
	storageLV.Add(, "Boston Butt Boneless", "Steak", "No", "Phat", "1500lbs", "20", "Yes")
	storageLV.Add(, "Boneless Picnic Roast", "Whole", "Yes", "Phat", "200lbs", "20", "No")
	storageLV.Add(, "Butt Roast", "Whole", "Yes", "Phat", "500lbs", "20", "No")
	storageLV.ModifyCol()
}
*/