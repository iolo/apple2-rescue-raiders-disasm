; Shared source-exact bytes for the first stored sector. The same sector is
; assembled at $0800 for boot and emitted unchanged at $BA00 in stage 1.
;
; Absolute operands in the initial boot loop intentionally remain based at
; $0800 after relocation: only the secondary entry at page offset $B0 runs
; from the $BA00 copy.
.macro emit_rescue_raiders_boot_page
boot_rwts_entry_ptr = $003e
boot_load_page      = $0027
boot_slot_x16       = $002b
boot_sector_number  = $003d
boot_track_number   = $0041
boot_text_on        = $c051
boot_page1_on       = $c054
boot_IOB            = $bfe8
boot_IOB_SLT        = boot_IOB+1
boot_IOB_TRK        = boot_IOB_SLT+1
boot_IOB_SEC        = boot_IOB_TRK+1
boot_IOB_BUFP       = boot_IOB_SEC+1
boot_IOB_CMD        = boot_IOB_BUFP+1

; Fixed addresses used by the original $0800-resident half of the sector.
boot_dos_sector_translate_addr = $08a0
boot_destination_page_addr     = $08ac
boot_logical_sector_addr       = $08ad

boot_sector_count:
    .byte $01

boot_entry:
    lda boot_load_page
    cmp #$09
    bne boot_read_next_sector
    lda boot_slot_x16
    lsr
    lsr
    lsr
    lsr
    ora #$c0
    sta boot_rwts_entry_ptr+1
    lda #$5c
    sta boot_rwts_entry_ptr
    clc
    lda boot_destination_page_addr
    adc boot_logical_sector_addr
    sta boot_destination_page_addr

boot_read_next_sector:
    ldx boot_logical_sector_addr
    bmi boot_stage1_loaded
    lda boot_dos_sector_translate_addr,x
    sta boot_sector_number
    dec boot_logical_sector_addr
    lda boot_destination_page_addr
    sta boot_load_page
    dec boot_destination_page_addr
    ldx boot_slot_x16
    jmp (boot_rwts_entry_ptr)

boot_stage1_loaded:
    inc boot_destination_page_addr
    inc boot_destination_page_addr
    bit boot_text_on
    bit boot_page1_on
    ldx boot_slot_x16
    stx boot_IOB_SLT
    txa
    lsr
    lsr
    lsr
    lsr
    tax
    lda #$00
    sta $80,x
    sta $40
    sta boot_track_number
    lda #$00
    ldy #$77
boot_clear_text_page:
    sta $0400,y
    sta $0480,y
    sta $0500,y
    sta $0580,y
    sta $0600,y
    sta $0680,y
    sta $0700,y
    sta $0780,y
    dey
    bpl boot_clear_text_page
    lda #$d2
    sta $07d3
    lda #$b1
    sta $07d4
    lda #$ae
    sta $07d5
    lda #$b2
    sta $07d6
    jmp $bab0

    .res $12, $00

boot_dos_sector_translate:
    .byte $00,$0d,$0b,$09,$07,$05,$03,$01
    .byte $0e,$0c,$0a
boot_unknown_08ab:
    .byte $00
boot_destination_page:
    .byte $ba
boot_logical_sector:
    .byte $05
boot_unknown_08ae:
    .byte $fb,$59

boot_secondary_entry:
    lda #$00
    pha
    ldx #$14
    stx boot_IOB_TRK
    ldx #$0c
    stx boot_IOB_SEC
    ldx #$70
    stx boot_IOB_BUFP
    ldx #$03
    stx boot_IOB_CMD
    ldx #$e8
    ldy #$bf
    jsr $bcff
    pla
    nop
    ldx #$13
    stx boot_IOB_TRK
    ldx #$0f
    stx boot_IOB_SEC
    ldx #$6f
    stx boot_IOB_BUFP
boot_secondary_loop:
    ldx #$e8
    ldy #$bf
    jsr $bcff
    dec boot_IOB_BUFP
    dec boot_IOB_SEC
    bpl boot_secondary_loop
    ldx boot_IOB_SLT
    lda $c088,x
    jmp $707c

    .res $08, $00
    .byte $01

boot_page_end:
.assert boot_dos_sector_translate - boot_sector_count = $00a0, error, "boot DOS table origin drift"
.assert boot_secondary_entry - boot_sector_count = $00b0, error, "secondary entry origin drift"
.assert boot_page_end - boot_sector_count = $0100, error, "boot page must remain exactly 256 bytes"
.endmacro
