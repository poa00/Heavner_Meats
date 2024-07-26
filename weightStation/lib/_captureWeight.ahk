#Requires Autohotkey v2
#SingleInstance force
#Include <GuiReSizer>

/**
 * Function: Call
 * 
 * Description:
 * This function captures the weight of an animal using the specified window handle and animal object. 
 * It can optionally wait for the weight capture to finish before returning.
 * 
 * @param {object} G - The window handle object.
 * @param {object} animalObj - The animal object.
 * @param {boolean} [wait=true] - Optional. Specifies whether to wait for the weight capture to finish. Default is True.
 * @returns {object} The updated animal object with the captured weight.
 * 
 * @example
 * ```
 * captureWeight.Call(&G, &animalObj, true)
 * ```
 */
class captureWeight
{
	static finished := false
	static hwnd := 0
	static animalObj := {}
	
	/**
		 * Function: Call
		 *
		 * Description:
		 * This function captures the weight of an animal using the specified window handle and animal object. 
		 * It can optionally wait for the weight capture to finish before returning.
		 *
		 * @param {object} G - The window handle object.
		 * @param {object} animalObj - The animal object.
		 * @param {boolean} [wait=true] - Optional. Specifies whether to wait for the weight capture to finish. Default is True.
		 * @returns {object} The updated animal object with the captured weight.
		 *
		 * @example
		 * ```
		 * captureWeight.Call(&G, &animalObj, true)
		 * ```
		 */
	static Call(&G, &animalObj, wait := True)
	{
		captureWeight.hwnd := G.hwnd
		captureWeight.animalObj := animalObj
		captureWeight.finished := false
		if G.HasOwnProp('captureWeight')
			captureWeight.reloadChild(&G, &animalObj)
		else
			captureWeight.constructG(&G, &animalObj)
		if wait
		{
			while !captureWeight.finished
				Sleep 100
		}
		animalObj := captureWeight.animalObj
		G.ToggleVisible(0)
		return captureWeight.animalObj
	}
	static constructG(&G, &animalObj)
	{ 
		G.ToggleVisible(0)
		G.LiveWeight := {}
		G.OnEvent("Size", GuiReSizer)
		G.LiveWeight.header := G.Add("Text", "", "Live Weight")
		pushToResizer(G.LiveWeight.header, 0.04, 0.03, 0.49, 0.39)
		G.SetFont('s44 cBlack')
		G.LiveWeight.weightField := G.Add("Edit", "", "____ . _")
		G.LiveWeight.weightField.Default := "____._"
		G.LiveWeight.weightField.SetFont('cBlack')
		G.LiveWeight.weightField.SetFont('s74 ', 'Arial')
		G.LiveWeight.weightField.Enabled := false
		pushToResizer(G.LiveWeight.weightField, 0.04, 0.18, 0.60, 0.21)
		G.LiveWeight.Reset := G.Add("Button", "", "Reset")
		pushToResizer(G.LiveWeight.Reset, 0.48, 0.43, 0.43, 0.24)
		G.LiveWeight.Capture := G.Add("Button", "", "Capture (continue)").OnEvent('Click', (this, params*) => finished(this, animalObj, params*))
		pushToResizer(G.LiveWeight.Capture, 0.04, 0.43, 0.40, 0.24)
		GuiResizer.Now(G)

		pushToResizer(ctrl, xp, yp, wp, hp)
		{
			ctrl.xp := xp
			ctrl.yp := yp
			ctrl.wp := wp
			ctrl.hp := hp
		}
		finished(animalObj, params*)
		{
			captureWeight.weight := G.LiveWeight.weightField.Value
			captureWeight.finished := true
		}
	}
	static reloadChild(&G)
	{
		
	}
	class captureObj 
	{
		__New()
		{
			
		}
	}
}

