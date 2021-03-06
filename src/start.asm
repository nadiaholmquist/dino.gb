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
	jp lcdc
SECTION "Timer",  ROM0 [$50]
	reti
SECTION "Serial", ROM0 [$58]
	reti
SECTION "Joypad", ROM0 [$60]
	reti


section "Header", rom0[$100]
	nop
	jp start
	ds $4C

section "Start", rom0[$150]

start:
	ld sp, $FFFE
	ld a, %11100100
	ldh [rBGP], a
	ld a, %11010000
	ldh [rOBP0], a

	call disable_lcd
	ld de, ground_gfx
	ld hl, _VRAM + 16
	ld c, 75
	call copy_1bpp
	ld de, cloud_gfx
	ld hl, v_cloud
	ld c, 6 * 2
	call copy_1bpp2
	call clear_screen0

	call fill_initial_ground

	ld a, $8
	ld [w_cloud_delay], a
	xor a
	ld [w_cloud_scroll], a

	ld a, 119
	ld [rLYC], a
	ld a, STATF_LYC
	ldh [rSTAT], a

	call enable_lcd
	ldh a, [rIE]
	or IEF_VBLANK | IEF_LCDC
	ldh [rIE], a
	ei

.loop
	halt
	jr .loop