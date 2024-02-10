#Requires Autohotkey v2
#Include <CLR>
#Include <cJson>
c := 
"
(
using System;

class FuzzyMatcher
{

    public double CalculateSimilarityScore(string str1, string str2)
    {
        int distance = FuzzyMatcher.CalculateLevenshteinDistance(str1, str2);
        int maxLength = Math.Max(str1.Length, str2.Length);

        if (maxLength == 0)
        {
            // Avoid division by zero if both strings are empty
            return 1.0;
        }

        double similarity = 1.0 - (double)distance / maxLength;
        return similarity;
    }

    private static int CalculateLevenshteinDistance(string str1, string str2)
    {
        int[,] distance = new int[str1.Length + 1, str2.Length + 1];

        for (int i = 0; i <= str1.Length; i++)
            distance[i, 0] = i;

        for (int j = 0; j <= str2.Length; j++)
            distance[0, j] = j;

        for (int i = 1; i <= str1.Length; i++)
        {
            for (int j = 1; j <= str2.Length; j++)
            {
                int cost = (str1[i - 1] == str2[j - 1]) ? 0 : 1;

                distance[i, j] = Math.Min(
                    Math.Min(distance[i - 1, j] + 1, distance[i, j - 1] + 1),
                    distance[i - 1, j - 1] + cost);
            }
        }

        return distance[str1.Length, str2.Length];
    }
}


)"

asm := CLR_CompileCS(c, "System.dll | System.Data.dll | System.Data.DataSetExtensions.dll | System.Net.Http.dll | System.Xml.dll | System.Xml.Linq.dll | System.Core.dll | Microsoft.CSharp.dll | System.Collections.dll")
obj := CLR_CreateObject(asm, "FuzzyMatcher")
Msgbox obj.CalculateSimilarityScore("hello", "h")

csharp:=
(
    "
    
using System;
using System.Collections;

class SimpleClass
{
    public string Objector(object x)
    {
        return  ;
    }
}
"
)
c := "
(
using System;
using System.Collections;

class SimpleClass
{
    public string Objector(object x)
    {
        Type objectType = x.GetType();
        
        // Get the type name as a string
        string typeName = objectType.FullName; // or use objectType.Name for short name
        
        return typeName;
    }
}
)"