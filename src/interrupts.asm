section "Interrupts", rom0

include "hardware.inc"

vblank::
	push af
	push bc
	push de
	push hl

	ld a, [rSCX]
	inc a
	ld [rSCX], a

	call update_ground

	pop hl
	pop de
	pop bc
	pop af
	reti