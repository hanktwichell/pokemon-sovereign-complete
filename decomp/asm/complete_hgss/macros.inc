#pragma once
; Sovereign Complete: the macros.inc of HeartGold's assembly (pret's pokeheartgold asm/macros.inc, with its
; macros/function.inc and macros/cw.inc), for the files tools/complete/import_hgss_asm.py copies into this folder.
; hgss_compat.inc comes first: its #defines give the engine functions the files call Platinum's names (or a shim's),
; from here on in each file, its own .inc's .public lines included.

	.include "hgss_compat.inc"

	.macro arm_func_start name
	.balign 4, 0
	.global \name
	.type \name, @function
	.arm
	.endm

	.macro local_arm_func_start name
	.balign 4, 0
	.arm
	.endm

	.macro arm_func_end name
	.size \name, .-\name
	.endm

	.macro thumb_func_start name
	.balign 4, 0
	.global \name
	.type \name, @function
	.thumb
	.endm

	.macro non_word_aligned_thumb_func_start name
	.global \name
	.type \name, @function
	.thumb
	.endm

	.macro thumb_func_end name
	.size \name, .-\name
	.endm

	.macro exception what, size, data
	.section .exceptix,4,1,2
	.balign 4, 0
	.type ?exc$\what, @object
	.global ?exc$\what
	.size ?exc$\what, 12
?exc$\what:
	.word \what
	.short \size
	.word \data
	.previous
	.endm
