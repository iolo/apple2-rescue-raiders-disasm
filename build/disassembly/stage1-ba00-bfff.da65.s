; da65 V2.19 - Git a028ac414
; Created:    reproducible build
; Input file: build/extract/stage1-ba00-bfff.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L003E           := $003E
L045D           := $045D
L28A9           := $28A9
L4000           := $4000
L707C           := $707C
LF956           := $F956
LFAFD           := $FAFD
LFB0B           := $FB0B
LFBA4           := $FBA4
LFBAF           := $FBAF
LFBC1           := $FBC1
LFC22           := $FC22
LFC24           := $FC24
LFC9E           := $FC9E
LFCA8           := $FCA8
LFCFD           := $FCFD
LFF4A           := $FF4A
; ----------------------------------------------------------------------------
        ora     ($A5,x)                         ; BA00 01 A5                    ..
        .byte   $27                             ; BA02 27                       '
        cmp     #$09                            ; BA03 C9 09                    ..
        bne     LBA1F                           ; BA05 D0 18                    ..
        lda     $2B                             ; BA07 A5 2B                    .+
        lsr     a                               ; BA09 4A                       J
        lsr     a                               ; BA0A 4A                       J
        lsr     a                               ; BA0B 4A                       J
        lsr     a                               ; BA0C 4A                       J
        ora     #$C0                            ; BA0D 09 C0                    ..
        sta     $3F                             ; BA0F 85 3F                    .?
        lda     #$5C                            ; BA11 A9 5C                    .\
        sta     L003E                           ; BA13 85 3E                    .>
        clc                                     ; BA15 18                       .
        lda     $08AC                           ; BA16 AD AC 08                 ...
        adc     $08AD                           ; BA19 6D AD 08                 m..
        sta     $08AC                           ; BA1C 8D AC 08                 ...
LBA1F:  ldx     $08AD                           ; BA1F AE AD 08                 ...
        bmi     LBA39                           ; BA22 30 15                    0.
        lda     $08A0,x                         ; BA24 BD A0 08                 ...
        sta     $3D                             ; BA27 85 3D                    .=
        dec     $08AD                           ; BA29 CE AD 08                 ...
        lda     $08AC                           ; BA2C AD AC 08                 ...
        sta     $27                             ; BA2F 85 27                    .'
        dec     $08AC                           ; BA31 CE AC 08                 ...
        ldx     $2B                             ; BA34 A6 2B                    .+
        jmp     (L003E)                         ; BA36 6C 3E 00                 l>.

; ----------------------------------------------------------------------------
LBA39:  inc     $08AC                           ; BA39 EE AC 08                 ...
        inc     $08AC                           ; BA3C EE AC 08                 ...
        bit     $C051                           ; BA3F 2C 51 C0                 ,Q.
        bit     $C054                           ; BA42 2C 54 C0                 ,T.
        ldx     $2B                             ; BA45 A6 2B                    .+
        stx     LBFE9                           ; BA47 8E E9 BF                 ...
        txa                                     ; BA4A 8A                       .
        lsr     a                               ; BA4B 4A                       J
        lsr     a                               ; BA4C 4A                       J
        lsr     a                               ; BA4D 4A                       J
        lsr     a                               ; BA4E 4A                       J
        tax                                     ; BA4F AA                       .
        lda     #$00                            ; BA50 A9 00                    ..
        sta     $80,x                           ; BA52 95 80                    ..
        sta     $40                             ; BA54 85 40                    .@
        sta     $41                             ; BA56 85 41                    .A
        lda     #$00                            ; BA58 A9 00                    ..
        ldy     #$77                            ; BA5A A0 77                    .w
LBA5C:  sta     $0400,y                         ; BA5C 99 00 04                 ...
        sta     $0480,y                         ; BA5F 99 80 04                 ...
        sta     $0500,y                         ; BA62 99 00 05                 ...
        sta     $0580,y                         ; BA65 99 80 05                 ...
        sta     $0600,y                         ; BA68 99 00 06                 ...
        sta     $0680,y                         ; BA6B 99 80 06                 ...
        sta     $0700,y                         ; BA6E 99 00 07                 ...
        sta     $0780,y                         ; BA71 99 80 07                 ...
        dey                                     ; BA74 88                       .
        bpl     LBA5C                           ; BA75 10 E5                    ..
        lda     #$D2                            ; BA77 A9 D2                    ..
        sta     $07D3                           ; BA79 8D D3 07                 ...
        lda     #$B1                            ; BA7C A9 B1                    ..
        sta     $07D4                           ; BA7E 8D D4 07                 ...
        lda     #$AE                            ; BA81 A9 AE                    ..
        sta     $07D5                           ; BA83 8D D5 07                 ...
        lda     #$B2                            ; BA86 A9 B2                    ..
        sta     $07D6                           ; BA88 8D D6 07                 ...
        jmp     LBAB0                           ; BA8B 4C B0 BA                 L..

; ----------------------------------------------------------------------------
        brk                                     ; BA8E 00                       .
        brk                                     ; BA8F 00                       .
        brk                                     ; BA90 00                       .
        brk                                     ; BA91 00                       .
        brk                                     ; BA92 00                       .
        brk                                     ; BA93 00                       .
        brk                                     ; BA94 00                       .
        brk                                     ; BA95 00                       .
        brk                                     ; BA96 00                       .
        brk                                     ; BA97 00                       .
        brk                                     ; BA98 00                       .
        brk                                     ; BA99 00                       .
        brk                                     ; BA9A 00                       .
        brk                                     ; BA9B 00                       .
        brk                                     ; BA9C 00                       .
        brk                                     ; BA9D 00                       .
        brk                                     ; BA9E 00                       .
        brk                                     ; BA9F 00                       .
        brk                                     ; BAA0 00                       .
        ora     $090B                           ; BAA1 0D 0B 09                 ...
        .byte   $07                             ; BAA4 07                       .
        ora     $03                             ; BAA5 05 03                    ..
        ora     ($0E,x)                         ; BAA7 01 0E                    ..
        .byte   $0C                             ; BAA9 0C                       .
        asl     a                               ; BAAA 0A                       .
        brk                                     ; BAAB 00                       .
        tsx                                     ; BAAC BA                       .
        ora     $FB                             ; BAAD 05 FB                    ..
        .byte   $59                             ; BAAF 59                       Y
LBAB0:  lda     #$00                            ; BAB0 A9 00                    ..
        pha                                     ; BAB2 48                       H
        ldx     #$14                            ; BAB3 A2 14                    ..
        stx     LBFEA                           ; BAB5 8E EA BF                 ...
        ldx     #$0C                            ; BAB8 A2 0C                    ..
        stx     LBFEB                           ; BABA 8E EB BF                 ...
        ldx     #$70                            ; BABD A2 70                    .p
        stx     LBFEC                           ; BABF 8E EC BF                 ...
        ldx     #$03                            ; BAC2 A2 03                    ..
        stx     LBFED                           ; BAC4 8E ED BF                 ...
        ldx     #$E8                            ; BAC7 A2 E8                    ..
        ldy     #$BF                            ; BAC9 A0 BF                    ..
        jsr     LBCFF                           ; BACB 20 FF BC                  ..
        pla                                     ; BACE 68                       h
        nop                                     ; BACF EA                       .
        ldx     #$13                            ; BAD0 A2 13                    ..
        stx     LBFEA                           ; BAD2 8E EA BF                 ...
        ldx     #$0F                            ; BAD5 A2 0F                    ..
        stx     LBFEB                           ; BAD7 8E EB BF                 ...
        ldx     #$6F                            ; BADA A2 6F                    .o
        stx     LBFEC                           ; BADC 8E EC BF                 ...
LBADF:  ldx     #$E8                            ; BADF A2 E8                    ..
        ldy     #$BF                            ; BAE1 A0 BF                    ..
        jsr     LBCFF                           ; BAE3 20 FF BC                  ..
        dec     LBFEC                           ; BAE6 CE EC BF                 ...
        dec     LBFEB                           ; BAE9 CE EB BF                 ...
        bpl     LBADF                           ; BAEC 10 F1                    ..
        ldx     LBFE9                           ; BAEE AE E9 BF                 ...
        lda     $C088,x                         ; BAF1 BD 88 C0                 ...
        jmp     L707C                           ; BAF4 4C 7C 70                 L|p

; ----------------------------------------------------------------------------
        brk                                     ; BAF7 00                       .
        brk                                     ; BAF8 00                       .
        brk                                     ; BAF9 00                       .
        brk                                     ; BAFA 00                       .
        brk                                     ; BAFB 00                       .
        brk                                     ; BAFC 00                       .
        brk                                     ; BAFD 00                       .
        brk                                     ; BAFE 00                       .
        ora     ($4C,x)                         ; BAFF 01 4C                    .L
        .byte   $FF                             ; BB01 FF                       .
        .byte   $BC                             ; BB02 BC                       .
LBB03:  ldx     #$00                            ; BB03 A2 00                    ..
        ldy     #$02                            ; BB05 A0 02                    ..
LBB07:  dey                                     ; BB07 88                       .
        lda     ($46),y                         ; BB08 B1 46                    .F
        lsr     a                               ; BB0A 4A                       J
        rol     LBF00,x                         ; BB0B 3E 00 BF                 >..
        lsr     a                               ; BB0E 4A                       J
        rol     LBF00,x                         ; BB0F 3E 00 BF                 >..
        sta     LBE00,y                         ; BB12 99 00 BE                 ...
        inx                                     ; BB15 E8                       .
        cpx     #$56                            ; BB16 E0 56                    .V
        bcc     LBB07                           ; BB18 90 ED                    ..
        ldx     #$00                            ; BB1A A2 00                    ..
        tya                                     ; BB1C 98                       .
        bne     LBB07                           ; BB1D D0 E8                    ..
        ldx     #$55                            ; BB1F A2 55                    .U
LBB21:  lda     LBF00,x                         ; BB21 BD 00 BF                 ...
        and     #$3F                            ; BB24 29 3F                    )?
        sta     LBF00,x                         ; BB26 9D 00 BF                 ...
        dex                                     ; BB29 CA                       .
        bpl     LBB21                           ; BB2A 10 F5                    ..
        rts                                     ; BB2C 60                       `

; ----------------------------------------------------------------------------
LBB2D:  sec                                     ; BB2D 38                       8
        stx     $43                             ; BB2E 86 43                    .C
        stx     a:$44                           ; BB30 8E 44 00                 .D.
        lda     $C08D,x                         ; BB33 BD 8D C0                 ...
        lda     $C08E,x                         ; BB36 BD 8E C0                 ...
        bmi     LBBB7                           ; BB39 30 7C                    0|
        lda     LBF00                           ; BB3B AD 00 BF                 ...
        sta     $42                             ; BB3E 85 42                    .B
        lda     #$FF                            ; BB40 A9 FF                    ..
        sta     $C08F,x                         ; BB42 9D 8F C0                 ...
        ora     $C08C,x                         ; BB45 1D 8C C0                 ...
        pha                                     ; BB48 48                       H
        pla                                     ; BB49 68                       h
        nop                                     ; BB4A EA                       .
        ldy     #$05                            ; BB4B A0 05                    ..
LBB4D:  pha                                     ; BB4D 48                       H
        pla                                     ; BB4E 68                       h
        jsr     LBBBC                           ; BB4F 20 BC BB                  ..
        dey                                     ; BB52 88                       .
        bne     LBB4D                           ; BB53 D0 F8                    ..
        lda     #$D5                            ; BB55 A9 D5                    ..
        jsr     LBBBB                           ; BB57 20 BB BB                  ..
        lda     #$AA                            ; BB5A A9 AA                    ..
        jsr     LBBBB                           ; BB5C 20 BB BB                  ..
        lda     #$AD                            ; BB5F A9 AD                    ..
        jsr     LBBBB                           ; BB61 20 BB BB                  ..
        tya                                     ; BB64 98                       .
        ldy     #$56                            ; BB65 A0 56                    .V
        bne     LBB6C                           ; BB67 D0 03                    ..
LBB69:  lda     LBF00,y                         ; BB69 B9 00 BF                 ...
LBB6C:  eor     LBEFF,y                         ; BB6C 59 FF BE                 Y..
        tax                                     ; BB6F AA                       .
        lda     LBF66,x                         ; BB70 BD 66 BF                 .f.
        ldx     $43                             ; BB73 A6 43                    .C
        sta     $C08D,x                         ; BB75 9D 8D C0                 ...
        lda     $C08C,x                         ; BB78 BD 8C C0                 ...
        dey                                     ; BB7B 88                       .
        bne     LBB69                           ; BB7C D0 EB                    ..
        lda     $42                             ; BB7E A5 42                    .B
        nop                                     ; BB80 EA                       .
LBB81:  eor     LBE00,y                         ; BB81 59 00 BE                 Y..
        tax                                     ; BB84 AA                       .
        lda     LBF66,x                         ; BB85 BD 66 BF                 .f.
        ldx     a:$44                           ; BB88 AE 44 00                 .D.
        sta     $C08D,x                         ; BB8B 9D 8D C0                 ...
        lda     $C08C,x                         ; BB8E BD 8C C0                 ...
        lda     LBE00,y                         ; BB91 B9 00 BE                 ...
        iny                                     ; BB94 C8                       .
        bne     LBB81                           ; BB95 D0 EA                    ..
        tax                                     ; BB97 AA                       .
        lda     LBF66,x                         ; BB98 BD 66 BF                 .f.
        ldx     $43                             ; BB9B A6 43                    .C
        jsr     LBBBE                           ; BB9D 20 BE BB                  ..
        lda     #$DE                            ; BBA0 A9 DE                    ..
        jsr     LBBBB                           ; BBA2 20 BB BB                  ..
        lda     #$AA                            ; BBA5 A9 AA                    ..
        jsr     LBBBB                           ; BBA7 20 BB BB                  ..
        lda     #$EB                            ; BBAA A9 EB                    ..
        jsr     LBBBB                           ; BBAC 20 BB BB                  ..
        lda     #$FF                            ; BBAF A9 FF                    ..
        jsr     LBBBB                           ; BBB1 20 BB BB                  ..
        lda     $C08E,x                         ; BBB4 BD 8E C0                 ...
LBBB7:  lda     $C08C,x                         ; BBB7 BD 8C C0                 ...
LBBBA:  rts                                     ; BBBA 60                       `

; ----------------------------------------------------------------------------
LBBBB:  clc                                     ; BBBB 18                       .
LBBBC:  pha                                     ; BBBC 48                       H
        pla                                     ; BBBD 68                       h
LBBBE:  sta     $C08D,x                         ; BBBE 9D 8D C0                 ...
        ora     $C08C,x                         ; BBC1 1D 8C C0                 ...
        rts                                     ; BBC4 60                       `

; ----------------------------------------------------------------------------
LBBC5:  ldy     #$00                            ; BBC5 A0 00                    ..
LBBC7:  ldx     #$56                            ; BBC7 A2 56                    .V
LBBC9:  dex                                     ; BBC9 CA                       .
        bmi     LBBC7                           ; BBCA 30 FB                    0.
        lda     LBE00,y                         ; BBCC B9 00 BE                 ...
        lsr     LBF00,x                         ; BBCF 5E 00 BF                 ^..
        rol     a                               ; BBD2 2A                       *
        lsr     LBF00,x                         ; BBD3 5E 00 BF                 ^..
        rol     a                               ; BBD6 2A                       *
        sta     ($46),y                         ; BBD7 91 46                    .F
        iny                                     ; BBD9 C8                       .
        bne     LBBC9                           ; BBDA D0 ED                    ..
        rts                                     ; BBDC 60                       `

; ----------------------------------------------------------------------------
LBBDD:  ldy     #$20                            ; BBDD A0 20                    . 
LBBDF:  dey                                     ; BBDF 88                       .
        beq     LBC41                           ; BBE0 F0 5F                    ._
LBBE2:  lda     $C08C,x                         ; BBE2 BD 8C C0                 ...
        bpl     LBBE2                           ; BBE5 10 FB                    ..
LBBE7:  eor     #$D5                            ; BBE7 49 D5                    I.
        bne     LBBDF                           ; BBE9 D0 F4                    ..
LBBEB:  lda     $C08C,x                         ; BBEB BD 8C C0                 ...
        bpl     LBBEB                           ; BBEE 10 FB                    ..
        cmp     #$AA                            ; BBF0 C9 AA                    ..
        bne     LBBE7                           ; BBF2 D0 F3                    ..
        ldy     #$56                            ; BBF4 A0 56                    .V
LBBF6:  lda     $C08C,x                         ; BBF6 BD 8C C0                 ...
        bpl     LBBF6                           ; BBF9 10 FB                    ..
        cmp     #$AD                            ; BBFB C9 AD                    ..
        bne     LBBE7                           ; BBFD D0 E8                    ..
        lda     #$00                            ; BBFF A9 00                    ..
LBC01:  dey                                     ; BC01 88                       .
        sty     $42                             ; BC02 84 42                    .B
LBC04:  ldy     $C08C,x                         ; BC04 BC 8C C0                 ...
        bpl     LBC04                           ; BC07 10 FB                    ..
        eor     LBD00,y                         ; BC09 59 00 BD                 Y..
        ldy     $42                             ; BC0C A4 42                    .B
        sta     LBF00,y                         ; BC0E 99 00 BF                 ...
        bne     LBC01                           ; BC11 D0 EE                    ..
LBC13:  sty     $42                             ; BC13 84 42                    .B
LBC15:  ldy     $C08C,x                         ; BC15 BC 8C C0                 ...
        bpl     LBC15                           ; BC18 10 FB                    ..
        eor     LBD00,y                         ; BC1A 59 00 BD                 Y..
        ldy     $42                             ; BC1D A4 42                    .B
        sta     LBE00,y                         ; BC1F 99 00 BE                 ...
        iny                                     ; BC22 C8                       .
        bne     LBC13                           ; BC23 D0 EE                    ..
LBC25:  ldy     $C08C,x                         ; BC25 BC 8C C0                 ...
        bpl     LBC25                           ; BC28 10 FB                    ..
        cmp     LBD00,y                         ; BC2A D9 00 BD                 ...
        bne     LBC41                           ; BC2D D0 12                    ..
LBC2F:  lda     $C08C,x                         ; BC2F BD 8C C0                 ...
        bpl     LBC2F                           ; BC32 10 FB                    ..
        cmp     #$DE                            ; BC34 C9 DE                    ..
        bne     LBC41                           ; BC36 D0 09                    ..
LBC38:  lda     $C08C,x                         ; BC38 BD 8C C0                 ...
        bpl     LBC38                           ; BC3B 10 FB                    ..
        cmp     #$AA                            ; BC3D C9 AA                    ..
        beq     LBC9B                           ; BC3F F0 5A                    .Z
LBC41:  sec                                     ; BC41 38                       8
        rts                                     ; BC42 60                       `

; ----------------------------------------------------------------------------
LBC43:  ldy     #$FC                            ; BC43 A0 FC                    ..
        sty     $42                             ; BC45 84 42                    .B
LBC47:  iny                                     ; BC47 C8                       .
        bne     LBC4E                           ; BC48 D0 04                    ..
        inc     $42                             ; BC4A E6 42                    .B
        beq     LBC41                           ; BC4C F0 F3                    ..
LBC4E:  lda     $C08C,x                         ; BC4E BD 8C C0                 ...
        bpl     LBC4E                           ; BC51 10 FB                    ..
LBC53:  cmp     #$D5                            ; BC53 C9 D5                    ..
        bne     LBC47                           ; BC55 D0 F0                    ..
LBC57:  lda     $C08C,x                         ; BC57 BD 8C C0                 ...
        bpl     LBC57                           ; BC5A 10 FB                    ..
        cmp     #$AA                            ; BC5C C9 AA                    ..
        bne     LBC53                           ; BC5E D0 F3                    ..
        ldy     #$03                            ; BC60 A0 03                    ..
LBC62:  lda     $C08C,x                         ; BC62 BD 8C C0                 ...
        bpl     LBC62                           ; BC65 10 FB                    ..
        cmp     #$96                            ; BC67 C9 96                    ..
        bne     LBC53                           ; BC69 D0 E8                    ..
        lda     #$00                            ; BC6B A9 00                    ..
LBC6D:  sta     $43                             ; BC6D 85 43                    .C
LBC6F:  lda     $C08C,x                         ; BC6F BD 8C C0                 ...
        bpl     LBC6F                           ; BC72 10 FB                    ..
        rol     a                               ; BC74 2A                       *
        sta     $42                             ; BC75 85 42                    .B
LBC77:  lda     $C08C,x                         ; BC77 BD 8C C0                 ...
        bpl     LBC77                           ; BC7A 10 FB                    ..
        and     $42                             ; BC7C 25 42                    %B
        sta     $49,y                           ; BC7E 99 49 00                 .I.
        eor     $43                             ; BC81 45 43                    EC
        dey                                     ; BC83 88                       .
        bpl     LBC6D                           ; BC84 10 E7                    ..
        tay                                     ; BC86 A8                       .
        bne     LBC41                           ; BC87 D0 B8                    ..
LBC89:  lda     $C08C,x                         ; BC89 BD 8C C0                 ...
        bpl     LBC89                           ; BC8C 10 FB                    ..
        cmp     #$DE                            ; BC8E C9 DE                    ..
        bne     LBC41                           ; BC90 D0 AF                    ..
LBC92:  lda     $C08C,x                         ; BC92 BD 8C C0                 ...
        bpl     LBC92                           ; BC95 10 FB                    ..
        cmp     #$AA                            ; BC97 C9 AA                    ..
        bne     LBC41                           ; BC99 D0 A6                    ..
LBC9B:  clc                                     ; BC9B 18                       .
        rts                                     ; BC9C 60                       `

; ----------------------------------------------------------------------------
LBC9D:  sta     $48                             ; BC9D 85 48                    .H
        cmp     $41                             ; BC9F C5 41                    .A
        beq     LBCFE                           ; BCA1 F0 5B                    .[
        lda     $40                             ; BCA3 A5 40                    .@
        bne     LBCAF                           ; BCA5 D0 08                    ..
        ldy     #$10                            ; BCA7 A0 10                    ..
LBCA9:  jsr     LBFB6                           ; BCA9 20 B6 BF                  ..
        dey                                     ; BCAC 88                       .
        bne     LBCA9                           ; BCAD D0 FA                    ..
LBCAF:  lda     #$00                            ; BCAF A9 00                    ..
        sta     $42                             ; BCB1 85 42                    .B
LBCB3:  lda     $41                             ; BCB3 A5 41                    .A
        sta     $43                             ; BCB5 85 43                    .C
        sec                                     ; BCB7 38                       8
        sbc     $48                             ; BCB8 E5 48                    .H
        beq     LBCED                           ; BCBA F0 31                    .1
        bcs     LBCC4                           ; BCBC B0 06                    ..
        eor     #$FF                            ; BCBE 49 FF                    I.
        inc     $41                             ; BCC0 E6 41                    .A
        bcc     LBCC8                           ; BCC2 90 04                    ..
LBCC4:  adc     #$FE                            ; BCC4 69 FE                    i.
        dec     $41                             ; BCC6 C6 41                    .A
LBCC8:  cmp     $42                             ; BCC8 C5 42                    .B
        bcc     LBCCE                           ; BCCA 90 02                    ..
        lda     $42                             ; BCCC A5 42                    .B
LBCCE:  cmp     #$08                            ; BCCE C9 08                    ..
        bcs     LBCD3                           ; BCD0 B0 01                    ..
        tay                                     ; BCD2 A8                       .
LBCD3:  sec                                     ; BCD3 38                       8
        jsr     LBCF1                           ; BCD4 20 F1 BC                  ..
        lda     LBF56,y                         ; BCD7 B9 56 BF                 .V.
        jsr     LBFB6                           ; BCDA 20 B6 BF                  ..
        lda     $43                             ; BCDD A5 43                    .C
        clc                                     ; BCDF 18                       .
        jsr     LBCF3                           ; BCE0 20 F3 BC                  ..
        lda     LBF5E,y                         ; BCE3 B9 5E BF                 .^.
        jsr     LBFB6                           ; BCE6 20 B6 BF                  ..
        inc     $42                             ; BCE9 E6 42                    .B
        bne     LBCB3                           ; BCEB D0 C6                    ..
LBCED:  jsr     LBFB6                           ; BCED 20 B6 BF                  ..
        clc                                     ; BCF0 18                       .
LBCF1:  lda     $41                             ; BCF1 A5 41                    .A
LBCF3:  and     #$03                            ; BCF3 29 03                    ).
        rol     a                               ; BCF5 2A                       *
        ora     $44                             ; BCF6 05 44                    .D
        tax                                     ; BCF8 AA                       .
        lda     $C080,x                         ; BCF9 BD 80 C0                 ...
        ldx     $44                             ; BCFC A6 44                    .D
LBCFE:  rts                                     ; BCFE 60                       `

; ----------------------------------------------------------------------------
LBCFF:  .byte   $86                             ; BCFF 86                       .
LBD00:  eor     $4E84                           ; BD00 4D 84 4E                 M.N
        php                                     ; BD03 08                       .
        sei                                     ; BD04 78                       x
        ldy     #$01                            ; BD05 A0 01                    ..
        lda     ($4D),y                         ; BD07 B1 4D                    .M
        sta     $44                             ; BD09 85 44                    .D
        tax                                     ; BD0B AA                       .
        lda     $C08E,x                         ; BD0C BD 8E C0                 ...
        lda     $C08C,x                         ; BD0F BD 8C C0                 ...
        ldy     #$05                            ; BD12 A0 05                    ..
        lda     ($4D),y                         ; BD14 B1 4D                    .M
        bne     LBD30                           ; BD16 D0 18                    ..
        lda     $C088,x                         ; BD18 BD 88 C0                 ...
        lda     #$FF                            ; BD1B A9 FF                    ..
        sta     $40                             ; BD1D 85 40                    .@
LBD1F:  clc                                     ; BD1F 18                       .
        lda     #$00                            ; BD20 A9 00                    ..
        .byte   $B0                             ; BD22 B0                       .
LBD23:  sec                                     ; BD23 38                       8
        ldy     #$06                            ; BD24 A0 06                    ..
        sta     ($4D),y                         ; BD26 91 4D                    .M
        inc     $40                             ; BD28 E6 40                    .@
        rol     $42                             ; BD2A 26 42                    &B
        plp                                     ; BD2C 28                       (
        lsr     $42                             ; BD2D 46 42                    FB
        rts                                     ; BD2F 60                       `

; ----------------------------------------------------------------------------
LBD30:  ldy     $C089,x                         ; BD30 BC 89 C0                 ...
        cmp     #$02                            ; BD33 C9 02                    ..
        bcc     LBD1F                           ; BD35 90 E8                    ..
        php                                     ; BD37 08                       .
        pha                                     ; BD38 48                       H
        ldy     #$02                            ; BD39 A0 02                    ..
        lda     ($4D),y                         ; BD3B B1 4D                    .M
        asl     a                               ; BD3D 0A                       .
        jsr     LBC9D                           ; BD3E 20 9D BC                  ..
        pla                                     ; BD41 68                       h
        plp                                     ; BD42 28                       (
        beq     LBD1F                           ; BD43 F0 DA                    ..
        lsr     a                               ; BD45 4A                       J
        php                                     ; BD46 08                       .
        ldy     #$04                            ; BD47 A0 04                    ..
        lda     ($4D),y                         ; BD49 B1 4D                    .M
        sta     $47                             ; BD4B 85 47                    .G
        lda     #$00                            ; BD4D A9 00                    ..
        sta     $46                             ; BD4F 85 46                    .F
        bcs     LBD56                           ; BD51 B0 03                    ..
        jsr     LBB03                           ; BD53 20 03 BB                  ..
LBD56:  ldx     $44                             ; BD56 A6 44                    .D
        jsr     LBC43                           ; BD58 20 43 BC                  C.
        .byte   $B0                             ; BD5B B0                       .
LBD5C:  sbc     $07A0,y                         ; BD5C F9 A0 07                 ...
        lda     ($4D),y                         ; BD5F B1 4D                    .M
        cmp     $4C                             ; BD61 C5 4C                    .L
        beq     LBD6A                           ; BD63 F0 05                    ..
        plp                                     ; BD65 28                       (
        lda     #$01                            ; BD66 A9 01                    ..
        bne     LBD23                           ; BD68 D0 B9                    ..
LBD6A:  ldy     #$02                            ; BD6A A0 02                    ..
        lda     ($4D),y                         ; BD6C B1 4D                    .M
        cmp     $4B                             ; BD6E C5 4B                    .K
        bne     LBD56                           ; BD70 D0 E4                    ..
        iny                                     ; BD72 C8                       .
        lda     ($4D),y                         ; BD73 B1 4D                    .M
        tay                                     ; BD75 A8                       .
        lda     LBFA6,y                         ; BD76 B9 A6 BF                 ...
        cmp     $4A                             ; BD79 C5 4A                    .J
        bne     LBD56                           ; BD7B D0 D9                    ..
        plp                                     ; BD7D 28                       (
        bcs     LBD89                           ; BD7E B0 09                    ..
        jsr     LBB2D                           ; BD80 20 2D BB                  -.
        bcc     LBD1F                           ; BD83 90 9A                    ..
        lda     #$02                            ; BD85 A9 02                    ..
        bne     LBD23                           ; BD87 D0 9A                    ..
LBD89:  jsr     LBBDD                           ; BD89 20 DD BB                  ..
        php                                     ; BD8C 08                       .
        bcs     LBD56                           ; BD8D B0 C7                    ..
        plp                                     ; BD8F 28                       (
        jsr     LBBC5                           ; BD90 20 C5 BB                  ..
        beq     LBD1F                           ; BD93 F0 8A                    ..
        .byte   $FF                             ; BD95 FF                       .
        brk                                     ; BD96 00                       .
        ora     ($98,x)                         ; BD97 01 98                    ..
        sta     $0302,y                         ; BD99 99 02 03                 ...
        .byte   $9C                             ; BD9C 9C                       .
        .byte   $04                             ; BD9D 04                       .
        ora     $06                             ; BD9E 05 06                    ..
        ldy     #$A1                            ; BDA0 A0 A1                    ..
        ldx     #$A3                            ; BDA2 A2 A3                    ..
        ldy     $A5                             ; BDA4 A4 A5                    ..
        .byte   $07                             ; BDA6 07                       .
        php                                     ; BDA7 08                       .
        tay                                     ; BDA8 A8                       .
        lda     #$AA                            ; BDA9 A9 AA                    ..
        ora     #$0A                            ; BDAB 09 0A                    ..
LBDAD:  .byte   $0B                             ; BDAD 0B                       .
        .byte   $0C                             ; BDAE 0C                       .
LBDAF:  ora     $B1B0                           ; BDAF 0D B0 B1                 ...
        asl     $100F                           ; BDB2 0E 0F 10                 ...
        ora     ($12),y                         ; BDB5 11 12                    ..
        .byte   $13                             ; BDB7 13                       .
        clv                                     ; BDB8 B8                       .
        .byte   $14                             ; BDB9 14                       .
        ora     $16,x                           ; BDBA 15 16                    ..
        .byte   $17                             ; BDBC 17                       .
        clc                                     ; BDBD 18                       .
        ora     $C01A,y                         ; BDBE 19 1A C0                 ...
        cmp     ($C2,x)                         ; BDC1 C1 C2                    ..
        .byte   $C3                             ; BDC3 C3                       .
        cpy     $C5                             ; BDC4 C4 C5                    ..
        dec     $C7                             ; BDC6 C6 C7                    ..
        iny                                     ; BDC8 C8                       .
        cmp     #$CA                            ; BDC9 C9 CA                    ..
        .byte   $1B                             ; BDCB 1B                       .
        cpy     $1D1C                           ; BDCC CC 1C 1D                 ...
        asl     $D1D0,x                         ; BDCF 1E D0 D1                 ...
        .byte   $D2                             ; BDD2 D2                       .
        .byte   $1F                             ; BDD3 1F                       .
        .byte   $D4                             ; BDD4 D4                       .
        cmp     $20,x                           ; BDD5 D5 20                    . 
        and     ($D8,x)                         ; BDD7 21 D8                    !.
        .byte   $22                             ; BDD9 22                       "
        .byte   $23                             ; BDDA 23                       #
        bit     $25                             ; BDDB 24 25                    $%
        rol     $27                             ; BDDD 26 27                    &'
        plp                                     ; BDDF 28                       (
        cpx     #$E1                            ; BDE0 E0 E1                    ..
        .byte   $E2                             ; BDE2 E2                       .
LBDE3:  .byte   $E3                             ; BDE3 E3                       .
        cpx     $29                             ; BDE4 E4 29                    .)
        rol     a                               ; BDE6 2A                       *
        .byte   $2B                             ; BDE7 2B                       +
        inx                                     ; BDE8 E8                       .
        bit     $2E2D                           ; BDE9 2C 2D 2E                 ,-.
        .byte   $2F                             ; BDEC 2F                       /
        bmi     LBE20                           ; BDED 30 31                    01
        .byte   $32                             ; BDEF 32                       2
        beq     LBDE3                           ; BDF0 F0 F1                    ..
        .byte   $33                             ; BDF2 33                       3
        .byte   $34                             ; BDF3 34                       4
        and     $36,x                           ; BDF4 35 36                    56
        .byte   $37                             ; BDF6 37                       7
        sec                                     ; BDF7 38                       8
        sed                                     ; BDF8 F8                       .
        and     $3B3A,y                         ; BDF9 39 3A 3B                 9:;
        .byte   $3C                             ; BDFC 3C                       <
        and     $3F3E,x                         ; BDFD 3D 3E 3F                 =>?
LBE00:  lda     ($3A),y                         ; BE00 B1 3A                    .:
        jsr     LF956                           ; BE02 20 56 F9                  V.
        sta     $3A                             ; BE05 85 3A                    .:
        tya                                     ; BE07 98                       .
        sec                                     ; BE08 38                       8
        bcs     LBDAD                           ; BE09 B0 A2                    ..
        jsr     LFF4A                           ; BE0B 20 4A FF                  J.
        sec                                     ; BE0E 38                       8
        bcs     LBDAF                           ; BE0F B0 9E                    ..
        nop                                     ; BE11 EA                       .
        nop                                     ; BE12 EA                       .
        jmp     LFB0B                           ; BE13 4C 0B FB                 L..

; ----------------------------------------------------------------------------
        jmp     LFAFD                           ; BE16 4C FD FA                 L..

; ----------------------------------------------------------------------------
        cmp     ($D8,x)                         ; BE19 C1 D8                    ..
        cmp     $D3D0,y                         ; BE1B D9 D0 D3                 ...
        .byte   $AD                             ; BE1E AD                       .
        .byte   $70                             ; BE1F 70                       p
LBE20:  cpy     #$A0                            ; BE20 C0 A0                    ..
        brk                                     ; BE22 00                       .
        nop                                     ; BE23 EA                       .
        nop                                     ; BE24 EA                       .
LBE25:  lda     $C064,x                         ; BE25 BD 64 C0                 .d.
        bpl     LBE2E                           ; BE28 10 04                    ..
        iny                                     ; BE2A C8                       .
        bne     LBE25                           ; BE2B D0 F8                    ..
        dey                                     ; BE2D 88                       .
LBE2E:  rts                                     ; BE2E 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; BE2F A9 00                    ..
        sta     $48                             ; BE31 85 48                    .H
        lda     $C056                           ; BE33 AD 56 C0                 .V.
        lda     $C054                           ; BE36 AD 54 C0                 .T.
        lda     $C051                           ; BE39 AD 51 C0                 .Q.
        lda     #$00                            ; BE3C A9 00                    ..
        beq     LBE4B                           ; BE3E F0 0B                    ..
        .byte   $E7                             ; BE40 E7                       .
        clc                                     ; BE41 18                       .
        .byte   $77                             ; BE42 77                       w
        .byte   $77                             ; BE43 77                       w
        and     $3A,x                           ; BE44 35 3A                    5:
        rol     $7A56                           ; BE46 2E 56 7A                 .Vz
        asl     a                               ; BE49 0A                       .
        .byte   $54                             ; BE4A 54                       T
LBE4B:  .byte   $43                             ; BE4B 43                       C
        .byte   $22                             ; BE4C 22                       "
        lda     #$00                            ; BE4D A9 00                    ..
        ror     a                               ; BE4F 6A                       j
        jsr     L28A9                           ; BE50 20 A9 28                  .(
        sta     $21                             ; BE53 85 21                    .!
        lda     #$18                            ; BE55 A9 18                    ..
        sta     $23                             ; BE57 85 23                    .#
        lda     #$17                            ; BE59 A9 17                    ..
        sta     $25                             ; BE5B 85 25                    .%
        jmp     LFC22                           ; BE5D 4C 22 FC                 L".

; ----------------------------------------------------------------------------
        jsr     LFBA4                           ; BE60 20 A4 FB                  ..
        ldy     #$10                            ; BE63 A0 10                    ..
LBE65:  lda     $50                             ; BE65 A5 50                    .P
        lsr     a                               ; BE67 4A                       J
        bcc     LBE76                           ; BE68 90 0C                    ..
        clc                                     ; BE6A 18                       .
        ldx     #$FE                            ; BE6B A2 FE                    ..
LBE6D:  lda     $54,x                           ; BE6D B5 54                    .T
        adc     $56,x                           ; BE6F 75 56                    uV
        sta     $54,x                           ; BE71 95 54                    .T
        inx                                     ; BE73 E8                       .
        bne     LBE6D                           ; BE74 D0 F7                    ..
LBE76:  ldx     #$03                            ; BE76 A2 03                    ..
LBE78:  ror     $50,x                           ; BE78 76 50                    vP
        dex                                     ; BE7A CA                       .
        bpl     LBE78                           ; BE7B 10 FB                    ..
        dey                                     ; BE7D 88                       .
        bne     LBE65                           ; BE7E D0 E5                    ..
        rts                                     ; BE80 60                       `

; ----------------------------------------------------------------------------
        jsr     LFBA4                           ; BE81 20 A4 FB                  ..
        ldy     #$10                            ; BE84 A0 10                    ..
LBE86:  asl     $50                             ; BE86 06 50                    .P
        rol     $51                             ; BE88 26 51                    &Q
        rol     $52                             ; BE8A 26 52                    &R
        rol     $53                             ; BE8C 26 53                    &S
        sec                                     ; BE8E 38                       8
        lda     $52                             ; BE8F A5 52                    .R
        sbc     $54                             ; BE91 E5 54                    .T
        tax                                     ; BE93 AA                       .
        lda     $53                             ; BE94 A5 53                    .S
        sbc     $55                             ; BE96 E5 55                    .U
        bcc     LBEA0                           ; BE98 90 06                    ..
        stx     $52                             ; BE9A 86 52                    .R
        sta     $53                             ; BE9C 85 53                    .S
        inc     $50                             ; BE9E E6 50                    .P
LBEA0:  dey                                     ; BEA0 88                       .
        bne     LBE86                           ; BEA1 D0 E3                    ..
        rts                                     ; BEA3 60                       `

; ----------------------------------------------------------------------------
        ldy     #$00                            ; BEA4 A0 00                    ..
        sty     $2F                             ; BEA6 84 2F                    ./
        ldx     #$54                            ; BEA8 A2 54                    .T
        jsr     LFBAF                           ; BEAA 20 AF FB                  ..
        ldx     #$50                            ; BEAD A2 50                    .P
        lda     $01,x                           ; BEAF B5 01                    ..
        bpl     LBEC0                           ; BEB1 10 0D                    ..
        sec                                     ; BEB3 38                       8
        tya                                     ; BEB4 98                       .
        sbc     $00,x                           ; BEB5 F5 00                    ..
        sta     $00,x                           ; BEB7 95 00                    ..
        tya                                     ; BEB9 98                       .
        sbc     $01,x                           ; BEBA F5 01                    ..
        .byte   $95                             ; BEBC 95                       .
LBEBD:  ora     ($E6,x)                         ; BEBD 01 E6                    ..
        .byte   $2F                             ; BEBF 2F                       /
LBEC0:  rts                                     ; BEC0 60                       `

; ----------------------------------------------------------------------------
        pha                                     ; BEC1 48                       H
        lsr     a                               ; BEC2 4A                       J
        and     #$03                            ; BEC3 29 03                    ).
        ora     #$04                            ; BEC5 09 04                    ..
        sta     $29                             ; BEC7 85 29                    .)
        pla                                     ; BEC9 68                       h
        and     #$18                            ; BECA 29 18                    ).
        bcc     LBED0                           ; BECC 90 02                    ..
        adc     #$7F                            ; BECE 69 7F                    i.
LBED0:  sta     $28                             ; BED0 85 28                    .(
        asl     a                               ; BED2 0A                       .
        asl     a                               ; BED3 0A                       .
        ora     $28                             ; BED4 05 28                    .(
        sta     $28                             ; BED6 85 28                    .(
        rts                                     ; BED8 60                       `

; ----------------------------------------------------------------------------
        cmp     #$87                            ; BED9 C9 87                    ..
        bne     LBEEF                           ; BEDB D0 12                    ..
        lda     #$40                            ; BEDD A9 40                    .@
        jsr     LFCA8                           ; BEDF 20 A8 FC                  ..
        ldy     #$C0                            ; BEE2 A0 C0                    ..
LBEE4:  lda     #$0C                            ; BEE4 A9 0C                    ..
        jsr     LFCA8                           ; BEE6 20 A8 FC                  ..
        lda     $C030                           ; BEE9 AD 30 C0                 .0.
        dey                                     ; BEEC 88                       .
        bne     LBEE4                           ; BEED D0 F5                    ..
LBEEF:  rts                                     ; BEEF 60                       `

; ----------------------------------------------------------------------------
        ldy     $24                             ; BEF0 A4 24                    .$
        sta     ($28),y                         ; BEF2 91 28                    .(
        inc     $24                             ; BEF4 E6 24                    .$
        lda     $24                             ; BEF6 A5 24                    .$
        cmp     $21                             ; BEF8 C5 21                    .!
        bcs     LBF62                           ; BEFA B0 66                    .f
        rts                                     ; BEFC 60                       `

; ----------------------------------------------------------------------------
        cmp     #$A0                            ; BEFD C9 A0                    ..
LBEFF:  .byte   $B0                             ; BEFF B0                       .
LBF00:  .byte   $04                             ; BF00 04                       .
        php                                     ; BF01 08                       .
        .byte   $0C                             ; BF02 0C                       .
        bpl     LBF19                           ; BF03 10 14                    ..
        clc                                     ; BF05 18                       .
        .byte   $1C                             ; BF06 1C                       .
        brk                                     ; BF07 00                       .
        .byte   $04                             ; BF08 04                       .
        php                                     ; BF09 08                       .
        .byte   $0C                             ; BF0A 0C                       .
        bpl     LBF21                           ; BF0B 10 14                    ..
        clc                                     ; BF0D 18                       .
        .byte   $1C                             ; BF0E 1C                       .
        brk                                     ; BF0F 00                       .
LBF10:  .byte   $04                             ; BF10 04                       .
        php                                     ; BF11 08                       .
        .byte   $0C                             ; BF12 0C                       .
        bpl     LBF29                           ; BF13 10 14                    ..
        clc                                     ; BF15 18                       .
        .byte   $1C                             ; BF16 1C                       .
        brk                                     ; BF17 00                       .
        .byte   $04                             ; BF18 04                       .
LBF19:  php                                     ; BF19 08                       .
LBF1A:  .byte   $0C                             ; BF1A 0C                       .
        bpl     LBF31                           ; BF1B 10 14                    ..
        clc                                     ; BF1D 18                       .
        .byte   $1C                             ; BF1E 1C                       .
        brk                                     ; BF1F 00                       .
        .byte   $04                             ; BF20 04                       .
LBF21:  php                                     ; BF21 08                       .
        lda     $25                             ; BF22 A5 25                    .%
        jsr     LFBC1                           ; BF24 20 C1 FB                  ..
        adc     $20                             ; BF27 65 20                    e 
LBF29:  sta     $28                             ; BF29 85 28                    .(
LBF2B:  rts                                     ; BF2B 60                       `

; ----------------------------------------------------------------------------
        eor     #$C0                            ; BF2C 49 C0                    I.
        beq     LBF58                           ; BF2E F0 28                    .(
        .byte   $69                             ; BF30 69                       i
LBF31:  sbc     $C090,x                         ; BF31 FD 90 C0                 ...
        beq     LBF10                           ; BF34 F0 DA                    ..
        adc     #$FD                            ; BF36 69 FD                    i.
        bcc     LBF66                           ; BF38 90 2C                    .,
        beq     LBF1A                           ; BF3A F0 DE                    ..
        adc     #$FD                            ; BF3C 69 FD                    i.
        bcc     LBF9C                           ; BF3E 90 5C                    .\
        bne     LBF2B                           ; BF40 D0 E9                    ..
        ldy     $24                             ; BF42 A4 24                    .$
        lda     $25                             ; BF44 A5 25                    .%
LBF46:  pha                                     ; BF46 48                       H
        jsr     LFC24                           ; BF47 20 24 FC                  $.
        jsr     LFC9E                           ; BF4A 20 9E FC                  ..
        ldy     #$00                            ; BF4D A0 00                    ..
        pla                                     ; BF4F 68                       h
        adc     #$00                            ; BF50 69 00                    i.
        cmp     $23                             ; BF52 C5 23                    .#
        bcc     LBF46                           ; BF54 90 F0                    ..
LBF56:  ora     ($30,x)                         ; BF56 01 30                    .0
LBF58:  plp                                     ; BF58 28                       (
        bit     $20                             ; BF59 24 20                    $ 
        asl     $1C1D,x                         ; BF5B 1E 1D 1C                 ...
LBF5E:  bvs     LBF8C                           ; BF5E 70 2C                    p,
        rol     $22                             ; BF60 26 22                    &"
LBF62:  .byte   $1F                             ; BF62 1F                       .
        asl     $1C1D,x                         ; BF63 1E 1D 1C                 ...
LBF66:  stx     $97,y                           ; BF66 96 97                    ..
        txs                                     ; BF68 9A                       .
        .byte   $9B                             ; BF69 9B                       .
        sta     $9F9E,x                         ; BF6A 9D 9E 9F                 ...
        ldx     $A7                             ; BF6D A6 A7                    ..
        .byte   $AB                             ; BF6F AB                       .
        ldy     $AEAD                           ; BF70 AC AD AE                 ...
        .byte   $AF                             ; BF73 AF                       .
        .byte   $B2                             ; BF74 B2                       .
        .byte   $B3                             ; BF75 B3                       .
        ldy     $B5,x                           ; BF76 B4 B5                    ..
        ldx     $B7,y                           ; BF78 B6 B7                    ..
        lda     LBBBA,y                         ; BF7A B9 BA BB                 ...
        ldy     LBEBD,x                         ; BF7D BC BD BE                 ...
        .byte   $BF                             ; BF80 BF                       .
        .byte   $CB                             ; BF81 CB                       .
        cmp     $CFCE                           ; BF82 CD CE CF                 ...
        .byte   $D3                             ; BF85 D3                       .
        dec     $D7,x                           ; BF86 D6 D7                    ..
        cmp     $DBDA,y                         ; BF88 D9 DA DB                 ...
        .byte   $DC                             ; BF8B DC                       .
LBF8C:  cmp     $DFDE,x                         ; BF8C DD DE DF                 ...
        sbc     $E6                             ; BF8F E5 E6                    ..
        .byte   $E7                             ; BF91 E7                       .
        sbc     #$EA                            ; BF92 E9 EA                    ..
        .byte   $EB                             ; BF94 EB                       .
        cpx     $EEED                           ; BF95 EC ED EE                 ...
        .byte   $EF                             ; BF98 EF                       .
        .byte   $F2                             ; BF99 F2                       .
        .byte   $F3                             ; BF9A F3                       .
        .byte   $F4                             ; BF9B F4                       .
LBF9C:  sbc     $F6,x                           ; BF9C F5 F6                    ..
        .byte   $F7                             ; BF9E F7                       .
        sbc     $FBFA,y                         ; BF9F F9 FA FB                 ...
        .byte   $FC                             ; BFA2 FC                       .
        sbc     $FFFE,x                         ; BFA3 FD FE FF                 ...
LBFA6:  brk                                     ; BFA6 00                       .
        ora     $090B                           ; BFA7 0D 0B 09                 ...
        .byte   $07                             ; BFAA 07                       .
        ora     $03                             ; BFAB 05 03                    ..
        ora     ($0E,x)                         ; BFAD 01 0E                    ..
        .byte   $0C                             ; BFAF 0C                       .
        asl     a                               ; BFB0 0A                       .
        php                                     ; BFB1 08                       .
        asl     $04                             ; BFB2 06 04                    ..
        .byte   $02                             ; BFB4 02                       .
        .byte   $0F                             ; BFB5 0F                       .
LBFB6:  ldx     #$11                            ; BFB6 A2 11                    ..
LBFB8:  dex                                     ; BFB8 CA                       .
        bne     LBFB8                           ; BFB9 D0 FD                    ..
        jmp     LBFBE                           ; BFBB 4C BE BF                 L..

; ----------------------------------------------------------------------------
LBFBE:  jmp     LBFC1                           ; BFBE 4C C1 BF                 L..

; ----------------------------------------------------------------------------
LBFC1:  nop                                     ; BFC1 EA                       .
        sec                                     ; BFC2 38                       8
        sbc     #$01                            ; BFC3 E9 01                    ..
        bne     LBFB6                           ; BFC5 D0 EF                    ..
        rts                                     ; BFC7 60                       `

; ----------------------------------------------------------------------------
        pha                                     ; BFC8 48                       H
        ldx     #$15                            ; BFC9 A2 15                    ..
        stx     LBFEA                           ; BFCB 8E EA BF                 ...
        ldx     #$00                            ; BFCE A2 00                    ..
        stx     LBFEB                           ; BFD0 8E EB BF                 ...
        ldx     #$40                            ; BFD3 A2 40                    .@
        stx     LBFEC                           ; BFD5 8E EC BF                 ...
        ldx     #$03                            ; BFD8 A2 03                    ..
        stx     LBFED                           ; BFDA 8E ED BF                 ...
        ldx     #$E8                            ; BFDD A2 E8                    ..
        ldy     #$BF                            ; BFDF A0 BF                    ..
        jsr     LBCFF                           ; BFE1 20 FF BC                  ..
        pla                                     ; BFE4 68                       h
        jmp     L4000                           ; BFE5 4C 00 40                 L.@

; ----------------------------------------------------------------------------
        .byte   $02                             ; BFE8 02                       .
LBFE9:  rts                                     ; BFE9 60                       `

; ----------------------------------------------------------------------------
LBFEA:  brk                                     ; BFEA 00                       .
LBFEB:  brk                                     ; BFEB 00                       .
LBFEC:  brk                                     ; BFEC 00                       .
LBFED:  brk                                     ; BFED 00                       .
LBFEE:  brk                                     ; BFEE 00                       .
        inc     $02A9,x                         ; BFEF FE A9 02                 ...
        jmp     L045D                           ; BFF2 4C 5D 04                 L].

; ----------------------------------------------------------------------------
        .byte   $3A                             ; BFF5 3A                       :
        dex                                     ; BFF6 CA                       .
        bne     LBFEE                           ; BFF7 D0 F5                    ..
        rts                                     ; BFF9 60                       `

; ----------------------------------------------------------------------------
        jsr     LFCFD                           ; BFFA 20 FD FC                  ..
        dey                                     ; BFFD 88                       .
        .byte   $AD                             ; BFFE AD                       .
        rts                                     ; BFFF 60                       `

; ----------------------------------------------------------------------------
