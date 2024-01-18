#Requires Autohotkey v2
#Include <CLR>
c := "
(
using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

//  string filePath = "C:\\Users\\dower\\OneDrive\\Documents\\_searchDocs\\docs\\lib\\LoopFiles.htm";

class Parse
{
    public static Dictionary<string, string> Run(string filePath)
    {
        // Assuming the HTML file is named "input.html" and is located in the same directory as the executable

        // Read the content from file
        if (File.Exists(filePath))
        {
            string htmlContent = File.ReadAllText(filePath);
            var sections = ParseHtmlSections(htmlContent);
            return sections;
            // Print Section Titles and their Content
            // foreach (KeyValuePair<string, string> section in sections)
            //   {
            //    Console.WriteLine($"Section: {section.Key}");
            //  Console.WriteLine($"Content: {section.Value}");
            //  Console.WriteLine();
            //  }
        }
        else
        {
            string answer = "File not found: " + filePath;
            var sections = new Dictionary<string, string>();
            sections["all"] = answer;
            return sections;
        }
    }

    private static Dictionary<string, string> ParseHtmlSections(string htmlContent)
    {
        var sections = new Dictionary<string, string>();
        // Regex pattern to find section titles and content
        string pattern = @"(<h1>.*?</h1>|<h2.*?>.*?</h2>)(.*?)(?=<h1>|<h2|$)";

        MatchCollection matches = Regex.Matches(htmlContent, pattern, RegexOptions.Singleline);

        // Iterate over the matches and populate the sections dictionary
        foreach (Match match in matches)
        {
            string title = Regex.Replace(match.Groups[1].Value, @"<.*?>", "").Trim(); // Remove HTML tags from title
            string content = match.Groups[2].Value.Trim(); // Content following the title
            sections[title] = StripHtml(content);
        }

        return sections;
    }
    public static string StripHtml(string html)
    {
        if (string.IsNullOrEmpty(html))
        {
            return string.Empty;
        }

        // Regex to detect all HTML tags and HTML-encoded characters
        string htmlTagPattern = "<.*?>";
        string htmlEncodedPattern = "&[^;]+;";

        // Replace HTML tags with empty string
        var withoutHtmlTags = Regex.Replace(html, htmlTagPattern, string.Empty);
        // Replace HTML-encoded characters with their actual characters
        // Unescape is not used because it handles escape characters in C# strings rather than HTML entities.
        var withoutHtmlEncoded = Regex.Replace(withoutHtmlTags, htmlEncodedPattern, match => HtmlEntityToChar(match.Value));

        return withoutHtmlEncoded;
    }
    private static string HtmlEntityToChar(string entity)
    {
        // Add more HTML entities to character mappings as needed
        var entityMappings = new Dictionary<string, string>
        {
            ["&amp;"] = "&",
            ["&lt;"] = "<",
            ["&gt;"] = ">",
            // ... Add more mappings for other entities ...
        };

        return entityMappings.TryGetValue(entity, out string character) ? character : entity;
    }
}
)"

url := "http://example.com/"

asm := CLR_CompileCS(c, "System.dll")
obj := CLR_CreateObject(asm, "Parse")
response := obj.Run("C:\Users\dower\OneDrive\Documents\AutoHotkeyDocs-2 (1)\AutoHotkeyDocs-2\docs\Concepts.htm") ; true to strip html from response 
Msgbox response