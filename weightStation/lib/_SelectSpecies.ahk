#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>
#Include <AHKpy>
/**
__New(&G, wait := True)

3 button option for species.

Parameters:
- &G: A reference to the G object.
- wait (optional): Specifies whether to wait for the selectSpecies process to finish before returning.

Returns:
- If wait is True, returns an Animal object based on the selected species.

Example usage:
__New(&G)
__New(&G, False)
*/
class selectSpecies
{
	static finished := false
	static hwnd := 0
	static species := false
	static animalObj := {}
	
	static Call(&G, wait := True)
	{
		selectSpecies.finished := false
		if wsGUI.HasOwnProp('selectSpeciesG')
			wsGUI.ToggleVisible(0), G.selectSpeciesG.ToggleVisible(1)
		else
			selectSpecies.newGui(&G)
		if wait
		{
			while !selectSpecies.finished
				Sleep 100
			return animal.selectSpecies(selectSpecies.species)
		}
	}
	static newGui(&G)
	{
		G.selectSpeciesG := {}
		G.SetFont("s45 cWhite")
		G.selectSpeciesG.grpbx := G.Add("GroupBox", "", "GroupBox")
		G.selectSpeciesG.grpbx.SetFont('s12 cWhite', 'cWhite')
		pushToResizer(G.selectSpeciesG.grpbx, 0.03, 0.03, 0.94, 0.81)
		G.selectSpeciesG.Cow := G.Add("Button", "", "Cow").BackColor("0xd0db00")
		G.selectSpeciesG.Cow.OnEvent("Click", (*) => selectSpecies.animalClick(G.selectSpeciesG.Cow))
		pushToResizer(G.selectSpeciesG.Cow, 0.05, 0.15, 0.28, 0.21)
		G.selectSpeciesG.Pig := G.Add("Button", "", "Pig").BackColor("0x77ff00")
		G.selectSpeciesG.Pig.OnEvent("Click", (*) => selectSpecies.animalClick(G.selectSpeciesG.Pig))
		pushToResizer(G.selectSpeciesG.Pig, 0.35, 0.15, 0.28, 0.21)
		G.selectSpeciesG.Lamb := G.Add("Button", "", "Lamb").BackColor("0xed7308")
		G.selectSpeciesG.Lamb.OnEvent("Click", (*) => selectSpecies.animalClick(G.selectSpeciesG.Lamb))
		pushToResizer(G.selectSpeciesG.Lamb, 0.65, 0.15, 0.28, 0.21)
		G.selectSpeciesG.ToggleVisible(1)
		GuiResizer.Now(G)
		Darkmode(G)
	}
	static animalClick(ctrl, *)
	{
		selectSpecies.species := ctrl.Text
		selectSpecies.finished := true
	}
}

pushToResizer(ctrl, xp, yp, wp, hp)
{
	ctrl.xp := xp
	ctrl.yp := yp
	ctrl.wp := wp
	ctrl.hp := hp
}

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	wsGUI := {}
	wsGUI := Gui("-DPIScale +Resize +MinSize850x500")
	wsGUI.OnEvent("Size", GuiResizer)
	wsGUI.Show("w620 h567")
}