﻿/*
import requests

url = 'http://<your-domain>/animals/'
headers = {'Content-Type': 'application/json'}
data = {
    'species': 'Canis lupus',
    'live_weight': 45,
    'sex': 'M',
    'is_over_30_months': False,
    'abscess': False,
    'organs_acceptable': True,
    'no_organs': False,
    'save_head': True,
    'save_hide': True,
    'comments': 'Healthy individual, no signs of disease',
    'event': 1,  # Assuming 'event' is the ID of an existing event in the database
    'customer': None  # Assuming this animal is not associated with a customer
}

response = requests.post(url, json=data, headers=headers)
print(response.json())
*/
class AnimalsAPI
{
    __New(species)
    {
        this.species := species
        this.live_weight := 0
        this.sex := 0
        this.is_over_30_months := 0
    }
    static convertToJSON(object) 
    {
        tempMap := Map()
        for k, v in object.OwnProps()
            tempMap.Set(k, v)
        return Json.Dump(tempMap)
    }
}

initNewAnimalAPI(eventID, obj)
{
        H := WinHttpRequest()
        return H.request(requests2.url . "/" "animals/" eventID "/")
}

addInitAnimal(){
        LV_DoubleClick(LV?, RowNum?)
        {
            if not RowNum
                return
            eventid := LV.GetText(RowNum, 3)
            obj := AnimalsAPI('cows')
            obj.event_id := eventid

            response := requests2.PostUrl("animals/" eventid, AnimalsAPI.convertToJSON(obj))
            ; SetTimer () => ToolTip(), -3000
            try Msgbox response
            try Msgbox JSON.Dump(response)
        }
}


