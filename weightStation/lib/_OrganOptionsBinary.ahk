#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter john whitemore (mmikeww)
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	animalObj := ''
	myGui := OrgansBinary(&animalObj)
	myGui.Show("")
}

class OrgansBinary
{
	static response := ""

	static Call(&animalObj)
	{
		tempGui := constructGui()
		tempGui.Show("")
		darkMode(tempGui)
		OrgansBinary.response := ""
		
		while OrgansBinary.response = ""
			Sleep 100
		animalObj.organs['preference'] := OrgansBinary.response
		tempGui.Destroy()
		
		constructGui()
		{
			myGui := Gui('-DPIScale +AlwaysOnTop')
			myGui.SetFont("s23")
			OrgansNotRequested := myGui.Add("Button", "x22 y32 ", "Organs Not Requested")
			CustomizeOrgans := myGui.Add("Button", "x+50 y32 Section", "Customize Organs")
			ACCEPTOrgans := myGui.Add("Button", "x22 y+20 ", "ACCEPT ALL Organs")
			RejectALLOrgans := myGui.Add("Button", "xs yp ", "Reject ALL Organs")
			OrgansNotRequested.Backcolor('0x62ff00')
			OrgansNotRequested.OnEvent("Click", OnEventHandler)
			CustomizeOrgans.OnEvent("Click", OnEventHandler)
			CustomizeOrgans.Backcolor('0xfff700')
			ACCEPTOrgans.OnEvent("Click", OnEventHandler)
			ACCEPTOrgans.Backcolor('0x005dd8')
			RejectALLOrgans.OnEvent("Click", OnEventHandler)
			myGui.OnEvent('Close', (*) => ExitApp())
			myGui.Title := "Question: Do you want to accept all organs?"
			return myGui
		}

		OnEventHandler(ctrl, *)
		{
			OrgansBinary.response := ctrl.Text
		}
		return OrgansBinary.response
	}

}