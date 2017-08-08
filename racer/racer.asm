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
  
  check proc near
    mov ah, 0bh
    int 21h
    ret
  check endp
  
  cge_cur proc near
    puch ax
    push bx
    push cx
    push dx
    mov ch, al
    xor bh, bh
    mov dh, pos_r
    mov dl, pos_c
    mov ah, 02h
    int 10h
    mov ah, 08h
    int 10h
    mov old_prop, ah
    mov old_char, al
    mov ah, 09h
    mov cx, 0001h
    mov al, ch
    int 10h
    pop dx
    pop cx
    pop bx
    pop ax
  cge_cur endp
  
  in_a proc near
    mov ah, 07h
    int 21h
    or al, al
    je spe
    xor bl, bl
    ret
  spe:
    int 21h
    mov bl, 0ffh
    ret
  int_a endp
  
  time_pause
    push ax
    push bx
    push cx
    push dx
    pushf
    xor ch, ch
    mov cl, cyls
  inni:
    push cx
    mov ah, 02ch
    int 21h
    mov cent_p, dl
  tryy:
    int 21h
    cmp dl, cent_p
    jb adding
  uuli:
    sub dl, cent_p
    cmp dl, 05h
    jb tryy
    pop cx
    loop inni
    call w_speed ; prima decremetna e poi salta se diverso da zero
    popf
    pop dx
    pop cx
    pop bx
    pop ax
    ret
  adding:
  add dl, 064h
  jmp uuli
time_pause endp

clear_s proc near
  push ax
  push bx
  push cx
  push dx
  mov ah, 06h
  mov bh, fill
  xor cx, cx
  mov dh, 24
  mov dl, 39
  int 10h
  pop dx
  pop cx
  pop bx
  pop ax
  ret
clear_s endp

mov_cur proc near
  push ax
  push bx
  push dx
  xor bh, bh
  mov ah, 02h
  int 10h
  pop dx
  pop bx
  pop ax
  ret
mov_cur endp

exit proc near
  call oldres
  call dos_r
exit endp

dos_r proc near
  int 20h
dos_r endp

su proc near
  call load_prop
  mov bl, pos_r
  or bl, bl
  je no3
  dec bl
  mov pos_r, bl
  call out_road
  or bh, bh
  jo no3
  call is_goal
  or bl, bl
  jne oik1
  mov bl, cur
  call cge_cur
  ret
no3:
  call bad_exit
oik1:
  call good_exit
su endp

giu proc nead
  call load_prop
  push dx
su endp
    
  
