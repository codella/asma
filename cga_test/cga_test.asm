.MODEL SMALL
.CODE
  ORG 100h
  MASTER PROC NEAR
    XOR AH, AH
    MOV AL, 04h
    INT 10h
    MOV AH, 0Bh
    XOR BH, BH
    MOV BL, 11
    INT 10h
    MOV BH, 01h
    MOV BL, 00h
    INT 10h
    XOR BH, BH
    MOV AH, 0Ch
    MOV AL, 02h
    MOV CX, 160
    MOV DX, 100
    INT 10h
    MOV AH, 07h
    INT 21h
    XOR AH, AH
    MOV AL, 03h
    INT 10h
    INT 20h
  MASTER ENDP
END MASTER