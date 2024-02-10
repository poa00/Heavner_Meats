#Include CLR.ahk

a := A_ScriptDir
config := a "\util\config.json"
message := a "\util\message.json"
response := a "\util\response.json"


asm := CLR_LoadLibrary(A_ScriptDir "\util\requests.dll")
obj := CLR_CreateObject(asm, "Program")
messageContents := Map("customerID", 42893)

x := Msgbox(obj.MyHttpClient("localhost", "5613", "calendar", "delete", message, response))


