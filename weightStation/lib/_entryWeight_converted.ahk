#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>
#Include <AHKpy>
/*
__New(&G, wait := True)

Creates a new instance of the __New class.

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
	static animal := false
	
	__New(&G, wait := True)
	{
		selectSpecies.finished := false
		if G.HasOwnProp('selectSpeciesG')
			G.ToggleVisible(0), G.selectSpeciesG.ToggleVisible(1)
		else
			selectSpecies.newGui(&G)
		if wait
		{
			while !selectSpecies.finished
				Sleep 100
			this.animalObj := Animal(selectSpecies.animal)
		}
	}
	static newGui(&G)
	{
		G.selectSpeciesG := {}
		G.SetFont("s25 cWhite")
		G.selectSpeciesG.grpbx := G.Add("GroupBox", "", "GroupBox")
		G.selectSpeciesG.grpbx.SetFont('s12 cWhite', 'cWhite')
		pushToResizer(G.selectSpeciesG.grpbx, 0.03, 0.03, 0.94, 0.81)
		G.selectSpeciesG.Cow := G.Add("Button", "", "Cow")
		G.selectSpeciesG.Cow.OnEvent("Click", (*) => selectSpecies.animalClick(G.selectSpeciesG.Cow))
		pushToResizer(G.selectSpeciesG.Cow, 0.05, 0.15, 0.28, 0.21)
		G.selectSpeciesG.Pig := G.Add("Button", "", "Pig")
		G.selectSpeciesG.Pig.OnEvent("Click", (*) => selectSpecies.animalClick(G.selectSpeciesG.Pig))
		pushToResizer(G.selectSpeciesG.Pig, 0.36, 0.15, 0.28, 0.21)
		G.selectSpeciesG.Lamb := G.Add("Button", "", "Lamb")
		G.selectSpeciesG.Lamb.OnEvent("Click", (*) => selectSpecies.animalClick(G.selectSpeciesG.Lamb))
		pushToResizer(G.selectSpeciesG.Lamb, 0.65, 0.15, 0.28, 0.21)
		G.selectSpeciesG.ToggleVisible(1)
		GuiResizer.Now(G)
		Darkmode(G)
	}
	static animalClick(ctrl, *)
	{
		selectSpecies.animal := ctrl.Text
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
	selectSpecies(&wsGUI)
	wsGUI.Show("w620 h567")
}