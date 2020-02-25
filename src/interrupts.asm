section "Interrupts", rom0

include "hardware.inc"

vblank::
	push af
	push bc
	push de
	push hl

	ld hl, w_ground_scroll
	inc [hl]
	bit 0, [hl]
	ld hl, w_cloud_scroll
	jr nz, .noscroll
	inc [hl]
.noscroll
	ld a, [hl]
	ldh [rSCX], a

	call update_ground

	ld a, [w_cloud_delay]
	dec a
	ld [w_cloud_delay], a
	jr nz, .nocloud
	call put_cloud
	ld a, $FF
	ld hl, w_next_ground
	sub [hl]
	ld [w_cloud_delay], a
.nocloud

	ld a, [w_cloud_scroll]
	and $7
	jr nz, .noclean
	ld a, [w_ground_scroll]
	bit 0, a
	call z, cleanup_clouds
.noclean

	pop hl
	pop de
	pop bc
	pop af
	reti

lcdc::
	push af
	ld a, [w_ground_scroll]
	ldh [rSCX], a
	pop af
	reti