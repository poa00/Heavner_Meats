#Requires AutoHotkey v2.0
#Include CLR.ahk
; #Include JSONS.ahk
/*
    This is a wrapper for the requests.dll
        public static string SendRequest(
            string method, string url, string data = null, 
            string username = null, string password = null)
*/

debugging := false

/*
    This is a wrapper for the requests.dll
*/
dllPath := FileExist(A_ScriptDir "\requests\requests.dll") ? A_ScriptDir "\requests\requests.dll" : A_ScriptDir "\requests.dll"
authpath := A_MyDocuments "\auth.json"
appName := "customers"

url := "http://127.0.0.1:5613"

; string baseUrl = "http://your-api-base-url";
; string username = "your-username";
; string password = "your-password";

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; MsgBox(Jsons.Dumps(requests.GetUrl("42955/events")))
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

; APIClient apiClient = new APIClient(baseUrl, username, password);
;     // Call the GET method to retrieve data from the API
; string getResult = apiClient.Get("/api/data");
; Console.WriteLine("GET Result: " + getResult);

; asm := CLR_LoadLibrary(dllPath)
; client :=  CLR_CreateObject(asm, "APIClient", "http://127.0.0.1:5613", "sam fisher", "3213")

; Msgbox client.Get("/users/")
class requests
{
    static tier := ""
    static appName := "customers"
    static url := url
    /*
    Function: Load
    Description: Loads the APIClient object from the specified URL and tier.
    Parameters:
        - url (string): The URL to load the APIClient object from.
        - tier (string): The tier to use for the APIClient object. If not provided, it will be determined based on the user's authentication information.
    Returns:
        - APIClient: The loaded APIClient object.
    */
    static Load(url, tier := "")
    {
        if tier = ""
        {
            user := debugging = false ? readAuth() : jsons.loads(&x := FileRead(A_MyDocuments "\authDEBUG.json"))
            requests.tier := Format("{1}", user['tier'])
        } else {
            requests.tier := tier
        }
        asm := CLR_LoadLibrary(dllPath)
        return CLR_CreateObject(asm, "APIClient")
    }            
    /*
    Function: Get
    Description: Retrieves data from a specified URL and returns it as a list of users.
    Parameters:
        - item (optional): The specific item to retrieve. Default is an empty string.
        - appName (optional): The name of the application. Default is "users".
    Returns:
        - A list of users retrieved from the specified URL.
    */
    static Get(item := "", appName := "customers")
    {
        client := item = "" ? requests.Load(url, "1") : requests.Load(url)
        if item != ""
        {
            x := client.Get(Format("{3}/{2}/{1}", item, appName, url), requests.tier)
            y := jsons.loads(&x)
            client := ""
            return y
        }
        x := Format("{2}/{1}/", appName, url)
        x := client.Get(x, requests.tier)
        try {
            return jsons.loads(&x)
        } catch as e
        {
            x := "error in loading jsons. " e.Message "`n" x
            return x 
        }
    }
    /*
    Function: GetUrl
    Description: Retrieves data from a specified URL.
    Parameters:
        - url: The URL to retrieve data from.
    */
    static GetUrl(params)
    {
        url := requests.url . "/" requests.appName . "/" . params
        client := requests.Load(url)
        response := client.Get(url, requests.tier)
        try {
            return jsons.loads(&response)
        } catch as e
        {
            return response
        }
    }
    /*
    Function: Post
    Description: Sends a POST request to the specified URL with the provided data.
    Parameters:
        - data: The data to be sent in the request.
    Returns:
        - If the request is successful, the parsed JSON response.
        - If an error occurs, an error message indicating the issue.
    */
    static Post(data)
    {
        client := requests.Load(url)
        jstring := requests.str(data)
        x := client.Post(
            Format("{2}/{1}/", appName, url), requests.tier, jstring
        )
        try {
            return jsons.loads(&x)
        } catch as e
        {
            x := "error in loading jsons. " e.Message "`n" x
            return x
        }
    }    
    /*
    Function: Put
    Description: Sends a PUT request to the specified URL with the provided data.
    Parameters:
        - id: The ID associated with the data.
        - data: The data to be sent in the request.
    Returns:
        - If the request is successful, the parsed JSON response.
        - If an error occurs, an error message indicating the issue.
    */
    static Put(id, data)
    {
        client := requests.Load(url)
        jstring := requests.str(data)
        x := client.Put(
            Format("{3}/{2}/{1}", id, appName, url), requests.tier, 
            jstring)
        try {
            return jsons.loads(&x)
        } catch as e
        {
            x := "error in loading jsons. " e.Message "`n" x
            return x
        }
    }
    /*
    Function: Del
    Description: Deletes a customer record based on the provided ID.
    Parameters:
        - id: The ID of the customer to be deleted.
    Returns:
        - If successful, returns the parsed JSON response.
        - If an error occurs, returns an error message.
    */
    static Del(id)
    {
        client := requests.Load(url)
        x := client.Delete(
            Format("{3}/{2}/{1}", id, appName, url), requests.tier)
        try {
            return jsons.loads(&x)
        } catch as e
        {
            x := "error in loading jsons. " e.Message "`n" x
            return x
        }
    }
    /*
    Function: str
    Description: Converts the given user object to a JSON string.
    Parameters:
        - user: The user object to convert.
    Returns:
        - The JSON string representation of the user object, or the user object itself if it is not an object.
    */
    static str(user)
    {
        try {
            return IsObject(user) ? jsons.dumps(user) : user
        } catch as e
        {
            Msgbox e.message
        }
    }
}
        ; string baseUrl = "http://your-api-base-url";
        ; string username = "your-username";
        ; string password = "your-password";

        ; APIClient apiClient = new APIClient(baseUrl, username, password);
        ;     // Call the GET method to retrieve data from the API
        ; string getResult = apiClient.Get("/api/data");
        ; Console.WriteLine("GET Result: " + getResult);

; asm := CLR_LoadLibrary(dllPath)
; client :=  CLR_CreateObject(asm, "APIClient", "http://127.0.0.1:5613", "sam fisher", "3213")

; Msgbox client.Get("/users/")


userMaps()
{
    
    try
    {
        return requests.Get()
    }
    catch as e
    {
        MsgBox("The API may not be connected. HTTP issue.`n`n" e.Message)
    }
}

readAuth()
{
    return jsons.loads(&x := reader(authpath))
}

reader(path, fullPath := false) 
{
    if fullPath = false && not InStr(path, ":\")
    {
        path := A_ScriptDir "\" path
    }
    F := FileOpen(path, "r")
    str := F.Read()
    F.Close()
    return str
}

writer(path, strToWrite, fullPath := false) 
{
    if fullPath == false && not InStr(path, ":\")
    {
        path := A_ScriptDir "\" path
    }
    F := FileOpen(path, "w")
    F.Write(strToWrite)
    F.Close()
    return
}
