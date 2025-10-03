' node declarations and data structure functions must be separated
' because qb64 is stupid and doesnt allow commands after subroutine declarations
'$include: 'node.bas'

' leetcode valid parentheses

s$ = "([{}]{})"

Print isValid(s$)

Function isValid% (s As String)
    Dim stack As Stack

    For i = 1 To Len(s)
        c$ = Mid$(s$, i, 1)

        If InStr("({[", c$) >= 1 Then
            PUSH_STACK stack, ORD(c$)
        Else
            If stack.length = 0 Then
                isValid% = FALSE
                Exit Function
            End If

            top = POP_STACK(stack)

            If (c$ = ")" And top <> ORD("(")) Or (c$ = "]" And top <> ORD("[")) Or (c$ = "}" And top <> ORD("{")) Then
                isValid% = FALSE
                Exit Function
            End If
        End If
    Next i

    isValid% = (stack.length = 0)
End Function

Function ORD% (c As String)
    ORD% = Asc(c)
End Function

'$Include: 'stack.bas'
