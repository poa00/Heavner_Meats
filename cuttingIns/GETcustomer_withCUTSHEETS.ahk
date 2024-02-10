#Include <request>
#Include <JSONS>
#Include <JSON>
#SingleInstance Force
#Requires Autohotkey v2.0

;Msgbox(Json.Dump(x := {j:"2",w:1}))

m := Map("cut", "beef", "price", 100)

;Cutsheets by customer
requests.appName:= "cutsheets"
requests.tier := 1
Msgbox Jsons.Dumps(y := requests.PostUrl("search", x := Map('producer', 76)), 0) ;2 is indentation

;Cutsheets by event
requests.appName:= "cutsheets"
requests.tier := 1
Msgbox Jsons.Dumps(y := requests.PostUrl("search", x := Map('event', 1)), 2)
