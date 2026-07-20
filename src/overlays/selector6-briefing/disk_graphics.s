; Rescue Raiders selector-6 disk/graphics support load, source-exact.
        .setcpu "6502"
        .segment "SELECTOR678"

; ----------------------------------------------------------------------------
LBB00           := $BB00
; ----------------------------------------------------------------------------
; Load and decode picture selector $01; selectors 0/1 are opening1/opening2
packed_hgr_entry:
        jmp     load_packed_hgr                 ; 7800 4C 03 78                 L.x

; ----------------------------------------------------------------------------
; Load pointer sector and selected descending packed-image span into $A000+
load_packed_hgr:
        lda     #$00                            ; 7803 A9 00                    ..
        sta     $BFEB                           ; 7805 8D EB BF                 ...
        lda     #$01                            ; 7808 A9 01                    ..
        sta     $BFEA                           ; 780A 8D EA BF                 ...
        lda     #$7B                            ; 780D A9 7B                    .{
        sta     $BFEC                           ; 780F 8D EC BF                 ...
        lda     #$03                            ; 7812 A9 03                    ..
        sta     $BFED                           ; 7814 8D ED BF                 ...
        jsr     packed_hgr_rwts_retry           ; 7817 20 14 79                  .y
        ldx     $01                             ; 781A A6 01                    ..
        lda     $01                             ; 781C A5 01                    ..
        asl     a                               ; 781E 0A                       .
        tay                                     ; 781F A8                       .
        lda     $7B00,y                         ; 7820 B9 00 7B                 ..{
        sta     $7B                             ; 7823 85 7B                    .{
        lda     $7B01,y                         ; 7825 B9 01 7B                 ..{
        clc                                     ; 7828 18                       .
        adc     packed_hgr_load_counts_minus_one,x; 7829 7D 28 79               }(y
        pha                                     ; 782C 48                       H
        and     #$0F                            ; 782D 29 0F                    ).
        sta     $BFEB                           ; 782F 8D EB BF                 ...
        pla                                     ; 7832 68                       h
        lsr     a                               ; 7833 4A                       J
        lsr     a                               ; 7834 4A                       J
        lsr     a                               ; 7835 4A                       J
        lsr     a                               ; 7836 4A                       J
        sta     $BFEA                           ; 7837 8D EA BF                 ...
        inc     $BFEA                           ; 783A EE EA BF                 ...
        lda     packed_hgr_load_base_pages,x    ; 783D BD 23 79                 .#y
        sta     $7C                             ; 7840 85 7C                    .|
        clc                                     ; 7842 18                       .
        adc     packed_hgr_load_counts_minus_one,x; 7843 7D 28 79               }(y
        sta     $BFEC                           ; 7846 8D EC BF                 ...
        lda     packed_hgr_load_counts_minus_one,x; 7849 BD 28 79               .(y
; Read selected disk pages backward into ascending packed-data memory
load_packed_hgr_page:
        pha                                     ; 784C 48                       H
        jsr     packed_hgr_rwts_retry           ; 784D 20 14 79                  .y
        lda     $BFEB                           ; 7850 AD EB BF                 ...
        bne     L785D                           ; 7853 D0 08                    ..
        lda     #$10                            ; 7855 A9 10                    ..
        sta     $BFEB                           ; 7857 8D EB BF                 ...
        dec     $BFEA                           ; 785A CE EA BF                 ...
L785D:  dec     $BFEB                           ; 785D CE EB BF                 ...
        dec     $BFEC                           ; 7860 CE EC BF                 ...
        pla                                     ; 7863 68                       h
        sec                                     ; 7864 38                       8
        sbc     #$01                            ; 7865 E9 01                    ..
        bpl     load_packed_hgr_page            ; 7867 10 E3                    ..
        lda     #$00                            ; 7869 A9 00                    ..
        sta     $BFED                           ; 786B 8D ED BF                 ...
        jsr     packed_hgr_rwts_retry           ; 786E 20 14 79                  .y
        jsr     decode_hgr_parity_pass          ; 7871 20 9E 78                  .x
        inc     L78A3                           ; 7874 EE A3 78                 ..x
        jsr     decode_hgr_parity_pass          ; 7877 20 9E 78                  .x
        dec     L78A3                           ; 787A CE A3 78                 ..x
        lda     #$40                            ; 787D A9 40                    .@
        sta     L788D                           ; 787F 8D 8D 78                 ..x
        sta     L7890                           ; 7882 8D 90 78                 ..x
        lda     #$00                            ; 7885 A9 00                    ..
        ldx     #$20                            ; 7887 A2 20                    . 
; Clear the 512 non-display bytes in HGR page 2
clear_hgr_screen_holes:
        ldy     #$07                            ; 7889 A0 07                    ..
L788B:
L788D           := * + 2
        sta     $4078,y                         ; 788B 99 78 40                 .x@
L7890           := * + 2
        sta     $40F8,y                         ; 788E 99 F8 40                 ..@
        dey                                     ; 7891 88                       .
        bpl     L788B                           ; 7892 10 F7                    ..
        inc     L788D                           ; 7894 EE 8D 78                 ..x
        inc     L7890                           ; 7897 EE 90 78                 ..x
        dex                                     ; 789A CA                       .
        bne     clear_hgr_screen_holes          ; 789B D0 EC                    ..
        rts                                     ; 789D 60                       `

; ----------------------------------------------------------------------------
; Decode one even/odd scanline pass, columns 39 down to 0
decode_hgr_parity_pass:
        lda     #$27                            ; 789E A9 27                    .'
        sta     $7F                             ; 78A0 85 7F                    ..
; Self-modified row start: $C0 even, then $C1 odd
decode_hgr_start_row:
L78A3           := * + 1
        ldx     #$C0                            ; 78A2 A2 C0                    ..
; Read signed literal/run command from packed stream
decode_hgr_command:
        ldy     #$00                            ; 78A4 A0 00                    ..
        lda     ($7B),y                         ; 78A6 B1 7B                    .{
        inc     $7B                             ; 78A8 E6 7B                    .{
        bne     L78AE                           ; 78AA D0 02                    ..
        inc     $7C                             ; 78AC E6 7C                    .|
L78AE:  cmp     #$00                            ; 78AE C9 00                    ..
        bpl     decode_hgr_run                  ; 78B0 10 30                    .0
        and     #$7F                            ; 78B2 29 7F                    ).
        sta     $7D                             ; 78B4 85 7D                    .}
; Negative command: copy command&$7F literal bytes
decode_hgr_literal_loop:
        dex                                     ; 78B6 CA                       .
        dex                                     ; 78B7 CA                       .
        lda     packed_hgr_row_low,x            ; 78B8 BD ED 79                 ..y
        sta     L78D3                           ; 78BB 8D D3 78                 ..x
        lda     packed_hgr_row_high,x           ; 78BE BD 2D 79                 .-y
        ora     $00                             ; 78C1 05 00                    ..
        sta     L78D4                           ; 78C3 8D D4 78                 ..x
        ldy     #$00                            ; 78C6 A0 00                    ..
        lda     ($7B),y                         ; 78C8 B1 7B                    .{
        inc     $7B                             ; 78CA E6 7B                    .{
        bne     L78D0                           ; 78CC D0 02                    ..
        inc     $7C                             ; 78CE E6 7C                    .|
L78D0:  ldy     $7F                             ; 78D0 A4 7F                    ..
L78D3           := * + 1
L78D4           := * + 2
        sta     $1234,y                         ; 78D2 99 34 12                 .4.
        dec     $7D                             ; 78D5 C6 7D                    .}
        bne     decode_hgr_literal_loop         ; 78D7 D0 DD                    ..
        cpx     #$02                            ; 78D9 E0 02                    ..
        bcs     decode_hgr_command              ; 78DB B0 C7                    ..
        dec     $7F                             ; 78DD C6 7F                    ..
        bpl     decode_hgr_start_row            ; 78DF 10 C1                    ..
        rts                                     ; 78E1 60                       `

; ----------------------------------------------------------------------------
; Nonnegative command: repeat following byte (zero means 256)
decode_hgr_run:
        sta     $7D                             ; 78E2 85 7D                    .}
        lda     ($7B),y                         ; 78E4 B1 7B                    .{
        inc     $7B                             ; 78E6 E6 7B                    .{
        bne     L78EC                           ; 78E8 D0 02                    ..
        inc     $7C                             ; 78EA E6 7C                    .|
L78EC:  sta     $7E                             ; 78EC 85 7E                    .~
; Store one repeated byte at the next HGR scanline
decode_hgr_run_loop:
        dex                                     ; 78EE CA                       .
        dex                                     ; 78EF CA                       .
        lda     packed_hgr_row_low,x            ; 78F0 BD ED 79                 ..y
        sta     L7905                           ; 78F3 8D 05 79                 ..y
        lda     packed_hgr_row_high,x           ; 78F6 BD 2D 79                 .-y
        ora     $00                             ; 78F9 05 00                    ..
        sta     L7906                           ; 78FB 8D 06 79                 ..y
        lda     $7D                             ; 78FE A5 7D                    .}
        ldy     $7F                             ; 7900 A4 7F                    ..
        lda     $7E                             ; 7902 A5 7E                    .~
L7905           := * + 1
L7906           := * + 2
        sta     $1234,y                         ; 7904 99 34 12                 .4.
        dec     $7D                             ; 7907 C6 7D                    .}
        bne     decode_hgr_run_loop             ; 7909 D0 E3                    ..
        cpx     #$02                            ; 790B E0 02                    ..
        bcs     decode_hgr_command              ; 790D B0 95                    ..
        dec     $7F                             ; 790F C6 7F                    ..
        bpl     decode_hgr_start_row            ; 7911 10 8F                    ..
        rts                                     ; 7913 60                       `

; ----------------------------------------------------------------------------
; Issue the configured RWTS request until carry clears
packed_hgr_rwts_retry:
        lda     #$00                            ; 7914 A9 00                    ..
        sta     $BFEE                           ; 7916 8D EE BF                 ...
        ldx     #$E8                            ; 7919 A2 E8                    ..
        ldy     #$BF                            ; 791B A0 BF                    ..
        jsr     LBB00                           ; 791D 20 00 BB                  ..
        bcs     packed_hgr_rwts_retry           ; 7920 B0 F2                    ..
        rts                                     ; 7922 60                       `

; ----------------------------------------------------------------------------
; Selectors 0..4 packed-data base pages: $A0,$A0,$A5,$A5,$A5
packed_hgr_load_base_pages:
        .byte   $A0,$A0,$A5,$A5,$A5             ; 7923 A0 A0 A5 A5 A5           .....
; Selectors 0..4 descending load counts minus one
packed_hgr_load_counts_minus_one:
        .byte   $16,$17,$0D,$11,$15             ; 7928 16 17 0D 11 15           .....
; Relative HGR scanline high bytes indexed by decoded row
packed_hgr_row_high:
        .byte   $00,$04,$08,$0C,$10,$14,$18,$1C ; 792D 00 04 08 0C 10 14 18 1C  ........
        .byte   $00,$04,$08,$0C,$10,$14,$18,$1C ; 7935 00 04 08 0C 10 14 18 1C  ........
        .byte   $01,$05,$09,$0D,$11,$15,$19,$1D ; 793D 01 05 09 0D 11 15 19 1D  ........
        .byte   $01,$05,$09,$0D,$11,$15,$19,$1D ; 7945 01 05 09 0D 11 15 19 1D  ........
        .byte   $02,$06,$0A,$0E,$12,$16,$1A,$1E ; 794D 02 06 0A 0E 12 16 1A 1E  ........
        .byte   $02,$06,$0A,$0E,$12,$16,$1A,$1E ; 7955 02 06 0A 0E 12 16 1A 1E  ........
        .byte   $03,$07,$0B,$0F,$13,$17,$1B,$1F ; 795D 03 07 0B 0F 13 17 1B 1F  ........
        .byte   $03,$07,$0B,$0F,$13,$17,$1B,$1F ; 7965 03 07 0B 0F 13 17 1B 1F  ........
        .byte   $00,$04,$08,$0C,$10,$14,$18,$1C ; 796D 00 04 08 0C 10 14 18 1C  ........
        .byte   $00,$04,$08,$0C,$10,$14,$18,$1C ; 7975 00 04 08 0C 10 14 18 1C  ........
        .byte   $01,$05,$09,$0D,$11,$15,$19,$1D ; 797D 01 05 09 0D 11 15 19 1D  ........
        .byte   $01,$05,$09,$0D,$11,$15,$19,$1D ; 7985 01 05 09 0D 11 15 19 1D  ........
        .byte   $02,$06,$0A,$0E,$12,$16,$1A,$1E ; 798D 02 06 0A 0E 12 16 1A 1E  ........
        .byte   $02,$06,$0A,$0E,$12,$16,$1A,$1E ; 7995 02 06 0A 0E 12 16 1A 1E  ........
        .byte   $03,$07,$0B,$0F,$13,$17,$1B,$1F ; 799D 03 07 0B 0F 13 17 1B 1F  ........
        .byte   $03,$07,$0B,$0F,$13,$17,$1B,$1F ; 79A5 03 07 0B 0F 13 17 1B 1F  ........
        .byte   $00,$04,$08,$0C,$10,$14,$18,$1C ; 79AD 00 04 08 0C 10 14 18 1C  ........
        .byte   $00,$04,$08,$0C,$10,$14,$18,$1C ; 79B5 00 04 08 0C 10 14 18 1C  ........
        .byte   $01,$05,$09,$0D,$11,$15,$19,$1D ; 79BD 01 05 09 0D 11 15 19 1D  ........
        .byte   $01,$05,$09,$0D,$11,$15,$19,$1D ; 79C5 01 05 09 0D 11 15 19 1D  ........
        .byte   $02,$06,$0A,$0E,$12,$16,$1A,$1E ; 79CD 02 06 0A 0E 12 16 1A 1E  ........
        .byte   $02,$06,$0A,$0E,$12,$16,$1A,$1E ; 79D5 02 06 0A 0E 12 16 1A 1E  ........
        .byte   $03,$07,$0B,$0F,$13,$17,$1B,$1F ; 79DD 03 07 0B 0F 13 17 1B 1F  ........
        .byte   $03,$07,$0B,$0F,$13,$17,$1B,$1F ; 79E5 03 07 0B 0F 13 17 1B 1F  ........
; HGR scanline low bytes indexed by decoded row
packed_hgr_row_low:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 79ED 00 00 00 00 00 00 00 00  ........
        .byte   $80,$80,$80,$80,$80,$80,$80,$80 ; 79F5 80 80 80 80 80 80 80 80  ........
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 79FD 00 00 00 00 00 00 00 00  ........
        .byte   $80,$80,$80,$80,$80,$80,$80,$80 ; 7A05 80 80 80 80 80 80 80 80  ........
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 7A0D 00 00 00 00 00 00 00 00  ........
        .byte   $80,$80,$80,$80,$80,$80,$80,$80 ; 7A15 80 80 80 80 80 80 80 80  ........
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 7A1D 00 00 00 00 00 00 00 00  ........
        .byte   $80,$80,$80,$80,$80,$80,$80,$80 ; 7A25 80 80 80 80 80 80 80 80  ........
        .byte   $28,$28,$28,$28,$28,$28,$28,$28 ; 7A2D 28 28 28 28 28 28 28 28  ((((((((
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8 ; 7A35 A8 A8 A8 A8 A8 A8 A8 A8  ........
        .byte   $28,$28,$28,$28,$28,$28,$28,$28 ; 7A3D 28 28 28 28 28 28 28 28  ((((((((
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8 ; 7A45 A8 A8 A8 A8 A8 A8 A8 A8  ........
        .byte   $28,$28,$28,$28,$28,$28,$28,$28 ; 7A4D 28 28 28 28 28 28 28 28  ((((((((
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8 ; 7A55 A8 A8 A8 A8 A8 A8 A8 A8  ........
        .byte   $28,$28,$28,$28,$28,$28,$28,$28 ; 7A5D 28 28 28 28 28 28 28 28  ((((((((
        .byte   $A8,$A8,$A8,$A8,$A8,$A8,$A8,$A8 ; 7A65 A8 A8 A8 A8 A8 A8 A8 A8  ........
        .byte   $50,$50,$50,$50,$50,$50,$50,$50 ; 7A6D 50 50 50 50 50 50 50 50  PPPPPPPP
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0 ; 7A75 D0 D0 D0 D0 D0 D0 D0 D0  ........
        .byte   $50,$50,$50,$50,$50,$50,$50,$50 ; 7A7D 50 50 50 50 50 50 50 50  PPPPPPPP
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0 ; 7A85 D0 D0 D0 D0 D0 D0 D0 D0  ........
        .byte   $50,$50,$50,$50,$50,$50,$50,$50 ; 7A8D 50 50 50 50 50 50 50 50  PPPPPPPP
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0 ; 7A95 D0 D0 D0 D0 D0 D0 D0 D0  ........
        .byte   $50,$50,$50,$50,$50,$50,$50,$50 ; 7A9D 50 50 50 50 50 50 50 50  PPPPPPPP
        .byte   $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0 ; 7AA5 D0 D0 D0 D0 D0 D0 D0 D0  ........
; Residual table/source-text bytes after the HGR row tables
packed_hgr_residual:
        .byte   $06,$0F,$0F,$00,$8D,$8D,$8D,$8D ; 7AAD 06 0F 0F 00 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7AB5 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7ABD 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7AC5 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7ACD 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7AD5 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7ADD 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7AE5 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$8D,$8D,$8D ; 7AED 8D 8D 8D 8D 8D 8D 8D 8D  ........
        .byte   $8D,$8D,$8D,$8D,$8D,$0A,$0A,$8D ; 7AF5 8D 8D 8D 8D 8D 0A 0A 8D  ........
        .byte   $8D,$8D,$8D                     ; 7AFD 8D 8D 8D                 ...
