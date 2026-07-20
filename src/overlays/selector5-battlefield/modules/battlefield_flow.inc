; Selector-5 entry vectors, battlefield lifecycle, disk I/O, counters, scoring.

selector5_start:
selector5_main_jump:
    jmp selector5_main_entry
selector5_delay_jump:
    jmp delay_with_speaker_click
selector5_random_byte_jump:
    jmp mix_entropy_byte
selector5_rwts_jump:
    jmp rwts_retry
selector5_bcd_adjustment_jump:
    jmp add_bcd_table_adjustment
selector5_disk_region_jump:
    jmp load_selector5_disk_region
selector5_counter_format_jump:
    jmp format_bcd_counter
selector5_entry_7:
selector5_unlink_object_jump:
    jmp unlink_current_active_object

; Type-indexed horizontal sizes. Type 0's byte is the high operand of the
; preceding JMP, preserving the original instruction/table overlap at $6917.
object_horizontal_sizes = selector5_entry_7+2
    .byte $01,$0b,$0d,$18,$1b,$0e,$09,$01,$08,$02,$04,$02,$03,$11,$11
    .byte $0e,$00,$02,$00,$07,$00,$10,$10,$10,$03,$02,$01,$0d,$00

object_vertical_sizes:
    .byte $00,$01,$0a,$01,$03,$14,$11,$07,$ff,$08,$04,$01,$07,$08,$0d
    .byte $0b,$0b,$00,$03,$00,$04,$00,$14,$0b,$0b,$0a,$03,$01,$0d,$00

; Nonzero entries identify types linked through the active-object list and
; therefore eligible for list unlink/collision traversal.
object_active_list_flags:
    .byte $00,$01,$01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01
    .byte $01,$00,$01,$00,$01,$00,$01,$01,$01,$01,$01,$01,$01,$00,$00

; Burn A inner-loop iterations for each Y outer pass and click the speaker once
; per completed inner delay.
delay_with_speaker_click:
    tax
speaker_delay_inner:
    dex
    bne speaker_delay_inner
    bit $c030
    dey
    bne delay_with_speaker_click
    rts

selector5_front_block_end:
.assert selector5_main_jump - selector5_start = $0000, error, "selector-5 main jump origin drift"
.assert object_horizontal_sizes - selector5_start = $0017, error, "object horizontal-size table origin drift"
.assert object_vertical_sizes - selector5_start = $0035, error, "object vertical-size table origin drift"
.assert object_active_list_flags - selector5_start = $0053, error, "object active-list table origin drift"
.assert delay_with_speaker_click - selector5_start = $0072, error, "speaker delay origin drift"
.assert selector5_front_block_end - selector5_start = $007d, error, "selector-5 front block size drift"

selector5_main_entry:
    ldx #$f0
    txs
    lda #$00
    sta $01
    lda #$02
    jsr $bfc8
    jsr initialize_gameplay_modules
    lda #$01
    sta $60b6
alternate_demo_and_interactive_passes:
    jsr run_battlefield_pass
    lda $60b6
    eor #$01
    sta $60b6
    jmp alternate_demo_and_interactive_passes

initialize_gameplay_modules:
    lda #$00
    sta $bfff
    jsr initialize_shared_state
    jsr object_module_initialize_jump
    jsr object_update_module_initialize_jump
    jsr secondary_module_initialize_jump
    jsr input_module_initialize_jump
    jsr strategy_module_initialize_jump
    jsr $ac00
    jmp $b300

initialize_shared_state:
    lda #$00
    sta $60d3
    sta $60a9
    sta $60aa
    lda #$a0
    sta last_score_digits
    sta last_score_digits+1
    sta last_score_digits+2
    lda #$b0
    sta last_score_digits+3
    lda #$ff
    sta $6002
    rts

run_battlefield_pass:
    jsr initialize_battlefield_pass
prepare_battle_stage:
    jsr initialize_battle_stage
run_battlefield_update:
    jsr $6a51
    lda $6001
    beq check_battlefield_state
    jsr $b30c
    lda #$05
    jsr $bfc8
    jmp run_battlefield_pass

check_battlefield_state:
    lda $60bc
    bne finish_interactive_pass
    lda $60c6
    beq check_start_or_end_flags
    inc $60c7
    bne check_start_or_end_flags
    lda $60b6
    bne run_battlefield_pass
    inc $60b7
    lda $60c6
    cmp #$01
    beq check_start_or_end_flags
    lda $05
    cmp #$08
    beq advance_to_briefing
check_start_or_end_flags:
    lda $60b8
    bne finish_current_pass
    lda $60b0
    bne delay_pass_finish
    lda $60b7
    beq run_battlefield_update
    jsr accumulate_battlefield_value
    jmp prepare_battle_stage
delay_pass_finish:
    inc $60b1
    bne run_battlefield_update
finish_current_pass:
    lda $60b6
    bne return_from_battlefield_pass
finish_interactive_pass:
    lda $6000
    cmp #$04
    beq return_from_battlefield_pass
    jmp check_campaign_threshold
return_from_battlefield_pass:
    rts

advance_to_briefing:
    inc $05
    jsr $b30c
    lda #$06
    jsr $bfc8
    jmp finish_current_pass

main_flow_source_end:
.assert selector5_main_entry - selector5_start = $007d, error, "selector-5 main entry origin drift"
.assert main_flow_source_end - selector5_main_entry = $00d4, error, "selector-5 main flow size drift"

update_battlefield_counters:
    jsr object_update_module_tick_jump
    lda $6000
    cmp #$04
    beq update_counters_done
    lda $04
    eor #$01
    beq update_object_timer
    lda $6003
    beq update_object_timer
    dec $6003
update_object_timer:
    jsr $b309
    inc $60c1
    bne update_counters_done
    inc $60c2
update_counters_done:
    rts

initialize_battlefield_pass:
    lda #$01
    sta $60b9
    lda $60b6
    beq initialize_pass_modules
    lda #$00
    sta $60bb
    jsr $b30c
    jsr probe_disk_data_flag
initialize_pass_modules:
    jsr reset_battlefield_state
    jsr object_module_reset_jump
    jsr object_update_module_reset_jump
    jsr secondary_module_reset_jump
    jsr input_module_reset_jump
    jsr strategy_module_reset_jump
    jsr $ac03
    jmp $b303

pass_wrappers_source_end:
.assert update_battlefield_counters - selector5_start = $0151, error, "update wrapper origin drift"
.assert pass_wrappers_source_end - update_battlefield_counters = $0051, error, "pass wrappers size drift"

reset_battlefield_state:
    lda #$00
    sta $6001
    sta $6000
    sta $60bc
    sta $60b0
    sta $60b1
    sta $60b8
    sta $60b7
    sta $60c6
    sta $60c7
    sta $60c1
    sta $60c2
    sta $0e
    sta $0f
    bit $60bb
    bmi retain_campaign_index
    lda $60b6
    eor #$01
    sta $05
retain_campaign_index:
    lda #$04
    sta $60ab
    ; Both side-indexed cash pools begin at 15 bags for a new battlefield pass.
    lda #$0f
    sta $6116
    sta $6117
    rts

initialize_battle_stage:
    lda $60b7
    beq load_battle_stage
    lda #$00
    sta $60b7
    inc $05
    lda #$00
    sta $60c6
    sta $60c7
load_battle_stage:
    jsr $6b94
    ldy #$07
copy_battle_parameters:
    lda $4064,y
    sta $60e9,y
    dey
    bpl copy_battle_parameters
    jsr object_module_noop_jump
    jsr object_update_module_stage_jump
    jsr secondary_module_stage_jump
    jsr input_module_stage_jump
    jsr strategy_module_stage_jump
    jsr $ac06
    jsr $b306
    jsr object_pool_initialize_jump
    lda #$00
    sta $6110
    sta $6111
    sta $60fe
    sta $60ff
    ldx $05
    cpx #$01
    bne initialize_stage_runtime
    sta $0e
    sta $0f
initialize_stage_runtime:
    lda #$01
    sta $6003
    ldy $05
    cpy $6002
    beq maybe_present_briefing
    lda $6dff,y
    ldx $6002
    cmp $6dff,x
    beq maybe_present_briefing
    jsr load_stage_disk_segments
maybe_present_briefing:
    lda $60b6
    bne briefing_complete
    bit $60bb
    bmi briefing_complete
    lda #$06
    jsr $bfc8
briefing_complete:

battlefield_initialization_source_end:
.assert reset_battlefield_state - selector5_start = $01a2, error, "battlefield reset origin drift"
.assert battlefield_initialization_source_end - reset_battlefield_state = $00bc, error, "battlefield initialization size drift"

; Read the initial stage sectors, clear the HGR page margins, then issue the
; final RWTS command through the selector-5 jump table.
load_initial_stage_sectors:
    lda #$06
    sta $bfec
    lda #$03
    sta $bfed
    lda #$0b
    sta $bfea
    lda #$02
    sta $bfeb
    jsr selector5_rwts_jump
    dec $bfeb
    dec $bfec
    jsr selector5_rwts_jump
    lda #$00
    sta $bfed
    bit $c010
    ldy #$07
clear_hgr_page_margins:
    sta $4078,y
    sta $40f8,y
    dey
    bpl clear_hgr_page_margins
    jmp selector5_rwts_jump

; Configure and load a stage-specific disk region. The pushed value becomes
; the block number for the second read after the first command is prepared.
load_stage_disk_region:
    jsr $b30c
    lda #$00
    sta $bfea
    lda $05
    clc
    adc #$06
    sta $bfeb
    lda #$40
    sta $bfec
    lda #$06
    pha
    jsr set_rwts_read_command
    pla
    sta $bfea
    lda #$02
    sta $bfed
    jsr selector5_rwts_jump
    lda #$00
    beq set_rwts_command
set_rwts_read_command:
    lda #$03
set_rwts_command:
    sta $bfed

; Invoke the RWTS I/O block at $BFE8 until it returns carry clear.
rwts_retry:
    lda #$00
    sta $bfee
    ldx #$e8
    ldy #$bf
    jsr $bb00
    bcs rwts_retry
    rts

; Mix several rapidly changing state bytes into the selector-5 entropy byte.
; Entry carry is intentionally included in the accumulator chain.
mix_entropy_byte:
    adc $60e7
    adc $6900,y
    adc object_module_initialize_jump,x
    adc $60c3
    adc $60c1
    adc $60c4
    adc $60e3
    sta $60e7
    rts

; Load four consecutive descending disk spans. The canonical instruction stream
; replaces the campaign-index Y value with one before the table lookup, selecting
; track $18/sector $0F. The resulting $D000, $1900, and final $E000 banks contain
; 14, 78, and 73 renderer-consumed sprite descriptors; the two-page intermediate
; $E000 load is overwritten by the final eleven-page span.
load_stage_disk_segments:
    lda #$03
    sta $bfed
    ldy $05                    ; overwritten by the canonical fixed selector
    ldy #$01
    ldx $6dff,y
    lda $6e08,x
    sta $bfea
    lda $6e0d,x
    sta $bfeb
    lda #$03
    sta $bfed
    ldx #$d3
    lda #$04
    jsr read_decrementing_disk_span
    ldx #$1f
    lda #$07
    jsr read_decrementing_disk_span
    ldx #$e1
    lda #$02
    jsr read_decrementing_disk_span
    ldx #$ea
    lda #$0b
    jsr read_decrementing_disk_span
    lda #$00
    sta $bfed
    jmp selector5_rwts_jump

read_decrementing_disk_span:
    stx $bfec
read_next_disk_block:
    pha
    jsr selector5_rwts_jump
    dec $bfec
    lda $bfeb
    bne decrement_disk_sector
    dec $bfea
    lda #$10
    sta $bfeb
decrement_disk_sector:
    dec $bfeb
    pla
    sec
    sbc #$01
    bne read_next_disk_block
    rts

; Publish the four display digits and request selector 3 when the packed-BCD
; campaign counter has crossed the fifth-place default score (1245).
check_campaign_threshold:
    jsr format_bcd_counter
    ldy #$03
copy_formatted_counter:
    lda $60,y
    sta last_score_digits,y
    dey
    bpl copy_formatted_counter
    lda $0f
    cmp #$90
    bcs campaign_threshold_not_reached
    cmp high_score_cutoff_bcd_hi
    bcc campaign_threshold_not_reached
    bne campaign_threshold_reached
    lda $0e
    cmp high_score_cutoff_bcd_lo
    bcc campaign_threshold_not_reached
    bne campaign_threshold_reached
campaign_threshold_not_reached:
    rts
campaign_threshold_reached:
    jsr $b30c
    lda #$03
    jmp $bfc8

; Add a table-selected packed-BCD adjustment to $0E/$0F.
add_bcd_table_adjustment:
    sta $6e8e
    lda $6e11,x
    beq bcd_adjustment_complete
    clc
    adc $6e8e
    tax
    sed
    lda $6e2f,x
    clc
    adc $0e
    sta $0e
    lda $6e37,x
    adc $0f
    sta $0f
    cld
bcd_adjustment_complete:
    rts

; Load a selector-5 disk region while preserving the campaign counters and
; stage number around the transfer.
load_selector5_disk_region:
    sta $bfed
    sta $6000
    ldx $0e
    stx $60d1
    ldx $0f
    stx $60d2
    ldx $05
    stx $60cf
    ldx #$1f
    stx $bfea
    cmp #$03
    bne load_disk_region_pages
    jsr $b30c
    lda #$07
    sta $bfeb
    lda #$40
    sta $bfec
    jsr selector5_rwts_jump
    lda #$00
    sta $4000
    inc $bfed
    jsr selector5_rwts_jump
    dec $bfed
load_disk_region_pages:
    lda #$0f
    sta $bfeb
    lda #$68
    sta $bfec
load_next_disk_region_page:
    jsr selector5_rwts_jump
    bcs load_next_disk_region_page
    dec $bfeb
    dec $bfec
    lda $bfec
    cmp #$60
    bcs load_next_disk_region_page
    lda $bfed
    cmp #$04
    beq mark_disk_region_complete
    lda $60d1
    sta $0e
    lda $60d2
    sta $0f
    lda $60cf
    sta $05
    jmp load_stage_disk_segments
mark_disk_region_complete:
    inc $60bc
    clc
    rts

issue_rwts_command:
    sta $bfed
    jmp selector5_rwts_jump

; Accumulate type-indexed object values and stage bonuses into the packed-BCD
; battlefield counter at $0E/$0F.
accumulate_battlefield_value:
    ldy $60df
accumulate_next_object_value:
    lda $625c,y
    tay
    cmp $60e0
    beq add_stage_value_bonus
    ldx $6124,y
    lda $6e6f,x
    and #$0f
    clc
    adc $6117
    bcc store_accumulated_object_count
    lda #$ff
store_accumulated_object_count:
    sta $6117
    lda $6e6f,x
    lsr a
    lsr a
    lsr a
    lsr a
    cmp #$0a
    bcc add_object_bcd_value
    adc #$05
add_object_bcd_value:
    sed
    adc $0e
    sta $0e
    lda $0f
    adc #$00
    sta $0f
    cld
    jmp accumulate_next_object_value
add_stage_value_bonus:
    lda $05
    sec
    sbc #$01
    beq add_final_value_bonus
    tax
add_next_stage_value_bonus:
    sed
    lda #$50
    clc
    adc $0e
    sta $0e
    lda $0f
    adc #$00
    sta $0f
    cld
    dex
    bne add_next_stage_value_bonus
add_final_value_bonus:
    lda #$01
    clc
    sed
    adc $0f
    sta $0f
    cld
    rts

; Convert the packed-BCD value at $0E/$0F into four high-bit display bytes.
; Negative values are rendered with a semicolon marker in the last position.
format_bcd_counter:
    lda #$a0
    sta $60
    sta $61
    sta $62
    sta $63
    ldy #$03
    sty $60a8
    lda $0e
    sta $64
    lda $0f
    sta $65
    cmp #$90
    bcc extract_next_bcd_digit
    lda #$bb
    sta $63
    sed
    lda #$00
    sbc $64
    sta $64
    lda #$00
    sbc $65
    sta $65
    cld
extract_next_bcd_digit:
    ldx #$04
shift_next_bcd_nibble:
    asl $64
    rol $65
    rol a
    dex
    bne shift_next_bcd_nibble
    and #$0f
    bne store_bcd_digit
    bit $60a8
    bmi store_bcd_digit
    cpy #$00
    bne advance_bcd_digit
store_bcd_digit:
    ora #$b0
    ldx $61
    stx $60
    ldx $62
    stx $61
    ldx $63
    stx $62
    sta $63
    sta $60a8
advance_bcd_digit:
    dey
    bpl extract_next_bcd_digit
    rts

; Remove the current object from the doubly linked active-object list.
unlink_current_active_object:
    ldy $60c3
    ldx $61f4,y
    lda $625c,y
    sta $625c,x
    tay
    txa
    sta $61f4,y
    rts

probe_disk_data_flag:
    lda #$1f
    sta $bfea
    lda #$07
    sta $bfeb
    lda #$40
    sta $bfec
    jsr set_rwts_read_command
    lda $4000
    beq store_disk_data_flag
    lda #$ff
store_disk_data_flag:
    sta $60b2
    rts

disk_and_counter_source_end:
.assert load_initial_stage_sectors - selector5_start = $025e, error, "disk helper origin drift"
.assert disk_and_counter_source_end - load_initial_stage_sectors = $02a1, error, "disk/counter source size drift"

; Campaign-to-disk lookup. The fifth sector entry at $6E11 is also type 0's
; BCD-adjustment selector, preserving the original table overlap.
campaign_disk_group:
    .byte $04,$00,$00,$01,$01,$02,$02,$03,$03
disk_track_by_group:
    .byte $18,$1a,$1b,$1c,$17
disk_sector_by_group = bcd_adjustment_group_by_type-4
    .byte $0f,$07,$0f,$07
bcd_adjustment_group_by_type:
    .byte $07,$00,$07,$00,$00,$00,$06,$00,$00,$05,$00,$00,$00,$01,$02
    .byte $03,$04,$00,$00,$00,$00,$00,$08,$08,$00,$01,$00,$00,$00,$00

bcd_adjustment_low:
    .byte $00,$99,$95,$98,$85,$97,$00,$79
bcd_adjustment_high:
    .byte $00,$99,$99,$99,$99,$99,$00,$99

; The adjustment routine indexes the low base at $6E2F and high base at $6E37
; with group offsets 0..8 plus state banks $00/$10/$20. Those 41-byte logical
; views overlap this physical tail. The final 15 bytes lie beyond both views.
bcd_adjustment_overlapping_tail:
    .byte $00,$98,$99,$00,$95,$00,$75,$00,$01,$99,$99,$00,$99,$00,$99,$00
    .byte $00,$01,$05,$02,$15,$03,$75,$07,$99,$00,$00,$00,$00,$00,$99,$00
    .byte $99
unclassified_core_table_tail:
    .byte $02,$05,$02,$15,$03,$04,$21,$20,$00,$00,$00,$00,$00,$00,$00

; Each object type contributes a packed count nibble and packed-BCD value.
object_battlefield_values:
    .byte $00,$00,$77,$00,$00,$00,$40,$00,$00,$20,$00,$00,$00,$10,$54
    .byte $25,$f2,$00,$00,$00,$00,$00,$00,$f0,$00,$10,$00,$00,$00,$00
    .byte $00
bcd_adjustment_index:
    .byte $00

; Initialized core workspace: 28 four-byte slots plus one trailing zero.
initialized_core_workspace:
    .repeat 28
        .byte $00,$ff,$ff,$00
    .endrepeat
    .byte $00

; Object-management module jump table.
