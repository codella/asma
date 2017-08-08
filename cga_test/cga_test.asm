.model small
.code
  org 100h
  master proc near
    xor ah, ah
    mov al, 04h
    int 10h
    mov ah, 0bh
    xor bh, bh
    mov bl, 11
    int 10h
    mov bh, 01h
    mov bl, 00h
    int 10h
    xor bh, bh
    mov ah, 0ch
    mov al, 02h
    mov cx, 160
    mov dx, 100
    int 10h
    mov ah, 07h
    int 21h
    xor ah, ah
    mov al, 03h
    int 10h
    int 20h
  master endp
end master