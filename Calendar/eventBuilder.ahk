#Include JSONS.ahk
#Include customers.ahk

; FormatTime(,A_YWeek) => FormatTime(timeinputToConvert, FormatVar)
;FileAppend(jsons.dump(customer), "events.json")

eventID := 1001
obj := Events.buildEvents()

FileAppend(jsons.dumps(obj), "events.json")

class Events
{
    static buildEvents()
    {
        Customers := CustomersClass.ParseCSV(A_ScriptDir "\customers.csv")
        eventMaps := Events.blankBuild()
        return Events.StructureObjs(Customers, eventMaps)
    }

    static blankBuild()
    {
        weeks := Map(SubStr(A_YWeek, -2), [], 
                SubStr(A_YWeek, -2) - 1, [], 
                SubStr(A_YWeek, -2) + 1, [])
        return weeks
    }
    static StructureObjs(Customers, EventMap)
    {
        for weekNum, Arrays in EventMap
        {
            Loop 5 
            {
                ind := Random(1, weekNum * 2)
                animalDetails := Events.RandomAnimals()
                EventMap[weekNum].Push(Events.pushEvents(Customers[ind], animalDetails, weekNum))
            }
        }
        return EventMap
    }
    static pushEvents(C, animalDetails, week)
    {
        global eventID
        eventID := eventID + 1
        return Events.Dummy(C.customer, C.id, eventID, animalDetails.animal, animalDetails.count, week)
    }

    static RandomAnimals()
    {
        anim := ["cows", "pigs", "lambs"]
        countMax := 300
        ret := {
            animal: anim[Random(1, 3)],
            count: Random(1, countMax)
        }
        return ret
    }

    class Dummy
    {
        __New(customer, customerID, eventID, animal, count, weeknumber)
        {
            this.customer := customer
            try {
                this.customerid := Integer(customerID)
            } catch as e {
                this.customerid := ""
            }
            if animal == "cows" {
                this.cows := count
            } else {
                this.cows := "null"
            }
            if animal == "pigs" {
                this.pigs := count
            } else {
                this.pigs := "null"
            }
            if animal == "lambs" {
                this.lambs := count
            } else {
                this.lambs := "null"
            }
            this.eventid := eventID
            this.week := Integer(weeknumber)
        }
    }
}