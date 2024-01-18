#Requires AutoHotkey v2 
; Helper Function for 'get'
;https://www.autohotkey.com/docs/v2/Objects.htm#Usage_Arrays_of_Arrays
; https://www.autohotkey.com/docs/v2/Objects.htm#Custom_Classes
; https://www.autohotkey.com/docs/v2/lib/Object.htm#DefineProp_Parameters 


class Example
{
    static get() => this.value
    static set(value) => this.value := value
}
myObject := { value: "" }
myObject.DefineProp("DynamicProperty", { get: Example.get, set: Example.set })

Msgbox myObject.DynamicProperty




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
class Example1 
{
    
}
getFunction(this) {
    return this._hiddenValue  ; Return the internally stored value
}
; Helper Function for 'set'
setFunction(this, value) {
    this._hiddenValue := value  ; Update the internally stored value
}
; Create an object and a hidden field to store the property value
myObject := { _hiddenValue: "" }
; Define a dynamic property with both getter and setter
myObject.DefineProp("DynamicProperty", {
    Get: getFunction,
    Set: setFunction
})
; Now you can get and set the value of DynamicProperty
myObject.DynamicProperty := "Hello, World"  ; Setter is called
MsgBox myObject.DynamicProperty  ; Getter is called and displays "Hello, World"

  /*
  You can add any property to any object
  This allows you to access the property at any time
  However, in this case, we want to add it to the object's prototype.  
  This gives all instances of the object access to the new property
  If you don't add it to the prototype, it won't be in the created objects, only the base object.  
  You'll want to create a descriptor. It's a special object that allows a property to be called
  (Spoiler alert, there are no TRUE "methods" in AHK.  
  They're ALL properties with callable descriptors.)  
  Descriptor object example: {Call:array_contains}
  The descriptor "describes" what actions a property should take
  */
  Array.Prototype.DefineProp("Contains", {Call:array_contains})

  ; When a descriptor is called, it ALWAYS sends a reference to the object as the first param.  
  ; It's known as the "this" variable when working inside an object/class/etc.  
  ; The search param is the expected item to find.  
  ; CaseSense is a bonus option added just to make the method more robust
  array_contains(arr, search, casesense:=0) {
      for index, value in arr {
          if !IsSet(value)
              continue
          else if (value == search)
              return index
          else if (value = search && !casesense)
              return index
      }
      return 0
  }

  ; Define an array
  arr := ['apple', 'banana', 'cherry']

  ; Now you can use the new "contains" method we just added  
  ; Remember, the array itself is passed implicitly and doesn't need to be included.  
  ; The "search" param is required and not providing one throws a parameter error  
  ; "CaseSense" is optional and defaults to false
  if arr.contains('Cherry')
      MsgBox('Found it!')
  else MsgBox('Not found.')

