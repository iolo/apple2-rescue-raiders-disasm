; Rescue Raiders selector-6 briefing/map coordinator, source-exact.
        .setcpu "6502"
        .segment "SELECTOR6"

; ----------------------------------------------------------------------------
L0207           := $0207
L7800           := $7800
L7C00           := $7C00
LA001           := $A001
LBB00           := $BB00
LBFC8           := $BFC8
LD800           := $D800
; ----------------------------------------------------------------------------
; Public jump to briefing/map coordinator
selector6_entry:
        jmp     selector6_coordinator           ; 8000 4C 86 80                 L..

; ----------------------------------------------------------------------------
; Render one briefing character, optionally with the typewriter delay
render_message_character:
        jsr     L836F                           ; 8003 20 6F 83                  o.
        bit     selector6_workspace             ; 8006 2C 53 87                 ,S.
        bpl     L801B                           ; 8009 10 10                    ..
        tya                                     ; 800B 98                       .
        pha                                     ; 800C 48                       H
        lda     #$00                            ; 800D A9 00                    ..
        ldy     #$20                            ; 800F A0 20                    . 
L8011:  sec                                     ; 8011 38                       8
        sbc     #$01                            ; 8012 E9 01                    ..
        bne     L8011                           ; 8014 D0 FB                    ..
        dey                                     ; 8016 88                       .
        bne     L8011                           ; 8017 D0 F8                    ..
        pla                                     ; 8019 68                       h
        tay                                     ; 801A A8                       .
L801B:  rts                                     ; 801B 60                       `

; ----------------------------------------------------------------------------
; Consumes metadata and high-bit text following its JSR return address
render_inline_message:
        pla                                     ; 801C 68                       h
        sta     $70                             ; 801D 85 70                    .p
        pla                                     ; 801F 68                       h
        sta     $71                             ; 8020 85 71                    .q
L8022:  ldy     #$00                            ; 8022 A0 00                    ..
        inc     $70                             ; 8024 E6 70                    .p
        bne     L802A                           ; 8026 D0 02                    ..
        inc     $71                             ; 8028 E6 71                    .q
L802A:  lda     ($70),y                         ; 802A B1 70                    .p
        cmp     #$0A                            ; 802C C9 0A                    ..
        bcc     L8039                           ; 802E 90 09                    ..
        jsr     render_message_character        ; 8030 20 03 80                  ..
        jsr     L817A                           ; 8033 20 7A 81                  z.
        jmp     L8022                           ; 8036 4C 22 80                 L".

; ----------------------------------------------------------------------------
L8039:  tax                                     ; 8039 AA                       .
        bne     L8043                           ; 803A D0 07                    ..
        lda     $71                             ; 803C A5 71                    .q
        pha                                     ; 803E 48                       H
        lda     $70                             ; 803F A5 70                    .p
        pha                                     ; 8041 48                       H
        rts                                     ; 8042 60                       `

; ----------------------------------------------------------------------------
L8043:  dex                                     ; 8043 CA                       .
        bne     L8057                           ; 8044 D0 11                    ..
        jsr     L8229                           ; 8046 20 29 82                  ).
        lda     ($70),y                         ; 8049 B1 70                    .p
        sta     $01                             ; 804B 85 01                    ..
        jsr     L8229                           ; 804D 20 29 82                  ).
        lda     ($70),y                         ; 8050 B1 70                    .p
        sta     $02                             ; 8052 85 02                    ..
        jmp     L8022                           ; 8054 4C 22 80                 L".

; ----------------------------------------------------------------------------
L8057:  dex                                     ; 8057 CA                       .
        bne     L8062                           ; 8058 D0 08                    ..
        lda     #$00                            ; 805A A9 00                    ..
        sta     selector6_workspace             ; 805C 8D 53 87                 .S.
        jmp     L8022                           ; 805F 4C 22 80                 L".

; ----------------------------------------------------------------------------
L8062:  dex                                     ; 8062 CA                       .
        bne     L806D                           ; 8063 D0 08                    ..
        lda     #$FF                            ; 8065 A9 FF                    ..
        sta     selector6_workspace             ; 8067 8D 53 87                 .S.
        jmp     L8022                           ; 806A 4C 22 80                 L".

; ----------------------------------------------------------------------------
L806D:  jmp     L8022                           ; 806D 4C 22 80                 L".

; ----------------------------------------------------------------------------
        pha                                     ; 8070 48                       H
        lsr     a                               ; 8071 4A                       J
        lsr     a                               ; 8072 4A                       J
        lsr     a                               ; 8073 4A                       J
        lsr     a                               ; 8074 4A                       J
        jsr     L8079                           ; 8075 20 79 80                  y.
        pla                                     ; 8078 68                       h
L8079:  and     #$0F                            ; 8079 29 0F                    ).
        ora     #$B0                            ; 807B 09 B0                    ..
        cmp     #$BA                            ; 807D C9 BA                    ..
        bcc     L8083                           ; 807F 90 02                    ..
        adc     #$06                            ; 8081 69 06                    i.
L8083:  jmp     render_message_character        ; 8083 4C 03 80                 L..

; ----------------------------------------------------------------------------
; Briefing, city/map, and selector dispatch coordinator
selector6_coordinator:
        lda     $05                             ; 8086 A5 05                    ..
        cmp     #$09                            ; 8088 C9 09                    ..
        beq     L8098                           ; 808A F0 0C                    ..
        jsr     prepare_later_stage_map         ; 808C 20 90 81                  ..
        jsr     present_emergency_briefing      ; 808F 20 C4 80                  ..
        jsr     present_campaign_city           ; 8092 20 E0 81                  ..
        jmp     dispatch_next_selector          ; 8095 4C 9B 80                 L..

; ----------------------------------------------------------------------------
L8098:  jsr     L81CA                           ; 8098 20 CA 81                  ..
; Campaign-index-dependent selector handoff through INTER
dispatch_next_selector:
        jsr     synchronize_hgr_page2           ; 809B 20 63 82                  c.
        lda     $05                             ; 809E A5 05                    ..
L80A1           := * + 1
        cmp     #$01                            ; 80A0 C9 01                    ..
        beq     L80AB                           ; 80A2 F0 07                    ..
        lda     L80A1                           ; 80A4 AD A1 80                 ...
        sta     $01                             ; 80A7 85 01                    ..
        lda     #$FE                            ; 80A9 A9 FE                    ..
L80AB:  clc                                     ; 80AB 18                       .
        adc     #$04                            ; 80AC 69 04                    i.
        jmp     LBFC8                           ; 80AE 4C C8 BF                 L..

; ----------------------------------------------------------------------------
L80B1:  bit     $C054                           ; 80B1 2C 54 C0                 ,T.
        lda     $00                             ; 80B4 A5 00                    ..
        cmp     #$20                            ; 80B6 C9 20                    . 
        beq     flip_hgr_drawing_page           ; 80B8 F0 03                    ..
        bit     $C055                           ; 80BA 2C 55 C0                 ,U.
; Toggle the HGR drawing-page base between $2000 and $4000
flip_hgr_drawing_page:
        lda     $00                             ; 80BD A5 00                    ..
        eor     #$60                            ; 80BF 49 60                    I`
        sta     $00                             ; 80C1 85 00                    ..
        rts                                     ; 80C3 60                       `

; ----------------------------------------------------------------------------
; FLOW-60 presentation path
present_emergency_briefing:
        lda     #$00                            ; 80C4 A9 00                    ..
        sta     $BFED                           ; 80C6 8D ED BF                 ...
        jsr     L82B5                           ; 80C9 20 B5 82                  ..
        jsr     synchronize_hgr_page2           ; 80CC 20 63 82                  c.
        jsr     L85D8                           ; 80CF 20 D8 85                  ..
        lda     #$00                            ; 80D2 A9 00                    ..
        sta     $0200                           ; 80D4 8D 00 02                 ...
        jsr     L0207                           ; 80D7 20 07 02                  ..
        jsr     LD800                           ; 80DA 20 00 D8                  ..
        jsr     flip_hgr_drawing_page           ; 80DD 20 BD 80                  ..
        lda     #$FF                            ; 80E0 A9 FF                    ..
        sta     L8759                           ; 80E2 8D 59 87                 .Y.
        jsr     render_inline_message           ; 80E5 20 1C 80                  ..
; Position commands plus Emergency transmission and Terrorists have been found at
briefing_message_record:
        .byte   $03,$01,$00,$00,$C5,$ED,$E5,$F2 ; 80E8 03 01 00 00 C5 ED E5 F2  ........
        .byte   $E7,$E5,$EE,$E3,$F9,$A0,$F4,$F2 ; 80F0 E7 E5 EE E3 F9 A0 F4 F2  ........
        .byte   $E1,$EE,$F3,$ED,$E9,$F3,$F3,$E9 ; 80F8 E1 EE F3 ED E9 F3 F3 E9  ........
        .byte   $EF,$EE,$BE,$01,$06,$06,$D4,$E5 ; 8100 EF EE BE 01 06 06 D4 E5  ........
        .byte   $F2,$F2,$EF,$F2,$E9,$F3,$F4,$F3 ; 8108 F2 F2 EF F2 E9 F3 F4 F3  ........
        .byte   $A0,$E8,$E1,$F6,$E5,$A0,$E2,$E5 ; 8110 A0 E8 E1 F6 E5 A0 E2 E5  ........
        .byte   $E5,$EE,$A0,$E6,$EF,$F5,$EE,$E4 ; 8118 E5 EE A0 E6 EF F5 EE E4  ........
        .byte   $A0,$E1,$F4,$00                 ; 8120 A0 E1 F4 00              ....
; ----------------------------------------------------------------------------
; Center the stage city on row 9 and append the action prompt
render_briefing_city_and_prompt:
        lda     #$09                            ; 8124 A9 09                    ..
        sta     $02                             ; 8126 85 02                    ..
        jsr     city_record_renderer            ; 8128 20 70 82                  p.
        jsr     render_inline_message           ; 812B 20 1C 80                  ..
; Inline position command and high-bit Prepare for action
prepare_for_action_record:
        .byte   $01,$0B,$0C,$D0,$F2,$E5,$F0,$E1 ; 812E 01 0B 0C D0 F2 E5 F0 E1  ........
        .byte   $F2,$E5,$A0,$E6,$EF,$F2,$A0,$E1 ; 8136 F2 E5 A0 E6 EF F2 A0 E1  ........
        .byte   $E3,$F4,$E9,$EF,$EE,$00         ; 813E E3 F4 E9 EF EE 00        ......
; ----------------------------------------------------------------------------
; Present the composed briefing and wait for its delay/input gate
wait_for_briefing_continue:
        jsr     flip_hgr_drawing_page           ; 8144 20 BD 80                  ..
L8147:  jsr     L817A                           ; 8147 20 7A 81                  z.
        lda     L875B                           ; 814A AD 5B 87                 .[.
        ora     $59                             ; 814D 05 59                    .Y
        bne     L8147                           ; 814F D0 F6                    ..
        lda     $06                             ; 8151 A5 06                    ..
        beq     L8179                           ; 8153 F0 24                    .$
        lda     $05                             ; 8155 A5 05                    ..
        cmp     #$02                            ; 8157 C9 02                    ..
        bcc     L8179                           ; 8159 90 1E                    ..
        ldx     #$40                            ; 815B A2 40                    .@
        lda     #$20                            ; 815D A9 20                    . 
        sta     $71                             ; 815F 85 71                    .q
        ldy     #$00                            ; 8161 A0 00                    ..
        sty     $70                             ; 8163 84 70                    .p
L8165:  lda     $1800,y                         ; 8165 B9 00 18                 ...
        sta     ($70),y                         ; 8168 91 70                    .p
        iny                                     ; 816A C8                       .
        bne     L8165                           ; 816B D0 F8                    ..
        inc     $71                             ; 816D E6 71                    .q
        dex                                     ; 816F CA                       .
        bne     L8165                           ; 8170 D0 F3                    ..
        lda     #$00                            ; 8172 A9 00                    ..
        pha                                     ; 8174 48                       H
        lda     #$FF                            ; 8175 A9 FF                    ..
        pha                                     ; 8177 48                       H
        rts                                     ; 8178 60                       `

; ----------------------------------------------------------------------------
L8179:  rts                                     ; 8179 60                       `

; ----------------------------------------------------------------------------
L817A:  ldy     L875B                           ; 817A AC 5B 87                 .[.
        beq     L818F                           ; 817D F0 10                    ..
        ldx     $59                             ; 817F A6 59                    .Y
        bne     L818F                           ; 8181 D0 0C                    ..
        lda     L8747,y                         ; 8183 B9 47 87                 .G.
        bpl     L818A                           ; 8186 10 02                    ..
        lda     $05                             ; 8188 A5 05                    ..
L818A:  sta     $59                             ; 818A 85 59                    .Y
        dec     L875B                           ; 818C CE 5B 87                 .[.
L818F:  rts                                     ; 818F 60                       `

; ----------------------------------------------------------------------------
; Later-stage map/progression preparation
prepare_later_stage_map:
        lda     $05                             ; 8190 A5 05                    ..
        cmp     #$02                            ; 8192 C9 02                    ..
        bcs     L8197                           ; 8194 B0 01                    ..
        rts                                     ; 8196 60                       `

; ----------------------------------------------------------------------------
L8197:  jsr     L8641                           ; 8197 20 41 86                  A.
        jsr     load_campaign_map_progression   ; 819A 20 A4 82                  ..
        lda     $05                             ; 819D A5 05                    ..
        clc                                     ; 819F 18                       .
        adc     #$09                            ; 81A0 69 09                    i.
        jsr     L83EE                           ; 81A2 20 EE 83                  ..
L81A5:  jsr     load_campaign_map_base          ; 81A5 20 A0 82                  ..
        ldx     #$01                            ; 81A8 A2 01                    ..
L81AA:  inx                                     ; 81AA E8                       .
        lda     L86F4,x                         ; 81AB BD F4 86                 ...
        sta     $01                             ; 81AE 85 01                    ..
        lda     L86FC,x                         ; 81B0 BD FC 86                 ...
        sta     $02                             ; 81B3 85 02                    ..
        lda     #$AB                            ; 81B5 A9 AB                    ..
        cpx     $05                             ; 81B7 E4 05                    ..
        bne     L81BD                           ; 81B9 D0 02                    ..
        lda     #$AA                            ; 81BB A9 AA                    ..
L81BD:  jsr     L85CE                           ; 81BD 20 CE 85                  ..
        cpx     $05                             ; 81C0 E4 05                    ..
        bcc     L81AA                           ; 81C2 90 E6                    ..
        lda     $05                             ; 81C4 A5 05                    ..
        jsr     L83EE                           ; 81C6 20 EE 83                  ..
        rts                                     ; 81C9 60                       `

; ----------------------------------------------------------------------------
L81CA:  lda     #$04                            ; 81CA A9 04                    ..
        sta     L875A                           ; 81CC 8D 5A 87                 .Z.
        jsr     L81A5                           ; 81CF 20 A5 81                  ..
        jsr     load_final_campaign_map         ; 81D2 20 9C 82                  ..
        lda     #$04                            ; 81D5 A9 04                    ..
        sta     L875A                           ; 81D7 8D 5A 87                 .Z.
        lda     #$0A                            ; 81DA A9 0A                    ..
        jsr     L83EE                           ; 81DC 20 EE 83                  ..
        rts                                     ; 81DF 60                       `

; ----------------------------------------------------------------------------
; FLOW-70 city selection, rendering, and continue gate
present_campaign_city:
        jsr     load_campaign_map_base          ; 81E0 20 A0 82                  ..
        jsr     LD800                           ; 81E3 20 00 D8                  ..
        lda     #$00                            ; 81E6 A9 00                    ..
        sta     selector6_workspace             ; 81E8 8D 53 87                 .S.
        sta     L8759                           ; 81EB 8D 59 87                 .Y.
        lda     #$17                            ; 81EE A9 17                    ..
        sta     $02                             ; 81F0 85 02                    ..
        jsr     city_record_renderer            ; 81F2 20 70 82                  p.
        jsr     L80B1                           ; 81F5 20 B1 80                  ..
        jsr     city_record_renderer            ; 81F8 20 70 82                  p.
        jsr     flip_hgr_drawing_page           ; 81FB 20 BD 80                  ..
        lda     #$08                            ; 81FE A9 08                    ..
L8200:  pha                                     ; 8200 48                       H
        lda     #$03                            ; 8201 A9 03                    ..
        sta     L8755                           ; 8203 8D 55 87                 .U.
L8206:  jsr     animate_campaign_location       ; 8206 20 C4 82                  ..
        dec     L8755                           ; 8209 CE 55 87                 .U.
        bpl     L8206                           ; 820C 10 F8                    ..
        pla                                     ; 820E 68                       h
        bit     $C061                           ; 820F 2C 61 C0                 ,a.
        bmi     L8225                           ; 8212 30 11                    0.
        ldy     $C000                           ; 8214 AC 00 C0                 ...
        bpl     L8220                           ; 8217 10 07                    ..
        bit     $C010                           ; 8219 2C 10 C0                 ,..
        cpy     #$9B                            ; 821C C0 9B                    ..
        beq     L8225                           ; 821E F0 05                    ..
L8220:  sec                                     ; 8220 38                       8
        sbc     #$01                            ; 8221 E9 01                    ..
        bne     L8200                           ; 8223 D0 DB                    ..
L8225:  jsr     flip_hgr_drawing_page           ; 8225 20 BD 80                  ..
        rts                                     ; 8228 60                       `

; ----------------------------------------------------------------------------
L8229:  inc     $70                             ; 8229 E6 70                    .p
        bne     L822F                           ; 822B D0 02                    ..
        inc     $71                             ; 822D E6 71                    .q
L822F:  rts                                     ; 822F 60                       `

; ----------------------------------------------------------------------------
; Copy all 32 HGR pages between the current and alternate framebuffer
copy_alternate_hgr_page:
        lda     $00                             ; 8230 A5 00                    ..
        sta     L8249                           ; 8232 8D 49 82                 .I.
        sta     L824F                           ; 8235 8D 4F 82                 .O.
        eor     #$60                            ; 8238 49 60                    I`
        sta     L8246                           ; 823A 8D 46 82                 .F.
        sta     L824C                           ; 823D 8D 4C 82                 .L.
        ldx     #$20                            ; 8240 A2 20                    . 
L8242:  ldy     #$77                            ; 8242 A0 77                    .w
L8244:
L8246           := * + 2
        lda     $2000,y                         ; 8244 B9 00 20                 .. 
L8249           := * + 2
        sta     $4000,y                         ; 8247 99 00 40                 ..@
L824C           := * + 2
        lda     $2080,y                         ; 824A B9 80 20                 .. 
L824F           := * + 2
        sta     $4080,y                         ; 824D 99 80 40                 ..@
        dey                                     ; 8250 88                       .
        bpl     L8244                           ; 8251 10 F1                    ..
        inc     L8246                           ; 8253 EE 46 82                 .F.
        inc     L824C                           ; 8256 EE 4C 82                 .L.
        inc     L8249                           ; 8259 EE 49 82                 .I.
        inc     L824F                           ; 825C EE 4F 82                 .O.
        dex                                     ; 825F CA                       .
        bne     L8242                           ; 8260 D0 E0                    ..
        rts                                     ; 8262 60                       `

; ----------------------------------------------------------------------------
; Copy/flip only when the drawing page is not already page 2
synchronize_hgr_page2:
        lda     $00                             ; 8263 A5 00                    ..
        cmp     #$40                            ; 8265 C9 40                    .@
        beq     L826F                           ; 8267 F0 06                    ..
        jsr     copy_alternate_hgr_page         ; 8269 20 30 82                  0.
        jmp     L80B1                           ; 826C 4C B1 80                 L..

; ----------------------------------------------------------------------------
L826F:  rts                                     ; 826F 60                       `

; ----------------------------------------------------------------------------
; Indexes stage city pointer and renders its length-prefixed record
city_record_renderer:
        ldy     $05                             ; 8270 A4 05                    ..
        lda     L86A7,y                         ; 8272 B9 A7 86                 ...
        sta     $70                             ; 8275 85 70                    .p
        lda     L86AF,y                         ; 8277 B9 AF 86                 ...
        sta     $71                             ; 827A 85 71                    .q
        ldy     #$00                            ; 827C A0 00                    ..
        lda     ($70),y                         ; 827E B1 70                    .p
        lsr     a                               ; 8280 4A                       J
        sta     $01                             ; 8281 85 01                    ..
        lda     #$13                            ; 8283 A9 13                    ..
        sec                                     ; 8285 38                       8
        sbc     $01                             ; 8286 E5 01                    ..
        sta     $01                             ; 8288 85 01                    ..
        ldy     #$00                            ; 828A A0 00                    ..
        lda     ($70),y                         ; 828C B1 70                    .p
        tax                                     ; 828E AA                       .
L828F:  iny                                     ; 828F C8                       .
        dex                                     ; 8290 CA                       .
        bpl     L8294                           ; 8291 10 01                    ..
        rts                                     ; 8293 60                       `

; ----------------------------------------------------------------------------
L8294:  lda     ($70),y                         ; 8294 B1 70                    .p
        jsr     render_message_character        ; 8296 20 03 80                  ..
        jmp     L828F                           ; 8299 4C 8F 82                 L..

; ----------------------------------------------------------------------------
; Decode packed-HGR selector 4
load_final_campaign_map:
        lda     #$04                            ; 829C A9 04                    ..
        bne     L82A6                           ; 829E D0 06                    ..
; Decode packed-HGR selector 2, the map base matched by map.hgr
load_campaign_map_base:
        lda     #$02                            ; 82A0 A9 02                    ..
        bne     L82A6                           ; 82A2 D0 02                    ..
; Decode packed-HGR selector 3 for later-stage progression
load_campaign_map_progression:
        lda     #$03                            ; 82A4 A9 03                    ..
L82A6:  pha                                     ; 82A6 48                       H
        jsr     synchronize_hgr_page2           ; 82A7 20 63 82                  c.
        pla                                     ; 82AA 68                       h
        sta     $01                             ; 82AB 85 01                    ..
        jmp     L7800                           ; 82AD 4C 00 78                 L.x

; ----------------------------------------------------------------------------
L82B0:  lda     #$03                            ; 82B0 A9 03                    ..
        sta     $BFED                           ; 82B2 8D ED BF                 ...
L82B5:  lda     #$00                            ; 82B5 A9 00                    ..
        sta     $BFEE                           ; 82B7 8D EE BF                 ...
        ldx     #$E8                            ; 82BA A2 E8                    ..
        ldy     #$BF                            ; 82BC A0 BF                    ..
        jsr     LBB00                           ; 82BE 20 00 BB                  ..
        bcs     L82B5                           ; 82C1 B0 F2                    ..
        rts                                     ; 82C3 60                       `

; ----------------------------------------------------------------------------
; Animate eight surrounding positions around the fixed stage marker
animate_campaign_location:
        lda     #$01                            ; 82C4 A9 01                    ..
        sta     L8754                           ; 82C6 8D 54 87                 .T.
        lda     #$03                            ; 82C9 A9 03                    ..
L82CB:  pha                                     ; 82CB 48                       H
        jsr     render_campaign_location_ring   ; 82CC 20 E8 82                  ..
        pla                                     ; 82CF 68                       h
        sec                                     ; 82D0 38                       8
        sbc     #$01                            ; 82D1 E9 01                    ..
        bpl     L82CB                           ; 82D3 10 F6                    ..
        dec     L8754                           ; 82D5 CE 54 87                 .T.
        lda     L8755                           ; 82D8 AD 55 87                 .U.
        and     #$03                            ; 82DB 29 03                    ).
L82DD:  pha                                     ; 82DD 48                       H
        jsr     render_campaign_location_ring   ; 82DE 20 E8 82                  ..
        pla                                     ; 82E1 68                       h
        sec                                     ; 82E2 38                       8
        sbc     #$01                            ; 82E3 E9 01                    ..
        bpl     L82DD                           ; 82E5 10 F6                    ..
        rts                                     ; 82E7 60                       `

; ----------------------------------------------------------------------------
; Compute and update the eight ring coordinates for one radius/phase
render_campaign_location_ring:
        sta     $73                             ; 82E8 85 73                    .s
        lda     #$07                            ; 82EA A9 07                    ..
L82EC:  pha                                     ; 82EC 48                       H
        tay                                     ; 82ED A8                       .
        ldx     $05                             ; 82EE A6 05                    ..
        lda     L8706,y                         ; 82F0 B9 06 87                 ...
        beq     L8300                           ; 82F3 F0 0B                    ..
        php                                     ; 82F5 08                       .
        lda     $73                             ; 82F6 A5 73                    .s
        plp                                     ; 82F8 28                       (
        bpl     L8300                           ; 82F9 10 05                    ..
        eor     #$FF                            ; 82FB 49 FF                    I.
        clc                                     ; 82FD 18                       .
        adc     #$01                            ; 82FE 69 01                    i.
L8300:  clc                                     ; 8300 18                       .
        adc     selector6_tables,x              ; 8301 7D F5 86                 }..
        sta     $01                             ; 8304 85 01                    ..
        lda     L870E,y                         ; 8306 B9 0E 87                 ...
        beq     L8316                           ; 8309 F0 0B                    ..
        php                                     ; 830B 08                       .
        lda     $73                             ; 830C A5 73                    .s
        plp                                     ; 830E 28                       (
        bpl     L8316                           ; 830F 10 05                    ..
        eor     #$FF                            ; 8311 49 FF                    I.
        clc                                     ; 8313 18                       .
        adc     #$01                            ; 8314 69 01                    i.
L8316:  clc                                     ; 8316 18                       .
        adc     L86FD,x                         ; 8317 7D FD 86                 }..
        sta     $02                             ; 831A 85 02                    ..
        lda     L8754                           ; 831C AD 54 87                 .T.
        beq     L8327                           ; 831F F0 06                    ..
        jsr     swap_campaign_dot_between_pages ; 8321 20 3E 83                  >.
        jmp     L832C                           ; 8324 4C 2C 83                 L,.

; ----------------------------------------------------------------------------
L8327:  lda     #$AA                            ; 8327 A9 AA                    ..
        jsr     L85CE                           ; 8329 20 CE 85                  ..
L832C:  pla                                     ; 832C 68                       h
        sec                                     ; 832D 38                       8
        sbc     #$01                            ; 832E E9 01                    ..
        bpl     L82EC                           ; 8330 10 BA                    ..
        ldy     #$10                            ; 8332 A0 10                    ..
        tya                                     ; 8334 98                       .
L8335:  sec                                     ; 8335 38                       8
        sbc     #$01                            ; 8336 E9 01                    ..
        bne     L8335                           ; 8338 D0 FB                    ..
        dey                                     ; 833A 88                       .
        bne     L8335                           ; 833B D0 F8                    ..
        rts                                     ; 833D 60                       `

; ----------------------------------------------------------------------------
; Move one eight-scanline dot column between the two HGR pages
swap_campaign_dot_between_pages:
        ldy     $02                             ; 833E A4 02                    ..
        lda     L8716,y                         ; 8340 B9 16 87                 ...
        sta     $70                             ; 8343 85 70                    .p
        lda     L872E,y                         ; 8345 B9 2E 87                 ...
        sta     $71                             ; 8348 85 71                    .q
        ldx     #$08                            ; 834A A2 08                    ..
        ldy     $01                             ; 834C A4 01                    ..
L834E:  lda     $71                             ; 834E A5 71                    .q
        and     #$1F                            ; 8350 29 1F                    ).
        ora     $00                             ; 8352 05 00                    ..
        pha                                     ; 8354 48                       H
        eor     #$60                            ; 8355 49 60                    I`
        sta     $71                             ; 8357 85 71                    .q
        lda     ($70),y                         ; 8359 B1 70                    .p
        sta     $72                             ; 835B 85 72                    .r
        pla                                     ; 835D 68                       h
        sta     $71                             ; 835E 85 71                    .q
        lda     $72                             ; 8360 A5 72                    .r
        sta     ($70),y                         ; 8362 91 70                    .p
        lda     $71                             ; 8364 A5 71                    .q
        clc                                     ; 8366 18                       .
        adc     #$04                            ; 8367 69 04                    i.
        sta     $71                             ; 8369 85 71                    .q
        dex                                     ; 836B CA                       .
        bne     L834E                           ; 836C D0 E0                    ..
        rts                                     ; 836E 60                       `

; ----------------------------------------------------------------------------
L836F:  sta     L8756                           ; 836F 8D 56 87                 .V.
        stx     L8757                           ; 8372 8E 57 87                 .W.
        sty     L8758                           ; 8375 8C 58 87                 .X.
        lda     L8759                           ; 8378 AD 59 87                 .Y.
        bmi     L8382                           ; 837B 30 05                    0.
        lda     #$FF                            ; 837D A9 FF                    ..
        sta     L8746                           ; 837F 8D 46 87                 .F.
L8382:  lda     L8746                           ; 8382 AD 46 87                 .F.
        bmi     L83A2                           ; 8385 30 1B                    0.
        lda     $01                             ; 8387 A5 01                    ..
        pha                                     ; 8389 48                       H
        lda     $02                             ; 838A A5 02                    ..
        pha                                     ; 838C 48                       H
        lda     L8746                           ; 838D AD 46 87                 .F.
        sta     $01                             ; 8390 85 01                    ..
        lda     L8747                           ; 8392 AD 47 87                 .G.
        sta     $02                             ; 8395 85 02                    ..
        lda     #$A0                            ; 8397 A9 A0                    ..
        jsr     L85C4                           ; 8399 20 C4 85                  ..
        pla                                     ; 839C 68                       h
        sta     $02                             ; 839D 85 02                    ..
        pla                                     ; 839F 68                       h
        sta     $01                             ; 83A0 85 01                    ..
L83A2:  lda     L8756                           ; 83A2 AD 56 87                 .V.
        cmp     #$C1                            ; 83A5 C9 C1                    ..
        bcc     L83BB                           ; 83A7 90 12                    ..
        cmp     #$DB                            ; 83A9 C9 DB                    ..
        bcc     L83B5                           ; 83AB 90 08                    ..
        cmp     #$E1                            ; 83AD C9 E1                    ..
        bcc     L83BB                           ; 83AF 90 0A                    ..
        cmp     #$FB                            ; 83B1 C9 FB                    ..
        bcs     L83BB                           ; 83B3 B0 06                    ..
L83B5:  jsr     L85C4                           ; 83B5 20 C4 85                  ..
        jmp     L83BE                           ; 83B8 4C BE 83                 L..

; ----------------------------------------------------------------------------
L83BB:  jsr     L85CE                           ; 83BB 20 CE 85                  ..
L83BE:  lda     L8759                           ; 83BE AD 59 87                 .Y.
        bpl     L83E4                           ; 83C1 10 21                    .!
        lda     #$7F                            ; 83C3 A9 7F                    ..
        sta     $03                             ; 83C5 85 03                    ..
        lda     $01                             ; 83C7 A5 01                    ..
        sta     L8746                           ; 83C9 8D 46 87                 .F.
        lda     $02                             ; 83CC A5 02                    ..
        sta     L8747                           ; 83CE 8D 47 87                 .G.
        lda     #$A0                            ; 83D1 A9 A0                    ..
        jsr     L85C4                           ; 83D3 20 C4 85                  ..
        lda     #$00                            ; 83D6 A9 00                    ..
        sta     $03                             ; 83D8 85 03                    ..
        lda     L8746                           ; 83DA AD 46 87                 .F.
        sta     $01                             ; 83DD 85 01                    ..
        lda     L8747                           ; 83DF AD 47 87                 .G.
        sta     $02                             ; 83E2 85 02                    ..
L83E4:  lda     L8756                           ; 83E4 AD 56 87                 .V.
        ldx     L8757                           ; 83E7 AE 57 87                 .W.
        ldy     L8758                           ; 83EA AC 58 87                 .X.
        rts                                     ; 83ED 60                       `

; ----------------------------------------------------------------------------
L83EE:  pha                                     ; 83EE 48                       H
        lda     #$0C                            ; 83EF A9 0C                    ..
        sta     $BFEB                           ; 83F1 8D EB BF                 ...
        lda     #$08                            ; 83F4 A9 08                    ..
        sta     $BFEA                           ; 83F6 8D EA BF                 ...
        lda     #$90                            ; 83F9 A9 90                    ..
        sta     $BFEC                           ; 83FB 8D EC BF                 ...
        lda     #$03                            ; 83FE A9 03                    ..
        sta     $BFED                           ; 8400 8D ED BF                 ...
        jsr     L82B5                           ; 8403 20 B5 82                  ..
        bit     $C010                           ; 8406 2C 10 C0                 ,..
        pla                                     ; 8409 68                       h
        asl     a                               ; 840A 0A                       .
        tay                                     ; 840B A8                       .
        lda     $8FFF,y                         ; 840C B9 FF 8F                 ...
        pha                                     ; 840F 48                       H
        lda     $9000,y                         ; 8410 B9 00 90                 ...
        clc                                     ; 8413 18                       .
        adc     #$11                            ; 8414 69 11                    i.
        pha                                     ; 8416 48                       H
        and     #$0F                            ; 8417 29 0F                    ).
        sta     $BFEB                           ; 8419 8D EB BF                 ...
        pla                                     ; 841C 68                       h
        lsr     a                               ; 841D 4A                       J
        lsr     a                               ; 841E 4A                       J
        lsr     a                               ; 841F 4A                       J
        lsr     a                               ; 8420 4A                       J
        clc                                     ; 8421 18                       .
        adc     #$08                            ; 8422 69 08                    i.
        sta     $BFEA                           ; 8424 8D EA BF                 ...
        lda     #$95                            ; 8427 A9 95                    ..
        sta     $BFEC                           ; 8429 8D EC BF                 ...
        lda     #$06                            ; 842C A9 06                    ..
L842E:  pha                                     ; 842E 48                       H
        jsr     L82B5                           ; 842F 20 B5 82                  ..
        dec     $BFEC                           ; 8432 CE EC BF                 ...
        lda     $BFEB                           ; 8435 AD EB BF                 ...
        bne     L8442                           ; 8438 D0 08                    ..
        dec     $BFEA                           ; 843A CE EA BF                 ...
        lda     #$10                            ; 843D A9 10                    ..
        sta     $BFEB                           ; 843F 8D EB BF                 ...
L8442:  dec     $BFEB                           ; 8442 CE EB BF                 ...
        pla                                     ; 8445 68                       h
        sec                                     ; 8446 38                       8
        sbc     #$01                            ; 8447 E9 01                    ..
        bne     L842E                           ; 8449 D0 E3                    ..
        lda     #$00                            ; 844B A9 00                    ..
        sta     $BFED                           ; 844D 8D ED BF                 ...
        jsr     L82B5                           ; 8450 20 B5 82                  ..
        jsr     L859E                           ; 8453 20 9E 85                  ..
        jsr     LD800                           ; 8456 20 00 D8                  ..
        jsr     L851C                           ; 8459 20 1C 85                  ..
        pla                                     ; 845C 68                       h
        sta     $70                             ; 845D 85 70                    .p
        lda     #$90                            ; 845F A9 90                    ..
        sta     $71                             ; 8461 85 71                    .q
L8463:  ldy     #$00                            ; 8463 A0 00                    ..
        lda     ($70),y                         ; 8465 B1 70                    .p
        beq     L848C                           ; 8467 F0 23                    .#
        sec                                     ; 8469 38                       8
        sbc     #$01                            ; 846A E9 01                    ..
        ldy     #$07                            ; 846C A0 07                    ..
        sty     L875D                           ; 846E 8C 5D 87                 .].
L8471:  pha                                     ; 8471 48                       H
        jsr     L8532                           ; 8472 20 32 85                  2.
        jsr     L8522                           ; 8475 20 22 85                  ".
        jsr     L85B1                           ; 8478 20 B1 85                  ..
        pla                                     ; 847B 68                       h
        bcs     L84AE                           ; 847C B0 30                    .0
        dec     L875D                           ; 847E CE 5D 87                 .].
        bne     L8471                           ; 8481 D0 EE                    ..
        inc     $70                             ; 8483 E6 70                    .p
        bne     L8463                           ; 8485 D0 DC                    ..
        inc     $71                             ; 8487 E6 71                    .q
        jmp     L8463                           ; 8489 4C 63 84                 Lc.

; ----------------------------------------------------------------------------
L848C:  lda     #$28                            ; 848C A9 28                    .(
L848E:  pha                                     ; 848E 48                       H
        ldy     #$07                            ; 848F A0 07                    ..
        sty     L875D                           ; 8491 8C 5D 87                 .].
L8494:  lda     #$A0                            ; 8494 A9 A0                    ..
        jsr     L8532                           ; 8496 20 32 85                  2.
        jsr     L8522                           ; 8499 20 22 85                  ".
        jsr     L85B1                           ; 849C 20 B1 85                  ..
        bcs     L84A6                           ; 849F B0 05                    ..
        dec     L875D                           ; 84A1 CE 5D 87                 .].
        bne     L8494                           ; 84A4 D0 EE                    ..
L84A6:  pla                                     ; 84A6 68                       h
        bcs     L84AE                           ; 84A7 B0 05                    ..
        sec                                     ; 84A9 38                       8
        sbc     #$01                            ; 84AA E9 01                    ..
        bne     L848E                           ; 84AC D0 E0                    ..
L84AE:  rts                                     ; 84AE 60                       `

; ----------------------------------------------------------------------------
L84AF:  lda     #$0A                            ; 84AF A9 0A                    ..
L84B1:  pha                                     ; 84B1 48                       H
        jsr     L84CB                           ; 84B2 20 CB 84                  ..
        lda     #$03                            ; 84B5 A9 03                    ..
L84B7:  ldy     #$1E                            ; 84B7 A0 1E                    ..
L84B9:  dex                                     ; 84B9 CA                       .
        bne     L84B9                           ; 84BA D0 FD                    ..
        dey                                     ; 84BC 88                       .
        bne     L84B9                           ; 84BD D0 FA                    ..
        sec                                     ; 84BF 38                       8
        sbc     #$01                            ; 84C0 E9 01                    ..
        bne     L84B7                           ; 84C2 D0 F3                    ..
        pla                                     ; 84C4 68                       h
        sec                                     ; 84C5 38                       8
        sbc     #$01                            ; 84C6 E9 01                    ..
        bne     L84B1                           ; 84C8 D0 E7                    ..
        rts                                     ; 84CA 60                       `

; ----------------------------------------------------------------------------
L84CB:  lda     #$D0                            ; 84CB A9 D0                    ..
        sta     $72                             ; 84CD 85 72                    .r
        sta     $74                             ; 84CF 85 74                    .t
        lda     #$03                            ; 84D1 A9 03                    ..
        ora     $00                             ; 84D3 05 00                    ..
        sta     $73                             ; 84D5 85 73                    .s
        eor     #$60                            ; 84D7 49 60                    I`
        sta     $75                             ; 84D9 85 75                    .u
        lda     $73                             ; 84DB A5 73                    .s
        clc                                     ; 84DD 18                       .
        adc     #$04                            ; 84DE 69 04                    i.
        sta     $73                             ; 84E0 85 73                    .s
        lda     #$07                            ; 84E2 A9 07                    ..
L84E4:  pha                                     ; 84E4 48                       H
        ldy     #$27                            ; 84E5 A0 27                    .'
L84E7:  lda     ($72),y                         ; 84E7 B1 72                    .r
        sta     ($74),y                         ; 84E9 91 74                    .t
        dey                                     ; 84EB 88                       .
        bpl     L84E7                           ; 84EC 10 F9                    ..
        lda     $73                             ; 84EE A5 73                    .s
        clc                                     ; 84F0 18                       .
        adc     #$04                            ; 84F1 69 04                    i.
        sta     $73                             ; 84F3 85 73                    .s
        lda     $75                             ; 84F5 A5 75                    .u
        adc     #$04                            ; 84F7 69 04                    i.
        sta     $75                             ; 84F9 85 75                    .u
        pla                                     ; 84FB 68                       h
        sec                                     ; 84FC 38                       8
        sbc     #$01                            ; 84FD E9 01                    ..
        bne     L84E4                           ; 84FF D0 E3                    ..
        ldy     #$27                            ; 8501 A0 27                    .'
L8503:  sta     ($74),y                         ; 8503 91 74                    .t
        dey                                     ; 8505 88                       .
        bpl     L8503                           ; 8506 10 FB                    ..
        jmp     L80B1                           ; 8508 4C B1 80                 L..

; ----------------------------------------------------------------------------
L850B:  lda     #$D0                            ; 850B A9 D0                    ..
        sta     $72                             ; 850D 85 72                    .r
        sta     $74                             ; 850F 85 74                    .t
        lda     #$03                            ; 8511 A9 03                    ..
        ora     $00                             ; 8513 05 00                    ..
        sta     $73                             ; 8515 85 73                    .s
        eor     #$60                            ; 8517 49 60                    I`
        sta     $75                             ; 8519 85 75                    .u
        rts                                     ; 851B 60                       `

; ----------------------------------------------------------------------------
L851C:  lda     #$00                            ; 851C A9 00                    ..
        sta     L875E                           ; 851E 8D 5E 87                 .^.
        rts                                     ; 8521 60                       `

; ----------------------------------------------------------------------------
L8522:  inc     L875E                           ; 8522 EE 5E 87                 .^.
        ldy     L875E                           ; 8525 AC 5E 87                 .^.
        cpy     #$07                            ; 8528 C0 07                    ..
        bne     L8531                           ; 852A D0 05                    ..
        ldy     #$00                            ; 852C A0 00                    ..
        sty     L875E                           ; 852E 8C 5E 87                 .^.
L8531:  rts                                     ; 8531 60                       `

; ----------------------------------------------------------------------------
L8532:  ldy     #$17                            ; 8532 A0 17                    ..
        sty     $02                             ; 8534 84 02                    ..
        ldy     #$27                            ; 8536 A0 27                    .'
        sty     $01                             ; 8538 84 01                    ..
        jsr     L836F                           ; 853A 20 6F 83                  o.
        ldy     L875E                           ; 853D AC 5E 87                 .^.
        lda     L874C,y                         ; 8540 B9 4C 87                 .L.
        sta     L875F                           ; 8543 8D 5F 87                 ._.
        jsr     L850B                           ; 8546 20 0B 85                  ..
        ldy     #$27                            ; 8549 A0 27                    .'
        ldx     #$08                            ; 854B A2 08                    ..
L854D:  lda     ($72),y                         ; 854D B1 72                    .r
        and     L875F                           ; 854F 2D 5F 87                 -_.
        beq     L8556                           ; 8552 F0 02                    ..
        lda     #$01                            ; 8554 A9 01                    ..
L8556:  sta     ($72),y                         ; 8556 91 72                    .r
        lda     $73                             ; 8558 A5 73                    .s
        clc                                     ; 855A 18                       .
        adc     #$04                            ; 855B 69 04                    i.
        sta     $73                             ; 855D 85 73                    .s
        dex                                     ; 855F CA                       .
        bne     L854D                           ; 8560 D0 EB                    ..
        jsr     L850B                           ; 8562 20 0B 85                  ..
        ldx     #$08                            ; 8565 A2 08                    ..
L8567:  ldy     #$27                            ; 8567 A0 27                    .'
        lda     ($72),y                         ; 8569 B1 72                    .r
        lsr     a                               ; 856B 4A                       J
        dey                                     ; 856C 88                       .
L856D:  php                                     ; 856D 08                       .
        lda     ($74),y                         ; 856E B1 74                    .t
        asl     a                               ; 8570 0A                       .
        plp                                     ; 8571 28                       (
        ror     a                               ; 8572 6A                       j
        lsr     a                               ; 8573 4A                       J
        sta     ($72),y                         ; 8574 91 72                    .r
        dey                                     ; 8576 88                       .
        bne     L856D                           ; 8577 D0 F4                    ..
        jsr     L858F                           ; 8579 20 8F 85                  ..
        dex                                     ; 857C CA                       .
        bne     L8567                           ; 857D D0 E8                    ..
        lda     #$17                            ; 857F A9 17                    ..
        sta     $02                             ; 8581 85 02                    ..
        lda     #$27                            ; 8583 A9 27                    .'
        sta     $01                             ; 8585 85 01                    ..
        lda     #$A0                            ; 8587 A9 A0                    ..
        jsr     L836F                           ; 8589 20 6F 83                  o.
        jmp     L80B1                           ; 858C 4C B1 80                 L..

; ----------------------------------------------------------------------------
L858F:  lda     $73                             ; 858F A5 73                    .s
        clc                                     ; 8591 18                       .
        adc     #$04                            ; 8592 69 04                    i.
        sta     $73                             ; 8594 85 73                    .s
        lda     $75                             ; 8596 A5 75                    .u
        clc                                     ; 8598 18                       .
        adc     #$04                            ; 8599 69 04                    i.
        sta     $75                             ; 859B 85 75                    .u
        rts                                     ; 859D 60                       `

; ----------------------------------------------------------------------------
L859E:  lda     #$00                            ; 859E A9 00                    ..
        sta     $01                             ; 85A0 85 01                    ..
        lda     #$17                            ; 85A2 A9 17                    ..
        sta     $02                             ; 85A4 85 02                    ..
        ldy     #$28                            ; 85A6 A0 28                    .(
        lda     #$A0                            ; 85A8 A9 A0                    ..
L85AA:  jsr     L836F                           ; 85AA 20 6F 83                  o.
        dey                                     ; 85AD 88                       .
        bne     L85AA                           ; 85AE D0 FA                    ..
        rts                                     ; 85B0 60                       `

; ----------------------------------------------------------------------------
L85B1:  lda     $C000                           ; 85B1 AD 00 C0                 ...
        bpl     L85C2                           ; 85B4 10 0C                    ..
        bit     $C010                           ; 85B6 2C 10 C0                 ,..
        cmp     #$9B                            ; 85B9 C9 9B                    ..
        bne     L85C2                           ; 85BB D0 05                    ..
        jsr     L84AF                           ; 85BD 20 AF 84                  ..
        sec                                     ; 85C0 38                       8
        rts                                     ; 85C1 60                       `

; ----------------------------------------------------------------------------
L85C2:  clc                                     ; 85C2 18                       .
        rts                                     ; 85C3 60                       `

; ----------------------------------------------------------------------------
L85C4:  pha                                     ; 85C4 48                       H
        lda     #$00                            ; 85C5 A9 00                    ..
        sta     $A000                           ; 85C7 8D 00 A0                 ...
        pla                                     ; 85CA 68                       h
        jmp     LA001                           ; 85CB 4C 01 A0                 L..

; ----------------------------------------------------------------------------
L85CE:  pha                                     ; 85CE 48                       H
        lda     #$02                            ; 85CF A9 02                    ..
        sta     $A000                           ; 85D1 8D 00 A0                 ...
        pla                                     ; 85D4 68                       h
        jmp     LA001                           ; 85D5 4C 01 A0                 L..

; ----------------------------------------------------------------------------
L85D8:  lda     $50                             ; 85D8 A5 50                    .P
        and     #$40                            ; 85DA 29 40                    )@
        bne     L85E6                           ; 85DC D0 08                    ..
        lda     #$00                            ; 85DE A9 00                    ..
        sta     L875B                           ; 85E0 8D 5B 87                 .[.
        sta     $59                             ; 85E3 85 59                    .Y
        rts                                     ; 85E5 60                       `

; ----------------------------------------------------------------------------
L85E6:  lda     #$04                            ; 85E6 A9 04                    ..
        sta     L875B                           ; 85E8 8D 5B 87                 .[.
        lda     #$03                            ; 85EB A9 03                    ..
        sta     $BFED                           ; 85ED 8D ED BF                 ...
        lda     #$07                            ; 85F0 A9 07                    ..
        sta     $BFEA                           ; 85F2 8D EA BF                 ...
        lda     #$03                            ; 85F5 A9 03                    ..
        sta     $BFEB                           ; 85F7 8D EB BF                 ...
        lda     #$7F                            ; 85FA A9 7F                    ..
        sta     $BFEC                           ; 85FC 8D EC BF                 ...
        lda     #$04                            ; 85FF A9 04                    ..
L8601:  pha                                     ; 8601 48                       H
        jsr     L82B5                           ; 8602 20 B5 82                  ..
        dec     $BFEC                           ; 8605 CE EC BF                 ...
        dec     $BFEB                           ; 8608 CE EB BF                 ...
        pla                                     ; 860B 68                       h
        sec                                     ; 860C 38                       8
        sbc     #$01                            ; 860D E9 01                    ..
        bne     L8601                           ; 860F D0 F0                    ..
        lda     #$0B                            ; 8611 A9 0B                    ..
        sta     $BFEB                           ; 8613 8D EB BF                 ...
        lda     #$AF                            ; 8616 A9 AF                    ..
        sta     $BFEC                           ; 8618 8D EC BF                 ...
        lda     #$04                            ; 861B A9 04                    ..
L861D:  pha                                     ; 861D 48                       H
        jsr     L82B5                           ; 861E 20 B5 82                  ..
        dec     $BFEC                           ; 8621 CE EC BF                 ...
        dec     $BFEB                           ; 8624 CE EB BF                 ...
        pla                                     ; 8627 68                       h
        sec                                     ; 8628 38                       8
        sbc     #$01                            ; 8629 E9 01                    ..
        bne     L861D                           ; 862B D0 F0                    ..
        lda     #$00                            ; 862D A9 00                    ..
        sta     $BFED                           ; 862F 8D ED BF                 ...
        jsr     L82B5                           ; 8632 20 B5 82                  ..
        jsr     L7C00                           ; 8635 20 00 7C                  .|
        lda     #$00                            ; 8638 A9 00                    ..
        sta     $5C                             ; 863A 85 5C                    .\
        lda     #$AC                            ; 863C A9 AC                    ..
        sta     $5D                             ; 863E 85 5D                    .]
        rts                                     ; 8640 60                       `

; ----------------------------------------------------------------------------
L8641:  lda     $00                             ; 8641 A5 00                    ..
        ora     #$07                            ; 8643 09 07                    ..
        sta     $BFEC                           ; 8645 8D EC BF                 ...
        sta     $71                             ; 8648 85 71                    .q
        and     #$F3                            ; 864A 29 F3                    ).
        sta     $73                             ; 864C 85 73                    .s
        lda     #$03                            ; 864E A9 03                    ..
        sta     $BFEB                           ; 8650 8D EB BF                 ...
        lda     #$15                            ; 8653 A9 15                    ..
        sta     $BFEA                           ; 8655 8D EA BF                 ...
L8658:  jsr     L82B0                           ; 8658 20 B0 82                  ..
        dec     $BFEC                           ; 865B CE EC BF                 ...
        dec     $BFEB                           ; 865E CE EB BF                 ...
        bpl     L8658                           ; 8661 10 F5                    ..
        lda     #$0B                            ; 8663 A9 0B                    ..
        sta     $BFEB                           ; 8665 8D EB BF                 ...
        lda     #$1E                            ; 8668 A9 1E                    ..
        sta     $BFEA                           ; 866A 8D EA BF                 ...
        lda     #$04                            ; 866D A9 04                    ..
L866F:  pha                                     ; 866F 48                       H
        jsr     L82B5                           ; 8670 20 B5 82                  ..
        dec     $BFEC                           ; 8673 CE EC BF                 ...
        dec     $BFEB                           ; 8676 CE EB BF                 ...
        pla                                     ; 8679 68                       h
        sec                                     ; 867A 38                       8
        sbc     #$01                            ; 867B E9 01                    ..
        bne     L866F                           ; 867D D0 F0                    ..
        ldy     #$00                            ; 867F A0 00                    ..
        sty     $70                             ; 8681 84 70                    .p
        sty     $72                             ; 8683 84 72                    .r
        ldx     #$04                            ; 8685 A2 04                    ..
L8687:  lda     #$72                            ; 8687 A9 72                    .r
        eor     ($70),y                         ; 8689 51 70                    Qp
        eor     ($72),y                         ; 868B 51 72                    Qr
        bne     L869A                           ; 868D D0 0B                    ..
        iny                                     ; 868F C8                       .
        bne     L8687                           ; 8690 D0 F5                    ..
        dec     $71                             ; 8692 C6 71                    .q
        dec     $73                             ; 8694 C6 73                    .s
        dex                                     ; 8696 CA                       .
        bne     L8687                           ; 8697 D0 EE                    ..
        rts                                     ; 8699 60                       `

; ----------------------------------------------------------------------------
L869A:  lda     a:$07                           ; 869A AD 07 00                 ...
        lda     #$80                            ; 869D A9 80                    ..
        ora     a:$07                           ; 869F 0D 07 00                 ...
        ldx     #$01                            ; 86A2 A2 01                    ..
        sta     a:$06,x                         ; 86A4 9D 06 00                 ...
L86A7:  rts                                     ; 86A7 60                       `

; ----------------------------------------------------------------------------
; Low bytes of eight stage-indexed city-record pointers
campaign_city_pointer_low:
        .byte   $B8,$C2,$C7,$D0,$D8,$DE,$E5     ; 86A8 B8 C2 C7 D0 D8 DE E5     .......
L86AF:  .byte   $EE                             ; 86AF EE                       .
; High bytes of eight stage-indexed city-record pointers
campaign_city_pointer_high:
        .byte   $86,$86,$86,$86,$86,$86,$86,$86 ; 86B0 86 86 86 86 86 86 86 86  ........
; Eight length-prefixed high-bit city names
campaign_city_records:
        .byte   $09,$C3,$E8,$E5,$F2,$E2,$EF,$F5 ; 86B8 09 C3 E8 E5 F2 E2 EF F5  ........
        .byte   $F2,$E7,$04,$C3,$E1,$E5,$EE,$08 ; 86C0 F2 E7 04 C3 E1 E5 EE 08  ........
        .byte   $D3,$E1,$E9,$EE,$F4,$AD,$CC,$C0 ; 86C8 D3 E1 E9 EE F4 AD CC C0  ........
        .byte   $07,$CF,$F2,$EC,$A3,$E1,$EE,$F3 ; 86D0 07 CF F2 EC A3 E1 EE F3  ........
        .byte   $05,$D0,$E1,$F2,$E9,$F3,$06,$D6 ; 86D8 05 D0 E1 F2 E9 F3 06 D6  ........
        .byte   $E5,$F2,$E4,$F5,$EE,$08,$C2,$F2 ; 86E0 E5 F2 E4 F5 EE 08 C2 F2  ........
        .byte   $F5,$F3,$F3,$E5,$EC,$F3,$07,$C1 ; 86E8 F5 F3 F3 E5 EC F3 07 C1  ........
        .byte   $EE,$F4,$F7,$E5                 ; 86F0 EE F4 F7 E5              ....
L86F4:  .byte   $F2                             ; 86F4 F2                       .
; Consumer-backed tables and initialized workspace
selector6_tables:
        .byte   $F0,$0B,$0E,$0C,$10,$12,$15     ; 86F5 F0 0B 0E 0C 10 12 15     .......
L86FC:  .byte   $15                             ; 86FC 15                       .
L86FD:  .byte   $13,$0D,$0E,$0F,$11,$10,$10,$0D ; 86FD 13 0D 0E 0F 11 10 10 0D  ........
        .byte   $0C                             ; 8705 0C                       .
L8706:  .byte   $00,$01,$01,$01,$00,$FF,$FF,$FF ; 8706 00 01 01 01 00 FF FF FF  ........
L870E:  .byte   $FF,$FF,$00,$01,$01,$01,$00,$FF ; 870E FF FF 00 01 01 01 00 FF  ........
L8716:  .byte   $00,$80,$00,$80,$00,$80,$00,$80 ; 8716 00 80 00 80 00 80 00 80  ........
        .byte   $28,$A8,$28,$A8,$28,$A8,$28,$A8 ; 871E 28 A8 28 A8 28 A8 28 A8  (.(.(.(.
        .byte   $50,$D0,$50,$D0,$50,$D0,$50,$D0 ; 8726 50 D0 50 D0 50 D0 50 D0  P.P.P.P.
L872E:  .byte   $00,$00,$01,$01,$02,$02,$03,$03 ; 872E 00 00 01 01 02 02 03 03  ........
        .byte   $00,$00,$01,$01,$02,$02,$03,$03 ; 8736 00 00 01 01 02 02 03 03  ........
        .byte   $00,$00,$01,$01,$02,$02,$03,$03 ; 873E 00 00 01 01 02 02 03 03  ........
L8746:  .byte   $FF                             ; 8746 FF                       .
L8747:  .byte   $FF,$0A,$FF,$09,$0B             ; 8747 FF 0A FF 09 0B           .....
L874C:  .byte   $01,$02,$04,$08,$10,$20,$40     ; 874C 01 02 04 08 10 20 40     ..... @
; Mutable initialized bytes
selector6_workspace:
        .byte   $00                             ; 8753 00                       .
L8754:  .byte   $00                             ; 8754 00                       .
L8755:  .byte   $00                             ; 8755 00                       .
L8756:  .byte   $00                             ; 8756 00                       .
L8757:  .byte   $00                             ; 8757 00                       .
L8758:  .byte   $00                             ; 8758 00                       .
L8759:  .byte   $00                             ; 8759 00                       .
L875A:  .byte   $00                             ; 875A 00                       .
L875B:  .byte   $00,$00                         ; 875B 00 00                    ..
L875D:  .byte   $00                             ; 875D 00                       .
L875E:  .byte   $00                             ; 875E 00                       .
L875F:  .byte   $00                             ; 875F 00                       .
; Tokenized/source-text fragment, not runtime code
embedded_source_tail:
        .byte   $30,$30,$2C,$59,$0D,$09,$D0,$05 ; 8760 30 30 2C 59 0D 09 D0 05  00,Y....
        .byte   $28,$54,$30,$29,$2C,$59,$0D,$03 ; 8768 28 54 30 29 2C 59 0D 03  (T0),Y..
        .byte   $9F,$00,$0D,$05,$86,$01,$3C,$31 ; 8770 9F 00 0D 05 86 01 3C 31  ......<1
        .byte   $0D,$05,$C9,$01,$54,$31,$0D,$03 ; 8778 0D 05 C9 01 54 31 0D 03  ....T1..
        .byte   $9C,$00,$0D,$05,$86,$01,$3C,$31 ; 8780 9C 00 0D 05 86 01 3C 31  ......<1
        .byte   $0D,$0A,$CD,$02,$2F,$24,$31,$30 ; 8788 0D 0A CD 02 2F 24 31 30  ..../$10
        .byte   $30,$2D,$31,$0D,$03,$A1,$00,$0D ; 8790 30 2D 31 0D 03 A1 00 0D  0-1.....
        .byte   $0A,$CD,$02,$23,$24,$31,$30,$30 ; 8798 0A CD 02 23 24 31 30 30  ...#$100
        .byte   $2D,$31,$0D,$03,$A1,$00,$0D,$03 ; 87A0 2D 31 0D 03 A1 00 0D 03  -1......
        .byte   $A5,$00,$0D,$0B,$5E,$39,$20,$20 ; 87A8 A5 00 0D 0B 5E 39 20 20  ....^9  
        .byte   $20,$20,$20,$20,$A5,$00,$0D,$02 ; 87B0 20 20 20 20 A5 00 0D 02      ....
        .byte   $3B,$0D,$11,$55,$50,$44,$54,$4C ; 87B8 3B 0D 11 55 50 44 54 4C  ;..UPDTL
        .byte   $4B,$20,$20,$CF,$01,$54,$4C,$4B ; 87C0 4B 20 20 CF 01 54 4C 4B  K  ..TLK
        .byte   $4E,$55,$4D,$0D,$05,$87,$01,$3E ; 87C8 4E 55 4D 0D 05 87 01 3E  NUM....>
        .byte   $39,$0D,$09,$CE,$01,$54,$4C,$4B ; 87D0 39 0D 09 CE 01 54 4C 4B  9....TLK
        .byte   $46,$4C,$47,$0D,$05,$86,$01,$3E ; 87D8 46 4C 47 0D 05 86 01 3E  FLG....>
        .byte   $39,$0D,$0D,$CD,$07,$54,$4C,$4B ; 87E0 39 0D 0D CD 07 54 4C 4B  9....TLK
        .byte   $54,$41,$42,$2D,$31,$2C,$59,$0D ; 87E8 54 41 42 2D 31 2C 59 0D  TAB-1,Y.
        .byte   $05,$85,$01,$3E,$31,$0D,$08,$CD ; 87F0 05 85 01 3E 31 0D 08 CD  ...>1...
        .byte   $01,$4C,$45,$56,$45,$4C,$0D,$11 ; 87F8 01 4C 45 56 45 4C 0D 11  .LEVEL..
