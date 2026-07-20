; da65 V2.19 - Git a028ac414
; Created:    reproducible build
; Input file: build/extract/selector6-load03-a000-a0ff.bin
; Page:       1


        .setcpu "6502"

; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------
; Mutable high address/page byte used by the renderer
selector6_render_state:
        .byte   $00                             ; A000 00                       .
; ----------------------------------------------------------------------------
; Render one eight-row glyph from the $A100 bitmap/font load
selector6_glyph_renderer:
        pha                                     ; A001 48                       H
        and     #$3F                            ; A002 29 3F                    )?
        sta     LA036                           ; A004 8D 36 A0                 .6.
        lda     #$00                            ; A007 A9 00                    ..
        asl     LA036                           ; A009 0E 36 A0                 .6.
        rol     a                               ; A00C 2A                       *
        rol     LA036                           ; A00D 2E 36 A0                 .6.
        rol     a                               ; A010 2A                       *
        rol     LA036                           ; A011 2E 36 A0                 .6.
        rol     a                               ; A014 2A                       *
        adc     selector6_render_state          ; A015 6D 00 A0                 m..
        adc     #$A1                            ; A018 69 A1                    i.
        sta     LA037                           ; A01A 8D 37 A0                 .7.
        tya                                     ; A01D 98                       .
        pha                                     ; A01E 48                       H
        txa                                     ; A01F 8A                       .
        pha                                     ; A020 48                       H
        ldy     $02                             ; A021 A4 02                    ..
        lda     selector6_hgr_low_rows,y        ; A023 B9 61 A0                 .a.
        sta     LA03B                           ; A026 8D 3B A0                 .;.
        lda     selector6_hgr_high_rows,y       ; A029 B9 79 A0                 .y.
        ora     $00                             ; A02C 05 00                    ..
        sta     LA03C                           ; A02E 8D 3C A0                 .<.
        ldy     $01                             ; A031 A4 01                    ..
        ldx     #$07                            ; A033 A2 07                    ..
LA035:
LA036           := * + 1
LA037           := * + 2
        lda     $1234,x                         ; A035 BD 34 12                 .4.
        eor     $03                             ; A038 45 03                    E.
LA03B           := * + 1
LA03C           := * + 2
        sta     $1234,y                         ; A03A 99 34 12                 .4.
        lda     LA03C                           ; A03D AD 3C A0                 .<.
        clc                                     ; A040 18                       .
        adc     #$04                            ; A041 69 04                    i.
        sta     LA03C                           ; A043 8D 3C A0                 .<.
        dex                                     ; A046 CA                       .
        bpl     LA035                           ; A047 10 EC                    ..
        inc     $01                             ; A049 E6 01                    ..
        lda     $01                             ; A04B A5 01                    ..
        cmp     #$28                            ; A04D C9 28                    .(
        bne     LA05B                           ; A04F D0 0A                    ..
        inc     $02                             ; A051 E6 02                    ..
        lda     $02                             ; A053 A5 02                    ..
        cmp     #$18                            ; A055 C9 18                    ..
        bne     LA05B                           ; A057 D0 02                    ..
        dec     $02                             ; A059 C6 02                    ..
LA05B:  pla                                     ; A05B 68                       h
        tax                                     ; A05C AA                       .
        pla                                     ; A05D 68                       h
        tay                                     ; A05E A8                       .
        pla                                     ; A05F 68                       h
        rts                                     ; A060 60                       `

; ----------------------------------------------------------------------------
; Low HGR row-address bytes
selector6_hgr_low_rows:
        .byte   $00,$80,$00,$80,$00,$80,$00,$80 ; A061 00 80 00 80 00 80 00 80  ........
        .byte   $28,$A8,$28,$A8,$28,$A8,$28,$A8 ; A069 28 A8 28 A8 28 A8 28 A8  (.(.(.(.
        .byte   $50,$D0,$50,$D0,$50,$D0,$50,$D0 ; A071 50 D0 50 D0 50 D0 50 D0  P.P.P.P.
; High HGR row-address offsets
selector6_hgr_high_rows:
        .byte   $00,$00,$01,$01,$02,$02,$03,$03 ; A079 00 00 01 01 02 02 03 03  ........
        .byte   $00,$00,$01,$01,$02,$02,$03,$03 ; A081 00 00 01 01 02 02 03 03  ........
        .byte   $00,$00,$01,$01,$02,$02,$03,$03 ; A089 00 00 01 01 02 02 03 03  ........
; High-bit drive/input prompt
selector6_prompt:
        .byte   $AD,$AD,$AD,$AD,$AD,$AD,$AD,$AD ; A091 AD AD AD AD AD AD AD AD  ........
        .byte   $AD,$AD,$AD,$AD,$AD,$AD,$8D,$D0 ; A099 AD AD AD AD AD AD 8D D0  ........
        .byte   $F5,$F4,$A0,$E4,$E9,$F3,$EB,$A0 ; A0A1 F5 F4 A0 E4 E9 F3 EB A0  ........
        .byte   $DB,$B2,$DD,$A0,$E9,$EE,$A0,$E4 ; A0A9 DB B2 DD A0 E9 EE A0 E4  ........
        .byte   $F2,$E9,$F6,$E5,$A0,$B1,$A0,$E1 ; A0B1 F2 E9 F6 E5 A0 B1 A0 E1  ........
        .byte   $EE,$E4,$A0,$E4,$E9,$F3,$EB,$A0 ; A0B9 EE E4 A0 E4 E9 F3 EB A0  ........
        .byte   $DB,$B0,$DD,$A0,$E9,$EE,$A0,$E4 ; A0C1 DB B0 DD A0 E9 EE A0 E4  ........
        .byte   $F2,$E9,$F6,$E5,$A0,$B2,$8D,$F0 ; A0C9 F2 E9 F6 E5 A0 B2 8D F0  ........
        .byte   $F2,$E5,$F3,$F3,$A0,$DB,$D7,$DD ; A0D1 F2 E5 F3 F3 A0 DB D7 DD  ........
        .byte   $A0,$F4,$EF,$A0,$F7,$F2,$E9,$F4 ; A0D9 A0 F4 EF A0 F7 F2 E9 F4  ........
        .byte   $E5,$A0,$EF,$F2,$A0,$DB,$C5,$DD ; A0E1 E5 A0 EF F2 A0 DB C5 DD  ........
        .byte   $A0,$F4,$EF,$A0,$E5,$F8,$E9,$F4 ; A0E9 A0 F4 EF A0 E5 F8 E9 F4  ........
        .byte   $BA,$20,$88,$00,$20,$81,$9E,$C9 ; A0F1 BA 20 88 00 20 81 9E C9  . .. ...
        .byte   $C5,$F0,$13,$C9,$E5,$00,$00     ; A0F9 C5 F0 13 C9 E5 00 00     .......
