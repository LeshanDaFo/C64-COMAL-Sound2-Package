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


phSetIRQ
    !by PROC
    !word .setirq
    !by $00
    !by ENDPRC;

phResetIRQ
    !by PROC
    !word .reset
    !by $00
    !by ENDPRC;

;-- FUNC VersSound$
;
phVersSound
    !by FUNC + STR
    !word VersSound2            ; proc code address
    !by $00                     ; count of params
    !by ENDFNC

; $B15B
phNote
    !by PROC
    !word procNote
    !by $02
    !by VALUE + INT
    !by VALUE + STR
    !by ENDPRC

; $B162
phPulse
    !by PROC
    !word procPulse
    !by $02
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B169
phGate
    !by PROC
    !word procGate
    !by $02
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B170
phSoundtype
    !by PROC
    !word procSoundtype
    !by $02
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B177
phRingmod
    !by PROC
    !word procRingmod
    !by $02
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B17E
phSync
    !by PROC
    !word procSync
    !by $02
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B185
phAdsr
    !by PROC
    !word procAdsr
    !by $05
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B18F
phFilterfreq
    !by PROC
    !word procFilterfreq
    !by $01
    !by VALUE + INT
    !by ENDPRC

; $B195
phResonance
    !by PROC
    !word procResonance
    !by $01
    !by VALUE + INT
    !by ENDPRC

; $B19B
phFilter
    !by PROC
    !word procFilter
    !by $04
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B1A4
phFiltertype
    !by PROC
    !word procFiltertype
    !by $04
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B1AD
phVolume
    !by PROC
    !word procVolume
    !by $01
    !by VALUE + INT
    !by ENDPRC

; $B1B3
phEnv3
    !by FUNC
    !word funcEnv3
    !by $00
    !by ENDFNC

; $B1B8
phOsc3
    !by FUNC
    !word funcOsc3
    !by $00
    !by ENDFNC

; $B1BD
phFrequency
    !by FUNC
    !word funcFrequency
    !by $01
    !by VALUE + STR
    !by ENDFNC

; $B1C3
phSetscore
    !by PROC
    !word procSetscore
    !by $04
    !by VALUE + INT
    !by REF + ARRAY + INT,1
    !by REF + ARRAY + INT,1
    !by REF + ARRAY + INT,1    
    !by ENDPRC

; $B1CF
phPlayscore
    !by PROC
    !word procPlayscore
    !by $03
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B1D7
phStopplay
    !by PROC
    !word procStopplay
    !by $03
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by ENDPRC

; $B1DF
phWaitscore
    !by FUNC
    !word procWaitscore
    !by $03
    !by VALUE + INT
    !by VALUE + INT
    !by VALUE + INT
    !by ENDFNC

; $B1E7
phSetfrequency
    !by PROC
    !word procSetfrequency
    !by $02
    !by VALUE + INT
    !by VALUE + REAL
    !by ENDPRC

