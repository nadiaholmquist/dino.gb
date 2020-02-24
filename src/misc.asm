include "hardware.inc"

section "Misc Routines", rom0

enable_lcd::
	ld a, [rLCDC]
	set 7, a
	ld [rLCDC], a
	ret

disable_lcd::
	ld a, [rLY]
	cp 144
	jr nz, disable_lcd
	ld a, [rLCDC]
	res 7, a
	ld [rLCDC], a
	ret

; Copies 1bpp graphics from ROM
;
; de: Location of the graphics to copy
; hl: Destination
; c: Number of tiles
copy_1bpp::
rept 8
	ld a, [de]
	ld [hli], a
	ld [hli], a
	inc de
endr
	dec c
	jr nz, copy_1bpp
	ret

clear_screen0::
	ld hl, _SCRN0
.loop
	ld a, $FF
	ld [hli], a
	ld a, h
	cp $9C
	jr nz, .loop
	ret