; ###############################################################################
; #                                                                             #
; #  C64 COMAL80 PACKAGE SOUND2                                                 #
; #  Version 1.0 (2025.04.12)                                                   #
; #  Copyright (c) 2025 Claus Schlereth                                         #
; #                                                                             #
; #  This version of the source code is under MIT License                       #
; #  https://github.com/LeshanDaFo/C64-COMAL-Sound2-Package/blob/main/LICENSE   #
; #                                                                             #
; ###############################################################################


start   =   $8009

    !source "sound2/soundsymb.asm"
    !source "c64symb.asm"

*= start

    !by  DEFPAG                     ; ram area from $8000
    !word endPkg                    ; the program end address
    !word signal                    ; the address of the signal handler

;-- package table -----------------
    !pet $06,"sound2"               ; package name
    !word ptSound                   ; proc table
    !word init_Sound                ; proc init
    !by $00

signal
    !source "sound2/sound2_sig.asm"

;-- init --------------------------
init_Sound
JSR .setirq                         ; change IRQ

;-- call the init routine in the sound package
;-- in Page 4 ($83) at address $B287
jsr CALL
!by PAGE4
!word $B287
RTS

;-- procedure table ---------------
ptSound
    !source "sound2/sound2_hdr_tbl.asm"
    !by $00

;-- procedure header --------------
    !source "sound2/sound2_prc_tbl.asm"
    

;-- code --------------------------
    !source "sound2/sound2_code.asm"


;-- irq ---------------------------
    !source "sound2/sound2_irq.asm"

endPkg