#Requires Autohotkey v2.0
#SingleInstance force
#Include <request>
#Include <cJson>

WSGetCustomers()
{
    return Requests.GetUrl("customers/weight-station")
}