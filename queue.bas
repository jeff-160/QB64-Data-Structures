Type Queue
    frontPtr As _Offset
    rearPtr As _Offset
    length As Integer
End Type


' add node to end of queue
Sub ENQUEUE_QUEUE (q As Queue, value As Integer)
    Dim node As Node
    node.value = value

    ' store node in memory
    Dim nodeBlock As _MEM
    nodeBlock = _MemNew(NODE_SIZE)
    _MemPut nodeBlock, nodeBlock.OFFSET, node

    If q.length = 0 Then
        q.frontPtr = nodeBlock.OFFSET
        q.rearPtr = q.frontPtr

        q.length = q.length + 1
        Exit Sub
    End If

    ' update node at rearptr
    Dim m As _MEM
    m = _Mem(q.rearPtr, NODE_SIZE)

    Dim lastNode As Node
    _MemGet m, m.OFFSET, lastNode

    lastNode.nextAddr = nodeBlock.OFFSET
    _MemPut m, m.OFFSET, lastNode

    q.rearPtr = nodeBlock.OFFSET

    q.length = q.length + 1
End Sub


' add node to front of queue
Sub DEQUEUE_QUEUE (q As Queue)
    If q.length = 0 Then
        Print "Queue is empty!"
        End
    End If

    Dim m As _MEM
    m = _Mem(q.frontPtr, NODE_SIZE)

    Dim current As Node
    _MemGet m, m.OFFSET, current

    q.frontPtr = current.nextAddr
    _MemFree m

    If q.frontPtr = 0 Then
        q.rearPtr = 0
    End If

    q.length = q.length - 1
End Sub


' get value of node at front of queue
Function PEEK_QUEUE% (q As Queue)
    If q.length = 0 Then
        Print "Queue is empty!"
        End
    End If

    Dim m As _MEM
    m = _Mem(q.frontPtr, NODE_SIZE)

    Dim node As Node
    _MemGet m, m.OFFSET, node

    PEEK_NODE% = node.value
End Function

' return string representation of queue
Function QUEUE_TO_STR$ (q As Queue)
    If q.length = 0 Then
        QUEUE_TO_STR$ = "{ }"
        Exit Function
    End If

    Dim current As Node
    Dim m As _MEM
    m = _Mem(q.frontPtr, NODE_SIZE)
    _MemGet m, m.OFFSET, current

    Dim repr As String
    repr = "{ "

    While current.nextAddr <> 0
        repr = repr + Str$(current.value) + " <- "

        m = _Mem(current.nextAddr, Len(current))

        _MemGet m, m.OFFSET, current
    Wend

    repr = repr + Str$(current.value) + " }"

    QUEUE_TO_STR$ = repr
End Function

