#Requires Autohotkey v2.0
#SingleInstance Force

QPC(1)

Loop 1000000
{
    t1a := 1
    t1b := 1
    t1c := 1
    t1d := 1
    t1e := 1
    t1f := 1
    t1g := 1
    t1h := 1
    t1i := 1
    t1j := 1
}
test1 := QPC(0), QPC(1)

Loop 1000000
    t2a := t2b := t2c := t2d := t2e := t2f := t2g := t2h := t2i := t2j := 1
test2 := QPC(0), QPC(1)

Loop 1000000
    t3a := 1, t3b := 1, t3c := 1, t3d := 1, t3e := 1, t3f := 1, t3g := 1, t3h := 1, t3i := 1, t3j := 1
test3 := QPC(0)

MsgBox(test1 "`n" test2 "`n" test3)
ExitApp()

; =========================================================================================================

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
    return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}
