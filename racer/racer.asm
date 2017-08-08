.model small

;--------- Racer.com --------

;--------- Constants --------

fill equ 010h
cur equ 011h
asfalto equ 07h
sta_sto equ 044h
char_road equ 0fah
contkm equ 060h
prop_km equ 060h
prop_pa equ 0a4h
ctime equ 084h
prop_who equ 0a8h

;--------- Group definition --------

racer group main, data
assume cs:racer, ds:racer

nga:
main segment
  org 100h
  master proc near
    call myres
    call clear_s
    mov bl, asfalto
    mov al, char_road
    lea si, track
    call print_map
    xor al, al
    mov bl, contkm
    lea si, cont
    call print_map
    mov dh, 02h
    mov dl, 025h
    call mov_cur
    xor al, al
    mov bl, contkm
    mov ah, 09h
    xor bh, bh
    mov cx, 0001h
    int 10h
    call star_st
    call write_who
    call w_speed
    jmp fit
  cicle:
    call time_pause
  nopa:
    call check
    or al, al
    je last_command
  fii:
    call in_a
    or bl, bl
    je nor
    jmp sps
  nor:
    lea si, input_n
  check1:
    cmp byte ptr [si], 00h
    je nopa
    cmp byte ptr [si], al
    je ok
    add si, 03h
    jmp check1
  ok:
    inc si
    call word ptr [si]
    jmp nopa
  sps:
    lea si, input_s
  check2:
    cmp byte ptr [si], 00h
    je nopa
    cmp byte ptr [si], al
    je ok2
    add si, 03h
    jmp check2
  ok2:
    int si
    call word ptr [si]
    dec si
    mov dl, al
    mov com_in_use, dl
    jmp cicle
  last_command:
    mov dl, com_in_use
    lea si, input_s
  check4:
    cmp byte ptr [si], 00h
    je cicle
    cmp byte ptr [si], dl
    je ok4
    add si, 03h
    jmp check4
  ok4:
    inc si
    call word ptr [si]
    jmp cicle
  master endp
    
