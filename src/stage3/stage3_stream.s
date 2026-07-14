; Rescue Raiders source-exact stage-3 selector stream loader and dispatcher.
.setcpu "6502"
.segment "STAGE3"

IOB       = $bfe8
IOB_TRK   = IOB+2
IOB_SEC   = IOB+3
IOB_BUFP  = IOB+4
IOB_CMD   = IOB+5
RWTS0     = $bb00

stream_ptr           = $70
opcode_handler_table = $4222
selector_stream_table = $422e

stage3_start:
stage3_entry:
    sei
    pha
    lda #$03
    sta IOB_SEC
    lda #$43
    sta IOB_BUFP
load_stage3_tail:
    jsr call_rwts0
    dec IOB_BUFP
    dec IOB_SEC
    bne load_stage3_tail

    ; A is the selector preserved by INTER. Each table entry is a stream
    ; pointer; stream opcode zero terminates interpretation.
    pla
    asl
    tax
    lda selector_stream_table,x
    sta stream_ptr
    lda selector_stream_table+1,x
    sta stream_ptr+1
interpret_next:
    jsr read_stream_byte
    asl
    beq interpreter_done
    tax
    lda opcode_handler_table,x
    sta handler_call_operand
    lda opcode_handler_table+1,x
    sta handler_call_operand+1
handler_call:
    .byte $20
handler_call_operand:
    .word $1234
    jmp interpret_next

interpreter_done:
    lda #$0b
    sta IOB_TRK
    lda #$02
    sta IOB_CMD
    jsr call_rwts0
    lda #$00
    sta IOB_CMD
    jsr call_rwts0
    jsr read_stream_byte
    sta final_jump_operand
    jsr read_stream_byte
    sta final_jump_operand+1
    ora final_jump_operand
    beq clear_and_return
    jsr clear_loaded_pages
final_jump:
    .byte $4c
final_jump_operand:
    .word $1234
clear_and_return:
    jmp clear_loaded_pages

call_rwts0:
    ldx #<IOB
    ldy #>IOB
    jmp RWTS0

promoted_stream_end:
.assert promoted_stream_end - stage3_start = $0073, error, "stage-3 interpreter size drift"

; Opcode 1: enable the language-card RAM write path, test $D000/$E000/$F000
; with ones and zeroes, and write the detected configuration marker.
handler_probe_ram:
    lda $c083
    lda $c083
    ldx #$01
    stx $04
    stx $d000
    stx $e000
    stx $f000
    lda $d000
    and $e000
    and $f000
    beq probe_ram_result
    dex
    stx $d000
    stx $e000
    stx $f000
    lda $d000
    ora $e000
    ora $f000
    bne probe_ram_result
    dec $04
probe_ram_result:
    ldx $04
    lda ram_marker_0,x
    sta $07d0
    lda ram_marker_1,x
    sta $07d1
    lda #$cb
    sta $07d2
    rts

; Compare a four-byte signature at two $C1xx/$C2xx slot-ROM candidates and
; accumulate the matching slot flags in $07.
detect_slot_roms:
    lda #$00
    sta $07
    sta $74
    lda #$c1
    jsr detect_slot_rom
    lda #$c2
detect_slot_rom:
    sta $75
    ldx #$03
detect_slot_compare:
    ldy slot_signature_offsets,x
    lda slot_signature_bytes,x
    cmp ($74),y
    bne detect_slot_done
    dex
    bpl detect_slot_compare
    lda $75
    and #$03
    tay
    ora #$b0
    sta $07d9,y
    lda #$d0
    sta $07d7
    lda #$d2
    sta $07d8
    lda #$d4
    sta $07d9
    tya
    ora #$80
    ora $07
    sta $07
detect_slot_done:
    rts

; Opcode 2: reset stream-loader scratch state.
handler_init_state:
    ldy #$00
    sty $5e
    sty $50
    lda #$c0
    sta $73
    rts

    .byte $04                  ; Unreferenced byte preceding support entry.
scan_memory_pages:
    sta $72
scan_memory_page:
    sec
    ldy #$00
    lda ($72),y
    sbc ($72),y
    cmp #$05
    bne scan_memory_next
    ldy #$80
    lda ($72),y
    sbc ($72),y
    cmp #$05
    bne scan_memory_next
    lda #$c0
    sta $50
    lda #$00
    sta $5e
    lda $73
    sta $5f
    lda #$cd
    sta $07d3
    lda #$c3
    sta $07d4
    lda #$cb
    sta $07d5
    lda $73
    and #$0f
    ora #$b0
    sta $07d6
    bmi scan_memory_done
scan_memory_next:
    dec $73
    lda $73
    cmp #$c0
    bne scan_memory_page
scan_memory_done:
    rts

read_stream_byte:
    ldy #$00
    lda (stream_ptr),y
    inc stream_ptr
    bne read_stream_done
    inc stream_ptr+1
read_stream_done:
    rts

; Opcode 3: consume track, sector, buffer page, and page count, then load the
; requested descending disk span through RWTS0.
handler_load_pages:
    jsr read_stream_byte
    sta IOB_TRK
    jsr read_stream_byte
    sta IOB_SEC
    jsr read_stream_byte
    sta IOB_BUFP
    lda #$03
    sta IOB_CMD
    jsr read_stream_byte
load_pages_next:
    pha
    jsr call_rwts0
    dec IOB_BUFP
    lda IOB_SEC
    bne load_pages_sector_ready
    dec IOB_TRK
    lda #$10
    sta IOB_SEC
load_pages_sector_ready:
    dec IOB_SEC
    pla
    sec
    sbc #$01
    bne load_pages_next
    rts

; Clear 32 pages in two interleaved eight-byte strips. The high bytes of both
; STA operands are incremented in place after each page.
clear_loaded_pages:
    lda #$40
    sta clear_store_0+2
    sta clear_store_1+2
    ldx #$20
    lda #$00
clear_page:
    ldy #$07
clear_strip:
clear_store_0:
    sta $4078,y
clear_store_1:
    sta $40f8,y
    dey
    bpl clear_strip
    inc clear_store_0+2
    inc clear_store_1+2
    dex
    bne clear_page
    rts

; Opcode 4: save text-page bytes, build a page-one trampoline, copy source
; pages through self-modified absolute-indexed operands, then optionally enter
; the trampoline when the RAM probe succeeded.
handler_build_trampoline:
    ldy #$7f
save_text_page:
    lda $0400,y
    sta $80,y
    dey
    bpl save_text_page
copy_source_page:
    lda #$00
copy_source_page_operand = *-1
    lsr
    pha
    lda #$f0
    ror
    sta copy_dest+1
    pla
    ora #$20
    sta copy_dest+2
    ldy #$07
copy_source:
    lda $4400,y
copy_source_operand = *-2
copy_dest:
    sta $1234,y
    dey
    bpl copy_source
    lda copy_source+1
    clc
    adc #$08
    sta copy_source+1
    bcc copy_source_advanced
    inc copy_source+2
copy_source_advanced:
    inc copy_source_page_operand
    lda copy_source_page_operand
    cmp #$40
    bne copy_source_page
    ldy #$28
copy_trampoline:
    lda $0480,y
    sta $0100,y
    dey
    bpl copy_trampoline
    lda #$00
    sta $03f2
    lda #$01
    sta $03f3
    eor #$a5
    sta $03f4
    lda $04
    beq build_trampoline_done
    jmp $0100
build_trampoline_done:
    rts

; Opcode 5: skip the following five-byte descriptor unless its leading value
; matches the RAM configuration flag.
handler_conditional_skip:
    jsr read_stream_byte
    cmp $04
    beq conditional_skip_done
    lda stream_ptr
    clc
    adc #$05
    sta stream_ptr
    bcc conditional_skip_done
    inc stream_ptr+1
conditional_skip_done:
    rts

handlers_end:
.assert handler_probe_ram - stage3_start = $0073, error, "handler 1 origin drift"
.assert handler_init_state - stage3_start = $00fb, error, "handler 2 origin drift"
.assert handler_load_pages - stage3_start = $0158, error, "handler 3 origin drift"
.assert handler_build_trampoline - stage3_start = $01b1, error, "handler 4 origin drift"
.assert handler_conditional_skip - stage3_start = $0211, error, "handler 5 origin drift"
.assert handlers_end - stage3_start = $0224, error, "stage-3 handler boundary drift"

opcode_handlers:
    .word handler_probe_ram
    .word handler_init_state
    .word handler_load_pages
    .word handler_build_trampoline
    .word handler_conditional_skip

selector_streams:
    .word selector0_stream
    .word selector1_stream
    .word selector2_stream
    .word selector3_stream
    .word selector4_stream
    .word selector5_stream
    .word selector6_stream

selector0_stream:
    .byte $01,$02,$03,$14,$0f,$ff,$30,$03,$11,$0f,$45,$02,$03,$0b,$00,$04
    .byte $01,$04,$03,$1d,$07,$1f,$18,$03,$11,$0d,$7a,$03,$03,$0b,$0c,$67
    .byte $08,$00,$00,$60
selector1_stream:
    .byte $03,$11,$0f,$45,$02,$03,$0b,$00,$04,$01,$04,$03,$0b,$04,$03,$02
    .byte $03,$0b,$02,$06,$02,$03,$0c,$09,$69,$01,$03,$21,$01,$18,$12,$03
    .byte $00,$0f,$04,$01,$00,$00,$69
selector2_stream:
    .byte $03,$1e,$03,$83,$04,$00,$00,$80
selector3_stream:
    .byte $03,$1f,$06,$86,$07,$03,$12,$03,$a4,$04,$03,$0b,$0d,$a0,$01,$03
    .byte $07,$0f,$9f,$04,$03,$07,$03,$7f,$04,$00,$00,$80
selector4_stream:
    .byte $03,$21,$0f,$87,$08,$03,$12,$03,$a4,$04,$03,$0b,$0d,$a0,$01,$00
    .byte $00,$80
selector5_stream:
    .byte $03,$11,$0a,$ba,$52,$00,$00,$00
selector6_stream:
    .byte $03,$15,$0f,$87,$08,$03,$12,$03,$a4,$04,$03,$11,$0d,$7a,$03,$03
    .byte $0b,$0d,$a0,$01,$00,$00,$80

stream_data_end:
.assert opcode_handlers - stage3_start = $0224, error, "handler table origin drift"
.assert selector_streams - stage3_start = $022e, error, "selector table origin drift"
.assert selector0_stream - stage3_start = $023c, error, "selector-0 stream origin drift"
.assert selector1_stream - stage3_start = $0260, error, "selector-1 stream origin drift"
.assert selector2_stream - stage3_start = $0287, error, "selector-2 stream origin drift"
.assert selector3_stream - stage3_start = $028f, error, "selector-3 stream origin drift"
.assert selector4_stream - stage3_start = $02ab, error, "selector-4 stream origin drift"
.assert selector5_stream - stage3_start = $02bd, error, "selector-5 stream origin drift"
.assert selector6_stream - stage3_start = $02c5, error, "selector-6 stream origin drift"
.assert stream_data_end - stage3_start = $02dc, error, "stream data boundary drift"

ram_marker_0:
    .byte $b6,$b4
ram_marker_1:
    .byte $b4,$b8
slot_signature_bytes:
    .byte $38,$18,$01,$31
slot_signature_offsets:
    .byte $05,$07,$0b,$0c

; No recovered stage-3 control-flow or data reference enters this area. The
; interpreter later clears $4000-$5FFF, so preserve its initial disk content as
; residual workspace data without assigning opcode semantics.
residual_workspace_initial:
    .byte $e8,$2c,$2d,$2e,$2f,$30,$31,$32,$f0,$f1,$33,$34,$35,$36,$37,$38
    .byte $f8,$39,$3a,$3b,$3c,$3d,$3e,$3f
    .byte $b1,$3a,$20,$56,$f9,$85,$3a,$98,$38,$b0,$a2,$20,$4a,$ff,$38,$b0
    .byte $9e,$ea,$ea,$4c,$0b,$fb,$4c,$fd,$fa,$c1,$d8,$d9,$d0,$d3,$ad,$70
    .byte $c0,$a0,$00,$ea,$ea,$bd,$64,$c0,$10,$04,$c8,$d0,$f8,$88,$60,$a9
    .byte $00,$85,$48,$ad,$56,$c0,$ad,$54,$c0,$ad,$51,$c0,$a9,$00,$f0,$0b
    .byte $ad,$50,$c0,$ad,$53,$c0,$20,$36,$f8,$a9,$14,$85,$22,$a9,$00,$85
    .byte $20,$a9,$28,$85,$21,$a9,$18,$85,$23,$a9,$17,$85,$25,$4c,$22,$fc
    .byte $20,$a4,$fb,$a0,$10,$a5,$50,$4a,$90,$0c,$18,$a2,$fe,$b5,$54,$75
    .byte $56,$95,$54,$e8,$d0,$f7,$a2,$03,$76,$50,$ca,$10,$fb,$88,$d0,$e5
    .byte $60,$20,$a4,$fb,$a0,$10,$06,$50,$26,$51,$26,$52,$26,$53,$38,$a5
    .byte $52,$e5,$54,$aa,$a5,$53,$e5,$55,$90,$06,$86,$52,$85,$53,$e6,$50
    .byte $88,$d0,$e3,$60,$a0,$00,$84,$2f,$a2,$54,$20,$af,$fb,$a2,$50,$b5
    .byte $01,$10,$0d,$38,$98,$f5,$00,$95,$00,$98,$f5,$01,$95,$01,$e6,$2f
    .byte $60,$48,$4a,$29,$03,$09,$04,$85,$29,$68,$29,$18,$90,$02,$69,$7f
    .byte $85,$28,$0a,$0a,$05,$28,$85,$28,$60,$c9,$87,$d0,$12,$a9,$40,$20
    .byte $a8,$fc,$a0,$c0,$a9,$0c,$20,$a8,$fc,$ad,$30,$c0,$88,$d0,$f5,$60
    .byte $a4,$24,$91,$28,$e6,$24,$a5,$24,$c5,$21,$b0,$66,$60,$c9,$a0,$b0

stage3_data_end:
.assert ram_marker_0 - stage3_start = $02dc, error, "RAM marker origin drift"
.assert slot_signature_bytes - stage3_start = $02e0, error, "signature origin drift"
.assert residual_workspace_initial - stage3_start = $02e8, error, "residual workspace origin drift"
.assert stage3_data_end - stage3_start = $0400, error, "stage-3 data boundary drift"

stage3_end:
.assert stage3_end - stage3_start = $0400, error, "stage-3 image must be 1024 bytes"
