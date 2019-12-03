section "Interrupts", rom0

include "hardware.inc"

vblank::
	push af
	ld a, [rSCX]
	inc a
	ld [rSCX], a
	pop af
	reti