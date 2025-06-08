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

; Sound
ptSound
;
    !pet $07,"set'irq"
    !word phSetIRQ
;    
    !pet $09,"reset'irq"
    !word phResetIRQ
;    
    !pet $0e,"version'sound2"
    !word phVersSound
;    
    !pet $05,"note2"
    !word phNote                ; $B15B
;
    !pet $06,"pulse2"
    !word phPulse               ; $B162
;
    !pet $05,"gate2"
    !word phGate                ; $B169
;
    !pet $0A,"soundtype2"
    !word phSoundtype           ; $B170
;
    !pet $08,"ringmod2"
    !word phRingmod             ; $B177
;
    !pet $05,"sync2"
    !word phSync                ; $B17E
;
    !pet $05,"adsr2"
    !word phAdsr                ; $B185
;
    !pet $0b,"filterfreq2"
    !word phFilterfreq          ; $B18F
;
    !pet $0A,"resonance2"
    !word phResonance           ; $B195
;
    !pet $07,"filter2"
    !word phFilter              ; $B19B
;
    !pet $0b,"filtertype2"
    !word phFiltertype          ; $B1A4
;
    !pet $07,"volume2"
    !word phVolume              ; $B1AD
;
    !pet $05,"env32"
    !word phEnv3                ; $B1B3
;
    !pet $05,"osc32"
    !word phOsc3                ; $B1B8
;
    !pet $0a,"frequency2"
    !word phFrequency           ; $B1BD
;
    !pet $09,"setscore2"
    !word phSetscore            ; $B1C3
;
    !pet $0a,"playscore2"
    !word phPlayscore           ; $B1CF
;
    !pet $09,"stopplay2"
    !word phStopplay            ; $B1D7
;
    !pet $0a,"waitscore2"
    !word phWaitscore           ; $B1DF
;
    !pet $0d,"setfrequency2"
    !word phSetfrequency        ; $B1E7

    !by $00
