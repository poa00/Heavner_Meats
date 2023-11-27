x := ["1", "2"]


class Enum
{
    static Call(params*)
    {
        if params is Array 
        {
            for i in params
            {
                return i.__Enum
            }
        }
    }
}

x := Enum(x)

for i in Enum(x)
{
    msgbox i
}