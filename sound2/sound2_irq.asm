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


.lBB5B
    LDA #$02                    ; zählt die Oszillatoren 3..1 (als 2..0)
    STA INF1
    LDA #$0E
    STA INF2                    ; enthält die Frequenz-Register (zuerst von Oszi 3: Offset 14)

.lBB63  ;           (MAINLOOP)
    LDX INF1                    ; zuerst: Oszi 3 (in .x)
    LDA $C308,X                 ; liegt ein Ton für diesen Oszi vor? (holt Flag: 2, 1 oder 0)
    BNE .lBB6D                  ; ja, noch nicht bearbeitet oder noch nicht abgelaufen? (2 oder 1?)
    JMP .lBC28                  ; nein, Ton abgelaufen oder nicht gesetzt (0), nächsten Oszi ansteuern

---------------------------------
.lBB6D  ;           Inner Loop (Tondauer)
    LDA $C31F,X                 ; Tondauerzähler abgelaufen? (ist 0?)
    ORA $C322,X
    BEQ .lBB78                  ; ja

    JMP .lBC1A                  ; nein, Dauer herunterzählen (16Bit-Zähler)
---------------------------------
; INF1 = 0, INF2 = 0
.lBB78
    LDA $C308,X                 ; Flag für Oszi (2..0) holen, minus 1
    TAY
    DEY
    BNE .lBBB6                  ; ist 0? (nein, dann Frequenzen setzen)
    
    LDY INF2                    ; ja, Oszinummer holen (0..2)
    LDA $C300,X                 ; Gatebit ausschalten (Ton aus), merken in $C300..$C302
    AND #$FE
    STA $C300,X
    STA $D404,Y                 ; jetzt aus
    CLC             ; Tondauerzähler rekonstruieren
    LDA xxxR_tab_L,X    ; $C317
    STA COPY1
    ADC #$02
    STA xxxR_tab_L,X    ; $C317
    LDA xxxR_tab_H,X    ; $C31A
    STA COPY1+1
    ADC #$00
    STA xxxR_tab_H,X    ; $C31A
;
; -------------------------------
;
    LDY #$00        ; hier zurückschreiben
    LDA (COPY1),Y
    STA $C322,X
    INY
    LDA (COPY1),Y
    STA $C31F,X
;
; -------------------------------
;
    LDA #$02        ; und Flag (Ton liegt vor) neu setzen
    STA $C308,X
    JMP .lBB6D      ; und herunterzählen starten
---------------------------------
.lBBB6
    LDA freq_tab_H,X    ; Frequenzen... ($C30E)
    STA COPY1+1
    LDA freq_tab_L,X    ; $C30B
    STA COPY1

    CLC
    ADC #$02        ; Tabellenzeiger erhoehen
    STA freq_tab_L,X    ; $C30B
    BCC .lBBCB
    INC freq_tab_H,X    ; $C30E

.lBBCB
    LDY #$01
    LDA (COPY1),Y
    DEY
    ORA (COPY1),Y
    BEQ .lBC37      ; keine Frequenz mehr
    LDA (COPY1),Y
    PHA
    INY
    LDA (COPY1),Y
    LDY INF2

    STA $D400,Y     ; ...ab hier...
    PLA
    STA $D401,Y

    CLC
    LDA ADSx_tab_L,X    ; $C311
    STA COPY1
    ADC #$02        ; Tabellenzeiger auf nächstes Wertepaar
    STA ADSx_tab_L,X    ; $C311
    LDA ADSx_tab_H,X    ; $C314
    STA COPY1+1
    ADC #$00
    STA ADSx_tab_H,X    ; $C314
;
; -- setzt den Wert aus ads als Zähler
;
    LDY #$00
    LDA (COPY1),Y
    STA $C322,X
    INY
    LDA (COPY1),Y
    STA $C31F,X
;
; -------------------------------
;
    LDA $C300,X     ; ...und Ton einschalten
    ORA #$01
    STA $C300,X
    LDY INF2
    STA $D404,Y
    LDA #$01        ; Flag setzen (1=Ton ist jetzt an)
    STA $C308,X
    JMP .lBB6D
---------------------------------
.lBC1A
    SEC
    LDA $C31F,X
    SBC #$01        ; Tondauerzähler minus 1
    INC $D020
    STA $C31F,X
    BCS .lBC28
    DEC $C322,X

.lBC28
    SEC             ; dann nächster Oszi
    LDA INF2        ; (von 14 auf 7 auf 0 auf -7)
    SBC #$07
    BMI .lBC36      ; negativ?: Ende
    STA INF2        ; sonst: neuen Oszi setzen
    DEC INF1        ; Oszis herunterzählen
    JMP .lBB63      ; zum Inner Loop (Tondauer)     (/mainloop)
---------------------------------
.lBC36
    RTS             ; finished
---------------------------------
.lBC37
    LDA #$00        ; Ton-spielen-Flags (je Oszi in .x) auf 0
    STA $C308,X
    STA freq_tab_L,X    ; $C30B
    STA freq_tab_H,X    ; $C30E
    BEQ .lBC28      ; uncond. branch (nächsten Oszi checken)
---------------------------------
.irq2
.lBC44  ;           (Sound IRQ Aufruf)
    LDA INF1        ; temp. Werte retten
    PHA
    LDA INF2
    PHA
    LDA COPY1
    PHA
    LDA COPY1+1
    PHA
    JSR .lBB5B      ; Sound
    PLA
    STA COPY1+1     ; temp. Werte zurück
    PLA
    STA COPY1
    PLA
    STA INF2
    PLA
    STA INF1
    RTS             ; zurück zum Main IRQ (?)


; --- irq1 ---
; this is not called from the sound routine,
; but includes some sound handling,
; and a jump to the sound IRQ
.irq1
.lB96F
    STA $D019
    LDA $D01E       ; collision s-s
    STA $C268
    ORA $C26C
    STA $C26C
    LDA $D01F       ; collision s-b
    STA $C269
    ORA $C26E
    STA $C26E
    LDA $C2FC
    BEQ .lB99D
    LDX #$0E
.lB991
    ASL
    BCC .lB999
    PHA

    JSR CALL                    ; jsr to another page
    !by PAGE4                   ; page No. $83
    !word $B9C5                 ; address

;    JSR .lB9C5

    PLA
.lB999
    DEX
    DEX
    BPL .lB991
.lB99D
    LDA PALNTS
    BEQ .lB9C4
    DEC $C2FE
    BNE .lB9C4
    LDA #$05
    STA $C2FE
    INC TIME+2
    BNE .lB9B6
    INC TIME+1
    BNE .lB9B6
    INC TIME

; sound part handling
.lB9B6
    LDA $C308       ; any sound to play?
    ORA $C309
    ORA $C30A
    BEQ .lB9C4      ; no
    JMP .lBC44      ; yes, jump to sound IRQ
---------------------------------
.lB9C4
    RTS