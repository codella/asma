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
