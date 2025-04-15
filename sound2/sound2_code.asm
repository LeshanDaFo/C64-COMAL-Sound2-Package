; #######################################################################
; #                                                                     #
; #  C64 COMAL80 PACKAGE SOUND2                                         #
; #  Version 1.0 (2025.04.12)                                           #
; #  Copyright (c) 2025 Claus Schlereth                                 #
; #                                                                     #
; #  This version of the source code is under MIT License               #
; #  https://github.com/LeshanDaFo/C64-COMAL-Packages/blob/main/LICENSE #
; #                                                                     #
; #######################################################################


;get 2 parameter; y (0,1,2), and x (0,7,14)
.lB1EE
    JSR .l95B0                  ; get a parameter, a= high, x= low
    BNE +                       ; invalid voice error
    DEX
    TXA
    STA T1                      ; temporary 1
    TAY                         ; voice no. in y
    CMP #$03                    ; max voice number
    BCS +                       ; invalid voice error
    ASL                         ; calculate register offset (0,7,14)
    ASL
    ASL
    SEC
    SBC T1                      ; temporary 1
    TAX                         ; register offset in x
    RTS
---------------------------------
.error5
    LDX #$05                    ; value out of range
    !by $2c
+   LDX #$23                    ; invalid voice
    JMP RUNERR
---------------------------------
;
; get a parameter (max. 15)
.lB209
    JSR FNDPAR
    JSR .l95B3                  ; load COPY1 with A (high) and X (low)
            ;.l95B3
            ;    LDY #$01
            ;    LDA (COPY1),Y  lowbyte
            ;    TAX
            ;    DEY
            ;    LDA (COPY1),Y  highbyte
            ;    RTS
    BNE .lB225                  ; if value > 255, output error 5
    CPX #$10
    BCS .lB225                  ; if value >= 16, output error 5
    TXA                         ; get value into accu
    RTS
---------------------------------

; get a parameter (0,1)
.lB217                          
    JSR FNDPAR
; also used as jump in from sprite
.lB21A
    LDY #$00
    LDA (COPY1),Y
    INY
    ORA (COPY1),Y
    BEQ +
    TYA

+   RTS
---------------------------------
.lB225
    JMP .error5                 ; error "value out of range"
---------------------------------

;
; get a table pointer 
.lB228
    JSR FNDPAR
    JSR .l95B3                  ; load COPY1 with A and X
    STA COPY3
    STX COPY3+1
    LDY #$06
    SEC
    LDA (COPY1),Y
    LDY #$04
    SBC (COPY1),Y
    STA COPY2+1
    LDY #$05
    LDA (COPY1),Y
    LDY #$03
    SBC (COPY1),Y
    STA COPY2
    LDA $C31D
    ORA $C31E
    BNE +
    LDA COPY2
    STA $C31D
    LDA COPY2+1
    STA $C31E
    JMP ++
---------------------------------
+   LDA COPY2
    CMP $C31D
    BCC .lB225
    BNE ++
    LDA COPY2+1
    CMP $C31E
    BCC .lB225

++  CLC
    ASL COPY2+1
    ROL COPY2
    CLC
    LDA COPY2+1
    ADC COPY3
    STA Q1
    LDA COPY2
    ADC COPY3+1
    STA Q1+1
    LDY #$00
    TYA
    STA (Q1),Y
    INY
    STA (Q1),Y
-   RTS
---------------------------------

;
; procSetfrequency
;
procSetfrequency
    JSR .l9595                  ; get 2. parameter (frequency)
    LDA COPY1
    LDY COPY1+1
    JSR LDAC1                   ; load ac1
    JSR FPINTA                  ; CONVERT AC1 INTO INTEGER (0 .. 65535)

    JSR .lB1EE                  ; get 1. parameter (as offset) into x (0,7,14)
    LDA AC1M4                   ; MANTISSA 4
    STA $D400,X
    LDA AC1M3                   ; MANTISSA 3
    STA $D401,X
    RTS

;
; procNote
;
procNote
    LDA #$02
    JSR .lB316                  ; get 2. parameter (note)
    JSR .lB1EE                  ; get 1. parameter (as offset) into x (0,7,14)
    LDA COPY3
    STA $D401,X
    LDA COPY3+1
    STA $D400,X
    RTS
---------------------------------
.lB311
    LDX #$24                    ; invalid note error
    JMP RUNERR
---------------------------------
; calculate frequency value from note input
.lB316
    JSR FNDPAR
    LDY #$02
    LDA (COPY1),Y
    BNE .lB311                  ; invalid note error
    INY
    LDA (COPY1),Y
    CMP #$02
    BCC .lB311                  ; invalid note error
    CMP #$04
    BCS .lB311                  ; invalid note error
    STA INF1
    INY
    LDA (COPY1),Y
    SEC
    SBC #$41
    BCC .lB311                  ; invalid note error
    CMP #$07
    BCS .lB311                  ; invalid note error
    TAX
    LDA .lB3A7,X
    INY
    INY
    TAX
    BMI +
    LDA INF1
    CMP #$02
    BEQ ++
    LDA (COPY1),Y
    CMP #$20
    BEQ ++
    CMP #$23
    BNE ++
    INX
    BNE ++
+   LDA INF1
    CMP #$02
    BEQ ++
    LDA (COPY1),Y
    CMP #$20
    BNE .lB311                  ; invalid note error
++  TXA
    ASL
    TAX
    CLC
    LDA PALNTS
    BEQ +
    TXA
    ADC #$18
    TAX
    CMP #$2E
+   PHP
    LDA .lB3AE,X
    STA COPY3
    LDA .lB3AE+1,X
    STA COPY3+1
    DEY
    SEC
    LDA #$37
    SBC (COPY1),Y
    BMI .lB311                  ; invalid note error
    BEQ ++
    CMP #$08
    BCS .lB311                  ; invalid note error
    TAX
    PLP
    ROR COPY3
    JMP +

-   LSR COPY3
+   ROR COPY3+1
    DEX
    BNE -
    LDA COPY3+1
    ADC #$00
    STA COPY3+1
    BCC .lB3A0
    INC COPY3
.lB3A0
    RTS
---------------------------------
++  PLP
    BCC .lB3A0
    JMP .lB311                  ; invalid note error
---------------------------------
.lB3A7
    !by $09,$8B,$00,$02,$84,$05,$07
.lB3AE
    !by $86,$1E,$8E,$18,$96,$8B,$9F,$7E 
    !by $A8,$FA,$B3,$06,$BD,$AC,$C8,$F3 
    !by $D4,$E6,$E1,$8F,$EE,$F8,$FD,$2E 
    !by $8B,$38,$93,$80,$9C,$45,$A5,$8F 
    !by $AF,$68,$B9,$D5,$C4,$E3,$D0,$98 
    !by $DC,$FF,$EA,$24,$F8,$0F,$06,$D0

;
; procPulse
;
procPulse
    JSR .l95AB                  ; get 2. parameter pulse width value
    STA COPY3
    STX COPY3+1
    AND #$F0
    BNE .lB3F7                  ; value out of range
    JSR .lB1EE                  ; get 1. parameter (as offset) into x (0,7,14)
    LDA COPY3+1
    STA $D402,X
    LDA COPY3
    STA $D403,X
    RTS
---------------------------------
.lB3F7
    JMP .error5                 ; value out of range
;
; procGate
;
procGate
    LDA #$02                    ; second parameter (on/off)
    JSR .lB217                  ; get parameter, returns 0 or 1
    STA COPY3
    JSR .lB1EE                  ; get 1. parameter (voice no. into y, and as offset into x (0,7,14)

    LDA $C300,Y                 ; set or delete the gate bit for voice y
    LSR
    ROR COPY3
    ROL
    STA $C300,Y
    STA $D404,X                 ; voice register offset in x
    RTS

;
; procSoundtype
;
procSoundtype
    LDA #$02
    JSR .lB209                  ; get waveform no.
    CPX #$05
    BCS .lB3F7                  ; value out of range
    LDA .lB431,X                ; waveform offset
    STA COPY3
    JSR .lB1EE                  ; get 1. parameter (voice no. into y, and as offset into x (0,7,14)
    LDA $C300,Y
    AND #$0F
    ORA COPY3
    STA $C300,Y
    STA $D404,X                 ; save waveform for voice x
    RTS

;waveform offset value
.lB431
    !by $00,$10,$20,$40,$80

;
; procRingmod
;
procRingmod
    LDA #$02
    JSR .lB217                  ; get parameter, returns 0 or 1
    PHA
    JSR .lB1EE                  ; get 1. parameter (voice no. into y, and as offset into x (0,7,14)
    PLA
    BEQ +
    LDA $C300,Y
    ORA #$04
    BNE ++

+   LDA $C300,Y
    AND #$FB

++  STA $C300,Y
    STA $D404,X
    RTS

;
; procSync
;
procSync
    LDA #$02
    JSR .lB217                  ; get 2. parameter, (yes/no) returns 0 or 1
    PHA
    JSR .lB1EE                  ; get 1. parameter (voice no. into y, and as offset into x (0,7,14)
    PLA
    BEQ +
    LDA $C300,Y
    ORA #$02
    BNE ++

+   LDA $C300,Y
    AND #$FD

++  STA $C300,Y
    STA $D404,X
    RTS

;
; procAdsr
;
procAdsr
    LDA #$02                    ; 2. parameter
    JSR .lB209                  ; get value 'a' (max. 15)
    ASL                         ;
    ASL                         ;
    ASL                         ;
    ASL                         ; move into high nibble
    STA COPY3

    LDA #$03                    ; 3. parameter
    JSR .lB209                  ; get value 'd' (max. 15)
    ORA COPY3                   ; ora with 'a' value
    STA COPY3

    LDA #$04                    ; 4. parameter
    JSR .lB209                  ; get value 's' (max. 15)
    ASL                         ;
    ASL                         ;
    ASL                         ;
    ASL                         ; move into high nibble
    STA COPY3+1

    LDA #$05                    ; 5. parameter
    JSR .lB209                  ; get value 'r' (max. 15)
    ORA COPY3+1                 ; ora with 's' value
    STA COPY3+1

    JSR .lB1EE                  ; get 1. parameter (voice no. as offset into x (0,7,14)
    LDA COPY3
    STA $D405,X                 ; set register with 'ad' 
    LDA COPY3+1
    STA $D406,X                 ; set register with 'sr'
    RTS
---------------------------------

-   JMP .lB3F7

;
; procFilterfreq
;
procFilterfreq
    JSR .l95B0                  ; get a parameter, a= high, x= low
    STA COPY3
    AND #$F8
    BNE -
    TXA
    LDX #$05

-   ASL
    ROL COPY3
    DEX
    BNE -
    LSR
    LSR
    LSR
    LSR
    LSR
    STA $D415
    LDA COPY3
    STA $D416
    RTS

;
; procResonance
;
procResonance
    LDA #$01
    JSR .lB209                  ; get a value (max. 15)
    ASL
    ASL
    ASL
    ASL                         ; move into high nibble
    STA COPY3
    LDA $C303
    AND #$0F                    ; and with low nibble
    ORA COPY3                   ; ora with high nibble
    STA $C303
    STA $D417                   ; write to register
    RTS

;
; procFilter
;
procFilter
    LDA $C303                   ; load filter value
    LSR
    LSR
    LSR
    LSR                         ; move high nibble into low nibble
    STA $C303
    LDA #$04                    ; loop and parameter counter
    STA COPY3

; write voice filter to register bit 0-3
-   JSR .lB217                  ; get parameter, returns 0 or 1
    ROR
    ROL $C303
    DEC COPY3
    LDA COPY3                   ; next parameter
    BNE -                       ; loop 4 times

    LDA $C303
    STA $D417
    RTS

;
; procFiltertype
;
procFiltertype
    LDA $C304                   ; load filter mod value
    ASL
    ASL
    ASL
    ASL                         ; move into high nibble
    STA $C304
    LDA #$01                    ; mode and parameter counter
    STA COPY3

; write filter mode to register bit 4-7
-   JSR .lB217                  ; get parameter, returns 0 or 1
    ROR
    ROR $C304
    INC COPY3
    LDA COPY3

    CMP #$05
    BCC -                       ; loop 4 times

    LDA $C304
    STA $D418
    RTS

;
; procVolume
;
procVolume
    LDA $C304                   ; load value
    AND #$F0                    ; delete volume bit 0-3
    STA $C304
    LDA #$01
    JSR .lB209                  ; get volume (max.15)
    ORA $C304                   ; ora with bit 4-7
    STA $C304
    STA $D418
    RTS

;
; funcEnv3
;
funcEnv3
    LDX $D41C
    JMP .lA993                  ; LDA #$00
                                ; JMP PSHINT
;
; funcOsc3
;
funcOsc3
    LDX $D41B
    JMP .lA993

;
; funcFrequency
;
funcFrequency
    LDA #$01
    JSR .lB316                  ; get frequency, vcalculated by note input
    LDA COPY3                   ; high byte
    LDX COPY3+1                 ; low byte
    JMP PSHINT                  ; FLOAT & PUSH INTEGER (-32768 .. 32767)

;
; procSetscore
;
procSetscore
; voice
    JSR .lB1EE                  ; get 1. parameter (voice no. into y)
    STY INF1                    ; y = 0, 1 or 2
    LDA #$00
    STA $C308,Y                 ; stop voice
    STA $C31D
    STA $C31E

; frequency table pointer   -- low byte -- , -- high byte --
; voice 1                       $C30B            $C30E
; voice 2                       $C30C            $C30F
; voice 3                       $C30D            $C310

; frequency
    LDA #$02
    JSR .lB228                  ; get parameter 2 (frequency table)
    LDX INF1                    ; voice number 0, 1 or 2
    LDA COPY3
    STA freq_tab_L,X            ; table address low, $C30B
    LDA COPY3+1
    STA freq_tab_H,X            ; table address high, $C30E

; ads table pointer         -- low byte -- , -- high byte --
; voice 1                       $C311            $C314
; voice 2                       $C312            $C315
; voice 3                       $C313            $C316

; ads-value
    LDA #$03
    JSR .lB228                  ; get parameter 3 (ads table)
    LDX INF1                    ; voice number 0, 1 or 2
    LDA COPY3
    STA ADSx_tab_L,X                ; table address low, $C311
    LDA COPY3+1
    STA ADSx_tab_H,X                ; table address high, $C314

; r table pointer           -- low byte -- , -- high byte --
; voice 1                       $C317            $C31A
; voice 2                       $C318            $C31B
; voice 3                       $C319            $C31C

; r-value
    LDA #$04
    JSR .lB228                  ; get parameter 4 (r table)
    LDX INF1                    ; voice number 0, 1 or 2
    LDA COPY3
    STA xxxR_tab_L,X                ; table address low, $C317
    LDA COPY3+1
    STA xxxR_tab_H,X                ; table address high, $C31A
    RTS

;
; procPlayscore
;
procPlayscore
    LDA #$03                    ; 3 Voices
    STA INF1                    ; counter

    SEI                         ; avoid interrupts

-   LDA INF1                    ; load voice-counter
    JSR .lB217                  ; get parameter, returns 0 or 1
    BEQ +                       ; branch if 0, nothing to do
    LDX INF1                    ; else load voice-counter as x-pointer
    LDA $C308-1,X                 
    BNE +                       ; not 0, exit
    LDA freq_tab_L-1,X          ; $C30B, freq-table low byte
    ORA freq_tab_H-1,X          ; $C30E, freq-table high byte
    BEQ +                       ; check next voice
    LDA #$00
;
; ---- delete timer -------------
;
    STA $C322-1,X
    STA $C31F-1,X
;
; -------------------------------
;
    LDA #$02
    STA $C308-1,X               ; activate voice (start IRQ)

+   DEC INF1                    ; dec voice counter
    BNE -                       ; branch if more voice(es)

    CLI                         ; allow interrupts
    RTS

;
; procStopplay
;
procStopplay
    LDA #$03                    ; 3 voices
    STA INF1                    ; counter
    LDA #$00
    STA INF2

-   LDA INF1                    ; load voice and parameter counter
    JSR .lB217                  ; get parameter, returns 0 or 1
    BEQ +
    LDX INF1
    LDA #$00
    STA $C308-1,X               ; clear interrupt flag voice x
    LDA $C300-1,X
    AND #$FE                    ; clear gate flag
    STA $C300-1,X
    LDY INF2
    STA $D404,Y                 ; stop play voce x in reg y

+   LDA INF2
    CLC
    ADC #$07                    ; next register
    STA INF2
    DEC INF1                    ; next voice
    BNE -
    RTS

;
; procWaitscore
;
procWaitscore
    LDA #$03                    ; voice and parameter counter
    STA INF2

-   LDA INF2
    JSR .lB217                  ; get parameter, returns 0 or 1
    BEQ +                       ; no wait on this voice
    LDX INF2
    LDA $C308-1,X               ; check interrupt flag
    BEQ +
    JMP .lA99D                  ; not analyzed, probably wait???
---------------------------------

+   DEC INF2
    BNE -
    JMP .lA99A                  ; not analyzed, probably wait???

; -------------------------------
.l9589
    LDY #$0B
.l958B
    LDA (FORPT),Y               ; stack entry chain
    STA COPY1
    INY
    LDA (FORPT),Y               ; stack entry chain
    STA COPY1+1
    RTS
---------------------------------
.l9595
    LDY #$10
    BNE .l958B
.l9599
    LDY #$15
    BNE .l958B

; not used in Sound
;--------------------------------------------------------
;.l959D
;    LDY #$1A
;    BNE .l958B
;.l95A1
;    JSR .l959D
;    BNE .l95B3                  ; load COPY1 with A and X
;.l95A6
;    JSR .l9599
;    BNE .l95B3                  ; load COPY1 with A and X
;--------------------------------------------------------

.l95AB
    JSR .l9595
    BNE .l95B3                  ; load COPY1 with A and X
.l95B0
    JSR .l9589
.l95B3
    LDY #$01
    LDA (COPY1),Y
    TAX
    DEY
    LDA (COPY1),Y
    RTS
------------------------
.lA993
    LDA #$00
    JMP PSHINT
---------------------------------
.lA998
    BEQ .lA99D
.lA99A
    LDA #$81
    !by $2c
.lA99D
    LDA #$00
    PHA
    CLC
    LDA STOS
    STA COPY2
    ADC #$05
    TAX
    LDA STOS+1
    STA COPY2+1
    ADC #$00
    TAY
    CPX SFREE
    SBC SFREE+1
    BCS .lA9CC
    STX STOS
    STY STOS+1
    PLA
    LDY #$00
    STA (COPY2),Y
    TYA
    INY
    STA (COPY2),Y
    INY
    STA (COPY2),Y
    INY
    STA (COPY2),Y
    INY
    STA (COPY2),Y
    RTS
---------------------------------
.lA9CC
    LDX #$34
    JMP RUNERR

VersSound2
.msglength = .msgend-.msgstart
    LDA #.msglength+2
    JSR EXCGST                  ; allocate local storage
    LDY #$00
-   LDA .msgstart,Y
    STA (COPY2),Y
    INY
    CPY #.msglength
    BNE -                       ; loop
    LDA #$00
    STA (COPY2),Y
    LDA #.msglength
    INY
    STA (COPY2),Y
    RTS

.msgstart
    !pet " 1.00 ",$9f,"SOUND2",$9a," package",$0d
    !pet " Claus Schlereth & Arndt Dettke in 2025",$0d
.msgend