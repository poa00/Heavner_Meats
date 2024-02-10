#Requires Autohotkey v2
#Include <CLR>
c := "
(
using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;

public class APIClient
{
    private HttpClient client;

    public APIClient(string baseUrl)
    {
        client = new HttpClient { BaseAddress = new Uri(baseUrl) };
    }

    public string Get(string endpoint)
    {
        try
        {
            HttpResponseMessage response = client.GetAsync(endpoint).Result; // Use .Result to block until the GET request is complete

            if (response.IsSuccessStatusCode)
            {
                return response.Content.ReadAsStringAsync().Result; // Use .Result to block until content is read
            }
            else
            {
                throw new Exception("Failed to GET data from " + endpoint + ". Status Code: " + response.StatusCode);
            }
        }
        catch (Exception ex)
        {
            return "{{\"error\": \"Error: " + ex.Message + "\"}}";
        }
    }

    public string Post(string endpoint, string data)
    {
        try
        {
            var content = new StringContent(data);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

            HttpResponseMessage response = client.PostAsync(endpoint, content).Result; // Use .Result to block until the POST request is complete

            if (response.IsSuccessStatusCode)
            {
                return response.Content.ReadAsStringAsync().Result; // Use .Result to block until content is read
            }
            else
            {
                throw new Exception("Failed to POST data from " + endpoint + ". Status Code: " + response.StatusCode); 
            }
        }
        catch (Exception ex)
        {
            return "{{\"error\": \"Error: " + ex.Message + "\"}}";
        }
    }

    public string Put(string endpoint, string data)
    {
        try
        {
            var content = new StringContent(data);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

            HttpResponseMessage response = client.PutAsync(endpoint, content).Result; // Use .Result to block until the PUT request is complete

            if (response.IsSuccessStatusCode)
            {
                return response.Content.ReadAsStringAsync().Result; // Use .Result to block until content is read
            }
            else
            {
                throw new Exception("Failed to PUT data from " + endpoint + ". Status Code: " + response.StatusCode); 
            }
        }
        catch (Exception ex)
        {
            return "{{\"error\": \"Error: " + ex.Message + "\"}}"; 
        }
    }

    public string Delete(string endpoint)
    {
        try
        {
            HttpResponseMessage response = client.DeleteAsync(endpoint).Result; // Use .Result to block until the DELETE request is complete

            if (response.IsSuccessStatusCode)
            {
                return response.Content.ReadAsStringAsync().Result; // Use .Result to block until content is read
            }
            else
            {
                throw new Exception("Failed to DELETE data from " + endpoint + ". Status Code: " + response.StatusCode); 
            }
        }
        catch (Exception ex)
        {
            return "{{\"error\": \"Error: " + ex.Message + "\"}}"; 
        }
    }
}
)"

url := "http://127.0.0.1:5613"
url := "http://localhost:8080/"

asm := CLR_CompileCS(c, "System.dll | System.Net.Http.dll")
obj := CLR_CreateObject(asm, "APIClient", url)
Msgbox obj.Get("")

