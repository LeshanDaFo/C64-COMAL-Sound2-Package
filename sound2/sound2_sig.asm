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
    
;-- patch the IRQ-routine at $C3BF

;-- executed on the LINK command
    CPY #LINK
    BEQ +
    CPY #DSCRD                  ; if DISCARD
    BEQ .reset
    CPY #BASIC                  ; if BASIC
    BNE ++

;-- reset main IRQ on DISCARD or BASIC
;-- also called from 'reset'irq'
.reset
    SEI
    LDA #<$B96F
    STA $C3DF
    LDA #>$B96F
    STA $C3E0
    LDA #<$BC44
    STA $C3F5
    LDA #>$BC44
    STA $C3F6
    CLI
    RTS


;-- copy jump table
; called on LINK, and also on 'set'irq'
.setirq
+   SEI
    LDY #$0F
-   LDA .jmp_table,Y
    STA $C86A,Y
    DEY
    BPL -

;$C86A : *="+17 ; reserved for future use
;-- patch main-IRQ
    LDA #<$C86A
    STA $C3DF
    LDA #>$C86A
    STA $C3E0
    LDA #<$C872
    STA $C3F5
    LDA #>$C872
    STA $C3F6
    CLI
++  RTS

;-- add a jump table to the location at $C86A
;-- this is a free are "for future use"
;-- but it is not used now by any programm i know

.jmp_table
    LDA #$E0
    STA $DE00
    JMP .irq1
    LDA #$E0
    STA $DE00
    JMP .irq2
