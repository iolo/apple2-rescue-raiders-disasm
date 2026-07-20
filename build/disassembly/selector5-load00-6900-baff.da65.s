; da65 V2.19 - Git a028ac414
; Created:    reproducible build
; Input file: build/extract/selector5-load00-6900-baff.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L0000           := $0000
L0060           := $0060
L0080           := $0080
L0099           := $0099
L0201           := $0201
L0204           := $0204
L020A           := $020A
L0500           := $0500
LBB00           := $BB00
LBFC8           := $BFC8
LD400           := $D400
LD800           := $D800
LDA1B           := $DA1B
; ----------------------------------------------------------------------------
L6900:  jmp     L697D                           ; 6900 4C 7D 69                 L}i

; ----------------------------------------------------------------------------
L6903:  jmp     L6972                           ; 6903 4C 72 69                 Lri

; ----------------------------------------------------------------------------
L6906:  jmp     L6BD3                           ; 6906 4C D3 6B                 L.k

; ----------------------------------------------------------------------------
L6909:  jmp     L6BC4                           ; 6909 4C C4 6B                 L.k

; ----------------------------------------------------------------------------
L690C:  jmp     L6C7B                           ; 690C 4C 7B 6C                 L{l

; ----------------------------------------------------------------------------
L690F:  jmp     L6C9A                           ; 690F 4C 9A 6C                 L.l

; ----------------------------------------------------------------------------
L6912:  jmp     L6D75                           ; 6912 4C 75 6D                 Lum

; ----------------------------------------------------------------------------
        .byte   $4C                             ; 6915 4C                       L
        .byte   $D0                             ; 6916 D0                       .
L6917:  adc     $0B01                           ; 6917 6D 01 0B                 m..
        .byte   $0D                             ; 691A 0D                       .
        clc                                     ; 691B 18                       .
L691C:  .byte   $1B                             ; 691C 1B                       .
        asl     $0109                           ; 691D 0E 09 01                 ...
        php                                     ; 6920 08                       .
        .byte   $02                             ; 6921 02                       .
        .byte   $04                             ; 6922 04                       .
        .byte   $02                             ; 6923 02                       .
        .byte   $03                             ; 6924 03                       .
L6925:  ora     ($11),y                         ; 6925 11 11                    ..
        asl     $0200                           ; 6927 0E 00 02                 ...
        brk                                     ; 692A 00                       .
        .byte   $07                             ; 692B 07                       .
        brk                                     ; 692C 00                       .
        .byte   $10                             ; 692D 10                       .
L692E:  bpl     *+18                            ; 692E 10 10                    ..
        .byte   $03                             ; 6930 03                       .
        .byte   $02                             ; 6931 02                       .
        .byte   $01                             ; 6932 01                       .
L6933:  .byte   $0D                             ; 6933 0D                       .
L6934:  brk                                     ; 6934 00                       .
L6935:  brk                                     ; 6935 00                       .
        .byte   $01                             ; 6936 01                       .
L6937:  asl     a                               ; 6937 0A                       .
        ora     ($03,x)                         ; 6938 01 03                    ..
        .byte   $14                             ; 693A 14                       .
        ora     ($07),y                         ; 693B 11 07                    ..
        .byte   $FF                             ; 693D FF                       .
        php                                     ; 693E 08                       .
L693F:  .byte   $04                             ; 693F 04                       .
        ora     ($07,x)                         ; 6940 01 07                    ..
L6942:  php                                     ; 6942 08                       .
        ora     $0B0B                           ; 6943 0D 0B 0B                 ...
        brk                                     ; 6946 00                       .
        .byte   $03                             ; 6947 03                       .
        brk                                     ; 6948 00                       .
        .byte   $04                             ; 6949 04                       .
        brk                                     ; 694A 00                       .
        .byte   $14                             ; 694B 14                       .
        .byte   $0B                             ; 694C 0B                       .
        .byte   $0B                             ; 694D 0B                       .
        asl     a                               ; 694E 0A                       .
        .byte   $03                             ; 694F 03                       .
        ora     ($0D,x)                         ; 6950 01 0D                    ..
        brk                                     ; 6952 00                       .
L6953:  brk                                     ; 6953 00                       .
        ora     ($01,x)                         ; 6954 01 01                    ..
        brk                                     ; 6956 00                       .
        ora     ($01,x)                         ; 6957 01 01                    ..
        ora     ($01,x)                         ; 6959 01 01                    ..
        ora     ($01,x)                         ; 695B 01 01                    ..
        ora     ($01,x)                         ; 695D 01 01                    ..
        brk                                     ; 695F 00                       .
        ora     ($01,x)                         ; 6960 01 01                    ..
        ora     ($01,x)                         ; 6962 01 01                    ..
        brk                                     ; 6964 00                       .
        ora     (L0000,x)                       ; 6965 01 00                    ..
        ora     (L0000,x)                       ; 6967 01 00                    ..
        ora     ($01,x)                         ; 6969 01 01                    ..
        ora     ($01,x)                         ; 696B 01 01                    ..
        ora     ($01,x)                         ; 696D 01 01                    ..
        ora     (L0000,x)                       ; 696F 01 00                    ..
        brk                                     ; 6971 00                       .
L6972:  tax                                     ; 6972 AA                       .
L6973:  dex                                     ; 6973 CA                       .
        bne     L6973                           ; 6974 D0 FD                    ..
        bit     $C030                           ; 6976 2C 30 C0                 ,0.
        dey                                     ; 6979 88                       .
        bne     L6972                           ; 697A D0 F6                    ..
        rts                                     ; 697C 60                       `

; ----------------------------------------------------------------------------
L697D:  ldx     #$F0                            ; 697D A2 F0                    ..
        txs                                     ; 697F 9A                       .
        lda     #$00                            ; 6980 A9 00                    ..
        sta     $01                             ; 6982 85 01                    ..
        lda     #$02                            ; 6984 A9 02                    ..
        jsr     LBFC8                           ; 6986 20 C8 BF                  ..
        jsr     L699F                           ; 6989 20 9F 69                  .i
        lda     #$01                            ; 698C A9 01                    ..
        sta     $60B6                           ; 698E 8D B6 60                 ..`
L6991:  .byte   $20                             ; 6991 20                        
L6992:  cmp     $AD69,x                         ; 6992 DD 69 AD                 .i.
        ldx     L0060,y                         ; 6995 B6 60                    .`
        eor     #$01                            ; 6997 49 01                    I.
        sta     $60B6                           ; 6999 8D B6 60                 ..`
        jmp     L6991                           ; 699C 4C 91 69                 L.i

; ----------------------------------------------------------------------------
L699F:  lda     #$00                            ; 699F A9 00                    ..
        sta     $BFFF                           ; 69A1 8D FF BF                 ...
        jsr     L69BC                           ; 69A4 20 BC 69                  .i
        jsr     L6F00                           ; 69A7 20 00 6F                  .o
        jsr     L7A00                           ; 69AA 20 00 7A                  .z
        jsr     L8500                           ; 69AD 20 00 85                  ..
        jsr     L8F00                           ; 69B0 20 00 8F                  ..
        jsr     L9A00                           ; 69B3 20 00 9A                  ..
        jsr     LAC00                           ; 69B6 20 00 AC                  ..
        jmp     LB300                           ; 69B9 4C 00 B3                 L..

; ----------------------------------------------------------------------------
L69BC:  lda     #$00                            ; 69BC A9 00                    ..
        sta     $60D3                           ; 69BE 8D D3 60                 ..`
        sta     $60A9                           ; 69C1 8D A9 60                 ..`
        sta     $60AA                           ; 69C4 8D AA 60                 ..`
        lda     #$A0                            ; 69C7 A9 A0                    ..
        sta     $01FC                           ; 69C9 8D FC 01                 ...
        sta     $01FD                           ; 69CC 8D FD 01                 ...
        sta     $01FE                           ; 69CF 8D FE 01                 ...
        lda     #$B0                            ; 69D2 A9 B0                    ..
        sta     $01FF                           ; 69D4 8D FF 01                 ...
        lda     #$FF                            ; 69D7 A9 FF                    ..
        sta     $6002                           ; 69D9 8D 02 60                 ..`
        rts                                     ; 69DC 60                       `

; ----------------------------------------------------------------------------
L69DD:  jsr     L6A75                           ; 69DD 20 75 6A                  uj
L69E0:  jsr     L6AE3                           ; 69E0 20 E3 6A                  .j
L69E3:  jsr     L6A51                           ; 69E3 20 51 6A                  Qj
        lda     $6001                           ; 69E6 AD 01 60                 ..`
        beq     L69F6                           ; 69E9 F0 0B                    ..
        jsr     LB30C                           ; 69EB 20 0C B3                  ..
        lda     #$05                            ; 69EE A9 05                    ..
        jsr     LBFC8                           ; 69F0 20 C8 BF                  ..
        jmp     L69DD                           ; 69F3 4C DD 69                 L.i

; ----------------------------------------------------------------------------
L69F6:  lda     $60BC                           ; 69F6 AD BC 60                 ..`
        bne     L6A39                           ; 69F9 D0 3E                    .>
        lda     $60C6                           ; 69FB AD C6 60                 ..`
        beq     L6A1A                           ; 69FE F0 1A                    ..
        inc     $60C7                           ; 6A00 EE C7 60                 ..`
        bne     L6A1A                           ; 6A03 D0 15                    ..
        lda     $60B6                           ; 6A05 AD B6 60                 ..`
        bne     L69DD                           ; 6A08 D0 D3                    ..
        inc     $60B7                           ; 6A0A EE B7 60                 ..`
        lda     $60C6                           ; 6A0D AD C6 60                 ..`
        cmp     #$01                            ; 6A10 C9 01                    ..
        beq     L6A1A                           ; 6A12 F0 06                    ..
        lda     $05                             ; 6A14 A5 05                    ..
        cmp     #$08                            ; 6A16 C9 08                    ..
        beq     L6A44                           ; 6A18 F0 2A                    .*
L6A1A:  lda     $60B8                           ; 6A1A AD B8 60                 ..`
        bne     L6A34                           ; 6A1D D0 15                    ..
        lda     $60B0                           ; 6A1F AD B0 60                 ..`
        bne     L6A2F                           ; 6A22 D0 0B                    ..
        lda     $60B7                           ; 6A24 AD B7 60                 ..`
        beq     L69E3                           ; 6A27 F0 BA                    ..
        jsr     L6D16                           ; 6A29 20 16 6D                  .m
        jmp     L69E0                           ; 6A2C 4C E0 69                 L.i

; ----------------------------------------------------------------------------
L6A2F:  inc     $60B1                           ; 6A2F EE B1 60                 ..`
        bne     L69E3                           ; 6A32 D0 AF                    ..
L6A34:  lda     $60B6                           ; 6A34 AD B6 60                 ..`
        bne     L6A43                           ; 6A37 D0 0A                    ..
L6A39:  lda     $6000                           ; 6A39 AD 00 60                 ..`
        cmp     #$04                            ; 6A3C C9 04                    ..
        beq     L6A43                           ; 6A3E F0 03                    ..
        jmp     L6C4E                           ; 6A40 4C 4E 6C                 LNl

; ----------------------------------------------------------------------------
L6A43:  rts                                     ; 6A43 60                       `

; ----------------------------------------------------------------------------
L6A44:  inc     $05                             ; 6A44 E6 05                    ..
        jsr     LB30C                           ; 6A46 20 0C B3                  ..
        lda     #$06                            ; 6A49 A9 06                    ..
        jsr     LBFC8                           ; 6A4B 20 C8 BF                  ..
        jmp     L6A34                           ; 6A4E 4C 34 6A                 L4j

; ----------------------------------------------------------------------------
L6A51:  jsr     L7A09                           ; 6A51 20 09 7A                  .z
        lda     $6000                           ; 6A54 AD 00 60                 ..`
        cmp     #$04                            ; 6A57 C9 04                    ..
        beq     L6A74                           ; 6A59 F0 19                    ..
        lda     $04                             ; 6A5B A5 04                    ..
        eor     #$01                            ; 6A5D 49 01                    I.
        beq     L6A69                           ; 6A5F F0 08                    ..
        lda     $6003                           ; 6A61 AD 03 60                 ..`
        beq     L6A69                           ; 6A64 F0 03                    ..
        dec     $6003                           ; 6A66 CE 03 60                 ..`
L6A69:  jsr     LB309                           ; 6A69 20 09 B3                  ..
        inc     $60C1                           ; 6A6C EE C1 60                 ..`
        bne     L6A74                           ; 6A6F D0 03                    ..
        inc     $60C2                           ; 6A71 EE C2 60                 ..`
L6A74:  rts                                     ; 6A74 60                       `

; ----------------------------------------------------------------------------
L6A75:  lda     #$01                            ; 6A75 A9 01                    ..
        sta     $60B9                           ; 6A77 8D B9 60                 ..`
        lda     $60B6                           ; 6A7A AD B6 60                 ..`
        beq     L6A8A                           ; 6A7D F0 0B                    ..
        lda     #$00                            ; 6A7F A9 00                    ..
        sta     $60BB                           ; 6A81 8D BB 60                 ..`
        jsr     LB30C                           ; 6A84 20 0C B3                  ..
        jsr     L6DE2                           ; 6A87 20 E2 6D                  .m
L6A8A:  jsr     L6AA2                           ; 6A8A 20 A2 6A                  .j
        jsr     L6F03                           ; 6A8D 20 03 6F                  .o
        jsr     L7A03                           ; 6A90 20 03 7A                  .z
        jsr     L8503                           ; 6A93 20 03 85                  ..
        jsr     L8F03                           ; 6A96 20 03 8F                  ..
        jsr     L9A03                           ; 6A99 20 03 9A                  ..
        jsr     LAC03                           ; 6A9C 20 03 AC                  ..
        jmp     LB303                           ; 6A9F 4C 03 B3                 L..

; ----------------------------------------------------------------------------
L6AA2:  lda     #$00                            ; 6AA2 A9 00                    ..
        sta     $6001                           ; 6AA4 8D 01 60                 ..`
        sta     $6000                           ; 6AA7 8D 00 60                 ..`
        sta     $60BC                           ; 6AAA 8D BC 60                 ..`
        sta     $60B0                           ; 6AAD 8D B0 60                 ..`
        sta     $60B1                           ; 6AB0 8D B1 60                 ..`
        sta     $60B8                           ; 6AB3 8D B8 60                 ..`
        sta     $60B7                           ; 6AB6 8D B7 60                 ..`
        sta     $60C6                           ; 6AB9 8D C6 60                 ..`
        sta     $60C7                           ; 6ABC 8D C7 60                 ..`
        sta     $60C1                           ; 6ABF 8D C1 60                 ..`
        sta     $60C2                           ; 6AC2 8D C2 60                 ..`
        sta     $0E                             ; 6AC5 85 0E                    ..
        sta     $0F                             ; 6AC7 85 0F                    ..
        bit     $60BB                           ; 6AC9 2C BB 60                 ,.`
        bmi     L6AD5                           ; 6ACC 30 07                    0.
        lda     $60B6                           ; 6ACE AD B6 60                 ..`
        eor     #$01                            ; 6AD1 49 01                    I.
        sta     $05                             ; 6AD3 85 05                    ..
L6AD5:  lda     #$04                            ; 6AD5 A9 04                    ..
        sta     $60AB                           ; 6AD7 8D AB 60                 ..`
        lda     #$0F                            ; 6ADA A9 0F                    ..
        sta     $6116                           ; 6ADC 8D 16 61                 ..a
        sta     $6117                           ; 6ADF 8D 17 61                 ..a
        rts                                     ; 6AE2 60                       `

; ----------------------------------------------------------------------------
L6AE3:  lda     $60B7                           ; 6AE3 AD B7 60                 ..`
        beq     L6AF7                           ; 6AE6 F0 0F                    ..
        lda     #$00                            ; 6AE8 A9 00                    ..
        sta     $60B7                           ; 6AEA 8D B7 60                 ..`
        inc     $05                             ; 6AED E6 05                    ..
        lda     #$00                            ; 6AEF A9 00                    ..
        sta     $60C6                           ; 6AF1 8D C6 60                 ..`
        sta     $60C7                           ; 6AF4 8D C7 60                 ..`
L6AF7:  jsr     L6B94                           ; 6AF7 20 94 6B                  .k
        ldy     #$07                            ; 6AFA A0 07                    ..
L6AFC:  lda     $4064,y                         ; 6AFC B9 64 40                 .d@
        sta     $60E9,y                         ; 6AFF 99 E9 60                 ..`
        dey                                     ; 6B02 88                       .
        bpl     L6AFC                           ; 6B03 10 F7                    ..
        jsr     L6F06                           ; 6B05 20 06 6F                  .o
        jsr     L7A06                           ; 6B08 20 06 7A                  .z
        jsr     L8506                           ; 6B0B 20 06 85                  ..
        jsr     L8F06                           ; 6B0E 20 06 8F                  ..
        jsr     L9A06                           ; 6B11 20 06 9A                  ..
        jsr     LAC06                           ; 6B14 20 06 AC                  ..
        jsr     LB306                           ; 6B17 20 06 B3                  ..
        jsr     L6F09                           ; 6B1A 20 09 6F                  .o
        lda     #$00                            ; 6B1D A9 00                    ..
        sta     $6110                           ; 6B1F 8D 10 61                 ..a
        sta     $6111                           ; 6B22 8D 11 61                 ..a
        sta     $60FE                           ; 6B25 8D FE 60                 ..`
        sta     $60FF                           ; 6B28 8D FF 60                 ..`
        ldx     $05                             ; 6B2B A6 05                    ..
        cpx     #$01                            ; 6B2D E0 01                    ..
        bne     L6B35                           ; 6B2F D0 04                    ..
        sta     $0E                             ; 6B31 85 0E                    ..
        sta     $0F                             ; 6B33 85 0F                    ..
L6B35:  lda     #$01                            ; 6B35 A9 01                    ..
        sta     $6003                           ; 6B37 8D 03 60                 ..`
        ldy     $05                             ; 6B3A A4 05                    ..
        cpy     $6002                           ; 6B3C CC 02 60                 ..`
        beq     L6B4F                           ; 6B3F F0 0E                    ..
        lda     L6DFF,y                         ; 6B41 B9 FF 6D                 ..m
        ldx     $6002                           ; 6B44 AE 02 60                 ..`
        cmp     L6DFF,x                         ; 6B47 DD FF 6D                 ..m
        beq     L6B4F                           ; 6B4A F0 03                    ..
        jsr     L6BEC                           ; 6B4C 20 EC 6B                  .k
L6B4F:  lda     $60B6                           ; 6B4F AD B6 60                 ..`
        bne     L6B5E                           ; 6B52 D0 0A                    ..
        bit     $60BB                           ; 6B54 2C BB 60                 ,.`
        bmi     L6B5E                           ; 6B57 30 05                    0.
        lda     #$06                            ; 6B59 A9 06                    ..
        jsr     LBFC8                           ; 6B5B 20 C8 BF                  ..
L6B5E:  lda     #$06                            ; 6B5E A9 06                    ..
        sta     $BFEC                           ; 6B60 8D EC BF                 ...
        lda     #$03                            ; 6B63 A9 03                    ..
        sta     $BFED                           ; 6B65 8D ED BF                 ...
        lda     #$0B                            ; 6B68 A9 0B                    ..
        sta     $BFEA                           ; 6B6A 8D EA BF                 ...
        lda     #$02                            ; 6B6D A9 02                    ..
        sta     $BFEB                           ; 6B6F 8D EB BF                 ...
        jsr     L6909                           ; 6B72 20 09 69                  .i
        dec     $BFEB                           ; 6B75 CE EB BF                 ...
        dec     $BFEC                           ; 6B78 CE EC BF                 ...
        jsr     L6909                           ; 6B7B 20 09 69                  .i
        lda     #$00                            ; 6B7E A9 00                    ..
        sta     $BFED                           ; 6B80 8D ED BF                 ...
        bit     $C010                           ; 6B83 2C 10 C0                 ,..
        ldy     #$07                            ; 6B86 A0 07                    ..
L6B88:  sta     $4078,y                         ; 6B88 99 78 40                 .x@
        sta     $40F8,y                         ; 6B8B 99 F8 40                 ..@
        dey                                     ; 6B8E 88                       .
        bpl     L6B88                           ; 6B8F 10 F7                    ..
        jmp     L6909                           ; 6B91 4C 09 69                 L.i

; ----------------------------------------------------------------------------
L6B94:  jsr     LB30C                           ; 6B94 20 0C B3                  ..
        lda     #$00                            ; 6B97 A9 00                    ..
        sta     $BFEA                           ; 6B99 8D EA BF                 ...
        lda     $05                             ; 6B9C A5 05                    ..
        clc                                     ; 6B9E 18                       .
        adc     #$06                            ; 6B9F 69 06                    i.
        sta     $BFEB                           ; 6BA1 8D EB BF                 ...
        lda     #$40                            ; 6BA4 A9 40                    .@
        sta     $BFEC                           ; 6BA6 8D EC BF                 ...
        lda     #$06                            ; 6BA9 A9 06                    ..
        pha                                     ; 6BAB 48                       H
        jsr     L6BBF                           ; 6BAC 20 BF 6B                  .k
        pla                                     ; 6BAF 68                       h
        sta     $BFEA                           ; 6BB0 8D EA BF                 ...
        lda     #$02                            ; 6BB3 A9 02                    ..
        sta     $BFED                           ; 6BB5 8D ED BF                 ...
        jsr     L6909                           ; 6BB8 20 09 69                  .i
        lda     #$00                            ; 6BBB A9 00                    ..
        beq     L6BC1                           ; 6BBD F0 02                    ..
L6BBF:  lda     #$03                            ; 6BBF A9 03                    ..
L6BC1:  sta     $BFED                           ; 6BC1 8D ED BF                 ...
L6BC4:  lda     #$00                            ; 6BC4 A9 00                    ..
        sta     $BFEE                           ; 6BC6 8D EE BF                 ...
        ldx     #$E8                            ; 6BC9 A2 E8                    ..
        ldy     #$BF                            ; 6BCB A0 BF                    ..
        jsr     LBB00                           ; 6BCD 20 00 BB                  ..
        bcs     L6BC4                           ; 6BD0 B0 F2                    ..
        rts                                     ; 6BD2 60                       `

; ----------------------------------------------------------------------------
L6BD3:  adc     $60E7                           ; 6BD3 6D E7 60                 m.`
        adc     L6900,y                         ; 6BD6 79 00 69                 y.i
        adc     L6F00,x                         ; 6BD9 7D 00 6F                 }.o
        adc     $60C3                           ; 6BDC 6D C3 60                 m.`
        adc     $60C1                           ; 6BDF 6D C1 60                 m.`
        adc     $60C4                           ; 6BE2 6D C4 60                 m.`
        adc     $60E3                           ; 6BE5 6D E3 60                 m.`
        sta     $60E7                           ; 6BE8 8D E7 60                 ..`
        rts                                     ; 6BEB 60                       `

; ----------------------------------------------------------------------------
L6BEC:  lda     #$03                            ; 6BEC A9 03                    ..
        sta     $BFED                           ; 6BEE 8D ED BF                 ...
        ldy     $05                             ; 6BF1 A4 05                    ..
        ldy     #$01                            ; 6BF3 A0 01                    ..
        ldx     L6DFF,y                         ; 6BF5 BE FF 6D                 ..m
        lda     L6E08,x                         ; 6BF8 BD 08 6E                 ..n
        sta     $BFEA                           ; 6BFB 8D EA BF                 ...
        lda     L6E0D,x                         ; 6BFE BD 0D 6E                 ..n
        sta     $BFEB                           ; 6C01 8D EB BF                 ...
        lda     #$03                            ; 6C04 A9 03                    ..
        sta     $BFED                           ; 6C06 8D ED BF                 ...
        ldx     #$D3                            ; 6C09 A2 D3                    ..
        lda     #$04                            ; 6C0B A9 04                    ..
        jsr     L6C2D                           ; 6C0D 20 2D 6C                  -l
        ldx     #$1F                            ; 6C10 A2 1F                    ..
        lda     #$07                            ; 6C12 A9 07                    ..
        jsr     L6C2D                           ; 6C14 20 2D 6C                  -l
        ldx     #$E1                            ; 6C17 A2 E1                    ..
        lda     #$02                            ; 6C19 A9 02                    ..
        jsr     L6C2D                           ; 6C1B 20 2D 6C                  -l
        ldx     #$EA                            ; 6C1E A2 EA                    ..
        lda     #$0B                            ; 6C20 A9 0B                    ..
        jsr     L6C2D                           ; 6C22 20 2D 6C                  -l
        lda     #$00                            ; 6C25 A9 00                    ..
        sta     $BFED                           ; 6C27 8D ED BF                 ...
        jmp     L6909                           ; 6C2A 4C 09 69                 L.i

; ----------------------------------------------------------------------------
L6C2D:  stx     $BFEC                           ; 6C2D 8E EC BF                 ...
L6C30:  pha                                     ; 6C30 48                       H
        jsr     L6909                           ; 6C31 20 09 69                  .i
        dec     $BFEC                           ; 6C34 CE EC BF                 ...
        lda     $BFEB                           ; 6C37 AD EB BF                 ...
        bne     L6C44                           ; 6C3A D0 08                    ..
        dec     $BFEA                           ; 6C3C CE EA BF                 ...
        lda     #$10                            ; 6C3F A9 10                    ..
        sta     $BFEB                           ; 6C41 8D EB BF                 ...
L6C44:  dec     $BFEB                           ; 6C44 CE EB BF                 ...
        pla                                     ; 6C47 68                       h
        sec                                     ; 6C48 38                       8
        sbc     #$01                            ; 6C49 E9 01                    ..
        bne     L6C30                           ; 6C4B D0 E3                    ..
        rts                                     ; 6C4D 60                       `

; ----------------------------------------------------------------------------
L6C4E:  jsr     L6D75                           ; 6C4E 20 75 6D                  um
        ldy     #$03                            ; 6C51 A0 03                    ..
L6C53:  lda     L0060,y                         ; 6C53 B9 60 00                 .`.
        sta     $01FC,y                         ; 6C56 99 FC 01                 ...
        dey                                     ; 6C59 88                       .
        bpl     L6C53                           ; 6C5A 10 F7                    ..
        lda     $0F                             ; 6C5C A5 0F                    ..
        cmp     #$90                            ; 6C5E C9 90                    ..
        bcs     L6C72                           ; 6C60 B0 10                    ..
        cmp     $0458                           ; 6C62 CD 58 04                 .X.
        bcc     L6C72                           ; 6C65 90 0B                    ..
        bne     L6C73                           ; 6C67 D0 0A                    ..
        lda     $0E                             ; 6C69 A5 0E                    ..
        cmp     $0459                           ; 6C6B CD 59 04                 .Y.
        bcc     L6C72                           ; 6C6E 90 02                    ..
        bne     L6C73                           ; 6C70 D0 01                    ..
L6C72:  rts                                     ; 6C72 60                       `

; ----------------------------------------------------------------------------
L6C73:  jsr     LB30C                           ; 6C73 20 0C B3                  ..
        lda     #$03                            ; 6C76 A9 03                    ..
        jmp     LBFC8                           ; 6C78 4C C8 BF                 L..

; ----------------------------------------------------------------------------
L6C7B:  sta     L6E8E                           ; 6C7B 8D 8E 6E                 ..n
        lda     L6E11,x                         ; 6C7E BD 11 6E                 ..n
        beq     L6C99                           ; 6C81 F0 16                    ..
        clc                                     ; 6C83 18                       .
        adc     L6E8E                           ; 6C84 6D 8E 6E                 m.n
        tax                                     ; 6C87 AA                       .
        sed                                     ; 6C88 F8                       .
        lda     L6E2F,x                         ; 6C89 BD 2F 6E                 ./n
        clc                                     ; 6C8C 18                       .
        adc     $0E                             ; 6C8D 65 0E                    e.
        sta     $0E                             ; 6C8F 85 0E                    ..
        lda     L6E37,x                         ; 6C91 BD 37 6E                 .7n
        adc     $0F                             ; 6C94 65 0F                    e.
        sta     $0F                             ; 6C96 85 0F                    ..
        cld                                     ; 6C98 D8                       .
L6C99:  rts                                     ; 6C99 60                       `

; ----------------------------------------------------------------------------
L6C9A:  sta     $BFED                           ; 6C9A 8D ED BF                 ...
        sta     $6000                           ; 6C9D 8D 00 60                 ..`
        ldx     $0E                             ; 6CA0 A6 0E                    ..
        stx     $60D1                           ; 6CA2 8E D1 60                 ..`
        ldx     $0F                             ; 6CA5 A6 0F                    ..
        stx     $60D2                           ; 6CA7 8E D2 60                 ..`
        ldx     $05                             ; 6CAA A6 05                    ..
        stx     $60CF                           ; 6CAC 8E CF 60                 ..`
        ldx     #$1F                            ; 6CAF A2 1F                    ..
        stx     $BFEA                           ; 6CB1 8E EA BF                 ...
        cmp     #$03                            ; 6CB4 C9 03                    ..
        bne     L6CD6                           ; 6CB6 D0 1E                    ..
        jsr     LB30C                           ; 6CB8 20 0C B3                  ..
        lda     #$07                            ; 6CBB A9 07                    ..
        sta     $BFEB                           ; 6CBD 8D EB BF                 ...
        lda     #$40                            ; 6CC0 A9 40                    .@
        sta     $BFEC                           ; 6CC2 8D EC BF                 ...
        jsr     L6909                           ; 6CC5 20 09 69                  .i
        lda     #$00                            ; 6CC8 A9 00                    ..
        sta     $4000                           ; 6CCA 8D 00 40                 ..@
        inc     $BFED                           ; 6CCD EE ED BF                 ...
        jsr     L6909                           ; 6CD0 20 09 69                  .i
        dec     $BFED                           ; 6CD3 CE ED BF                 ...
L6CD6:  lda     #$0F                            ; 6CD6 A9 0F                    ..
        sta     $BFEB                           ; 6CD8 8D EB BF                 ...
        lda     #$68                            ; 6CDB A9 68                    .h
        sta     $BFEC                           ; 6CDD 8D EC BF                 ...
L6CE0:  jsr     L6909                           ; 6CE0 20 09 69                  .i
        bcs     L6CE0                           ; 6CE3 B0 FB                    ..
        dec     $BFEB                           ; 6CE5 CE EB BF                 ...
        dec     $BFEC                           ; 6CE8 CE EC BF                 ...
        lda     $BFEC                           ; 6CEB AD EC BF                 ...
        cmp     #$60                            ; 6CEE C9 60                    .`
        bcs     L6CE0                           ; 6CF0 B0 EE                    ..
        lda     $BFED                           ; 6CF2 AD ED BF                 ...
        cmp     #$04                            ; 6CF5 C9 04                    ..
        beq     L6D0B                           ; 6CF7 F0 12                    ..
        lda     $60D1                           ; 6CF9 AD D1 60                 ..`
        sta     $0E                             ; 6CFC 85 0E                    ..
        lda     $60D2                           ; 6CFE AD D2 60                 ..`
        sta     $0F                             ; 6D01 85 0F                    ..
        lda     $60CF                           ; 6D03 AD CF 60                 ..`
        sta     $05                             ; 6D06 85 05                    ..
        jmp     L6BEC                           ; 6D08 4C EC 6B                 L.k

; ----------------------------------------------------------------------------
L6D0B:  inc     $60BC                           ; 6D0B EE BC 60                 ..`
        clc                                     ; 6D0E 18                       .
        rts                                     ; 6D0F 60                       `

; ----------------------------------------------------------------------------
        sta     $BFED                           ; 6D10 8D ED BF                 ...
        jmp     L6909                           ; 6D13 4C 09 69                 L.i

; ----------------------------------------------------------------------------
L6D16:  ldy     $60DF                           ; 6D16 AC DF 60                 ..`
L6D19:  lda     $625C,y                         ; 6D19 B9 5C 62                 .\b
        tay                                     ; 6D1C A8                       .
        cmp     $60E0                           ; 6D1D CD E0 60                 ..`
        beq     L6D51                           ; 6D20 F0 2F                    ./
        ldx     $6124,y                         ; 6D22 BE 24 61                 .$a
        lda     L6E6F,x                         ; 6D25 BD 6F 6E                 .on
        and     #$0F                            ; 6D28 29 0F                    ).
        clc                                     ; 6D2A 18                       .
        adc     $6117                           ; 6D2B 6D 17 61                 m.a
        bcc     L6D32                           ; 6D2E 90 02                    ..
        lda     #$FF                            ; 6D30 A9 FF                    ..
L6D32:  sta     $6117                           ; 6D32 8D 17 61                 ..a
        lda     L6E6F,x                         ; 6D35 BD 6F 6E                 .on
        lsr     a                               ; 6D38 4A                       J
        lsr     a                               ; 6D39 4A                       J
        lsr     a                               ; 6D3A 4A                       J
        lsr     a                               ; 6D3B 4A                       J
        cmp     #$0A                            ; 6D3C C9 0A                    ..
        bcc     L6D42                           ; 6D3E 90 02                    ..
        adc     #$05                            ; 6D40 69 05                    i.
L6D42:  sed                                     ; 6D42 F8                       .
        adc     $0E                             ; 6D43 65 0E                    e.
        sta     $0E                             ; 6D45 85 0E                    ..
        lda     $0F                             ; 6D47 A5 0F                    ..
        adc     #$00                            ; 6D49 69 00                    i.
        sta     $0F                             ; 6D4B 85 0F                    ..
        cld                                     ; 6D4D D8                       .
        jmp     L6D19                           ; 6D4E 4C 19 6D                 L.m

; ----------------------------------------------------------------------------
L6D51:  lda     $05                             ; 6D51 A5 05                    ..
        sec                                     ; 6D53 38                       8
        sbc     #$01                            ; 6D54 E9 01                    ..
        beq     L6D6B                           ; 6D56 F0 13                    ..
        tax                                     ; 6D58 AA                       .
L6D59:  sed                                     ; 6D59 F8                       .
        lda     #$50                            ; 6D5A A9 50                    .P
        clc                                     ; 6D5C 18                       .
        adc     $0E                             ; 6D5D 65 0E                    e.
        sta     $0E                             ; 6D5F 85 0E                    ..
        lda     $0F                             ; 6D61 A5 0F                    ..
        adc     #$00                            ; 6D63 69 00                    i.
        sta     $0F                             ; 6D65 85 0F                    ..
        cld                                     ; 6D67 D8                       .
        dex                                     ; 6D68 CA                       .
        bne     L6D59                           ; 6D69 D0 EE                    ..
L6D6B:  lda     #$01                            ; 6D6B A9 01                    ..
        clc                                     ; 6D6D 18                       .
        sed                                     ; 6D6E F8                       .
        adc     $0F                             ; 6D6F 65 0F                    e.
        sta     $0F                             ; 6D71 85 0F                    ..
        cld                                     ; 6D73 D8                       .
        rts                                     ; 6D74 60                       `

; ----------------------------------------------------------------------------
L6D75:  lda     #$A0                            ; 6D75 A9 A0                    ..
        sta     L0060                           ; 6D77 85 60                    .`
        sta     $61                             ; 6D79 85 61                    .a
        sta     $62                             ; 6D7B 85 62                    .b
        sta     $63                             ; 6D7D 85 63                    .c
        ldy     #$03                            ; 6D7F A0 03                    ..
        sty     $60A8                           ; 6D81 8C A8 60                 ..`
        lda     $0E                             ; 6D84 A5 0E                    ..
        sta     $64                             ; 6D86 85 64                    .d
        lda     $0F                             ; 6D88 A5 0F                    ..
        sta     $65                             ; 6D8A 85 65                    .e
        cmp     #$90                            ; 6D8C C9 90                    ..
        bcc     L6DA2                           ; 6D8E 90 12                    ..
        lda     #$BB                            ; 6D90 A9 BB                    ..
        sta     $63                             ; 6D92 85 63                    .c
        sed                                     ; 6D94 F8                       .
        lda     #$00                            ; 6D95 A9 00                    ..
        sbc     $64                             ; 6D97 E5 64                    .d
        sta     $64                             ; 6D99 85 64                    .d
        lda     #$00                            ; 6D9B A9 00                    ..
        sbc     $65                             ; 6D9D E5 65                    .e
        sta     $65                             ; 6D9F 85 65                    .e
        cld                                     ; 6DA1 D8                       .
L6DA2:  ldx     #$04                            ; 6DA2 A2 04                    ..
L6DA4:  asl     $64                             ; 6DA4 06 64                    .d
        rol     $65                             ; 6DA6 26 65                    &e
        rol     a                               ; 6DA8 2A                       *
        dex                                     ; 6DA9 CA                       .
        bne     L6DA4                           ; 6DAA D0 F8                    ..
        and     #$0F                            ; 6DAC 29 0F                    ).
        bne     L6DB9                           ; 6DAE D0 09                    ..
        bit     $60A8                           ; 6DB0 2C A8 60                 ,.`
        bmi     L6DB9                           ; 6DB3 30 04                    0.
        cpy     #$00                            ; 6DB5 C0 00                    ..
        bne     L6DCC                           ; 6DB7 D0 13                    ..
L6DB9:  ora     #$B0                            ; 6DB9 09 B0                    ..
        ldx     $61                             ; 6DBB A6 61                    .a
        stx     L0060                           ; 6DBD 86 60                    .`
        ldx     $62                             ; 6DBF A6 62                    .b
        stx     $61                             ; 6DC1 86 61                    .a
        ldx     $63                             ; 6DC3 A6 63                    .c
        stx     $62                             ; 6DC5 86 62                    .b
        sta     $63                             ; 6DC7 85 63                    .c
        sta     $60A8                           ; 6DC9 8D A8 60                 ..`
L6DCC:  dey                                     ; 6DCC 88                       .
        bpl     L6DA2                           ; 6DCD 10 D3                    ..
        rts                                     ; 6DCF 60                       `

; ----------------------------------------------------------------------------
L6DD0:  ldy     $60C3                           ; 6DD0 AC C3 60                 ..`
        ldx     $61F4,y                         ; 6DD3 BE F4 61                 ..a
        lda     $625C,y                         ; 6DD6 B9 5C 62                 .\b
        sta     $625C,x                         ; 6DD9 9D 5C 62                 .\b
        tay                                     ; 6DDC A8                       .
        txa                                     ; 6DDD 8A                       .
        sta     $61F4,y                         ; 6DDE 99 F4 61                 ..a
        rts                                     ; 6DE1 60                       `

; ----------------------------------------------------------------------------
L6DE2:  lda     #$1F                            ; 6DE2 A9 1F                    ..
        sta     $BFEA                           ; 6DE4 8D EA BF                 ...
        lda     #$07                            ; 6DE7 A9 07                    ..
        sta     $BFEB                           ; 6DE9 8D EB BF                 ...
        lda     #$40                            ; 6DEC A9 40                    .@
        sta     $BFEC                           ; 6DEE 8D EC BF                 ...
        jsr     L6BBF                           ; 6DF1 20 BF 6B                  .k
        lda     $4000                           ; 6DF4 AD 00 40                 ..@
        beq     L6DFB                           ; 6DF7 F0 02                    ..
        lda     #$FF                            ; 6DF9 A9 FF                    ..
L6DFB:  sta     $60B2                           ; 6DFB 8D B2 60                 ..`
        rts                                     ; 6DFE 60                       `

; ----------------------------------------------------------------------------
L6DFF:  .byte   $04                             ; 6DFF 04                       .
        brk                                     ; 6E00 00                       .
        brk                                     ; 6E01 00                       .
        ora     ($01,x)                         ; 6E02 01 01                    ..
        .byte   $02                             ; 6E04 02                       .
        .byte   $02                             ; 6E05 02                       .
        .byte   $03                             ; 6E06 03                       .
        .byte   $03                             ; 6E07 03                       .
L6E08:  clc                                     ; 6E08 18                       .
        .byte   $1A                             ; 6E09 1A                       .
        .byte   $1B                             ; 6E0A 1B                       .
        .byte   $1C                             ; 6E0B 1C                       .
        .byte   $17                             ; 6E0C 17                       .
L6E0D:  .byte   $0F                             ; 6E0D 0F                       .
        .byte   $07                             ; 6E0E 07                       .
        .byte   $0F                             ; 6E0F 0F                       .
        .byte   $07                             ; 6E10 07                       .
L6E11:  .byte   $07                             ; 6E11 07                       .
        brk                                     ; 6E12 00                       .
        .byte   $07                             ; 6E13 07                       .
        brk                                     ; 6E14 00                       .
        brk                                     ; 6E15 00                       .
        brk                                     ; 6E16 00                       .
        asl     L0000                           ; 6E17 06 00                    ..
        brk                                     ; 6E19 00                       .
        ora     L0000                           ; 6E1A 05 00                    ..
        brk                                     ; 6E1C 00                       .
        brk                                     ; 6E1D 00                       .
        ora     ($02,x)                         ; 6E1E 01 02                    ..
        .byte   $03                             ; 6E20 03                       .
        .byte   $04                             ; 6E21 04                       .
        brk                                     ; 6E22 00                       .
        brk                                     ; 6E23 00                       .
        brk                                     ; 6E24 00                       .
        brk                                     ; 6E25 00                       .
        brk                                     ; 6E26 00                       .
        php                                     ; 6E27 08                       .
        php                                     ; 6E28 08                       .
        brk                                     ; 6E29 00                       .
        ora     (L0000,x)                       ; 6E2A 01 00                    ..
        brk                                     ; 6E2C 00                       .
        brk                                     ; 6E2D 00                       .
        brk                                     ; 6E2E 00                       .
L6E2F:  brk                                     ; 6E2F 00                       .
        sta     L9895,y                         ; 6E30 99 95 98                 ...
        sta     $97                             ; 6E33 85 97                    ..
        brk                                     ; 6E35 00                       .
        .byte   $79                             ; 6E36 79                       y
L6E37:  brk                                     ; 6E37 00                       .
        sta     L9999,y                         ; 6E38 99 99 99                 ...
        sta     L0099,y                         ; 6E3B 99 99 00                 ...
        sta     L9800,y                         ; 6E3E 99 00 98                 ...
        sta     L9500,y                         ; 6E41 99 00 95                 ...
        brk                                     ; 6E44 00                       .
        adc     L0000,x                         ; 6E45 75 00                    u.
        ora     (L0099,x)                       ; 6E47 01 99                    ..
        sta     L9900,y                         ; 6E49 99 00 99                 ...
        brk                                     ; 6E4C 00                       .
        sta     L0000,y                         ; 6E4D 99 00 00                 ...
        ora     ($05,x)                         ; 6E50 01 05                    ..
        .byte   $02                             ; 6E52 02                       .
        ora     $03,x                           ; 6E53 15 03                    ..
        adc     $07,x                           ; 6E55 75 07                    u.
        sta     L0000,y                         ; 6E57 99 00 00                 ...
        brk                                     ; 6E5A 00                       .
        brk                                     ; 6E5B 00                       .
        brk                                     ; 6E5C 00                       .
        sta     L9900,y                         ; 6E5D 99 00 99                 ...
        .byte   $02                             ; 6E60 02                       .
        ora     $02                             ; 6E61 05 02                    ..
        ora     $03,x                           ; 6E63 15 03                    ..
        .byte   $04                             ; 6E65 04                       .
        and     ($20,x)                         ; 6E66 21 20                    ! 
        brk                                     ; 6E68 00                       .
        brk                                     ; 6E69 00                       .
        brk                                     ; 6E6A 00                       .
        brk                                     ; 6E6B 00                       .
        brk                                     ; 6E6C 00                       .
        brk                                     ; 6E6D 00                       .
        brk                                     ; 6E6E 00                       .
L6E6F:  brk                                     ; 6E6F 00                       .
        brk                                     ; 6E70 00                       .
        .byte   $77                             ; 6E71 77                       w
        brk                                     ; 6E72 00                       .
        brk                                     ; 6E73 00                       .
        brk                                     ; 6E74 00                       .
        rti                                     ; 6E75 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 6E76 00                       .
        brk                                     ; 6E77 00                       .
        jsr     L0000                           ; 6E78 20 00 00                  ..
        brk                                     ; 6E7B 00                       .
        bpl     L6ED2                           ; 6E7C 10 54                    .T
        and     $F2                             ; 6E7E 25 F2                    %.
        brk                                     ; 6E80 00                       .
        brk                                     ; 6E81 00                       .
        brk                                     ; 6E82 00                       .
        brk                                     ; 6E83 00                       .
        brk                                     ; 6E84 00                       .
        brk                                     ; 6E85 00                       .
        beq     L6E88                           ; 6E86 F0 00                    ..
L6E88:  bpl     L6E8A                           ; 6E88 10 00                    ..
L6E8A:  brk                                     ; 6E8A 00                       .
        brk                                     ; 6E8B 00                       .
        brk                                     ; 6E8C 00                       .
        brk                                     ; 6E8D 00                       .
L6E8E:  brk                                     ; 6E8E 00                       .
        brk                                     ; 6E8F 00                       .
        .byte   $FF                             ; 6E90 FF                       .
        .byte   $FF                             ; 6E91 FF                       .
        brk                                     ; 6E92 00                       .
        brk                                     ; 6E93 00                       .
        .byte   $FF                             ; 6E94 FF                       .
        .byte   $FF                             ; 6E95 FF                       .
        brk                                     ; 6E96 00                       .
        brk                                     ; 6E97 00                       .
        .byte   $FF                             ; 6E98 FF                       .
        .byte   $FF                             ; 6E99 FF                       .
        brk                                     ; 6E9A 00                       .
        brk                                     ; 6E9B 00                       .
        .byte   $FF                             ; 6E9C FF                       .
        .byte   $FF                             ; 6E9D FF                       .
        brk                                     ; 6E9E 00                       .
        brk                                     ; 6E9F 00                       .
        .byte   $FF                             ; 6EA0 FF                       .
        .byte   $FF                             ; 6EA1 FF                       .
        brk                                     ; 6EA2 00                       .
        brk                                     ; 6EA3 00                       .
        .byte   $FF                             ; 6EA4 FF                       .
        .byte   $FF                             ; 6EA5 FF                       .
        brk                                     ; 6EA6 00                       .
        brk                                     ; 6EA7 00                       .
        .byte   $FF                             ; 6EA8 FF                       .
        .byte   $FF                             ; 6EA9 FF                       .
        brk                                     ; 6EAA 00                       .
        brk                                     ; 6EAB 00                       .
        .byte   $FF                             ; 6EAC FF                       .
        .byte   $FF                             ; 6EAD FF                       .
        brk                                     ; 6EAE 00                       .
        brk                                     ; 6EAF 00                       .
        .byte   $FF                             ; 6EB0 FF                       .
        .byte   $FF                             ; 6EB1 FF                       .
        brk                                     ; 6EB2 00                       .
        brk                                     ; 6EB3 00                       .
        .byte   $FF                             ; 6EB4 FF                       .
        .byte   $FF                             ; 6EB5 FF                       .
        brk                                     ; 6EB6 00                       .
        brk                                     ; 6EB7 00                       .
        .byte   $FF                             ; 6EB8 FF                       .
        .byte   $FF                             ; 6EB9 FF                       .
        brk                                     ; 6EBA 00                       .
        brk                                     ; 6EBB 00                       .
        .byte   $FF                             ; 6EBC FF                       .
        .byte   $FF                             ; 6EBD FF                       .
        brk                                     ; 6EBE 00                       .
        brk                                     ; 6EBF 00                       .
        .byte   $FF                             ; 6EC0 FF                       .
        .byte   $FF                             ; 6EC1 FF                       .
        brk                                     ; 6EC2 00                       .
        brk                                     ; 6EC3 00                       .
        .byte   $FF                             ; 6EC4 FF                       .
        .byte   $FF                             ; 6EC5 FF                       .
        brk                                     ; 6EC6 00                       .
        brk                                     ; 6EC7 00                       .
        .byte   $FF                             ; 6EC8 FF                       .
        .byte   $FF                             ; 6EC9 FF                       .
        brk                                     ; 6ECA 00                       .
        brk                                     ; 6ECB 00                       .
        .byte   $FF                             ; 6ECC FF                       .
        .byte   $FF                             ; 6ECD FF                       .
        brk                                     ; 6ECE 00                       .
        brk                                     ; 6ECF 00                       .
        .byte   $FF                             ; 6ED0 FF                       .
        .byte   $FF                             ; 6ED1 FF                       .
L6ED2:  brk                                     ; 6ED2 00                       .
        brk                                     ; 6ED3 00                       .
        .byte   $FF                             ; 6ED4 FF                       .
        .byte   $FF                             ; 6ED5 FF                       .
        brk                                     ; 6ED6 00                       .
        brk                                     ; 6ED7 00                       .
        .byte   $FF                             ; 6ED8 FF                       .
        .byte   $FF                             ; 6ED9 FF                       .
        brk                                     ; 6EDA 00                       .
        brk                                     ; 6EDB 00                       .
        .byte   $FF                             ; 6EDC FF                       .
        .byte   $FF                             ; 6EDD FF                       .
        brk                                     ; 6EDE 00                       .
        brk                                     ; 6EDF 00                       .
        .byte   $FF                             ; 6EE0 FF                       .
        .byte   $FF                             ; 6EE1 FF                       .
        brk                                     ; 6EE2 00                       .
        brk                                     ; 6EE3 00                       .
        .byte   $FF                             ; 6EE4 FF                       .
        .byte   $FF                             ; 6EE5 FF                       .
        brk                                     ; 6EE6 00                       .
        brk                                     ; 6EE7 00                       .
        .byte   $FF                             ; 6EE8 FF                       .
        .byte   $FF                             ; 6EE9 FF                       .
        brk                                     ; 6EEA 00                       .
        brk                                     ; 6EEB 00                       .
        .byte   $FF                             ; 6EEC FF                       .
        .byte   $FF                             ; 6EED FF                       .
        brk                                     ; 6EEE 00                       .
        brk                                     ; 6EEF 00                       .
        .byte   $FF                             ; 6EF0 FF                       .
        .byte   $FF                             ; 6EF1 FF                       .
        brk                                     ; 6EF2 00                       .
        brk                                     ; 6EF3 00                       .
        .byte   $FF                             ; 6EF4 FF                       .
        .byte   $FF                             ; 6EF5 FF                       .
        brk                                     ; 6EF6 00                       .
        brk                                     ; 6EF7 00                       .
        .byte   $FF                             ; 6EF8 FF                       .
        .byte   $FF                             ; 6EF9 FF                       .
        brk                                     ; 6EFA 00                       .
        brk                                     ; 6EFB 00                       .
        .byte   $FF                             ; 6EFC FF                       .
        .byte   $FF                             ; 6EFD FF                       .
        brk                                     ; 6EFE 00                       .
        brk                                     ; 6EFF 00                       .
L6F00:  jmp     L6F15                           ; 6F00 4C 15 6F                 L.o

; ----------------------------------------------------------------------------
L6F03:  jmp     L6F16                           ; 6F03 4C 16 6F                 L.o

; ----------------------------------------------------------------------------
L6F06:  jmp     L6F1E                           ; 6F06 4C 1E 6F                 L.o

; ----------------------------------------------------------------------------
L6F09:  jmp     L6F1F                           ; 6F09 4C 1F 6F                 L.o

; ----------------------------------------------------------------------------
L6F0C:  jmp     L72AF                           ; 6F0C 4C AF 72                 L.r

; ----------------------------------------------------------------------------
L6F0F:  jmp     L72D3                           ; 6F0F 4C D3 72                 L.r

; ----------------------------------------------------------------------------
L6F12:  jmp     L7830                           ; 6F12 4C 30 78                 L0x

; ----------------------------------------------------------------------------
L6F15:  rts                                     ; 6F15 60                       `

; ----------------------------------------------------------------------------
L6F16:  lda     #$00                            ; 6F16 A9 00                    ..
        sta     $60FE                           ; 6F18 8D FE 60                 ..`
        sta     $60FF                           ; 6F1B 8D FF 60                 ..`
L6F1E:  rts                                     ; 6F1E 60                       `

; ----------------------------------------------------------------------------
L6F1F:  ldy     #$67                            ; 6F1F A0 67                    .g
        sty     $6012                           ; 6F21 8C 12 60                 ..`
        lda     #$00                            ; 6F24 A9 00                    ..
L6F26:  sta     $6124,y                         ; 6F26 99 24 61                 .$a
        sta     $6604,y                         ; 6F29 99 04 66                 ..f
        dey                                     ; 6F2C 88                       .
        bpl     L6F26                           ; 6F2D 10 F7                    ..
        ldy     #$0C                            ; 6F2F A0 0C                    ..
L6F31:  sta     $6117,y                         ; 6F31 99 17 61                 ..a
        dey                                     ; 6F34 88                       .
        bne     L6F31                           ; 6F35 D0 FA                    ..
        jsr     L6F46                           ; 6F37 20 46 6F                  Fo
        jsr     L6FC4                           ; 6F3A 20 C4 6F                  .o
        jsr     L7710                           ; 6F3D 20 10 77                  .w
        jsr     L70B4                           ; 6F40 20 B4 70                  .p
        jmp     L7786                           ; 6F43 4C 86 77                 L.w

; ----------------------------------------------------------------------------
L6F46:  jsr     L6F90                           ; 6F46 20 90 6F                  .o
        lda     #$01                            ; 6F49 A9 01                    ..
        sta     $6124,y                         ; 6F4B 99 24 61                 .$a
        sty     $60E0                           ; 6F4E 8C E0 60                 ..`
        jsr     L6F90                           ; 6F51 20 90 6F                  .o
        lda     #$01                            ; 6F54 A9 01                    ..
        sta     $6124,y                         ; 6F56 99 24 61                 .$a
        sty     $60DF                           ; 6F59 8C DF 60                 ..`
        ldx     $60E0                           ; 6F5C AE E0 60                 ..`
        lda     #$00                            ; 6F5F A9 00                    ..
        sta     $618C,y                         ; 6F61 99 8C 61                 ..a
        sta     $618C,x                         ; 6F64 9D 8C 61                 ..a
        lda     #$FF                            ; 6F67 A9 FF                    ..
        sta     $61F4,y                         ; 6F69 99 F4 61                 ..a
        sta     $625C,x                         ; 6F6C 9D 5C 62                 .\b
        txa                                     ; 6F6F 8A                       .
        sta     $625C,y                         ; 6F70 99 5C 62                 .\b
        tya                                     ; 6F73 98                       .
        sta     $61F4,x                         ; 6F74 9D F4 61                 ..a
        lda     #$00                            ; 6F77 A9 00                    ..
        sta     $632C,y                         ; 6F79 99 2C 63                 .,c
        sta     $6394,y                         ; 6F7C 99 94 63                 ..c
        sta     $63FC,y                         ; 6F7F 99 FC 63                 ..c
        sta     $63FC,x                         ; 6F82 9D FC 63                 ..c
        lda     #$FF                            ; 6F85 A9 FF                    ..
        sta     $632C,x                         ; 6F87 9D 2C 63                 .,c
        sta     $6394,x                         ; 6F8A 9D 94 63                 ..c
        rts                                     ; 6F8D 60                       `

; ----------------------------------------------------------------------------
L6F8E:  sec                                     ; 6F8E 38                       8
        .byte   $90                             ; 6F8F 90                       .
L6F90:  clc                                     ; 6F90 18                       .
        ldx     #$68                            ; 6F91 A2 68                    .h
        ldy     $6012                           ; 6F93 AC 12 60                 ..`
L6F96:  lda     $6124,y                         ; 6F96 B9 24 61                 .$a
        beq     L6FBA                           ; 6F99 F0 1F                    ..
        dex                                     ; 6F9B CA                       .
        beq     L6FA5                           ; 6F9C F0 07                    ..
        dey                                     ; 6F9E 88                       .
        bpl     L6F96                           ; 6F9F 10 F5                    ..
        ldy     #$67                            ; 6FA1 A0 67                    .g
        bne     L6F96                           ; 6FA3 D0 F1                    ..
L6FA5:  bcs     L6FC3                           ; 6FA5 B0 1C                    ..
        lda     #$0C                            ; 6FA7 A9 0C                    ..
        ldx     #$68                            ; 6FA9 A2 68                    .h
L6FAB:  cmp     $6124,y                         ; 6FAB D9 24 61                 .$a
        beq     L6FBA                           ; 6FAE F0 0A                    ..
        dex                                     ; 6FB0 CA                       .
        beq     L6FC2                           ; 6FB1 F0 0F                    ..
        dey                                     ; 6FB3 88                       .
        bpl     L6FAB                           ; 6FB4 10 F5                    ..
        ldy     #$67                            ; 6FB6 A0 67                    .g
        bne     L6FAB                           ; 6FB8 D0 F1                    ..
L6FBA:  sty     $60C3                           ; 6FBA 8C C3 60                 ..`
        sty     $6012                           ; 6FBD 8C 12 60                 ..`
        clc                                     ; 6FC0 18                       .
        rts                                     ; 6FC1 60                       `

; ----------------------------------------------------------------------------
L6FC2:  sec                                     ; 6FC2 38                       8
L6FC3:  rts                                     ; 6FC3 60                       `

; ----------------------------------------------------------------------------
L6FC4:  lda     #$01                            ; 6FC4 A9 01                    ..
        sta     $60BD                           ; 6FC6 8D BD 60                 ..`
        jsr     L6FCF                           ; 6FC9 20 CF 6F                  .o
        dec     $60BD                           ; 6FCC CE BD 60                 ..`
L6FCF:  lda     #$65                            ; 6FCF A9 65                    .e
        sta     $6012                           ; 6FD1 8D 12 60                 ..`
        jsr     L6F90                           ; 6FD4 20 90 6F                  .o
        bcs     L6FC3                           ; 6FD7 B0 EA                    ..
        tya                                     ; 6FD9 98                       .
        ldx     $60BD                           ; 6FDA AE BD 60                 ..`
        sta     $6112,x                         ; 6FDD 9D 12 61                 ..a
        lda     #$02                            ; 6FE0 A9 02                    ..
        sta     $6124,y                         ; 6FE2 99 24 61                 .$a
        sty     L0060                           ; 6FE5 84 60                    .`
        jsr     L6F90                           ; 6FE7 20 90 6F                  .o
        bcs     L6FC3                           ; 6FEA B0 D7                    ..
        ldy     L0060                           ; 6FEC A4 60                    .`
        ldx     $60BD                           ; 6FEE AE BD 60                 ..`
        lda     #$01                            ; 6FF1 A9 01                    ..
        sta     $62C4,y                         ; 6FF3 99 C4 62                 ..b
        lda     #$00                            ; 6FF6 A9 00                    ..
        sta     $6464,y                         ; 6FF8 99 64 64                 .dd
        sta     $6100,x                         ; 6FFB 9D 00 61                 ..a
        sta     $6104,x                         ; 6FFE 9D 04 61                 ..a
        sta     $610A,x                         ; 7001 9D 0A 61                 ..a
        lda     #$FF                            ; 7004 A9 FF                    ..
        sta     $610E,x                         ; 7006 9D 0E 61                 ..a
        sta     $6114,x                         ; 7009 9D 14 61                 ..a
        lda     #$01                            ; 700C A9 01                    ..
        sta     $618C,y                         ; 700E 99 8C 61                 ..a
        lda     #$0F                            ; 7011 A9 0F                    ..
        sta     $659C,y                         ; 7013 99 9C 65                 ..e
        lda     #$09                            ; 7016 A9 09                    ..
        sta     $666C,y                         ; 7018 99 6C 66                 .lf
        txa                                     ; 701B 8A                       .
        sta     $6604,y                         ; 701C 99 04 66                 ..f
        lda     $60B6                           ; 701F AD B6 60                 ..`
        bne     L7027                           ; 7022 D0 03                    ..
        txa                                     ; 7024 8A                       .
        eor     #$01                            ; 7025 49 01                    I.
L7027:  eor     #$01                            ; 7027 49 01                    I.
        sta     $60F8,x                         ; 7029 9D F8 60                 ..`
        lda     L7915,x                         ; 702C BD 15 79                 ..y
        clc                                     ; 702F 18                       .
        adc     #$08                            ; 7030 69 08                    i.
        sta     $6394,y                         ; 7032 99 94 63                 ..c
        lda     L791B,x                         ; 7035 BD 1B 79                 ..y
        adc     #$00                            ; 7038 69 00                    i.
        sta     $632C,y                         ; 703A 99 2C 63                 .,c
        lda     #$DC                            ; 703D A9 DC                    ..
        sta     $63FC,y                         ; 703F 99 FC 63                 ..c
        lda     #$00                            ; 7042 A9 00                    ..
        sta     $64CC,y                         ; 7044 99 CC 64                 ..d
        sta     $6534,y                         ; 7047 99 34 65                 .4e
        lda     #$80                            ; 704A A9 80                    ..
        sta     $6108,x                         ; 704C 9D 08 61                 ..a
        lda     #$0A                            ; 704F A9 0A                    ..
        sta     $60F4,x                         ; 7051 9D F4 60                 ..`
        lda     #$40                            ; 7054 A9 40                    .@
        sta     $60F6,x                         ; 7056 9D F6 60                 ..`
        lda     $60EE                           ; 7059 AD EE 60                 ..`
        beq     L7063                           ; 705C F0 05                    ..
        lda     #$06                            ; 705E A9 06                    ..
        sta     $60F6,x                         ; 7060 9D F6 60                 ..`
L7063:  lda     #$02                            ; 7063 A9 02                    ..
        sta     $6102,x                         ; 7065 9D 02 61                 ..a
        sty     $60C3                           ; 7068 8C C3 60                 ..`
        lda     $60BD                           ; 706B AD BD 60                 ..`
        beq     L7078                           ; 706E F0 08                    ..
        ldx     $60A7                           ; 7070 AE A7 60                 ..`
        lda     #$00                            ; 7073 A9 00                    ..
        jsr     L690C                           ; 7075 20 0C 69                  .i
L7078:  jsr     L7830                           ; 7078 20 30 78                  0x
        jsr     L6F90                           ; 707B 20 90 6F                  .o
        lda     #$03                            ; 707E A9 03                    ..
        sta     $6124,y                         ; 7080 99 24 61                 .$a
        lda     #$02                            ; 7083 A9 02                    ..
        sta     $618C,y                         ; 7085 99 8C 61                 ..a
        lda     #$FF                            ; 7088 A9 FF                    ..
        sta     $62C4,y                         ; 708A 99 C4 62                 ..b
        sta     $666C,y                         ; 708D 99 6C 66                 .lf
        lda     $60BD                           ; 7090 AD BD 60                 ..`
        sta     $6604,y                         ; 7093 99 04 66                 ..f
        lda     #$80                            ; 7096 A9 80                    ..
        sta     $632C,y                         ; 7098 99 2C 63                 .,c
        sta     $63FC,y                         ; 709B 99 FC 63                 ..c
        lda     #$01                            ; 709E A9 01                    ..
        sta     $6464,y                         ; 70A0 99 64 64                 .dd
        lda     #$00                            ; 70A3 A9 00                    ..
        sta     $6394,y                         ; 70A5 99 94 63                 ..c
        lda     L0060                           ; 70A8 A5 60                    .`
        sta     $66D4,y                         ; 70AA 99 D4 66                 ..f
        tax                                     ; 70AD AA                       .
        tya                                     ; 70AE 98                       .
        sta     $66D4,x                         ; 70AF 9D D4 66                 ..f
        clc                                     ; 70B2 18                       .
        rts                                     ; 70B3 60                       `

; ----------------------------------------------------------------------------
L70B4:  lda     #$00                            ; 70B4 A9 00                    ..
        sta     L79FC                           ; 70B6 8D FC 79                 ..y
        lda     #$00                            ; 70B9 A9 00                    ..
        sta     $60CD                           ; 70BB 8D CD 60                 ..`
        lda     #$02                            ; 70BE A9 02                    ..
        sta     $60CC                           ; 70C0 8D CC 60                 ..`
L70C3:  ldy     L79FC                           ; 70C3 AC FC 79                 ..y
        lda     $4000,y                         ; 70C6 B9 00 40                 ..@
        beq     L70D1                           ; 70C9 F0 06                    ..
        jsr     L70F5                           ; 70CB 20 F5 70                  .p
        ldy     L79FC                           ; 70CE AC FC 79                 ..y
L70D1:  lda     $4020,y                         ; 70D1 B9 20 40                 . @
        beq     L70D9                           ; 70D4 F0 03                    ..
        jsr     L70F9                           ; 70D6 20 F9 70                  .p
L70D9:  inc     L79FC                           ; 70D9 EE FC 79                 ..y
        lda     $60CD                           ; 70DC AD CD 60                 ..`
        clc                                     ; 70DF 18                       .
        adc     #$60                            ; 70E0 69 60                    i`
        sta     $60CD                           ; 70E2 8D CD 60                 ..`
        lda     #$00                            ; 70E5 A9 00                    ..
        adc     $60CC                           ; 70E7 6D CC 60                 m.`
        sta     $60CC                           ; 70EA 8D CC 60                 ..`
        lda     L79FC                           ; 70ED AD FC 79                 ..y
        cmp     #$20                            ; 70F0 C9 20                    . 
        bne     L70C3                           ; 70F2 D0 CF                    ..
        rts                                     ; 70F4 60                       `

; ----------------------------------------------------------------------------
L70F5:  ldx     #$06                            ; 70F5 A2 06                    ..
        bne     L70FB                           ; 70F7 D0 02                    ..
L70F9:  ldx     #$09                            ; 70F9 A2 09                    ..
L70FB:  stx     $60A7                           ; 70FB 8E A7 60                 ..`
        sta     $65                             ; 70FE 85 65                    .e
        lda     $60CD                           ; 7100 AD CD 60                 ..`
        pha                                     ; 7103 48                       H
        lda     $60CC                           ; 7104 AD CC 60                 ..`
        pha                                     ; 7107 48                       H
        lda     $4040,y                         ; 7108 B9 40 40                 .@@
        sta     $64                             ; 710B 85 64                    .d
        lda     #$07                            ; 710D A9 07                    ..
        sta     $60E3                           ; 710F 8D E3 60                 ..`
L7112:  asl     $65                             ; 7112 06 65                    .e
        bcc     L712A                           ; 7114 90 14                    ..
        lda     $64                             ; 7116 A5 64                    .d
        asl     a                               ; 7118 0A                       .
        lda     #$00                            ; 7119 A9 00                    ..
        rol     a                               ; 711B 2A                       *
        sta     $60BD                           ; 711C 8D BD 60                 ..`
        lda     $60A7                           ; 711F AD A7 60                 ..`
        pha                                     ; 7122 48                       H
        jsr     L6F0C                           ; 7123 20 0C 6F                  .o
        pla                                     ; 7126 68                       h
        sta     $60A7                           ; 7127 8D A7 60                 ..`
L712A:  asl     $64                             ; 712A 06 64                    .d
        lda     $60CD                           ; 712C AD CD 60                 ..`
        clc                                     ; 712F 18                       .
        adc     #$0C                            ; 7130 69 0C                    i.
        sta     $60CD                           ; 7132 8D CD 60                 ..`
        lda     $60CC                           ; 7135 AD CC 60                 ..`
        adc     #$00                            ; 7138 69 00                    i.
        sta     $60CC                           ; 713A 8D CC 60                 ..`
        dec     $60E3                           ; 713D CE E3 60                 ..`
        bpl     L7112                           ; 7140 10 D0                    ..
        pla                                     ; 7142 68                       h
        sta     $60CC                           ; 7143 8D CC 60                 ..`
        pla                                     ; 7146 68                       h
        sta     $60CD                           ; 7147 8D CD 60                 ..`
        rts                                     ; 714A 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 714B A9 00                    ..
        sta     $60B3                           ; 714D 8D B3 60                 ..`
        jsr     L76B9                           ; 7150 20 B9 76                  .v
        lda     $6106,x                         ; 7153 BD 06 61                 ..a
        bpl     L715C                           ; 7156 10 04                    ..
        tya                                     ; 7158 98                       .
        sta     $6106,x                         ; 7159 9D 06 61                 ..a
L715C:  rts                                     ; 715C 60                       `

; ----------------------------------------------------------------------------
        lda     #$80                            ; 715D A9 80                    ..
        sta     $60B3                           ; 715F 8D B3 60                 ..`
        jsr     L76B9                           ; 7162 20 B9 76                  .v
        lda     #$FF                            ; 7165 A9 FF                    ..
        sta     $66D4,y                         ; 7167 99 D4 66                 ..f
        tya                                     ; 716A 98                       .
        sta     $60F2,x                         ; 716B 9D F2 60                 ..`
        rts                                     ; 716E 60                       `

; ----------------------------------------------------------------------------
        lda     #$2F                            ; 716F A9 2F                    ./
        sta     $60B3                           ; 7171 8D B3 60                 ..`
        jsr     L76B9                           ; 7174 20 B9 76                  .v
        lda     $406D                           ; 7177 AD 6D 40                 .m@
        sta     $67A4,y                         ; 717A 99 A4 67                 ..g
        sec                                     ; 717D 38                       8
        adc     $6118,x                         ; 717E 7D 18 61                 }.a
        sta     $6118,x                         ; 7181 9D 18 61                 ..a
        lda     $406D                           ; 7184 AD 6D 40                 .m@
        adc     $611E,x                         ; 7187 7D 1E 61                 }.a
        sta     $611E,x                         ; 718A 9D 1E 61                 ..a
        inc     $611C,x                         ; 718D FE 1C 61                 ..a
        sty     L0060                           ; 7190 84 60                    .`
        lda     #$06                            ; 7192 A9 06                    ..
        sta     $60B3                           ; 7194 8D B3 60                 ..`
        lda     #$07                            ; 7197 A9 07                    ..
        jsr     L76B6                           ; 7199 20 B6 76                  .v
        lda     $60CC                           ; 719C AD CC 60                 ..`
        and     #$08                            ; 719F 29 08                    ).
        beq     L71A4                           ; 71A1 F0 01                    ..
        sec                                     ; 71A3 38                       8
L71A4:  lda     #$00                            ; 71A4 A9 00                    ..
        sta     $64CC,y                         ; 71A6 99 CC 64                 ..d
        sta     $6534,y                         ; 71A9 99 34 65                 .4e
        rol     a                               ; 71AC 2A                       *
        eor     #$01                            ; 71AD 49 01                    I.
        adc     #$12                            ; 71AF 69 12                    i.
        sta     $62C4,y                         ; 71B1 99 C4 62                 ..b
        lda     #$CD                            ; 71B4 A9 CD                    ..
        sta     $63FC,y                         ; 71B6 99 FC 63                 ..c
        lda     L0060                           ; 71B9 A5 60                    .`
        sta     $66D4,y                         ; 71BB 99 D4 66                 ..f
        tax                                     ; 71BE AA                       .
        tya                                     ; 71BF 98                       .
        sta     $66D4,x                         ; 71C0 9D D4 66                 ..f
        jsr     L6906                           ; 71C3 20 06 69                  .i
        and     #$3F                            ; 71C6 29 3F                    )?
        clc                                     ; 71C8 18                       .
        adc     #$7B                            ; 71C9 69 7B                    i{
        sta     $673C,y                         ; 71CB 99 3C 67                 .<g
        sty     L0060                           ; 71CE 84 60                    .`
        jsr     L6F90                           ; 71D0 20 90 6F                  .o
        lda     #$08                            ; 71D3 A9 08                    ..
        sta     $6124,y                         ; 71D5 99 24 61                 .$a
        lda     #$01                            ; 71D8 A9 01                    ..
        sta     $618C,y                         ; 71DA 99 8C 61                 ..a
        lda     #$D1                            ; 71DD A9 D1                    ..
        sta     $6464,y                         ; 71DF 99 64 64                 .dd
        lda     #$00                            ; 71E2 A9 00                    ..
        sta     $64CC,y                         ; 71E4 99 CC 64                 ..d
        sta     $6534,y                         ; 71E7 99 34 65                 .4e
        lda     #$F0                            ; 71EA A9 F0                    ..
        sta     $62C4,y                         ; 71EC 99 C4 62                 ..b
        lda     $60CD                           ; 71EF AD CD 60                 ..`
        clc                                     ; 71F2 18                       .
        adc     #$04                            ; 71F3 69 04                    i.
        sta     $6394,y                         ; 71F5 99 94 63                 ..c
        lda     $60CC                           ; 71F8 AD CC 60                 ..`
        adc     #$00                            ; 71FB 69 00                    i.
        sta     $632C,y                         ; 71FD 99 2C 63                 .,c
        lda     #$80                            ; 7200 A9 80                    ..
        sta     $659C,y                         ; 7202 99 9C 65                 ..e
        lda     #$FF                            ; 7205 A9 FF                    ..
        sta     $666C,y                         ; 7207 99 6C 66                 .lf
        lda     $60BD                           ; 720A AD BD 60                 ..`
        sta     $6604,y                         ; 720D 99 04 66                 ..f
        lda     L0060                           ; 7210 A5 60                    .`
        sta     $66D4,y                         ; 7212 99 D4 66                 ..f
        tax                                     ; 7215 AA                       .
        lda     $63FC,x                         ; 7216 BD FC 63                 ..c
        sta     $63FC,y                         ; 7219 99 FC 63                 ..c
        tya                                     ; 721C 98                       .
        sta     $67A4,x                         ; 721D 9D A4 67                 ..g
        lda     $66D4,x                         ; 7220 BD D4 66                 ..f
        sta     $673C,y                         ; 7223 99 3C 67                 .<g
        tax                                     ; 7226 AA                       .
        tya                                     ; 7227 98                       .
        sta     $673C,x                         ; 7228 9D 3C 67                 .<g
        jmp     L7830                           ; 722B 4C 30 78                 L0x

; ----------------------------------------------------------------------------
        lda     #$16                            ; 722E A9 16                    ..
        sta     $60B3                           ; 7230 8D B3 60                 ..`
        lda     $60BD                           ; 7233 AD BD 60                 ..`
        beq     L7240                           ; 7236 F0 08                    ..
        lda     #$00                            ; 7238 A9 00                    ..
        ldx     $60A7                           ; 723A AE A7 60                 ..`
        jsr     L690C                           ; 723D 20 0C 69                  .i
L7240:  jsr     L76B9                           ; 7240 20 B9 76                  .v
        lda     $60E3                           ; 7243 AD E3 60                 ..`
        and     #$01                            ; 7246 29 01                    ).
        sta     $66D4,y                         ; 7248 99 D4 66                 ..f
        rts                                     ; 724B 60                       `

; ----------------------------------------------------------------------------
        lda     #$07                            ; 724C A9 07                    ..
        sta     $60B3                           ; 724E 8D B3 60                 ..`
        lda     $60C3                           ; 7251 AD C3 60                 ..`
        sta     L0060                           ; 7254 85 60                    .`
        jsr     L76B9                           ; 7256 20 B9 76                  .v
        bcs     L7285                           ; 7259 B0 2A                    .*
        ldx     #$02                            ; 725B A2 02                    ..
        cpy     L0060                           ; 725D C4 60                    .`
        bcc     L7262                           ; 725F 90 01                    ..
        dex                                     ; 7261 CA                       .
L7262:  txa                                     ; 7262 8A                       .
        sta     $67A4,y                         ; 7263 99 A4 67                 ..g
        lda     #$00                            ; 7266 A9 00                    ..
        sta     $6534,y                         ; 7268 99 34 65                 .4e
        lda     #$03                            ; 726B A9 03                    ..
        sta     $673C,y                         ; 726D 99 3C 67                 .<g
        jsr     L7534                           ; 7270 20 34 75                  4u
        ldx     #$3D                            ; 7273 A2 3D                    .=
        lda     $60CF                           ; 7275 AD CF 60                 ..`
        bne     L727E                           ; 7278 D0 04                    ..
        ldx     #$3A                            ; 727A A2 3A                    .:
        bne     L7281                           ; 727C D0 03                    ..
L727E:  bmi     L7281                           ; 727E 30 01                    0.
        inx                                     ; 7280 E8                       .
L7281:  txa                                     ; 7281 8A                       .
        sta     $62C4,y                         ; 7282 99 C4 62                 ..b
L7285:  rts                                     ; 7285 60                       `

; ----------------------------------------------------------------------------
        jsr     L76B9                           ; 7286 20 B9 76                  .v
        bcs     L72AE                           ; 7289 B0 23                    .#
        lda     #$01                            ; 728B A9 01                    ..
        sta     $6464,y                         ; 728D 99 64 64                 .dd
        lda     $60A8                           ; 7290 AD A8 60                 ..`
        sta     $67A4,y                         ; 7293 99 A4 67                 ..g
        clc                                     ; 7296 18                       .
        adc     #$0A                            ; 7297 69 0A                    i.
        sta     $673C,y                         ; 7299 99 3C 67                 .<g
        lda     $60CF                           ; 729C AD CF 60                 ..`
        sta     $64CC,y                         ; 729F 99 CC 64                 ..d
        lda     $60CE                           ; 72A2 AD CE 60                 ..`
        sta     $63FC,y                         ; 72A5 99 FC 63                 ..c
        lda     $60D0                           ; 72A8 AD D0 60                 ..`
        sta     $6534,y                         ; 72AB 99 34 65                 .4e
L72AE:  rts                                     ; 72AE 60                       `

; ----------------------------------------------------------------------------
L72AF:  txa                                     ; 72AF 8A                       .
        pha                                     ; 72B0 48                       H
        lda     $60C3                           ; 72B1 AD C3 60                 ..`
        pha                                     ; 72B4 48                       H
        lda     $60A7                           ; 72B5 AD A7 60                 ..`
        asl     a                               ; 72B8 0A                       .
        tay                                     ; 72B9 A8                       .
        lda     L7875,y                         ; 72BA B9 75 78                 .ux
        sta     L72C7                           ; 72BD 8D C7 72                 ..r
        lda     L7876,y                         ; 72C0 B9 76 78                 .vx
        sta     L72C8                           ; 72C3 8D C8 72                 ..r
        .byte   $20                             ; 72C6 20                        
L72C7:  .byte   $34                             ; 72C7 34                       4
L72C8:  .byte   $12                             ; 72C8 12                       .
        ldy     $60C3                           ; 72C9 AC C3 60                 ..`
        pla                                     ; 72CC 68                       h
        sta     $60C3                           ; 72CD 8D C3 60                 ..`
        pla                                     ; 72D0 68                       h
        tax                                     ; 72D1 AA                       .
        rts                                     ; 72D2 60                       `

; ----------------------------------------------------------------------------
L72D3:  tax                                     ; 72D3 AA                       .
        lda     $60C3                           ; 72D4 AD C3 60                 ..`
        pha                                     ; 72D7 48                       H
        txa                                     ; 72D8 8A                       .
L72D9:  pha                                     ; 72D9 48                       H
        jsr     L72E9                           ; 72DA 20 E9 72                  .r
        pla                                     ; 72DD 68                       h
        bcs     L72E4                           ; 72DE B0 04                    ..
        adc     #$FF                            ; 72E0 69 FF                    i.
        bne     L72D9                           ; 72E2 D0 F5                    ..
L72E4:  pla                                     ; 72E4 68                       h
        sta     $60C3                           ; 72E5 8D C3 60                 ..`
        rts                                     ; 72E8 60                       `

; ----------------------------------------------------------------------------
L72E9:  jsr     L6F8E                           ; 72E9 20 8E 6F                  .o
        bcs     L736D                           ; 72EC B0 7F                    ..
        lda     #$00                            ; 72EE A9 00                    ..
        sta     $6604,y                         ; 72F0 99 04 66                 ..f
        lda     #$FF                            ; 72F3 A9 FF                    ..
        sta     $62C4,y                         ; 72F5 99 C4 62                 ..b
        sta     $666C,y                         ; 72F8 99 6C 66                 .lf
        lda     #$0C                            ; 72FB A9 0C                    ..
        sta     $6124,y                         ; 72FD 99 24 61                 .$a
        lda     #$02                            ; 7300 A9 02                    ..
        sta     $618C,y                         ; 7302 99 8C 61                 ..a
        jsr     L7540                           ; 7305 20 40 75                  @u
        lda     $60CE                           ; 7308 AD CE 60                 ..`
        sta     $63FC,y                         ; 730B 99 FC 63                 ..c
        cmp     #$DD                            ; 730E C9 DD                    ..
        bne     L731C                           ; 7310 D0 0A                    ..
        lda     #$00                            ; 7312 A9 00                    ..
        sta     $60CF                           ; 7314 8D CF 60                 ..`
        lda     #$F8                            ; 7317 A9 F8                    ..
        sta     $60D0                           ; 7319 8D D0 60                 ..`
L731C:  lda     $60E7                           ; 731C AD E7 60                 ..`
        and     #$03                            ; 731F 29 03                    ).
        adc     #$01                            ; 7321 69 01                    i.
        sta     $659C,y                         ; 7323 99 9C 65                 ..e
        lda     $60E7                           ; 7326 AD E7 60                 ..`
        and     #$1C                            ; 7329 29 1C                    ).
        sta     $66D4,y                         ; 732B 99 D4 66                 ..f
        jsr     L6906                           ; 732E 20 06 69                  .i
        and     #$0F                            ; 7331 29 0F                    ).
        adc     #$0C                            ; 7333 69 0C                    i.
        sta     $673C,y                         ; 7335 99 3C 67                 .<g
        jsr     L6906                           ; 7338 20 06 69                  .i
        and     #$07                            ; 733B 29 07                    ).
        sbc     #$03                            ; 733D E9 03                    ..
        clc                                     ; 733F 18                       .
        adc     $60CF                           ; 7340 6D CF 60                 m.`
        sta     $64CC,y                         ; 7343 99 CC 64                 ..d
        jsr     L6906                           ; 7346 20 06 69                  .i
        and     #$0F                            ; 7349 29 0F                    ).
        sbc     #$07                            ; 734B E9 07                    ..
        clc                                     ; 734D 18                       .
        adc     $60D0                           ; 734E 6D D0 60                 m.`
        sta     $6534,y                         ; 7351 99 34 65                 .4e
        lda     $60A8                           ; 7354 AD A8 60                 ..`
        sta     $67A4,y                         ; 7357 99 A4 67                 ..g
        bpl     L736C                           ; 735A 10 10                    ..
        lda     $6534,y                         ; 735C B9 34 65                 .4e
        pha                                     ; 735F 48                       H
        asl     a                               ; 7360 0A                       .
        pla                                     ; 7361 68                       h
        ror     a                               ; 7362 6A                       j
        sta     $6534,y                         ; 7363 99 34 65                 .4e
        ldx     $60C3                           ; 7366 AE C3 60                 ..`
        lsr     $659C,x                         ; 7369 5E 9C 65                 ^.e
L736C:  clc                                     ; 736C 18                       .
L736D:  rts                                     ; 736D 60                       `

; ----------------------------------------------------------------------------
L736E:  lda     #$05                            ; 736E A9 05                    ..
        sta     $60B3                           ; 7370 8D B3 60                 ..`
        lda     $60E1                           ; 7373 AD E1 60                 ..`
        pha                                     ; 7376 48                       H
        jsr     L76B9                           ; 7377 20 B9 76                  .v
        pla                                     ; 737A 68                       h
        bcs     L73AB                           ; 737B B0 2E                    ..
        bpl     L738A                           ; 737D 10 0B                    ..
        tax                                     ; 737F AA                       .
        lda     L6942                           ; 7380 AD 42 69                 .Bi
        clc                                     ; 7383 18                       .
        adc     #$DD                            ; 7384 69 DD                    i.
        sta     $63FC,y                         ; 7386 99 FC 63                 ..c
        txa                                     ; 7389 8A                       .
L738A:  and     #$01                            ; 738A 29 01                    ).
        sta     $67A4,y                         ; 738C 99 A4 67                 ..g
        ldx     $60BD                           ; 738F AE BD 60                 ..`
        inc     $611E,x                         ; 7392 FE 1E 61                 ..a
        inc     $6118,x                         ; 7395 FE 18 61                 ..a
        lda     #$FF                            ; 7398 A9 FF                    ..
        sta     $66D4,y                         ; 739A 99 D4 66                 ..f
        lda     #$00                            ; 739D A9 00                    ..
        sta     $6874,y                         ; 739F 99 74 68                 .th
        sta     $6464,y                         ; 73A2 99 64 64                 .dd
        lda     L7923,x                         ; 73A5 BD 23 79                 .#y
        sta     $64CC,y                         ; 73A8 99 CC 64                 ..d
L73AB:  rts                                     ; 73AB 60                       `

; ----------------------------------------------------------------------------
        lda     #$0E                            ; 73AC A9 0E                    ..
        sta     $60A7                           ; 73AE 8D A7 60                 ..`
        lda     #$01                            ; 73B1 A9 01                    ..
        sta     L79FB                           ; 73B3 8D FB 79                 ..y
        lda     #$0F                            ; 73B6 A9 0F                    ..
        sta     $60B3                           ; 73B8 8D B3 60                 ..`
        ldx     $60BD                           ; 73BB AE BD 60                 ..`
        inc     $6120,x                         ; 73BE FE 20 61                 . a
        inc     $6118,x                         ; 73C1 FE 18 61                 ..a
        lda     #$06                            ; 73C4 A9 06                    ..
        sta     $0200                           ; 73C6 8D 00 02                 ...
        lda     #$2D                            ; 73C9 A9 2D                    .-
        jsr     L7425                           ; 73CB 20 25 74                  %t
        bcs     L73DB                           ; 73CE B0 0B                    ..
        ldy     $60C3                           ; 73D0 AC C3 60                 ..`
        lda     #$00                            ; 73D3 A9 00                    ..
        sta     $673C,y                         ; 73D5 99 3C 67                 .<g
        sta     $6874,y                         ; 73D8 99 74 68                 .th
L73DB:  rts                                     ; 73DB 60                       `

; ----------------------------------------------------------------------------
        lda     #$0F                            ; 73DC A9 0F                    ..
        sta     $60A7                           ; 73DE 8D A7 60                 ..`
        lda     #$01                            ; 73E1 A9 01                    ..
        sta     L79FB                           ; 73E3 8D FB 79                 ..y
        lda     #$06                            ; 73E6 A9 06                    ..
        sta     $60B3                           ; 73E8 8D B3 60                 ..`
        lda     #$06                            ; 73EB A9 06                    ..
        sta     $0200                           ; 73ED 8D 00 02                 ...
        lda     #$32                            ; 73F0 A9 32                    .2
        ldx     $60BD                           ; 73F2 AE BD 60                 ..`
        beq     L73F9                           ; 73F5 F0 02                    ..
        lda     #$34                            ; 73F7 A9 34                    .4
L73F9:  inc     $611A,x                         ; 73F9 FE 1A 61                 ..a
        inc     $6118,x                         ; 73FC FE 18 61                 ..a
        jmp     L7425                           ; 73FF 4C 25 74                 L%t

; ----------------------------------------------------------------------------
        lda     #$10                            ; 7402 A9 10                    ..
        sta     $60A7                           ; 7404 8D A7 60                 ..`
        lda     #$01                            ; 7407 A9 01                    ..
        sta     L79FB                           ; 7409 8D FB 79                 ..y
        lda     #$09                            ; 740C A9 09                    ..
        sta     $60B3                           ; 740E 8D B3 60                 ..`
        lda     #$07                            ; 7411 A9 07                    ..
        sta     $0200                           ; 7413 8D 00 02                 ...
        lda     #$41                            ; 7416 A9 41                    .A
        ldx     $60BD                           ; 7418 AE BD 60                 ..`
        beq     L741F                           ; 741B F0 02                    ..
        lda     #$43                            ; 741D A9 43                    .C
L741F:  inc     $6122,x                         ; 741F FE 22 61                 ."a
        inc     $6118,x                         ; 7422 FE 18 61                 ..a
L7425:  sta     $10                             ; 7425 85 10                    ..
        jsr     L6F90                           ; 7427 20 90 6F                  .o
        bcs     L74A1                           ; 742A B0 75                    .u
        lda     $60A7                           ; 742C AD A7 60                 ..`
        sta     $6124,y                         ; 742F 99 24 61                 .$a
        lda     L79FB                           ; 7432 AD FB 79                 ..y
        sta     $618C,y                         ; 7435 99 8C 61                 ..a
        lda     $60CC                           ; 7438 AD CC 60                 ..`
        ora     $60CD                           ; 743B 0D CD 60                 ..`
        beq     L744F                           ; 743E F0 0F                    ..
        lda     $60CD                           ; 7440 AD CD 60                 ..`
        sta     $6394,y                         ; 7443 99 94 63                 ..c
        lda     $60CC                           ; 7446 AD CC 60                 ..`
        sta     $632C,y                         ; 7449 99 2C 63                 .,c
        jmp     L7468                           ; 744C 4C 68 74                 Lht

; ----------------------------------------------------------------------------
L744F:  lda     #$00                            ; 744F A9 00                    ..
        sta     $632C,y                         ; 7451 99 2C 63                 .,c
        lda     #$08                            ; 7454 A9 08                    ..
        sta     $6394,y                         ; 7456 99 94 63                 ..c
        lda     $60BD                           ; 7459 AD BD 60                 ..`
        beq     L7478                           ; 745C F0 1A                    ..
        lda     #$0F                            ; 745E A9 0F                    ..
        sta     $632C,y                         ; 7460 99 2C 63                 .,c
        lda     #$F7                            ; 7463 A9 F7                    ..
        sta     $6394,y                         ; 7465 99 94 63                 ..c
L7468:  ldx     #$01                            ; 7468 A2 01                    ..
        lda     $60BD                           ; 746A AD BD 60                 ..`
        beq     L7471                           ; 746D F0 02                    ..
        ldx     #$FF                            ; 746F A2 FF                    ..
L7471:  sta     $6604,y                         ; 7471 99 04 66                 ..f
        txa                                     ; 7474 8A                       .
        sta     $64CC,y                         ; 7475 99 CC 64                 ..d
L7478:  ldx     $6124,y                         ; 7478 BE 24 61                 .$a
        lda     L6935,x                         ; 747B BD 35 69                 .5i
        clc                                     ; 747E 18                       .
        adc     #$DD                            ; 747F 69 DD                    i.
        sta     $63FC,y                         ; 7481 99 FC 63                 ..c
        lda     #$00                            ; 7484 A9 00                    ..
        sta     $6534,y                         ; 7486 99 34 65                 .4e
        lda     $0200                           ; 7489 AD 00 02                 ...
        sta     $666C,y                         ; 748C 99 6C 66                 .lf
        lda     $60B3                           ; 748F AD B3 60                 ..`
        sta     $659C,y                         ; 7492 99 9C 65                 ..e
        lda     $10                             ; 7495 A5 10                    ..
        sta     $67A4,y                         ; 7497 99 A4 67                 ..g
        sta     $62C4,y                         ; 749A 99 C4 62                 ..b
        jsr     L6F12                           ; 749D 20 12 6F                  .o
        clc                                     ; 74A0 18                       .
L74A1:  rts                                     ; 74A1 60                       `

; ----------------------------------------------------------------------------
        lda     $60C3                           ; 74A2 AD C3 60                 ..`
        sta     L0060                           ; 74A5 85 60                    .`
        jsr     L6F90                           ; 74A7 20 90 6F                  .o
        bcs     L74DD                           ; 74AA B0 31                    .1
        lda     #$11                            ; 74AC A9 11                    ..
        sta     $6124,y                         ; 74AE 99 24 61                 .$a
        lda     #$02                            ; 74B1 A9 02                    ..
        sta     $618C,y                         ; 74B3 99 8C 61                 ..a
        lda     #$FF                            ; 74B6 A9 FF                    ..
        sta     $666C,y                         ; 74B8 99 6C 66                 .lf
        jsr     L753A                           ; 74BB 20 3A 75                  :u
        lda     $10                             ; 74BE A5 10                    ..
        sta     $62C4,y                         ; 74C0 99 C4 62                 ..b
        lda     $60CF                           ; 74C3 AD CF 60                 ..`
        sta     $66D4,y                         ; 74C6 99 D4 66                 ..f
        lda     $60E3                           ; 74C9 AD E3 60                 ..`
        sta     $6464,y                         ; 74CC 99 64 64                 .dd
        ldx     #$02                            ; 74CF A2 02                    ..
        lda     L0060                           ; 74D1 A5 60                    .`
        cmp     $60C3                           ; 74D3 CD C3 60                 ..`
        bcs     L74D9                           ; 74D6 B0 01                    ..
        inx                                     ; 74D8 E8                       .
L74D9:  txa                                     ; 74D9 8A                       .
        sta     $673C,y                         ; 74DA 99 3C 67                 .<g
L74DD:  rts                                     ; 74DD 60                       `

; ----------------------------------------------------------------------------
        lda     #$15                            ; 74DE A9 15                    ..
        sta     $60B3                           ; 74E0 8D B3 60                 ..`
        jsr     L76B9                           ; 74E3 20 B9 76                  .v
        bcs     L7533                           ; 74E6 B0 4B                    .K
        ldx     #$63                            ; 74E8 A2 63                    .c
        lda     $60CF                           ; 74EA AD CF 60                 ..`
        sta     $64CC,y                         ; 74ED 99 CC 64                 ..d
        beq     L74FA                           ; 74F0 F0 08                    ..
        bpl     L74F8                           ; 74F2 10 04                    ..
        ldx     #$6F                            ; 74F4 A2 6F                    .o
        bne     L74FA                           ; 74F6 D0 02                    ..
L74F8:  ldx     #$67                            ; 74F8 A2 67                    .g
L74FA:  txa                                     ; 74FA 8A                       .
        sta     $62C4,y                         ; 74FB 99 C4 62                 ..b
        lda     $60CE                           ; 74FE AD CE 60                 ..`
        sta     $63FC,y                         ; 7501 99 FC 63                 ..c
        lda     #$00                            ; 7504 A9 00                    ..
        sta     $6534,y                         ; 7506 99 34 65                 .4e
        lda     #$00                            ; 7509 A9 00                    ..
        sta     $6464,y                         ; 750B 99 64 64                 .dd
        lda     $60A8                           ; 750E AD A8 60                 ..`
        sta     $66D4,y                         ; 7511 99 D4 66                 ..f
        lda     $60AF                           ; 7514 AD AF 60                 ..`
        sta     $673C,y                         ; 7517 99 3C 67                 .<g
        cmp     #$02                            ; 751A C9 02                    ..
        bne     L752D                           ; 751C D0 0F                    ..
        lda     $60BD                           ; 751E AD BD 60                 ..`
        eor     #$01                            ; 7521 49 01                    I.
        tax                                     ; 7523 AA                       .
        lda     $6114,x                         ; 7524 BD 14 61                 ..a
        bpl     L752D                           ; 7527 10 04                    ..
        tya                                     ; 7529 98                       .
        sta     $6114,x                         ; 752A 9D 14 61                 ..a
L752D:  lda     #$7F                            ; 752D A9 7F                    ..
        sta     $67A4,y                         ; 752F 99 A4 67                 ..g
        clc                                     ; 7532 18                       .
L7533:  rts                                     ; 7533 60                       `

; ----------------------------------------------------------------------------
L7534:  lda     $60CF                           ; 7534 AD CF 60                 ..`
        sta     $64CC,y                         ; 7537 99 CC 64                 ..d
L753A:  lda     $60CE                           ; 753A AD CE 60                 ..`
        sta     $63FC,y                         ; 753D 99 FC 63                 ..c
L7540:  lda     $60CC                           ; 7540 AD CC 60                 ..`
        sta     $632C,y                         ; 7543 99 2C 63                 .,c
        lda     $60CD                           ; 7546 AD CD 60                 ..`
        sta     $6394,y                         ; 7549 99 94 63                 ..c
        rts                                     ; 754C 60                       `

; ----------------------------------------------------------------------------
        lda     $60C3                           ; 754D AD C3 60                 ..`
        sta     L0060                           ; 7550 85 60                    .`
        jsr     L6F8E                           ; 7552 20 8E 6F                  .o
        bcs     L7584                           ; 7555 B0 2D                    .-
        ldx     #$02                            ; 7557 A2 02                    ..
        cpy     L0060                           ; 7559 C4 60                    .`
        bcc     L755E                           ; 755B 90 01                    ..
        dex                                     ; 755D CA                       .
L755E:  txa                                     ; 755E 8A                       .
        sta     $673C,y                         ; 755F 99 3C 67                 .<g
        lda     #$13                            ; 7562 A9 13                    ..
        sta     $6124,y                         ; 7564 99 24 61                 .$a
        lda     #$02                            ; 7567 A9 02                    ..
        sta     $618C,y                         ; 7569 99 8C 61                 ..a
        jsr     L753A                           ; 756C 20 3A 75                  :u
        lda     $60A8                           ; 756F AD A8 60                 ..`
        sta     $66D4,y                         ; 7572 99 D4 66                 ..f
        lda     #$F1                            ; 7575 A9 F1                    ..
        sta     $62C4,y                         ; 7577 99 C4 62                 ..b
        lda     #$02                            ; 757A A9 02                    ..
        sta     $6464,y                         ; 757C 99 64 64                 .dd
        lda     #$FF                            ; 757F A9 FF                    ..
        sta     $666C,y                         ; 7581 99 6C 66                 .lf
L7584:  rts                                     ; 7584 60                       `

; ----------------------------------------------------------------------------
        cmp     #$00                            ; 7585 C9 00                    ..
        bmi     L758E                           ; 7587 30 05                    0.
        beq     L758D                           ; 7589 F0 02                    ..
        lda     #$01                            ; 758B A9 01                    ..
L758D:  rts                                     ; 758D 60                       `

; ----------------------------------------------------------------------------
L758E:  lda     #$FF                            ; 758E A9 FF                    ..
        rts                                     ; 7590 60                       `

; ----------------------------------------------------------------------------
        jsr     L6F8E                           ; 7591 20 8E 6F                  .o
        bcs     L75BF                           ; 7594 B0 29                    .)
        lda     #$15                            ; 7596 A9 15                    ..
        sta     $6124,y                         ; 7598 99 24 61                 .$a
        lda     #$02                            ; 759B A9 02                    ..
        sta     $618C,y                         ; 759D 99 8C 61                 ..a
        jsr     L753A                           ; 75A0 20 3A 75                  :u
        lda     $60A8                           ; 75A3 AD A8 60                 ..`
        sta     $673C,y                         ; 75A6 99 3C 67                 .<g
        tax                                     ; 75A9 AA                       .
        lda     L78B0,x                         ; 75AA BD B0 78                 ..x
        sta     $62C4,y                         ; 75AD 99 C4 62                 ..b
        lda     #$FF                            ; 75B0 A9 FF                    ..
        sta     $666C,y                         ; 75B2 99 6C 66                 .lf
        lda     #$04                            ; 75B5 A9 04                    ..
        sta     $66D4,y                         ; 75B7 99 D4 66                 ..f
        lda     #$01                            ; 75BA A9 01                    ..
        sta     $6464,y                         ; 75BC 99 64 64                 .dd
L75BF:  rts                                     ; 75BF 60                       `

; ----------------------------------------------------------------------------
        lda     $60CC                           ; 75C0 AD CC 60                 ..`
        lsr     a                               ; 75C3 4A                       J
        lsr     a                               ; 75C4 4A                       J
        lsr     a                               ; 75C5 4A                       J
        bpl     L75CA                           ; 75C6 10 02                    ..
        lda     #$00                            ; 75C8 A9 00                    ..
L75CA:  sta     $60BD                           ; 75CA 8D BD 60                 ..`
        lda     #$80                            ; 75CD A9 80                    ..
        sta     $60B3                           ; 75CF 8D B3 60                 ..`
        jsr     L76B9                           ; 75D2 20 B9 76                  .v
        lda     $60A7                           ; 75D5 AD A7 60                 ..`
        cmp     #$17                            ; 75D8 C9 17                    ..
        bne     L75E3                           ; 75DA D0 07                    ..
        ldx     $60BD                           ; 75DC AE BD 60                 ..`
        tya                                     ; 75DF 98                       .
        sta     $60FA,x                         ; 75E0 9D FA 60                 ..`
L75E3:  inc     $6118,x                         ; 75E3 FE 18 61                 ..a
        inc     $611C,x                         ; 75E6 FE 1C 61                 ..a
        rts                                     ; 75E9 60                       `

; ----------------------------------------------------------------------------
        jsr     L761D                           ; 75EA 20 1D 76                  .v
        bcs     L75FA                           ; 75ED B0 0B                    ..
        lda     $6604,y                         ; 75EF B9 04 66                 ..f
        beq     L75FA                           ; 75F2 F0 06                    ..
        ldx     $60C3                           ; 75F4 AE C3 60                 ..`
        inc     $62C4,x                         ; 75F7 FE C4 62                 ..b
L75FA:  rts                                     ; 75FA 60                       `

; ----------------------------------------------------------------------------
L75FB:  jsr     L761D                           ; 75FB 20 1D 76                  .v
        bcs     L7615                           ; 75FE B0 15                    ..
        lda     #$01                            ; 7600 A9 01                    ..
        sta     $66D4,y                         ; 7602 99 D4 66                 ..f
        lda     #$08                            ; 7605 A9 08                    ..
        sta     $673C,y                         ; 7607 99 3C 67                 .<g
        lda     $60CF                           ; 760A AD CF 60                 ..`
        sta     $64CC,y                         ; 760D 99 CC 64                 ..d
        lda     #$45                            ; 7610 A9 45                    .E
        sta     $62C4,y                         ; 7612 99 C4 62                 ..b
L7615:  rts                                     ; 7615 60                       `

; ----------------------------------------------------------------------------
        lda     $60A8                           ; 7616 AD A8 60                 ..`
        cmp     #$1A                            ; 7619 C9 1A                    ..
        beq     L75FB                           ; 761B F0 DE                    ..
L761D:  lda     $60C3                           ; 761D AD C3 60                 ..`
        sta     L0060                           ; 7620 85 60                    .`
        lda     #$80                            ; 7622 A9 80                    ..
        sta     $60B3                           ; 7624 8D B3 60                 ..`
        jsr     L76B9                           ; 7627 20 B9 76                  .v
        bcs     L7643                           ; 762A B0 17                    ..
        lda     #$03                            ; 762C A9 03                    ..
        sta     $66D4,y                         ; 762E 99 D4 66                 ..f
        lda     #$00                            ; 7631 A9 00                    ..
        cpy     L0060                           ; 7633 C4 60                    .`
        bcs     L7639                           ; 7635 B0 02                    ..
        lda     #$01                            ; 7637 A9 01                    ..
L7639:  sta     $673C,y                         ; 7639 99 3C 67                 .<g
        lda     $60A8                           ; 763C AD A8 60                 ..`
        sta     $67A4,y                         ; 763F 99 A4 67                 ..g
        clc                                     ; 7642 18                       .
L7643:  rts                                     ; 7643 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 7644 A9 00                    ..
        sta     $60E1                           ; 7646 8D E1 60                 ..`
        jsr     L736E                           ; 7649 20 6E 73                  ns
        bcs     L768F                           ; 764C B0 41                    .A
        lda     $60CE                           ; 764E AD CE 60                 ..`
        cmp     #$DD                            ; 7651 C9 DD                    ..
        beq     L768F                           ; 7653 F0 3A                    .:
        ldy     $60C3                           ; 7655 AC C3 60                 ..`
        sta     $63FC,y                         ; 7658 99 FC 63                 ..c
        lda     #$19                            ; 765B A9 19                    ..
        sta     $6124,y                         ; 765D 99 24 61                 .$a
        lda     $60BD                           ; 7660 AD BD 60                 ..`
        clc                                     ; 7663 18                       .
        adc     #$5F                            ; 7664 69 5F                    i_
        sta     $62C4,y                         ; 7666 99 C4 62                 ..b
        lda     #$00                            ; 7669 A9 00                    ..
        sta     $6464,y                         ; 766B 99 64 64                 .dd
        lda     #$03                            ; 766E A9 03                    ..
        sta     $659C,y                         ; 7670 99 9C 65                 ..e
        lda     #$02                            ; 7673 A9 02                    ..
        sta     $6534,y                         ; 7675 99 34 65                 .4e
        lda     $60CE                           ; 7678 AD CE 60                 ..`
        cmp     #$AB                            ; 767B C9 AB                    ..
        lda     $60E7                           ; 767D AD E7 60                 ..`
        and     #$0F                            ; 7680 29 0F                    ).
        beq     L768C                           ; 7682 F0 08                    ..
        and     #$07                            ; 7684 29 07                    ).
        bcc     L768A                           ; 7686 90 02                    ..
        and     #$03                            ; 7688 29 03                    ).
L768A:  adc     #$03                            ; 768A 69 03                    i.
L768C:  .byte   $99                             ; 768C 99                       .
L768D:  ldy     $67                             ; 768D A4 67                    .g
L768F:  rts                                     ; 768F 60                       `

; ----------------------------------------------------------------------------
        lda     #$15                            ; 7690 A9 15                    ..
        sta     $60B3                           ; 7692 8D B3 60                 ..`
        jsr     L76B9                           ; 7695 20 B9 76                  .v
        bcs     L76B5                           ; 7698 B0 1B                    ..
        lda     #$03                            ; 769A A9 03                    ..
        sta     $6464,y                         ; 769C 99 64 64                 .dd
        ldx     #$67                            ; 769F A2 67                    .g
        lda     $60CF                           ; 76A1 AD CF 60                 ..`
        sta     $64CC,y                         ; 76A4 99 CC 64                 ..d
        bpl     L76AB                           ; 76A7 10 02                    ..
        ldx     #$6F                            ; 76A9 A2 6F                    .o
L76AB:  txa                                     ; 76AB 8A                       .
        sta     $62C4,y                         ; 76AC 99 C4 62                 ..b
        lda     $60CE                           ; 76AF AD CE 60                 ..`
        sta     $63FC,y                         ; 76B2 99 FC 63                 ..c
L76B5:  rts                                     ; 76B5 60                       `

; ----------------------------------------------------------------------------
L76B6:  sta     $60A7                           ; 76B6 8D A7 60                 ..`
L76B9:  jsr     L6F90                           ; 76B9 20 90 6F                  .o
        bcs     L770C                           ; 76BC B0 4E                    .N
        lda     $60BD                           ; 76BE AD BD 60                 ..`
        sta     $6604,y                         ; 76C1 99 04 66                 ..f
        lda     $60B3                           ; 76C4 AD B3 60                 ..`
        sta     $659C,y                         ; 76C7 99 9C 65                 ..e
        lda     $60A7                           ; 76CA AD A7 60                 ..`
        sta     $6124,y                         ; 76CD 99 24 61                 .$a
        tax                                     ; 76D0 AA                       .
        lda     L78D0,x                         ; 76D1 BD D0 78                 ..x
        sta     $618C,y                         ; 76D4 99 8C 61                 ..a
        lda     L78B3,x                         ; 76D7 BD B3 78                 ..x
        sta     $666C,y                         ; 76DA 99 6C 66                 .lf
        lda     L78ED,x                         ; 76DD BD ED 78                 ..x
        sta     $62C4,y                         ; 76E0 99 C4 62                 ..b
        jsr     L7540                           ; 76E3 20 40 75                  @u
        lda     #$DD                            ; 76E6 A9 DD                    ..
        sta     $63FC,y                         ; 76E8 99 FC 63                 ..c
        lda     #$00                            ; 76EB A9 00                    ..
        sta     $66D4,y                         ; 76ED 99 D4 66                 ..f
        sta     $673C,y                         ; 76F0 99 3C 67                 .<g
        sta     $67A4,y                         ; 76F3 99 A4 67                 ..g
        sta     $64CC,y                         ; 76F6 99 CC 64                 ..d
        sta     $6534,y                         ; 76F9 99 34 65                 .4e
        lda     #$01                            ; 76FC A9 01                    ..
        sta     $6874,y                         ; 76FE 99 74 68                 .th
        lda     L6953,x                         ; 7701 BD 53 69                 .Si
        beq     L770C                           ; 7704 F0 06                    ..
        jsr     L6F12                           ; 7706 20 12 6F                  .o
        ldy     $60C3                           ; 7709 AC C3 60                 ..`
L770C:  ldx     $60BD                           ; 770C AE BD 60                 ..`
        rts                                     ; 770F 60                       `

; ----------------------------------------------------------------------------
L7710:  lda     #$FF                            ; 7710 A9 FF                    ..
        sta     $6106                           ; 7712 8D 06 61                 ..a
        sta     $6107                           ; 7715 8D 07 61                 ..a
        lda     #$05                            ; 7718 A9 05                    ..
L771A:  pha                                     ; 771A 48                       H
        tay                                     ; 771B A8                       .
        and     #$01                            ; 771C 29 01                    ).
        sta     $60BD                           ; 771E 8D BD 60                 ..`
        lda     L790B,y                         ; 7721 B9 0B 79                 ..y
        sta     $60A7                           ; 7724 8D A7 60                 ..`
        lda     L7911,y                         ; 7727 B9 11 79                 ..y
        sta     $60CD                           ; 772A 8D CD 60                 ..`
        lda     L7917,y                         ; 772D B9 17 79                 ..y
        sta     $60CC                           ; 7730 8D CC 60                 ..`
        jsr     L6F0C                           ; 7733 20 0C 6F                  .o
        pla                                     ; 7736 68                       h
        sec                                     ; 7737 38                       8
        sbc     #$01                            ; 7738 E9 01                    ..
        bpl     L771A                           ; 773A 10 DE                    ..
        lda     $4060                           ; 773C AD 60 40                 .`@
        sta     $60E8                           ; 773F 8D E8 60                 ..`
        beq     L7756                           ; 7742 F0 12                    ..
        lda     #$07                            ; 7744 A9 07                    ..
        sta     $60CC                           ; 7746 8D CC 60                 ..`
        lda     #$F2                            ; 7749 A9 F2                    ..
        sta     $60CD                           ; 774B 8D CD 60                 ..`
        lda     #$04                            ; 774E A9 04                    ..
        sta     $60A7                           ; 7750 8D A7 60                 ..`
        jsr     L6F0C                           ; 7753 20 0C 6F                  .o
L7756:  lda     #$02                            ; 7756 A9 02                    ..
L7758:  pha                                     ; 7758 48                       H
        tay                                     ; 7759 A8                       .
        lda     #$FF                            ; 775A A9 FF                    ..
        sta     $60BE,y                         ; 775C 99 BE 60                 ..`
        lda     $4061,y                         ; 775F B9 61 40                 .a@
        beq     L777F                           ; 7762 F0 1B                    ..
        lda     L791D,y                         ; 7764 B9 1D 79                 ..y
        sta     $60CC                           ; 7767 8D CC 60                 ..`
        lda     L7920,y                         ; 776A B9 20 79                 . y
        sta     $60CD                           ; 776D 8D CD 60                 ..`
        lda     #$16                            ; 7770 A9 16                    ..
        sta     $60A7                           ; 7772 8D A7 60                 ..`
        jsr     L6F0C                           ; 7775 20 0C 6F                  .o
        pla                                     ; 7778 68                       h
        pha                                     ; 7779 48                       H
        tax                                     ; 777A AA                       .
        tya                                     ; 777B 98                       .
        sta     $60BE,x                         ; 777C 9D BE 60                 ..`
L777F:  pla                                     ; 777F 68                       h
        sec                                     ; 7780 38                       8
        sbc     #$01                            ; 7781 E9 01                    ..
        bpl     L7758                           ; 7783 10 D3                    ..
L7785:  rts                                     ; 7785 60                       `

; ----------------------------------------------------------------------------
L7786:  ldy     $05                             ; 7786 A4 05                    ..
        ldx     L79F2,y                         ; 7788 BE F2 79                 ..y
        lda     L792D,x                         ; 778B BD 2D 79                 .-y
        beq     L7785                           ; 778E F0 F5                    ..
        sta     L79FD                           ; 7790 8D FD 79                 ..y
        lda     #$00                            ; 7793 A9 00                    ..
        sta     $60BD                           ; 7795 8D BD 60                 ..`
        txa                                     ; 7798 8A                       .
        sec                                     ; 7799 38                       8
        adc     L792D,x                         ; 779A 7D 2D 79                 }-y
        tay                                     ; 779D A8                       .
        stx     L79FE                           ; 779E 8E FE 79                 ..y
        sty     L79FF                           ; 77A1 8C FF 79                 ..y
L77A4:  dec     L79FD                           ; 77A4 CE FD 79                 ..y
        bmi     L7785                           ; 77A7 30 DC                    0.
        inc     L79FE                           ; 77A9 EE FE 79                 ..y
        ldx     L79FE                           ; 77AC AE FE 79                 ..y
        lda     L792D,x                         ; 77AF BD 2D 79                 .-y
        ldx     #$03                            ; 77B2 A2 03                    ..
L77B4:  cmp     L7925,x                         ; 77B4 DD 25 79                 .%y
        beq     L77BD                           ; 77B7 F0 04                    ..
        dex                                     ; 77B9 CA                       .
        bpl     L77B4                           ; 77BA 10 F8                    ..
        inx                                     ; 77BC E8                       .
L77BD:  lda     L7929,x                         ; 77BD BD 29 79                 .)y
        sta     $60A7                           ; 77C0 8D A7 60                 ..`
        ldx     #$01                            ; 77C3 A2 01                    ..
        cmp     #$0D                            ; 77C5 C9 0D                    ..
        bne     L77CB                           ; 77C7 D0 02                    ..
        ldx     #$04                            ; 77C9 A2 04                    ..
L77CB:  ldy     L79FF                           ; 77CB AC FF 79                 ..y
        inc     L79FF                           ; 77CE EE FF 79                 ..y
        lda     #$00                            ; 77D1 A9 00                    ..
        sta     $60CD                           ; 77D3 8D CD 60                 ..`
        lda     L792D,y                         ; 77D6 B9 2D 79                 .-y
        lsr     a                               ; 77D9 4A                       J
        ror     $60CD                           ; 77DA 6E CD 60                 n.`
        lsr     a                               ; 77DD 4A                       J
        ror     $60CD                           ; 77DE 6E CD 60                 n.`
        lsr     a                               ; 77E1 4A                       J
        ror     $60CD                           ; 77E2 6E CD 60                 n.`
        lsr     a                               ; 77E5 4A                       J
        ror     $60CD                           ; 77E6 6E CD 60                 n.`
        sta     $60CC                           ; 77E9 8D CC 60                 ..`
        sta     $61                             ; 77EC 85 61                    .a
        lda     $60CD                           ; 77EE AD CD 60                 ..`
        sta     L0060                           ; 77F1 85 60                    .`
        lsr     $61                             ; 77F3 46 61                    Fa
        ror     L0060                           ; 77F5 66 60                    f`
        lsr     $61                             ; 77F7 46 61                    Fa
        ror     L0060                           ; 77F9 66 60                    f`
        lda     $60CD                           ; 77FB AD CD 60                 ..`
        sec                                     ; 77FE 38                       8
        sbc     L0060                           ; 77FF E5 60                    .`
        sta     $60CD                           ; 7801 8D CD 60                 ..`
        lda     $60CC                           ; 7804 AD CC 60                 ..`
        sbc     $61                             ; 7807 E5 61                    .a
        adc     #$01                            ; 7809 69 01                    i.
        sta     $60CC                           ; 780B 8D CC 60                 ..`
        txa                                     ; 780E 8A                       .
L780F:  pha                                     ; 780F 48                       H
        lda     #$00                            ; 7810 A9 00                    ..
        sta     $60E1                           ; 7812 8D E1 60                 ..`
        jsr     L6F0C                           ; 7815 20 0C 6F                  .o
        lda     $60CD                           ; 7818 AD CD 60                 ..`
        clc                                     ; 781B 18                       .
        adc     #$03                            ; 781C 69 03                    i.
        sta     $60CD                           ; 781E 8D CD 60                 ..`
        bcc     L7826                           ; 7821 90 03                    ..
        inc     $60CC                           ; 7823 EE CC 60                 ..`
L7826:  pla                                     ; 7826 68                       h
        sec                                     ; 7827 38                       8
        sbc     #$01                            ; 7828 E9 01                    ..
        bne     L780F                           ; 782A D0 E3                    ..
        jmp     L77A4                           ; 782C 4C A4 77                 L.w

; ----------------------------------------------------------------------------
        rts                                     ; 782F 60                       `

; ----------------------------------------------------------------------------
L7830:  ldy     $60C3                           ; 7830 AC C3 60                 ..`
        lda     $632C,y                         ; 7833 B9 2C 63                 .,c
        and     #$08                            ; 7836 29 08                    ).
        bne     L7857                           ; 7838 D0 1D                    ..
        ldx     $60DF                           ; 783A AE DF 60                 ..`
        txa                                     ; 783D 8A                       .
        sta     $61F4,y                         ; 783E 99 F4 61                 ..a
        lda     $625C,x                         ; 7841 BD 5C 62                 .\b
        sta     $625C,y                         ; 7844 99 5C 62                 .\b
        sta     $60E2                           ; 7847 8D E2 60                 ..`
        tya                                     ; 784A 98                       .
        sta     $625C,x                         ; 784B 9D 5C 62                 .\b
        ldy     $60E2                           ; 784E AC E2 60                 ..`
        sta     $61F4,y                         ; 7851 99 F4 61                 ..a
        jmp     L7A0C                           ; 7854 4C 0C 7A                 L.z

; ----------------------------------------------------------------------------
L7857:  ldx     $60C3                           ; 7857 AE C3 60                 ..`
L785A:  ldy     $60E0                           ; 785A AC E0 60                 ..`
        tya                                     ; 785D 98                       .
        sta     $625C,x                         ; 785E 9D 5C 62                 .\b
        lda     $61F4,y                         ; 7861 B9 F4 61                 ..a
        sta     $61F4,x                         ; 7864 9D F4 61                 ..a
        sta     $60E1                           ; 7867 8D E1 60                 ..`
        txa                                     ; 786A 8A                       .
        sta     $61F4,y                         ; 786B 99 F4 61                 ..a
        ldy     $60E1                           ; 786E AC E1 60                 ..`
        sta     $625C,y                         ; 7871 99 5C 62                 .\b
        .byte   $4C                             ; 7874 4C                       L
L7875:  .byte   $0C                             ; 7875 0C                       .
L7876:  .byte   $7A                             ; 7876 7A                       z
        brk                                     ; 7877 00                       .
        brk                                     ; 7878 00                       .
        .byte   $CF                             ; 7879 CF                       .
        .byte   $6F                             ; 787A 6F                       o
        .byte   $7B                             ; 787B 7B                       {
        bvs     L78C9                           ; 787C 70 4B                    pK
        adc     ($5D),y                         ; 787E 71 5D                    q]
        adc     ($6F),y                         ; 7880 71 6F                    qo
        adc     ($92),y                         ; 7882 71 92                    q.
        adc     ($D0),y                         ; 7884 71 D0                    q.
        adc     ($2E),y                         ; 7886 71 2E                    q.
        .byte   $72                             ; 7888 72                       r
        jmp     L8672                           ; 7889 4C 72 86                 Lr.

; ----------------------------------------------------------------------------
        .byte   $72                             ; 788C 72                       r
        sbc     #$72                            ; 788D E9 72                    .r
        ror     LAC73                           ; 788F 6E 73 AC                 ns.
        .byte   $73                             ; 7892 73                       s
        .byte   $DC                             ; 7893 DC                       .
        .byte   $73                             ; 7894 73                       s
        .byte   $02                             ; 7895 02                       .
        .byte   $74                             ; 7896 74                       t
        ldx     #$74                            ; 7897 A2 74                    .t
        dec     $4D74,x                         ; 7899 DE 74 4D                 .tM
        adc     $FB,x                           ; 789C 75 FB                    u.
        adc     $91,x                           ; 789E 75 91                    u.
        adc     $C8,x                           ; 78A0 75 C8                    u.
        adc     $C0,x                           ; 78A2 75 C0                    u.
        adc     $1D,x                           ; 78A4 75 1D                    u.
        ror     $44,x                           ; 78A6 76 44                    vD
        ror     $90,x                           ; 78A8 76 90                    v.
        ror     L0000,x                         ; 78AA 76 00                    v.
        brk                                     ; 78AC 00                       .
        nop                                     ; 78AD EA                       .
        adc     $16,x                           ; 78AE 75 16                    u.
L78B0:  ror     $F1,x                           ; 78B0 76 F1                    v.
        .byte   $94                             ; 78B2 94                       .
L78B3:  sta     $FF,x                           ; 78B3 95 FF                    ..
        ora     #$FF                            ; 78B5 09 FF                    ..
        .byte   $03                             ; 78B7 03                       .
        ora     ($02,x)                         ; 78B8 01 02                    ..
        .byte   $02                             ; 78BA 02                       .
        .byte   $FF                             ; 78BB FF                       .
        ora     ($FF,x)                         ; 78BC 01 FF                    ..
        .byte   $FF                             ; 78BE FF                       .
        .byte   $FF                             ; 78BF FF                       .
        .byte   $02                             ; 78C0 02                       .
        asl     $06                             ; 78C1 06 06                    ..
        .byte   $07                             ; 78C3 07                       .
        .byte   $FF                             ; 78C4 FF                       .
        asl     $FF                             ; 78C5 06 FF                    ..
        .byte   $FF                             ; 78C7 FF                       .
        .byte   $FF                             ; 78C8 FF                       .
L78C9:  ora     ($01,x)                         ; 78C9 01 01                    ..
        .byte   $FF                             ; 78CB FF                       .
        .byte   $02                             ; 78CC 02                       .
        .byte   $07                             ; 78CD 07                       .
        .byte   $FF                             ; 78CE FF                       .
        .byte   $FF                             ; 78CF FF                       .
L78D0:  .byte   $FF                             ; 78D0 FF                       .
        brk                                     ; 78D1 00                       .
        ora     ($02,x)                         ; 78D2 01 02                    ..
        ora     ($01,x)                         ; 78D4 01 01                    ..
        ora     ($01,x)                         ; 78D6 01 01                    ..
        ora     ($01,x)                         ; 78D8 01 01                    ..
        ora     ($01,x)                         ; 78DA 01 01                    ..
        .byte   $02                             ; 78DC 02                       .
        ora     ($01,x)                         ; 78DD 01 01                    ..
        ora     ($01,x)                         ; 78DF 01 01                    ..
        .byte   $02                             ; 78E1 02                       .
        .byte   $01                             ; 78E2 01                       .
L78E3:  .byte   $02                             ; 78E3 02                       .
        ora     ($02,x)                         ; 78E4 01 02                    ..
        ora     ($01,x)                         ; 78E6 01 01                    ..
        ora     ($01,x)                         ; 78E8 01 01                    ..
        ora     ($01,x)                         ; 78EA 01 01                    ..
        .byte   $01                             ; 78EC 01                       .
L78ED:  ora     ($FF,x)                         ; 78ED 01 FF                    ..
        .byte   $FF                             ; 78EF FF                       .
        .byte   $FF                             ; 78F0 FF                       .
        rol     $31,x                           ; 78F1 36 31                    61
        .byte   $FF                             ; 78F3 FF                       .
        .byte   $FF                             ; 78F4 FF                       .
        beq     L790F                           ; 78F5 F0 18                    ..
        .byte   $FF                             ; 78F7 FF                       .
        sbc     ($FF),y                         ; 78F8 F1 FF                    ..
        ora     $FFFF,x                         ; 78FA 1D FF FF                 ...
        .byte   $FF                             ; 78FD FF                       .
        .byte   $FF                             ; 78FE FF                       .
        .byte   $FF                             ; 78FF FF                       .
        sbc     ($45),y                         ; 7900 F1 45                    .E
        .byte   $FF                             ; 7902 FF                       .
        lsr     $57,x                           ; 7903 56 57                    VW
        .byte   $5B                             ; 7905 5B                       [
        lsr     $FFFF,x                         ; 7906 5E FF FF                 ^..
        adc     ($5C,x)                         ; 7909 61 5C                    a\
L790B:  .byte   $17                             ; 790B 17                       .
        .byte   $17                             ; 790C 17                       .
        ora     $05                             ; 790D 05 05                    ..
L790F:  .byte   $04                             ; 790F 04                       .
        .byte   $04                             ; 7910 04                       .
L7911:  .byte   $30                             ; 7911 30                       0
L7912:  bne     *+122                           ; 7912 D0 78                    .x
        dey                                     ; 7914 88                       .
L7915:  bcc     L7987                           ; 7915 90 70                    .p
L7917:  .byte   $02                             ; 7917 02                       .
        ora     $0D02                           ; 7918 0D 02 0D                 ...
L791B:  .byte   $02                             ; 791B 02                       .
        .byte   $0D                             ; 791C 0D                       .
L791D:  .byte   $04                             ; 791D 04                       .
        .byte   $07                             ; 791E 07                       .
        .byte   $0B                             ; 791F 0B                       .
L7920:  tay                                     ; 7920 A8                       .
        sed                                     ; 7921 F8                       .
        pla                                     ; 7922 68                       h
L7923:  ora     ($FF,x)                         ; 7923 01 FF                    ..
L7925:  dec     $D4,x                           ; 7925 D6 D4                    ..
        .byte   $CD                             ; 7927 CD                       .
        .byte   $C1                             ; 7928 C1                       .
L7929:  bpl     L7939                           ; 7929 10 0E                    ..
        .byte   $0D                             ; 792B 0D                       .
        .byte   $0F                             ; 792C 0F                       .
L792D:  brk                                     ; 792D 00                       .
        .byte   $0C                             ; 792E 0C                       .
        dec     $D6,x                           ; 792F D6 D6                    ..
        .byte   $D4                             ; 7931 D4                       .
        .byte   $D4                             ; 7932 D4                       .
        .byte   $D4                             ; 7933 D4                       .
        cmp     $C1CD                           ; 7934 CD CD C1                 ...
        .byte   $D4                             ; 7937 D4                       .
        .byte   $CD                             ; 7938 CD                       .
L7939:  .byte   $D4                             ; 7939 D4                       .
        cmp     $100F                           ; 793A CD 0F 10                 ...
        .byte   $27                             ; 793D 27                       '
        plp                                     ; 793E 28                       (
        and     #$2A                            ; 793F 29 2A                    )*
        .byte   $2B                             ; 7941 2B                       +
        ror     $67                             ; 7942 66 67                    fg
        pla                                     ; 7944 68                       h
        adc     #$6A                            ; 7945 69 6A                    ij
        .byte   $0F                             ; 7947 0F                       .
        dec     $D6,x                           ; 7948 D6 D6                    ..
        cmp     ($D4,x)                         ; 794A C1 D4                    ..
        .byte   $D4                             ; 794C D4                       .
        .byte   $D4                             ; 794D D4                       .
        cmp     $C1CD                           ; 794E CD CD C1                 ...
        cmp     ($D4,x)                         ; 7951 C1 D4                    ..
        cmp     $CDD4                           ; 7953 CD D4 CD                 ...
        cmp     ($0F,x)                         ; 7956 C1 0F                    ..
        bpl     L7980                           ; 7958 10 26                    .&
        .byte   $27                             ; 795A 27                       '
        plp                                     ; 795B 28                       (
        and     #$2A                            ; 795C 29 2A                    )*
        .byte   $2B                             ; 795E 2B                       +
        bcs     L7912                           ; 795F B0 B1                    ..
        .byte   $B2                             ; 7961 B2                       .
        .byte   $B3                             ; 7962 B3                       .
        ldy     $B5,x                           ; 7963 B4 B5                    ..
        ldx     $10,y                           ; 7965 B6 10                    ..
        dec     $D6,x                           ; 7967 D6 D6                    ..
        cmp     ($D4,x)                         ; 7969 C1 D4                    ..
        .byte   $D4                             ; 796B D4                       .
        .byte   $D4                             ; 796C D4                       .
        cmp     ($CD,x)                         ; 796D C1 CD                    ..
        cmp     $D4C1                           ; 796F CD C1 D4                 ...
        .byte   $D4                             ; 7972 D4                       .
        .byte   $D4                             ; 7973 D4                       .
        cmp     $CDCD                           ; 7974 CD CD CD                 ...
        .byte   $0F                             ; 7977 0F                       .
        bpl     L79A0                           ; 7978 10 26                    .&
        .byte   $27                             ; 797A 27                       '
        plp                                     ; 797B 28                       (
        and     #$70                            ; 797C 29 70                    )p
        adc     ($72),y                         ; 797E 71 72                    qr
L7980:  ldy     #$A1                            ; 7980 A0 A1                    ..
        ldx     #$A3                            ; 7982 A2 A3                    ..
        ldy     $A5                             ; 7984 A4 A5                    ..
        .byte   $A6                             ; 7986 A6                       .
L7987:  asl     $D6D6                           ; 7987 0E D6 D6                 ...
        cmp     ($D4,x)                         ; 798A C1 D4                    ..
        .byte   $D4                             ; 798C D4                       .
        .byte   $D4                             ; 798D D4                       .
        cmp     ($D4,x)                         ; 798E C1 D4                    ..
        cmp     $C1CD                           ; 7990 CD CD C1                 ...
        cmp     $CDCD                           ; 7993 CD CD CD                 ...
        .byte   $0F                             ; 7996 0F                       .
        bpl     L79BF                           ; 7997 10 26                    .&
        .byte   $27                             ; 7999 27                       '
        plp                                     ; 799A 28                       (
        and     #$70                            ; 799B 29 70                    )p
        adc     ($72),y                         ; 799D 71 72                    qr
        .byte   $73                             ; 799F 73                       s
L79A0:  ldx     $B7,y                           ; 79A0 B6 B7                    ..
        clv                                     ; 79A2 B8                       .
        lda     $11BA,y                         ; 79A3 B9 BA 11                 ...
        dec     $D6,x                           ; 79A6 D6 D6                    ..
        cmp     ($D4,x)                         ; 79A8 C1 D4                    ..
        .byte   $D4                             ; 79AA D4                       .
        .byte   $D4                             ; 79AB D4                       .
        cmp     $C1C1                           ; 79AC CD C1 C1                 ...
        cmp     $CDD4                           ; 79AF CD D4 CD                 ...
        cmp     ($CD,x)                         ; 79B2 C1 CD                    ..
        cmp     $C1CD                           ; 79B4 CD CD C1                 ...
        bmi     L79EA                           ; 79B7 30 31                    01
        sec                                     ; 79B9 38                       8
        and     $3B3A,y                         ; 79BA 39 3A 3B                 9:;
        .byte   $3C                             ; 79BD 3C                       <
        .byte   $3D                             ; 79BE 3D                       =
L79BF:  rts                                     ; 79BF 60                       `

; ----------------------------------------------------------------------------
        ror     $70                             ; 79C0 66 70                    fp
        adc     ($72),y                         ; 79C2 71 72                    qr
        .byte   $73                             ; 79C4 73                       s
        .byte   $BB                             ; 79C5 BB                       .
        ldy     $BEBD,x                         ; 79C6 BC BD BE                 ...
        .byte   $BF                             ; 79C9 BF                       .
        cpy     #$12                            ; 79CA C0 12                    ..
        dec     $D6,x                           ; 79CC D6 D6                    ..
        cmp     ($D4,x)                         ; 79CE C1 D4                    ..
        .byte   $D4                             ; 79D0 D4                       .
        .byte   $D4                             ; 79D1 D4                       .
        cmp     $C1C1                           ; 79D2 CD C1 C1                 ...
        cmp     ($D4,x)                         ; 79D5 C1 D4                    ..
        cmp     $CDD4                           ; 79D7 CD D4 CD                 ...
        cmp     ($CD,x)                         ; 79DA C1 CD                    ..
        cmp     $60CD                           ; 79DC CD CD 60                 ..`
        adc     ($76,x)                         ; 79DF 61 76                    av
        .byte   $77                             ; 79E1 77                       w
        sei                                     ; 79E2 78                       x
        adc     LA37A,y                         ; 79E3 79 7A A3                 yz.
        lda     #$B6                            ; 79E6 A9 B6                    ..
        .byte   $B7                             ; 79E8 B7                       .
        clv                                     ; 79E9 B8                       .
L79EA:  lda     $D8BA,y                         ; 79EA B9 BA D8                 ...
        .byte   $DF                             ; 79ED DF                       .
        cpx     #$E1                            ; 79EE E0 E1                    ..
        .byte   $E2                             ; 79F0 E2                       .
        .byte   $E3                             ; 79F1 E3                       .
L79F2:  brk                                     ; 79F2 00                       .
        brk                                     ; 79F3 00                       .
        brk                                     ; 79F4 00                       .
        ora     ($1A,x)                         ; 79F5 01 1A                    ..
        and     L785A,y                         ; 79F7 39 5A 78                 9Zx
        .byte   $9E                             ; 79FA 9E                       .
L79FB:  brk                                     ; 79FB 00                       .
L79FC:  brk                                     ; 79FC 00                       .
L79FD:  brk                                     ; 79FD 00                       .
L79FE:  brk                                     ; 79FE 00                       .
L79FF:  brk                                     ; 79FF 00                       .
L7A00:  jmp     L7A1F                           ; 7A00 4C 1F 7A                 L.z

; ----------------------------------------------------------------------------
L7A03:  jmp     L7A15                           ; 7A03 4C 15 7A                 L.z

; ----------------------------------------------------------------------------
L7A06:  jmp     L7A1F                           ; 7A06 4C 1F 7A                 L.z

; ----------------------------------------------------------------------------
L7A09:  jmp     L7A20                           ; 7A09 4C 20 7A                 L z

; ----------------------------------------------------------------------------
L7A0C:  jmp     L7ABA                           ; 7A0C 4C BA 7A                 L.z

; ----------------------------------------------------------------------------
        jmp     L7CAD                           ; 7A0F 4C AD 7C                 L.|

; ----------------------------------------------------------------------------
L7A12:  jmp     L7A96                           ; 7A12 4C 96 7A                 L.z

; ----------------------------------------------------------------------------
L7A15:  lda     #$37                            ; 7A15 A9 37                    .7
        sta     $6022                           ; 7A17 8D 22 60                 ."`
        lda     #$5A                            ; 7A1A A9 5A                    .Z
        sta     $6023                           ; 7A1C 8D 23 60                 .#`
L7A1F:  rts                                     ; 7A1F 60                       `

; ----------------------------------------------------------------------------
L7A20:  dec     $6022                           ; 7A20 CE 22 60                 ."`
        bpl     L7A3A                           ; 7A23 10 15                    ..
        lda     #$37                            ; 7A25 A9 37                    .7
        sta     $6022                           ; 7A27 8D 22 60                 ."`
        inc     $6116                           ; 7A2A EE 16 61                 ..a
        bne     L7A32                           ; 7A2D D0 03                    ..
        dec     $6116                           ; 7A2F CE 16 61                 ..a
L7A32:  inc     $6117                           ; 7A32 EE 17 61                 ..a
        bne     L7A3A                           ; 7A35 D0 03                    ..
        dec     $6117                           ; 7A37 CE 17 61                 ..a
L7A3A:  dec     $6023                           ; 7A3A CE 23 60                 .#`
        bne     L7A59                           ; 7A3D D0 1A                    ..
        lda     #$5A                            ; 7A3F A9 5A                    .Z
        sta     $6023                           ; 7A41 8D 23 60                 .#`
        lda     $0F                             ; 7A44 A5 0F                    ..
        cmp     #$90                            ; 7A46 C9 90                    ..
        bcs     L7A59                           ; 7A48 B0 0F                    ..
        sed                                     ; 7A4A F8                       .
        lda     $0E                             ; 7A4B A5 0E                    ..
        clc                                     ; 7A4D 18                       .
        adc     #$99                            ; 7A4E 69 99                    i.
        sta     $0E                             ; 7A50 85 0E                    ..
        lda     $0F                             ; 7A52 A5 0F                    ..
        adc     #$99                            ; 7A54 69 99                    i.
        sta     $0F                             ; 7A56 85 0F                    ..
        cld                                     ; 7A58 D8                       .
L7A59:  jsr     L8F0C                           ; 7A59 20 0C 8F                  ..
        jsr     L8509                           ; 7A5C 20 09 85                  ..
        lda     #$67                            ; 7A5F A9 67                    .g
L7A61:  pha                                     ; 7A61 48                       H
        tay                                     ; 7A62 A8                       .
        lda     $6124,y                         ; 7A63 B9 24 61                 .$a
        beq     L7A7C                           ; 7A66 F0 14                    ..
        sty     $60C3                           ; 7A68 8C C3 60                 ..`
        asl     a                               ; 7A6B 0A                       .
        tax                                     ; 7A6C AA                       .
        lda     L8467,x                         ; 7A6D BD 67 84                 .g.
        sta     L7A7A                           ; 7A70 8D 7A 7A                 .zz
        lda     L8468,x                         ; 7A73 BD 68 84                 .h.
        sta     L7A7B                           ; 7A76 8D 7B 7A                 .{z
        .byte   $20                             ; 7A79 20                        
L7A7A:  .byte   $34                             ; 7A7A 34                       4
L7A7B:  .byte   $12                             ; 7A7B 12                       .
L7A7C:  pla                                     ; 7A7C 68                       h
        sec                                     ; 7A7D 38                       8
        sbc     #$01                            ; 7A7E E9 01                    ..
        bpl     L7A61                           ; 7A80 10 DF                    ..
        jmp     LAC09                           ; 7A82 4C 09 AC                 L..

; ----------------------------------------------------------------------------
L7A85:  ldx     $6604,y                         ; 7A85 BE 04 66                 ..f
        lda     L84A4,x                         ; 7A88 BD A4 84                 ...
        bne     L7A93                           ; 7A8B D0 06                    ..
L7A8D:  ldx     $6604,y                         ; 7A8D BE 04 66                 ..f
        lda     L84A3,x                         ; 7A90 BD A3 84                 ...
L7A93:  sta     $64CC,y                         ; 7A93 99 CC 64                 ..d
L7A96:  ldy     $60C3                           ; 7A96 AC C3 60                 ..`
        ldx     #$00                            ; 7A99 A2 00                    ..
        lda     $64CC,y                         ; 7A9B B9 CC 64                 ..d
        bpl     L7AA1                           ; 7A9E 10 01                    ..
        dex                                     ; 7AA0 CA                       .
L7AA1:  clc                                     ; 7AA1 18                       .
        adc     $6394,y                         ; 7AA2 79 94 63                 y.c
        sta     $6394,y                         ; 7AA5 99 94 63                 ..c
        txa                                     ; 7AA8 8A                       .
        adc     $632C,y                         ; 7AA9 79 2C 63                 y,c
        and     #$0F                            ; 7AAC 29 0F                    ).
        sta     $632C,y                         ; 7AAE 99 2C 63                 .,c
        ldx     $6124,y                         ; 7AB1 BE 24 61                 .$a
        lda     L6953,x                         ; 7AB4 BD 53 69                 .Si
        bne     L7ABA                           ; 7AB7 D0 01                    ..
        rts                                     ; 7AB9 60                       `

; ----------------------------------------------------------------------------
L7ABA:  ldy     $60C3                           ; 7ABA AC C3 60                 ..`
        ldx     $61F4,y                         ; 7ABD BE F4 61                 ..a
        lda     $632C,x                         ; 7AC0 BD 2C 63                 .,c
        cmp     $632C,y                         ; 7AC3 D9 2C 63                 .,c
        bcc     L7AFE                           ; 7AC6 90 36                    .6
        bne     L7AD4                           ; 7AC8 D0 0A                    ..
        lda     $6394,x                         ; 7ACA BD 94 63                 ..c
        cmp     $6394,y                         ; 7ACD D9 94 63                 ..c
        bcc     L7AFE                           ; 7AD0 90 2C                    .,
        beq     L7AFE                           ; 7AD2 F0 2A                    .*
L7AD4:  lda     $61F4,x                         ; 7AD4 BD F4 61                 ..a
        sta     $60E1                           ; 7AD7 8D E1 60                 ..`
        sta     $61F4,y                         ; 7ADA 99 F4 61                 ..a
        lda     $625C,y                         ; 7ADD B9 5C 62                 .\b
        sta     $60E2                           ; 7AE0 8D E2 60                 ..`
        sta     $625C,x                         ; 7AE3 9D 5C 62                 .\b
        txa                                     ; 7AE6 8A                       .
        sta     $625C,y                         ; 7AE7 99 5C 62                 .\b
        tya                                     ; 7AEA 98                       .
        sta     $61F4,x                         ; 7AEB 9D F4 61                 ..a
        ldy     $60E1                           ; 7AEE AC E1 60                 ..`
        sta     $625C,y                         ; 7AF1 99 5C 62                 .\b
        txa                                     ; 7AF4 8A                       .
        ldx     $60E2                           ; 7AF5 AE E2 60                 ..`
        sta     $61F4,x                         ; 7AF8 9D F4 61                 ..a
        jmp     L7ABA                           ; 7AFB 4C BA 7A                 L.z

; ----------------------------------------------------------------------------
L7AFE:  ldy     $60C3                           ; 7AFE AC C3 60                 ..`
        ldx     $625C,y                         ; 7B01 BE 5C 62                 .\b
        lda     $632C,y                         ; 7B04 B9 2C 63                 .,c
        cmp     $632C,x                         ; 7B07 DD 2C 63                 .,c
        bcc     L7B43                           ; 7B0A 90 37                    .7
        bne     L7B18                           ; 7B0C D0 0A                    ..
        lda     $6394,y                         ; 7B0E B9 94 63                 ..c
        cmp     $6394,x                         ; 7B11 DD 94 63                 ..c
        bcc     L7B43                           ; 7B14 90 2D                    .-
        beq     L7B42                           ; 7B16 F0 2A                    .*
L7B18:  lda     $61F4,y                         ; 7B18 B9 F4 61                 ..a
        sta     $60E1                           ; 7B1B 8D E1 60                 ..`
        sta     $61F4,x                         ; 7B1E 9D F4 61                 ..a
        lda     $625C,x                         ; 7B21 BD 5C 62                 .\b
        sta     $60E2                           ; 7B24 8D E2 60                 ..`
        sta     $625C,y                         ; 7B27 99 5C 62                 .\b
        tya                                     ; 7B2A 98                       .
        sta     $625C,x                         ; 7B2B 9D 5C 62                 .\b
        txa                                     ; 7B2E 8A                       .
        sta     $61F4,y                         ; 7B2F 99 F4 61                 ..a
        ldx     $60E1                           ; 7B32 AE E1 60                 ..`
        sta     $625C,x                         ; 7B35 9D 5C 62                 .\b
        tya                                     ; 7B38 98                       .
        ldy     $60E2                           ; 7B39 AC E2 60                 ..`
        sta     $61F4,y                         ; 7B3C 99 F4 61                 ..a
        jmp     L7AFE                           ; 7B3F 4C FE 7A                 L.z

; ----------------------------------------------------------------------------
L7B42:  clc                                     ; 7B42 18                       .
L7B43:  rts                                     ; 7B43 60                       `

; ----------------------------------------------------------------------------
L7B44:  cmp     #$00                            ; 7B44 C9 00                    ..
        bmi     L7B4D                           ; 7B46 30 05                    0.
        beq     L7B4C                           ; 7B48 F0 02                    ..
        lda     #$01                            ; 7B4A A9 01                    ..
L7B4C:  rts                                     ; 7B4C 60                       `

; ----------------------------------------------------------------------------
L7B4D:  lda     #$FF                            ; 7B4D A9 FF                    ..
        rts                                     ; 7B4F 60                       `

; ----------------------------------------------------------------------------
        lda     $60C1                           ; 7B50 AD C1 60                 ..`
        eor     $60C3                           ; 7B53 4D C3 60                 M.`
        and     #$01                            ; 7B56 29 01                    ).
        ora     $6874,y                         ; 7B58 19 74 68                 .th
        beq     L7B6F                           ; 7B5B F0 12                    ..
        lda     $632C,y                         ; 7B5D B9 2C 63                 .,c
        lsr     a                               ; 7B60 4A                       J
        lsr     a                               ; 7B61 4A                       J
        and     #$02                            ; 7B62 29 02                    ).
        ora     $6604,y                         ; 7B64 19 04 66                 ..f
        eor     #$03                            ; 7B67 49 03                    I.
        clc                                     ; 7B69 18                       .
        adc     #$14                            ; 7B6A 69 14                    i.
        sta     $62C4,y                         ; 7B6C 99 C4 62                 ..b
L7B6F:  lda     $67A4,y                         ; 7B6F B9 A4 67                 ..g
        beq     L7B82                           ; 7B72 F0 0E                    ..
        pha                                     ; 7B74 48                       H
        lda     $659C,y                         ; 7B75 B9 9C 65                 ..e
        cmp     #$2F                            ; 7B78 C9 2F                    ./
        bcs     L7B81                           ; 7B7A B0 05                    ..
        adc     #$01                            ; 7B7C 69 01                    i.
        sta     $659C,y                         ; 7B7E 99 9C 65                 ..e
L7B81:  pla                                     ; 7B81 68                       h
L7B82:  cmp     #$02                            ; 7B82 C9 02                    ..
        bcc     L7BC2                           ; 7B84 90 3C                    .<
        lda     $60C1                           ; 7B86 AD C1 60                 ..`
        eor     $60C3                           ; 7B89 4D C3 60                 M.`
        and     #$07                            ; 7B8C 29 07                    ).
        bne     L7BC2                           ; 7B8E D0 32                    .2
        lda     $67A4,y                         ; 7B90 B9 A4 67                 ..g
        sbc     #$01                            ; 7B93 E9 01                    ..
        sta     $67A4,y                         ; 7B95 99 A4 67                 ..g
        lda     $6394,y                         ; 7B98 B9 94 63                 ..c
        clc                                     ; 7B9B 18                       .
        adc     #$06                            ; 7B9C 69 06                    i.
        sta     $60CD                           ; 7B9E 8D CD 60                 ..`
        lda     $632C,y                         ; 7BA1 B9 2C 63                 .,c
        adc     #$00                            ; 7BA4 69 00                    i.
        sta     $60CC                           ; 7BA6 8D CC 60                 ..`
        ldx     $6604,y                         ; 7BA9 BE 04 66                 ..f
        stx     $60BD                           ; 7BAC 8E BD 60                 ..`
        lda     #$0D                            ; 7BAF A9 0D                    ..
        sta     $60A7                           ; 7BB1 8D A7 60                 ..`
        lda     #$00                            ; 7BB4 A9 00                    ..
        sta     $60E1                           ; 7BB6 8D E1 60                 ..`
        dec     $6118,x                         ; 7BB9 DE 18 61                 ..a
        dec     $611E,x                         ; 7BBC DE 1E 61                 ..a
        jmp     L6F0C                           ; 7BBF 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L7BC2:  rts                                     ; 7BC2 60                       `

; ----------------------------------------------------------------------------
        lda     #$02                            ; 7BC3 A9 02                    ..
        ldx     $6874,y                         ; 7BC5 BE 74 68                 .th
        bne     L7BD6                           ; 7BC8 D0 0C                    ..
        lda     $60C1                           ; 7BCA AD C1 60                 ..`
        eor     $60C3                           ; 7BCD 4D C3 60                 M.`
        and     #$01                            ; 7BD0 29 01                    ).
        beq     L7C39                           ; 7BD2 F0 65                    .e
        lda     #$04                            ; 7BD4 A9 04                    ..
L7BD6:  sta     $61                             ; 7BD6 85 61                    .a
        lda     $67A4,y                         ; 7BD8 B9 A4 67                 ..g
        ora     $66D4,y                         ; 7BDB 19 D4 66                 ..f
        bpl     L7BF0                           ; 7BDE 10 10                    ..
        lda     $63FC,y                         ; 7BE0 B9 FC 63                 ..c
        sec                                     ; 7BE3 38                       8
        sbc     $61                             ; 7BE4 E5 61                    .a
        sta     $63FC,y                         ; 7BE6 99 FC 63                 ..c
        cmp     #$24                            ; 7BE9 C9 24                    .$
        bcs     L7C39                           ; 7BEB B0 4C                    .L
        jmp     L813E                           ; 7BED 4C 3E 81                 L>.

; ----------------------------------------------------------------------------
L7BF0:  ldx     $66D4,y                         ; 7BF0 BE D4 66                 ..f
        lda     $6604,x                         ; 7BF3 BD 04 66                 ..f
        sta     $6604,y                         ; 7BF6 99 04 66                 ..f
        lda     $673C,y                         ; 7BF9 B9 3C 67                 .<g
        sec                                     ; 7BFC 38                       8
        sbc     $63FC,y                         ; 7BFD F9 FC 63                 ..c
        pha                                     ; 7C00 48                       H
        bcs     L7C07                           ; 7C01 B0 04                    ..
        eor     #$FF                            ; 7C03 49 FF                    I.
        adc     #$01                            ; 7C05 69 01                    i.
L7C07:  cmp     $61                             ; 7C07 C5 61                    .a
        pla                                     ; 7C09 68                       h
        bcc     L7C17                           ; 7C0A 90 0B                    ..
        jsr     L7B44                           ; 7C0C 20 44 7B                  D{
        asl     a                               ; 7C0F 0A                       .
        ldx     $61                             ; 7C10 A6 61                    .a
        cpx     #$04                            ; 7C12 E0 04                    ..
        bne     L7C17                           ; 7C14 D0 01                    ..
        asl     a                               ; 7C16 0A                       .
L7C17:  clc                                     ; 7C17 18                       .
        adc     $63FC,y                         ; 7C18 79 FC 63                 y.c
        sta     $63FC,y                         ; 7C1B 99 FC 63                 ..c
        lda     $60E7                           ; 7C1E AD E7 60                 ..`
        pha                                     ; 7C21 48                       H
        jsr     L6906                           ; 7C22 20 06 69                  .i
        pla                                     ; 7C25 68                       h
        and     #$0F                            ; 7C26 29 0F                    ).
        bne     L7C39                           ; 7C28 D0 0F                    ..
        lda     $60E7                           ; 7C2A AD E7 60                 ..`
        and     #$3F                            ; 7C2D 29 3F                    )?
        sta     L0060                           ; 7C2F 85 60                    .`
        lsr     a                               ; 7C31 4A                       J
        adc     L0060                           ; 7C32 65 60                    e`
        adc     #$53                            ; 7C34 69 53                    iS
        sta     $673C,y                         ; 7C36 99 3C 67                 .<g
L7C39:  rts                                     ; 7C39 60                       `

; ----------------------------------------------------------------------------
        lda     $66D4,y                         ; 7C3A B9 D4 66                 ..f
        ora     $673C,y                         ; 7C3D 19 3C 67                 .<g
        bmi     L7C52                           ; 7C40 30 10                    0.
        ldx     $66D4,y                         ; 7C42 BE D4 66                 ..f
        lda     $63FC,x                         ; 7C45 BD FC 63                 ..c
        sta     $63FC,y                         ; 7C48 99 FC 63                 ..c
        lda     $6604,x                         ; 7C4B BD 04 66                 ..f
        sta     $6604,y                         ; 7C4E 99 04 66                 ..f
L7C51:  rts                                     ; 7C51 60                       `

; ----------------------------------------------------------------------------
L7C52:  lda     $66D4,y                         ; 7C52 B9 D4 66                 ..f
        bpl     L7C92                           ; 7C55 10 3B                    .;
        lda     $63FC,y                         ; 7C57 B9 FC 63                 ..c
        cmp     #$27                            ; 7C5A C9 27                    .'
        bcs     L7C6F                           ; 7C5C B0 11                    ..
        lda     $6464,y                         ; 7C5E B9 64 64                 .dd
        sec                                     ; 7C61 38                       8
        sbc     #$02                            ; 7C62 E9 02                    ..
        sta     $6464,y                         ; 7C64 99 64 64                 .dd
        cmp     $63FC,y                         ; 7C67 D9 FC 63                 ..c
        bcs     L7C51                           ; 7C6A B0 E5                    ..
L7C6C:  jmp     LAC0C                           ; 7C6C 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L7C6F:  lda     $673C,y                         ; 7C6F B9 3C 67                 .<g
        bpl     L7C83                           ; 7C72 10 0F                    ..
        lda     $6464,y                         ; 7C74 B9 64 64                 .dd
        clc                                     ; 7C77 18                       .
        adc     #$02                            ; 7C78 69 02                    i.
        cmp     #$DD                            ; 7C7A C9 DD                    ..
        bcc     L7C80                           ; 7C7C 90 02                    ..
        lda     #$DD                            ; 7C7E A9 DD                    ..
L7C80:  sta     $6464,y                         ; 7C80 99 64 64                 .dd
L7C83:  lda     $63FC,y                         ; 7C83 B9 FC 63                 ..c
        clc                                     ; 7C86 18                       .
        adc     #$02                            ; 7C87 69 02                    i.
        sta     $63FC,y                         ; 7C89 99 FC 63                 ..c
        cmp     $6464,y                         ; 7C8C D9 64 64                 .dd
        bcs     L7C6C                           ; 7C8F B0 DB                    ..
        rts                                     ; 7C91 60                       `

; ----------------------------------------------------------------------------
L7C92:  lda     $63FC,y                         ; 7C92 B9 FC 63                 ..c
        cmp     #$27                            ; 7C95 C9 27                    .'
        bcc     L7C9E                           ; 7C97 90 05                    ..
        sbc     #$02                            ; 7C99 E9 02                    ..
        sta     $63FC,y                         ; 7C9B 99 FC 63                 ..c
L7C9E:  lda     $6464,y                         ; 7C9E B9 64 64                 .dd
        sec                                     ; 7CA1 38                       8
        sbc     #$02                            ; 7CA2 E9 02                    ..
        sta     $6464,y                         ; 7CA4 99 64 64                 .dd
        cmp     $63FC,y                         ; 7CA7 D9 FC 63                 ..c
        bcc     L7C6C                           ; 7CAA 90 C0                    ..
        rts                                     ; 7CAC 60                       `

; ----------------------------------------------------------------------------
L7CAD:  lda     $6394,x                         ; 7CAD BD 94 63                 ..c
        sec                                     ; 7CB0 38                       8
        sbc     $60CD                           ; 7CB1 ED CD 60                 ..`
        sta     L0060                           ; 7CB4 85 60                    .`
        lda     $632C,x                         ; 7CB6 BD 2C 63                 .,c
        sbc     $60CC                           ; 7CB9 ED CC 60                 ..`
        sta     $61                             ; 7CBC 85 61                    .a
        ldy     #$00                            ; 7CBE A0 00                    ..
        lda     $6534,x                         ; 7CC0 BD 34 65                 .4e
        bpl     L7CC6                           ; 7CC3 10 01                    ..
        dey                                     ; 7CC5 88                       .
L7CC6:  sta     $60D0                           ; 7CC6 8D D0 60                 ..`
        sty     $60D2                           ; 7CC9 8C D2 60                 ..`
        lda     $60E7                           ; 7CCC AD E7 60                 ..`
        bmi     L7CDB                           ; 7CCF 30 0A                    0.
        and     #$40                            ; 7CD1 29 40                    )@
        beq     L7CF3                           ; 7CD3 F0 1E                    ..
        lda     $64CC,x                         ; 7CD5 BD CC 64                 ..d
        jmp     L7CE5                           ; 7CD8 4C E5 7C                 L.|

; ----------------------------------------------------------------------------
L7CDB:  lda     $64CC,x                         ; 7CDB BD CC 64                 ..d
        asl     a                               ; 7CDE 0A                       .
        asl     $60D0                           ; 7CDF 0E D0 60                 ..`
        rol     $60D2                           ; 7CE2 2E D2 60                 ..`
L7CE5:  asl     a                               ; 7CE5 0A                       .
        asl     $60D0                           ; 7CE6 0E D0 60                 ..`
        rol     $60D2                           ; 7CE9 2E D2 60                 ..`
        asl     a                               ; 7CEC 0A                       .
        asl     $60D0                           ; 7CED 0E D0 60                 ..`
        rol     $60D2                           ; 7CF0 2E D2 60                 ..`
L7CF3:  sta     $62                             ; 7CF3 85 62                    .b
        ldy     $6124,x                         ; 7CF5 BC 24 61                 .$a
        lda     L6935,y                         ; 7CF8 B9 35 69                 .5i
        lsr     a                               ; 7CFB 4A                       J
        sta     $63                             ; 7CFC 85 63                    .c
        lda     $63FC,x                         ; 7CFE BD FC 63                 ..c
        sec                                     ; 7D01 38                       8
        sbc     $63                             ; 7D02 E5 63                    .c
        sbc     #$1F                            ; 7D04 E9 1F                    ..
        clc                                     ; 7D06 18                       .
        adc     $60D0                           ; 7D07 6D D0 60                 m.`
        sta     $60D0                           ; 7D0A 8D D0 60                 ..`
        lda     #$00                            ; 7D0D A9 00                    ..
        adc     $60D2                           ; 7D0F 6D D2 60                 m.`
        sta     $60D2                           ; 7D12 8D D2 60                 ..`
        lda     $60D0                           ; 7D15 AD D0 60                 ..`
        sec                                     ; 7D18 38                       8
        sbc     $60CE                           ; 7D19 ED CE 60                 ..`
        sta     $60D0                           ; 7D1C 8D D0 60                 ..`
        lda     $60D2                           ; 7D1F AD D2 60                 ..`
        sbc     #$00                            ; 7D22 E9 00                    ..
        lsr     a                               ; 7D24 4A                       J
        ror     $60D0                           ; 7D25 6E D0 60                 n.`
        lsr     a                               ; 7D28 4A                       J
        ror     $60D0                           ; 7D29 6E D0 60                 n.`
        lsr     a                               ; 7D2C 4A                       J
        ror     $60D0                           ; 7D2D 6E D0 60                 n.`
        ldy     $6124,x                         ; 7D30 BC 24 61                 .$a
        lda     L6917,y                         ; 7D33 B9 17 69                 ..i
        lsr     a                               ; 7D36 4A                       J
        ldx     #$00                            ; 7D37 A2 00                    ..
        clc                                     ; 7D39 18                       .
        adc     $62                             ; 7D3A 65 62                    eb
        bpl     L7D3F                           ; 7D3C 10 01                    ..
        dex                                     ; 7D3E CA                       .
L7D3F:  clc                                     ; 7D3F 18                       .
        adc     L0060                           ; 7D40 65 60                    e`
        sta     L0060                           ; 7D42 85 60                    .`
        txa                                     ; 7D44 8A                       .
        adc     $61                             ; 7D45 65 61                    ea
        lsr     a                               ; 7D47 4A                       J
        ror     L0060                           ; 7D48 66 60                    f`
        lsr     a                               ; 7D4A 4A                       J
        ror     L0060                           ; 7D4B 66 60                    f`
        lsr     a                               ; 7D4D 4A                       J
        ror     L0060                           ; 7D4E 66 60                    f`
        lda     L0060                           ; 7D50 A5 60                    .`
        sta     $60CF                           ; 7D52 8D CF 60                 ..`
        lda     #$01                            ; 7D55 A9 01                    ..
        sta     $60A8                           ; 7D57 8D A8 60                 ..`
        lda     #$05                            ; 7D5A A9 05                    ..
        jmp     L8243                           ; 7D5C 4C 43 82                 LC.

; ----------------------------------------------------------------------------
        lda     $659C,y                         ; 7D5F B9 9C 65                 ..e
        cmp     #$16                            ; 7D62 C9 16                    ..
        beq     L7D71                           ; 7D64 F0 0B                    ..
        lda     $60C1                           ; 7D66 AD C1 60                 ..`
        and     #$01                            ; 7D69 29 01                    ).
        adc     $659C,y                         ; 7D6B 79 9C 65                 y.e
        sta     $659C,y                         ; 7D6E 99 9C 65                 ..e
L7D71:  ldx     $66D4,y                         ; 7D71 BE D4 66                 ..f
        bne     L7D7C                           ; 7D74 D0 06                    ..
        jsr     L8327                           ; 7D76 20 27 83                  '.
        bcs     L7D81                           ; 7D79 B0 06                    ..
L7D7B:  rts                                     ; 7D7B 60                       `

; ----------------------------------------------------------------------------
L7D7C:  jsr     L8362                           ; 7D7C 20 62 83                  b.
        bcc     L7D7B                           ; 7D7F 90 FA                    ..
L7D81:  lda     $6874,y                         ; 7D81 B9 74 68                 .th
        beq     L7DD0                           ; 7D84 F0 4A                    .J
        lda     #$00                            ; 7D86 A9 00                    ..
        sta     $62                             ; 7D88 85 62                    .b
        lda     $6394,y                         ; 7D8A B9 94 63                 ..c
        sec                                     ; 7D8D 38                       8
        sbc     $6394,x                         ; 7D8E FD 94 63                 ..c
        sta     L0060                           ; 7D91 85 60                    .`
        lda     $632C,y                         ; 7D93 B9 2C 63                 .,c
        sbc     $632C,x                         ; 7D96 FD 2C 63                 .,c
        sta     $61                             ; 7D99 85 61                    .a
        bcs     L7DB1                           ; 7D9B B0 14                    ..
        lda     #$02                            ; 7D9D A9 02                    ..
        sta     $62                             ; 7D9F 85 62                    .b
        lda     L0060                           ; 7DA1 A5 60                    .`
        eor     #$FF                            ; 7DA3 49 FF                    I.
        adc     #$01                            ; 7DA5 69 01                    i.
        sta     L0060                           ; 7DA7 85 60                    .`
        lda     $61                             ; 7DA9 A5 61                    .a
        eor     #$FF                            ; 7DAB 49 FF                    I.
        adc     #$00                            ; 7DAD 69 00                    i.
        sta     $61                             ; 7DAF 85 61                    .a
L7DB1:  lda     $61                             ; 7DB1 A5 61                    .a
        bne     L7D7B                           ; 7DB3 D0 C6                    ..
        lda     L0060                           ; 7DB5 A5 60                    .`
        cmp     #$0F                            ; 7DB7 C9 0F                    ..
        bcs     L7DBF                           ; 7DB9 B0 04                    ..
        lda     #$1C                            ; 7DBB A9 1C                    ..
        bne     L7DCD                           ; 7DBD D0 0E                    ..
L7DBF:  lda     $63FC,y                         ; 7DBF B9 FC 63                 ..c
        sec                                     ; 7DC2 38                       8
        sbc     $63FC,x                         ; 7DC3 FD FC 63                 ..c
        lsr     a                               ; 7DC6 4A                       J
        cmp     L0060                           ; 7DC7 C5 60                    .`
        lda     #$18                            ; 7DC9 A9 18                    ..
        adc     $62                             ; 7DCB 65 62                    eb
L7DCD:  sta     $62C4,y                         ; 7DCD 99 C4 62                 ..b
L7DD0:  lda     $60C1                           ; 7DD0 AD C1 60                 ..`
        eor     $60C3                           ; 7DD3 4D C3 60                 M.`
        and     #$01                            ; 7DD6 29 01                    ).
        bne     L7D7B                           ; 7DD8 D0 A1                    ..
        lda     $6394,y                         ; 7DDA B9 94 63                 ..c
        clc                                     ; 7DDD 18                       .
        adc     #$03                            ; 7DDE 69 03                    i.
        sta     $60CD                           ; 7DE0 8D CD 60                 ..`
        lda     $632C,y                         ; 7DE3 B9 2C 63                 .,c
        adc     #$00                            ; 7DE6 69 00                    i.
        sta     $60CC                           ; 7DE8 8D CC 60                 ..`
        lda     $6604,y                         ; 7DEB B9 04 66                 ..f
        sta     $60BD                           ; 7DEE 8D BD 60                 ..`
        lda     #$DA                            ; 7DF1 A9 DA                    ..
        sta     $60CE                           ; 7DF3 8D CE 60                 ..`
        jmp     L7CAD                           ; 7DF6 4C AD 7C                 L.|

; ----------------------------------------------------------------------------
L7DF9:  lda     #$00                            ; 7DF9 A9 00                    ..
        sta     $60AF                           ; 7DFB 8D AF 60                 ..`
        ldx     $60C3                           ; 7DFE AE C3 60                 ..`
        lda     $63FC,x                         ; 7E01 BD FC 63                 ..c
        cmp     #$DD                            ; 7E04 C9 DD                    ..
        beq     L7E0B                           ; 7E06 F0 03                    ..
        dec     $63FC,x                         ; 7E08 DE FC 63                 ..c
L7E0B:  lda     $673C,x                         ; 7E0B BD 3C 67                 .<g
        beq     L7E13                           ; 7E0E F0 03                    ..
        dec     $673C,x                         ; 7E10 DE 3C 67                 .<g
L7E13:  jsr     L7E48                           ; 7E13 20 48 7E                  H~
        ldy     $60C3                           ; 7E16 AC C3 60                 ..`
        lda     $6124,y                         ; 7E19 B9 24 61                 .$a
        beq     L7E47                           ; 7E1C F0 29                    .)
        lda     $60AF                           ; 7E1E AD AF 60                 ..`
        bne     L7E47                           ; 7E21 D0 24                    .$
        ldx     #$1D                            ; 7E23 A2 1D                    ..
        lda     $64CC,y                         ; 7E25 B9 CC 64                 ..d
        bmi     L7E2C                           ; 7E28 30 02                    0.
        ldx     #$21                            ; 7E2A A2 21                    .!
L7E2C:  stx     L0060                           ; 7E2C 86 60                    .`
        lda     $60C1                           ; 7E2E AD C1 60                 ..`
        adc     $60C3                           ; 7E31 6D C3 60                 m.`
        and     #$03                            ; 7E34 29 03                    ).
        clc                                     ; 7E36 18                       .
        adc     L0060                           ; 7E37 65 60                    e`
        sta     L0060                           ; 7E39 85 60                    .`
        lda     $6604,y                         ; 7E3B B9 04 66                 ..f
        beq     L7E42                           ; 7E3E F0 02                    ..
        lda     #$08                            ; 7E40 A9 08                    ..
L7E42:  adc     L0060                           ; 7E42 65 60                    e`
        sta     $62C4,y                         ; 7E44 99 C4 62                 ..b
L7E47:  rts                                     ; 7E47 60                       `

; ----------------------------------------------------------------------------
L7E48:  lda     $6394,y                         ; 7E48 B9 94 63                 ..c
        sec                                     ; 7E4B 38                       8
        sbc     #$01                            ; 7E4C E9 01                    ..
        and     #$03                            ; 7E4E 29 03                    ).
        bne     L7E9C                           ; 7E50 D0 4A                    .J
        jsr     L80A2                           ; 7E52 20 A2 80                  ..
        bcc     L7E9C                           ; 7E55 90 45                    .E
        lda     $659C,y                         ; 7E57 B9 9C 65                 ..e
        cmp     #$05                            ; 7E5A C9 05                    ..
        bne     L7E99                           ; 7E5C D0 3B                    .;
        lda     $6124,x                         ; 7E5E BD 24 61                 .$a
        cmp     #$17                            ; 7E61 C9 17                    ..
        beq     L7E89                           ; 7E63 F0 24                    .$
        lda     $67A4,y                         ; 7E65 B9 A4 67                 ..g
        bne     L7E9C                           ; 7E68 D0 32                    .2
        lda     $6604,y                         ; 7E6A B9 04 66                 ..f
        cmp     $6604,x                         ; 7E6D DD 04 66                 ..f
        bne     L7E99                           ; 7E70 D0 27                    .'
        lda     $6124,x                         ; 7E72 BD 24 61                 .$a
        cmp     #$16                            ; 7E75 C9 16                    ..
        beq     L7E80                           ; 7E77 F0 07                    ..
        lda     $67A4,x                         ; 7E79 BD A4 67                 ..g
        bne     L7E9C                           ; 7E7C D0 1E                    ..
        beq     L7E99                           ; 7E7E F0 19                    ..
L7E80:  lda     $67A4,x                         ; 7E80 BD A4 67                 ..g
        cmp     #$05                            ; 7E83 C9 05                    ..
        bcs     L7E9C                           ; 7E85 B0 15                    ..
        bcc     L7E99                           ; 7E87 90 10                    ..
L7E89:  lda     $632C,x                         ; 7E89 BD 2C 63                 .,c
        lsr     a                               ; 7E8C 4A                       J
        lsr     a                               ; 7E8D 4A                       J
        lsr     a                               ; 7E8E 4A                       J
        cmp     $6604,y                         ; 7E8F D9 04 66                 ..f
        bne     L7E99                           ; 7E92 D0 05                    ..
        lda     $67A4,x                         ; 7E94 BD A4 67                 ..g
        bne     L7E9C                           ; 7E97 D0 03                    ..
L7E99:  jmp     L80D6                           ; 7E99 4C D6 80                 L..

; ----------------------------------------------------------------------------
L7E9C:  jsr     L824E                           ; 7E9C 20 4E 82                  N.
        bcc     L7EE9                           ; 7E9F 90 48                    .H
        ldy     $60C3                           ; 7EA1 AC C3 60                 ..`
        ldx     $6027                           ; 7EA4 AE 27 60                 .'`
        lda     $6604,y                         ; 7EA7 B9 04 66                 ..f
        cmp     $6604,x                         ; 7EAA DD 04 66                 ..f
        bne     L7ECE                           ; 7EAD D0 1F                    ..
        tax                                     ; 7EAF AA                       .
        lda     $6100,x                         ; 7EB0 BD 00 61                 ..a
        cmp     #$05                            ; 7EB3 C9 05                    ..
        beq     L7EE9                           ; 7EB5 F0 32                    .2
        ldy     $60C3                           ; 7EB7 AC C3 60                 ..`
        ldx     $6604,y                         ; 7EBA BE 04 66                 ..f
        inc     $6118,x                         ; 7EBD FE 18 61                 ..a
        inc     $611E,x                         ; 7EC0 FE 1E 61                 ..a
        inc     $6100,x                         ; 7EC3 FE 00 61                 ..a
        lda     #$FF                            ; 7EC6 A9 FF                    ..
        sta     $680C,y                         ; 7EC8 99 0C 68                 ..h
        jmp     LAC0C                           ; 7ECB 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L7ECE:  lda     $6604,x                         ; 7ECE BD 04 66                 ..f
        tax                                     ; 7ED1 AA                       .
        lda     $6104,x                         ; 7ED2 BD 04 61                 ..a
        bne     L7EE9                           ; 7ED5 D0 12                    ..
        lda     $60C3                           ; 7ED7 AD C3 60                 ..`
        pha                                     ; 7EDA 48                       H
        lda     $6027                           ; 7EDB AD 27 60                 .'`
        sta     $60C3                           ; 7EDE 8D C3 60                 ..`
        jsr     LAC0C                           ; 7EE1 20 0C AC                  ..
        pla                                     ; 7EE4 68                       h
        sta     $60C3                           ; 7EE5 8D C3 60                 ..`
        rts                                     ; 7EE8 60                       `

; ----------------------------------------------------------------------------
L7EE9:  ldy     $60C3                           ; 7EE9 AC C3 60                 ..`
        lda     $673C,y                         ; 7EEC B9 3C 67                 .<g
        bne     L7F06                           ; 7EEF D0 15                    ..
        lda     $6874,y                         ; 7EF1 B9 74 68                 .th
        beq     L7EF9                           ; 7EF4 F0 03                    ..
        jmp     L820C                           ; 7EF6 4C 0C 82                 L..

; ----------------------------------------------------------------------------
L7EF9:  lda     $67A4,y                         ; 7EF9 B9 A4 67                 ..g
        beq     L7F03                           ; 7EFC F0 05                    ..
        jsr     L83D8                           ; 7EFE 20 D8 83                  ..
        bcs     L7F63                           ; 7F01 B0 60                    .`
L7F03:  jmp     L7A8D                           ; 7F03 4C 8D 7A                 L.z

; ----------------------------------------------------------------------------
L7F06:  lda     #$01                            ; 7F06 A9 01                    ..
        ldx     $6874,y                         ; 7F08 BE 74 68                 .th
        beq     L7F17                           ; 7F0B F0 0A                    ..
        bpl     L7F11                           ; 7F0D 10 02                    ..
        lda     #$FF                            ; 7F0F A9 FF                    ..
L7F11:  sta     $64CC,y                         ; 7F11 99 CC 64                 ..d
        jmp     L7A12                           ; 7F14 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
L7F17:  jmp     L7A85                           ; 7F17 4C 85 7A                 L.z

; ----------------------------------------------------------------------------
L7F1A:  lda     $6394,y                         ; 7F1A B9 94 63                 ..c
        ora     $632C,y                         ; 7F1D 19 2C 63                 .,c
        bne     L7F25                           ; 7F20 D0 03                    ..
        jmp     L813E                           ; 7F22 4C 3E 81                 L>.

; ----------------------------------------------------------------------------
L7F25:  tya                                     ; 7F25 98                       .
        eor     $60C1                           ; 7F26 4D C1 60                 M.`
        and     #$1F                            ; 7F29 29 1F                    ).
        bne     L7F39                           ; 7F2B D0 0C                    ..
        lda     $659C,y                         ; 7F2D B9 9C 65                 ..e
        cmp     #$0F                            ; 7F30 C9 0F                    ..
        bcs     L7F39                           ; 7F32 B0 05                    ..
        adc     #$01                            ; 7F34 69 01                    i.
        sta     $659C,y                         ; 7F36 99 9C 65                 ..e
L7F39:  lda     $63FC,y                         ; 7F39 B9 FC 63                 ..c
        cmp     #$DD                            ; 7F3C C9 DD                    ..
        beq     L7F45                           ; 7F3E F0 05                    ..
        sbc     #$01                            ; 7F40 E9 01                    ..
        sta     $63FC,y                         ; 7F42 99 FC 63                 ..c
L7F45:  lda     $673C,y                         ; 7F45 B9 3C 67                 .<g
        beq     L7F50                           ; 7F48 F0 06                    ..
        ldx     $60C3                           ; 7F4A AE C3 60                 ..`
        dec     $673C,x                         ; 7F4D DE 3C 67                 .<g
L7F50:  lda     $6604,y                         ; 7F50 B9 04 66                 ..f
        asl     a                               ; 7F53 0A                       .
        adc     #$2D                            ; 7F54 69 2D                    i-
        sta     $62C4,y                         ; 7F56 99 C4 62                 ..b
        lda     $6874,y                         ; 7F59 B9 74 68                 .th
        beq     L7F67                           ; 7F5C F0 09                    ..
        lda     $673C,y                         ; 7F5E B9 3C 67                 .<g
        beq     L7F64                           ; 7F61 F0 01                    ..
L7F63:  rts                                     ; 7F63 60                       `

; ----------------------------------------------------------------------------
L7F64:  jmp     L8146                           ; 7F64 4C 46 81                 LF.

; ----------------------------------------------------------------------------
L7F67:  lda     $60C1                           ; 7F67 AD C1 60                 ..`
        and     #$01                            ; 7F6A 29 01                    ).
        clc                                     ; 7F6C 18                       .
        adc     $62C4,y                         ; 7F6D 79 C4 62                 y.b
        sta     $62C4,y                         ; 7F70 99 C4 62                 ..b
        jmp     L7A8D                           ; 7F73 4C 8D 7A                 L.z

; ----------------------------------------------------------------------------
        lda     $60C1                           ; 7F76 AD C1 60                 ..`
        eor     $60C3                           ; 7F79 4D C3 60                 M.`
        and     #$03                            ; 7F7C 29 03                    ).
        bne     L7FF1                           ; 7F7E D0 71                    .q
        lda     $6604,y                         ; 7F80 B9 04 66                 ..f
        sta     $60BD                           ; 7F83 8D BD 60                 ..`
        eor     #$01                            ; 7F86 49 01                    I.
        tax                                     ; 7F88 AA                       .
        lda     $6104,x                         ; 7F89 BD 04 61                 ..a
        bne     L7FF1                           ; 7F8C D0 63                    .c
        lda     $6114,x                         ; 7F8E BD 14 61                 ..a
        bpl     L7FF1                           ; 7F91 10 5E                    .^
        lda     $6112,x                         ; 7F93 BD 12 61                 ..a
        tax                                     ; 7F96 AA                       .
        lda     $6394,x                         ; 7F97 BD 94 63                 ..c
        sec                                     ; 7F9A 38                       8
        sbc     $6394,y                         ; 7F9B F9 94 63                 ..c
        lda     $632C,x                         ; 7F9E BD 2C 63                 .,c
        sbc     $632C,y                         ; 7FA1 F9 2C 63                 .,c
        bcs     L7FB3                           ; 7FA4 B0 0D                    ..
        lda     $6394,y                         ; 7FA6 B9 94 63                 ..c
        sec                                     ; 7FA9 38                       8
        sbc     $6394,x                         ; 7FAA FD 94 63                 ..c
        lda     $632C,y                         ; 7FAD B9 2C 63                 .,c
        sbc     $632C,x                         ; 7FB0 FD 2C 63                 .,c
L7FB3:  bne     L7FF1                           ; 7FB3 D0 3C                    .<
        lda     $60BD                           ; 7FB5 AD BD 60                 ..`
        asl     a                               ; 7FB8 0A                       .
        asl     a                               ; 7FB9 0A                       .
        asl     a                               ; 7FBA 0A                       .
        adc     $6394,y                         ; 7FBB 79 94 63                 y.c
        sta     $60CD                           ; 7FBE 8D CD 60                 ..`
        lda     $632C,y                         ; 7FC1 B9 2C 63                 .,c
        adc     #$00                            ; 7FC4 69 00                    i.
        sta     $60CC                           ; 7FC6 8D CC 60                 ..`
        lda     #$D9                            ; 7FC9 A9 D9                    ..
        sta     $60CE                           ; 7FCB 8D CE 60                 ..`
        stx     $60A8                           ; 7FCE 8E A8 60                 ..`
        lda     #$02                            ; 7FD1 A9 02                    ..
        sta     $60AF                           ; 7FD3 8D AF 60                 ..`
        lda     #$00                            ; 7FD6 A9 00                    ..
        sta     $60CF                           ; 7FD8 8D CF 60                 ..`
        sta     $60D0                           ; 7FDB 8D D0 60                 ..`
        lda     #$12                            ; 7FDE A9 12                    ..
        sta     $60A7                           ; 7FE0 8D A7 60                 ..`
        jsr     L6F0C                           ; 7FE3 20 0C 6F                  .o
        ldy     $60C3                           ; 7FE6 AC C3 60                 ..`
        lda     #$00                            ; 7FE9 A9 00                    ..
        sta     $680C,y                         ; 7FEB 99 0C 68                 ..h
        jmp     LAC0C                           ; 7FEE 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L7FF1:  lda     #$06                            ; 7FF1 A9 06                    ..
        jsr     L7FF9                           ; 7FF3 20 F9 7F                  ..
        jmp     L7A8D                           ; 7FF6 4C 8D 7A                 L.z

; ----------------------------------------------------------------------------
L7FF9:  sta     L0060                           ; 7FF9 85 60                    .`
        tya                                     ; 7FFB 98                       .
        eor     $60C1                           ; 7FFC 4D C1 60                 M.`
        pha                                     ; 7FFF 48                       H
L8000:  and     #$01                            ; 8000 29 01                    ).
        clc                                     ; 8002 18                       .
        adc     $67A4,y                         ; 8003 79 A4 67                 y.g
        sta     $62C4,y                         ; 8006 99 C4 62                 ..b
        lda     $63FC,y                         ; 8009 B9 FC 63                 ..c
        cmp     #$DD                            ; 800C C9 DD                    ..
        beq     L8015                           ; 800E F0 05                    ..
        sbc     #$01                            ; 8010 E9 01                    ..
        sta     $63FC,y                         ; 8012 99 FC 63                 ..c
L8015:  pla                                     ; 8015 68                       h
        and     #$3F                            ; 8016 29 3F                    )?
        bne     L8026                           ; 8018 D0 0C                    ..
        lda     $659C,y                         ; 801A B9 9C 65                 ..e
        cmp     L0060                           ; 801D C5 60                    .`
        bcs     L8026                           ; 801F B0 05                    ..
        adc     #$01                            ; 8021 69 01                    i.
        sta     $659C,y                         ; 8023 99 9C 65                 ..e
L8026:  rts                                     ; 8026 60                       `

; ----------------------------------------------------------------------------
        lda     #$09                            ; 8027 A9 09                    ..
        jsr     L7FF9                           ; 8029 20 F9 7F                  ..
        lda     $60C6                           ; 802C AD C6 60                 ..`
        bne     L809E                           ; 802F D0 6D                    .m
        lda     $6394,y                         ; 8031 B9 94 63                 ..c
        clc                                     ; 8034 18                       .
        adc     #$04                            ; 8035 69 04                    i.
        and     #$07                            ; 8037 29 07                    ).
        bne     L809F                           ; 8039 D0 64                    .d
        lda     $6604,y                         ; 803B B9 04 66                 ..f
        eor     #$01                            ; 803E 49 01                    I.
        tax                                     ; 8040 AA                       .
        stx     L0060                           ; 8041 86 60                    .`
        lda     $6106,x                         ; 8043 BD 06 61                 ..a
        tax                                     ; 8046 AA                       .
        lda     $6394,x                         ; 8047 BD 94 63                 ..c
        clc                                     ; 804A 18                       .
        adc     #$04                            ; 804B 69 04                    i.
        sta     $61                             ; 804D 85 61                    .a
        lda     $632C,x                         ; 804F BD 2C 63                 .,c
        adc     #$00                            ; 8052 69 00                    i.
        cmp     $632C,y                         ; 8054 D9 2C 63                 .,c
        bne     L809F                           ; 8057 D0 46                    .F
        lda     $6394,y                         ; 8059 B9 94 63                 ..c
        cmp     $61                             ; 805C C5 61                    .a
        bne     L809F                           ; 805E D0 3F                    .?
        lda     $6604,y                         ; 8060 B9 04 66                 ..f
        sta     $60C6                           ; 8063 8D C6 60                 ..`
        eor     #$01                            ; 8066 49 01                    I.
        ora     $60B0                           ; 8068 0D B0 60                 ..`
        sta     $60B0                           ; 806B 8D B0 60                 ..`
        lda     #$F0                            ; 806E A9 F0                    ..
        sta     $60C7                           ; 8070 8D C7 60                 ..`
        ldx     L0060                           ; 8073 A6 60                    .`
        lda     $60C3                           ; 8075 AD C3 60                 ..`
        pha                                     ; 8078 48                       H
        lda     $60F2,x                         ; 8079 BD F2 60                 ..`
        sta     $60C3                           ; 807C 8D C3 60                 ..`
        tax                                     ; 807F AA                       .
        lda     #$00                            ; 8080 A9 00                    ..
        sta     $680C,x                         ; 8082 9D 0C 68                 ..h
        jsr     LAC0C                           ; 8085 20 0C AC                  ..
        pla                                     ; 8088 68                       h
        sta     $60C3                           ; 8089 8D C3 60                 ..`
        inc     $60C6                           ; 808C EE C6 60                 ..`
        lda     $60B6                           ; 808F AD B6 60                 ..`
        bne     L809E                           ; 8092 D0 0A                    ..
        lda     $60C6                           ; 8094 AD C6 60                 ..`
        cmp     #$02                            ; 8097 C9 02                    ..
L8099:  beq     L809E                           ; 8099 F0 03                    ..
        inc     $60B0                           ; 809B EE B0 60                 ..`
L809E:  rts                                     ; 809E 60                       `

; ----------------------------------------------------------------------------
L809F:  jmp     L7A8D                           ; 809F 4C 8D 7A                 L.z

; ----------------------------------------------------------------------------
L80A2:  lda     $6394,y                         ; 80A2 B9 94 63                 ..c
        sec                                     ; 80A5 38                       8
        sbc     #$05                            ; 80A6 E9 05                    ..
        sta     L0060                           ; 80A8 85 60                    .`
        lda     $632C,y                         ; 80AA B9 2C 63                 .,c
        sbc     #$00                            ; 80AD E9 00                    ..
        sta     $61                             ; 80AF 85 61                    .a
        ldx     #$67                            ; 80B1 A2 67                    .g
L80B3:  lda     $6124,x                         ; 80B3 BD 24 61                 .$a
        cmp     #$06                            ; 80B6 C9 06                    ..
        beq     L80C7                           ; 80B8 F0 0D                    ..
        cmp     #$16                            ; 80BA C9 16                    ..
        beq     L80C7                           ; 80BC F0 09                    ..
        cmp     #$17                            ; 80BE C9 17                    ..
        beq     L80C7                           ; 80C0 F0 05                    ..
L80C2:  dex                                     ; 80C2 CA                       .
        bpl     L80B3                           ; 80C3 10 EE                    ..
        clc                                     ; 80C5 18                       .
        rts                                     ; 80C6 60                       `

; ----------------------------------------------------------------------------
L80C7:  lda     $6394,x                         ; 80C7 BD 94 63                 ..c
        cmp     L0060                           ; 80CA C5 60                    .`
        bne     L80C2                           ; 80CC D0 F4                    ..
        lda     $632C,x                         ; 80CE BD 2C 63                 .,c
        cmp     $61                             ; 80D1 C5 61                    .a
        bne     L80C2                           ; 80D3 D0 ED                    ..
        rts                                     ; 80D5 60                       `

; ----------------------------------------------------------------------------
L80D6:  ldy     $60C3                           ; 80D6 AC C3 60                 ..`
        lda     $67A4,x                         ; 80D9 BD A4 67                 ..g
        beq     L80FE                           ; 80DC F0 20                    . 
        lda     $6604,y                         ; 80DE B9 04 66                 ..f
        cmp     $6604,x                         ; 80E1 DD 04 66                 ..f
        beq     L812B                           ; 80E4 F0 45                    .E
        dec     $67A4,x                         ; 80E6 DE A4 67                 ..g
        lda     $6604,x                         ; 80E9 BD 04 66                 ..f
        tax                                     ; 80EC AA                       .
        dec     $6118,x                         ; 80ED DE 18 61                 ..a
        dec     $611E,x                         ; 80F0 DE 1E 61                 ..a
        dec     $60AF                           ; 80F3 CE AF 60                 ..`
        lda     #$00                            ; 80F6 A9 00                    ..
        sta     $680C,y                         ; 80F8 99 0C 68                 ..h
        jmp     LAC0C                           ; 80FB 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L80FE:  lda     $6604,y                         ; 80FE B9 04 66                 ..f
        cmp     $6604,x                         ; 8101 DD 04 66                 ..f
        beq     L812B                           ; 8104 F0 25                    .%
        sta     $6604,x                         ; 8106 9D 04 66                 ..f
        stx     L0060                           ; 8109 86 60                    .`
        eor     #$01                            ; 810B 49 01                    I.
        tax                                     ; 810D AA                       .
        dec     $6118,x                         ; 810E DE 18 61                 ..a
        dec     $611C,x                         ; 8111 DE 1C 61                 ..a
        sty     $61                             ; 8114 84 61                    .a
        ldy     $05                             ; 8116 A4 05                    ..
        lda     L84F6,y                         ; 8118 B9 F6 84                 ...
        sta     $60AD,x                         ; 811B 9D AD 60                 ..`
        ldy     $61                             ; 811E A4 61                    .a
        ldx     $6604,y                         ; 8120 BE 04 66                 ..f
        inc     $6118,x                         ; 8123 FE 18 61                 ..a
        inc     $611C,x                         ; 8126 FE 1C 61                 ..a
        ldx     L0060                           ; 8129 A6 60                    .`
L812B:  inc     $67A4,x                         ; 812B FE A4 67                 ..g
        lda     $6124,x                         ; 812E BD 24 61                 .$a
        cmp     #$17                            ; 8131 C9 17                    ..
        beq     L813E                           ; 8133 F0 09                    ..
        ldx     $6604,y                         ; 8135 BE 04 66                 ..f
        inc     $6118,x                         ; 8138 FE 18 61                 ..a
        inc     $611E,x                         ; 813B FE 1E 61                 ..a
L813E:  lda     #$FF                            ; 813E A9 FF                    ..
        sta     $680C,y                         ; 8140 99 0C 68                 ..h
        jmp     LAC0C                           ; 8143 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L8146:  lda     #$03                            ; 8146 A9 03                    ..
        sta     $673C,y                         ; 8148 99 3C 67                 .<g
        lda     $66D4,y                         ; 814B B9 D4 66                 ..f
        lsr     a                               ; 814E 4A                       J
        bcs     L81C0                           ; 814F B0 6F                    .o
        lsr     a                               ; 8151 4A                       J
        bcs     L8164                           ; 8152 B0 10                    ..
        lda     $05                             ; 8154 A5 05                    ..
        eor     #$01                            ; 8156 49 01                    I.
        beq     L8164                           ; 8158 F0 0A                    ..
        lda     $60C1                           ; 815A AD C1 60                 ..`
        eor     $60C3                           ; 815D 4D C3 60                 M.`
        and     #$03                            ; 8160 29 03                    ).
        beq     L81C0                           ; 8162 F0 5C                    .\
L8164:  php                                     ; 8164 08                       .
        lda     $6604,y                         ; 8165 B9 04 66                 ..f
        sta     $60BD                           ; 8168 8D BD 60                 ..`
        tax                                     ; 816B AA                       .
        eor     #$01                            ; 816C 49 01                    I.
        beq     L8173                           ; 816E F0 03                    ..
        lda     L6925                           ; 8170 AD 25 69                 .%i
L8173:  sec                                     ; 8173 38                       8
        adc     $6394,y                         ; 8174 79 94 63                 y.c
        sta     $60CD                           ; 8177 8D CD 60                 ..`
        lda     $632C,y                         ; 817A B9 2C 63                 .,c
        adc     #$00                            ; 817D 69 00                    i.
        sta     $60CC                           ; 817F 8D CC 60                 ..`
        lda     $60CD                           ; 8182 AD CD 60                 ..`
        bne     L818A                           ; 8185 D0 03                    ..
        dec     $60CC                           ; 8187 CE CC 60                 ..`
L818A:  dec     $60CD                           ; 818A CE CD 60                 ..`
        lda     L84A3,x                         ; 818D BD A3 84                 ...
        asl     a                               ; 8190 0A                       .
        sta     $60CF                           ; 8191 8D CF 60                 ..`
        lda     #$00                            ; 8194 A9 00                    ..
        sta     $60D0                           ; 8196 8D D0 60                 ..`
        sta     $60A8                           ; 8199 8D A8 60                 ..`
        lda     #$05                            ; 819C A9 05                    ..
        ldx     #$D9                            ; 819E A2 D9                    ..
        plp                                     ; 81A0 28                       (
        bcc     L81BA                           ; 81A1 90 17                    ..
        asl     $60CF                           ; 81A3 0E CF 60                 ..`
        jsr     L6906                           ; 81A6 20 06 69                  .i
        and     #$70                            ; 81A9 29 70                    )p
        bne     L81B1                           ; 81AB D0 04                    ..
        lda     #$0F                            ; 81AD A9 0F                    ..
        bne     L81B8                           ; 81AF D0 07                    ..
L81B1:  lda     $60E7                           ; 81B1 AD E7 60                 ..`
        and     #$03                            ; 81B4 29 03                    ).
        adc     #$01                            ; 81B6 69 01                    i.
L81B8:  ldx     #$D3                            ; 81B8 A2 D3                    ..
L81BA:  stx     $60CE                           ; 81BA 8E CE 60                 ..`
        jmp     L8243                           ; 81BD 4C 43 82                 LC.

; ----------------------------------------------------------------------------
L81C0:  lda     #$1C                            ; 81C0 A9 1C                    ..
        sta     $60A7                           ; 81C2 8D A7 60                 ..`
        lda     L6925                           ; 81C5 AD 25 69                 .%i
        ldx     $6604,y                         ; 81C8 BE 04 66                 ..f
        stx     $60BD                           ; 81CB 8E BD 60                 ..`
        beq     L81D7                           ; 81CE F0 07                    ..
        ldx     #$FF                            ; 81D0 A2 FF                    ..
        lda     L6933                           ; 81D2 AD 33 69                 .3i
        eor     #$FF                            ; 81D5 49 FF                    I.
L81D7:  clc                                     ; 81D7 18                       .
        adc     $6394,y                         ; 81D8 79 94 63                 y.c
        sta     $60CD                           ; 81DB 8D CD 60                 ..`
        txa                                     ; 81DE 8A                       .
        adc     $632C,y                         ; 81DF 79 2C 63                 y,c
        sta     $60CC                           ; 81E2 8D CC 60                 ..`
        jmp     L6F0C                           ; 81E5 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
        lda     $673C,y                         ; 81E8 B9 3C 67                 .<g
        beq     L820B                           ; 81EB F0 1E                    ..
        sec                                     ; 81ED 38                       8
        sbc     #$01                            ; 81EE E9 01                    ..
        sta     $673C,y                         ; 81F0 99 3C 67                 .<g
        bne     L820B                           ; 81F3 D0 16                    ..
        ldx     $66D4,y                         ; 81F5 BE D4 66                 ..f
        cpx     #$0A                            ; 81F8 E0 0A                    ..
        bcs     L8205                           ; 81FA B0 09                    ..
        cpx     #$05                            ; 81FC E0 05                    ..
        bcc     L8205                           ; 81FE 90 05                    ..
        lda     L84A1,x                         ; 8200 BD A1 84                 ...
        bne     L8208                           ; 8203 D0 03                    ..
L8205:  jmp     LAC0C                           ; 8205 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L8208:  sta     $62C4,y                         ; 8208 99 C4 62                 ..b
L820B:  rts                                     ; 820B 60                       `

; ----------------------------------------------------------------------------
L820C:  lda     #$03                            ; 820C A9 03                    ..
        sta     $673C,y                         ; 820E 99 3C 67                 .<g
        ldx     #$FF                            ; 8211 A2 FF                    ..
        lda     $6874,y                         ; 8213 B9 74 68                 .th
        bpl     L821A                           ; 8216 10 02                    ..
        ldx     #$01                            ; 8218 A2 01                    ..
L821A:  txa                                     ; 821A 8A                       .
        sta     $64CC,y                         ; 821B 99 CC 64                 ..d
        asl     a                               ; 821E 0A                       .
        sta     $60CF                           ; 821F 8D CF 60                 ..`
        lda     #$D9                            ; 8222 A9 D9                    ..
        sta     $60CE                           ; 8224 8D CE 60                 ..`
        lda     $6394,y                         ; 8227 B9 94 63                 ..c
        sta     $60CD                           ; 822A 8D CD 60                 ..`
        lda     $632C,y                         ; 822D B9 2C 63                 .,c
        sta     $60CC                           ; 8230 8D CC 60                 ..`
        lda     #$00                            ; 8233 A9 00                    ..
        sta     $60D0                           ; 8235 8D D0 60                 ..`
        sta     $60A8                           ; 8238 8D A8 60                 ..`
        lda     $6604,y                         ; 823B B9 04 66                 ..f
        sta     $60BD                           ; 823E 8D BD 60                 ..`
        lda     #$01                            ; 8241 A9 01                    ..
L8243:  sta     $60B3                           ; 8243 8D B3 60                 ..`
        lda     #$0B                            ; 8246 A9 0B                    ..
        sta     $60A7                           ; 8248 8D A7 60                 ..`
        jmp     L6F0C                           ; 824B 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L824E:  ldy     $60C3                           ; 824E AC C3 60                 ..`
        ldx     #$00                            ; 8251 A2 00                    ..
        jsr     L825A                           ; 8253 20 5A 82                  Z.
        bcs     L8287                           ; 8256 B0 2F                    ./
        ldx     #$01                            ; 8258 A2 01                    ..
L825A:  lda     $6104,x                         ; 825A BD 04 61                 ..a
        bne     L8286                           ; 825D D0 27                    .'
        lda     $6112,x                         ; 825F BD 12 61                 ..a
        tax                                     ; 8262 AA                       .
        lda     $63FC,x                         ; 8263 BD FC 63                 ..c
        cmp     #$DD                            ; 8266 C9 DD                    ..
        bne     L8286                           ; 8268 D0 1C                    ..
        stx     $6027                           ; 826A 8E 27 60                 .'`
        lda     $6394,x                         ; 826D BD 94 63                 ..c
        clc                                     ; 8270 18                       .
        adc     #$05                            ; 8271 69 05                    i.
        sta     L0060                           ; 8273 85 60                    .`
        lda     $632C,x                         ; 8275 BD 2C 63                 .,c
        adc     #$00                            ; 8278 69 00                    i.
        cmp     $632C,y                         ; 827A D9 2C 63                 .,c
        bne     L8286                           ; 827D D0 07                    ..
        lda     L0060                           ; 827F A5 60                    .`
        cmp     $6394,y                         ; 8281 D9 94 63                 ..c
        beq     L8287                           ; 8284 F0 01                    ..
L8286:  clc                                     ; 8286 18                       .
L8287:  rts                                     ; 8287 60                       `

; ----------------------------------------------------------------------------
        lda     $63FC,y                         ; 8288 B9 FC 63                 ..c
        cmp     #$DD                            ; 828B C9 DD                    ..
        bne     L82D0                           ; 828D D0 41                    .A
        lda     $67A4,y                         ; 828F B9 A4 67                 ..g
        bmi     L829C                           ; 8292 30 08                    0.
        lda     #$00                            ; 8294 A9 00                    ..
        sta     $680C,y                         ; 8296 99 0C 68                 ..h
        jmp     LAC0C                           ; 8299 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L829C:  lda     $6464,y                         ; 829C B9 64 64                 .dd
        bpl     L82BC                           ; 829F 10 1B                    ..
        lda     #$00                            ; 82A1 A9 00                    ..
        sta     $6874,y                         ; 82A3 99 74 68                 .th
        lda     #$0D                            ; 82A6 A9 0D                    ..
        sta     $6124,y                         ; 82A8 99 24 61                 .$a
        lda     $659C,y                         ; 82AB B9 9C 65                 ..e
        clc                                     ; 82AE 18                       .
        adc     #$02                            ; 82AF 69 02                    i.
        sta     $659C,y                         ; 82B1 99 9C 65                 ..e
        lda     #$00                            ; 82B4 A9 00                    ..
        sta     $67A4,y                         ; 82B6 99 A4 67                 ..g
        jmp     L7DF9                           ; 82B9 4C F9 7D                 L.}

; ----------------------------------------------------------------------------
L82BC:  lda     #$FF                            ; 82BC A9 FF                    ..
        sta     $6464,y                         ; 82BE 99 64 64                 .dd
        lda     $04                             ; 82C1 A5 04                    ..
        bne     L82CF                           ; 82C3 D0 0A                    ..
        lda     $6604,y                         ; 82C5 B9 04 66                 ..f
        beq     L82CF                           ; 82C8 F0 05                    ..
        lda     #$A4                            ; 82CA A9 A4                    ..
        sta     $62C4,y                         ; 82CC 99 C4 62                 ..b
L82CF:  rts                                     ; 82CF 60                       `

; ----------------------------------------------------------------------------
L82D0:  ldx     #$02                            ; 82D0 A2 02                    ..
        lda     $67A4,y                         ; 82D2 B9 A4 67                 ..g
        bmi     L82E5                           ; 82D5 30 0E                    0.
        beq     L82E3                           ; 82D7 F0 0A                    ..
        sec                                     ; 82D9 38                       8
        sbc     #$01                            ; 82DA E9 01                    ..
        bne     L82E0                           ; 82DC D0 02                    ..
        lda     #$FF                            ; 82DE A9 FF                    ..
L82E0:  sta     $67A4,y                         ; 82E0 99 A4 67                 ..g
L82E3:  ldx     #$04                            ; 82E3 A2 04                    ..
L82E5:  txa                                     ; 82E5 8A                       .
        clc                                     ; 82E6 18                       .
        adc     $63FC,y                         ; 82E7 79 FC 63                 y.c
        cmp     #$DC                            ; 82EA C9 DC                    ..
        bcc     L82F0                           ; 82EC 90 02                    ..
        lda     #$DD                            ; 82EE A9 DD                    ..
L82F0:  sta     $63FC,y                         ; 82F0 99 FC 63                 ..c
        lda     #$5D                            ; 82F3 A9 5D                    .]
        ldx     $67A4,y                         ; 82F5 BE A4 67                 ..g
        bpl     L8317                           ; 82F8 10 1D                    ..
        ldx     $6604,y                         ; 82FA BE 04 66                 ..f
        beq     L8314                           ; 82FD F0 15                    ..
        eor     $60C1                           ; 82FF 4D C1 60                 M.`
        eor     $60C3                           ; 8302 4D C3 60                 M.`
        and     #$01                            ; 8305 29 01                    ).
        clc                                     ; 8307 18                       .
        adc     $6464,y                         ; 8308 79 64 64                 ydd
        and     #$03                            ; 830B 29 03                    ).
        sta     $6464,y                         ; 830D 99 64 64                 .dd
        tax                                     ; 8310 AA                       .
        lda     L84EE,x                         ; 8311 BD EE 84                 ...
L8314:  sta     $62C4,y                         ; 8314 99 C4 62                 ..b
L8317:  rts                                     ; 8317 60                       `

; ----------------------------------------------------------------------------
        ldx     $60C3                           ; 8318 AE C3 60                 ..`
        lda     $673C,x                         ; 831B BD 3C 67                 .<g
        bne     L8323                           ; 831E D0 03                    ..
        jmp     LAC0C                           ; 8320 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L8323:  dec     $673C,x                         ; 8323 DE 3C 67                 .<g
        rts                                     ; 8326 60                       `

; ----------------------------------------------------------------------------
L8327:  lda     $6604,y                         ; 8327 B9 04 66                 ..f
        eor     #$01                            ; 832A 49 01                    I.
        tax                                     ; 832C AA                       .
        lda     $6104,x                         ; 832D BD 04 61                 ..a
        bne     L8360                           ; 8330 D0 2E                    ..
        lda     $6112,x                         ; 8332 BD 12 61                 ..a
        tax                                     ; 8335 AA                       .
        lda     $6394,y                         ; 8336 B9 94 63                 ..c
        sec                                     ; 8339 38                       8
        sbc     $6394,x                         ; 833A FD 94 63                 ..c
        sta     L0060                           ; 833D 85 60                    .`
        lda     $632C,y                         ; 833F B9 2C 63                 .,c
        sbc     $632C,x                         ; 8342 FD 2C 63                 .,c
        bcs     L8356                           ; 8345 B0 0F                    ..
        lda     $6394,x                         ; 8347 BD 94 63                 ..c
        sec                                     ; 834A 38                       8
        sbc     $6394,y                         ; 834B F9 94 63                 ..c
        sta     L0060                           ; 834E 85 60                    .`
        lda     $632C,x                         ; 8350 BD 2C 63                 .,c
        sbc     $632C,y                         ; 8353 F9 2C 63                 .,c
L8356:  bne     L8360                           ; 8356 D0 08                    ..
        lda     L0060                           ; 8358 A5 60                    .`
        cmp     #$60                            ; 835A C9 60                    .`
        bcs     L8360                           ; 835C B0 02                    ..
        sec                                     ; 835E 38                       8
        rts                                     ; 835F 60                       `

; ----------------------------------------------------------------------------
L8360:  clc                                     ; 8360 18                       .
        rts                                     ; 8361 60                       `

; ----------------------------------------------------------------------------
L8362:  ldx     $6604,y                         ; 8362 BE 04 66                 ..f
        stx     $60BD                           ; 8365 8E BD 60                 ..`
        lda     $6394,y                         ; 8368 B9 94 63                 ..c
        clc                                     ; 836B 18                       .
        adc     L84F2,x                         ; 836C 7D F2 84                 }..
        sta     $60CD                           ; 836F 8D CD 60                 ..`
        lda     $632C,y                         ; 8372 B9 2C 63                 .,c
        adc     L84F4,x                         ; 8375 7D F4 84                 }..
        sta     $60CC                           ; 8378 8D CC 60                 ..`
        tya                                     ; 837B 98                       .
        tax                                     ; 837C AA                       .
        lda     $60BD                           ; 837D AD BD 60                 ..`
        bne     L83AD                           ; 8380 D0 2B                    .+
L8382:  lda     $625C,x                         ; 8382 BD 5C 62                 .\b
        bmi     L83EF                           ; 8385 30 68                    0h
        tax                                     ; 8387 AA                       .
        lda     $632C,x                         ; 8388 BD 2C 63                 .,c
        cmp     $60CC                           ; 838B CD CC 60                 ..`
        bcc     L839C                           ; 838E 90 0C                    ..
        bne     L83EF                           ; 8390 D0 5D                    .]
        lda     $6394,x                         ; 8392 BD 94 63                 ..c
        cmp     $60CD                           ; 8395 CD CD 60                 ..`
        bcc     L839C                           ; 8398 90 02                    ..
        bne     L83EF                           ; 839A D0 53                    .S
L839C:  lda     $6604,x                         ; 839C BD 04 66                 ..f
        cmp     $60BD                           ; 839F CD BD 60                 ..`
        beq     L8382                           ; 83A2 F0 DE                    ..
        lda     $6124,x                         ; 83A4 BD 24 61                 .$a
        cmp     #$0E                            ; 83A7 C9 0E                    ..
        bne     L8382                           ; 83A9 D0 D7                    ..
        sec                                     ; 83AB 38                       8
        rts                                     ; 83AC 60                       `

; ----------------------------------------------------------------------------
L83AD:  lda     $61F4,x                         ; 83AD BD F4 61                 ..a
        bmi     L83EF                           ; 83B0 30 3D                    0=
        tax                                     ; 83B2 AA                       .
        lda     $60CC                           ; 83B3 AD CC 60                 ..`
        cmp     $632C,x                         ; 83B6 DD 2C 63                 .,c
        bcc     L83C7                           ; 83B9 90 0C                    ..
        bne     L83EF                           ; 83BB D0 32                    .2
        lda     $60CD                           ; 83BD AD CD 60                 ..`
        cmp     $6394,x                         ; 83C0 DD 94 63                 ..c
        bcc     L83C7                           ; 83C3 90 02                    ..
        bne     L83EF                           ; 83C5 D0 28                    .(
L83C7:  lda     $6604,x                         ; 83C7 BD 04 66                 ..f
        cmp     $60BD                           ; 83CA CD BD 60                 ..`
        beq     L83AD                           ; 83CD F0 DE                    ..
        lda     $6124,x                         ; 83CF BD 24 61                 .$a
        cmp     #$0E                            ; 83D2 C9 0E                    ..
        bne     L83AD                           ; 83D4 D0 D7                    ..
        sec                                     ; 83D6 38                       8
        rts                                     ; 83D7 60                       `

; ----------------------------------------------------------------------------
L83D8:  lda     $6394,y                         ; 83D8 B9 94 63                 ..c
        sec                                     ; 83DB 38                       8
        sbc     #$02                            ; 83DC E9 02                    ..
        sta     $60CD                           ; 83DE 8D CD 60                 ..`
        and     #$03                            ; 83E1 29 03                    ).
        beq     L83F1                           ; 83E3 F0 0C                    ..
        lda     $6464,y                         ; 83E5 B9 64 64                 .dd
        beq     L83EF                           ; 83E8 F0 05                    ..
        lda     #$00                            ; 83EA A9 00                    ..
        sta     $67A4,y                         ; 83EC 99 A4 67                 ..g
L83EF:  clc                                     ; 83EF 18                       .
        rts                                     ; 83F0 60                       `

; ----------------------------------------------------------------------------
L83F1:  lda     $632C,y                         ; 83F1 B9 2C 63                 .,c
        sbc     #$00                            ; 83F4 E9 00                    ..
        sta     $60CC                           ; 83F6 8D CC 60                 ..`
        ldx     #$67                            ; 83F9 A2 67                    .g
L83FB:  lda     #$11                            ; 83FB A9 11                    ..
L83FD:  cmp     $6124,x                         ; 83FD DD 24 61                 .$a
        beq     L840C                           ; 8400 F0 0A                    ..
        dex                                     ; 8402 CA                       .
        bpl     L83FD                           ; 8403 10 F8                    ..
        clc                                     ; 8405 18                       .
        rts                                     ; 8406 60                       `

; ----------------------------------------------------------------------------
L8407:  dex                                     ; 8407 CA                       .
        bpl     L83FB                           ; 8408 10 F1                    ..
        clc                                     ; 840A 18                       .
        rts                                     ; 840B 60                       `

; ----------------------------------------------------------------------------
L840C:  lda     #$09                            ; 840C A9 09                    ..
        cmp     $66D4,x                         ; 840E DD D4 66                 ..f
        bne     L8407                           ; 8411 D0 F4                    ..
        lda     $6394,x                         ; 8413 BD 94 63                 ..c
        cmp     $60CD                           ; 8416 CD CD 60                 ..`
        bne     L8407                           ; 8419 D0 EC                    ..
        lda     $632C,x                         ; 841B BD 2C 63                 .,c
        cmp     $60CC                           ; 841E CD CC 60                 ..`
        bne     L8407                           ; 8421 D0 E4                    ..
        lda     $60C1                           ; 8423 AD C1 60                 ..`
        lsr     a                               ; 8426 4A                       J
        bcs     L8430                           ; 8427 B0 07                    ..
        lda     #$03                            ; 8429 A9 03                    ..
        sta     $67A4,x                         ; 842B 9D A4 67                 ..g
        sec                                     ; 842E 38                       8
        rts                                     ; 842F 60                       `

; ----------------------------------------------------------------------------
L8430:  lda     #$01                            ; 8430 A9 01                    ..
        sta     $6464,y                         ; 8432 99 64 64                 .dd
        dec     $67A4,x                         ; 8435 DE A4 67                 ..g
        bne     L8467                           ; 8438 D0 2D                    .-
        lda     $60C3                           ; 843A AD C3 60                 ..`
        pha                                     ; 843D 48                       H
        stx     $60C3                           ; 843E 8E C3 60                 ..`
        lda     #$FF                            ; 8441 A9 FF                    ..
        sta     $680C,x                         ; 8443 9D 0C 68                 ..h
        lda     $6464,x                         ; 8446 BD 64 64                 .dd
        pha                                     ; 8449 48                       H
        jsr     LAC0C                           ; 844A 20 0C AC                  ..
        pla                                     ; 844D 68                       h
        sta     $60E3                           ; 844E 8D E3 60                 ..`
        pla                                     ; 8451 68                       h
        sta     $60C3                           ; 8452 8D C3 60                 ..`
        tay                                     ; 8455 A8                       .
        lda     #$09                            ; 8456 A9 09                    ..
        sta     $60A7                           ; 8458 8D A7 60                 ..`
        lda     $6604,y                         ; 845B B9 04 66                 ..f
        sta     $60BD                           ; 845E 8D BD 60                 ..`
        jsr     L6F0C                           ; 8461 20 0C 6F                  .o
        ldy     $60C3                           ; 8464 AC C3 60                 ..`
L8467:  sec                                     ; 8467 38                       8
L8468:  rts                                     ; 8468 60                       `

; ----------------------------------------------------------------------------
        .byte   $4F                             ; 8469 4F                       O
        .byte   $7B                             ; 846A 7B                       {
        ora     #$8F                            ; 846B 09 8F                    ..
        .byte   $0C                             ; 846D 0C                       .
        sta     $0C                             ; 846E 85 0C                    ..
        sta     $0C                             ; 8470 85 0C                    ..
        sta     $50                             ; 8472 85 50                    .P
        .byte   $7B                             ; 8474 7B                       {
        .byte   $C3                             ; 8475 C3                       .
        .byte   $7B                             ; 8476 7B                       {
        .byte   $3A                             ; 8477 3A                       :
        .byte   $7C                             ; 8478 7C                       |
        .byte   $5F                             ; 8479 5F                       _
        adc     L850C,x                         ; 847A 7D 0C 85                 }..
        .byte   $0C                             ; 847D 0C                       .
        sta     $0C                             ; 847E 85 0C                    ..
        sta     $F9                             ; 8480 85 F9                    ..
        adc     L7F1A,x                         ; 8482 7D 1A 7F                 }..
        ror     $7F,x                           ; 8485 76 7F                    v.
        .byte   $27                             ; 8487 27                       '
        .byte   $80                             ; 8488 80                       .
        inx                                     ; 8489 E8                       .
        sta     ($0C,x)                         ; 848A 81 0C                    ..
        sta     $0C                             ; 848C 85 0C                    ..
        sta     $0C                             ; 848E 85 0C                    ..
        sta     $0C                             ; 8490 85 0C                    ..
        sta     $0C                             ; 8492 85 0C                    ..
        sta     $0C                             ; 8494 85 0C                    ..
        sta     $0C                             ; 8496 85 0C                    ..
        sta     $88                             ; 8498 85 88                    ..
        .byte   $82                             ; 849A 82                       .
        .byte   $0C                             ; 849B 0C                       .
        sta     $0C                             ; 849C 85 0C                    ..
        sta     $18                             ; 849E 85 18                    ..
        .byte   $83                             ; 84A0 83                       .
L84A1:  .byte   $0C                             ; 84A1 0C                       .
        .byte   $85                             ; 84A2 85                       .
L84A3:  .byte   $01                             ; 84A3 01                       .
L84A4:  .byte   $FF                             ; 84A4 FF                       .
        ora     ($93,x)                         ; 84A5 01 93                    ..
        sec                                     ; 84A7 38                       8
        brk                                     ; 84A8 00                       .
        brk                                     ; 84A9 00                       .
        and     $0200,y                         ; 84AA 39 00 02                 9..
        .byte   $03                             ; 84AD 03                       .
        .byte   $03                             ; 84AE 03                       .
        .byte   $04                             ; 84AF 04                       .
        .byte   $03                             ; 84B0 03                       .
        .byte   $03                             ; 84B1 03                       .
        .byte   $02                             ; 84B2 02                       .
        brk                                     ; 84B3 00                       .
        inc     $FDFD,x                         ; 84B4 FE FD FD                 ...
        .byte   $FC                             ; 84B7 FC                       .
        sbc     $FEFE,x                         ; 84B8 FD FE FE                 ...
        sed                                     ; 84BB F8                       .
        .byte   $FA                             ; 84BC FA                       .
        sbc     a:$FF,x                         ; 84BD FD FF 00                 ...
        ora     ($03,x)                         ; 84C0 01 03                    ..
        asl     $08                             ; 84C2 06 08                    ..
        asl     $03                             ; 84C4 06 03                    ..
        ora     (L0000,x)                       ; 84C6 01 00                    ..
        .byte   $FF                             ; 84C8 FF                       .
        sbc     a:$FA,x                         ; 84C9 FD FA 00                 ...
        .byte   $80                             ; 84CC 80                       .
        ora     ($01,x)                         ; 84CD 01 01                    ..
        ora     ($01,x)                         ; 84CF 01 01                    ..
        ora     ($01,x)                         ; 84D1 01 01                    ..
        .byte   $80                             ; 84D3 80                       .
        ora     ($01,x)                         ; 84D4 01 01                    ..
        ora     (L0080,x)                       ; 84D6 01 80                    ..
        .byte   $80                             ; 84D8 80                       .
        .byte   $80                             ; 84D9 80                       .
        .byte   $80                             ; 84DA 80                       .
        ora     (L0080,x)                       ; 84DB 01 80                    ..
        ora     ($01,x)                         ; 84DD 01 01                    ..
        ora     ($01,x)                         ; 84DF 01 01                    ..
        ora     ($01,x)                         ; 84E1 01 01                    ..
        ora     ($01,x)                         ; 84E3 01 01                    ..
        ora     ($01,x)                         ; 84E5 01 01                    ..
        .byte   $02                             ; 84E7 02                       .
        .byte   $03                             ; 84E8 03                       .
        asl     $07                             ; 84E9 06 07                    ..
        sbc     ($94),y                         ; 84EB F1 94                    ..
        .byte   $95                             ; 84ED 95                       .
L84EE:  lsr     $5EA2,x                         ; 84EE 5E A2 5E                 ^.^
        .byte   $A3                             ; 84F1 A3                       .
L84F2:  rts                                     ; 84F2 60                       `

; ----------------------------------------------------------------------------
        .byte   $C4                             ; 84F3 C4                       .
L84F4:  brk                                     ; 84F4 00                       .
        .byte   $FF                             ; 84F5 FF                       .
L84F6:  ora     ($FF,x)                         ; 84F6 01 FF                    ..
        ldy     $78,x                           ; 84F8 B4 78                    .x
        .byte   $54                             ; 84FA 54                       T
        pha                                     ; 84FB 48                       H
        .byte   $3C                             ; 84FC 3C                       <
        bmi     L8517                           ; 84FD 30 18                    0.
        brk                                     ; 84FF 00                       .
L8500:  jmp     L850F                           ; 8500 4C 0F 85                 L..

; ----------------------------------------------------------------------------
L8503:  jmp     L8559                           ; 8503 4C 59 85                 LY.

; ----------------------------------------------------------------------------
L8506:  jmp     L8518                           ; 8506 4C 18 85                 L..

; ----------------------------------------------------------------------------
L8509:  jmp     L8889                           ; 8509 4C 89 88                 L..

; ----------------------------------------------------------------------------
L850C:  jmp     L855E                           ; 850C 4C 5E 85                 L^.

; ----------------------------------------------------------------------------
L850F:  lda     #$05                            ; 850F A9 05                    ..
        sta     $6033                           ; 8511 8D 33 60                 .3`
        sta     $6034                           ; 8514 8D 34 60                 .4`
L8517:  rts                                     ; 8517 60                       `

; ----------------------------------------------------------------------------
L8518:  lda     #$57                            ; 8518 A9 57                    .W
        sta     $BFEC                           ; 851A 8D EC BF                 ...
        lda     #$07                            ; 851D A9 07                    ..
        sta     $BFEB                           ; 851F 8D EB BF                 ...
        lda     #$1E                            ; 8522 A9 1E                    ..
        sta     $BFEA                           ; 8524 8D EA BF                 ...
        lda     #$03                            ; 8527 A9 03                    ..
        sta     $BFED                           ; 8529 8D ED BF                 ...
L852C:  jsr     L6909                           ; 852C 20 09 69                  .i
        dec     $BFEC                           ; 852F CE EC BF                 ...
        dec     $BFEB                           ; 8532 CE EB BF                 ...
        bpl     L852C                           ; 8535 10 F5                    ..
        ldx     #$04                            ; 8537 A2 04                    ..
        ldy     #$00                            ; 8539 A0 00                    ..
        sty     L0060                           ; 853B 84 60                    .`
        sty     $62                             ; 853D 84 62                    .b
        lda     #$57                            ; 853F A9 57                    .W
        sta     $61                             ; 8541 85 61                    .a
        lda     #$53                            ; 8543 A9 53                    .S
        sta     $63                             ; 8545 85 63                    .c
L8547:  lda     #$31                            ; 8547 A9 31                    .1
        eor     (L0060),y                       ; 8549 51 60                    Q`
        eor     ($62),y                         ; 854B 51 62                    Qb
        bne     L855A                           ; 854D D0 0B                    ..
        iny                                     ; 854F C8                       .
        bne     L8547                           ; 8550 D0 F5                    ..
        dec     $61                             ; 8552 C6 61                    .a
        dec     $63                             ; 8554 C6 63                    .c
        dex                                     ; 8556 CA                       .
        bne     L8547                           ; 8557 D0 EE                    ..
L8559:  rts                                     ; 8559 60                       `

; ----------------------------------------------------------------------------
L855A:  sta     $60AC                           ; 855A 8D AC 60                 ..`
        rts                                     ; 855D 60                       `

; ----------------------------------------------------------------------------
L855E:  lda     L8E19,x                         ; 855E BD 19 8E                 ...
        sta     L0060                           ; 8561 85 60                    .`
        lda     L8E1A,x                         ; 8563 BD 1A 8E                 ...
        sta     $61                             ; 8566 85 61                    .a
        jmp     (L0060)                         ; 8568 6C 60 00                 l`.

; ----------------------------------------------------------------------------
L856B:  cmp     #$00                            ; 856B C9 00                    ..
        beq     L8576                           ; 856D F0 07                    ..
        bpl     L8574                           ; 856F 10 03                    ..
L8571:  lda     #$FF                            ; 8571 A9 FF                    ..
        rts                                     ; 8573 60                       `

; ----------------------------------------------------------------------------
L8574:  lda     #$01                            ; 8574 A9 01                    ..
L8576:  rts                                     ; 8576 60                       `

; ----------------------------------------------------------------------------
L8577:  lda     $632C,x                         ; 8577 BD 2C 63                 .,c
        cmp     $632C,y                         ; 857A D9 2C 63                 .,c
        bcc     L8571                           ; 857D 90 F2                    ..
        bne     L8574                           ; 857F D0 F3                    ..
        lda     $6394,x                         ; 8581 BD 94 63                 ..c
        cmp     $6394,y                         ; 8584 D9 94 63                 ..c
        bcc     L8571                           ; 8587 90 E8                    ..
        bne     L8574                           ; 8589 D0 E9                    ..
        lda     #$00                            ; 858B A9 00                    ..
        rts                                     ; 858D 60                       `

; ----------------------------------------------------------------------------
        ldx     $6604,y                         ; 858E BE 04 66                 ..f
        lda     $6104,x                         ; 8591 BD 04 61                 ..a
        bne     L85E2                           ; 8594 D0 4C                    .L
        lda     $6112,x                         ; 8596 BD 12 61                 ..a
        tax                                     ; 8599 AA                       .
        lda     $6874,x                         ; 859A BD 74 68                 .th
        beq     L85E2                           ; 859D F0 43                    .C
        lda     $632C,x                         ; 859F BD 2C 63                 .,c
        sta     $632C,y                         ; 85A2 99 2C 63                 .,c
        lda     $6394,x                         ; 85A5 BD 94 63                 ..c
        sta     $11                             ; 85A8 85 11                    ..
        lda     $63FC,x                         ; 85AA BD FC 63                 ..c
        sta     $12                             ; 85AD 85 12                    ..
        lda     $62C4,x                         ; 85AF BD C4 62                 ..b
        cmp     #$97                            ; 85B2 C9 97                    ..
        bcc     L85B9                           ; 85B4 90 03                    ..
        sbc     #$97                            ; 85B6 E9 97                    ..
        clc                                     ; 85B8 18                       .
L85B9:  tax                                     ; 85B9 AA                       .
        lda     $60C1                           ; 85BA AD C1 60                 ..`
        lsr     a                               ; 85BD 4A                       J
        lda     L8E5E,x                         ; 85BE BD 5E 8E                 .^.
        adc     #$09                            ; 85C1 69 09                    i.
        pha                                     ; 85C3 48                       H
        lda     $12                             ; 85C4 A5 12                    ..
        clc                                     ; 85C6 18                       .
        adc     #$F6                            ; 85C7 69 F6                    i.
        sta     $63FC,y                         ; 85C9 99 FC 63                 ..c
        lda     $11                             ; 85CC A5 11                    ..
        clc                                     ; 85CE 18                       .
        adc     L8E55,x                         ; 85CF 7D 55 8E                 }U.
        sta     $6394,y                         ; 85D2 99 94 63                 ..c
        lda     $632C,y                         ; 85D5 B9 2C 63                 .,c
        adc     #$00                            ; 85D8 69 00                    i.
        sta     $632C,y                         ; 85DA 99 2C 63                 .,c
        pla                                     ; 85DD 68                       h
L85DE:  sta     $62C4,y                         ; 85DE 99 C4 62                 ..b
L85E1:  rts                                     ; 85E1 60                       `

; ----------------------------------------------------------------------------
L85E2:  lda     #$FF                            ; 85E2 A9 FF                    ..
        bmi     L85DE                           ; 85E4 30 F8                    0.
        lda     $60C1                           ; 85E6 AD C1 60                 ..`
        and     #$01                            ; 85E9 29 01                    ).
        clc                                     ; 85EB 18                       .
        adc     #$36                            ; 85EC 69 36                    i6
        bcc     L85DE                           ; 85EE 90 EE                    ..
        lda     $67A4,y                         ; 85F0 B9 A4 67                 ..g
        beq     L85FD                           ; 85F3 F0 08                    ..
        sec                                     ; 85F5 38                       8
        sbc     #$01                            ; 85F6 E9 01                    ..
        sta     $67A4,y                         ; 85F8 99 A4 67                 ..g
        bne     L8622                           ; 85FB D0 25                    .%
L85FD:  lda     $60C1                           ; 85FD AD C1 60                 ..`
        eor     $6604,y                         ; 8600 59 04 66                 Y.f
        and     #$0F                            ; 8603 29 0F                    ).
        beq     L860C                           ; 8605 F0 05                    ..
        lda     $66D4,y                         ; 8607 B9 D4 66                 ..f
        bpl     L8614                           ; 860A 10 08                    ..
L860C:  jsr     L8623                           ; 860C 20 23 86                  #.
        bcc     L8622                           ; 860F 90 11                    ..
        jmp     L8C6D                           ; 8611 4C 6D 8C                 Lm.

; ----------------------------------------------------------------------------
L8614:  tax                                     ; 8614 AA                       .
        lda     $673C,y                         ; 8615 B9 3C 67                 .<g
        cmp     $6124,x                         ; 8618 DD 24 61                 .$a
        beq     L85E1                           ; 861B F0 C4                    ..
        lda     #$FF                            ; 861D A9 FF                    ..
        sta     $66D4,y                         ; 861F 99 D4 66                 ..f
L8622:  rts                                     ; 8622 60                       `

; ----------------------------------------------------------------------------
L8623:  ldx     $60C3                           ; 8623 AE C3 60                 ..`
        ldy     $6604,x                         ; 8626 BC 04 66                 ..f
        sty     $60BD                           ; 8629 8C BD 60                 ..`
        ldx     $60DF,y                         ; 862C BE DF 60                 ..`
        dey                                     ; 862F 88                       .
        sty     L0060                           ; 8630 84 60                    .`
L8632:  bit     L0060                           ; 8632 24 60                    $`
        bpl     L863D                           ; 8634 10 07                    ..
        lda     $625C,x                         ; 8636 BD 5C 62                 .\b
        bpl     L864C                           ; 8639 10 11                    ..
L863B:  clc                                     ; 863B 18                       .
        rts                                     ; 863C 60                       `

; ----------------------------------------------------------------------------
L863D:  lda     $61F4,x                         ; 863D BD F4 61                 ..a
        bmi     L863B                           ; 8640 30 F9                    0.
        tax                                     ; 8642 AA                       .
        lda     $632C,x                         ; 8643 BD 2C 63                 .,c
        cmp     #$0D                            ; 8646 C9 0D                    ..
        beq     L8654                           ; 8648 F0 0A                    ..
        clc                                     ; 864A 18                       .
        rts                                     ; 864B 60                       `

; ----------------------------------------------------------------------------
L864C:  tax                                     ; 864C AA                       .
        lda     $632C,x                         ; 864D BD 2C 63                 .,c
        cmp     #$02                            ; 8650 C9 02                    ..
        bne     L863B                           ; 8652 D0 E7                    ..
L8654:  lda     $6604,x                         ; 8654 BD 04 66                 ..f
        cmp     $60BD                           ; 8657 CD BD 60                 ..`
        beq     L8632                           ; 865A F0 D6                    ..
        lda     $6124,x                         ; 865C BD 24 61                 .$a
        cmp     #$02                            ; 865F C9 02                    ..
        bne     L8632                           ; 8661 D0 CF                    ..
        sta     $60A7                           ; 8663 8D A7 60                 ..`
        ldy     $6604,x                         ; 8666 BC 04 66                 ..f
        lda     $6104,y                         ; 8669 B9 04 61                 ..a
        bne     L8632                           ; 866C D0 C4                    ..
        sec                                     ; 866E 38                       8
        rts                                     ; 866F 60                       `

; ----------------------------------------------------------------------------
        .byte   $B9                             ; 8670 B9                       .
        .byte   $64                             ; 8671 64                       d
L8672:  .byte   $64                             ; 8672 64                       d
        beq     L867B                           ; 8673 F0 06                    ..
        ldx     $60C3                           ; 8675 AE C3 60                 ..`
        dec     $6464,x                         ; 8678 DE 64 64                 .dd
L867B:  ldx     $66D4,y                         ; 867B BE D4 66                 ..f
        bmi     L86AD                           ; 867E 30 2D                    0-
        lda     $673C,y                         ; 8680 B9 3C 67                 .<g
        cmp     $6124,x                         ; 8683 DD 24 61                 .$a
        beq     L8694                           ; 8686 F0 0C                    ..
L8688:  lda     #$FF                            ; 8688 A9 FF                    ..
        sta     $66D4,y                         ; 868A 99 D4 66                 ..f
        lda     #$00                            ; 868D A9 00                    ..
        sta     $67A4,y                         ; 868F 99 A4 67                 ..g
        beq     L86C1                           ; 8692 F0 2D                    .-
L8694:  cmp     #$02                            ; 8694 C9 02                    ..
        bne     L86AD                           ; 8696 D0 15                    ..
        lda     $6604,x                         ; 8698 BD 04 66                 ..f
        tax                                     ; 869B AA                       .
        lda     $6104,x                         ; 869C BD 04 61                 ..a
        bne     L8688                           ; 869F D0 E7                    ..
        lda     $6114,x                         ; 86A1 BD 14 61                 ..a
        bpl     L86AA                           ; 86A4 10 04                    ..
        tya                                     ; 86A6 98                       .
        sta     $6114,x                         ; 86A7 9D 14 61                 ..a
L86AA:  ldx     $66D4,y                         ; 86AA BE D4 66                 ..f
L86AD:  lda     $63FC,y                         ; 86AD B9 FC 63                 ..c
        cmp     #$DD                            ; 86B0 C9 DD                    ..
        bne     L86BC                           ; 86B2 D0 08                    ..
        lda     #$00                            ; 86B4 A9 00                    ..
        sta     $680C,y                         ; 86B6 99 0C 68                 ..h
        jmp     LAC0C                           ; 86B9 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L86BC:  lda     $66D4,y                         ; 86BC B9 D4 66                 ..f
        bpl     L86DA                           ; 86BF 10 19                    ..
L86C1:  lda     $6534,y                         ; 86C1 B9 34 65                 .4e
        clc                                     ; 86C4 18                       .
        adc     #$02                            ; 86C5 69 02                    i.
        sta     $6534,y                         ; 86C7 99 34 65                 .4e
        clc                                     ; 86CA 18                       .
        adc     $63FC,y                         ; 86CB 79 FC 63                 y.c
        cmp     #$DD                            ; 86CE C9 DD                    ..
        bcc     L86D4                           ; 86D0 90 02                    ..
        lda     #$DD                            ; 86D2 A9 DD                    ..
L86D4:  sta     $63FC,y                         ; 86D4 99 FC 63                 ..c
        jmp     L7A12                           ; 86D7 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
L86DA:  lda     $67A4,y                         ; 86DA B9 A4 67                 ..g
        sec                                     ; 86DD 38                       8
        sbc     #$01                            ; 86DE E9 01                    ..
        beq     L8688                           ; 86E0 F0 A6                    ..
        sta     $67A4,y                         ; 86E2 99 A4 67                 ..g
        jsr     L8577                           ; 86E5 20 77 85                  w.
        sta     L0060                           ; 86E8 85 60                    .`
        ldx     $673C,y                         ; 86EA BE 3C 67                 .<g
        lda     L6935,x                         ; 86ED BD 35 69                 .5i
        lsr     a                               ; 86F0 4A                       J
        sta     $61                             ; 86F1 85 61                    .a
        ldx     $66D4,y                         ; 86F3 BE D4 66                 ..f
        lda     $63FC,x                         ; 86F6 BD FC 63                 ..c
        sec                                     ; 86F9 38                       8
        sbc     $61                             ; 86FA E5 61                    .a
        cmp     $63FC,y                         ; 86FC D9 FC 63                 ..c
        bcs     L870D                           ; 86FF B0 0C                    ..
        ldx     #$FF                            ; 8701 A2 FF                    ..
        sta     $62                             ; 8703 85 62                    .b
        lda     $63FC,y                         ; 8705 B9 FC 63                 ..c
        sec                                     ; 8708 38                       8
        sbc     $62                             ; 8709 E5 62                    .b
        bne     L8712                           ; 870B D0 05                    ..
L870D:  sec                                     ; 870D 38                       8
        sbc     $63FC,y                         ; 870E F9 FC 63                 ..c
        tax                                     ; 8711 AA                       .
L8712:  stx     $62                             ; 8712 86 62                    .b
        ldx     #$00                            ; 8714 A2 00                    ..
        cmp     #$00                            ; 8716 C9 00                    ..
        beq     L8725                           ; 8718 F0 0B                    ..
        inx                                     ; 871A E8                       .
        cmp     #$04                            ; 871B C9 04                    ..
        bcc     L8725                           ; 871D 90 06                    ..
        inx                                     ; 871F E8                       .
        cmp     #$08                            ; 8720 C9 08                    ..
        bcc     L8725                           ; 8722 90 01                    ..
        inx                                     ; 8724 E8                       .
L8725:  stx     $61                             ; 8725 86 61                    .a
        lda     L0060                           ; 8727 A5 60                    .`
        bmi     L874C                           ; 8729 30 21                    0!
        beq     L8741                           ; 872B F0 14                    ..
        lda     $62                             ; 872D A5 62                    .b
        bpl     L8739                           ; 872F 10 08                    ..
        lda     #$04                            ; 8731 A9 04                    ..
        sec                                     ; 8733 38                       8
        sbc     $61                             ; 8734 E5 61                    .a
        jmp     L875D                           ; 8736 4C 5D 87                 L].

; ----------------------------------------------------------------------------
L8739:  lda     #$04                            ; 8739 A9 04                    ..
        clc                                     ; 873B 18                       .
        adc     $61                             ; 873C 65 61                    ea
        jmp     L875D                           ; 873E 4C 5D 87                 L].

; ----------------------------------------------------------------------------
L8741:  lda     $61                             ; 8741 A5 61                    .a
        asl     a                               ; 8743 0A                       .
        lda     #$00                            ; 8744 A9 00                    ..
        bcs     L875D                           ; 8746 B0 15                    ..
        lda     #$08                            ; 8748 A9 08                    ..
        bne     L875D                           ; 874A D0 11                    ..
L874C:  lda     $62                             ; 874C A5 62                    .b
        bmi     L8758                           ; 874E 30 08                    0.
        lda     #$0C                            ; 8750 A9 0C                    ..
        sec                                     ; 8752 38                       8
        sbc     $61                             ; 8753 E5 61                    .a
        jmp     L875D                           ; 8755 4C 5D 87                 L].

; ----------------------------------------------------------------------------
L8758:  lda     #$0C                            ; 8758 A9 0C                    ..
        clc                                     ; 875A 18                       .
        adc     $61                             ; 875B 65 61                    ea
L875D:  sta     $61                             ; 875D 85 61                    .a
        lda     $62C4,y                         ; 875F B9 C4 62                 ..b
        sec                                     ; 8762 38                       8
        sbc     #$63                            ; 8763 E9 63                    .c
        sta     L0060                           ; 8765 85 60                    .`
        ldx     #$00                            ; 8767 A2 00                    ..
        cmp     $61                             ; 8769 C5 61                    .a
        beq     L8785                           ; 876B F0 18                    ..
        inx                                     ; 876D E8                       .
        bcs     L877A                           ; 876E B0 0A                    ..
        adc     #$08                            ; 8770 69 08                    i.
        cmp     $61                             ; 8772 C5 61                    .a
        bcs     L8785                           ; 8774 B0 0F                    ..
        ldx     #$FF                            ; 8776 A2 FF                    ..
        bmi     L8785                           ; 8778 30 0B                    0.
L877A:  lda     $61                             ; 877A A5 61                    .a
        clc                                     ; 877C 18                       .
        adc     #$08                            ; 877D 69 08                    i.
        cmp     L0060                           ; 877F C5 60                    .`
        bcc     L8785                           ; 8781 90 02                    ..
        ldx     #$FF                            ; 8783 A2 FF                    ..
L8785:  txa                                     ; 8785 8A                       .
        clc                                     ; 8786 18                       .
        adc     L0060                           ; 8787 65 60                    e`
        and     #$0F                            ; 8789 29 0F                    ).
        tax                                     ; 878B AA                       .
        clc                                     ; 878C 18                       .
        adc     #$63                            ; 878D 69 63                    ic
        sta     $62C4,y                         ; 878F 99 C4 62                 ..b
        cpx     $61                             ; 8792 E4 61                    .a
        beq     L8799                           ; 8794 F0 03                    ..
        jmp     L7A12                           ; 8796 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
L8799:  txa                                     ; 8799 8A                       .
        pha                                     ; 879A 48                       H
        lda     $63FC,y                         ; 879B B9 FC 63                 ..c
        sta     $60CE                           ; 879E 8D CE 60                 ..`
        lda     $632C,y                         ; 87A1 B9 2C 63                 .,c
        sta     $60CC                           ; 87A4 8D CC 60                 ..`
        lda     $6394,y                         ; 87A7 B9 94 63                 ..c
        sta     $60CD                           ; 87AA 8D CD 60                 ..`
        lda     #$03                            ; 87AD A9 03                    ..
        sta     $60A8                           ; 87AF 8D A8 60                 ..`
        lda     #$13                            ; 87B2 A9 13                    ..
        sta     $60A7                           ; 87B4 8D A7 60                 ..`
        jsr     L6F0C                           ; 87B7 20 0C 6F                  .o
        pla                                     ; 87BA 68                       h
        tax                                     ; 87BB AA                       .
        ldy     $60C3                           ; 87BC AC C3 60                 ..`
        lda     L8E7A,x                         ; 87BF BD 7A 8E                 .z.
        clc                                     ; 87C2 18                       .
        adc     $63FC,y                         ; 87C3 79 FC 63                 y.c
        cmp     #$DD                            ; 87C6 C9 DD                    ..
        bcc     L87CC                           ; 87C8 90 02                    ..
        lda     #$DD                            ; 87CA A9 DD                    ..
L87CC:  sta     $63FC,y                         ; 87CC 99 FC 63                 ..c
        lda     L8E6A,x                         ; 87CF BD 6A 8E                 .j.
        sec                                     ; 87D2 38                       8
        sbc     $64CC,y                         ; 87D3 F9 CC 64                 ..d
        jsr     L856B                           ; 87D6 20 6B 85                  k.
        clc                                     ; 87D9 18                       .
        adc     $64CC,y                         ; 87DA 79 CC 64                 y.d
        sta     $64CC,y                         ; 87DD 99 CC 64                 ..d
        jmp     L7A12                           ; 87E0 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
        lda     $673C,y                         ; 87E3 B9 3C 67                 .<g
        beq     L87EF                           ; 87E6 F0 07                    ..
        sec                                     ; 87E8 38                       8
        sbc     #$01                            ; 87E9 E9 01                    ..
        sta     $673C,y                         ; 87EB 99 3C 67                 .<g
        rts                                     ; 87EE 60                       `

; ----------------------------------------------------------------------------
L87EF:  lda     $66D4,y                         ; 87EF B9 D4 66                 ..f
        sec                                     ; 87F2 38                       8
        sbc     #$01                            ; 87F3 E9 01                    ..
        sta     $66D4,y                         ; 87F5 99 D4 66                 ..f
        bne     L8802                           ; 87F8 D0 08                    ..
L87FA:  lda     #$FF                            ; 87FA A9 FF                    ..
        sta     $680C,y                         ; 87FC 99 0C 68                 ..h
        jmp     LAC0C                           ; 87FF 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L8802:  jsr     L6906                           ; 8802 20 06 69                  .i
        and     #$03                            ; 8805 29 03                    ).
        tax                                     ; 8807 AA                       .
        lda     L8EA5,x                         ; 8808 BD A5 8E                 ...
        sta     $6464,y                         ; 880B 99 64 64                 .dd
        rts                                     ; 880E 60                       `

; ----------------------------------------------------------------------------
        ldx     $60C3                           ; 880F AE C3 60                 ..`
        lda     $66D4,x                         ; 8812 BD D4 66                 ..f
        bne     L883F                           ; 8815 D0 28                    .(
        dec     $673C,x                         ; 8817 DE 3C 67                 .<g
        bne     L8824                           ; 881A D0 08                    ..
L881C:  lda     #$00                            ; 881C A9 00                    ..
        sta     $680C,x                         ; 881E 9D 0C 68                 ..h
        jmp     LAC0C                           ; 8821 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L8824:  lda     $673C,x                         ; 8824 BD 3C 67                 .<g
        lsr     a                               ; 8827 4A                       J
        bcs     L882D                           ; 8828 B0 03                    ..
        inc     $62C4,x                         ; 882A FE C4 62                 ..b
L882D:  ldy     #$FF                            ; 882D A0 FF                    ..
        lda     $64CC,x                         ; 882F BD CC 64                 ..d
        bmi     L8838                           ; 8832 30 04                    0.
        beq     L8837                           ; 8834 F0 01                    ..
        iny                                     ; 8836 C8                       .
L8837:  iny                                     ; 8837 C8                       .
L8838:  tya                                     ; 8838 98                       .
        sta     $64CC,x                         ; 8839 9D CC 64                 ..d
        jmp     L7A12                           ; 883C 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
L883F:  lda     $6394,x                         ; 883F BD 94 63                 ..c
        sta     $60CD                           ; 8842 8D CD 60                 ..`
        lda     $632C,x                         ; 8845 BD 2C 63                 .,c
        sta     $60CC                           ; 8848 8D CC 60                 ..`
        lda     #$14                            ; 884B A9 14                    ..
        sta     $60A7                           ; 884D 8D A7 60                 ..`
        jsr     L6F0C                           ; 8850 20 0C 6F                  .o
        lda     #$00                            ; 8853 A9 00                    ..
        sta     $66D4,y                         ; 8855 99 D4 66                 ..f
        ldx     $60C3                           ; 8858 AE C3 60                 ..`
        dec     $673C,x                         ; 885B DE 3C 67                 .<g
        beq     L881C                           ; 885E F0 BC                    ..
        jmp     L7A12                           ; 8860 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
        ldx     $66D4,y                         ; 8863 BE D4 66                 ..f
        cpx     #$04                            ; 8866 E0 04                    ..
        bne     L886F                           ; 8868 D0 05                    ..
        ldx     $673C,y                         ; 886A BE 3C 67                 .<g
        bne     L887E                           ; 886D D0 0F                    ..
L886F:  dex                                     ; 886F CA                       .
        bne     L887E                           ; 8870 D0 0C                    ..
        jmp     LAC0C                           ; 8872 4C 0C AC                 L..

; ----------------------------------------------------------------------------
        lda     $63FC,y                         ; 8875 B9 FC 63                 ..c
        sec                                     ; 8878 38                       8
        sbc     #$03                            ; 8879 E9 03                    ..
        sta     $63FC,y                         ; 887B 99 FC 63                 ..c
L887E:  lda     L8EA8,x                         ; 887E BD A8 8E                 ...
        sta     $62C4,y                         ; 8881 99 C4 62                 ..b
        txa                                     ; 8884 8A                       .
        sta     $66D4,y                         ; 8885 99 D4 66                 ..f
        rts                                     ; 8888 60                       `

; ----------------------------------------------------------------------------
L8889:  lda     #$FF                            ; 8889 A9 FF                    ..
        sta     L8EE7                           ; 888B 8D E7 8E                 ...
        sta     L8EE9                           ; 888E 8D E9 8E                 ...
        sta     L8EEC                           ; 8891 8D EC 8E                 ...
        sta     L8EE8                           ; 8894 8D E8 8E                 ...
        sta     L8EEA                           ; 8897 8D EA 8E                 ...
        sta     L8EED                           ; 889A 8D ED 8E                 ...
        ldy     $60DF                           ; 889D AC DF 60                 ..`
L88A0:  cpy     $60E0                           ; 88A0 CC E0 60                 ..`
        beq     L88EE                           ; 88A3 F0 49                    .I
        lda     L8EE9                           ; 88A5 AD E9 8E                 ...
        ora     L8EEA                           ; 88A8 0D EA 8E                 ...
        bpl     L88EE                           ; 88AB 10 41                    .A
        ldx     $6124,y                         ; 88AD BE 24 61                 .$a
        lda     L8EAB,x                         ; 88B0 BD AB 8E                 ...
        beq     L88E8                           ; 88B3 F0 33                    .3
        ldx     $6604,y                         ; 88B5 BE 04 66                 ..f
        lda     L8EE9,x                         ; 88B8 BD E9 8E                 ...
        bpl     L88E8                           ; 88BB 10 2B                    .+
        lda     $6124,y                         ; 88BD B9 24 61                 .$a
        cmp     #$17                            ; 88C0 C9 17                    ..
        bne     L88D0                           ; 88C2 D0 0C                    ..
L88C4:  lda     $67A4,y                         ; 88C4 B9 A4 67                 ..g
        beq     L88E8                           ; 88C7 F0 1F                    ..
        lda     L8EE9,x                         ; 88C9 BD E9 8E                 ...
        bpl     L88E8                           ; 88CC 10 1A                    ..
        bmi     L88E4                           ; 88CE 30 14                    0.
L88D0:  cmp     #$16                            ; 88D0 C9 16                    ..
        beq     L88C4                           ; 88D2 F0 F0                    ..
        cmp     #$02                            ; 88D4 C9 02                    ..
        bne     L88DD                           ; 88D6 D0 05                    ..
        lda     $6104,x                         ; 88D8 BD 04 61                 ..a
        bne     L88E8                           ; 88DB D0 0B                    ..
L88DD:  lda     $63FC,y                         ; 88DD B9 FC 63                 ..c
        cmp     #$D8                            ; 88E0 C9 D8                    ..
        bcc     L88E8                           ; 88E2 90 04                    ..
L88E4:  tya                                     ; 88E4 98                       .
        sta     L8EE9,x                         ; 88E5 9D E9 8E                 ...
L88E8:  lda     $625C,y                         ; 88E8 B9 5C 62                 .\b
        tay                                     ; 88EB A8                       .
        bpl     L88A0                           ; 88EC 10 B2                    ..
L88EE:  ldy     L8EE9                           ; 88EE AC E9 8E                 ...
        bpl     L88F9                           ; 88F1 10 06                    ..
        ldy     L8EEA                           ; 88F3 AC EA 8E                 ...
        bpl     L8913                           ; 88F6 10 1B                    ..
        rts                                     ; 88F8 60                       `

; ----------------------------------------------------------------------------
L88F9:  ldx     L8EEA                           ; 88F9 AE EA 8E                 ...
        bmi     L8913                           ; 88FC 30 15                    0.
        lda     $632C,y                         ; 88FE B9 2C 63                 .,c
        cmp     $632C,x                         ; 8901 DD 2C 63                 .,c
        bcc     L8913                           ; 8904 90 0D                    ..
        bne     L8910                           ; 8906 D0 08                    ..
        lda     $6394,y                         ; 8908 B9 94 63                 ..c
        cmp     $6394,x                         ; 890B DD 94 63                 ..c
        bcc     L8913                           ; 890E 90 03                    ..
L8910:  ldy     L8EEA                           ; 8910 AC EA 8E                 ...
L8913:  sty     $60C3                           ; 8913 8C C3 60                 ..`
        jsr     L891C                           ; 8916 20 1C 89                  ..
        jmp     L88EE                           ; 8919 4C EE 88                 L..

; ----------------------------------------------------------------------------
L891C:  ldx     $6604,y                         ; 891C BE 04 66                 ..f
        stx     $60BD                           ; 891F 8E BD 60                 ..`
        txa                                     ; 8922 8A                       .
        eor     #$01                            ; 8923 49 01                    I.
        sta     L8EEB                           ; 8925 8D EB 8E                 ...
L8928:  lda     $625C,y                         ; 8928 B9 5C 62                 .\b
        cmp     $60E0                           ; 892B CD E0 60                 ..`
        beq     L8965                           ; 892E F0 35                    .5
        tay                                     ; 8930 A8                       .
        lda     $6604,y                         ; 8931 B9 04 66                 ..f
        cmp     $60BD                           ; 8934 CD BD 60                 ..`
        bne     L8928                           ; 8937 D0 EF                    ..
        ldx     $6124,y                         ; 8939 BE 24 61                 .$a
        lda     L8EAB,x                         ; 893C BD AB 8E                 ...
        beq     L8928                           ; 893F F0 E7                    ..
        cpx     #$17                            ; 8941 E0 17                    ..
        bne     L894C                           ; 8943 D0 07                    ..
L8945:  lda     $67A4,y                         ; 8945 B9 A4 67                 ..g
        beq     L8928                           ; 8948 F0 DE                    ..
        bne     L8967                           ; 894A D0 1B                    ..
L894C:  cpx     #$16                            ; 894C E0 16                    ..
        beq     L8945                           ; 894E F0 F5                    ..
        cpx     #$02                            ; 8950 E0 02                    ..
        bne     L895C                           ; 8952 D0 08                    ..
        ldx     $60BD                           ; 8954 AE BD 60                 ..`
        lda     $6104,x                         ; 8957 BD 04 61                 ..a
        bne     L8928                           ; 895A D0 CC                    ..
L895C:  lda     $63FC,y                         ; 895C B9 FC 63                 ..c
        cmp     #$D8                            ; 895F C9 D8                    ..
        bcc     L8928                           ; 8961 90 C5                    ..
        bcs     L8967                           ; 8963 B0 02                    ..
L8965:  ldy     #$FF                            ; 8965 A0 FF                    ..
L8967:  tya                                     ; 8967 98                       .
        ldx     $60BD                           ; 8968 AE BD 60                 ..`
        sta     L8EE9,x                         ; 896B 9D E9 8E                 ...
        lda     L8EEC,x                         ; 896E BD EC 8E                 ...
        bpl     L8979                           ; 8971 10 06                    ..
        lda     L8EE7,x                         ; 8973 BD E7 8E                 ...
        sta     L8EEC,x                         ; 8976 9D EC 8E                 ...
L8979:  ldy     $60C3                           ; 8979 AC C3 60                 ..`
        tya                                     ; 897C 98                       .
        sta     L8EE7,x                         ; 897D 9D E7 8E                 ...
        ldx     $6124,y                         ; 8980 BE 24 61                 .$a
        lda     L8EC4,x                         ; 8983 BD C4 8E                 ...
        bne     L8989                           ; 8986 D0 01                    ..
        rts                                     ; 8988 60                       `

; ----------------------------------------------------------------------------
L8989:  sta     $62                             ; 8989 85 62                    .b
        lda     $632C,y                         ; 898B B9 2C 63                 .,c
        sta     $60CC                           ; 898E 8D CC 60                 ..`
        lda     $6394,y                         ; 8991 B9 94 63                 ..c
        sta     $60CD                           ; 8994 8D CD 60                 ..`
        lda     #$00                            ; 8997 A9 00                    ..
        sta     $6874,y                         ; 8999 99 74 68                 .th
        ldx     L8EEB                           ; 899C AE EB 8E                 ...
        bit     $62                             ; 899F 24 62                    $b
        bvc     L89AB                           ; 89A1 50 08                    P.
        lda     $6604,y                         ; 89A3 B9 04 66                 ..f
        bne     L89AB                           ; 89A6 D0 03                    ..
L89A8:  jmp     L8ACF                           ; 89A8 4C CF 8A                 L..

; ----------------------------------------------------------------------------
L89AB:  lda     L8EE7,x                         ; 89AB BD E7 8E                 ...
        bmi     L89A8                           ; 89AE 30 F8                    0.
        sta     $63                             ; 89B0 85 63                    .c
L89B2:  lda     L8EEC,x                         ; 89B2 BD EC 8E                 ...
        bmi     L8A29                           ; 89B5 30 72                    0r
        tax                                     ; 89B7 AA                       .
        ldy     $6124,x                         ; 89B8 BC 24 61                 .$a
        lda     L6917,y                         ; 89BB B9 17 69                 ..i
        clc                                     ; 89BE 18                       .
        adc     $6394,x                         ; 89BF 7D 94 63                 }.c
        sta     L0060                           ; 89C2 85 60                    .`
        lda     $632C,x                         ; 89C4 BD 2C 63                 .,c
        adc     #$00                            ; 89C7 69 00                    i.
        sta     $61                             ; 89C9 85 61                    .a
        lda     $60CD                           ; 89CB AD CD 60                 ..`
        sec                                     ; 89CE 38                       8
        sbc     L0060                           ; 89CF E5 60                    .`
        sta     L0060                           ; 89D1 85 60                    .`
        lda     $60CC                           ; 89D3 AD CC 60                 ..`
        sbc     $61                             ; 89D6 E5 61                    .a
        bmi     L8A29                           ; 89D8 30 4F                    0O
        bne     L89E2                           ; 89DA D0 06                    ..
        lda     L0060                           ; 89DC A5 60                    .`
        cmp     #$0E                            ; 89DE C9 0E                    ..
        bcc     L8A29                           ; 89E0 90 47                    .G
L89E2:  lda     $625C,x                         ; 89E2 BD 5C 62                 .\b
        cmp     $63                             ; 89E5 C5 63                    .c
        bne     L89ED                           ; 89E7 D0 04                    ..
        lda     #$FF                            ; 89E9 A9 FF                    ..
        bmi     L8A21                           ; 89EB 30 34                    04
L89ED:  tax                                     ; 89ED AA                       .
        lda     $6604,x                         ; 89EE BD 04 66                 ..f
        cmp     L8EEB                           ; 89F1 CD EB 8E                 ...
        bne     L89E2                           ; 89F4 D0 EC                    ..
        ldy     $6124,x                         ; 89F6 BC 24 61                 .$a
        lda     L8EAB,y                         ; 89F9 B9 AB 8E                 ...
        beq     L89E2                           ; 89FC F0 E4                    ..
        cpy     #$16                            ; 89FE C0 16                    ..
        beq     L8A06                           ; 8A00 F0 04                    ..
        cpy     #$17                            ; 8A02 C0 17                    ..
        bne     L8A0D                           ; 8A04 D0 07                    ..
L8A06:  lda     $67A4,y                         ; 8A06 B9 A4 67                 ..g
        beq     L89E2                           ; 8A09 F0 D7                    ..
        bne     L8A20                           ; 8A0B D0 13                    ..
L8A0D:  cpy     #$02                            ; 8A0D C0 02                    ..
        bne     L8A19                           ; 8A0F D0 08                    ..
        ldy     L8EEB                           ; 8A11 AC EB 8E                 ...
        lda     $6104,y                         ; 8A14 B9 04 61                 ..a
        bne     L89E2                           ; 8A17 D0 C9                    ..
L8A19:  lda     $63FC,x                         ; 8A19 BD FC 63                 ..c
        cmp     #$D8                            ; 8A1C C9 D8                    ..
        bcc     L89E2                           ; 8A1E 90 C2                    ..
L8A20:  txa                                     ; 8A20 8A                       .
L8A21:  ldx     L8EEB                           ; 8A21 AE EB 8E                 ...
        sta     L8EEC,x                         ; 8A24 9D EC 8E                 ...
        bpl     L89B2                           ; 8A27 10 89                    ..
L8A29:  ldx     L8EEB                           ; 8A29 AE EB 8E                 ...
        ldy     L8EEC,x                         ; 8A2C BC EC 8E                 ...
        bpl     L8A34                           ; 8A2F 10 03                    ..
        ldy     L8EE7,x                         ; 8A31 BC E7 8E                 ...
L8A34:  ldx     $6124,y                         ; 8A34 BE 24 61                 .$a
        lda     L6917,x                         ; 8A37 BD 17 69                 ..i
        clc                                     ; 8A3A 18                       .
        adc     $6394,y                         ; 8A3B 79 94 63                 y.c
        sta     L0060                           ; 8A3E 85 60                    .`
        lda     $632C,y                         ; 8A40 B9 2C 63                 .,c
        adc     #$00                            ; 8A43 69 00                    i.
        sta     $61                             ; 8A45 85 61                    .a
        lda     $60CD                           ; 8A47 AD CD 60                 ..`
        sec                                     ; 8A4A 38                       8
        sbc     L0060                           ; 8A4B E5 60                    .`
        sta     L0060                           ; 8A4D 85 60                    .`
        lda     $60CC                           ; 8A4F AD CC 60                 ..`
        sbc     $61                             ; 8A52 E5 61                    .a
        bmi     L8A76                           ; 8A54 30 20                    0 
        bne     L8A85                           ; 8A56 D0 2D                    .-
        lda     L0060                           ; 8A58 A5 60                    .`
        cmp     #$0C                            ; 8A5A C9 0C                    ..
        bcc     L8A66                           ; 8A5C 90 08                    ..
        bit     $62                             ; 8A5E 24 62                    $b
        bmi     L8A85                           ; 8A60 30 23                    0#
        cmp     #$0E                            ; 8A62 C9 0E                    ..
        bcs     L8A85                           ; 8A64 B0 1F                    ..
L8A66:  ldx     $60C3                           ; 8A66 AE C3 60                 ..`
        lda     $6874,x                         ; 8A69 BD 74 68                 .th
        beq     L8A72                           ; 8A6C F0 04                    ..
        cmp     L0060                           ; 8A6E C5 60                    .`
        bcc     L8A85                           ; 8A70 90 13                    ..
L8A72:  lda     L0060                           ; 8A72 A5 60                    .`
        bne     L8A78                           ; 8A74 D0 02                    ..
L8A76:  lda     #$01                            ; 8A76 A9 01                    ..
L8A78:  sta     $6874,x                         ; 8A78 9D 74 68                 .th
        lda     $6124,y                         ; 8A7B B9 24 61                 .$a
        sta     $63                             ; 8A7E 85 63                    .c
        lda     $66D4,y                         ; 8A80 B9 D4 66                 ..f
        sta     $64                             ; 8A83 85 64                    .d
L8A85:  ldx     L8EEB                           ; 8A85 AE EB 8E                 ...
        tya                                     ; 8A88 98                       .
        cmp     L8EE7,x                         ; 8A89 DD E7 8E                 ...
        beq     L8ACF                           ; 8A8C F0 41                    .A
L8A8E:  lda     $625C,y                         ; 8A8E B9 5C 62                 .\b
        tay                                     ; 8A91 A8                       .
        ldx     L8EEB                           ; 8A92 AE EB 8E                 ...
        cmp     L8EE7,x                         ; 8A95 DD E7 8E                 ...
        beq     L8ACC                           ; 8A98 F0 32                    .2
        lda     $6604,y                         ; 8A9A B9 04 66                 ..f
        cmp     L8EEB                           ; 8A9D CD EB 8E                 ...
        bne     L8A8E                           ; 8AA0 D0 EC                    ..
        ldx     $6124,y                         ; 8AA2 BE 24 61                 .$a
        lda     L8EAB,x                         ; 8AA5 BD AB 8E                 ...
        beq     L8A8E                           ; 8AA8 F0 E4                    ..
        cpx     #$02                            ; 8AAA E0 02                    ..
        bne     L8AB6                           ; 8AAC D0 08                    ..
        ldx     L8EEB                           ; 8AAE AE EB 8E                 ...
        lda     $6104,x                         ; 8AB1 BD 04 61                 ..a
        bne     L8A8E                           ; 8AB4 D0 D8                    ..
L8AB6:  cpx     #$16                            ; 8AB6 E0 16                    ..
        bne     L8AC1                           ; 8AB8 D0 07                    ..
L8ABA:  lda     $66D4,y                         ; 8ABA B9 D4 66                 ..f
        beq     L8A8E                           ; 8ABD F0 CF                    ..
        bne     L8ACC                           ; 8ABF D0 0B                    ..
L8AC1:  cpx     #$17                            ; 8AC1 E0 17                    ..
        beq     L8ABA                           ; 8AC3 F0 F5                    ..
        lda     $63FC,y                         ; 8AC5 B9 FC 63                 ..c
        cmp     #$D8                            ; 8AC8 C9 D8                    ..
        bcc     L8A8E                           ; 8ACA 90 C2                    ..
L8ACC:  jmp     L8A34                           ; 8ACC 4C 34 8A                 L4.

; ----------------------------------------------------------------------------
L8ACF:  ldy     $60C3                           ; 8ACF AC C3 60                 ..`
        bit     $62                             ; 8AD2 24 62                    $b
        bvc     L8ADB                           ; 8AD4 50 05                    P.
        lda     $6604,y                         ; 8AD6 B9 04 66                 ..f
        bne     L8B2D                           ; 8AD9 D0 52                    .R
L8ADB:  lda     L8EE9,x                         ; 8ADB BD E9 8E                 ...
        bmi     L8B2D                           ; 8ADE 30 4D                    0M
        pha                                     ; 8AE0 48                       H
        ldx     $6124,y                         ; 8AE1 BE 24 61                 .$a
        lda     L6917,x                         ; 8AE4 BD 17 69                 ..i
        clc                                     ; 8AE7 18                       .
        adc     $60CD                           ; 8AE8 6D CD 60                 m.`
        sta     L0060                           ; 8AEB 85 60                    .`
        lda     $60CC                           ; 8AED AD CC 60                 ..`
        adc     #$00                            ; 8AF0 69 00                    i.
        sta     $61                             ; 8AF2 85 61                    .a
        pla                                     ; 8AF4 68                       h
        tax                                     ; 8AF5 AA                       .
        lda     $6394,x                         ; 8AF6 BD 94 63                 ..c
        sec                                     ; 8AF9 38                       8
        sbc     L0060                           ; 8AFA E5 60                    .`
        sta     L0060                           ; 8AFC 85 60                    .`
        lda     $632C,x                         ; 8AFE BD 2C 63                 .,c
        sbc     $61                             ; 8B01 E5 61                    .a
        bmi     L8B1E                           ; 8B03 30 19                    0.
        bne     L8B2D                           ; 8B05 D0 26                    .&
        lda     L0060                           ; 8B07 A5 60                    .`
        cmp     #$0C                            ; 8B09 C9 0C                    ..
        bcc     L8B15                           ; 8B0B 90 08                    ..
        bit     $62                             ; 8B0D 24 62                    $b
        bmi     L8B2D                           ; 8B0F 30 1C                    0.
        cmp     #$0E                            ; 8B11 C9 0E                    ..
        bcs     L8B2D                           ; 8B13 B0 18                    ..
L8B15:  lda     $6874,y                         ; 8B15 B9 74 68                 .th
        beq     L8B1E                           ; 8B18 F0 04                    ..
        cmp     L0060                           ; 8B1A C5 60                    .`
        bcc     L8B2D                           ; 8B1C 90 0F                    ..
L8B1E:  lda     #$FF                            ; 8B1E A9 FF                    ..
        sta     $6874,y                         ; 8B20 99 74 68                 .th
        lda     $6124,x                         ; 8B23 BD 24 61                 .$a
        sta     $63                             ; 8B26 85 63                    .c
        lda     $66D4,x                         ; 8B28 BD D4 66                 ..f
        sta     $64                             ; 8B2B 85 64                    .d
L8B2D:  lda     $6874,y                         ; 8B2D B9 74 68                 .th
        beq     L8B50                           ; 8B30 F0 1E                    ..
        bit     $62                             ; 8B32 24 62                    $b
        bvc     L8B50                           ; 8B34 50 1A                    P.
        ldx     #$00                            ; 8B36 A2 00                    ..
        lda     $63                             ; 8B38 A5 63                    .c
        cmp     #$0D                            ; 8B3A C9 0D                    ..
        beq     L8B4C                           ; 8B3C F0 0E                    ..
        cmp     #$09                            ; 8B3E C9 09                    ..
        beq     L8B4C                           ; 8B40 F0 0A                    ..
        inx                                     ; 8B42 E8                       .
        cmp     #$17                            ; 8B43 C9 17                    ..
        beq     L8B4C                           ; 8B45 F0 05                    ..
        cmp     #$16                            ; 8B47 C9 16                    ..
        beq     L8B4C                           ; 8B49 F0 01                    ..
        inx                                     ; 8B4B E8                       .
L8B4C:  txa                                     ; 8B4C 8A                       .
        sta     $66D4,y                         ; 8B4D 99 D4 66                 ..f
L8B50:  rts                                     ; 8B50 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 8B51 A9 00                    ..
        sta     $60AC                           ; 8B53 8D AC 60                 ..`
        nop                                     ; 8B56 EA                       .
        nop                                     ; 8B57 EA                       .
        nop                                     ; 8B58 EA                       .
        nop                                     ; 8B59 EA                       .
        nop                                     ; 8B5A EA                       .
        nop                                     ; 8B5B EA                       .
        nop                                     ; 8B5C EA                       .
        nop                                     ; 8B5D EA                       .
        nop                                     ; 8B5E EA                       .
        nop                                     ; 8B5F EA                       .
        nop                                     ; 8B60 EA                       .
        nop                                     ; 8B61 EA                       .
        nop                                     ; 8B62 EA                       .
        nop                                     ; 8B63 EA                       .
        nop                                     ; 8B64 EA                       .
        nop                                     ; 8B65 EA                       .
        nop                                     ; 8B66 EA                       .
        nop                                     ; 8B67 EA                       .
        nop                                     ; 8B68 EA                       .
        nop                                     ; 8B69 EA                       .
        nop                                     ; 8B6A EA                       .
        nop                                     ; 8B6B EA                       .
        nop                                     ; 8B6C EA                       .
        nop                                     ; 8B6D EA                       .
        nop                                     ; 8B6E EA                       .
        nop                                     ; 8B6F EA                       .
        nop                                     ; 8B70 EA                       .
        nop                                     ; 8B71 EA                       .
        nop                                     ; 8B72 EA                       .
        nop                                     ; 8B73 EA                       .
        nop                                     ; 8B74 EA                       .
        nop                                     ; 8B75 EA                       .
        nop                                     ; 8B76 EA                       .
        nop                                     ; 8B77 EA                       .
        nop                                     ; 8B78 EA                       .
        nop                                     ; 8B79 EA                       .
        nop                                     ; 8B7A EA                       .
        nop                                     ; 8B7B EA                       .
        nop                                     ; 8B7C EA                       .
        nop                                     ; 8B7D EA                       .
        nop                                     ; 8B7E EA                       .
        nop                                     ; 8B7F EA                       .
        nop                                     ; 8B80 EA                       .
        nop                                     ; 8B81 EA                       .
        nop                                     ; 8B82 EA                       .
        nop                                     ; 8B83 EA                       .
        nop                                     ; 8B84 EA                       .
        nop                                     ; 8B85 EA                       .
        nop                                     ; 8B86 EA                       .
        nop                                     ; 8B87 EA                       .
        nop                                     ; 8B88 EA                       .
        nop                                     ; 8B89 EA                       .
        nop                                     ; 8B8A EA                       .
        nop                                     ; 8B8B EA                       .
        nop                                     ; 8B8C EA                       .
        nop                                     ; 8B8D EA                       .
        nop                                     ; 8B8E EA                       .
        nop                                     ; 8B8F EA                       .
        nop                                     ; 8B90 EA                       .
        nop                                     ; 8B91 EA                       .
        nop                                     ; 8B92 EA                       .
        nop                                     ; 8B93 EA                       .
        nop                                     ; 8B94 EA                       .
        nop                                     ; 8B95 EA                       .
        nop                                     ; 8B96 EA                       .
        nop                                     ; 8B97 EA                       .
        nop                                     ; 8B98 EA                       .
        nop                                     ; 8B99 EA                       .
        nop                                     ; 8B9A EA                       .
        nop                                     ; 8B9B EA                       .
        lda     $67A4,y                         ; 8B9C B9 A4 67                 ..g
        beq     L8BFC                           ; 8B9F F0 5B                    .[
        lda     $60C1                           ; 8BA1 AD C1 60                 ..`
        and     #$01                            ; 8BA4 29 01                    ).
        beq     L8BFC                           ; 8BA6 F0 54                    .T
        ldx     #$00                            ; 8BA8 A2 00                    ..
        lda     $6874,y                         ; 8BAA B9 74 68                 .th
        beq     L8BFC                           ; 8BAD F0 4D                    .M
        bpl     L8BB2                           ; 8BAF 10 01                    ..
        inx                                     ; 8BB1 E8                       .
L8BB2:  lda     L8EE2,x                         ; 8BB2 BD E2 8E                 ...
        sta     $60CF                           ; 8BB5 8D CF 60                 ..`
        clc                                     ; 8BB8 18                       .
        bpl     L8BCB                           ; 8BB9 10 10                    ..
        lda     $6394,y                         ; 8BBB B9 94 63                 ..c
        adc     #$FF                            ; 8BBE 69 FF                    i.
        sta     $60CD                           ; 8BC0 8D CD 60                 ..`
        lda     $632C,y                         ; 8BC3 B9 2C 63                 .,c
        adc     #$FF                            ; 8BC6 69 FF                    i.
        jmp     L8BD9                           ; 8BC8 4C D9 8B                 L..

; ----------------------------------------------------------------------------
L8BCB:  lda     $6394,y                         ; 8BCB B9 94 63                 ..c
        adc     L692E                           ; 8BCE 6D 2E 69                 m.i
        sta     $60CD                           ; 8BD1 8D CD 60                 ..`
        lda     $632C,y                         ; 8BD4 B9 2C 63                 .,c
        adc     #$00                            ; 8BD7 69 00                    i.
L8BD9:  sta     $60CC                           ; 8BD9 8D CC 60                 ..`
        lda     $6604,y                         ; 8BDC B9 04 66                 ..f
        sta     $60BD                           ; 8BDF 8D BD 60                 ..`
        lda     #$00                            ; 8BE2 A9 00                    ..
        sta     $60D0                           ; 8BE4 8D D0 60                 ..`
        sta     $60A8                           ; 8BE7 8D A8 60                 ..`
        lda     #$04                            ; 8BEA A9 04                    ..
        sta     $60B3                           ; 8BEC 8D B3 60                 ..`
        lda     #$D9                            ; 8BEF A9 D9                    ..
        sta     $60CE                           ; 8BF1 8D CE 60                 ..`
        lda     #$0B                            ; 8BF4 A9 0B                    ..
        sta     $60A7                           ; 8BF6 8D A7 60                 ..`
        jmp     L6F0C                           ; 8BF9 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L8BFC:  rts                                     ; 8BFC 60                       `

; ----------------------------------------------------------------------------
        lda     $6464,y                         ; 8BFD B9 64 64                 .dd
        beq     L8C08                           ; 8C00 F0 06                    ..
        ldx     $60C3                           ; 8C02 AE C3 60                 ..`
        dec     $6464,x                         ; 8C05 DE 64 64                 .dd
L8C08:  lda     $63FC,y                         ; 8C08 B9 FC 63                 ..c
        cmp     #$DC                            ; 8C0B C9 DC                    ..
        bne     L8C12                           ; 8C0D D0 03                    ..
        jmp     L87FA                           ; 8C0F 4C FA 87                 L..

; ----------------------------------------------------------------------------
L8C12:  lda     $64CC,y                         ; 8C12 B9 CC 64                 ..d
        bpl     L8C1F                           ; 8C15 10 08                    ..
        cmp     #$F6                            ; 8C17 C9 F6                    ..
        beq     L8C25                           ; 8C19 F0 0A                    ..
        sbc     #$01                            ; 8C1B E9 01                    ..
        bne     L8C25                           ; 8C1D D0 06                    ..
L8C1F:  cmp     #$0A                            ; 8C1F C9 0A                    ..
        beq     L8C25                           ; 8C21 F0 02                    ..
        adc     #$01                            ; 8C23 69 01                    i.
L8C25:  sta     $64CC,y                         ; 8C25 99 CC 64                 ..d
        lda     $63FC,y                         ; 8C28 B9 FC 63                 ..c
        sta     $60CE                           ; 8C2B 8D CE 60                 ..`
        lda     $6394,y                         ; 8C2E B9 94 63                 ..c
        sta     $60CD                           ; 8C31 8D CD 60                 ..`
        lda     $632C,y                         ; 8C34 B9 2C 63                 .,c
        sta     $60CC                           ; 8C37 8D CC 60                 ..`
        lda     #$03                            ; 8C3A A9 03                    ..
        sta     $60A8                           ; 8C3C 8D A8 60                 ..`
        lda     #$13                            ; 8C3F A9 13                    ..
        sta     $60A7                           ; 8C41 8D A7 60                 ..`
        jsr     L6F0C                           ; 8C44 20 0C 6F                  .o
        jsr     L7A12                           ; 8C47 20 12 7A                  .z
        ldy     $60C3                           ; 8C4A AC C3 60                 ..`
        lda     $60C1                           ; 8C4D AD C1 60                 ..`
        and     #$03                            ; 8C50 29 03                    ).
        beq     L8C56                           ; 8C52 F0 02                    ..
        lda     #$01                            ; 8C54 A9 01                    ..
L8C56:  eor     #$01                            ; 8C56 49 01                    I.
        clc                                     ; 8C58 18                       .
        adc     $6534,y                         ; 8C59 79 34 65                 y4e
        sta     $6534,y                         ; 8C5C 99 34 65                 .4e
        clc                                     ; 8C5F 18                       .
        adc     $63FC,y                         ; 8C60 79 FC 63                 y.c
        cmp     #$DD                            ; 8C63 C9 DD                    ..
        bcc     L8C69                           ; 8C65 90 02                    ..
        lda     #$DC                            ; 8C67 A9 DC                    ..
L8C69:  sta     $63FC,y                         ; 8C69 99 FC 63                 ..c
        rts                                     ; 8C6C 60                       `

; ----------------------------------------------------------------------------
L8C6D:  ldy     $60C3                           ; 8C6D AC C3 60                 ..`
        stx     $60A8                           ; 8C70 8E A8 60                 ..`
        lda     #$10                            ; 8C73 A9 10                    ..
        sec                                     ; 8C75 38                       8
        sbc     $05                             ; 8C76 E5 05                    ..
        sta     $67A4,y                         ; 8C78 99 A4 67                 ..g
        lda     $60A7                           ; 8C7B AD A7 60                 ..`
        sta     $60AF                           ; 8C7E 8D AF 60                 ..`
        lda     #$00                            ; 8C81 A9 00                    ..
        sta     $60CF                           ; 8C83 8D CF 60                 ..`
        ldx     $6604,y                         ; 8C86 BE 04 66                 ..f
        stx     $60BD                           ; 8C89 8E BD 60                 ..`
        lda     L691C                           ; 8C8C AD 1C 69                 ..i
        lsr     a                               ; 8C8F 4A                       J
        adc     $6394,y                         ; 8C90 79 94 63                 y.c
        sta     $60CD                           ; 8C93 8D CD 60                 ..`
        lda     #$00                            ; 8C96 A9 00                    ..
        adc     $632C,y                         ; 8C98 79 2C 63                 y,c
        sta     $60CC                           ; 8C9B 8D CC 60                 ..`
        lda     #$C9                            ; 8C9E A9 C9                    ..
        sta     $60CE                           ; 8CA0 8D CE 60                 ..`
        lda     #$12                            ; 8CA3 A9 12                    ..
        sta     $60A7                           ; 8CA5 8D A7 60                 ..`
        sta     $673C,y                         ; 8CA8 99 3C 67                 .<g
        jsr     L6F0C                           ; 8CAB 20 0C 6F                  .o
        bcs     L8CB7                           ; 8CAE B0 07                    ..
        tya                                     ; 8CB0 98                       .
        ldy     $60C3                           ; 8CB1 AC C3 60                 ..`
        sta     $66D4,y                         ; 8CB4 99 D4 66                 ..f
L8CB7:  rts                                     ; 8CB7 60                       `

; ----------------------------------------------------------------------------
        lda     $67A4,y                         ; 8CB8 B9 A4 67                 ..g
        beq     L8CC4                           ; 8CBB F0 07                    ..
        sec                                     ; 8CBD 38                       8
        sbc     #$01                            ; 8CBE E9 01                    ..
        sta     $67A4,y                         ; 8CC0 99 A4 67                 ..g
        rts                                     ; 8CC3 60                       `

; ----------------------------------------------------------------------------
L8CC4:  lda     $66D4,y                         ; 8CC4 B9 D4 66                 ..f
        eor     #$01                            ; 8CC7 49 01                    I.
        sta     $66D4,y                         ; 8CC9 99 D4 66                 ..f
        and     #$01                            ; 8CCC 29 01                    ).
        bne     L8CE2                           ; 8CCE D0 12                    ..
        lda     $64CC,y                         ; 8CD0 B9 CC 64                 ..d
        jsr     L856B                           ; 8CD3 20 6B 85                  k.
        eor     #$FF                            ; 8CD6 49 FF                    I.
        clc                                     ; 8CD8 18                       .
        adc     #$01                            ; 8CD9 69 01                    i.
        clc                                     ; 8CDB 18                       .
        adc     $64CC,y                         ; 8CDC 79 CC 64                 y.d
        sta     $64CC,y                         ; 8CDF 99 CC 64                 ..d
L8CE2:  lda     $63FC,y                         ; 8CE2 B9 FC 63                 ..c
        cmp     #$DC                            ; 8CE5 C9 DC                    ..
        bne     L8CF8                           ; 8CE7 D0 0F                    ..
        ldx     #$FF                            ; 8CE9 A2 FF                    ..
        lda     $60ED                           ; 8CEB AD ED 60                 ..`
        bne     L8CF1                           ; 8CEE D0 01                    ..
        inx                                     ; 8CF0 E8                       .
L8CF1:  txa                                     ; 8CF1 8A                       .
        sta     $680C,y                         ; 8CF2 99 0C 68                 ..h
        jmp     LAC0C                           ; 8CF5 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L8CF8:  lda     $673C,y                         ; 8CF8 B9 3C 67                 .<g
        beq     L8D1D                           ; 8CFB F0 20                    . 
        sec                                     ; 8CFD 38                       8
        sbc     #$01                            ; 8CFE E9 01                    ..
        sta     $673C,y                         ; 8D00 99 3C 67                 .<g
        bne     L8D1D                           ; 8D03 D0 18                    ..
        lda     $62C4,y                         ; 8D05 B9 C4 62                 ..b
        sec                                     ; 8D08 38                       8
        sbc     #$02                            ; 8D09 E9 02                    ..
        cmp     #$3A                            ; 8D0B C9 3A                    .:
        bcs     L8D11                           ; 8D0D B0 02                    ..
        lda     #$3A                            ; 8D0F A9 3A                    .:
L8D11:  sta     $62C4,y                         ; 8D11 99 C4 62                 ..b
        cmp     #$3A                            ; 8D14 C9 3A                    .:
        beq     L8D1D                           ; 8D16 F0 05                    ..
        lda     #$01                            ; 8D18 A9 01                    ..
        sta     $673C,y                         ; 8D1A 99 3C 67                 .<g
L8D1D:  lda     $6534,y                         ; 8D1D B9 34 65                 .4e
        clc                                     ; 8D20 18                       .
        adc     #$02                            ; 8D21 69 02                    i.
        sta     $6534,y                         ; 8D23 99 34 65                 .4e
        clc                                     ; 8D26 18                       .
        adc     $63FC,y                         ; 8D27 79 FC 63                 y.c
        cmp     #$DD                            ; 8D2A C9 DD                    ..
        bcc     L8D30                           ; 8D2C 90 02                    ..
        lda     #$DC                            ; 8D2E A9 DC                    ..
L8D30:  sta     $63FC,y                         ; 8D30 99 FC 63                 ..c
        cmp     #$DC                            ; 8D33 C9 DC                    ..
        beq     L8D46                           ; 8D35 F0 0F                    ..
        lda     $66D4,y                         ; 8D37 B9 D4 66                 ..f
        and     #$02                            ; 8D3A 29 02                    ).
        beq     L8D41                           ; 8D3C F0 03                    ..
        jmp     L7A12                           ; 8D3E 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
L8D41:  ora     #$02                            ; 8D41 09 02                    ..
        sta     $66D4,y                         ; 8D43 99 D4 66                 ..f
L8D46:  rts                                     ; 8D46 60                       `

; ----------------------------------------------------------------------------
L8D47:  jmp     L87FA                           ; 8D47 4C FA 87                 L..

; ----------------------------------------------------------------------------
L8D4A:  jsr     L7A12                           ; 8D4A 20 12 7A                  .z
        ldy     $60C3                           ; 8D4D AC C3 60                 ..`
        lda     $6534,y                         ; 8D50 B9 34 65                 .4e
        clc                                     ; 8D53 18                       .
        adc     $67A4,y                         ; 8D54 79 A4 67                 y.g
        sta     $6534,y                         ; 8D57 99 34 65                 .4e
        lda     $63FC,y                         ; 8D5A B9 FC 63                 ..c
        cmp     #$DC                            ; 8D5D C9 DC                    ..
        beq     L8D47                           ; 8D5F F0 E6                    ..
        clc                                     ; 8D61 18                       .
        adc     $6534,y                         ; 8D62 79 34 65                 y4e
        cmp     #$DD                            ; 8D65 C9 DD                    ..
        bcc     L8D6B                           ; 8D67 90 02                    ..
        lda     #$DC                            ; 8D69 A9 DC                    ..
L8D6B:  sta     $63FC,y                         ; 8D6B 99 FC 63                 ..c
        cmp     #$28                            ; 8D6E C9 28                    .(
        bcc     L8D47                           ; 8D70 90 D5                    ..
        cmp     #$DC                            ; 8D72 C9 DC                    ..
        beq     L8D81                           ; 8D74 F0 0B                    ..
        lda     $673C,y                         ; 8D76 B9 3C 67                 .<g
        sec                                     ; 8D79 38                       8
        sbc     #$01                            ; 8D7A E9 01                    ..
        beq     L8D47                           ; 8D7C F0 C9                    ..
        sta     $673C,y                         ; 8D7E 99 3C 67                 .<g
L8D81:  rts                                     ; 8D81 60                       `

; ----------------------------------------------------------------------------
        jsr     L6906                           ; 8D82 20 06 69                  .i
        and     #$03                            ; 8D85 29 03                    ).
        bne     L8D99                           ; 8D87 D0 10                    ..
        lda     #$1B                            ; 8D89 A9 1B                    ..
        sta     $6124,y                         ; 8D8B 99 24 61                 .$a
        lda     #$01                            ; 8D8E A9 01                    ..
        sta     $618C,y                         ; 8D90 99 8C 61                 ..a
        jsr     L6F12                           ; 8D93 20 12 6F                  .o
        ldy     $60C3                           ; 8D96 AC C3 60                 ..`
L8D99:  lda     $673C,y                         ; 8D99 B9 3C 67                 .<g
        sec                                     ; 8D9C 38                       8
        sbc     #$01                            ; 8D9D E9 01                    ..
        bne     L8DA5                           ; 8D9F D0 04                    ..
L8DA1:  jmp     LAC0C                           ; 8DA1 4C 0C AC                 L..

; ----------------------------------------------------------------------------
        rts                                     ; 8DA4 60                       `

; ----------------------------------------------------------------------------
L8DA5:  sta     $673C,y                         ; 8DA5 99 3C 67                 .<g
        lda     $67A4,y                         ; 8DA8 B9 A4 67                 ..g
        bpl     L8DC3                           ; 8DAB 10 16                    ..
        .byte   $AD                             ; 8DAD AD                       .
        .byte   $E7                             ; 8DAE E7                       .
L8DAF:  rts                                     ; 8DAF 60                       `

; ----------------------------------------------------------------------------
        eor     $60C3                           ; 8DB0 4D C3 60                 M.`
        sta     $60E7                           ; 8DB3 8D E7 60                 ..`
        and     #$03                            ; 8DB6 29 03                    ).
        tax                                     ; 8DB8 AA                       .
        lda     L8EA5,x                         ; 8DB9 BD A5 8E                 ...
        sta     $6464,y                         ; 8DBC 99 64 64                 .dd
        lda     #$F1                            ; 8DBF A9 F1                    ..
        bne     L8DD2                           ; 8DC1 D0 0F                    ..
L8DC3:  .byte   $AD                             ; 8DC3 AD                       .
        .byte   $C1                             ; 8DC4 C1                       .
L8DC5:  rts                                     ; 8DC5 60                       `

; ----------------------------------------------------------------------------
        clc                                     ; 8DC6 18                       .
        adc     $60C3                           ; 8DC7 6D C3 60                 m.`
        and     #$03                            ; 8DCA 29 03                    ).
        clc                                     ; 8DCC 18                       .
        adc     $66D4,y                         ; 8DCD 79 D4 66                 y.f
        adc     #$73                            ; 8DD0 69 73                    is
L8DD2:  sta     $62C4,y                         ; 8DD2 99 C4 62                 ..b
        lda     $6534,y                         ; 8DD5 B9 34 65                 .4e
        clc                                     ; 8DD8 18                       .
        adc     #$02                            ; 8DD9 69 02                    i.
        sta     $6534,y                         ; 8DDB 99 34 65                 .4e
        clc                                     ; 8DDE 18                       .
        adc     $63FC,y                         ; 8DDF 79 FC 63                 y.c
        cmp     #$DD                            ; 8DE2 C9 DD                    ..
        bcs     L8DA1                           ; 8DE4 B0 BB                    ..
        sta     $63FC,y                         ; 8DE6 99 FC 63                 ..c
        jmp     L7A12                           ; 8DE9 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
        ldx     $60C3                           ; 8DEC AE C3 60                 ..`
        lda     $673C,x                         ; 8DEF BD 3C 67                 .<g
        bne     L8E00                           ; 8DF2 D0 0C                    ..
        dec     $66D4,x                         ; 8DF4 DE D4 66                 ..f
        bpl     L8DFC                           ; 8DF7 10 03                    ..
        jmp     LAC0C                           ; 8DF9 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L8DFC:  dec     $62C4,x                         ; 8DFC DE C4 62                 ..b
        rts                                     ; 8DFF 60                       `

; ----------------------------------------------------------------------------
L8E00:  dec     $673C,x                         ; 8E00 DE 3C 67                 .<g
        rts                                     ; 8E03 60                       `

; ----------------------------------------------------------------------------
        ldx     $67A4,y                         ; 8E04 BE A4 67                 ..g
        lda     #$14                            ; 8E07 A9 14                    ..
        cpx     #$1A                            ; 8E09 E0 1A                    ..
        beq     L8E0F                           ; 8E0B F0 02                    ..
        lda     #$18                            ; 8E0D A9 18                    ..
L8E0F:  sta     $6124,y                         ; 8E0F 99 24 61                 .$a
        pha                                     ; 8E12 48                       H
        jsr     L6F12                           ; 8E13 20 12 6F                  .o
        ldy     $60C3                           ; 8E16 AC C3 60                 ..`
L8E19:  pla                                     ; 8E19 68                       h
L8E1A:  asl     a                               ; 8E1A 0A                       .
        tax                                     ; 8E1B AA                       .
        jmp     L855E                           ; 8E1C 4C 5E 85                 L^.

; ----------------------------------------------------------------------------
        stx     $E685                           ; 8E1F 8E 85 E6                 ...
        sta     $F0                             ; 8E22 85 F0                    ..
        sta     $76                             ; 8E24 85 76                    .v
        sta     $76                             ; 8E26 85 76                    .v
        sta     $76                             ; 8E28 85 76                    .v
        sta     $76                             ; 8E2A 85 76                    .v
        sta     $B8                             ; 8E2C 85 B8                    ..
        sty     L8D4A                           ; 8E2E 8C 4A 8D                 .J.
        .byte   $82                             ; 8E31 82                       .
        sta     L8576                           ; 8E32 8D 76 85                 .v.
        ror     $85,x                           ; 8E35 76 85                    v.
        ror     $85,x                           ; 8E37 76 85                    v.
        ror     $85,x                           ; 8E39 76 85                    v.
        ror     $85,x                           ; 8E3B 76 85                    v.
        bvs     L8DC5                           ; 8E3D 70 86                    p.
        .byte   $E3                             ; 8E3F E3                       .
        .byte   $87                             ; 8E40 87                       .
        .byte   $0F                             ; 8E41 0F                       .
        dey                                     ; 8E42 88                       .
        .byte   $63                             ; 8E43 63                       c
        dey                                     ; 8E44 88                       .
        eor     ($8B),y                         ; 8E45 51 8B                    Q.
        .byte   $9C                             ; 8E47 9C                       .
        .byte   $8B                             ; 8E48 8B                       .
        cpx     L768D                           ; 8E49 EC 8D 76                 ..v
        sta     $FD                             ; 8E4C 85 FD                    ..
        .byte   $8B                             ; 8E4E 8B                       .
        sta     L768D,y                         ; 8E4F 99 8D 76                 ..v
        sta     $04                             ; 8E52 85 04                    ..
        .byte   $8E                             ; 8E54 8E                       .
L8E55:  ora     $06                             ; 8E55 05 06                    ..
        asl     $06                             ; 8E57 06 06                    ..
        .byte   $04                             ; 8E59 04                       .
        .byte   $04                             ; 8E5A 04                       .
        .byte   $04                             ; 8E5B 04                       .
        ora     $05                             ; 8E5C 05 05                    ..
L8E5E:  .byte   $03                             ; 8E5E 03                       .
        brk                                     ; 8E5F 00                       .
        asl     $06                             ; 8E60 06 06                    ..
        brk                                     ; 8E62 00                       .
        .byte   $03                             ; 8E63 03                       .
        brk                                     ; 8E64 00                       .
        brk                                     ; 8E65 00                       .
        brk                                     ; 8E66 00                       .
        ora     ($FF,x)                         ; 8E67 01 FF                    ..
        .byte   $01                             ; 8E69 01                       .
L8E6A:  brk                                     ; 8E6A 00                       .
        php                                     ; 8E6B 08                       .
L8E6C:  asl     a                               ; 8E6C 0A                       .
        .byte   $0C                             ; 8E6D 0C                       .
        bpl     L8E7C                           ; 8E6E 10 0C                    ..
        asl     a                               ; 8E70 0A                       .
        php                                     ; 8E71 08                       .
        brk                                     ; 8E72 00                       .
        sed                                     ; 8E73 F8                       .
        inc     $F4,x                           ; 8E74 F6 F4                    ..
        beq     L8E6C                           ; 8E76 F0 F4                    ..
        inc     $F8,x                           ; 8E78 F6 F8                    ..
L8E7A:  .byte   $F7                             ; 8E7A F7                       .
        .byte   $F9                             ; 8E7B F9                       .
L8E7C:  .byte   $FC                             ; 8E7C FC                       .
        .byte   $FF                             ; 8E7D FF                       .
        brk                                     ; 8E7E 00                       .
        ora     ($04,x)                         ; 8E7F 01 04                    ..
        .byte   $07                             ; 8E81 07                       .
        ora     #$07                            ; 8E82 09 07                    ..
        .byte   $04                             ; 8E84 04                       .
        ora     (L0000,x)                       ; 8E85 01 00                    ..
        .byte   $FF                             ; 8E87 FF                       .
        .byte   $FC                             ; 8E88 FC                       .
        sbc     L8000,y                         ; 8E89 F9 00 80                 ...
        ora     ($01,x)                         ; 8E8C 01 01                    ..
        ora     ($01,x)                         ; 8E8E 01 01                    ..
        ora     ($01,x)                         ; 8E90 01 01                    ..
        .byte   $80                             ; 8E92 80                       .
        ora     ($01,x)                         ; 8E93 01 01                    ..
        ora     (L0080,x)                       ; 8E95 01 80                    ..
        .byte   $80                             ; 8E97 80                       .
        .byte   $80                             ; 8E98 80                       .
        .byte   $80                             ; 8E99 80                       .
        ora     (L0080,x)                       ; 8E9A 01 80                    ..
        ora     ($01,x)                         ; 8E9C 01 01                    ..
        ora     ($01,x)                         ; 8E9E 01 01                    ..
        ora     ($01,x)                         ; 8EA0 01 01                    ..
        ora     ($01,x)                         ; 8EA2 01 01                    ..
        .byte   $01                             ; 8EA4 01                       .
L8EA5:  .byte   $02                             ; 8EA5 02                       .
        .byte   $03                             ; 8EA6 03                       .
        .byte   $06                             ; 8EA7 06                       .
L8EA8:  .byte   $07                             ; 8EA8 07                       .
        sbc     ($94),y                         ; 8EA9 F1 94                    ..
L8EAB:  sta     L0000,x                         ; 8EAB 95 00                    ..
        sta     (L0000,x)                       ; 8EAD 81 00                    ..
        brk                                     ; 8EAF 00                       .
        brk                                     ; 8EB0 00                       .
        brk                                     ; 8EB1 00                       .
        brk                                     ; 8EB2 00                       .
        brk                                     ; 8EB3 00                       .
        sta     (L0000,x)                       ; 8EB4 81 00                    ..
        brk                                     ; 8EB6 00                       .
        brk                                     ; 8EB7 00                       .
        sta     ($81,x)                         ; 8EB8 81 81                    ..
        sta     ($81,x)                         ; 8EBA 81 81                    ..
        brk                                     ; 8EBC 00                       .
        brk                                     ; 8EBD 00                       .
        brk                                     ; 8EBE 00                       .
        brk                                     ; 8EBF 00                       .
        brk                                     ; 8EC0 00                       .
        .byte   $80                             ; 8EC1 80                       .
        .byte   $80                             ; 8EC2 80                       .
        brk                                     ; 8EC3 00                       .
L8EC4:  sta     (L0000,x)                       ; 8EC4 81 00                    ..
        brk                                     ; 8EC6 00                       .
        brk                                     ; 8EC7 00                       .
        brk                                     ; 8EC8 00                       .
        brk                                     ; 8EC9 00                       .
        brk                                     ; 8ECA 00                       .
        brk                                     ; 8ECB 00                       .
        brk                                     ; 8ECC 00                       .
        brk                                     ; 8ECD 00                       .
        brk                                     ; 8ECE 00                       .
        brk                                     ; 8ECF 00                       .
        brk                                     ; 8ED0 00                       .
        .byte   $80                             ; 8ED1 80                       .
        rti                                     ; 8ED2 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8ED3 00                       .
        brk                                     ; 8ED4 00                       .
        brk                                     ; 8ED5 00                       .
        brk                                     ; 8ED6 00                       .
        brk                                     ; 8ED7 00                       .
        brk                                     ; 8ED8 00                       .
        brk                                     ; 8ED9 00                       .
        ora     ($01,x)                         ; 8EDA 01 01                    ..
        brk                                     ; 8EDC 00                       .
        brk                                     ; 8EDD 00                       .
        brk                                     ; 8EDE 00                       .
        brk                                     ; 8EDF 00                       .
        brk                                     ; 8EE0 00                       .
        brk                                     ; 8EE1 00                       .
L8EE2:  inc     a:$02,x                         ; 8EE2 FE 02 00                 ...
        brk                                     ; 8EE5 00                       .
        brk                                     ; 8EE6 00                       .
L8EE7:  brk                                     ; 8EE7 00                       .
L8EE8:  brk                                     ; 8EE8 00                       .
L8EE9:  brk                                     ; 8EE9 00                       .
L8EEA:  brk                                     ; 8EEA 00                       .
L8EEB:  brk                                     ; 8EEB 00                       .
L8EEC:  brk                                     ; 8EEC 00                       .
L8EED:  brk                                     ; 8EED 00                       .
        brk                                     ; 8EEE 00                       .
        asl     a                               ; 8EEF 0A                       .
        tay                                     ; 8EF0 A8                       .
        lda     LAB14,y                         ; 8EF1 B9 14 AB                 ...
        sta     L0060                           ; 8EF4 85 60                    .`
        lda     LAB15,y                         ; 8EF6 B9 15 AB                 ...
        sta     $61                             ; 8EF9 85 61                    .a
        jmp     (L0060)                         ; 8EFB 6C 60 00                 l`.

; ----------------------------------------------------------------------------
        .byte   $AE                             ; 8EFE AE                       .
        iny                                     ; 8EFF C8                       .
L8F00:  jmp     L8F18                           ; 8F00 4C 18 8F                 L..

; ----------------------------------------------------------------------------
L8F03:  jmp     L8F19                           ; 8F03 4C 19 8F                 L..

; ----------------------------------------------------------------------------
L8F06:  jmp     L8F2B                           ; 8F06 4C 2B 8F                 L+.

; ----------------------------------------------------------------------------
        jmp     L91C2                           ; 8F09 4C C2 91                 L..

; ----------------------------------------------------------------------------
L8F0C:  jmp     L9014                           ; 8F0C 4C 14 90                 L..

; ----------------------------------------------------------------------------
        jmp     L98BA                           ; 8F0F 4C BA 98                 L..

; ----------------------------------------------------------------------------
L8F12:  jmp     L960B                           ; 8F12 4C 0B 96                 L..

; ----------------------------------------------------------------------------
L8F15:  jmp     (L0060)                         ; 8F15 6C 60 00                 l`.

; ----------------------------------------------------------------------------
L8F18:  rts                                     ; 8F18 60                       `

; ----------------------------------------------------------------------------
L8F19:  lda     #$03                            ; 8F19 A9 03                    ..
        sta     $6044                           ; 8F1B 8D 44 60                 .D`
        lda     #$00                            ; 8F1E A9 00                    ..
        sta     $60A6                           ; 8F20 8D A6 60                 ..`
        sta     $6046                           ; 8F23 8D 46 60                 .F`
        lda     #$04                            ; 8F26 A9 04                    ..
        sta     $6045                           ; 8F28 8D 45 60                 .E`
L8F2B:  lda     $6049                           ; 8F2B AD 49 60                 .I`
        sta     $60CA                           ; 8F2E 8D CA 60                 ..`
        lda     $604A                           ; 8F31 AD 4A 60                 .J`
        sta     $60CB                           ; 8F34 8D CB 60                 ..`
        lda     $C061                           ; 8F37 AD 61 C0                 .a.
        and     #$80                            ; 8F3A 29 80                    ).
        sta     $60C8                           ; 8F3C 8D C8 60                 ..`
        sta     $6049                           ; 8F3F 8D 49 60                 .I`
        lda     $C062                           ; 8F42 AD 62 C0                 .b.
        and     #$80                            ; 8F45 29 80                    ).
        sta     $60C9                           ; 8F47 8D C9 60                 ..`
        sta     $604A                           ; 8F4A 8D 4A 60                 .J`
        and     $60C8                           ; 8F4D 2D C8 60                 -.`
        bpl     L8F61                           ; 8F50 10 0F                    ..
        lda     $60CA                           ; 8F52 AD CA 60                 ..`
        eor     $60CB                           ; 8F55 4D CB 60                 M.`
L8F58:  eor     #$80                            ; 8F58 49 80                    I.
        sta     $60C8                           ; 8F5A 8D C8 60                 ..`
        sta     $60C9                           ; 8F5D 8D C9 60                 ..`
        rts                                     ; 8F60 60                       `

; ----------------------------------------------------------------------------
L8F61:  lda     $60CA                           ; 8F61 AD CA 60                 ..`
        and     $60CB                           ; 8F64 2D CB 60                 -.`
        bmi     L8F58                           ; 8F67 30 EF                    0.
        lda     $60CA                           ; 8F69 AD CA 60                 ..`
        sta     $60C8                           ; 8F6C 8D C8 60                 ..`
        lda     $60CB                           ; 8F6F AD CB 60                 ..`
        sta     $60C9                           ; 8F72 8D C9 60                 ..`
        rts                                     ; 8F75 60                       `

; ----------------------------------------------------------------------------
        inc     $60B4                           ; 8F76 EE B4 60                 ..`
        rts                                     ; 8F79 60                       `

; ----------------------------------------------------------------------------
        lda     #$01                            ; 8F7A A9 01                    ..
        sta     $60BC                           ; 8F7C 8D BC 60                 ..`
        sta     $60B0                           ; 8F7F 8D B0 60                 ..`
        rts                                     ; 8F82 60                       `

; ----------------------------------------------------------------------------
        sta     $6042                           ; 8F83 8D 42 60                 .B`
        rts                                     ; 8F86 60                       `

; ----------------------------------------------------------------------------
L8F87:  lda     #$00                            ; 8F87 A9 00                    ..
        sta     $60BB                           ; 8F89 8D BB 60                 ..`
        inc     $60B0                           ; 8F8C EE B0 60                 ..`
        inc     $60B8                           ; 8F8F EE B8 60                 ..`
        rts                                     ; 8F92 60                       `

; ----------------------------------------------------------------------------
L8F93:  jsr     LB30F                           ; 8F93 20 0F B3                  ..
        bit     $C010                           ; 8F96 2C 10 C0                 ,..
L8F99:  ldx     #$03                            ; 8F99 A2 03                    ..
L8F9B:  lda     $C000                           ; 8F9B AD 00 C0                 ...
        bpl     L8F9B                           ; 8F9E 10 FB                    ..
        bit     $C010                           ; 8FA0 2C 10 C0                 ,..
        cmp     #$9B                            ; 8FA3 C9 9B                    ..
        beq     L8FC4                           ; 8FA5 F0 1D                    ..
        cmp     #$E1                            ; 8FA7 C9 E1                    ..
        bcc     L8FB1                           ; 8FA9 90 06                    ..
        cmp     #$FB                            ; 8FAB C9 FB                    ..
        bcs     L8FB1                           ; 8FAD B0 02                    ..
        adc     #$E0                            ; 8FAF 69 E0                    i.
L8FB1:  cmp     L99EC,x                         ; 8FB1 DD EC 99                 ...
        bne     L8F99                           ; 8FB4 D0 E3                    ..
        dex                                     ; 8FB6 CA                       .
        bpl     L8F9B                           ; 8FB7 10 E2                    ..
        lda     $06                             ; 8FB9 A5 06                    ..
        bne     L8F99                           ; 8FBB D0 DC                    ..
        lda     #$04                            ; 8FBD A9 04                    ..
        jsr     L690F                           ; 8FBF 20 0F 69                  .i
        bcs     L8F99                           ; 8FC2 B0 D5                    ..
L8FC4:  rts                                     ; 8FC4 60                       `

; ----------------------------------------------------------------------------
        bit     $6046                           ; 8FC5 2C 46 60                 ,F`
        bpl     L8FED                           ; 8FC8 10 23                    .#
        bit     $C010                           ; 8FCA 2C 10 C0                 ,..
L8FCD:  lda     $C000                           ; 8FCD AD 00 C0                 ...
        bpl     L8FCD                           ; 8FD0 10 FB                    ..
        bit     $C010                           ; 8FD2 2C 10 C0                 ,..
        cmp     #$B1                            ; 8FD5 C9 B1                    ..
        bcc     L8FED                           ; 8FD7 90 14                    ..
        cmp     #$BA                            ; 8FD9 C9 BA                    ..
        bcs     L8FED                           ; 8FDB B0 10                    ..
        and     #$0F                            ; 8FDD 29 0F                    ).
        sta     $05                             ; 8FDF 85 05                    ..
        dec     $05                             ; 8FE1 C6 05                    ..
        lda     #$02                            ; 8FE3 A9 02                    ..
        sta     $60C6                           ; 8FE5 8D C6 60                 ..`
        lda     #$F0                            ; 8FE8 A9 F0                    ..
        sta     $60C7                           ; 8FEA 8D C7 60                 ..`
L8FED:  rts                                     ; 8FED 60                       `

; ----------------------------------------------------------------------------
        lda     #$60                            ; 8FEE A9 60                    .`
        ldx     #$02                            ; 8FF0 A2 02                    ..
        bne     L8FFE                           ; 8FF2 D0 0A                    ..
        lda     #$F7                            ; 8FF4 A9 F7                    ..
        ldx     #$07                            ; 8FF6 A2 07                    ..
        bne     L8FFE                           ; 8FF8 D0 04                    ..
        lda     #$A0                            ; 8FFA A9 A0                    ..
        ldx     #$0D                            ; 8FFC A2 0D                    ..
L8FFE:  bit     $6046                           ; 8FFE 2C 46 60                 ,F`
        bpl     L9013                           ; 9001 10 10                    ..
        ldy     $6113                           ; 9003 AC 13 61                 ..a
        sty     $60C3                           ; 9006 8C C3 60                 ..`
        sta     $6394,y                         ; 9009 99 94 63                 ..c
        txa                                     ; 900C 8A                       .
        sta     $632C,y                         ; 900D 99 2C 63                 .,c
        jmp     L7A0C                           ; 9010 4C 0C 7A                 L.z

; ----------------------------------------------------------------------------
L9013:  rts                                     ; 9013 60                       `

; ----------------------------------------------------------------------------
L9014:  jsr     L8F2B                           ; 9014 20 2B 8F                  +.
        lda     #$00                            ; 9017 A9 00                    ..
        sta     L99FE                           ; 9019 8D FE 99                 ...
        lda     $C000                           ; 901C AD 00 C0                 ...
        bpl     L9077                           ; 901F 10 56                    .V
        cmp     #$E1                            ; 9021 C9 E1                    ..
        bcc     L902B                           ; 9023 90 06                    ..
        cmp     #$FB                            ; 9025 C9 FB                    ..
        bcs     L902B                           ; 9027 B0 02                    ..
        adc     #$E0                            ; 9029 69 E0                    i.
L902B:  sta     L99FE                           ; 902B 8D FE 99                 ...
        bit     $C010                           ; 902E 2C 10 C0                 ,..
        ldy     $60B6                           ; 9031 AC B6 60                 ..`
        bne     L90AC                           ; 9034 D0 76                    .v
        ldy     $60C6                           ; 9036 AC C6 60                 ..`
        beq     L9043                           ; 9039 F0 08                    ..
        cmp     #$92                            ; 903B C9 92                    ..
        beq     L9043                           ; 903D F0 04                    ..
        cmp     #$9B                            ; 903F C9 9B                    ..
        bne     L9077                           ; 9041 D0 34                    .4
L9043:  ldy     $60B0                           ; 9043 AC B0 60                 ..`
        beq     L9056                           ; 9046 F0 0E                    ..
        ldy     $60B1                           ; 9048 AC B1 60                 ..`
        cpy     #$10                            ; 904B C0 10                    ..
        bcc     L9077                           ; 904D 90 28                    .(
        lda     #$FF                            ; 904F A9 FF                    ..
        sta     $60B1                           ; 9051 8D B1 60                 ..`
        bmi     L9077                           ; 9054 30 21                    0!
L9056:  ldy     #$10                            ; 9056 A0 10                    ..
L9058:  cmp     L9939,y                         ; 9058 D9 39 99                 .9.
        beq     L907A                           ; 905B F0 1D                    ..
        dey                                     ; 905D 88                       .
        bpl     L9058                           ; 905E 10 F8                    ..
        cmp     #$B1                            ; 9060 C9 B1                    ..
        bcc     L9090                           ; 9062 90 2C                    .,
        cmp     #$BA                            ; 9064 C9 BA                    ..
        bcs     L9090                           ; 9066 B0 28                    .(
        and     #$0F                            ; 9068 29 0F                    ).
        asl     a                               ; 906A 0A                       .
        sta     $60B5                           ; 906B 8D B5 60                 ..`
        lda     #$14                            ; 906E A9 14                    ..
        sec                                     ; 9070 38                       8
        sbc     $60B5                           ; 9071 ED B5 60                 ..`
        sta     $60B5                           ; 9074 8D B5 60                 ..`
L9077:  jmp     L90F6                           ; 9077 4C F6 90                 L..

; ----------------------------------------------------------------------------
L907A:  tya                                     ; 907A 98                       .
        asl     a                               ; 907B 0A                       .
        tax                                     ; 907C AA                       .
        lda     L994A,x                         ; 907D BD 4A 99                 .J.
        sta     L0060                           ; 9080 85 60                    .`
        lda     L994B,x                         ; 9082 BD 4B 99                 .K.
        sta     $61                             ; 9085 85 61                    .a
        lda     L99FE                           ; 9087 AD FE 99                 ...
        jsr     L8F15                           ; 908A 20 15 8F                  ..
        jmp     L90F6                           ; 908D 4C F6 90                 L..

; ----------------------------------------------------------------------------
L9090:  ldy     $6045                           ; 9090 AC 45 60                 .E`
        cmp     L99A8,y                         ; 9093 D9 A8 99                 ...
        bne     L90A5                           ; 9096 D0 0D                    ..
        dec     $6045                           ; 9098 CE 45 60                 .E`
        bpl     L90F6                           ; 909B 10 59                    .Y
        lda     $6046                           ; 909D AD 46 60                 .F`
        eor     #$FF                            ; 90A0 49 FF                    I.
        sta     $6046                           ; 90A2 8D 46 60                 .F`
L90A5:  lda     #$04                            ; 90A5 A9 04                    ..
        sta     $6045                           ; 90A7 8D 45 60                 .E`
        bne     L90F6                           ; 90AA D0 4A                    .J
L90AC:  ldy     #$01                            ; 90AC A0 01                    ..
        cmp     #$BD                            ; 90AE C9 BD                    ..
        bne     L90B8                           ; 90B0 D0 06                    ..
        jsr     L9927                           ; 90B2 20 27 99                  '.
        jmp     L90F6                           ; 90B5 4C F6 90                 L..

; ----------------------------------------------------------------------------
L90B8:  dey                                     ; 90B8 88                       .
        cmp     #$D3                            ; 90B9 C9 D3                    ..
        bne     L90C3                           ; 90BB D0 06                    ..
        jsr     L8F87                           ; 90BD 20 87 8F                  ..
        jmp     L90F6                           ; 90C0 4C F6 90                 L..

; ----------------------------------------------------------------------------
L90C3:  ldy     $60B2                           ; 90C3 AC B2 60                 ..`
        beq     L90F6                           ; 90C6 F0 2E                    ..
        ldy     $6044                           ; 90C8 AC 44 60                 .D`
        cmp     L99F0,y                         ; 90CB D9 F0 99                 ...
        beq     L90D8                           ; 90CE F0 08                    ..
        lda     #$03                            ; 90D0 A9 03                    ..
        sta     $6044                           ; 90D2 8D 44 60                 .D`
        jmp     L90F6                           ; 90D5 4C F6 90                 L..

; ----------------------------------------------------------------------------
L90D8:  dec     $6044                           ; 90D8 CE 44 60                 .D`
        bpl     L90F6                           ; 90DB 10 19                    ..
        lda     $06                             ; 90DD A5 06                    ..
        bne     L90F6                           ; 90DF D0 15                    ..
        lda     #$03                            ; 90E1 A9 03                    ..
        sta     $6044                           ; 90E3 8D 44 60                 .D`
        jsr     L690F                           ; 90E6 20 0F 69                  .i
        lda     $60B6                           ; 90E9 AD B6 60                 ..`
        bne     L90F6                           ; 90EC D0 08                    ..
        lda     #$01                            ; 90EE A9 01                    ..
        jsr     LB309                           ; 90F0 20 09 B3                  ..
        jsr     L8F93                           ; 90F3 20 93 8F                  ..
L90F6:  lda     $60B6                           ; 90F6 AD B6 60                 ..`
        bne     L9135                           ; 90F9 D0 3A                    .:
        lda     $60B0                           ; 90FB AD B0 60                 ..`
        beq     L911C                           ; 90FE F0 1C                    ..
        lda     $60B1                           ; 9100 AD B1 60                 ..`
        cmp     #$10                            ; 9103 C9 10                    ..
        bcc     L911C                           ; 9105 90 15                    ..
        lda     $60C8                           ; 9107 AD C8 60                 ..`
        eor     $60CA                           ; 910A 4D CA 60                 M.`
        bne     L9117                           ; 910D D0 08                    ..
        lda     $60C9                           ; 910F AD C9 60                 ..`
        eor     $60CB                           ; 9112 4D CB 60                 M.`
        bpl     L911C                           ; 9115 10 05                    ..
L9117:  lda     #$FF                            ; 9117 A9 FF                    ..
        sta     $60B1                           ; 9119 8D B1 60                 ..`
L911C:  lda     $60C6                           ; 911C AD C6 60                 ..`
        beq     L9129                           ; 911F F0 08                    ..
        lda     #$00                            ; 9121 A9 00                    ..
        sta     $60C8                           ; 9123 8D C8 60                 ..`
        sta     $60C9                           ; 9126 8D C9 60                 ..`
L9129:  jsr     L914C                           ; 9129 20 4C 91                  L.
        bit     $60BB                           ; 912C 2C BB 60                 ,.`
        bpl     L9134                           ; 912F 10 03                    ..
        jsr     LDA1B                           ; 9131 20 1B DA                  ..
L9134:  rts                                     ; 9134 60                       `

; ----------------------------------------------------------------------------
L9135:  lda     $60C8                           ; 9135 AD C8 60                 ..`
        eor     $60CA                           ; 9138 4D CA 60                 M.`
        bne     L9145                           ; 913B D0 08                    ..
        lda     $60C9                           ; 913D AD C9 60                 ..`
        eor     $60CB                           ; 9140 4D CB 60                 M.`
        beq     L914B                           ; 9143 F0 06                    ..
L9145:  inc     $60B0                           ; 9145 EE B0 60                 ..`
        inc     $60B8                           ; 9148 EE B8 60                 ..`
L914B:  rts                                     ; 914B 60                       `

; ----------------------------------------------------------------------------
L914C:  ldx     #$00                            ; 914C A2 00                    ..
        stx     $604D                           ; 914E 8E 4D 60                 .M`
        stx     $604E                           ; 9151 8E 4E 60                 .N`
        lda     $C070                           ; 9154 AD 70 C0                 .p.
L9157:  lda     $C064                           ; 9157 AD 64 C0                 .d.
        bpl     L91BE                           ; 915A 10 62                    .b
        stx     $604D                           ; 915C 8E 4D 60                 .M`
L915F:  lda     $C065                           ; 915F AD 65 C0                 .e.
        bpl     L91C0                           ; 9162 10 5C                    .\
        stx     $604E                           ; 9164 8E 4E 60                 .N`
L9167:  inx                                     ; 9167 E8                       .
        bne     L9157                           ; 9168 D0 ED                    ..
        lda     #$64                            ; 916A A9 64                    .d
        cmp     $604D                           ; 916C CD 4D 60                 .M`
        bcs     L9174                           ; 916F B0 03                    ..
        sta     $604D                           ; 9171 8D 4D 60                 .M`
L9174:  cmp     $604E                           ; 9174 CD 4E 60                 .N`
        bcs     L917C                           ; 9177 B0 03                    ..
        sta     $604E                           ; 9179 8D 4E 60                 .N`
L917C:  lda     $604D                           ; 917C AD 4D 60                 .M`
        lsr     a                               ; 917F 4A                       J
        lsr     a                               ; 9180 4A                       J
        tax                                     ; 9181 AA                       .
        lda     L998E,x                         ; 9182 BD 8E 99                 ...
        sta     $604D                           ; 9185 8D 4D 60                 .M`
        lda     #$00                            ; 9188 A9 00                    ..
        sta     $62                             ; 918A 85 62                    .b
        sta     $63                             ; 918C 85 63                    .c
        lda     #$BF                            ; 918E A9 BF                    ..
        sta     L0060                           ; 9190 85 60                    .`
        lda     #$01                            ; 9192 A9 01                    ..
        sta     $61                             ; 9194 85 61                    .a
        ldx     #$08                            ; 9196 A2 08                    ..
        lda     $604E                           ; 9198 AD 4E 60                 .N`
        eor     #$FF                            ; 919B 49 FF                    I.
L919D:  lsr     a                               ; 919D 4A                       J
        bcs     L91AE                           ; 919E B0 0E                    ..
        pha                                     ; 91A0 48                       H
        lda     L0060                           ; 91A1 A5 60                    .`
        adc     $62                             ; 91A3 65 62                    eb
        sta     $62                             ; 91A5 85 62                    .b
        lda     $61                             ; 91A7 A5 61                    .a
        adc     $63                             ; 91A9 65 63                    ec
        sta     $63                             ; 91AB 85 63                    .c
        pla                                     ; 91AD 68                       h
L91AE:  asl     L0060                           ; 91AE 06 60                    .`
        rol     $61                             ; 91B0 26 61                    &a
        dex                                     ; 91B2 CA                       .
        bne     L919D                           ; 91B3 D0 E8                    ..
        lda     $63                             ; 91B5 A5 63                    .c
        clc                                     ; 91B7 18                       .
        adc     #$38                            ; 91B8 69 38                    i8
        sta     $604E                           ; 91BA 8D 4E 60                 .N`
        rts                                     ; 91BD 60                       `

; ----------------------------------------------------------------------------
L91BE:  bpl     L915F                           ; 91BE 10 9F                    ..
L91C0:  bpl     L9167                           ; 91C0 10 A5                    ..
L91C2:  ldy     $60C3                           ; 91C2 AC C3 60                 ..`
        ldx     $6604,y                         ; 91C5 BE 04 66                 ..f
        stx     L99F8                           ; 91C8 8E F8 99                 ...
        lda     $604B,x                         ; 91CB BD 4B 60                 .K`
        beq     L91D3                           ; 91CE F0 03                    ..
        dec     $604B,x                         ; 91D0 DE 4B 60                 .K`
L91D3:  lda     $610A,x                         ; 91D3 BD 0A 61                 ..a
        beq     L91E1                           ; 91D6 F0 09                    ..
        dec     $610A,x                         ; 91D8 DE 0A 61                 ..a
        jsr     L98C1                           ; 91DB 20 C1 98                  ..
        ldx     L99F8                           ; 91DE AE F8 99                 ...
L91E1:  lda     $6104,x                         ; 91E1 BD 04 61                 ..a
        beq     L9249                           ; 91E4 F0 63                    .c
        lda     #$00                            ; 91E6 A9 00                    ..
        sta     $60F1                           ; 91E8 8D F1 60                 ..`
        sta     $60FC,x                         ; 91EB 9D FC 60                 ..`
        sta     $610A,x                         ; 91EE 9D 0A 61                 ..a
        lda     $60F8,x                         ; 91F1 BD F8 60                 ..`
        beq     L91F9                           ; 91F4 F0 03                    ..
        jsr     L933D                           ; 91F6 20 3D 93                  =.
L91F9:  lda     $60AB                           ; 91F9 AD AB 60                 ..`
        beq     L9246                           ; 91FC F0 48                    .H
        dec     $6104,x                         ; 91FE DE 04 61                 ..a
        bne     L9246                           ; 9201 D0 43                    .C
        lda     $60B6                           ; 9203 AD B6 60                 ..`
        bne     L9218                           ; 9206 D0 10                    ..
        txa                                     ; 9208 8A                       .
        beq     L9218                           ; 9209 F0 0D                    ..
        lda     $C061                           ; 920B AD 61 C0                 .a.
        ora     $C062                           ; 920E 0D 62 C0                 .b.
        bpl     L9218                           ; 9211 10 05                    ..
        inc     $6104,x                         ; 9213 FE 04 61                 ..a
        bne     L9246                           ; 9216 D0 2E                    ..
L9218:  jsr     LAC0F                           ; 9218 20 0F AC                  ..
        lda     #$02                            ; 921B A9 02                    ..
        sta     $60A7                           ; 921D 8D A7 60                 ..`
        ldx     L99F8                           ; 9220 AE F8 99                 ...
        stx     $60BD                           ; 9223 8E BD 60                 ..`
        lda     $6106,x                         ; 9226 BD 06 61                 ..a
        tax                                     ; 9229 AA                       .
        lda     $6394,x                         ; 922A BD 94 63                 ..c
        clc                                     ; 922D 18                       .
        adc     #$08                            ; 922E 69 08                    i.
        sta     $60CD                           ; 9230 8D CD 60                 ..`
        lda     $632C,x                         ; 9233 BD 2C 63                 .,c
        adc     #$00                            ; 9236 69 00                    i.
        sta     $60CC                           ; 9238 8D CC 60                 ..`
        jsr     L6F0C                           ; 923B 20 0C 6F                  .o
        bcc     L9246                           ; 923E 90 06                    ..
        ldx     L99F8                           ; 9240 AE F8 99                 ...
        inc     $6104,x                         ; 9243 FE 04 61                 ..a
L9246:  jmp     L94D6                           ; 9246 4C D6 94                 L..

; ----------------------------------------------------------------------------
L9249:  lda     $60F8,x                         ; 9249 BD F8 60                 ..`
        bne     L9254                           ; 924C D0 06                    ..
        jsr     L9A09                           ; 924E 20 09 9A                  ..
        jmp     L9257                           ; 9251 4C 57 92                 LW.

; ----------------------------------------------------------------------------
L9254:  jsr     L9325                           ; 9254 20 25 93                  %.
L9257:  jsr     L934C                           ; 9257 20 4C 93                  L.
        jsr     L94D6                           ; 925A 20 D6 94                  ..
        ldy     $60C3                           ; 925D AC C3 60                 ..`
        lda     $659C,y                         ; 9260 B9 9C 65                 ..e
        cmp     #$0F                            ; 9263 C9 0F                    ..
        beq     L9288                           ; 9265 F0 21                    .!
        ldx     $6604,y                         ; 9267 BE 04 66                 ..f
        lda     $63FC,y                         ; 926A B9 FC 63                 ..c
        cmp     #$DD                            ; 926D C9 DD                    ..
        bne     L9285                           ; 926F D0 14                    ..
        lda     $6100,x                         ; 9271 BD 00 61                 ..a
        cmp     #$04                            ; 9274 C9 04                    ..
        bcc     L9285                           ; 9276 90 0D                    ..
        lda     $60C1                           ; 9278 AD C1 60                 ..`
        and     #$07                            ; 927B 29 07                    ).
        bne     L9285                           ; 927D D0 06                    ..
        adc     $659C,y                         ; 927F 79 9C 65                 y.e
        sta     $659C,y                         ; 9282 99 9C 65                 ..e
L9285:  jsr     L9867                           ; 9285 20 67 98                  g.
L9288:  ldx     L99F8                           ; 9288 AE F8 99                 ...
        lda     #$00                            ; 928B A9 00                    ..
        sta     $60FC,x                         ; 928D 9D FC 60                 ..`
        jmp     L96D0                           ; 9290 4C D0 96                 L..

; ----------------------------------------------------------------------------
L9293:  ldy     $60C3                           ; 9293 AC C3 60                 ..`
        ldx     L99F8                           ; 9296 AE F8 99                 ...
        lda     L99FC,x                         ; 9299 BD FC 99                 ...
        sta     $61                             ; 929C 85 61                    .a
        ldx     #$00                            ; 929E A2 00                    ..
        lda     $64CC,y                         ; 92A0 B9 CC 64                 ..d
        beq     L92AD                           ; 92A3 F0 08                    ..
        lda     $64CC,y                         ; 92A5 B9 CC 64                 ..d
        bmi     L92BB                           ; 92A8 30 11                    0.
        inx                                     ; 92AA E8                       .
        bne     L92BB                           ; 92AB D0 0E                    ..
L92AD:  lda     $62C4,y                         ; 92AD B9 C4 62                 ..b
        cmp     #$97                            ; 92B0 C9 97                    ..
        bcc     L92B6                           ; 92B2 90 02                    ..
        sbc     #$97                            ; 92B4 E9 97                    ..
L92B6:  cmp     #$03                            ; 92B6 C9 03                    ..
        bcc     L92BB                           ; 92B8 90 01                    ..
        inx                                     ; 92BA E8                       .
L92BB:  stx     L0060                           ; 92BB 86 60                    .`
        ldx     #$01                            ; 92BD A2 01                    ..
        lda     $61                             ; 92BF A5 61                    .a
        beq     L92D2                           ; 92C1 F0 0F                    ..
        dex                                     ; 92C3 CA                       .
        lda     $64CC,y                         ; 92C4 B9 CC 64                 ..d
        beq     L92D2                           ; 92C7 F0 09                    ..
        lda     $64CC,y                         ; 92C9 B9 CC 64                 ..d
        eor     $61                             ; 92CC 45 61                    Ea
        bpl     L92D2                           ; 92CE 10 02                    ..
        ldx     #$02                            ; 92D0 A2 02                    ..
L92D2:  stx     $61                             ; 92D2 86 61                    .a
        lda     L0060                           ; 92D4 A5 60                    .`
        asl     a                               ; 92D6 0A                       .
        adc     L0060                           ; 92D7 65 60                    e`
        adc     $61                             ; 92D9 65 61                    ea
        tax                                     ; 92DB AA                       .
        lda     $6464,y                         ; 92DC B9 64 64                 .dd
        bpl     L92E9                           ; 92DF 10 08                    ..
        lda     L9985,x                         ; 92E1 BD 85 99                 ...
        asl     a                               ; 92E4 0A                       .
        adc     #$06                            ; 92E5 69 06                    i.
        bpl     L9308                           ; 92E7 10 1F                    ..
L92E9:  cmp     L9985,x                         ; 92E9 DD 85 99                 ...
        beq     L9307                           ; 92EC F0 19                    ..
        lda     $62C4,y                         ; 92EE B9 C4 62                 ..b
        cmp     #$97                            ; 92F1 C9 97                    ..
        bcc     L92F7                           ; 92F3 90 02                    ..
        sbc     #$97                            ; 92F5 E9 97                    ..
L92F7:  cmp     #$06                            ; 92F7 C9 06                    ..
        bcs     L9303                           ; 92F9 B0 08                    ..
        lda     $6464,y                         ; 92FB B9 64 64                 .dd
        asl     a                               ; 92FE 0A                       .
        adc     #$06                            ; 92FF 69 06                    i.
        bpl     L9308                           ; 9301 10 05                    ..
L9303:  lda     #$07                            ; 9303 A9 07                    ..
        bpl     L9308                           ; 9305 10 01                    ..
L9307:  txa                                     ; 9307 8A                       .
L9308:  sta     $62C4,y                         ; 9308 99 C4 62                 ..b
        tax                                     ; 930B AA                       .
        lda     L9985,x                         ; 930C BD 85 99                 ...
        sta     $6464,y                         ; 930F 99 64 64                 .dd
        lda     $04                             ; 9312 A5 04                    ..
        bne     L9324                           ; 9314 D0 0E                    ..
        lda     $6604,y                         ; 9316 B9 04 66                 ..f
        bne     L9324                           ; 9319 D0 09                    ..
        lda     $62C4,y                         ; 931B B9 C4 62                 ..b
        clc                                     ; 931E 18                       .
        adc     #$97                            ; 931F 69 97                    i.
        sta     $62C4,y                         ; 9321 99 C4 62                 ..b
L9324:  rts                                     ; 9324 60                       `

; ----------------------------------------------------------------------------
L9325:  lda     $604D                           ; 9325 AD 4D 60                 .M`
        sta     $60E3                           ; 9328 8D E3 60                 ..`
        lda     $604E                           ; 932B AD 4E 60                 .N`
        sta     $60E4                           ; 932E 8D E4 60                 ..`
        lda     $60C8                           ; 9331 AD C8 60                 ..`
        sta     $60E5                           ; 9334 8D E5 60                 ..`
        lda     $60C9                           ; 9337 AD C9 60                 ..`
        sta     $60E6                           ; 933A 8D E6 60                 ..`
L933D:  lda     $6042                           ; 933D AD 42 60                 .B`
        sta     $6043                           ; 9340 8D 43 60                 .C`
        sta     $60F1                           ; 9343 8D F1 60                 ..`
        lda     #$00                            ; 9346 A9 00                    ..
        sta     $6042                           ; 9348 8D 42 60                 .B`
        rts                                     ; 934B 60                       `

; ----------------------------------------------------------------------------
L934C:  ldy     $60C3                           ; 934C AC C3 60                 ..`
        ldx     $6604,y                         ; 934F BE 04 66                 ..f
        lda     $6108,x                         ; 9352 BD 08 61                 ..a
        beq     L9393                           ; 9355 F0 3C                    .<
        lda     $60FC,x                         ; 9357 BD FC 60                 ..`
        bne     L9380                           ; 935A D0 24                    .$
        lda     $60C1                           ; 935C AD C1 60                 ..`
        and     #$0F                            ; 935F 29 0F                    ).
        bne     L9380                           ; 9361 D0 1D                    ..
        lda     $63FC,y                         ; 9363 B9 FC 63                 ..c
        cmp     #$DD                            ; 9366 C9 DD                    ..
        bne     L9371                           ; 9368 D0 07                    ..
        lda     $60C1                           ; 936A AD C1 60                 ..`
        and     #$1F                            ; 936D 29 1F                    ).
        bne     L9380                           ; 936F D0 0F                    ..
L9371:  dec     $6108,x                         ; 9371 DE 08 61                 ..a
        bne     L9380                           ; 9374 D0 0A                    ..
        inc     $610A,x                         ; 9376 FE 0A 61                 ..a
        lda     #$00                            ; 9379 A9 00                    ..
        sta     $6534,y                         ; 937B 99 34 65                 .4e
        beq     L9393                           ; 937E F0 13                    ..
L9380:  jsr     L97AC                           ; 9380 20 AC 97                  ..
        php                                     ; 9383 08                       .
        jsr     L9293                           ; 9384 20 93 92                  ..
        lda     $60C6                           ; 9387 AD C6 60                 ..`
        bne     L938F                           ; 938A D0 03                    ..
        jsr     L93BA                           ; 938C 20 BA 93                  ..
L938F:  plp                                     ; 938F 28                       (
        bcs     L93AC                           ; 9390 B0 1A                    ..
        rts                                     ; 9392 60                       `

; ----------------------------------------------------------------------------
L9393:  lda     $6534,y                         ; 9393 B9 34 65                 .4e
        clc                                     ; 9396 18                       .
        adc     #$02                            ; 9397 69 02                    i.
        sta     $6534,y                         ; 9399 99 34 65                 .4e
        clc                                     ; 939C 18                       .
        adc     $63FC,y                         ; 939D 79 FC 63                 y.c
        sta     $63FC,y                         ; 93A0 99 FC 63                 ..c
        cmp     #$DD                            ; 93A3 C9 DD                    ..
        bcc     L93B7                           ; 93A5 90 10                    ..
        lda     #$DD                            ; 93A7 A9 DD                    ..
        sta     $63FC,y                         ; 93A9 99 FC 63                 ..c
L93AC:  ldy     $60C3                           ; 93AC AC C3 60                 ..`
        lda     #$00                            ; 93AF A9 00                    ..
        sta     $680C,y                         ; 93B1 99 0C 68                 ..h
        jmp     LAC0C                           ; 93B4 4C 0C AC                 L..

; ----------------------------------------------------------------------------
L93B7:  jmp     L7A12                           ; 93B7 4C 12 7A                 L.z

; ----------------------------------------------------------------------------
L93BA:  ldy     $60C3                           ; 93BA AC C3 60                 ..`
        ldx     $6604,y                         ; 93BD BE 04 66                 ..f
        stx     $60BD                           ; 93C0 8E BD 60                 ..`
        lda     $60FC,x                         ; 93C3 BD FC 60                 ..`
        bne     L9403                           ; 93C6 D0 3B                    .;
        lda     $63FC,y                         ; 93C8 B9 FC 63                 ..c
        cmp     #$DD                            ; 93CB C9 DD                    ..
        bne     L9404                           ; 93CD D0 35                    .5
        lda     $60E6                           ; 93CF AD E6 60                 ..`
        bpl     L9403                           ; 93D2 10 2F                    ./
        lda     $6100,x                         ; 93D4 BD 00 61                 ..a
        beq     L9403                           ; 93D7 F0 2A                    .*
        txa                                     ; 93D9 8A                       .
        eor     #$01                            ; 93DA 49 01                    I.
        asl     a                               ; 93DC 0A                       .
        adc     #$04                            ; 93DD 69 04                    i.
        adc     $6394,y                         ; 93DF 79 94 63                 y.c
        sta     $60CD                           ; 93E2 8D CD 60                 ..`
        lda     $632C,y                         ; 93E5 B9 2C 63                 .,c
        adc     #$00                            ; 93E8 69 00                    i.
        sta     $60CC                           ; 93EA 8D CC 60                 ..`
        dec     $6100,x                         ; 93ED DE 00 61                 ..a
        dec     $6118,x                         ; 93F0 DE 18 61                 ..a
        dec     $611E,x                         ; 93F3 DE 1E 61                 ..a
        lda     #$0D                            ; 93F6 A9 0D                    ..
        sta     $60A7                           ; 93F8 8D A7 60                 ..`
        lda     #$00                            ; 93FB A9 00                    ..
        sta     $60E1                           ; 93FD 8D E1 60                 ..`
        jmp     L6F0C                           ; 9400 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L9403:  rts                                     ; 9403 60                       `

; ----------------------------------------------------------------------------
L9404:  lda     $60E5                           ; 9404 AD E5 60                 ..`
        and     $60E6                           ; 9407 2D E6 60                 -.`
        bpl     L940F                           ; 940A 10 03                    ..
        jmp     L95F5                           ; 940C 4C F5 95                 L..

; ----------------------------------------------------------------------------
L940F:  bit     $60E5                           ; 940F 2C E5 60                 ,.`
        bpl     L9489                           ; 9412 10 75                    .u
        lda     $60F6,x                         ; 9414 BD F6 60                 ..`
        beq     L9488                           ; 9417 F0 6F                    .o
        lda     $62C4,y                         ; 9419 B9 C4 62                 ..b
        cmp     #$97                            ; 941C C9 97                    ..
        bcc     L9422                           ; 941E 90 02                    ..
        sbc     #$97                            ; 9420 E9 97                    ..
L9422:  cmp     #$07                            ; 9422 C9 07                    ..
        beq     L9488                           ; 9424 F0 62                    .b
        dec     $60F6,x                         ; 9426 DE F6 60                 ..`
        tax                                     ; 9429 AA                       .
        lda     $60EE                           ; 942A AD EE 60                 ..`
        beq     L9432                           ; 942D F0 03                    ..
        jmp     L98FD                           ; 942F 4C FD 98                 L..

; ----------------------------------------------------------------------------
L9432:  lda     #$00                            ; 9432 A9 00                    ..
        sta     L944E                           ; 9434 8D 4E 94                 .N.
        lda     L99BF,x                         ; 9437 BD BF 99                 ...
        sec                                     ; 943A 38                       8
        sbc     $64CC,y                         ; 943B F9 CC 64                 ..d
        bpl     L9443                           ; 943E 10 03                    ..
        dec     L944E                           ; 9440 CE 4E 94                 .N.
L9443:  clc                                     ; 9443 18                       .
        adc     $6394,y                         ; 9444 79 94 63                 y.c
        sta     $60CD                           ; 9447 8D CD 60                 ..`
        lda     $632C,y                         ; 944A B9 2C 63                 .,c
        .byte   $69                             ; 944D 69                       i
L944E:  brk                                     ; 944E 00                       .
        sta     $60CC                           ; 944F 8D CC 60                 ..`
        lda     $63FC,y                         ; 9452 B9 FC 63                 ..c
        clc                                     ; 9455 18                       .
        adc     L99C8,x                         ; 9456 7D C8 99                 }..
        sec                                     ; 9459 38                       8
        sbc     $6534,y                         ; 945A F9 34 65                 .4e
        sta     $60CE                           ; 945D 8D CE 60                 ..`
        lda     $64CC,y                         ; 9460 B9 CC 64                 ..d
        clc                                     ; 9463 18                       .
        adc     L99D1,x                         ; 9464 7D D1 99                 }..
        sta     $60CF                           ; 9467 8D CF 60                 ..`
        lda     L99DA,x                         ; 946A BD DA 99                 ...
        sta     $60D0                           ; 946D 8D D0 60                 ..`
        lda     $6604,y                         ; 9470 B9 04 66                 ..f
        sta     $60BD                           ; 9473 8D BD 60                 ..`
        lda     #$0B                            ; 9476 A9 0B                    ..
        sta     $60A7                           ; 9478 8D A7 60                 ..`
        lda     #$02                            ; 947B A9 02                    ..
        sta     $60B3                           ; 947D 8D B3 60                 ..`
        lda     #$00                            ; 9480 A9 00                    ..
        sta     $60A8                           ; 9482 8D A8 60                 ..`
        jmp     L6F0C                           ; 9485 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L9488:  rts                                     ; 9488 60                       `

; ----------------------------------------------------------------------------
L9489:  bit     $60E6                           ; 9489 2C E6 60                 ,.`
        bpl     L94C9                           ; 948C 10 3B                    .;
        ldy     $60C3                           ; 948E AC C3 60                 ..`
        ldx     $6604,y                         ; 9491 BE 04 66                 ..f
        stx     $60BD                           ; 9494 8E BD 60                 ..`
        lda     $60F4,x                         ; 9497 BD F4 60                 ..`
        beq     L94C9                           ; 949A F0 2D                    .-
        dec     $60F4,x                         ; 949C DE F4 60                 ..`
        lda     $6394,y                         ; 949F B9 94 63                 ..c
        clc                                     ; 94A2 18                       .
        adc     #$06                            ; 94A3 69 06                    i.
        sta     $60CD                           ; 94A5 8D CD 60                 ..`
        lda     $632C,y                         ; 94A8 B9 2C 63                 .,c
        adc     #$00                            ; 94AB 69 00                    i.
        sta     $60CC                           ; 94AD 8D CC 60                 ..`
        lda     $63FC,y                         ; 94B0 B9 FC 63                 ..c
        sta     $60CE                           ; 94B3 8D CE 60                 ..`
        lda     $64CC,y                         ; 94B6 B9 CC 64                 ..d
        sta     $60CF                           ; 94B9 8D CF 60                 ..`
        lda     #$00                            ; 94BC A9 00                    ..
        sta     $60D0                           ; 94BE 8D D0 60                 ..`
        lda     #$0A                            ; 94C1 A9 0A                    ..
        sta     $60A7                           ; 94C3 8D A7 60                 ..`
        jmp     L6F0C                           ; 94C6 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L94C9:  rts                                     ; 94C9 60                       `

; ----------------------------------------------------------------------------
L94CA:  cmp     #$00                            ; 94CA C9 00                    ..
        bmi     L94D3                           ; 94CC 30 05                    0.
        beq     L94D2                           ; 94CE F0 02                    ..
        lda     #$01                            ; 94D0 A9 01                    ..
L94D2:  rts                                     ; 94D2 60                       `

; ----------------------------------------------------------------------------
L94D3:  lda     #$FF                            ; 94D3 A9 FF                    ..
        rts                                     ; 94D5 60                       `

; ----------------------------------------------------------------------------
L94D6:  ldx     L99F8                           ; 94D6 AE F8 99                 ...
        stx     $60BD                           ; 94D9 8E BD 60                 ..`
        lda     $60F1                           ; 94DC AD F1 60                 ..`
        cmp     #$A0                            ; 94DF C9 A0                    ..
        bne     L950B                           ; 94E1 D0 28                    .(
        lda     $6104,x                         ; 94E3 BD 04 61                 ..a
        bne     L9506                           ; 94E6 D0 1E                    ..
        lda     $6100,x                         ; 94E8 BD 00 61                 ..a
        beq     L9508                           ; 94EB F0 1B                    ..
        ldy     $6112,x                         ; 94ED BC 12 61                 ..a
        lda     $63FC,y                         ; 94F0 B9 FC 63                 ..c
        cmp     #$D3                            ; 94F3 C9 D3                    ..
        bcs     L9506                           ; 94F5 B0 0F                    ..
        dec     $6118,x                         ; 94F7 DE 18 61                 ..a
        dec     $611E,x                         ; 94FA DE 1E 61                 ..a
        dec     $6100,x                         ; 94FD DE 00 61                 ..a
L9500:  jsr     L98C1                           ; 9500 20 C1 98                  ..
        ldx     L99F8                           ; 9503 AE F8 99                 ...
L9506:  lda     #$00                            ; 9506 A9 00                    ..
L9508:  sta     $60F1                           ; 9508 8D F1 60                 ..`
L950B:  cmp     #$C8                            ; 950B C9 C8                    ..
        bne     L9524                           ; 950D D0 15                    ..
        lda     $6117                           ; 950F AD 17 61                 ..a
        sbc     #$14                            ; 9512 E9 14                    ..
        bcc     L9524                           ; 9514 90 0E                    ..
        sta     $6117                           ; 9516 8D 17 61                 ..a
        inc     $60AB                           ; 9519 EE AB 60                 ..`
        lda     #$02                            ; 951C A9 02                    ..
        sta     $60A7                           ; 951E 8D A7 60                 ..`
        jmp     L95CB                           ; 9521 4C CB 95                 L..

; ----------------------------------------------------------------------------
L9524:  lda     $6110,x                         ; 9524 BD 10 61                 ..a
        beq     L9543                           ; 9527 F0 1A                    ..
        dec     $6110,x                         ; 9529 DE 10 61                 ..a
        bne     L9558                           ; 952C D0 2A                    .*
        lda     $60FE,x                         ; 952E BD FE 60                 ..`
        beq     L9543                           ; 9531 F0 10                    ..
        lda     #$0D                            ; 9533 A9 0D                    ..
        sta     $60A7                           ; 9535 8D A7 60                 ..`
        lda     $6047,x                         ; 9538 BD 47 60                 .G`
        asl     a                               ; 953B 0A                       .
        asl     a                               ; 953C 0A                       .
        tay                                     ; 953D A8                       .
        dec     $60FE,x                         ; 953E DE FE 60                 ..`
        bpl     L95A6                           ; 9541 10 63                    .c
L9543:  lda     $60F1                           ; 9543 AD F1 60                 ..`
        beq     L9558                           ; 9546 F0 10                    ..
        ldy     #$04                            ; 9548 A0 04                    ..
L954A:  cmp     L9971,y                         ; 954A D9 71 99                 .q.
        bne     L9555                           ; 954D D0 06                    ..
        lda     L9980,y                         ; 954F B9 80 99                 ...
        jmp     L9559                           ; 9552 4C 59 95                 LY.

; ----------------------------------------------------------------------------
L9555:  dey                                     ; 9555 88                       .
        bpl     L954A                           ; 9556 10 F2                    ..
L9558:  rts                                     ; 9558 60                       `

; ----------------------------------------------------------------------------
L9559:  sta     $60A7                           ; 9559 8D A7 60                 ..`
        lda     L9976,y                         ; 955C B9 76 99                 .v.
        clc                                     ; 955F 18                       .
        adc     L99F8                           ; 9560 6D F8 99                 m..
        stx     L0060                           ; 9563 86 60                    .`
        tax                                     ; 9565 AA                       .
        lda     $6118,x                         ; 9566 BD 18 61                 ..a
        cmp     L997B,y                         ; 9569 D9 7B 99                 .{.
        ldx     L0060                           ; 956C A6 60                    .`
        bcs     L9558                           ; 956E B0 E8                    ..
        lda     L996C,y                         ; 9570 B9 6C 99                 .l.
        sta     L99FB                           ; 9573 8D FB 99                 ...
        lda     $6116,x                         ; 9576 BD 16 61                 ..a
        sec                                     ; 9579 38                       8
        sbc     L99FB                           ; 957A ED FB 99                 ...
        bcc     L9558                           ; 957D 90 D9                    ..
        sta     $6116,x                         ; 957F 9D 16 61                 ..a
        lda     #$80                            ; 9582 A9 80                    ..
        cpy     #$04                            ; 9584 C0 04                    ..
        adc     #$00                            ; 9586 69 00                    i.
        sta     $6047,x                         ; 9588 9D 47 60                 .G`
        lda     $60A7                           ; 958B AD A7 60                 ..`
        cmp     #$0D                            ; 958E C9 0D                    ..
        bne     L95A6                           ; 9590 D0 14                    ..
        sty     L0060                           ; 9592 84 60                    .`
        tya                                     ; 9594 98                       .
        bne     L959B                           ; 9595 D0 04                    ..
        ldy     #$05                            ; 9597 A0 05                    ..
        bne     L959D                           ; 9599 D0 02                    ..
L959B:  ldy     #$02                            ; 959B A0 02                    ..
L959D:  dey                                     ; 959D 88                       .
        tya                                     ; 959E 98                       .
        sbc     #$00                            ; 959F E9 00                    ..
        sta     $60FE,x                         ; 95A1 9D FE 60                 ..`
        ldy     L0060                           ; 95A4 A4 60                    .`
L95A6:  lda     $6047,x                         ; 95A6 BD 47 60                 .G`
        sta     $60E1                           ; 95A9 8D E1 60                 ..`
        lda     #$11                            ; 95AC A9 11                    ..
        cpy     #$04                            ; 95AE C0 04                    ..
        bne     L95B4                           ; 95B0 D0 02                    ..
        lda     #$07                            ; 95B2 A9 07                    ..
L95B4:  sta     $6110,x                         ; 95B4 9D 10 61                 ..a
        ldx     $60BD                           ; 95B7 AE BD 60                 ..`
        lda     L99F4,x                         ; 95BA BD F4 99                 ...
        sta     $60CD                           ; 95BD 8D CD 60                 ..`
        lda     L99F6,x                         ; 95C0 BD F6 99                 ...
        sta     $60CC                           ; 95C3 8D CC 60                 ..`
        lda     $60BD                           ; 95C6 AD BD 60                 ..`
        beq     L95DA                           ; 95C9 F0 0F                    ..
L95CB:  lda     #$00                            ; 95CB A9 00                    ..
        ldx     $60A7                           ; 95CD AE A7 60                 ..`
        jsr     L690C                           ; 95D0 20 0C 69                  .i
        lda     $60A7                           ; 95D3 AD A7 60                 ..`
        cmp     #$02                            ; 95D6 C9 02                    ..
        beq     L95EE                           ; 95D8 F0 14                    ..
L95DA:  lda     $60B6                           ; 95DA AD B6 60                 ..`
        bne     L95EB                           ; 95DD D0 0C                    ..
        lda     $60BD                           ; 95DF AD BD 60                 ..`
        beq     L95EB                           ; 95E2 F0 07                    ..
        lda     #$20                            ; 95E4 A9 20                    . 
        ldy     #$10                            ; 95E6 A0 10                    ..
        jsr     L6903                           ; 95E8 20 03 69                  .i
L95EB:  jmp     L6F0C                           ; 95EB 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L95EE:  lda     #$20                            ; 95EE A9 20                    . 
        ldy     #$10                            ; 95F0 A0 10                    ..
        jmp     L6903                           ; 95F2 4C 03 69                 L.i

; ----------------------------------------------------------------------------
L95F5:  ldy     $60C3                           ; 95F5 AC C3 60                 ..`
        ldx     $6604,y                         ; 95F8 BE 04 66                 ..f
        lda     $604B,x                         ; 95FB BD 4B 60                 .K`
        bne     L9605                           ; 95FE D0 05                    ..
        lda     $6102,x                         ; 9600 BD 02 61                 ..a
        bne     L9606                           ; 9603 D0 01                    ..
L9605:  rts                                     ; 9605 60                       `

; ----------------------------------------------------------------------------
L9606:  jsr     L9650                           ; 9606 20 50 96                  P.
        bcc     L9605                           ; 9609 90 FA                    ..
L960B:  ldy     $60C3                           ; 960B AC C3 60                 ..`
        lda     $632C,y                         ; 960E B9 2C 63                 .,c
        sta     $60CC                           ; 9611 8D CC 60                 ..`
        lda     $6394,y                         ; 9614 B9 94 63                 ..c
        sta     $60CD                           ; 9617 8D CD 60                 ..`
        lda     $63FC,y                         ; 961A B9 FC 63                 ..c
        sec                                     ; 961D 38                       8
        sbc     #$03                            ; 961E E9 03                    ..
        sta     $60CE                           ; 9620 8D CE 60                 ..`
        lda     $64CC,y                         ; 9623 B9 CC 64                 ..d
        bne     L962E                           ; 9626 D0 06                    ..
        lda     $64                             ; 9628 A5 64                    .d
        bne     L962E                           ; 962A D0 02                    ..
        lda     #$FF                            ; 962C A9 FF                    ..
L962E:  sta     $60CF                           ; 962E 8D CF 60                 ..`
        ldx     $6604,y                         ; 9631 BE 04 66                 ..f
        stx     $60BD                           ; 9634 8E BD 60                 ..`
        dec     $6102,x                         ; 9637 DE 02 61                 ..a
        lda     #$03                            ; 963A A9 03                    ..
        sta     $604B,x                         ; 963C 9D 4B 60                 .K`
        lda     #$12                            ; 963F A9 12                    ..
        sta     $60A7                           ; 9641 8D A7 60                 ..`
        ldx     $60A8                           ; 9644 AE A8 60                 ..`
        lda     $6124,x                         ; 9647 BD 24 61                 .$a
        sta     $60AF                           ; 964A 8D AF 60                 ..`
        jmp     L6F0C                           ; 964D 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L9650:  ldy     $60C3                           ; 9650 AC C3 60                 ..`
        lda     $6464,y                         ; 9653 B9 64 64                 .dd
        bmi     L966F                           ; 9656 30 17                    0.
        sta     $64                             ; 9658 85 64                    .d
        lda     $63FC,y                         ; 965A B9 FC 63                 ..c
        sec                                     ; 965D 38                       8
        sbc     L6937                           ; 965E ED 37 69                 .7i
        sta     $60CE                           ; 9661 8D CE 60                 ..`
        tya                                     ; 9664 98                       .
        tax                                     ; 9665 AA                       .
L9666:  lda     $64                             ; 9666 A5 64                    .d
        bne     L9671                           ; 9668 D0 07                    ..
        lda     $61F4,x                         ; 966A BD F4 61                 ..a
        bpl     L9676                           ; 966D 10 07                    ..
L966F:  clc                                     ; 966F 18                       .
        rts                                     ; 9670 60                       `

; ----------------------------------------------------------------------------
L9671:  lda     $625C,x                         ; 9671 BD 5C 62                 .\b
        bmi     L966F                           ; 9674 30 F9                    0.
L9676:  tax                                     ; 9676 AA                       .
        ldy     $60C3                           ; 9677 AC C3 60                 ..`
        lda     $6604,x                         ; 967A BD 04 66                 ..f
        cmp     $6604,y                         ; 967D D9 04 66                 ..f
        beq     L9666                           ; 9680 F0 E4                    ..
        lda     $659C,x                         ; 9682 BD 9C 65                 ..e
        beq     L9666                           ; 9685 F0 DF                    ..
        lda     $63FC,x                         ; 9687 BD FC 63                 ..c
        cmp     $60CE                           ; 968A CD CE 60                 ..`
        bcc     L9666                           ; 968D 90 D7                    ..
        ldy     $6124,x                         ; 968F BC 24 61                 .$a
        cpy     #$08                            ; 9692 C0 08                    ..
        beq     L9666                           ; 9694 F0 D0                    ..
        cpy     #$0B                            ; 9696 C0 0B                    ..
        beq     L9666                           ; 9698 F0 CC                    ..
        cpy     #$0A                            ; 969A C0 0A                    ..
        beq     L9666                           ; 969C F0 C8                    ..
        cpy     #$12                            ; 969E C0 12                    ..
        beq     L9666                           ; 96A0 F0 C4                    ..
        cpy     #$1A                            ; 96A2 C0 1A                    ..
        beq     L9666                           ; 96A4 F0 C0                    ..
        cpy     #$02                            ; 96A6 C0 02                    ..
        bne     L96BF                           ; 96A8 D0 15                    ..
        stx     $60A8                           ; 96AA 8E A8 60                 ..`
        sta     L0060                           ; 96AD 85 60                    .`
        lda     $6604,x                         ; 96AF BD 04 66                 ..f
        tax                                     ; 96B2 AA                       .
        lda     $6104,x                         ; 96B3 BD 04 61                 ..a
        php                                     ; 96B6 08                       .
        ldx     $60A8                           ; 96B7 AE A8 60                 ..`
        plp                                     ; 96BA 28                       (
        bne     L9666                           ; 96BB D0 A9                    ..
        lda     L0060                           ; 96BD A5 60                    .`
L96BF:  sec                                     ; 96BF 38                       8
        sbc     L6935,y                         ; 96C0 F9 35 69                 .5i
        ldy     $60C3                           ; 96C3 AC C3 60                 ..`
        cmp     $63FC,y                         ; 96C6 D9 FC 63                 ..c
        bcs     L9666                           ; 96C9 B0 9B                    ..
        stx     $60A8                           ; 96CB 8E A8 60                 ..`
        sec                                     ; 96CE 38                       8
        rts                                     ; 96CF 60                       `

; ----------------------------------------------------------------------------
L96D0:  ldy     $60C3                           ; 96D0 AC C3 60                 ..`
        ldx     $6604,y                         ; 96D3 BE 04 66                 ..f
        lda     #$00                            ; 96D6 A9 00                    ..
        sta     $610C,x                         ; 96D8 9D 0C 61                 ..a
        lda     $63FC,y                         ; 96DB B9 FC 63                 ..c
        cmp     #$DA                            ; 96DE C9 DA                    ..
        bcs     L96E3                           ; 96E0 B0 01                    ..
        rts                                     ; 96E2 60                       `

; ----------------------------------------------------------------------------
L96E3:  lda     $632C,y                         ; 96E3 B9 2C 63                 .,c
        cmp     #$02                            ; 96E6 C9 02                    ..
        beq     L9707                           ; 96E8 F0 1D                    ..
        cmp     #$0D                            ; 96EA C9 0D                    ..
        beq     L9707                           ; 96EC F0 19                    ..
        cmp     #$07                            ; 96EE C9 07                    ..
        bne     L9706                           ; 96F0 D0 14                    ..
        lda     $60E8                           ; 96F2 AD E8 60                 ..`
        beq     L9706                           ; 96F5 F0 0F                    ..
        lda     $6394,y                         ; 96F7 B9 94 63                 ..c
        sec                                     ; 96FA 38                       8
        sbc     #$F0                            ; 96FB E9 F0                    ..
        sta     L0060                           ; 96FD 85 60                    .`
        lda     $632C,y                         ; 96FF B9 2C 63                 .,c
        sbc     #$07                            ; 9702 E9 07                    ..
        bcs     L971C                           ; 9704 B0 16                    ..
L9706:  rts                                     ; 9706 60                       `

; ----------------------------------------------------------------------------
L9707:  lda     $6106,x                         ; 9707 BD 06 61                 ..a
        tax                                     ; 970A AA                       .
        lda     $6394,y                         ; 970B B9 94 63                 ..c
        sec                                     ; 970E 38                       8
        sbc     $6394,x                         ; 970F FD 94 63                 ..c
        sta     L0060                           ; 9712 85 60                    .`
        lda     $632C,y                         ; 9714 B9 2C 63                 .,c
        sbc     $632C,x                         ; 9717 FD 2C 63                 .,c
        bne     L9706                           ; 971A D0 EA                    ..
L971C:  lda     L0060                           ; 971C A5 60                    .`
        cmp     #$05                            ; 971E C9 05                    ..
        bcc     L9706                           ; 9720 90 E4                    ..
        cmp     #$0E                            ; 9722 C9 0E                    ..
        bcs     L9706                           ; 9724 B0 E0                    ..
        ldx     $6604,y                         ; 9726 BE 04 66                 ..f
        lda     $6108,x                         ; 9729 BD 08 61                 ..a
        beq     L9706                           ; 972C F0 D8                    ..
        inc     $60FC,x                         ; 972E FE FC 60                 ..`
        lda     #$DB                            ; 9731 A9 DB                    ..
        sta     $63FC,y                         ; 9733 99 FC 63                 ..c
        lda     #$00                            ; 9736 A9 00                    ..
        sta     L0060                           ; 9738 85 60                    .`
        lda     $659C,y                         ; 973A B9 9C 65                 ..e
        cmp     #$0F                            ; 973D C9 0F                    ..
        beq     L9751                           ; 973F F0 10                    ..
        lda     $60C1                           ; 9741 AD C1 60                 ..`
        and     #$03                            ; 9744 29 03                    ).
        bne     L974F                           ; 9746 D0 07                    ..
        sec                                     ; 9748 38                       8
        adc     $659C,y                         ; 9749 79 9C 65                 y.e
        sta     $659C,y                         ; 974C 99 9C 65                 ..e
L974F:  inc     L0060                           ; 974F E6 60                    .`
L9751:  lda     $6108,x                         ; 9751 BD 08 61                 ..a
        cmp     #$80                            ; 9754 C9 80                    ..
        beq     L975D                           ; 9756 F0 05                    ..
        inc     $6108,x                         ; 9758 FE 08 61                 ..a
        inc     L0060                           ; 975B E6 60                    .`
L975D:  lda     $60EE                           ; 975D AD EE 60                 ..`
        bne     L976B                           ; 9760 D0 09                    ..
        lda     $60F6,x                         ; 9762 BD F6 60                 ..`
        cmp     #$40                            ; 9765 C9 40                    .@
        beq     L977E                           ; 9767 F0 15                    ..
        bne     L9779                           ; 9769 D0 0E                    ..
L976B:  lda     $60F6,x                         ; 976B BD F6 60                 ..`
        cmp     #$06                            ; 976E C9 06                    ..
        beq     L977E                           ; 9770 F0 0C                    ..
        lda     $60C1                           ; 9772 AD C1 60                 ..`
        and     #$07                            ; 9775 29 07                    ).
        bne     L977C                           ; 9777 D0 03                    ..
L9779:  inc     $60F6,x                         ; 9779 FE F6 60                 ..`
L977C:  inc     L0060                           ; 977C E6 60                    .`
L977E:  lda     $60F4,x                         ; 977E BD F4 60                 ..`
        cmp     #$0A                            ; 9781 C9 0A                    ..
        beq     L9791                           ; 9783 F0 0C                    ..
        inc     L0060                           ; 9785 E6 60                    .`
        lda     $60C1                           ; 9787 AD C1 60                 ..`
        and     #$03                            ; 978A 29 03                    ).
        bne     L9791                           ; 978C D0 03                    ..
        inc     $60F4,x                         ; 978E FE F4 60                 ..`
L9791:  lda     $6102,x                         ; 9791 BD 02 61                 ..a
        cmp     #$02                            ; 9794 C9 02                    ..
        beq     L97A4                           ; 9796 F0 0C                    ..
        inc     L0060                           ; 9798 E6 60                    .`
        lda     $60C1                           ; 979A AD C1 60                 ..`
        and     #$0F                            ; 979D 29 0F                    ).
        bne     L97A4                           ; 979F D0 03                    ..
        inc     $6102,x                         ; 97A1 FE 02 61                 ..a
L97A4:  lda     L0060                           ; 97A4 A5 60                    .`
        bne     L97AB                           ; 97A6 D0 03                    ..
        inc     $610C,x                         ; 97A8 FE 0C 61                 ..a
L97AB:  rts                                     ; 97AB 60                       `

; ----------------------------------------------------------------------------
L97AC:  ldy     $60C3                           ; 97AC AC C3 60                 ..`
        lda     $60E4                           ; 97AF AD E4 60                 ..`
        ldx     #$00                            ; 97B2 A2 00                    ..
        cmp     $63FC,y                         ; 97B4 D9 FC 63                 ..c
        beq     L97D4                           ; 97B7 F0 1B                    ..
        bcs     L97BD                           ; 97B9 B0 02                    ..
        ldx     #$E0                            ; 97BB A2 E0                    ..
L97BD:  sec                                     ; 97BD 38                       8
        sbc     $63FC,y                         ; 97BE F9 FC 63                 ..c
        lsr     a                               ; 97C1 4A                       J
        lsr     a                               ; 97C2 4A                       J
        lsr     a                               ; 97C3 4A                       J
        sta     L0060                           ; 97C4 85 60                    .`
        txa                                     ; 97C6 8A                       .
        ora     L0060                           ; 97C7 05 60                    .`
        bne     L97CD                           ; 97C9 D0 02                    ..
        lda     #$01                            ; 97CB A9 01                    ..
L97CD:  sta     $6534,y                         ; 97CD 99 34 65                 .4e
        clc                                     ; 97D0 18                       .
        adc     $63FC,y                         ; 97D1 79 FC 63                 y.c
L97D4:  cmp     #$DD                            ; 97D4 C9 DD                    ..
        bcc     L97F7                           ; 97D6 90 1F                    ..
        lda     $64CC,y                         ; 97D8 B9 CC 64                 ..d
        cmp     #$07                            ; 97DB C9 07                    ..
        beq     L97E3                           ; 97DD F0 04                    ..
        cmp     #$F9                            ; 97DF C9 F9                    ..
        bne     L97E5                           ; 97E1 D0 02                    ..
L97E3:  sec                                     ; 97E3 38                       8
        .byte   $90                             ; 97E4 90                       .
L97E5:  clc                                     ; 97E5 18                       .
        lda     #$00                            ; 97E6 A9 00                    ..
        sta     $64CC,y                         ; 97E8 99 CC 64                 ..d
        ldx     L99F8                           ; 97EB AE F8 99                 ...
        sta     L99FC,x                         ; 97EE 9D FC 99                 ...
        lda     #$DD                            ; 97F1 A9 DD                    ..
        sta     $63FC,y                         ; 97F3 99 FC 63                 ..c
        rts                                     ; 97F6 60                       `

; ----------------------------------------------------------------------------
L97F7:  sta     $63FC,y                         ; 97F7 99 FC 63                 ..c
        lda     $64CC,y                         ; 97FA B9 CC 64                 ..d
        cmp     #$07                            ; 97FD C9 07                    ..
        .byte   $F0                             ; 97FF F0                       .
L9800:  php                                     ; 9800 08                       .
        cmp     #$F9                            ; 9801 C9 F9                    ..
        bne     L980E                           ; 9803 D0 09                    ..
        lda     #$FA                            ; 9805 A9 FA                    ..
        bne     L980B                           ; 9807 D0 02                    ..
        lda     #$06                            ; 9809 A9 06                    ..
L980B:  sta     $64CC,y                         ; 980B 99 CC 64                 ..d
L980E:  ldx     L99F8                           ; 980E AE F8 99                 ...
        lda     $60FC,x                         ; 9811 BD FC 60                 ..`
        beq     L981E                           ; 9814 F0 08                    ..
        lda     #$00                            ; 9816 A9 00                    ..
        sta     $64CC,y                         ; 9818 99 CC 64                 ..d
        sta     $60E3                           ; 981B 8D E3 60                 ..`
L981E:  lda     $60E3                           ; 981E AD E3 60                 ..`
        sec                                     ; 9821 38                       8
        sbc     $64CC,y                         ; 9822 F9 CC 64                 ..d
        jsr     L94CA                           ; 9825 20 CA 94                  ..
        sta     L99FC,x                         ; 9828 9D FC 99                 ...
        clc                                     ; 982B 18                       .
        ldx     #$00                            ; 982C A2 00                    ..
        adc     $64CC,y                         ; 982E 79 CC 64                 y.d
        sta     $64CC,y                         ; 9831 99 CC 64                 ..d
        bpl     L9837                           ; 9834 10 01                    ..
        dex                                     ; 9836 CA                       .
L9837:  clc                                     ; 9837 18                       .
        adc     $6394,y                         ; 9838 79 94 63                 y.c
        sta     L0060                           ; 983B 85 60                    .`
        txa                                     ; 983D 8A                       .
        adc     $632C,y                         ; 983E 79 2C 63                 y,c
        sta     $632C,y                         ; 9841 99 2C 63                 .,c
        cmp     #$02                            ; 9844 C9 02                    ..
        bne     L9853                           ; 9846 D0 0B                    ..
        lda     L0060                           ; 9848 A5 60                    .`
        cmp     #$30                            ; 984A C9 30                    .0
        bcc     L9862                           ; 984C 90 14                    ..
        sta     $6394,y                         ; 984E 99 94 63                 ..c
        bcs     L9862                           ; 9851 B0 0F                    ..
L9853:  cmp     #$0D                            ; 9853 C9 0D                    ..
        bne     L985D                           ; 9855 D0 06                    ..
        lda     L0060                           ; 9857 A5 60                    .`
        cmp     #$D0                            ; 9859 C9 D0                    ..
        bcs     L9862                           ; 985B B0 05                    ..
L985D:  lda     L0060                           ; 985D A5 60                    .`
        sta     $6394,y                         ; 985F 99 94 63                 ..c
L9862:  jsr     L7A0C                           ; 9862 20 0C 7A                  .z
        clc                                     ; 9865 18                       .
        rts                                     ; 9866 60                       `

; ----------------------------------------------------------------------------
L9867:  lda     $60C1                           ; 9867 AD C1 60                 ..`
        and     #$07                            ; 986A 29 07                    ).
        beq     L987A                           ; 986C F0 0C                    ..
        ldx     $659C,y                         ; 986E BE 9C 65                 ..e
        cpx     #$07                            ; 9871 E0 07                    ..
        bcs     L9879                           ; 9873 B0 04                    ..
        and     #$03                            ; 9875 29 03                    ).
        beq     L987A                           ; 9877 F0 01                    ..
L9879:  rts                                     ; 9879 60                       `

; ----------------------------------------------------------------------------
L987A:  lda     $62C4,y                         ; 987A B9 C4 62                 ..b
        cmp     #$97                            ; 987D C9 97                    ..
        bcc     L9883                           ; 987F 90 02                    ..
        sbc     #$97                            ; 9881 E9 97                    ..
L9883:  tax                                     ; 9883 AA                       .
        lda     $6394,y                         ; 9884 B9 94 63                 ..c
        clc                                     ; 9887 18                       .
        adc     L99AD,x                         ; 9888 7D AD 99                 }..
        sta     $60CD                           ; 988B 8D CD 60                 ..`
        lda     $632C,y                         ; 988E B9 2C 63                 .,c
        adc     #$00                            ; 9891 69 00                    i.
        .byte   $8D                             ; 9893 8D                       .
        .byte   $CC                             ; 9894 CC                       .
L9895:  rts                                     ; 9895 60                       `

; ----------------------------------------------------------------------------
        lda     $63FC,y                         ; 9896 B9 FC 63                 ..c
        clc                                     ; 9899 18                       .
        adc     L99B6,x                         ; 989A 7D B6 99                 }..
        sta     $60CE                           ; 989D 8D CE 60                 ..`
        lda     #$15                            ; 98A0 A9 15                    ..
        sta     $60A7                           ; 98A2 8D A7 60                 ..`
        ldx     #$01                            ; 98A5 A2 01                    ..
        lda     $659C,y                         ; 98A7 B9 9C 65                 ..e
        cmp     #$0A                            ; 98AA C9 0A                    ..
        bcs     L98B4                           ; 98AC B0 06                    ..
        inx                                     ; 98AE E8                       .
        cmp     #$05                            ; 98AF C9 05                    ..
        bcs     L98B4                           ; 98B1 B0 01                    ..
        inx                                     ; 98B3 E8                       .
L98B4:  stx     $60A8                           ; 98B4 8E A8 60                 ..`
        jmp     L6F0C                           ; 98B7 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L98BA:  ldx     $6604,y                         ; 98BA BE 04 66                 ..f
        inc     $610A,x                         ; 98BD FE 0A 61                 ..a
        rts                                     ; 98C0 60                       `

; ----------------------------------------------------------------------------
L98C1:  ldy     $6112,x                         ; 98C1 BC 12 61                 ..a
        stx     $60BD                           ; 98C4 8E BD 60                 ..`
        lda     $6394,y                         ; 98C7 B9 94 63                 ..c
        clc                                     ; 98CA 18                       .
        adc     #$05                            ; 98CB 69 05                    i.
        sta     $60CD                           ; 98CD 8D CD 60                 ..`
        lda     $632C,y                         ; 98D0 B9 2C 63                 .,c
        adc     #$00                            ; 98D3 69 00                    i.
        sta     $60CC                           ; 98D5 8D CC 60                 ..`
        lda     $63FC,y                         ; 98D8 B9 FC 63                 ..c
        sta     $60CE                           ; 98DB 8D CE 60                 ..`
        lda     #$19                            ; 98DE A9 19                    ..
        sta     $60A7                           ; 98E0 8D A7 60                 ..`
        jmp     L6F0C                           ; 98E3 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
        bit     $6046                           ; 98E6 2C 46 60                 ,F`
        bpl     L98EE                           ; 98E9 10 03                    ..
        inc     $60AB                           ; 98EB EE AB 60                 ..`
L98EE:  rts                                     ; 98EE 60                       `

; ----------------------------------------------------------------------------
        bit     $6046                           ; 98EF 2C 46 60                 ,F`
        bpl     L98FC                           ; 98F2 10 08                    ..
        lda     $60A6                           ; 98F4 AD A6 60                 ..`
        eor     #$FF                            ; 98F7 49 FF                    I.
        sta     $60A6                           ; 98F9 8D A6 60                 ..`
L98FC:  rts                                     ; 98FC 60                       `

; ----------------------------------------------------------------------------
L98FD:  lda     L99E3,x                         ; 98FD BD E3 99                 ...
L9900:  beq     L992A                           ; 9900 F0 28                    .(
        sta     $60CF                           ; 9902 8D CF 60                 ..`
        lda     #$05                            ; 9905 A9 05                    ..
        clc                                     ; 9907 18                       .
        adc     $6394,y                         ; 9908 79 94 63                 y.c
        sta     $60CD                           ; 990B 8D CD 60                 ..`
        lda     $632C,y                         ; 990E B9 2C 63                 .,c
        adc     #$00                            ; 9911 69 00                    i.
        sta     $60CC                           ; 9913 8D CC 60                 ..`
        lda     $63FC,y                         ; 9916 B9 FC 63                 ..c
        sec                                     ; 9919 38                       8
        sbc     #$02                            ; 991A E9 02                    ..
        sta     $60CE                           ; 991C 8D CE 60                 ..`
        lda     #$1A                            ; 991F A9 1A                    ..
        sta     $60A7                           ; 9921 8D A7 60                 ..`
        jmp     L6F0C                           ; 9924 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
L9927:  inc     $6001                           ; 9927 EE 01 60                 ..`
L992A:  rts                                     ; 992A 60                       `

; ----------------------------------------------------------------------------
        bit     $6046                           ; 992B 2C 46 60                 ,F`
        bpl     L992A                           ; 992E 10 FA                    ..
        lda     $60BA                           ; 9930 AD BA 60                 ..`
        eor     #$FF                            ; 9933 49 FF                    I.
        sta     $60BA                           ; 9935 8D BA 60                 ..`
        rts                                     ; 9938 60                       `

; ----------------------------------------------------------------------------
L9939:  cmp     $C1D4                           ; 9939 CD D4 C1                 ...
        cpy     $C5                             ; 993C C4 C5                    ..
        iny                                     ; 993E C8                       .
        ldy     #$C3                            ; 993F A0 C3                    ..
        .byte   $9B                             ; 9941 9B                       .
        .byte   $92                             ; 9942 92                       .
        dex                                     ; 9943 CA                       .
        .byte   $CB                             ; 9944 CB                       .
        cpy     L8DAF                           ; 9945 CC AF 8D                 ...
        .byte   $AD                             ; 9948 AD                       .
        .byte   $81                             ; 9949 81                       .
L994A:  .byte   $83                             ; 994A 83                       .
L994B:  .byte   $8F                             ; 994B 8F                       .
        .byte   $83                             ; 994C 83                       .
        .byte   $8F                             ; 994D 8F                       .
        .byte   $83                             ; 994E 83                       .
        .byte   $8F                             ; 994F 8F                       .
        .byte   $83                             ; 9950 83                       .
        .byte   $8F                             ; 9951 8F                       .
        .byte   $83                             ; 9952 83                       .
        .byte   $8F                             ; 9953 8F                       .
        .byte   $83                             ; 9954 83                       .
        .byte   $8F                             ; 9955 8F                       .
        .byte   $83                             ; 9956 83                       .
        .byte   $8F                             ; 9957 8F                       .
        ror     $8F,x                           ; 9958 76 8F                    v.
        .byte   $93                             ; 995A 93                       .
        .byte   $8F                             ; 995B 8F                       .
        .byte   $7A                             ; 995C 7A                       z
        .byte   $8F                             ; 995D 8F                       .
        inc     $F48F                           ; 995E EE 8F F4                 ...
        .byte   $8F                             ; 9961 8F                       .
        .byte   $FA                             ; 9962 FA                       .
        .byte   $8F                             ; 9963 8F                       .
        inc     $98                             ; 9964 E6 98                    ..
        .byte   $EF                             ; 9966 EF                       .
        tya                                     ; 9967 98                       .
        cmp     $8F                             ; 9968 C5 8F                    ..
        .byte   $2B                             ; 996A 2B                       +
        .byte   $99                             ; 996B 99                       .
L996C:  ora     $04                             ; 996C 05 04                    ..
        .byte   $03                             ; 996E 03                       .
        .byte   $02                             ; 996F 02                       .
        .byte   $05                             ; 9970 05                       .
L9971:  cmp     $C1D4                           ; 9971 CD D4 C1                 ...
        cpy     $C5                             ; 9974 C4 C5                    ..
L9976:  asl     $08                             ; 9976 06 08                    ..
        .byte   $02                             ; 9978 02                       .
        asl     a                               ; 9979 0A                       .
        .byte   $06                             ; 997A 06                       .
L997B:  .byte   $1A                             ; 997B 1A                       .
        asl     $07                             ; 997C 06 07                    ..
        php                                     ; 997E 08                       .
        .byte   $1D                             ; 997F 1D                       .
L9980:  ora     $0F0E                           ; 9980 0D 0E 0F                 ...
        bpl     L9992                           ; 9983 10 0D                    ..
L9985:  brk                                     ; 9985 00                       .
        brk                                     ; 9986 00                       .
        brk                                     ; 9987 00                       .
        ora     ($01,x)                         ; 9988 01 01                    ..
        ora     (L0000,x)                       ; 998A 01 00                    ..
        .byte   $80                             ; 998C 80                       .
        .byte   $01                             ; 998D 01                       .
L998E:  sbc     $FAF9,y                         ; 998E F9 F9 FA                 ...
        .byte   $FB                             ; 9991 FB                       .
L9992:  .byte   $FC                             ; 9992 FC                       .
        sbc     $FEFE,x                         ; 9993 FD FE FE                 ...
        .byte   $FF                             ; 9996 FF                       .
        .byte   $FF                             ; 9997 FF                       .
        brk                                     ; 9998 00                       .
L9999:  brk                                     ; 9999 00                       .
        brk                                     ; 999A 00                       .
        brk                                     ; 999B 00                       .
        brk                                     ; 999C 00                       .
        ora     ($01,x)                         ; 999D 01 01                    ..
        .byte   $02                             ; 999F 02                       .
        .byte   $02                             ; 99A0 02                       .
        .byte   $03                             ; 99A1 03                       .
        .byte   $04                             ; 99A2 04                       .
        ora     $06                             ; 99A3 05 06                    ..
        .byte   $07                             ; 99A5 07                       .
        .byte   $07                             ; 99A6 07                       .
        .byte   $07                             ; 99A7 07                       .
L99A8:  cmp     $D0D0,y                         ; 99A8 D9 D0 D0                 ...
        cmp     #$DA                            ; 99AB C9 DA                    ..
L99AD:  asl     a                               ; 99AD 0A                       .
        ora     #$0A                            ; 99AE 09 0A                    ..
        brk                                     ; 99B0 00                       .
        brk                                     ; 99B1 00                       .
        brk                                     ; 99B2 00                       .
        .byte   $07                             ; 99B3 07                       .
        brk                                     ; 99B4 00                       .
        .byte   $03                             ; 99B5 03                       .
L99B6:  .byte   $FA                             ; 99B6 FA                       .
        inc     $FAFF,x                         ; 99B7 FE FF FA                 ...
        inc     $FEFF,x                         ; 99BA FE FF FE                 ...
        brk                                     ; 99BD 00                       .
        .byte   $FE                             ; 99BE FE                       .
L99BF:  .byte   $FF                             ; 99BF FF                       .
        .byte   $FF                             ; 99C0 FF                       .
        .byte   $FF                             ; 99C1 FF                       .
        .byte   $0B                             ; 99C2 0B                       .
        .byte   $0B                             ; 99C3 0B                       .
        .byte   $0B                             ; 99C4 0B                       .
        .byte   $FF                             ; 99C5 FF                       .
        brk                                     ; 99C6 00                       .
        .byte   $0B                             ; 99C7 0B                       .
L99C8:  inc     $F8FC,x                         ; 99C8 FE FC F8                 ...
        inc     $F8FC,x                         ; 99CB FE FC F8                 ...
        .byte   $FC                             ; 99CE FC                       .
        brk                                     ; 99CF 00                       .
        .byte   $FC                             ; 99D0 FC                       .
L99D1:  sed                                     ; 99D1 F8                       .
        sed                                     ; 99D2 F8                       .
        sed                                     ; 99D3 F8                       .
        php                                     ; 99D4 08                       .
        php                                     ; 99D5 08                       .
        php                                     ; 99D6 08                       .
        sed                                     ; 99D7 F8                       .
        brk                                     ; 99D8 00                       .
        php                                     ; 99D9 08                       .
L99DA:  .byte   $02                             ; 99DA 02                       .
        brk                                     ; 99DB 00                       .
        inc     a:$02,x                         ; 99DC FE 02 00                 ...
        inc     a:L0000,x                       ; 99DF FE 00 00                 ...
        brk                                     ; 99E2 00                       .
L99E3:  .byte   $FF                             ; 99E3 FF                       .
        .byte   $FF                             ; 99E4 FF                       .
        .byte   $FF                             ; 99E5 FF                       .
        ora     ($01,x)                         ; 99E6 01 01                    ..
        ora     ($FF,x)                         ; 99E8 01 FF                    ..
        brk                                     ; 99EA 00                       .
        .byte   $01                             ; 99EB 01                       .
L99EC:  cmp     $D6                             ; 99EC C5 D6                    ..
        cmp     ($D3,x)                         ; 99EE C1 D3                    ..
L99F0:  .byte   $D4                             ; 99F0 D4                       .
        dec     $C3CF                           ; 99F1 CE CF C3                 ...
L99F4:  php                                     ; 99F4 08                       .
        sed                                     ; 99F5 F8                       .
L99F6:  .byte   $02                             ; 99F6 02                       .
        .byte   $0D                             ; 99F7 0D                       .
L99F8:  brk                                     ; 99F8 00                       .
        brk                                     ; 99F9 00                       .
        brk                                     ; 99FA 00                       .
L99FB:  brk                                     ; 99FB 00                       .
L99FC:  .byte   $3C                             ; 99FC 3C                       <
        .byte   $30                             ; 99FD 30                       0
L99FE:  brk                                     ; 99FE 00                       .
        brk                                     ; 99FF 00                       .
L9A00:  jmp     L9A14                           ; 9A00 4C 14 9A                 L..

; ----------------------------------------------------------------------------
L9A03:  jmp     L9A14                           ; 9A03 4C 14 9A                 L..

; ----------------------------------------------------------------------------
L9A06:  jmp     L9A0C                           ; 9A06 4C 0C 9A                 L..

; ----------------------------------------------------------------------------
L9A09:  jmp     L9A15                           ; 9A09 4C 15 9A                 L..

; ----------------------------------------------------------------------------
L9A0C:  lda     #$00                            ; 9A0C A9 00                    ..
        sta     $60AD                           ; 9A0E 8D AD 60                 ..`
        sta     $60AE                           ; 9A11 8D AE 60                 ..`
L9A14:  rts                                     ; 9A14 60                       `

; ----------------------------------------------------------------------------
L9A15:  lda     #$00                            ; 9A15 A9 00                    ..
        sta     $60E5                           ; 9A17 8D E5 60                 ..`
        sta     $60E6                           ; 9A1A 8D E6 60                 ..`
        sta     $60F1                           ; 9A1D 8D F1 60                 ..`
        ldy     $60C3                           ; 9A20 AC C3 60                 ..`
        lda     $6604,y                         ; 9A23 B9 04 66                 ..f
        sta     LABD1                           ; 9A26 8D D1 AB                 ...
        eor     #$01                            ; 9A29 49 01                    I.
        sta     LABD2                           ; 9A2B 8D D2 AB                 ...
        jsr     L9B0A                           ; 9A2E 20 0A 9B                  ..
        ldx     LABD1                           ; 9A31 AE D1 AB                 ...
        beq     L9A43                           ; 9A34 F0 0D                    ..
        lda     $60C1                           ; 9A36 AD C1 60                 ..`
        bne     L9A43                           ; 9A39 D0 08                    ..
        inc     $60B4                           ; 9A3B EE B4 60                 ..`
        lda     #$0A                            ; 9A3E A9 0A                    ..
        sta     $60B5                           ; 9A40 8D B5 60                 ..`
L9A43:  lda     $610E,x                         ; 9A43 BD 0E 61                 ..a
        beq     L9A4E                           ; 9A46 F0 06                    ..
        jsr     L9BAA                           ; 9A48 20 AA 9B                  ..
        ldx     LABD1                           ; 9A4B AE D1 AB                 ...
L9A4E:  lda     $606E,x                         ; 9A4E BD 6E 60                 .n`
        sta     $60E3                           ; 9A51 8D E3 60                 ..`
        lda     $6070,x                         ; 9A54 BD 70 60                 .p`
        sta     $60E4                           ; 9A57 8D E4 60                 ..`
        lda     $606C,x                         ; 9A5A BD 6C 60                 .l`
        beq     L9A78                           ; 9A5D F0 19                    ..
        lda     $6100,x                         ; 9A5F BD 00 61                 ..a
        sta     $606C,x                         ; 9A62 9D 6C 60                 .l`
        beq     L9A78                           ; 9A65 F0 11                    ..
        lda     $60F1                           ; 9A67 AD F1 60                 ..`
        bne     L9A78                           ; 9A6A D0 0C                    ..
        jsr     L6906                           ; 9A6C 20 06 69                  .i
        and     #$09                            ; 9A6F 29 09                    ).
        bne     L9A78                           ; 9A71 D0 05                    ..
        lda     #$A0                            ; 9A73 A9 A0                    ..
        sta     $60F1                           ; 9A75 8D F1 60                 ..`
L9A78:  jsr     LA6D9                           ; 9A78 20 D9 A6                  ..
        bcs     L9A80                           ; 9A7B B0 03                    ..
        jsr     LA420                           ; 9A7D 20 20 A4                   .
L9A80:  ldx     LABD1                           ; 9A80 AE D1 AB                 ...
        lda     $60E3                           ; 9A83 AD E3 60                 ..`
        sta     $606E,x                         ; 9A86 9D 6E 60                 .n`
        lda     $60E4                           ; 9A89 AD E4 60                 ..`
        cmp     #$39                            ; 9A8C C9 39                    .9
        bcs     L9A95                           ; 9A8E B0 05                    ..
        lda     #$39                            ; 9A90 A9 39                    .9
        sta     $60E4                           ; 9A92 8D E4 60                 ..`
L9A95:  sta     $6070,x                         ; 9A95 9D 70 60                 .p`
        lda     $6102,x                         ; 9A98 BD 02 61                 ..a
        cmp     #$02                            ; 9A9B C9 02                    ..
        bne     L9B09                           ; 9A9D D0 6A                    .j
        lda     $60C1                           ; 9A9F AD C1 60                 ..`
        and     #$3F                            ; 9AA2 29 3F                    )?
        bne     L9B09                           ; 9AA4 D0 63                    .c
        lda     $05                             ; 9AA6 A5 05                    ..
        cmp     #$01                            ; 9AA8 C9 01                    ..
        beq     L9B09                           ; 9AAA F0 5D                    .]
        lda     $60E5                           ; 9AAC AD E5 60                 ..`
        ora     $60E6                           ; 9AAF 0D E6 60                 ..`
        bmi     L9B09                           ; 9AB2 30 55                    0U
        ldy     LABD2                           ; 9AB4 AC D2 AB                 ...
        lda     $6104,y                         ; 9AB7 B9 04 61                 ..a
        bne     L9B09                           ; 9ABA D0 4D                    .M
        lda     $6112,x                         ; 9ABC BD 12 61                 ..a
        tax                                     ; 9ABF AA                       .
        lda     $6112,y                         ; 9AC0 B9 12 61                 ..a
        tay                                     ; 9AC3 A8                       .
        lda     $63FC,x                         ; 9AC4 BD FC 63                 ..c
        sec                                     ; 9AC7 38                       8
        sbc     $63FC,y                         ; 9AC8 F9 FC 63                 ..c
        bcs     L9AD4                           ; 9ACB B0 07                    ..
        lda     $63FC,x                         ; 9ACD BD FC 63                 ..c
        sec                                     ; 9AD0 38                       8
        sbc     $63FC,y                         ; 9AD1 F9 FC 63                 ..c
L9AD4:  cmp     #$0A                            ; 9AD4 C9 0A                    ..
        bcs     L9B09                           ; 9AD6 B0 31                    .1
        sty     $60A8                           ; 9AD8 8C A8 60                 ..`
        stx     $60C3                           ; 9ADB 8E C3 60                 ..`
        lda     #$FF                            ; 9ADE A9 FF                    ..
        sta     L0060                           ; 9AE0 85 60                    .`
        lda     $6394,y                         ; 9AE2 B9 94 63                 ..c
        sec                                     ; 9AE5 38                       8
        sbc     $6394,x                         ; 9AE6 FD 94 63                 ..c
        sta     $61                             ; 9AE9 85 61                    .a
        lda     $632C,y                         ; 9AEB B9 2C 63                 .,c
        sbc     $632C,y                         ; 9AEE F9 2C 63                 .,c
        bcc     L9AF9                           ; 9AF1 90 06                    ..
        beq     L9AF7                           ; 9AF3 F0 02                    ..
        inc     L0060                           ; 9AF5 E6 60                    .`
L9AF7:  inc     $61                             ; 9AF7 E6 61                    .a
L9AF9:  lda     $60E3                           ; 9AF9 AD E3 60                 ..`
        jsr     LAA3C                           ; 9AFC 20 3C AA                  <.
        cmp     $61                             ; 9AFF C5 61                    .a
        bne     L9B09                           ; 9B01 D0 06                    ..
        ldx     LABD1                           ; 9B03 AE D1 AB                 ...
        jsr     L8F12                           ; 9B06 20 12 8F                  ..
L9B09:  rts                                     ; 9B09 60                       `

; ----------------------------------------------------------------------------
L9B0A:  ldx     LABD1                           ; 9B0A AE D1 AB                 ...
        lda     $6110,x                         ; 9B0D BD 10 61                 ..a
        bne     L9B2C                           ; 9B10 D0 1A                    ..
        jsr     L6906                           ; 9B12 20 06 69                  .i
        lsr     a                               ; 9B15 4A                       J
        bcs     L9B2C                           ; 9B16 B0 14                    ..
        lda     $6116,x                         ; 9B18 BD 16 61                 ..a
        cmp     #$0A                            ; 9B1B C9 0A                    ..
        bcc     L9B2C                           ; 9B1D 90 0D                    ..
        ldy     $60FA,x                         ; 9B1F BC FA 60                 ..`
        lda     $67A4,y                         ; 9B22 B9 A4 67                 ..g
        bne     L9B2D                           ; 9B25 D0 06                    ..
        lda     #$CD                            ; 9B27 A9 CD                    ..
L9B29:  sta     $60F1                           ; 9B29 8D F1 60                 ..`
L9B2C:  rts                                     ; 9B2C 60                       `

; ----------------------------------------------------------------------------
L9B2D:  lda     $6604,y                         ; 9B2D B9 04 66                 ..f
        cmp     LABD1                           ; 9B30 CD D1 AB                 ...
        beq     L9B49                           ; 9B33 F0 14                    ..
        lda     $60AD,x                         ; 9B35 BD AD 60                 ..`
        bne     L9B3E                           ; 9B38 D0 04                    ..
        lda     #$D4                            ; 9B3A A9 D4                    ..
        bne     L9B29                           ; 9B3C D0 EB                    ..
L9B3E:  lda     $60C1                           ; 9B3E AD C1 60                 ..`
        and     #$0F                            ; 9B41 29 0F                    ).
        bne     L9B2C                           ; 9B43 D0 E7                    ..
        dec     $60AD,x                         ; 9B45 DE AD 60                 ..`
        rts                                     ; 9B48 60                       `

; ----------------------------------------------------------------------------
L9B49:  lda     $611E,x                         ; 9B49 BD 1E 61                 ..a
        asl     a                               ; 9B4C 0A                       .
        asl     a                               ; 9B4D 0A                       .
        sta     L0060                           ; 9B4E 85 60                    .`
        lda     $6122,x                         ; 9B50 BD 22 61                 ."a
        asl     a                               ; 9B53 0A                       .
        asl     a                               ; 9B54 0A                       .
        asl     a                               ; 9B55 0A                       .
        asl     a                               ; 9B56 0A                       .
        sec                                     ; 9B57 38                       8
        sbc     $6122,x                         ; 9B58 FD 22 61                 ."a
        sta     $61                             ; 9B5B 85 61                    .a
        lda     $611A,x                         ; 9B5D BD 1A 61                 ..a
        asl     a                               ; 9B60 0A                       .
        asl     a                               ; 9B61 0A                       .
        asl     a                               ; 9B62 0A                       .
        asl     a                               ; 9B63 0A                       .
        adc     $611A,x                         ; 9B64 7D 1A 61                 }.a
        sta     $62                             ; 9B67 85 62                    .b
        lda     $05                             ; 9B69 A5 05                    ..
        beq     L9B75                           ; 9B6B F0 08                    ..
        cmp     #$03                            ; 9B6D C9 03                    ..
        bcs     L9B75                           ; 9B6F B0 04                    ..
        lda     #$FF                            ; 9B71 A9 FF                    ..
        sta     $62                             ; 9B73 85 62                    .b
L9B75:  lda     $6120,x                         ; 9B75 BD 20 61                 . a
        asl     a                               ; 9B78 0A                       .
        asl     a                               ; 9B79 0A                       .
        sta     $63                             ; 9B7A 85 63                    .c
        asl     a                               ; 9B7C 0A                       .
        asl     a                               ; 9B7D 0A                       .
        adc     $63                             ; 9B7E 65 63                    ec
        sta     $63                             ; 9B80 85 63                    .c
        ldx     #$03                            ; 9B82 A2 03                    ..
        lda     $63                             ; 9B84 A5 63                    .c
        ldy     #$02                            ; 9B86 A0 02                    ..
L9B88:  cmp     L0060,y                         ; 9B88 D9 60 00                 .`.
        bcc     L9B94                           ; 9B8B 90 07                    ..
        beq     L9B94                           ; 9B8D F0 05                    ..
        tya                                     ; 9B8F 98                       .
        tax                                     ; 9B90 AA                       .
        lda     L0060,y                         ; 9B91 B9 60 00                 .`.
L9B94:  dey                                     ; 9B94 88                       .
        bpl     L9B88                           ; 9B95 10 F1                    ..
        txa                                     ; 9B97 8A                       .
        bne     L9BA3                           ; 9B98 D0 09                    ..
        jsr     L6906                           ; 9B9A 20 06 69                  .i
        and     #$06                            ; 9B9D 29 06                    ).
        beq     L9BA3                           ; 9B9F F0 02                    ..
        ldx     #$04                            ; 9BA1 A2 04                    ..
L9BA3:  lda     LABCC,x                         ; 9BA3 BD CC AB                 ...
        sta     $60F1                           ; 9BA6 8D F1 60                 ..`
        rts                                     ; 9BA9 60                       `

; ----------------------------------------------------------------------------
L9BAA:  ldx     LABD1                           ; 9BAA AE D1 AB                 ...
        lda     #$00                            ; 9BAD A9 00                    ..
        sta     $610E,x                         ; 9BAF 9D 0E 61                 ..a
        sta     $606C,x                         ; 9BB2 9D 6C 60                 .l`
        lda     #$00                            ; 9BB5 A9 00                    ..
        sta     $606E,x                         ; 9BB7 9D 6E 60                 .n`
        lda     #$DD                            ; 9BBA A9 DD                    ..
        sta     $6070,x                         ; 9BBC 9D 70 60                 .p`
        jmp     L9F33                           ; 9BBF 4C 33 9F                 L3.

; ----------------------------------------------------------------------------
        lda     #$00                            ; 9BC2 A9 00                    ..
        sta     $60E3                           ; 9BC4 8D E3 60                 ..`
        lda     $610C,x                         ; 9BC7 BD 0C 61                 ..a
        bne     L9BCD                           ; 9BCA D0 01                    ..
        rts                                     ; 9BCC 60                       `

; ----------------------------------------------------------------------------
L9BCD:  jmp     L9EFB                           ; 9BCD 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        ldy     $6112,x                         ; 9BD0 BC 12 61                 ..a
        lda     $63FC,y                         ; 9BD3 B9 FC 63                 ..c
        cmp     #$C9                            ; 9BD6 C9 C9                    ..
        bcc     L9BE0                           ; 9BD8 90 06                    ..
        lda     #$20                            ; 9BDA A9 20                    . 
        sta     $60E4                           ; 9BDC 8D E4 60                 ..`
        rts                                     ; 9BDF 60                       `

; ----------------------------------------------------------------------------
L9BE0:  sta     $60E4                           ; 9BE0 8D E4 60                 ..`
        jmp     L9EFB                           ; 9BE3 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        lda     #$DD                            ; 9BE6 A9 DD                    ..
        sta     $60E4                           ; 9BE8 8D E4 60                 ..`
        ldy     $6112,x                         ; 9BEB BC 12 61                 ..a
        lda     $63FC,y                         ; 9BEE B9 FC 63                 ..c
        cmp     #$DD                            ; 9BF1 C9 DD                    ..
        bcs     L9BFD                           ; 9BF3 B0 08                    ..
        lda     $60FC,x                         ; 9BF5 BD FC 60                 ..`
        bne     L9BFD                           ; 9BF8 D0 03                    ..
        jmp     LA435                           ; 9BFA 4C 35 A4                 L5.

; ----------------------------------------------------------------------------
L9BFD:  jmp     L9EFB                           ; 9BFD 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        ldy     $6112,x                         ; 9C00 BC 12 61                 ..a
        lda     $6064,x                         ; 9C03 BD 64 60                 .d`
        sta     $60E4                           ; 9C06 8D E4 60                 ..`
        sec                                     ; 9C09 38                       8
        sbc     $63FC,y                         ; 9C0A F9 FC 63                 ..c
        cmp     #$02                            ; 9C0D C9 02                    ..
        bcc     L9C16                           ; 9C0F 90 05                    ..
        cmp     #$FE                            ; 9C11 C9 FE                    ..
        bcs     L9C16                           ; 9C13 B0 01                    ..
        rts                                     ; 9C15 60                       `

; ----------------------------------------------------------------------------
L9C16:  jmp     L9EFB                           ; 9C16 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        jsr     LA435                           ; 9C19 20 35 A4                  5.
        jsr     LA73C                           ; 9C1C 20 3C A7                  <.
        lda     $60E3                           ; 9C1F AD E3 60                 ..`
        bpl     L9C29                           ; 9C22 10 05                    ..
        eor     #$FF                            ; 9C24 49 FF                    I.
        clc                                     ; 9C26 18                       .
        adc     #$01                            ; 9C27 69 01                    i.
L9C29:  cmp     #$03                            ; 9C29 C9 03                    ..
        bcc     L9C2E                           ; 9C2B 90 01                    ..
        rts                                     ; 9C2D 60                       `

; ----------------------------------------------------------------------------
L9C2E:  jmp     L9EFB                           ; 9C2E 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        rts                                     ; 9C31 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 9C32 60                       `

; ----------------------------------------------------------------------------
        jsr     LA435                           ; 9C33 20 35 A4                  5.
        lda     $6100,x                         ; 9C36 BD 00 61                 ..a
        beq     L9C59                           ; 9C39 F0 1E                    ..
        ldy     $6112,x                         ; 9C3B BC 12 61                 ..a
        lda     $63FC,y                         ; 9C3E B9 FC 63                 ..c
        cmp     #$DD                            ; 9C41 C9 DD                    ..
        bne     L9C4B                           ; 9C43 D0 06                    ..
        lda     #$FF                            ; 9C45 A9 FF                    ..
        sta     $60E6                           ; 9C47 8D E6 60                 ..`
        rts                                     ; 9C4A 60                       `

; ----------------------------------------------------------------------------
L9C4B:  jsr     LA73C                           ; 9C4B 20 3C A7                  <.
        lda     $60F1                           ; 9C4E AD F1 60                 ..`
        bne     L9C58                           ; 9C51 D0 05                    ..
        lda     #$A0                            ; 9C53 A9 A0                    ..
        sta     $60F1                           ; 9C55 8D F1 60                 ..`
L9C58:  rts                                     ; 9C58 60                       `

; ----------------------------------------------------------------------------
L9C59:  jmp     L9EFB                           ; 9C59 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        jsr     LA435                           ; 9C5C 20 35 A4                  5.
        lda     #$12                            ; 9C5F A9 12                    ..
        jsr     LA7CF                           ; 9C61 20 CF A7                  ..
        bcc     L9C74                           ; 9C64 90 0E                    ..
        jsr     LA73C                           ; 9C66 20 3C A7                  <.
        ldx     LABD1                           ; 9C69 AE D1 AB                 ...
        lda     #$FF                            ; 9C6C A9 FF                    ..
        sta     $6066,x                         ; 9C6E 9D 66 60                 .f`
        jmp     L9EFB                           ; 9C71 4C FB 9E                 L..

; ----------------------------------------------------------------------------
L9C74:  lda     #$DB                            ; 9C74 A9 DB                    ..
        sta     $60E4                           ; 9C76 8D E4 60                 ..`
        ldx     LABD1                           ; 9C79 AE D1 AB                 ...
        dec     $6066,x                         ; 9C7C DE 66 60                 .f`
        beq     L9C82                           ; 9C7F F0 01                    ..
        rts                                     ; 9C81 60                       `

; ----------------------------------------------------------------------------
L9C82:  jmp     L9EFB                           ; 9C82 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        lda     $6100,x                         ; 9C85 BD 00 61                 ..a
        cmp     #$04                            ; 9C88 C9 04                    ..
        bcs     L9CF0                           ; 9C8A B0 64                    .d
        ldy     $60C3                           ; 9C8C AC C3 60                 ..`
        lda     #$04                            ; 9C8F A9 04                    ..
        sta     L0060                           ; 9C91 85 60                    .`
        lda     LABD1                           ; 9C93 AD D1 AB                 ...
        bne     L9CA4                           ; 9C96 D0 0C                    ..
        lda     $625C,y                         ; 9C98 B9 5C 62                 .\b
        bmi     L9CA4                           ; 9C9B 30 07                    0.
        tay                                     ; 9C9D A8                       .
        lda     $625C,y                         ; 9C9E B9 5C 62                 .\b
        bmi     L9CA4                           ; 9CA1 30 01                    0.
        tay                                     ; 9CA3 A8                       .
L9CA4:  lda     LABD1                           ; 9CA4 AD D1 AB                 ...
        bne     L9CB0                           ; 9CA7 D0 07                    ..
        lda     $61F4,y                         ; 9CA9 B9 F4 61                 ..a
        bmi     L9CF0                           ; 9CAC 30 42                    0B
        bpl     L9CB5                           ; 9CAE 10 05                    ..
L9CB0:  lda     $625C,y                         ; 9CB0 B9 5C 62                 .\b
        bmi     L9CF0                           ; 9CB3 30 3B                    0;
L9CB5:  tay                                     ; 9CB5 A8                       .
        lda     $6124,y                         ; 9CB6 B9 24 61                 .$a
        cmp     #$0D                            ; 9CB9 C9 0D                    ..
        beq     L9CC1                           ; 9CBB F0 04                    ..
        dec     L0060                           ; 9CBD C6 60                    .`
        bne     L9CA4                           ; 9CBF D0 E3                    ..
L9CC1:  ldx     $60C3                           ; 9CC1 AE C3 60                 ..`
        lda     $6394,x                         ; 9CC4 BD 94 63                 ..c
        sec                                     ; 9CC7 38                       8
        sbc     $6394,y                         ; 9CC8 F9 94 63                 ..c
        sta     L0060                           ; 9CCB 85 60                    .`
        lda     $632C,x                         ; 9CCD BD 2C 63                 .,c
        sbc     $632C,y                         ; 9CD0 F9 2C 63                 .,c
        sta     $61                             ; 9CD3 85 61                    .a
        bcs     L9CE7                           ; 9CD5 B0 10                    ..
        eor     #$FF                            ; 9CD7 49 FF                    I.
        sta     $61                             ; 9CD9 85 61                    .a
        lda     L0060                           ; 9CDB A5 60                    .`
        eor     #$FF                            ; 9CDD 49 FF                    I.
        adc     #$01                            ; 9CDF 69 01                    i.
        sta     L0060                           ; 9CE1 85 60                    .`
        bcc     L9CE7                           ; 9CE3 90 02                    ..
        inc     $61                             ; 9CE5 E6 61                    .a
L9CE7:  lda     $61                             ; 9CE7 A5 61                    .a
        bne     L9CF0                           ; 9CE9 D0 05                    ..
        lda     L0060                           ; 9CEB A5 60                    .`
        bmi     L9CF0                           ; 9CED 30 01                    0.
        rts                                     ; 9CEF 60                       `

; ----------------------------------------------------------------------------
L9CF0:  jmp     L9EFB                           ; 9CF0 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        ldy     $6066,x                         ; 9CF3 BC 66 60                 .f`
        lda     $6124,y                         ; 9CF6 B9 24 61                 .$a
        cmp     $6068,x                         ; 9CF9 DD 68 60                 .h`
        bne     L9D3D                           ; 9CFC D0 3F                    .?
        lda     $6394,y                         ; 9CFE B9 94 63                 ..c
        sta     $6060,x                         ; 9D01 9D 60 60                 .``
        lda     $632C,y                         ; 9D04 B9 2C 63                 .,c
        sta     $6062,x                         ; 9D07 9D 62 60                 .b`
        ldx     $60C3                           ; 9D0A AE C3 60                 ..`
        lda     $6394,y                         ; 9D0D B9 94 63                 ..c
        sec                                     ; 9D10 38                       8
        sbc     $6394,x                         ; 9D11 FD 94 63                 ..c
        sta     L0060                           ; 9D14 85 60                    .`
        lda     $632C,y                         ; 9D16 B9 2C 63                 .,c
        sbc     $632C,x                         ; 9D19 FD 2C 63                 .,c
        sta     $61                             ; 9D1C 85 61                    .a
        bcs     L9D30                           ; 9D1E B0 10                    ..
        eor     #$FF                            ; 9D20 49 FF                    I.
        sta     $61                             ; 9D22 85 61                    .a
        lda     L0060                           ; 9D24 A5 60                    .`
        eor     #$FF                            ; 9D26 49 FF                    I.
        sta     L0060                           ; 9D28 85 60                    .`
        inc     L0060                           ; 9D2A E6 60                    .`
        bne     L9D30                           ; 9D2C D0 02                    ..
        inc     $61                             ; 9D2E E6 61                    .a
L9D30:  ldx     LABD1                           ; 9D30 AE D1 AB                 ...
        lda     $61                             ; 9D33 A5 61                    .a
        bne     L9D40                           ; 9D35 D0 09                    ..
        lda     L0060                           ; 9D37 A5 60                    .`
        cmp     #$1E                            ; 9D39 C9 1E                    ..
        bcs     L9D40                           ; 9D3B B0 03                    ..
L9D3D:  jmp     L9EFB                           ; 9D3D 4C FB 9E                 L..

; ----------------------------------------------------------------------------
L9D40:  jsr     LA435                           ; 9D40 20 35 A4                  5.
        jmp     LA73C                           ; 9D43 4C 3C A7                 L<.

; ----------------------------------------------------------------------------
        jsr     LA435                           ; 9D46 20 35 A4                  5.
        jsr     LA73C                           ; 9D49 20 3C A7                  <.
        dec     $6066,x                         ; 9D4C DE 66 60                 .f`
        beq     L9D52                           ; 9D4F F0 01                    ..
        rts                                     ; 9D51 60                       `

; ----------------------------------------------------------------------------
L9D52:  jmp     L9EFB                           ; 9D52 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        lda     #$FF                            ; 9D55 A9 FF                    ..
        sta     $605C,x                         ; 9D57 9D 5C 60                 .\`
        jmp     L9EFB                           ; 9D5A 4C FB 9E                 L..

; ----------------------------------------------------------------------------
        ldy     $6114,x                         ; 9D5D BC 14 61                 ..a
        bmi     L9DA1                           ; 9D60 30 3F                    0?
        jsr     LAA16                           ; 9D62 20 16 AA                  ..
        lda     $63FC,y                         ; 9D65 B9 FC 63                 ..c
        sec                                     ; 9D68 38                       8
        sbc     #$05                            ; 9D69 E9 05                    ..
        sta     $60E4                           ; 9D6B 8D E4 60                 ..`
        jsr     LA8F5                           ; 9D6E 20 F5 A8                  ..
        ldx     LABD1                           ; 9D71 AE D1 AB                 ...
        lda     #$01                            ; 9D74 A9 01                    ..
        sta     $606C,x                         ; 9D76 9D 6C 60                 .l`
        lda     L0060                           ; 9D79 A5 60                    .`
        cmp     #$60                            ; 9D7B C9 60                    .`
        bcs     L9DA0                           ; 9D7D B0 21                    .!
        lda     $05                             ; 9D7F A5 05                    ..
        cmp     #$05                            ; 9D81 C9 05                    ..
        bcs     L9DA4                           ; 9D83 B0 1F                    ..
        lda     $60F6,x                         ; 9D85 BD F6 60                 ..`
        beq     L9DA0                           ; 9D88 F0 16                    ..
        lda     $05                             ; 9D8A A5 05                    ..
        cmp     #$05                            ; 9D8C C9 05                    ..
        bcs     L9D9B                           ; 9D8E B0 0B                    ..
        dec     $6066,x                         ; 9D90 DE 66 60                 .f`
        bne     L9DA0                           ; 9D93 D0 0B                    ..
        lda     $6068,x                         ; 9D95 BD 68 60                 .h`
        sta     $6066,x                         ; 9D98 9D 66 60                 .f`
L9D9B:  lda     #$FF                            ; 9D9B A9 FF                    ..
        sta     $60E5                           ; 9D9D 8D E5 60                 ..`
L9DA0:  rts                                     ; 9DA0 60                       `

; ----------------------------------------------------------------------------
L9DA1:  jmp     L9EFB                           ; 9DA1 4C FB 9E                 L..

; ----------------------------------------------------------------------------
L9DA4:  lda     $6100,x                         ; 9DA4 BD 00 61                 ..a
        beq     L9DA1                           ; 9DA7 F0 F8                    ..
        bne     L9DA0                           ; 9DA9 D0 F5                    ..
        ldy     LABD2                           ; 9DAB AC D2 AB                 ...
        lda     $6104,y                         ; 9DAE B9 04 61                 ..a
        beq     L9DB6                           ; 9DB1 F0 03                    ..
L9DB3:  jmp     L9EFB                           ; 9DB3 4C FB 9E                 L..

; ----------------------------------------------------------------------------
L9DB6:  lda     $6102,x                         ; 9DB6 BD 02 61                 ..a
        beq     L9DB3                           ; 9DB9 F0 F8                    ..
        lda     $05                             ; 9DBB A5 05                    ..
        cmp     #$01                            ; 9DBD C9 01                    ..
        beq     L9DB3                           ; 9DBF F0 F2                    ..
        lda     $6112,y                         ; 9DC1 B9 12 61                 ..a
        tay                                     ; 9DC4 A8                       .
        ldx     $60C3                           ; 9DC5 AE C3 60                 ..`
        jsr     LA8F5                           ; 9DC8 20 F5 A8                  ..
        lda     $61                             ; 9DCB A5 61                    .a
        bne     L9DB3                           ; 9DCD D0 E4                    ..
        jsr     LAA16                           ; 9DCF 20 16 AA                  ..
        lda     #$40                            ; 9DD2 A9 40                    .@
        jsr     LA7CF                           ; 9DD4 20 CF A7                  ..
        lda     #$DC                            ; 9DD7 A9 DC                    ..
        bcc     L9DE1                           ; 9DD9 90 06                    ..
        jsr     LA73C                           ; 9DDB 20 3C A7                  <.
        lda     $60E4                           ; 9DDE AD E4 60                 ..`
L9DE1:  sta     $60E4                           ; 9DE1 8D E4 60                 ..`
        ldy     LABD2                           ; 9DE4 AC D2 AB                 ...
        lda     $6112,y                         ; 9DE7 B9 12 61                 ..a
        sta     $60A8                           ; 9DEA 8D A8 60                 ..`
        tay                                     ; 9DED A8                       .
        lda     $63FC,y                         ; 9DEE B9 FC 63                 ..c
        sta     L0060                           ; 9DF1 85 60                    .`
        cmp     $60E4                           ; 9DF3 CD E4 60                 ..`
        bcs     L9DFB                           ; 9DF6 B0 03                    ..
        sta     $60E4                           ; 9DF8 8D E4 60                 ..`
L9DFB:  sec                                     ; 9DFB 38                       8
        ldy     $60C3                           ; 9DFC AC C3 60                 ..`
        sbc     $63FC,y                         ; 9DFF F9 FC 63                 ..c
        bcs     L9E0A                           ; 9E02 B0 06                    ..
        lda     $63FC,y                         ; 9E04 B9 FC 63                 ..c
        sec                                     ; 9E07 38                       8
        sbc     L0060                           ; 9E08 E5 60                    .`
L9E0A:  cmp     #$0A                            ; 9E0A C9 0A                    ..
        bcs     L9E14                           ; 9E0C B0 06                    ..
        ldx     LABD1                           ; 9E0E AE D1 AB                 ...
        jmp     L8F12                           ; 9E11 4C 12 8F                 L..

; ----------------------------------------------------------------------------
L9E14:  ldx     LABD2                           ; 9E14 AE D2 AB                 ...
        ldy     $6112,x                         ; 9E17 BC 12 61                 ..a
        ldx     $60C3                           ; 9E1A AE C3 60                 ..`
        lda     $63FC,x                         ; 9E1D BD FC 63                 ..c
        cmp     $63FC,y                         ; 9E20 D9 FC 63                 ..c
        bcs     L9E39                           ; 9E23 B0 14                    ..
        lda     $60C1                           ; 9E25 AD C1 60                 ..`
        and     #$07                            ; 9E28 29 07                    ).
        bne     L9E39                           ; 9E2A D0 0D                    ..
        lda     $63FC,x                         ; 9E2C BD FC 63                 ..c
        cmp     $63FC,y                         ; 9E2F D9 FC 63                 ..c
        bcs     L9E39                           ; 9E32 B0 05                    ..
        lda     #$FF                            ; 9E34 A9 FF                    ..
        sta     $60E6                           ; 9E36 8D E6 60                 ..`
L9E39:  rts                                     ; 9E39 60                       `

; ----------------------------------------------------------------------------
L9E3A:  ldy     LABD2                           ; 9E3A AC D2 AB                 ...
        lda     $6104,y                         ; 9E3D B9 04 61                 ..a
        beq     L9E45                           ; 9E40 F0 03                    ..
L9E42:  jmp     L9EFB                           ; 9E42 4C FB 9E                 L..

; ----------------------------------------------------------------------------
L9E45:  lda     $60F4,x                         ; 9E45 BD F4 60                 ..`
        beq     L9E42                           ; 9E48 F0 F8                    ..
        lda     #$36                            ; 9E4A A9 36                    .6
        sta     $60E4                           ; 9E4C 8D E4 60                 ..`
        lda     $6112,y                         ; 9E4F B9 12 61                 ..a
        tay                                     ; 9E52 A8                       .
        lda     $6394,y                         ; 9E53 B9 94 63                 ..c
        sta     $6060,x                         ; 9E56 9D 60 60                 .``
        lda     $632C,y                         ; 9E59 B9 2C 63                 .,c
        sta     $6062,x                         ; 9E5C 9D 62 60                 .b`
        jsr     LA435                           ; 9E5F 20 35 A4                  5.
        ldx     LABD2                           ; 9E62 AE D2 AB                 ...
        ldy     $6112,x                         ; 9E65 BC 12 61                 ..a
        ldx     $60C3                           ; 9E68 AE C3 60                 ..`
        lda     $63FC,y                         ; 9E6B B9 FC 63                 ..c
        sec                                     ; 9E6E 38                       8
        sbc     L6937                           ; 9E6F ED 37 69                 .7i
        sec                                     ; 9E72 38                       8
        sbc     $63FC,x                         ; 9E73 FD FC 63                 ..c
        php                                     ; 9E76 08                       .
        lsr     a                               ; 9E77 4A                       J
        lsr     a                               ; 9E78 4A                       J
        sta     $62                             ; 9E79 85 62                    .b
        jsr     LA8F5                           ; 9E7B 20 F5 A8                  ..
        plp                                     ; 9E7E 28                       (
        bcc     L9EA6                           ; 9E7F 90 25                    .%
        ldx     LABD1                           ; 9E81 AE D1 AB                 ...
        lda     $61                             ; 9E84 A5 61                    .a
        bne     L9EA6                           ; 9E86 D0 1E                    ..
        lda     L0060                           ; 9E88 A5 60                    .`
        cmp     $62                             ; 9E8A C5 62                    .b
        bcs     L9EA6                           ; 9E8C B0 18                    ..
        lda     #$0A                            ; 9E8E A9 0A                    ..
        sec                                     ; 9E90 38                       8
        sbc     $05                             ; 9E91 E5 05                    ..
        cmp     $606A,x                         ; 9E93 DD 6A 60                 .j`
        bcs     L9E9B                           ; 9E96 B0 03                    ..
        sta     $606A,x                         ; 9E98 9D 6A 60                 .j`
L9E9B:  dec     $606A,x                         ; 9E9B DE 6A 60                 .j`
        bpl     L9EA5                           ; 9E9E 10 05                    ..
        lda     #$FF                            ; 9EA0 A9 FF                    ..
        sta     $60E6                           ; 9EA2 8D E6 60                 ..`
L9EA5:  rts                                     ; 9EA5 60                       `

; ----------------------------------------------------------------------------
L9EA6:  lda     $60E3                           ; 9EA6 AD E3 60                 ..`
        cmp     #$07                            ; 9EA9 C9 07                    ..
        beq     L9EB1                           ; 9EAB F0 04                    ..
        cmp     #$F9                            ; 9EAD C9 F9                    ..
        bne     L9ECA                           ; 9EAF D0 19                    ..
L9EB1:  lsr     $61                             ; 9EB1 46 61                    Fa
        ror     L0060                           ; 9EB3 66 60                    f`
        lsr     $61                             ; 9EB5 46 61                    Fa
        ror     L0060                           ; 9EB7 66 60                    f`
        lda     $61                             ; 9EB9 A5 61                    .a
        bne     L9ECA                           ; 9EBB D0 0D                    ..
        lda     $63FC,y                         ; 9EBD B9 FC 63                 ..c
        sec                                     ; 9EC0 38                       8
        sbc     L0060                           ; 9EC1 E5 60                    .`
        cmp     #$3A                            ; 9EC3 C9 3A                    .:
        bcc     L9EEE                           ; 9EC5 90 27                    .'
        sta     $60E4                           ; 9EC7 8D E4 60                 ..`
L9ECA:  ldy     LABD2                           ; 9ECA AC D2 AB                 ...
        lda     $6112,y                         ; 9ECD B9 12 61                 ..a
        tay                                     ; 9ED0 A8                       .
        lda     $63FC,y                         ; 9ED1 B9 FC 63                 ..c
        sta     L0060                           ; 9ED4 85 60                    .`
        sec                                     ; 9ED6 38                       8
        ldy     $60C3                           ; 9ED7 AC C3 60                 ..`
        sbc     $63FC,y                         ; 9EDA F9 FC 63                 ..c
        bcs     L9EE5                           ; 9EDD B0 06                    ..
        lda     $63FC,y                         ; 9EDF B9 FC 63                 ..c
        sec                                     ; 9EE2 38                       8
        sbc     L0060                           ; 9EE3 E5 60                    .`
L9EE5:  cmp     #$0A                            ; 9EE5 C9 0A                    ..
        bcs     L9EEE                           ; 9EE7 B0 05                    ..
        lda     #$FF                            ; 9EE9 A9 FF                    ..
        sta     $60E5                           ; 9EEB 8D E5 60                 ..`
L9EEE:  rts                                     ; 9EEE 60                       `

; ----------------------------------------------------------------------------
        ldy     LABD2                           ; 9EEF AC D2 AB                 ...
        lda     $6104,y                         ; 9EF2 B9 04 61                 ..a
        beq     L9EFA                           ; 9EF5 F0 03                    ..
        jmp     L9EFB                           ; 9EF7 4C FB 9E                 L..

; ----------------------------------------------------------------------------
L9EFA:  rts                                     ; 9EFA 60                       `

; ----------------------------------------------------------------------------
L9EFB:  ldx     LABD1                           ; 9EFB AE D1 AB                 ...
        inc     $605C,x                         ; 9EFE FE 5C 60                 .\`
        ldy     $605A,x                         ; 9F01 BC 5A 60                 .Z`
        lda     LAAA5,y                         ; 9F04 B9 A5 AA                 ...
        clc                                     ; 9F07 18                       .
        adc     $605C,x                         ; 9F08 7D 5C 60                 }\`
        tay                                     ; 9F0B A8                       .
        lda     LAA72,y                         ; 9F0C B9 72 AA                 .r.
        bmi     L9F17                           ; 9F0F 30 06                    0.
        sta     $605E,x                         ; 9F11 9D 5E 60                 .^`
        jmp     LA3F2                           ; 9F14 4C F2 A3                 L..

; ----------------------------------------------------------------------------
L9F17:  jmp     L9F1A                           ; 9F17 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
L9F1A:  ldx     LABD1                           ; 9F1A AE D1 AB                 ...
        inc     $6058,x                         ; 9F1D FE 58 60                 .X`
        ldy     $6056,x                         ; 9F20 BC 56 60                 .V`
        lda     LAA6B,y                         ; 9F23 B9 6B AA                 .k.
        sec                                     ; 9F26 38                       8
        adc     $6058,x                         ; 9F27 7D 58 60                 }X`
        tay                                     ; 9F2A A8                       .
        lda     LAA48,y                         ; 9F2B B9 48 AA                 .H.
        bmi     L9F33                           ; 9F2E 30 03                    0.
        jmp     LA3A6                           ; 9F30 4C A6 A3                 L..

; ----------------------------------------------------------------------------
L9F33:  ldx     LABD1                           ; 9F33 AE D1 AB                 ...
        ldy     $6114,x                         ; 9F36 BC 14 61                 ..a
        bmi     L9F63                           ; 9F39 30 28                    0(
        ldx     $60C3                           ; 9F3B AE C3 60                 ..`
        jsr     LA8F5                           ; 9F3E 20 F5 A8                  ..
        lda     $61                             ; 9F41 A5 61                    .a
        bne     L9F63                           ; 9F43 D0 1E                    ..
        lda     L0060                           ; 9F45 A5 60                    .`
        cmp     #$C0                            ; 9F47 C9 C0                    ..
        bcs     L9F63                           ; 9F49 B0 18                    ..
        ldx     LABD1                           ; 9F4B AE D1 AB                 ...
        lda     $6100,x                         ; 9F4E BD 00 61                 ..a
        bne     L9F5E                           ; 9F51 D0 0B                    ..
        lda     $05                             ; 9F53 A5 05                    ..
        cmp     #$05                            ; 9F55 C9 05                    ..
        bcs     L9F63                           ; 9F57 B0 0A                    ..
        lda     $60F6,x                         ; 9F59 BD F6 60                 ..`
        beq     L9F63                           ; 9F5C F0 05                    ..
L9F5E:  lda     #$06                            ; 9F5E A9 06                    ..
        jmp     LA39B                           ; 9F60 4C 9B A3                 L..

; ----------------------------------------------------------------------------
L9F63:  jsr     LA8D8                           ; 9F63 20 D8 A8                  ..
        ldx     LABD1                           ; 9F66 AE D1 AB                 ...
        ldy     $60C3                           ; 9F69 AC C3 60                 ..`
        bcc     L9F83                           ; 9F6C 90 15                    ..
        lda     $05                             ; 9F6E A5 05                    ..
        cmp     #$01                            ; 9F70 C9 01                    ..
        beq     L9F79                           ; 9F72 F0 05                    ..
        lda     $6102,x                         ; 9F74 BD 02 61                 ..a
        bne     L9F7E                           ; 9F77 D0 05                    ..
L9F79:  lda     $60F4,x                         ; 9F79 BD F4 60                 ..`
        beq     L9F83                           ; 9F7C F0 05                    ..
L9F7E:  lda     #$05                            ; 9F7E A9 05                    ..
        jmp     LA39B                           ; 9F80 4C 9B A3                 L..

; ----------------------------------------------------------------------------
L9F83:  ldx     LABD1                           ; 9F83 AE D1 AB                 ...
        ldy     $60C3                           ; 9F86 AC C3 60                 ..`
        lda     $6108,x                         ; 9F89 BD 08 61                 ..a
        cmp     #$20                            ; 9F8C C9 20                    . 
        bcc     L9FAE                           ; 9F8E 90 1E                    ..
        lda     $659C,y                         ; 9F90 B9 9C 65                 ..e
        cmp     #$05                            ; 9F93 C9 05                    ..
        bcc     L9FAE                           ; 9F95 90 17                    ..
        lda     $60F4,x                         ; 9F97 BD F4 60                 ..`
        cmp     #$02                            ; 9F9A C9 02                    ..
        bcc     L9FAE                           ; 9F9C 90 10                    ..
        lda     $60F6,x                         ; 9F9E BD F6 60                 ..`
        cmp     #$02                            ; 9FA1 C9 02                    ..
        bcc     L9FAE                           ; 9FA3 90 09                    ..
        ldy     $60EE                           ; 9FA5 AC EE 60                 ..`
        bne     L9FB3                           ; 9FA8 D0 09                    ..
        cmp     #$10                            ; 9FAA C9 10                    ..
        bcs     L9FB3                           ; 9FAC B0 05                    ..
L9FAE:  lda     #$00                            ; 9FAE A9 00                    ..
L9FB0:  jmp     LA39B                           ; 9FB0 4C 9B A3                 L..

; ----------------------------------------------------------------------------
L9FB3:  lda     LABD1                           ; 9FB3 AD D1 AB                 ...
        asl     a                               ; 9FB6 0A                       .
        sta     L0060                           ; 9FB7 85 60                    .`
L9FB9:  ldy     L0060                           ; 9FB9 A4 60                    .`
        lda     $60BE,y                         ; 9FBB B9 BE 60                 ..`
        bmi     L9FCE                           ; 9FBE 30 0E                    0.
        tay                                     ; 9FC0 A8                       .
        lda     $67A4,y                         ; 9FC1 B9 A4 67                 ..g
        bne     L9FCE                           ; 9FC4 D0 08                    ..
        tya                                     ; 9FC6 98                       .
        sta     $606A,x                         ; 9FC7 9D 6A 60                 .j`
        lda     #$03                            ; 9FCA A9 03                    ..
        bne     L9FB0                           ; 9FCC D0 E2                    ..
L9FCE:  lda     LABD1                           ; 9FCE AD D1 AB                 ...
        bne     L9FDD                           ; 9FD1 D0 0A                    ..
        inc     L0060                           ; 9FD3 E6 60                    .`
        lda     L0060                           ; 9FD5 A5 60                    .`
        cmp     #$03                            ; 9FD7 C9 03                    ..
        bne     L9FB9                           ; 9FD9 D0 DE                    ..
        beq     L9FE1                           ; 9FDB F0 04                    ..
L9FDD:  dec     L0060                           ; 9FDD C6 60                    .`
        bpl     L9FB9                           ; 9FDF 10 D8                    ..
L9FE1:  ldy     LABD2                           ; 9FE1 AC D2 AB                 ...
        jsr     LA1AF                           ; 9FE4 20 AF A1                  ..
        ldx     LABD1                           ; 9FE7 AE D1 AB                 ...
        ldy     LABD2                           ; 9FEA AC D2 AB                 ...
        bcc     L9FF6                           ; 9FED 90 07                    ..
        sta     $606A,x                         ; 9FEF 9D 6A 60                 .j`
        lda     #$03                            ; 9FF2 A9 03                    ..
        bne     L9FB0                           ; 9FF4 D0 BA                    ..
L9FF6:  lda     $6120,y                         ; 9FF6 B9 20 61                 . a
        asl     a                               ; 9FF9 0A                       .
        asl     a                               ; 9FFA 0A                       .
        adc     $611E,y                         ; 9FFB 79 1E 61                 y.a
        sta     L0060                           ; 9FFE 85 60                    .`
        lda     $6120,x                         ; A000 BD 20 61                 . a
        asl     a                               ; A003 0A                       .
        asl     a                               ; A004 0A                       .
        adc     $611E,x                         ; A005 7D 1E 61                 }.a
        cmp     L0060                           ; A008 C5 60                    .`
        bcs     LA025                           ; A00A B0 19                    ..
        jsr     LA05E                           ; A00C 20 5E A0                  ^.
        bcc     LA025                           ; A00F 90 14                    ..
        tay                                     ; A011 A8                       .
        lda     $632C,y                         ; A012 B9 2C 63                 .,c
        ldy     LABD2                           ; A015 AC D2 AB                 ...
        cmp     #$04                            ; A018 C9 04                    ..
        bcc     LA025                           ; A01A 90 09                    ..
        cmp     #$0C                            ; A01C C9 0C                    ..
        bcs     LA025                           ; A01E B0 05                    ..
        lda     #$02                            ; A020 A9 02                    ..
LA022:  jmp     LA39B                           ; A022 4C 9B A3                 L..

; ----------------------------------------------------------------------------
LA025:  lda     #$02                            ; A025 A9 02                    ..
        sta     L0060                           ; A027 85 60                    .`
        ldx     LABD1                           ; A029 AE D1 AB                 ...
        lda     $60F4,x                         ; A02C BD F4 60                 ..`
        cmp     #$03                            ; A02F C9 03                    ..
        bcs     LA035                           ; A031 B0 02                    ..
        dec     L0060                           ; A033 C6 60                    .`
LA035:  lda     #$00                            ; A035 A9 00                    ..
        bit     $60EE                           ; A037 2C EE 60                 ,.`
        bpl     LA03F                           ; A03A 10 03                    ..
        lda     $60F6,x                         ; A03C BD F6 60                 ..`
LA03F:  clc                                     ; A03F 18                       .
        adc     $6102,x                         ; A040 7D 02 61                 }.a
        cmp     #$01                            ; A043 C9 01                    ..
        bcs     LA04B                           ; A045 B0 04                    ..
        dec     L0060                           ; A047 C6 60                    .`
        beq     LA056                           ; A049 F0 0B                    ..
LA04B:  lda     $60F6,x                         ; A04B BD F6 60                 ..`
        cmp     #$20                            ; A04E C9 20                    . 
        bcs     LA05A                           ; A050 B0 08                    ..
        dec     L0060                           ; A052 C6 60                    .`
        bne     LA05A                           ; A054 D0 04                    ..
LA056:  lda     #$01                            ; A056 A9 01                    ..
        bne     LA022                           ; A058 D0 C8                    ..
LA05A:  lda     #$04                            ; A05A A9 04                    ..
        bne     LA022                           ; A05C D0 C4                    ..
LA05E:  ldy     $60DF                           ; A05E AC DF 60                 ..`
        lda     LABD1                           ; A061 AD D1 AB                 ...
        bne     LA069                           ; A064 D0 03                    ..
        ldy     $60E0                           ; A066 AC E0 60                 ..`
LA069:  lda     LABD1                           ; A069 AD D1 AB                 ...
        beq     LA075                           ; A06C F0 07                    ..
        lda     $625C,y                         ; A06E B9 5C 62                 .\b
        bpl     LA07A                           ; A071 10 07                    ..
        bmi     LA08D                           ; A073 30 18                    0.
LA075:  lda     $61F4,y                         ; A075 B9 F4 61                 ..a
        bmi     LA08D                           ; A078 30 13                    0.
LA07A:  tay                                     ; A07A A8                       .
        lda     $6124,y                         ; A07B B9 24 61                 .$a
        cmp     #$0E                            ; A07E C9 0E                    ..
        bne     LA069                           ; A080 D0 E7                    ..
        lda     $6604,y                         ; A082 B9 04 66                 ..f
        cmp     LABD1                           ; A085 CD D1 AB                 ...
        bne     LA069                           ; A088 D0 DF                    ..
        tya                                     ; A08A 98                       .
        sec                                     ; A08B 38                       8
        .byte   $90                             ; A08C 90                       .
LA08D:  clc                                     ; A08D 18                       .
        ldy     LABD2                           ; A08E AC D2 AB                 ...
        rts                                     ; A091 60                       `

; ----------------------------------------------------------------------------
        ldy     LABD2                           ; A092 AC D2 AB                 ...
        lda     $6104,y                         ; A095 B9 04 61                 ..a
        bne     LA0D2                           ; A098 D0 38                    .8
        ldx     LABD1                           ; A09A AE D1 AB                 ...
        lda     $6394,y                         ; A09D B9 94 63                 ..c
        sec                                     ; A0A0 38                       8
        sbc     $6394,x                         ; A0A1 FD 94 63                 ..c
        sta     $60CD                           ; A0A4 8D CD 60                 ..`
        lda     $632C,y                         ; A0A7 B9 2C 63                 .,c
        sbc     $632C,x                         ; A0AA FD 2C 63                 .,c
        sta     $60CC                           ; A0AD 8D CC 60                 ..`
        bcs     LA0C7                           ; A0B0 B0 15                    ..
        eor     #$FF                            ; A0B2 49 FF                    I.
        sta     $60CC                           ; A0B4 8D CC 60                 ..`
        lda     $60CD                           ; A0B7 AD CD 60                 ..`
        eor     #$FF                            ; A0BA 49 FF                    I.
        sta     $60CD                           ; A0BC 8D CD 60                 ..`
        inc     $60CD                           ; A0BF EE CD 60                 ..`
        bne     LA0C7                           ; A0C2 D0 03                    ..
        .byte   $EE                             ; A0C4 EE                       .
LA0C5:  .byte   $CC                             ; A0C5 CC                       .
        rts                                     ; A0C6 60                       `

; ----------------------------------------------------------------------------
LA0C7:  lda     $60CC                           ; A0C7 AD CC 60                 ..`
        bne     LA0D2                           ; A0CA D0 06                    ..
        lda     L0060                           ; A0CC A5 60                    .`
        bmi     LA0D2                           ; A0CE 30 02                    0.
        clc                                     ; A0D0 18                       .
        rts                                     ; A0D1 60                       `

; ----------------------------------------------------------------------------
LA0D2:  sec                                     ; A0D2 38                       8
        rts                                     ; A0D3 60                       `

; ----------------------------------------------------------------------------
        jmp     LA407                           ; A0D4 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        .byte   $4C                             ; A0D7 4C                       L
        .byte   $07                             ; A0D8 07                       .
LA0D9:  ldy     $BC                             ; A0D9 A4 BC                    ..
        asl     $61                             ; A0DB 06 61                    .a
        lda     $6394,y                         ; A0DD B9 94 63                 ..c
        clc                                     ; A0E0 18                       .
        adc     #$06                            ; A0E1 69 06                    i.
        sta     $6060,x                         ; A0E3 9D 60 60                 .``
        lda     $632C,y                         ; A0E6 B9 2C 63                 .,c
        adc     #$00                            ; A0E9 69 00                    i.
        sta     $6062,x                         ; A0EB 9D 62 60                 .b`
        jmp     LA407                           ; A0EE 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        lda     $6100,x                         ; A0F1 BD 00 61                 ..a
        cmp     #$04                            ; A0F4 C9 04                    ..
        bcs     LA137                           ; A0F6 B0 3F                    .?
        ldy     $605C,x                         ; A0F8 BC 5C 60                 .\`
        cpy     #$01                            ; A0FB C0 01                    ..
        bne     LA14C                           ; A0FD D0 4D                    .M
        lda     $605A,x                         ; A0FF BD 5A 60                 .Z`
        cmp     #$03                            ; A102 C9 03                    ..
        bne     LA10C                           ; A104 D0 06                    ..
        jsr     LA5D1                           ; A106 20 D1 A5                  ..
        jmp     LA10F                           ; A109 4C 0F A1                 L..

; ----------------------------------------------------------------------------
LA10C:  jsr     LA9AF                           ; A10C 20 AF A9                  ..
LA10F:  bcs     LA13A                           ; A10F B0 29                    .)
        lda     $6110,x                         ; A111 BD 10 61                 ..a
        ora     $60F1                           ; A114 0D F1 60                 ..`
        bne     LA12E                           ; A117 D0 15                    ..
        ldy     $60FA,x                         ; A119 BC FA 60                 ..`
        lda     $6604,y                         ; A11C B9 04 66                 ..f
        cmp     LABD1                           ; A11F CD D1 AB                 ...
        beq     LA129                           ; A122 F0 05                    ..
        lda     $67A4,y                         ; A124 B9 A4 67                 ..g
        bne     LA137                           ; A127 D0 0E                    ..
LA129:  lda     #$CD                            ; A129 A9 CD                    ..
        sta     $60F1                           ; A12B 8D F1 60                 ..`
LA12E:  ldy     $6106,x                         ; A12E BC 06 61                 ..a
        jsr     LA919                           ; A131 20 19 A9                  ..
        jmp     LA407                           ; A134 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA137:  jmp     L9F1A                           ; A137 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
LA13A:  lda     L0060                           ; A13A A5 60                    .`
        sta     $6066,x                         ; A13C 9D 66 60                 .f`
        lda     #$0D                            ; A13F A9 0D                    ..
        sta     $6068,x                         ; A141 9D 68 60                 .h`
        lda     #$04                            ; A144 A9 04                    ..
        sta     $605C,x                         ; A146 9D 5C 60                 .\`
        jmp     LA407                           ; A149 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA14C:  cpy     #$02                            ; A14C C0 02                    ..
        bne     LA158                           ; A14E D0 08                    ..
        lda     #$04                            ; A150 A9 04                    ..
        sta     $6066,x                         ; A152 9D 66 60                 .f`
        jmp     LA407                           ; A155 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA158:  cpy     #$05                            ; A158 C0 05                    ..
        bne     LA17C                           ; A15A D0 20                    . 
        ldy     $6066,x                         ; A15C BC 66 60                 .f`
        lda     $6124,y                         ; A15F B9 24 61                 .$a
        cmp     #$0D                            ; A162 C9 0D                    ..
        bne     LA180                           ; A164 D0 1A                    ..
        lda     $6394,y                         ; A166 B9 94 63                 ..c
        clc                                     ; A169 18                       .
        adc     LAB7E,x                         ; A16A 7D 7E AB                 }~.
        sta     $6060,x                         ; A16D 9D 60 60                 .``
        lda     $632C,y                         ; A170 B9 2C 63                 .,c
        adc     LAB80,x                         ; A173 7D 80 AB                 }..
        sta     $6062,x                         ; A176 9D 62 60                 .b`
        jmp     LA407                           ; A179 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA17C:  cpy     #$07                            ; A17C C0 07                    ..
        bne     LA185                           ; A17E D0 05                    ..
LA180:  lda     #$00                            ; A180 A9 00                    ..
        sta     $605C,x                         ; A182 9D 5C 60                 .\`
LA185:  jmp     LA407                           ; A185 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        jmp     LA407                           ; A188 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        lda     $605C,x                         ; A18B BD 5C 60                 .\`
        bne     LA19A                           ; A18E D0 0A                    ..
        lda     #$40                            ; A190 A9 40                    .@
        jsr     LA7CF                           ; A192 20 CF A7                  ..
        bcc     LA19D                           ; A195 90 06                    ..
        inc     $605C,x                         ; A197 FE 5C 60                 .\`
LA19A:  jmp     LA407                           ; A19A 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA19D:  ldy     $60C3                           ; A19D AC C3 60                 ..`
        lda     $6394,y                         ; A1A0 B9 94 63                 ..c
        sta     $6060,x                         ; A1A3 9D 60 60                 .``
        lda     $632C,y                         ; A1A6 B9 2C 63                 .,c
        sta     $6062,x                         ; A1A9 9D 62 60                 .b`
        jmp     LA407                           ; A1AC 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA1AF:  jsr     LA05E                           ; A1AF 20 5E A0                  ^.
        bcc     LA1D9                           ; A1B2 90 25                    .%
        tay                                     ; A1B4 A8                       .
LA1B5:  lda     LABD1                           ; A1B5 AD D1 AB                 ...
        bne     LA1C1                           ; A1B8 D0 07                    ..
        lda     $61F4,y                         ; A1BA B9 F4 61                 ..a
        bpl     LA1C6                           ; A1BD 10 07                    ..
        bmi     LA1D9                           ; A1BF 30 18                    0.
LA1C1:  lda     $625C,y                         ; A1C1 B9 5C 62                 .\b
        bmi     LA1D9                           ; A1C4 30 13                    0.
LA1C6:  tay                                     ; A1C6 A8                       .
        lda     $6124,y                         ; A1C7 B9 24 61                 .$a
        cmp     #$06                            ; A1CA C9 06                    ..
        bne     LA1B5                           ; A1CC D0 E7                    ..
        lda     $6604,y                         ; A1CE B9 04 66                 ..f
        cmp     LABD1                           ; A1D1 CD D1 AB                 ...
        beq     LA1B5                           ; A1D4 F0 DF                    ..
        tya                                     ; A1D6 98                       .
        sec                                     ; A1D7 38                       8
        .byte   $90                             ; A1D8 90                       .
LA1D9:  clc                                     ; A1D9 18                       .
        ldy     LABD2                           ; A1DA AC D2 AB                 ...
        rts                                     ; A1DD 60                       `

; ----------------------------------------------------------------------------
        lda     $605C,x                         ; A1DE BD 5C 60                 .\`
        beq     LA1F1                           ; A1E1 F0 0E                    ..
        ldy     $606A,x                         ; A1E3 BC 6A 60                 .j`
        lda     $6124,y                         ; A1E6 B9 24 61                 .$a
        cmp     $6068,x                         ; A1E9 DD 68 60                 .h`
        beq     LA1FE                           ; A1EC F0 10                    ..
        jmp     L9F1A                           ; A1EE 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
LA1F1:  lda     $606A,x                         ; A1F1 BD 6A 60                 .j`
        sta     $6066,x                         ; A1F4 9D 66 60                 .f`
        tay                                     ; A1F7 A8                       .
        lda     $6124,y                         ; A1F8 B9 24 61                 .$a
        sta     $6068,x                         ; A1FB 9D 68 60                 .h`
LA1FE:  jmp     LA407                           ; A1FE 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        lda     $605C,x                         ; A201 BD 5C 60                 .\`
        beq     LA1F1                           ; A204 F0 EB                    ..
        cmp     #$02                            ; A206 C9 02                    ..
        bne     LA228                           ; A208 D0 1E                    ..
        ldy     $6066,x                         ; A20A BC 66 60                 .f`
        lda     $6124,y                         ; A20D B9 24 61                 .$a
        cmp     $6068,x                         ; A210 DD 68 60                 .h`
        bne     LA22B                           ; A213 D0 16                    ..
        lda     $6394,y                         ; A215 B9 94 63                 ..c
        clc                                     ; A218 18                       .
        adc     LAB7E,x                         ; A219 7D 7E AB                 }~.
        sta     $6060,x                         ; A21C 9D 60 60                 .``
        lda     $632C,y                         ; A21F B9 2C 63                 .,c
        adc     LAB80,x                         ; A222 7D 80 AB                 }..
        sta     $6062,x                         ; A225 9D 62 60                 .b`
LA228:  jmp     LA407                           ; A228 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA22B:  jmp     L9F1A                           ; A22B 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
        jmp     LA407                           ; A22E 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        ldy     $606A,x                         ; A231 BC 6A 60                 .j`
        lda     $6124,y                         ; A234 B9 24 61                 .$a
        cmp     $6068,x                         ; A237 DD 68 60                 .h`
        bne     LA263                           ; A23A D0 27                    .'
        lda     $605C,x                         ; A23C BD 5C 60                 .\`
        beq     LA260                           ; A23F F0 1F                    ..
        cmp     #$03                            ; A241 C9 03                    ..
        bcs     LA266                           ; A243 B0 21                    .!
        ldx     $60C3                           ; A245 AE C3 60                 ..`
        jsr     LA8F5                           ; A248 20 F5 A8                  ..
        lda     $61                             ; A24B A5 61                    .a
        bne     LA255                           ; A24D D0 06                    ..
        lda     L0060                           ; A24F A5 60                    .`
        cmp     #$2D                            ; A251 C9 2D                    .-
        bcc     LA266                           ; A253 90 11                    ..
LA255:  ldx     LABD1                           ; A255 AE D1 AB                 ...
        jsr     LA919                           ; A258 20 19 A9                  ..
        lda     #$01                            ; A25B A9 01                    ..
        sta     $605C,x                         ; A25D 9D 5C 60                 .\`
LA260:  jmp     LA407                           ; A260 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA263:  jmp     L9F1A                           ; A263 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
LA266:  ldx     $60C3                           ; A266 AE C3 60                 ..`
        lda     $63FC,x                         ; A269 BD FC 63                 ..c
        sta     L0060                           ; A26C 85 60                    .`
        lda     $64CC,y                         ; A26E B9 CC 64                 ..d
        asl     a                               ; A271 0A                       .
        sta     $64                             ; A272 85 64                    .d
        lda     $6394,y                         ; A274 B9 94 63                 ..c
        sta     $60CD                           ; A277 8D CD 60                 ..`
        lda     $632C,y                         ; A27A B9 2C 63                 .,c
        sta     $60CC                           ; A27D 8D CC 60                 ..`
        lda     #$00                            ; A280 A9 00                    ..
        sta     $63                             ; A282 85 63                    .c
        lda     #$DC                            ; A284 A9 DC                    ..
LA286:  cmp     L0060                           ; A286 C5 60                    .`
        bcc     LA290                           ; A288 90 06                    ..
        inc     $63                             ; A28A E6 63                    .c
        sbc     $63                             ; A28C E5 63                    .c
        bcs     LA286                           ; A28E B0 F6                    ..
LA290:  lda     $63                             ; A290 A5 63                    .c
        jsr     LA96D                           ; A292 20 6D A9                  m.
        ldy     $60C3                           ; A295 AC C3 60                 ..`
        jsr     LA949                           ; A298 20 49 A9                  I.
        lda     $61                             ; A29B A5 61                    .a
        bne     LA263                           ; A29D D0 C4                    ..
        lda     L0060                           ; A29F A5 60                    .`
        cmp     #$07                            ; A2A1 C9 07                    ..
        bcs     LA2AA                           ; A2A3 B0 05                    ..
        lda     #$FF                            ; A2A5 A9 FF                    ..
        sta     $60E6                           ; A2A7 8D E6 60                 ..`
LA2AA:  lda     $63                             ; A2AA A5 63                    .c
        lsr     a                               ; A2AC 4A                       J
        sta     $6066,x                         ; A2AD 9D 66 60                 .f`
        inc     $6066,x                         ; A2B0 FE 66 60                 .f`
        asl     a                               ; A2B3 0A                       .
        adc     #$02                            ; A2B4 69 02                    i.
        ldy     $606A,x                         ; A2B6 BC 6A 60                 .j`
        jsr     LA96D                           ; A2B9 20 6D A9                  m.
        lda     #$02                            ; A2BC A9 02                    ..
        sta     $605C,x                         ; A2BE 9D 5C 60                 .\`
        jmp     LA407                           ; A2C1 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        ldy     $606A,x                         ; A2C4 BC 6A 60                 .j`
        lda     $6124,y                         ; A2C7 B9 24 61                 .$a
        cmp     $6068,x                         ; A2CA DD 68 60                 .h`
        bne     LA2F9                           ; A2CD D0 2A                    .*
        lda     $605C,x                         ; A2CF BD 5C 60                 .\`
        cmp     #$03                            ; A2D2 C9 03                    ..
        bcs     LA2FC                           ; A2D4 B0 26                    .&
        lda     #$00                            ; A2D6 A9 00                    ..
        sta     $6066,x                         ; A2D8 9D 66 60                 .f`
        ldx     $60C3                           ; A2DB AE C3 60                 ..`
        jsr     LA8F5                           ; A2DE 20 F5 A8                  ..
        lda     $61                             ; A2E1 A5 61                    .a
        bne     LA2EB                           ; A2E3 D0 06                    ..
        lda     L0060                           ; A2E5 A5 60                    .`
        cmp     #$6E                            ; A2E7 C9 6E                    .n
        bcc     LA2FC                           ; A2E9 90 11                    ..
LA2EB:  ldx     LABD1                           ; A2EB AE D1 AB                 ...
        jsr     LA919                           ; A2EE 20 19 A9                  ..
        lda     #$01                            ; A2F1 A9 01                    ..
        sta     $605C,x                         ; A2F3 9D 5C 60                 .\`
        jmp     LA407                           ; A2F6 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA2F9:  jmp     L9F1A                           ; A2F9 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
LA2FC:  ldx     LABD1                           ; A2FC AE D1 AB                 ...
        lda     $6066,x                         ; A2FF BD 66 60                 .f`
        cmp     #$FF                            ; A302 C9 FF                    ..
        bne     LA311                           ; A304 D0 0B                    ..
        lda     #$05                            ; A306 A9 05                    ..
        sta     $605C,x                         ; A308 9D 5C 60                 .\`
        sta     $6066,x                         ; A30B 9D 66 60                 .f`
        jmp     LA407                           ; A30E 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA311:  ldy     $606A,x                         ; A311 BC 6A 60                 .j`
        lda     #$C9                            ; A314 A9 C9                    ..
        sta     L0060                           ; A316 85 60                    .`
        lda     #$FF                            ; A318 A9 FF                    ..
        sta     $61                             ; A31A 85 61                    .a
        lda     $64CC,y                         ; A31C B9 CC 64                 ..d
        bpl     LA327                           ; A31F 10 06                    ..
        lda     #$37                            ; A321 A9 37                    .7
        sta     L0060                           ; A323 85 60                    .`
        inc     $61                             ; A325 E6 61                    .a
LA327:  lda     $6394,y                         ; A327 B9 94 63                 ..c
        clc                                     ; A32A 18                       .
        adc     L0060                           ; A32B 65 60                    e`
        sta     $6060,x                         ; A32D 9D 60 60                 .``
        lda     $632C,y                         ; A330 B9 2C 63                 .,c
        adc     $61                             ; A333 65 61                    ea
        sta     $6062,x                         ; A335 9D 62 60                 .b`
        lda     #$02                            ; A338 A9 02                    ..
        sta     $6066,x                         ; A33A 9D 66 60                 .f`
        sta     $605C,x                         ; A33D 9D 5C 60                 .\`
        ldy     $60C3                           ; A340 AC C3 60                 ..`
        lda     $63FC,y                         ; A343 B9 FC 63                 ..c
        cmp     #$DA                            ; A346 C9 DA                    ..
        bcc     LA34F                           ; A348 90 05                    ..
        lda     #$FF                            ; A34A A9 FF                    ..
        sta     $60E5                           ; A34C 8D E5 60                 ..`
LA34F:  jmp     LA407                           ; A34F 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        ldy     LABD2                           ; A352 AC D2 AB                 ...
        lda     $6104,y                         ; A355 B9 04 61                 ..a
        beq     LA35D                           ; A358 F0 03                    ..
LA35A:  jmp     L9F1A                           ; A35A 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
LA35D:  lda     $6112,y                         ; A35D B9 12 61                 ..a
        tay                                     ; A360 A8                       .
        ldx     $60C3                           ; A361 AE C3 60                 ..`
        jsr     LA8F5                           ; A364 20 F5 A8                  ..
        lda     $61                             ; A367 A5 61                    .a
        bne     LA36F                           ; A369 D0 04                    ..
        lda     L0060                           ; A36B A5 60                    .`
        bpl     LA35A                           ; A36D 10 EB                    ..
LA36F:  ldx     LABD1                           ; A36F AE D1 AB                 ...
        jsr     LA919                           ; A372 20 19 A9                  ..
        lda     #$01                            ; A375 A9 01                    ..
        sta     $605C,x                         ; A377 9D 5C 60                 .\`
LA37A:  jmp     LA407                           ; A37A 4C 07 A4                 L..

; ----------------------------------------------------------------------------
        ldy     LABD2                           ; A37D AC D2 AB                 ...
        lda     $6104,y                         ; A380 B9 04 61                 ..a
        beq     LA388                           ; A383 F0 03                    ..
LA385:  jmp     L9F1A                           ; A385 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
LA388:  lda     $05                             ; A388 A5 05                    ..
        cmp     #$01                            ; A38A C9 01                    ..
        beq     LA393                           ; A38C F0 05                    ..
        lda     $6102,x                         ; A38E BD 02 61                 ..a
        bne     LA398                           ; A391 D0 05                    ..
LA393:  lda     $60F4,x                         ; A393 BD F4 60                 ..`
        beq     LA385                           ; A396 F0 ED                    ..
LA398:  jmp     LA407                           ; A398 4C 07 A4                 L..

; ----------------------------------------------------------------------------
LA39B:  ldx     LABD1                           ; A39B AE D1 AB                 ...
        sta     $6056,x                         ; A39E 9D 56 60                 .V`
        lda     #$00                            ; A3A1 A9 00                    ..
        sta     $6058,x                         ; A3A3 9D 58 60                 .X`
LA3A6:  ldx     LABD1                           ; A3A6 AE D1 AB                 ...
        ldy     $6056,x                         ; A3A9 BC 56 60                 .V`
        lda     LAA6B,y                         ; A3AC B9 6B AA                 .k.
        tay                                     ; A3AF A8                       .
        lda     LAA48,y                         ; A3B0 B9 48 AA                 .H.
        sta     $6054,x                         ; A3B3 9D 54 60                 .T`
        tya                                     ; A3B6 98                       .
        sec                                     ; A3B7 38                       8
        adc     $6058,x                         ; A3B8 7D 58 60                 }X`
        tay                                     ; A3BB A8                       .
        lda     LAA48,y                         ; A3BC B9 48 AA                 .H.
        sta     $605A,x                         ; A3BF 9D 5A 60                 .Z`
        lda     #$00                            ; A3C2 A9 00                    ..
        sta     $605C,x                         ; A3C4 9D 5C 60                 .\`
        lda     $6056,x                         ; A3C7 BD 56 60                 .V`
        asl     a                               ; A3CA 0A                       .
        tay                                     ; A3CB A8                       .
        lda     LAB39,y                         ; A3CC B9 39 AB                 .9.
        sta     L0060                           ; A3CF 85 60                    .`
        lda     LAB3A,y                         ; A3D1 B9 3A AB                 .:.
        sta     $61                             ; A3D4 85 61                    .a
        jmp     (L0060)                         ; A3D6 6C 60 00                 l`.

; ----------------------------------------------------------------------------
LA3D9:  ldx     LABD1                           ; A3D9 AE D1 AB                 ...
        ldy     $6056,x                         ; A3DC BC 56 60                 .V`
        lda     LAA6B,y                         ; A3DF B9 6B AA                 .k.
        sec                                     ; A3E2 38                       8
        adc     $6058,x                         ; A3E3 7D 58 60                 }X`
        tay                                     ; A3E6 A8                       .
        lda     LAA48,y                         ; A3E7 B9 48 AA                 .H.
        bpl     LA3EF                           ; A3EA 10 03                    ..
        jmp     L9F33                           ; A3EC 4C 33 9F                 L3.

; ----------------------------------------------------------------------------
LA3EF:  sta     $605A,x                         ; A3EF 9D 5A 60                 .Z`
LA3F2:  ldx     LABD1                           ; A3F2 AE D1 AB                 ...
        lda     $605A,x                         ; A3F5 BD 5A 60                 .Z`
        asl     a                               ; A3F8 0A                       .
        tay                                     ; A3F9 A8                       .
        lda     LAB1D,y                         ; A3FA B9 1D AB                 ...
        sta     L0060                           ; A3FD 85 60                    .`
        lda     LAB1E,y                         ; A3FF B9 1E AB                 ...
        sta     $61                             ; A402 85 61                    .a
        jmp     (L0060)                         ; A404 6C 60 00                 l`.

; ----------------------------------------------------------------------------
LA407:  ldx     LABD1                           ; A407 AE D1 AB                 ...
        ldy     $605A,x                         ; A40A BC 5A 60                 .Z`
        lda     LAAA5,y                         ; A40D B9 A5 AA                 ...
        clc                                     ; A410 18                       .
        adc     $605C,x                         ; A411 7D 5C 60                 }\`
        tay                                     ; A414 A8                       .
        lda     LAA72,y                         ; A415 B9 72 AA                 .r.
        bpl     LA41D                           ; A418 10 03                    ..
        jmp     L9F1A                           ; A41A 4C 1A 9F                 L..

; ----------------------------------------------------------------------------
LA41D:  sta     $605E,x                         ; A41D 9D 5E 60                 .^`
LA420:  ldx     LABD1                           ; A420 AE D1 AB                 ...
        lda     $605E,x                         ; A423 BD 5E 60                 .^`
        asl     a                               ; A426 0A                       .
        tay                                     ; A427 A8                       .
        lda     LAAFB,y                         ; A428 B9 FB AA                 ...
        sta     L0060                           ; A42B 85 60                    .`
        lda     LAAFC,y                         ; A42D B9 FC AA                 ...
        sta     $61                             ; A430 85 61                    .a
        jmp     (L0060)                         ; A432 6C 60 00                 l`.

; ----------------------------------------------------------------------------
LA435:  ldx     LABD1                           ; A435 AE D1 AB                 ...
        ldy     $60C3                           ; A438 AC C3 60                 ..`
        lda     $6060,x                         ; A43B BD 60 60                 .``
        sec                                     ; A43E 38                       8
        sbc     $6394,y                         ; A43F F9 94 63                 ..c
        sta     $60CD                           ; A442 8D CD 60                 ..`
        lda     $6062,x                         ; A445 BD 62 60                 .b`
        sbc     $632C,y                         ; A448 F9 2C 63                 .,c
        bmi     LA463                           ; A44B 30 16                    0.
        bne     LA45D                           ; A44D D0 0E                    ..
        ldy     $60CD                           ; A44F AC CD 60                 ..`
        cpy     #$1C                            ; A452 C0 1C                    ..
        bcs     LA45D                           ; A454 B0 07                    ..
        lda     LAB63,y                         ; A456 B9 63 AB                 .c.
        sta     $60E3                           ; A459 8D E3 60                 ..`
        rts                                     ; A45C 60                       `

; ----------------------------------------------------------------------------
LA45D:  lda     #$07                            ; A45D A9 07                    ..
        sta     $60E3                           ; A45F 8D E3 60                 ..`
        rts                                     ; A462 60                       `

; ----------------------------------------------------------------------------
LA463:  cmp     #$FF                            ; A463 C9 FF                    ..
        bne     LA475                           ; A465 D0 0E                    ..
        ldy     $60CD                           ; A467 AC CD 60                 ..`
        cpy     #$E5                            ; A46A C0 E5                    ..
        bcc     LA475                           ; A46C 90 07                    ..
        lda     LAA63,y                         ; A46E B9 63 AA                 .c.
        sta     $60E3                           ; A471 8D E3 60                 ..`
        rts                                     ; A474 60                       `

; ----------------------------------------------------------------------------
LA475:  lda     #$F9                            ; A475 A9 F9                    ..
        sta     $60E3                           ; A477 8D E3 60                 ..`
        rts                                     ; A47A 60                       `

; ----------------------------------------------------------------------------
        lda     #$01                            ; A47B A9 01                    ..
        sta     $606C,x                         ; A47D 9D 6C 60                 .l`
        jmp     LA3D9                           ; A480 4C D9 A3                 L..

; ----------------------------------------------------------------------------
        lda     $6058,x                         ; A483 BD 58 60                 .X`
        cmp     #$01                            ; A486 C9 01                    ..
        bne     LA4A1                           ; A488 D0 17                    ..
        lda     LABD2                           ; A48A AD D2 AB                 ...
        asl     a                               ; A48D 0A                       .
        tay                                     ; A48E A8                       .
        lda     $60BE,y                         ; A48F B9 BE 60                 ..`
        bmi     LA4A4                           ; A492 30 10                    0.
        tay                                     ; A494 A8                       .
        lda     $6394,y                         ; A495 B9 94 63                 ..c
        sta     $6060,x                         ; A498 9D 60 60                 .``
        lda     $632C,y                         ; A49B B9 2C 63                 .,c
        sta     $6062,x                         ; A49E 9D 62 60                 .b`
LA4A1:  jmp     LA3D9                           ; A4A1 4C D9 A3                 L..

; ----------------------------------------------------------------------------
LA4A4:  lda     $60E7                           ; A4A4 AD E7 60                 ..`
        sta     $6060,x                         ; A4A7 9D 60 60                 .``
        and     #$07                            ; A4AA 29 07                    ).
        sta     L0060                           ; A4AC 85 60                    .`
        lda     LABD2                           ; A4AE AD D2 AB                 ...
        asl     a                               ; A4B1 0A                       .
        asl     a                               ; A4B2 0A                       .
        asl     a                               ; A4B3 0A                       .
        ora     L0060                           ; A4B4 05 60                    .`
        sta     $6062,x                         ; A4B6 9D 62 60                 .b`
        jmp     LA3D9                           ; A4B9 4C D9 A3                 L..

; ----------------------------------------------------------------------------
        lda     $6058,x                         ; A4BC BD 58 60                 .X`
        cmp     #$01                            ; A4BF C9 01                    ..
        bne     LA4CE                           ; A4C1 D0 0B                    ..
        jsr     LA05E                           ; A4C3 20 5E A0                  ^.
        bcc     LA4E4                           ; A4C6 90 1C                    ..
        sta     $606A,x                         ; A4C8 9D 6A 60                 .j`
LA4CB:  jmp     LA3D9                           ; A4CB 4C D9 A3                 L..

; ----------------------------------------------------------------------------
LA4CE:  cmp     #$02                            ; A4CE C9 02                    ..
        bne     LA4CB                           ; A4D0 D0 F9                    ..
        ldy     $606A,x                         ; A4D2 BC 6A 60                 .j`
        lda     $6124,y                         ; A4D5 B9 24 61                 .$a
        cmp     #$0E                            ; A4D8 C9 0E                    ..
        bne     LA4E4                           ; A4DA D0 08                    ..
        lda     $6604,y                         ; A4DC B9 04 66                 ..f
        cmp     LABD1                           ; A4DF CD D1 AB                 ...
        beq     LA4CB                           ; A4E2 F0 E7                    ..
LA4E4:  jmp     L9F33                           ; A4E4 4C 33 9F                 L3.

; ----------------------------------------------------------------------------
        ldy     $606A,x                         ; A4E7 BC 6A 60                 .j`
        lda     $6124,y                         ; A4EA B9 24 61                 .$a
        bne     LA4F2                           ; A4ED D0 03                    ..
        jmp     L9F33                           ; A4EF 4C 33 9F                 L3.

; ----------------------------------------------------------------------------
LA4F2:  lda     $6394,y                         ; A4F2 B9 94 63                 ..c
        clc                                     ; A4F5 18                       .
        adc     LAB82,x                         ; A4F6 7D 82 AB                 }..
        sta     $6060,x                         ; A4F9 9D 60 60                 .``
        lda     $632C,y                         ; A4FC B9 2C 63                 .,c
        adc     LAB84,x                         ; A4FF 7D 84 AB                 }..
        sta     $6062,x                         ; A502 9D 62 60                 .b`
        jmp     LA3D9                           ; A505 4C D9 A3                 L..

; ----------------------------------------------------------------------------
        lda     $6058,x                         ; A508 BD 58 60                 .X`
        bne     LA528                           ; A50B D0 1B                    ..
        ldy     $60C3                           ; A50D AC C3 60                 ..`
        lda     $632C,y                         ; A510 B9 2C 63                 .,c
        ldx     LABD1                           ; A513 AE D1 AB                 ...
        bne     LA51F                           ; A516 D0 07                    ..
        cmp     #$04                            ; A518 C9 04                    ..
        bcs     LA523                           ; A51A B0 07                    ..
LA51C:  jmp     LA3D9                           ; A51C 4C D9 A3                 L..

; ----------------------------------------------------------------------------
LA51F:  cmp     #$0C                            ; A51F C9 0C                    ..
        bcs     LA51C                           ; A521 B0 F9                    ..
LA523:  inc     $6058,x                         ; A523 FE 58 60                 .X`
        lda     #$01                            ; A526 A9 01                    ..
LA528:  cmp     #$01                            ; A528 C9 01                    ..
        bne     LA560                           ; A52A D0 34                    .4
        jsr     LA839                           ; A52C 20 39 A8                  9.
        bcs     LA553                           ; A52F B0 22                    ."
        ldy     LABD2                           ; A531 AC D2 AB                 ...
        lda     $6104,y                         ; A534 B9 04 61                 ..a
        bne     LA54E                           ; A537 D0 15                    ..
        lda     $60F4,x                         ; A539 BD F4 60                 ..`
        bne     LA549                           ; A53C D0 0B                    ..
        lda     $05                             ; A53E A5 05                    ..
        cmp     #$01                            ; A540 C9 01                    ..
        beq     LA54E                           ; A542 F0 0A                    ..
        lda     $6102,x                         ; A544 BD 02 61                 ..a
        beq     LA596                           ; A547 F0 4D                    .M
LA549:  lda     #$05                            ; A549 A9 05                    ..
        jmp     LA39B                           ; A54B 4C 9B A3                 L..

; ----------------------------------------------------------------------------
LA54E:  lda     #$01                            ; A54E A9 01                    ..
        jmp     LA39B                           ; A550 4C 9B A3                 L..

; ----------------------------------------------------------------------------
LA553:  tya                                     ; A553 98                       .
        sta     $606A,x                         ; A554 9D 6A 60                 .j`
        lda     $6124,y                         ; A557 B9 24 61                 .$a
        sta     $6068,x                         ; A55A 9D 68 60                 .h`
        jmp     LA3D9                           ; A55D 4C D9 A3                 L..

; ----------------------------------------------------------------------------
LA560:  cmp     #$02                            ; A560 C9 02                    ..
        bne     LA593                           ; A562 D0 2F                    ./
        ldy     $606A,x                         ; A564 BC 6A 60                 .j`
        lda     $6124,y                         ; A567 B9 24 61                 .$a
        cmp     $6068,x                         ; A56A DD 68 60                 .h`
        bne     LA596                           ; A56D D0 27                    .'
        sta     L0060                           ; A56F 85 60                    .`
        ldy     #$03                            ; A571 A0 03                    ..
        lda     $05                             ; A573 A5 05                    ..
        cmp     #$05                            ; A575 C9 05                    ..
        bcs     LA58F                           ; A577 B0 16                    ..
        lda     $60F6,x                         ; A579 BD F6 60                 ..`
        beq     LA58F                           ; A57C F0 11                    ..
        ldy     #$05                            ; A57E A0 05                    ..
        lda     $60F4,x                         ; A580 BD F4 60                 ..`
        beq     LA58F                           ; A583 F0 0A                    ..
        lda     L0060                           ; A585 A5 60                    .`
        ldy     #$03                            ; A587 A0 03                    ..
        cmp     #$0E                            ; A589 C9 0E                    ..
        beq     LA58F                           ; A58B F0 02                    ..
        ldy     #$05                            ; A58D A0 05                    ..
LA58F:  tya                                     ; A58F 98                       .
        sta     $6058,x                         ; A590 9D 58 60                 .X`
LA593:  jmp     LA3D9                           ; A593 4C D9 A3                 L..

; ----------------------------------------------------------------------------
LA596:  jmp     L9F33                           ; A596 4C 33 9F                 L3.

; ----------------------------------------------------------------------------
        ldy     LABD2                           ; A599 AC D2 AB                 ...
        lda     $6104,y                         ; A59C B9 04 61                 ..a
        beq     LA5A4                           ; A59F F0 03                    ..
LA5A1:  jmp     L9F33                           ; A5A1 4C 33 9F                 L3.

; ----------------------------------------------------------------------------
LA5A4:  lda     $05                             ; A5A4 A5 05                    ..
        cmp     #$01                            ; A5A6 C9 01                    ..
        beq     LA5AF                           ; A5A8 F0 05                    ..
        lda     $6102,x                         ; A5AA BD 02 61                 ..a
        bne     LA5B4                           ; A5AD D0 05                    ..
LA5AF:  lda     $60F4,x                         ; A5AF BD F4 60                 ..`
        beq     LA5A1                           ; A5B2 F0 ED                    ..
LA5B4:  jmp     LA3D9                           ; A5B4 4C D9 A3                 L..

; ----------------------------------------------------------------------------
        lda     $6058,x                         ; A5B7 BD 58 60                 .X`
        bne     LA5CE                           ; A5BA D0 12                    ..
        lda     #$01                            ; A5BC A9 01                    ..
        ldx     $05                             ; A5BE A6 05                    ..
        beq     LA5C8                           ; A5C0 F0 06                    ..
        lda     #$05                            ; A5C2 A9 05                    ..
        sec                                     ; A5C4 38                       8
        sbc     $05                             ; A5C5 E5 05                    ..
        asl     a                               ; A5C7 0A                       .
LA5C8:  sta     $6068,x                         ; A5C8 9D 68 60                 .h`
        sta     $6066,x                         ; A5CB 9D 66 60                 .f`
LA5CE:  jmp     LA3D9                           ; A5CE 4C D9 A3                 L..

; ----------------------------------------------------------------------------
LA5D1:  jsr     LA05E                           ; A5D1 20 5E A0                  ^.
        pha                                     ; A5D4 48                       H
        php                                     ; A5D5 08                       .
        lda     #$04                            ; A5D6 A9 04                    ..
        sec                                     ; A5D8 38                       8
        sbc     $6100,x                         ; A5D9 FD 00 61                 ..a
        sta     $60A7                           ; A5DC 8D A7 60                 ..`
        lda     #$00                            ; A5DF A9 00                    ..
        sta     $64                             ; A5E1 85 64                    .d
        lda     #$08                            ; A5E3 A9 08                    ..
        sta     $65                             ; A5E5 85 65                    .e
        plp                                     ; A5E7 28                       (
        pla                                     ; A5E8 68                       h
        bcc     LA5FD                           ; A5E9 90 12                    ..
        tay                                     ; A5EB A8                       .
        lda     $6394,y                         ; A5EC B9 94 63                 ..c
        sec                                     ; A5EF 38                       8
        sbc     LAB7E,x                         ; A5F0 FD 7E AB                 .~.
        sta     $64                             ; A5F3 85 64                    .d
        lda     $632C,y                         ; A5F5 B9 2C 63                 .,c
        sbc     LAB80,x                         ; A5F8 FD 80 AB                 ...
        sta     $65                             ; A5FB 85 65                    .e
LA5FD:  ldx     #$00                            ; A5FD A2 00                    ..
        lda     LABD1                           ; A5FF AD D1 AB                 ...
        bne     LA66F                           ; A602 D0 6B                    .k
        ldy     $60DF                           ; A604 AC DF 60                 ..`
LA607:  lda     $625C,y                         ; A607 B9 5C 62                 .\b
        tay                                     ; A60A A8                       .
        lda     $632C,y                         ; A60B B9 2C 63                 .,c
        cmp     $65                             ; A60E C5 65                    .e
        bcc     LA61B                           ; A610 90 09                    ..
        bne     LA669                           ; A612 D0 55                    .U
        lda     $6394,y                         ; A614 B9 94 63                 ..c
        cmp     $64                             ; A617 C5 64                    .d
        bcs     LA669                           ; A619 B0 4E                    .N
LA61B:  txa                                     ; A61B 8A                       .
        beq     LA63A                           ; A61C F0 1C                    ..
        lda     $6394,y                         ; A61E B9 94 63                 ..c
        sec                                     ; A621 38                       8
        sbc     $62                             ; A622 E5 62                    .b
        sta     $61                             ; A624 85 61                    .a
        lda     $632C,y                         ; A626 B9 2C 63                 .,c
        sbc     $63                             ; A629 E5 63                    .c
        bne     LA633                           ; A62B D0 06                    ..
        lda     $61                             ; A62D A5 61                    .a
        cmp     #$50                            ; A62F C9 50                    .P
        bcc     LA63A                           ; A631 90 07                    ..
LA633:  cpx     $60A7                           ; A633 EC A7 60                 ..`
        bcs     LA66A                           ; A636 B0 32                    .2
        ldx     #$00                            ; A638 A2 00                    ..
LA63A:  lda     $6604,y                         ; A63A B9 04 66                 ..f
        bne     LA607                           ; A63D D0 C8                    ..
        lda     $6124,y                         ; A63F B9 24 61                 .$a
        cmp     #$0D                            ; A642 C9 0D                    ..
        bne     LA607                           ; A644 D0 C1                    ..
        lda     $67A4,y                         ; A646 B9 A4 67                 ..g
        bne     LA607                           ; A649 D0 BC                    ..
        txa                                     ; A64B 8A                       .
        bne     LA658                           ; A64C D0 0A                    ..
        lda     $632C,y                         ; A64E B9 2C 63                 .,c
        sta     $63                             ; A651 85 63                    .c
        lda     $6394,y                         ; A653 B9 94 63                 ..c
        sta     $62                             ; A656 85 62                    .b
LA658:  lda     $6394,y                         ; A658 B9 94 63                 ..c
        sta     $60CD                           ; A65B 8D CD 60                 ..`
        lda     $632C,y                         ; A65E B9 2C 63                 .,c
        sta     $60CC                           ; A661 8D CC 60                 ..`
        sty     L0060                           ; A664 84 60                    .`
        inx                                     ; A666 E8                       .
        bne     LA607                           ; A667 D0 9E                    ..
LA669:  clc                                     ; A669 18                       .
LA66A:  txa                                     ; A66A 8A                       .
        ldx     LABD1                           ; A66B AE D1 AB                 ...
        rts                                     ; A66E 60                       `

; ----------------------------------------------------------------------------
LA66F:  ldy     $60E0                           ; A66F AC E0 60                 ..`
LA672:  lda     $61F4,y                         ; A672 B9 F4 61                 ..a
        tay                                     ; A675 A8                       .
        lda     $632C,y                         ; A676 B9 2C 63                 .,c
        cmp     $65                             ; A679 C5 65                    .e
        bcc     LA6D4                           ; A67B 90 57                    .W
        bne     LA686                           ; A67D D0 07                    ..
        lda     $6394,y                         ; A67F B9 94 63                 ..c
        cmp     $64                             ; A682 C5 64                    .d
        bcc     LA6D4                           ; A684 90 4E                    .N
LA686:  txa                                     ; A686 8A                       .
        beq     LA6A4                           ; A687 F0 1B                    ..
        lda     $62                             ; A689 A5 62                    .b
        sec                                     ; A68B 38                       8
        sbc     $6394,y                         ; A68C F9 94 63                 ..c
        sta     $61                             ; A68F 85 61                    .a
        lda     $63                             ; A691 A5 63                    .c
        sbc     $632C,y                         ; A693 F9 2C 63                 .,c
        bne     LA69E                           ; A696 D0 06                    ..
        lda     $61                             ; A698 A5 61                    .a
        cmp     #$50                            ; A69A C9 50                    .P
        bcc     LA6A4                           ; A69C 90 06                    ..
LA69E:  cpx     #$04                            ; A69E E0 04                    ..
        bcs     LA6D4                           ; A6A0 B0 32                    .2
        ldx     #$00                            ; A6A2 A2 00                    ..
LA6A4:  lda     $6604,y                         ; A6A4 B9 04 66                 ..f
        beq     LA672                           ; A6A7 F0 C9                    ..
        lda     $6124,y                         ; A6A9 B9 24 61                 .$a
        cmp     #$0D                            ; A6AC C9 0D                    ..
        bne     LA672                           ; A6AE D0 C2                    ..
        lda     $67A4,y                         ; A6B0 B9 A4 67                 ..g
        bne     LA672                           ; A6B3 D0 BD                    ..
        txa                                     ; A6B5 8A                       .
        bne     LA6C2                           ; A6B6 D0 0A                    ..
        lda     $632C,y                         ; A6B8 B9 2C 63                 .,c
        sta     $63                             ; A6BB 85 63                    .c
        lda     $6394,y                         ; A6BD B9 94 63                 ..c
        sta     $62                             ; A6C0 85 62                    .b
LA6C2:  lda     $6394,y                         ; A6C2 B9 94 63                 ..c
        sta     $60CD                           ; A6C5 8D CD 60                 ..`
        lda     $632C,y                         ; A6C8 B9 2C 63                 .,c
        sta     $60CC                           ; A6CB 8D CC 60                 ..`
        sty     L0060                           ; A6CE 84 60                    .`
        inx                                     ; A6D0 E8                       .
        bne     LA672                           ; A6D1 D0 9F                    ..
        clc                                     ; A6D3 18                       .
LA6D4:  txa                                     ; A6D4 8A                       .
        ldx     LABD1                           ; A6D5 AE D1 AB                 ...
        rts                                     ; A6D8 60                       `

; ----------------------------------------------------------------------------
LA6D9:  lda     $6056,x                         ; A6D9 BD 56 60                 .V`
        cmp     #$06                            ; A6DC C9 06                    ..
        beq     LA73A                           ; A6DE F0 5A                    .Z
        ldy     $6114,x                         ; A6E0 BC 14 61                 ..a
        bmi     LA708                           ; A6E3 30 23                    0#
        lda     $05                             ; A6E5 A5 05                    ..
        cmp     #$05                            ; A6E7 C9 05                    ..
        bcc     LA6F0                           ; A6E9 90 05                    ..
        lda     $6100,x                         ; A6EB BD 00 61                 ..a
        beq     LA708                           ; A6EE F0 18                    ..
LA6F0:  ldx     $60C3                           ; A6F0 AE C3 60                 ..`
        jsr     LA8F5                           ; A6F3 20 F5 A8                  ..
        ldx     LABD1                           ; A6F6 AE D1 AB                 ...
        lda     $61                             ; A6F9 A5 61                    .a
        bne     LA708                           ; A6FB D0 0B                    ..
        lda     L0060                           ; A6FD A5 60                    .`
        cmp     #$C0                            ; A6FF C9 C0                    ..
        bcs     LA708                           ; A701 B0 05                    ..
LA703:  jsr     L9F33                           ; A703 20 33 9F                  3.
        sec                                     ; A706 38                       8
        rts                                     ; A707 60                       `

; ----------------------------------------------------------------------------
LA708:  lda     $6056,x                         ; A708 BD 56 60                 .V`
        beq     LA73A                           ; A70B F0 2D                    .-
        cmp     #$05                            ; A70D C9 05                    ..
        beq     LA729                           ; A70F F0 18                    ..
        lda     $05                             ; A711 A5 05                    ..
        cmp     #$05                            ; A713 C9 05                    ..
        bcs     LA71C                           ; A715 B0 05                    ..
        lda     $60F6,x                         ; A717 BD F6 60                 ..`
        bne     LA721                           ; A71A D0 05                    ..
LA71C:  lda     $6102,x                         ; A71C BD 02 61                 ..a
        beq     LA703                           ; A71F F0 E2                    ..
LA721:  jsr     LA8D8                           ; A721 20 D8 A8                  ..
        bcs     LA703                           ; A724 B0 DD                    ..
        ldx     LABD1                           ; A726 AE D1 AB                 ...
LA729:  lda     $6108,x                         ; A729 BD 08 61                 ..a
        cmp     #$20                            ; A72C C9 20                    . 
        bcc     LA703                           ; A72E 90 D3                    ..
        ldy     $60C3                           ; A730 AC C3 60                 ..`
        lda     $659C,y                         ; A733 B9 9C 65                 ..e
        cmp     #$05                            ; A736 C9 05                    ..
        bcc     LA703                           ; A738 90 C9                    ..
LA73A:  clc                                     ; A73A 18                       .
        rts                                     ; A73B 60                       `

; ----------------------------------------------------------------------------
LA73C:  lda     #$FF                            ; A73C A9 FF                    ..
        sta     L0060                           ; A73E 85 60                    .`
        ldy     $60C3                           ; A740 AC C3 60                 ..`
        lda     $6394,y                         ; A743 B9 94 63                 ..c
        sta     $60CD                           ; A746 8D CD 60                 ..`
        lda     $632C,y                         ; A749 B9 2C 63                 .,c
        sta     $60CC                           ; A74C 8D CC 60                 ..`
LA74F:  lda     $625C,y                         ; A74F B9 5C 62                 .\b
        bmi     LA773                           ; A752 30 1F                    0.
        tay                                     ; A754 A8                       .
        lda     $6394,y                         ; A755 B9 94 63                 ..c
        sec                                     ; A758 38                       8
        sbc     $60CD                           ; A759 ED CD 60                 ..`
        sta     $61                             ; A75C 85 61                    .a
        lda     $632C,y                         ; A75E B9 2C 63                 .,c
        sbc     $60CC                           ; A761 ED CC 60                 ..`
        bne     LA773                           ; A764 D0 0D                    ..
        lda     $6124,y                         ; A766 B9 24 61                 .$a
        cmp     #$08                            ; A769 C9 08                    ..
        bne     LA74F                           ; A76B D0 E2                    ..
        lda     $61                             ; A76D A5 61                    .a
        sta     L0060                           ; A76F 85 60                    .`
        sty     $62                             ; A771 84 62                    .b
LA773:  ldy     $60C3                           ; A773 AC C3 60                 ..`
LA776:  lda     $61F4,y                         ; A776 B9 F4 61                 ..a
        bmi     LA79C                           ; A779 30 21                    0!
        tay                                     ; A77B A8                       .
        lda     $60CD                           ; A77C AD CD 60                 ..`
        sec                                     ; A77F 38                       8
        sbc     $6394,y                         ; A780 F9 94 63                 ..c
        sta     $61                             ; A783 85 61                    .a
        lda     $60CC                           ; A785 AD CC 60                 ..`
        sbc     $632C,y                         ; A788 F9 2C 63                 .,c
        bne     LA79C                           ; A78B D0 0F                    ..
        lda     $6124,y                         ; A78D B9 24 61                 .$a
        cmp     #$08                            ; A790 C9 08                    ..
        bne     LA776                           ; A792 D0 E2                    ..
        sty     $62                             ; A794 84 62                    .b
        lda     $61                             ; A796 A5 61                    .a
        cmp     L0060                           ; A798 C5 60                    .`
        bcc     LA79E                           ; A79A 90 02                    ..
LA79C:  lda     L0060                           ; A79C A5 60                    .`
LA79E:  cmp     #$56                            ; A79E C9 56                    .V
        bcc     LA7A8                           ; A7A0 90 06                    ..
        lda     #$BF                            ; A7A2 A9 BF                    ..
        sta     $60E4                           ; A7A4 8D E4 60                 ..`
        rts                                     ; A7A7 60                       `

; ----------------------------------------------------------------------------
LA7A8:  ldy     $62                             ; A7A8 A4 62                    .b
        lda     $66D4,y                         ; A7AA B9 D4 66                 ..f
        bpl     LA7B9                           ; A7AD 10 0A                    ..
LA7AF:  lda     $63FC,y                         ; A7AF B9 FC 63                 ..c
        sec                                     ; A7B2 38                       8
        sbc     #$1E                            ; A7B3 E9 1E                    ..
        sta     $60E4                           ; A7B5 8D E4 60                 ..`
        rts                                     ; A7B8 60                       `

; ----------------------------------------------------------------------------
LA7B9:  lda     $673C,y                         ; A7B9 B9 3C 67                 .<g
        bpl     LA7AF                           ; A7BC 10 F1                    ..
        lda     $63FC,y                         ; A7BE B9 FC 63                 ..c
        cmp     #$64                            ; A7C1 C9 64                    .d
        bcc     LA7AF                           ; A7C3 90 EA                    ..
        lda     $6464,y                         ; A7C5 B9 64 64                 .dd
        clc                                     ; A7C8 18                       .
        adc     #$1E                            ; A7C9 69 1E                    i.
        sta     $60E4                           ; A7CB 8D E4 60                 ..`
        rts                                     ; A7CE 60                       `

; ----------------------------------------------------------------------------
LA7CF:  sta     $62                             ; A7CF 85 62                    .b
        lda     #$FF                            ; A7D1 A9 FF                    ..
        sta     L0060                           ; A7D3 85 60                    .`
        ldy     $60C3                           ; A7D5 AC C3 60                 ..`
        lda     $6394,y                         ; A7D8 B9 94 63                 ..c
        sta     $60CD                           ; A7DB 8D CD 60                 ..`
        lda     $632C,y                         ; A7DE B9 2C 63                 .,c
        sta     $60CC                           ; A7E1 8D CC 60                 ..`
LA7E4:  lda     $625C,y                         ; A7E4 B9 5C 62                 .\b
        bmi     LA807                           ; A7E7 30 1E                    0.
        tay                                     ; A7E9 A8                       .
        lda     $6394,y                         ; A7EA B9 94 63                 ..c
        sec                                     ; A7ED 38                       8
        sbc     $60CD                           ; A7EE ED CD 60                 ..`
        sta     $61                             ; A7F1 85 61                    .a
        lda     $632C,y                         ; A7F3 B9 2C 63                 .,c
        sbc     $60CC                           ; A7F6 ED CC 60                 ..`
        bne     LA807                           ; A7F9 D0 0C                    ..
        lda     $6604,y                         ; A7FB B9 04 66                 ..f
        cmp     LABD2                           ; A7FE CD D2 AB                 ...
        bne     LA7E4                           ; A801 D0 E1                    ..
        lda     $61                             ; A803 A5 61                    .a
        sta     L0060                           ; A805 85 60                    .`
LA807:  ldy     $60C3                           ; A807 AC C3 60                 ..`
LA80A:  lda     $61F4,y                         ; A80A B9 F4 61                 ..a
        bmi     LA82F                           ; A80D 30 20                    0 
        tay                                     ; A80F A8                       .
        lda     $60CD                           ; A810 AD CD 60                 ..`
        sec                                     ; A813 38                       8
        sbc     $6394,y                         ; A814 F9 94 63                 ..c
        sta     $61                             ; A817 85 61                    .a
        lda     $60CC                           ; A819 AD CC 60                 ..`
        sbc     $632C,y                         ; A81C F9 2C 63                 .,c
        bne     LA82F                           ; A81F D0 0E                    ..
        lda     $6604,y                         ; A821 B9 04 66                 ..f
        cmp     LABD2                           ; A824 CD D2 AB                 ...
        bne     LA80A                           ; A827 D0 E1                    ..
        lda     $61                             ; A829 A5 61                    .a
        cmp     L0060                           ; A82B C5 60                    .`
        bcc     LA831                           ; A82D 90 02                    ..
LA82F:  lda     L0060                           ; A82F A5 60                    .`
LA831:  cmp     $62                             ; A831 C5 62                    .b
        bcc     LA837                           ; A833 90 02                    ..
        clc                                     ; A835 18                       .
        rts                                     ; A836 60                       `

; ----------------------------------------------------------------------------
LA837:  sec                                     ; A837 38                       8
        rts                                     ; A838 60                       `

; ----------------------------------------------------------------------------
LA839:  ldy     $60C3                           ; A839 AC C3 60                 ..`
        lda     $632C,y                         ; A83C B9 2C 63                 .,c
        sta     $60CC                           ; A83F 8D CC 60                 ..`
        lda     $6394,y                         ; A842 B9 94 63                 ..c
        sta     $60CD                           ; A845 8D CD 60                 ..`
        lda     #$FF                            ; A848 A9 FF                    ..
        sta     L0060                           ; A84A 85 60                    .`
        sta     $61                             ; A84C 85 61                    .a
        sta     $60A7                           ; A84E 8D A7 60                 ..`
        ldy     $60DF                           ; A851 AC DF 60                 ..`
LA854:  lda     $625C,y                         ; A854 B9 5C 62                 .\b
        bmi     LA8CC                           ; A857 30 73                    0s
        tay                                     ; A859 A8                       .
        lda     $6604,y                         ; A85A B9 04 66                 ..f
        cmp     LABD1                           ; A85D CD D1 AB                 ...
        beq     LA854                           ; A860 F0 F2                    ..
        ldx     $6124,y                         ; A862 BE 24 61                 .$a
        lda     LABAB,x                         ; A865 BD AB AB                 ...
        bmi     LA854                           ; A868 30 EA                    0.
        sta     $60A8                           ; A86A 8D A8 60                 ..`
        tax                                     ; A86D AA                       .
        lda     $60CD                           ; A86E AD CD 60                 ..`
        sec                                     ; A871 38                       8
        sbc     $6394,y                         ; A872 F9 94 63                 ..c
        sta     $62                             ; A875 85 62                    .b
        lda     $60CC                           ; A877 AD CC 60                 ..`
        sbc     $632C,y                         ; A87A F9 2C 63                 .,c
        sta     $63                             ; A87D 85 63                    .c
        bcs     LA891                           ; A87F B0 10                    ..
        eor     #$FF                            ; A881 49 FF                    I.
        sta     $63                             ; A883 85 63                    .c
        lda     $62                             ; A885 A5 62                    .b
        eor     #$FF                            ; A887 49 FF                    I.
        adc     #$01                            ; A889 69 01                    i.
        sta     $62                             ; A88B 85 62                    .b
        bcc     LA891                           ; A88D 90 02                    ..
        inc     $63                             ; A88F E6 63                    .c
LA891:  inc     $63                             ; A891 E6 63                    .c
        lda     $62                             ; A893 A5 62                    .b
        sec                                     ; A895 38                       8
        sbc     LABC9,x                         ; A896 FD C9 AB                 ...
        sta     $64                             ; A899 85 64                    .d
        lda     $63                             ; A89B A5 63                    .c
        sbc     #$00                            ; A89D E9 00                    ..
        sta     $65                             ; A89F 85 65                    .e
        cmp     $61                             ; A8A1 C5 61                    .a
        bcc     LA8AF                           ; A8A3 90 0A                    ..
        bne     LA854                           ; A8A5 D0 AD                    ..
        lda     $64                             ; A8A7 A5 64                    .d
        cmp     L0060                           ; A8A9 C5 60                    .`
        bcc     LA8AF                           ; A8AB 90 02                    ..
        bne     LA854                           ; A8AD D0 A5                    ..
LA8AF:  lda     $6124,y                         ; A8AF B9 24 61                 .$a
        cmp     #$02                            ; A8B2 C9 02                    ..
        bne     LA8BE                           ; A8B4 D0 08                    ..
        ldx     $6604,y                         ; A8B6 BE 04 66                 ..f
        lda     $6104,x                         ; A8B9 BD 04 61                 ..a
        bne     LA854                           ; A8BC D0 96                    ..
LA8BE:  lda     $65                             ; A8BE A5 65                    .e
        sta     $61                             ; A8C0 85 61                    .a
        lda     $64                             ; A8C2 A5 64                    .d
        sta     L0060                           ; A8C4 85 60                    .`
        sty     $60A7                           ; A8C6 8C A7 60                 ..`
        jmp     LA854                           ; A8C9 4C 54 A8                 LT.

; ----------------------------------------------------------------------------
LA8CC:  ldx     LABD1                           ; A8CC AE D1 AB                 ...
        ldy     $60A7                           ; A8CF AC A7 60                 ..`
        bpl     LA8D6                           ; A8D2 10 02                    ..
        clc                                     ; A8D4 18                       .
        rts                                     ; A8D5 60                       `

; ----------------------------------------------------------------------------
LA8D6:  sec                                     ; A8D6 38                       8
        rts                                     ; A8D7 60                       `

; ----------------------------------------------------------------------------
LA8D8:  ldy     LABD2                           ; A8D8 AC D2 AB                 ...
        lda     $6104,y                         ; A8DB B9 04 61                 ..a
        bne     LA8F3                           ; A8DE D0 13                    ..
        ldx     $6112,y                         ; A8E0 BE 12 61                 ..a
        ldy     $60C3                           ; A8E3 AC C3 60                 ..`
        jsr     LA8F5                           ; A8E6 20 F5 A8                  ..
        lda     $61                             ; A8E9 A5 61                    .a
        bne     LA8F3                           ; A8EB D0 06                    ..
        lda     L0060                           ; A8ED A5 60                    .`
        bmi     LA8F3                           ; A8EF 30 02                    0.
        sec                                     ; A8F1 38                       8
        rts                                     ; A8F2 60                       `

; ----------------------------------------------------------------------------
LA8F3:  clc                                     ; A8F3 18                       .
        rts                                     ; A8F4 60                       `

; ----------------------------------------------------------------------------
LA8F5:  lda     $6394,y                         ; A8F5 B9 94 63                 ..c
        sec                                     ; A8F8 38                       8
        sbc     $6394,x                         ; A8F9 FD 94 63                 ..c
        sta     L0060                           ; A8FC 85 60                    .`
        lda     $632C,y                         ; A8FE B9 2C 63                 .,c
        sbc     $632C,x                         ; A901 FD 2C 63                 .,c
        sta     $61                             ; A904 85 61                    .a
        bcs     LA918                           ; A906 B0 10                    ..
        eor     #$FF                            ; A908 49 FF                    I.
        sta     $61                             ; A90A 85 61                    .a
        lda     L0060                           ; A90C A5 60                    .`
        eor     #$FF                            ; A90E 49 FF                    I.
        adc     #$01                            ; A910 69 01                    i.
        sta     L0060                           ; A912 85 60                    .`
        bcc     LA918                           ; A914 90 02                    ..
        inc     $61                             ; A916 E6 61                    .a
LA918:  rts                                     ; A918 60                       `

; ----------------------------------------------------------------------------
LA919:  lda     $632C,y                         ; A919 B9 2C 63                 .,c
        pha                                     ; A91C 48                       H
        lda     $6394,y                         ; A91D B9 94 63                 ..c
        ldy     $60C3                           ; A920 AC C3 60                 ..`
        sec                                     ; A923 38                       8
        sbc     $6394,y                         ; A924 F9 94 63                 ..c
        sta     L0060                           ; A927 85 60                    .`
        pla                                     ; A929 68                       h
        sbc     $632C,y                         ; A92A F9 2C 63                 .,c
        sta     $61                             ; A92D 85 61                    .a
        clc                                     ; A92F 18                       .
        bpl     LA933                           ; A930 10 01                    ..
        sec                                     ; A932 38                       8
LA933:  ror     $61                             ; A933 66 61                    fa
        ror     L0060                           ; A935 66 60                    f`
        lda     L0060                           ; A937 A5 60                    .`
        clc                                     ; A939 18                       .
        adc     $6394,y                         ; A93A 79 94 63                 y.c
        sta     $6060,x                         ; A93D 9D 60 60                 .``
        lda     $61                             ; A940 A5 61                    .a
        adc     $632C,y                         ; A942 79 2C 63                 y,c
        sta     $6062,x                         ; A945 9D 62 60                 .b`
        rts                                     ; A948 60                       `

; ----------------------------------------------------------------------------
LA949:  lda     $6394,y                         ; A949 B9 94 63                 ..c
        sec                                     ; A94C 38                       8
        sbc     $6060,x                         ; A94D FD 60 60                 .``
        sta     L0060                           ; A950 85 60                    .`
        lda     $632C,y                         ; A952 B9 2C 63                 .,c
        sbc     $6062,x                         ; A955 FD 62 60                 .b`
        sta     $61                             ; A958 85 61                    .a
        bcs     LA96C                           ; A95A B0 10                    ..
        eor     #$FF                            ; A95C 49 FF                    I.
        sta     $61                             ; A95E 85 61                    .a
        lda     L0060                           ; A960 A5 60                    .`
        eor     #$FF                            ; A962 49 FF                    I.
        adc     #$01                            ; A964 69 01                    i.
        sta     L0060                           ; A966 85 60                    .`
        bcc     LA96C                           ; A968 90 02                    ..
        inc     $61                             ; A96A E6 61                    .a
LA96C:  rts                                     ; A96C 60                       `

; ----------------------------------------------------------------------------
LA96D:  ldx     #$FA                            ; A96D A2 FA                    ..
        stx     $62                             ; A96F 86 62                    .b
        ldx     #$08                            ; A971 A2 08                    ..
        eor     #$FF                            ; A973 49 FF                    I.
LA975:  lsr     a                               ; A975 4A                       J
        bcs     LA980                           ; A976 B0 08                    ..
        pha                                     ; A978 48                       H
        lda     $62                             ; A979 A5 62                    .b
        adc     $64                             ; A97B 65 64                    ed
        sta     $62                             ; A97D 85 62                    .b
        pla                                     ; A97F 68                       h
LA980:  dex                                     ; A980 CA                       .
        bne     LA975                           ; A981 D0 F2                    ..
        lda     $62                             ; A983 A5 62                    .b
        bpl     LA988                           ; A985 10 01                    ..
        dex                                     ; A987 CA                       .
LA988:  clc                                     ; A988 18                       .
        adc     $60CD                           ; A989 6D CD 60                 m.`
        pha                                     ; A98C 48                       H
        txa                                     ; A98D 8A                       .
        adc     $60CC                           ; A98E 6D CC 60                 m.`
        ldx     LABD1                           ; A991 AE D1 AB                 ...
        sta     $6062,x                         ; A994 9D 62 60                 .b`
        pla                                     ; A997 68                       h
        sta     $6060,x                         ; A998 9D 60 60                 .``
        lda     $6124,y                         ; A99B B9 24 61                 .$a
        tay                                     ; A99E A8                       .
        lda     L6917,y                         ; A99F B9 17 69                 ..i
        lsr     a                               ; A9A2 4A                       J
        adc     $6060,x                         ; A9A3 7D 60 60                 }``
        sta     $6060,x                         ; A9A6 9D 60 60                 .``
        bcc     LA9AE                           ; A9A9 90 03                    ..
        inc     $6062,x                         ; A9AB FE 62 60                 .b`
LA9AE:  rts                                     ; A9AE 60                       `

; ----------------------------------------------------------------------------
LA9AF:  ldx     $60C3                           ; A9AF AE C3 60                 ..`
        lda     #$FF                            ; A9B2 A9 FF                    ..
        sta     $62                             ; A9B4 85 62                    .b
        sta     $63                             ; A9B6 85 63                    .c
        sta     $64                             ; A9B8 85 64                    .d
        ldy     $60C3                           ; A9BA AC C3 60                 ..`
LA9BD:  lda     $625C,y                         ; A9BD B9 5C 62                 .\b
        bmi     LA9DF                           ; A9C0 30 1D                    0.
        tay                                     ; A9C2 A8                       .
        lda     $6604,y                         ; A9C3 B9 04 66                 ..f
        cmp     LABD1                           ; A9C6 CD D1 AB                 ...
        bne     LA9BD                           ; A9C9 D0 F2                    ..
        lda     $6124,y                         ; A9CB B9 24 61                 .$a
        cmp     #$0D                            ; A9CE C9 0D                    ..
        bne     LA9BD                           ; A9D0 D0 EB                    ..
        jsr     LA8F5                           ; A9D2 20 F5 A8                  ..
        lda     L0060                           ; A9D5 A5 60                    .`
        sta     $62                             ; A9D7 85 62                    .b
        lda     $61                             ; A9D9 A5 61                    .a
        sta     $63                             ; A9DB 85 63                    .c
        sty     $64                             ; A9DD 84 64                    .d
LA9DF:  ldy     $60C3                           ; A9DF AC C3 60                 ..`
LA9E2:  lda     $61F4,y                         ; A9E2 B9 F4 61                 ..a
        bmi     LAA08                           ; A9E5 30 21                    0!
        tay                                     ; A9E7 A8                       .
        lda     $6604,y                         ; A9E8 B9 04 66                 ..f
        cmp     LABD1                           ; A9EB CD D1 AB                 ...
        bne     LA9E2                           ; A9EE D0 F2                    ..
        lda     $6124,y                         ; A9F0 B9 24 61                 .$a
        cmp     #$0D                            ; A9F3 C9 0D                    ..
        bne     LA9E2                           ; A9F5 D0 EB                    ..
        jsr     LA8F5                           ; A9F7 20 F5 A8                  ..
        lda     $61                             ; A9FA A5 61                    .a
        cmp     $63                             ; A9FC C5 63                    .c
        bcc     LAA0A                           ; A9FE 90 0A                    ..
        bne     LAA08                           ; AA00 D0 06                    ..
        lda     L0060                           ; AA02 A5 60                    .`
        cmp     $62                             ; AA04 C5 62                    .b
        bcc     LAA0A                           ; AA06 90 02                    ..
LAA08:  ldy     $64                             ; AA08 A4 64                    .d
LAA0A:  cpy     #$00                            ; AA0A C0 00                    ..
        clc                                     ; AA0C 18                       .
        bmi     LAA12                           ; AA0D 30 03                    0.
        sec                                     ; AA0F 38                       8
        sty     L0060                           ; AA10 84 60                    .`
LAA12:  ldx     LABD1                           ; AA12 AE D1 AB                 ...
        rts                                     ; AA15 60                       `

; ----------------------------------------------------------------------------
LAA16:  ldx     $60C3                           ; AA16 AE C3 60                 ..`
        lda     $6394,y                         ; AA19 B9 94 63                 ..c
        sec                                     ; AA1C 38                       8
        sbc     $6394,x                         ; AA1D FD 94 63                 ..c
        sta     L0060                           ; AA20 85 60                    .`
        lda     $632C,y                         ; AA22 B9 2C 63                 .,c
        sbc     $632C,x                         ; AA25 FD 2C 63                 .,c
        sta     $61                             ; AA28 85 61                    .a
        bcc     LAA36                           ; AA2A 90 0A                    ..
        bne     LAA32                           ; AA2C D0 04                    ..
        lda     L0060                           ; AA2E A5 60                    .`
        beq     LAA38                           ; AA30 F0 06                    ..
LAA32:  lda     #$01                            ; AA32 A9 01                    ..
        bne     LAA38                           ; AA34 D0 02                    ..
LAA36:  lda     #$FF                            ; AA36 A9 FF                    ..
LAA38:  sta     $60E3                           ; AA38 8D E3 60                 ..`
        rts                                     ; AA3B 60                       `

; ----------------------------------------------------------------------------
LAA3C:  cmp     #$00                            ; AA3C C9 00                    ..
        beq     LAA44                           ; AA3E F0 04                    ..
        bpl     LAA45                           ; AA40 10 03                    ..
        lda     #$FF                            ; AA42 A9 FF                    ..
LAA44:  rts                                     ; AA44 60                       `

; ----------------------------------------------------------------------------
LAA45:  lda     #$01                            ; AA45 A9 01                    ..
        rts                                     ; AA47 60                       `

; ----------------------------------------------------------------------------
LAA48:  ora     $02                             ; AA48 05 02                    ..
        brk                                     ; AA4A 00                       .
        ora     ($FF,x)                         ; AA4B 01 FF                    ..
        .byte   $03                             ; AA4D 03                       .
        .byte   $03                             ; AA4E 03                       .
        .byte   $04                             ; AA4F 04                       .
        ora     $FF                             ; AA50 05 FF                    ..
        .byte   $03                             ; AA52 03                       .
        .byte   $03                             ; AA53 03                       .
        asl     $05                             ; AA54 06 05                    ..
        .byte   $FF                             ; AA56 FF                       .
        .byte   $03                             ; AA57 03                       .
        .byte   $0B                             ; AA58 0B                       .
        .byte   $07                             ; AA59 07                       .
        ora     $FF                             ; AA5A 05 FF                    ..
        ora     ($03,x)                         ; AA5C 01 03                    ..
        asl     L0000                           ; AA5E 06 00                    ..
        ora     #$FF                            ; AA60 09 FF                    ..
        asl     a                               ; AA62 0A                       .
LAA63:  .byte   $FF                             ; AA63 FF                       .
        brk                                     ; AA64 00                       .
        .byte   $0C                             ; AA65 0C                       .
        ora     $02FF                           ; AA66 0D FF 02                 ...
        php                                     ; AA69 08                       .
        .byte   $FF                             ; AA6A FF                       .
LAA6B:  brk                                     ; AA6B 00                       .
        ora     $0A                             ; AA6C 05 0A                    ..
        .byte   $0F                             ; AA6E 0F                       .
        .byte   $14                             ; AA6F 14                       .
        .byte   $1C                             ; AA70 1C                       .
        .byte   $20                             ; AA71 20                        
LAA72:  .byte   $02                             ; AA72 02                       .
        .byte   $FF                             ; AA73 FF                       .
        brk                                     ; AA74 00                       .
        .byte   $FF                             ; AA75 FF                       .
        ora     ($04,x)                         ; AA76 01 04                    ..
        .byte   $FF                             ; AA78 FF                       .
        ora     ($04,x)                         ; AA79 01 04                    ..
        .byte   $0B                             ; AA7B 0B                       .
        .byte   $0C                             ; AA7C 0C                       .
        asl     a                               ; AA7D 0A                       .
        .byte   $02                             ; AA7E 02                       .
        ora     #$00                            ; AA7F 09 00                    ..
        .byte   $FF                             ; AA81 FF                       .
        ora     ($04,x)                         ; AA82 01 04                    ..
        .byte   $FF                             ; AA84 FF                       .
        .byte   $02                             ; AA85 02                       .
        .byte   $07                             ; AA86 07                       .
        .byte   $FF                             ; AA87 FF                       .
        ora     ($0A,x)                         ; AA88 01 0A                    ..
        .byte   $FF                             ; AA8A FF                       .
        ora     ($0A,x)                         ; AA8B 01 0A                    ..
        .byte   $FF                             ; AA8D FF                       .
        ora     ($0D,x)                         ; AA8E 01 0D                    ..
        .byte   $FF                             ; AA90 FF                       .
        ora     ($04,x)                         ; AA91 01 04                    ..
        .byte   $0B                             ; AA93 0B                       .
        brk                                     ; AA94 00                       .
        .byte   $FF                             ; AA95 FF                       .
        ora     ($04,x)                         ; AA96 01 04                    ..
        php                                     ; AA98 08                       .
        brk                                     ; AA99 00                       .
LAA9A:  .byte   $FF                             ; AA9A FF                       .
        .byte   $0B                             ; AA9B 0B                       .
        .byte   $FF                             ; AA9C FF                       .
        ora     ($04,x)                         ; AA9D 01 04                    ..
        brk                                     ; AA9F 00                       .
        .byte   $FF                             ; AAA0 FF                       .
        ora     ($0E,x)                         ; AAA1 01 0E                    ..
        .byte   $0F                             ; AAA3 0F                       .
        .byte   $FF                             ; AAA4 FF                       .
LAAA5:  brk                                     ; AAA5 00                       .
        .byte   $02                             ; AAA6 02                       .
        .byte   $04                             ; AAA7 04                       .
        .byte   $07                             ; AAA8 07                       .
        bpl     LAABE                           ; AAA9 10 13                    ..
        asl     $19,x                           ; AAAB 16 19                    ..
        .byte   $1C                             ; AAAD 1C                       .
        .byte   $1F                             ; AAAE 1F                       .
        bit     $07                             ; AAAF 24 07                    $.
        .byte   $2B                             ; AAB1 2B                       +
        .byte   $2F                             ; AAB2 2F                       /
        brk                                     ; AAB3 00                       .
        ora     ($02,x)                         ; AAB4 01 02                    ..
        .byte   $03                             ; AAB6 03                       .
        .byte   $04                             ; AAB7 04                       .
        ora     $06                             ; AAB8 05 06                    ..
        .byte   $07                             ; AABA 07                       .
        brk                                     ; AABB 00                       .
        brk                                     ; AABC 00                       .
        brk                                     ; AABD 00                       .
LAABE:  brk                                     ; AABE 00                       .
        brk                                     ; AABF 00                       .
        brk                                     ; AAC0 00                       .
        brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        brk                                     ; AAC3 00                       .
        brk                                     ; AAC4 00                       .
        brk                                     ; AAC5 00                       .
        brk                                     ; AAC6 00                       .
        ora     ($01,x)                         ; AAC7 01 01                    ..
        ora     ($01,x)                         ; AAC9 01 01                    ..
        brk                                     ; AACB 00                       .
        brk                                     ; AACC 00                       .
        ora     ($01,x)                         ; AACD 01 01                    ..
        .byte   $02                             ; AACF 02                       .
        .byte   $02                             ; AAD0 02                       .
        .byte   $02                             ; AAD1 02                       .
        .byte   $02                             ; AAD2 02                       .
        brk                                     ; AAD3 00                       .
        ora     ($01,x)                         ; AAD4 01 01                    ..
        .byte   $02                             ; AAD6 02                       .
        .byte   $02                             ; AAD7 02                       .
        .byte   $03                             ; AAD8 03                       .
        .byte   $03                             ; AAD9 03                       .
        .byte   $03                             ; AADA 03                       .
        brk                                     ; AADB 00                       .
        ora     ($02,x)                         ; AADC 01 02                    ..
        .byte   $02                             ; AADE 02                       .
        .byte   $03                             ; AADF 03                       .
        .byte   $03                             ; AAE0 03                       .
        .byte   $04                             ; AAE1 04                       .
        .byte   $04                             ; AAE2 04                       .
        brk                                     ; AAE3 00                       .
        ora     ($02,x)                         ; AAE4 01 02                    ..
        .byte   $03                             ; AAE6 03                       .
        .byte   $04                             ; AAE7 04                       .
        .byte   $04                             ; AAE8 04                       .
        ora     $05                             ; AAE9 05 05                    ..
        brk                                     ; AAEB 00                       .
        ora     ($02,x)                         ; AAEC 01 02                    ..
        .byte   $03                             ; AAEE 03                       .
        .byte   $04                             ; AAEF 04                       .
        ora     $06                             ; AAF0 05 06                    ..
        asl     L0000                           ; AAF2 06 00                    ..
        ora     ($02,x)                         ; AAF4 01 02                    ..
        .byte   $03                             ; AAF6 03                       .
        .byte   $04                             ; AAF7 04                       .
        ora     $06                             ; AAF8 05 06                    ..
        .byte   $07                             ; AAFA 07                       .
LAAFB:  .byte   $C2                             ; AAFB C2                       .
LAAFC:  .byte   $9B                             ; AAFC 9B                       .
        bne     LAA9A                           ; AAFD D0 9B                    ..
        inc     $9B                             ; AAFF E6 9B                    ..
        brk                                     ; AB01 00                       .
        .byte   $9C                             ; AB02 9C                       .
        ora     $319C,y                         ; AB03 19 9C 31                 ..1
        .byte   $9C                             ; AB06 9C                       .
        .byte   $32                             ; AB07 32                       2
        .byte   $9C                             ; AB08 9C                       .
        .byte   $33                             ; AB09 33                       3
        .byte   $9C                             ; AB0A 9C                       .
        .byte   $5C                             ; AB0B 5C                       \
        .byte   $9C                             ; AB0C 9C                       .
        sta     $9C                             ; AB0D 85 9C                    ..
        .byte   $F3                             ; AB0F F3                       .
        .byte   $9C                             ; AB10 9C                       .
        lsr     $9D                             ; AB11 46 9D                    F.
        .byte   $55                             ; AB13 55                       U
LAB14:  .byte   $9D                             ; AB14 9D                       .
LAB15:  eor     LAB9D,x                         ; AB15 5D 9D AB                 ]..
        sta     L9E3A,x                         ; AB18 9D 3A 9E                 .:.
        .byte   $EF                             ; AB1B EF                       .
        .byte   $9E                             ; AB1C 9E                       .
LAB1D:  .byte   $D4                             ; AB1D D4                       .
LAB1E:  ldy     #$D7                            ; AB1E A0 D7                    ..
        ldy     #$DA                            ; AB20 A0 DA                    ..
        ldy     #$F1                            ; AB22 A0 F1                    ..
        ldy     #$88                            ; AB24 A0 88                    ..
        lda     ($8B,x)                         ; AB26 A1 8B                    ..
        lda     ($DE,x)                         ; AB28 A1 DE                    ..
        lda     ($01,x)                         ; AB2A A1 01                    ..
        ldx     #$2E                            ; AB2C A2 2E                    ..
        ldx     #$31                            ; AB2E A2 31                    .1
        ldx     #$C4                            ; AB30 A2 C4                    ..
        ldx     #$F1                            ; AB32 A2 F1                    ..
        ldy     #$52                            ; AB34 A0 52                    .R
        .byte   $A3                             ; AB36 A3                       .
        .byte   $7D                             ; AB37 7D                       }
        .byte   $A3                             ; AB38 A3                       .
LAB39:  .byte   $7B                             ; AB39 7B                       {
LAB3A:  ldy     $83                             ; AB3A A4 83                    ..
        ldy     $BC                             ; AB3C A4 BC                    ..
        ldy     $E7                             ; AB3E A4 E7                    ..
        ldy     $08                             ; AB40 A4 08                    ..
        lda     L0099                           ; AB42 A5 99                    ..
        lda     $B7                             ; AB44 A5 B7                    ..
        lda     $FA                             ; AB46 A5 FA                    ..
        .byte   $FA                             ; AB48 FA                       .
        .byte   $FA                             ; AB49 FA                       .
        .byte   $FA                             ; AB4A FA                       .
        .byte   $FA                             ; AB4B FA                       .
        .byte   $FA                             ; AB4C FA                       .
        .byte   $FA                             ; AB4D FA                       .
        .byte   $FB                             ; AB4E FB                       .
        .byte   $FB                             ; AB4F FB                       .
        .byte   $FB                             ; AB50 FB                       .
        .byte   $FB                             ; AB51 FB                       .
        .byte   $FB                             ; AB52 FB                       .
        .byte   $FB                             ; AB53 FB                       .
        .byte   $FC                             ; AB54 FC                       .
        .byte   $FC                             ; AB55 FC                       .
        .byte   $FC                             ; AB56 FC                       .
        .byte   $FC                             ; AB57 FC                       .
        .byte   $FC                             ; AB58 FC                       .
        sbc     $FDFD,x                         ; AB59 FD FD FD                 ...
        sbc     $FEFE,x                         ; AB5C FD FE FE                 ...
        inc     $FFFF,x                         ; AB5F FE FF FF                 ...
        brk                                     ; AB62 00                       .
LAB63:  ora     ($01,x)                         ; AB63 01 01                    ..
        .byte   $02                             ; AB65 02                       .
        .byte   $02                             ; AB66 02                       .
        .byte   $02                             ; AB67 02                       .
        .byte   $03                             ; AB68 03                       .
        .byte   $03                             ; AB69 03                       .
        .byte   $03                             ; AB6A 03                       .
        .byte   $03                             ; AB6B 03                       .
        .byte   $04                             ; AB6C 04                       .
        .byte   $04                             ; AB6D 04                       .
        .byte   $04                             ; AB6E 04                       .
        .byte   $04                             ; AB6F 04                       .
        .byte   $04                             ; AB70 04                       .
        ora     $05                             ; AB71 05 05                    ..
        ora     $05                             ; AB73 05 05                    ..
        ora     $05                             ; AB75 05 05                    ..
        asl     $06                             ; AB77 06 06                    ..
        asl     $06                             ; AB79 06 06                    ..
        asl     $06                             ; AB7B 06 06                    ..
        .byte   $06                             ; AB7D 06                       .
LAB7E:  rti                                     ; AB7E 40                       @

; ----------------------------------------------------------------------------
        .byte   $C0                             ; AB7F C0                       .
LAB80:  brk                                     ; AB80 00                       .
        .byte   $FF                             ; AB81 FF                       .
LAB82:  cpx     #$20                            ; AB82 E0 20                    . 
LAB84:  .byte   $FF                             ; AB84 FF                       .
        brk                                     ; AB85 00                       .
        .byte   $FF                             ; AB86 FF                       .
        .byte   $FF                             ; AB87 FF                       .
        .byte   $FF                             ; AB88 FF                       .
        ora     ($01,x)                         ; AB89 01 01                    ..
        ora     ($FF,x)                         ; AB8B 01 FF                    ..
        brk                                     ; AB8D 00                       .
        ora     (L0000,x)                       ; AB8E 01 00                    ..
        brk                                     ; AB90 00                       .
        brk                                     ; AB91 00                       .
        brk                                     ; AB92 00                       .
        ora     ($01,x)                         ; AB93 01 01                    ..
        brk                                     ; AB95 00                       .
        ora     ($01,x)                         ; AB96 01 01                    ..
        brk                                     ; AB98 00                       .
        brk                                     ; AB99 00                       .
        brk                                     ; AB9A 00                       .
        brk                                     ; AB9B 00                       .
        brk                                     ; AB9C 00                       .
LAB9D:  brk                                     ; AB9D 00                       .
        brk                                     ; AB9E 00                       .
        brk                                     ; AB9F 00                       .
        brk                                     ; ABA0 00                       .
        brk                                     ; ABA1 00                       .
        brk                                     ; ABA2 00                       .
        brk                                     ; ABA3 00                       .
        ora     ($01,x)                         ; ABA4 01 01                    ..
        brk                                     ; ABA6 00                       .
        brk                                     ; ABA7 00                       .
        brk                                     ; ABA8 00                       .
        brk                                     ; ABA9 00                       .
        brk                                     ; ABAA 00                       .
LABAB:  brk                                     ; ABAB 00                       .
        .byte   $FF                             ; ABAC FF                       .
        .byte   $FF                             ; ABAD FF                       .
        .byte   $FF                             ; ABAE FF                       .
        .byte   $FF                             ; ABAF FF                       .
        .byte   $FF                             ; ABB0 FF                       .
        .byte   $FF                             ; ABB1 FF                       .
        .byte   $FF                             ; ABB2 FF                       .
        .byte   $FF                             ; ABB3 FF                       .
        .byte   $FF                             ; ABB4 FF                       .
        .byte   $FF                             ; ABB5 FF                       .
        .byte   $FF                             ; ABB6 FF                       .
        .byte   $FF                             ; ABB7 FF                       .
        brk                                     ; ABB8 00                       .
        ora     ($FF,x)                         ; ABB9 01 FF                    ..
        .byte   $02                             ; ABBB 02                       .
        .byte   $FF                             ; ABBC FF                       .
        .byte   $FF                             ; ABBD FF                       .
        .byte   $FF                             ; ABBE FF                       .
        .byte   $FF                             ; ABBF FF                       .
        .byte   $FF                             ; ABC0 FF                       .
        .byte   $FF                             ; ABC1 FF                       .
        .byte   $FF                             ; ABC2 FF                       .
        .byte   $FF                             ; ABC3 FF                       .
        .byte   $FF                             ; ABC4 FF                       .
        .byte   $FF                             ; ABC5 FF                       .
        .byte   $FF                             ; ABC6 FF                       .
        .byte   $FF                             ; ABC7 FF                       .
        .byte   $FF                             ; ABC8 FF                       .
LABC9:  brk                                     ; ABC9 00                       .
        brk                                     ; ABCA 00                       .
        brk                                     ; ABCB 00                       .
LABCC:  cmp     $C4                             ; ABCC C5 C4                    ..
        cmp     ($D4,x)                         ; ABCE C1 D4                    ..
        .byte   $CD                             ; ABD0 CD                       .
LABD1:  brk                                     ; ABD1 00                       .
LABD2:  brk                                     ; ABD2 00                       .
        brk                                     ; ABD3 00                       .
        brk                                     ; ABD4 00                       .
        brk                                     ; ABD5 00                       .
        brk                                     ; ABD6 00                       .
        brk                                     ; ABD7 00                       .
        brk                                     ; ABD8 00                       .
        brk                                     ; ABD9 00                       .
        brk                                     ; ABDA 00                       .
        brk                                     ; ABDB 00                       .
        brk                                     ; ABDC 00                       .
        brk                                     ; ABDD 00                       .
        brk                                     ; ABDE 00                       .
        brk                                     ; ABDF 00                       .
        brk                                     ; ABE0 00                       .
        brk                                     ; ABE1 00                       .
        brk                                     ; ABE2 00                       .
        brk                                     ; ABE3 00                       .
        brk                                     ; ABE4 00                       .
        brk                                     ; ABE5 00                       .
        brk                                     ; ABE6 00                       .
        brk                                     ; ABE7 00                       .
        brk                                     ; ABE8 00                       .
        brk                                     ; ABE9 00                       .
        brk                                     ; ABEA 00                       .
        brk                                     ; ABEB 00                       .
        brk                                     ; ABEC 00                       .
        brk                                     ; ABED 00                       .
        brk                                     ; ABEE 00                       .
        brk                                     ; ABEF 00                       .
        brk                                     ; ABF0 00                       .
        brk                                     ; ABF1 00                       .
        brk                                     ; ABF2 00                       .
        brk                                     ; ABF3 00                       .
        brk                                     ; ABF4 00                       .
        brk                                     ; ABF5 00                       .
        brk                                     ; ABF6 00                       .
        brk                                     ; ABF7 00                       .
        brk                                     ; ABF8 00                       .
        brk                                     ; ABF9 00                       .
        brk                                     ; ABFA 00                       .
        brk                                     ; ABFB 00                       .
        brk                                     ; ABFC 00                       .
        brk                                     ; ABFD 00                       .
        brk                                     ; ABFE 00                       .
        brk                                     ; ABFF 00                       .
LAC00:  jmp     LAC38                           ; AC00 4C 38 AC                 L8.

; ----------------------------------------------------------------------------
LAC03:  jmp     LAC38                           ; AC03 4C 38 AC                 L8.

; ----------------------------------------------------------------------------
LAC06:  jmp     LAC38                           ; AC06 4C 38 AC                 L8.

; ----------------------------------------------------------------------------
LAC09:  jmp     LACBC                           ; AC09 4C BC AC                 L..

; ----------------------------------------------------------------------------
LAC0C:  jmp     LAC5B                           ; AC0C 4C 5B AC                 L[.

; ----------------------------------------------------------------------------
LAC0F:  jmp     LAC85                           ; AC0F 4C 85 AC                 L..

; ----------------------------------------------------------------------------
LAC12:  ldy     $60C3                           ; AC12 AC C3 60                 ..`
        lda     $6124,y                         ; AC15 B9 24 61                 .$a
        cmp     #$02                            ; AC18 C9 02                    ..
        bne     LAC26                           ; AC1A D0 0A                    ..
        lda     $6604,y                         ; AC1C B9 04 66                 ..f
        beq     LAC26                           ; AC1F F0 05                    ..
        lda     $60A6                           ; AC21 AD A6 60                 ..`
        bmi     LAC38                           ; AC24 30 12                    0.
LAC26:  lda     $659C,y                         ; AC26 B9 9C 65                 ..e
        beq     LAC38                           ; AC29 F0 0D                    ..
        bmi     LAC38                           ; AC2B 30 0B                    0.
        sec                                     ; AC2D 38                       8
        sbc     $60B3                           ; AC2E ED B3 60                 ..`
        beq     LAC50                           ; AC31 F0 1D                    ..
        bcc     LAC50                           ; AC33 90 1B                    ..
        sta     $659C,y                         ; AC35 99 9C 65                 ..e
LAC38:  rts                                     ; AC38 60                       `

; ----------------------------------------------------------------------------
LAC39:  lda     #$FF                            ; AC39 A9 FF                    ..
        bmi     LAC55                           ; AC3B 30 18                    0.
LAC3D:  ldy     $60C3                           ; AC3D AC C3 60                 ..`
        lda     #$02                            ; AC40 A9 02                    ..
        sec                                     ; AC42 38                       8
        sbc     $6604,y                         ; AC43 F9 04 66                 ..f
        asl     a                               ; AC46 0A                       .
        asl     a                               ; AC47 0A                       .
        asl     a                               ; AC48 0A                       .
        asl     a                               ; AC49 0A                       .
        ldx     $6124,y                         ; AC4A BE 24 61                 .$a
        jmp     L690C                           ; AC4D 4C 0C 69                 L.i

; ----------------------------------------------------------------------------
LAC50:  jsr     LAC3D                           ; AC50 20 3D AC                  =.
        lda     #$00                            ; AC53 A9 00                    ..
LAC55:  ldy     $60C3                           ; AC55 AC C3 60                 ..`
        sta     $680C,y                         ; AC58 99 0C 68                 ..h
LAC5B:  ldy     $60C3                           ; AC5B AC C3 60                 ..`
        lda     $6124,y                         ; AC5E B9 24 61                 .$a
        beq     LAC84                           ; AC61 F0 21                    .!
        pha                                     ; AC63 48                       H
        lda     $66D4,y                         ; AC64 B9 D4 66                 ..f
        sta     $60E3                           ; AC67 8D E3 60                 ..`
        jsr     LB0CD                           ; AC6A 20 CD B0                  ..
        jsr     LB107                           ; AC6D 20 07 B1                  ..
        pla                                     ; AC70 68                       h
        asl     a                               ; AC71 0A                       .
        tay                                     ; AC72 A8                       .
LAC73:  lda     LB265,y                         ; AC73 B9 65 B2                 .e.
        sta     L0060                           ; AC76 85 60                    .`
        lda     LB266,y                         ; AC78 B9 66 B2                 .f.
        sta     $61                             ; AC7B 85 61                    .a
        ora     L0060                           ; AC7D 05 60                    .`
        beq     LAC85                           ; AC7F F0 04                    ..
        jmp     (L0060)                         ; AC81 6C 60 00                 l`.

; ----------------------------------------------------------------------------
LAC84:  rts                                     ; AC84 60                       `

; ----------------------------------------------------------------------------
LAC85:  ldy     $60C3                           ; AC85 AC C3 60                 ..`
        ldx     $6124,y                         ; AC88 BE 24 61                 .$a
        beq     LACBB                           ; AC8B F0 2E                    ..
        lda     #$00                            ; AC8D A9 00                    ..
        sta     $6124,y                         ; AC8F 99 24 61                 .$a
        lda     LB2DA,x                         ; AC92 BD DA B2                 ...
        beq     LACA8                           ; AC95 F0 11                    ..
        stx     L0060                           ; AC97 86 60                    .`
        ora     $6604,y                         ; AC99 19 04 66                 ..f
        tax                                     ; AC9C AA                       .
        dec     $6118,x                         ; AC9D DE 18 61                 ..a
        ldx     $6604,y                         ; ACA0 BE 04 66                 ..f
        dec     $6118,x                         ; ACA3 DE 18 61                 ..a
        ldx     L0060                           ; ACA6 A6 60                    .`
LACA8:  lda     L6953,x                         ; ACA8 BD 53 69                 .Si
        beq     LACBB                           ; ACAB F0 0E                    ..
        ldx     $61F4,y                         ; ACAD BE F4 61                 ..a
        lda     $625C,y                         ; ACB0 B9 5C 62                 .\b
        sta     $625C,x                         ; ACB3 9D 5C 62                 .\b
        tay                                     ; ACB6 A8                       .
        txa                                     ; ACB7 8A                       .
        sta     $61F4,y                         ; ACB8 99 F4 61                 ..a
LACBB:  rts                                     ; ACBB 60                       `

; ----------------------------------------------------------------------------
LACBC:  lda     $60C6                           ; ACBC AD C6 60                 ..`
        bne     LACE3                           ; ACBF D0 22                    ."
        lda     $60DF                           ; ACC1 AD DF 60                 ..`
        sta     $60C4                           ; ACC4 8D C4 60                 ..`
LACC7:  ldy     $60C4                           ; ACC7 AC C4 60                 ..`
        sty     $6087                           ; ACCA 8C 87 60                 ..`
LACCD:  ldx     $625C,y                         ; ACCD BE 5C 62                 .\b
        stx     $60C4                           ; ACD0 8E C4 60                 ..`
        lda     $625C,x                         ; ACD3 BD 5C 62                 .\b
        bmi     LACE3                           ; ACD6 30 0B                    0.
        jsr     LACE4                           ; ACD8 20 E4 AC                  ..
        bcc     LACC7                           ; ACDB 90 EA                    ..
        ldy     $6087                           ; ACDD AC 87 60                 ..`
        bpl     LACCD                           ; ACE0 10 EB                    ..
LACE2:  clc                                     ; ACE2 18                       .
LACE3:  rts                                     ; ACE3 60                       `

; ----------------------------------------------------------------------------
LACE4:  ldy     $60C4                           ; ACE4 AC C4 60                 ..`
        lda     $618C,y                         ; ACE7 B9 8C 61                 ..a
        cmp     #$01                            ; ACEA C9 01                    ..
        bne     LACE2                           ; ACEC D0 F4                    ..
        sty     $60C5                           ; ACEE 8C C5 60                 ..`
        ldx     $6124,y                         ; ACF1 BE 24 61                 .$a
        cpx     #$08                            ; ACF4 E0 08                    ..
        beq     LAD16                           ; ACF6 F0 1E                    ..
        cpx     #$02                            ; ACF8 E0 02                    ..
        beq     LAD08                           ; ACFA F0 0C                    ..
LACFC:  lda     $63FC,y                         ; ACFC B9 FC 63                 ..c
        sta     $6084                           ; ACFF 8D 84 60                 ..`
        sec                                     ; AD02 38                       8
        sbc     L6935,x                         ; AD03 FD 35 69                 .5i
        bne     LAD1F                           ; AD06 D0 17                    ..
LAD08:  stx     L0060                           ; AD08 86 60                    .`
        ldx     $6604,y                         ; AD0A BE 04 66                 ..f
        lda     $6104,x                         ; AD0D BD 04 61                 ..a
        bne     LACE2                           ; AD10 D0 D0                    ..
        ldx     L0060                           ; AD12 A6 60                    .`
        bpl     LACFC                           ; AD14 10 E6                    ..
LAD16:  lda     $6464,y                         ; AD16 B9 64 64                 .dd
        sta     $6084                           ; AD19 8D 84 60                 ..`
        lda     $63FC,y                         ; AD1C B9 FC 63                 ..c
LAD1F:  sta     $6085                           ; AD1F 8D 85 60                 ..`
        lda     $6394,y                         ; AD22 B9 94 63                 ..c
        clc                                     ; AD25 18                       .
        adc     L6917,x                         ; AD26 7D 17 69                 }.i
        sta     $6083                           ; AD29 8D 83 60                 ..`
        lda     $632C,y                         ; AD2C B9 2C 63                 .,c
        adc     #$00                            ; AD2F 69 00                    i.
        sta     $6082                           ; AD31 8D 82 60                 ..`
LAD34:  ldy     $60C5                           ; AD34 AC C5 60                 ..`
        sty     $6088                           ; AD37 8C 88 60                 ..`
LAD3A:  ldx     $625C,y                         ; AD3A BE 5C 62                 .\b
        stx     $60C5                           ; AD3D 8E C5 60                 ..`
        lda     $625C,x                         ; AD40 BD 5C 62                 .\b
        bmi     LAD82                           ; AD43 30 3D                    0=
        lda     $618C,x                         ; AD45 BD 8C 61                 ..a
        cmp     #$02                            ; AD48 C9 02                    ..
        beq     LAD34                           ; AD4A F0 E8                    ..
        lda     $632C,x                         ; AD4C BD 2C 63                 .,c
        cmp     $6082                           ; AD4F CD 82 60                 ..`
        bcc     LAD60                           ; AD52 90 0C                    ..
        bne     LAD82                           ; AD54 D0 2C                    .,
        lda     $6394,x                         ; AD56 BD 94 63                 ..c
        cmp     $6083                           ; AD59 CD 83 60                 ..`
        bcc     LAD60                           ; AD5C 90 02                    ..
        bne     LAD82                           ; AD5E D0 22                    ."
LAD60:  jsr     LAD86                           ; AD60 20 86 AD                  ..
        ldy     $60C4                           ; AD63 AC C4 60                 ..`
        ldx     $6124,y                         ; AD66 BE 24 61                 .$a
        beq     LAD84                           ; AD69 F0 19                    ..
        lda     L6953,x                         ; AD6B BD 53 69                 .Si
        beq     LAD84                           ; AD6E F0 14                    ..
        ldx     $60C5                           ; AD70 AE C5 60                 ..`
        ldy     $6124,x                         ; AD73 BC 24 61                 .$a
        beq     LAD7D                           ; AD76 F0 05                    ..
        lda     L6953,y                         ; AD78 B9 53 69                 .Si
        bne     LAD34                           ; AD7B D0 B7                    ..
LAD7D:  ldy     $6088                           ; AD7D AC 88 60                 ..`
        bpl     LAD3A                           ; AD80 10 B8                    ..
LAD82:  clc                                     ; AD82 18                       .
        rts                                     ; AD83 60                       `

; ----------------------------------------------------------------------------
LAD84:  sec                                     ; AD84 38                       8
        rts                                     ; AD85 60                       `

; ----------------------------------------------------------------------------
LAD86:  ldy     $6124,x                         ; AD86 BC 24 61                 .$a
        cpy     #$08                            ; AD89 C0 08                    ..
        beq     LADC2                           ; AD8B F0 35                    .5
        cpy     #$02                            ; AD8D C0 02                    ..
        bne     LAD9E                           ; AD8F D0 0D                    ..
        stx     L0060                           ; AD91 86 60                    .`
        lda     $6604,x                         ; AD93 BD 04 66                 ..f
        tax                                     ; AD96 AA                       .
        lda     $6104,x                         ; AD97 BD 04 61                 ..a
        bne     LADC1                           ; AD9A D0 25                    .%
        ldx     L0060                           ; AD9C A6 60                    .`
LAD9E:  lda     $63FC,x                         ; AD9E BD FC 63                 ..c
        cmp     $6085                           ; ADA1 CD 85 60                 ..`
        bcc     LADC1                           ; ADA4 90 1B                    ..
        beq     LADB6                           ; ADA6 F0 0E                    ..
        sbc     L6935,y                         ; ADA8 F9 35 69                 .5i
        cmp     $6084                           ; ADAB CD 84 60                 ..`
        beq     LADB2                           ; ADAE F0 02                    ..
        bcs     LADC1                           ; ADB0 B0 0F                    ..
LADB2:  cpy     #$02                            ; ADB2 C0 02                    ..
        beq     LADB9                           ; ADB4 F0 03                    ..
LADB6:  jmp     LAE2C                           ; ADB6 4C 2C AE                 L,.

; ----------------------------------------------------------------------------
LADB9:  ldx     $6604,y                         ; ADB9 BE 04 66                 ..f
        lda     $6104,x                         ; ADBC BD 04 61                 ..a
        beq     LADB6                           ; ADBF F0 F5                    ..
LADC1:  rts                                     ; ADC1 60                       `

; ----------------------------------------------------------------------------
LADC2:  lda     $63FC,x                         ; ADC2 BD FC 63                 ..c
        cmp     $6084                           ; ADC5 CD 84 60                 ..`
        beq     LADB2                           ; ADC8 F0 E8                    ..
        bcs     LADC1                           ; ADCA B0 F5                    ..
        lda     $6464,x                         ; ADCC BD 64 64                 .dd
        cmp     $6085                           ; ADCF CD 85 60                 ..`
        bcs     LADB2                           ; ADD2 B0 DE                    ..
        rts                                     ; ADD4 60                       `

; ----------------------------------------------------------------------------
        ldy     $60C3                           ; ADD5 AC C3 60                 ..`
        ldx     $6604,y                         ; ADD8 BE 04 66                 ..f
        lda     $6104,x                         ; ADDB BD 04 61                 ..a
        bne     LADC1                           ; ADDE D0 E1                    ..
        txa                                     ; ADE0 8A                       .
        beq     LADF3                           ; ADE1 F0 10                    ..
        lda     $60B6                           ; ADE3 AD B6 60                 ..`
        ora     $60C6                           ; ADE6 0D C6 60                 ..`
        bne     LADF3                           ; ADE9 D0 08                    ..
        dec     $60AB                           ; ADEB CE AB 60                 ..`
        bne     LADF3                           ; ADEE D0 03                    ..
        inc     $60B0                           ; ADF0 EE B0 60                 ..`
LADF3:  stx     $60BD                           ; ADF3 8E BD 60                 ..`
        lda     $63FC,y                         ; ADF6 B9 FC 63                 ..c
        cmp     #$D9                            ; ADF9 C9 D9                    ..
        bcs     LAE00                           ; ADFB B0 03                    ..
        inc     $610A,x                         ; ADFD FE 0A 61                 ..a
LAE00:  lda     #$30                            ; AE00 A9 30                    .0
        sta     $6104,x                         ; AE02 9D 04 61                 ..a
        lda     $6118,x                         ; AE05 BD 18 61                 ..a
        sec                                     ; AE08 38                       8
        sbc     $6100,x                         ; AE09 FD 00 61                 ..a
        sta     $6118,x                         ; AE0C 9D 18 61                 ..a
        lda     $611E,x                         ; AE0F BD 1E 61                 ..a
        sbc     $6100,x                         ; AE12 FD 00 61                 ..a
        sta     $611E,x                         ; AE15 9D 1E 61                 ..a
        lda     #$FF                            ; AE18 A9 FF                    ..
        sta     $6114,x                         ; AE1A 9D 14 61                 ..a
        sta     $62C4,y                         ; AE1D 99 C4 62                 ..b
        sta     $666C,y                         ; AE20 99 6C 66                 .lf
        ldx     $66D4,y                         ; AE23 BE D4 66                 ..f
        lda     #$00                            ; AE26 A9 00                    ..
        sta     $6124,x                         ; AE28 9D 24 61                 .$a
        rts                                     ; AE2B 60                       `

; ----------------------------------------------------------------------------
LAE2C:  lda     $60C4                           ; AE2C AD C4 60                 ..`
        tay                                     ; AE2F A8                       .
        pha                                     ; AE30 48                       H
        lda     $60C5                           ; AE31 AD C5 60                 ..`
        pha                                     ; AE34 48                       H
        jsr     LAE41                           ; AE35 20 41 AE                  A.
        pla                                     ; AE38 68                       h
        sta     $60C5                           ; AE39 8D C5 60                 ..`
        pla                                     ; AE3C 68                       h
        sta     $60C4                           ; AE3D 8D C4 60                 ..`
        rts                                     ; AE40 60                       `

; ----------------------------------------------------------------------------
LAE41:  lda     $6124,y                         ; AE41 B9 24 61                 .$a
        asl     a                               ; AE44 0A                       .
        tay                                     ; AE45 A8                       .
        lda     LB22E,y                         ; AE46 B9 2E B2                 ...
        beq     LAE55                           ; AE49 F0 0A                    ..
        sta     $61                             ; AE4B 85 61                    .a
        lda     LB22D,y                         ; AE4D B9 2D B2                 .-.
        sta     L0060                           ; AE50 85 60                    .`
        jmp     (L0060)                         ; AE52 6C 60 00                 l`.

; ----------------------------------------------------------------------------
LAE55:  ldx     $60C4                           ; AE55 AE C4 60                 ..`
        ldy     $60C5                           ; AE58 AC C5 60                 ..`
        sty     $60C4                           ; AE5B 8C C4 60                 ..`
        stx     $60C5                           ; AE5E 8E C5 60                 ..`
        lda     $6124,y                         ; AE61 B9 24 61                 .$a
        asl     a                               ; AE64 0A                       .
        tay                                     ; AE65 A8                       .
        lda     LB22E,y                         ; AE66 B9 2E B2                 ...
        beq     LAE92                           ; AE69 F0 27                    .'
        sta     $61                             ; AE6B 85 61                    .a
        lda     LB22D,y                         ; AE6D B9 2D B2                 .-.
        sta     L0060                           ; AE70 85 60                    .`
        jmp     (L0060)                         ; AE72 6C 60 00                 l`.

; ----------------------------------------------------------------------------
        ldx     $60C4                           ; AE75 AE C4 60                 ..`
        ldy     $60C5                           ; AE78 AC C5 60                 ..`
        lda     $6124,y                         ; AE7B B9 24 61                 .$a
        cmp     #$05                            ; AE7E C9 05                    ..
        beq     LAE98                           ; AE80 F0 16                    ..
        cmp     #$16                            ; AE82 C9 16                    ..
        beq     LAE93                           ; AE84 F0 0D                    ..
        cmp     #$17                            ; AE86 C9 17                    ..
        beq     LAE93                           ; AE88 F0 09                    ..
        cmp     #$04                            ; AE8A C9 04                    ..
        beq     LAE55                           ; AE8C F0 C7                    ..
        cmp     #$18                            ; AE8E C9 18                    ..
        bne     LAEA6                           ; AE90 D0 14                    ..
LAE92:  rts                                     ; AE92 60                       `

; ----------------------------------------------------------------------------
LAE93:  lda     $66D4,y                         ; AE93 B9 D4 66                 ..f
        bmi     LAEA0                           ; AE96 30 08                    0.
LAE98:  lda     $6604,y                         ; AE98 B9 04 66                 ..f
        cmp     $6604,x                         ; AE9B DD 04 66                 ..f
        beq     LAE92                           ; AE9E F0 F2                    ..
LAEA0:  stx     $60C3                           ; AEA0 8E C3 60                 ..`
        jmp     LAC50                           ; AEA3 4C 50 AC                 LP.

; ----------------------------------------------------------------------------
LAEA6:  cmp     #$19                            ; AEA6 C9 19                    ..
        beq     LAE92                           ; AEA8 F0 E8                    ..
        cmp     #$0D                            ; AEAA C9 0D                    ..
        beq     LAE92                           ; AEAC F0 E4                    ..
        cmp     #$0A                            ; AEAE C9 0A                    ..
        bne     LAEBD                           ; AEB0 D0 0B                    ..
LAEB2:  lda     $6604,y                         ; AEB2 B9 04 66                 ..f
        cmp     $6604,x                         ; AEB5 DD 04 66                 ..f
        beq     LAE92                           ; AEB8 F0 D8                    ..
LAEBA:  jmp     LB15F                           ; AEBA 4C 5F B1                 L_.

; ----------------------------------------------------------------------------
LAEBD:  cmp     #$12                            ; AEBD C9 12                    ..
        beq     LAEB2                           ; AEBF F0 F1                    ..
        cmp     #$1A                            ; AEC1 C9 1A                    ..
        beq     LAEB2                           ; AEC3 F0 ED                    ..
        cmp     #$0B                            ; AEC5 C9 0B                    ..
        beq     LAEDD                           ; AEC7 F0 14                    ..
        cmp     #$18                            ; AEC9 C9 18                    ..
        beq     LAEDD                           ; AECB F0 10                    ..
        cmp     #$14                            ; AECD C9 14                    ..
        beq     LAEDD                           ; AECF F0 0C                    ..
        cmp     #$07                            ; AED1 C9 07                    ..
        beq     LAEE0                           ; AED3 F0 0B                    ..
        cmp     #$08                            ; AED5 C9 08                    ..
        beq     LAEEA                           ; AED7 F0 11                    ..
        cmp     #$1B                            ; AED9 C9 1B                    ..
        bne     LAEB2                           ; AEDB D0 D5                    ..
LAEDD:  jmp     LAE55                           ; AEDD 4C 55 AE                 LU.

; ----------------------------------------------------------------------------
LAEE0:  lda     $66D4,y                         ; AEE0 B9 D4 66                 ..f
        ora     $67A4,y                         ; AEE3 19 A4 67                 ..g
        bpl     LAEB2                           ; AEE6 10 CA                    ..
        bmi     LAEBA                           ; AEE8 30 D0                    0.
LAEEA:  lda     $66D4,y                         ; AEEA B9 D4 66                 ..f
        ora     $673C,y                         ; AEED 19 3C 67                 .<g
        bpl     LAEB2                           ; AEF0 10 C0                    ..
        bmi     LAEBA                           ; AEF2 30 C6                    0.
        ldy     $60C4                           ; AEF4 AC C4 60                 ..`
        ldx     $60C5                           ; AEF7 AE C5 60                 ..`
        lda     $6124,x                         ; AEFA BD 24 61                 .$a
        cmp     #$16                            ; AEFD C9 16                    ..
        beq     LAF45                           ; AEFF F0 44                    .D
        cmp     #$17                            ; AF01 C9 17                    ..
        beq     LAF45                           ; AF03 F0 40                    .@
        cmp     #$05                            ; AF05 C9 05                    ..
        beq     LAF35                           ; AF07 F0 2C                    .,
        cmp     #$1B                            ; AF09 C9 1B                    ..
        beq     LAF31                           ; AF0B F0 24                    .$
        lda     $6124,y                         ; AF0D B9 24 61                 .$a
        cmp     #$1A                            ; AF10 C9 1A                    ..
        beq     LAF1C                           ; AF12 F0 08                    ..
        lda     $67A4,y                         ; AF14 B9 A4 67                 ..g
        ora     $6464,y                         ; AF17 19 64 64                 .dd
        beq     LAF24                           ; AF1A F0 08                    ..
LAF1C:  lda     $6604,y                         ; AF1C B9 04 66                 ..f
        cmp     $6604,x                         ; AF1F DD 04 66                 ..f
        beq     LAF31                           ; AF22 F0 0D                    ..
LAF24:  lda     $6124,x                         ; AF24 BD 24 61                 .$a
        cmp     #$0B                            ; AF27 C9 0B                    ..
        beq     LAF32                           ; AF29 F0 07                    ..
        cmp     #$0A                            ; AF2B C9 0A                    ..
        beq     LAF32                           ; AF2D F0 03                    ..
        bne     LAFA4                           ; AF2F D0 73                    .s
LAF31:  rts                                     ; AF31 60                       `

; ----------------------------------------------------------------------------
LAF32:  jmp     LB15F                           ; AF32 4C 5F B1                 L_.

; ----------------------------------------------------------------------------
LAF35:  lda     $67A4,y                         ; AF35 B9 A4 67                 ..g
        ora     $6464,y                         ; AF38 19 64 64                 .dd
        beq     LAF45                           ; AF3B F0 08                    ..
        lda     $6604,y                         ; AF3D B9 04 66                 ..f
        cmp     $6604,x                         ; AF40 DD 04 66                 ..f
        beq     LAF31                           ; AF43 F0 EC                    ..
LAF45:  sty     $60C3                           ; AF45 8C C3 60                 ..`
        jmp     LAC50                           ; AF48 4C 50 AC                 LP.

; ----------------------------------------------------------------------------
LAF4B:  ldy     $60C5                           ; AF4B AC C5 60                 ..`
        lda     $6124,y                         ; AF4E B9 24 61                 .$a
        cmp     #$12                            ; AF51 C9 12                    ..
        beq     LAF31                           ; AF53 F0 DC                    ..
        cmp     #$0E                            ; AF55 C9 0E                    ..
        beq     LAF31                           ; AF57 F0 D8                    ..
        cmp     #$1B                            ; AF59 C9 1B                    ..
        beq     LAF31                           ; AF5B F0 D4                    ..
        cmp     #$10                            ; AF5D C9 10                    ..
        bne     LAF68                           ; AF5F D0 07                    ..
        lda     $659C,y                         ; AF61 B9 9C 65                 ..e
        lsr     a                               ; AF64 4A                       J
        sta     $659C,y                         ; AF65 99 9C 65                 ..e
LAF68:  ldy     $60C4                           ; AF68 AC C4 60                 ..`
        ldx     $60C5                           ; AF6B AE C5 60                 ..`
        lda     $6124,x                         ; AF6E BD 24 61                 .$a
        cmp     #$0B                            ; AF71 C9 0B                    ..
        beq     LAF31                           ; AF73 F0 BC                    ..
        cmp     #$07                            ; AF75 C9 07                    ..
        bne     LAF83                           ; AF77 D0 0A                    ..
        lda     $66D4,y                         ; AF79 B9 D4 66                 ..f
        ora     $67A4,y                         ; AF7C 19 A4 67                 ..g
        bmi     LAFA1                           ; AF7F 30 20                    0 
        lda     #$07                            ; AF81 A9 07                    ..
LAF83:  cmp     #$0D                            ; AF83 C9 0D                    ..
        beq     LAF8B                           ; AF85 F0 04                    ..
        cmp     #$19                            ; AF87 C9 19                    ..
        bne     LAF92                           ; AF89 D0 07                    ..
LAF8B:  lda     $6124,y                         ; AF8B B9 24 61                 .$a
        cmp     #$0A                            ; AF8E C9 0A                    ..
        beq     LAFDC                           ; AF90 F0 4A                    .J
LAF92:  lda     $6124,y                         ; AF92 B9 24 61                 .$a
        cmp     #$1B                            ; AF95 C9 1B                    ..
        beq     LAFA1                           ; AF97 F0 08                    ..
        lda     $6604,y                         ; AF99 B9 04 66                 ..f
        cmp     $6604,x                         ; AF9C DD 04 66                 ..f
        beq     LB004                           ; AF9F F0 63                    .c
LAFA1:  lda     $6124,x                         ; AFA1 BD 24 61                 .$a
LAFA4:  cmp     #$17                            ; AFA4 C9 17                    ..
        beq     LAFFB                           ; AFA6 F0 53                    .S
        cmp     #$16                            ; AFA8 C9 16                    ..
        beq     LAFFB                           ; AFAA F0 4F                    .O
        cmp     #$08                            ; AFAC C9 08                    ..
        beq     LB004                           ; AFAE F0 54                    .T
        cmp     #$1C                            ; AFB0 C9 1C                    ..
        beq     LB005                           ; AFB2 F0 51                    .Q
        cmp     #$18                            ; AFB4 C9 18                    ..
        beq     LB005                           ; AFB6 F0 4D                    .M
        cmp     #$14                            ; AFB8 C9 14                    ..
        beq     LB005                           ; AFBA F0 49                    .I
        cmp     #$02                            ; AFBC C9 02                    ..
        bne     LAFD1                           ; AFBE D0 11                    ..
        ldy     $60C4                           ; AFC0 AC C4 60                 ..`
        lda     $6124,y                         ; AFC3 B9 24 61                 .$a
        cmp     #$0B                            ; AFC6 C9 0B                    ..
        beq     LAFD1                           ; AFC8 F0 07                    ..
        cmp     #$1B                            ; AFCA C9 1B                    ..
        beq     LAFD1                           ; AFCC F0 03                    ..
        jmp     LAE55                           ; AFCE 4C 55 AE                 LU.

; ----------------------------------------------------------------------------
LAFD1:  cmp     #$12                            ; AFD1 C9 12                    ..
        beq     LAFD9                           ; AFD3 F0 04                    ..
        cmp     #$1A                            ; AFD5 C9 1A                    ..
        bne     LAFDC                           ; AFD7 D0 03                    ..
LAFD9:  jmp     LB15F                           ; AFD9 4C 5F B1                 L_.

; ----------------------------------------------------------------------------
LAFDC:  lda     $659C,x                         ; AFDC BD 9C 65                 ..e
        beq     LB004                           ; AFDF F0 23                    .#
        ldy     $60C4                           ; AFE1 AC C4 60                 ..`
        lda     $659C,y                         ; AFE4 B9 9C 65                 ..e
        sta     $60B3                           ; AFE7 8D B3 60                 ..`
        lda     $60C5                           ; AFEA AD C5 60                 ..`
        sta     $60C3                           ; AFED 8D C3 60                 ..`
        lda     $60C4                           ; AFF0 AD C4 60                 ..`
        pha                                     ; AFF3 48                       H
        jsr     LAC12                           ; AFF4 20 12 AC                  ..
        pla                                     ; AFF7 68                       h
        sta     $60C4                           ; AFF8 8D C4 60                 ..`
LAFFB:  lda     $60C4                           ; AFFB AD C4 60                 ..`
        sta     $60C3                           ; AFFE 8D C3 60                 ..`
        jmp     LAC50                           ; B001 4C 50 AC                 LP.

; ----------------------------------------------------------------------------
LB004:  rts                                     ; B004 60                       `

; ----------------------------------------------------------------------------
LB005:  lda     $60C4                           ; B005 AD C4 60                 ..`
        sta     $60C3                           ; B008 8D C3 60                 ..`
        jmp     LAC39                           ; B00B 4C 39 AC                 L9.

; ----------------------------------------------------------------------------
        ldy     $60C5                           ; B00E AC C5 60                 ..`
        ldx     $60C4                           ; B011 AE C4 60                 ..`
        lda     $6604,x                         ; B014 BD 04 66                 ..f
        cmp     $6604,y                         ; B017 D9 04 66                 ..f
        beq     LB044                           ; B01A F0 28                    .(
        lda     $6124,y                         ; B01C B9 24 61                 .$a
        cmp     #$16                            ; B01F C9 16                    ..
        beq     LB045                           ; B021 F0 22                    ."
        cmp     #$17                            ; B023 C9 17                    ..
        beq     LB045                           ; B025 F0 1E                    ..
        cmp     #$0D                            ; B027 C9 0D                    ..
        beq     LB02F                           ; B029 F0 04                    ..
        cmp     #$19                            ; B02B C9 19                    ..
        bne     LB03A                           ; B02D D0 0B                    ..
LB02F:  sty     $60C3                           ; B02F 8C C3 60                 ..`
        lda     #$04                            ; B032 A9 04                    ..
        sta     $60B3                           ; B034 8D B3 60                 ..`
        jmp     LAC12                           ; B037 4C 12 AC                 L..

; ----------------------------------------------------------------------------
LB03A:  cmp     #$0B                            ; B03A C9 0B                    ..
        bne     LB044                           ; B03C D0 06                    ..
        sty     $60C3                           ; B03E 8C C3 60                 ..`
        jmp     LAC39                           ; B041 4C 39 AC                 L9.

; ----------------------------------------------------------------------------
LB044:  rts                                     ; B044 60                       `

; ----------------------------------------------------------------------------
LB045:  jmp     LAE55                           ; B045 4C 55 AE                 LU.

; ----------------------------------------------------------------------------
        ldy     $60C5                           ; B048 AC C5 60                 ..`
        ldx     $60C4                           ; B04B AE C4 60                 ..`
        lda     $6124,y                         ; B04E B9 24 61                 .$a
        cmp     #$02                            ; B051 C9 02                    ..
        beq     LB044                           ; B053 F0 EF                    ..
        cmp     #$0D                            ; B055 C9 0D                    ..
        beq     LB05D                           ; B057 F0 04                    ..
        cmp     #$19                            ; B059 C9 19                    ..
        bne     LB03A                           ; B05B D0 DD                    ..
LB05D:  ldx     $66D4,y                         ; B05D BE D4 66                 ..f
        bmi     LB02F                           ; B060 30 CD                    0.
        lda     $6124,x                         ; B062 BD 24 61                 .$a
        cmp     #$17                            ; B065 C9 17                    ..
        beq     LB03A                           ; B067 F0 D1                    ..
        cmp     #$16                            ; B069 C9 16                    ..
        beq     LB03A                           ; B06B F0 CD                    ..
        bne     LB02F                           ; B06D D0 C0                    ..
        ldy     $60C3                           ; B06F AC C3 60                 ..`
        lda     #$FF                            ; B072 A9 FF                    ..
        ldx     $66D4,y                         ; B074 BE D4 66                 ..f
        bmi     LB07C                           ; B077 30 03                    0.
        sta     $66D4,x                         ; B079 9D D4 66                 ..f
LB07C:  ldx     $673C,y                         ; B07C BE 3C 67                 .<g
        bmi     LB084                           ; B07F 30 03                    0.
        sta     $673C,x                         ; B081 9D 3C 67                 .<g
LB084:  ldx     $6604,y                         ; B084 BE 04 66                 ..f
        lda     $6118,x                         ; B087 BD 18 61                 ..a
        sec                                     ; B08A 38                       8
        sbc     $67A4,y                         ; B08B F9 A4 67                 ..g
        sta     $6118,x                         ; B08E 9D 18 61                 ..a
        lda     $611E,x                         ; B091 BD 1E 61                 ..a
        sbc     $67A4,y                         ; B094 F9 A4 67                 ..g
        sta     $611E,x                         ; B097 9D 1E 61                 ..a
        jmp     LAC0F                           ; B09A 4C 0F AC                 L..

; ----------------------------------------------------------------------------
        ldy     $60C3                           ; B09D AC C3 60                 ..`
        lda     #$FF                            ; B0A0 A9 FF                    ..
        ldx     $67A4,y                         ; B0A2 BE A4 67                 ..g
        bmi     LB0AA                           ; B0A5 30 03                    0.
        sta     $66D4,x                         ; B0A7 9D D4 66                 ..f
LB0AA:  ldx     $66D4,y                         ; B0AA BE D4 66                 ..f
        bmi     LB0B2                           ; B0AD 30 03                    0.
        sta     $66D4,x                         ; B0AF 9D D4 66                 ..f
LB0B2:  jmp     LAC0F                           ; B0B2 4C 0F AC                 L..

; ----------------------------------------------------------------------------
        ldy     $60C3                           ; B0B5 AC C3 60                 ..`
        lda     #$FF                            ; B0B8 A9 FF                    ..
        ldx     $66D4,y                         ; B0BA BE D4 66                 ..f
        bmi     LB0C2                           ; B0BD 30 03                    0.
        sta     $67A4,x                         ; B0BF 9D A4 67                 ..g
LB0C2:  ldx     $673C,y                         ; B0C2 BE 3C 67                 .<g
        bmi     LB0CA                           ; B0C5 30 03                    0.
        sta     $673C,x                         ; B0C7 9D 3C 67                 .<g
LB0CA:  jmp     LAC0F                           ; B0CA 4C 0F AC                 L..

; ----------------------------------------------------------------------------
LB0CD:  ldx     $6124,y                         ; B0CD BE 24 61                 .$a
        stx     $60CF                           ; B0D0 8E CF 60                 ..`
        lda     LB2A0,x                         ; B0D3 BD A0 B2                 ...
        beq     LB106                           ; B0D6 F0 2E                    ..
        sta     $10                             ; B0D8 85 10                    ..
        lda     $680C,y                         ; B0DA B9 0C 68                 ..h
        bne     LB106                           ; B0DD D0 27                    .'
        cpx     #$0E                            ; B0DF E0 0E                    ..
        bne     LB0EC                           ; B0E1 D0 09                    ..
        ldx     $6604,y                         ; B0E3 BE 04 66                 ..f
        beq     LB0EC                           ; B0E6 F0 04                    ..
        lda     #$A1                            ; B0E8 A9 A1                    ..
        sta     $10                             ; B0EA 85 10                    ..
LB0EC:  lda     $632C,y                         ; B0EC B9 2C 63                 .,c
        sta     $60CC                           ; B0EF 8D CC 60                 ..`
        lda     $6394,y                         ; B0F2 B9 94 63                 ..c
        sta     $60CD                           ; B0F5 8D CD 60                 ..`
        lda     $63FC,y                         ; B0F8 B9 FC 63                 ..c
        sta     $60CE                           ; B0FB 8D CE 60                 ..`
        lda     #$11                            ; B0FE A9 11                    ..
        sta     $60A7                           ; B100 8D A7 60                 ..`
        jmp     L6F0C                           ; B103 4C 0C 6F                 L.o

; ----------------------------------------------------------------------------
LB106:  rts                                     ; B106 60                       `

; ----------------------------------------------------------------------------
LB107:  ldy     $60C3                           ; B107 AC C3 60                 ..`
        ldx     $6124,y                         ; B10A BE 24 61                 .$a
        lda     LB2BD,x                         ; B10D BD BD B2                 ...
        beq     LB15E                           ; B110 F0 4C                    .L
        tax                                     ; B112 AA                       .
        lda     $680C,y                         ; B113 B9 0C 68                 ..h
        bne     LB15E                           ; B116 D0 46                    .F
        lda     $64CC,y                         ; B118 B9 CC 64                 ..d
        sta     $60CF                           ; B11B 8D CF 60                 ..`
        lda     $6534,y                         ; B11E B9 34 65                 .4e
        sta     $60D0                           ; B121 8D D0 60                 ..`
        lda     $63FC,y                         ; B124 B9 FC 63                 ..c
        sta     $60CE                           ; B127 8D CE 60                 ..`
        cmp     #$DC                            ; B12A C9 DC                    ..
        bcc     LB138                           ; B12C 90 0A                    ..
        lda     $60D0                           ; B12E AD D0 60                 ..`
        bmi     LB138                           ; B131 30 05                    0.
        lda     #$F9                            ; B133 A9 F9                    ..
        sta     $60D0                           ; B135 8D D0 60                 ..`
LB138:  lda     $632C,y                         ; B138 B9 2C 63                 .,c
        sta     $60CC                           ; B13B 8D CC 60                 ..`
        lda     $6394,y                         ; B13E B9 94 63                 ..c
        sta     $60CD                           ; B141 8D CD 60                 ..`
        txa                                     ; B144 8A                       .
        stx     $60A8                           ; B145 8E A8 60                 ..`
        and     #$7F                            ; B148 29 7F                    ).
        jsr     L6F0F                           ; B14A 20 0F 6F                  .o
        lda     $60A8                           ; B14D AD A8 60                 ..`
        bmi     LB15E                           ; B150 30 0C                    0.
        lsr     a                               ; B152 4A                       J
        lsr     a                               ; B153 4A                       J
        ora     #$80                            ; B154 09 80                    ..
        sta     $60A8                           ; B156 8D A8 60                 ..`
        and     #$7F                            ; B159 29 7F                    ).
        jmp     L6F0F                           ; B15B 4C 0F 6F                 L.o

; ----------------------------------------------------------------------------
LB15E:  rts                                     ; B15E 60                       `

; ----------------------------------------------------------------------------
LB15F:  lda     $60C5                           ; B15F AD C5 60                 ..`
        sta     $60C3                           ; B162 8D C3 60                 ..`
        lda     $60C4                           ; B165 AD C4 60                 ..`
        pha                                     ; B168 48                       H
        jsr     LAC50                           ; B169 20 50 AC                  P.
        pla                                     ; B16C 68                       h
        sta     $60C3                           ; B16D 8D C3 60                 ..`
        jmp     LAC50                           ; B170 4C 50 AC                 LP.

; ----------------------------------------------------------------------------
        jmp     (L0060)                         ; B173 6C 60 00                 l`.

; ----------------------------------------------------------------------------
        lda     $60ED                           ; B176 AD ED 60                 ..`
        beq     LB1B4                           ; B179 F0 39                    .9
        ldy     $60C3                           ; B17B AC C3 60                 ..`
        lda     $6124,y                         ; B17E B9 24 61                 .$a
        sta     $60A8                           ; B181 8D A8 60                 ..`
        lda     $63FC,y                         ; B184 B9 FC 63                 ..c
        cmp     #$D6                            ; B187 C9 D6                    ..
        bcc     LB1B4                           ; B189 90 29                    .)
        lda     #$1D                            ; B18B A9 1D                    ..
        sta     $60A7                           ; B18D 8D A7 60                 ..`
        lda     $6394,y                         ; B190 B9 94 63                 ..c
        sec                                     ; B193 38                       8
        sbc     #$07                            ; B194 E9 07                    ..
        sta     $60CD                           ; B196 8D CD 60                 ..`
        lda     $632C,y                         ; B199 B9 2C 63                 .,c
        sbc     #$00                            ; B19C E9 00                    ..
        sta     $60CC                           ; B19E 8D CC 60                 ..`
        lda     $64CC,y                         ; B1A1 B9 CC 64                 ..d
        pha                                     ; B1A4 48                       H
        asl     a                               ; B1A5 0A                       .
        pla                                     ; B1A6 68                       h
        ror     a                               ; B1A7 6A                       j
        sta     $60CF                           ; B1A8 8D CF 60                 ..`
        lda     $6604,y                         ; B1AB B9 04 66                 ..f
        sta     $60BD                           ; B1AE 8D BD 60                 ..`
        jsr     L6F0C                           ; B1B1 20 0C 6F                  .o
LB1B4:  jmp     LAC0F                           ; B1B4 4C 0F AC                 L..

; ----------------------------------------------------------------------------
        ldy     $60C5                           ; B1B7 AC C5 60                 ..`
        ldx     $60C4                           ; B1BA AE C4 60                 ..`
        lda     $6604,x                         ; B1BD BD 04 66                 ..f
        cmp     $6604,y                         ; B1C0 D9 04 66                 ..f
        beq     LB1F1                           ; B1C3 F0 2C                    .,
        lda     $6124,y                         ; B1C5 B9 24 61                 .$a
        cmp     #$1C                            ; B1C8 C9 1C                    ..
        beq     LB1CF                           ; B1CA F0 03                    ..
        jmp     LAE55                           ; B1CC 4C 55 AE                 LU.

; ----------------------------------------------------------------------------
LB1CF:  lda     $67A4,x                         ; B1CF BD A4 67                 ..g
        beq     LB1F1                           ; B1D2 F0 1D                    ..
        dec     $67A4,x                         ; B1D4 DE A4 67                 ..g
        lda     $6604,x                         ; B1D7 BD 04 66                 ..f
        tax                                     ; B1DA AA                       .
        ldy     $60C4                           ; B1DB AC C4 60                 ..`
        lda     $6124,y                         ; B1DE B9 24 61                 .$a
        cmp     #$17                            ; B1E1 C9 17                    ..
        beq     LB1EB                           ; B1E3 F0 06                    ..
        dec     $6118,x                         ; B1E5 DE 18 61                 ..a
        .byte   $DE                             ; B1E8 DE                       .
LB1E9:  .byte   $1E                             ; B1E9 1E                       .
        .byte   $61                             ; B1EA 61                       a
LB1EB:  stx     $60C3                           ; B1EB 8E C3 60                 ..`
        jmp     LAC3D                           ; B1EE 4C 3D AC                 L=.

; ----------------------------------------------------------------------------
LB1F1:  rts                                     ; B1F1 60                       `

; ----------------------------------------------------------------------------
        ldy     $60C3                           ; B1F2 AC C3 60                 ..`
        lda     $673C,y                         ; B1F5 B9 3C 67                 .<g
        cmp     #$02                            ; B1F8 C9 02                    ..
        bne     LB20D                           ; B1FA D0 11                    ..
        lda     $6604,y                         ; B1FC B9 04 66                 ..f
        eor     #$01                            ; B1FF 49 01                    I.
        tax                                     ; B201 AA                       .
        tya                                     ; B202 98                       .
        cmp     $6114,x                         ; B203 DD 14 61                 ..a
        bne     LB20D                           ; B206 D0 05                    ..
        lda     #$FF                            ; B208 A9 FF                    ..
        sta     $6114,x                         ; B20A 9D 14 61                 ..a
LB20D:  jmp     LAC0F                           ; B20D 4C 0F AC                 L..

; ----------------------------------------------------------------------------
        .byte   $AC                             ; B210 AC                       .
LB211:  cmp     L0060                           ; B211 C5 60                    .`
        lda     $6124,y                         ; B213 B9 24 61                 .$a
        cmp     #$02                            ; B216 C9 02                    ..
        bne     LB22E                           ; B218 D0 14                    ..
        lda     $6604,y                         ; B21A B9 04 66                 ..f
        eor     #$01                            ; B21D 49 01                    I.
        tax                                     ; B21F AA                       .
        lda     $6106,x                         ; B220 BD 06 61                 ..a
        cmp     $60C4                           ; B223 CD C4 60                 ..`
        bne     LB22E                           ; B226 D0 06                    ..
        sty     $60C3                           ; B228 8C C3 60                 ..`
LB22B:  .byte   $4C                             ; B22B 4C                       L
        .byte   $50                             ; B22C 50                       P
LB22D:  .byte   $AC                             ; B22D AC                       .
LB22E:  rts                                     ; B22E 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; B22F 00                       .
        brk                                     ; B230 00                       .
        adc     $AE,x                           ; B231 75 AE                    u.
        brk                                     ; B233 00                       .
        brk                                     ; B234 00                       .
        bpl     LB1E9                           ; B235 10 B2                    ..
        brk                                     ; B237 00                       .
        brk                                     ; B238 00                       .
        brk                                     ; B239 00                       .
        brk                                     ; B23A 00                       .
        brk                                     ; B23B 00                       .
        brk                                     ; B23C 00                       .
        brk                                     ; B23D 00                       .
        brk                                     ; B23E 00                       .
        brk                                     ; B23F 00                       .
        brk                                     ; B240 00                       .
        pla                                     ; B241 68                       h
        .byte   $AF                             ; B242 AF                       .
        pla                                     ; B243 68                       h
        .byte   $AF                             ; B244 AF                       .
        brk                                     ; B245 00                       .
        brk                                     ; B246 00                       .
        brk                                     ; B247 00                       .
        brk                                     ; B248 00                       .
        brk                                     ; B249 00                       .
        brk                                     ; B24A 00                       .
        brk                                     ; B24B 00                       .
        brk                                     ; B24C 00                       .
        brk                                     ; B24D 00                       .
        brk                                     ; B24E 00                       .
        brk                                     ; B24F 00                       .
        brk                                     ; B250 00                       .
        .byte   $F4                             ; B251 F4                       .
        ldx     a:L0000                         ; B252 AE 00 00                 ...
        pha                                     ; B255 48                       H
        bcs     LB258                           ; B256 B0 00                    ..
LB258:  brk                                     ; B258 00                       .
        .byte   $B7                             ; B259 B7                       .
        lda     ($B7),y                         ; B25A B1 B7                    ..
        lda     ($48),y                         ; B25C B1 48                    .H
        bcs     LB260                           ; B25E B0 00                    ..
LB260:  brk                                     ; B260 00                       .
        .byte   $F4                             ; B261 F4                       .
        ldx     LAF4B                           ; B262 AE 4B AF                 .K.
LB265:  .byte   $0E                             ; B265 0E                       .
LB266:  bcs     LB268                           ; B266 B0 00                    ..
LB268:  brk                                     ; B268 00                       .
        cmp     $AD,x                           ; B269 D5 AD                    ..
        brk                                     ; B26B 00                       .
        brk                                     ; B26C 00                       .
        brk                                     ; B26D 00                       .
        brk                                     ; B26E 00                       .
        brk                                     ; B26F 00                       .
        brk                                     ; B270 00                       .
        .byte   $6F                             ; B271 6F                       o
        bcs     LB211                           ; B272 B0 9D                    ..
        bcs     LB22B                           ; B274 B0 B5                    ..
        bcs     LB278                           ; B276 B0 00                    ..
LB278:  brk                                     ; B278 00                       .
        ror     $B1,x                           ; B279 76 B1                    v.
        brk                                     ; B27B 00                       .
        brk                                     ; B27C 00                       .
        brk                                     ; B27D 00                       .
        brk                                     ; B27E 00                       .
        brk                                     ; B27F 00                       .
        brk                                     ; B280 00                       .
        brk                                     ; B281 00                       .
        brk                                     ; B282 00                       .
        brk                                     ; B283 00                       .
        brk                                     ; B284 00                       .
        brk                                     ; B285 00                       .
        brk                                     ; B286 00                       .
        brk                                     ; B287 00                       .
        brk                                     ; B288 00                       .
        .byte   $F2                             ; B289 F2                       .
        lda     (L0000),y                       ; B28A B1 00                    ..
        brk                                     ; B28C 00                       .
        brk                                     ; B28D 00                       .
        brk                                     ; B28E 00                       .
        brk                                     ; B28F 00                       .
        brk                                     ; B290 00                       .
        brk                                     ; B291 00                       .
        brk                                     ; B292 00                       .
        brk                                     ; B293 00                       .
        brk                                     ; B294 00                       .
        brk                                     ; B295 00                       .
        brk                                     ; B296 00                       .
        brk                                     ; B297 00                       .
        brk                                     ; B298 00                       .
        .byte   $7B                             ; B299 7B                       {
        lda     (L0000),y                       ; B29A B1 00                    ..
        brk                                     ; B29C 00                       .
        brk                                     ; B29D 00                       .
        brk                                     ; B29E 00                       .
        brk                                     ; B29F 00                       .
LB2A0:  brk                                     ; B2A0 00                       .
        brk                                     ; B2A1 00                       .
        .byte   $4B                             ; B2A2 4B                       K
        brk                                     ; B2A3 00                       .
        brk                                     ; B2A4 00                       .
        .byte   $4B                             ; B2A5 4B                       K
        eor     a:$4E                           ; B2A6 4D 4E 00                 MN.
        lsr     a                               ; B2A9 4A                       J
        eor     #$49                            ; B2AA 49 49                    II
        brk                                     ; B2AC 00                       .
        eor     #$A0                            ; B2AD 49 A0                    I.
        .byte   $4B                             ; B2AF 4B                       K
        jmp     L0000                           ; B2B0 4C 00 00                 L..

; ----------------------------------------------------------------------------
        brk                                     ; B2B3 00                       .
        brk                                     ; B2B4 00                       .
        brk                                     ; B2B5 00                       .
        brk                                     ; B2B6 00                       .
        brk                                     ; B2B7 00                       .
        brk                                     ; B2B8 00                       .
        eor     #$00                            ; B2B9 49 00                    I.
        brk                                     ; B2BB 00                       .
        brk                                     ; B2BC 00                       .
LB2BD:  brk                                     ; B2BD 00                       .
        brk                                     ; B2BE 00                       .
        .byte   $14                             ; B2BF 14                       .
        brk                                     ; B2C0 00                       .
        brk                                     ; B2C1 00                       .
        plp                                     ; B2C2 28                       (
        asl     a                               ; B2C3 0A                       .
        ora     L0000                           ; B2C4 05 00                    ..
        .byte   $04                             ; B2C6 04                       .
        brk                                     ; B2C7 00                       .
        brk                                     ; B2C8 00                       .
        brk                                     ; B2C9 00                       .
        sty     $0A                             ; B2CA 84 0A                    ..
        asl     a                               ; B2CC 0A                       .
        asl     a                               ; B2CD 0A                       .
        brk                                     ; B2CE 00                       .
        asl     L0000                           ; B2CF 06 00                    ..
        brk                                     ; B2D1 00                       .
        brk                                     ; B2D2 00                       .
        brk                                     ; B2D3 00                       .
        brk                                     ; B2D4 00                       .
        brk                                     ; B2D5 00                       .
        sty     $0A                             ; B2D6 84 0A                    ..
        brk                                     ; B2D8 00                       .
        brk                                     ; B2D9 00                       .
LB2DA:  brk                                     ; B2DA 00                       .
        brk                                     ; B2DB 00                       .
        brk                                     ; B2DC 00                       .
        brk                                     ; B2DD 00                       .
        brk                                     ; B2DE 00                       .
        brk                                     ; B2DF 00                       .
        .byte   $04                             ; B2E0 04                       .
        brk                                     ; B2E1 00                       .
        brk                                     ; B2E2 00                       .
        brk                                     ; B2E3 00                       .
        brk                                     ; B2E4 00                       .
        brk                                     ; B2E5 00                       .
        brk                                     ; B2E6 00                       .
        asl     $08                             ; B2E7 06 08                    ..
        .byte   $02                             ; B2E9 02                       .
        asl     a                               ; B2EA 0A                       .
        brk                                     ; B2EB 00                       .
        brk                                     ; B2EC 00                       .
        brk                                     ; B2ED 00                       .
        brk                                     ; B2EE 00                       .
        brk                                     ; B2EF 00                       .
        brk                                     ; B2F0 00                       .
        brk                                     ; B2F1 00                       .
        brk                                     ; B2F2 00                       .
        asl     L0000                           ; B2F3 06 00                    ..
        brk                                     ; B2F5 00                       .
        brk                                     ; B2F6 00                       .
        brk                                     ; B2F7 00                       .
        rts                                     ; B2F8 60                       `

; ----------------------------------------------------------------------------
        cmp     #$03                            ; B2F9 C9 03                    ..
        bne     LB303                           ; B2FB D0 06                    ..
        jsr     LA5C8                           ; B2FD 20 C8 A5                  ..
LB300:  jmp     LB312                           ; B300 4C 12 B3                 L..

; ----------------------------------------------------------------------------
LB303:  jmp     LB3CB                           ; B303 4C CB B3                 L..

; ----------------------------------------------------------------------------
LB306:  jmp     LB321                           ; B306 4C 21 B3                 L!.

; ----------------------------------------------------------------------------
LB309:  jmp     LB32A                           ; B309 4C 2A B3                 L*.

; ----------------------------------------------------------------------------
LB30C:  jmp     LB861                           ; B30C 4C 61 B8                 La.

; ----------------------------------------------------------------------------
LB30F:  jmp     LBA52                           ; B30F 4C 52 BA                 LR.

; ----------------------------------------------------------------------------
LB312:  lda     #$40                            ; B312 A9 40                    .@
        sta     L0000                           ; B314 85 00                    ..
        lda     #$00                            ; B316 A9 00                    ..
        sta     $60BA                           ; B318 8D BA 60                 ..`
        sta     $60AC                           ; B31B 8D AC 60                 ..`
        bit     $C054                           ; B31E 2C 54 C0                 ,T.
LB321:  lda     #$20                            ; B321 A9 20                    . 
LB323:  sta     $60A2                           ; B323 8D A2 60                 ..`
        sta     $60A3                           ; B326 8D A3 60                 ..`
        rts                                     ; B329 60                       `

; ----------------------------------------------------------------------------
LB32A:  pha                                     ; B32A 48                       H
        ldy     $6111                           ; B32B AC 11 61                 ..a
        beq     LB332                           ; B32E F0 02                    ..
        ldy     #$01                            ; B330 A0 01                    ..
LB332:  jsr     L0500                           ; B332 20 00 05                  ..
        lda     $04                             ; B335 A5 04                    ..
        bne     LB33C                           ; B337 D0 03                    ..
        jsr     LD400                           ; B339 20 00 D4                  ..
LB33C:  jsr     LB7B6                           ; B33C 20 B6 B7                  ..
        jsr     LB653                           ; B33F 20 53 B6                  S.
        lda     $60B6                           ; B342 AD B6 60                 ..`
        beq     LB364                           ; B345 F0 1D                    ..
        lda     $06                             ; B347 A5 06                    ..
        beq     LB361                           ; B349 F0 16                    ..
        jsr     LB619                           ; B34B 20 19 B6                  ..
        ora     ($0C,x)                         ; B34E 01 0C                    ..
        .byte   $14                             ; B350 14                       .
        .byte   $C2                             ; B351 C2                       .
        cmp     ($C4,x)                         ; B352 C1 C4                    ..
        ldy     #$C4                            ; B354 A0 C4                    ..
        .byte   $D2                             ; B356 D2                       .
        cmp     #$D6                            ; B357 C9 D6                    ..
        cmp     $A0                             ; B359 C5 A0                    ..
        .byte   $D3                             ; B35B D3                       .
        bne     LB323                           ; B35C D0 C5                    ..
        cmp     $C4                             ; B35E C5 C4                    ..
        brk                                     ; B360 00                       .
LB361:  jsr     LB893                           ; B361 20 93 B8                  ..
LB364:  dec     $60AB                           ; B364 CE AB 60                 ..`
        jsr     LB438                           ; B367 20 38 B4                  8.
        inc     $60AB                           ; B36A EE AB 60                 ..`
        jsr     LB387                           ; B36D 20 87 B3                  ..
        pla                                     ; B370 68                       h
        beq     LB376                           ; B371 F0 03                    ..
        jmp     LD800                           ; B373 4C 00 D8                 L..

; ----------------------------------------------------------------------------
LB376:  lda     L0000                           ; B376 A5 00                    ..
        eor     #$60                            ; B378 49 60                    I`
        sta     L0000                           ; B37A 85 00                    ..
        bit     $C054                           ; B37C 2C 54 C0                 ,T.
        cmp     #$20                            ; B37F C9 20                    . 
        bne     LB386                           ; B381 D0 03                    ..
        bit     $C055                           ; B383 2C 55 C0                 ,U.
LB386:  rts                                     ; B386 60                       `

; ----------------------------------------------------------------------------
LB387:  lda     #$67                            ; B387 A9 67                    .g
        sta     $60C3                           ; B389 8D C3 60                 ..`
        sta     $60A1                           ; B38C 8D A1 60                 ..`
        lda     $05                             ; B38F A5 05                    ..
        cmp     #$08                            ; B391 C9 08                    ..
        bne     LB3AD                           ; B393 D0 18                    ..
        lda     $60A3                           ; B395 AD A3 60                 ..`
        beq     LB3A8                           ; B398 F0 0E                    ..
        dec     $60A2                           ; B39A CE A2 60                 ..`
        bne     LB3AD                           ; B39D D0 0E                    ..
        dec     $60A3                           ; B39F CE A3 60                 ..`
        lda     $60A3                           ; B3A2 AD A3 60                 ..`
        sta     $60A2                           ; B3A5 8D A2 60                 ..`
LB3A8:  lda     #$FF                            ; B3A8 A9 FF                    ..
        sta     $60A1                           ; B3AA 8D A1 60                 ..`
LB3AD:  ldy     $60C3                           ; B3AD AC C3 60                 ..`
        lda     $6124,y                         ; B3B0 B9 24 61                 .$a
        beq     LB3C5                           ; B3B3 F0 10                    ..
        lda     $618C,y                         ; B3B5 B9 8C 61                 ..a
        beq     LB3C5                           ; B3B8 F0 0B                    ..
        bit     $60A1                           ; B3BA 2C A1 60                 ,.`
        bmi     LB3C2                           ; B3BD 30 03                    0.
        jsr     LB3E8                           ; B3BF 20 E8 B3                  ..
LB3C2:  jsr     LB751                           ; B3C2 20 51 B7                  Q.
LB3C5:  dec     $60C3                           ; B3C5 CE C3 60                 ..`
        bpl     LB3AD                           ; B3C8 10 E3                    ..
        rts                                     ; B3CA 60                       `

; ----------------------------------------------------------------------------
LB3CB:  lda     #$00                            ; B3CB A9 00                    ..
        sta     $03                             ; B3CD 85 03                    ..
        sta     $6093                           ; B3CF 8D 93 60                 ..`
        sta     $6095                           ; B3D2 8D 95 60                 ..`
        sta     $609C                           ; B3D5 8D 9C 60                 ..`
        lda     #$80                            ; B3D8 A9 80                    ..
        sta     $6094                           ; B3DA 8D 94 60                 ..`
        lda     #$03                            ; B3DD A9 03                    ..
        sta     $609E                           ; B3DF 8D 9E 60                 ..`
        lda     #$20                            ; B3E2 A9 20                    . 
        sta     $609F                           ; B3E4 8D 9F 60                 ..`
LB3E7:  rts                                     ; B3E7 60                       `

; ----------------------------------------------------------------------------
LB3E8:  ldy     $60C3                           ; B3E8 AC C3 60                 ..`
        lda     $666C,y                         ; B3EB B9 6C 66                 .lf
        bmi     LB437                           ; B3EE 30 47                    0G
        cpy     $6112                           ; B3F0 CC 12 61                 ..a
        bne     LB3FB                           ; B3F3 D0 06                    ..
        ldx     $05                             ; B3F5 A6 05                    ..
        cpx     #$07                            ; B3F7 E0 07                    ..
        bcs     LB3E7                           ; B3F9 B0 EC                    ..
LB3FB:  pha                                     ; B3FB 48                       H
        and     #$07                            ; B3FC 29 07                    ).
        sta     $0200                           ; B3FE 8D 00 02                 ...
        lda     $6394,y                         ; B401 B9 94 63                 ..c
        sta     $11                             ; B404 85 11                    ..
        lda     $632C,y                         ; B406 B9 2C 63                 .,c
        asl     $11                             ; B409 06 11                    ..
        rol     a                               ; B40B 2A                       *
        sta     L0060                           ; B40C 85 60                    .`
        asl     $11                             ; B40E 06 11                    ..
        rol     a                               ; B410 2A                       *
        asl     $11                             ; B411 06 11                    ..
        rol     a                               ; B413 2A                       *
        adc     L0060                           ; B414 65 60                    e`
        adc     #$30                            ; B416 69 30                    i0
        sta     $11                             ; B418 85 11                    ..
        lda     $63FC,y                         ; B41A B9 FC 63                 ..c
        sec                                     ; B41D 38                       8
        sbc     #$20                            ; B41E E9 20                    . 
        bcc     LB436                           ; B420 90 14                    ..
        lsr     a                               ; B422 4A                       J
        lsr     a                               ; B423 4A                       J
        lsr     a                               ; B424 4A                       J
        lsr     a                               ; B425 4A                       J
        lsr     a                               ; B426 4A                       J
        sta     $12                             ; B427 85 12                    ..
        jsr     L0204                           ; B429 20 04 02                  ..
        pla                                     ; B42C 68                       h
        cmp     #$08                            ; B42D C9 08                    ..
        bcc     LB437                           ; B42F 90 06                    ..
        inc     $12                             ; B431 E6 12                    ..
        jmp     L0204                           ; B433 4C 04 02                 L..

; ----------------------------------------------------------------------------
LB436:  pla                                     ; B436 68                       h
LB437:  rts                                     ; B437 60                       `

; ----------------------------------------------------------------------------
LB438:  lda     $60C6                           ; B438 AD C6 60                 ..`
        beq     LB44F                           ; B43B F0 12                    ..
        jsr     LB619                           ; B43D 20 19 B6                  ..
        ora     ($0E,x)                         ; B440 01 0E                    ..
        .byte   $12                             ; B442 12                       .
        .byte   $C2                             ; B443 C2                       .
        cmp     ($D4,x)                         ; B444 C1 D4                    ..
        .byte   $D4                             ; B446 D4                       .
        cpy     LA0C5                           ; B447 CC C5 A0                 ...
        .byte   $CF                             ; B44A CF                       .
        dec     $C5,x                           ; B44B D6 C5                    ..
        .byte   $D2                             ; B44D D2                       .
        brk                                     ; B44E 00                       .
LB44F:  lda     $60B6                           ; B44F AD B6 60                 ..`
        beq     LB461                           ; B452 F0 0D                    ..
        lda     $60B2                           ; B454 AD B2 60                 ..`
        beq     LB461                           ; B457 F0 08                    ..
        jsr     LB619                           ; B459 20 19 B6                  ..
        ora     ($27,x)                         ; B45C 01 27                    .'
        ora     $A2                             ; B45E 05 A2                    ..
        brk                                     ; B460 00                       .
LB461:  lda     $60AB                           ; B461 AD AB 60                 ..`
        bmi     LB46D                           ; B464 30 07                    0.
        lda     $60C6                           ; B466 AD C6 60                 ..`
        cmp     #$01                            ; B469 C9 01                    ..
        bne     LB47A                           ; B46B D0 0D                    ..
LB46D:  lda     #$80                            ; B46D A9 80                    ..
        sta     $11                             ; B46F 85 11                    ..
        lda     #$66                            ; B471 A9 66                    .f
        sta     $12                             ; B473 85 12                    ..
        lda     #$55                            ; B475 A9 55                    .U
        jsr     LB870                           ; B477 20 70 B8                  p.
LB47A:  ldx     $60B9                           ; B47A AE B9 60                 ..`
        lda     $6108,x                         ; B47D BD 08 61                 ..a
        bne     LB48A                           ; B480 D0 08                    ..
        ldx     #$74                            ; B482 A2 74                    .t
        lda     #$7E                            ; B484 A9 7E                    .~
        ldy     #$53                            ; B486 A0 53                    .S
        bne     LB49F                           ; B488 D0 15                    ..
LB48A:  ldx     $60B9                           ; B48A AE B9 60                 ..`
        lda     $6104,x                         ; B48D BD 04 61                 ..a
        bne     LB4C9                           ; B490 D0 37                    .7
        lda     $6108,x                         ; B492 BD 08 61                 ..a
        cmp     #$22                            ; B495 C9 22                    ."
        bcs     LB4B6                           ; B497 B0 1D                    ..
        ldx     #$71                            ; B499 A2 71                    .q
        lda     #$81                            ; B49B A9 81                    ..
        ldy     #$52                            ; B49D A0 52                    .R
LB49F:  stx     $11                             ; B49F 86 11                    ..
        pha                                     ; B4A1 48                       H
        lda     #$80                            ; B4A2 A9 80                    ..
        sta     $12                             ; B4A4 85 12                    ..
        tya                                     ; B4A6 98                       .
        jsr     LB870                           ; B4A7 20 70 B8                  p.
        pla                                     ; B4AA 68                       h
        sta     $11                             ; B4AB 85 11                    ..
        lda     #$80                            ; B4AD A9 80                    ..
        sta     $12                             ; B4AF 85 12                    ..
        lda     #$54                            ; B4B1 A9 54                    .T
        jsr     LB870                           ; B4B3 20 70 B8                  p.
LB4B6:  ldx     $60B9                           ; B4B6 AE B9 60                 ..`
        lda     $60FC,x                         ; B4B9 BD FC 60                 ..`
        and     $610C,x                         ; B4BC 3D 0C 61                 =.a
        beq     LB4C9                           ; B4BF F0 08                    ..
        lda     #$02                            ; B4C1 A9 02                    ..
        sta     $0200                           ; B4C3 8D 00 02                 ...
        jsr     LB80A                           ; B4C6 20 0A B8                  ..
LB4C9:  lda     $60B4                           ; B4C9 AD B4 60                 ..`
        beq     LB4DE                           ; B4CC F0 10                    ..
        lda     #$06                            ; B4CE A9 06                    ..
        sta     $6093                           ; B4D0 8D 93 60                 ..`
        lda     $60B5                           ; B4D3 AD B5 60                 ..`
        sta     $6092                           ; B4D6 8D 92 60                 ..`
        lda     #$00                            ; B4D9 A9 00                    ..
        sta     $60B4                           ; B4DB 8D B4 60                 ..`
LB4DE:  ldy     $6093                           ; B4DE AC 93 60                 ..`
        bne     LB4F9                           ; B4E1 D0 16                    ..
        ldx     $60B9                           ; B4E3 AE B9 60                 ..`
        lda     $6108,x                         ; B4E6 BD 08 61                 ..a
        cmp     #$10                            ; B4E9 C9 10                    ..
        bcs     LB4F8                           ; B4EB B0 0B                    ..
        jsr     LB9F2                           ; B4ED 20 F2 B9                  ..
        lda     $60B6                           ; B4F0 AD B6 60                 ..`
        bne     LB4F8                           ; B4F3 D0 03                    ..
        bit     $C030                           ; B4F5 2C 30 C0                 ,0.
LB4F8:  rts                                     ; B4F8 60                       `

; ----------------------------------------------------------------------------
LB4F9:  lda     LBADB,y                         ; B4F9 B9 DB BA                 ...
        sta     LB514                           ; B4FC 8D 14 B5                 ...
        lda     LBAE1,y                         ; B4FF B9 E1 BA                 ...
        sta     LB515                           ; B502 8D 15 B5                 ...
        lda     $60EE                           ; B505 AD EE 60                 ..`
        beq     LB510                           ; B508 F0 06                    ..
        ldx     $60B9                           ; B50A AE B9 60                 ..`
        lda     $60F6,x                         ; B50D BD F6 60                 ..`
LB510:  sta     $60A0                           ; B510 8D A0 60                 ..`
        .byte   $AE                             ; B513 AE                       .
LB514:  .byte   $34                             ; B514 34                       4
LB515:  .byte   $12                             ; B515 12                       .
        bne     LB51E                           ; B516 D0 06                    ..
        jsr     LB597                           ; B518 20 97 B5                  ..
        jmp     LB4DE                           ; B51B 4C DE B4                 L..

; ----------------------------------------------------------------------------
LB51E:  lda     #$00                            ; B51E A9 00                    ..
        sta     $01                             ; B520 85 01                    ..
        lda     #$05                            ; B522 A9 05                    ..
        sta     $02                             ; B524 85 02                    ..
        ldy     $60B9                           ; B526 AC B9 60                 ..`
        lda     $60FC,y                         ; B529 B9 FC 60                 ..`
        and     $610C,y                         ; B52C 39 0C 61                 9.a
        beq     LB534                           ; B52F F0 03                    ..
        jmp     LB53B                           ; B531 4C 3B B5                 L;.

; ----------------------------------------------------------------------------
LB534:  txa                                     ; B534 8A                       .
        pha                                     ; B535 48                       H
        jsr     LB9F2                           ; B536 20 F2 B9                  ..
        pla                                     ; B539 68                       h
        tax                                     ; B53A AA                       .
LB53B:  ldy     $6093                           ; B53B AC 93 60                 ..`
        cpy     #$06                            ; B53E C0 06                    ..
        bne     LB545                           ; B540 D0 03                    ..
        jmp     LB5AB                           ; B542 4C AB B5                 L..

; ----------------------------------------------------------------------------
LB545:  lda     LBAC9,y                         ; B545 B9 C9 BA                 ...
        sta     $609A                           ; B548 8D 9A 60                 ..`
        lda     LBACE,y                         ; B54B B9 CE BA                 ...
        sta     $609B                           ; B54E 8D 9B 60                 ..`
LB551:  cpy     #$01                            ; B551 C0 01                    ..
        bne     LB571                           ; B553 D0 1C                    ..
        txa                                     ; B555 8A                       .
        clc                                     ; B556 18                       .
        adc     $60C1                           ; B557 6D C1 60                 m.`
        and     #$03                            ; B55A 29 03                    ).
        tay                                     ; B55C A8                       .
        lda     LBAD4,y                         ; B55D B9 D4 BA                 ...
        sta     $609A                           ; B560 8D 9A 60                 ..`
        lda     LBAD8,y                         ; B563 B9 D8 BA                 ...
        sta     $609B                           ; B566 8D 9B 60                 ..`
        ldy     #$01                            ; B569 A0 01                    ..
        cpx     #$14                            ; B56B E0 14                    ..
        bcc     LB571                           ; B56D 90 02                    ..
        ldx     #$14                            ; B56F A2 14                    ..
LB571:  lda     $609A                           ; B571 AD 9A 60                 ..`
        jsr     LB5A1                           ; B574 20 A1 B5                  ..
        lda     $609B                           ; B577 AD 9B 60                 ..`
        jsr     LB5A1                           ; B57A 20 A1 B5                  ..
        dex                                     ; B57D CA                       .
        bne     LB551                           ; B57E D0 D1                    ..
        lda     $60C1                           ; B580 AD C1 60                 ..`
        and     #$03                            ; B583 29 03                    ).
        tax                                     ; B585 AA                       .
        lda     LBAD4,x                         ; B586 BD D4 BA                 ...
        sta     LBACA                           ; B589 8D CA BA                 ...
        lda     LBAD8,x                         ; B58C BD D8 BA                 ...
        sta     LBACF                           ; B58F 8D CF BA                 ...
LB592:  dec     $6092                           ; B592 CE 92 60                 ..`
        bne     LB5A0                           ; B595 D0 09                    ..
LB597:  dec     $6093                           ; B597 CE 93 60                 ..`
        lda     $60B5                           ; B59A AD B5 60                 ..`
        sta     $6092                           ; B59D 8D 92 60                 ..`
LB5A0:  rts                                     ; B5A0 60                       `

; ----------------------------------------------------------------------------
LB5A1:  cmp     #$A0                            ; B5A1 C9 A0                    ..
        beq     LB5A8                           ; B5A3 F0 03                    ..
        jmp     L0080                           ; B5A5 4C 80 00                 L..

; ----------------------------------------------------------------------------
LB5A8:  inc     $01                             ; B5A8 E6 01                    ..
        rts                                     ; B5AA 60                       `

; ----------------------------------------------------------------------------
LB5AB:  txa                                     ; B5AB 8A                       .
        dec     $02                             ; B5AC C6 02                    ..
        cmp     #$30                            ; B5AE C9 30                    .0
        bcc     LB5B4                           ; B5B0 90 02                    ..
        lda     #$30                            ; B5B2 A9 30                    .0
LB5B4:  pha                                     ; B5B4 48                       H
        lsr     a                               ; B5B5 4A                       J
        lsr     a                               ; B5B6 4A                       J
        beq     LB5DE                           ; B5B7 F0 25                    .%
LB5B9:  pha                                     ; B5B9 48                       H
        lda     #$AB                            ; B5BA A9 AB                    ..
        jsr     LB5A1                           ; B5BC 20 A1 B5                  ..
        lda     #$AC                            ; B5BF A9 AC                    ..
        jsr     LB5A1                           ; B5C1 20 A1 B5                  ..
        inc     $02                             ; B5C4 E6 02                    ..
        dec     $01                             ; B5C6 C6 01                    ..
        dec     $01                             ; B5C8 C6 01                    ..
        lda     #$AD                            ; B5CA A9 AD                    ..
        jsr     LB5A1                           ; B5CC 20 A1 B5                  ..
        lda     #$AE                            ; B5CF A9 AE                    ..
        jsr     LB5A1                           ; B5D1 20 A1 B5                  ..
        inc     $01                             ; B5D4 E6 01                    ..
        dec     $02                             ; B5D6 C6 02                    ..
        pla                                     ; B5D8 68                       h
        sec                                     ; B5D9 38                       8
        sbc     #$01                            ; B5DA E9 01                    ..
        bne     LB5B9                           ; B5DC D0 DB                    ..
LB5DE:  pla                                     ; B5DE 68                       h
        and     #$03                            ; B5DF 29 03                    ).
        beq     LB5FD                           ; B5E1 F0 1A                    ..
        tay                                     ; B5E3 A8                       .
        inc     $02                             ; B5E4 E6 02                    ..
        lda     #$AF                            ; B5E6 A9 AF                    ..
        jsr     LB5A1                           ; B5E8 20 A1 B5                  ..
        dey                                     ; B5EB 88                       .
        beq     LB5FD                           ; B5EC F0 0F                    ..
        jsr     LB5A1                           ; B5EE 20 A1 B5                  ..
        dey                                     ; B5F1 88                       .
        beq     LB5FD                           ; B5F2 F0 09                    ..
        dec     $02                             ; B5F4 C6 02                    ..
        dec     $01                             ; B5F6 C6 01                    ..
        dec     $01                             ; B5F8 C6 01                    ..
        jsr     LB5A1                           ; B5FA 20 A1 B5                  ..
LB5FD:  jmp     LB592                           ; B5FD 4C 92 B5                 L..

; ----------------------------------------------------------------------------
LB600:  pha                                     ; B600 48                       H
        lsr     a                               ; B601 4A                       J
        lsr     a                               ; B602 4A                       J
        lsr     a                               ; B603 4A                       J
        lsr     a                               ; B604 4A                       J
        jsr     LB609                           ; B605 20 09 B6                  ..
        pla                                     ; B608 68                       h
LB609:  and     #$0F                            ; B609 29 0F                    ).
        ora     #$B0                            ; B60B 09 B0                    ..
        cmp     #$BA                            ; B60D C9 BA                    ..
        bcc     LB613                           ; B60F 90 02                    ..
        adc     #$06                            ; B611 69 06                    i.
LB613:  jmp     L0080                           ; B613 4C 80 00                 L..

; ----------------------------------------------------------------------------
        jmp     (L0060)                         ; B616 6C 60 00                 l`.

; ----------------------------------------------------------------------------
LB619:  pla                                     ; B619 68                       h
        sta     L0060                           ; B61A 85 60                    .`
        pla                                     ; B61C 68                       h
        sta     $61                             ; B61D 85 61                    .a
        ldy     #$00                            ; B61F A0 00                    ..
LB621:  inc     L0060                           ; B621 E6 60                    .`
        bne     LB627                           ; B623 D0 02                    ..
        inc     $61                             ; B625 E6 61                    .a
LB627:  lda     (L0060),y                       ; B627 B1 60                    .`
        beq     LB635                           ; B629 F0 0A                    ..
        cmp     #$01                            ; B62B C9 01                    ..
        beq     LB63C                           ; B62D F0 0D                    ..
        jsr     L0080                           ; B62F 20 80 00                  ..
        jmp     LB621                           ; B632 4C 21 B6                 L!.

; ----------------------------------------------------------------------------
LB635:  lda     $61                             ; B635 A5 61                    .a
        pha                                     ; B637 48                       H
        lda     L0060                           ; B638 A5 60                    .`
        pha                                     ; B63A 48                       H
        rts                                     ; B63B 60                       `

; ----------------------------------------------------------------------------
LB63C:  inc     L0060                           ; B63C E6 60                    .`
        bne     LB642                           ; B63E D0 02                    ..
        inc     $61                             ; B640 E6 61                    .a
LB642:  lda     (L0060),y                       ; B642 B1 60                    .`
        sta     $01                             ; B644 85 01                    ..
        inc     L0060                           ; B646 E6 60                    .`
        bne     LB64C                           ; B648 D0 02                    ..
        inc     $61                             ; B64A E6 61                    .a
LB64C:  lda     (L0060),y                       ; B64C B1 60                    .`
        sta     $02                             ; B64E 85 02                    ..
        jmp     LB621                           ; B650 4C 21 B6                 L!.

; ----------------------------------------------------------------------------
LB653:  jsr     LB737                           ; B653 20 37 B7                  7.
        lda     $6099                           ; B656 AD 99 60                 ..`
        beq     LB687                           ; B659 F0 2C                    .,
        ldx     #$00                            ; B65B A2 00                    ..
        ldy     $6098                           ; B65D AC 98 60                 ..`
        lda     $64CC,y                         ; B660 B9 CC 64                 ..d
        asl     a                               ; B663 0A                       .
        sta     L0060                           ; B664 85 60                    .`
        asl     a                               ; B666 0A                       .
        adc     L0060                           ; B667 65 60                    e`
        bpl     LB66C                           ; B669 10 01                    ..
        dex                                     ; B66B CA                       .
LB66C:  clc                                     ; B66C 18                       .
        adc     $6394,y                         ; B66D 79 94 63                 y.c
        sta     L0060                           ; B670 85 60                    .`
        txa                                     ; B672 8A                       .
        adc     $632C,y                         ; B673 79 2C 63                 y,c
        sta     $61                             ; B676 85 61                    .a
        lda     L0060                           ; B678 A5 60                    .`
        sec                                     ; B67A 38                       8
        sbc     #$44                            ; B67B E9 44                    .D
        sta     $6097                           ; B67D 8D 97 60                 ..`
        lda     $61                             ; B680 A5 61                    .a
        sbc     #$00                            ; B682 E9 00                    ..
        sta     $6096                           ; B684 8D 96 60                 ..`
LB687:  ldy     $6098                           ; B687 AC 98 60                 ..`
        lda     $6874,y                         ; B68A B9 74 68                 .th
        beq     LB6B7                           ; B68D F0 28                    .(
        lda     $6097                           ; B68F AD 97 60                 ..`
        sec                                     ; B692 38                       8
        sbc     $6095                           ; B693 ED 95 60                 ..`
        sta     L0060                           ; B696 85 60                    .`
        lda     $6096                           ; B698 AD 96 60                 ..`
        sbc     $6094                           ; B69B ED 94 60                 ..`
        bcs     LB6AF                           ; B69E B0 0F                    ..
        lda     $6095                           ; B6A0 AD 95 60                 ..`
        sec                                     ; B6A3 38                       8
        sbc     $6097                           ; B6A4 ED 97 60                 ..`
        sta     L0060                           ; B6A7 85 60                    .`
        lda     $6094                           ; B6A9 AD 94 60                 ..`
        sbc     $6096                           ; B6AC ED 96 60                 ..`
LB6AF:  bne     LB6B7                           ; B6AF D0 06                    ..
        lda     L0060                           ; B6B1 A5 60                    .`
        cmp     #$A0                            ; B6B3 C9 A0                    ..
        bcc     LB6C4                           ; B6B5 90 0D                    ..
LB6B7:  lda     $6096                           ; B6B7 AD 96 60                 ..`
        sta     $6094                           ; B6BA 8D 94 60                 ..`
        lda     $6097                           ; B6BD AD 97 60                 ..`
        sta     $6095                           ; B6C0 8D 95 60                 ..`
        rts                                     ; B6C3 60                       `

; ----------------------------------------------------------------------------
LB6C4:  lda     $6097                           ; B6C4 AD 97 60                 ..`
        sec                                     ; B6C7 38                       8
        sbc     $6095                           ; B6C8 ED 95 60                 ..`
        sta     L0060                           ; B6CB 85 60                    .`
        lda     $6096                           ; B6CD AD 96 60                 ..`
        sbc     $6094                           ; B6D0 ED 94 60                 ..`
        sta     $61                             ; B6D3 85 61                    .a
        sta     $63                             ; B6D5 85 63                    .c
        ldy     $6098                           ; B6D7 AC 98 60                 ..`
        lda     $64CC,y                         ; B6DA B9 CC 64                 ..d
        bpl     LB6E4                           ; B6DD 10 05                    ..
        eor     #$FF                            ; B6DF 49 FF                    I.
        clc                                     ; B6E1 18                       .
        adc     #$01                            ; B6E2 69 01                    i.
LB6E4:  clc                                     ; B6E4 18                       .
        adc     #$01                            ; B6E5 69 01                    i.
        sta     $64                             ; B6E7 85 64                    .d
        lda     $61                             ; B6E9 A5 61                    .a
        bpl     LB6FE                           ; B6EB 10 11                    ..
        lda     L0060                           ; B6ED A5 60                    .`
        eor     #$FF                            ; B6EF 49 FF                    I.
        clc                                     ; B6F1 18                       .
        adc     #$01                            ; B6F2 69 01                    i.
        sta     L0060                           ; B6F4 85 60                    .`
        lda     $61                             ; B6F6 A5 61                    .a
        eor     #$FF                            ; B6F8 49 FF                    I.
        adc     #$00                            ; B6FA 69 00                    i.
        sta     $61                             ; B6FC 85 61                    .a
LB6FE:  lda     $61                             ; B6FE A5 61                    .a
        bne     LB708                           ; B700 D0 06                    ..
        lda     L0060                           ; B702 A5 60                    .`
        cmp     $64                             ; B704 C5 64                    .d
        bcc     LB710                           ; B706 90 08                    ..
LB708:  lda     $64                             ; B708 A5 64                    .d
        sta     L0060                           ; B70A 85 60                    .`
        lda     #$00                            ; B70C A9 00                    ..
        sta     $61                             ; B70E 85 61                    .a
LB710:  lda     $63                             ; B710 A5 63                    .c
        bpl     LB725                           ; B712 10 11                    ..
        lda     L0060                           ; B714 A5 60                    .`
        eor     #$FF                            ; B716 49 FF                    I.
        clc                                     ; B718 18                       .
        adc     #$01                            ; B719 69 01                    i.
        sta     L0060                           ; B71B 85 60                    .`
        lda     $61                             ; B71D A5 61                    .a
        eor     #$FF                            ; B71F 49 FF                    I.
        adc     #$00                            ; B721 69 00                    i.
        sta     $61                             ; B723 85 61                    .a
LB725:  lda     $6095                           ; B725 AD 95 60                 ..`
        clc                                     ; B728 18                       .
        adc     L0060                           ; B729 65 60                    e`
        sta     $6095                           ; B72B 8D 95 60                 ..`
        lda     $6094                           ; B72E AD 94 60                 ..`
        adc     $61                             ; B731 65 61                    ea
        sta     $6094                           ; B733 8D 94 60                 ..`
        rts                                     ; B736 60                       `

; ----------------------------------------------------------------------------
LB737:  ldx     $60B9                           ; B737 AE B9 60                 ..`
        ldy     $6104,x                         ; B73A BC 04 61                 ..a
        beq     LB745                           ; B73D F0 06                    ..
        lda     #$00                            ; B73F A9 00                    ..
        sta     $6099                           ; B741 8D 99 60                 ..`
        rts                                     ; B744 60                       `

; ----------------------------------------------------------------------------
LB745:  lda     $6112,x                         ; B745 BD 12 61                 ..a
        sta     $6098                           ; B748 8D 98 60                 ..`
        lda     #$01                            ; B74B A9 01                    ..
        sta     $6099                           ; B74D 8D 99 60                 ..`
        rts                                     ; B750 60                       `

; ----------------------------------------------------------------------------
LB751:  ldx     $60C3                           ; B751 AE C3 60                 ..`
        lda     #$00                            ; B754 A9 00                    ..
        sta     $6874,x                         ; B756 9D 74 68                 .th
        lda     $6394,x                         ; B759 BD 94 63                 ..c
        sec                                     ; B75C 38                       8
        sbc     $6095                           ; B75D ED 95 60                 ..`
        sta     L0060                           ; B760 85 60                    .`
        lda     $632C,x                         ; B762 BD 2C 63                 .,c
        sbc     $6094                           ; B765 ED 94 60                 ..`
        beq     LB76F                           ; B768 F0 05                    ..
        cmp     #$FF                            ; B76A C9 FF                    ..
        beq     LB776                           ; B76C F0 08                    ..
LB76E:  rts                                     ; B76E 60                       `

; ----------------------------------------------------------------------------
LB76F:  lda     L0060                           ; B76F A5 60                    .`
        cmp     #$8C                            ; B771 C9 8C                    ..
        bcc     LB77C                           ; B773 90 07                    ..
LB775:  rts                                     ; B775 60                       `

; ----------------------------------------------------------------------------
LB776:  lda     L0060                           ; B776 A5 60                    .`
        cmp     #$E0                            ; B778 C9 E0                    ..
        bcc     LB76E                           ; B77A 90 F2                    ..
LB77C:  inc     $6874,x                         ; B77C FE 74 68                 .th
        clc                                     ; B77F 18                       .
        adc     #$3A                            ; B780 69 3A                    i:
        sta     $11                             ; B782 85 11                    ..
        lda     $63FC,x                         ; B784 BD FC 63                 ..c
        sta     $12                             ; B787 85 12                    ..
        lda     $62C4,x                         ; B789 BD C4 62                 ..b
        cmp     #$F0                            ; B78C C9 F0                    ..
        bcs     LB795                           ; B78E B0 05                    ..
        sta     $10                             ; B790 85 10                    ..
        jmp     LB86E                           ; B792 4C 6E B8                 Ln.

; ----------------------------------------------------------------------------
LB795:  cmp     #$FF                            ; B795 C9 FF                    ..
        beq     LB775                           ; B797 F0 DC                    ..
        cmp     #$F0                            ; B799 C9 F0                    ..
        bne     LB7AD                           ; B79B D0 10                    ..
        lda     $6464,x                         ; B79D BD 64 64                 .dd
        sta     $14                             ; B7A0 85 14                    ..
        lda     $6604,x                         ; B7A2 BD 04 66                 ..f
        ora     #$02                            ; B7A5 09 02                    ..
        sta     $0200                           ; B7A7 8D 00 02                 ...
        jmp     L020A                           ; B7AA 4C 0A 02                 L..

; ----------------------------------------------------------------------------
LB7AD:  lda     $6464,x                         ; B7AD BD 64 64                 .dd
        sta     $0200                           ; B7B0 8D 00 02                 ...
        jmp     L0204                           ; B7B3 4C 04 02                 L..

; ----------------------------------------------------------------------------
LB7B6:  ldy     $60D3                           ; B7B6 AC D3 60                 ..`
        beq     LB7D6                           ; B7B9 F0 1B                    ..
        lda     $60BA                           ; B7BB AD BA 60                 ..`
        beq     LB7D6                           ; B7BE F0 16                    ..
        lda     #$0A                            ; B7C0 A9 0A                    ..
        sta     $02                             ; B7C2 85 02                    ..
        ldy     #$00                            ; B7C4 A0 00                    ..
        sty     $01                             ; B7C6 84 01                    ..
LB7C8:  lda     $60D4,y                         ; B7C8 B9 D4 60                 ..`
        jsr     LB600                           ; B7CB 20 00 B6                  ..
        inc     $01                             ; B7CE E6 01                    ..
        iny                                     ; B7D0 C8                       .
        cpy     $60D3                           ; B7D1 CC D3 60                 ..`
        bne     LB7C8                           ; B7D4 D0 F2                    ..
LB7D6:  rts                                     ; B7D6 60                       `

; ----------------------------------------------------------------------------
LB7D7:  lda     L0000                           ; B7D7 A5 00                    ..
        sta     LB7F0                           ; B7D9 8D F0 B7                 ...
        sta     LB7F6                           ; B7DC 8D F6 B7                 ...
        eor     #$60                            ; B7DF 49 60                    I`
        sta     LB7ED                           ; B7E1 8D ED B7                 ...
        sta     LB7F3                           ; B7E4 8D F3 B7                 ...
        ldx     #$20                            ; B7E7 A2 20                    . 
LB7E9:  ldy     #$77                            ; B7E9 A0 77                    .w
LB7EB:  .byte   $B9                             ; B7EB B9                       .
        brk                                     ; B7EC 00                       .
LB7ED:  jsr     L0099                           ; B7ED 20 99 00                  ..
LB7F0:  rti                                     ; B7F0 40                       @

; ----------------------------------------------------------------------------
        .byte   $B9                             ; B7F1 B9                       .
        .byte   $80                             ; B7F2 80                       .
LB7F3:  jsr     L8099                           ; B7F3 20 99 80                  ..
LB7F6:  rti                                     ; B7F6 40                       @

; ----------------------------------------------------------------------------
        dey                                     ; B7F7 88                       .
        bpl     LB7EB                           ; B7F8 10 F1                    ..
        inc     LB7F0                           ; B7FA EE F0 B7                 ...
        inc     LB7ED                           ; B7FD EE ED B7                 ...
        inc     LB7F6                           ; B800 EE F6 B7                 ...
        inc     LB7F3                           ; B803 EE F3 B7                 ...
        dex                                     ; B806 CA                       .
        bne     LB7E9                           ; B807 D0 E0                    ..
        rts                                     ; B809 60                       `

; ----------------------------------------------------------------------------
LB80A:  ldy     $0200                           ; B80A AC 00 02                 ...
        lda     LBABA,y                         ; B80D B9 BA BA                 ...
        sta     L0060                           ; B810 85 60                    .`
        lda     LBAC2,y                         ; B812 B9 C2 BA                 ...
        sta     $61                             ; B815 85 61                    .a
        ldx     #$26                            ; B817 A2 26                    .&
        lda     L0000                           ; B819 A5 00                    ..
        cmp     #$20                            ; B81B C9 20                    . 
        bne     LB840                           ; B81D D0 21                    .!
LB81F:  lda     L0060                           ; B81F A5 60                    .`
        sta     $2480,x                         ; B821 9D 80 24                 ..$
        sta     $2C80,x                         ; B824 9D 80 2C                 ..,
        sta     $3480,x                         ; B827 9D 80 34                 ..4
        sta     $3C80,x                         ; B82A 9D 80 3C                 ..<
        lda     $61                             ; B82D A5 61                    .a
        sta     $2481,x                         ; B82F 9D 81 24                 ..$
        sta     $2C81,x                         ; B832 9D 81 2C                 ..,
        sta     $3481,x                         ; B835 9D 81 34                 ..4
        sta     $3C81,x                         ; B838 9D 81 3C                 ..<
        dex                                     ; B83B CA                       .
        dex                                     ; B83C CA                       .
        bpl     LB81F                           ; B83D 10 E0                    ..
        rts                                     ; B83F 60                       `

; ----------------------------------------------------------------------------
LB840:  lda     L0060                           ; B840 A5 60                    .`
        sta     $4480,x                         ; B842 9D 80 44                 ..D
        sta     $4C80,x                         ; B845 9D 80 4C                 ..L
        sta     $5480,x                         ; B848 9D 80 54                 ..T
        sta     $5C80,x                         ; B84B 9D 80 5C                 ..\
        lda     $61                             ; B84E A5 61                    .a
        sta     $4481,x                         ; B850 9D 81 44                 ..D
        sta     $4C81,x                         ; B853 9D 81 4C                 ..L
        sta     $5481,x                         ; B856 9D 81 54                 ..T
        sta     $5C81,x                         ; B859 9D 81 5C                 ..\
        dex                                     ; B85C CA                       .
        dex                                     ; B85D CA                       .
        bpl     LB840                           ; B85E 10 E0                    ..
        rts                                     ; B860 60                       `

; ----------------------------------------------------------------------------
LB861:  lda     #$40                            ; B861 A9 40                    .@
        cmp     L0000                           ; B863 C5 00                    ..
        beq     LB86D                           ; B865 F0 06                    ..
        jsr     LB7D7                           ; B867 20 D7 B7                  ..
        jmp     LB376                           ; B86A 4C 76 B3                 Lv.

; ----------------------------------------------------------------------------
LB86D:  rts                                     ; B86D 60                       `

; ----------------------------------------------------------------------------
LB86E:  lda     $10                             ; B86E A5 10                    ..
LB870:  ldx     #$00                            ; B870 A2 00                    ..
        ldy     #$E0                            ; B872 A0 E0                    ..
        cmp     #$49                            ; B874 C9 49                    .I
        bcc     LB88A                           ; B876 90 12                    ..
        sbc     #$49                            ; B878 E9 49                    .I
        cmp     #$4E                            ; B87A C9 4E                    .N
        bcc     LB886                           ; B87C 90 08                    ..
        sbc     #$4E                            ; B87E E9 4E                    .N
        ldx     #$00                            ; B880 A2 00                    ..
        ldy     #$D0                            ; B882 A0 D0                    ..
        bne     LB88A                           ; B884 D0 04                    ..
LB886:  ldx     #$00                            ; B886 A2 00                    ..
        ldy     #$19                            ; B888 A0 19                    ..
LB88A:  stx     $15                             ; B88A 86 15                    ..
        sty     $16                             ; B88C 84 16                    ..
        sta     $10                             ; B88E 85 10                    ..
        jmp     L0201                           ; B890 4C 01 02                 L..

; ----------------------------------------------------------------------------
LB893:  ldx     $609E                           ; B893 AE 9E 60                 ..`
        lda     LBAE7,x                         ; B896 BD E7 BA                 ...
        sta     LB8A3                           ; B899 8D A3 B8                 ...
        lda     LBAEE,x                         ; B89C BD EE BA                 ...
        sta     LB8A4                           ; B89F 8D A4 B8                 ...
        .byte   $20                             ; B8A2 20                        
LB8A3:  .byte   $34                             ; B8A3 34                       4
LB8A4:  .byte   $12                             ; B8A4 12                       .
        dec     $609F                           ; B8A5 CE 9F 60                 ..`
        bne     LB8B9                           ; B8A8 D0 0F                    ..
        lda     #$20                            ; B8AA A9 20                    . 
        sta     $609F                           ; B8AC 8D 9F 60                 ..`
        dec     $609E                           ; B8AF CE 9E 60                 ..`
        bne     LB8B9                           ; B8B2 D0 05                    ..
        lda     #$07                            ; B8B4 A9 07                    ..
        sta     $609E                           ; B8B6 8D 9E 60                 ..`
LB8B9:  rts                                     ; B8B9 60                       `

; ----------------------------------------------------------------------------
        jsr     LB619                           ; B8BA 20 19 B6                  ..
        ora     ($0E,x)                         ; B8BD 01 0E                    ..
        asl     $C8                             ; B8BF 06 C8                    ..
        cmp     #$C7                            ; B8C1 C9 C7                    ..
        iny                                     ; B8C3 C8                       .
        ldy     #$D3                            ; B8C4 A0 D3                    ..
        .byte   $C3                             ; B8C6 C3                       .
        .byte   $CF                             ; B8C7 CF                       .
        .byte   $D2                             ; B8C8 D2                       .
        cmp     $D3                             ; B8C9 C5 D3                    ..
        brk                                     ; B8CB 00                       .
        lda     #$04                            ; B8CC A9 04                    ..
LB8CE:  pha                                     ; B8CE 48                       H
        clc                                     ; B8CF 18                       .
        adc     #$08                            ; B8D0 69 08                    i.
        sta     $02                             ; B8D2 85 02                    ..
        lda     #$09                            ; B8D4 A9 09                    ..
        sta     $01                             ; B8D6 85 01                    ..
        pla                                     ; B8D8 68                       h
        pha                                     ; B8D9 48                       H
        asl     a                               ; B8DA 0A                       .
        sta     L0060                           ; B8DB 85 60                    .`
        asl     a                               ; B8DD 0A                       .
        asl     a                               ; B8DE 0A                       .
        asl     a                               ; B8DF 0A                       .
        tay                                     ; B8E0 A8                       .
        ldx     #$10                            ; B8E1 A2 10                    ..
LB8E3:  lda     $0400,y                         ; B8E3 B9 00 04                 ...
        jsr     LB5A1                           ; B8E6 20 A1 B5                  ..
        iny                                     ; B8E9 C8                       .
        dex                                     ; B8EA CA                       .
        bne     LB8E3                           ; B8EB D0 F6                    ..
        ldy     L0060                           ; B8ED A4 60                    .`
        lda     $0450,y                         ; B8EF B9 50 04                 .P.
        sta     $61                             ; B8F2 85 61                    .a
        lda     $0451,y                         ; B8F4 B9 51 04                 .Q.
        sta     L0060                           ; B8F7 85 60                    .`
        inc     $01                             ; B8F9 E6 01                    ..
        ldx     #$03                            ; B8FB A2 03                    ..
        stx     $62                             ; B8FD 86 62                    .b
LB8FF:  lda     #$00                            ; B8FF A9 00                    ..
        asl     L0060                           ; B901 06 60                    .`
        rol     $61                             ; B903 26 61                    &a
        rol     a                               ; B905 2A                       *
        asl     L0060                           ; B906 06 60                    .`
        rol     $61                             ; B908 26 61                    &a
        rol     a                               ; B90A 2A                       *
        asl     L0060                           ; B90B 06 60                    .`
        rol     $61                             ; B90D 26 61                    &a
        rol     a                               ; B90F 2A                       *
        asl     L0060                           ; B910 06 60                    .`
        rol     $61                             ; B912 26 61                    &a
        rol     a                               ; B914 2A                       *
        bne     LB923                           ; B915 D0 0C                    ..
        bit     $62                             ; B917 24 62                    $b
        bmi     LB923                           ; B919 30 08                    0.
        cpx     #$00                            ; B91B E0 00                    ..
        beq     LB923                           ; B91D F0 04                    ..
        inc     $01                             ; B91F E6 01                    ..
        bpl     LB92A                           ; B921 10 07                    ..
LB923:  ora     #$B0                            ; B923 09 B0                    ..
        sta     $62                             ; B925 85 62                    .b
        jsr     L0080                           ; B927 20 80 00                  ..
LB92A:  dex                                     ; B92A CA                       .
        bpl     LB8FF                           ; B92B 10 D2                    ..
        pla                                     ; B92D 68                       h
        sec                                     ; B92E 38                       8
        sbc     #$01                            ; B92F E9 01                    ..
        bpl     LB8CE                           ; B931 10 9B                    ..
        rts                                     ; B933 60                       `

; ----------------------------------------------------------------------------
        lda     #$64                            ; B934 A9 64                    .d
        sta     $11                             ; B936 85 11                    ..
        pha                                     ; B938 48                       H
        lda     #$30                            ; B939 A9 30                    .0
        sta     $12                             ; B93B 85 12                    ..
        pha                                     ; B93D 48                       H
        lda     #$3F                            ; B93E A9 3F                    .?
        jsr     LB870                           ; B940 20 70 B8                  p.
        pla                                     ; B943 68                       h
        sta     $12                             ; B944 85 12                    ..
        pla                                     ; B946 68                       h
        clc                                     ; B947 18                       .
        adc     #$1B                            ; B948 69 1B                    i.
        sta     $11                             ; B94A 85 11                    ..
        lda     #$40                            ; B94C A9 40                    .@
        jmp     LB870                           ; B94E 4C 70 B8                 Lp.

; ----------------------------------------------------------------------------
        jsr     LB619                           ; B951 20 19 B6                  ..
        ora     ($0C,x)                         ; B954 01 0C                    ..
        .byte   $02                             ; B956 02                       .
        cpx     #$E0                            ; B957 E0 E0                    ..
        iny                                     ; B959 C8                       .
        cmp     $CC                             ; B95A C5 CC                    ..
        cpy     $E0CF                           ; B95C CC CF E0                 ...
        iny                                     ; B95F C8                       .
        cmp     $D2                             ; B960 C5 D2                    ..
        .byte   $D2                             ; B962 D2                       .
        .byte   $C2                             ; B963 C2                       .
        cpx     #$E0                            ; B964 E0 E0                    ..
        cpx     #$00                            ; B966 E0 00                    ..
        rts                                     ; B968 60                       `

; ----------------------------------------------------------------------------
        jsr     LB619                           ; B969 20 19 B6                  ..
        ora     ($03,x)                         ; B96C 01 03                    ..
        .byte   $02                             ; B96E 02                       .
        cpx     #$D4                            ; B96F E0 D4                    ..
        iny                                     ; B971 C8                       .
        cmp     #$D3                            ; B972 C9 D3                    ..
        cpx     #$CD                            ; B974 E0 CD                    ..
        cmp     $D3                             ; B976 C5 D3                    ..
        .byte   $D3                             ; B978 D3                       .
        cmp     ($C7,x)                         ; B979 C1 C7                    ..
        cmp     $E0                             ; B97B C5 E0                    ..
        .byte   $C2                             ; B97D C2                       .
        .byte   $D2                             ; B97E D2                       .
        .byte   $CF                             ; B97F CF                       .
        cmp     $C7,x                           ; B980 D5 C7                    ..
        iny                                     ; B982 C8                       .
        .byte   $D4                             ; B983 D4                       .
        cpx     #$D4                            ; B984 E0 D4                    ..
        .byte   $CF                             ; B986 CF                       .
        ldy     #$D9                            ; B987 A0 D9                    ..
        .byte   $CF                             ; B989 CF                       .
        cmp     $A0,x                           ; B98A D5 A0                    ..
        .byte   $C2                             ; B98C C2                       .
        cmp     $E0E0,y                         ; B98D D9 E0 E0                 ...
        brk                                     ; B990 00                       .
        rts                                     ; B991 60                       `

; ----------------------------------------------------------------------------
        jsr     LB619                           ; B992 20 19 B6                  ..
        ora     ($0A,x)                         ; B995 01 0A                    ..
        .byte   $02                             ; B997 02                       .
        cpx     #$C4                            ; B998 E0 C4                    ..
        cmp     ($D2,x)                         ; B99A C1 D2                    ..
        .byte   $D2                             ; B99C D2                       .
        cmp     $CC                             ; B99D C5 CC                    ..
        cpy     $C1E0                           ; B99F CC E0 C1                 ...
        dec     $E0C4                           ; B9A2 CE C4 E0                 ...
        dex                                     ; B9A5 CA                       .
        .byte   $CF                             ; B9A6 CF                       .
        dec     $E0E0                           ; B9A7 CE E0 E0                 ...
        cpx     #$00                            ; B9AA E0 00                    ..
        rts                                     ; B9AC 60                       `

; ----------------------------------------------------------------------------
        jsr     LB619                           ; B9AD 20 19 B6                  ..
        ora     ($0B,x)                         ; B9B0 01 0B                    ..
        .byte   $02                             ; B9B2 02                       .
        .byte   $CC                             ; B9B3 CC                       .
LB9B4:  cmp     ($D3,x)                         ; B9B4 C1 D3                    ..
        .byte   $D4                             ; B9B6 D4                       .
        .byte   $A0                             ; B9B7 A0                       .
LB9B8:  .byte   $D3                             ; B9B8 D3                       .
LB9B9:  .byte   $C3                             ; B9B9 C3                       .
        .byte   $CF                             ; B9BA CF                       .
        .byte   $D2                             ; B9BB D2                       .
LB9BC:  cmp     $A0                             ; B9BC C5 A0                    ..
        brk                                     ; B9BE 00                       .
        ldy     #$00                            ; B9BF A0 00                    ..
LB9C1:  lda     $01FC,y                         ; B9C1 B9 FC 01                 ...
        jsr     L0080                           ; B9C4 20 80 00                  ..
        iny                                     ; B9C7 C8                       .
        cpy     #$04                            ; B9C8 C0 04                    ..
        bne     LB9C1                           ; B9CA D0 F5                    ..
        rts                                     ; B9CC 60                       `

; ----------------------------------------------------------------------------
        lda     #$61                            ; B9CD A9 61                    .a
        sta     $11                             ; B9CF 85 11                    ..
        lda     #$30                            ; B9D1 A9 30                    .0
LB9D3:  sta     $12                             ; B9D3 85 12                    ..
        lda     #$96                            ; B9D5 A9 96                    ..
        jsr     LB870                           ; B9D7 20 70 B8                  p.
        jsr     LB619                           ; B9DA 20 19 B6                  ..
        ora     ($10,x)                         ; B9DD 01 10                    ..
        .byte   $03                             ; B9DF 03                       .
        bne     LB9B4                           ; B9E0 D0 D2                    ..
        .byte   $CF                             ; B9E2 CF                       .
        cmp     $C4,x                           ; B9E3 D5 C4                    ..
        cpy     LA0D9                           ; B9E5 CC D9 A0                 ...
        bne     LB9BC                           ; B9E8 D0 D2                    ..
        cmp     $D3                             ; B9EA C5 D3                    ..
        cmp     $CE                             ; B9EC C5 CE                    ..
        .byte   $D4                             ; B9EE D4                       .
        .byte   $D3                             ; B9EF D3                       .
        brk                                     ; B9F0 00                       .
        rts                                     ; B9F1 60                       `

; ----------------------------------------------------------------------------
LB9F2:  ldx     $60B9                           ; B9F2 AE B9 60                 ..`
        lda     $6108,x                         ; B9F5 BD 08 61                 ..a
        lsr     a                               ; B9F8 4A                       J
        lsr     a                               ; B9F9 4A                       J
        tax                                     ; B9FA AA                       .
        lda     #$7F                            ; B9FB A9 7F                    ..
        sta     LBA32                           ; B9FD 8D 32 BA                 .2.
        lda     LBA35                           ; BA00 AD 35 BA                 .5.
        and     #$1F                            ; BA03 29 1F                    ).
        ora     L0000                           ; BA05 05 00                    ..
        sta     LBA35                           ; BA07 8D 35 BA                 .5.
        lda     LBA38                           ; BA0A AD 38 BA                 .8.
        and     #$1F                            ; BA0D 29 1F                    ).
        ora     L0000                           ; BA0F 05 00                    ..
        sta     LBA38                           ; BA11 8D 38 BA                 .8.
        lda     LBA3B                           ; BA14 AD 3B BA                 .;.
        and     #$1F                            ; BA17 29 1F                    ).
        ora     L0000                           ; BA19 05 00                    ..
        sta     LBA3B                           ; BA1B 8D 3B BA                 .;.
        ldy     #$00                            ; BA1E A0 00                    ..
        sty     LBA40                           ; BA20 8C 40 BA                 .@.
LBA23:  dex                                     ; BA23 CA                       .
        bpl     LBA31                           ; BA24 10 0B                    ..
        .byte   $A9                             ; BA26 A9                       .
LBA27:  tax                                     ; BA27 AA                       .
        sta     LBA32                           ; BA28 8D 32 BA                 .2.
        lda     #$7F                            ; BA2B A9 7F                    ..
        sta     LBA40                           ; BA2D 8D 40 BA                 .@.
        tax                                     ; BA30 AA                       .
LBA31:  .byte   $A9                             ; BA31 A9                       .
LBA32:  brk                                     ; BA32 00                       .
        .byte   $99                             ; BA33 99                       .
        .byte   $84                             ; BA34 84                       .
LBA35:  plp                                     ; BA35 28                       (
        .byte   $99                             ; BA36 99                       .
        .byte   $84                             ; BA37 84                       .
LBA38:  bmi     LB9D3                           ; BA38 30 99                    0.
        .byte   $84                             ; BA3A 84                       .
LBA3B:  sec                                     ; BA3B 38                       8
        lda     LBA32                           ; BA3C AD 32 BA                 .2.
        .byte   $49                             ; BA3F 49                       I
LBA40:  brk                                     ; BA40 00                       .
        sta     LBA32                           ; BA41 8D 32 BA                 .2.
        lda     LBA27                           ; BA44 AD 27 BA                 .'.
        eor     #$7F                            ; BA47 49 7F                    I.
        sta     LBA27                           ; BA49 8D 27 BA                 .'.
        iny                                     ; BA4C C8                       .
        cpy     #$20                            ; BA4D C0 20                    . 
        bne     LBA23                           ; BA4F D0 D2                    ..
        rts                                     ; BA51 60                       `

; ----------------------------------------------------------------------------
LBA52:  jsr     LB7D7                           ; BA52 20 D7 B7                  ..
        jsr     LB619                           ; BA55 20 19 B6                  ..
        ora     ($0C,x)                         ; BA58 01 0C                    ..
        asl     a                               ; BA5A 0A                       .
        cpy     #$A1                            ; BA5B C0 A1                    ..
        .byte   $DB                             ; BA5D DB                       .
        lda     ($DB,x)                         ; BA5E A1 DB                    ..
        lda     ($DB,x)                         ; BA60 A1 DB                    ..
        lda     ($DB,x)                         ; BA62 A1 DB                    ..
        lda     ($DB,x)                         ; BA64 A1 DB                    ..
        lda     ($DB,x)                         ; BA66 A1 DB                    ..
        .byte   $A3                             ; BA68 A3                       .
        ora     ($0C,x)                         ; BA69 01 0C                    ..
        .byte   $0B                             ; BA6B 0B                       .
        ldy     $A0                             ; BA6C A4 A0                    ..
        ldy     #$C2                            ; BA6E A0 C2                    ..
        cmp     ($D4,x)                         ; BA70 C1 D4                    ..
        .byte   $D4                             ; BA72 D4                       .
        cpy     LA0C5                           ; BA73 CC C5 A0                 ...
        brk                                     ; BA76 00                       .
        lda     $05                             ; BA77 A5 05                    ..
        ora     #$B0                            ; BA79 09 B0                    ..
        jsr     L0080                           ; BA7B 20 80 00                  ..
        jsr     LB619                           ; BA7E 20 19 B6                  ..
        ldy     #$A0                            ; BA81 A0 A0                    ..
        tay                                     ; BA83 A8                       .
        ora     ($0C,x)                         ; BA84 01 0C                    ..
        .byte   $0C                             ; BA86 0C                       .
        ldy     $A0                             ; BA87 A4 A0                    ..
        .byte   $D3                             ; BA89 D3                       .
        .byte   $C3                             ; BA8A C3                       .
        .byte   $CF                             ; BA8B CF                       .
        .byte   $D2                             ; BA8C D2                       .
        cmp     $A0                             ; BA8D C5 A0                    ..
        brk                                     ; BA8F 00                       .
        jsr     L6912                           ; BA90 20 12 69                  .i
        ldy     #$00                            ; BA93 A0 00                    ..
LBA95:  lda     L0060,y                         ; BA95 B9 60 00                 .`.
        jsr     L0080                           ; BA98 20 80 00                  ..
        iny                                     ; BA9B C8                       .
        cpy     #$04                            ; BA9C C0 04                    ..
        bne     LBA95                           ; BA9E D0 F5                    ..
        jsr     LB619                           ; BAA0 20 19 B6                  ..
        ldy     #$A8                            ; BAA3 A0 A8                    ..
        ora     ($0C,x)                         ; BAA5 01 0C                    ..
        ora     $BEBF                           ; BAA7 0D BF BE                 ...
        ldy     $BCBE,x                         ; BAAA BC BE BC                 ...
        ldx     $BEBC,y                         ; BAAD BE BC BE                 ...
        ldy     $BCBE,x                         ; BAB0 BC BE BC                 ...
        ldx     $BDBC,y                         ; BAB3 BE BC BD                 ...
        brk                                     ; BAB6 00                       .
        jmp     LB376                           ; BAB7 4C 76 B3                 Lv.

; ----------------------------------------------------------------------------
LBABA:  brk                                     ; BABA 00                       .
        .byte   $7F                             ; BABB 7F                       .
        rol     a                               ; BABC 2A                       *
        eor     L0080,x                         ; BABD 55 80                    U.
        .byte   $FF                             ; BABF FF                       .
        tax                                     ; BAC0 AA                       .
        .byte   $D5                             ; BAC1 D5                       .
LBAC2:  brk                                     ; BAC2 00                       .
        .byte   $7F                             ; BAC3 7F                       .
        eor     $2A,x                           ; BAC4 55 2A                    U*
        .byte   $80                             ; BAC6 80                       .
        .byte   $FF                             ; BAC7 FF                       .
        .byte   $D5                             ; BAC8 D5                       .
LBAC9:  tax                                     ; BAC9 AA                       .
LBACA:  lda     $AA                             ; BACA A5 AA                    ..
        .byte   $DE                             ; BACC DE                       .
        .byte   $A7                             ; BACD A7                       .
LBACE:  tsx                                     ; BACE BA                       .
LBACF:  ldx     $A0                             ; BACF A6 A0                    ..
        ldy     #$A0                            ; BAD1 A0 A0                    ..
        .byte   $A0                             ; BAD3 A0                       .
LBAD4:  .byte   $DC                             ; BAD4 DC                       .
        lda     $A5                             ; BAD5 A5 A5                    ..
        .byte   $DC                             ; BAD7 DC                       .
LBAD8:  .byte   $DF                             ; BAD8 DF                       .
        .byte   $DF                             ; BAD9 DF                       .
        .byte   $A6                             ; BADA A6                       .
LBADB:  ldx     $AB                             ; BADB A6 AB                    ..
        ldy     #$01                            ; BADD A0 01                    ..
        .byte   $03                             ; BADF 03                       .
        .byte   $F5                             ; BAE0 F5                       .
LBAE1:  .byte   $17                             ; BAE1 17                       .
        rts                                     ; BAE2 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; BAE3 60                       `

; ----------------------------------------------------------------------------
        adc     ($61,x)                         ; BAE4 61 61                    aa
        rts                                     ; BAE6 60                       `

; ----------------------------------------------------------------------------
LBAE7:  adc     ($CD,x)                         ; BAE7 61 CD                    a.
        tsx                                     ; BAE9 BA                       .
        lda     L6992                           ; BAEA AD 92 69                 ..i
        .byte   $51                             ; BAED 51                       Q
LBAEE:  .byte   $34                             ; BAEE 34                       4
        lda     LB9B8,y                         ; BAEF B9 B8 B9                 ...
        lda     LB9B9,y                         ; BAF2 B9 B9 B9                 ...
        lda     L0000,y                         ; BAF5 B9 00 00                 ...
        brk                                     ; BAF8 00                       .
        brk                                     ; BAF9 00                       .
        brk                                     ; BAFA 00                       .
        brk                                     ; BAFB 00                       .
        brk                                     ; BAFC 00                       .
        brk                                     ; BAFD 00                       .
        .byte   $0F                             ; BAFE 0F                       .
        .byte   $09                             ; BAFF 09                       .
