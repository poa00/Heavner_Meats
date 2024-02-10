#Include <request>
#Include <JSONS>
#Include <JSON>
#SingleInstance Force
#Requires Autohotkey v2.0

Msgbox(Json.Dump(x := {j:"2",w:1}))

m := Map("cut", "beef", "price", 100)
requests.appName:= "cutsheets"
requests.tier := 1
Msgbox Jsons.Dumps(y := requests.PostUrl("search", x := Map('event', 1)), 2)
 