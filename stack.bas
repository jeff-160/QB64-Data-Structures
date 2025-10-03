Type Stack
    topPtr As _Offset
    length As Integer
End Type


' add node to end of stack
Sub PUSH_STACK (stk As Stack, value As Integer)
    Dim node As Node
    node.value = value
    node.nextAddr = stk.topPtr

    ' store node in memory
    Dim nodeBlock As _MEM
    nodeBlock = _MemNew(NODE_SIZE)
    _MemPut nodeBlock, nodeBlock.OFFSET, node

    stk.topPtr = nodeBlock.OFFSET

    stk.length = stk.length + 1
End Sub


' remove and return value of node from top of stack
Function POP_STACK% (stk As Stack)
    If stk.length = 0 Then
        Print "Stack is empty!"
        End
    End If

    Dim m As _MEM
    m = _Mem(stk.topPtr, NODE_SIZE)

    Dim topNode As Node
    _MemGet m, m.OFFSET, topNode

    Dim value
    value = topNode.value

    stk.topPtr = topNode.nextAddr
    _MemFree m

    stk.length = stk.length - 1

    POP_STACK% = value
End Function


' get value of node at top of stack
Function PEEK_STACK% (stk As Stack)
    If stk.length = 0 Then
        Print "Stack is empty!"
        End
    End If

    Dim m As _MEM
    m = _Mem(stk.topPtr, NODE_SIZE)

    Dim node As Node
    _MemGet m, m.OFFSET, node

    PEEK_STACK% = node.value
End Function


' return string representation of stack
Function STACK_TO_STR$ (stk As Stack)
    If stk.topPtr = 0 Then
        STACK_TO_STR$ = "{ }"
        Exit Function
    End If

    Dim current As Node
    Dim m As _MEM
    m = _Mem(stk.topPtr, NODE_SIZE)
    _MemGet m, m.OFFSET, current

    Dim repr As String
    repr = ""

    While current.nextAddr <> 0
        repr = repr + Str$(current.value) + " -> "

        m = _Mem(current.nextAddr, Len(current))

        _MemGet m, m.OFFSET, current
    Wend

    repr = "{ " + repr + Str$(current.value) + " }"

    STACK_TO_STR$ = repr
End Function
