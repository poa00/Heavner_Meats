Array.Prototype.DefineProp("Contains", { Call: array_contains})


class array_contains
{
    static Call(arr, search, casesense := 0)
    {
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
}
