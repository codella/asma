; -----------------------------------------------------------------------------
; Racer.com - DOS Text-Mode Racing Game
; This program initializes a racing track in text mode, draws the road,
; handles user input, updates the car's position, and manages the game loop.
; It uses BIOS and DOS interrupts for screen and keyboard operations.
; -----------------------------------------------------------------------------
.model small                        ; Use the SMALL memory model

;--------- Racer.com --------

;--------- Constants --------

fill equ 010h                       ; Attribute for screen fill (background)
cur equ 011h                        ; Attribute for cursor
asfalto equ 07h                     ; Attribute for road color
sta_sto equ 044h                    ; Attribute for start/stop
char_road equ 0fah                  ; Character for road
contkm equ 060h                     ; Counter for kilometers
prop_km equ 060h                    ; Property for kilometers
prop_pa equ 0a4h                    ; Property for player
ctime equ 084h                      ; Property for current time
prop_who equ 0a8h                   ; Property for player identity

;--------- Group definition --------

racer group main, data              ; Define segment group
assume cs:racer, ds:racer           ; Set code and data segment registers

nga:
main segment
  org 100h                         ; .COM program entry point
  master proc near                  ; Main procedure
    call myres                     ; Initialize resources
    call clear_s                   ; Clear the screen
    mov bl, asfalto                ; Set BL to road color attribute
    mov al, char_road              ; Set AL to road character
    lea si, track                  ; Load address of track into SI
    call print_map                 ; Draw the track
    xor al, al                     ; Clear AL (set to 0)
    mov bl, contkm                 ; Set BL to kilometer counter attribute
    lea si, cont                   ; Load address of counter into SI
    call print_map                 ; Draw the counter
    mov dh, 02h                    ; Set DH to row 2
    mov dl, 025h                   ; Set DL to column 25
    call mov_cur                   ; Move cursor to (2, 25)
    xor al, al                     ; Clear AL
    mov bl, contkm                 ; Set BL to kilometer counter attribute
    mov ah, 09h                    ; AH = 09h (write character/attribute)
    xor bh, bh                     ; BH = 0 (page number)
    mov cx, 0001h                  ; CX = 1 (repeat count)
    int 10h                        ; BIOS: Write character at cursor
    call star_st                   ; Call start/stop routine
    call write_who                 ; Write player identity
    call w_speed                   ; Write speed
    jmp fit                        ; Jump to fit label
  cicle:
    call time_pause                ; Pause for a time interval
  nopa:
    call check                     ; Check for user input
    or al, al                      ; Test AL
    je last_command                ; Jump if no input
  fii:
    call in_a                      ; Read input
    or bl, bl                      ; Test BL
    je nor                         ; Jump if no input
    jmp sps                        ; Jump to sps label
  nor:
    lea si, input_n                ; Load address of input_n into SI
  check1:
    cmp byte ptr [si], 00h         ; Check if end of input_n
    je nopa                        ; Jump if end
    cmp byte ptr [si], al          ; Compare input with AL
    je ok                          ; Jump if match
    add si, 03h                    ; Move to next input
    jmp check1                     ; Repeat check
  ok:
    inc si                         ; Increment SI
    call word ptr [si]             ; Call function at SI
    jmp nopa                       ; Jump to nopa label
  sps:
    lea si, input_s                ; Load address of input_s into SI
  check2:
    cmp byte ptr [si], 00h         ; Check if end of input_s
    je nopa                        ; Jump if end
    cmp byte ptr [si], al          ; Compare input with AL
    je ok2                         ; Jump if match
    add si, 03h                    ; Move to next input
    jmp check2                     ; Repeat check
  ok2:
    int si                         ; Call interrupt at SI
    call word ptr [si]             ; Call function at SI
    dec si                         ; Decrement SI
    mov dl, al                     ; Move AL to DL
    mov com_in_use, dl             ; Store DL in com_in_use
    jmp cicle                      ; Jump to cicle label
  last_command:
    mov dl, com_in_use             ; Load last command
    lea si, input_s                ; Load address of input_s into SI
  check4:
    cmp byte ptr [si], 00h         ; Check if end of input_s
    je cicle                       ; Jump if end
    cmp byte ptr [si], dl          ; Compare input with DL
    je ok4                         ; Jump if match
    add si, 03h                    ; Move to next input
    jmp check4                     ; Repeat check
  ok4:
    inc si                         ; Increment SI
    call word ptr [si]             ; Call function at SI
    jmp cicle                      ; Jump to cicle label
  master endp
  
  check proc near
    mov ah, 0bh                    ; DOS: Check keyboard input
    int 21h                        ; Interrupt 21h
    ret                            ; Return
  check endp
  
  cge_cur proc near
    push ax                        ; Save AX
    push bx                        ; Save BX
    push cx                        ; Save CX
    push dx                        ; Save DX
    mov ch, al                     ; Move AL to CH
    xor bh, bh                     ; Clear BH
    mov dh, pos_r                  ; Load row position
    mov dl, pos_c                  ; Load column position
    mov ah, 02h                    ; BIOS: Set cursor position
    int 10h                        ; Interrupt 10h
    mov ah, 08h                    ; BIOS: Read character/attribute
    int 10h                        ; Interrupt 10h
    mov old_prop, ah               ; Save attribute
    mov old_char, al               ; Save character
    mov ah, 09h                    ; BIOS: Write character/attribute
    mov cx, 0001h                  ; CX = 1 (repeat count)
    mov al, ch                     ; Load character
    int 10h                        ; Interrupt 10h
    pop dx                         ; Restore DX
    pop cx                         ; Restore CX
    pop bx                         ; Restore BX
    pop ax                         ; Restore AX
    ret                            ; Return
  cge_cur endp
  
  in_a proc near
    mov ah, 07h                    ; DOS: Direct console input
    int 21h                        ; Interrupt 21h
    or al, al                      ; Test AL
    je spe                         ; Jump if no input
    xor bl, bl                     ; Clear BL
    ret                            ; Return
  spe:
    int 21h                        ; Interrupt 21h
    mov bl, 0ffh                   ; Set BL to -1
    ret                            ; Return
  int_a endp
  
  time_pause
    push ax                        ; Save AX
    push bx                        ; Save BX
    push cx                        ; Save CX
    push dx                        ; Save DX
    pushf                          ; Save flags
    xor ch, ch                     ; Clear CH
    mov cl, cyls                   ; Load cycles into CL
  inni:
    push cx                        ; Save CX
    mov ah, 02ch                   ; DOS: Get system time
    int 21h                        ; Interrupt 21h
    mov cent_p, dl                 ; Save centiseconds
  tryy:
    int 21h                        ; Interrupt 21h
    cmp dl, cent_p                 ; Compare centiseconds
    jb adding                      ; Jump if less
  uuli:
    sub dl, cent_p                 ; Subtract centiseconds
    cmp dl, 05h                    ; Compare with 5
    jb tryy                        ; Jump if less
    pop cx                         ; Restore CX
    loop inni                      ; Loop
    call w_speed                   ; Update speed
    popf                           ; Restore flags
    pop dx                         ; Restore DX
    pop cx                         ; Restore CX
    pop bx                         ; Restore BX
    pop ax                         ; Restore AX
    ret                            ; Return
  adding:
    add dl, 064h                   ; Add 100
    jmp uuli                       ; Jump to uuli
  time_pause endp

  clear_s proc near
    push ax                        ; Save AX
    push bx                        ; Save BX
    push cx                        ; Save CX
    push dx                        ; Save DX
    mov ah, 06h                    ; BIOS: Scroll screen
    mov bh, fill                   ; Set fill attribute
    xor cx, cx                     ; Clear CX
    mov dh, 24                     ; Set bottom row
    mov dl, 39                     ; Set bottom column
    int 10h                        ; Interrupt 10h
    pop dx                         ; Restore DX
    pop cx                         ; Restore CX
    pop bx                         ; Restore BX
    pop ax                         ; Restore AX
    ret                            ; Return
  clear_s endp

  mov_cur proc near
    push ax                        ; Save AX
    push bx                        ; Save BX
    push dx                        ; Save DX
    xor bh, bh                     ; Clear BH
    mov ah, 02h                    ; BIOS: Set cursor position
    int 10h                        ; Interrupt 10h
    pop dx                         ; Restore DX
    pop bx                         ; Restore BX
    pop ax                         ; Restore AX
    ret                            ; Return
  mov_cur endp

  exit proc near
    call oldres                    ; Restore resources
    call dos_r                     ; Exit to DOS
  exit endp

  dos_r proc near
    int 20h                        ; DOS: Terminate program
  dos_r endp

  su proc near
    call load_prop                 ; Load properties
    mov bl, pos_r                  ; Load row position
    or bl, bl                      ; Test BL
    je no3                         ; Jump if zero
    dec bl                         ; Decrement BL
    mov pos_r, bl                  ; Update row position
    call out_road                  ; Output road
    or bh, bh                      ; Test BH
    jo no3                         ; Jump if overflow
    call is_goal                   ; Check if goal reached
    or bl, bl                      ; Test BL
    jne oik1                       ; Jump if not equal
    mov bl, cur                    ; Load cursor attribute
    call cge_cur                   ; Change cursor
    ret                            ; Return
  no3:
    call bad_exit                  ; Handle bad exit
  oik1:
    call good_exit                 ; Handle good exit
  su endp

  giu proc nead
    call load_prop                 ; Load properties
    push dx                        ; Save DX
  su endp


