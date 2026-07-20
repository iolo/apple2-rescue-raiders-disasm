; da65 V2.19 - Git a028ac414
; Created:    reproducible build
; Input file: build/extract/selector2-load00-8000-83ff.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
L0E18           := $0E18
L2218           := $2218
L8400           := $8400
L8402           := $8402
L8404           := $8404
L8406           := $8406
L8408           := $8408
L840A           := $840A
L840C           := $840C
L840E           := $840E
L8411           := $8411
L8413           := $8413
L8415           := $8415
L8417           := $8417
L841B           := $841B
L841D           := $841D
L841F           := $841F
L8421           := $8421
L8423           := $8423
L8425           := $8425
L8427           := $8427
L8429           := $8429
L842B           := $842B
L842D           := $842D
L842F           := $842F
L8431           := $8431
L8433           := $8433
L8435           := $8435
L8438           := $8438
L843A           := $843A
L843C           := $843C
L843E           := $843E
L8440           := $8440
L8442           := $8442
L8446           := $8446
L8448           := $8448
L844A           := $844A
L844C           := $844C
L844E           := $844E
L8450           := $8450
L8718           := $8718
LBFC8           := $BFC8
; ----------------------------------------------------------------------------
        jmp     L8005                           ; 8000 4C 05 80                 L..

; ----------------------------------------------------------------------------
        .byte   $3D                             ; 8003 3D                       =
        brk                                     ; 8004 00                       .
L8005:  ldx     #$04                            ; 8005 A2 04                    ..
        lda     #$3D                            ; 8007 A9 3D                    .=
        sta     $70                             ; 8009 85 70                    .p
        lda     #$80                            ; 800B A9 80                    ..
        sta     $71                             ; 800D 85 71                    .q
        ldy     #$00                            ; 800F A0 00                    ..
L8011:  lda     ($70),y                         ; 8011 B1 70                    .p
        eor     #$A7                            ; 8013 49 A7                    I.
        sta     ($70),y                         ; 8015 91 70                    .p
L8017:  iny                                     ; 8017 C8                       .
        bne     L8011                           ; 8018 D0 F7                    ..
        inc     $71                             ; 801A E6 71                    .q
        dex                                     ; 801C CA                       .
        bne     L8011                           ; 801D D0 F2                    ..
        lda     #$01                            ; 801F A9 01                    ..
        sta     $BFED                           ; 8021 8D ED BF                 ...
        jsr     L8046                           ; 8024 20 46 80                  F.
        lda     $01                             ; 8027 A5 01                    ..
        asl     a                               ; 8029 0A                       .
        tay                                     ; 802A A8                       .
        lda     L8365,y                         ; 802B B9 65 83                 .e.
        sta     $70                             ; 802E 85 70                    .p
        lda     L8366,y                         ; 8030 B9 66 83                 .f.
        sta     $71                             ; 8033 85 71                    .q
        jsr     L80AC                           ; 8035 20 AC 80                  ..
        lda     #$05                            ; 8038 A9 05                    ..
        jmp     LBFC8                           ; 803A 4C C8 BF                 L..

; ----------------------------------------------------------------------------
        asl     $77A5                           ; 803D 0E A5 77                 ..w
        lda     $0E                             ; 8040 A5 0E                    ..
        ldy     $2A                             ; 8042 A4 2A                    .*
        lsr     a                               ; 8044 4A                       J
        clc                                     ; 8045 18                       .
L8046:  ora     $4F                             ; 8046 05 4F                    .O
        .byte   $07                             ; 8048 07                       .
        clc                                     ; 8049 18                       .
        .byte   $87                             ; 804A 87                       .
        .byte   $A7                             ; 804B A7                       .
        .byte   $1C                             ; 804C 1C                       .
        .byte   $17                             ; 804D 17                       .
        bvc     L8017                           ; 804E 50 C7                    P.
        .byte   $C7                             ; 8050 C7                       .
        tya                                     ; 8051 98                       .
        and     $87                             ; 8052 25 87                    %.
        ldx     #$24                            ; 8054 A2 24                    .$
        .byte   $EB                             ; 8056 EB                       .
        .byte   $8F                             ; 8057 8F                       .
        bit     $0E                             ; 8058 24 0E                    $.
        .byte   $A7                             ; 805A A7                       .
        .byte   $22                             ; 805B 22                       "
        lda     ($2A,x)                         ; 805C A1 2A                    .*
        eor     $2A18                           ; 805E 4D 18 2A                 M.*
        jmp     L0E18                           ; 8061 4C 18 0E                 L..

; ----------------------------------------------------------------------------
        cli                                     ; 8064 58                       X
        .byte   $22                             ; 8065 22                       "
        ldy     #$C7                            ; 8066 A0 C7                    ..
        ldy     $2A                             ; 8068 A4 2A                    .*
        lsr     a                               ; 806A 4A                       J
        clc                                     ; 806B 18                       .
        asl     $2A37                           ; 806C 0E 37 2A                 .7*
        .byte   $4B                             ; 806F 4B                       K
        clc                                     ; 8070 18                       .
        .byte   $87                             ; 8071 87                       .
        sbc     ($27,x)                         ; 8072 E1 27                    .'
        .byte   $07                             ; 8074 07                       .
        lda     ($3F,x)                         ; 8075 A1 3F                    .?
        .byte   $BF                             ; 8077 BF                       .
        dec     $3752,x                         ; 8078 DE 52 37                 .R7
        .byte   $2F                             ; 807B 2F                       /
        .byte   $B7                             ; 807C B7                       .
        eor     $58EE,x                         ; 807D 5D EE 58                 ].X
        nop                                     ; 8080 EA                       .
        .byte   $53                             ; 8081 53                       S
        .byte   $37                             ; 8082 37                       7
        .byte   $57                             ; 8083 57                       W
        .byte   $A3                             ; 8084 A3                       .
        asl     $2258                           ; 8085 0E 58 22                 .X"
        lda     ($0A,x)                         ; 8088 A1 0A                    ..
        .byte   $47                             ; 808A 47                       G
        .byte   $37                             ; 808B 37                       7
        .byte   $EF                             ; 808C EF                       .
        asl     $2AA3                           ; 808D 0E A3 2A                 ..*
        jmp     L8718                           ; 8090 4C 18 87                 L..

; ----------------------------------------------------------------------------
        inc     $27                             ; 8093 E6 27                    .'
        asl     a                               ; 8095 0A                       .
        .byte   $E7                             ; 8096 E7                       .
        .byte   $37                             ; 8097 37                       7
        rol     a                               ; 8098 2A                       *
        .byte   $3C                             ; 8099 3C                       <
        bit     $0A                             ; 809A 24 0A                    $.
        inc     $37                             ; 809C E6 37                    .7
        rol     a                               ; 809E 2A                       *
        .byte   $3B                             ; 809F 3B                       ;
        bit     $CF                             ; 80A0 24 CF                    $.
        rol     a                               ; 80A2 2A                       *
        eor     L8718                           ; 80A3 4D 18 87                 M..
        inc     $27                             ; 80A6 E6 27                    .'
        .byte   $87                             ; 80A8 87                       .
        ldy     $25,x                           ; 80A9 B4 25                    .%
        .byte   $C7                             ; 80AB C7                       .
L80AC:  .byte   $CB                             ; 80AC CB                       .
        .byte   $D7                             ; 80AD D7                       .
        .byte   $A7                             ; 80AE A7                       .
        .byte   $1A                             ; 80AF 1A                       .
        .byte   $2B                             ; 80B0 2B                       +
        .byte   $67                             ; 80B1 67                       g
        .byte   $B7                             ; 80B2 B7                       .
        .byte   $5C                             ; 80B3 5C                       \
        .byte   $9F                             ; 80B4 9F                       .
        sta     $CE2A                           ; 80B5 8D 2A CE                 .*.
        bit     $1A                             ; 80B8 24 1A                    $.
        .byte   $2B                             ; 80BA 2B                       +
        .byte   $67                             ; 80BB 67                       g
        .byte   $B7                             ; 80BC B7                       .
        .byte   $5C                             ; 80BD 5C                       \
        txa                                     ; 80BE 8A                       .
        dec     $C724                           ; 80BF CE 24 C7                 .$.
        ora     #$4E                            ; 80C2 09 4E                    .N
        clc                                     ; 80C4 18                       .
        .byte   $1A                             ; 80C5 1A                       .
        and     #$67                            ; 80C6 29 67                    )g
        .byte   $07                             ; 80C8 07                       .
        .byte   $5B                             ; 80C9 5B                       [
        .byte   $23                             ; 80CA 23                       #
        .byte   $D3                             ; 80CB D3                       .
        .byte   $6F                             ; 80CC 6F                       o
        .byte   $77                             ; 80CD 77                       w
        .byte   $A3                             ; 80CE A3                       .
        eor     ($D3,x)                         ; 80CF 41 D3                    A.
        .byte   $57                             ; 80D1 57                       W
        .byte   $92                             ; 80D2 92                       .
        .byte   $1A                             ; 80D3 1A                       .
        .byte   $2B                             ; 80D4 2B                       +
        .byte   $67                             ; 80D5 67                       g
        .byte   $B7                             ; 80D6 B7                       .
        .byte   $5C                             ; 80D7 5C                       \
        ror     $7772                           ; 80D8 6E 72 77                 nrw
        .byte   $57                             ; 80DB 57                       W
        .byte   $1A                             ; 80DC 1A                       .
        .byte   $2B                             ; 80DD 2B                       +
        .byte   $67                             ; 80DE 67                       g
        .byte   $B7                             ; 80DF B7                       .
        .byte   $5C                             ; 80E0 5C                       \
        ror     $770D                           ; 80E1 6E 0D 77                 n.w
        .byte   $54                             ; 80E4 54                       T
        .byte   $1A                             ; 80E5 1A                       .
        .byte   $2B                             ; 80E6 2B                       +
        .byte   $67                             ; 80E7 67                       g
        .byte   $B7                             ; 80E8 B7                       .
        .byte   $5C                             ; 80E9 5C                       \
        ror     $7731                           ; 80EA 6E 31 77                 n1w
        eor     $0887                           ; 80ED 4D 87 08                 M..
        .byte   $27                             ; 80F0 27                       '
        .byte   $87                             ; 80F1 87                       .
        php                                     ; 80F2 08                       .
        .byte   $27                             ; 80F3 27                       '
        .byte   $87                             ; 80F4 87                       .
        php                                     ; 80F5 08                       .
        .byte   $27                             ; 80F6 27                       '
        rol     a                               ; 80F7 2A                       *
        cmp     $8724                           ; 80F8 CD 24 87                 .$.
        php                                     ; 80FB 08                       .
        .byte   $27                             ; 80FC 27                       '
        .byte   $1A                             ; 80FD 1A                       .
        .byte   $2B                             ; 80FE 2B                       +
        .byte   $67                             ; 80FF 67                       g
        .byte   $B7                             ; 8100 B7                       .
        .byte   $5C                             ; 8101 5C                       \
        ror     $7779                           ; 8102 6E 79 77                 nyw
        adc     $BF,x                           ; 8105 75 BF                    u.
        .byte   $C7                             ; 8107 C7                       .
        .byte   $9F                             ; 8108 9F                       .
        .byte   $C7                             ; 8109 C7                       .
        .byte   $87                             ; 810A 87                       .
        .byte   $27                             ; 810B 27                       '
        rol     $0E                             ; 810C 26 0E                    &.
        .byte   $A7                             ; 810E A7                       .
        .byte   $22                             ; 810F 22                       "
        .byte   $D7                             ; 8110 D7                       .
        asl     $2237                           ; 8111 0E 37 22                 .7"
        dec     $87,x                           ; 8114 D6 87                    ..
        cmp     $26                             ; 8116 C5 26                    .&
        .byte   $17                             ; 8118 17                       .
        .byte   $83                             ; 8119 83                       .
        .byte   $02                             ; 811A 02                       .
        .byte   $D7                             ; 811B D7                       .
        rol     a                               ; 811C 2A                       *
        cpy     $0224                           ; 811D CC 24 02                 .$.
        dec     $2A,x                           ; 8120 D6 2A                    .*
        .byte   $CB                             ; 8122 CB                       .
        bit     $BF                             ; 8123 24 BF                    $.
        dec     $22BF                           ; 8125 CE BF 22                 .."
        dec     $87,x                           ; 8128 D6 87                    ..
        cmp     $26                             ; 812A C5 26                    .&
        .byte   $17                             ; 812C 17                       .
        .byte   $B7                             ; 812D B7                       .
        .byte   $02                             ; 812E 02                       .
        .byte   $D7                             ; 812F D7                       .
        .byte   $9F                             ; 8130 9F                       .
        lsr     a                               ; 8131 4A                       J
        cpy     $2224                           ; 8132 CC 24 22                 .$"
        cmp     $02,x                           ; 8135 D5 02                    ..
        dec     $4A,x                           ; 8137 D6 4A                    .J
        .byte   $CB                             ; 8139 CB                       .
        bit     $22                             ; 813A 24 22                    $"
        .byte   $D4                             ; 813C D4                       .
        .byte   $BF                             ; 813D BF                       .
        .byte   $C7                             ; 813E C7                       .
        .byte   $87                             ; 813F 87                       .
        lda     $E226                           ; 8140 AD 26 E2                 .&.
        cmp     $07,x                           ; 8143 D5 07                    ..
        .byte   $A7                             ; 8145 A7                       .
        .byte   $BF                             ; 8146 BF                       .
        dec     $D7,x                           ; 8147 D6 D7                    ..
        ora     ($D7,x)                         ; 8149 01 D7                    ..
        .byte   $77                             ; 814B 77                       w
        lda     $61                             ; 814C A5 61                    .a
        dec     $61,x                           ; 814E D6 61                    .a
        .byte   $D7                             ; 8150 D7                       .
        adc     $CC4B                           ; 8151 6D 4B CC                 mK.
        bit     $77                             ; 8154 24 77                    $w
        pha                                     ; 8156 48                       H
        ora     ($D6,x)                         ; 8157 01 D6                    ..
        .byte   $4B                             ; 8159 4B                       K
        .byte   $CB                             ; 815A CB                       .
        bit     $77                             ; 815B 24 77                    $w
        .byte   $4F                             ; 815D 4F                       O
        .byte   $BF                             ; 815E BF                       .
        .byte   $C7                             ; 815F C7                       .
        .byte   $9F                             ; 8160 9F                       .
        .byte   $C7                             ; 8161 C7                       .
        .byte   $07                             ; 8162 07                       .
        .byte   $AF                             ; 8163 AF                       .
        asl     $2660,x                         ; 8164 1E 60 26                 .`&
        .byte   $57                             ; 8167 57                       W
        lda     $76,x                           ; 8168 B5 76                    .v
        .byte   $D7                             ; 816A D7                       .
        .byte   $57                             ; 816B 57                       W
        lda     #$41                            ; 816C A9 41                    .A
        .byte   $D7                             ; 816E D7                       .
        .byte   $77                             ; 816F 77                       w
        lsr     $41,x                           ; 8170 56 41                    VA
        dec     $02,x                           ; 8172 D6 02                    ..
        dec     $6E,x                           ; 8174 D6 6E                    .n
        .byte   $17                             ; 8176 17                       .
        .byte   $77                             ; 8177 77                       w
        lsr     $C79F                           ; 8178 4E 9F C7                 N..
        .byte   $2F                             ; 817B 2F                       /
        .byte   $B7                             ; 817C B7                       .
        eor     ($BF,x)                         ; 817D 41 BF                    A.
        .byte   $C7                             ; 817F C7                       .
        ora     #$4E                            ; 8180 09 4E                    .N
        clc                                     ; 8182 18                       .
        .byte   $87                             ; 8183 87                       .
        adc     $27                             ; 8184 65 27                    e'
        .byte   $17                             ; 8186 17                       .
        .byte   $5C                             ; 8187 5C                       \
        asl     a                               ; 8188 0A                       .
        cmp     $6E24                           ; 8189 CD 24 6E                 .$n
        tay                                     ; 818C A8                       .
        .byte   $77                             ; 818D 77                       w
        .byte   $53                             ; 818E 53                       S
        .byte   $1A                             ; 818F 1A                       .
        .byte   $2B                             ; 8190 2B                       +
        .byte   $67                             ; 8191 67                       g
        .byte   $B7                             ; 8192 B7                       .
        .byte   $5C                             ; 8193 5C                       \
        ror     $7779                           ; 8194 6E 79 77                 nyw
        bvc     L81B3                           ; 8197 50 1A                    P.
        .byte   $2B                             ; 8199 2B                       +
        .byte   $67                             ; 819A 67                       g
        .byte   $B7                             ; 819B B7                       .
        .byte   $5C                             ; 819C 5C                       \
        ror     $770D                           ; 819D 6E 0D 77                 n.w
        .byte   $54                             ; 81A0 54                       T
        .byte   $1A                             ; 81A1 1A                       .
        .byte   $2B                             ; 81A2 2B                       +
        .byte   $67                             ; 81A3 67                       g
        .byte   $B7                             ; 81A4 B7                       .
        .byte   $5C                             ; 81A5 5C                       \
        ror     $774C                           ; 81A6 6E 4C 77                 nLw
        eor     $A707                           ; 81A9 4D 07 A7                 M..
        .byte   $23                             ; 81AC 23                       #
        .byte   $D7                             ; 81AD D7                       .
        asl     $2237                           ; 81AE 0E 37 22                 .7"
        dec     $0E,x                           ; 81B1 D6 0E                    ..
L81B3:  .byte   $87                             ; 81B3 87                       .
        .byte   $22                             ; 81B4 22                       "
        cmp     $1A,x                           ; 81B5 D5 1A                    ..
        .byte   $2B                             ; 81B7 2B                       +
        .byte   $67                             ; 81B8 67                       g
        .byte   $B7                             ; 81B9 B7                       .
        .byte   $5C                             ; 81BA 5C                       \
        rol     $D7,x                           ; 81BB 36 D7                    6.
        .byte   $6F                             ; 81BD 6F                       o
        .byte   $77                             ; 81BE 77                       w
        eor     ($41),y                         ; 81BF 51 41                    QA
        dec     $61,x                           ; 81C1 D6 61                    .a
        cmp     $77,x                           ; 81C3 D5 77                    .w
        .byte   $57                             ; 81C5 57                       W
        .byte   $C7                             ; 81C6 C7                       .
        .byte   $72                             ; 81C7 72                       r
        ora     $A731                           ; 81C8 0D 31 A7                 .1.
        .byte   $A7                             ; 81CB A7                       .
        .byte   $A7                             ; 81CC A7                       .
        .byte   $A7                             ; 81CD A7                       .
        ora     $0E0D                           ; 81CE 0D 0D 0E                 ...
        .byte   $A7                             ; 81D1 A7                       .
        rol     a                               ; 81D2 2A                       *
        eor     $2A18                           ; 81D3 4D 18 2A                 M.*
        jmp     L2218                           ; 81D6 4C 18 22                 L."

; ----------------------------------------------------------------------------
        .byte   $D7                             ; 81D9 D7                       .
        .byte   $87                             ; 81DA 87                       .
        txs                                     ; 81DB 9A                       .
        .byte   $27                             ; 81DC 27                       '
        .byte   $87                             ; 81DD 87                       .
        adc     $27                             ; 81DE 65 27                    e'
        asl     $1758                           ; 81E0 0E 58 17                 .X.
        .byte   $89                             ; 81E3 89                       .
        asl     a                               ; 81E4 0A                       .
        cmp     $7724                           ; 81E5 CD 24 77                 .$w
        .byte   $53                             ; 81E8 53                       S
        eor     #$4D                            ; 81E9 49 4D                    IM
        clc                                     ; 81EB 18                       .
        asl     a                               ; 81EC 0A                       .
        eor     $6E18                           ; 81ED 4D 18 6E                 M.n
        sty     $57                             ; 81F0 84 57                    .W
        ldx     $9A87,y                         ; 81F2 BE 87 9A                 ...
        .byte   $27                             ; 81F5 27                       '
        .byte   $87                             ; 81F6 87                       .
        adc     $27                             ; 81F7 65 27                    e'
        .byte   $17                             ; 81F9 17                       .
        bcs     L8207                           ; 81FA B0 0B                    ..
        eor     $0A18                           ; 81FC 4D 18 0A                 M..
        cmp     $AD24                           ; 81FF CD 24 AD                 .$.
        ror     $2858,x                         ; 8202 7E 58 28                 ~X(
        .byte   $57                             ; 8205 57                       W
        .byte   $45                             ; 8206 45                       E
L8207:  .byte   $22                             ; 8207 22                       "
        .byte   $D7                             ; 8208 D7                       .
        .byte   $EB                             ; 8209 EB                       .
        lsr     $BF26                           ; 820A 4E 26 BF                 N&.
        .byte   $02                             ; 820D 02                       .
        .byte   $D7                             ; 820E D7                       .
        .byte   $57                             ; 820F 57                       W
        ldx     $9F                             ; 8210 A6 9F                    ..
        .byte   $C7                             ; 8212 C7                       .
        asl     $2AA4                           ; 8213 0E A4 2A                 ..*
        and     $24,x                           ; 8216 35 24                    5$
        adc     #$35                            ; 8218 69 35                    i5
        bit     $77                             ; 821A 24 77                    $w
        ldx     #$0E                            ; 821C A2 0E                    ..
        cli                                     ; 821E 58                       X
        .byte   $22                             ; 821F 22                       "
        lda     ($C7,x)                         ; 8220 A1 C7                    ..
        .byte   $87                             ; 8222 87                       .
        lda     $1726                           ; 8223 AD 26 17                 .&.
        lsr     $02,x                           ; 8226 56 02                    V.
        cmp     $EA,x                           ; 8228 D5 EA                    ..
        .byte   $3C                             ; 822A 3C                       <
        bit     $77                             ; 822B 24 77                    $w
        eor     $D4E2                           ; 822D 4D E2 D4                 M..
        nop                                     ; 8230 EA                       .
        .byte   $3B                             ; 8231 3B                       ;
        bit     $77                             ; 8232 24 77                    $w
        .byte   $44                             ; 8234 44                       D
        .byte   $C7                             ; 8235 C7                       .
        ldy     $AAAB                           ; 8236 AC AB AA                 ...
        lda     #$A8                            ; 8239 A9 A8                    ..
        .byte   $B7                             ; 823B B7                       .
        ldx     $B2,y                           ; 823C B6 B2                    ..
        lda     $A70E,y                         ; 823E B9 0E A7                 ...
        rol     a                               ; 8241 2A                       *
        eor     L0E18                           ; 8242 4D 18 0E                 M..
        .byte   $A3                             ; 8245 A3                       .
        rol     a                               ; 8246 2A                       *
        jmp     L0E18                           ; 8247 4C 18 0E                 L..

; ----------------------------------------------------------------------------
        .byte   $37                             ; 824A 37                       7
        rol     a                               ; 824B 2A                       *
        .byte   $4B                             ; 824C 4B                       K
        clc                                     ; 824D 18                       .
        .byte   $87                             ; 824E 87                       .
        inc     $27                             ; 824F E6 27                    .'
        asl     $2AAF                           ; 8251 0E AF 2A                 ..*
        .byte   $3A                             ; 8254 3A                       :
        bit     $87                             ; 8255 24 87                    $.
        cmp     $3725                           ; 8257 CD 25 37                 .%7
        ldx     $CD87                           ; 825A AE 87 CD                 ...
        and     $37                             ; 825D 25 37                    %7
        .byte   $A3                             ; 825F A3                       .
        asl     $22A7                           ; 8260 0E A7 22                 .."
        ldy     #$69                            ; 8263 A0 69                    .i
        .byte   $3A                             ; 8265 3A                       :
        bit     $B7                             ; 8266 24 B7                    $.
        lsr     a                               ; 8268 4A                       J
        .byte   $C7                             ; 8269 C7                       .
        .byte   $0B                             ; 826A 0B                       .
        .byte   $3A                             ; 826B 3A                       :
        bit     $1E                             ; 826C 24 1E                    $.
        sta     ($25),y                         ; 826E 91 25                    .%
        rol     a                               ; 8270 2A                       *
        eor     L8718                           ; 8271 4D 18 87                 M..
        txs                                     ; 8274 9A                       .
        .byte   $27                             ; 8275 27                       '
        .byte   $07                             ; 8276 07                       .
        tay                                     ; 8277 A8                       .
        asl     $3EA7                           ; 8278 0E A7 3E                 ..>
        and     $2F24,y                         ; 827B 39 24 2F                 9$/
        .byte   $B7                             ; 827E B7                       .
        .byte   $5F                             ; 827F 5F                       _
        asl     $2A97                           ; 8280 0E 97 2A                 ..*
        and     $24,x                           ; 8283 35 24                    5$
        asl     $22B7                           ; 8285 0E B7 22                 .."
        cmp     $69,x                           ; 8288 D5 69                    .i
        and     $24,x                           ; 828A 35 24                    5$
        .byte   $77                             ; 828C 77                       w
        lda     $9F                             ; 828D A5 9F                    ..
        .byte   $C7                             ; 828F C7                       .
        .byte   $87                             ; 8290 87                       .
        adc     $27                             ; 8291 65 27                    e'
        .byte   $17                             ; 8293 17                       .
        .byte   $53                             ; 8294 53                       S
        .byte   $0B                             ; 8295 0B                       .
        cmp     $1E24                           ; 8296 CD 24 1E                 .$.
        and     $7724,y                         ; 8299 39 24 77                 9$w
        .byte   $4B                             ; 829C 4B                       K
        .byte   $87                             ; 829D 87                       .
        .byte   $1B                             ; 829E 1B                       .
        and     $17                             ; 829F 25 17                    %.
        rti                                     ; 82A1 40                       @

; ----------------------------------------------------------------------------
        adc     ($D5,x)                         ; 82A2 61 D5                    a.
        .byte   $77                             ; 82A4 77                       w
        .byte   $44                             ; 82A5 44                       D
        asl     $07A7                           ; 82A6 0E A7 07                 ...
        tay                                     ; 82A9 A8                       .
        inc     $2409,x                         ; 82AA FE 09 24                 ..$
        .byte   $2F                             ; 82AD 2F                       /
        .byte   $B7                             ; 82AE B7                       .
        eor     $3A0B,x                         ; 82AF 5D 0B 3A                 ].:
        bit     $7E                             ; 82B2 24 7E                    $~
        cpx     $37                             ; 82B4 E4 37                    .7
        .byte   $77                             ; 82B6 77                       w
        lda     $BF                             ; 82B7 A5 BF                    ..
        .byte   $C7                             ; 82B9 C7                       .
        .byte   $9F                             ; 82BA 9F                       .
        .byte   $C7                             ; 82BB C7                       .
        .byte   $07                             ; 82BC 07                       .
        .byte   $57                             ; 82BD 57                       W
        .byte   $6F                             ; 82BE 6F                       o
        .byte   $77                             ; 82BF 77                       w
        lda     $9F                             ; 82C0 A5 9F                    ..
        .byte   $C7                             ; 82C2 C7                       .
        .byte   $1A                             ; 82C3 1A                       .
        .byte   $2B                             ; 82C4 2B                       +
        .byte   $67                             ; 82C5 67                       g
        .byte   $B7                             ; 82C6 B7                       .
        .byte   $5C                             ; 82C7 5C                       \
        ror     $7772                           ; 82C8 6E 72 77                 nrw
        eor     $1A,x                           ; 82CB 55 1A                    U.
        .byte   $2B                             ; 82CD 2B                       +
        .byte   $67                             ; 82CE 67                       g
        .byte   $B7                             ; 82CF B7                       .
        .byte   $5C                             ; 82D0 5C                       \
        ror     $770D                           ; 82D1 6E 0D 77                 n.w
        .byte   $54                             ; 82D4 54                       T
        .byte   $1A                             ; 82D5 1A                       .
        .byte   $2B                             ; 82D6 2B                       +
        .byte   $67                             ; 82D7 67                       g
        .byte   $B7                             ; 82D8 B7                       .
        .byte   $5C                             ; 82D9 5C                       \
        ror     $770A                           ; 82DA 6E 0A 77                 n.w
        eor     $F007                           ; 82DD 4D 07 F0                 M..
        .byte   $9F                             ; 82E0 9F                       .
        .byte   $37                             ; 82E1 37                       7
        .byte   $BF                             ; 82E2 BF                       .
        .byte   $1A                             ; 82E3 1A                       .
        .byte   $2B                             ; 82E4 2B                       +
        .byte   $67                             ; 82E5 67                       g
        .byte   $B7                             ; 82E6 B7                       .
        .byte   $5C                             ; 82E7 5C                       \
        .byte   $2F                             ; 82E8 2F                       /
        .byte   $77                             ; 82E9 77                       w
        .byte   $5F                             ; 82EA 5F                       _
        .byte   $17                             ; 82EB 17                       .
        .byte   $52                             ; 82EC 52                       R
        .byte   $0B                             ; 82ED 0B                       .
        cmp     $3E24                           ; 82EE CD 24 3E                 .$>
        ora     #$24                            ; 82F1 09 24                    .$
        .byte   $1A                             ; 82F3 1A                       .
        .byte   $2B                             ; 82F4 2B                       +
        .byte   $67                             ; 82F5 67                       g
        .byte   $B7                             ; 82F6 B7                       .
        .byte   $5C                             ; 82F7 5C                       \
        ror     $7779                           ; 82F8 6E 79 77                 nyw
        ldy     #$0E                            ; 82FB A0 0E                    ..
        cli                                     ; 82FD 58                       X
        rol     $2439,x                         ; 82FE 3E 39 24                 >9$
        .byte   $BF                             ; 8301 BF                       .
        .byte   $C7                             ; 8302 C7                       .
        .byte   $9F                             ; 8303 9F                       .
        .byte   $C7                             ; 8304 C7                       .
        asl     $2AA7                           ; 8305 0E A7 2A                 ..*
        eor     L0E18                           ; 8308 4D 18 0E                 M..
        ldx     #$2A                            ; 830B A2 2A                    .*
        jmp     L0E18                           ; 830D 4C 18 0E                 L..

; ----------------------------------------------------------------------------
        .byte   $37                             ; 8310 37                       7
        rol     a                               ; 8311 2A                       *
        .byte   $4B                             ; 8312 4B                       K
        clc                                     ; 8313 18                       .
        .byte   $87                             ; 8314 87                       .
        inc     $27                             ; 8315 E6 27                    .'
        .byte   $87                             ; 8317 87                       .
        .byte   $77                             ; 8318 77                       w
        rol     $EF                             ; 8319 26 EF                    &.
        .byte   $87                             ; 831B 87                       .
        .byte   $77                             ; 831C 77                       w
        rol     $CF                             ; 831D 26 CF                    &.
        .byte   $37                             ; 831F 37                       7
        lda     ($57,x)                         ; 8320 A1 57                    .W
        .byte   $A3                             ; 8322 A3                       .
        asl     $22A7                           ; 8323 0E A7 22                 .."
        ldy     #$C7                            ; 8326 A0 C7                    ..
        asl     $2AA7                           ; 8328 0E A7 2A                 ..*
        eor     L0E18                           ; 832B 4D 18 0E                 M..
        .byte   $A3                             ; 832E A3                       .
        rol     a                               ; 832F 2A                       *
        jmp     L0E18                           ; 8330 4C 18 0E                 L..

; ----------------------------------------------------------------------------
        .byte   $37                             ; 8333 37                       7
        rol     a                               ; 8334 2A                       *
        .byte   $4B                             ; 8335 4B                       K
        clc                                     ; 8336 18                       .
        .byte   $87                             ; 8337 87                       .
L8338:  inc     $27                             ; 8338 E6 27                    .'
        asl     a                               ; 833A 0A                       .
        sbc     $37                             ; 833B E5 37                    .7
        rol     a                               ; 833D 2A                       *
        rts                                     ; 833E 60                       `

; ----------------------------------------------------------------------------
        bit     $0E                             ; 833F 24 0E                    $.
        .byte   $A7                             ; 8341 A7                       .
        rol     a                               ; 8342 2A                       *
L8343:  jmp     L8718                           ; 8343 4C 18 87                 L..

; ----------------------------------------------------------------------------
        inc     $27                             ; 8346 E6 27                    .'
        asl     a                               ; 8348 0A                       .
        .byte   $44                             ; 8349 44                       D
        .byte   $37                             ; 834A 37                       7
        rol     a                               ; 834B 2A                       *
        eor     L8718                           ; 834C 4D 18 87                 M..
        txs                                     ; 834F 9A                       .
        .byte   $27                             ; 8350 27                       '
        .byte   $87                             ; 8351 87                       .
        tya                                     ; 8352 98                       .
        rol     $37                             ; 8353 26 37                    &7
        ldx     #$87                            ; 8355 A2 87                    ..
        tya                                     ; 8357 98                       .
        rol     $17                             ; 8358 26 17                    &.
        ldx     #$6A                            ; 835A A2 6A                    .j
        rts                                     ; 835C 60                       `

; ----------------------------------------------------------------------------
        bit     $57                             ; 835D 24 57                    $W
        .byte   $A3                             ; 835F A3                       .
        asl     $22A7                           ; 8360 0E A7 22                 .."
        ldy     #$C7                            ; 8363 A0 C7                    ..
L8365:  .byte   $FE                             ; 8365 FE                       .
L8366:  .byte   $27                             ; 8366 27                       '
        .byte   $F7                             ; 8367 F7                       .
        .byte   $27                             ; 8368 27                       '
        .byte   $A7                             ; 8369 A7                       .
        .byte   $A7                             ; 836A A7                       .
        .byte   $A7                             ; 836B A7                       .
        .byte   $A7                             ; 836C A7                       .
        bvc     L83BF                           ; 836D 50 50                    PP
        bvc     L83C1                           ; 836F 50 50                    PP
        bvc     L83C3                           ; 8371 50 50                    PP
        bvc     L83C5                           ; 8373 50 50                    PP
        bvc     L83C7                           ; 8375 50 50                    PP
        bvc     L83C9                           ; 8377 50 50                    PP
        bvc     L83CB                           ; 8379 50 50                    PP
        bvc     L83CD                           ; 837B 50 50                    PP
        bvc     L83CF                           ; 837D 50 50                    PP
        bvc     L83D1                           ; 837F 50 50                    PP
        bvc     L83D3                           ; 8381 50 50                    PP
        bvc     L83D5                           ; 8383 50 50                    PP
        bvc     L83D7                           ; 8385 50 50                    PP
        bvc     L83D9                           ; 8387 50 50                    PP
        bvc     L83DB                           ; 8389 50 50                    PP
        bvc     L83DD                           ; 838B 50 50                    PP
        bvc     L83DF                           ; 838D 50 50                    PP
        bvc     L8338                           ; 838F 50 A7                    P.
        .byte   $A7                             ; 8391 A7                       .
        .byte   $A7                             ; 8392 A7                       .
        .byte   $A7                             ; 8393 A7                       .
        bvc     L83E6                           ; 8394 50 50                    PP
        bvc     L83E8                           ; 8396 50 50                    PP
        bvc     L83EA                           ; 8398 50 50                    PP
        bvc     L8343                           ; 839A 50 A7                    P.
        .byte   $A7                             ; 839C A7                       .
        .byte   $A7                             ; 839D A7                       .
        bvc     L83F0                           ; 839E 50 50                    PP
        bvc     L83F2                           ; 83A0 50 50                    PP
        bvc     L83F4                           ; 83A2 50 50                    PP
        bvc     L83F6                           ; 83A4 50 50                    PP
        bvc     L83F8                           ; 83A6 50 50                    PP
        bvc     L83FA                           ; 83A8 50 50                    PP
        bvc     L83FC                           ; 83AA 50 50                    PP
        bvc     L83FE                           ; 83AC 50 50                    PP
        bvc     L8400                           ; 83AE 50 50                    PP
        bvc     L8402                           ; 83B0 50 50                    PP
        bvc     L8404                           ; 83B2 50 50                    PP
        bvc     L8406                           ; 83B4 50 50                    PP
        bvc     L8408                           ; 83B6 50 50                    PP
        bvc     L840A                           ; 83B8 50 50                    PP
        bvc     L840C                           ; 83BA 50 50                    PP
        bvc     L840E                           ; 83BC 50 50                    PP
        .byte   $50                             ; 83BE 50                       P
L83BF:  bvc     L8411                           ; 83BF 50 50                    PP
L83C1:  bvc     L8413                           ; 83C1 50 50                    PP
L83C3:  bvc     L8415                           ; 83C3 50 50                    PP
L83C5:  bvc     L8417                           ; 83C5 50 50                    PP
L83C7:  .byte   $A7                             ; 83C7 A7                       .
        .byte   $50                             ; 83C8 50                       P
L83C9:  bvc     L841B                           ; 83C9 50 50                    PP
L83CB:  bvc     L841D                           ; 83CB 50 50                    PP
L83CD:  bvc     L841F                           ; 83CD 50 50                    PP
L83CF:  bvc     L8421                           ; 83CF 50 50                    PP
L83D1:  bvc     L8423                           ; 83D1 50 50                    PP
L83D3:  bvc     L8425                           ; 83D3 50 50                    PP
L83D5:  bvc     L8427                           ; 83D5 50 50                    PP
L83D7:  bvc     L8429                           ; 83D7 50 50                    PP
L83D9:  bvc     L842B                           ; 83D9 50 50                    PP
L83DB:  bvc     L842D                           ; 83DB 50 50                    PP
L83DD:  bvc     L842F                           ; 83DD 50 50                    PP
L83DF:  bvc     L8431                           ; 83DF 50 50                    PP
        bvc     L8433                           ; 83E1 50 50                    PP
        bvc     L8435                           ; 83E3 50 50                    PP
        .byte   $50                             ; 83E5 50                       P
L83E6:  bvc     L8438                           ; 83E6 50 50                    PP
L83E8:  bvc     L843A                           ; 83E8 50 50                    PP
L83EA:  bvc     L843C                           ; 83EA 50 50                    PP
        bvc     L843E                           ; 83EC 50 50                    PP
        bvc     L8440                           ; 83EE 50 50                    PP
L83F0:  bvc     L8442                           ; 83F0 50 50                    PP
L83F2:  bvc     L8404                           ; 83F2 50 10                    P.
L83F4:  bvc     L8446                           ; 83F4 50 50                    PP
L83F6:  bvc     L8448                           ; 83F6 50 50                    PP
L83F8:  bvc     L844A                           ; 83F8 50 50                    PP
L83FA:  bvc     L844C                           ; 83FA 50 50                    PP
L83FC:  bvc     L844E                           ; 83FC 50 50                    PP
L83FE:  bvc     L8450                           ; 83FE 50 50                    PP
