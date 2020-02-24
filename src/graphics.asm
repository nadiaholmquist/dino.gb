include "hardware.inc"
section "Graphics", rom0

ground_gfx::
	incbin "ground.1bpp"

ground_pos equ 15

fill_initial_ground::
	ld hl, _SCRN0 + (32 * ground_pos)
	xor a
.loop
	ld [hli], a
	inc a
	cp a, 32
	jr nz, .loop
	ld [w_next_ground], a
	ret

; should be called during vblank
update_ground::
	ld a, [rSCX]
	and $7
	ret nz
	ld a, [rSCX]
	and $F8
	swap a
	rlca
	ld hl, _SCRN0 + (32 * ground_pos)
	add l
	ld l, a
	dec l
	set 5, l
	ld a, [w_next_ground]
	ld [hl], a
	inc a
	cp 75
	jr nz, .noreset
	xor a
.noreset
	ld [w_next_ground], a
	ret