#Include onscreenKB.ahk

/**
 * Represents a comment handler object.
 */
class CommentHandler
{
    static KB := {} ; => CommentHandler.PrivateInit()
    static comments := ""
    
    static Call(comments := True, hwnd?)
    {
        CommentHandler.KB := Keyboard(,CommentHandler.comments)
        While Keyboard.Active = True
            Sleep(100)
        CommentHandler.KB := ''
        CommentHandler.comments := Keyboard.edit_value
        return Keyboard.edit_value
    }
    static Clear()
    {
        Keyboard.edit_value := ''
    }
    static RetSend()
    {
        val := Keyboard.edit_value
        Keyboard.edit_value := ''
        CommentHandler.Clear()
        return val
    }
}
