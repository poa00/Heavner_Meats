#Requires Autohotkey v2
#Include CLR.ahk
c := "
(
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using System.Runtime.InteropServices;

    // New project as ".NET DLL"

    class Runner
    {
        public string Run()
        {
            string var = "some string";

            return var;
        }
    }
    
)"

a := A_ScriptDir

config := a "\config.json"
message := a "\message.json"
response := a "\response.json"
asm := CLR_LoadLibrary(A_ScriptDir "\requests.dll")
obj := CLR_CreateObject(asm, "Program")
x := Msgbox(obj.MyHttpClient(config, message, response))

Msgbox(x)

/*

#Include CLR.ahk
c := "
(

)"
asm := CLR_LoadLibrary(A_ScriptDir "\Printer.dll")
obj := CLR_CreateObject(asm, "Runner")
x := obj.Returner()

Msgbox(x)











CLR_Start()
asm := CLR_LoadLibrary(A_ScriptDir "\AHK.dll")
o := CLR_CreateObject(asm, "AHK")
o.Main()

Sleep(1)

/*




namespace AHK
{
    public class AHK
    {
        [DllExport("Main", CallingConvention = CallingConvention.StdCall)]

        public static string Main()
        {
            return "hello";
        }
    }
}



using System;

public class MyClass
{
    public static string HelloWorld { get; set; }

    public MyClass()
    {
        HelloWorld = "Hello, world!";
    }
}





D := A_ScriptDir "\AHK.dll"
hModule := DllCall("LoadLibrary", "Str", D, "Ptr")

if (hModule)
{
    result := DllCall(hModule, "Str", "Main")
    MsgBox result
    DllCall("FreeLibrary", "Ptr", hModule)
}
else
{
    MsgBox "Failed to load the DLL."
}
