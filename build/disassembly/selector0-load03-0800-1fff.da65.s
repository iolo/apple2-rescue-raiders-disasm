; da65 V2.19 - Git a028ac414
; Created:    reproducible build
; Input file: build/extract/selector0-load03-0800-1fff.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L0066           := $0066
L052A           := $052A
L2013           := $2013
L213D           := $213D
L2156           := $2156
L2B05           := $2B05
L2B15           := $2B15
L2C05           := $2C05
L3B05           := $3B05
L3C0B           := $3C0B
L3CAD           := $3CAD
L3E1F           := $3E1F
L3F1C           := $3F1C
L4E65           := $4E65
L6C06           := $6C06
LAB2E           := $AB2E
LFDDA           := $FDDA
LFDED           := $FDED
LFDF0           := $FDF0
LFF7B           := $FF7B
; ----------------------------------------------------------------------------
        jmp     L084F                           ; 0800 4C 4F 08                 LO.

; ----------------------------------------------------------------------------
L0803:  sed                                     ; 0803 F8                       .
        rol     $36,x                           ; 0804 36 36                    66
        ora     ($01,x)                         ; 0806 01 01                    ..
        ora     ($01,x)                         ; 0808 01 01                    ..
        cpy     $C4                             ; 080A C4 C4                    ..
        cpy     $F0                             ; 080C C4 F0                    ..
        ora     ($A5,x)                         ; 080E 01 A5                    ..
        brk                                     ; 0810 00                       .
        ldy     L12A6                           ; 0811 AC A6 12                 ...
        ora     L1079,y                         ; 0814 19 79 10                 .y.
        sta     $65                             ; 0817 85 65                    .e
        lda     L0FB9,y                         ; 0819 B9 B9 0F                 ...
        sta     $64                             ; 081C 85 64                    .d
        rts                                     ; 081E 60                       `

; ----------------------------------------------------------------------------
L081F:  ldy     L12A6                           ; 081F AC A6 12                 ...
        cpy     #$C0                            ; 0822 C0 C0                    ..
        bcs     L084E                           ; 0824 B0 28                    .(
        lda     L0FB9,y                         ; 0826 B9 B9 0F                 ...
        sta     $64                             ; 0829 85 64                    .d
        lda     L1079,y                         ; 082B B9 79 10                 .y.
        ora     $00                             ; 082E 05 00                    ..
        sta     $65                             ; 0830 85 65                    .e
        lda     L12A9                           ; 0832 AD A9 12                 ...
        and     #$07                            ; 0835 29 07                    ).
        tax                                     ; 0837 AA                       .
        lda     L1139,x                         ; 0838 BD 39 11                 .9.
        ldy     #$26                            ; 083B A0 26                    .&
L083D:  sta     ($64),y                         ; 083D 91 64                    .d
        dey                                     ; 083F 88                       .
        dey                                     ; 0840 88                       .
        bpl     L083D                           ; 0841 10 FA                    ..
        lda     L1141,x                         ; 0843 BD 41 11                 .A.
        ldy     #$27                            ; 0846 A0 27                    .'
L0848:  sta     ($64),y                         ; 0848 91 64                    .d
        dey                                     ; 084A 88                       .
        dey                                     ; 084B 88                       .
        bpl     L0848                           ; 084C 10 FA                    ..
L084E:  rts                                     ; 084E 60                       `

; ----------------------------------------------------------------------------
L084F:  jsr     L0859                           ; 084F 20 59 08                  Y.
        jsr     L0889                           ; 0852 20 89 08                  ..
        jsr     L0C45                           ; 0855 20 45 0C                  E.
        rts                                     ; 0858 60                       `

; ----------------------------------------------------------------------------
L0859:  lda     #$40                            ; 0859 A9 40                    .@
        sta     $00                             ; 085B 85 00                    ..
        jsr     L08C0                           ; 085D 20 C0 08                  ..
        bit     $C050                           ; 0860 2C 50 C0                 ,P.
        bit     $C052                           ; 0863 2C 52 C0                 ,R.
        bit     $C055                           ; 0866 2C 55 C0                 ,U.
        bit     $C057                           ; 0869 2C 57 C0                 ,W.
        jsr     L0878                           ; 086C 20 78 08                  x.
        jsr     L08C0                           ; 086F 20 C0 08                  ..
        lda     #$C0                            ; 0872 A9 C0                    ..
        sta     L12AB                           ; 0874 8D AB 12                 ...
        rts                                     ; 0877 60                       `

; ----------------------------------------------------------------------------
L0878:  lda     $00                             ; 0878 A5 00                    ..
        eor     #$60                            ; 087A 49 60                    I`
        sta     $00                             ; 087C 85 00                    ..
        bit     $C054                           ; 087E 2C 54 C0                 ,T.
        cmp     #$20                            ; 0881 C9 20                    . 
        bne     L0888                           ; 0883 D0 03                    ..
        bit     $C055                           ; 0885 2C 55 C0                 ,U.
L0888:  rts                                     ; 0888 60                       `

; ----------------------------------------------------------------------------
L0889:  jsr     L09DE                           ; 0889 20 DE 09                  ..
L088C:  jsr     L0BE3                           ; 088C 20 E3 0B                  ..
        jsr     L0D69                           ; 088F 20 69 0D                  i.
        jsr     L0C4B                           ; 0892 20 4B 0C                  K.
        lda     $C000                           ; 0895 AD 00 C0                 ...
        cmp     #$9B                            ; 0898 C9 9B                    ..
        bne     L08A2                           ; 089A D0 06                    ..
L089C:  dec     L14AE                           ; 089C CE AE 14                 ...
        bit     $C010                           ; 089F 2C 10 C0                 ,..
L08A2:  ldy     L14B1                           ; 08A2 AC B1 14                 ...
        sec                                     ; 08A5 38                       8
L08A6:  lda     #$0A                            ; 08A6 A9 0A                    ..
L08A8:  sbc     #$01                            ; 08A8 E9 01                    ..
        bne     L08A8                           ; 08AA D0 FC                    ..
        dey                                     ; 08AC 88                       .
        bne     L08A6                           ; 08AD D0 F7                    ..
        bit     L14AE                           ; 08AF 2C AE 14                 ,..
        bpl     L088C                           ; 08B2 10 D8                    ..
        lda     #$02                            ; 08B4 A9 02                    ..
        sta     L1298                           ; 08B6 8D 98 12                 ...
        jsr     L0C4B                           ; 08B9 20 4B 0C                  K.
        rts                                     ; 08BC 60                       `

; ----------------------------------------------------------------------------
L08BD:  jmp     (L0066)                         ; 08BD 6C 66 00                 lf.

; ----------------------------------------------------------------------------
L08C0:  lda     $00                             ; 08C0 A5 00                    ..
        sta     L08D0                           ; 08C2 8D D0 08                 ...
        sta     L08D3                           ; 08C5 8D D3 08                 ...
        ldx     #$20                            ; 08C8 A2 20                    . 
        lda     #$00                            ; 08CA A9 00                    ..
L08CC:  ldy     #$77                            ; 08CC A0 77                    .w
L08CE:  .byte   $99                             ; 08CE 99                       .
        brk                                     ; 08CF 00                       .
L08D0:  rti                                     ; 08D0 40                       @

; ----------------------------------------------------------------------------
        .byte   $99                             ; 08D1 99                       .
        .byte   $80                             ; 08D2 80                       .
L08D3:  rti                                     ; 08D3 40                       @

; ----------------------------------------------------------------------------
        dey                                     ; 08D4 88                       .
        bpl     L08CE                           ; 08D5 10 F7                    ..
        inc     L08D0                           ; 08D7 EE D0 08                 ...
        inc     L08D3                           ; 08DA EE D3 08                 ...
        dex                                     ; 08DD CA                       .
        bne     L08CC                           ; 08DE D0 EC                    ..
        jsr     L0A4E                           ; 08E0 20 4E 0A                  N.
        rts                                     ; 08E3 60                       `

; ----------------------------------------------------------------------------
L08E4:  lda     L12A5                           ; 08E4 AD A5 12                 ...
        lsr     a                               ; 08E7 4A                       J
        lda     L12AA                           ; 08E8 AD AA 12                 ...
        rol     a                               ; 08EB 2A                       *
        asl     a                               ; 08EC 0A                       .
        tay                                     ; 08ED A8                       .
        lda     L1700,y                         ; 08EE B9 00 17                 ...
        adc     #$00                            ; 08F1 69 00                    i.
        sta     L0066                           ; 08F3 85 66                    .f
        lda     L1701,y                         ; 08F5 B9 01 17                 ...
        adc     #$17                            ; 08F8 69 17                    i.
        sta     $67                             ; 08FA 85 67                    .g
        ldy     #$00                            ; 08FC A0 00                    ..
        lda     (L0066),y                       ; 08FE B1 66                    .f
        sta     $68                             ; 0900 85 68                    .h
        inc     L0066                           ; 0902 E6 66                    .f
        bne     L0908                           ; 0904 D0 02                    ..
        inc     $67                             ; 0906 E6 67                    .g
L0908:  lda     (L0066),y                       ; 0908 B1 66                    .f
        sta     $69                             ; 090A 85 69                    .i
        inc     L0066                           ; 090C E6 66                    .f
        bne     L0912                           ; 090E D0 02                    ..
        inc     $67                             ; 0910 E6 67                    .g
L0912:  lda     L12A6                           ; 0912 AD A6 12                 ...
        pha                                     ; 0915 48                       H
        lda     L0066                           ; 0916 A5 66                    .f
        sta     L0950                           ; 0918 8D 50 09                 .P.
        lda     $67                             ; 091B A5 67                    .g
        sta     L0951                           ; 091D 8D 51 09                 .Q.
        lda     L12A5                           ; 0920 AD A5 12                 ...
        clc                                     ; 0923 18                       .
        adc     $68                             ; 0924 65 68                    eh
        sta     L0066                           ; 0926 85 66                    .f
        dec     L0066                           ; 0928 C6 66                    .f
L092A:  ldx     L12A6                           ; 092A AE A6 12                 ...
        cpx     L12AB                           ; 092D EC AB 12                 ...
        bcs     L0971                           ; 0930 B0 3F                    .?
        lda     L0FB9,x                         ; 0932 BD B9 0F                 ...
        sta     L0956                           ; 0935 8D 56 09                 .V.
        sta     L0953                           ; 0938 8D 53 09                 .S.
        lda     L1079,x                         ; 093B BD 79 10                 .y.
        ora     $00                             ; 093E 05 00                    ..
        sta     L0957                           ; 0940 8D 57 09                 .W.
        sta     L0954                           ; 0943 8D 54 09                 .T.
        ldx     $68                             ; 0946 A6 68                    .h
        dex                                     ; 0948 CA                       .
        ldy     L0066                           ; 0949 A4 66                    .f
L094B:  cpy     #$28                            ; 094B C0 28                    .(
        bcs     L0958                           ; 094D B0 09                    ..
        .byte   $BD                             ; 094F BD                       .
L0950:  .byte   $34                             ; 0950 34                       4
L0951:  .byte   $12                             ; 0951 12                       .
        .byte   $19                             ; 0952 19                       .
L0953:  .byte   $34                             ; 0953 34                       4
L0954:  .byte   $12                             ; 0954 12                       .
        .byte   $99                             ; 0955 99                       .
L0956:  .byte   $34                             ; 0956 34                       4
L0957:  .byte   $12                             ; 0957 12                       .
L0958:  dey                                     ; 0958 88                       .
        dex                                     ; 0959 CA                       .
        bpl     L094B                           ; 095A 10 EF                    ..
        lda     L0950                           ; 095C AD 50 09                 .P.
        clc                                     ; 095F 18                       .
        adc     $68                             ; 0960 65 68                    eh
        sta     L0950                           ; 0962 8D 50 09                 .P.
        bcc     L096A                           ; 0965 90 03                    ..
        inc     L0951                           ; 0967 EE 51 09                 .Q.
L096A:  inc     L12A6                           ; 096A EE A6 12                 ...
        dec     $69                             ; 096D C6 69                    .i
        bne     L092A                           ; 096F D0 B9                    ..
L0971:  pla                                     ; 0971 68                       h
        sta     L12A6                           ; 0972 8D A6 12                 ...
        rts                                     ; 0975 60                       `

; ----------------------------------------------------------------------------
L0976:  lda     L12A5                           ; 0976 AD A5 12                 ...
        lsr     a                               ; 0979 4A                       J
        lda     L12AA                           ; 097A AD AA 12                 ...
        rol     a                               ; 097D 2A                       *
        asl     a                               ; 097E 0A                       .
        tay                                     ; 097F A8                       .
        lda     L1700,y                         ; 0980 B9 00 17                 ...
        adc     #$00                            ; 0983 69 00                    i.
        sta     L0066                           ; 0985 85 66                    .f
        lda     L1701,y                         ; 0987 B9 01 17                 ...
        adc     #$17                            ; 098A 69 17                    i.
        sta     $67                             ; 098C 85 67                    .g
        ldy     #$00                            ; 098E A0 00                    ..
        lda     (L0066),y                       ; 0990 B1 66                    .f
        sta     $68                             ; 0992 85 68                    .h
        adc     L12A5                           ; 0994 6D A5 12                 m..
        tax                                     ; 0997 AA                       .
        iny                                     ; 0998 C8                       .
        lda     (L0066),y                       ; 0999 B1 66                    .f
        sta     $69                             ; 099B 85 69                    .i
        dex                                     ; 099D CA                       .
        stx     L0066                           ; 099E 86 66                    .f
        lda     L12A6                           ; 09A0 AD A6 12                 ...
        pha                                     ; 09A3 48                       H
L09A4:  ldx     L12A6                           ; 09A4 AE A6 12                 ...
        cpx     L12AB                           ; 09A7 EC AB 12                 ...
        bcs     L09D2                           ; 09AA B0 26                    .&
        lda     L0FB9,x                         ; 09AC BD B9 0F                 ...
        sta     L09C5                           ; 09AF 8D C5 09                 ...
        lda     L1079,x                         ; 09B2 BD 79 10                 .y.
        ora     $00                             ; 09B5 05 00                    ..
        sta     L09C6                           ; 09B7 8D C6 09                 ...
        ldx     $68                             ; 09BA A6 68                    .h
        ldy     L0066                           ; 09BC A4 66                    .f
        lda     #$00                            ; 09BE A9 00                    ..
L09C0:  cpy     #$28                            ; 09C0 C0 28                    .(
        bcs     L09C7                           ; 09C2 B0 03                    ..
        .byte   $99                             ; 09C4 99                       .
L09C5:  .byte   $34                             ; 09C5 34                       4
L09C6:  .byte   $12                             ; 09C6 12                       .
L09C7:  dey                                     ; 09C7 88                       .
        dex                                     ; 09C8 CA                       .
        bne     L09C0                           ; 09C9 D0 F5                    ..
        inc     L12A6                           ; 09CB EE A6 12                 ...
        dec     $69                             ; 09CE C6 69                    .i
        bne     L09A4                           ; 09D0 D0 D2                    ..
L09D2:  pla                                     ; 09D2 68                       h
        sta     L12A6                           ; 09D3 8D A6 12                 ...
        rts                                     ; 09D6 60                       `

; ----------------------------------------------------------------------------
        jsr     L09DB                           ; 09D7 20 DB 09                  ..
        txa                                     ; 09DA 8A                       .
L09DB:  jmp     LFDDA                           ; 09DB 4C DA FD                 L..

; ----------------------------------------------------------------------------
L09DE:  lda     #$00                            ; 09DE A9 00                    ..
        sta     L13E1                           ; 09E0 8D E1 13                 ...
        sta     L13E2                           ; 09E3 8D E2 13                 ...
        sta     L14AE                           ; 09E6 8D AE 14                 ...
        sta     L14B0                           ; 09E9 8D B0 14                 ...
        sta     L14B1                           ; 09EC 8D B1 14                 ...
        sta     L14B2                           ; 09EF 8D B2 14                 ...
        inc     L14B1                           ; 09F2 EE B1 14                 ...
        jsr     L0A16                           ; 09F5 20 16 0A                  ..
        jsr     L0A38                           ; 09F8 20 38 0A                  8.
        jsr     L0D38                           ; 09FB 20 38 0D                  8.
        jsr     L0D4C                           ; 09FE 20 4C 0D                  L.
        jsr     L0A0B                           ; 0A01 20 0B 0A                  ..
        jsr     L0ECF                           ; 0A04 20 CF 0E                  ..
        bit     $C010                           ; 0A07 2C 10 C0                 ,..
        rts                                     ; 0A0A 60                       `

; ----------------------------------------------------------------------------
L0A0B:  lda     #$B6                            ; 0A0B A9 B6                    ..
        sta     L13E6                           ; 0A0D 8D E6 13                 ...
        lda     #$00                            ; 0A10 A9 00                    ..
        sta     L13E5                           ; 0A12 8D E5 13                 ...
        rts                                     ; 0A15 60                       `

; ----------------------------------------------------------------------------
L0A16:  lda     #$00                            ; 0A16 A9 00                    ..
        sta     L12B2                           ; 0A18 8D B2 12                 ...
        sta     L12B3                           ; 0A1B 8D B3 12                 ...
        sta     L12B4                           ; 0A1E 8D B4 12                 ...
        sta     L12B7                           ; 0A21 8D B7 12                 ...
        sta     L12B1                           ; 0A24 8D B1 12                 ...
        sta     L12BD                           ; 0A27 8D BD 12                 ...
        sta     L13E4                           ; 0A2A 8D E4 13                 ...
        lda     #$EC                            ; 0A2D A9 EC                    ..
        sta     L12B5                           ; 0A2F 8D B5 12                 ...
        lda     #$9D                            ; 0A32 A9 9D                    ..
        sta     L12B6                           ; 0A34 8D B6 12                 ...
        rts                                     ; 0A37 60                       `

; ----------------------------------------------------------------------------
L0A38:  lda     #$00                            ; 0A38 A9 00                    ..
        sta     L1299                           ; 0A3A 8D 99 12                 ...
        sta     L129D                           ; 0A3D 8D 9D 12                 ...
        sta     L12A1                           ; 0A40 8D A1 12                 ...
        lda     #$9D                            ; 0A43 A9 9D                    ..
        sta     L129B                           ; 0A45 8D 9B 12                 ...
        lda     #$0C                            ; 0A48 A9 0C                    ..
        .byte   $8D                             ; 0A4A 8D                       .
        txs                                     ; 0A4B 9A                       .
L0A4C:  .byte   $12                             ; 0A4C 12                       .
        rts                                     ; 0A4D 60                       `

; ----------------------------------------------------------------------------
L0A4E:  lda     #$06                            ; 0A4E A9 06                    ..
        sta     L12A9                           ; 0A50 8D A9 12                 ...
        lda     #$BF                            ; 0A53 A9 BF                    ..
        sta     L12A6                           ; 0A55 8D A6 12                 ...
        lda     #$0A                            ; 0A58 A9 0A                    ..
L0A5A:  pha                                     ; 0A5A 48                       H
        jsr     L081F                           ; 0A5B 20 1F 08                  ..
        dec     L12A6                           ; 0A5E CE A6 12                 ...
        pla                                     ; 0A61 68                       h
        sec                                     ; 0A62 38                       8
        sbc     #$01                            ; 0A63 E9 01                    ..
        bne     L0A5A                           ; 0A65 D0 F3                    ..
        rts                                     ; 0A67 60                       `

; ----------------------------------------------------------------------------
L0A68:  lda     #$B6                            ; 0A68 A9 B6                    ..
        sta     L12AB                           ; 0A6A 8D AB 12                 ...
        lda     L12BD                           ; 0A6D AD BD 12                 ...
        beq     L0AC6                           ; 0A70 F0 54                    .T
        lda     L12BB                           ; 0A72 AD BB 12                 ...
        sta     L12A5                           ; 0A75 8D A5 12                 ...
        lda     L12BC                           ; 0A78 AD BC 12                 ...
        sta     L12A6                           ; 0A7B 8D A6 12                 ...
        cmp     L12B6                           ; 0A7E CD B6 12                 ...
        bne     L0A8B                           ; 0A81 D0 08                    ..
        lda     L12B5                           ; 0A83 AD B5 12                 ...
        cmp     L12A5                           ; 0A86 CD A5 12                 ...
        beq     L0A93                           ; 0A89 F0 08                    ..
L0A8B:  lda     #$04                            ; 0A8B A9 04                    ..
        sta     L12AA                           ; 0A8D 8D AA 12                 ...
        jsr     L0976                           ; 0A90 20 76 09                  v.
L0A93:  lda     L12A6                           ; 0A93 AD A6 12                 ...
        clc                                     ; 0A96 18                       .
        adc     #$12                            ; 0A97 69 12                    i.
        sta     L12A6                           ; 0A99 8D A6 12                 ...
        lda     #$05                            ; 0A9C A9 05                    ..
        sta     L12AA                           ; 0A9E 8D AA 12                 ...
        jsr     L0976                           ; 0AA1 20 76 09                  v.
        lda     L12A5                           ; 0AA4 AD A5 12                 ...
        clc                                     ; 0AA7 18                       .
        adc     #$0E                            ; 0AA8 69 0E                    i.
        sta     L12A5                           ; 0AAA 8D A5 12                 ...
        lda     #$08                            ; 0AAD A9 08                    ..
        sta     L12AA                           ; 0AAF 8D AA 12                 ...
        jsr     L0976                           ; 0AB2 20 76 09                  v.
        lda     L12A5                           ; 0AB5 AD A5 12                 ...
        clc                                     ; 0AB8 18                       .
        adc     #$04                            ; 0AB9 69 04                    i.
        sta     L12A5                           ; 0ABB 8D A5 12                 ...
        lda     #$0B                            ; 0ABE A9 0B                    ..
        sta     L12AA                           ; 0AC0 8D AA 12                 ...
        jsr     L0976                           ; 0AC3 20 76 09                  v.
L0AC6:  lda     L12B1                           ; 0AC6 AD B1 12                 ...
        sta     L12BD                           ; 0AC9 8D BD 12                 ...
        lda     L12AF                           ; 0ACC AD AF 12                 ...
        sta     L12BB                           ; 0ACF 8D BB 12                 ...
        lda     L12B0                           ; 0AD2 AD B0 12                 ...
        sta     L12BC                           ; 0AD5 8D BC 12                 ...
        lda     L12B7                           ; 0AD8 AD B7 12                 ...
        sta     L12B1                           ; 0ADB 8D B1 12                 ...
        beq     L0B39                           ; 0ADE F0 59                    .Y
        lda     L12B5                           ; 0AE0 AD B5 12                 ...
        sta     L12A5                           ; 0AE3 8D A5 12                 ...
        sta     L12AF                           ; 0AE6 8D AF 12                 ...
        lda     L12B6                           ; 0AE9 AD B6 12                 ...
        sta     L12A6                           ; 0AEC 8D A6 12                 ...
        sta     L12B0                           ; 0AEF 8D B0 12                 ...
        lda     #$04                            ; 0AF2 A9 04                    ..
        sta     L12AA                           ; 0AF4 8D AA 12                 ...
        jsr     L08E4                           ; 0AF7 20 E4 08                  ..
        lda     #$05                            ; 0AFA A9 05                    ..
        clc                                     ; 0AFC 18                       .
        adc     L12B2                           ; 0AFD 6D B2 12                 m..
        sta     L12AA                           ; 0B00 8D AA 12                 ...
        lda     L12A6                           ; 0B03 AD A6 12                 ...
        clc                                     ; 0B06 18                       .
        adc     #$12                            ; 0B07 69 12                    i.
        sta     L12A6                           ; 0B09 8D A6 12                 ...
        jsr     L08E4                           ; 0B0C 20 E4 08                  ..
        lda     L12A5                           ; 0B0F AD A5 12                 ...
        clc                                     ; 0B12 18                       .
        adc     #$0E                            ; 0B13 69 0E                    i.
        sta     L12A5                           ; 0B15 8D A5 12                 ...
        lda     #$08                            ; 0B18 A9 08                    ..
        clc                                     ; 0B1A 18                       .
        adc     L12B3                           ; 0B1B 6D B3 12                 m..
        sta     L12AA                           ; 0B1E 8D AA 12                 ...
        jsr     L08E4                           ; 0B21 20 E4 08                  ..
        lda     L12A5                           ; 0B24 AD A5 12                 ...
        clc                                     ; 0B27 18                       .
        adc     #$04                            ; 0B28 69 04                    i.
        sta     L12A5                           ; 0B2A 8D A5 12                 ...
        lda     #$0B                            ; 0B2D A9 0B                    ..
        clc                                     ; 0B2F 18                       .
        adc     L12B4                           ; 0B30 6D B4 12                 m..
        sta     L12AA                           ; 0B33 8D AA 12                 ...
        jsr     L08E4                           ; 0B36 20 E4 08                  ..
L0B39:  rts                                     ; 0B39 60                       `

; ----------------------------------------------------------------------------
L0B3A:  lda     #$9D                            ; 0B3A A9 9D                    ..
        sta     L12AB                           ; 0B3C 8D AB 12                 ...
        lda     L12A1                           ; 0B3F AD A1 12                 ...
        beq     L0B74                           ; 0B42 F0 30                    .0
        lda     L12A2                           ; 0B44 AD A2 12                 ...
        sta     L12A5                           ; 0B47 8D A5 12                 ...
        lda     L12A3                           ; 0B4A AD A3 12                 ...
        sta     L12A6                           ; 0B4D 8D A6 12                 ...
        lda     L12A0                           ; 0B50 AD A0 12                 ...
        sta     L12AA                           ; 0B53 8D AA 12                 ...
        jsr     L0976                           ; 0B56 20 76 09                  v.
        lda     L12A5                           ; 0B59 AD A5 12                 ...
        cmp     L129A                           ; 0B5C CD 9A 12                 ...
        bne     L0B69                           ; 0B5F D0 08                    ..
        lda     L12A6                           ; 0B61 AD A6 12                 ...
        cmp     L129B                           ; 0B64 CD 9B 12                 ...
        beq     L0B74                           ; 0B67 F0 0B                    ..
L0B69:  inc     L12A6                           ; 0B69 EE A6 12                 ...
        lda     #$03                            ; 0B6C A9 03                    ..
        sta     L12AA                           ; 0B6E 8D AA 12                 ...
        jsr     L0976                           ; 0B71 20 76 09                  v.
L0B74:  lda     L129D                           ; 0B74 AD 9D 12                 ...
        sta     L12A1                           ; 0B77 8D A1 12                 ...
        beq     L0B8E                           ; 0B7A F0 12                    ..
        lda     L129E                           ; 0B7C AD 9E 12                 ...
        sta     L12A2                           ; 0B7F 8D A2 12                 ...
        lda     L129F                           ; 0B82 AD 9F 12                 ...
        sta     L12A3                           ; 0B85 8D A3 12                 ...
        lda     L129C                           ; 0B88 AD 9C 12                 ...
        sta     L12A0                           ; 0B8B 8D A0 12                 ...
L0B8E:  lda     L1299                           ; 0B8E AD 99 12                 ...
        sta     L129D                           ; 0B91 8D 9D 12                 ...
        beq     L0BC2                           ; 0B94 F0 2C                    .,
        lda     L129A                           ; 0B96 AD 9A 12                 ...
        sta     L12A5                           ; 0B99 8D A5 12                 ...
        sta     L129E                           ; 0B9C 8D 9E 12                 ...
        lda     L129B                           ; 0B9F AD 9B 12                 ...
        sta     L12A6                           ; 0BA2 8D A6 12                 ...
        sta     L129F                           ; 0BA5 8D 9F 12                 ...
        ldx     L1298                           ; 0BA8 AE 98 12                 ...
        lda     L0FB4,x                         ; 0BAB BD B4 0F                 ...
        sta     L12AA                           ; 0BAE 8D AA 12                 ...
        sta     L129C                           ; 0BB1 8D 9C 12                 ...
        jsr     L08E4                           ; 0BB4 20 E4 08                  ..
        inc     L12A6                           ; 0BB7 EE A6 12                 ...
        lda     #$03                            ; 0BBA A9 03                    ..
        sta     L12AA                           ; 0BBC 8D AA 12                 ...
        jsr     L08E4                           ; 0BBF 20 E4 08                  ..
L0BC2:  rts                                     ; 0BC2 60                       `

; ----------------------------------------------------------------------------
L0BC3:  adc     $C000                           ; 0BC3 6D 00 C0                 m..
        adc     L0066                           ; 0BC6 65 66                    ef
        adc     $67                             ; 0BC8 65 67                    eg
        adc     $D000,x                         ; 0BCA 7D 00 D0                 }..
        adc     $E000,y                         ; 0BCD 79 00 E0                 y..
        adc     L12A5                           ; 0BD0 6D A5 12                 m..
        adc     L12A6                           ; 0BD3 6D A6 12                 m..
        adc     L12BF                           ; 0BD6 6D BF 12                 m..
        adc     L12C0                           ; 0BD9 6D C0 12                 m..
        sta     L12BF                           ; 0BDC 8D BF 12                 ...
        inc     L12C0                           ; 0BDF EE C0 12                 ...
        rts                                     ; 0BE2 60                       `

; ----------------------------------------------------------------------------
L0BE3:  lda     #$00                            ; 0BE3 A9 00                    ..
        sta     L14AF                           ; 0BE5 8D AF 14                 ...
        inc     L13E1                           ; 0BE8 EE E1 13                 ...
        bne     L0BF0                           ; 0BEB D0 03                    ..
        inc     L13E2                           ; 0BED EE E2 13                 ...
L0BF0:  lda     #$49                            ; 0BF0 A9 49                    .I
        sta     $62                             ; 0BF2 85 62                    .b
        lda     #$11                            ; 0BF4 A9 11                    ..
        sta     $63                             ; 0BF6 85 63                    .c
L0BF8:  ldy     #$00                            ; 0BF8 A0 00                    ..
        lda     ($62),y                         ; 0BFA B1 62                    .b
        cmp     L13E1                           ; 0BFC CD E1 13                 ...
        .byte   $D0                             ; 0BFF D0                       .
L0C00:  asl     $B1C8                           ; 0C00 0E C8 B1                 ...
        .byte   $62                             ; 0C03 62                       b
        cmp     L13E2                           ; 0C04 CD E2 13                 ...
        bne     L0C0F                           ; 0C07 D0 06                    ..
        inc     L14AF                           ; 0C09 EE AF 14                 ...
L0C0C:  jsr     L0C37                           ; 0C0C 20 37 0C                  7.
L0C0F:  ldy     #$00                            ; 0C0F A0 00                    ..
        lda     ($62),y                         ; 0C11 B1 62                    .b
        iny                                     ; 0C13 C8                       .
        ora     ($62),y                         ; 0C14 11 62                    .b
        beq     L0C25                           ; 0C16 F0 0D                    ..
        lda     $62                             ; 0C18 A5 62                    .b
        clc                                     ; 0C1A 18                       .
        adc     #$04                            ; 0C1B 69 04                    i.
        sta     $62                             ; 0C1D 85 62                    .b
        bne     L0BF8                           ; 0C1F D0 D7                    ..
        inc     $63                             ; 0C21 E6 63                    .c
        bne     L0BF8                           ; 0C23 D0 D3                    ..
L0C25:  lda     L14AF                           ; 0C25 AD AF 14                 ...
        beq     L0C36                           ; 0C28 F0 0C                    ..
        ldy     L14B0                           ; 0C2A AC B0 14                 ...
        lda     L0803,y                         ; 0C2D B9 03 08                 ...
        sta     L14B1                           ; 0C30 8D B1 14                 ...
        inc     L14B0                           ; 0C33 EE B0 14                 ...
L0C36:  rts                                     ; 0C36 60                       `

; ----------------------------------------------------------------------------
L0C37:  iny                                     ; 0C37 C8                       .
        lda     ($62),y                         ; 0C38 B1 62                    .b
        sta     L0066                           ; 0C3A 85 66                    .f
        iny                                     ; 0C3C C8                       .
        lda     ($62),y                         ; 0C3D B1 62                    .b
        sta     $67                             ; 0C3F 85 67                    .g
        jsr     L08BD                           ; 0C41 20 BD 08                  ..
        rts                                     ; 0C44 60                       `

; ----------------------------------------------------------------------------
L0C45:  lda     $00                             ; 0C45 A5 00                    ..
        cmp     #$40                            ; 0C47 C9 40                    .@
        beq     L0C5A                           ; 0C49 F0 0F                    ..
L0C4B:  jsr     L0C5B                           ; 0C4B 20 5B 0C                  [.
        jsr     L0CC5                           ; 0C4E 20 C5 0C                  ..
        jsr     L0B3A                           ; 0C51 20 3A 0B                  :.
        jsr     L0A68                           ; 0C54 20 68 0A                  h.
        .byte   $20                             ; 0C57 20                        
L0C58:  sei                                     ; 0C58 78                       x
        php                                     ; 0C59 08                       .
L0C5A:  rts                                     ; 0C5A 60                       `

; ----------------------------------------------------------------------------
L0C5B:  ldx     #$1F                            ; 0C5B A2 1F                    ..
L0C5D:  lda     L1381,x                         ; 0C5D BD 81 13                 ...
L0C60:  beq     L0C7B                           ; 0C60 F0 19                    ..
        ldy     L13C1,x                         ; 0C62 BC C1 13                 ...
        .byte   $B9                             ; 0C65 B9                       .
L0C66:  lda     $8D0F,y                         ; 0C66 B9 0F 8D                 ...
        adc     $B90C,y                         ; 0C69 79 0C B9                 y..
        adc     $0510,y                         ; 0C6C 79 10 05                 y..
        brk                                     ; 0C6F 00                       .
        sta     L0C7A                           ; 0C70 8D 7A 0C                 .z.
        lda     #$00                            ; 0C73 A9 00                    ..
        ldy     L13A1,x                         ; 0C75 BC A1 13                 ...
        .byte   $99                             ; 0C78 99                       .
L0C79:  .byte   $34                             ; 0C79 34                       4
L0C7A:  .byte   $12                             ; 0C7A 12                       .
L0C7B:  lda     L1321,x                         ; 0C7B BD 21 13                 .!.
        sta     L1381,x                         ; 0C7E 9D 81 13                 ...
        beq     L0C8F                           ; 0C81 F0 0C                    ..
        lda     L1341,x                         ; 0C83 BD 41 13                 .A.
        sta     L13A1,x                         ; 0C86 9D A1 13                 ...
        lda     L1361,x                         ; 0C89 BD 61 13                 .a.
        sta     L13C1,x                         ; 0C8C 9D C1 13                 ...
L0C8F:  lda     L12C1,x                         ; 0C8F BD C1 12                 ...
        sta     L1321,x                         ; 0C92 9D 21 13                 .!.
        beq     L0CC1                           ; 0C95 F0 2A                    .*
        ldy     L1301,x                         ; 0C97 BC 01 13                 ...
        tya                                     ; 0C9A 98                       .
        sta     L1361,x                         ; 0C9B 9D 61 13                 .a.
        lda     L0FB9,y                         ; 0C9E B9 B9 0F                 ...
        sta     $64                             ; 0CA1 85 64                    .d
        lda     L1079,y                         ; 0CA3 B9 79 10                 .y.
        ora     $00                             ; 0CA6 05 00                    ..
        sta     $65                             ; 0CA8 85 65                    .e
        sty     L12A6                           ; 0CAA 8C A6 12                 ...
        jsr     L0BC3                           ; 0CAD 20 C3 0B                  ..
        and     #$07                            ; 0CB0 29 07                    ).
        tay                                     ; 0CB2 A8                       .
        lda     L117F,y                         ; 0CB3 B9 7F 11                 ...
        ldy     L12E1,x                         ; 0CB6 BC E1 12                 ...
        ora     ($64),y                         ; 0CB9 11 64                    .d
        sta     ($64),y                         ; 0CBB 91 64                    .d
        tya                                     ; 0CBD 98                       .
        sta     L1341,x                         ; 0CBE 9D 41 13                 .A.
L0CC1:  dex                                     ; 0CC1 CA                       .
        bpl     L0C5D                           ; 0CC2 10 99                    ..
        rts                                     ; 0CC4 60                       `

; ----------------------------------------------------------------------------
L0CC5:  lda     #$B6                            ; 0CC5 A9 B6                    ..
        sta     L12AB                           ; 0CC7 8D AB 12                 ...
        lda     #$0F                            ; 0CCA A9 0F                    ..
        sta     L14A7                           ; 0CCC 8D A7 14                 ...
L0CCF:  ldx     L14A7                           ; 0CCF AE A7 14                 ...
        lda     L1467,x                         ; 0CD2 BD 67 14                 .g.
        beq     L0CEF                           ; 0CD5 F0 18                    ..
        lda     L1477,x                         ; 0CD7 BD 77 14                 .w.
        sta     L12A5                           ; 0CDA 8D A5 12                 ...
        lda     L1487,x                         ; 0CDD BD 87 14                 ...
        sta     L12A6                           ; 0CE0 8D A6 12                 ...
        lda     L1497,x                         ; 0CE3 BD 97 14                 ...
        sta     L12AA                           ; 0CE6 8D AA 12                 ...
        jsr     L0976                           ; 0CE9 20 76 09                  v.
        ldx     L14A7                           ; 0CEC AE A7 14                 ...
L0CEF:  lda     L1427,x                         ; 0CEF BD 27 14                 .'.
        sta     L1467,x                         ; 0CF2 9D 67 14                 .g.
        beq     L0D09                           ; 0CF5 F0 12                    ..
        lda     L1437,x                         ; 0CF7 BD 37 14                 .7.
        sta     L1477,x                         ; 0CFA 9D 77 14                 .w.
        lda     L1447,x                         ; 0CFD BD 47 14                 .G.
        sta     L1487,x                         ; 0D00 9D 87 14                 ...
        lda     L1457,x                         ; 0D03 BD 57 14                 .W.
        sta     L1497,x                         ; 0D06 9D 97 14                 ...
L0D09:  lda     L13E7,x                         ; 0D09 BD E7 13                 ...
        sta     L1427,x                         ; 0D0C 9D 27 14                 .'.
        beq     L0D32                           ; 0D0F F0 21                    .!
        lda     L13F7,x                         ; 0D11 BD F7 13                 ...
        sta     L12A5                           ; 0D14 8D A5 12                 ...
        sta     L1437,x                         ; 0D17 9D 37 14                 .7.
        lda     L1407,x                         ; 0D1A BD 07 14                 ...
        .byte   $8D                             ; 0D1D 8D                       .
L0D1E:  ldx     $12                             ; 0D1E A6 12                    ..
        sta     L1447,x                         ; 0D20 9D 47 14                 .G.
        lda     L1417,x                         ; 0D23 BD 17 14                 ...
        clc                                     ; 0D26 18                       .
        adc     #$0D                            ; 0D27 69 0D                    i.
        sta     L12AA                           ; 0D29 8D AA 12                 ...
        sta     L1457,x                         ; 0D2C 9D 57 14                 .W.
        jsr     L08E4                           ; 0D2F 20 E4 08                  ..
L0D32:  dec     L14A7                           ; 0D32 CE A7 14                 ...
        bpl     L0CCF                           ; 0D35 10 98                    ..
        rts                                     ; 0D37 60                       `

; ----------------------------------------------------------------------------
L0D38:  lda     #$00                            ; 0D38 A9 00                    ..
        sta     L13E3                           ; 0D3A 8D E3 13                 ...
        ldy     #$1F                            ; 0D3D A0 1F                    ..
L0D3F:  sta     L12C1,y                         ; 0D3F 99 C1 12                 ...
        sta     L1321,y                         ; 0D42 99 21 13                 .!.
        sta     L1381,y                         ; 0D45 99 81 13                 ...
        dey                                     ; 0D48 88                       .
        bpl     L0D3F                           ; 0D49 10 F4                    ..
        rts                                     ; 0D4B 60                       `

; ----------------------------------------------------------------------------
L0D4C:  ldx     #$0F                            ; 0D4C A2 0F                    ..
        lda     #$00                            ; 0D4E A9 00                    ..
L0D50:  sta     L13E7,x                         ; 0D50 9D E7 13                 ...
        sta     L1427,x                         ; 0D53 9D 27 14                 .'.
        .byte   $9D                             ; 0D56 9D                       .
        .byte   $67                             ; 0D57 67                       g
L0D58:  .byte   $14                             ; 0D58 14                       .
        dex                                     ; 0D59 CA                       .
        bpl     L0D50                           ; 0D5A 10 F4                    ..
        rts                                     ; 0D5C 60                       `

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 0D5D A9 FF                    ..
        sta     L13E3                           ; 0D5F 8D E3 13                 ...
        rts                                     ; 0D62 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 0D63 A9 00                    ..
        sta     L13E3                           ; 0D65 8D E3 13                 ...
        rts                                     ; 0D68 60                       `

; ----------------------------------------------------------------------------
L0D69:  jsr     L0E45                           ; 0D69 20 45 0E                  E.
        jsr     L0DE2                           ; 0D6C 20 E2 0D                  ..
        jsr     L0D9D                           ; 0D6F 20 9D 0D                  ..
        jsr     L0DF7                           ; 0D72 20 F7 0D                  ..
        jsr     L0D7C                           ; 0D75 20 7C 0D                  |.
        jsr     L0ED5                           ; 0D78 20 D5 0E                  ..
        rts                                     ; 0D7B 60                       `

; ----------------------------------------------------------------------------
L0D7C:  bit     L13E5                           ; 0D7C 2C E5 13                 ,..
        bpl     L0D9C                           ; 0D7F 10 1B                    ..
        lda     L13E6                           ; 0D81 AD E6 13                 ...
        cmp     #$C2                            ; 0D84 C9 C2                    ..
        beq     L0D9C                           ; 0D86 F0 14                    ..
        sta     L12A6                           ; 0D88 8D A6 12                 ...
        lda     #$00                            ; 0D8B A9 00                    ..
        sta     L12A9                           ; 0D8D 8D A9 12                 ...
        jsr     L081F                           ; 0D90 20 1F 08                  ..
        dec     L12A6                           ; 0D93 CE A6 12                 ...
        jsr     L081F                           ; 0D96 20 1F 08                  ..
        inc     L13E6                           ; 0D99 EE E6 13                 ...
L0D9C:  rts                                     ; 0D9C 60                       `

; ----------------------------------------------------------------------------
L0D9D:  lda     L12B7                           ; 0D9D AD B7 12                 ...
        bne     L0DA3                           ; 0DA0 D0 01                    ..
        rts                                     ; 0DA2 60                       `

; ----------------------------------------------------------------------------
L0DA3:  lda     L12B5                           ; 0DA3 AD B5 12                 ...
        clc                                     ; 0DA6 18                       .
        adc     L12BE                           ; 0DA7 6D BE 12                 m..
        sta     L12B5                           ; 0DAA 8D B5 12                 ...
        lda     L12BE                           ; 0DAD AD BE 12                 ...
        beq     L0DB5                           ; 0DB0 F0 03                    ..
        dec     L13E4                           ; 0DB2 CE E4 13                 ...
L0DB5:  dec     L13E4                           ; 0DB5 CE E4 13                 ...
        bpl     L0DC5                           ; 0DB8 10 0B                    ..
        jsr     L0BC3                           ; 0DBA 20 C3 0B                  ..
        and     #$0F                            ; 0DBD 29 0F                    ).
        clc                                     ; 0DBF 18                       .
        adc     #$10                            ; 0DC0 69 10                    i.
        sta     L13E4                           ; 0DC2 8D E4 13                 ...
L0DC5:  ldx     L13E4                           ; 0DC5 AE E4 13                 ...
        lda     L1187,x                         ; 0DC8 BD 87 11                 ...
        pha                                     ; 0DCB 48                       H
        and     #$03                            ; 0DCC 29 03                    ).
        sta     L12B2                           ; 0DCE 8D B2 12                 ...
        pla                                     ; 0DD1 68                       h
        lsr     a                               ; 0DD2 4A                       J
        lsr     a                               ; 0DD3 4A                       J
        pha                                     ; 0DD4 48                       H
        and     #$03                            ; 0DD5 29 03                    ).
        sta     L12B3                           ; 0DD7 8D B3 12                 ...
        pla                                     ; 0DDA 68                       h
        lsr     a                               ; 0DDB 4A                       J
        lsr     a                               ; 0DDC 4A                       J
        sta     L12B4                           ; 0DDD 8D B4 12                 ...
        rts                                     ; 0DE0 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 0DE1 60                       `

; ----------------------------------------------------------------------------
L0DE2:  lda     L129B                           ; 0DE2 AD 9B 12                 ...
        clc                                     ; 0DE5 18                       .
        adc     L12A4                           ; 0DE6 6D A4 12                 m..
        sta     L129B                           ; 0DE9 8D 9B 12                 ...
        dec     L1298                           ; 0DEC CE 98 12                 ...
        bpl     L0DF6                           ; 0DEF 10 05                    ..
        lda     #$04                            ; 0DF1 A9 04                    ..
        sta     L1298                           ; 0DF3 8D 98 12                 ...
L0DF6:  rts                                     ; 0DF6 60                       `

; ----------------------------------------------------------------------------
L0DF7:  lda     L12B7                           ; 0DF7 AD B7 12                 ...
        beq     L0E2C                           ; 0DFA F0 30                    .0
        lda     L13E1                           ; 0DFC AD E1 13                 ...
        and     #$07                            ; 0DFF 29 07                    ).
        bne     L0E2C                           ; 0E01 D0 29                    .)
        jsr     L0BC3                           ; 0E03 20 C3 0B                  ..
        and     #$03                            ; 0E06 29 03                    ).
        beq     L0E2C                           ; 0E08 F0 22                    ."
        ldx     #$0F                            ; 0E0A A2 0F                    ..
L0E0C:  lda     L13E7,x                         ; 0E0C BD E7 13                 ...
        beq     L0E16                           ; 0E0F F0 05                    ..
        dex                                     ; 0E11 CA                       .
        bpl     L0E0C                           ; 0E12 10 F8                    ..
        bmi     L0E2C                           ; 0E14 30 16                    0.
L0E16:  dec     L13E7,x                         ; 0E16 DE E7 13                 ...
        lda     L12B5                           ; 0E19 AD B5 12                 ...
        clc                                     ; 0E1C 18                       .
        adc     #$0E                            ; 0E1D 69 0E                    i.
        sta     L13F7,x                         ; 0E1F 9D F7 13                 ...
        lda     #$93                            ; 0E22 A9 93                    ..
        sta     L1407,x                         ; 0E24 9D 07 14                 ...
        lda     #$06                            ; 0E27 A9 06                    ..
        sta     L1417,x                         ; 0E29 9D 17 14                 ...
L0E2C:  ldx     #$0F                            ; 0E2C A2 0F                    ..
L0E2E:  lda     L13E7,x                         ; 0E2E BD E7 13                 ...
        beq     L0E41                           ; 0E31 F0 0E                    ..
        dec     L1417,x                         ; 0E33 DE 17 14                 ...
        bmi     L0E3E                           ; 0E36 30 06                    0.
        ldy     L1417,x                         ; 0E38 BC 17 14                 ...
        jmp     L0E41                           ; 0E3B 4C 41 0E                 LA.

; ----------------------------------------------------------------------------
L0E3E:  inc     L13E7,x                         ; 0E3E FE E7 13                 ...
L0E41:  dex                                     ; 0E41 CA                       .
        bpl     L0E2E                           ; 0E42 10 EA                    ..
        rts                                     ; 0E44 60                       `

; ----------------------------------------------------------------------------
L0E45:  ldx     #$1F                            ; 0E45 A2 1F                    ..
L0E47:  lda     L12C1,x                         ; 0E47 BD C1 12                 ...
        beq     L0E5E                           ; 0E4A F0 12                    ..
        txa                                     ; 0E4C 8A                       .
        lsr     a                               ; 0E4D 4A                       J
        bcc     L0E56                           ; 0E4E 90 06                    ..
        eor     L13E1                           ; 0E50 4D E1 13                 M..
        lsr     a                               ; 0E53 4A                       J
        bcc     L0E5E                           ; 0E54 90 08                    ..
L0E56:  dec     L12E1,x                         ; 0E56 DE E1 12                 ...
        bpl     L0E5E                           ; 0E59 10 03                    ..
        inc     L12C1,x                         ; 0E5B FE C1 12                 ...
L0E5E:  dex                                     ; 0E5E CA                       .
        bpl     L0E47                           ; 0E5F 10 E6                    ..
        bit     L13E3                           ; 0E61 2C E3 13                 ,..
        .byte   $10                             ; 0E64 10                       .
L0E65:  .byte   $1D                             ; 0E65 1D                       .
L0E66:  jsr     L0BC3                           ; 0E66 20 C3 0B                  ..
        and     #$1F                            ; 0E69 29 1F                    ).
        tax                                     ; 0E6B AA                       .
        lda     L12C1,x                         ; 0E6C BD C1 12                 ...
        bne     L0E83                           ; 0E6F D0 12                    ..
        jsr     L0BC3                           ; 0E71 20 C3 0B                  ..
        cmp     #$B6                            ; 0E74 C9 B6                    ..
        bcs     L0E83                           ; 0E76 B0 0B                    ..
        sta     L1301,x                         ; 0E78 9D 01 13                 ...
        lda     #$27                            ; 0E7B A9 27                    .'
        sta     L12E1,x                         ; 0E7D 9D E1 12                 ...
        dec     L12C1,x                         ; 0E80 DE C1 12                 ...
L0E83:  rts                                     ; 0E83 60                       `

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 0E84 A9 FF                    ..
        sta     L12B7                           ; 0E86 8D B7 12                 ...
        lda     #$01                            ; 0E89 A9 01                    ..
        sta     L12BE                           ; 0E8B 8D BE 12                 ...
        rts                                     ; 0E8E 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 0E8F A9 00                    ..
        sta     L12BE                           ; 0E91 8D BE 12                 ...
        rts                                     ; 0E94 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 0E95 A9 00                    ..
        sta     L12B7                           ; 0E97 8D B7 12                 ...
        rts                                     ; 0E9A 60                       `

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 0E9B A9 FF                    ..
        sta     L1299                           ; 0E9D 8D 99 12                 ...
        lda     #$FF                            ; 0EA0 A9 FF                    ..
        sta     L12A4                           ; 0EA2 8D A4 12                 ...
        rts                                     ; 0EA5 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 0EA6 A9 00                    ..
        sta     L12A4                           ; 0EA8 8D A4 12                 ...
        rts                                     ; 0EAB 60                       `

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 0EAC A9 FF                    ..
        sta     L13E5                           ; 0EAE 8D E5 13                 ...
        rts                                     ; 0EB1 60                       `

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 0EB2 A9 FF                    ..
        sta     L14A8                           ; 0EB4 8D A8 14                 ...
        lda     #$02                            ; 0EB7 A9 02                    ..
        sta     L14AB                           ; 0EB9 8D AB 14                 ...
        lda     #$00                            ; 0EBC A9 00                    ..
        sta     L14A9                           ; 0EBE 8D A9 14                 ...
        lda     #$0E                            ; 0EC1 A9 0E                    ..
        sta     L14AA                           ; 0EC3 8D AA 14                 ...
        lda     #$A7                            ; 0EC6 A9 A7                    ..
        sta     $60                             ; 0EC8 85 60                    .`
        lda     #$11                            ; 0ECA A9 11                    ..
        sta     $61                             ; 0ECC 85 61                    .a
        rts                                     ; 0ECE 60                       `

; ----------------------------------------------------------------------------
L0ECF:  lda     #$00                            ; 0ECF A9 00                    ..
        sta     L14A8                           ; 0ED1 8D A8 14                 ...
        rts                                     ; 0ED4 60                       `

; ----------------------------------------------------------------------------
L0ED5:  lda     L14A8                           ; 0ED5 AD A8 14                 ...
        bne     L0EDB                           ; 0ED8 D0 01                    ..
        rts                                     ; 0EDA 60                       `

; ----------------------------------------------------------------------------
L0EDB:  lda     L14A9                           ; 0EDB AD A9 14                 ...
        sta     L14AC                           ; 0EDE 8D AC 14                 ...
        lda     L14AA                           ; 0EE1 AD AA 14                 ...
        sta     L14AD                           ; 0EE4 8D AD 14                 ...
        ldy     #$00                            ; 0EE7 A0 00                    ..
        lda     ($60),y                         ; 0EE9 B1 60                    .`
        jsr     L0F24                           ; 0EEB 20 24 0F                  $.
        iny                                     ; 0EEE C8                       .
        lda     ($60),y                         ; 0EEF B1 60                    .`
        beq     L0EF8                           ; 0EF1 F0 05                    ..
        lda     #$AA                            ; 0EF3 A9 AA                    ..
        jsr     L0F24                           ; 0EF5 20 24 0F                  $.
L0EF8:  dec     L14AB                           ; 0EF8 CE AB 14                 ...
        bne     L0F23                           ; 0EFB D0 26                    .&
        lda     #$02                            ; 0EFD A9 02                    ..
        sta     L14AB                           ; 0EFF 8D AB 14                 ...
        inc     L14A9                           ; 0F02 EE A9 14                 ...
        lda     L14A9                           ; 0F05 AD A9 14                 ...
        cmp     #$28                            ; 0F08 C9 28                    .(
        bne     L0F14                           ; 0F0A D0 08                    ..
        lda     #$00                            ; 0F0C A9 00                    ..
        sta     L14A9                           ; 0F0E 8D A9 14                 ...
        inc     L14AA                           ; 0F11 EE AA 14                 ...
L0F14:  inc     $60                             ; 0F14 E6 60                    .`
        bne     L0F1A                           ; 0F16 D0 02                    ..
        inc     $61                             ; 0F18 E6 61                    .a
L0F1A:  ldy     #$00                            ; 0F1A A0 00                    ..
        lda     ($60),y                         ; 0F1C B1 60                    .`
        bne     L0F23                           ; 0F1E D0 03                    ..
        sta     L14A8                           ; 0F20 8D A8 14                 ...
L0F23:  rts                                     ; 0F23 60                       `

; ----------------------------------------------------------------------------
L0F24:  pha                                     ; 0F24 48                       H
        asl     a                               ; 0F25 0A                       .
        asl     a                               ; 0F26 0A                       .
        asl     a                               ; 0F27 0A                       .
        sta     L0F4D                           ; 0F28 8D 4D 0F                 .M.
        lda     #$15                            ; 0F2B A9 15                    ..
        adc     #$00                            ; 0F2D 69 00                    i.
        sta     L0F4E                           ; 0F2F 8D 4E 0F                 .N.
        tya                                     ; 0F32 98                       .
        pha                                     ; 0F33 48                       H
        txa                                     ; 0F34 8A                       .
        pha                                     ; 0F35 48                       H
        ldy     L14AD                           ; 0F36 AC AD 14                 ...
        lda     L0F84,y                         ; 0F39 B9 84 0F                 ...
        sta     L0F50                           ; 0F3C 8D 50 0F                 .P.
        lda     L0F9C,y                         ; 0F3F B9 9C 0F                 ...
        ora     $00                             ; 0F42 05 00                    ..
        sta     L0F51                           ; 0F44 8D 51 0F                 .Q.
        ldy     L14AC                           ; 0F47 AC AC 14                 ...
        ldx     #$07                            ; 0F4A A2 07                    ..
L0F4C:  .byte   $BD                             ; 0F4C BD                       .
L0F4D:  .byte   $34                             ; 0F4D 34                       4
L0F4E:  .byte   $12                             ; 0F4E 12                       .
        .byte   $99                             ; 0F4F 99                       .
L0F50:  .byte   $34                             ; 0F50 34                       4
L0F51:  .byte   $12                             ; 0F51 12                       .
        lda     L0F51                           ; 0F52 AD 51 0F                 .Q.
        clc                                     ; 0F55 18                       .
        adc     #$04                            ; 0F56 69 04                    i.
        sta     L0F51                           ; 0F58 8D 51 0F                 .Q.
        dex                                     ; 0F5B CA                       .
        bpl     L0F4C                           ; 0F5C 10 EE                    ..
        inc     L14AC                           ; 0F5E EE AC 14                 ...
        lda     L14AC                           ; 0F61 AD AC 14                 ...
        cmp     #$28                            ; 0F64 C9 28                    .(
L0F66:  bne     L0F7A                           ; 0F66 D0 12                    ..
L0F68:  lda     #$00                            ; 0F68 A9 00                    ..
L0F6A:  .byte   $8D                             ; 0F6A 8D                       .
        .byte   $AC                             ; 0F6B AC                       .
L0F6C:  .byte   $14                             ; 0F6C 14                       .
        inc     L14AD                           ; 0F6D EE AD 14                 ...
        lda     L14AD                           ; 0F70 AD AD 14                 ...
        cmp     #$18                            ; 0F73 C9 18                    ..
        bne     L0F7A                           ; 0F75 D0 03                    ..
        dec     L14AD                           ; 0F77 CE AD 14                 ...
L0F7A:  pla                                     ; 0F7A 68                       h
        tax                                     ; 0F7B AA                       .
        pla                                     ; 0F7C 68                       h
        tay                                     ; 0F7D A8                       .
        pla                                     ; 0F7E 68                       h
        rts                                     ; 0F7F 60                       `

; ----------------------------------------------------------------------------
        dec     L14AE                           ; 0F80 CE AE 14                 ...
        rts                                     ; 0F83 60                       `

; ----------------------------------------------------------------------------
L0F84:  brk                                     ; 0F84 00                       .
        .byte   $80                             ; 0F85 80                       .
        brk                                     ; 0F86 00                       .
        .byte   $80                             ; 0F87 80                       .
        brk                                     ; 0F88 00                       .
        .byte   $80                             ; 0F89 80                       .
        brk                                     ; 0F8A 00                       .
        .byte   $80                             ; 0F8B 80                       .
        plp                                     ; 0F8C 28                       (
        tay                                     ; 0F8D A8                       .
        plp                                     ; 0F8E 28                       (
        tay                                     ; 0F8F A8                       .
        plp                                     ; 0F90 28                       (
        tay                                     ; 0F91 A8                       .
        plp                                     ; 0F92 28                       (
        tay                                     ; 0F93 A8                       .
        bvc     L0F66                           ; 0F94 50 D0                    P.
        bvc     L0F68                           ; 0F96 50 D0                    P.
        bvc     L0F6A                           ; 0F98 50 D0                    P.
        bvc     L0F6C                           ; 0F9A 50 D0                    P.
L0F9C:  brk                                     ; 0F9C 00                       .
        brk                                     ; 0F9D 00                       .
        ora     ($01,x)                         ; 0F9E 01 01                    ..
        .byte   $02                             ; 0FA0 02                       .
        .byte   $02                             ; 0FA1 02                       .
        .byte   $03                             ; 0FA2 03                       .
        .byte   $03                             ; 0FA3 03                       .
        brk                                     ; 0FA4 00                       .
        brk                                     ; 0FA5 00                       .
        ora     ($01,x)                         ; 0FA6 01 01                    ..
        .byte   $02                             ; 0FA8 02                       .
        .byte   $02                             ; 0FA9 02                       .
        .byte   $03                             ; 0FAA 03                       .
        .byte   $03                             ; 0FAB 03                       .
        brk                                     ; 0FAC 00                       .
        brk                                     ; 0FAD 00                       .
        ora     ($01,x)                         ; 0FAE 01 01                    ..
        .byte   $02                             ; 0FB0 02                       .
        .byte   $02                             ; 0FB1 02                       .
        .byte   $03                             ; 0FB2 03                       .
        .byte   $03                             ; 0FB3 03                       .
L0FB4:  .byte   $02                             ; 0FB4 02                       .
        ora     ($00,x)                         ; 0FB5 01 00                    ..
        ora     ($02,x)                         ; 0FB7 01 02                    ..
L0FB9:  brk                                     ; 0FB9 00                       .
        brk                                     ; 0FBA 00                       .
        brk                                     ; 0FBB 00                       .
        brk                                     ; 0FBC 00                       .
        brk                                     ; 0FBD 00                       .
        brk                                     ; 0FBE 00                       .
        brk                                     ; 0FBF 00                       .
        brk                                     ; 0FC0 00                       .
        .byte   $80                             ; 0FC1 80                       .
        .byte   $80                             ; 0FC2 80                       .
        .byte   $80                             ; 0FC3 80                       .
        .byte   $80                             ; 0FC4 80                       .
        .byte   $80                             ; 0FC5 80                       .
        .byte   $80                             ; 0FC6 80                       .
        .byte   $80                             ; 0FC7 80                       .
        .byte   $80                             ; 0FC8 80                       .
        brk                                     ; 0FC9 00                       .
        brk                                     ; 0FCA 00                       .
        brk                                     ; 0FCB 00                       .
        brk                                     ; 0FCC 00                       .
        brk                                     ; 0FCD 00                       .
        brk                                     ; 0FCE 00                       .
        brk                                     ; 0FCF 00                       .
        brk                                     ; 0FD0 00                       .
        .byte   $80                             ; 0FD1 80                       .
        .byte   $80                             ; 0FD2 80                       .
        .byte   $80                             ; 0FD3 80                       .
        .byte   $80                             ; 0FD4 80                       .
        .byte   $80                             ; 0FD5 80                       .
        .byte   $80                             ; 0FD6 80                       .
        .byte   $80                             ; 0FD7 80                       .
        .byte   $80                             ; 0FD8 80                       .
        brk                                     ; 0FD9 00                       .
        brk                                     ; 0FDA 00                       .
        brk                                     ; 0FDB 00                       .
        brk                                     ; 0FDC 00                       .
        brk                                     ; 0FDD 00                       .
        brk                                     ; 0FDE 00                       .
        brk                                     ; 0FDF 00                       .
        brk                                     ; 0FE0 00                       .
        .byte   $80                             ; 0FE1 80                       .
        .byte   $80                             ; 0FE2 80                       .
        .byte   $80                             ; 0FE3 80                       .
        .byte   $80                             ; 0FE4 80                       .
        .byte   $80                             ; 0FE5 80                       .
        .byte   $80                             ; 0FE6 80                       .
        .byte   $80                             ; 0FE7 80                       .
        .byte   $80                             ; 0FE8 80                       .
        brk                                     ; 0FE9 00                       .
        brk                                     ; 0FEA 00                       .
        brk                                     ; 0FEB 00                       .
        brk                                     ; 0FEC 00                       .
        brk                                     ; 0FED 00                       .
        brk                                     ; 0FEE 00                       .
        brk                                     ; 0FEF 00                       .
        brk                                     ; 0FF0 00                       .
        .byte   $80                             ; 0FF1 80                       .
        .byte   $80                             ; 0FF2 80                       .
        .byte   $80                             ; 0FF3 80                       .
        .byte   $80                             ; 0FF4 80                       .
        .byte   $80                             ; 0FF5 80                       .
        .byte   $80                             ; 0FF6 80                       .
        .byte   $80                             ; 0FF7 80                       .
        .byte   $80                             ; 0FF8 80                       .
        plp                                     ; 0FF9 28                       (
        plp                                     ; 0FFA 28                       (
        plp                                     ; 0FFB 28                       (
        plp                                     ; 0FFC 28                       (
        plp                                     ; 0FFD 28                       (
        plp                                     ; 0FFE 28                       (
        plp                                     ; 0FFF 28                       (
        plp                                     ; 1000 28                       (
        tay                                     ; 1001 A8                       .
        tay                                     ; 1002 A8                       .
        tay                                     ; 1003 A8                       .
        tay                                     ; 1004 A8                       .
        tay                                     ; 1005 A8                       .
        tay                                     ; 1006 A8                       .
        tay                                     ; 1007 A8                       .
        tay                                     ; 1008 A8                       .
        plp                                     ; 1009 28                       (
        plp                                     ; 100A 28                       (
        plp                                     ; 100B 28                       (
        plp                                     ; 100C 28                       (
        plp                                     ; 100D 28                       (
        plp                                     ; 100E 28                       (
        plp                                     ; 100F 28                       (
        plp                                     ; 1010 28                       (
        tay                                     ; 1011 A8                       .
        tay                                     ; 1012 A8                       .
L1013:  tay                                     ; 1013 A8                       .
        tay                                     ; 1014 A8                       .
L1015:  tay                                     ; 1015 A8                       .
        tay                                     ; 1016 A8                       .
L1017:  tay                                     ; 1017 A8                       .
        tay                                     ; 1018 A8                       .
L1019:  plp                                     ; 1019 28                       (
        plp                                     ; 101A 28                       (
        plp                                     ; 101B 28                       (
        plp                                     ; 101C 28                       (
        plp                                     ; 101D 28                       (
        plp                                     ; 101E 28                       (
        plp                                     ; 101F 28                       (
        plp                                     ; 1020 28                       (
        tay                                     ; 1021 A8                       .
        tay                                     ; 1022 A8                       .
L1023:  tay                                     ; 1023 A8                       .
        tay                                     ; 1024 A8                       .
L1025:  tay                                     ; 1025 A8                       .
        tay                                     ; 1026 A8                       .
L1027:  tay                                     ; 1027 A8                       .
        tay                                     ; 1028 A8                       .
L1029:  plp                                     ; 1029 28                       (
        plp                                     ; 102A 28                       (
        plp                                     ; 102B 28                       (
        plp                                     ; 102C 28                       (
        plp                                     ; 102D 28                       (
        plp                                     ; 102E 28                       (
        plp                                     ; 102F 28                       (
        plp                                     ; 1030 28                       (
        tay                                     ; 1031 A8                       .
        tay                                     ; 1032 A8                       .
L1033:  tay                                     ; 1033 A8                       .
        tay                                     ; 1034 A8                       .
L1035:  tay                                     ; 1035 A8                       .
        tay                                     ; 1036 A8                       .
L1037:  tay                                     ; 1037 A8                       .
        tay                                     ; 1038 A8                       .
L1039:  bvc     L108B                           ; 1039 50 50                    PP
        bvc     L108D                           ; 103B 50 50                    PP
        bvc     L108F                           ; 103D 50 50                    PP
        bvc     L1091                           ; 103F 50 50                    PP
        bne     L1013                           ; 1041 D0 D0                    ..
L1043:  bne     L1015                           ; 1043 D0 D0                    ..
L1045:  bne     L1017                           ; 1045 D0 D0                    ..
L1047:  bne     L1019                           ; 1047 D0 D0                    ..
L1049:  bvc     L109B                           ; 1049 50 50                    PP
        bvc     L109D                           ; 104B 50 50                    PP
        bvc     L109F                           ; 104D 50 50                    PP
        bvc     L10A1                           ; 104F 50 50                    PP
        bne     L1023                           ; 1051 D0 D0                    ..
        bne     L1025                           ; 1053 D0 D0                    ..
        bne     L1027                           ; 1055 D0 D0                    ..
        bne     L1029                           ; 1057 D0 D0                    ..
        bvc     L10AB                           ; 1059 50 50                    PP
        bvc     L10AD                           ; 105B 50 50                    PP
        bvc     L10AF                           ; 105D 50 50                    PP
        bvc     L10B1                           ; 105F 50 50                    PP
        bne     L1033                           ; 1061 D0 D0                    ..
        bne     L1035                           ; 1063 D0 D0                    ..
        bne     L1037                           ; 1065 D0 D0                    ..
        bne     L1039                           ; 1067 D0 D0                    ..
        bvc     L10BB                           ; 1069 50 50                    PP
        bvc     L10BD                           ; 106B 50 50                    PP
        bvc     L10BF                           ; 106D 50 50                    PP
        bvc     L10C1                           ; 106F 50 50                    PP
        bne     L1043                           ; 1071 D0 D0                    ..
        bne     L1045                           ; 1073 D0 D0                    ..
        bne     L1047                           ; 1075 D0 D0                    ..
        bne     L1049                           ; 1077 D0 D0                    ..
L1079:  brk                                     ; 1079 00                       .
        .byte   $04                             ; 107A 04                       .
        php                                     ; 107B 08                       .
        .byte   $0C                             ; 107C 0C                       .
        bpl     L1093                           ; 107D 10 14                    ..
        clc                                     ; 107F 18                       .
        .byte   $1C                             ; 1080 1C                       .
        brk                                     ; 1081 00                       .
        .byte   $04                             ; 1082 04                       .
        php                                     ; 1083 08                       .
        .byte   $0C                             ; 1084 0C                       .
        bpl     L109B                           ; 1085 10 14                    ..
        clc                                     ; 1087 18                       .
        .byte   $1C                             ; 1088 1C                       .
        ora     ($05,x)                         ; 1089 01 05                    ..
L108B:  ora     #$0D                            ; 108B 09 0D                    ..
L108D:  ora     ($15),y                         ; 108D 11 15                    ..
L108F:  .byte   $19                             ; 108F 19                       .
        .byte   $1D                             ; 1090 1D                       .
L1091:  ora     ($05,x)                         ; 1091 01 05                    ..
L1093:  ora     #$0D                            ; 1093 09 0D                    ..
        ora     ($15),y                         ; 1095 11 15                    ..
        ora     $021D,y                         ; 1097 19 1D 02                 ...
        .byte   $06                             ; 109A 06                       .
L109B:  asl     a                               ; 109B 0A                       .
        .byte   $0E                             ; 109C 0E                       .
L109D:  .byte   $12                             ; 109D 12                       .
        .byte   $16                             ; 109E 16                       .
L109F:  .byte   $1A                             ; 109F 1A                       .
        .byte   $1E                             ; 10A0 1E                       .
L10A1:  .byte   $02                             ; 10A1 02                       .
        asl     $0A                             ; 10A2 06 0A                    ..
        asl     L1612                           ; 10A4 0E 12 16                 ...
        .byte   $1A                             ; 10A7 1A                       .
        asl     $0703,x                         ; 10A8 1E 03 07                 ...
L10AB:  .byte   $0B                             ; 10AB 0B                       .
        .byte   $0F                             ; 10AC 0F                       .
L10AD:  .byte   $13                             ; 10AD 13                       .
        .byte   $17                             ; 10AE 17                       .
L10AF:  .byte   $1B                             ; 10AF 1B                       .
        .byte   $1F                             ; 10B0 1F                       .
L10B1:  .byte   $03                             ; 10B1 03                       .
        .byte   $07                             ; 10B2 07                       .
        .byte   $0B                             ; 10B3 0B                       .
        .byte   $0F                             ; 10B4 0F                       .
        .byte   $13                             ; 10B5 13                       .
        .byte   $17                             ; 10B6 17                       .
        .byte   $1B                             ; 10B7 1B                       .
        .byte   $1F                             ; 10B8 1F                       .
        brk                                     ; 10B9 00                       .
        .byte   $04                             ; 10BA 04                       .
L10BB:  php                                     ; 10BB 08                       .
        .byte   $0C                             ; 10BC 0C                       .
L10BD:  bpl     L10D3                           ; 10BD 10 14                    ..
L10BF:  clc                                     ; 10BF 18                       .
        .byte   $1C                             ; 10C0 1C                       .
L10C1:  brk                                     ; 10C1 00                       .
        .byte   $04                             ; 10C2 04                       .
        php                                     ; 10C3 08                       .
        .byte   $0C                             ; 10C4 0C                       .
        bpl     L10DB                           ; 10C5 10 14                    ..
        clc                                     ; 10C7 18                       .
        .byte   $1C                             ; 10C8 1C                       .
        ora     ($05,x)                         ; 10C9 01 05                    ..
        ora     #$0D                            ; 10CB 09 0D                    ..
        ora     ($15),y                         ; 10CD 11 15                    ..
        ora     $011D,y                         ; 10CF 19 1D 01                 ...
        .byte   $05                             ; 10D2 05                       .
L10D3:  ora     #$0D                            ; 10D3 09 0D                    ..
        ora     ($15),y                         ; 10D5 11 15                    ..
        ora     $021D,y                         ; 10D7 19 1D 02                 ...
        .byte   $06                             ; 10DA 06                       .
L10DB:  asl     a                               ; 10DB 0A                       .
        asl     L1612                           ; 10DC 0E 12 16                 ...
        .byte   $1A                             ; 10DF 1A                       .
        asl     $0602,x                         ; 10E0 1E 02 06                 ...
        asl     a                               ; 10E3 0A                       .
        asl     L1612                           ; 10E4 0E 12 16                 ...
        .byte   $1A                             ; 10E7 1A                       .
        asl     $0703,x                         ; 10E8 1E 03 07                 ...
        .byte   $0B                             ; 10EB 0B                       .
        .byte   $0F                             ; 10EC 0F                       .
        .byte   $13                             ; 10ED 13                       .
        .byte   $17                             ; 10EE 17                       .
        .byte   $1B                             ; 10EF 1B                       .
        .byte   $1F                             ; 10F0 1F                       .
        .byte   $03                             ; 10F1 03                       .
        .byte   $07                             ; 10F2 07                       .
        .byte   $0B                             ; 10F3 0B                       .
        .byte   $0F                             ; 10F4 0F                       .
        .byte   $13                             ; 10F5 13                       .
        .byte   $17                             ; 10F6 17                       .
        .byte   $1B                             ; 10F7 1B                       .
        .byte   $1F                             ; 10F8 1F                       .
        brk                                     ; 10F9 00                       .
        .byte   $04                             ; 10FA 04                       .
        php                                     ; 10FB 08                       .
        .byte   $0C                             ; 10FC 0C                       .
        bpl     L1113                           ; 10FD 10 14                    ..
        clc                                     ; 10FF 18                       .
        .byte   $1C                             ; 1100 1C                       .
        brk                                     ; 1101 00                       .
        .byte   $04                             ; 1102 04                       .
        php                                     ; 1103 08                       .
        .byte   $0C                             ; 1104 0C                       .
        bpl     L111B                           ; 1105 10 14                    ..
        clc                                     ; 1107 18                       .
        .byte   $1C                             ; 1108 1C                       .
        ora     ($05,x)                         ; 1109 01 05                    ..
        ora     #$0D                            ; 110B 09 0D                    ..
        ora     ($15),y                         ; 110D 11 15                    ..
        ora     $011D,y                         ; 110F 19 1D 01                 ...
        .byte   $05                             ; 1112 05                       .
L1113:  ora     #$0D                            ; 1113 09 0D                    ..
        ora     ($15),y                         ; 1115 11 15                    ..
        ora     $021D,y                         ; 1117 19 1D 02                 ...
        .byte   $06                             ; 111A 06                       .
L111B:  asl     a                               ; 111B 0A                       .
        asl     L1612                           ; 111C 0E 12 16                 ...
        .byte   $1A                             ; 111F 1A                       .
        asl     $0602,x                         ; 1120 1E 02 06                 ...
        asl     a                               ; 1123 0A                       .
        asl     L1612                           ; 1124 0E 12 16                 ...
        .byte   $1A                             ; 1127 1A                       .
        asl     $0703,x                         ; 1128 1E 03 07                 ...
        .byte   $0B                             ; 112B 0B                       .
        .byte   $0F                             ; 112C 0F                       .
        .byte   $13                             ; 112D 13                       .
        .byte   $17                             ; 112E 17                       .
        .byte   $1B                             ; 112F 1B                       .
        .byte   $1F                             ; 1130 1F                       .
        .byte   $03                             ; 1131 03                       .
        .byte   $07                             ; 1132 07                       .
        .byte   $0B                             ; 1133 0B                       .
        .byte   $0F                             ; 1134 0F                       .
        .byte   $13                             ; 1135 13                       .
        .byte   $17                             ; 1136 17                       .
        .byte   $1B                             ; 1137 1B                       .
        .byte   $1F                             ; 1138 1F                       .
L1139:  brk                                     ; 1139 00                       .
        .byte   $7F                             ; 113A 7F                       .
        rol     a                               ; 113B 2A                       *
        eor     $80,x                           ; 113C 55 80                    U.
        .byte   $FF                             ; 113E FF                       .
        tax                                     ; 113F AA                       .
        .byte   $D5                             ; 1140 D5                       .
L1141:  brk                                     ; 1141 00                       .
        .byte   $7F                             ; 1142 7F                       .
        eor     $2A,x                           ; 1143 55 2A                    U*
        .byte   $80                             ; 1145 80                       .
        .byte   $FF                             ; 1146 FF                       .
        cmp     $AA,x                           ; 1147 D5 AA                    ..
        iny                                     ; 1149 C8                       .
        brk                                     ; 114A 00                       .
        eor     $F40D,x                         ; 114B 5D 0D F4                 ]..
        ora     ($84,x)                         ; 114E 01 84                    ..
        asl     $0214                           ; 1150 0E 14 02                 ...
        .byte   $8F                             ; 1153 8F                       .
        asl     $021C                           ; 1154 0E 1C 02                 ...
        .byte   $9B                             ; 1157 9B                       .
        asl     $023A                           ; 1158 0E 3A 02                 .:.
        ldx     $0E                             ; 115B A6 0E                    ..
        cli                                     ; 115D 58                       X
        .byte   $02                             ; 115E 02                       .
        sty     $0E                             ; 115F 84 0E                    ..
        ror     $02,x                           ; 1161 76 02                    v.
        sta     $0E,x                           ; 1163 95 0E                    ..
        .byte   $80                             ; 1165 80                       .
        .byte   $02                             ; 1166 02                       .
        .byte   $9B                             ; 1167 9B                       .
        asl     $02BC                           ; 1168 0E BC 02                 ...
        ldx     $0E                             ; 116B A6 0E                    ..
        ldy     $AC02,x                         ; 116D BC 02 AC                 ...
        asl     $0384                           ; 1170 0E 84 03                 ...
        .byte   $63                             ; 1173 63                       c
        ora     $03E8                           ; 1174 0D E8 03                 ...
        .byte   $B2                             ; 1177 B2                       .
        asl     $0618                           ; 1178 0E 18 06                 ...
        .byte   $80                             ; 117B 80                       .
        .byte   $0F                             ; 117C 0F                       .
        brk                                     ; 117D 00                       .
        brk                                     ; 117E 00                       .
L117F:  ora     ($02,x)                         ; 117F 01 02                    ..
        sta     ($82,x)                         ; 1181 81 82                    ..
        .byte   $01                             ; 1183 01                       .
L1184:  .byte   $02                             ; 1184 02                       .
        brk                                     ; 1185 00                       .
        brk                                     ; 1186 00                       .
L1187:  .byte   $02                             ; 1187 02                       .
        .byte   $02                             ; 1188 02                       .
        ora     ($01,x)                         ; 1189 01 01                    ..
        brk                                     ; 118B 00                       .
        brk                                     ; 118C 00                       .
        brk                                     ; 118D 00                       .
        brk                                     ; 118E 00                       .
        php                                     ; 118F 08                       .
        php                                     ; 1190 08                       .
        .byte   $04                             ; 1191 04                       .
        .byte   $04                             ; 1192 04                       .
        brk                                     ; 1193 00                       .
        brk                                     ; 1194 00                       .
        bpl     L11A7                           ; 1195 10 10                    ..
        brk                                     ; 1197 00                       .
        brk                                     ; 1198 00                       .
        brk                                     ; 1199 00                       .
        brk                                     ; 119A 00                       .
        brk                                     ; 119B 00                       .
        brk                                     ; 119C 00                       .
        brk                                     ; 119D 00                       .
        brk                                     ; 119E 00                       .
        brk                                     ; 119F 00                       .
        brk                                     ; 11A0 00                       .
        brk                                     ; 11A1 00                       .
        brk                                     ; 11A2 00                       .
        brk                                     ; 11A3 00                       .
        brk                                     ; 11A4 00                       .
        brk                                     ; 11A5 00                       .
        brk                                     ; 11A6 00                       .
L11A7:  .byte   $C3                             ; 11A7 C3                       .
        .byte   $CF                             ; 11A8 CF                       .
        bne     L1184                           ; 11A9 D0 D9                    ..
        .byte   $D2                             ; 11AB D2                       .
        cmp     #$C7                            ; 11AC C9 C7                    ..
        iny                                     ; 11AE C8                       .
        .byte   $D4                             ; 11AF D4                       .
        ldy     #$A8                            ; 11B0 A0 A8                    ..
        .byte   $C3                             ; 11B2 C3                       .
        lda     #$A0                            ; 11B3 A9 A0                    ..
        lda     ($B9),y                         ; 11B5 B1 B9                    ..
        clv                                     ; 11B7 B8                       .
        ldy     $A0,x                           ; 11B8 B4 A0                    ..
        cmp     ($CC,x)                         ; 11BA C1 CC                    ..
        cpy     $D2A0                           ; 11BC CC A0 D2                 ...
        cmp     #$C7                            ; 11BF C9 C7                    ..
        iny                                     ; 11C1 C8                       .
        .byte   $D4                             ; 11C2 D4                       .
        .byte   $D3                             ; 11C3 D3                       .
        ldy     #$D2                            ; 11C4 A0 D2                    ..
        cmp     $D3                             ; 11C6 C5 D3                    ..
        cmp     $D2                             ; 11C8 C5 D2                    ..
        dec     $C5,x                           ; 11CA D6 C5                    ..
        cpy     $A0                             ; 11CC C4 A0                    ..
        ldy     #$C2                            ; 11CE A0 C2                    ..
        cmp     $C1A0,y                         ; 11D0 D9 A0 C1                 ...
        .byte   $D2                             ; 11D3 D2                       .
        .byte   $D4                             ; 11D4 D4                       .
        iny                                     ; 11D5 C8                       .
        cmp     $D2,x                           ; 11D6 D5 D2                    ..
        ldy     #$C2                            ; 11D8 A0 C2                    ..
        .byte   $D2                             ; 11DA D2                       .
        cmp     #$D4                            ; 11DB C9 D4                    ..
        .byte   $D4                             ; 11DD D4                       .
        .byte   $CF                             ; 11DE CF                       .
        ldy     #$C9                            ; 11DF A0 C9                    ..
        cmp     #$A0                            ; 11E1 C9 A0                    ..
        cmp     ($CE,x)                         ; 11E3 C1 CE                    ..
        cpy     $A0                             ; 11E5 C4 A0                    ..
        .byte   $C7                             ; 11E7 C7                       .
        .byte   $D2                             ; 11E8 D2                       .
        cmp     $C7                             ; 11E9 C5 C7                    ..
        ldy     #$C8                            ; 11EB A0 C8                    ..
        cmp     ($CC,x)                         ; 11ED C1 CC                    ..
        cmp     $AE                             ; 11EF C5 AE                    ..
        ldy     #$D4                            ; 11F1 A0 D4                    ..
        iny                                     ; 11F3 C8                       .
        cmp     #$D3                            ; 11F4 C9 D3                    ..
        ldy     #$D0                            ; 11F6 A0 D0                    ..
        .byte   $D2                             ; 11F8 D2                       .
        .byte   $CF                             ; 11F9 CF                       .
        .byte   $C7                             ; 11FA C7                       .
        .byte   $D2                             ; 11FB D2                       .
        cmp     ($CD,x)                         ; 11FC C1 CD                    ..
        ldy     #$C9                            ; 11FE A0 C9                    ..
        .byte   $D3                             ; 1200 D3                       .
        ldy     #$D0                            ; 1201 A0 D0                    ..
        .byte   $D2                             ; 1203 D2                       .
        .byte   $CF                             ; 1204 CF                       .
        .byte   $D4                             ; 1205 D4                       .
        cmp     $C3                             ; 1206 C5 C3                    ..
        .byte   $D4                             ; 1208 D4                       .
        cmp     $C4                             ; 1209 C5 C4                    ..
        ldy     #$D5                            ; 120B A0 D5                    ..
        dec     $C5C4                           ; 120D CE C4 C5                 ...
        .byte   $D2                             ; 1210 D2                       .
        ldy     #$D4                            ; 1211 A0 D4                    ..
        iny                                     ; 1213 C8                       .
        cmp     $A0                             ; 1214 C5 A0                    ..
        cpy     $D7C1                           ; 1216 CC C1 D7                 ...
        .byte   $D3                             ; 1219 D3                       .
        ldy     #$CF                            ; 121A A0 CF                    ..
        dec     $A0                             ; 121C C6 A0                    ..
        ldy     #$D4                            ; 121E A0 D4                    ..
        iny                                     ; 1220 C8                       .
        cmp     $A0                             ; 1221 C5 A0                    ..
        cmp     $CE,x                           ; 1223 D5 CE                    ..
        cmp     #$D4                            ; 1225 C9 D4                    ..
        cmp     $C4                             ; 1227 C5 C4                    ..
        ldy     #$D3                            ; 1229 A0 D3                    ..
        .byte   $D4                             ; 122B D4                       .
        cmp     ($D4,x)                         ; 122C C1 D4                    ..
        cmp     $D3                             ; 122E C5 D3                    ..
        ldy     #$C1                            ; 1230 A0 C1                    ..
        dec     $A0C4                           ; 1232 CE C4 A0                 ...
        .byte   $CF                             ; 1235 CF                       .
        .byte   $D4                             ; 1236 D4                       .
        iny                                     ; 1237 C8                       .
        cmp     $D2                             ; 1238 C5 D2                    ..
        ldy     #$C3                            ; 123A A0 C3                    ..
        .byte   $CF                             ; 123C CF                       .
        cmp     $CE,x                           ; 123D D5 CE                    ..
        .byte   $D4                             ; 123F D4                       .
        .byte   $D2                             ; 1240 D2                       .
        cmp     #$C5                            ; 1241 C9 C5                    ..
        .byte   $D3                             ; 1243 D3                       .
        ldy     #$A0                            ; 1244 A0 A0                    ..
        ldy     #$C1                            ; 1246 A0 C1                    ..
        dec     $A0C4                           ; 1248 CE C4 A0                 ...
        cmp     #$CC                            ; 124B C9 CC                    ..
        cpy     $C7C5                           ; 124D CC C5 C7                 ...
        cmp     ($CC,x)                         ; 1250 C1 CC                    ..
        ldy     #$C4                            ; 1252 A0 C4                    ..
        cmp     #$D3                            ; 1254 C9 D3                    ..
        .byte   $D4                             ; 1256 D4                       .
        .byte   $D2                             ; 1257 D2                       .
        cmp     #$C2                            ; 1258 C9 C2                    ..
        cmp     $D4,x                           ; 125A D5 D4                    ..
        cmp     #$CF                            ; 125C C9 CF                    ..
        dec     $CDA0                           ; 125E CE A0 CD                 ...
        cmp     ($D9,x)                         ; 1261 C1 D9                    ..
        ldy     #$D2                            ; 1263 A0 D2                    ..
        cmp     $D3                             ; 1265 C5 D3                    ..
        cmp     $CC,x                           ; 1267 D5 CC                    ..
        .byte   $D4                             ; 1269 D4                       .
        ldy     #$C9                            ; 126A A0 C9                    ..
        dec     $A0A0                           ; 126C CE A0 A0                 ...
        .byte   $C3                             ; 126F C3                       .
        cmp     #$D6                            ; 1270 C9 D6                    ..
        cmp     #$CC                            ; 1272 C9 CC                    ..
        ldy     #$CC                            ; 1274 A0 CC                    ..
        cmp     #$C1                            ; 1276 C9 C1                    ..
        .byte   $C2                             ; 1278 C2                       .
        cpy     $D4C9                           ; 1279 CC C9 D4                 ...
        cmp     $C1A0,y                         ; 127C D9 A0 C1                 ...
        dec     $A0C4                           ; 127F CE C4 A0                 ...
        .byte   $C3                             ; 1282 C3                       .
        .byte   $D2                             ; 1283 D2                       .
        cmp     #$CD                            ; 1284 C9 CD                    ..
        cmp     #$CE                            ; 1286 C9 CE                    ..
        cmp     ($CC,x)                         ; 1288 C1 CC                    ..
        ldy     #$D0                            ; 128A A0 D0                    ..
        .byte   $D2                             ; 128C D2                       .
        .byte   $CF                             ; 128D CF                       .
        .byte   $D3                             ; 128E D3                       .
        cmp     $C3                             ; 128F C5 C3                    ..
        cmp     $D4,x                           ; 1291 D5 D4                    ..
        cmp     #$CF                            ; 1293 C9 CF                    ..
        dec     a:$AE                           ; 1295 CE AE 00                 ...
L1298:  brk                                     ; 1298 00                       .
L1299:  brk                                     ; 1299 00                       .
L129A:  brk                                     ; 129A 00                       .
L129B:  brk                                     ; 129B 00                       .
L129C:  brk                                     ; 129C 00                       .
L129D:  brk                                     ; 129D 00                       .
L129E:  brk                                     ; 129E 00                       .
L129F:  brk                                     ; 129F 00                       .
L12A0:  brk                                     ; 12A0 00                       .
L12A1:  brk                                     ; 12A1 00                       .
L12A2:  brk                                     ; 12A2 00                       .
L12A3:  brk                                     ; 12A3 00                       .
L12A4:  brk                                     ; 12A4 00                       .
L12A5:  brk                                     ; 12A5 00                       .
L12A6:  brk                                     ; 12A6 00                       .
        brk                                     ; 12A7 00                       .
        brk                                     ; 12A8 00                       .
L12A9:  brk                                     ; 12A9 00                       .
L12AA:  brk                                     ; 12AA 00                       .
L12AB:  brk                                     ; 12AB 00                       .
        brk                                     ; 12AC 00                       .
        brk                                     ; 12AD 00                       .
        brk                                     ; 12AE 00                       .
L12AF:  brk                                     ; 12AF 00                       .
L12B0:  brk                                     ; 12B0 00                       .
L12B1:  brk                                     ; 12B1 00                       .
L12B2:  brk                                     ; 12B2 00                       .
L12B3:  brk                                     ; 12B3 00                       .
L12B4:  brk                                     ; 12B4 00                       .
L12B5:  brk                                     ; 12B5 00                       .
L12B6:  brk                                     ; 12B6 00                       .
L12B7:  brk                                     ; 12B7 00                       .
        brk                                     ; 12B8 00                       .
        brk                                     ; 12B9 00                       .
        brk                                     ; 12BA 00                       .
L12BB:  brk                                     ; 12BB 00                       .
L12BC:  brk                                     ; 12BC 00                       .
L12BD:  brk                                     ; 12BD 00                       .
L12BE:  brk                                     ; 12BE 00                       .
L12BF:  brk                                     ; 12BF 00                       .
L12C0:  brk                                     ; 12C0 00                       .
L12C1:  brk                                     ; 12C1 00                       .
        brk                                     ; 12C2 00                       .
        brk                                     ; 12C3 00                       .
        brk                                     ; 12C4 00                       .
        brk                                     ; 12C5 00                       .
        rol     a                               ; 12C6 2A                       *
        sta     $4F00,x                         ; 12C7 9D 00 4F                 ..O
        brk                                     ; 12CA 00                       .
        brk                                     ; 12CB 00                       .
        rol     a                               ; 12CC 2A                       *
        sta     $0100,x                         ; 12CD 9D 00 01                 ...
        ror     a                               ; 12D0 6A                       j
        .byte   $C2                             ; 12D1 C2                       .
        brk                                     ; 12D2 00                       .
        brk                                     ; 12D3 00                       .
        brk                                     ; 12D4 00                       .
        brk                                     ; 12D5 00                       .
        brk                                     ; 12D6 00                       .
        brk                                     ; 12D7 00                       .
        brk                                     ; 12D8 00                       .
        brk                                     ; 12D9 00                       .
        brk                                     ; 12DA 00                       .
        brk                                     ; 12DB 00                       .
        brk                                     ; 12DC 00                       .
        brk                                     ; 12DD 00                       .
        brk                                     ; 12DE 00                       .
        brk                                     ; 12DF 00                       .
        brk                                     ; 12E0 00                       .
L12E1:  brk                                     ; 12E1 00                       .
        brk                                     ; 12E2 00                       .
        brk                                     ; 12E3 00                       .
        brk                                     ; 12E4 00                       .
        brk                                     ; 12E5 00                       .
        brk                                     ; 12E6 00                       .
        brk                                     ; 12E7 00                       .
        brk                                     ; 12E8 00                       .
        brk                                     ; 12E9 00                       .
        brk                                     ; 12EA 00                       .
        brk                                     ; 12EB 00                       .
        brk                                     ; 12EC 00                       .
        brk                                     ; 12ED 00                       .
        brk                                     ; 12EE 00                       .
        brk                                     ; 12EF 00                       .
        brk                                     ; 12F0 00                       .
        brk                                     ; 12F1 00                       .
        .byte   $FF                             ; 12F2 FF                       .
        .byte   $FF                             ; 12F3 FF                       .
        .byte   $FF                             ; 12F4 FF                       .
        .byte   $FF                             ; 12F5 FF                       .
        .byte   $FF                             ; 12F6 FF                       .
        .byte   $FF                             ; 12F7 FF                       .
        .byte   $FF                             ; 12F8 FF                       .
        .byte   $FF                             ; 12F9 FF                       .
        .byte   $FF                             ; 12FA FF                       .
        .byte   $FF                             ; 12FB FF                       .
        .byte   $FF                             ; 12FC FF                       .
        .byte   $FF                             ; 12FD FF                       .
        .byte   $FF                             ; 12FE FF                       .
        .byte   $FF                             ; 12FF FF                       .
        .byte   $FF                             ; 1300 FF                       .
L1301:  .byte   $FF                             ; 1301 FF                       .
        .byte   $FF                             ; 1302 FF                       .
        .byte   $FF                             ; 1303 FF                       .
        .byte   $FF                             ; 1304 FF                       .
        .byte   $FF                             ; 1305 FF                       .
        .byte   $FF                             ; 1306 FF                       .
        .byte   $FF                             ; 1307 FF                       .
        .byte   $FF                             ; 1308 FF                       .
        .byte   $FF                             ; 1309 FF                       .
        .byte   $FF                             ; 130A FF                       .
        .byte   $FF                             ; 130B FF                       .
        .byte   $FF                             ; 130C FF                       .
        .byte   $FF                             ; 130D FF                       .
        .byte   $FF                             ; 130E FF                       .
        .byte   $FF                             ; 130F FF                       .
        .byte   $FF                             ; 1310 FF                       .
        .byte   $FF                             ; 1311 FF                       .
        ldy     $6296                           ; 1312 AC 96 62                 ..b
        and     $3C                             ; 1315 25 3C                    %<
        sty     $9E27                           ; 1317 8C 27 9E                 .'.
        txa                                     ; 131A 8A                       .
        sta     $AA                             ; 131B 85 AA                    ..
        .byte   $82                             ; 131D 82                       .
        .byte   $54                             ; 131E 54                       T
        .byte   $8C                             ; 131F 8C                       .
        .byte   $0E                             ; 1320 0E                       .
L1321:  rol     $5F,x                           ; 1321 36 5F                    6_
        pla                                     ; 1323 68                       h
        clc                                     ; 1324 18                       .
        lsr     $9560,x                         ; 1325 5E 60 95                 ^`.
        ora     $02B0,y                         ; 1328 19 B0 02                 ...
        bpl     L138B                           ; 132B 10 5E                    .^
        rol     L089C                           ; 132D 2E 9C 08                 ...
        .byte   $0B                             ; 1330 0B                       .
        ora     ($00,x)                         ; 1331 01 00                    ..
        brk                                     ; 1333 00                       .
        brk                                     ; 1334 00                       .
        brk                                     ; 1335 00                       .
        brk                                     ; 1336 00                       .
        brk                                     ; 1337 00                       .
        brk                                     ; 1338 00                       .
        brk                                     ; 1339 00                       .
        brk                                     ; 133A 00                       .
        brk                                     ; 133B 00                       .
        brk                                     ; 133C 00                       .
        brk                                     ; 133D 00                       .
        brk                                     ; 133E 00                       .
        brk                                     ; 133F 00                       .
        brk                                     ; 1340 00                       .
L1341:  brk                                     ; 1341 00                       .
        brk                                     ; 1342 00                       .
        brk                                     ; 1343 00                       .
        brk                                     ; 1344 00                       .
        brk                                     ; 1345 00                       .
        brk                                     ; 1346 00                       .
        brk                                     ; 1347 00                       .
        brk                                     ; 1348 00                       .
        brk                                     ; 1349 00                       .
        brk                                     ; 134A 00                       .
        brk                                     ; 134B 00                       .
        brk                                     ; 134C 00                       .
        brk                                     ; 134D 00                       .
        brk                                     ; 134E 00                       .
        brk                                     ; 134F 00                       .
        brk                                     ; 1350 00                       .
        brk                                     ; 1351 00                       .
        brk                                     ; 1352 00                       .
        brk                                     ; 1353 00                       .
        brk                                     ; 1354 00                       .
        brk                                     ; 1355 00                       .
        brk                                     ; 1356 00                       .
        brk                                     ; 1357 00                       .
        brk                                     ; 1358 00                       .
        brk                                     ; 1359 00                       .
        brk                                     ; 135A 00                       .
        brk                                     ; 135B 00                       .
        brk                                     ; 135C 00                       .
        brk                                     ; 135D 00                       .
        brk                                     ; 135E 00                       .
        brk                                     ; 135F 00                       .
        brk                                     ; 1360 00                       .
L1361:  brk                                     ; 1361 00                       .
        brk                                     ; 1362 00                       .
        brk                                     ; 1363 00                       .
        brk                                     ; 1364 00                       .
        brk                                     ; 1365 00                       .
        brk                                     ; 1366 00                       .
        brk                                     ; 1367 00                       .
        brk                                     ; 1368 00                       .
        brk                                     ; 1369 00                       .
        brk                                     ; 136A 00                       .
        brk                                     ; 136B 00                       .
        brk                                     ; 136C 00                       .
        brk                                     ; 136D 00                       .
        brk                                     ; 136E 00                       .
        brk                                     ; 136F 00                       .
        brk                                     ; 1370 00                       .
        brk                                     ; 1371 00                       .
        ldy     $6296                           ; 1372 AC 96 62                 ..b
        and     $3C                             ; 1375 25 3C                    %<
        sty     $9E27                           ; 1377 8C 27 9E                 .'.
        txa                                     ; 137A 8A                       .
        sta     $AA                             ; 137B 85 AA                    ..
        .byte   $82                             ; 137D 82                       .
        .byte   $54                             ; 137E 54                       T
        .byte   $8C                             ; 137F 8C                       .
        .byte   $0E                             ; 1380 0E                       .
L1381:  rol     $5F,x                           ; 1381 36 5F                    6_
        pla                                     ; 1383 68                       h
        clc                                     ; 1384 18                       .
        lsr     $9560,x                         ; 1385 5E 60 95                 ^`.
        ora     $02B0,y                         ; 1388 19 B0 02                 ...
L138B:  bpl     L13EB                           ; 138B 10 5E                    .^
        rol     L089C                           ; 138D 2E 9C 08                 ...
        .byte   $0B                             ; 1390 0B                       .
        ora     ($00,x)                         ; 1391 01 00                    ..
        brk                                     ; 1393 00                       .
        brk                                     ; 1394 00                       .
        brk                                     ; 1395 00                       .
        brk                                     ; 1396 00                       .
        brk                                     ; 1397 00                       .
        brk                                     ; 1398 00                       .
        brk                                     ; 1399 00                       .
        brk                                     ; 139A 00                       .
        brk                                     ; 139B 00                       .
        brk                                     ; 139C 00                       .
        brk                                     ; 139D 00                       .
        brk                                     ; 139E 00                       .
        brk                                     ; 139F 00                       .
        brk                                     ; 13A0 00                       .
L13A1:  brk                                     ; 13A1 00                       .
        brk                                     ; 13A2 00                       .
        brk                                     ; 13A3 00                       .
        brk                                     ; 13A4 00                       .
        brk                                     ; 13A5 00                       .
        brk                                     ; 13A6 00                       .
        brk                                     ; 13A7 00                       .
        brk                                     ; 13A8 00                       .
        brk                                     ; 13A9 00                       .
        brk                                     ; 13AA 00                       .
        brk                                     ; 13AB 00                       .
        brk                                     ; 13AC 00                       .
        brk                                     ; 13AD 00                       .
        brk                                     ; 13AE 00                       .
        brk                                     ; 13AF 00                       .
        brk                                     ; 13B0 00                       .
        brk                                     ; 13B1 00                       .
        brk                                     ; 13B2 00                       .
        brk                                     ; 13B3 00                       .
        brk                                     ; 13B4 00                       .
        brk                                     ; 13B5 00                       .
        brk                                     ; 13B6 00                       .
        brk                                     ; 13B7 00                       .
        brk                                     ; 13B8 00                       .
        brk                                     ; 13B9 00                       .
        brk                                     ; 13BA 00                       .
        brk                                     ; 13BB 00                       .
        brk                                     ; 13BC 00                       .
        brk                                     ; 13BD 00                       .
        brk                                     ; 13BE 00                       .
        brk                                     ; 13BF 00                       .
        brk                                     ; 13C0 00                       .
L13C1:  brk                                     ; 13C1 00                       .
        brk                                     ; 13C2 00                       .
        brk                                     ; 13C3 00                       .
        brk                                     ; 13C4 00                       .
        brk                                     ; 13C5 00                       .
        brk                                     ; 13C6 00                       .
        brk                                     ; 13C7 00                       .
        brk                                     ; 13C8 00                       .
        brk                                     ; 13C9 00                       .
        brk                                     ; 13CA 00                       .
        brk                                     ; 13CB 00                       .
        brk                                     ; 13CC 00                       .
        brk                                     ; 13CD 00                       .
        brk                                     ; 13CE 00                       .
        brk                                     ; 13CF 00                       .
        brk                                     ; 13D0 00                       .
        brk                                     ; 13D1 00                       .
        ldy     $6296                           ; 13D2 AC 96 62                 ..b
        and     $3C                             ; 13D5 25 3C                    %<
        sty     a:$00                           ; 13D7 8C 00 00                 ...
        brk                                     ; 13DA 00                       .
        brk                                     ; 13DB 00                       .
        brk                                     ; 13DC 00                       .
        brk                                     ; 13DD 00                       .
        .byte   $54                             ; 13DE 54                       T
        .byte   $8C                             ; 13DF 8C                       .
        .byte   $0E                             ; 13E0 0E                       .
L13E1:  brk                                     ; 13E1 00                       .
L13E2:  brk                                     ; 13E2 00                       .
L13E3:  brk                                     ; 13E3 00                       .
L13E4:  brk                                     ; 13E4 00                       .
L13E5:  brk                                     ; 13E5 00                       .
L13E6:  brk                                     ; 13E6 00                       .
L13E7:  brk                                     ; 13E7 00                       .
        brk                                     ; 13E8 00                       .
        brk                                     ; 13E9 00                       .
        brk                                     ; 13EA 00                       .
L13EB:  brk                                     ; 13EB 00                       .
        lsr     $9C2E,x                         ; 13EC 5E 2E 9C                 ^..
        php                                     ; 13EF 08                       .
        .byte   $0B                             ; 13F0 0B                       .
        ora     ($92,x)                         ; 13F1 01 92                    ..
        ora     #$00                            ; 13F3 09 00                    ..
        ora     ($FF),y                         ; 13F5 11 FF                    ..
L13F7:  .byte   $C2                             ; 13F7 C2                       .
        brk                                     ; 13F8 00                       .
        brk                                     ; 13F9 00                       .
        brk                                     ; 13FA 00                       .
        brk                                     ; 13FB 00                       .
        brk                                     ; 13FC 00                       .
        brk                                     ; 13FD 00                       .
        brk                                     ; 13FE 00                       .
        brk                                     ; 13FF 00                       .
        brk                                     ; 1400 00                       .
        brk                                     ; 1401 00                       .
        brk                                     ; 1402 00                       .
        brk                                     ; 1403 00                       .
        brk                                     ; 1404 00                       .
        brk                                     ; 1405 00                       .
        brk                                     ; 1406 00                       .
L1407:  brk                                     ; 1407 00                       .
        eor     ($2C),y                         ; 1408 51 2C                    Q,
        jsr     LAB2E                           ; 140A 20 2E AB                  ..
        adc     $2F38                           ; 140D 6D 38 2F                 m8/
        php                                     ; 1410 08                       .
        brk                                     ; 1411 00                       .
        .byte   $14                             ; 1412 14                       .
        .byte   $FF                             ; 1413 FF                       .
        .byte   $C2                             ; 1414 C2                       .
        brk                                     ; 1415 00                       .
        brk                                     ; 1416 00                       .
L1417:  .byte   $37                             ; 1417 37                       7
        brk                                     ; 1418 00                       .
        brk                                     ; 1419 00                       .
        brk                                     ; 141A 00                       .
        brk                                     ; 141B 00                       .
        brk                                     ; 141C 00                       .
        brk                                     ; 141D 00                       .
        brk                                     ; 141E 00                       .
        .byte   $93                             ; 141F 93                       .
        brk                                     ; 1420 00                       .
        brk                                     ; 1421 00                       .
        brk                                     ; 1422 00                       .
        brk                                     ; 1423 00                       .
        brk                                     ; 1424 00                       .
        ora     $2C,x                           ; 1425 15 2C                    .,
L1427:  .byte   $93                             ; 1427 93                       .
        cpy     #$37                            ; 1428 C0 37                    .7
        .byte   $03                             ; 142A 03                       .
        beq     L1430                           ; 142B F0 03                    ..
        jsr     LFF7B                           ; 142D 20 7B FF                  {.
L1430:  brk                                     ; 1430 00                       .
        brk                                     ; 1431 00                       .
        brk                                     ; 1432 00                       .
        brk                                     ; 1433 00                       .
        brk                                     ; 1434 00                       .
        brk                                     ; 1435 00                       .
        brk                                     ; 1436 00                       .
L1437:  .byte   $FF                             ; 1437 FF                       .
        brk                                     ; 1438 00                       .
        brk                                     ; 1439 00                       .
        brk                                     ; 143A 00                       .
        brk                                     ; 143B 00                       .
        brk                                     ; 143C 00                       .
        brk                                     ; 143D 00                       .
        brk                                     ; 143E 00                       .
        brk                                     ; 143F 00                       .
        brk                                     ; 1440 00                       .
        brk                                     ; 1441 00                       .
        brk                                     ; 1442 00                       .
        brk                                     ; 1443 00                       .
        brk                                     ; 1444 00                       .
        brk                                     ; 1445 00                       .
        brk                                     ; 1446 00                       .
L1447:  brk                                     ; 1447 00                       .
        sty     $FF                             ; 1448 84 FF                    ..
        brk                                     ; 144A 00                       .
        brk                                     ; 144B 00                       .
        brk                                     ; 144C 00                       .
        brk                                     ; 144D 00                       .
        brk                                     ; 144E 00                       .
        .byte   $2F                             ; 144F 2F                       /
        brk                                     ; 1450 00                       .
        brk                                     ; 1451 00                       .
        brk                                     ; 1452 00                       .
        brk                                     ; 1453 00                       .
        .byte   $FF                             ; 1454 FF                       .
        brk                                     ; 1455 00                       .
        brk                                     ; 1456 00                       .
L1457:  .byte   $37                             ; 1457 37                       7
        brk                                     ; 1458 00                       .
        brk                                     ; 1459 00                       .
        brk                                     ; 145A 00                       .
        brk                                     ; 145B 00                       .
        brk                                     ; 145C 00                       .
        brk                                     ; 145D 00                       .
        brk                                     ; 145E 00                       .
        .byte   $93                             ; 145F 93                       .
        brk                                     ; 1460 00                       .
        brk                                     ; 1461 00                       .
        brk                                     ; 1462 00                       .
        brk                                     ; 1463 00                       .
        brk                                     ; 1464 00                       .
        .byte   $F4                             ; 1465 F4                       .
        rts                                     ; 1466 60                       `

; ----------------------------------------------------------------------------
L1467:  .byte   $93                             ; 1467 93                       .
        .byte   $CF                             ; 1468 CF                       .
        .byte   $37                             ; 1469 37                       7
        .byte   $D4                             ; 146A D4                       .
        cmp     #$CE                            ; 146B C9 CE                    ..
        .byte   $C7                             ; 146D C7                       .
        ldy     #$0D                            ; 146E A0 0D                    ..
        brk                                     ; 1470 00                       .
        brk                                     ; 1471 00                       .
        brk                                     ; 1472 00                       .
        brk                                     ; 1473 00                       .
        brk                                     ; 1474 00                       .
        brk                                     ; 1475 00                       .
        brk                                     ; 1476 00                       .
L1477:  ora     a:$00                           ; 1477 0D 00 00                 ...
        brk                                     ; 147A 00                       .
        brk                                     ; 147B 00                       .
        brk                                     ; 147C 00                       .
        brk                                     ; 147D 00                       .
        brk                                     ; 147E 00                       .
        brk                                     ; 147F 00                       .
        brk                                     ; 1480 00                       .
        brk                                     ; 1481 00                       .
        brk                                     ; 1482 00                       .
        brk                                     ; 1483 00                       .
        brk                                     ; 1484 00                       .
        brk                                     ; 1485 00                       .
        brk                                     ; 1486 00                       .
L1487:  brk                                     ; 1487 00                       .
        cmp     ($0D,x)                         ; 1488 C1 0D                    ..
        brk                                     ; 148A 00                       .
        brk                                     ; 148B 00                       .
        brk                                     ; 148C 00                       .
        brk                                     ; 148D 00                       .
        brk                                     ; 148E 00                       .
        brk                                     ; 148F 00                       .
        brk                                     ; 1490 00                       .
        brk                                     ; 1491 00                       .
        brk                                     ; 1492 00                       .
        brk                                     ; 1493 00                       .
        brk                                     ; 1494 00                       .
        brk                                     ; 1495 00                       .
        brk                                     ; 1496 00                       .
L1497:  brk                                     ; 1497 00                       .
        brk                                     ; 1498 00                       .
        brk                                     ; 1499 00                       .
        brk                                     ; 149A 00                       .
        brk                                     ; 149B 00                       .
        brk                                     ; 149C 00                       .
        brk                                     ; 149D 00                       .
        brk                                     ; 149E 00                       .
        brk                                     ; 149F 00                       .
        brk                                     ; 14A0 00                       .
        brk                                     ; 14A1 00                       .
        brk                                     ; 14A2 00                       .
        brk                                     ; 14A3 00                       .
        brk                                     ; 14A4 00                       .
        brk                                     ; 14A5 00                       .
        brk                                     ; 14A6 00                       .
L14A7:  brk                                     ; 14A7 00                       .
L14A8:  brk                                     ; 14A8 00                       .
L14A9:  brk                                     ; 14A9 00                       .
L14AA:  brk                                     ; 14AA 00                       .
L14AB:  brk                                     ; 14AB 00                       .
L14AC:  brk                                     ; 14AC 00                       .
L14AD:  brk                                     ; 14AD 00                       .
L14AE:  brk                                     ; 14AE 00                       .
L14AF:  brk                                     ; 14AF 00                       .
L14B0:  brk                                     ; 14B0 00                       .
L14B1:  brk                                     ; 14B1 00                       .
L14B2:  brk                                     ; 14B2 00                       .
        brk                                     ; 14B3 00                       .
        brk                                     ; 14B4 00                       .
        brk                                     ; 14B5 00                       .
        brk                                     ; 14B6 00                       .
        ora     a:$FF                           ; 14B7 0D FF 00                 ...
        brk                                     ; 14BA 00                       .
        .byte   $14                             ; 14BB 14                       .
        .byte   $02                             ; 14BC 02                       .
        brk                                     ; 14BD 00                       .
        .byte   $14                             ; 14BE 14                       .
        .byte   $FF                             ; 14BF FF                       .
        ora     ($0C,x)                         ; 14C0 01 0C                    ..
        ora     ($00,x)                         ; 14C2 01 00                    ..
        .byte   $93                             ; 14C4 93                       .
        cmp     $D2                             ; 14C5 C5 D2                    ..
        brk                                     ; 14C7 00                       .
        cpy     $0D                             ; 14C8 C4 0D                    ..
        .byte   $FF                             ; 14CA FF                       .
        brk                                     ; 14CB 00                       .
        brk                                     ; 14CC 00                       .
        .byte   $14                             ; 14CD 14                       .
        .byte   $02                             ; 14CE 02                       .
        brk                                     ; 14CF 00                       .
        .byte   $14                             ; 14D0 14                       .
        .byte   $FF                             ; 14D1 FF                       .
        ora     ($0C,x)                         ; 14D2 01 0C                    ..
        ora     a:$FF                           ; 14D4 0D FF 00                 ...
        brk                                     ; 14D7 00                       .
        .byte   $14                             ; 14D8 14                       .
        .byte   $02                             ; 14D9 02                       .
        brk                                     ; 14DA 00                       .
        .byte   $14                             ; 14DB 14                       .
        .byte   $FF                             ; 14DC FF                       .
        ora     ($0C,x)                         ; 14DD 01 0C                    ..
        ora     ($00,x)                         ; 14DF 01 00                    ..
L14E1:  dex                                     ; 14E1 CA                       .
        bmi     L14F2                           ; 14E2 30 0E                    0.
L14E4:  lda     ($01),y                         ; 14E4 B1 01                    ..
        inc     $01                             ; 14E6 E6 01                    ..
        bne     L14EC                           ; 14E8 D0 02                    ..
        inc     $02                             ; 14EA E6 02                    ..
L14EC:  cmp     #$00                            ; 14EC C9 00                    ..
        bne     L14E4                           ; 14EE D0 F4                    ..
        beq     L14E1                           ; 14F0 F0 EF                    ..
L14F2:  lda     ($01),y                         ; 14F2 B1 01                    ..
        beq     L1501                           ; 14F4 F0 0B                    ..
        jsr     LFDF0                           ; 14F6 20 F0 FD                  ..
        inc     $01                             ; 14F9 E6 01                    ..
        bne     L14F2                           ; 14FB D0 F5                    ..
        inc     $02                             ; 14FD E6 02                    ..
        bne     L1501                           ; 14FF D0 00                    ..
L1501:  rol     $3B03,x                         ; 1501 3E 03 3B                 >.;
        .byte   $3B                             ; 1504 3B                       ;
        .byte   $33                             ; 1505 33                       3
        .byte   $33                             ; 1506 33                       3
        asl     $3300,x                         ; 1507 1E 00 33                 ..3
        .byte   $33                             ; 150A 33                       3
        .byte   $33                             ; 150B 33                       3
        .byte   $3F                             ; 150C 3F                       ?
        .byte   $33                             ; 150D 33                       3
        .byte   $33                             ; 150E 33                       3
        asl     L1F00,x                         ; 150F 1E 00 1F                 ...
        .byte   $33                             ; 1512 33                       3
        .byte   $33                             ; 1513 33                       3
        .byte   $1F                             ; 1514 1F                       .
        .byte   $33                             ; 1515 33                       3
        .byte   $33                             ; 1516 33                       3
        .byte   $1F                             ; 1517 1F                       .
        brk                                     ; 1518 00                       .
        asl     $0333,x                         ; 1519 1E 33 03                 .3.
        .byte   $03                             ; 151C 03                       .
        .byte   $03                             ; 151D 03                       .
        .byte   $33                             ; 151E 33                       3
        asl     L1F00,x                         ; 151F 1E 00 1F                 ...
        .byte   $33                             ; 1522 33                       3
        .byte   $33                             ; 1523 33                       3
        .byte   $33                             ; 1524 33                       3
        .byte   $33                             ; 1525 33                       3
        .byte   $33                             ; 1526 33                       3
        .byte   $1F                             ; 1527 1F                       .
        brk                                     ; 1528 00                       .
        .byte   $3F                             ; 1529 3F                       ?
        .byte   $03                             ; 152A 03                       .
        .byte   $03                             ; 152B 03                       .
        .byte   $1F                             ; 152C 1F                       .
        .byte   $03                             ; 152D 03                       .
        .byte   $03                             ; 152E 03                       .
        .byte   $3F                             ; 152F 3F                       ?
        brk                                     ; 1530 00                       .
        .byte   $03                             ; 1531 03                       .
        .byte   $03                             ; 1532 03                       .
        .byte   $03                             ; 1533 03                       .
        .byte   $0F                             ; 1534 0F                       .
        .byte   $03                             ; 1535 03                       .
        .byte   $03                             ; 1536 03                       .
        .byte   $3F                             ; 1537 3F                       ?
L1538:  brk                                     ; 1538 00                       .
        rol     $3333,x                         ; 1539 3E 33 33                 >33
        .byte   $3B                             ; 153C 3B                       ;
        .byte   $03                             ; 153D 03                       .
        .byte   $03                             ; 153E 03                       .
        rol     $3300,x                         ; 153F 3E 00 33                 >.3
L1542:  .byte   $33                             ; 1542 33                       3
        .byte   $33                             ; 1543 33                       3
        .byte   $3F                             ; 1544 3F                       ?
        .byte   $33                             ; 1545 33                       3
        .byte   $33                             ; 1546 33                       3
        .byte   $33                             ; 1547 33                       3
        brk                                     ; 1548 00                       .
        asl     L0C0C,x                         ; 1549 1E 0C 0C                 ...
        .byte   $0C                             ; 154C 0C                       .
        .byte   $0C                             ; 154D 0C                       .
        .byte   $0C                             ; 154E 0C                       .
        asl     L1E00,x                         ; 154F 1E 00 1E                 ...
        .byte   $33                             ; 1552 33                       3
        bmi     L1585                           ; 1553 30 30                    00
        bmi     L1587                           ; 1555 30 30                    00
        bmi     L1559                           ; 1557 30 00                    0.
L1559:  .byte   $33                             ; 1559 33                       3
        .byte   $33                             ; 155A 33                       3
        .byte   $1B                             ; 155B 1B                       .
        .byte   $0F                             ; 155C 0F                       .
        .byte   $1B                             ; 155D 1B                       .
        .byte   $33                             ; 155E 33                       3
        .byte   $33                             ; 155F 33                       3
        brk                                     ; 1560 00                       .
        .byte   $3F                             ; 1561 3F                       ?
        .byte   $03                             ; 1562 03                       .
        .byte   $03                             ; 1563 03                       .
        .byte   $03                             ; 1564 03                       .
        .byte   $03                             ; 1565 03                       .
        .byte   $03                             ; 1566 03                       .
        .byte   $03                             ; 1567 03                       .
        brk                                     ; 1568 00                       .
        .byte   $33                             ; 1569 33                       3
        .byte   $33                             ; 156A 33                       3
        .byte   $33                             ; 156B 33                       3
        .byte   $3F                             ; 156C 3F                       ?
        .byte   $3F                             ; 156D 3F                       ?
        .byte   $3F                             ; 156E 3F                       ?
        .byte   $33                             ; 156F 33                       3
        brk                                     ; 1570 00                       .
        .byte   $33                             ; 1571 33                       3
        .byte   $3B                             ; 1572 3B                       ;
        .byte   $3B                             ; 1573 3B                       ;
        .byte   $3F                             ; 1574 3F                       ?
        .byte   $37                             ; 1575 37                       7
        .byte   $37                             ; 1576 37                       7
        .byte   $33                             ; 1577 33                       3
        brk                                     ; 1578 00                       .
        asl     $3333,x                         ; 1579 1E 33 33                 .33
        .byte   $33                             ; 157C 33                       3
        .byte   $33                             ; 157D 33                       3
        .byte   $33                             ; 157E 33                       3
        asl     $0300,x                         ; 157F 1E 00 03                 ...
        .byte   $03                             ; 1582 03                       .
        .byte   $03                             ; 1583 03                       .
        .byte   $1F                             ; 1584 1F                       .
L1585:  .byte   $33                             ; 1585 33                       3
        .byte   $33                             ; 1586 33                       3
L1587:  .byte   $1F                             ; 1587 1F                       .
        brk                                     ; 1588 00                       .
        rol     $1B,x                           ; 1589 36 1B                    6.
        .byte   $33                             ; 158B 33                       3
        .byte   $33                             ; 158C 33                       3
        .byte   $33                             ; 158D 33                       3
        .byte   $33                             ; 158E 33                       3
        asl     $3300,x                         ; 158F 1E 00 33                 ..3
        .byte   $33                             ; 1592 33                       3
        .byte   $1B                             ; 1593 1B                       .
        .byte   $1F                             ; 1594 1F                       .
        .byte   $33                             ; 1595 33                       3
        .byte   $33                             ; 1596 33                       3
        .byte   $1F                             ; 1597 1F                       .
        brk                                     ; 1598 00                       .
        .byte   $1F                             ; 1599 1F                       .
        bmi     L15CC                           ; 159A 30 30                    00
        asl     $0303,x                         ; 159C 1E 03 03                 ...
        rol     L0C00,x                         ; 159F 3E 00 0C                 >..
        .byte   $0C                             ; 15A2 0C                       .
        .byte   $0C                             ; 15A3 0C                       .
        .byte   $0C                             ; 15A4 0C                       .
        .byte   $0C                             ; 15A5 0C                       .
        .byte   $0C                             ; 15A6 0C                       .
        .byte   $3F                             ; 15A7 3F                       ?
        brk                                     ; 15A8 00                       .
        asl     $3333,x                         ; 15A9 1E 33 33                 .33
        .byte   $33                             ; 15AC 33                       3
        .byte   $33                             ; 15AD 33                       3
        .byte   $33                             ; 15AE 33                       3
        .byte   $33                             ; 15AF 33                       3
        brk                                     ; 15B0 00                       .
        .byte   $0C                             ; 15B1 0C                       .
        asl     $3333,x                         ; 15B2 1E 33 33                 .33
        .byte   $33                             ; 15B5 33                       3
        .byte   $33                             ; 15B6 33                       3
        .byte   $33                             ; 15B7 33                       3
        brk                                     ; 15B8 00                       .
        asl     $3F3F,x                         ; 15B9 1E 3F 3F                 .??
        .byte   $33                             ; 15BC 33                       3
        .byte   $33                             ; 15BD 33                       3
        .byte   $33                             ; 15BE 33                       3
        .byte   $33                             ; 15BF 33                       3
        brk                                     ; 15C0 00                       .
        .byte   $33                             ; 15C1 33                       3
        .byte   $33                             ; 15C2 33                       3
        asl     L1E0C,x                         ; 15C3 1E 0C 1E                 ...
        .byte   $33                             ; 15C6 33                       3
        .byte   $33                             ; 15C7 33                       3
        brk                                     ; 15C8 00                       .
        .byte   $0C                             ; 15C9 0C                       .
        .byte   $0C                             ; 15CA 0C                       .
        .byte   $0C                             ; 15CB 0C                       .
L15CC:  asl     $3333,x                         ; 15CC 1E 33 33                 .33
        .byte   $33                             ; 15CF 33                       3
        brk                                     ; 15D0 00                       .
        .byte   $3F                             ; 15D1 3F                       ?
        .byte   $03                             ; 15D2 03                       .
        asl     $0C                             ; 15D3 06 0C                    ..
        clc                                     ; 15D5 18                       .
        bmi     L1617                           ; 15D6 30 3F                    0?
        brk                                     ; 15D8 00                       .
        .byte   $3F                             ; 15D9 3F                       ?
        .byte   $03                             ; 15DA 03                       .
        .byte   $03                             ; 15DB 03                       .
        .byte   $03                             ; 15DC 03                       .
        .byte   $03                             ; 15DD 03                       .
        .byte   $03                             ; 15DE 03                       .
        .byte   $3F                             ; 15DF 3F                       ?
        brk                                     ; 15E0 00                       .
        bmi     L15FB                           ; 15E1 30 18                    0.
        clc                                     ; 15E3 18                       .
        .byte   $0C                             ; 15E4 0C                       .
        asl     $06                             ; 15E5 06 06                    ..
        .byte   $03                             ; 15E7 03                       .
        brk                                     ; 15E8 00                       .
        .byte   $3F                             ; 15E9 3F                       ?
        bmi     L161C                           ; 15EA 30 30                    00
        bmi     L161E                           ; 15EC 30 30                    00
        bmi     L162F                           ; 15EE 30 3F                    0?
        brk                                     ; 15F0 00                       .
        brk                                     ; 15F1 00                       .
        brk                                     ; 15F2 00                       .
        brk                                     ; 15F3 00                       .
        brk                                     ; 15F4 00                       .
        .byte   $33                             ; 15F5 33                       3
        asl     a:$0C,x                         ; 15F6 1E 0C 00                 ...
        .byte   $7F                             ; 15F9 7F                       .
        brk                                     ; 15FA 00                       .
L15FB:  brk                                     ; 15FB 00                       .
        brk                                     ; 15FC 00                       .
        brk                                     ; 15FD 00                       .
        brk                                     ; 15FE 00                       .
        brk                                     ; 15FF 00                       .
        brk                                     ; 1600 00                       .
        brk                                     ; 1601 00                       .
        brk                                     ; 1602 00                       .
        brk                                     ; 1603 00                       .
        brk                                     ; 1604 00                       .
        brk                                     ; 1605 00                       .
        brk                                     ; 1606 00                       .
        brk                                     ; 1607 00                       .
        brk                                     ; 1608 00                       .
        clc                                     ; 1609 18                       .
        brk                                     ; 160A 00                       .
L160B:  clc                                     ; 160B 18                       .
        clc                                     ; 160C 18                       .
        clc                                     ; 160D 18                       .
        clc                                     ; 160E 18                       .
        clc                                     ; 160F 18                       .
        brk                                     ; 1610 00                       .
        brk                                     ; 1611 00                       .
L1612:  brk                                     ; 1612 00                       .
        brk                                     ; 1613 00                       .
        brk                                     ; 1614 00                       .
        brk                                     ; 1615 00                       .
        .byte   $36                             ; 1616 36                       6
L1617:  rol     $00,x                           ; 1617 36 00                    6.
        rol     $7F,x                           ; 1619 36 7F                    6.
        .byte   $36                             ; 161B 36                       6
L161C:  rol     $36,x                           ; 161C 36 36                    66
L161E:  .byte   $7F                             ; 161E 7F                       .
        rol     $00,x                           ; 161F 36 00                    6.
        .byte   $0C                             ; 1621 0C                       .
        .byte   $1F                             ; 1622 1F                       .
        bit     L0D1E                           ; 1623 2C 1E 0D                 ,..
        rol     a:$0C,x                         ; 1626 3E 0C 00                 >..
        .byte   $33                             ; 1629 33                       3
        .byte   $33                             ; 162A 33                       3
        .byte   $06                             ; 162B 06                       .
L162C:  .byte   $0C                             ; 162C 0C                       .
        clc                                     ; 162D 18                       .
        .byte   $33                             ; 162E 33                       3
L162F:  .byte   $33                             ; 162F 33                       3
        brk                                     ; 1630 00                       .
        asl     $3B33,x                         ; 1631 1E 33 3B                 .3;
        asl     $03                             ; 1634 06 03                    ..
        .byte   $33                             ; 1636 33                       3
        asl     a:$00,x                         ; 1637 1E 00 00                 ...
        brk                                     ; 163A 00                       .
L163B:  brk                                     ; 163B 00                       .
        brk                                     ; 163C 00                       .
        .byte   $0C                             ; 163D 0C                       .
        .byte   $0C                             ; 163E 0C                       .
        .byte   $0C                             ; 163F 0C                       .
        brk                                     ; 1640 00                       .
        .byte   $0C                             ; 1641 0C                       .
        asl     $03                             ; 1642 06 03                    ..
        .byte   $03                             ; 1644 03                       .
        .byte   $03                             ; 1645 03                       .
        asl     $0C                             ; 1646 06 0C                    ..
        brk                                     ; 1648 00                       .
        .byte   $0C                             ; 1649 0C                       .
        clc                                     ; 164A 18                       .
        bmi     L167D                           ; 164B 30 30                    00
        bmi     L1667                           ; 164D 30 18                    0.
        .byte   $0C                             ; 164F 0C                       .
        brk                                     ; 1650 00                       .
        asl     $3F3F,x                         ; 1651 1E 3F 3F                 .??
        .byte   $3F                             ; 1654 3F                       ?
        .byte   $3F                             ; 1655 3F                       ?
        .byte   $3F                             ; 1656 3F                       ?
        asl     L0C00,x                         ; 1657 1E 00 0C                 ...
        .byte   $0C                             ; 165A 0C                       .
        .byte   $3F                             ; 165B 3F                       ?
        .byte   $3F                             ; 165C 3F                       ?
        .byte   $0C                             ; 165D 0C                       .
        .byte   $0C                             ; 165E 0C                       .
        brk                                     ; 165F 00                       .
        .byte   $0C                             ; 1660 0C                       .
        clc                                     ; 1661 18                       .
        clc                                     ; 1662 18                       .
        brk                                     ; 1663 00                       .
        brk                                     ; 1664 00                       .
        brk                                     ; 1665 00                       .
        brk                                     ; 1666 00                       .
L1667:  brk                                     ; 1667 00                       .
        brk                                     ; 1668 00                       .
        brk                                     ; 1669 00                       .
        brk                                     ; 166A 00                       .
        .byte   $3F                             ; 166B 3F                       ?
        .byte   $3F                             ; 166C 3F                       ?
        brk                                     ; 166D 00                       .
        brk                                     ; 166E 00                       .
        brk                                     ; 166F 00                       .
        brk                                     ; 1670 00                       .
        .byte   $1C                             ; 1671 1C                       .
        .byte   $1C                             ; 1672 1C                       .
        brk                                     ; 1673 00                       .
        brk                                     ; 1674 00                       .
        brk                                     ; 1675 00                       .
        brk                                     ; 1676 00                       .
        brk                                     ; 1677 00                       .
        brk                                     ; 1678 00                       .
        .byte   $03                             ; 1679 03                       .
        .byte   $03                             ; 167A 03                       .
        asl     $0C                             ; 167B 06 0C                    ..
L167D:  clc                                     ; 167D 18                       .
        bmi     L16B0                           ; 167E 30 30                    00
        brk                                     ; 1680 00                       .
        asl     $3737,x                         ; 1681 1E 37 37                 .77
        .byte   $3F                             ; 1684 3F                       ?
        .byte   $3B                             ; 1685 3B                       ;
        .byte   $3B                             ; 1686 3B                       ;
        asl     L0C00,x                         ; 1687 1E 00 0C                 ...
        .byte   $0C                             ; 168A 0C                       .
        .byte   $0C                             ; 168B 0C                       .
        .byte   $0C                             ; 168C 0C                       .
        .byte   $0C                             ; 168D 0C                       .
        asl     a:$0C                           ; 168E 0E 0C 00                 ...
        .byte   $3F                             ; 1691 3F                       ?
        .byte   $03                             ; 1692 03                       .
        asl     $1C                             ; 1693 06 1C                    ..
        bmi     L16CA                           ; 1695 30 33                    03
        asl     L1E00,x                         ; 1697 1E 00 1E                 ...
        .byte   $33                             ; 169A 33                       3
        bmi     L16B5                           ; 169B 30 18                    0.
        bmi     L16D2                           ; 169D 30 33                    03
        asl     L1800,x                         ; 169F 1E 00 18                 ...
        clc                                     ; 16A2 18                       .
        .byte   $3F                             ; 16A3 3F                       ?
        .byte   $1B                             ; 16A4 1B                       .
        asl     L181C,x                         ; 16A5 1E 1C 18                 ...
        brk                                     ; 16A8 00                       .
        .byte   $1F                             ; 16A9 1F                       .
        bmi     L16DC                           ; 16AA 30 30                    00
        .byte   $1F                             ; 16AC 1F                       .
        .byte   $03                             ; 16AD 03                       .
        .byte   $03                             ; 16AE 03                       .
        .byte   $3F                             ; 16AF 3F                       ?
L16B0:  brk                                     ; 16B0 00                       .
        asl     $3333,x                         ; 16B1 1E 33 33                 .33
        .byte   $1F                             ; 16B4 1F                       .
L16B5:  .byte   $03                             ; 16B5 03                       .
        asl     $18                             ; 16B6 06 18                    ..
        brk                                     ; 16B8 00                       .
        .byte   $0C                             ; 16B9 0C                       .
        .byte   $0C                             ; 16BA 0C                       .
        .byte   $0C                             ; 16BB 0C                       .
        .byte   $0C                             ; 16BC 0C                       .
        clc                                     ; 16BD 18                       .
        bmi     L16FF                           ; 16BE 30 3F                    0?
        brk                                     ; 16C0 00                       .
        asl     $3333,x                         ; 16C1 1E 33 33                 .33
        asl     $3333,x                         ; 16C4 1E 33 33                 .33
        asl     L0C00,x                         ; 16C7 1E 00 0C                 ...
L16CA:  clc                                     ; 16CA 18                       .
        bmi     L170B                           ; 16CB 30 3E                    0>
        .byte   $33                             ; 16CD 33                       3
        .byte   $33                             ; 16CE 33                       3
        asl     L1800,x                         ; 16CF 1E 00 18                 ...
L16D2:  clc                                     ; 16D2 18                       .
        brk                                     ; 16D3 00                       .
        brk                                     ; 16D4 00                       .
        clc                                     ; 16D5 18                       .
        clc                                     ; 16D6 18                       .
        brk                                     ; 16D7 00                       .
        .byte   $0C                             ; 16D8 0C                       .
        clc                                     ; 16D9 18                       .
        clc                                     ; 16DA 18                       .
        brk                                     ; 16DB 00                       .
L16DC:  brk                                     ; 16DC 00                       .
        clc                                     ; 16DD 18                       .
        clc                                     ; 16DE 18                       .
        brk                                     ; 16DF 00                       .
        brk                                     ; 16E0 00                       .
        clc                                     ; 16E1 18                       .
        .byte   $0C                             ; 16E2 0C                       .
        asl     $03                             ; 16E3 06 03                    ..
        asl     $0C                             ; 16E5 06 0C                    ..
        clc                                     ; 16E7 18                       .
        brk                                     ; 16E8 00                       .
        brk                                     ; 16E9 00                       .
        brk                                     ; 16EA 00                       .
        .byte   $3F                             ; 16EB 3F                       ?
        brk                                     ; 16EC 00                       .
        .byte   $3F                             ; 16ED 3F                       ?
        brk                                     ; 16EE 00                       .
        brk                                     ; 16EF 00                       .
        brk                                     ; 16F0 00                       .
        asl     $0C                             ; 16F1 06 0C                    ..
        clc                                     ; 16F3 18                       .
        bmi     L170E                           ; 16F4 30 18                    0.
        .byte   $0C                             ; 16F6 0C                       .
        asl     $00                             ; 16F7 06 00                    ..
        .byte   $0C                             ; 16F9 0C                       .
        brk                                     ; 16FA 00                       .
        .byte   $0C                             ; 16FB 0C                       .
        clc                                     ; 16FC 18                       .
        bmi     L1732                           ; 16FD 30 33                    03
L16FF:  .byte   $1E                             ; 16FF 1E                       .
L1700:  .byte   $4C                             ; 1700 4C                       L
L1701:  brk                                     ; 1701 00                       .
        .byte   $5F                             ; 1702 5F                       _
        brk                                     ; 1703 00                       .
        .byte   $72                             ; 1704 72                       r
        brk                                     ; 1705 00                       .
        .byte   $83                             ; 1706 83                       .
        brk                                     ; 1707 00                       .
        sty     $00,x                           ; 1708 94 00                    ..
        .byte   $A1                             ; 170A A1                       .
L170B:  brk                                     ; 170B 00                       .
        .byte   $AE                             ; 170C AE                       .
        brk                                     ; 170D 00                       .
L170E:  cpy     #$01                            ; 170E C0 01                    ..
        .byte   $D2                             ; 1710 D2                       .
        .byte   $02                             ; 1711 02                       .
        ldy     #$04                            ; 1712 A0 04                    ..
        ror     $8506                           ; 1714 6E 06 85                 n..
        asl     $9C                             ; 1717 06 9C                    ..
        asl     $B3                             ; 1719 06 B3                    ..
        asl     $CA                             ; 171B 06 CA                    ..
        asl     $E1                             ; 171D 06 E1                    ..
        asl     $F8                             ; 171F 06 F8                    ..
        asl     $0F                             ; 1721 06 0F                    ..
        .byte   $07                             ; 1723 07                       .
        rol     $07                             ; 1724 26 07                    &.
        and     $5407,x                         ; 1726 3D 07 54                 =.T
        .byte   $07                             ; 1729 07                       .
        .byte   $6B                             ; 172A 6B                       k
        .byte   $07                             ; 172B 07                       .
        .byte   $82                             ; 172C 82                       .
        .byte   $07                             ; 172D 07                       .
        .byte   $92                             ; 172E 92                       .
        .byte   $07                             ; 172F 07                       .
        ldx     #$07                            ; 1730 A2 07                    ..
L1732:  .byte   $B2                             ; 1732 B2                       .
        .byte   $07                             ; 1733 07                       .
        .byte   $C2                             ; 1734 C2                       .
        .byte   $07                             ; 1735 07                       .
        iny                                     ; 1736 C8                       .
        .byte   $07                             ; 1737 07                       .
        dec     $D807                           ; 1738 CE 07 D8                 ...
        .byte   $07                             ; 173B 07                       .
        .byte   $E2                             ; 173C E2                       .
        .byte   $07                             ; 173D 07                       .
        .byte   $F3                             ; 173E F3                       .
        .byte   $07                             ; 173F 07                       .
        .byte   $04                             ; 1740 04                       .
        php                                     ; 1741 08                       .
        clc                                     ; 1742 18                       .
        php                                     ; 1743 08                       .
        bit     $4E08                           ; 1744 2C 08 4E                 ,.N
        php                                     ; 1747 08                       .
        bvs     L1752                           ; 1748 70 08                    p.
        stx     $08,y                           ; 174A 96 08                    ..
        ora     ($01),y                         ; 174C 11 01                    ..
        .byte   $7C                             ; 174E 7C                       |
        .byte   $7F                             ; 174F 7F                       .
        .byte   $7F                             ; 1750 7F                       .
        .byte   $7F                             ; 1751 7F                       .
L1752:  .byte   $7F                             ; 1752 7F                       .
        .byte   $7F                             ; 1753 7F                       .
        .byte   $7F                             ; 1754 7F                       .
        .byte   $7F                             ; 1755 7F                       .
        .byte   $7F                             ; 1756 7F                       .
        .byte   $7F                             ; 1757 7F                       .
        .byte   $7F                             ; 1758 7F                       .
        .byte   $7F                             ; 1759 7F                       .
        .byte   $7F                             ; 175A 7F                       .
        .byte   $7F                             ; 175B 7F                       .
        .byte   $7F                             ; 175C 7F                       .
        .byte   $7F                             ; 175D 7F                       .
        .byte   $1F                             ; 175E 1F                       .
        ora     ($01),y                         ; 175F 11 01                    ..
        sei                                     ; 1761 78                       x
        .byte   $7F                             ; 1762 7F                       .
        .byte   $7F                             ; 1763 7F                       .
        .byte   $7F                             ; 1764 7F                       .
        .byte   $7F                             ; 1765 7F                       .
        .byte   $7F                             ; 1766 7F                       .
        .byte   $7F                             ; 1767 7F                       .
        .byte   $7F                             ; 1768 7F                       .
        .byte   $7F                             ; 1769 7F                       .
        .byte   $7F                             ; 176A 7F                       .
        .byte   $7F                             ; 176B 7F                       .
        .byte   $7F                             ; 176C 7F                       .
        .byte   $7F                             ; 176D 7F                       .
        .byte   $7F                             ; 176E 7F                       .
        .byte   $7F                             ; 176F 7F                       .
        .byte   $7F                             ; 1770 7F                       .
        .byte   $3F                             ; 1771 3F                       ?
        .byte   $0F                             ; 1772 0F                       .
        ora     ($00,x)                         ; 1773 01 00                    ..
        brk                                     ; 1775 00                       .
        .byte   $7F                             ; 1776 7F                       .
        .byte   $7F                             ; 1777 7F                       .
        .byte   $7F                             ; 1778 7F                       .
        .byte   $7F                             ; 1779 7F                       .
        .byte   $7F                             ; 177A 7F                       .
        .byte   $7F                             ; 177B 7F                       .
        .byte   $7F                             ; 177C 7F                       .
        .byte   $7F                             ; 177D 7F                       .
        .byte   $7F                             ; 177E 7F                       .
        .byte   $7F                             ; 177F 7F                       .
        .byte   $7F                             ; 1780 7F                       .
        .byte   $7F                             ; 1781 7F                       .
        .byte   $7F                             ; 1782 7F                       .
        .byte   $0F                             ; 1783 0F                       .
        ora     ($00,x)                         ; 1784 01 00                    ..
        brk                                     ; 1786 00                       .
        ror     $7F7F,x                         ; 1787 7E 7F 7F                 ~..
        .byte   $7F                             ; 178A 7F                       .
        .byte   $7F                             ; 178B 7F                       .
        .byte   $7F                             ; 178C 7F                       .
        .byte   $7F                             ; 178D 7F                       .
        .byte   $7F                             ; 178E 7F                       .
        .byte   $7F                             ; 178F 7F                       .
        .byte   $7F                             ; 1790 7F                       .
        .byte   $7F                             ; 1791 7F                       .
        .byte   $7F                             ; 1792 7F                       .
        .byte   $7F                             ; 1793 7F                       .
        .byte   $0B                             ; 1794 0B                       .
        ora     ($00,x)                         ; 1795 01 00                    ..
        brk                                     ; 1797 00                       .
        brk                                     ; 1798 00                       .
        brk                                     ; 1799 00                       .
        brk                                     ; 179A 00                       .
        brk                                     ; 179B 00                       .
        rts                                     ; 179C 60                       `

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 179D 7F                       .
        .byte   $7F                             ; 179E 7F                       .
        .byte   $7F                             ; 179F 7F                       .
        .byte   $03                             ; 17A0 03                       .
        .byte   $0B                             ; 17A1 0B                       .
        ora     ($00,x)                         ; 17A2 01 00                    ..
        brk                                     ; 17A4 00                       .
        brk                                     ; 17A5 00                       .
        brk                                     ; 17A6 00                       .
        brk                                     ; 17A7 00                       .
        brk                                     ; 17A8 00                       .
        rti                                     ; 17A9 40                       @

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 17AA 7F                       .
        .byte   $7F                             ; 17AB 7F                       .
        .byte   $7F                             ; 17AC 7F                       .
        .byte   $07                             ; 17AD 07                       .
        ora     ($10),y                         ; 17AE 11 10                    ..
        brk                                     ; 17B0 00                       .
        brk                                     ; 17B1 00                       .
        brk                                     ; 17B2 00                       .
        brk                                     ; 17B3 00                       .
        brk                                     ; 17B4 00                       .
        brk                                     ; 17B5 00                       .
        brk                                     ; 17B6 00                       .
        brk                                     ; 17B7 00                       .
        .byte   $3C                             ; 17B8 3C                       <
        brk                                     ; 17B9 00                       .
        brk                                     ; 17BA 00                       .
        brk                                     ; 17BB 00                       .
        brk                                     ; 17BC 00                       .
        brk                                     ; 17BD 00                       .
        brk                                     ; 17BE 00                       .
        brk                                     ; 17BF 00                       .
        brk                                     ; 17C0 00                       .
        plp                                     ; 17C1 28                       (
        eor     ($0A,x)                         ; 17C2 41 0A                    A.
        ora     $0A                             ; 17C4 05 0A                    ..
        .byte   $14                             ; 17C6 14                       .
        .byte   $22                             ; 17C7 22                       "
        ora     $2A                             ; 17C8 05 2A                    .*
        rti                                     ; 17CA 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; 17CB 02                       .
        eor     $0A                             ; 17CC 45 0A                    E.
        .byte   $54                             ; 17CE 54                       T
        plp                                     ; 17CF 28                       (
        eor     ($02,x)                         ; 17D0 41 02                    A.
        jmp     (L4E65)                         ; 17D2 6C 65 4E                 leN

; ----------------------------------------------------------------------------
        ora     $2B,x                           ; 17D5 15 2B                    .+
        asl     $33,x                           ; 17D7 16 33                    .3
        .byte   $07                             ; 17D9 07                       .
        .byte   $3B                             ; 17DA 3B                       ;
        eor     $654B,y                         ; 17DB 59 4B 65                 YKe
        rol     $6C76                           ; 17DE 2E 76 6C                 .vl
        adc     $0A                             ; 17E1 65 0A                    e.
        bit     $4266                           ; 17E3 2C 66 42                 ,fB
        ora     $2B,x                           ; 17E6 15 2B                    .+
        asl     $33,x                           ; 17E8 16 33                    .3
        ora     ($4B,x)                         ; 17EA 01 4B                    .K
        eor     $654C,y                         ; 17EC 59 4C 65                 YLe
        .byte   $32                             ; 17EF 32                       2
        asl     $2C,x                           ; 17F0 16 2C                    .,
        ror     $0A                             ; 17F2 66 0A                    f.
        bit     $4266                           ; 17F4 2C 66 42                 ,fB
        ora     L163B,x                         ; 17F7 1D 3B 16                 .;.
        .byte   $33                             ; 17FA 33                       3
        ora     ($4B,x)                         ; 17FB 01 4B                    .K
        eor     $654C,y                         ; 17FD 59 4C 65                 YLe
L1800:  .byte   $32                             ; 1800 32                       2
        asl     $2C,x                           ; 1801 16 2C                    .,
        ror     $0E                             ; 1803 66 0E                    f.
        bit     $4266                           ; 1805 2C 66 42                 ,fB
        ora     $0B                             ; 1808 05 0B                    ..
        asl     $33,x                           ; 180A 16 33                    .3
        ora     ($4B,x)                         ; 180C 01 4B                    .K
        eor     $654C,y                         ; 180E 59 4C 65                 YLe
        .byte   $32                             ; 1811 32                       2
        asl     $2C,x                           ; 1812 16 2C                    .,
        ror     $02                             ; 1814 66 02                    f.
        bit     $4A61                           ; 1816 2C 61 4A                 ,aJ
        ora     $0B                             ; 1819 05 0B                    ..
        .byte   $16                             ; 181B 16                       .
L181C:  .byte   $33                             ; 181C 33                       3
        ora     $2B                             ; 181D 05 2B                    .+
        cli                                     ; 181F 58                       X
        lsr     a                               ; 1820 4A                       J
        adc     $32                             ; 1821 65 32                    e2
        lsr     $2C,x                           ; 1823 56 2C                    V,
        adc     ($02,x)                         ; 1825 61 02                    a.
        bit     $4A61                           ; 1827 2C 61 4A                 ,aJ
        ora     $0B,x                           ; 182A 15 0B                    ..
        asl     $33,x                           ; 182C 16 33                    .3
        ora     $2B                             ; 182E 05 2B                    .+
        cli                                     ; 1830 58                       X
        lsr     a                               ; 1831 4A                       J
        adc     $32                             ; 1832 65 32                    e2
        lsr     $2C,x                           ; 1834 56 2C                    V,
        adc     ($0A,x)                         ; 1836 61 0A                    a.
        jmp     (L0E65)                         ; 1838 6C 65 0E                 le.

; ----------------------------------------------------------------------------
        asl     $0B,x                           ; 183B 16 0B                    ..
        asl     $33,x                           ; 183D 16 33                    .3
        .byte   $07                             ; 183F 07                       .
        .byte   $3B                             ; 1840 3B                       ;
        eor     $654B,y                         ; 1841 59 4B 65                 YKe
        .byte   $32                             ; 1844 32                       2
        ror     $6C,x                           ; 1845 76 6C                    vl
        ora     $0B                             ; 1847 05 0B                    ..
        bit     $0266                           ; 1849 2C 66 02                 ,f.
        asl     $0B,x                           ; 184C 16 0B                    ..
        asl     $33,x                           ; 184E 16 33                    .3
        ora     ($4B,x)                         ; 1850 01 4B                    .K
        eor     $654C,y                         ; 1852 59 4C 65                 YLe
        .byte   $32                             ; 1855 32                       2
        asl     $2C,x                           ; 1856 16 2C                    .,
        asl     $0B                             ; 1858 06 0B                    ..
        bit     $0266                           ; 185A 2C 66 02                 ,f.
        asl     $0B,x                           ; 185D 16 0B                    ..
        asl     $33,x                           ; 185F 16 33                    .3
        ora     ($4B,x)                         ; 1861 01 4B                    .K
        eor     $654C,y                         ; 1863 59 4C 65                 YLe
        .byte   $32                             ; 1866 32                       2
        asl     $2C,x                           ; 1867 16 2C                    .,
        asl     $0B                             ; 1869 06 0B                    ..
        bit     $0266                           ; 186B 2C 66 02                 ,f.
        asl     $0B,x                           ; 186E 16 0B                    ..
        asl     $33,x                           ; 1870 16 33                    .3
        ora     ($4B,x)                         ; 1872 01 4B                    .K
        eor     $654C,y                         ; 1874 59 4C 65                 YLe
        .byte   $32                             ; 1877 32                       2
        asl     $2C,x                           ; 1878 16 2C                    .,
        asl     $0B                             ; 187A 06 0B                    ..
        .byte   $2C                             ; 187C 2C                       ,
L187D:  ror     $4A                             ; 187D 66 4A                    fJ
        ora     $2B,x                           ; 187F 15 2B                    .+
        asl     $33,x                           ; 1881 16 33                    .3
        ora     $4B                             ; 1883 05 4B                    .K
        eor     $654C,y                         ; 1885 59 4C 65                 YLe
        rol     a                               ; 1888 2A                       *
        lsr     $2C,x                           ; 1889 56 2C                    V,
        ror     $0A                             ; 188B 66 0A                    f.
        bit     $4A66                           ; 188D 2C 66 4A                 ,fJ
        ora     $2B,x                           ; 1890 15 2B                    .+
        lsr     $32,x                           ; 1892 56 32                    V2
        ora     $4B                             ; 1894 05 4B                    .K
        eor     $654C,y                         ; 1896 59 4C 65                 YLe
        rol     a                               ; 1899 2A                       *
        lsr     $2C,x                           ; 189A 56 2C                    V,
        ror     $0A                             ; 189C 66 0A                    f.
        bit     $4A66                           ; 189E 2C 66 4A                 ,fJ
        ora     $2B,x                           ; 18A1 15 2B                    .+
        lsr     $32,x                           ; 18A3 56 32                    V2
        ora     $4B                             ; 18A5 05 4B                    .K
        eor     $654C,y                         ; 18A7 59 4C 65                 YLe
        rol     a                               ; 18AA 2A                       *
        lsr     $2C,x                           ; 18AB 56 2C                    V,
        ror     $0A                             ; 18AD 66 0A                    f.
        .byte   $3C                             ; 18AF 3C                       <
        ror     $0F                             ; 18B0 66 0F                    f.
        .byte   $1F                             ; 18B2 1F                       .
        rol     $737C,x                         ; 18B3 3E 7C 73                 >|s
        .byte   $07                             ; 18B6 07                       .
        .byte   $4F                             ; 18B7 4F                       O
        adc     $674C,y                         ; 18B8 79 4C 67                 yLg
        .byte   $3F                             ; 18BB 3F                       ?
        ror     $463C,x                         ; 18BC 7E 3C 46                 ~<F
        .byte   $0F                             ; 18BF 0F                       .
        ora     ($10),y                         ; 18C0 11 10                    ..
        brk                                     ; 18C2 00                       .
        brk                                     ; 18C3 00                       .
        brk                                     ; 18C4 00                       .
        brk                                     ; 18C5 00                       .
        brk                                     ; 18C6 00                       .
        brk                                     ; 18C7 00                       .
        brk                                     ; 18C8 00                       .
        brk                                     ; 18C9 00                       .
        sei                                     ; 18CA 78                       x
        brk                                     ; 18CB 00                       .
        brk                                     ; 18CC 00                       .
        brk                                     ; 18CD 00                       .
        brk                                     ; 18CE 00                       .
        brk                                     ; 18CF 00                       .
        brk                                     ; 18D0 00                       .
        brk                                     ; 18D1 00                       .
        brk                                     ; 18D2 00                       .
        bvc     L18D7                           ; 18D3 50 02                    P.
        ora     $0A,x                           ; 18D5 15 0A                    ..
L18D7:  .byte   $14                             ; 18D7 14                       .
        plp                                     ; 18D8 28                       (
        .byte   $44                             ; 18D9 44                       D
        asl     a                               ; 18DA 0A                       .
        .byte   $54                             ; 18DB 54                       T
        brk                                     ; 18DC 00                       .
        ora     $0A                             ; 18DD 05 0A                    ..
        ora     $28,x                           ; 18DF 15 28                    .(
        eor     ($02),y                         ; 18E1 51 02                    Q.
        ora     $58                             ; 18E3 05 58                    .X
        .byte   $4B                             ; 18E5 4B                       K
        ora     $562B,x                         ; 18E6 1D 2B 56                 .+V
        bit     L0E66                           ; 18E9 2C 66 0E                 ,f.
        ror     $32,x                           ; 18EC 76 32                    v2
        .byte   $17                             ; 18EE 17                       .
        .byte   $4B                             ; 18EF 4B                       K
        eor     $596C,x                         ; 18F0 5D 6C 59                 ]lY
        .byte   $4B                             ; 18F3 4B                       K
        ora     $58,x                           ; 18F4 15 58                    .X
        jmp     L2B05                           ; 18F6 4C 05 2B                 L.+

; ----------------------------------------------------------------------------
        lsr     $2C,x                           ; 18F9 56 2C                    V,
        ror     $02                             ; 18FB 66 02                    f.
        asl     $33,x                           ; 18FD 16 33                    .3
        ora     $654B,y                         ; 18FF 19 4B 65                 .Ke
        bit     $4C58                           ; 1902 2C 58 4C                 ,XL
        ora     $58,x                           ; 1905 15 58                    .X
        jmp     L3B05                           ; 1907 4C 05 3B                 L.;

; ----------------------------------------------------------------------------
        ror     $2C,x                           ; 190A 76 2C                    v,
        ror     $02                             ; 190C 66 02                    f.
        asl     $33,x                           ; 190E 16 33                    .3
        ora     $654B,y                         ; 1910 19 4B 65                 .Ke
        bit     $4C58                           ; 1913 2C 58 4C                 ,XL
        ora     $4C58,x                         ; 1916 1D 58 4C                 .XL
        ora     $0B                             ; 1919 05 0B                    ..
        asl     $2C,x                           ; 191B 16 2C                    .,
        ror     $02                             ; 191D 66 02                    f.
        asl     $33,x                           ; 191F 16 33                    .3
        ora     $654B,y                         ; 1921 19 4B 65                 .Ke
        bit     $4C58                           ; 1924 2C 58 4C                 ,XL
        ora     $58                             ; 1927 05 58                    .X
        .byte   $42                             ; 1929 42                       B
        ora     $0B,x                           ; 192A 15 0B                    ..
        asl     $2C,x                           ; 192C 16 2C                    .,
        ror     $0A                             ; 192E 66 0A                    f.
        lsr     $30,x                           ; 1930 56 30                    V0
        ora     $4B,x                           ; 1932 15 4B                    .K
        adc     $2C                             ; 1934 65 2C                    e,
        eor     $0542,y                         ; 1936 59 42 05                 YB.
        cli                                     ; 1939 58                       X
        .byte   $42                             ; 193A 42                       B
        ora     $2B,x                           ; 193B 15 2B                    .+
        asl     $2C,x                           ; 193D 16 2C                    .,
        ror     $0A                             ; 193F 66 0A                    f.
        lsr     $30,x                           ; 1941 56 30                    V0
        ora     $4B,x                           ; 1943 15 4B                    .K
        adc     $2C                             ; 1945 65 2C                    e,
        eor     L1542,y                         ; 1947 59 42 15                 YB.
        cli                                     ; 194A 58                       X
        .byte   $4B                             ; 194B 4B                       K
        ora     L162C,x                         ; 194C 1D 2C 16                 .,.
        bit     L0E66                           ; 194F 2C 66 0E                 ,f.
        ror     $32,x                           ; 1952 76 32                    v2
        .byte   $17                             ; 1954 17                       .
        .byte   $4B                             ; 1955 4B                       K
        adc     $6C                             ; 1956 65 6C                    el
        eor     L160B,y                         ; 1958 59 0B 16                 Y..
        cli                                     ; 195B 58                       X
        jmp     L2C05                           ; 195C 4C 05 2C                 L.,

; ----------------------------------------------------------------------------
        asl     $2C,x                           ; 195F 16 2C                    .,
        ror     $02                             ; 1961 66 02                    f.
        asl     $33,x                           ; 1963 16 33                    .3
        ora     $654B,y                         ; 1965 19 4B 65                 .Ke
        bit     L0C58                           ; 1968 2C 58 0C                 ,X.
        asl     $58,x                           ; 196B 16 58                    .X
        jmp     L2C05                           ; 196D 4C 05 2C                 L.,

; ----------------------------------------------------------------------------
        asl     $2C,x                           ; 1970 16 2C                    .,
        .byte   $66                             ; 1972 66                       f
L1973:  .byte   $02                             ; 1973 02                       .
        asl     $33,x                           ; 1974 16 33                    .3
        ora     $654B,y                         ; 1976 19 4B 65                 .Ke
        bit     L0C58                           ; 1979 2C 58 0C                 ,X.
        asl     $58,x                           ; 197C 16 58                    .X
        jmp     L2C05                           ; 197E 4C 05 2C                 L.,

; ----------------------------------------------------------------------------
        asl     $2C,x                           ; 1981 16 2C                    .,
        ror     $02                             ; 1983 66 02                    f.
        asl     $33,x                           ; 1985 16 33                    .3
        ora     $654B,y                         ; 1987 19 4B 65                 .Ke
        bit     L0C58                           ; 198A 2C 58 0C                 ,X.
        asl     $58,x                           ; 198D 16 58                    .X
        jmp     L2B15                           ; 198F 4C 15 2B                 L.+

; ----------------------------------------------------------------------------
        lsr     $2C,x                           ; 1992 56 2C                    V,
        ror     $0A                             ; 1994 66 0A                    f.
        asl     $33,x                           ; 1996 16 33                    .3
        ora     $554B,y                         ; 1998 19 4B 55                 .KU
        bit     $4C59                           ; 199B 2C 59 4C                 ,YL
        ora     $58,x                           ; 199E 15 58                    .X
        jmp     L2B15                           ; 19A0 4C 15 2B                 L.+

; ----------------------------------------------------------------------------
        lsr     $2C,x                           ; 19A3 56 2C                    V,
        adc     $0A                             ; 19A5 65 0A                    e.
        asl     $33,x                           ; 19A7 16 33                    .3
        ora     $554B,y                         ; 19A9 19 4B 55                 .KU
        bit     $4C59                           ; 19AC 2C 59 4C                 ,YL
        ora     $58,x                           ; 19AF 15 58                    .X
        jmp     L2B15                           ; 19B1 4C 15 2B                 L.+

; ----------------------------------------------------------------------------
        lsr     $2C,x                           ; 19B4 56 2C                    V,
        adc     $0A                             ; 19B6 65 0A                    e.
        asl     $33,x                           ; 19B8 16 33                    .3
        ora     $554B,y                         ; 19BA 19 4B 55                 .KU
        bit     $4C59                           ; 19BD 2C 59 4C                 ,YL
        ora     $78,x                           ; 19C0 15 78                    .x
        jmp     L3E1F                           ; 19C2 4C 1F 3E                 L.>

; ----------------------------------------------------------------------------
        .byte   $7C                             ; 19C5 7C                       |
        sei                                     ; 19C6 78                       x
        .byte   $67                             ; 19C7 67                       g
        .byte   $0F                             ; 19C8 0F                       .
        asl     L1973,x                         ; 19C9 1E 73 19                 .s.
        .byte   $4F                             ; 19CC 4F                       O
        .byte   $7F                             ; 19CD 7F                       .
        .byte   $7C                             ; 19CE 7C                       |
        adc     L1F0C,y                         ; 19CF 79 0C 1F                 y..
        .byte   $14                             ; 19D2 14                       .
        .byte   $17                             ; 19D3 17                       .
        .byte   $7F                             ; 19D4 7F                       .
        .byte   $7F                             ; 19D5 7F                       .
        .byte   $7F                             ; 19D6 7F                       .
        .byte   $7F                             ; 19D7 7F                       .
        .byte   $7F                             ; 19D8 7F                       .
        .byte   $7F                             ; 19D9 7F                       .
        .byte   $7F                             ; 19DA 7F                       .
        .byte   $7F                             ; 19DB 7F                       .
        .byte   $7F                             ; 19DC 7F                       .
        .byte   $7F                             ; 19DD 7F                       .
        .byte   $7F                             ; 19DE 7F                       .
        .byte   $7F                             ; 19DF 7F                       .
        .byte   $7F                             ; 19E0 7F                       .
        .byte   $7F                             ; 19E1 7F                       .
        .byte   $7F                             ; 19E2 7F                       .
        .byte   $7F                             ; 19E3 7F                       .
        .byte   $3F                             ; 19E4 3F                       ?
        .byte   $0C                             ; 19E5 0C                       .
        brk                                     ; 19E6 00                       .
        brk                                     ; 19E7 00                       .
        .byte   $7F                             ; 19E8 7F                       .
        .byte   $7F                             ; 19E9 7F                       .
        .byte   $7F                             ; 19EA 7F                       .
        .byte   $7F                             ; 19EB 7F                       .
        .byte   $7F                             ; 19EC 7F                       .
        .byte   $7F                             ; 19ED 7F                       .
        .byte   $7F                             ; 19EE 7F                       .
        .byte   $7F                             ; 19EF 7F                       .
        .byte   $7F                             ; 19F0 7F                       .
        .byte   $7F                             ; 19F1 7F                       .
        .byte   $7F                             ; 19F2 7F                       .
        .byte   $7F                             ; 19F3 7F                       .
        .byte   $7F                             ; 19F4 7F                       .
        .byte   $7F                             ; 19F5 7F                       .
        .byte   $7F                             ; 19F6 7F                       .
        .byte   $7F                             ; 19F7 7F                       .
        .byte   $3F                             ; 19F8 3F                       ?
        .byte   $0C                             ; 19F9 0C                       .
        brk                                     ; 19FA 00                       .
        brk                                     ; 19FB 00                       .
        .byte   $3F                             ; 19FC 3F                       ?
        eor     $2F,x                           ; 19FD 55 2F                    U/
        adc     $2B,x                           ; 19FF 75 2B                    u+
        adc     $7F,x                           ; 1A01 75 7F                    u.
        .byte   $7F                             ; 1A03 7F                       .
        .byte   $2B                             ; 1A04 2B                       +
        eor     $2F,x                           ; 1A05 55 2F                    U/
        eor     $3F,x                           ; 1A07 55 3F                    U?
        eor     $2F,x                           ; 1A09 55 2F                    U/
        .byte   $5F                             ; 1A0B 5F                       _
        rol     $2A4C,x                         ; 1A0C 3E 4C 2A                 >L*
        ora     ($7F,x)                         ; 1A0F 01 7F                    ..
        .byte   $7F                             ; 1A11 7F                       .
        .byte   $7F                             ; 1A12 7F                       .
        .byte   $7F                             ; 1A13 7F                       .
        .byte   $7F                             ; 1A14 7F                       .
        .byte   $7F                             ; 1A15 7F                       .
        .byte   $7F                             ; 1A16 7F                       .
        .byte   $7F                             ; 1A17 7F                       .
        .byte   $7F                             ; 1A18 7F                       .
        .byte   $7F                             ; 1A19 7F                       .
        .byte   $7F                             ; 1A1A 7F                       .
        .byte   $7F                             ; 1A1B 7F                       .
        .byte   $7F                             ; 1A1C 7F                       .
        .byte   $7F                             ; 1A1D 7F                       .
        .byte   $7F                             ; 1A1E 7F                       .
        .byte   $7F                             ; 1A1F 7F                       .
        .byte   $3F                             ; 1A20 3F                       ?
        jmp     L052A                           ; 1A21 4C 2A 05                 L*.

; ----------------------------------------------------------------------------
        .byte   $2F                             ; 1A24 2F                       /
        eor     $2F,x                           ; 1A25 55 2F                    U/
        adc     $2B,x                           ; 1A27 75 2B                    u+
        eor     $7F,x                           ; 1A29 55 7F                    U.
        .byte   $7F                             ; 1A2B 7F                       .
        .byte   $2B                             ; 1A2C 2B                       +
        eor     $2F,x                           ; 1A2D 55 2F                    U/
        eor     $2F,x                           ; 1A2F 55 2F                    U/
        eor     $2F,x                           ; 1A31 55 2F                    U/
        .byte   $5F                             ; 1A33 5F                       _
        rol     L0A4C,x                         ; 1A34 3E 4C 0A                 >L.
        .byte   $04                             ; 1A37 04                       .
        .byte   $7F                             ; 1A38 7F                       .
        .byte   $7F                             ; 1A39 7F                       .
        .byte   $7F                             ; 1A3A 7F                       .
        .byte   $7F                             ; 1A3B 7F                       .
        .byte   $7F                             ; 1A3C 7F                       .
        .byte   $7F                             ; 1A3D 7F                       .
        .byte   $7F                             ; 1A3E 7F                       .
        .byte   $7F                             ; 1A3F 7F                       .
        .byte   $7F                             ; 1A40 7F                       .
        .byte   $7F                             ; 1A41 7F                       .
        .byte   $7F                             ; 1A42 7F                       .
        .byte   $7F                             ; 1A43 7F                       .
        .byte   $7F                             ; 1A44 7F                       .
        .byte   $7F                             ; 1A45 7F                       .
        .byte   $7F                             ; 1A46 7F                       .
        .byte   $7F                             ; 1A47 7F                       .
        .byte   $3F                             ; 1A48 3F                       ?
        rti                                     ; 1A49 40                       @

; ----------------------------------------------------------------------------
        asl     a                               ; 1A4A 0A                       .
        .byte   $04                             ; 1A4B 04                       .
        .byte   $2F                             ; 1A4C 2F                       /
        .byte   $7F                             ; 1A4D 7F                       .
        .byte   $3F                             ; 1A4E 3F                       ?
        adc     $576B,x                         ; 1A4F 7D 6B 57                 }kW
        .byte   $7F                             ; 1A52 7F                       .
        .byte   $7F                             ; 1A53 7F                       .
        .byte   $3F                             ; 1A54 3F                       ?
        adc     $7F2F,x                         ; 1A55 7D 2F 7F                 }/.
        .byte   $2F                             ; 1A58 2F                       /
        .byte   $7F                             ; 1A59 7F                       .
        .byte   $2F                             ; 1A5A 2F                       /
        eor     $3E,x                           ; 1A5B 55 3E                    U>
        .byte   $5C                             ; 1A5D 5C                       \
        asl     a                               ; 1A5E 0A                       .
        .byte   $04                             ; 1A5F 04                       .
        .byte   $7F                             ; 1A60 7F                       .
        .byte   $7F                             ; 1A61 7F                       .
        .byte   $7F                             ; 1A62 7F                       .
        .byte   $7F                             ; 1A63 7F                       .
        .byte   $7F                             ; 1A64 7F                       .
        .byte   $7F                             ; 1A65 7F                       .
        .byte   $7F                             ; 1A66 7F                       .
        .byte   $7F                             ; 1A67 7F                       .
        .byte   $7F                             ; 1A68 7F                       .
        .byte   $7F                             ; 1A69 7F                       .
        .byte   $7F                             ; 1A6A 7F                       .
        .byte   $7F                             ; 1A6B 7F                       .
        .byte   $7F                             ; 1A6C 7F                       .
        .byte   $7F                             ; 1A6D 7F                       .
        .byte   $7F                             ; 1A6E 7F                       .
        .byte   $7F                             ; 1A6F 7F                       .
        .byte   $3F                             ; 1A70 3F                       ?
        .byte   $5C                             ; 1A71 5C                       \
        asl     a                               ; 1A72 0A                       .
        .byte   $04                             ; 1A73 04                       .
        .byte   $3F                             ; 1A74 3F                       ?
        adc     $3F,x                           ; 1A75 75 3F                    u?
        adc     $552B,x                         ; 1A77 7D 2B 55                 }+U
        .byte   $3F                             ; 1A7A 3F                       ?
        eor     $3F,x                           ; 1A7B 55 3F                    U?
        adc     $752F,x                         ; 1A7D 7D 2F 75                 }/u
        .byte   $2F                             ; 1A80 2F                       /
        .byte   $7F                             ; 1A81 7F                       .
        .byte   $2F                             ; 1A82 2F                       /
        eor     $3E,x                           ; 1A83 55 3E                    U>
        .byte   $5C                             ; 1A85 5C                       \
        rol     a                               ; 1A86 2A                       *
        ora     $7F7F                           ; 1A87 0D 7F 7F                 ...
        .byte   $7F                             ; 1A8A 7F                       .
        .byte   $7F                             ; 1A8B 7F                       .
        .byte   $7F                             ; 1A8C 7F                       .
        .byte   $7F                             ; 1A8D 7F                       .
        .byte   $7F                             ; 1A8E 7F                       .
        .byte   $7F                             ; 1A8F 7F                       .
        .byte   $7F                             ; 1A90 7F                       .
        .byte   $7F                             ; 1A91 7F                       .
        .byte   $7F                             ; 1A92 7F                       .
        .byte   $7F                             ; 1A93 7F                       .
        .byte   $7F                             ; 1A94 7F                       .
        .byte   $7F                             ; 1A95 7F                       .
        .byte   $7F                             ; 1A96 7F                       .
        .byte   $7F                             ; 1A97 7F                       .
        .byte   $3F                             ; 1A98 3F                       ?
        .byte   $5C                             ; 1A99 5C                       \
        rol     a                               ; 1A9A 2A                       *
        ora     $577F                           ; 1A9B 0D 7F 57                 ..W
        .byte   $3F                             ; 1A9E 3F                       ?
        adc     $756B,x                         ; 1A9F 7D 6B 75                 }ku
        .byte   $7F                             ; 1AA2 7F                       .
        .byte   $7F                             ; 1AA3 7F                       .
        .byte   $3F                             ; 1AA4 3F                       ?
        adc     $7F2F,x                         ; 1AA5 7D 2F 7F                 }/.
        .byte   $2F                             ; 1AA8 2F                       /
        .byte   $7F                             ; 1AA9 7F                       .
        .byte   $2F                             ; 1AAA 2F                       /
        .byte   $5F                             ; 1AAB 5F                       _
        rol     $7A5C,x                         ; 1AAC 3E 5C 7A                 >\z
        ora     $7F7F                           ; 1AAF 0D 7F 7F                 ...
        .byte   $7F                             ; 1AB2 7F                       .
        .byte   $7F                             ; 1AB3 7F                       .
        .byte   $7F                             ; 1AB4 7F                       .
        .byte   $7F                             ; 1AB5 7F                       .
        .byte   $7F                             ; 1AB6 7F                       .
        .byte   $7F                             ; 1AB7 7F                       .
        .byte   $7F                             ; 1AB8 7F                       .
        .byte   $7F                             ; 1AB9 7F                       .
        .byte   $7F                             ; 1ABA 7F                       .
        .byte   $7F                             ; 1ABB 7F                       .
        .byte   $7F                             ; 1ABC 7F                       .
        .byte   $7F                             ; 1ABD 7F                       .
        .byte   $7F                             ; 1ABE 7F                       .
        .byte   $7F                             ; 1ABF 7F                       .
        .byte   $3F                             ; 1AC0 3F                       ?
        .byte   $5C                             ; 1AC1 5C                       \
        rol     a                               ; 1AC2 2A                       *
        ora     $552F                           ; 1AC3 0D 2F 55                 ./U
        .byte   $2F                             ; 1AC6 2F                       /
        adc     $6B,x                           ; 1AC7 75 6B                    uk
        .byte   $57                             ; 1AC9 57                       W
        .byte   $7F                             ; 1ACA 7F                       .
        .byte   $7F                             ; 1ACB 7F                       .
        .byte   $3F                             ; 1ACC 3F                       ?
        adc     $552F,x                         ; 1ACD 7D 2F 55                 }/U
        .byte   $2F                             ; 1AD0 2F                       /
        eor     $2F,x                           ; 1AD1 55 2F                    U/
        .byte   $5F                             ; 1AD3 5F                       _
        rol     $7E5C,x                         ; 1AD4 3E 5C 7E                 >\~
        ora     $7F7F                           ; 1AD7 0D 7F 7F                 ...
        .byte   $7F                             ; 1ADA 7F                       .
        .byte   $7F                             ; 1ADB 7F                       .
        .byte   $7F                             ; 1ADC 7F                       .
        .byte   $7F                             ; 1ADD 7F                       .
        .byte   $7F                             ; 1ADE 7F                       .
        .byte   $7F                             ; 1ADF 7F                       .
        .byte   $7F                             ; 1AE0 7F                       .
        .byte   $7F                             ; 1AE1 7F                       .
        .byte   $7F                             ; 1AE2 7F                       .
        .byte   $7F                             ; 1AE3 7F                       .
        .byte   $7F                             ; 1AE4 7F                       .
        .byte   $7F                             ; 1AE5 7F                       .
        .byte   $7F                             ; 1AE6 7F                       .
        .byte   $7F                             ; 1AE7 7F                       .
        .byte   $3F                             ; 1AE8 3F                       ?
        .byte   $5C                             ; 1AE9 5C                       \
        rol     a                               ; 1AEA 2A                       *
        ora     $752F                           ; 1AEB 0D 2F 75                 ./u
        .byte   $2F                             ; 1AEE 2F                       /
        adc     $6B,x                           ; 1AEF 75 6B                    uk
        .byte   $57                             ; 1AF1 57                       W
        .byte   $7F                             ; 1AF2 7F                       .
        .byte   $7F                             ; 1AF3 7F                       .
        .byte   $3F                             ; 1AF4 3F                       ?
        adc     $552F,x                         ; 1AF5 7D 2F 55                 }/U
        .byte   $3F                             ; 1AF8 3F                       ?
        eor     $2F,x                           ; 1AF9 55 2F                    U/
        .byte   $5F                             ; 1AFB 5F                       _
        rol     $7F5C,x                         ; 1AFC 3E 5C 7F                 >\.
        ora     $7F7F                           ; 1AFF 0D 7F 7F                 ...
        .byte   $7F                             ; 1B02 7F                       .
        .byte   $7F                             ; 1B03 7F                       .
        .byte   $7F                             ; 1B04 7F                       .
        .byte   $7F                             ; 1B05 7F                       .
        .byte   $7F                             ; 1B06 7F                       .
        .byte   $7F                             ; 1B07 7F                       .
        .byte   $7F                             ; 1B08 7F                       .
        .byte   $7F                             ; 1B09 7F                       .
        .byte   $7F                             ; 1B0A 7F                       .
        .byte   $7F                             ; 1B0B 7F                       .
        .byte   $7F                             ; 1B0C 7F                       .
        .byte   $7F                             ; 1B0D 7F                       .
        .byte   $7F                             ; 1B0E 7F                       .
        .byte   $7F                             ; 1B0F 7F                       .
        .byte   $3F                             ; 1B10 3F                       ?
        .byte   $5C                             ; 1B11 5C                       \
        rol     a                               ; 1B12 2A                       *
        ora     $7F7F                           ; 1B13 0D 7F 7F                 ...
        .byte   $7F                             ; 1B16 7F                       .
        .byte   $7F                             ; 1B17 7F                       .
        .byte   $7F                             ; 1B18 7F                       .
        .byte   $7F                             ; 1B19 7F                       .
        .byte   $7F                             ; 1B1A 7F                       .
        .byte   $7F                             ; 1B1B 7F                       .
        .byte   $7F                             ; 1B1C 7F                       .
        .byte   $7F                             ; 1B1D 7F                       .
        .byte   $7F                             ; 1B1E 7F                       .
        .byte   $7F                             ; 1B1F 7F                       .
        .byte   $7F                             ; 1B20 7F                       .
        .byte   $7F                             ; 1B21 7F                       .
        .byte   $7F                             ; 1B22 7F                       .
        .byte   $7F                             ; 1B23 7F                       .
        .byte   $3F                             ; 1B24 3F                       ?
        .byte   $5C                             ; 1B25 5C                       \
        rol     a                               ; 1B26 2A                       *
        ora     $00                             ; 1B27 05 00                    ..
        brk                                     ; 1B29 00                       .
        brk                                     ; 1B2A 00                       .
        brk                                     ; 1B2B 00                       .
        brk                                     ; 1B2C 00                       .
        brk                                     ; 1B2D 00                       .
        brk                                     ; 1B2E 00                       .
        brk                                     ; 1B2F 00                       .
L1B30:  brk                                     ; 1B30 00                       .
        brk                                     ; 1B31 00                       .
        brk                                     ; 1B32 00                       .
        brk                                     ; 1B33 00                       .
        brk                                     ; 1B34 00                       .
        brk                                     ; 1B35 00                       .
L1B36:  brk                                     ; 1B36 00                       .
        brk                                     ; 1B37 00                       .
        brk                                     ; 1B38 00                       .
        brk                                     ; 1B39 00                       .
        .byte   $02                             ; 1B3A 02                       .
        .byte   $04                             ; 1B3B 04                       .
        .byte   $02                             ; 1B3C 02                       .
        sec                                     ; 1B3D 38                       8
        brk                                     ; 1B3E 00                       .
        brk                                     ; 1B3F 00                       .
        brk                                     ; 1B40 00                       .
        brk                                     ; 1B41 00                       .
        brk                                     ; 1B42 00                       .
        brk                                     ; 1B43 00                       .
        brk                                     ; 1B44 00                       .
        brk                                     ; 1B45 00                       .
        brk                                     ; 1B46 00                       .
        brk                                     ; 1B47 00                       .
        brk                                     ; 1B48 00                       .
        brk                                     ; 1B49 00                       .
        asl     $1C                             ; 1B4A 06 1C                    ..
        rti                                     ; 1B4C 40                       @

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 1B4D 7F                       .
        .byte   $02                             ; 1B4E 02                       .
        brk                                     ; 1B4F 00                       .
        .byte   $02                             ; 1B50 02                       .
        brk                                     ; 1B51 00                       .
        brk                                     ; 1B52 00                       .
        brk                                     ; 1B53 00                       .
        brk                                     ; 1B54 00                       .
        brk                                     ; 1B55 00                       .
        brk                                     ; 1B56 00                       .
        brk                                     ; 1B57 00                       .
        brk                                     ; 1B58 00                       .
        brk                                     ; 1B59 00                       .
        brk                                     ; 1B5A 00                       .
        brk                                     ; 1B5B 00                       .
        brk                                     ; 1B5C 00                       .
        brk                                     ; 1B5D 00                       .
        brk                                     ; 1B5E 00                       .
        brk                                     ; 1B5F 00                       .
        rti                                     ; 1B60 40                       @

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 1B61 7F                       .
        brk                                     ; 1B62 00                       .
        brk                                     ; 1B63 00                       .
        .byte   $02                             ; 1B64 02                       .
        brk                                     ; 1B65 00                       .
        brk                                     ; 1B66 00                       .
        brk                                     ; 1B67 00                       .
        brk                                     ; 1B68 00                       .
        brk                                     ; 1B69 00                       .
        brk                                     ; 1B6A 00                       .
        brk                                     ; 1B6B 00                       .
        brk                                     ; 1B6C 00                       .
        brk                                     ; 1B6D 00                       .
        brk                                     ; 1B6E 00                       .
        brk                                     ; 1B6F 00                       .
        brk                                     ; 1B70 00                       .
        brk                                     ; 1B71 00                       .
        brk                                     ; 1B72 00                       .
        brk                                     ; 1B73 00                       .
        rti                                     ; 1B74 40                       @

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 1B75 7F                       .
        brk                                     ; 1B76 00                       .
        brk                                     ; 1B77 00                       .
        .byte   $02                             ; 1B78 02                       .
        brk                                     ; 1B79 00                       .
        brk                                     ; 1B7A 00                       .
        brk                                     ; 1B7B 00                       .
        brk                                     ; 1B7C 00                       .
        brk                                     ; 1B7D 00                       .
        brk                                     ; 1B7E 00                       .
        brk                                     ; 1B7F 00                       .
        brk                                     ; 1B80 00                       .
        brk                                     ; 1B81 00                       .
        brk                                     ; 1B82 00                       .
        brk                                     ; 1B83 00                       .
        brk                                     ; 1B84 00                       .
        brk                                     ; 1B85 00                       .
        brk                                     ; 1B86 00                       .
        brk                                     ; 1B87 00                       .
        rti                                     ; 1B88 40                       @

; ----------------------------------------------------------------------------
        .byte   $7F                             ; 1B89 7F                       .
        brk                                     ; 1B8A 00                       .
        brk                                     ; 1B8B 00                       .
        .byte   $02                             ; 1B8C 02                       .
        brk                                     ; 1B8D 00                       .
        brk                                     ; 1B8E 00                       .
        brk                                     ; 1B8F 00                       .
        brk                                     ; 1B90 00                       .
        brk                                     ; 1B91 00                       .
        brk                                     ; 1B92 00                       .
        brk                                     ; 1B93 00                       .
        brk                                     ; 1B94 00                       .
        brk                                     ; 1B95 00                       .
        brk                                     ; 1B96 00                       .
        brk                                     ; 1B97 00                       .
        brk                                     ; 1B98 00                       .
        brk                                     ; 1B99 00                       .
        brk                                     ; 1B9A 00                       .
        brk                                     ; 1B9B 00                       .
        brk                                     ; 1B9C 00                       .
        brk                                     ; 1B9D 00                       .
        brk                                     ; 1B9E 00                       .
        brk                                     ; 1B9F 00                       .
        .byte   $14                             ; 1BA0 14                       .
        .byte   $17                             ; 1BA1 17                       .
        ror     $7F7F,x                         ; 1BA2 7E 7F 7F                 ~..
        .byte   $7F                             ; 1BA5 7F                       .
        .byte   $7F                             ; 1BA6 7F                       .
        .byte   $7F                             ; 1BA7 7F                       .
        .byte   $7F                             ; 1BA8 7F                       .
        .byte   $7F                             ; 1BA9 7F                       .
        .byte   $7F                             ; 1BAA 7F                       .
        .byte   $7F                             ; 1BAB 7F                       .
        .byte   $7F                             ; 1BAC 7F                       .
        .byte   $7F                             ; 1BAD 7F                       .
        .byte   $7F                             ; 1BAE 7F                       .
        .byte   $7F                             ; 1BAF 7F                       .
        .byte   $7F                             ; 1BB0 7F                       .
        .byte   $7F                             ; 1BB1 7F                       .
        .byte   $7F                             ; 1BB2 7F                       .
        clc                                     ; 1BB3 18                       .
        brk                                     ; 1BB4 00                       .
        brk                                     ; 1BB5 00                       .
        ror     $7F7F,x                         ; 1BB6 7E 7F 7F                 ~..
        .byte   $7F                             ; 1BB9 7F                       .
        .byte   $7F                             ; 1BBA 7F                       .
        .byte   $7F                             ; 1BBB 7F                       .
        .byte   $7F                             ; 1BBC 7F                       .
        .byte   $7F                             ; 1BBD 7F                       .
        .byte   $7F                             ; 1BBE 7F                       .
        .byte   $7F                             ; 1BBF 7F                       .
        .byte   $7F                             ; 1BC0 7F                       .
        .byte   $7F                             ; 1BC1 7F                       .
        .byte   $7F                             ; 1BC2 7F                       .
        .byte   $7F                             ; 1BC3 7F                       .
        .byte   $7F                             ; 1BC4 7F                       .
        .byte   $7F                             ; 1BC5 7F                       .
        .byte   $7F                             ; 1BC6 7F                       .
        clc                                     ; 1BC7 18                       .
        brk                                     ; 1BC8 00                       .
        brk                                     ; 1BC9 00                       .
        ror     $5F2A,x                         ; 1BCA 7E 2A 5F                 ~*_
        ror     a                               ; 1BCD 6A                       j
        .byte   $57                             ; 1BCE 57                       W
        ror     a                               ; 1BCF 6A                       j
        .byte   $7F                             ; 1BD0 7F                       .
        .byte   $7F                             ; 1BD1 7F                       .
        .byte   $57                             ; 1BD2 57                       W
        rol     a                               ; 1BD3 2A                       *
        .byte   $5F                             ; 1BD4 5F                       _
        rol     a                               ; 1BD5 2A                       *
        .byte   $7F                             ; 1BD6 7F                       .
        rol     a                               ; 1BD7 2A                       *
        .byte   $5F                             ; 1BD8 5F                       _
        rol     L187D,x                         ; 1BD9 3E 7D 18                 >}.
        eor     $02,x                           ; 1BDC 55 02                    U.
        ror     $7F7F,x                         ; 1BDE 7E 7F 7F                 ~..
        .byte   $7F                             ; 1BE1 7F                       .
        .byte   $7F                             ; 1BE2 7F                       .
        .byte   $7F                             ; 1BE3 7F                       .
        .byte   $7F                             ; 1BE4 7F                       .
        .byte   $7F                             ; 1BE5 7F                       .
        .byte   $7F                             ; 1BE6 7F                       .
        .byte   $7F                             ; 1BE7 7F                       .
        .byte   $7F                             ; 1BE8 7F                       .
        .byte   $7F                             ; 1BE9 7F                       .
        .byte   $7F                             ; 1BEA 7F                       .
        .byte   $7F                             ; 1BEB 7F                       .
        .byte   $7F                             ; 1BEC 7F                       .
        .byte   $7F                             ; 1BED 7F                       .
        .byte   $7F                             ; 1BEE 7F                       .
        clc                                     ; 1BEF 18                       .
        eor     $0A,x                           ; 1BF0 55 0A                    U.
        lsr     $5F2A,x                         ; 1BF2 5E 2A 5F                 ^*_
        ror     a                               ; 1BF5 6A                       j
        .byte   $57                             ; 1BF6 57                       W
        rol     a                               ; 1BF7 2A                       *
        .byte   $7F                             ; 1BF8 7F                       .
        .byte   $7F                             ; 1BF9 7F                       .
        .byte   $57                             ; 1BFA 57                       W
        rol     a                               ; 1BFB 2A                       *
        .byte   $5F                             ; 1BFC 5F                       _
        rol     a                               ; 1BFD 2A                       *
        .byte   $5F                             ; 1BFE 5F                       _
        rol     a                               ; 1BFF 2A                       *
        .byte   $5F                             ; 1C00 5F                       _
        rol     L187D,x                         ; 1C01 3E 7D 18                 >}.
        ora     $08,x                           ; 1C04 15 08                    ..
        ror     $7F7F,x                         ; 1C06 7E 7F 7F                 ~..
        .byte   $7F                             ; 1C09 7F                       .
        .byte   $7F                             ; 1C0A 7F                       .
        .byte   $7F                             ; 1C0B 7F                       .
        .byte   $7F                             ; 1C0C 7F                       .
        .byte   $7F                             ; 1C0D 7F                       .
        .byte   $7F                             ; 1C0E 7F                       .
        .byte   $7F                             ; 1C0F 7F                       .
        .byte   $7F                             ; 1C10 7F                       .
        .byte   $7F                             ; 1C11 7F                       .
        .byte   $7F                             ; 1C12 7F                       .
        .byte   $7F                             ; 1C13 7F                       .
        .byte   $7F                             ; 1C14 7F                       .
        .byte   $7F                             ; 1C15 7F                       .
        .byte   $7F                             ; 1C16 7F                       .
        brk                                     ; 1C17 00                       .
        ora     $08,x                           ; 1C18 15 08                    ..
        lsr     $7F7E,x                         ; 1C1A 5E 7E 7F                 ^~.
        .byte   $7A                             ; 1C1D 7A                       z
        .byte   $57                             ; 1C1E 57                       W
        .byte   $2F                             ; 1C1F 2F                       /
        .byte   $7F                             ; 1C20 7F                       .
        .byte   $7F                             ; 1C21 7F                       .
        .byte   $7F                             ; 1C22 7F                       .
        .byte   $7A                             ; 1C23 7A                       z
        .byte   $5F                             ; 1C24 5F                       _
        ror     $7E5F,x                         ; 1C25 7E 5F 7E                 ~_~
        .byte   $5F                             ; 1C28 5F                       _
        rol     a                               ; 1C29 2A                       *
        adc     L1538,x                         ; 1C2A 7D 38 15                 }8.
        php                                     ; 1C2D 08                       .
        ror     $7F7F,x                         ; 1C2E 7E 7F 7F                 ~..
        .byte   $7F                             ; 1C31 7F                       .
        .byte   $7F                             ; 1C32 7F                       .
        .byte   $7F                             ; 1C33 7F                       .
        .byte   $7F                             ; 1C34 7F                       .
        .byte   $7F                             ; 1C35 7F                       .
        .byte   $7F                             ; 1C36 7F                       .
        .byte   $7F                             ; 1C37 7F                       .
        .byte   $7F                             ; 1C38 7F                       .
        .byte   $7F                             ; 1C39 7F                       .
        .byte   $7F                             ; 1C3A 7F                       .
        .byte   $7F                             ; 1C3B 7F                       .
        .byte   $7F                             ; 1C3C 7F                       .
        .byte   $7F                             ; 1C3D 7F                       .
        .byte   $7F                             ; 1C3E 7F                       .
        sec                                     ; 1C3F 38                       8
        ora     $08,x                           ; 1C40 15 08                    ..
        ror     $7F6A,x                         ; 1C42 7E 6A 7F                 ~j.
        .byte   $7A                             ; 1C45 7A                       z
        .byte   $57                             ; 1C46 57                       W
        rol     a                               ; 1C47 2A                       *
        .byte   $7F                             ; 1C48 7F                       .
        rol     a                               ; 1C49 2A                       *
        .byte   $7F                             ; 1C4A 7F                       .
        .byte   $7A                             ; 1C4B 7A                       z
        .byte   $5F                             ; 1C4C 5F                       _
        ror     a                               ; 1C4D 6A                       j
        .byte   $5F                             ; 1C4E 5F                       _
        ror     $2A5F,x                         ; 1C4F 7E 5F 2A                 ~_*
        adc     $5538,x                         ; 1C52 7D 38 55                 }8U
        .byte   $1A                             ; 1C55 1A                       .
        ror     $7F7F,x                         ; 1C56 7E 7F 7F                 ~..
        .byte   $7F                             ; 1C59 7F                       .
        .byte   $7F                             ; 1C5A 7F                       .
        .byte   $7F                             ; 1C5B 7F                       .
        .byte   $7F                             ; 1C5C 7F                       .
        .byte   $7F                             ; 1C5D 7F                       .
        .byte   $7F                             ; 1C5E 7F                       .
        .byte   $7F                             ; 1C5F 7F                       .
        .byte   $7F                             ; 1C60 7F                       .
        .byte   $7F                             ; 1C61 7F                       .
        .byte   $7F                             ; 1C62 7F                       .
        .byte   $7F                             ; 1C63 7F                       .
        .byte   $7F                             ; 1C64 7F                       .
        .byte   $7F                             ; 1C65 7F                       .
        .byte   $7F                             ; 1C66 7F                       .
        sec                                     ; 1C67 38                       8
        eor     $1A,x                           ; 1C68 55 1A                    U.
        ror     $7F2F,x                         ; 1C6A 7E 2F 7F                 ~/.
        .byte   $7A                             ; 1C6D 7A                       z
        .byte   $57                             ; 1C6E 57                       W
        .byte   $6B                             ; 1C6F 6B                       k
        .byte   $7F                             ; 1C70 7F                       .
        .byte   $7F                             ; 1C71 7F                       .
        .byte   $7F                             ; 1C72 7F                       .
        .byte   $7A                             ; 1C73 7A                       z
        .byte   $5F                             ; 1C74 5F                       _
        ror     $7E5F,x                         ; 1C75 7E 5F 7E                 ~_~
        .byte   $5F                             ; 1C78 5F                       _
        rol     $387D,x                         ; 1C79 3E 7D 38                 >}8
        adc     $1B,x                           ; 1C7C 75 1B                    u.
        ror     $7F7F,x                         ; 1C7E 7E 7F 7F                 ~..
        .byte   $7F                             ; 1C81 7F                       .
        .byte   $7F                             ; 1C82 7F                       .
        .byte   $7F                             ; 1C83 7F                       .
        .byte   $7F                             ; 1C84 7F                       .
        .byte   $7F                             ; 1C85 7F                       .
        .byte   $7F                             ; 1C86 7F                       .
        .byte   $7F                             ; 1C87 7F                       .
        .byte   $7F                             ; 1C88 7F                       .
        .byte   $7F                             ; 1C89 7F                       .
        .byte   $7F                             ; 1C8A 7F                       .
        .byte   $7F                             ; 1C8B 7F                       .
        .byte   $7F                             ; 1C8C 7F                       .
        .byte   $7F                             ; 1C8D 7F                       .
        .byte   $7F                             ; 1C8E 7F                       .
        sec                                     ; 1C8F 38                       8
        eor     $1A,x                           ; 1C90 55 1A                    U.
        lsr     $5F2A,x                         ; 1C92 5E 2A 5F                 ^*_
        ror     a                               ; 1C95 6A                       j
        .byte   $57                             ; 1C96 57                       W
        .byte   $2F                             ; 1C97 2F                       /
        .byte   $7F                             ; 1C98 7F                       .
        .byte   $7F                             ; 1C99 7F                       .
        .byte   $7F                             ; 1C9A 7F                       .
        .byte   $7A                             ; 1C9B 7A                       z
        .byte   $5F                             ; 1C9C 5F                       _
        rol     a                               ; 1C9D 2A                       *
        .byte   $5F                             ; 1C9E 5F                       _
        rol     a                               ; 1C9F 2A                       *
        .byte   $5F                             ; 1CA0 5F                       _
        rol     $387D,x                         ; 1CA1 3E 7D 38                 >}8
        adc     $7E1B,x                         ; 1CA4 7D 1B 7E                 }.~
        .byte   $7F                             ; 1CA7 7F                       .
        .byte   $7F                             ; 1CA8 7F                       .
        .byte   $7F                             ; 1CA9 7F                       .
        .byte   $7F                             ; 1CAA 7F                       .
        .byte   $7F                             ; 1CAB 7F                       .
        .byte   $7F                             ; 1CAC 7F                       .
        .byte   $7F                             ; 1CAD 7F                       .
        .byte   $7F                             ; 1CAE 7F                       .
        .byte   $7F                             ; 1CAF 7F                       .
        .byte   $7F                             ; 1CB0 7F                       .
        .byte   $7F                             ; 1CB1 7F                       .
        .byte   $7F                             ; 1CB2 7F                       .
        .byte   $7F                             ; 1CB3 7F                       .
        .byte   $7F                             ; 1CB4 7F                       .
        .byte   $7F                             ; 1CB5 7F                       .
        .byte   $7F                             ; 1CB6 7F                       .
        sec                                     ; 1CB7 38                       8
        eor     $1A,x                           ; 1CB8 55 1A                    U.
        lsr     $5F6A,x                         ; 1CBA 5E 6A 5F                 ^j_
        ror     a                               ; 1CBD 6A                       j
        .byte   $57                             ; 1CBE 57                       W
        .byte   $2F                             ; 1CBF 2F                       /
        .byte   $7F                             ; 1CC0 7F                       .
        .byte   $7F                             ; 1CC1 7F                       .
        .byte   $7F                             ; 1CC2 7F                       .
        .byte   $7A                             ; 1CC3 7A                       z
        .byte   $5F                             ; 1CC4 5F                       _
        rol     a                               ; 1CC5 2A                       *
        .byte   $7F                             ; 1CC6 7F                       .
        rol     a                               ; 1CC7 2A                       *
        .byte   $5F                             ; 1CC8 5F                       _
        rol     $387D,x                         ; 1CC9 3E 7D 38                 >}8
        .byte   $7F                             ; 1CCC 7F                       .
        .byte   $1B                             ; 1CCD 1B                       .
        ror     $7F7F,x                         ; 1CCE 7E 7F 7F                 ~..
        .byte   $7F                             ; 1CD1 7F                       .
        .byte   $7F                             ; 1CD2 7F                       .
        .byte   $7F                             ; 1CD3 7F                       .
        .byte   $7F                             ; 1CD4 7F                       .
        .byte   $7F                             ; 1CD5 7F                       .
        .byte   $7F                             ; 1CD6 7F                       .
        .byte   $7F                             ; 1CD7 7F                       .
        .byte   $7F                             ; 1CD8 7F                       .
        .byte   $7F                             ; 1CD9 7F                       .
        .byte   $7F                             ; 1CDA 7F                       .
        .byte   $7F                             ; 1CDB 7F                       .
        .byte   $7F                             ; 1CDC 7F                       .
        .byte   $7F                             ; 1CDD 7F                       .
        .byte   $7F                             ; 1CDE 7F                       .
        sec                                     ; 1CDF 38                       8
        eor     $1A,x                           ; 1CE0 55 1A                    U.
        ror     $7F7F,x                         ; 1CE2 7E 7F 7F                 ~..
        .byte   $7F                             ; 1CE5 7F                       .
        .byte   $7F                             ; 1CE6 7F                       .
        .byte   $7F                             ; 1CE7 7F                       .
        .byte   $7F                             ; 1CE8 7F                       .
        .byte   $7F                             ; 1CE9 7F                       .
        .byte   $7F                             ; 1CEA 7F                       .
        .byte   $7F                             ; 1CEB 7F                       .
        .byte   $7F                             ; 1CEC 7F                       .
        .byte   $7F                             ; 1CED 7F                       .
        .byte   $7F                             ; 1CEE 7F                       .
        .byte   $7F                             ; 1CEF 7F                       .
        .byte   $7F                             ; 1CF0 7F                       .
        .byte   $7F                             ; 1CF1 7F                       .
        .byte   $7F                             ; 1CF2 7F                       .
        sec                                     ; 1CF3 38                       8
        eor     $0A,x                           ; 1CF4 55 0A                    U.
        brk                                     ; 1CF6 00                       .
        brk                                     ; 1CF7 00                       .
        brk                                     ; 1CF8 00                       .
        brk                                     ; 1CF9 00                       .
        brk                                     ; 1CFA 00                       .
        brk                                     ; 1CFB 00                       .
        brk                                     ; 1CFC 00                       .
        brk                                     ; 1CFD 00                       .
        brk                                     ; 1CFE 00                       .
        brk                                     ; 1CFF 00                       .
        brk                                     ; 1D00 00                       .
        brk                                     ; 1D01 00                       .
        brk                                     ; 1D02 00                       .
        brk                                     ; 1D03 00                       .
        brk                                     ; 1D04 00                       .
        brk                                     ; 1D05 00                       .
        brk                                     ; 1D06 00                       .
        brk                                     ; 1D07 00                       .
        .byte   $04                             ; 1D08 04                       .
        php                                     ; 1D09 08                       .
        .byte   $04                             ; 1D0A 04                       .
        bvs     L1D0D                           ; 1D0B 70 00                    p.
L1D0D:  brk                                     ; 1D0D 00                       .
        brk                                     ; 1D0E 00                       .
        brk                                     ; 1D0F 00                       .
        brk                                     ; 1D10 00                       .
        brk                                     ; 1D11 00                       .
        brk                                     ; 1D12 00                       .
        brk                                     ; 1D13 00                       .
        brk                                     ; 1D14 00                       .
        brk                                     ; 1D15 00                       .
        brk                                     ; 1D16 00                       .
        brk                                     ; 1D17 00                       .
        .byte   $0C                             ; 1D18 0C                       .
        sec                                     ; 1D19 38                       8
        brk                                     ; 1D1A 00                       .
        .byte   $7F                             ; 1D1B 7F                       .
        ora     $00                             ; 1D1C 05 00                    ..
        .byte   $04                             ; 1D1E 04                       .
        brk                                     ; 1D1F 00                       .
        brk                                     ; 1D20 00                       .
        brk                                     ; 1D21 00                       .
        brk                                     ; 1D22 00                       .
        brk                                     ; 1D23 00                       .
        brk                                     ; 1D24 00                       .
        brk                                     ; 1D25 00                       .
        brk                                     ; 1D26 00                       .
        brk                                     ; 1D27 00                       .
        brk                                     ; 1D28 00                       .
        brk                                     ; 1D29 00                       .
        brk                                     ; 1D2A 00                       .
        brk                                     ; 1D2B 00                       .
        brk                                     ; 1D2C 00                       .
        brk                                     ; 1D2D 00                       .
        brk                                     ; 1D2E 00                       .
        .byte   $7F                             ; 1D2F 7F                       .
        ora     ($00,x)                         ; 1D30 01 00                    ..
        .byte   $04                             ; 1D32 04                       .
        brk                                     ; 1D33 00                       .
        brk                                     ; 1D34 00                       .
        brk                                     ; 1D35 00                       .
        brk                                     ; 1D36 00                       .
        brk                                     ; 1D37 00                       .
        brk                                     ; 1D38 00                       .
        brk                                     ; 1D39 00                       .
        brk                                     ; 1D3A 00                       .
        brk                                     ; 1D3B 00                       .
        brk                                     ; 1D3C 00                       .
        brk                                     ; 1D3D 00                       .
        brk                                     ; 1D3E 00                       .
        brk                                     ; 1D3F 00                       .
        brk                                     ; 1D40 00                       .
        brk                                     ; 1D41 00                       .
        brk                                     ; 1D42 00                       .
        .byte   $7F                             ; 1D43 7F                       .
        ora     ($00,x)                         ; 1D44 01 00                    ..
        .byte   $04                             ; 1D46 04                       .
        brk                                     ; 1D47 00                       .
        brk                                     ; 1D48 00                       .
        brk                                     ; 1D49 00                       .
        brk                                     ; 1D4A 00                       .
        brk                                     ; 1D4B 00                       .
        brk                                     ; 1D4C 00                       .
        brk                                     ; 1D4D 00                       .
        brk                                     ; 1D4E 00                       .
        brk                                     ; 1D4F 00                       .
        brk                                     ; 1D50 00                       .
        brk                                     ; 1D51 00                       .
        brk                                     ; 1D52 00                       .
        brk                                     ; 1D53 00                       .
        brk                                     ; 1D54 00                       .
        brk                                     ; 1D55 00                       .
        brk                                     ; 1D56 00                       .
        .byte   $7F                             ; 1D57 7F                       .
        ora     ($00,x)                         ; 1D58 01 00                    ..
        .byte   $04                             ; 1D5A 04                       .
        brk                                     ; 1D5B 00                       .
        brk                                     ; 1D5C 00                       .
        brk                                     ; 1D5D 00                       .
        brk                                     ; 1D5E 00                       .
        brk                                     ; 1D5F 00                       .
        brk                                     ; 1D60 00                       .
        brk                                     ; 1D61 00                       .
        brk                                     ; 1D62 00                       .
        brk                                     ; 1D63 00                       .
        brk                                     ; 1D64 00                       .
        brk                                     ; 1D65 00                       .
        brk                                     ; 1D66 00                       .
        brk                                     ; 1D67 00                       .
        brk                                     ; 1D68 00                       .
        brk                                     ; 1D69 00                       .
        brk                                     ; 1D6A 00                       .
        brk                                     ; 1D6B 00                       .
        brk                                     ; 1D6C 00                       .
        brk                                     ; 1D6D 00                       .
        .byte   $03                             ; 1D6E 03                       .
        .byte   $07                             ; 1D6F 07                       .
        brk                                     ; 1D70 00                       .
        brk                                     ; 1D71 00                       .
        brk                                     ; 1D72 00                       .
        rts                                     ; 1D73 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1D74 03                       .
        .byte   $0F                             ; 1D75 0F                       .
        bmi     L1DBE                           ; 1D76 30 46                    0F
        ora     $6D58,y                         ; 1D78 19 58 6D                 .Xm
        rol     $58,x                           ; 1D7B 36 58                    6X
        adc     $3036                           ; 1D7D 6D 36 30                 m60
        lsr     $19                             ; 1D80 46 19                    F.
        rts                                     ; 1D82 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1D83 03                       .
        .byte   $0F                             ; 1D84 0F                       .
        .byte   $03                             ; 1D85 03                       .
        .byte   $07                             ; 1D86 07                       .
        brk                                     ; 1D87 00                       .
        brk                                     ; 1D88 00                       .
        brk                                     ; 1D89 00                       .
        rti                                     ; 1D8A 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 1D8B 07                       .
        asl     L0C60,x                         ; 1D8C 1E 60 0C                 .`.
        .byte   $33                             ; 1D8F 33                       3
        bmi     L1DED                           ; 1D90 30 5B                    0[
        adc     $5B30                           ; 1D92 6D 30 5B                 m0[
        adc     L0C60                           ; 1D95 6D 60 0C                 m`.
        .byte   $33                             ; 1D98 33                       3
        rti                                     ; 1D99 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 1D9A 07                       .
        asl     $0703,x                         ; 1D9B 1E 03 07                 ...
        brk                                     ; 1D9E 00                       .
        brk                                     ; 1D9F 00                       .
        .byte   $0F                             ; 1DA0 0F                       .
        rts                                     ; 1DA1 60                       `

; ----------------------------------------------------------------------------
        .byte   $43                             ; 1DA2 43                       C
        ora     $6630,y                         ; 1DA3 19 30 66                 .0f
        rol     $58,x                           ; 1DA6 36 58                    6X
        adc     $5836                           ; 1DA8 6D 36 58                 m6X
        eor     $3019                           ; 1DAB 4D 19 30                 M.0
        asl     $0F                             ; 1DAE 06 0F                    ..
        rts                                     ; 1DB0 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1DB1 03                       .
        brk                                     ; 1DB2 00                       .
        .byte   $03                             ; 1DB3 03                       .
        .byte   $07                             ; 1DB4 07                       .
        brk                                     ; 1DB5 00                       .
        brk                                     ; 1DB6 00                       .
        asl     $0740,x                         ; 1DB7 1E 40 07                 .@.
        .byte   $33                             ; 1DBA 33                       3
        rts                                     ; 1DBB 60                       `

; ----------------------------------------------------------------------------
        .byte   $4C                             ; 1DBC 4C                       L
        .byte   $6D                             ; 1DBD 6D                       m
L1DBE:  bmi     L1E1B                           ; 1DBE 30 5B                    0[
        adc     L1B30                           ; 1DC0 6D 30 1B                 m0.
        .byte   $33                             ; 1DC3 33                       3
        rts                                     ; 1DC4 60                       `

; ----------------------------------------------------------------------------
        .byte   $0C                             ; 1DC5 0C                       .
        asl     $0740,x                         ; 1DC6 1E 40 07                 .@.
        brk                                     ; 1DC9 00                       .
        .byte   $03                             ; 1DCA 03                       .
        .byte   $07                             ; 1DCB 07                       .
        rts                                     ; 1DCC 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1DCD 03                       .
        brk                                     ; 1DCE 00                       .
        bmi     L1DD7                           ; 1DCF 30 06                    0.
        .byte   $0F                             ; 1DD1 0F                       .
        cli                                     ; 1DD2 58                       X
        eor     $5819                           ; 1DD3 4D 19 58                 M.X
        .byte   $6D                             ; 1DD6 6D                       m
L1DD7:  rol     $30,x                           ; 1DD7 36 30                    60
        ror     $36                             ; 1DD9 66 36                    f6
        rts                                     ; 1DDB 60                       `

; ----------------------------------------------------------------------------
        .byte   $43                             ; 1DDC 43                       C
        ora     $00,y                           ; 1DDD 19 00 00                 ...
        .byte   $0F                             ; 1DE0 0F                       .
        .byte   $03                             ; 1DE1 03                       .
        .byte   $07                             ; 1DE2 07                       .
        rti                                     ; 1DE3 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 1DE4 07                       .
        brk                                     ; 1DE5 00                       .
        rts                                     ; 1DE6 60                       `

; ----------------------------------------------------------------------------
        .byte   $0C                             ; 1DE7 0C                       .
        asl     L1B30,x                         ; 1DE8 1E 30 1B                 .0.
        .byte   $33                             ; 1DEB 33                       3
        .byte   $30                             ; 1DEC 30                       0
L1DED:  .byte   $5B                             ; 1DED 5B                       [
        adc     $4C60                           ; 1DEE 6D 60 4C                 m`L
        adc     $0740                           ; 1DF1 6D 40 07                 m@.
        .byte   $33                             ; 1DF4 33                       3
        brk                                     ; 1DF5 00                       .
        brk                                     ; 1DF6 00                       .
        asl     $0703,x                         ; 1DF7 1E 03 07                 ...
        brk                                     ; 1DFA 00                       .
        brk                                     ; 1DFB 00                       .
        brk                                     ; 1DFC 00                       .
        bvs     L1E40                           ; 1DFD 70 41                    pA
        .byte   $07                             ; 1DFF 07                       .
L1E00:  clc                                     ; 1E00 18                       .
        .byte   $63                             ; 1E01 63                       c
        .byte   $0C                             ; 1E02 0C                       .
        jmp     (L1B36)                         ; 1E03 6C 36 1B                 l6.

; ----------------------------------------------------------------------------
        jmp     (L1B36)                         ; 1E06 6C 36 1B                 l6.

; ----------------------------------------------------------------------------
        clc                                     ; 1E09 18                       .
        .byte   $63                             ; 1E0A 63                       c
        .byte   $0C                             ; 1E0B 0C                       .
L1E0C:  bvs     L1E4F                           ; 1E0C 70 41                    pA
        .byte   $07                             ; 1E0E 07                       .
        .byte   $03                             ; 1E0F 03                       .
        .byte   $07                             ; 1E10 07                       .
        brk                                     ; 1E11 00                       .
        brk                                     ; 1E12 00                       .
        brk                                     ; 1E13 00                       .
        rts                                     ; 1E14 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1E15 03                       .
        .byte   $0F                             ; 1E16 0F                       .
        bmi     L1E5F                           ; 1E17 30 46                    0F
        .byte   $19                             ; 1E19 19                       .
        cli                                     ; 1E1A 58                       X
L1E1B:  adc     $5836                           ; 1E1B 6D 36 58                 m6X
        adc     $3036                           ; 1E1E 6D 36 30                 m60
        lsr     $19                             ; 1E21 46 19                    F.
        rts                                     ; 1E23 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1E24 03                       .
        .byte   $0F                             ; 1E25 0F                       .
        .byte   $03                             ; 1E26 03                       .
        .byte   $07                             ; 1E27 07                       .
        brk                                     ; 1E28 00                       .
        rti                                     ; 1E29 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 1E2A 07                       .
        bvs     L1E8E                           ; 1E2B 70 61                    pa
        .byte   $0C                             ; 1E2D 0C                       .
        clc                                     ; 1E2E 18                       .
        .byte   $33                             ; 1E2F 33                       3
        .byte   $1B                             ; 1E30 1B                       .
        jmp     (L1B36)                         ; 1E31 6C 36 1B                 l6.

; ----------------------------------------------------------------------------
        jmp     (L0C66)                         ; 1E34 6C 66 0C                 lf.

; ----------------------------------------------------------------------------
        clc                                     ; 1E37 18                       .
        .byte   $43                             ; 1E38 43                       C
        .byte   $07                             ; 1E39 07                       .
        bvs     L1E3D                           ; 1E3A 70 01                    p.
        brk                                     ; 1E3C 00                       .
L1E3D:  .byte   $03                             ; 1E3D 03                       .
        .byte   $07                             ; 1E3E 07                       .
        brk                                     ; 1E3F 00                       .
L1E40:  brk                                     ; 1E40 00                       .
        .byte   $0F                             ; 1E41 0F                       .
        rts                                     ; 1E42 60                       `

; ----------------------------------------------------------------------------
        .byte   $43                             ; 1E43 43                       C
        ora     $6630,y                         ; 1E44 19 30 66                 .0f
        rol     $58,x                           ; 1E47 36 58                    6X
        adc     $5836                           ; 1E49 6D 36 58                 m6X
        eor     $3019                           ; 1E4C 4D 19 30                 M.0
L1E4F:  asl     $0F                             ; 1E4F 06 0F                    ..
        rts                                     ; 1E51 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1E52 03                       .
        brk                                     ; 1E53 00                       .
        .byte   $03                             ; 1E54 03                       .
        .byte   $07                             ; 1E55 07                       .
        bvs     L1E59                           ; 1E56 70 01                    p.
        brk                                     ; 1E58 00                       .
L1E59:  clc                                     ; 1E59 18                       .
        .byte   $43                             ; 1E5A 43                       C
        .byte   $07                             ; 1E5B 07                       .
        jmp     (L0C66)                         ; 1E5C 6C 66 0C                 lf.

; ----------------------------------------------------------------------------
L1E5F:  jmp     (L1B36)                         ; 1E5F 6C 36 1B                 l6.

; ----------------------------------------------------------------------------
        clc                                     ; 1E62 18                       .
        .byte   $33                             ; 1E63 33                       3
        .byte   $1B                             ; 1E64 1B                       .
        bvs     L1EC8                           ; 1E65 70 61                    pa
        .byte   $0C                             ; 1E67 0C                       .
        brk                                     ; 1E68 00                       .
        rti                                     ; 1E69 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 1E6A 07                       .
        .byte   $03                             ; 1E6B 03                       .
        .byte   $07                             ; 1E6C 07                       .
        rts                                     ; 1E6D 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1E6E 03                       .
        brk                                     ; 1E6F 00                       .
        bmi     L1E78                           ; 1E70 30 06                    0.
        .byte   $0F                             ; 1E72 0F                       .
        cli                                     ; 1E73 58                       X
        eor     $5819                           ; 1E74 4D 19 58                 M.X
        .byte   $6D                             ; 1E77 6D                       m
L1E78:  rol     $30,x                           ; 1E78 36 30                    60
        ror     $36                             ; 1E7A 66 36                    f6
        rts                                     ; 1E7C 60                       `

; ----------------------------------------------------------------------------
        .byte   $43                             ; 1E7D 43                       C
        ora     $00,y                           ; 1E7E 19 00 00                 ...
        .byte   $0F                             ; 1E81 0F                       .
        .byte   $02                             ; 1E82 02                       .
        .byte   $07                             ; 1E83 07                       .
        brk                                     ; 1E84 00                       .
        brk                                     ; 1E85 00                       .
        bvs     L1E89                           ; 1E86 70 01                    p.
        clc                                     ; 1E88 18                       .
L1E89:  .byte   $03                             ; 1E89 03                       .
        jmp     (L6C06)                         ; 1E8A 6C 06 6C                 l.l

; ----------------------------------------------------------------------------
        .byte   $06                             ; 1E8D 06                       .
L1E8E:  clc                                     ; 1E8E 18                       .
        .byte   $03                             ; 1E8F 03                       .
        bvs     L1E93                           ; 1E90 70 01                    p.
        .byte   $02                             ; 1E92 02                       .
L1E93:  .byte   $07                             ; 1E93 07                       .
        brk                                     ; 1E94 00                       .
        brk                                     ; 1E95 00                       .
        rts                                     ; 1E96 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1E97 03                       .
        bmi     L1EA0                           ; 1E98 30 06                    0.
        cli                                     ; 1E9A 58                       X
        ora     L0D58                           ; 1E9B 0D 58 0D                 .X.
        bmi     L1EA6                           ; 1E9E 30 06                    0.
L1EA0:  rts                                     ; 1EA0 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1EA1 03                       .
        .byte   $02                             ; 1EA2 02                       .
        .byte   $07                             ; 1EA3 07                       .
        bvs     L1EA7                           ; 1EA4 70 01                    p.
L1EA6:  clc                                     ; 1EA6 18                       .
L1EA7:  .byte   $03                             ; 1EA7 03                       .
        jmp     (L6C06)                         ; 1EA8 6C 06 6C                 l.l

; ----------------------------------------------------------------------------
        asl     $18                             ; 1EAB 06 18                    ..
        .byte   $03                             ; 1EAD 03                       .
        bvs     L1EB1                           ; 1EAE 70 01                    p.
        brk                                     ; 1EB0 00                       .
L1EB1:  brk                                     ; 1EB1 00                       .
        .byte   $02                             ; 1EB2 02                       .
        .byte   $07                             ; 1EB3 07                       .
        rts                                     ; 1EB4 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1EB5 03                       .
        bmi     L1EBE                           ; 1EB6 30 06                    0.
        cli                                     ; 1EB8 58                       X
        ora     L0D58                           ; 1EB9 0D 58 0D                 .X.
        bmi     L1EC4                           ; 1EBC 30 06                    0.
L1EBE:  rts                                     ; 1EBE 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1EBF 03                       .
        brk                                     ; 1EC0 00                       .
        brk                                     ; 1EC1 00                       .
        .byte   $02                             ; 1EC2 02                       .
        .byte   $02                             ; 1EC3 02                       .
L1EC4:  brk                                     ; 1EC4 00                       .
        .byte   $03                             ; 1EC5 03                       .
        brk                                     ; 1EC6 00                       .
        .byte   $06                             ; 1EC7 06                       .
L1EC8:  .byte   $02                             ; 1EC8 02                       .
        .byte   $02                             ; 1EC9 02                       .
        brk                                     ; 1ECA 00                       .
        asl     $00                             ; 1ECB 06 00                    ..
        .byte   $0C                             ; 1ECD 0C                       .
        .byte   $02                             ; 1ECE 02                       .
        .byte   $04                             ; 1ECF 04                       .
        brk                                     ; 1ED0 00                       .
        brk                                     ; 1ED1 00                       .
        brk                                     ; 1ED2 00                       .
        brk                                     ; 1ED3 00                       .
        brk                                     ; 1ED4 00                       .
        bmi     L1ED7                           ; 1ED5 30 00                    0.
L1ED7:  sec                                     ; 1ED7 38                       8
        .byte   $02                             ; 1ED8 02                       .
        .byte   $04                             ; 1ED9 04                       .
        brk                                     ; 1EDA 00                       .
        brk                                     ; 1EDB 00                       .
        brk                                     ; 1EDC 00                       .
        brk                                     ; 1EDD 00                       .
        brk                                     ; 1EDE 00                       .
        rts                                     ; 1EDF 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 1EE0 00                       .
        bvs     L1EE6                           ; 1EE1 70 03                    p.
        ora     $00                             ; 1EE3 05 00                    ..
        brk                                     ; 1EE5 00                       .
L1EE6:  brk                                     ; 1EE6 00                       .
        brk                                     ; 1EE7 00                       .
        brk                                     ; 1EE8 00                       .
        brk                                     ; 1EE9 00                       .
        brk                                     ; 1EEA 00                       .
        brk                                     ; 1EEB 00                       .
        .byte   $03                             ; 1EEC 03                       .
        brk                                     ; 1EED 00                       .
        rti                                     ; 1EEE 40                       @

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1EEF 03                       .
        brk                                     ; 1EF0 00                       .
        brk                                     ; 1EF1 00                       .
        .byte   $03                             ; 1EF2 03                       .
        .byte   $03                             ; 1EF3 03                       .
        ora     $00                             ; 1EF4 05 00                    ..
        brk                                     ; 1EF6 00                       .
        brk                                     ; 1EF7 00                       .
        brk                                     ; 1EF8 00                       .
        brk                                     ; 1EF9 00                       .
        brk                                     ; 1EFA 00                       .
        brk                                     ; 1EFB 00                       .
        brk                                     ; 1EFC 00                       .
        asl     $00                             ; 1EFD 06 00                    ..
        brk                                     ; 1EFF 00                       .
L1F00:  .byte   $07                             ; 1F00 07                       .
        brk                                     ; 1F01 00                       .
        brk                                     ; 1F02 00                       .
        asl     $03                             ; 1F03 06 03                    ..
        asl     $00                             ; 1F05 06 00                    ..
        brk                                     ; 1F07 00                       .
        brk                                     ; 1F08 00                       .
        brk                                     ; 1F09 00                       .
        brk                                     ; 1F0A 00                       .
        brk                                     ; 1F0B 00                       .
L1F0C:  brk                                     ; 1F0C 00                       .
        brk                                     ; 1F0D 00                       .
        brk                                     ; 1F0E 00                       .
        brk                                     ; 1F0F 00                       .
        brk                                     ; 1F10 00                       .
        .byte   $0C                             ; 1F11 0C                       .
        brk                                     ; 1F12 00                       .
        brk                                     ; 1F13 00                       .
        asl     a:$00                           ; 1F14 0E 00 00                 ...
        .byte   $1C                             ; 1F17 1C                       .
        .byte   $03                             ; 1F18 03                       .
        asl     $00                             ; 1F19 06 00                    ..
        brk                                     ; 1F1B 00                       .
        brk                                     ; 1F1C 00                       .
        brk                                     ; 1F1D 00                       .
        brk                                     ; 1F1E 00                       .
        brk                                     ; 1F1F 00                       .
        brk                                     ; 1F20 00                       .
        brk                                     ; 1F21 00                       .
        brk                                     ; 1F22 00                       .
        brk                                     ; 1F23 00                       .
        brk                                     ; 1F24 00                       .
        clc                                     ; 1F25 18                       .
        brk                                     ; 1F26 00                       .
        brk                                     ; 1F27 00                       .
        .byte   $1C                             ; 1F28 1C                       .
        brk                                     ; 1F29 00                       .
        brk                                     ; 1F2A 00                       .
        sec                                     ; 1F2B 38                       8
        .byte   $04                             ; 1F2C 04                       .
        php                                     ; 1F2D 08                       .
        brk                                     ; 1F2E 00                       .
        brk                                     ; 1F2F 00                       .
        brk                                     ; 1F30 00                       .
        brk                                     ; 1F31 00                       .
        brk                                     ; 1F32 00                       .
        brk                                     ; 1F33 00                       .
        brk                                     ; 1F34 00                       .
        brk                                     ; 1F35 00                       .
        brk                                     ; 1F36 00                       .
        brk                                     ; 1F37 00                       .
        brk                                     ; 1F38 00                       .
        brk                                     ; 1F39 00                       .
        brk                                     ; 1F3A 00                       .
        brk                                     ; 1F3B 00                       .
        brk                                     ; 1F3C 00                       .
        brk                                     ; 1F3D 00                       .
        brk                                     ; 1F3E 00                       .
        brk                                     ; 1F3F 00                       .
        brk                                     ; 1F40 00                       .
        brk                                     ; 1F41 00                       .
        brk                                     ; 1F42 00                       .
        brk                                     ; 1F43 00                       .
        rts                                     ; 1F44 60                       `

; ----------------------------------------------------------------------------
        ora     ($00,x)                         ; 1F45 01 00                    ..
        brk                                     ; 1F47 00                       .
        rts                                     ; 1F48 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1F49 03                       .
        brk                                     ; 1F4A 00                       .
        brk                                     ; 1F4B 00                       .
        rti                                     ; 1F4C 40                       @

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1F4D 03                       .
        .byte   $04                             ; 1F4E 04                       .
        php                                     ; 1F4F 08                       .
        brk                                     ; 1F50 00                       .
        brk                                     ; 1F51 00                       .
        brk                                     ; 1F52 00                       .
        brk                                     ; 1F53 00                       .
        brk                                     ; 1F54 00                       .
        brk                                     ; 1F55 00                       .
        brk                                     ; 1F56 00                       .
        brk                                     ; 1F57 00                       .
        brk                                     ; 1F58 00                       .
        brk                                     ; 1F59 00                       .
        brk                                     ; 1F5A 00                       .
        brk                                     ; 1F5B 00                       .
        brk                                     ; 1F5C 00                       .
        brk                                     ; 1F5D 00                       .
        brk                                     ; 1F5E 00                       .
        brk                                     ; 1F5F 00                       .
        brk                                     ; 1F60 00                       .
        brk                                     ; 1F61 00                       .
        brk                                     ; 1F62 00                       .
        brk                                     ; 1F63 00                       .
        brk                                     ; 1F64 00                       .
        brk                                     ; 1F65 00                       .
        rti                                     ; 1F66 40                       @

; ----------------------------------------------------------------------------
        .byte   $03                             ; 1F67 03                       .
        brk                                     ; 1F68 00                       .
        brk                                     ; 1F69 00                       .
        rti                                     ; 1F6A 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 1F6B 07                       .
        brk                                     ; 1F6C 00                       .
        brk                                     ; 1F6D 00                       .
        brk                                     ; 1F6E 00                       .
        .byte   $07                             ; 1F6F 07                       .
        .byte   $04                             ; 1F70 04                       .
        ora     #$00                            ; 1F71 09 00                    ..
        brk                                     ; 1F73 00                       .
        brk                                     ; 1F74 00                       .
        brk                                     ; 1F75 00                       .
        brk                                     ; 1F76 00                       .
        brk                                     ; 1F77 00                       .
        brk                                     ; 1F78 00                       .
        brk                                     ; 1F79 00                       .
        brk                                     ; 1F7A 00                       .
        brk                                     ; 1F7B 00                       .
        brk                                     ; 1F7C 00                       .
        brk                                     ; 1F7D 00                       .
        brk                                     ; 1F7E 00                       .
        brk                                     ; 1F7F 00                       .
        brk                                     ; 1F80 00                       .
        brk                                     ; 1F81 00                       .
        brk                                     ; 1F82 00                       .
        brk                                     ; 1F83 00                       .
        brk                                     ; 1F84 00                       .
        brk                                     ; 1F85 00                       .
        brk                                     ; 1F86 00                       .
        brk                                     ; 1F87 00                       .
        brk                                     ; 1F88 00                       .
        brk                                     ; 1F89 00                       .
        brk                                     ; 1F8A 00                       .
        brk                                     ; 1F8B 00                       .
        rti                                     ; 1F8C 40                       @

; ----------------------------------------------------------------------------
        .byte   $07                             ; 1F8D 07                       .
        brk                                     ; 1F8E 00                       .
        brk                                     ; 1F8F 00                       .
        rti                                     ; 1F90 40                       @

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 1F91 0F                       .
        brk                                     ; 1F92 00                       .
        brk                                     ; 1F93 00                       .
        brk                                     ; 1F94 00                       .
        .byte   $0F                             ; 1F95 0F                       .
        .byte   $04                             ; 1F96 04                       .
        ora     #$00                            ; 1F97 09 00                    ..
        brk                                     ; 1F99 00                       .
        brk                                     ; 1F9A 00                       .
        brk                                     ; 1F9B 00                       .
        brk                                     ; 1F9C 00                       .
        brk                                     ; 1F9D 00                       .
        brk                                     ; 1F9E 00                       .
        brk                                     ; 1F9F 00                       .
        brk                                     ; 1FA0 00                       .
        brk                                     ; 1FA1 00                       .
        brk                                     ; 1FA2 00                       .
        brk                                     ; 1FA3 00                       .
        brk                                     ; 1FA4 00                       .
        brk                                     ; 1FA5 00                       .
        brk                                     ; 1FA6 00                       .
        brk                                     ; 1FA7 00                       .
        brk                                     ; 1FA8 00                       .
        brk                                     ; 1FA9 00                       .
        brk                                     ; 1FAA 00                       .
        brk                                     ; 1FAB 00                       .
        brk                                     ; 1FAC 00                       .
        brk                                     ; 1FAD 00                       .
        brk                                     ; 1FAE 00                       .
        brk                                     ; 1FAF 00                       .
        brk                                     ; 1FB0 00                       .
        brk                                     ; 1FB1 00                       .
        brk                                     ; 1FB2 00                       .
        .byte   $0F                             ; 1FB3 0F                       .
        brk                                     ; 1FB4 00                       .
        brk                                     ; 1FB5 00                       .
        brk                                     ; 1FB6 00                       .
        .byte   $1F                             ; 1FB7 1F                       .
        brk                                     ; 1FB8 00                       .
        brk                                     ; 1FB9 00                       .
        brk                                     ; 1FBA 00                       .
        asl     $206F,x                         ; 1FBB 1E 6F 20                 .o 
        .byte   $1C                             ; 1FBE 1C                       .
        .byte   $3F                             ; 1FBF 3F                       ?
        jmp     L3C0B                           ; 1FC0 4C 0B 3C                 L.<

; ----------------------------------------------------------------------------
        lda     $225C                           ; 1FC3 AD 5C 22                 .\"
        bne     L1FE0                           ; 1FC6 D0 18                    ..
        lda     #$77                            ; 1FC8 A9 77                    .w
        jsr     L3F1C                           ; 1FCA 20 1C 3F                  .?
L1FCD:  jsr     L3CAD                           ; 1FCD 20 AD 3C                  .<
        cmp     #$D2                            ; 1FD0 C9 D2                    ..
        beq     L1FDD                           ; 1FD2 F0 09                    ..
        cmp     #$D3                            ; 1FD4 C9 D3                    ..
        bne     L1FCD                           ; 1FD6 D0 F5                    ..
        ldx     #$01                            ; 1FD8 A2 01                    ..
        sta     $224F                           ; 1FDA 8D 4F 22                 .O"
L1FDD:  jsr     LFDED                           ; 1FDD 20 ED FD                  ..
L1FE0:  jsr     L213D                           ; 1FE0 20 3D 21                  =!
        jsr     L2156                           ; 1FE3 20 56 21                  V!
        lda     $225C                           ; 1FE6 AD 5C 22                 .\"
        cmp     #$04                            ; 1FE9 C9 04                    ..
        bne     L2013                           ; 1FEB D0 26                    .&
        sec                                     ; 1FED 38                       8
        lda     #$00                            ; 1FEE A9 00                    ..
        sbc     $7102                           ; 1FF0 ED 02 71                 ..q
        sta     $2256                           ; 1FF3 8D 56 22                 .V"
        lda     #$00                            ; 1FF6 A9 00                    ..
        sbc     $7103                           ; 1FF8 ED 03 71                 ..q
        sta     $2257                           ; 1FFB 8D 57 22                 .W"
        sec                                     ; 1FFE 38                       8
        .byte   $A9                             ; 1FFF A9                       .
