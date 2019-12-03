include "hardware.inc"

SECTION "RST 00", ROM0 [$00]
	rst $38
SECTION "RST 08", ROM0 [$08]
	rst $38
SECTION "RST 10", ROM0 [$10]
	rst $38
SECTION "RST 18", ROM0 [$18]
	rst $38
SECTION "RST 20", ROM0 [$20]
	rst $38
SECTION "RST 28", ROM0 [$28]
	rst $38
SECTION "RST 30", ROM0 [$30]
	rst $38
SECTION "RST 38", ROM0 [$38]
	rst $38

SECTION "VBlank", ROM0 [$40]
	jp vblank
SECTION "LCDC", ROM0 [$48]
	reti
SECTION "Timer",  ROM0 [$50]
	reti
SECTION "Serial", ROM0 [$58]
	reti
SECTION "Joypad", ROM0 [$60]
	reti


section "Header", rom0[$100]
	nop
	jp start

section "Start", rom0[$150]

start:
	ld sp, $FFFE
	ld a, %11100100
	ld [rBGP], a
	ld a, %11010000
	ld [rOBP0], a

	call disable_lcd
	ld de, ground_gfx
	ld hl, _VRAM
	ld c, 75
	call copy_1bpp
	call enable_lcd
	ld a, [rIE]
	or IEF_VBLANK
	ld [rIE], a
	ei

.loop
	halt
	jr .loop