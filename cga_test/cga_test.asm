; -----------------------------------------------------------------------------
; CGA Graphics Demo: Sets CGA graphics mode, changes palette, plots a pixel,
; waits for a keypress, then restores text mode and exits.
; Runs as a .COM program under DOS.
; -----------------------------------------------------------------------------

.MODEL SMALL           ; Use the SMALL memory model (code and data fit in 64KB)
.CODE                  ; Start of code segment
  ORG 100h             ; .COM program entry point (offset 100h)
  MASTER PROC NEAR     ; Define procedure MASTER

    XOR AH, AH         ; AH = 0 (clear AH)
    MOV AL, 04h        ; AL = 4 (CGA graphics mode 320x200, 4 colors)
    INT 10h            ; BIOS: Set video mode

    MOV AH, 0Bh        ; AH = 0Bh (set palette)
    XOR BH, BH         ; BH = 0 (background page)
    MOV BL, 11         ; BL = 11h (palette: high intensity, color set 1)
    INT 10h            ; BIOS: Set palette

    MOV BH, 01h        ; BH = 1 (set border color)
    MOV BL, 00h        ; BL = 0 (border color black)
    INT 10h            ; BIOS: Set border color

    XOR BH, BH         ; BH = 0 (not used here, just clearing)
    MOV AH, 0Ch        ; AH = 0Ch (write pixel)
    MOV AL, 02h        ; AL = 2 (color 2: green)
    MOV CX, 160        ; CX = 160 (X coordinate)
    MOV DX, 100        ; DX = 100 (Y coordinate)
    INT 10h            ; BIOS: Plot pixel at (160, 100) with color 2

    MOV AH, 07h        ; AH = 7 (wait for keypress, no echo)
    INT 21h            ; DOS: Wait for keypress

    XOR AH, AH         ; AH = 0 (clear AH)
    MOV AL, 03h        ; AL = 3 (text mode 80x25, 16 colors)
    INT 10h            ; BIOS: Set video mode (restore text mode)

    INT 20h            ; DOS: Exit program

  MASTER ENDP          ; End of MASTER procedure
END MASTER             ; Program entry point