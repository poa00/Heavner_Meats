#Include _JSONS.ahk
#Include customers.ahk

; FormatTime(,A_YWeek) => FormatTime(timeinputToConvert, FormatVar)
;FileAppend(Jsons.Dumps(customer), "events.json")

eventID := 1001
obj := Events.buildEvents()

FileAppend(Jsons.Dumps(obj), "events.json")

class Events
{
    static buildEvents()
    {

        Customers := CustomersClass.ParseCSV(A_ScriptDir "\customers.csv")

        thisWeek := {
            number: SubStr(A_YWeek, -2),
            events: []
        }
        previousWeek := {
            number: thisweek.number - 1,
            events: []
        }
        nextWeek := {
            number: thisweek.number + 1,
            events: []
        }

        animalDetails := Events.RandomAnimals()
        Loop 3
        {
            thisWeek := Events.pushEvents(Customers, animalDetails, thisWeek)
        }
        Loop 3
        {
            previousWeek := Events.pushEvents(Customers, animalDetails, previousWeek)
        }
        Loop 3
        {
            nextWeek := Events.pushEvents(Customers, animalDetails, nextWeek)
        }
        return events := {
            thisweek: thisweek, previousWeek: previousWeek, nextWeek: nextWeek
        }
    }

    static pushEvents(Customers, animalDetails, week)
    {
        global eventID
        Loop 3
        {
            eventID := eventID + 1
            week.events.Push(Events.Dummy(Customers[A_Index].customer, Customers[A_Index].id, eventID, animalDetails.count " " animalDetails.animal))
        }
        return week
    }
    
    static RandomAnimals()
    {
        anim := ["cow", "pig", "lamb"]
        countMax := 300
        ret := 
        {
            animal: Random(1, 3),
            count: Random(1, countMax)
        }
        return ret
    }

    class Dummy
    {
        __New(customer, customerID, eventID, details)
        {
            this.customer := customer
            this.customerid := customerID
            this.eventID := eventID
            this.details := details
        }
    }
}