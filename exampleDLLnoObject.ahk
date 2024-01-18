#Requires Autohotkey v2
#Include <CLR>
c := "
(

using System;
using System.Collections.Generic;
using System.Linq;

    public class FuzzyMatcher
    {
        public string FindBestMatch(string shortString, string largeString)
        {
            // Tokenize the large string by splitting into words
            string[] words = largeString.Split(new[] { ' ', ',', '.', ';', ':', '-', '!', '?' }, StringSplitOptions.RemoveEmptyEntries);

            string bestMatch = null;
            double bestSimilarity = 0.0;

            foreach (string word in words)
            {
                double similarity = CalculateSimilarity(shortString, word);

                if (similarity > bestSimilarity)
                {
                    bestSimilarity = similarity;
                    bestMatch = word;
                }
            }

            return bestMatch;
        }

        public int LevenshteinDistance(string source, string target)
        {
            if (string.IsNullOrEmpty(source))
            {
                return target.Length;
            }

            if (string.IsNullOrEmpty(target))
            {
                return source.Length;
            }

            int sourceLength = source.Length;
            int targetLength = target.Length;
            int[,] distance = new int[sourceLength + 1, targetLength + 1];

            for (int i = 0; i <= sourceLength; distance[i, 0] = i++) { }
            for (int j = 0; j <= targetLength; distance[0, j] = j++) { }

            for (int i = 1; i <= sourceLength; i++)
            {
                for (int j = 1; j <= targetLength; j++)
                {
                    int cost = (target[j - 1] == source[i - 1]) ? 0 : 1;

                    distance[i, j] = Math.Min(
                        Math.Min(distance[i - 1, j] + 1, distance[i, j - 1] + 1),
                        distance[i - 1, j - 1] + cost);
                }
            }

            return distance[sourceLength, targetLength];
        }

        public double CalculateSimilarity(string source, string target)
        {
            int maxLength = Math.Max(source.Length, target.Length);
            if (maxLength == 0)
                return 1.0;

            int distance = LevenshteinDistance(source, target);
            return (maxLength - distance) / (double)maxLength;
        }
    } 
)"

path := "C:\Users\dower\OneDrive\Documents\_searchDocs\docs\v2-changes.htm"
asm := CLR_CompileCS(c, "System.dll | System.Linq.dll")
obj := CLR_CreateObject(asm, "FuzzyMatcher")
response := obj.FindBestMatch("gui",FileRead(path)) ; true to strip html from response 
Msgbox response