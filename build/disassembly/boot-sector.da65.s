; da65 V2.19 - Git a028ac414
; Created:    reproducible build
; Input file: build/disassembly/boot-sector.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L003E           := $003E
L707C           := $707C
LBAB0           := $BAB0
LBCFF           := $BCFF
; ----------------------------------------------------------------------------
        .byte   $01                             ; 0800 01                       .
; ----------------------------------------------------------------------------
; Boot entry after sector-count byte
boot_entry:
        lda     $27                             ; 0801 A5 27                    .'
        cmp     #$09                            ; 0803 C9 09                    ..
        bne     L081F                           ; 0805 D0 18                    ..
        lda     $2B                             ; 0807 A5 2B                    .+
        lsr     a                               ; 0809 4A                       J
        lsr     a                               ; 080A 4A                       J
        lsr     a                               ; 080B 4A                       J
        lsr     a                               ; 080C 4A                       J
        ora     #$C0                            ; 080D 09 C0                    ..
        sta     $3F                             ; 080F 85 3F                    .?
        lda     #$5C                            ; 0811 A9 5C                    .\
        sta     L003E                           ; 0813 85 3E                    .>
        clc                                     ; 0815 18                       .
        lda     loader_state_lo                 ; 0816 AD AC 08                 ...
        adc     loader_state_hi                 ; 0819 6D AD 08                 m..
        sta     loader_state_lo                 ; 081C 8D AC 08                 ...
L081F:  ldx     loader_state_hi                 ; 081F AE AD 08                 ...
        bmi     L0839                           ; 0822 30 15                    0.
        lda     dos_sector_translate,x          ; 0824 BD A0 08                 ...
        sta     $3D                             ; 0827 85 3D                    .=
        dec     loader_state_hi                 ; 0829 CE AD 08                 ...
        lda     loader_state_lo                 ; 082C AD AC 08                 ...
        sta     $27                             ; 082F 85 27                    .'
        dec     loader_state_lo                 ; 0831 CE AC 08                 ...
        ldx     $2B                             ; 0834 A6 2B                    .+
        jmp     (L003E)                         ; 0836 6C 3E 00                 l>.

; ----------------------------------------------------------------------------
L0839:  inc     loader_state_lo                 ; 0839 EE AC 08                 ...
        inc     loader_state_lo                 ; 083C EE AC 08                 ...
        bit     $C051                           ; 083F 2C 51 C0                 ,Q.
        bit     $C054                           ; 0842 2C 54 C0                 ,T.
        ldx     $2B                             ; 0845 A6 2B                    .+
        stx     $BFE9                           ; 0847 8E E9 BF                 ...
        txa                                     ; 084A 8A                       .
        lsr     a                               ; 084B 4A                       J
        lsr     a                               ; 084C 4A                       J
        lsr     a                               ; 084D 4A                       J
        lsr     a                               ; 084E 4A                       J
        tax                                     ; 084F AA                       .
        lda     #$00                            ; 0850 A9 00                    ..
        sta     $80,x                           ; 0852 95 80                    ..
        sta     $40                             ; 0854 85 40                    .@
        sta     $41                             ; 0856 85 41                    .A
        lda     #$00                            ; 0858 A9 00                    ..
        ldy     #$77                            ; 085A A0 77                    .w
L085C:  sta     $0400,y                         ; 085C 99 00 04                 ...
        sta     $0480,y                         ; 085F 99 80 04                 ...
        sta     $0500,y                         ; 0862 99 00 05                 ...
        sta     $0580,y                         ; 0865 99 80 05                 ...
        sta     $0600,y                         ; 0868 99 00 06                 ...
        sta     $0680,y                         ; 086B 99 80 06                 ...
        sta     $0700,y                         ; 086E 99 00 07                 ...
        sta     $0780,y                         ; 0871 99 80 07                 ...
        dey                                     ; 0874 88                       .
        bpl     L085C                           ; 0875 10 E5                    ..
        lda     #$D2                            ; 0877 A9 D2                    ..
        sta     $07D3                           ; 0879 8D D3 07                 ...
        lda     #$B1                            ; 087C A9 B1                    ..
        sta     $07D4                           ; 087E 8D D4 07                 ...
        lda     #$AE                            ; 0881 A9 AE                    ..
        sta     $07D5                           ; 0883 8D D5 07                 ...
        lda     #$B2                            ; 0886 A9 B2                    ..
        sta     $07D6                           ; 0888 8D D6 07                 ...
        jmp     LBAB0                           ; 088B 4C B0 BA                 L..

; ----------------------------------------------------------------------------
        brk                                     ; 088E 00                       .
        brk                                     ; 088F 00                       .
        brk                                     ; 0890 00                       .
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 0891 00 00 00 00 00 00 00 00  ........
        .byte   $00,$00,$00,$00,$00,$00,$00     ; 0899 00 00 00 00 00 00 00     .......
; DOS-order sector translation prefix
dos_sector_translate:
        .byte   $00,$0D,$0B,$09,$07,$05,$03,$01 ; 08A0 00 0D 0B 09 07 05 03 01  ........
        .byte   $0E,$0C,$0A,$00                 ; 08A8 0E 0C 0A 00              ....
; Self-modified loader state
loader_state_lo:
        .byte   $BA                             ; 08AC BA                       .
; Self-modified loader state / sector index
loader_state_hi:
        .byte   $05,$FB,$59                     ; 08AD 05 FB 59                 ..Y
; ----------------------------------------------------------------------------
        lda     #$00                            ; 08B0 A9 00                    ..
        pha                                     ; 08B2 48                       H
        ldx     #$14                            ; 08B3 A2 14                    ..
        stx     $BFEA                           ; 08B5 8E EA BF                 ...
        ldx     #$0C                            ; 08B8 A2 0C                    ..
        stx     $BFEB                           ; 08BA 8E EB BF                 ...
        ldx     #$70                            ; 08BD A2 70                    .p
        stx     $BFEC                           ; 08BF 8E EC BF                 ...
        ldx     #$03                            ; 08C2 A2 03                    ..
        stx     $BFED                           ; 08C4 8E ED BF                 ...
        ldx     #$E8                            ; 08C7 A2 E8                    ..
        ldy     #$BF                            ; 08C9 A0 BF                    ..
        jsr     LBCFF                           ; 08CB 20 FF BC                  ..
        pla                                     ; 08CE 68                       h
        nop                                     ; 08CF EA                       .
        ldx     #$13                            ; 08D0 A2 13                    ..
        stx     $BFEA                           ; 08D2 8E EA BF                 ...
        ldx     #$0F                            ; 08D5 A2 0F                    ..
        stx     $BFEB                           ; 08D7 8E EB BF                 ...
        ldx     #$6F                            ; 08DA A2 6F                    .o
        stx     $BFEC                           ; 08DC 8E EC BF                 ...
L08DF:  ldx     #$E8                            ; 08DF A2 E8                    ..
        ldy     #$BF                            ; 08E1 A0 BF                    ..
        jsr     LBCFF                           ; 08E3 20 FF BC                  ..
        dec     $BFEC                           ; 08E6 CE EC BF                 ...
        dec     $BFEB                           ; 08E9 CE EB BF                 ...
        bpl     L08DF                           ; 08EC 10 F1                    ..
        ldx     $BFE9                           ; 08EE AE E9 BF                 ...
        lda     $C088,x                         ; 08F1 BD 88 C0                 ...
        jmp     L707C                           ; 08F4 4C 7C 70                 L|p

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 08F7 00 00 00 00 00 00 00 00  ........
        .byte   $01                             ; 08FF 01                       .
