; Function to strip HTML tags from a string
StripHtml(inputString) {
    ; Use regular expression to remove HTML tags
    outputString := RegExReplace(inputString, "<[^>]*>")
    return outputString
}

; Example usage
Download("http://www.autohotkey.com/docs/commands/MsgBox.htm", "temp.html")
htmlString := "<p>This is <b>bold</b> and <i>italic</i></p>"
plainText := StripHtml(htmlString)

MsgBox "Original String:`n" htmlString "`n`nStripped String:`n" plainText
