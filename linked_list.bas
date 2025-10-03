Type Node
    value As Integer
    nextAddr As _Offset
End Type

Dim Shared NODE_SIZE As Integer
Dim n1 As Node
NODE_SIZE = Len(n1)

Type LinkedList
    headPtr As _Offset
    tailPtr As _Offset
    length As Integer
End Type


' add node to end of linked list
Sub APPEND_NODE (lis As LinkedList, value As Integer)
    Dim node As Node
    node.value = value

    ' store node in memory
    Dim nodeBlock As _MEM
    nodeBlock = _MemNew(NODE_SIZE)
    _MemPut nodeBlock, nodeBlock.OFFSET, node

    ' if linked list is empty
    If lis.length = 0 Then
        lis.headPtr = nodeBlock.OFFSET
        lis.tailPtr = lis.headPtr

        lis.length = 1
        Exit Sub
    End If

    Dim current As Node
    Dim m As _MEM
    m = _Mem(lis.headPtr, NODE_SIZE)
    _MemGet m, m.OFFSET, current

    While current.nextAddr <> 0
        m = _Mem(current.nextAddr, NODE_SIZE)

        _MemGet m, m.OFFSET, current
    Wend

    current.nextAddr = nodeBlock.OFFSET

    ' update last node in memory
    Dim lastBlock As _MEM
    lastBlock = _Mem(lis.tailPtr, NODE_SIZE)

    _MemPut lastBlock, lastBlock.OFFSET, current

    lis.tailPtr = current.nextAddr

    lis.length = lis.length + 1
End Sub


' add node to front of linked list
Sub PREPEND_NODE (lis As LinkedList, value As Integer)
    Dim node As Node
    node.value = value
    node.nextAddr = lis.headPtr

    Dim nodeBlock As _MEM
    nodeBlock = _MemNew(NODE_SIZE)
    _MemPut nodeBlock, nodeBlock.OFFSET, node

    lis.headPtr = nodeBlock.OFFSET

    lis.length = lis.length + 1
End Sub


' remove node at index
Sub REMOVE_NODE (lis As LinkedList, index As Integer)
    If lis.length = 0 Then
        Print "Linked list is empty!"
        End
    ElseIf index < 0 Or index >= lis.length Then
        Print "Index out of bounds!"
        End
    End If

    Dim m As _MEM
    m = _Mem(lis.headPtr, NODE_SIZE)

    Dim current As Node
    _MemGet m, m.OFFSET, current

    ' if index is at the front
    If index = 0 Then
        lis.headPtr = current.nextAddr

        _MemFree m

        If lis.headPtr = 0 Then
            lis.tailPtr = 0
        End If

        lis.length = lis.length - 1
        Exit Sub
    End If

    ' track previous node
    Dim previous As Node
    Dim addr As _Offset

    previous = current
    addr = m.OFFSET

    ' shift probe forward
    m = _Mem(current.nextAddr, NODE_SIZE)
    _MemGet m, m.OFFSET, current

    For i = 1 To index - 1
        previous = current
        addr = m.OFFSET

        m = _Mem(current.nextAddr, NODE_SIZE)
        _MemGet m, m.OFFSET, current
    Next i

    previous.nextAddr = current.nextAddr

    ' update previous node in memory
    Dim previousBlock As _MEM
    previousBlock = _Mem(addr, NODE_SIZE)

    _MemPut previousBlock, previousBlock.OFFSET, previous
    _MemFree m

    ' update tail pointer if last node is removed
    If index = length - 1 Then
        lis.tailPtr = addr
    End If

    lis.length = lis.length - 1
End Sub


' get value of node at index
Function GET_NODE% (lis As LinkedList, index As Integer)
    If index < 0 Or index >= lis.length Then
        Print "Index out of bounds!"
        End
    End If

    Dim current As Node
    Dim m As _MEM
    m = _Mem(lis.headPtr, NODE_SIZE)
    _MemGet m, m.OFFSET, current

    For i = 0 To index - 1
        m = _Mem(current.nextAddr, Len(current))
        _MemGet m, m.OFFSET, current
    Next i

    GET_NODE% = current.value
End Function

' return string representation of linked list
Function TO_STR$ (lis As LinkedList)
    If lis.length = 0 Then
        TO_STR$ = "{ }"
        Exit Function
    End If

    Dim current As Node
    Dim m As _MEM
    m = _Mem(lis.headPtr, NODE_SIZE)
    _MemGet m, m.OFFSET, current

    Dim repr As String
    repr = "{ "

    While current.nextAddr <> 0
        repr = repr + Str$(current.value) + " <- "

        m = _Mem(current.nextAddr, Len(current))

        _MemGet m, m.OFFSET, current
    Wend

    repr = repr + Str$(current.value) + " }"

    TO_STR$ = repr
End Function
