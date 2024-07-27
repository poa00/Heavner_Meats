Dynamic Property with get and set:
class Example {
    Property {
        get {
            ; return some calculated value
            return this.value + 10
        }
        set {
            ; store the value
            this.value := value
        }
    }
}

ex := new Example()
ex.value := 5
MsgBox ex.Property  ; Output: 15
ex.Property := 20
MsgBox ex.value  ; Output: 20
Dynamic Property with parameters:
class Example {
    Property[par1, par2] {
        get {
            ; return value based on parameters
            return par1 + par2
        }
        set {
            ; handle parameters
            this.result := value
        }
    }
}

ex := new Example()
MsgBox ex.Property[5, 10]  ; Output: 15
ex.Property := 20
MsgBox ex.result  ; Output: 20
Static Property with get:
class StaticExample {
    static Property {
        get => 50
    }
}

MsgBox StaticExample.Property  ; Output: 50
Short Fat Arrow Property:
class FatArrowExample {
    Property[par1, par2] => par1 + par2
}

ex := new FatArrowExample()
MsgBox ex.Property[5, 10]  ; Output: 15
Using __Item Property for indexing:
class IndexExample {
    static __Item[name] {
        get => name
        set => MsgBox("Setting " . name . " to " . value)
    }
}

IndexExample["example"] := "test"
MsgBox IndexExample["example"]  ; Output: examp