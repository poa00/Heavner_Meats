#Requires AutoHotkey v2.0

#Include _JSONS.ahk
m := Map("app", "customers", "operation", "read_all", "ip", "localhost", "port", "5613")
jdata := jsons.dump(m)

FileOpen("test.json", "w").Write(jdata)