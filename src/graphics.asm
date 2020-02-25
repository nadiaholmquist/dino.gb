include "hardware.inc"
section "Graphics", rom0

ground_gfx::
	incbin "ground.1bpp"
.end
ground_gfx_size equ .end - ground_gfx
export ground_gfx_size

cloud_gfx::
	incbin "cloud.1bpp"
.end
cloud_gfx_size equ .end - cloud_gfx
export cloud_gfx_size

ground_pos equ 15

fill_initial_ground::
	ld hl, _SCRN0 + (32 * ground_pos)
	ld a, 1
.loop
	ld [hli], a
	inc a
	cp a, 33
	jr nz, .loop
	ld [w_next_ground], a
	ret

; should be called during vblank
update_ground::
	ld a, [w_ground_scroll]
	and $7
	ret nz
	ld a, [w_ground_scroll]
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
	cp 76
	jr nz, .noreset
	ld a, 1
.noreset
	ld [w_next_ground], a
	ret

; Put a cloud at a randomish y position
put_cloud::
	; we'll use the next ground tile number as a 'random' value
	ld a, [w_next_ground]
	rlca
	and $E0
	ld b, a ; store lower bits of row number
	ld a, [w_cloud_scroll]
	add $A8 ; screen width + 1 tile
	and $F8
	swap a
	rlca
	set 7, b ; move it down a bit
	or b
	ld h, HIGH(_SCRN0)
	ld l, a
	ld c, $4C
	push hl
	call .do_loop
	pop hl
	ld a, l ; move down a row
	add 32
	ld l, a
	jr nc, .next
	inc h
.next
	and $E0
	ld b, a
	call .do_loop
	ret
.do_loop
	ld d, 6
.loop
	ld [hl], c
	inc c
	ld a, l
	inc a
	and $1F ; remove upper 3 bits
	or b ; and put the lower bits of the row so we don't wrap
	ld l, a
	dec d
	jr nz, .loop
	ret

cleanup_clouds::
	ld a, [w_cloud_scroll]
	sub 8
	and $F8
	swap a
	rlca
	set 7, a
	ld h, $98
	ld l, a
	ld b, 8
	ld de, 32
.loop
	ld [hl], 0
	add hl, de
	dec b
	jr nz, .loop
	ret