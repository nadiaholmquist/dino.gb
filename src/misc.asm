include "hardware.inc"

section "Misc Routines", rom0

enable_lcd::
	ldh a, [rLCDC]
	set 7, a
	ldh [rLCDC], a
	ret

disable_lcd::
	ldh a, [rLY]
	cp 144
	jr nz, disable_lcd
	ldh a, [rLCDC]
	res 7, a
	ldh [rLCDC], a
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

; this sucks
copy_1bpp2::
rept 8
	ld a, [de]
	ld [hli], a
	inc hl
	ld [hl], 0
	inc de
endr
	dec c
	jr nz, copy_1bpp2
	ret

clear_screen0::
	ld hl, _SCRN0
.loop
	xor a
	ld [hli], a
	ld a, h
	cp $9C
	jr nz, .loop
	ret