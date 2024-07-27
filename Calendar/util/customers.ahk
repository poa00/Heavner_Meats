

/*
@example 
Customers := CustomersClass.ParseCSV(A_ScriptDir "\customers.csv")

@return
* Customers[12].customer
* Customers[12].telephone
* Customers[12].mobile
* Customers[12].email 
* Customers[12].address
* Customers[12].city
* Customers[12].zip
* Customers[12].id
*/
class CustomersClass
{
    static ParseCSV(path)
    {
        csvString := FileRead(path)
        csvRows := StrSplit(csvString, "`n")
        Customers := []
        Loop csvRows.Length
        {
            row := StrSplit(csvRows[A_Index], ",")
            try 
            {
                Customers.Push(CustomersClass.Obj(
                    row[1], row[2], row[4], 
                    row[5], row[6], row[7], 
                    row[8], row[16])
                )
            } catch as e {
                message := e.message "`n at => " FormatTime() "`nLineNumber => " A_Index "`n`n"
                FileAppend(message, "errorLog.txt")
            }
            
        }
        return Customers
    }

    class Obj
    {
        __New(customer, telephone, mobile, email, address, city, zip, id) 
        {
            this.customer := customer
            this.telephone := telephone
            this.mobile := mobile
            this.email := email
            this.address := address
            this.city := city
            this.zip := zip
            this.id := StrReplace(Trim(id), "`r", "")
        }
    }
}




/*
; FormatTime(,A_YWeek) => FormatTime(timeinputToConvert, FormatVar)
val := "20230823"
week := FormatTime(val, "YWeek")
week := SubStr(week, -2)
Msgbox val "`nWeek: " week

Msgbox(Week)

FormatTime(, A_YWeek)

customer := {
    farmer:"123 farms",
    animal:"cow",
    weight:"15lbs"
}
FileAppend(jsons.dump(customer), "events.json")