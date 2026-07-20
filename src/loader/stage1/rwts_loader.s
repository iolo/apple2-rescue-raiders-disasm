; Rescue Raiders stage-1 loader, reconstructed at its runtime address.
;
; The relocated boot page ($BA00-$BAFF) shares the source-exact boot-page
; emitter. The Disk II codec and seek path, high-level RWTS-style dispatcher,
; work buffers and tables, delay utility, INTER/IOB interface, and residual
; sector tail are all bounded ca65 source/data.
.setcpu "6502"
.segment "STAGE1"

iob_ptr       = $4d
rwts_buffer   = $46
disk_slot     = $44
disk_phase    = $40
disk_seek     = $41
disk_delta    = $42
disk_saved    = $43
found_sector  = $4a
found_track   = $4b
found_volume  = $4c

disk_motor_off = $c088
disk_motor_on  = $c089
disk_q6l       = $c08c
disk_q6h       = $c08d
disk_q7l       = $c08e
disk_q7h       = $c08f
disk_phase_switch = $c080
six_and_two_aux  = $be00
six_and_two_aux1 = $beff
six_and_two_main = $bf00
read_translate   = $bd00

stage1_start:
    .include "../boot/boot_page.inc"
    emit_rescue_raiders_boot_page

; Embedded tokenized source names this entry RWTS0. It is the public jump
; into the high-level dispatcher reconstructed below.
RWTS0:
    jmp rwts_dispatch

; Convert the 256-byte sector at (rwts_buffer) into the DOS 3.3 6-and-2
; intermediate buffers consumed by write_sector_data.
encode_6_and_2:
    ldx #$00
    ldy #$02
encode_6_and_2_byte:
    dey
    lda (rwts_buffer),y
    lsr
    rol six_and_two_main,x
    lsr
    rol six_and_two_main,x
    sta six_and_two_aux,y
    inx
    cpx #$56
    bcc encode_6_and_2_byte
    ldx #$00
    tya
    bne encode_6_and_2_byte
    ldx #$55
encode_6_and_2_mask:
    lda six_and_two_main,x
    and #$3f
    sta six_and_two_main,x
    dex
    bpl encode_6_and_2_mask
    rts

; Emit a DOS 3.3 data field. X is the slot soft-switch offset and the
; encoded sector is held in the $BE00/$BF00 work buffers.
write_sector_data:
    sec
    stx disk_saved
    stx a:disk_slot
    lda disk_q6h,x
    lda disk_q7l,x
    bmi write_sector_done
    lda six_and_two_main
    sta disk_delta
    lda #$ff
    sta disk_q7h,x
    ora disk_q6l,x
    pha
    pla
    nop
    ldy #$05
write_sync_delay:
    pha
    pla
    jsr write_nibble
    dey
    bne write_sync_delay
    lda #$d5
    jsr write_nibble_clc
    lda #$aa
    jsr write_nibble_clc
    lda #$ad
    jsr write_nibble_clc
    tya
    ldy #$56
    bne write_main_byte
write_main_next:
    lda six_and_two_main,y
write_main_byte:
    eor six_and_two_aux1,y
    tax
    lda write_translate,x
    ldx disk_saved
    sta disk_q6h,x
    lda disk_q6l,x
    dey
    bne write_main_next
    lda disk_delta
    nop
write_aux_next:
    eor six_and_two_aux,y
    tax
    lda write_translate,x
    ldx a:disk_slot
    sta disk_q6h,x
    lda disk_q6l,x
    lda six_and_two_aux,y
    iny
    bne write_aux_next
    tax
    lda write_translate,x
    ldx disk_saved
    jsr write_nibble_now
    lda #$de
    jsr write_nibble_clc
    lda #$aa
    jsr write_nibble_clc
    lda #$eb
    jsr write_nibble_clc
    lda #$ff
    jsr write_nibble_clc
    lda disk_q7l,x
write_sector_done:
    lda disk_q6l,x
    rts

; CLC is a second entry point: callers use it before the prologue/epilogue
; bytes, while the sync loop enters with the existing carry state.
write_nibble_clc:
    clc
write_nibble:
    pha
    pla
write_nibble_now:
    sta disk_q6h,x
    ora disk_q6l,x
    rts

low_level_write_end:
.assert RWTS0 - stage1_start = $0100, error, "RWTS0 origin drift"
.assert low_level_write_end - RWTS0 = $00c5, error, "write path size drift"

; Recombine the two low bits in the auxiliary buffer with the six-bit values
; in the main buffer, writing the decoded 256-byte sector to (rwts_buffer).
decode_6_and_2:
    ldy #$00
decode_6_and_2_reset:
    ldx #$56
decode_6_and_2_byte:
    dex
    bmi decode_6_and_2_reset
    lda six_and_two_aux,y
    lsr six_and_two_main,x
    rol
    lsr six_and_two_main,x
    rol
    sta (rwts_buffer),y
    iny
    bne decode_6_and_2_byte
    rts

; Read and reverse-translate a DOS 3.3 data field into the two work buffers.
; Carry clear reports a valid checksum and DE AA epilogue; carry set reports
; timeout or malformed data.
read_sector_data:
    ldy #$20
read_data_retry:
    dey
    beq disk_read_error
read_data_nibble:
    lda disk_q6l,x
    bpl read_data_nibble
read_data_d5:
    eor #$d5
    bne read_data_retry
read_data_aa:
    lda disk_q6l,x
    bpl read_data_aa
    cmp #$aa
    bne read_data_d5
    ldy #$56
read_data_ad:
    lda disk_q6l,x
    bpl read_data_ad
    cmp #$ad
    bne read_data_d5
    lda #$00
read_main_next:
    dey
    sty disk_delta
read_main_nibble:
    ldy disk_q6l,x
    bpl read_main_nibble
    eor read_translate,y
    ldy disk_delta
    sta six_and_two_main,y
    bne read_main_next
read_aux_next:
    sty disk_delta
read_aux_nibble:
    ldy disk_q6l,x
    bpl read_aux_nibble
    eor read_translate,y
    ldy disk_delta
    sta six_and_two_aux,y
    iny
    bne read_aux_next
read_checksum_nibble:
    ldy disk_q6l,x
    bpl read_checksum_nibble
    cmp read_translate,y
    bne disk_read_error
read_data_de:
    lda disk_q6l,x
    bpl read_data_de
    cmp #$de
    bne disk_read_error
read_data_epilogue_aa:
    lda disk_q6l,x
    bpl read_data_epilogue_aa
    cmp #$aa
    beq disk_read_success
disk_read_error:
    sec
    rts

; Scan and decode a DOS 3.3 D5 AA 96 address field. The four 4-and-4
; values land at checksum/sector/track/volume ($49-$4C).
read_address_field:
    ldy #$fc
    sty disk_delta
read_address_retry:
    iny
    bne read_address_nibble
    inc disk_delta
    beq disk_read_error
read_address_nibble:
    lda disk_q6l,x
    bpl read_address_nibble
read_address_d5:
    cmp #$d5
    bne read_address_retry
read_address_aa:
    lda disk_q6l,x
    bpl read_address_aa
    cmp #$aa
    bne read_address_d5
    ldy #$03
read_address_96:
    lda disk_q6l,x
    bpl read_address_96
    cmp #$96
    bne read_address_d5
    lda #$00
read_address_pair:
    sta disk_saved
read_address_odd:
    lda disk_q6l,x
    bpl read_address_odd
    rol
    sta disk_delta
read_address_even:
    lda disk_q6l,x
    bpl read_address_even
    and disk_delta
    sta $49,y
    eor disk_saved
    dey
    bpl read_address_pair
    tay
    bne disk_read_error
read_address_de:
    lda disk_q6l,x
    bpl read_address_de
    cmp #$de
    bne disk_read_error
read_address_epilogue_aa:
    lda disk_q6l,x
    bpl read_address_epilogue_aa
    cmp #$aa
    bne disk_read_error
disk_read_success:
    clc
    rts

; Move the Disk II head to A (half-track units), using the two phase-delay
; tables and the shared motor delay routine copied later in the stage.
seek_track:
    sta $48
    cmp disk_seek
    beq seek_done
    lda disk_phase
    bne seek_initialized
    ldy #$10
seek_motor_delay:
    jsr disk_delay
    dey
    bne seek_motor_delay
seek_initialized:
    lda #$00
    sta disk_delta
seek_step:
    lda disk_seek
    sta disk_saved
    sec
    sbc $48
    beq seek_settle
    bcs seek_outward
    eor #$ff
    inc disk_seek
    bcc seek_distance
seek_outward:
    adc #$fe
    dec disk_seek
seek_distance:
    cmp disk_delta
    bcc seek_distance_ready
    lda disk_delta
seek_distance_ready:
    cmp #$08
    bcs seek_phase_on
    tay
seek_phase_on:
    sec
    jsr select_current_phase
    lda seek_delay_in,y
    jsr disk_delay
    lda disk_saved
    clc
    jsr select_phase
    lda seek_delay_out,y
    jsr disk_delay
    inc disk_delta
    bne seek_step
seek_settle:
    jsr disk_delay
    clc
select_current_phase:
    lda disk_seek
select_phase:
    and #$03
    rol
    ora disk_slot
    tax
    lda disk_phase_switch,x
    ldx disk_slot
seek_done:
    rts

low_level_codec_end:
.assert decode_6_and_2 - stage1_start = $01c5, error, "decoder origin drift"
.assert read_sector_data - stage1_start = $01dd, error, "data reader origin drift"
.assert read_address_field - stage1_start = $0243, error, "address reader origin drift"
.assert seek_track - stage1_start = $029d, error, "seek origin drift"
.assert low_level_codec_end - stage1_start = $02ff, error, "codec size drift"

; Entry receives X/Y = address of the eight-byte I/O block.
rwts_dispatch:
    stx iob_ptr
    sty iob_ptr+1
    php
    sei
    ldy #$01
    lda (iob_ptr),y
    sta disk_slot
    tax
    lda disk_q7l,x
    lda disk_q6l,x
    ldy #$05
    lda (iob_ptr),y
    bne rwts_command
    lda disk_motor_off,x
    lda #$ff
    sta disk_phase
rwts_success:
    clc
    lda #$00
    ; This branch intentionally targets the operand byte of the later
    ; read-retry branch. Entering at that byte decodes the overlapping
    ; error path beginning with SBC $07A0,Y.
    .byte $b0
rwts_error_operand:
    .byte $38                  ; BCS rwts_retry_operand displacement.
rwts_finish:
    ldy #$06
    sta (iob_ptr),y
    inc disk_phase
    rol disk_delta
    plp
    lsr disk_delta
    rts

rwts_command:
    ldy disk_motor_on,x
    cmp #$02
    bcc rwts_success
    php
    pha
    ldy #$02
    lda (iob_ptr),y
    asl
    jsr seek_track
    pla
    plp
    beq rwts_success
    lsr
    php
    ldy #$04
    lda (iob_ptr),y
    sta $47
    lda #$00
    sta $46
    bcs rwts_buffer_ready
    jsr encode_6_and_2
rwts_buffer_ready:
    ldx disk_slot
rwts_read_retry:
    jsr read_address_field
    .byte $b0                  ; BCS rwts_read_retry in the linear path.
rwts_retry_operand:
    .byte $f9                  ; Also the overlapping error-path entry opcode.
    ldy #$07
    lda (iob_ptr),y
    cmp found_volume
    beq rwts_check_track
    plp
    lda #$01
    bne rwts_error_operand
rwts_check_track:
    ldy #$02
    lda (iob_ptr),y
    cmp found_track
    bne rwts_buffer_ready
    iny
    lda (iob_ptr),y
    tay
    lda dos_sector_translate,y
    cmp found_sector
    bne rwts_buffer_ready
    plp
    bcs rwts_read
    jsr write_sector_data
    bcc rwts_success
    lda #$02
    bne rwts_error_operand
rwts_read:
    jsr read_sector_data
    php
    bcs rwts_buffer_ready
    plp
    jsr decode_6_and_2
    beq rwts_success

rwts_dispatch_end:
.assert rwts_dispatch - stage1_start = $02ff, error, "RWTS dispatcher origin drift"
.assert rwts_dispatch_end - rwts_dispatch = $0096, error, "RWTS dispatcher size drift"

; Reverse 6-and-2 translation values. The reader indexes this through the
; deliberately biased $BD00 base using raw disk nibbles $96-$FF; $BD95 is the
; invalid-nibble sentinel immediately before the valid table.
reverse_translate_sentinel:
    .byte $ff
reverse_translate_values:
    .byte $00,$01,$98,$99,$02,$03,$9c,$04,$05,$06,$a0,$a1,$a2,$a3,$a4
    .byte $a5,$07,$08,$a8,$a9,$aa,$09,$0a,$0b,$0c,$0d,$b0,$b1,$0e,$0f
    .byte $10,$11,$12,$13,$b8,$14,$15,$16,$17,$18,$19,$1a,$c0,$c1,$c2
    .byte $c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$1b,$cc,$1c,$1d,$1e,$d0,$d1
    .byte $d2,$1f,$d4,$d5,$20,$21,$d8,$22,$23,$24,$25,$26,$27,$28,$e0
    .byte $e1,$e2,$e3,$e4,$29,$2a,$2b,$e8,$2c,$2d,$2e,$2f,$30,$31,$32
    .byte $f0,$f1,$33,$34,$35,$36,$37,$38,$f8,$39,$3a,$3b,$3c,$3d,$3e
    .byte $3f

; Initial contents of the two mutable 6-and-2 work areas. These bytes contain
; incidental utility fragments in the disk image, but the live RWTS paths use
; $BE00-$BEFF and $BF00-$BF55 only as sector scratch storage.
six_and_two_aux_initial:
    .byte $b1,$3a,$20,$56,$f9,$85,$3a,$98,$38,$b0,$a2,$20,$4a,$ff,$38,$b0
    .byte $9e,$ea,$ea,$4c,$0b,$fb,$4c,$fd,$fa,$c1,$d8,$d9,$d0,$d3,$ad,$70
    .byte $c0,$a0,$00,$ea,$ea,$bd,$64,$c0,$10,$04,$c8,$d0,$f8,$88,$60,$a9
    .byte $00,$85,$48,$ad,$56,$c0,$ad,$54,$c0,$ad,$51,$c0,$a9,$00,$f0,$0b
    .byte $e7,$18,$77,$77,$35,$3a,$2e,$56,$7a,$0a,$54,$43,$22,$a9,$00,$6a
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

six_and_two_main_initial:
    .byte $04,$08,$0c,$10,$14,$18,$1c,$00,$04,$08,$0c,$10,$14,$18,$1c,$00
    .byte $04,$08,$0c,$10,$14,$18,$1c,$00,$04,$08,$0c,$10,$14,$18,$1c,$00
    .byte $04,$08,$a5,$25,$20,$c1,$fb,$65,$20,$85,$28,$60,$49,$c0,$f0,$28
    .byte $69,$fd,$90,$c0,$f0,$da,$69,$fd,$90,$2c,$f0,$de,$69,$fd,$90,$5c
    .byte $d0,$e9,$a4,$24,$a5,$25,$48,$20,$24,$fc,$20,$9e,$fc,$a0,$00,$68
    .byte $69,$00,$c5,$23,$90,$f0

seek_delay_in:
    .byte $01,$30,$28,$24,$20,$1e,$1d,$1c
seek_delay_out:
    .byte $70,$2c,$26,$22,$1f,$1e,$1d,$1c

; DOS 3.3 legal disk-byte translation table used by write_sector_data.
write_translate:
    .byte $96,$97,$9a,$9b,$9d,$9e,$9f,$a6,$a7,$ab,$ac,$ad,$ae,$af,$b2,$b3
    .byte $b4,$b5,$b6,$b7,$b9,$ba,$bb,$bc,$bd,$be,$bf,$cb,$cd,$ce,$cf,$d3
    .byte $d6,$d7,$d9,$da,$db,$dc,$dd,$de,$df,$e5,$e6,$e7,$e9,$ea,$eb,$ec
    .byte $ed,$ee,$ef,$f2,$f3,$f4,$f5,$f6,$f7,$f9,$fa,$fb,$fc,$fd,$fe,$ff

; Logical-sector to Disk II physical-sector permutation.
dos_sector_translate:
    .byte $00,$0d,$0b,$09,$07,$05,$03,$01,$0e,$0c,$0a,$08,$06,$04,$02,$0f

; A is a delay count. Each outer iteration burns a fixed inner loop before
; subtracting one; the two JMPs preserve the original timing and entry layout.
disk_delay:
    ldx #$11
disk_delay_inner:
    dex
    bne disk_delay_inner
    jmp disk_delay_bridge
disk_delay_bridge:
    jmp disk_delay_tick
disk_delay_tick:
    nop
    sec
    sbc #$01
    bne disk_delay
    rts

stage1_tables_end:
.assert reverse_translate_sentinel - stage1_start = $0395, error, "reverse table origin drift"
.assert six_and_two_aux_initial - stage1_start = $0400, error, "aux scratch origin drift"
.assert six_and_two_main_initial - stage1_start = $0500, error, "main scratch origin drift"
.assert seek_delay_in - stage1_start = $0556, error, "seek table origin drift"
.assert write_translate - stage1_start = $0566, error, "write table origin drift"
.assert dos_sector_translate - stage1_start = $05a6, error, "sector table origin drift"
.assert disk_delay - stage1_start = $05b6, error, "delay routine origin drift"
.assert stage1_tables_end - stage1_start = $05c8, error, "table/utility span size drift"

; Embedded tokenized source independently names these symbols INTER, IOB,
; SLT, TRK, SEC, BUFP, CMD, and RWTS0 ($BB00).
INTER:
    pha
    ldx #$15
    stx TRK
    ldx #$00
    stx IOB_SEC
    ldx #$40
    stx BUFP
    ldx #$03
    stx CMD
    ldx #<IOB
    ldy #>IOB
    jsr rwts_dispatch
    pla
    jmp $4000

IOB:
    .byte $02
SLT:
    .byte $60
TRK:
    .byte $00
IOB_SEC:                         ; Original source symbol: SEC (ca65 opcode)
    .byte $00
BUFP:
    .byte $00
CMD:
    .byte $00

interface_end:
.assert INTER - stage1_start = $05c8, error, "INTER origin drift"
.assert IOB - stage1_start = $05e8, error, "IOB origin drift"
.assert interface_end - stage1_start = $05ee, error, "interface size drift"

; No recovered control-flow or data reference enters these final 18 bytes.
; Preserve the residual sector content as data rather than assigning false
; instruction semantics to the opcode-like fragments.
residual_sector_tail:
    .byte $00,$fe,$a9,$02,$4c,$5d,$04,$3a,$ca,$d0,$f5,$60,$20,$fd,$fc,$88
    .byte $ad,$60

stage1_end:
.assert residual_sector_tail - stage1_start = $05ee, error, "residual tail origin drift"
.assert stage1_end - stage1_start = $0600, error, "stage-1 image must be 1536 bytes"
