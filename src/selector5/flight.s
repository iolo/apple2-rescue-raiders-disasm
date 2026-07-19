; Rescue Raiders selector-5 flight input and player-helicopter motion slices.
.setcpu "6502"
.segment "SELECTOR5"

paddle_trigger = $c070
paddle_0       = $c064
paddle_1       = $c065

last_score_digits         = $01fc
default_high_score_names  = $0400 ; five 16-byte high-bit names, loaded from T0/S15
default_high_score_values = $0450 ; five two-byte packed-BCD scores
high_score_cutoff_bcd_hi  = default_high_score_values+8 ; $12 from fifth-place 1245
high_score_cutoff_bcd_lo  = default_high_score_values+9 ; $45

horizontal_target = $604d
vertical_target   = $604e
current_object    = $60c3
desired_horizontal_velocity = $60e3
desired_vertical_position   = $60e4
strategy_shared_update_entry = $9efb
strategy_negative_velocity_table = strategy_wrapped_negative_velocity_values-$e5

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
object_module_initialize_jump:
    jmp object_module_noop
object_module_reset_jump:
    jmp reset_object_module_counters
object_module_noop_jump:
    jmp object_module_noop_2
object_pool_initialize_jump:
    jmp initialize_object_pool
object_constructor_jump:
    jmp dispatch_object_constructor
type0c_batch_jump:
    jmp initialize_type0c_batch
object_finalize_jump:
    jmp $7830

object_module_noop:
    rts

reset_object_module_counters:
    lda #$00
    sta $60fe
    sta $60ff
object_module_noop_2:
    rts

; Clear the 104 object slots and selected per-type counters, create the two
; active-list sentinel objects, then initialize the remaining object modules.
initialize_object_pool:
    ldy #$67
    sty $6012
    lda #$00
clear_next_object_slot:
    sta $6124,y
    sta $6604,y
    dey
    bpl clear_next_object_slot
    ldy #$0c
clear_next_object_counter:
    sta $6117,y
    dey
    bne clear_next_object_counter
    jsr initialize_active_list_sentinels
    jsr initialize_player_helicopters
    jsr $7710
    jsr initialize_battlefield_layout_objects
    jmp $7786

; Allocate and link the two type-1 sentinels anchoring the doubly linked active
; object list. $60DF and $60E0 retain the two sentinel indices.
initialize_active_list_sentinels:
    jsr allocate_object
    lda #$01
    sta $6124,y
    sty $60e0
    jsr allocate_object
    lda #$01
    sta $6124,y
    sty $60df
    ldx $60e0
    lda #$00
    sta $618c,y
    sta $618c,x
    lda #$ff
    sta $61f4,y
    sta $625c,x
    txa
    sta $625c,y
    tya
    sta $61f4,x
    lda #$00
    sta $632c,y
    sta $6394,y
    sta $63fc,y
    sta $63fc,x
    lda #$ff
    sta $632c,x
    sta $6394,x
    rts

; Entry $6F8E sets carry and therefore permits reclaiming a type-$0C slot if
; no free slot exists. Entry $6F90 clears carry and only accepts a free slot.
allocate_object_or_type0c_slot:
    sec
    .byte $90                  ; BCC opcode; $6F90 CLC is its operand byte
allocate_object:
    clc
    ldx #$68
    ldy $6012
scan_for_free_object_slot:
    lda $6124,y
    beq allocate_selected_object_slot
    dex
    beq maybe_scan_type0c_slots
    dey
    bpl scan_for_free_object_slot
    ldy #$67
    bne scan_for_free_object_slot
maybe_scan_type0c_slots:
    bcs object_allocation_failed
    lda #$0c
    ldx #$68
scan_for_type0c_slot:
    cmp $6124,y
    beq allocate_selected_object_slot
    dex
    beq object_allocation_carry_return
    dey
    bpl scan_for_type0c_slot
    ldy #$67
    bne scan_for_type0c_slot
allocate_selected_object_slot:
    sty current_object
    sty $6012
    clc
    rts
object_allocation_carry_return:
    sec
object_allocation_failed:
    rts

object_core_source_end:
.assert campaign_disk_group - selector5_start = $04ff, error, "core table origin drift"
.assert object_module_initialize_jump - selector5_start = $0600, error, "object module origin drift"
.assert allocate_object_or_type0c_slot - selector5_start = $068e, error, "fallback allocator origin drift"
.assert allocate_object - selector5_start = $0690, error, "object allocator origin drift"
.assert object_core_source_end - campaign_disk_group = $01c5, error, "core tables/module source size drift"

; Create and initialize both player helicopters and their linked companion
; objects. $60BD is the player slot, first 1 and then 0.
initialize_player_helicopters:
    lda #$01
    sta $60bd
    jsr initialize_player_helicopter
    dec $60bd
initialize_player_helicopter:
    lda #$65
    sta $6012
    jsr allocate_object
    .byte $b0,$ea              ; BCS $6FC3 (return with carry set)
    tya
    ldx $60bd
    sta $6112,x
    lda #$02
    sta $6124,y
    sty $60
    jsr allocate_object
    .byte $b0,$d7              ; BCS $6FC3 (return with carry set)
    ldy $60
    ldx $60bd
    lda #$01
    sta $62c4,y
    lda #$00
    sta $6464,y
    sta $6100,x
    sta $6104,x
    sta $610a,x
    lda #$ff
    sta $610e,x
    sta $6114,x
    lda #$01
    sta $618c,y
    lda #$0f
    sta $659c,y
    lda #$09
    sta $666c,y
    txa
    sta $6604,y
    lda $60b6
    bne initialize_player_side
    txa
    eor #$01
initialize_player_side:
    eor #$01
    sta $60f8,x
    lda $7915,x
    clc
    adc #$08
    sta $6394,y
    lda $791b,x
    adc #$00
    sta $632c,y
    lda #$dc
    sta $63fc,y
    lda #$00
    sta $64cc,y
    sta $6534,y
    lda #$80
    sta $6108,x
    lda #$0a
    sta $60f4,x
    lda #$40
    sta $60f6,x
    lda $60ee
    beq initialize_missiles
    lda #$06
    sta $60f6,x
initialize_missiles:
    lda #$02
    sta $6102,x
    sty current_object
    lda $60bd
    beq initialize_companion
    ldx $60a7
    lda #$00
    jsr $690c
initialize_companion:
    jsr $7830
    jsr allocate_object
    lda #$03
    sta $6124,y
    lda #$02
    sta $618c,y
    lda #$ff
    sta $62c4,y
    sta $666c,y
    lda $60bd
    sta $6604,y
    lda #$80
    sta $632c,y
    sta $63fc,y
    lda #$01
    sta $6464,y
    lda #$00
    sta $6394,y
    lda $60
    sta $66d4,y
    tax
    tya
    sta $66d4,x
    clc
    rts

initialize_players_end:
.assert initialize_player_helicopters - selector5_start = $06c4, error, "player initialization origin drift"
.assert initialize_players_end - initialize_player_helicopters = $00f0, error, "player initialization size drift"

; Decode the two 32-row battlefield bitfields at $4000/$4020. Set bits create
; type-$06 stationary-gun assemblies or type-$09 objects at 12-unit intervals.
initialize_battlefield_layout_objects:
    lda #$00
    sta $79fc
    lda #$00
    sta $60cd
    lda #$02
    sta $60cc
decode_next_battlefield_layout_row:
    ldy $79fc
    lda $4000,y
    beq decode_type09_layout_row
    jsr decode_type06_layout_bits
    ldy $79fc
decode_type09_layout_row:
    lda $4020,y
    beq advance_battlefield_layout_row
    jsr decode_type09_layout_bits
advance_battlefield_layout_row:
    inc $79fc
    lda $60cd
    clc
    adc #$60
    sta $60cd
    lda #$00
    adc $60cc
    sta $60cc
    lda $79fc
    cmp #$20
    bne decode_next_battlefield_layout_row
    rts

decode_type06_layout_bits:
    ldx #$06
    bne decode_battlefield_layout_bits
decode_type09_layout_bits:
    ldx #$09
decode_battlefield_layout_bits:
    stx $60a7
    sta $65
    lda $60cd
    pha
    lda $60cc
    pha
    lda $4040,y
    sta $64
    lda #$07
    sta $60e3
decode_next_battlefield_layout_bit:
    asl $65
    bcc advance_battlefield_layout_bit
    lda $64
    asl a
    lda #$00
    rol a
    sta $60bd
    lda $60a7
    pha
    jsr object_constructor_jump
    pla
    sta $60a7
advance_battlefield_layout_bit:
    asl $64
    lda $60cd
    clc
    adc #$0c
    sta $60cd
    lda $60cc
    adc #$00
    sta $60cc
    dec $60e3
    bpl decode_next_battlefield_layout_bit
    pla
    sta $60cc
    pla
    sta $60cd
    rts

initialize_type04_with_zero_damage:
    lda #$00
initialize_type04_object:
    sta $60b3
    jsr $76b9
    lda $6106,x
    bpl type04_initialization_done
    tya
    sta $6106,x
type04_initialization_done:
    rts

initialize_type05_object:
    lda #$80
    sta $60b3
    jsr $76b9
    lda #$ff
    sta $66d4,y
    tya
    sta $60f2,x
    rts

battlefield_layout_source_end:
.assert initialize_battlefield_layout_objects - selector5_start = $07b4, error, "battlefield layout origin drift"
.assert initialize_type04_object - selector5_start = $084d, error, "type-04 constructor entry drift"
.assert initialize_type05_object - selector5_start = $085d, error, "type-05 constructor entry drift"
.assert battlefield_layout_source_end - initialize_battlefield_layout_objects = $00bb, error, "battlefield layout source size drift"

; Initialize the linked type-$06/$07/$08 capturable structure assembly. Types
; $07/$08 run the linked vertical-motion handlers; the independent type-$09
; object below owns the stationary-gun targeting and five-damage fire path.
initialize_type06_linked_structure:
    lda #$2f
    sta $60b3
    jsr $76b9
    lda $406d
    sta $67a4,y
    sec
    adc $6118,x
    sta $6118,x
    lda $406d
    adc $611e,x
    sta $611e,x
    inc $611c,x
    sty $60
    lda #$06
    sta $60b3
    lda #$07
    jsr $76b6
    lda $60cc
    and #$08
    beq linked_component_side_ready
    sec
linked_component_side_ready:
    lda #$00
    sta $64cc,y
    sta $6534,y
    rol
    eor #$01
    adc #$12
    sta $62c4,y
    lda #$cd
    sta $63fc,y
    lda $60
    sta $66d4,y
    tax
    tya
    sta $66d4,x
    jsr $6906
    and #$3f
    clc
    adc #$7b
    sta $673c,y
    sty $60
    jsr allocate_object
    lda #$08
    sta $6124,y
    lda #$01
    sta $618c,y
    lda #$d1
    sta $6464,y
    lda #$00
    sta $64cc,y
    sta $6534,y
    lda #$f0
    sta $62c4,y
    lda $60cd
    clc
    adc #$04
    sta $6394,y
    lda $60cc
    adc #$00
    sta $632c,y
    lda #$80
    sta $659c,y
    lda #$ff
    sta $666c,y
    lda $60bd
    sta $6604,y
    lda $60
    sta $66d4,y
    tax
    lda $63fc,x
    sta $63fc,y
    tya
    sta $67a4,x
    lda $66d4,x
    sta $673c,y
    tax
    tya
    sta $673c,x
    jmp $7830

type06_linked_structure_end:
.assert initialize_type06_linked_structure - selector5_start = $086f, error, "type-06 linked structure origin drift"
.assert type06_linked_structure_end - initialize_type06_linked_structure = $00bf, error, "type-06 linked structure size drift"

; Type-$09 constructor. Interactive-side creation first applies its table-based
; BCD adjustment; the common constructor receives 22 integrity/damage units.
initialize_type09_object:
    lda #$16
    sta $60b3
    lda $60bd
    beq type09_construct_object
    lda #$00
    ldx $60a7
    jsr selector5_bcd_adjustment_jump
type09_construct_object:
    jsr $76b9
    lda $60e3
    and #$01
    sta $66d4,y
    rts

type09_initialization_end:
.assert initialize_type09_object - selector5_start = $092e, error, "type-09 constructor origin drift"
.assert type09_initialization_end - initialize_type09_object = $001e, error, "type-09 constructor size drift"

; Initialize a player bomb with seven integrity/damage units. The common object
; allocator leaves Y selecting the newly allocated projectile.
initialize_bomb_projectile:
    lda #$07
    sta $60b3
    lda current_object
    sta $60
    jsr $76b9
    bcs bomb_projectile_done
    ldx #$02
    cpy $60
    bcc bomb_projectile_side_ready
    dex
bomb_projectile_side_ready:
    txa
    sta $67a4,y
    lda #$00
    sta $6534,y
    lda #$03
    sta $673c,y
    jsr copy_constructor_velocity_and_position
    ldx #$3d
    lda $60cf
    bne bomb_projectile_moving
    ldx #$3a
    bne bomb_projectile_sprite_ready
bomb_projectile_moving:
    bmi bomb_projectile_sprite_ready
    inx
bomb_projectile_sprite_ready:
    txa
    sta $62c4,y
bomb_projectile_done:
    rts

initialize_bomb_projectile_end:
.assert initialize_bomb_projectile - selector5_start = $094c, error, "bomb initialization origin drift"
.assert initialize_bomb_projectile_end - initialize_bomb_projectile = $003a, error, "bomb initialization size drift"

; Shared type-$0B projectile initialization. $60CF/$60D0 are horizontal and
; vertical velocity, $60A8 is vertical acceleration, and the life counter is
; initialized to 10 + acceleration.
initialize_type0b_projectile:
    jsr $76b9
    bcs type0b_initialization_done
    lda #$01
    sta $6464,y
    lda $60a8
    sta $67a4,y
    clc
    adc #$0a
    sta $673c,y
    lda $60cf
    sta $64cc,y
    lda $60ce
    sta $63fc,y
    lda $60d0
    sta $6534,y
type0b_initialization_done:
    rts

type0b_initialization_end:
.assert initialize_type0b_projectile - selector5_start = $0986, error, "type-0B initialization origin drift"
.assert type0b_initialization_end - initialize_type0b_projectile = $0029, error, "type-0B initialization size drift"

; Dispatch the constructor selected by object type in $60A7. The pointer table
; at $7875 is copied into a self-modifying JSR so constructors can return
; normally while the caller's object index and X register remain intact.
dispatch_object_constructor:
    txa
    pha
    lda current_object
    pha
    lda $60a7
    asl
    tay
    lda $7875,y
    sta constructor_call+1
    lda $7876,y
    sta constructor_call+2
constructor_call:
    jsr $1234
    ldy current_object
    pla
    sta current_object
    pla
    tax
    rts

; Create A type-$0C fragments. A successful fragment construction returns
; carry clear, which also makes ADC #$FF decrement the saved count by one.
initialize_type0c_batch:
    tax
    lda current_object
    pha
    txa
type0c_batch_loop:
    pha
    jsr initialize_type0c_fragment
    pla
    bcs type0c_batch_done
    adc #$ff
    bne type0c_batch_loop
type0c_batch_done:
    pla
    sta current_object
    rts

; Initialize a short-lived randomized type-$0C fragment around the position
; and velocity supplied in the constructor workspace.
initialize_type0c_fragment:
    jsr allocate_object_or_type0c_slot
    bcs type0c_fragment_done
    lda #$00
    sta $6604,y
    lda #$ff
    sta $62c4,y
    sta $666c,y
    lda #$0c
    sta $6124,y
    lda #$02
    sta $618c,y
    jsr copy_constructor_horizontal_position
    lda $60ce
    sta $63fc,y
    cmp #$dd
    bne type0c_fragment_randomize
    lda #$00
    sta $60cf
    lda #$f8
    sta $60d0
type0c_fragment_randomize:
    lda $60e7
    and #$03
    adc #$01
    sta $659c,y
    lda $60e7
    and #$1c
    sta $66d4,y
    jsr $6906
    and #$0f
    adc #$0c
    sta $673c,y
    jsr $6906
    and #$07
    sbc #$03
    clc
    adc $60cf
    sta $64cc,y
    jsr $6906
    and #$0f
    sbc #$07
    clc
    adc $60d0
    sta $6534,y
    lda $60a8
    sta $67a4,y
    bpl type0c_fragment_success
    lda $6534,y
    pha
    asl
    pla
    ror
    sta $6534,y
    ldx current_object
    lsr $659c,x
type0c_fragment_success:
    clc
type0c_fragment_done:
    rts

; Type-$0D constructor shared by a five-man infantry squad and a two-person
; engineer team. $60E1 selects variant 0/1 and can also request special
; placement when negative. Each member begins with five integrity units.
initialize_infantry:
    lda #$05
    sta $60b3
    lda $60e1
    pha
    jsr $76b9
    pla
    bcs infantry_initialization_done
    bpl infantry_variant_ready
    tax
    lda $6942
    clc
    adc #$dd
    sta $63fc,y
    txa
infantry_variant_ready:
    and #$01
    sta $67a4,y
    ldx $60bd
    inc $611e,x
    inc $6118,x
    lda #$ff
    sta $66d4,y
    lda #$00
    sta $6874,y
    sta $6464,y
    lda $7923,x
    sta $64cc,y
infantry_initialization_done:
    rts

; Type-$0E tank: 15 integrity units and vehicle sprite $2D.
initialize_tank:
    lda #$0e
    sta $60a7
    lda #$01
    sta $79fb
    lda #$0f
    sta $60b3
    ldx $60bd
    inc $6120,x
    inc $6118,x
    lda #$06
    sta $0200
    lda #$2d
    jsr initialize_ground_vehicle
    bcs tank_initialization_done
    ldy current_object
    lda #$00
    sta $673c,y
    sta $6874,y
tank_initialization_done:
    rts

; Type-$0F anti-air missile carrier: six integrity units. The sprite differs
; by battlefield side.
initialize_missile_carrier:
    lda #$0f
    sta $60a7
    lda #$01
    sta $79fb
    lda #$06
    sta $60b3
    lda #$06
    sta $0200
    lda #$32
    ldx $60bd
    beq missile_carrier_sprite_ready
    lda #$34
missile_carrier_sprite_ready:
    inc $611a,x
    inc $6118,x
    jmp initialize_ground_vehicle

; Type-$10 demolition vehicle: nine integrity units and a side-specific
; vehicle sprite.
initialize_demolition_vehicle:
    lda #$10
    sta $60a7
    lda #$01
    sta $79fb
    lda #$09
    sta $60b3
    lda #$07
    sta $0200
    lda #$41
    ldx $60bd
    beq demolition_vehicle_sprite_ready
    lda #$43
demolition_vehicle_sprite_ready:
    inc $6122,x
    inc $6118,x

; Common type-$0E/$0F/$10 vehicle constructor. A supplies the sprite code;
; $60B3 supplies integrity, $0200 supplies an additional object property, and
; $60BD selects side-facing defaults when explicit coordinates are absent.
initialize_ground_vehicle:
    sta $10
    jsr allocate_object
    bcs ground_vehicle_initialization_done
    lda $60a7
    sta $6124,y
    lda $79fb
    sta $618c,y
    lda $60cc
    ora $60cd
    beq ground_vehicle_default_position
    lda $60cd
    sta $6394,y
    lda $60cc
    sta $632c,y
    jmp ground_vehicle_set_side
ground_vehicle_default_position:
    lda #$00
    sta $632c,y
    lda #$08
    sta $6394,y
    lda $60bd
    beq ground_vehicle_finish_position
    lda #$0f
    sta $632c,y
    lda #$f7
    sta $6394,y
ground_vehicle_set_side:
    ldx #$01
    lda $60bd
    beq ground_vehicle_store_side
    ldx #$ff
ground_vehicle_store_side:
    sta $6604,y
    txa
    sta $64cc,y
ground_vehicle_finish_position:
    ldx $6124,y
    lda $6935,x
    clc
    adc #$dd
    sta $63fc,y
    lda #$00
    sta $6534,y
    lda $0200
    sta $666c,y
    lda $60b3
    sta $659c,y
    lda $10
    sta $67a4,y
    sta $62c4,y
    jsr object_finalize_jump
    clc
ground_vehicle_initialization_done:
    rts

ground_unit_constructors_end:
.assert dispatch_object_constructor - selector5_start = $09af, error, "object constructor dispatcher origin drift"
.assert initialize_infantry - selector5_start = $0a6e, error, "infantry constructor origin drift"
.assert initialize_tank - selector5_start = $0aac, error, "tank constructor origin drift"
.assert initialize_missile_carrier - selector5_start = $0adc, error, "missile carrier constructor origin drift"
.assert initialize_demolition_vehicle - selector5_start = $0b02, error, "demolition vehicle constructor origin drift"
.assert initialize_ground_vehicle - selector5_start = $0b25, error, "common vehicle constructor origin drift"
.assert ground_unit_constructors_end - dispatch_object_constructor = $01f3, error, "object constructor span size drift"

; Initialize the type-$11 visual object emitted during destruction. $10 selects
; its sprite/effect code, $60CF records the destroyed object type, and $60E3
; carries that object's link field. The short lifetime is 2 or 3 updates.
initialize_destruction_effect:
    lda current_object
    sta $60
    jsr allocate_object
    bcs destruction_effect_init_done
    lda #$11
    sta $6124,y
    lda #$02
    sta $618c,y
    lda #$ff
    sta $666c,y
    jsr copy_constructor_position
    lda $10
    sta $62c4,y
    lda $60cf
    sta $66d4,y
    lda $60e3
    sta $6464,y
    ldx #$02
    lda $60
    cmp current_object
    bcs destruction_effect_lifetime_ready
    inx
destruction_effect_lifetime_ready:
    txa
    sta $673c,y
destruction_effect_init_done:
    rts

destruction_effect_init_end:
.assert initialize_destruction_effect - selector5_start = $0ba2, error, "destruction effect initialization origin drift"
.assert destruction_effect_init_end - initialize_destruction_effect = $003c, error, "destruction effect initialization size drift"

; Initialize a smart missile with 21 integrity/damage units and bind its target
; and owner fields supplied by the player firing path.
initialize_smart_missile:
    lda #$15
    sta $60b3
    jsr $76b9
    bcs smart_missile_init_done
    ldx #$63
    lda $60cf
    sta $64cc,y
    beq smart_missile_sprite_ready
    bpl smart_missile_right
    ldx #$6f
    bne smart_missile_sprite_ready
smart_missile_right:
    ldx #$67
smart_missile_sprite_ready:
    txa
    sta $62c4,y
    lda $60ce
    sta $63fc,y
    lda #$00
    sta $6534,y
    lda #$00
    sta $6464,y
    lda $60a8
    sta $66d4,y
    lda $60af
    sta $673c,y
    cmp #$02
    bne smart_missile_store_lifetime
    lda $60bd
    eor #$01
    tax
    lda $6114,x
    bpl smart_missile_store_lifetime
    tya
    sta $6114,x
smart_missile_store_lifetime:
    lda #$7f
    sta $67a4,y
    clc
smart_missile_init_done:
    rts

initialize_smart_missile_end:
.assert initialize_smart_missile - selector5_start = $0bde, error, "smart-missile initialization origin drift"
.assert initialize_smart_missile_end - initialize_smart_missile = $0056, error, "smart-missile initialization size drift"

; Copy constructor workspace velocity/position fields into object Y. Interior
; entries allow callers to omit velocity or horizontal velocity.
copy_constructor_velocity_and_position:
    lda $60cf
    sta $64cc,y
copy_constructor_position:
    lda $60ce
    sta $63fc,y
copy_constructor_horizontal_position:
    lda $60cc
    sta $632c,y
    lda $60cd
    sta $6394,y
    rts

; Initialize a type-$13 object. The common routine entry begins at the allocator;
; the preceding entry preserves the caller's current object for link metadata.
initialize_type13_from_current_object:
    lda current_object
    sta $60
initialize_type13_object:
    jsr allocate_object_or_type0c_slot
    bcs type13_initialization_done
    ldx #$02
    cpy $60
    bcc type13_store_order
    dex
type13_store_order:
    txa
    sta $673c,y
    lda #$13
    sta $6124,y
    lda #$02
    sta $618c,y
    jsr copy_constructor_position
    lda $60a8
    sta $66d4,y
    lda #$f1
    sta $62c4,y
    lda #$02
    sta $6464,y
    lda #$ff
    sta $666c,y
type13_initialization_done:
    rts

; Clamp signed A to -1, 0, or +1.
signed_unit_clamp:
    cmp #$00
    bmi signed_unit_negative
    beq signed_unit_done
    lda #$01
signed_unit_done:
    rts
signed_unit_negative:
    lda #$ff
    rts

; Initialize a type-$15 smoke object using the source object's sprite selector.
initialize_type15_smoke:
    jsr allocate_object_or_type0c_slot
    bcs type15_smoke_done
    lda #$15
    sta $6124,y
    lda #$02
    sta $618c,y
    jsr copy_constructor_position
    lda $60a8
    sta $673c,y
    tax
    lda $78b0,x
    sta $62c4,y
    lda #$ff
    sta $666c,y
    lda #$04
    sta $66d4,y
    lda #$01
    sta $6464,y
type15_smoke_done:
    rts

constructor_helpers_source_end:
.assert copy_constructor_velocity_and_position - selector5_start = $0c34, error, "constructor copier origin drift"
.assert copy_constructor_position - selector5_start = $0c3a, error, "constructor position entry drift"
.assert initialize_type13_object - selector5_start = $0c52, error, "type-13 constructor entry drift"
.assert signed_unit_clamp - selector5_start = $0c85, error, "signed clamp origin drift"
.assert initialize_type15_smoke - selector5_start = $0c91, error, "type-15 constructor origin drift"
.assert constructor_helpers_source_end - copy_constructor_velocity_and_position = $008c, error, "constructor helper source size drift"

; Initialize the type-$16/$17 bunker variants. Type $17 is the unique fixed
; armed bunker recorded per side in $60FA; type $16 is stage-optional.
initialize_bunker_variant:
    lda $60cc
    lsr
    lsr
    lsr
    bpl bunker_variant_side_ready
    lda #$00
bunker_variant_side_ready:
    sta $60bd
    lda #$80
    sta $60b3
    jsr $76b9
    lda $60a7
    cmp #$17
    bne bunker_variant_count_object
    ldx $60bd
    tya
    sta $60fa,x
bunker_variant_count_object:
    inc $6118,x
    inc $611c,x
    rts

initialize_bunker_variant_end:
.assert initialize_bunker_variant - selector5_start = $0cc0, error, "bunker-variant initialization origin drift"
.assert initialize_bunker_variant_end - initialize_bunker_variant = $002a, error, "bunker-variant initialization size drift"

; Type-$1C wraps the shared type-$18 constructor and advances the source
; object's sprite when the constructed object's side is nonzero.
initialize_type1c_object:
    jsr initialize_type18_object
    bcs type1c_initialization_done
    lda $6604,y
    beq type1c_initialization_done
    ldx current_object
    inc $62c4,x
type1c_initialization_done:
    rts

initialize_type14_object:
    jsr initialize_type18_object
    bcs type14_initialization_done
    lda #$01
    sta $66d4,y
    lda #$08
    sta $673c,y
    lda $60cf
    sta $64cc,y
    lda #$45
    sta $62c4,y
type14_initialization_done:
    rts

initialize_type1d_object:
    lda $60a8
    cmp #$1a
    beq initialize_type14_object
initialize_type18_object:
    lda current_object
    sta $60
    lda #$80
    sta $60b3
    jsr construct_object_from_workspace
    bcs type18_initialization_done
    lda #$03
    sta $66d4,y
    lda #$00
    cpy $60
    bcs type18_store_order
    lda #$01
type18_store_order:
    sta $673c,y
    lda $60a8
    sta $67a4,y
    clc
type18_initialization_done:
    rts

; Type-$19 is falling infantry emitted by the player drop/ejection paths. It
; uses the infantry allocation path, then specializes its sprite, integrity,
; descent, and parachute countdown. A zero entropy low nibble leaves countdown
; zero, so the parachute never opens and ground contact destroys the object.
initialize_type19_object:
    lda #$00
    sta $60e1
    jsr initialize_infantry
    bcs type19_initialization_done
    lda $60ce
    cmp #$dd
    beq type19_initialization_done
    ldy current_object
    sta $63fc,y
    lda #$19
    sta $6124,y
    lda $60bd
    clc
    adc #$5f
    sta $62c4,y
    lda #$00
    sta $6464,y
    lda #$03
    sta $659c,y
    lda #$02
    sta $6534,y
    lda $60ce
    cmp #$ab
    lda $60e7
    and #$0f
    beq type19_store_lifetime
    and #$07
    bcc type19_add_lifetime_base
    and #$03
type19_add_lifetime_base:
    adc #$03
type19_store_lifetime:
    sta $67a4,y
type19_initialization_done:
    rts

; Stage-controlled type-$1A alternate player projectile. It carries 21 damage,
; starts at signed horizontal velocity -1/+1, and supplies its own sprite bank.
initialize_type1a_object:
    lda #$15
    sta $60b3
    jsr construct_object_from_workspace
    bcs type1a_initialization_done
    lda #$03
    sta $6464,y
    ldx #$67
    lda $60cf
    sta $64cc,y
    bpl type1a_store_sprite
    ldx #$6f
type1a_store_sprite:
    txa
    sta $62c4,y
    lda $60ce
    sta $63fc,y
type1a_initialization_done:
    rts

; Common constructor entry: A may supply the object type through the interior
; entry at $76B6; the ordinary entry consumes the type already in $60A7.
construct_object_type_a:
    sta $60a7
construct_object_from_workspace:
    jsr allocate_object
    bcs construct_object_done
    lda $60bd
    sta $6604,y
    lda $60b3
    sta $659c,y
    lda $60a7
    sta $6124,y
    tax
    lda $78d0,x
    sta $618c,y
    lda $78b3,x
    sta $666c,y
    lda $78ed,x
    sta $62c4,y
    jsr copy_constructor_horizontal_position
    lda #$dd
    sta $63fc,y
    lda #$00
    sta $66d4,y
    sta $673c,y
    sta $67a4,y
    sta $64cc,y
    sta $6534,y
    lda #$01
    sta $6874,y
    lda object_active_list_flags,x
    beq construct_object_done
    jsr object_finalize_jump
    ldy current_object
construct_object_done:
    ldx $60bd
    rts

; Create the fixed per-side battlefield structures described by the tables at
; $790B-$7922, plus the optional type-$04 and three type-$16 objects.
initialize_fixed_battlefield_objects:
    lda #$ff
    sta $6106
    sta $6107
    lda #$05
initialize_next_fixed_object:
    pha
    tay
    and #$01
    sta $60bd
    lda $790b,y
    sta $60a7
    lda $7911,y
    sta $60cd
    lda $7917,y
    sta $60cc
    jsr object_constructor_jump
    pla
    sec
    sbc #$01
    bpl initialize_next_fixed_object
    lda $4060
    sta $60e8
    beq initialize_type16_objects
    lda #$07
    sta $60cc
    lda #$f2
    sta $60cd
    lda #$04
    sta $60a7
    jsr object_constructor_jump
initialize_type16_objects:
    lda #$02
initialize_next_type16_object:
    pha
    tay
    lda #$ff
    sta $60be,y
    lda $4061,y
    beq skip_type16_object
    lda $791d,y
    sta $60cc
    lda $7920,y
    sta $60cd
    lda #$16
    sta $60a7
    jsr object_constructor_jump
    pla
    pha
    tax
    tya
    sta $60be,x
skip_type16_object:
    pla
    sec
    sbc #$01
    bpl initialize_next_type16_object
fixed_battlefield_objects_done:
    rts

; Decode the current campaign's compact formation stream and create one or four
; units per record, spacing each unit three horizontal coordinates apart.
initialize_campaign_formations:
    ldy $05
    ldx $79f2,y
    lda $792d,x
    beq fixed_battlefield_objects_done
    sta $79fd
    lda #$00
    sta $60bd
    txa
    sec
    adc $792d,x
    tay
    stx $79fe
    sty $79ff
initialize_next_formation_record:
    dec $79fd
    bmi fixed_battlefield_objects_done
    inc $79fe
    ldx $79fe
    lda $792d,x
    ldx #$03
match_formation_object_code:
    cmp $7925,x
    beq formation_object_code_matched
    dex
    bpl match_formation_object_code
    inx
formation_object_code_matched:
    lda $7929,x
    sta $60a7
    ldx #$01
    cmp #$0d
    bne formation_count_ready
    ldx #$04
formation_count_ready:
    ldy $79ff
    inc $79ff
    lda #$00
    sta $60cd
    lda $792d,y
    lsr a
    ror $60cd
    lsr a
    ror $60cd
    lsr a
    ror $60cd
    lsr a
    ror $60cd
    sta $60cc
    sta $61
    lda $60cd
    sta $60
    lsr $61
    ror $60
    lsr $61
    ror $60
    lda $60cd
    sec
    sbc $60
    sta $60cd
    lda $60cc
    sbc $61
    adc #$01
    sta $60cc
    txa
initialize_next_formation_unit:
    pha
    lda #$00
    sta $60e1
    jsr object_constructor_jump
    lda $60cd
    clc
    adc #$03
    sta $60cd
    bcc formation_position_ready
    inc $60cc
formation_position_ready:
    pla
    sec
    sbc #$01
    bne initialize_next_formation_unit
    jmp initialize_next_formation_record

object_list_noop:
    rts

; Insert the current object at the appropriate end of the active list according
; to bit 3 of its high horizontal coordinate, then finish position setup. The
; final JMP operand overlaps the constructor pointer table at $7875-$7876.
link_current_object_active:
    ldy current_object
    lda $632c,y
    and #$08
    bne link_current_object_at_tail
    ldx $60df
    txa
    sta $61f4,y
    lda $625c,x
    sta $625c,y
    sta $60e2
    tya
    sta $625c,x
    ldy $60e2
    sta $61f4,y
    jmp finish_position_update
link_current_object_at_tail:
    ldx current_object
    ldy $60e0
    tya
    sta $625c,x
    lda $61f4,y
    sta $61f4,x
    sta $60e1
    txa
    sta $61f4,y
    ldy $60e1
    sta $625c,y
    jmp finish_position_update

constructor_core_source_end:
.assert initialize_type1c_object - selector5_start = $0cea, error, "type-1C constructor origin drift"
.assert initialize_type18_object - selector5_start = $0d1d, error, "type-18 constructor origin drift"
.assert initialize_type19_object - selector5_start = $0d44, error, "type-19 constructor origin drift"
.assert construct_object_from_workspace - selector5_start = $0db9, error, "common constructor origin drift"
.assert initialize_fixed_battlefield_objects - selector5_start = $0e10, error, "fixed object initializer origin drift"
.assert initialize_campaign_formations - selector5_start = $0e86, error, "formation initializer origin drift"
.assert link_current_object_active - selector5_start = $0f30, error, "active-list insertion origin drift"
.assert constructor_core_source_end - initialize_type1c_object = $028d, error, "constructor core source size drift"

; Constructor pointers for object types $00-$1D. Type 0's pointer at
; $7875-$7876 is already emitted by the overlapping JMP operand above.
object_constructor_pointers = constructor_core_source_end-2
    .word $0000,$6fcf,$707b,$714b,$715d,$716f,$7192,$71d0,$722e,$724c
    .word $7286,$72e9,$736e,$73ac,$73dc,$7402,$74a2,$74de,$754d,$75fb
    .word $7591,$75c8,$75c0,$761d,$7644,$7690,$0000,$75ea,$7616

; Overlapping type-indexed constructor defaults. The first byte at $78B0 is
; also the high byte of the final constructor pointer above.
type15_source_sprites = object_constructor_pointers+59
    .byte $f1,$94
object_default_link_state:
    .byte $95,$ff,$09,$ff,$03,$01,$02,$02,$ff,$01,$ff,$ff,$ff,$02,$06
    .byte $06,$07,$ff,$06,$ff,$ff,$ff,$01,$01,$ff,$02,$07,$ff,$ff
object_default_update_state:
    .byte $ff,$00,$01,$02,$01,$01,$01,$01,$01,$01,$01,$01,$02,$01,$01
    .byte $01,$01,$02,$01,$02,$01,$02,$01,$01,$01,$01,$01,$01,$01
object_default_sprite:
    .byte $01,$ff,$ff,$ff,$36,$31,$ff,$ff,$f0,$18,$ff,$f1,$ff,$1d,$ff
    .byte $ff,$ff,$ff,$ff,$f1,$45,$ff,$56,$57,$5b,$5e,$ff,$ff,$61,$5c

fixed_object_types:
    .byte $17,$17,$05,$05,$04,$04
fixed_object_horizontal_low:
    .byte $30,$d0,$78,$88,$90,$70
fixed_object_horizontal_high:
    .byte $02,$0d,$02,$0d,$02,$0d
type16_horizontal_high:
    .byte $04,$07,$0b
type16_horizontal_low:
    .byte $a8,$f8,$68
fixed_object_table_residual:
    .byte $01,$ff
formation_record_codes:
    .byte $d6,$d4,$cd,$c1
formation_object_types:
    .byte $10,$0e,$0d,$0f

constructor_tables_source_end:
.assert object_constructor_pointers - selector5_start = $0f75, error, "constructor pointer table origin drift"
.assert type15_source_sprites - selector5_start = $0fb0, error, "overlapped constructor default origin drift"
.assert object_default_link_state - selector5_start = $0fb3, error, "default link table origin drift"
.assert object_default_update_state - selector5_start = $0fd0, error, "default update table origin drift"
.assert object_default_sprite - selector5_start = $0fed, error, "default sprite table origin drift"
.assert fixed_object_types - selector5_start = $100b, error, "fixed object table origin drift"
.assert formation_record_codes - selector5_start = $1025, error, "formation code table origin drift"
.assert constructor_tables_source_end - selector5_start = $102d, error, "constructor tables size drift"

; Compact formation records. Campaign offsets below select record-count and
; record-data runs consumed by initialize_campaign_formations.
campaign_formation_stream:
    .byte $00,$0c,$d6,$d6,$d4,$d4,$d4,$cd,$cd,$c1,$d4,$cd,$d4,$cd,$0f,$10
    .byte $27,$28,$29,$2a,$2b,$66,$67,$68,$69,$6a,$0f,$d6,$d6,$c1,$d4,$d4
    .byte $d4,$cd,$cd,$c1,$c1,$d4,$cd,$d4,$cd,$c1,$0f,$10,$26,$27,$28,$29
    .byte $2a,$2b,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$10,$d6,$d6,$c1,$d4,$d4,$d4
    .byte $c1,$cd,$cd,$c1,$d4,$d4,$d4,$cd,$cd,$cd,$0f,$10,$26,$27,$28,$29
    .byte $70,$71,$72,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$0e,$d6,$d6,$c1,$d4,$d4
    .byte $d4,$c1,$d4,$cd,$cd,$c1,$cd,$cd,$cd,$0f,$10,$26,$27,$28,$29,$70
    .byte $71,$72,$73,$b6,$b7,$b8,$b9,$ba,$11,$d6,$d6,$c1,$d4,$d4,$d4,$cd
    .byte $c1,$c1,$cd,$d4,$cd,$c1,$cd,$cd,$cd,$c1,$30,$31,$38,$39,$3a,$3b
    .byte $3c,$3d,$60,$66,$70,$71,$72,$73,$bb,$bc,$bd,$be,$bf,$c0,$12,$d6
    .byte $d6,$c1,$d4,$d4,$d4,$cd,$c1,$c1,$c1,$d4,$cd,$d4,$cd,$c1,$cd,$cd
    .byte $cd,$60,$61,$76,$77,$78,$79,$7a,$a3,$a9,$b6,$b7,$b8,$b9,$ba,$d8
    .byte $df,$e0,$e1,$e2,$e3
campaign_formation_offsets:
    .byte $00,$00,$00,$01,$1a,$39,$5a,$78,$9e
formation_workspace:
    .byte $00,$00,$00,$00,$00

formation_tables_source_end:
.assert campaign_formation_stream - selector5_start = $102d, error, "formation stream origin drift"
.assert campaign_formation_offsets - selector5_start = $10f2, error, "formation offset table origin drift"
.assert formation_workspace - selector5_start = $10fb, error, "formation workspace origin drift"
.assert formation_tables_source_end - selector5_start = $1100, error, "formation tables size drift"

; Object-update module entry table.
object_update_module_initialize_jump:
    jmp object_update_noop
object_update_module_reset_jump:
    jmp reset_object_update_timers
object_update_module_stage_jump:
    jmp object_update_noop
object_update_module_tick_jump:
    jmp update_all_objects
finish_position_update:
    jmp repair_active_object_order
stationary_gun_projectile_jump:
    jmp compute_stationary_gun_projectile
integrate_horizontal_position_jump:
    jmp integrate_horizontal_position

reset_object_update_timers:
    lda #$37
    sta $6022
    lda #$5a
    sta $6023
object_update_noop:
    rts

; Maintain the long-period counters, run input/secondary updates, dispatch each
; occupied object through its type handler, then run collision processing.
; The $6022 period adds one bag to each side every 56 completed calls and
; saturates the two $6116/$6117 cash bytes at 255.
update_all_objects:
    dec $6022
    bpl update_score_timer
    lda #$37
    sta $6022
    inc $6116
    bne update_secondary_counter
    dec $6116
update_secondary_counter:
    inc $6117
    bne update_score_timer
    dec $6117
update_score_timer:
    dec $6023
    bne dispatch_object_updates
    lda #$5a
    sta $6023
    lda $0f
    cmp #$90
    bcs dispatch_object_updates
    sed
    lda $0e
    clc
    adc #$99
    sta $0e
    lda $0f
    adc #$99
    sta $0f
    cld
dispatch_object_updates:
    jsr input_module_dispatch_jump
    jsr secondary_module_tick_jump
    lda #$67
dispatch_next_object_update:
    pha
    tay
    lda $6124,y
    beq advance_object_update
    sty current_object
    asl a
    tax
    lda $8467,x
    sta object_update_call+1
    lda $8468,x
    sta object_update_call+2
object_update_call:
    jsr $1234
advance_object_update:
    pla
    sec
    sbc #$01
    bpl dispatch_next_object_update
    jmp $ac09

set_side_horizontal_velocity:
    ldx $6604,y
    lda $84a4,x
    bne store_side_horizontal_velocity
    ldx $6604,y
    lda $84a3,x
store_side_horizontal_velocity:
    sta $64cc,y

; Apply signed horizontal velocity and repair active-list order when required.
integrate_horizontal_position:
    ldy current_object
    ldx #$00
    lda $64cc,y
    bpl horizontal_velocity_extended
    dex
horizontal_velocity_extended:
    clc
    adc $6394,y
    sta $6394,y
    txa
    adc $632c,y
    and #$0f
    sta $632c,y
    ldx $6124,y
    lda object_active_list_flags,x
    bne repair_active_object_order
    rts

; Move the current object backward or forward through the X-sorted doubly
; linked active list until its 12-bit horizontal coordinate is ordered.
repair_active_object_order:
    ldy current_object
    ldx $61f4,y
    lda $632c,x
    cmp $632c,y
    bcc scan_active_object_forward
    bne swap_active_object_backward
    lda $6394,x
    cmp $6394,y
    bcc scan_active_object_forward
    beq scan_active_object_forward
swap_active_object_backward:
    lda $61f4,x
    sta $60e1
    sta $61f4,y
    lda $625c,y
    sta $60e2
    sta $625c,x
    txa
    sta $625c,y
    tya
    sta $61f4,x
    ldy $60e1
    sta $625c,y
    txa
    ldx $60e2
    sta $61f4,x
    jmp repair_active_object_order
scan_active_object_forward:
    ldy current_object
    ldx $625c,y
    lda $632c,y
    cmp $632c,x
    bcc active_object_order_done
    bne swap_active_object_forward
    lda $6394,y
    cmp $6394,x
    bcc active_object_order_done
    beq active_object_order_equal
swap_active_object_forward:
    lda $61f4,y
    sta $60e1
    sta $61f4,x
    lda $625c,x
    sta $60e2
    sta $625c,y
    tya
    sta $625c,x
    txa
    sta $61f4,y
    ldx $60e1
    sta $625c,x
    tya
    ldy $60e2
    sta $61f4,y
    jmp scan_active_object_forward
active_object_order_equal:
    clc
active_object_order_done:
    rts

object_update_signed_unit:
    cmp #$00
    bmi object_update_signed_negative
    beq object_update_signed_done
    lda #$01
object_update_signed_done:
    rts
object_update_signed_negative:
    lda #$ff
    rts

; Periodically animate and replenish the infantry count associated with this
; structure while its stored capacity remains at least two.
update_infantry_producer:
    lda $60c1
    eor current_object
    and #$01
    ora $6874,y
    beq producer_check_capacity
    lda $632c,y
    lsr a
    lsr a
    and #$02
    ora $6604,y
    eor #$03
    clc
    adc #$14
    sta $62c4,y
producer_check_capacity:
    lda $67a4,y
    beq producer_capacity_finished
    pha
    lda $659c,y
    cmp #$2f
    bcs producer_capacity_ready
    adc #$01
    sta $659c,y
producer_capacity_ready:
    pla
producer_capacity_finished:
    cmp #$02
    bcc infantry_producer_done
    lda $60c1
    eor current_object
    and #$07
    bne infantry_producer_done
    lda $67a4,y
    sbc #$01
    sta $67a4,y
    lda $6394,y
    clc
    adc #$06
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    ldx $6604,y
    stx $60bd
    lda #$0d
    sta $60a7
    lda #$00
    sta $60e1
    dec $6118,x
    dec $611e,x
    jmp object_constructor_jump
infantry_producer_done:
    rts

; Move vertically toward the linked object's target height, with a slower step
; in the ordinary state and randomized target refreshes.
update_linked_vertical_motion:
    lda #$02
    ldx $6874,y
    bne linked_vertical_step_ready
    lda $60c1
    eor current_object
    and #$01
    beq linked_vertical_motion_done
    lda #$04
linked_vertical_step_ready:
    sta $61
    lda $67a4,y
    ora $66d4,y
    bpl linked_vertical_has_target
    lda $63fc,y
    sec
    sbc $61
    sta $63fc,y
    cmp #$24
    bcs linked_vertical_motion_done
    jmp $813e
linked_vertical_has_target:
    ldx $66d4,y
    lda $6604,x
    sta $6604,y
    lda $673c,y
    sec
    sbc $63fc,y
    pha
    bcs linked_vertical_delta_ready
    eor #$ff
    adc #$01
linked_vertical_delta_ready:
    cmp $61
    pla
    bcc linked_vertical_apply_step
    jsr object_update_signed_unit
    asl a
    ldx $61
    cpx #$04
    bne linked_vertical_apply_step
    asl a
linked_vertical_apply_step:
    clc
    adc $63fc,y
    sta $63fc,y
    lda $60e7
    pha
    jsr selector5_random_byte_jump
    pla
    and #$0f
    bne linked_vertical_motion_done
    lda $60e7
    and #$3f
    sta $60
    lsr a
    adc $60
    adc #$53
    sta $673c,y
linked_vertical_motion_done:
    rts

; Follow a linked object's vertical position or converge the object's two
; vertical fields; destroy it when those fields cross.
update_linked_vertical_pair:
    lda $66d4,y
    ora $673c,y
    bmi vertical_pair_unlinked
    ldx $66d4,y
    lda $63fc,x
    sta $63fc,y
    lda $6604,x
    sta $6604,y
vertical_pair_done:
    rts
vertical_pair_unlinked:
    lda $66d4,y
    bpl vertical_pair_descend
    lda $63fc,y
    cmp #$27
    bcs vertical_pair_raise_lower_bound
    lda $6464,y
    sec
    sbc #$02
    sta $6464,y
    cmp $63fc,y
    bcs vertical_pair_done
destroy_vertical_pair:
    jmp $ac0c
vertical_pair_raise_lower_bound:
    lda $673c,y
    bpl vertical_pair_raise_position
    lda $6464,y
    clc
    adc #$02
    cmp #$dd
    bcc vertical_pair_store_lower_bound
    lda #$dd
vertical_pair_store_lower_bound:
    sta $6464,y
vertical_pair_raise_position:
    lda $63fc,y
    clc
    adc #$02
    sta $63fc,y
    cmp $6464,y
    bcs destroy_vertical_pair
    rts
vertical_pair_descend:
    lda $63fc,y
    cmp #$27
    bcc vertical_pair_lower_bound
    sbc #$02
    sta $63fc,y
vertical_pair_lower_bound:
    lda $6464,y
    sec
    sbc #$02
    sta $6464,y
    cmp $63fc,y
    bcc destroy_vertical_pair
    rts

object_update_core_source_end:
.assert object_update_module_initialize_jump - selector5_start = $1100, error, "object update module origin drift"
.assert update_all_objects - selector5_start = $1120, error, "object update loop origin drift"
.assert integrate_horizontal_position - selector5_start = $1196, error, "horizontal integration origin drift"
.assert repair_active_object_order - selector5_start = $11ba, error, "active-list repair origin drift"
.assert update_infantry_producer - selector5_start = $1250, error, "infantry producer origin drift"
.assert update_linked_vertical_motion - selector5_start = $12c3, error, "linked vertical motion origin drift"
.assert update_linked_vertical_pair - selector5_start = $133a, error, "linked vertical pair origin drift"
.assert object_update_core_source_end - selector5_start = $13ad, error, "object update module size drift"

; Compute type-$09 stationary gun's aimed type-$0B velocity toward target X.
; Target velocity receives a random prediction scale of 0/1, 4, or 8 before
; both position deltas are divided by eight. Vertical acceleration is +1 and
; the projectile carries five damage units.
compute_stationary_gun_projectile:
    lda $6394,x
    sec
    sbc $60cd
    sta $60
    lda $632c,x
    sbc $60cc
    sta $61
    ldy #$00
    lda $6534,x
    bpl stationary_target_vy_ready
    dey
stationary_target_vy_ready:
    sta $60d0
    sty $60d2
    lda $60e7
    bmi stationary_prediction_scale8
    and #$40
    beq stationary_prediction_ready
    lda $64cc,x
    jmp stationary_prediction_scale4
stationary_prediction_scale8:
    lda $64cc,x
    asl
    asl $60d0
    rol $60d2
stationary_prediction_scale4:
    asl
    asl $60d0
    rol $60d2
    asl
    asl $60d0
    rol $60d2
stationary_prediction_ready:
    sta $62
    ldy $6124,x
    lda $6935,y
    lsr
    sta $63
    lda $63fc,x
    sec
    sbc $63
    sbc #$1f
    clc
    adc $60d0
    sta $60d0
    lda #$00
    adc $60d2
    sta $60d2
    lda $60d0
    sec
    sbc $60ce
    sta $60d0
    lda $60d2
    sbc #$00
    lsr
    ror $60d0
    lsr
    ror $60d0
    lsr
    ror $60d0
    ldy $6124,x
    lda $6917,y
    lsr
    ldx #$00
    clc
    adc $62
    bpl stationary_predicted_x_ready
    dex
stationary_predicted_x_ready:
    clc
    adc $60
    sta $60
    txa
    adc $61
    lsr
    ror $60
    lsr
    ror $60
    lsr
    ror $60
    lda $60
    sta $60cf
    lda #$01
    sta $60a8
    lda #$05
    jmp create_type0b_projectile

stationary_gun_projectile_end:
.assert compute_stationary_gun_projectile - selector5_start = $13ad, error, "stationary gun projectile origin drift"
.assert stationary_gun_projectile_end - compute_stationary_gun_projectile = $00b2, error, "stationary gun projectile size drift"

; Type-$09 stationary-gun behavior. Mode zero acquires the opposing helicopter
; within 96 horizontal units; the alternate mode searches opposing type-$0E
; tanks. The shared fire check requires a same-page (<256) separation and
; runs on alternating (counter XOR object-slot) parity.
update_type09_stationary_gun:
    lda $659c,y
    cmp #$16
    beq stationary_gun_select_target
    lda $60c1
    and #$01
    adc $659c,y
    sta $659c,y
stationary_gun_select_target:
    ldx $66d4,y
    bne stationary_gun_find_tank
    jsr stationary_gun_find_helicopter
    bcs stationary_gun_target_found
stationary_gun_done:
    rts
stationary_gun_find_tank:
    jsr stationary_gun_find_type0e
    bcc stationary_gun_done
stationary_gun_target_found:
    lda $6874,y
    beq stationary_gun_fire_gate
    lda #$00
    sta $62
    lda $6394,y
    sec
    sbc $6394,x
    sta $60
    lda $632c,y
    sbc $632c,x
    sta $61
    bcs stationary_gun_distance_absolute
    lda #$02
    sta $62
    lda $60
    eor #$ff
    adc #$01
    sta $60
    lda $61
    eor #$ff
    adc #$00
    sta $61
stationary_gun_distance_absolute:
    lda $61
    bne stationary_gun_done
    lda $60
    cmp #$0f
    bcs stationary_gun_choose_angle
    lda #$1c
    bne stationary_gun_store_angle
stationary_gun_choose_angle:
    lda $63fc,y
    sec
    sbc $63fc,x
    lsr
    cmp $60
    lda #$18
    adc $62
stationary_gun_store_angle:
    sta $62c4,y
stationary_gun_fire_gate:
    lda $60c1
    eor current_object
    and #$01
    bne stationary_gun_done
    lda $6394,y
    clc
    adc #$03
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    lda $6604,y
    sta $60bd
    lda #$da
    sta $60ce
    jmp compute_stationary_gun_projectile

type09_stationary_gun_end:
.assert update_type09_stationary_gun - selector5_start = $145f, error, "type-09 stationary gun origin drift"
.assert type09_stationary_gun_end - update_type09_stationary_gun = $009a, error, "type-09 stationary gun size drift"

; Primary update for grounded infantry type $0D: settle it toward the ground,
; age its fire counter, process nearby player/structure interactions, and
; animate by side/direction.
update_ground_infantry:
    lda #$00
    sta $60af
    ldx current_object
    lda $63fc,x
    cmp #$dd
    beq ground_infantry_height_ready
    dec $63fc,x
ground_infantry_height_ready:
    lda $673c,x
    beq ground_infantry_counter_ready
    dec $673c,x
ground_infantry_counter_ready:
    jsr handle_ground_infantry_interactions
    ldy current_object
    lda $6124,y
    beq ground_infantry_update_done
    lda $60af
    bne ground_infantry_update_done
    ldx #$1d
    lda $64cc,y
    bmi ground_infantry_animation_base_ready
    ldx #$21
ground_infantry_animation_base_ready:
    stx $60
    lda $60c1
    adc current_object
    and #$03
    clc
    adc $60
    sta $60
    lda $6604,y
    beq ground_infantry_store_sprite
    lda #$08
ground_infantry_store_sprite:
    adc $60
    sta $62c4,y
ground_infantry_update_done:
    rts

; Resolve grounded infantry's nearby capturable-structure and player-helicopter
; interactions before falling through to ordinary targeting and motion.
handle_ground_infantry_interactions:
    lda $6394,y
    sec
    sbc #$01
    and #$03
    bne ground_infantry_check_player_pickup
    jsr find_nearby_structure
    bcc ground_infantry_check_player_pickup
    lda $659c,y
    cmp #$05
    bne ground_infantry_apply_structure_interaction
    lda $6124,x
    cmp #$17
    beq ground_infantry_check_type17_side
    lda $67a4,y
    bne ground_infantry_check_player_pickup
    lda $6604,y
    cmp $6604,x
    bne ground_infantry_apply_structure_interaction
    lda $6124,x
    cmp #$16
    beq ground_infantry_check_type16_value
    lda $67a4,x
    bne ground_infantry_check_player_pickup
    beq ground_infantry_apply_structure_interaction
ground_infantry_check_type16_value:
    lda $67a4,x
    cmp #$05
    bcs ground_infantry_check_player_pickup
    bcc ground_infantry_apply_structure_interaction
ground_infantry_check_type17_side:
    lda $632c,x
    lsr a
    lsr a
    lsr a
    cmp $6604,y
    bne ground_infantry_apply_structure_interaction
    lda $67a4,x
    bne ground_infantry_check_player_pickup
ground_infantry_apply_structure_interaction:
    jmp resolve_infantry_structure_interaction

ground_infantry_check_player_pickup:
    jsr find_grounded_player_behind
    bcc ground_infantry_update_motion
    ldy current_object
    ldx $6027
    lda $6604,y
    cmp $6604,x
    bne ground_infantry_enemy_player
    tax
    lda $6100,x
    cmp #$05
    beq ground_infantry_update_motion
    ldy current_object
    ldx $6604,y
    inc $6118,x
    inc $611e,x
    inc $6100,x
    lda #$ff
    sta $680c,y
    jmp $ac0c
ground_infantry_enemy_player:
    lda $6604,x
    tax
    lda $6104,x
    bne ground_infantry_update_motion
    lda current_object
    pha
    lda $6027
    sta current_object
    jsr $ac0c
    pla
    sta current_object
    rts

ground_infantry_update_motion:
    ldy current_object
    lda $673c,y
    bne ground_infantry_apply_velocity
    lda $6874,y
    beq ground_infantry_try_fire
    jmp $820c
ground_infantry_try_fire:
    lda $67a4,y
    beq ground_infantry_integrate_motion
    jsr $83d8
    bcs shared_weapon_update_done
ground_infantry_integrate_motion:
    jmp $7a8d
ground_infantry_apply_velocity:
    lda #$01
    ldx $6874,y
    beq ground_infantry_set_side_velocity
    bpl ground_infantry_positive_velocity
    lda #$ff
ground_infantry_positive_velocity:
    sta $64cc,y
    jmp integrate_horizontal_position_jump
ground_infantry_set_side_velocity:
    jmp $7a85

; Primary tank update: restore integrity slowly, settle to ground, animate by
; side, and dispatch its weapon when the state and cooldown permit.
update_tank:
    lda $6394,y
    ora $632c,y
    bne tank_position_nonzero
    jmp $813e
tank_position_nonzero:
    tya
    eor $60c1
    and #$1f
    bne tank_integrity_ready
    lda $659c,y
    cmp #$0f
    bcs tank_integrity_ready
    adc #$01
    sta $659c,y
tank_integrity_ready:
    lda $63fc,y
    cmp #$dd
    beq tank_height_ready
    sbc #$01
    sta $63fc,y
tank_height_ready:
    lda $673c,y
    beq tank_cooldown_ready
    ldx current_object
    dec $673c,x
tank_cooldown_ready:
    lda $6604,y
    asl a
    adc #$2d
    sta $62c4,y
    lda $6874,y
    beq tank_animate
    lda $673c,y
    beq tank_dispatch_weapon
shared_weapon_update_done:
    rts
tank_dispatch_weapon:
    jmp dispatch_tank_weapon
tank_animate:
    lda $60c1
    and #$01
    clc
    adc $62c4,y
    sta $62c4,y
    jmp $7a8d

ground_infantry_and_tank_source_end:
.assert update_ground_infantry - selector5_start = $14f9, error, "ground infantry update origin drift"
.assert handle_ground_infantry_interactions - selector5_start = $1548, error, "ground infantry interaction origin drift"
.assert update_tank - selector5_start = $161a, error, "tank update origin drift"
.assert ground_infantry_and_tank_source_end - update_ground_infantry = $017d, error, "ground infantry/tank source size drift"

; Type-$0F anti-air missile carrier. Every fourth (counter XOR slot) value it
; can launch one type-$12 missile at the active opposing helicopter when no
; linked missile exists and absolute horizontal separation is below $0100.
update_missile_carrier:
    lda $60c1
    eor current_object
    and #$03
    bne missile_carrier_idle
    lda $6604,y
    sta $60bd
    eor #$01
    tax
    lda $6104,x
    bne missile_carrier_idle
    lda $6114,x
    bpl missile_carrier_idle
    lda $6112,x
    tax
    lda $6394,x
    sec
    sbc $6394,y
    lda $632c,x
    sbc $632c,y
    bcs missile_carrier_distance_ready
    lda $6394,y
    sec
    sbc $6394,x
    lda $632c,y
    sbc $632c,x
missile_carrier_distance_ready:
    bne missile_carrier_idle
    lda $60bd
    asl
    asl
    asl
    adc $6394,y
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    lda #$d9
    sta $60ce
    stx $60a8
    lda #$02
    sta $60af
    lda #$00
    sta $60cf
    sta $60d0
    lda #$12
    sta $60a7
    jsr object_constructor_jump
    ldy current_object
    lda #$00
    sta $680c,y
    jmp $ac0c
missile_carrier_idle:
    lda #$06
    jsr $7ff9
    jmp $7a8d

missile_carrier_update_end:
.assert update_missile_carrier - selector5_start = $1676, error, "missile carrier origin drift"
.assert missile_carrier_update_end - update_missile_carrier = $0083, error, "missile carrier size drift"

; Animate a ground vehicle, settle it toward ground level, and slowly restore
; integrity up to the limit supplied in A.
update_ground_vehicle_integrity:
    sta $60
    tya
    eor $60c1
    pha
    and #$01
    clc
    adc $67a4,y
    sta $62c4,y
    lda $63fc,y
    cmp #$dd
    beq ground_vehicle_height_ready
    sbc #$01
    sta $63fc,y
ground_vehicle_height_ready:
    pla
    and #$3f
    bne ground_vehicle_integrity_done
    lda $659c,y
    cmp $60
    bcs ground_vehicle_integrity_done
    adc #$01
    sta $659c,y
ground_vehicle_integrity_done:
    rts

; Type-$10 demolition vehicle arrival handler. Reaching the opposing linked
; objective sets the battle-completion flags and destroys that objective.
update_demolition_vehicle:
    lda #$09
    jsr update_ground_vehicle_integrity
    lda $60c6
    bne demolition_vehicle_done
    lda $6394,y
    clc
    adc #$04
    and #$07
    bne demolition_vehicle_continue_motion
    lda $6604,y
    eor #$01
    tax
    stx $60
    lda $6106,x
    tax
    lda $6394,x
    clc
    adc #$04
    sta $61
    lda $632c,x
    adc #$00
    cmp $632c,y
    bne demolition_vehicle_continue_motion
    lda $6394,y
    cmp $61
    bne demolition_vehicle_continue_motion
    lda $6604,y
    sta $60c6
    eor #$01
    ora $60b0
    sta $60b0
    lda #$f0
    sta $60c7
    ldx $60
    lda current_object
    pha
    lda $60f2,x
    sta current_object
    tax
    lda #$00
    sta $680c,x
    jsr $ac0c
    pla
    sta current_object
    inc $60c6
    lda $60b6
    bne demolition_vehicle_done
    lda $60c6
    cmp #$02
    beq demolition_vehicle_done
    inc $60b0
demolition_vehicle_done:
    rts
demolition_vehicle_continue_motion:
    jmp $7a8d

; Find a type-$06/$16/$17 object exactly five horizontal units behind Y.
find_nearby_structure:
    lda $6394,y
    sec
    sbc #$05
    sta $60
    lda $632c,y
    sbc #$00
    sta $61
    ldx #$67
scan_nearby_structure:
    lda $6124,x
    cmp #$06
    beq check_nearby_structure_position
    cmp #$16
    beq check_nearby_structure_position
    cmp #$17
    beq check_nearby_structure_position
advance_nearby_structure:
    dex
    bpl scan_nearby_structure
    clc
    rts
check_nearby_structure_position:
    lda $6394,x
    cmp $60
    bne advance_nearby_structure
    lda $632c,x
    cmp $61
    bne advance_nearby_structure
    rts

; Apply the infantry/structure interaction selected above. An enemy soldier
; consumes one stored unit; an empty opposing structure changes owner; a
; friendly or capturing soldier increments the structure's stored capacity.
resolve_infantry_structure_interaction:
    ldy current_object
    lda $67a4,x
    beq transfer_structure_ownership
    lda $6604,y
    cmp $6604,x
    beq increment_structure_value
    dec $67a4,x
    lda $6604,x
    tax
    dec $6118,x
    dec $611e,x
    dec $60af
    lda #$00
    sta $680c,y
    jmp $ac0c
transfer_structure_ownership:
    lda $6604,y
    cmp $6604,x
    beq increment_structure_value
    sta $6604,x
    stx $60
    eor #$01
    tax
    dec $6118,x
    dec $611c,x
    sty $61
    ldy $05
    lda capture_strategy_delays,y
    sta $60ad,x
    ldy $61
    ldx $6604,y
    inc $6118,x
    inc $611c,x
    ldx $60
increment_structure_value:
    inc $67a4,x
    lda $6124,x
    cmp #$17
    beq destroy_current_update_object
    ldx $6604,y
    inc $6118,x
    inc $611e,x
destroy_current_update_object:
    lda #$ff
    sta $680c,y
    jmp $ac0c

ground_vehicle_interactions_source_end:
.assert update_ground_vehicle_integrity - selector5_start = $16f9, error, "ground vehicle helper origin drift"
.assert update_demolition_vehicle - selector5_start = $1727, error, "demolition vehicle origin drift"
.assert find_nearby_structure - selector5_start = $17a2, error, "nearby structure search origin drift"
.assert resolve_infantry_structure_interaction - selector5_start = $17d6, error, "infantry structure interaction origin drift"
.assert destroy_current_update_object - selector5_start = $183e, error, "update destruction origin drift"
.assert ground_vehicle_interactions_source_end - update_ground_vehicle_integrity = $014d, error, "ground vehicle interaction source size drift"

; Object type $0E tank weapon dispatcher. Its ordinary type-$0B branch carries five
; damage. When state bit 1 is set, the random branch carries 15 when bits $70
; are clear, otherwise ($60E7 & 3) + 1 + the random helper's carry: 1..5.
; Other state combinations emit object type $1C instead.
dispatch_tank_weapon:
    lda #$03
    sta $673c,y
    lda $66d4,y
    lsr
    bcs fire_type1c_projectile
    lsr
    bcs prepare_tank_projectile
    lda $05
    eor #$01
    beq prepare_tank_projectile
    lda $60c1
    eor current_object
    and #$03
    beq fire_type1c_projectile
prepare_tank_projectile:
    php
    lda $6604,y
    sta $60bd
    tax
    eor #$01
    beq tank_horizontal_origin_ready
    lda $6925
tank_horizontal_origin_ready:
    sec
    adc $6394,y
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    lda $60cd
    bne tank_origin_nonzero
    dec $60cc
tank_origin_nonzero:
    dec $60cd
    lda tank_projectile_direction,x
    asl
    sta $60cf
    lda #$00
    sta $60d0
    sta $60a8
    lda #$05
    ldx #$d9
    plp
    bcc tank_store_projectile
    asl $60cf
    jsr $6906
    and #$70
    bne tank_random_damage
    lda #$0f
    bne tank_random_damage_ready
tank_random_damage:
    lda $60e7
    and #$03
    adc #$01
tank_random_damage_ready:
    ldx #$d3
tank_store_projectile:
    stx $60ce
    jmp create_type0b_projectile

fire_type1c_projectile:
    lda #$1c
    sta $60a7
    lda $6925
    ldx $6604,y
    stx $60bd
    beq type1c_origin_ready
    ldx #$ff
    lda $6933
    eor #$ff
type1c_origin_ready:
    clc
    adc $6394,y
    sta $60cd
    txa
    adc $632c,y
    sta $60cc
    jmp object_constructor_jump

tank_weapon_dispatch_end:
.assert dispatch_tank_weapon - selector5_start = $1846, error, "tank weapon dispatch origin drift"
.assert tank_weapon_dispatch_end - dispatch_tank_weapon = $00a2, error, "tank weapon dispatch size drift"

; Count down a timed object's state, select its terminal sprite from the
; type-indexed table when available, or destroy it when the state expires.
update_timed_sprite_object:
    lda $673c,y
    beq timed_sprite_update_done
    sec
    sbc #$01
    sta $673c,y
    bne timed_sprite_update_done
    ldx $66d4,y
    cpx #$0a
    bcs destroy_timed_sprite_object
    cpx #$05
    bcc destroy_timed_sprite_object
    lda $84a1,x
    bne store_timed_object_sprite
destroy_timed_sprite_object:
    jmp $ac0c
store_timed_object_sprite:
    sta $62c4,y
timed_sprite_update_done:
    rts

timed_sprite_source_end:
.assert update_timed_sprite_object - selector5_start = $18e8, error, "timed sprite update origin drift"
.assert timed_sprite_source_end - update_timed_sprite_object = $0024, error, "timed sprite update size drift"

; Emit the fixed one-damage type-$0B projectile selected by grounded infantry
; object type $0D. Its horizontal direction follows $6874,Y.
fire_damage_one_projectile:
    lda #$03
    sta $673c,y
    ldx #$ff
    lda $6874,y
    bpl damage_one_direction_ready
    ldx #$01
damage_one_direction_ready:
    txa
    sta $64cc,y
    asl
    sta $60cf
    lda #$d9
    sta $60ce
    lda $6394,y
    sta $60cd
    lda $632c,y
    sta $60cc
    lda #$00
    sta $60d0
    sta $60a8
    lda $6604,y
    sta $60bd
    lda #$01
create_type0b_projectile:
    sta $60b3
    lda #$0b
    sta $60a7
    jmp object_constructor_jump

damage_one_projectile_end:
.assert fire_damage_one_projectile - selector5_start = $190c, error, "damage-one projectile origin drift"
.assert damage_one_projectile_end - fire_damage_one_projectile = $0042, error, "damage-one projectile size drift"

; Find either grounded player helicopter exactly five horizontal units behind
; the current object. On success, $6027 records the player object index.
find_grounded_player_behind:
    ldy current_object
    ldx #$00
    jsr test_grounded_player_behind
    bcs grounded_player_search_done
    ldx #$01
test_grounded_player_behind:
    lda $6104,x
    bne grounded_player_not_found
    lda $6112,x
    tax
    lda $63fc,x
    cmp #$dd
    bne grounded_player_not_found
    stx $6027
    lda $6394,x
    clc
    adc #$05
    sta $60
    lda $632c,x
    adc #$00
    cmp $632c,y
    bne grounded_player_not_found
    lda $60
    cmp $6394,y
    beq grounded_player_search_done
grounded_player_not_found:
    clc
grounded_player_search_done:
    rts

; Type-$19 falling-infantry update across parachute, landing, and grounded
; transition states. Landing can convert it to ordinary type-$0D infantry.
update_falling_infantry_object:
    lda $63fc,y
    cmp #$dd
    bne update_airborne_infantry
    lda $67a4,y
    bmi infantry_ground_state
    lda #$00
    sta $680c,y
    jmp $ac0c
infantry_ground_state:
    lda $6464,y
    bpl infantry_mark_ground_state
    lda #$00
    sta $6874,y
    lda #$0d
    sta $6124,y
    lda $659c,y
    clc
    adc #$02
    sta $659c,y
    lda #$00
    sta $67a4,y
    jmp update_ground_infantry
infantry_mark_ground_state:
    lda #$ff
    sta $6464,y
    lda $04
    bne infantry_update_done
    lda $6604,y
    beq infantry_update_done
    lda #$a4
    sta $62c4,y
infantry_update_done:
    rts

update_airborne_infantry:
    ldx #$02
    lda $67a4,y
    bmi airborne_infantry_step_ready
    beq airborne_infantry_use_fast_step
    sec
    sbc #$01
    bne airborne_infantry_store_state
    lda #$ff
airborne_infantry_store_state:
    sta $67a4,y
airborne_infantry_use_fast_step:
    ldx #$04
airborne_infantry_step_ready:
    txa
    clc
    adc $63fc,y
    cmp #$dc
    bcc airborne_infantry_store_height
    lda #$dd
airborne_infantry_store_height:
    sta $63fc,y
    lda #$5d
    ldx $67a4,y
    bpl airborne_infantry_done
    ldx $6604,y
    beq airborne_infantry_store_sprite
    eor $60c1
    eor current_object
    and #$01
    clc
    adc $6464,y
    and #$03
    sta $6464,y
    tax
    lda airborne_infantry_sprites,x
airborne_infantry_store_sprite:
    sta $62c4,y
airborne_infantry_done:
    rts

update_lifetime_countdown:
    ldx current_object
    lda $673c,x
    bne decrement_lifetime_countdown
    jmp $ac0c
decrement_lifetime_countdown:
    dec $673c,x
    rts

infantry_update_source_end:
.assert find_grounded_player_behind - selector5_start = $194e, error, "grounded player search origin drift"
.assert update_falling_infantry_object - selector5_start = $1988, error, "falling infantry update origin drift"
.assert update_lifetime_countdown - selector5_start = $1a18, error, "lifetime countdown origin drift"
.assert infantry_update_source_end - find_grounded_player_behind = $00d9, error, "falling infantry update source size drift"

; Acquire the active opposing helicopter when its absolute horizontal distance
; is below $60. A nonzero high byte rejects distances of $0100 or more.
stationary_gun_find_helicopter:
    lda $6604,y
    eor #$01
    tax
    lda $6104,x
    bne stationary_target_not_found
    lda $6112,x
    tax
    lda $6394,y
    sec
    sbc $6394,x
    sta $60
    lda $632c,y
    sbc $632c,x
    bcs stationary_helicopter_distance_ready
    lda $6394,x
    sec
    sbc $6394,y
    sta $60
    lda $632c,x
    sbc $632c,y
stationary_helicopter_distance_ready:
    bne stationary_target_not_found
    lda $60
    cmp #$60
    bcs stationary_target_not_found
    sec
    rts
stationary_target_not_found:
    clc
    rts

; Search the side-ordered object list for an opposing type-$0E tank beyond
; the side-specific coordinate threshold. Returns its slot in X with carry set.
stationary_gun_find_type0e:
    ldx $6604,y
    stx $60bd
    lda $6394,y
    clc
    adc stationary_type0e_threshold_low,x
    sta $60cd
    lda $632c,y
    adc stationary_type0e_threshold_high,x
    sta $60cc
    tya
    tax
    lda $60bd
    bne stationary_search_reverse
stationary_search_forward:
    lda $625c,x
    bmi stationary_type0e_not_found
    tax
    lda $632c,x
    cmp $60cc
    bcc stationary_forward_candidate
    bne stationary_type0e_not_found
    lda $6394,x
    cmp $60cd
    bcc stationary_forward_candidate
    bne stationary_type0e_not_found
stationary_forward_candidate:
    lda $6604,x
    cmp $60bd
    beq stationary_search_forward
    lda $6124,x
    cmp #$0e
    bne stationary_search_forward
    sec
    rts
stationary_search_reverse:
    lda $61f4,x
    bmi stationary_type0e_not_found
    tax
    lda $60cc
    cmp $632c,x
    bcc stationary_reverse_candidate
    bne stationary_type0e_not_found
    lda $60cd
    cmp $6394,x
    bcc stationary_reverse_candidate
    bne stationary_type0e_not_found
stationary_reverse_candidate:
    lda $6604,x
    cmp $60bd
    beq stationary_search_reverse
    lda $6124,x
    cmp #$0e
    bne stationary_search_reverse
    sec
    rts

stationary_target_helpers_end:
.assert stationary_gun_find_helicopter - selector5_start = $1a27, error, "stationary targeting helper origin drift"
.assert stationary_target_helpers_end - stationary_gun_find_helicopter = $00b1, error, "stationary targeting helper size drift"

; Prepare the stationary-gun target-search coordinate and enter the following
; search routine at its success/failure interior entries.
prepare_stationary_gun_target_search:
    lda $6394,y
    sec
    sbc #$02
    sta $60cd
    and #$03
    beq stationary_target_search
    lda $6464,y
    beq type11_target_not_found
    lda #$00
    sta $67a4,y

stationary_target_prep_source_end:
.assert prepare_stationary_gun_target_search - selector5_start = $1ad8, error, "stationary target prep origin drift"
.assert stationary_target_prep_source_end - prepare_stationary_gun_target_search = $0017, error, "stationary target prep size drift"
stationary_type0e_not_found:
type11_target_not_found:
    clc
    rts

; Search for a type-$11 object with link value 9 at the prepared coordinate.
; Alternate updates either arm its short counter or consume it and construct a
; type-$09 replacement owned by the current object's side.
stationary_target_search:
    lda $632c,y
    sbc #$00
    sta $60cc
    ldx #$67
restart_type11_target_search:
    lda #$11
scan_type11_target:
    cmp $6124,x
    beq check_type11_target
    dex
    bpl scan_type11_target
    clc
    rts
advance_type11_target:
    dex
    bpl restart_type11_target_search
    clc
    rts
check_type11_target:
    lda #$09
    cmp $66d4,x
    bne advance_type11_target
    lda $6394,x
    cmp $60cd
    bne advance_type11_target
    lda $632c,x
    cmp $60cc
    bne advance_type11_target
    lda $60c1
    lsr a
    bcs consume_type11_target
    lda #$03
    sta $67a4,x
    sec
    rts
consume_type11_target:
    lda #$01
    sta $6464,y
    dec $67a4,x
    bne stationary_target_found
    lda current_object
    pha
    stx current_object
    lda #$ff
    sta $680c,x
    lda $6464,x
    pha
    jsr $ac0c
    pla
    sta $60e3
    pla
    sta current_object
    tay
    lda #$09
    sta $60a7
    lda $6604,y
    sta $60bd
    jsr object_constructor_jump
    ldy current_object
stationary_target_found:
    sec
    rts

stationary_target_search_source_end:
.assert type11_target_not_found - selector5_start = $1aef, error, "stationary target failure origin drift"
.assert stationary_target_search - selector5_start = $1af1, error, "stationary target search origin drift"
.assert stationary_target_search_source_end - type11_target_not_found = $007a, error, "stationary target search size drift"

; Secondary behavior entries for object types $01-$1D. Type $00 is the
; overlapping word at $8467; the dispatcher indexes from that address, so this
; authored span deliberately begins with type $01. In particular, type $08
; points to linked vertical-pair update $7C3A, stationary gun $09 to $7D5F,
; grounded infantry $0D to $7DF9, tank $0E to $7F1A, AA carrier $0F to $7F76,
; demolition vehicle $10 to $8027, and falling infantry $19 to $8288.
secondary_behavior_handlers_type01:
    .word $7b4f,input_module_counter_jump,$850c,$850c,$850c,$7b50,$7bc3,$7c3a
    .word $7d5f,$850c,$850c,$850c,$7df9,$7f1a,$7f76,$8027
    .word $81e8,$850c,$850c,$850c,$850c,$850c,$850c,$850c
    .word $8288,$850c,$850c,$8318,$850c

secondary_behavior_handlers_end:
.assert secondary_behavior_handlers_type01 - selector5_start = $1b69, error, "secondary behavior table origin drift"
.assert secondary_behavior_handlers_end - secondary_behavior_handlers_type01 = $003a, error, "secondary behavior table size drift"

; Side-indexed base velocity for type-$0E tank fire. The ordinary branch doubles
; these signed bytes to +/-2; the alternate branch doubles again to +/-4.
tank_projectile_direction:
    .byte $01,$ff

tank_projectile_direction_end:
.assert tank_projectile_direction - selector5_start = $1ba3, error, "tank projectile table origin drift"
.assert tank_projectile_direction_end - tank_projectile_direction = $0002, error, "tank projectile table size drift"

; Bounded update/animation defaults with no confirmed direct consumer yet.
; These bytes remain explicit source data without stronger semantic claims.
unclassified_update_defaults:
    .byte $01,$93,$38,$00,$00,$39,$00,$02,$03,$03,$04,$03,$03,$02,$00,$fe
    .byte $fd,$fd,$fc,$fd,$fe,$fe,$f8,$fa,$fd,$ff,$00,$01,$03,$06,$08,$06
    .byte $03,$01,$00,$ff,$fd,$fa,$00,$80,$01,$01,$01,$01,$01,$01,$80,$01
    .byte $01,$01,$80,$80,$80,$80,$01,$80,$01,$01,$01,$01,$01,$01,$01,$01
    .byte $01,$01,$02,$03,$06,$07,$f1,$94,$95
airborne_infantry_sprites:
    .byte $5e,$a2,$5e,$a3

update_defaults_end:
.assert unclassified_update_defaults - selector5_start = $1ba5, error, "update defaults origin drift"
.assert airborne_infantry_sprites - selector5_start = $1bee, error, "airborne infantry sprite table origin drift"
.assert update_defaults_end - unclassified_update_defaults = $004d, error, "update defaults size drift"

stationary_type0e_threshold_low:
    .byte $60,$c4
stationary_type0e_threshold_high:
    .byte $00,$ff

stationary_type0e_thresholds_end:
.assert stationary_type0e_threshold_low - selector5_start = $1bf2, error, "stationary target threshold origin drift"
.assert stationary_type0e_thresholds_end - stationary_type0e_threshold_low = $0004, error, "stationary target threshold size drift"

capture_strategy_delays:
    .byte $01,$ff,$b4,$78,$54,$48,$3c,$30,$18,$00

; Secondary-update module entry table.
secondary_module_initialize_jump:
    jmp initialize_secondary_module
secondary_module_reset_jump:
    jmp secondary_module_noop_entry
secondary_module_stage_jump:
    jmp verify_secondary_disk_pages
secondary_module_tick_jump:
    jmp update_secondary_target_selection
secondary_module_dispatch_jump:
    jmp dispatch_secondary_behavior

initialize_secondary_module:
    lda #$05
    sta $6033
    sta $6034
secondary_module_noop:
    rts

; Load eight pages and compare four page pairs with XOR key $31. Any mismatch
; is retained in $60AC; an exact comparison returns without changing it.
verify_secondary_disk_pages:
    lda #$57
    sta $bfec
    lda #$07
    sta $bfeb
    lda #$1e
    sta $bfea
    lda #$03
    sta $bfed
load_next_secondary_disk_page:
    jsr selector5_rwts_jump
    dec $bfec
    dec $bfeb
    bpl load_next_secondary_disk_page
    ldx #$04
    ldy #$00
    sty $60
    sty $62
    lda #$57
    sta $61
    lda #$53
    sta $63
compare_secondary_disk_pages:
    lda #$31
    eor ($60),y
    eor ($62),y
    bne secondary_disk_mismatch
    iny
    bne compare_secondary_disk_pages
    dec $61
    dec $63
    dex
    bne compare_secondary_disk_pages
secondary_module_noop_entry:
    rts
secondary_disk_mismatch:
    sta $60ac
    rts

; Dispatch X through the pointer table at $8E19.
dispatch_secondary_behavior:
    lda $8e19,x
    sta $60
    lda $8e1a,x
    sta $61
    jmp ($60)

secondary_signed_unit:
    cmp #$00
    beq secondary_signed_zero
    bpl secondary_signed_positive
secondary_signed_negative:
    lda #$ff
    rts
secondary_signed_positive:
    lda #$01
secondary_signed_zero:
    rts

; Compare the 12-bit horizontal coordinates of X and Y and return -1/0/+1.
compare_object_horizontal_positions:
    lda $632c,x
    cmp $632c,y
    bcc secondary_signed_negative
    bne secondary_signed_positive
    lda $6394,x
    cmp $6394,y
    bcc secondary_signed_negative
    bne secondary_signed_positive
    lda #$00
    rts

; Keep a companion object positioned and animated relative to its owning player
; helicopter. Hidden/unavailable owners select sprite $FF.
update_player_companion:
    ldx $6604,y
    lda $6104,x
    bne hide_player_companion
    lda $6112,x
    tax
    lda $6874,x
    beq hide_player_companion
    lda $632c,x
    sta $632c,y
    lda $6394,x
    sta $11
    lda $63fc,x
    sta $12
    lda $62c4,x
    cmp #$97
    bcc companion_direction_ready
    sbc #$97
    clc
companion_direction_ready:
    tax
    lda $60c1
    lsr a
    lda companion_animation_offsets,x
    adc #$09
    pha
    lda $12
    clc
    adc #$f6
    sta $63fc,y
    lda $11
    clc
    adc companion_horizontal_offsets,x
    sta $6394,y
    lda $632c,y
    adc #$00
    sta $632c,y
    pla
store_player_companion_sprite:
    sta $62c4,y
player_companion_done:
    rts
hide_player_companion:
    lda #$ff
    bmi store_player_companion_sprite

; Periodically validate or acquire an opposing airborne player target.
update_opposing_player_target:
    lda $60c1
    and #$01
    clc
    adc #$36
    bcc store_player_companion_sprite
    lda $67a4,y
    beq maybe_acquire_opposing_player
    sec
    sbc #$01
    sta $67a4,y
    bne opposing_player_target_done
maybe_acquire_opposing_player:
    lda $60c1
    eor $6604,y
    and #$0f
    beq acquire_opposing_player
    lda $66d4,y
    bpl validate_opposing_player_target
acquire_opposing_player:
    jsr find_opposing_airborne_player
    bcc opposing_player_target_done
    jmp launch_targeted_smart_missile
validate_opposing_player_target:
    tax
    lda $673c,y
    cmp $6124,x
    beq player_companion_done
    lda #$ff
    sta $66d4,y
opposing_player_target_done:
    rts

; Search the active list in the side-selected direction for an opposing,
; airborne type-$02 player helicopter.
find_opposing_airborne_player:
    ldx current_object
    ldy $6604,x
    sty $60bd
    ldx $60df,y
    dey
    sty $60
scan_opposing_player:
    bit $60
    bpl scan_opposing_player_backward
    lda $625c,x
    bpl test_opposing_player_high_bound
opposing_player_not_found:
    clc
    rts
scan_opposing_player_backward:
    lda $61f4,x
    bmi opposing_player_not_found
    tax
    lda $632c,x
    cmp #$0d
    beq test_opposing_player
    clc
    rts
test_opposing_player_high_bound:
    tax
    lda $632c,x
    cmp #$02
    bne opposing_player_not_found
test_opposing_player:
    lda $6604,x
    cmp $60bd
    beq scan_opposing_player
    lda $6124,x
    cmp #$02
    bne scan_opposing_player
    sta $60a7
    ldy $6604,x
    lda $6104,y
    bne scan_opposing_player
    sec
    rts

secondary_module_source_end:
.assert capture_strategy_delays - selector5_start = $1bf6, error, "capture strategy-delay table origin drift"
.assert secondary_module_initialize_jump - selector5_start = $1c00, error, "secondary module origin drift"
.assert verify_secondary_disk_pages - selector5_start = $1c18, error, "secondary disk verification origin drift"
.assert dispatch_secondary_behavior - selector5_start = $1c5e, error, "secondary dispatch origin drift"
.assert compare_object_horizontal_positions - selector5_start = $1c77, error, "horizontal compare origin drift"
.assert update_player_companion - selector5_start = $1c8e, error, "player companion update origin drift"
.assert update_opposing_player_target - selector5_start = $1ce6, error, "opposing target update origin drift"
.assert find_opposing_airborne_player - selector5_start = $1d23, error, "opposing player search origin drift"
.assert secondary_module_source_end - capture_strategy_delays = $017a, error, "secondary module source size drift"

; Primary update handler for the player smart missile (type $12). It validates
; its linked target, homes one angular step per update, and spawns a type-$13
; impact object when aligned. A lost target turns the missile into a falling
; unguided object; reaching the lower boundary destroys it.
update_smart_missile:
    lda $6464,y
    beq smart_target_check
    ldx current_object
    dec $6464,x
smart_target_check:
    ldx $66d4,y
    bmi smart_check_ground
    lda $673c,y
    cmp $6124,x
    beq smart_player_target
smart_lose_target:
    lda #$ff
    sta $66d4,y
    lda #$00
    sta $67a4,y
    beq smart_fall
smart_player_target:
    cmp #$02
    bne smart_check_ground
    lda $6604,x
    tax
    lda $6104,x
    bne smart_lose_target
    lda $6114,x
    bpl smart_reload_target
    tya
    sta $6114,x
smart_reload_target:
    ldx $66d4,y
smart_check_ground:
    lda $63fc,y
    cmp #$dd
    bne smart_target_state
    lda #$00
    sta $680c,y
    jmp $ac0c
smart_target_state:
    lda $66d4,y
    bpl smart_steer
smart_fall:
    lda $6534,y
    clc
    adc #$02
    sta $6534,y
    clc
    adc $63fc,y
    cmp #$dd
    bcc smart_fall_altitude_ready
    lda #$dd
smart_fall_altitude_ready:
    sta $63fc,y
    jmp $7a12
smart_steer:
    lda $67a4,y
    sec
    sbc #$01
    beq smart_lose_target
    sta $67a4,y
    jsr compare_object_horizontal_positions
    sta $60
    ldx $673c,y
    lda $6935,x
    lsr
    sta $61
    ldx $66d4,y
    lda $63fc,x
    sec
    sbc $61
    cmp $63fc,y
    bcs smart_vertical_difference_positive
    ldx #$ff
    sta $62
    lda $63fc,y
    sec
    sbc $62
    bne smart_vertical_distance_ready
smart_vertical_difference_positive:
    sec
    sbc $63fc,y
    tax
smart_vertical_distance_ready:
    stx $62
    ldx #$00
    cmp #$00
    beq smart_vertical_band_ready
    inx
    cmp #$04
    bcc smart_vertical_band_ready
    inx
    cmp #$08
    bcc smart_vertical_band_ready
    inx
smart_vertical_band_ready:
    stx $61
    lda $60
    bmi smart_target_left
    beq smart_target_centered
    lda $62
    bpl smart_target_right_below
    lda #$04
    sec
    sbc $61
    jmp smart_desired_angle_ready
smart_target_right_below:
    lda #$04
    clc
    adc $61
    jmp smart_desired_angle_ready
smart_target_centered:
    lda $61
    asl
    lda #$00
    bcs smart_desired_angle_ready
    lda #$08
    bne smart_desired_angle_ready
smart_target_left:
    lda $62
    bmi smart_target_left_above
    lda #$0c
    sec
    sbc $61
    jmp smart_desired_angle_ready
smart_target_left_above:
    lda #$0c
    clc
    adc $61
smart_desired_angle_ready:
    sta $61
    lda $62c4,y
    sec
    sbc #$63
    sta $60
    ldx #$00
    cmp $61
    beq smart_angle_step_ready
    inx
    bcs smart_angle_decrease
    adc #$08
    cmp $61
    bcs smart_angle_step_ready
    ldx #$ff
    bmi smart_angle_step_ready
smart_angle_decrease:
    lda $61
    clc
    adc #$08
    cmp $60
    bcc smart_angle_step_ready
    ldx #$ff
smart_angle_step_ready:
    txa
    clc
    adc $60
    and #$0f
    tax
    clc
    adc #$63
    sta $62c4,y
    cpx $61
    beq smart_impact
    jmp $7a12
smart_impact:
    txa
    pha
    lda $63fc,y
    sta $60ce
    lda $632c,y
    sta $60cc
    lda $6394,y
    sta $60cd
    lda #$03
    sta $60a8
    lda #$13
    sta $60a7
    jsr object_constructor_jump
    pla
    tax
    ldy current_object
    lda $8e7a,x
    clc
    adc $63fc,y
    cmp #$dd
    bcc smart_impact_altitude_ready
    lda #$dd
smart_impact_altitude_ready:
    sta $63fc,y
    lda $8e6a,x
    sec
    sbc $64cc,y
    jsr $856b
    clc
    adc $64cc,y
    sta $64cc,y
    jmp $7a12

smart_missile_update_end:
.assert update_smart_missile - selector5_start = $1d70, error, "smart-missile update origin drift"
.assert smart_missile_update_end - update_smart_missile = $0173, error, "smart-missile update size drift"

; Countdown animation with randomized frame selection and terminal destruction.
update_countdown_animation:
    lda $673c,y
    beq countdown_animation_phase
    sec
    sbc #$01
    sta $673c,y
    rts
countdown_animation_phase:
    lda $66d4,y
    sec
    sbc #$01
    sta $66d4,y
    bne choose_countdown_animation_frame
    lda #$ff
    sta $680c,y
    jmp $ac0c
choose_countdown_animation_frame:
    jsr selector5_random_byte_jump
    and #$03
    tax
    lda countdown_animation_frames,x
    sta $6464,y
    rts

; Spawn a type-$14 object on the first phase, then animate/move the source
; object until its countdown expires.
update_type14_spawn_chain:
    ldx current_object
    lda $66d4,x
    bne spawn_type14_phase
    dec $673c,x
    bne animate_type14_source
destroy_type14_source:
    lda #$00
    sta $680c,x
    jmp $ac0c
animate_type14_source:
    lda $673c,x
    lsr a
    bcs type14_source_velocity
    inc $62c4,x
type14_source_velocity:
    ldy #$ff
    lda $64cc,x
    bmi store_type14_source_velocity
    beq type14_source_zero_velocity
    iny
type14_source_zero_velocity:
    iny
store_type14_source_velocity:
    tya
    sta $64cc,x
    jmp integrate_horizontal_position_jump
spawn_type14_phase:
    lda $6394,x
    sta $60cd
    lda $632c,x
    sta $60cc
    lda #$14
    sta $60a7
    jsr object_constructor_jump
    lda #$00
    sta $66d4,y
    ldx current_object
    dec $673c,x
    beq destroy_type14_source
    jmp integrate_horizontal_position_jump

; Advance a short four-state effect, optionally moving it upward first.
update_four_state_effect:
    ldx $66d4,y
    cpx #$04
    bne four_state_check_terminal
    ldx $673c,y
    bne store_four_state_effect
four_state_check_terminal:
    dex
    bne store_four_state_effect
    jmp $ac0c
raise_four_state_effect:
    lda $63fc,y
    sec
    sbc #$03
    sta $63fc,y
store_four_state_effect:
    lda four_state_effect_sprites,x
    sta $62c4,y
    txa
    sta $66d4,y
    rts

early_effect_updates_source_end:
.assert update_countdown_animation - selector5_start = $1ee3, error, "countdown animation origin drift"
.assert update_type14_spawn_chain - selector5_start = $1f0f, error, "type-14 spawn update origin drift"
.assert update_four_state_effect - selector5_start = $1f63, error, "four-state effect origin drift"
.assert early_effect_updates_source_end - update_countdown_animation = $00a6, error, "early effect update source size drift"

; Build and advance side-specific target cursors through the active-object list.
; Eligible types and behavior flags come from $8EAB/$8EC4; selected horizontal
; clearance is stored in $6874 for the current object.
update_secondary_target_selection:
    lda #$ff
    sta $8ee7
    sta $8ee9
    sta $8eec
    sta $8ee8
    sta $8eea
    sta $8eed
    ldy $60df
scan_initial_secondary_candidates:
    cpy $60e0
    beq select_next_secondary_candidate
    lda $8ee9
    ora $8eea
    bpl select_next_secondary_candidate
    ldx $6124,y
    lda secondary_target_type_eligible,x
    beq advance_initial_secondary_candidate
    ldx $6604,y
    lda $8ee9,x
    bpl advance_initial_secondary_candidate
    lda $6124,y
    cmp #$17
    bne initial_candidate_type16
initial_candidate_bunker:
    lda $67a4,y
    beq advance_initial_secondary_candidate
    lda $8ee9,x
    bpl advance_initial_secondary_candidate
    bmi store_initial_secondary_candidate
initial_candidate_type16:
    cmp #$16
    beq initial_candidate_bunker
    cmp #$02
    bne initial_candidate_height
    lda $6104,x
    bne advance_initial_secondary_candidate
initial_candidate_height:
    lda $63fc,y
    cmp #$d8
    bcc advance_initial_secondary_candidate
store_initial_secondary_candidate:
    tya
    sta $8ee9,x
advance_initial_secondary_candidate:
    lda $625c,y
    tay
    bpl scan_initial_secondary_candidates

select_next_secondary_candidate:
    ldy $8ee9
    bpl compare_secondary_side_candidates
    ldy $8eea
    bpl process_selected_secondary_candidate
    rts
compare_secondary_side_candidates:
    ldx $8eea
    bmi process_selected_secondary_candidate
    lda $632c,y
    cmp $632c,x
    bcc process_selected_secondary_candidate
    bne select_secondary_side_one
    lda $6394,y
    cmp $6394,x
    bcc process_selected_secondary_candidate
select_secondary_side_one:
    ldy $8eea
process_selected_secondary_candidate:
    sty current_object
    jsr process_secondary_candidate
    jmp select_next_secondary_candidate

process_secondary_candidate:
    ldx $6604,y
    stx $60bd
    txa
    eor #$01
    sta $8eeb
scan_next_same_side_candidate:
    lda $625c,y
    cmp $60e0
    beq no_next_same_side_candidate
    tay
    lda $6604,y
    cmp $60bd
    bne scan_next_same_side_candidate
    ldx $6124,y
    lda secondary_target_type_eligible,x
    beq scan_next_same_side_candidate
    cpx #$17
    bne next_candidate_type16
next_candidate_bunker:
    lda $67a4,y
    beq scan_next_same_side_candidate
    bne store_next_same_side_candidate
next_candidate_type16:
    cpx #$16
    beq next_candidate_bunker
    cpx #$02
    bne next_candidate_height
    ldx $60bd
    lda $6104,x
    bne scan_next_same_side_candidate
next_candidate_height:
    lda $63fc,y
    cmp #$d8
    bcc scan_next_same_side_candidate
    bcs store_next_same_side_candidate
no_next_same_side_candidate:
    ldy #$ff
store_next_same_side_candidate:
    tya
    ldx $60bd
    sta $8ee9,x
    lda $8eec,x
    bpl preserve_secondary_cursor
    lda $8ee7,x
    sta $8eec,x
preserve_secondary_cursor:
    ldy current_object
    tya
    sta $8ee7,x
    ldx $6124,y
    lda secondary_target_behavior_flags,x
    bne evaluate_secondary_clearance
    rts

evaluate_secondary_clearance:
    sta $62
    lda $632c,y
    sta $60cc
    lda $6394,y
    sta $60cd
    lda #$00
    sta $6874,y
    ldx $8eeb
    bit $62
    bvc scan_prior_opposing_candidates
    lda $6604,y
    bne scan_prior_opposing_candidates
finish_secondary_candidate:
    jmp evaluate_initial_opposing_candidate
scan_prior_opposing_candidates:
    lda $8ee7,x
    bmi finish_secondary_candidate
    sta $63
scan_opposing_cursor:
    lda $8eec,x
    bmi choose_secondary_clearance_target
    tax
    ldy $6124,x
    lda object_horizontal_sizes,y
    clc
    adc $6394,x
    sta $60
    lda $632c,x
    adc #$00
    sta $61
    lda $60cd
    sec
    sbc $60
    sta $60
    lda $60cc
    sbc $61
    bmi choose_secondary_clearance_target
    bne advance_opposing_clearance_cursor
    lda $60
    cmp #$0e
    bcc choose_secondary_clearance_target
advance_opposing_clearance_cursor:
    lda $625c,x
    cmp $63
    bne test_opposing_clearance_candidate
    lda #$ff
    bmi store_opposing_clearance_cursor
test_opposing_clearance_candidate:
    tax
    lda $6604,x
    cmp $8eeb
    bne advance_opposing_clearance_cursor
    ldy $6124,x
    lda secondary_target_type_eligible,y
    beq advance_opposing_clearance_cursor
    cpy #$16
    beq opposing_clearance_bunker
    cpy #$17
    bne opposing_clearance_player
opposing_clearance_bunker:
    lda $67a4,y
    beq advance_opposing_clearance_cursor
    bne accept_opposing_clearance_candidate
opposing_clearance_player:
    cpy #$02
    bne opposing_clearance_height
    ldy $8eeb
    lda $6104,y
    bne advance_opposing_clearance_cursor
opposing_clearance_height:
    lda $63fc,x
    cmp #$d8
    bcc advance_opposing_clearance_cursor
accept_opposing_clearance_candidate:
    txa
store_opposing_clearance_cursor:
    ldx $8eeb
    sta $8eec,x
    bpl scan_opposing_cursor

choose_secondary_clearance_target:
    ldx $8eeb
    ldy $8eec,x
    bpl compute_secondary_clearance
    ldy $8ee7,x
compute_secondary_clearance:
    ldx $6124,y
    lda object_horizontal_sizes,x
    clc
    adc $6394,y
    sta $60
    lda $632c,y
    adc #$00
    sta $61
    lda $60cd
    sec
    sbc $60
    sta $60
    lda $60cc
    sbc $61
    bmi force_secondary_unit_clearance
    bne scan_remaining_opposing_candidates
    lda $60
    cmp #$0c
    bcc store_secondary_clearance
    bit $62
    bmi scan_remaining_opposing_candidates
    cmp #$0e
    bcs scan_remaining_opposing_candidates
store_secondary_clearance:
    ldx current_object
    lda $6874,x
    beq compare_secondary_clearance
    cmp $60
    bcc scan_remaining_opposing_candidates
compare_secondary_clearance:
    lda $60
    bne write_secondary_clearance
force_secondary_unit_clearance:
    lda #$01
write_secondary_clearance:
    sta $6874,x
    lda $6124,y
    sta $63
    lda $66d4,y
    sta $64
scan_remaining_opposing_candidates:
    ldx $8eeb
    tya
    cmp $8ee7,x
    beq evaluate_initial_opposing_candidate
advance_remaining_opposing_candidate:
    lda $625c,y
    tay
    ldx $8eeb
    cmp $8ee7,x
    beq repeat_secondary_clearance
    lda $6604,y
    cmp $8eeb
    bne advance_remaining_opposing_candidate
    ldx $6124,y
    lda secondary_target_type_eligible,x
    beq advance_remaining_opposing_candidate
    cpx #$02
    bne remaining_candidate_type16
    ldx $8eeb
    lda $6104,x
    bne advance_remaining_opposing_candidate
remaining_candidate_type16:
    cpx #$16
    bne remaining_candidate_type17
remaining_candidate_bunker:
    lda $66d4,y
    beq advance_remaining_opposing_candidate
    bne repeat_secondary_clearance
remaining_candidate_type17:
    cpx #$17
    beq remaining_candidate_bunker
    lda $63fc,y
    cmp #$d8
    bcc advance_remaining_opposing_candidate
repeat_secondary_clearance:
    jmp compute_secondary_clearance

evaluate_initial_opposing_candidate:
    ldy current_object
    bit $62
    bvc initial_opposing_candidate_ready
    lda $6604,y
    bne finalize_secondary_target_class
initial_opposing_candidate_ready:
    lda $8ee9,x
    bmi finalize_secondary_target_class
    pha
    ldx $6124,y
    lda object_horizontal_sizes,x
    clc
    adc $60cd
    sta $60
    lda $60cc
    adc #$00
    sta $61
    pla
    tax
    lda $6394,x
    sec
    sbc $60
    sta $60
    lda $632c,x
    sbc $61
    bmi accept_initial_opposing_candidate
    bne finalize_secondary_target_class
    lda $60
    cmp #$0c
    bcc compare_initial_opposing_clearance
    bit $62
    bmi finalize_secondary_target_class
    cmp #$0e
    bcs finalize_secondary_target_class
compare_initial_opposing_clearance:
    lda $6874,y
    beq accept_initial_opposing_candidate
    cmp $60
    bcc finalize_secondary_target_class
accept_initial_opposing_candidate:
    lda #$ff
    sta $6874,y
    lda $6124,x
    sta $63
    lda $66d4,x
    sta $64
finalize_secondary_target_class:
    lda $6874,y
    beq secondary_target_selection_done
    bit $62
    bvc secondary_target_selection_done
    ldx #$00
    lda $63
    cmp #$0d
    beq store_secondary_target_class
    cmp #$09
    beq store_secondary_target_class
    inx
    cmp #$17
    beq store_secondary_target_class
    cmp #$16
    beq store_secondary_target_class
    inx
store_secondary_target_class:
    txa
    sta $66d4,y
secondary_target_selection_done:
    rts

; Initialized module status plus a 70-byte patch/reserve area.
secondary_target_workspace_init:
    lda #$00
    sta $60ac
secondary_target_nop_reserve:
    .repeat 70
        nop
    .endrepeat

secondary_target_selection_source_end:
.assert update_secondary_target_selection - selector5_start = $1f89, error, "secondary target selection origin drift"
.assert process_secondary_candidate - selector5_start = $201c, error, "secondary target candidate origin drift"
.assert evaluate_secondary_clearance - selector5_start = $2089, error, "secondary clearance origin drift"
.assert evaluate_initial_opposing_candidate - selector5_start = $21cf, error, "initial opposing candidate origin drift"
.assert secondary_target_workspace_init - selector5_start = $2251, error, "secondary target workspace origin drift"
.assert secondary_target_nop_reserve - selector5_start = $2256, error, "secondary target reserve origin drift"
.assert secondary_target_selection_source_end - update_secondary_target_selection = $0313, error, "secondary target selection source size drift"

; Primary update handler for object type $17. It fires a type-$0B projectile
; carrying four integrity/damage units every other update-counter value while
; its activity and direction fields are nonzero.
fire_type17_projectile:
    lda $67a4,y
    beq type17_fire_done
    lda $60c1
    and #$01
    beq type17_fire_done
    ldx #$00
    lda $6874,y
    beq type17_fire_done
    bpl type17_direction_ready
    inx
type17_direction_ready:
    lda type17_projectile_velocity,x
    sta $60cf
    clc
    bpl type17_position_right
    lda $6394,y
    adc #$ff
    sta $60cd
    lda $632c,y
    adc #$ff
    jmp type17_store_position
type17_position_right:
    lda $6394,y
    adc $692e
    sta $60cd
    lda $632c,y
    adc #$00
type17_store_position:
    sta $60cc
    lda $6604,y
    sta $60bd
    lda #$00
    sta $60d0
    sta $60a8
    lda #$04
    sta $60b3
    lda #$d9
    sta $60ce
    lda #$0b
    sta $60a7
    jmp object_constructor_jump
type17_fire_done:
    rts

type17_projectile_end:
.assert fire_type17_projectile - selector5_start = $229c, error, "type-17 projectile origin drift"
.assert type17_projectile_end - fire_type17_projectile = $0061, error, "type-17 projectile size drift"

; Update the stage-controlled type-$1A alternate projectile: accelerate its
; horizontal velocity toward -10/+10, emit type $13, integrate position, and
; add downward velocity on counter values divisible by four.
update_type1a_alternate_projectile:
    lda $6464,y
    beq emitter_delay_ready
    ldx current_object
    dec $6464,x
emitter_delay_ready:
    lda $63fc,y
    cmp #$dc
    bne emitter_adjust_velocity
    jmp $87fa
emitter_adjust_velocity:
    lda $64cc,y
    bpl emitter_positive_velocity
    cmp #$f6
    beq emitter_velocity_ready
    sbc #$01
    bne emitter_velocity_ready
emitter_positive_velocity:
    cmp #$0a
    beq emitter_velocity_ready
    adc #$01
emitter_velocity_ready:
    sta $64cc,y
    lda $63fc,y
    sta $60ce
    lda $6394,y
    sta $60cd
    lda $632c,y
    sta $60cc
    lda #$03
    sta $60a8
    lda #$13
    sta $60a7
    jsr object_constructor_jump
    jsr integrate_horizontal_position_jump
    ldy current_object
    lda $60c1
    and #$03
    beq emitter_vertical_delta_ready
    lda #$01
emitter_vertical_delta_ready:
    eor #$01
    clc
    adc $6534,y
    sta $6534,y
    clc
    adc $63fc,y
    cmp #$dd
    bcc emitter_store_height
    lda #$dc
emitter_store_height:
    sta $63fc,y
    rts

; Launch a type-$12 smart missile toward the target already selected in X.
launch_targeted_smart_missile:
    ldy current_object
    stx $60a8
    lda #$10
    sec
    sbc $05
    sta $67a4,y
    lda $60a7
    sta $60af
    lda #$00
    sta $60cf
    ldx $6604,y
    stx $60bd
    lda $691c
    lsr a
    adc $6394,y
    sta $60cd
    lda #$00
    adc $632c,y
    sta $60cc
    lda #$c9
    sta $60ce
    lda #$12
    sta $60a7
    sta $673c,y
    jsr object_constructor_jump
    bcs targeted_smart_missile_done
    tya
    ldy current_object
    sta $66d4,y
targeted_smart_missile_done:
    rts

airborne_emitter_source_end:
.assert update_type1a_alternate_projectile - selector5_start = $22fd, error, "type-1A alternate projectile origin drift"
.assert launch_targeted_smart_missile - selector5_start = $236d, error, "targeted smart missile origin drift"
.assert airborne_emitter_source_end - update_type1a_alternate_projectile = $00bb, error, "type-1A alternate projectile source size drift"

; Primary update handler for the player bomb (type $0A). A short arming delay
; precedes alternating horizontal drag. The bomb spins while accelerating
; downward, clamps at the ground, and enters its destruction/explosion path.
update_bomb:
    lda $67a4,y
    beq bomb_armed
    sec
    sbc #$01
    sta $67a4,y
    rts
bomb_armed:
    lda $66d4,y
    eor #$01
    sta $66d4,y
    and #$01
    bne bomb_check_ground
    lda $64cc,y
    jsr $856b
    eor #$ff
    clc
    adc #$01
    clc
    adc $64cc,y
    sta $64cc,y
bomb_check_ground:
    lda $63fc,y
    cmp #$dc
    bne bomb_spin
    ldx #$ff
    lda $60ed
    bne bomb_store_destroyed_state
    inx
bomb_store_destroyed_state:
    txa
    sta $680c,y
    jmp $ac0c
bomb_spin:
    lda $673c,y
    beq bomb_accelerate
    sec
    sbc #$01
    sta $673c,y
    bne bomb_accelerate
    lda $62c4,y
    sec
    sbc #$02
    cmp #$3a
    bcs bomb_angle_ready
    lda #$3a
bomb_angle_ready:
    sta $62c4,y
    cmp #$3a
    beq bomb_accelerate
    lda #$01
    sta $673c,y
bomb_accelerate:
    lda $6534,y
    clc
    adc #$02
    sta $6534,y
    clc
    adc $63fc,y
    cmp #$dd
    bcc bomb_altitude_ready
    lda #$dc
bomb_altitude_ready:
    sta $63fc,y
    cmp #$dc
    beq bomb_update_done
    lda $66d4,y
    and #$02
    beq bomb_mark_moved
    jmp $7a12
bomb_mark_moved:
    ora #$02
    sta $66d4,y
bomb_update_done:
    rts

bomb_update_end:
.assert update_bomb - selector5_start = $23b8, error, "bomb update origin drift"
.assert bomb_update_end - update_bomb = $008f, error, "bomb update size drift"

; Type-$0B projectile update. The shared horizontal mover runs first; then the
; acceleration byte is added to vertical velocity and the result to altitude.
; Projectiles expire at the ground/upper boundary or when $673C reaches zero.
destroy_type0b_projectile:
    jmp $87fa
update_type0b_projectile:
    jsr $7a12
    ldy current_object
    lda $6534,y
    clc
    adc $67a4,y
    sta $6534,y
    lda $63fc,y
    cmp #$dc
    beq destroy_type0b_projectile
    clc
    adc $6534,y
    cmp #$dd
    bcc type0b_altitude_ready
    lda #$dc
type0b_altitude_ready:
    sta $63fc,y
    cmp #$28
    bcc destroy_type0b_projectile
    cmp #$dc
    beq type0b_update_done
    lda $673c,y
    sec
    sbc #$01
    beq destroy_type0b_projectile
    sta $673c,y
type0b_update_done:
    rts

type0b_update_end:
.assert update_type0b_projectile - selector5_start = $244a, error, "type-0B update origin drift"
.assert type0b_update_end - update_type0b_projectile = $0038, error, "type-0B update size drift"

; Update a falling effect, occasionally converting it to type-$1B and linking
; it into the active list before continuing its lifetime/animation path.
update_falling_effect:
    jsr selector5_random_byte_jump
    and #$03
    bne falling_effect_countdown
    lda #$1b
    sta $6124,y
    lda #$01
    sta $618c,y
    jsr object_finalize_jump
    ldy current_object
falling_effect_countdown:
    lda $673c,y
    sec
    sbc #$01
    bne falling_effect_store_countdown
destroy_falling_effect:
    jmp $ac0c
falling_effect_noop:
    rts
falling_effect_store_countdown:
    sta $673c,y
    lda $67a4,y
    bpl falling_effect_ordinary_sprite
    lda $60e7
    eor current_object
    sta $60e7
    and #$03
    tax
    lda countdown_animation_frames,x
    sta $6464,y
    lda #$f1
    bne falling_effect_store_sprite
falling_effect_ordinary_sprite:
    lda $60c1
    clc
    adc current_object
    and #$03
    clc
    adc $66d4,y
    adc #$73
falling_effect_store_sprite:
    sta $62c4,y
    lda $6534,y
    clc
    adc #$02
    sta $6534,y
    clc
    adc $63fc,y
    cmp #$dd
    bcs destroy_falling_effect
    sta $63fc,y
    jmp integrate_horizontal_position_jump

update_effect_sprite_countdown:
    ldx current_object
    lda $673c,x
    bne decrement_effect_primary_countdown
    dec $66d4,x
    bpl decrement_effect_sprite
    jmp $ac0c
decrement_effect_sprite:
    dec $62c4,x
    rts
decrement_effect_primary_countdown:
    dec $673c,x
    rts

; Convert the current object to type $14 or $18 according to its control type,
; link it into the active list, then immediately dispatch secondary behavior.
convert_effect_object_type:
    ldx $67a4,y
    lda #$14
    cpx #$1a
    beq store_converted_effect_type
    lda #$18
store_converted_effect_type:
    sta $6124,y
    pha
    jsr object_finalize_jump
    ldy current_object
    pla
    asl a
    tax
    jmp dispatch_secondary_behavior

effect_state_source_end:
.assert update_falling_effect - selector5_start = $2482, error, "falling effect origin drift"
.assert update_effect_sprite_countdown - selector5_start = $24ec, error, "effect countdown origin drift"
.assert convert_effect_object_type - selector5_start = $2504, error, "effect conversion origin drift"
.assert effect_state_source_end - update_falling_effect = $009d, error, "effect state source size drift"

; Primary update dispatch entries for object types $03 through $1D. The table
; lookup base is $8E19; earlier overlapping bytes serve types below $03.
; Type $17 selects the four-damage firing routine at $8B9C.
primary_update_handlers_type03:
    .word $858e,$85e6,$85f0,$8576,$8576,$8576,$8576,update_bomb
    .word $8d4a,$8d82,$8576,$8576,$8576,$8576,$8576,update_smart_missile
    .word $87e3,$880f,$8863,$8b51,fire_type17_projectile,$8dec,$8576
    .word $8bfd,$8d99,$8576,$8e04

primary_update_handlers_type03_end:
.assert primary_update_handlers_type03 - selector5_start = $251f, error, "primary update table origin drift"
.assert primary_update_handlers_type03_end - primary_update_handlers_type03 = $0036, error, "primary update table size drift"

companion_horizontal_offsets:
    .byte $05,$06,$06,$06,$04,$04,$04,$05,$05
companion_animation_offsets:
    .byte $03,$00,$06,$06,$00,$03,$00,$00,$00

; Bounded motion/default tables whose individual consumers are not yet
; confirmed. They remain explicit data without stronger semantic claims.
unclassified_secondary_motion_defaults:
    .byte $01,$ff,$01,$00,$08,$0a,$0c,$10,$0c,$0a,$08,$00,$f8,$f6,$f4,$f0
    .byte $f4,$f6,$f8,$f7,$f9,$fc,$ff,$00,$01,$04,$07,$09,$07,$04,$01,$00
    .byte $ff,$fc,$f9,$00,$80,$01,$01,$01,$01,$01,$01,$80,$01,$01,$01,$80
    .byte $80,$80,$80,$01,$80,$01,$01,$01,$01,$01,$01,$01,$01,$01

; The final countdown frame at $8EA8 is also the first four-state frame; the
; fourth four-state frame at $8EAB is eligibility entry zero.
countdown_animation_frames:
    .byte $02,$03,$06
four_state_effect_sprites:
    .byte $07,$f1,$94
secondary_target_type_eligible:
    .byte $95,$00,$81,$00,$00,$00,$00,$00,$00,$81,$00,$00,$00,$81,$81
    .byte $81,$81,$00,$00,$00,$00,$00,$80,$80,$00
secondary_target_behavior_flags:
    .byte $81,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$40
    .byte $00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00,$00,$00,$00

secondary_tables_source_end:
.assert companion_horizontal_offsets - selector5_start = $2555, error, "companion horizontal table origin drift"
.assert companion_animation_offsets - selector5_start = $255e, error, "companion animation table origin drift"
.assert unclassified_secondary_motion_defaults - selector5_start = $2567, error, "secondary motion defaults origin drift"
.assert countdown_animation_frames - selector5_start = $25a5, error, "countdown animation table origin drift"
.assert four_state_effect_sprites - selector5_start = $25a8, error, "four-state sprite table origin drift"
.assert secondary_target_type_eligible - selector5_start = $25ab, error, "secondary eligibility table origin drift"
.assert secondary_target_behavior_flags - selector5_start = $25c4, error, "secondary behavior flags origin drift"
.assert secondary_tables_source_end - companion_horizontal_offsets = $008d, error, "secondary tables source size drift"

; Direction-indexed horizontal velocity for the type-$17 HQ projectile.
type17_projectile_velocity:
    .byte $fe,$02

type17_projectile_velocity_end:
.assert type17_projectile_velocity - selector5_start = $25e2, error, "type-17 projectile table origin drift"
.assert type17_projectile_velocity_end - type17_projectile_velocity = $0002, error, "type-17 projectile table size drift"

; Initialized side/cursor workspace consumed by secondary target selection.
secondary_target_cursor_workspace:
    .repeat 11
        .byte $00
    .endrepeat

dispatch_primary_behavior_from_a:
    asl a
    tay
    lda $ab14,y
    sta $60
    lda $ab15,y
    sta $61
    jmp ($60)

primary_dispatch_residual:
    .byte $ae,$c8

; Input module entry table.
input_module_initialize_jump:
    jmp input_module_noop
input_module_reset_jump:
    jmp initialize_input_state
input_module_stage_jump:
    jmp sample_player_buttons
input_module_counter_jump:
    jmp update_player_helicopter_state
input_module_dispatch_jump:
    jmp $9014
input_module_motion_jump:
    jmp increment_player_smoke_counter
input_module_weapon_jump:
    jmp $960b
input_module_indirect_jump:
    jmp ($60)
input_module_noop:
    rts

initialize_input_state:
    lda #$03
    sta $6044
    lda #$00
    sta $60a6
    sta $6046
    lda #$04
    sta $6045

; Sample both Apple II pushbuttons and normalize simultaneous edge changes into
; the per-frame button state at $60C8/$60C9.
sample_player_buttons:
    lda $6049
    sta $60ca
    lda $604a
    sta $60cb
    lda $c061
    and #$80
    sta $60c8
    sta $6049
    lda $c062
    and #$80
    sta $60c9
    sta $604a
    and $60c8
    bpl buttons_not_both_pressed
    lda $60ca
    eor $60cb
normalize_button_edges:
    eor #$80
    sta $60c8
    sta $60c9
    rts
buttons_not_both_pressed:
    lda $60ca
    and $60cb
    bmi normalize_button_edges
    lda $60ca
    sta $60c8
    lda $60cb
    sta $60c9
    rts

increment_input_exit_counter:
    inc $60b4
    rts

request_battlefield_exit:
    lda #$01
    sta $60bc
    sta $60b0
    rts

store_input_state_6042:
    sta $6042
    rts

input_module_front_source_end:
.assert secondary_target_cursor_workspace - selector5_start = $25e4, error, "secondary cursor workspace origin drift"
.assert dispatch_primary_behavior_from_a - selector5_start = $25ef, error, "primary behavior dispatch origin drift"
.assert input_module_initialize_jump - selector5_start = $2600, error, "input module origin drift"
.assert initialize_input_state - selector5_start = $2619, error, "input initialization origin drift"
.assert sample_player_buttons - selector5_start = $262b, error, "button sampler origin drift"
.assert increment_input_exit_counter - selector5_start = $2676, error, "input exit counter origin drift"
.assert request_battlefield_exit - selector5_start = $267a, error, "battlefield exit request origin drift"
.assert store_input_state_6042 - selector5_start = $2683, error, "input state setter origin drift"
.assert input_module_front_source_end - secondary_target_cursor_workspace = $00a3, error, "input module front size drift"

; Demo-only S handling clears the sentinel that otherwise suppresses the
; selector-6 briefing gate, then raises both exit counters for the current
; demo pass.
start_interactive_campaign:
    lda #$00
    sta $60bb
    inc $60b0
    inc $60b8
    rts

start_interactive_campaign_end:
.assert start_interactive_campaign - selector5_start = $2687, error, "start transition origin drift"
.assert start_interactive_campaign_end - start_interactive_campaign = $000c, error, "start transition size drift"

; Wait for one of four accepted high-bit keys, normalizing lowercase letters.
; When permitted, selector command 4 is issued before returning.
wait_for_selector_key:
    jsr $b30f
    bit $c010
restart_selector_key_wait:
    ldx #$03
wait_for_selector_keypress:
    lda $c000
    bpl wait_for_selector_keypress
    bit $c010
    cmp #$9b
    beq selector_key_done
    cmp #$e1
    bcc compare_selector_key
    cmp #$fb
    bcs compare_selector_key
    adc #$e0
compare_selector_key:
    cmp selector_save_sequence_reversed,x
    bne restart_selector_key_wait
    dex
    bpl wait_for_selector_keypress
    lda $06
    bne restart_selector_key_wait
    lda #$04
    jsr selector5_disk_region_jump
    bcs restart_selector_key_wait
selector_key_done:
    rts

; In the enabled debug/input mode, accept campaign digits 1-9 and prime the
; same battle-transition counters used by ordinary flow.
read_campaign_digit:
    bit $6046
    bpl campaign_digit_done
    bit $c010
wait_for_campaign_digit:
    lda $c000
    bpl wait_for_campaign_digit
    bit $c010
    cmp #$b1
    bcc campaign_digit_done
    cmp #$ba
    bcs campaign_digit_done
    and #$0f
    sta $05
    dec $05
    lda #$02
    sta $60c6
    lda #$f0
    sta $60c7
campaign_digit_done:
    rts

position_player_at_left_edge:
    lda #$60
    ldx #$02
    bne position_debug_player
position_player_at_right_edge:
    lda #$f7
    ldx #$07
    bne position_debug_player
position_player_at_center:
    lda #$a0
    ldx #$0d
position_debug_player:
    bit $6046
    bpl position_debug_player_done
    ldy $6113
    sty current_object
    sta $6394,y
    txa
    sta $632c,y
    jmp finish_position_update
position_debug_player_done:
    rts

; Sample buttons, normalize a pending key, dispatch command-table entries, and
; handle numeric timing/debug controls before the demo-specific tail.
dispatch_player_input:
    jsr sample_player_buttons
    lda #$00
    sta current_input_key
    lda $c000
    bpl finish_player_input
    cmp #$e1
    bcc store_player_input_key
    cmp #$fb
    bcs store_player_input_key
    adc #$e0
store_player_input_key:
    sta current_input_key
    bit $c010
    ldy $60b6
    bne dispatch_demo_input
    ldy $60c6
    beq check_player_command_state
    cmp #$92
    beq check_player_command_state
    cmp #$9b
    bne finish_player_input
check_player_command_state:
    ldy $60b0
    beq scan_player_input_commands
    ldy $60b1
    cpy #$10
    bcc finish_player_input
    lda #$ff
    sta $60b1
    bmi finish_player_input
scan_player_input_commands:
    ldy #$10
scan_next_player_input_command:
    cmp $9939,y
    beq dispatch_player_input_command
    dey
    bpl scan_next_player_input_command
    cmp #$b1
    bcc check_input_mode_sequence
    cmp #$ba
    bcs check_input_mode_sequence
    and #$0f
    asl a
    sta $60b5
    lda #$14
    sec
    sbc $60b5
    sta $60b5
finish_player_input:
    jmp $90f6
dispatch_player_input_command:
    tya
    asl a
    tax
    lda $994a,x
    sta $60
    lda $994b,x
    sta $61
    lda current_input_key
    jsr input_module_indirect_jump
    jmp $90f6
check_input_mode_sequence:
    ldy $6045
    cmp hidden_debug_sequence_reversed,y
    bne reset_input_mode_sequence
    dec $6045
    bpl finish_player_input_frame
    lda $6046
    eor #$ff
    sta $6046
reset_input_mode_sequence:
    lda #$04
    sta $6045
    bne finish_player_input_frame
dispatch_demo_input:
    ldy #$01
    cmp #$bd
    bne dispatch_demo_start_key
    jsr increment_input_transition_counter
    jmp $90f6

input_dispatch_source_end:
.assert wait_for_selector_key - selector5_start = $2693, error, "selector key wait origin drift"
.assert read_campaign_digit - selector5_start = $26c5, error, "campaign digit input origin drift"
.assert position_player_at_left_edge - selector5_start = $26ee, error, "debug player left entry drift"
.assert position_player_at_right_edge - selector5_start = $26f4, error, "debug player right entry drift"
.assert position_player_at_center - selector5_start = $26fa, error, "debug player center entry drift"
.assert dispatch_player_input - selector5_start = $2714, error, "player input dispatch origin drift"
.assert input_dispatch_source_end - wait_for_selector_key = $0125, error, "input dispatch source size drift"

dispatch_demo_start_key:
    dey
    cmp #$d3                    ; high-bit S
    bne demo_start_key_not_s
    jsr start_interactive_campaign
    jmp $90f6
demo_start_key_not_s:

dispatch_demo_start_key_end:
.assert dispatch_demo_start_key - selector5_start = $27b8, error, "S dispatch origin drift"
.assert dispatch_demo_start_key_end - dispatch_demo_start_key = $000b, error, "S dispatch size drift"

; A second gated four-key sequence issues selector command 3 and optionally
; enters the blocking selector-key routine.
process_hidden_selector_sequence:
    ldy $60b2
    beq finish_player_input_frame
    ldy $6044
    cmp selector_continue_sequence_reversed,y
    beq advance_hidden_selector_sequence
    lda #$03
    sta $6044
    jmp finish_player_input_frame
advance_hidden_selector_sequence:
    dec $6044
    bpl finish_player_input_frame
    lda $06
    bne finish_player_input_frame
    lda #$03
    sta $6044
    jsr selector5_disk_region_jump
    lda $60b6
    bne finish_player_input_frame
    lda #$01
    jsr $b309
    jsr wait_for_selector_key

; Complete per-frame interactive/demo input processing after key dispatch.
finish_player_input_frame:
    lda $60b6
    bne finish_demo_input_frame
    lda $60b0
    beq clear_buttons_during_transition
    lda $60b1
    cmp #$10
    bcc clear_buttons_during_transition
    lda $60c8
    eor $60ca
    bne force_input_transition
    lda $60c9
    eor $60cb
    bpl clear_buttons_during_transition
force_input_transition:
    lda #$ff
    sta $60b1
clear_buttons_during_transition:
    lda $60c6
    beq sample_analog_input
    lda #$00
    sta $60c8
    sta $60c9
sample_analog_input:
    jsr sample_player_paddles
    bit $60bb
    bpl interactive_input_done
    jsr $da1b
interactive_input_done:
    rts
finish_demo_input_frame:
    lda $60c8
    eor $60ca
    bne end_demo_from_input
    lda $60c9
    eor $60cb
    beq demo_input_done
end_demo_from_input:
    inc $60b0
    inc $60b8
demo_input_done:
    rts

input_completion_source_end:
.assert process_hidden_selector_sequence - selector5_start = $27c3, error, "hidden selector sequence origin drift"
.assert finish_player_input_frame - selector5_start = $27f6, error, "input completion origin drift"
.assert input_completion_source_end - process_hidden_selector_sequence = $0089, error, "input completion source size drift"

sample_player_paddles:
    ldx #$00
    stx horizontal_target
    stx vertical_target
    lda paddle_trigger
sample_paddle_0:
    lda paddle_0
    bpl paddle_0_done
    stx horizontal_target
sample_paddle_1:
    lda paddle_1
    bpl paddle_1_done
    stx vertical_target
sample_paddles_next:
    inx
    bne sample_paddle_0
    lda #$64
    cmp horizontal_target
    bcs horizontal_capped
    sta horizontal_target
horizontal_capped:
    cmp vertical_target
    bcs vertical_capped
    sta vertical_target
vertical_capped:
    lda horizontal_target
    lsr
    lsr
    tax
    lda horizontal_target_table,x
    sta horizontal_target

    ; Scale the complemented vertical sample by $01BF using the original
    ; eight-step shift/add loop, then bias its high byte by $38.
    lda #$00
    sta $62
    sta $63
    lda #$bf
    sta $60
    lda #$01
    sta $61
    ldx #$08
    lda vertical_target
    eor #$ff
scale_vertical:
    lsr
    bcs scale_vertical_shift
    pha
    lda $60
    adc $62
    sta $62
    lda $61
    adc $63
    sta $63
    pla
scale_vertical_shift:
    asl $60
    rol $61
    dex
    bne scale_vertical
    lda $63
    clc
    adc #$38
    sta vertical_target
    rts

paddle_0_done:
    bpl sample_paddle_1
paddle_1_done:
    bpl sample_paddles_next

flight_input_end:
.assert sample_player_paddles - selector5_start = $284c, error, "flight input origin drift"
.assert flight_input_end - sample_player_paddles = $0076, error, "flight input size drift"

; Coordinate per-player cooldowns, destroyed-player respawn, and ordinary
; service/fuel/flight updates. The ordinary path deliberately falls through
; into the grounded field-repair routine at $925D.
update_player_helicopter_state:
    ldy current_object
    ldx $6604,y
    stx player_index
    lda $604b,x
    beq player_action_cooldown_ready
    dec $604b,x
player_action_cooldown_ready:
    lda $610a,x
    beq player_smoke_feedback_ready
    dec $610a,x
    jsr spawn_player_falling_infantry
    ldx player_index
player_smoke_feedback_ready:
    lda $6104,x
    beq update_active_player_helicopter
    lda #$00
    sta $60f1
    sta $60fc,x
    sta $610a,x
    lda $60f8,x
    beq advance_player_respawn
    jsr capture_player_action_state
advance_player_respawn:
    lda $60ab
    beq finish_destroyed_player_update
    dec $6104,x
    bne finish_destroyed_player_update
    lda $60b6
    bne respawn_player_helicopter
    txa
    beq respawn_player_helicopter
    lda $c061
    ora $c062
    bpl respawn_player_helicopter
    inc $6104,x
    bne finish_destroyed_player_update
respawn_player_helicopter:
    jsr $ac0f
    lda #$02
    sta $60a7
    ldx player_index
    stx $60bd
    lda $6106,x
    tax
    lda $6394,x
    clc
    adc #$08
    sta $60cd
    lda $632c,x
    adc #$00
    sta $60cc
    jsr object_constructor_jump
    bcc finish_destroyed_player_update
    ldx player_index
    inc $6104,x
finish_destroyed_player_update:
    jmp process_player_action_and_deployment

update_active_player_helicopter:
    lda $60f8,x
    bne update_interactive_player
    jsr strategy_module_tick_jump
    jmp update_player_flight_systems
update_interactive_player:
    jsr capture_interactive_player_input
update_player_flight_systems:
    jsr $934c
    jsr process_player_action_and_deployment

player_state_source_end:
.assert update_player_helicopter_state - selector5_start = $28c2, error, "player state update origin drift"
.assert update_active_player_helicopter - selector5_start = $2949, error, "active player update origin drift"
.assert player_state_source_end - update_player_helicopter_state = $009b, error, "player state source size drift"

; Grounded field repair requires altitude $DD and at least four carried units.
; The successful CMP #4 leaves carry set; the later AND does not change it, so
; ADC increments integrity by exactly one every eight update-counter values.
field_repair_and_service:
    ldy current_object
    lda $659c,y
    cmp #$0f
    beq field_repair_complete
    ldx $6604,y
    lda $63fc,y
    cmp #$dd
    bne field_repair_smoke
    lda $6100,x
    cmp #$04
    bcc field_repair_smoke
    lda $60c1
    and #$07
    bne field_repair_smoke
    adc $659c,y
    sta $659c,y
field_repair_smoke:
    jsr $9867
field_repair_complete:
    ldx player_index
    lda #$00
    sta $60fc,x
    jmp service_player_helicopter

field_repair_end:
.assert field_repair_and_service - selector5_start = $295d, error, "field repair origin drift"
.assert field_repair_end - field_repair_and_service = $0036, error, "field repair size drift"

; Choose the player-helicopter animation frame from horizontal velocity,
; feedback direction, prior animation state, and side-specific sprite bank.
update_player_helicopter_animation:
    ldy current_object
    ldx player_index
    lda velocity_feedback,x
    sta $61
    ldx #$00
    lda $64cc,y
    beq classify_player_animation_frame
    lda $64cc,y
    bmi player_animation_motion_ready
    inx
    bne player_animation_motion_ready
classify_player_animation_frame:
    lda $62c4,y
    cmp #$97
    bcc player_animation_frame_normalized
    sbc #$97
player_animation_frame_normalized:
    cmp #$03
    bcc player_animation_motion_ready
    inx
player_animation_motion_ready:
    stx $60
    ldx #$01
    lda $61
    beq player_animation_feedback_ready
    dex
    lda $64cc,y
    beq player_animation_feedback_ready
    lda $64cc,y
    eor $61
    bpl player_animation_feedback_ready
    ldx #$02
player_animation_feedback_ready:
    stx $61
    lda $60
    asl a
    adc $60
    adc $61
    tax
    lda $6464,y
    bpl compare_player_animation_state
    lda player_animation_feedback_states,x
    asl a
    adc #$06
    bpl store_player_animation_frame
compare_player_animation_state:
    cmp player_animation_feedback_states,x
    beq use_player_animation_index
    lda $62c4,y
    cmp #$97
    bcc player_animation_current_normalized
    sbc #$97
player_animation_current_normalized:
    cmp #$06
    bcs use_player_animation_fallback
    lda $6464,y
    asl a
    adc #$06
    bpl store_player_animation_frame
use_player_animation_fallback:
    lda #$07
    bpl store_player_animation_frame
use_player_animation_index:
    txa
store_player_animation_frame:
    sta $62c4,y
    tax
    lda player_animation_feedback_states,x
    sta $6464,y
    lda $04
    bne player_animation_done
    lda $6604,y
    bne player_animation_done
    lda $62c4,y
    clc
    adc #$97
    sta $62c4,y
player_animation_done:
    rts

; Snapshot scaled paddle targets and button states for the interactive player.
capture_interactive_player_input:
    lda horizontal_target
    sta desired_horizontal_velocity
    lda vertical_target
    sta desired_vertical_position
    lda $60c8
    sta $60e5
    lda $60c9
    sta $60e6
capture_player_action_state:
    lda $6042
    sta $6043
    sta $60f1
    lda #$00
    sta $6042
    rts

player_animation_input_source_end:
.assert update_player_helicopter_animation - selector5_start = $2993, error, "player animation origin drift"
.assert capture_interactive_player_input - selector5_start = $2a25, error, "interactive input snapshot origin drift"
.assert capture_player_action_state - selector5_start = $2a3d, error, "player action snapshot entry drift"
.assert player_animation_input_source_end - update_player_helicopter_animation = $00b9, error, "player animation/input source size drift"

; Drain fuel once per 16 update-counter values in flight, or once per 32 while
; resting at altitude $DD. Active pad service suppresses drain. Empty fuel
; transitions the helicopter into the original forced-descent path.
update_fuel_and_motion:
    ldy current_object
    ldx $6604,y
    lda $6108,x
    beq fuel_empty_descent
    lda $60fc,x
    bne fuel_continue_motion
    lda $60c1
    and #$0f
    bne fuel_continue_motion
    lda $63fc,y
    cmp #$dd
    bne drain_fuel
    lda $60c1
    and #$1f
    bne fuel_continue_motion
drain_fuel:
    dec $6108,x
    bne fuel_continue_motion
    inc $610a,x
    lda #$00
    sta $6534,y
    beq fuel_empty_descent
fuel_continue_motion:
    jsr update_player_motion
    php
    jsr $9293
    lda $60c6
    bne fuel_motion_status
    jsr $93ba
fuel_motion_status:
    plp
    bcs fuel_destroy_object
    rts

fuel_empty_descent:
    lda $6534,y
    clc
    adc #$02
    sta $6534,y
    clc
    adc $63fc,y
    sta $63fc,y
    cmp #$dd
    bcc fuel_fall_update
    lda #$dd
    sta $63fc,y
fuel_destroy_object:
    ldy current_object
    lda #$00
    sta $680c,y
    jmp $ac0c
fuel_fall_update:
    jmp $7a12

fuel_update_end:
.assert update_fuel_and_motion - selector5_start = $2a4c, error, "fuel update origin drift"
.assert fuel_update_end - update_fuel_and_motion = $006e, error, "fuel update size drift"

; Dispatch the player's grounded action or airborne weapons. Machine-gun
; rounds carry two damage units directly; bombs and smart missiles select
; object types whose initialization routines assign seven and 21.
dispatch_player_weapons:
    ldy current_object
    ldx $6604,y
    stx $60bd
    lda $60fc,x
    bne player_weapon_return
    lda $63fc,y
    cmp #$dd
    bne dispatch_airborne_weapons
    lda $60e6
    bpl player_weapon_return
    lda $6100,x
    beq player_weapon_return
    txa
    eor #$01
    asl
    adc #$04
    adc $6394,y
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    dec $6100,x
    dec $6118,x
    dec $611e,x
    lda #$0d
    sta $60a7
    lda #$00
    sta $60e1
    jmp object_constructor_jump
player_weapon_return:
    rts

dispatch_airborne_weapons:
    lda $60e5
    and $60e6
    bpl check_machine_gun
    jmp fire_smart_missile
check_machine_gun:
    bit $60e5
    bpl fire_bomb
    lda $60f6,x
    beq machine_gun_done
    lda $62c4,y
    cmp #$97
    bcc machine_gun_angle_ready
    sbc #$97
machine_gun_angle_ready:
    cmp #$07
    beq machine_gun_done
    dec $60f6,x
    tax
    lda $60ee
    beq fire_machine_gun
    jmp fire_type1a_alternate
fire_machine_gun:
    lda #$00
    sta machine_gun_page_carry
    lda machine_gun_horizontal_offsets,x
    sec
    sbc $64cc,y
    bpl machine_gun_x_offset_ready
    dec machine_gun_page_carry
machine_gun_x_offset_ready:
    clc
    adc $6394,y
    sta $60cd
    lda $632c,y
    .byte $69                 ; ADC #imm; operand is modified at $9434.
machine_gun_page_carry:
    .byte $00
    sta $60cc
    lda $63fc,y
    clc
    adc machine_gun_vertical_offsets,x
    sec
    sbc $6534,y
    sta $60ce
    lda $64cc,y
    clc
    adc machine_gun_horizontal_velocities,x
    sta $60cf
    lda machine_gun_vertical_velocities,x
    sta $60d0
    lda $6604,y
    sta $60bd
    lda #$0b
    sta $60a7
    lda #$02
    sta $60b3
    lda #$00
    sta $60a8
    jmp object_constructor_jump
machine_gun_done:
    rts

fire_bomb:
    bit $60e6
    bpl bomb_fire_done
    ldy current_object
    ldx $6604,y
    stx $60bd
    lda $60f4,x
    beq bomb_fire_done
    dec $60f4,x
    lda $6394,y
    clc
    adc #$06
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    lda $63fc,y
    sta $60ce
    lda $64cc,y
    sta $60cf
    lda #$00
    sta $60d0
    lda #$0a
    sta $60a7
    jmp object_constructor_jump
bomb_fire_done:
    rts

player_weapon_dispatch_end:
.assert dispatch_player_weapons - selector5_start = $2aba, error, "player weapon dispatch origin drift"
.assert machine_gun_page_carry - selector5_start = $2b4e, error, "machine-gun self-modified operand drift"
.assert player_weapon_dispatch_end - dispatch_player_weapons = $0110, error, "player weapon dispatch size drift"

; Clamp a signed difference to one step toward its target: -1, 0, or +1.
signed_step_clamp:
    cmp #$00
    bmi signed_step_negative
    beq signed_step_done
    lda #$01
signed_step_done:
    rts
signed_step_negative:
    lda #$ff
    rts

signed_step_clamp_end:
.assert signed_step_clamp - selector5_start = $2bca, error, "signed-step helper origin drift"
.assert signed_step_clamp_end - signed_step_clamp = $000c, error, "signed-step helper size drift"

; Process special player actions and advance pending ground-unit deployment
; before entering the authored purchase/deployment routine at $9543.
process_player_action_and_deployment:
    ldx player_index
    stx $60bd
    lda $60f1
    cmp #$a0
    bne check_player_replacement_purchase
    lda $6104,x
    bne clear_processed_player_action
    lda $6100,x
    beq store_processed_player_action
    ldy $6112,x
    lda $63fc,y
    cmp #$d3
    bcs clear_processed_player_action
    dec $6118,x
    dec $611e,x
    dec $6100,x
    jsr spawn_player_falling_infantry
    ldx player_index
clear_processed_player_action:
    lda #$00
store_processed_player_action:
    sta $60f1
check_player_replacement_purchase:
    cmp #$c8
    bne advance_pending_unit_deployment
    lda $6117
    sbc #$14
    bcc advance_pending_unit_deployment
    sta $6117
    inc $60ab
    lda #$02
    sta $60a7
    jmp deploy_create_effect
advance_pending_unit_deployment:
    lda $6110,x
    beq deploy_ground_unit
    dec $6110,x
    .byte $d0,$2a             ; BNE $9558, interior ground-unit resume entry
    lda $60fe,x
    beq deploy_ground_unit
    lda #$0d
    sta $60a7
    lda $6047,x
    asl a
    asl a
    tay
    dec $60fe,x
    bpl deploy_ground_unit_objects

player_action_prefix_source_end:
.assert process_player_action_and_deployment - selector5_start = $2bd6, error, "player action prefix origin drift"
.assert player_action_prefix_source_end - process_player_action_and_deployment = $006d, error, "player action prefix size drift"

; Purchase and deploy the ground-unit command stored in $60F1. The table index
; is shared by costs, ownership counters, caps, and object type. Both M (men)
; and E (engineers) select type $0D, with different squad counts below.
deploy_ground_unit:
    lda $60f1
    beq deploy_unit_done
    ldy #$04
find_ground_unit_command:
    cmp ground_unit_keys,y
    bne next_ground_unit_command
    lda ground_unit_types,y
    jmp ground_unit_command_found
next_ground_unit_command:
    dey
    bpl find_ground_unit_command
deploy_unit_done:
    rts
ground_unit_command_found:
    sta $60a7
    lda ground_unit_counter_offsets,y
    clc
    adc player_index
    stx $60
    tax
    lda $6118,x
    cmp ground_unit_caps,y
    ldx $60
    bcs deploy_unit_done
    lda ground_unit_costs,y
    sta pending_deployment_cost
    lda $6116,x
    sec
    sbc pending_deployment_cost
    bcc deploy_unit_done
    sta $6116,x
    lda #$80
    cpy #$04
    adc #$00
    sta $6047,x
    lda $60a7
    cmp #$0d
    bne deploy_ground_unit_objects
    sty $60
    tya
    bne deploy_engineer_pair
    ldy #$05
    bne set_infantry_count
deploy_engineer_pair:
    ldy #$02
set_infantry_count:
    dey
    tya
    sbc #$00
    sta $60fe,x
    ldy $60
deploy_ground_unit_objects:
    lda $6047,x
    sta $60e1
    lda #$11
    cpy #$04
    bne store_deploy_delay
    lda #$07
store_deploy_delay:
    sta $6110,x
    ldx $60bd
    lda deployment_horizontal_low,x
    sta $60cd
    lda deployment_horizontal_high,x
    sta $60cc
    lda $60bd
    beq deploy_create_object
deploy_create_effect:
    lda #$00
    ldx $60a7
    jsr $690c
    lda $60a7
    cmp #$02
    beq deploy_sound_only
deploy_create_object:
    lda $60b6
    bne deploy_finish_create
    lda $60bd
    beq deploy_finish_create
    lda #$20
    ldy #$10
    jsr $6903
deploy_finish_create:
    jmp object_constructor_jump
deploy_sound_only:
    lda #$20
    ldy #$10
    jmp $6903

deploy_ground_unit_end:
.assert deploy_ground_unit - selector5_start = $2c43, error, "ground-unit deployment origin drift"
.assert deploy_ground_unit_end - deploy_ground_unit = $00b2, error, "ground-unit deployment size drift"

; Fire a smart missile if its cooldown is clear and ammunition remains. The
; targeting helper at $9650 selects a target in $60A8 before object creation.
fire_smart_missile:
    ldy current_object
    ldx $6604,y
    lda $604b,x
    bne smart_missile_fire_done
    lda $6102,x
    bne smart_missile_find_target
smart_missile_fire_done:
    rts
smart_missile_find_target:
    jsr find_smart_missile_target
    bcc smart_missile_fire_done
    ldy current_object
    lda $632c,y
    sta $60cc
    lda $6394,y
    sta $60cd
    lda $63fc,y
    sec
    sbc #$03
    sta $60ce
    lda $64cc,y
    bne smart_missile_velocity_ready
    lda $64
    bne smart_missile_velocity_ready
    lda #$ff
smart_missile_velocity_ready:
    sta $60cf
    ldx $6604,y
    stx $60bd
    dec $6102,x
    lda #$03
    sta $604b,x
    lda #$12
    sta $60a7
    ldx $60a8
    lda $6124,x
    sta $60af
    jmp object_constructor_jump

fire_smart_missile_end:
.assert fire_smart_missile - selector5_start = $2cf5, error, "smart-missile firing origin drift"
.assert fire_smart_missile_end - fire_smart_missile = $005b, error, "smart-missile firing size drift"

; Search the active list in facing direction for a hostile, live object whose
; vertical bounds overlap the firing player. Success stores X in $60A8.
find_smart_missile_target:
    ldy current_object
    lda $6464,y
    bmi smart_target_search_failed
    sta $64
    lda $63fc,y
    sec
    sbc $6937
    sta $60ce
    tya
    tax
advance_smart_target_search:
    lda $64
    bne scan_smart_targets_forward
    lda $61f4,x
    bpl test_smart_target
smart_target_search_failed:
    clc
    rts
scan_smart_targets_forward:
    lda $625c,x
    bmi smart_target_search_failed
test_smart_target:
    tax
    ldy current_object
    lda $6604,x
    cmp $6604,y
    beq advance_smart_target_search
    lda $659c,x
    beq advance_smart_target_search
    lda $63fc,x
    cmp $60ce
    bcc advance_smart_target_search
    ldy $6124,x
    cpy #$08
    beq advance_smart_target_search
    cpy #$0b
    beq advance_smart_target_search
    cpy #$0a
    beq advance_smart_target_search
    cpy #$12
    beq advance_smart_target_search
    cpy #$1a
    beq advance_smart_target_search
    cpy #$02
    bne smart_target_player_ready
    stx $60a8
    sta $60
    lda $6604,x
    tax
    lda $6104,x
    php
    ldx $60a8
    plp
    bne advance_smart_target_search
    lda $60
smart_target_player_ready:
    sec
    sbc object_vertical_sizes,y
    ldy current_object
    cmp $63fc,y
    bcs advance_smart_target_search
    stx $60a8
    sec
    rts

smart_target_search_source_end:
.assert find_smart_missile_target - selector5_start = $2d50, error, "smart missile target search origin drift"
.assert smart_target_search_source_end - find_smart_missile_target = $0080, error, "smart missile target search size drift"

; Service a player helicopter when it is aligned with a valid pad. Y is the
; helicopter object; X becomes its player/resource slot through $6604,Y.
service_player_helicopter:
    ldy current_object
    ldx $6604,y
    lda #$00
    sta $610c,x
    lda $63fc,y
    cmp #$da
    bcs service_check_pad
    rts
service_check_pad:
    lda $632c,y
    cmp #$02
    beq service_relative_to_pad
    cmp #$0d
    beq service_relative_to_pad
    cmp #$07
    bne service_done
    lda $60e8
    beq service_done
    lda $6394,y
    sec
    sbc #$f0
    sta $60
    lda $632c,y
    sbc #$07
    bcs service_check_alignment
service_done:
    rts
service_relative_to_pad:
    lda $6106,x
    tax
    lda $6394,y
    sec
    sbc $6394,x
    sta $60
    lda $632c,y
    sbc $632c,x
    bne service_done
service_check_alignment:
    lda $60
    cmp #$05
    bcc service_done
    cmp #$0e
    bcs service_done
    ldx $6604,y
    lda $6108,x
    beq service_done
    inc $60fc,x
    lda #$db
    sta $63fc,y
    lda #$00
    sta $60

    ; Repair integrity to 15, gated every four update-counter values.
    lda $659c,y
    cmp #$0f
    beq service_fuel
    lda $60c1
    and #$03
    bne service_integrity_pending
    sec
    adc $659c,y
    sta $659c,y
service_integrity_pending:
    inc $60

service_fuel:
    lda $6108,x
    cmp #$80
    beq service_ammunition
    inc $6108,x
    inc $60

service_ammunition:
    lda $60ee
    bne service_ammunition_alternate
    lda $60f6,x
    cmp #$40
    beq service_bombs
    bne service_ammunition_increment
service_ammunition_alternate:
    lda $60f6,x
    cmp #$06
    beq service_bombs
    lda $60c1
    and #$07
    bne service_ammunition_pending
service_ammunition_increment:
    inc $60f6,x
service_ammunition_pending:
    inc $60

service_bombs:
    lda $60f4,x
    cmp #$0a
    beq service_missiles
    inc $60
    lda $60c1
    and #$03
    bne service_missiles
    inc $60f4,x
service_missiles:
    lda $6102,x
    cmp #$02
    beq service_ready_check
    inc $60
    lda $60c1
    and #$0f
    bne service_ready_check
    inc $6102,x
service_ready_check:
    lda $60
    bne service_return
    inc $610c,x
service_return:
    rts

service_player_helicopter_end:
.assert service_player_helicopter - selector5_start = $2dd0, error, "pad service origin drift"
.assert service_player_helicopter_end - service_player_helicopter = $00dc, error, "pad service size drift"

update_player_motion:
    ldy current_object
    lda desired_vertical_position
    ldx #$00
    cmp $63fc,y
    beq vertical_position_ready
    bcs vertical_error_ready
    ldx #$e0
vertical_error_ready:
    sec
    sbc $63fc,y
    lsr
    lsr
    lsr
    sta $60
    txa
    ora $60
    bne vertical_step_ready
    lda #$01
vertical_step_ready:
    sta $6534,y
    clc
    adc $63fc,y
vertical_position_ready:
    cmp #$dd
    bcc store_vertical_position
    lda $64cc,y
    cmp #$07
    beq vertical_grounded
    cmp #$f9
    bne vertical_airborne
vertical_grounded:
    sec
    .byte $90                  ; Never-taken BCC; operand is overlapping CLC.
vertical_airborne:
    clc
    lda #$00
    sta $64cc,y
    ldx player_index
    sta velocity_feedback,x
    lda #$dd
    sta $63fc,y
    rts

store_vertical_position:
    sta $63fc,y
    lda $64cc,y
    cmp #$07
    beq set_positive_six
    cmp #$f9
    bne horizontal_control
    lda #$fa
    bne store_horizontal_velocity
set_positive_six:
    lda #$06
store_horizontal_velocity:
    sta $64cc,y
horizontal_control:
    ldx player_index
    lda $60fc,x
    beq approach_horizontal_target
    lda #$00
    sta $64cc,y
    sta desired_horizontal_velocity
approach_horizontal_target:
    lda desired_horizontal_velocity
    sec
    sbc $64cc,y
    jsr signed_step_clamp
    sta velocity_feedback,x
    clc
    ldx #$00
    adc $64cc,y
    sta $64cc,y
    bpl horizontal_sign_ready
    dex
horizontal_sign_ready:
    clc
    adc $6394,y
    sta $60
    txa
    adc $632c,y
    sta $632c,y
    cmp #$02
    bne check_right_boundary
    lda $60
    cmp #$30
    bcc position_clamped
    sta $6394,y
    bcs position_clamped
check_right_boundary:
    cmp #$0d
    bne store_horizontal_position
    lda $60
    cmp #$d0
    bcs position_clamped
store_horizontal_position:
    lda $60
    sta $6394,y
position_clamped:
    jsr finish_position_update
    clc
    rts

flight_motion_end:
.assert update_player_motion - selector5_start = $2eac, error, "flight motion origin drift"
.assert vertical_airborne - selector5_start = $2ee5, error, "overlapping CLC origin drift"
.assert flight_motion_end - update_player_motion = $00bb, error, "flight motion size drift"

; Emit helicopter smoke every eight counter values at integrity >=7 and every
; four below 7. Smoke tier is 1 at 10..15, 2 at 5..9, and 3 at 1..4.
update_helicopter_smoke:
    lda $60c1
    and #$07
    beq smoke_emit
    ldx $659c,y
    cpx #$07
    bcs smoke_done
    and #$03
    beq smoke_emit
smoke_done:
    rts
smoke_emit:
    lda $62c4,y
    cmp #$97
    bcc smoke_index_ready
    sbc #$97
smoke_index_ready:
    tax
    lda $6394,y
    clc
    adc smoke_horizontal_offsets,x
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    lda $63fc,y
    clc
    adc smoke_vertical_offsets,x
    sta $60ce
    lda #$15
    sta $60a7
    ldx #$01
    lda $659c,y
    cmp #$0a
    bcs smoke_tier_ready
    inx
    cmp #$05
    bcs smoke_tier_ready
    inx
smoke_tier_ready:
    stx $60a8
    jmp object_constructor_jump

smoke_update_end:
.assert update_helicopter_smoke - selector5_start = $2f67, error, "smoke update origin drift"
.assert smoke_update_end - update_helicopter_smoke = $0053, error, "smoke update size drift"

increment_player_smoke_counter:
    ldx $6604,y
    inc $610a,x
    rts

; Spawn type-$19 falling infantry five horizontal units from player X. This is
; used both by the explicit airborne drop action and the ejection countdown.
spawn_player_falling_infantry:
    ldy $6112,x
    stx $60bd
    lda $6394,y
    clc
    adc #$05
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    lda $63fc,y
    sta $60ce
    lda #$19
    sta $60a7
    jmp object_constructor_jump

debug_increment_player_pool:
    bit $6046
    bpl debug_increment_player_pool_done
    inc $60ab
debug_increment_player_pool_done:
    rts

debug_toggle_60a6:
    bit $6046
    bpl debug_toggle_60a6_done
    lda $60a6
    eor #$ff
    sta $60a6
debug_toggle_60a6_done:
    rts

; Alternate weapon path selected by $60EE. A zero table entry returns through
; the shared completion byte at $992A.
fire_type1a_alternate:
    lda alternate_weapon_direction_table,x
    beq input_transition_counter_done
    sta $60cf
    lda #$05
    clc
    adc $6394,y
    sta $60cd
    lda $632c,y
    adc #$00
    sta $60cc
    lda $63fc,y
    sec
    sbc #$02
    sta $60ce
    lda #$1a
    sta $60a7
    jmp object_constructor_jump
increment_input_transition_counter:
    inc $6001
input_transition_counter_done:
    rts

debug_toggle_60ba:
    bit $6046
    bpl input_transition_counter_done
    lda $60ba
    eor #$ff
    sta $60ba
    rts

player_input_command_keys:
    .byte $cd,$d4,$c1,$c4,$c5,$c8,$a0,$c3,$9b,$92,$ca,$cb,$cc,$af,$8d,$ad,$81
player_input_command_handlers:
    .word store_input_state_6042,store_input_state_6042,store_input_state_6042
    .word store_input_state_6042,store_input_state_6042,store_input_state_6042
    .word store_input_state_6042,increment_input_exit_counter
    .word wait_for_selector_key,request_battlefield_exit,position_player_at_left_edge
    .word position_player_at_right_edge,position_player_at_center,debug_increment_player_pool
    .word debug_toggle_60a6,read_campaign_digit,debug_toggle_60ba

player_input_helpers_source_end:
.assert increment_player_smoke_counter - selector5_start = $2fba, error, "player smoke counter origin drift"
.assert spawn_player_falling_infantry - selector5_start = $2fc1, error, "falling infantry spawn origin drift"
.assert debug_increment_player_pool - selector5_start = $2fe6, error, "debug player pool origin drift"
.assert debug_toggle_60a6 - selector5_start = $2fef, error, "debug 60A6 toggle origin drift"
.assert fire_type1a_alternate - selector5_start = $2ffd, error, "alternate weapon origin drift"
.assert increment_input_transition_counter - selector5_start = $3027, error, "input transition counter origin drift"
.assert debug_toggle_60ba - selector5_start = $302b, error, "debug 60BA toggle origin drift"
.assert player_input_command_keys - selector5_start = $3039, error, "input command key table origin drift"
.assert player_input_command_handlers - selector5_start = $304a, error, "input command handler table origin drift"
.assert player_input_helpers_source_end - increment_player_smoke_counter = $00b2, error, "player input helper source size drift"

; Parallel ground-unit deployment tables, indexed in M/T/A/D/E order.
ground_unit_costs:
    .byte $05,$04,$03,$02,$05
ground_unit_keys:
    .byte $cd,$d4,$c1,$c4,$c5
ground_unit_counter_offsets:
    .byte $06,$08,$02,$0a,$06
ground_unit_caps:
    .byte $1a,$06,$07,$08,$1d
ground_unit_types:
    .byte $0d,$0e,$0f,$10,$0d

ground_unit_tables_end:
.assert ground_unit_costs - selector5_start = $306c, error, "ground-unit tables origin drift"
.assert ground_unit_tables_end - ground_unit_costs = $0019, error, "ground-unit tables size drift"

; Feedback state selected from the 3x3 player motion/animation matrix.
player_animation_feedback_states:
    .byte $00,$00,$00,$01,$01,$01,$00,$80,$01

player_animation_feedback_states_end:
.assert player_animation_feedback_states - selector5_start = $3085, error, "player animation feedback table origin drift"
.assert player_animation_feedback_states_end - player_animation_feedback_states = $0009, error, "player animation feedback table size drift"

; Signed horizontal target velocity indexed by capped paddle sample / 4.
horizontal_target_table:
    .byte $f9,$f9,$fa,$fb,$fc,$fd,$fe,$fe,$ff,$ff,$00,$00,$00
    .byte $00,$00,$01,$01,$02,$02,$03,$04,$05,$06,$07,$07,$07

horizontal_target_table_end:
.assert horizontal_target_table - selector5_start = $308e, error, "horizontal target table origin drift"
.assert horizontal_target_table_end - horizontal_target_table = $001a, error, "horizontal target table size drift"

; Compared from the last byte toward the first by the hidden input sequence.
hidden_debug_sequence_reversed:
    .byte $d9,$d0,$d0,$c9,$da       ; high-bit "YPPIZ" => entered as "ZIPPY"

hidden_debug_sequence_reversed_end:
.assert hidden_debug_sequence_reversed - selector5_start = $30a8, error, "hidden debug sequence origin drift"
.assert hidden_debug_sequence_reversed_end - hidden_debug_sequence_reversed = $0005, error, "hidden debug sequence size drift"

; Nine-way animation/aim tables used by smoke and the player machine gun.
; Machine-gun velocity bytes are original signed units indexed by rotor/gun
; angle after the forbidden index 7 has been rejected by the firing path.
smoke_horizontal_offsets:
    .byte $0a,$09,$0a,$00,$00,$00,$07,$00,$03
smoke_vertical_offsets:
    .byte $fa,$fe,$ff,$fa,$fe,$ff,$fe,$00,$fe
machine_gun_horizontal_offsets:
    .byte $ff,$ff,$ff,$0b,$0b,$0b,$ff,$00,$0b
machine_gun_vertical_offsets:
    .byte $fe,$fc,$f8,$fe,$fc,$f8,$fc,$00,$fc
machine_gun_horizontal_velocities:
    .byte $f8,$f8,$f8,$08,$08,$08,$f8,$00,$08
machine_gun_vertical_velocities:
    .byte $02,$00,$fe,$02,$00,$fe,$00,$00,$00

weapon_direction_tables_end:
.assert smoke_horizontal_offsets - selector5_start = $30ad, error, "weapon direction table origin drift"
.assert weapon_direction_tables_end - smoke_horizontal_offsets = $0036, error, "weapon direction table size drift"

; Direction/state values used by the alternate type-$1A weapon path.
alternate_weapon_direction_table:
    .byte $ff,$ff,$ff,$01,$01,$01,$ff,$00,$01

; Both command sequences are compared from their final byte toward the first.
selector_save_sequence_reversed:
    .byte $c5,$d6,$c1,$d3       ; high-bit "EVAS" => entered as "SAVE"
selector_continue_sequence_reversed:
    .byte $d4,$ce,$cf,$c3       ; high-bit "TNOC" => entered as "CONT"

deployment_horizontal_low:
    .byte $08,$f8
deployment_horizontal_high:
    .byte $02,$0d

; Initialized input/deployment workspace. Only the first byte of the three-byte
; player block has a confirmed direct consumer.
player_index:
    .byte $00
initialized_player_workspace_residual:
    .byte $00,$00
pending_deployment_cost:
    .byte $00
velocity_feedback:
    .byte $3c,$30
current_input_key:
    .byte $00
input_workspace_residual:
    .byte $00

input_tables_source_end:
.assert alternate_weapon_direction_table - selector5_start = $30e3, error, "alternate weapon table origin drift"
.assert selector_save_sequence_reversed - selector5_start = $30ec, error, "SAVE sequence origin drift"
.assert selector_continue_sequence_reversed - selector5_start = $30f0, error, "CONT sequence origin drift"
.assert deployment_horizontal_low - selector5_start = $30f4, error, "deployment low table origin drift"
.assert player_index - selector5_start = $30f8, error, "player workspace origin drift"
.assert velocity_feedback - selector5_start = $30fc, error, "velocity feedback origin drift"
.assert current_input_key - selector5_start = $30fe, error, "input key workspace origin drift"
.assert input_tables_source_end - alternate_weapon_direction_table = $001d, error, "input table/workspace size drift"

; Public module entries: initialize/reset are no-ops, stage setup clears the
; two shared status bytes, and the tick entry runs the coordinator below.
strategy_module_initialize_jump:
    jmp strategy_module_return
strategy_module_reset_jump:
    jmp strategy_module_return
strategy_module_stage_jump:
    jmp clear_strategy_status
strategy_module_tick_jump:
    jmp update_strategy_state

clear_strategy_status:
    lda #$00
    sta $60ad
    sta $60ae
strategy_module_return:
    rts

strategy_module_front_source_end:
.assert strategy_module_initialize_jump - selector5_start = $3100, error, "strategy module origin drift"
.assert clear_strategy_status - selector5_start = $310c, error, "strategy clear origin drift"
.assert strategy_module_front_source_end - strategy_module_initialize_jump = $0015, error, "strategy module front size drift"

; Coordinate the current side's strategy state. This imports its saved target
; values, updates automated command selection, delegates the still-bounded
; movement/decision helpers, clamps the vertical target, and occasionally
; synthesizes an input action when opposing helicopters are closely aligned.
update_strategy_state:
    lda #$00
    sta $60e5
    sta $60e6
    sta $60f1
    ldy current_object
    lda $6604,y
    sta strategy_side
    eor #$01
    sta strategy_opposing_side
    jsr select_strategy_command
    ldx strategy_side
    beq strategy_service_check
    lda $60c1
    bne strategy_service_check
    inc $60b4
    lda #$0a
    sta $60b5
strategy_service_check:
    lda $610e,x
    beq strategy_load_targets
    jsr reset_strategy_motion
    ldx strategy_side
strategy_load_targets:
    lda $606e,x
    sta desired_horizontal_velocity
    lda $6070,x
    sta desired_vertical_position
    lda $606c,x
    beq strategy_run_motion
    lda $6100,x
    sta $606c,x
    beq strategy_run_motion
    lda $60f1
    bne strategy_run_motion
    jsr selector5_random_byte_jump
    and #$09
    bne strategy_run_motion
    lda #$a0
    sta $60f1
strategy_run_motion:
    jsr validate_strategy_action_conditions
    bcs strategy_store_targets
    jsr $a420
strategy_store_targets:
    ldx strategy_side
    lda desired_horizontal_velocity
    sta $606e,x
    lda desired_vertical_position
    cmp #$39
    bcs strategy_vertical_ready
    lda #$39
    sta desired_vertical_position
strategy_vertical_ready:
    sta $6070,x
    lda $6102,x
    cmp #$02
    bne strategy_update_done
    lda $60c1
    and #$3f
    bne strategy_update_done
    lda $05
    cmp #$01
    beq strategy_update_done
    lda $60e5
    ora $60e6
    bmi strategy_update_done
    ldy strategy_opposing_side
    lda $6104,y
    bne strategy_update_done
    lda $6112,x
    tax
    lda $6112,y
    tay
    lda $63fc,x
    sec
    sbc $63fc,y
    bcs strategy_compare_vertical_distance
    lda $63fc,x
    sec
    sbc $63fc,y
strategy_compare_vertical_distance:
    cmp #$0a
    bcs strategy_update_done
    sty $60a8
    stx current_object
    lda #$ff
    sta $60
    lda $6394,y
    sec
    sbc $6394,x
    sta $61
    lda $632c,y
    sbc $632c,y                 ; preserved original same-index subtraction
    bcc strategy_compare_motion
    beq strategy_adjust_distance
    inc $60
strategy_adjust_distance:
    inc $61
strategy_compare_motion:
    lda desired_horizontal_velocity
    jsr clamp_strategy_direction_sign
    cmp $61
    bne strategy_update_done
    ldx strategy_side
    jsr input_module_weapon_jump
strategy_update_done:
    rts

; When the side is ready, probabilistically select the high-bit M command.
; A nonzero linked-HQ state continues into the next bounded strategy routine.
select_strategy_command:
    ldx strategy_side
    lda $6110,x
    bne strategy_command_done
    jsr selector5_random_byte_jump
    lsr a
    bcs strategy_command_done
    lda $6116,x
    cmp #$0a
    bcc strategy_command_done
    ldy $60fa,x
    lda $67a4,y
    bne strategy_linked_hq_entry
    lda #$cd                    ; high-bit M
store_strategy_command:
    sta $60f1
strategy_command_done:
    rts

strategy_coordinator_source_end:
.assert update_strategy_state - selector5_start = $3115, error, "strategy coordinator origin drift"
.assert select_strategy_command - selector5_start = $320a, error, "strategy command selector origin drift"
.assert strategy_coordinator_source_end - update_strategy_state = $0118, error, "strategy coordinator size drift"

strategy_linked_hq_entry:
    lda $6604,y
    cmp strategy_side
    beq select_strategy_resource_command
    lda $60ad,x
    bne strategy_decrement_foreign_delay
    lda #$d4                    ; high-bit T
    bne store_strategy_command
strategy_decrement_foreign_delay:
    lda $60c1
    and #$0f
    bne strategy_command_done
    dec $60ad,x
    rts

; Derive four resource scores, choose the smallest, and map its index through
; the command table. The early campaign override saturates the third score;
; index zero can be randomized to the fifth command.
select_strategy_resource_command:
    lda $611e,x
    asl a
    asl a
    sta $60
    lda $6122,x
    asl a
    asl a
    asl a
    asl a
    sec
    sbc $6122,x
    sta $61
    lda $611a,x
    asl a
    asl a
    asl a
    asl a
    adc $611a,x
    sta $62
    lda $05
    beq strategy_score_fourth_resource
    cmp #$03
    bcs strategy_score_fourth_resource
    lda #$ff
    sta $62
strategy_score_fourth_resource:
    lda $6120,x
    asl a
    asl a
    sta $63
    asl a
    asl a
    adc $63
    sta $63
    ldx #$03
    lda $63
    ldy #$02
strategy_find_smallest_score:
    cmp $60,y
    bcc strategy_next_score
    beq strategy_next_score
    tya
    tax
    lda $60,y
strategy_next_score:
    dey
    bpl strategy_find_smallest_score
    txa
    bne strategy_map_command
    jsr selector5_random_byte_jump
    and #$06
    beq strategy_map_command
    ldx #$04
strategy_map_command:
    lda strategy_command_table,x
    sta $60f1
    rts

strategy_resource_selection_end:
.assert strategy_linked_hq_entry - selector5_start = $322d, error, "strategy HQ selector origin drift"
.assert select_strategy_resource_command - selector5_start = $3249, error, "strategy resource selector origin drift"
.assert strategy_resource_selection_end - strategy_linked_hq_entry = $007d, error, "strategy resource selector size drift"

; Clear the side's pending strategy/motion state, set the default vertical
; target, and continue through the shared strategy-motion entry.
reset_strategy_motion:
    ldx strategy_side
    lda #$00
    sta $610e,x
    sta $606c,x
    lda #$00
    sta $606e,x
    lda #$dd
    sta $6070,x
    jmp strategy_resume_entry

reset_strategy_motion_end:
.assert reset_strategy_motion - selector5_start = $32aa, error, "strategy motion reset origin drift"
.assert reset_strategy_motion_end - reset_strategy_motion = $0018, error, "strategy motion reset size drift"

; First seven table-selected strategy handlers. They establish or validate
; desired motion values and then either return or enter shared bounded logic.
strategy_handle_input_gate:
    lda #$00
    sta desired_horizontal_velocity
    lda $610c,x
    bne strategy_continue_shared_update
    rts
strategy_continue_shared_update:
    jmp strategy_shared_update_entry

strategy_handle_object_altitude:
    ldy $6112,x
    lda $63fc,y
    cmp #$c9
    bcc strategy_store_object_altitude
    lda #$20
    sta desired_vertical_position
    rts
strategy_store_object_altitude:
    sta desired_vertical_position
    jmp strategy_shared_update_entry

strategy_handle_service_altitude:
    lda #$dd
    sta desired_vertical_position
    ldy $6112,x
    lda $63fc,y
    cmp #$dd
    bcs strategy_service_altitude_shared
    lda $60fc,x
    bne strategy_service_altitude_shared
    jmp strategy_prepare_entry
strategy_service_altitude_shared:
    jmp strategy_shared_update_entry

strategy_handle_saved_altitude:
    ldy $6112,x
    lda $6064,x
    sta desired_vertical_position
    sec
    sbc $63fc,y
    cmp #$02
    bcc strategy_saved_altitude_shared
    cmp #$fe
    bcs strategy_saved_altitude_shared
    rts
strategy_saved_altitude_shared:
    jmp strategy_shared_update_entry

strategy_handle_low_horizontal_speed:
    jsr strategy_prepare_entry
    jsr strategy_adjust_entry
    lda desired_horizontal_velocity
    bpl strategy_abs_speed_ready
    eor #$ff
    clc
    adc #$01
strategy_abs_speed_ready:
    cmp #$03
    bcc strategy_low_speed_shared
    rts
strategy_low_speed_shared:
    jmp strategy_shared_update_entry

strategy_handle_noop_1:
    rts
strategy_handle_noop_2:
    rts

strategy_handler_group1_end:
.assert strategy_handle_input_gate - selector5_start = $32c2, error, "strategy input-gate handler origin drift"
.assert strategy_handle_object_altitude - selector5_start = $32d0, error, "strategy altitude handler origin drift"
.assert strategy_handle_service_altitude - selector5_start = $32e6, error, "strategy service-altitude origin drift"
.assert strategy_handle_saved_altitude - selector5_start = $3300, error, "strategy saved-altitude origin drift"
.assert strategy_handle_low_horizontal_speed - selector5_start = $3319, error, "strategy low-speed handler origin drift"
.assert strategy_handle_noop_1 - selector5_start = $3331, error, "strategy noop-1 origin drift"
.assert strategy_handle_noop_2 - selector5_start = $3332, error, "strategy noop-2 origin drift"
.assert strategy_handler_group1_end - strategy_handle_input_gate = $0071, error, "strategy handler group 1 size drift"

strategy_handle_grounded_command:
    jsr strategy_prepare_entry
    lda $6100,x
    beq strategy_grounded_command_shared
    ldy $6112,x
    lda $63fc,y
    cmp #$dd
    bne strategy_grounded_command_adjust
    lda #$ff
    sta $60e6
    rts
strategy_grounded_command_adjust:
    jsr strategy_adjust_entry
    lda $60f1
    bne strategy_grounded_command_done
    lda #$a0                    ; high-bit space
    sta $60f1
strategy_grounded_command_done:
    rts
strategy_grounded_command_shared:
    jmp strategy_shared_update_entry

strategy_handle_type12_search:
    jsr strategy_prepare_entry
    lda #$12
    jsr strategy_search_type_entry
    bcc strategy_type12_search_miss
    jsr strategy_adjust_entry
    ldx strategy_side
    lda #$ff
    sta $6066,x
    jmp strategy_shared_update_entry
strategy_type12_search_miss:
    lda #$db
    sta desired_vertical_position
    ldx strategy_side
    dec $6066,x
    beq strategy_type12_search_shared
    rts
strategy_type12_search_shared:
    jmp strategy_shared_update_entry

; Walk at most four active-list links in the side-dependent direction looking
; for type $0D, then accept only a same-page nonnegative horizontal delta.
strategy_handle_type0d_proximity:
    lda $6100,x
    cmp #$04
    bcs strategy_type0d_proximity_shared
    ldy current_object
    lda #$04
    sta $60
    lda strategy_side
    bne strategy_scan_previous_links
    lda $625c,y
    bmi strategy_scan_previous_links
    tay
    lda $625c,y
    bmi strategy_scan_previous_links
    tay
strategy_scan_previous_links:
    lda strategy_side
    bne strategy_take_next_link
    lda $61f4,y
    bmi strategy_type0d_proximity_shared
    bpl strategy_test_type0d_link
strategy_take_next_link:
    lda $625c,y
    bmi strategy_type0d_proximity_shared
strategy_test_type0d_link:
    tay
    lda $6124,y
    cmp #$0d
    beq strategy_compare_type0d_position
    dec $60
    bne strategy_scan_previous_links
strategy_compare_type0d_position:
    ldx current_object
    lda $6394,x
    sec
    sbc $6394,y
    sta $60
    lda $632c,x
    sbc $632c,y
    sta $61
    bcs strategy_type0d_delta_ready
    eor #$ff
    sta $61
    lda $60
    eor #$ff
    adc #$01
    sta $60
    bcc strategy_type0d_delta_ready
    inc $61
strategy_type0d_delta_ready:
    lda $61
    bne strategy_type0d_proximity_shared
    lda $60
    bmi strategy_type0d_proximity_shared
    rts
strategy_type0d_proximity_shared:
    jmp strategy_shared_update_entry

strategy_handler_group2_end:
.assert strategy_handle_grounded_command - selector5_start = $3333, error, "strategy grounded handler origin drift"
.assert strategy_handle_type12_search - selector5_start = $335c, error, "strategy type-12 search origin drift"
.assert strategy_handle_type0d_proximity - selector5_start = $3385, error, "strategy type-0D proximity origin drift"
.assert strategy_handler_group2_end - strategy_handle_grounded_command = $00c0, error, "strategy handler group 2 size drift"

; Track the object named by $6066 when its type still matches $6068. Save its
; horizontal position, measure absolute distance from the current object, and
; use the shared path below 30 units; otherwise prepare/adjust motion directly.
strategy_handle_tracked_object:
    ldy $6066,x
    lda $6124,y
    cmp $6068,x
    bne strategy_tracked_object_shared
    lda $6394,y
    sta $6060,x
    lda $632c,y
    sta $6062,x
    ldx current_object
    lda $6394,y
    sec
    sbc $6394,x
    sta $60
    lda $632c,y
    sbc $632c,x
    sta $61
    bcs strategy_tracked_distance_ready
    eor #$ff
    sta $61
    lda $60
    eor #$ff
    sta $60
    inc $60
    bne strategy_tracked_distance_ready
    inc $61
strategy_tracked_distance_ready:
    ldx strategy_side
    lda $61
    bne strategy_tracked_object_far
    lda $60
    cmp #$1e
    bcs strategy_tracked_object_far
strategy_tracked_object_shared:
    jmp strategy_shared_update_entry
strategy_tracked_object_far:
    jsr strategy_prepare_entry
    jmp strategy_adjust_entry

strategy_tracked_object_end:
.assert strategy_handle_tracked_object - selector5_start = $33f3, error, "strategy tracked-object handler origin drift"
.assert strategy_tracked_object_end - strategy_handle_tracked_object = $0053, error, "strategy tracked-object handler size drift"

strategy_handle_countdown_motion:
    jsr strategy_prepare_entry
    jsr strategy_adjust_entry
    dec $6066,x
    beq strategy_countdown_motion_shared
    rts
strategy_countdown_motion_shared:
    jmp strategy_shared_update_entry

strategy_handle_mark_state:
    lda #$ff
    sta $605c,x
    jmp strategy_shared_update_entry

; Follow the object linked through $6114, derive a target altitude five units
; above it, and update side flags/counters from the measured separation.
strategy_handle_linked_target:
    ldy $6114,x
    bmi strategy_linked_target_shared
    jsr strategy_measure_target_entry
    lda $63fc,y
    sec
    sbc #$05
    sta desired_vertical_position
    jsr strategy_compute_delta_entry
    ldx strategy_side
    lda #$01
    sta $606c,x
    lda $60
    cmp #$60
    bcs strategy_linked_target_done
    lda $05
    cmp #$05
    bcs strategy_linked_target_late_stage
    lda $60f6,x
    beq strategy_linked_target_done
    lda $05
    cmp #$05
    bcs strategy_linked_target_mark
    dec $6066,x
    bne strategy_linked_target_done
    lda $6068,x
    sta $6066,x
strategy_linked_target_mark:
    lda #$ff
    sta $60e5
strategy_linked_target_done:
    rts
strategy_linked_target_shared:
    jmp strategy_shared_update_entry
strategy_linked_target_late_stage:
    lda $6100,x
    beq strategy_linked_target_shared
    bne strategy_linked_target_done

; Engage the opposing player's linked object when both sides are active and
; the campaign has advanced. It selects a vertical target, triggers the weapon
; entry below ten vertical units, and periodically marks relative altitude.
strategy_handle_opposing_player:
    ldy strategy_opposing_side
    lda $6104,y
    beq strategy_opponent_active
strategy_opponent_shared:
    jmp strategy_shared_update_entry
strategy_opponent_active:
    lda $6102,x
    beq strategy_opponent_shared
    lda $05
    cmp #$01
    beq strategy_opponent_shared
    lda $6112,y
    tay
    ldx current_object
    jsr strategy_compute_delta_entry
    lda $61
    bne strategy_opponent_shared
    jsr strategy_measure_target_entry
    lda #$40
    jsr strategy_search_type_entry
    lda #$dc
    bcc strategy_store_opponent_vertical
    jsr strategy_adjust_entry
    lda desired_vertical_position
strategy_store_opponent_vertical:
    sta desired_vertical_position
    ldy strategy_opposing_side
    lda $6112,y
    sta $60a8
    tay
    lda $63fc,y
    sta $60
    cmp desired_vertical_position
    bcs strategy_compare_opponent_vertical
    sta desired_vertical_position
strategy_compare_opponent_vertical:
    sec
    ldy current_object
    sbc $63fc,y
    bcs strategy_opponent_distance_ready
    lda $63fc,y
    sec
    sbc $60
strategy_opponent_distance_ready:
    cmp #$0a
    bcs strategy_mark_opponent_altitude
    ldx strategy_side
    jmp input_module_weapon_jump
strategy_mark_opponent_altitude:
    ldx strategy_opposing_side
    ldy $6112,x
    ldx current_object
    lda $63fc,x
    cmp $63fc,y
    bcs strategy_opponent_done
    lda $60c1
    and #$07
    bne strategy_opponent_done
    lda $63fc,x
    cmp $63fc,y
    bcs strategy_opponent_done
    lda #$ff
    sta $60e6
strategy_opponent_done:
    rts

strategy_handler_group3_end:
.assert strategy_handle_countdown_motion - selector5_start = $3446, error, "strategy countdown-motion origin drift"
.assert strategy_handle_mark_state - selector5_start = $3455, error, "strategy mark-state origin drift"
.assert strategy_handle_linked_target - selector5_start = $345d, error, "strategy linked-target origin drift"
.assert strategy_handle_opposing_player - selector5_start = $34ab, error, "strategy opposing-player origin drift"
.assert strategy_handler_group3_end - strategy_handle_countdown_motion = $00f4, error, "strategy handler group 3 size drift"

; Pursue the opposing player's linked object. The handler combines saved
; coordinates, vertical-size clearance, computed distance, campaign-scaled
; countdowns, horizontal extreme checks, and a final ten-unit proximity flag.
strategy_handle_opponent_pursuit:
    ldy strategy_opposing_side
    lda $6104,y
    beq strategy_opponent_pursuit_ready
strategy_opponent_pursuit_shared:
    jmp strategy_shared_update_entry
strategy_opponent_pursuit_ready:
    lda $60f4,x
    beq strategy_opponent_pursuit_shared
    lda #$36
    sta desired_vertical_position
    lda $6112,y
    tay
    lda $6394,y
    sta $6060,x
    lda $632c,y
    sta $6062,x
    jsr strategy_prepare_entry
    ldx strategy_opposing_side
    ldy $6112,x
    ldx current_object
    lda $63fc,y
    sec
    sbc object_vertical_sizes+2
    sec
    sbc $63fc,x
    php
    lsr a
    lsr a
    sta $62
    jsr strategy_compute_delta_entry
    plp
    bcc strategy_opponent_pursuit_adjust
    ldx strategy_side
    lda $61
    bne strategy_opponent_pursuit_adjust
    lda $60
    cmp $62
    bcs strategy_opponent_pursuit_adjust
    lda #$0a
    sec
    sbc $05
    cmp $606a,x
    bcs strategy_decrement_pursuit_counter
    sta $606a,x
strategy_decrement_pursuit_counter:
    dec $606a,x
    bpl strategy_opponent_pursuit_done
    lda #$ff
    sta $60e6
strategy_opponent_pursuit_done:
    rts
strategy_opponent_pursuit_adjust:
    lda desired_horizontal_velocity
    cmp #$07
    beq strategy_scale_pursuit_distance
    cmp #$f9
    bne strategy_check_opponent_proximity
strategy_scale_pursuit_distance:
    lsr $61
    ror $60
    lsr $61
    ror $60
    lda $61
    bne strategy_check_opponent_proximity
    lda $63fc,y
    sec
    sbc $60
    cmp #$3a
    bcc strategy_opponent_pursuit_return
    sta desired_vertical_position
strategy_check_opponent_proximity:
    ldy strategy_opposing_side
    lda $6112,y
    tay
    lda $63fc,y
    sta $60
    sec
    ldy current_object
    sbc $63fc,y
    bcs strategy_opponent_proximity_ready
    lda $63fc,y
    sec
    sbc $60
strategy_opponent_proximity_ready:
    cmp #$0a
    bcs strategy_opponent_pursuit_return
    lda #$ff
    sta $60e5
strategy_opponent_pursuit_return:
    rts

strategy_handle_opponent_gate:
    ldy strategy_opposing_side
    lda $6104,y
    beq strategy_opponent_gate_done
    jmp strategy_shared_update_entry
strategy_opponent_gate_done:
    rts

strategy_handler_group4_end:
.assert strategy_handle_opponent_pursuit - selector5_start = $353a, error, "strategy opponent-pursuit origin drift"
.assert strategy_handle_opponent_gate - selector5_start = $35ef, error, "strategy opponent-gate origin drift"
.assert strategy_handler_group4_end - strategy_handle_opponent_pursuit = $00c1, error, "strategy handler group 4 size drift"

; Advance the two side-indexed strategy scripts. Nonnegative table entries are
; applied through separate shared helpers; negative entries fall through to
; the next strategy phase. The SEC before the primary ADC intentionally adds
; one to its indexed phase counter.
strategy_advance_secondary_script:
    ldx strategy_side
    inc $605c,x
    ldy $605a,x
    lda strategy_secondary_script_offsets,y
    clc
    adc $605c,x
    tay
    lda strategy_secondary_script_values,y
    bmi strategy_advance_primary_script_bridge
    sta $605e,x
    jmp strategy_apply_secondary_entry
strategy_advance_primary_script_bridge:
    jmp strategy_advance_primary_script

strategy_advance_primary_script:
    ldx strategy_side
    inc $6058,x
    ldy $6056,x
    lda strategy_primary_script_offsets,y
    sec
    adc $6058,x
    tay
    lda strategy_primary_script_values,y
    bmi strategy_resume_entry
    jmp strategy_apply_primary_entry

strategy_script_advance_end:
.assert strategy_advance_secondary_script - selector5_start = $35fb, error, "secondary strategy script origin drift"
.assert strategy_advance_primary_script - selector5_start = $361a, error, "primary strategy script origin drift"
.assert strategy_script_advance_end - strategy_advance_secondary_script = $0038, error, "strategy script advance size drift"

strategy_resume_entry:
    ldx strategy_side
    ldy $6114,x
    bmi strategy_evaluate_environment
    ldx current_object
    jsr strategy_compute_delta_entry
    lda $61
    bne strategy_evaluate_environment
    lda $60
    cmp #$c0
    bcs strategy_evaluate_environment
    ldx strategy_side
    lda $6100,x
    bne strategy_choose_action6
    lda $05
    cmp #$05
    bcs strategy_evaluate_environment
    lda $60f6,x
    beq strategy_evaluate_environment
strategy_choose_action6:
    lda #$06
    jmp strategy_apply_action_entry

strategy_evaluate_environment:
    jsr strategy_evaluate_link_entry
    ldx strategy_side
    ldy current_object
    bcc strategy_evaluate_resources
    lda $05
    cmp #$01
    beq strategy_check_action5_stock
    lda $6102,x
    bne strategy_choose_action5
strategy_check_action5_stock:
    lda $60f4,x
    beq strategy_evaluate_resources
strategy_choose_action5:
    lda #$05
    jmp strategy_apply_action_entry

strategy_evaluate_resources:
    ldx strategy_side
    ldy current_object
    lda $6108,x
    cmp #$20
    bcc strategy_choose_action0
    lda $659c,y
    cmp #$05
    bcc strategy_choose_action0
    lda $60f4,x
    cmp #$02
    bcc strategy_choose_action0
    lda $60f6,x
    cmp #$02
    bcc strategy_choose_action0
    ldy $60ee
    bne strategy_scan_side_candidates
    cmp #$10
    bcs strategy_scan_side_candidates
strategy_choose_action0:
    lda #$00
strategy_apply_selected_action:
    jmp strategy_apply_action_entry

; Search the side's two candidate slots for an object whose $67A4 state is
; zero. Slot order is side-dependent; a match selects action 3.
strategy_scan_side_candidates:
    lda strategy_side
    asl a
    sta $60
strategy_scan_next_side_candidate:
    ldy $60
    lda $60be,y
    bmi strategy_advance_side_candidate
    tay
    lda $67a4,y
    bne strategy_advance_side_candidate
    tya
    sta $606a,x
    lda #$03
    bne strategy_apply_selected_action
strategy_advance_side_candidate:
    lda strategy_side
    bne strategy_scan_candidates_reverse
    inc $60
    lda $60
    cmp #$03
    bne strategy_scan_next_side_candidate
    beq strategy_compare_opponent_resources
strategy_scan_candidates_reverse:
    dec $60
    bpl strategy_scan_next_side_candidate

strategy_compare_opponent_resources:
    ldy strategy_opposing_side
    jsr strategy_find_opponent_candidate_entry
    ldx strategy_side
    ldy strategy_opposing_side
    bcc strategy_compare_weighted_resources
    sta $606a,x
    lda #$03
    bne strategy_apply_selected_action
strategy_compare_weighted_resources:
    lda $6120,y
    asl a
    asl a
    adc $611e,y
    sta $60
    lda $6120,x
    asl a
    asl a
    adc $611e,x
    cmp $60
    bcs strategy_next_decision_entry
    jsr strategy_find_active_candidate_entry
    bcc strategy_next_decision_entry
    tay
    lda $632c,y
    ldy strategy_opposing_side
    cmp #$04
    bcc strategy_next_decision_entry
    cmp #$0c
    bcs strategy_next_decision_entry
    lda #$02
strategy_apply_action2:
    jmp strategy_apply_action_entry

strategy_shared_decision_end:
.assert strategy_resume_entry - selector5_start = $3633, error, "shared strategy decision origin drift"
.assert strategy_scan_side_candidates - selector5_start = $36b3, error, "strategy candidate scan origin drift"
.assert strategy_compare_opponent_resources - selector5_start = $36e1, error, "strategy resource comparison origin drift"
.assert strategy_shared_decision_end - strategy_resume_entry = $00f2, error, "shared strategy decision size drift"

strategy_next_decision_entry:
    lda #$02
    sta $60
    ldx strategy_side
    lda $60f4,x
    cmp #$03
    bcs strategy_check_combined_stock
    dec $60
strategy_check_combined_stock:
    lda #$00
    bit $60ee
    bpl strategy_add_active_stock
    lda $60f6,x
strategy_add_active_stock:
    clc
    adc $6102,x
    cmp #$01
    bcs strategy_check_reserve_stock
    dec $60
    beq strategy_choose_action1
strategy_check_reserve_stock:
    lda $60f6,x
    cmp #$20
    bcs strategy_choose_action4
    dec $60
    bne strategy_choose_action4
strategy_choose_action1:
    lda #$01
    bne strategy_apply_action2
strategy_choose_action4:
    lda #$04
    bne strategy_apply_action2

; Scan the active list in side-dependent order for an owned type-$0E object.
; Success returns its index in A with carry set. Failure returns carry clear
; and restores Y to the opposing side. The BCC opcode at $A08C overlaps the
; following CLC byte as its unused operand; SEC makes that branch unreachable.
strategy_find_active_candidate_entry:
find_side_type0e_object:
    ldy $60df
    lda strategy_side
    bne find_type0e_choose_direction
    ldy $60e0
find_type0e_choose_direction:
    lda strategy_side
    beq find_type0e_previous
    lda $625c,y
    bpl find_type0e_test
    bmi find_type0e_not_found
find_type0e_previous:
    lda $61f4,y
    bmi find_type0e_not_found
find_type0e_test:
    tay
    lda $6124,y
    cmp #$0e
    bne find_type0e_choose_direction
    lda $6604,y
    cmp strategy_side
    bne find_type0e_choose_direction
    tya
    sec
    .byte $90                   ; unreachable BCC; operand is CLC at $A08D
find_type0e_not_found:
    clc
    ldy strategy_opposing_side
    rts

strategy_decision_fallback_end:
.assert strategy_next_decision_entry - selector5_start = $3725, error, "strategy fallback decision origin drift"
.assert find_side_type0e_object - selector5_start = $375e, error, "strategy type-0E scan origin drift"
.assert strategy_decision_fallback_end - strategy_next_decision_entry = $006d, error, "strategy fallback/scan size drift"

; Compute an absolute 16-bit horizontal delta between the side-indexed slots.
; Carry returns clear only when the high byte is zero and the preexisting $60
; scratch value is nonnegative; other cases return carry set.
strategy_compare_side_coordinate_delta:
    ldy strategy_opposing_side
    lda $6104,y
    bne strategy_side_delta_rejected
    ldx strategy_side
    lda $6394,y
    sec
    sbc $6394,x
    sta $60cd
    lda $632c,y
    sbc $632c,x
    sta $60cc
    bcs strategy_side_delta_absolute_ready
    eor #$ff
    sta $60cc
    lda $60cd
    eor #$ff
    sta $60cd
    inc $60cd
    bne strategy_side_delta_absolute_ready
    inc $60cc
strategy_side_delta_absolute_ready:
    lda $60cc
    bne strategy_side_delta_rejected
    lda $60
    bmi strategy_side_delta_rejected
    clc
    rts
strategy_side_delta_rejected:
    sec
    rts

strategy_side_delta_end:
.assert strategy_compare_side_coordinate_delta - selector5_start = $3792, error, "strategy side-delta origin drift"
.assert strategy_side_delta_end - strategy_compare_side_coordinate_delta = $0042, error, "strategy side-delta size drift"

; Three table-selected action entries. The second JMP's high operand byte at
; $A0D9 is also an LDY-zp opcode for an otherwise untabled interior entry;
; the third public entry begins at $A0DA with LDY $6106,X.
strategy_action_finalize_1:
    jmp strategy_finalize_action_entry
strategy_action_finalize_2:
    .byte $4c,$07               ; JMP $A407; high byte is the next $A4
strategy_action_overlap_ldy:
    .byte $a4                   ; high operand and LDY-zp opcode at $A0D9
strategy_action_offset_from_link:
    ldy $6106,x
    lda $6394,y
    clc
    adc #$06
    sta $6060,x
    lda $632c,y
    adc #$00
    sta $6062,x
    jmp strategy_finalize_action_entry

strategy_action_front_end:
.assert strategy_action_finalize_1 - selector5_start = $37d4, error, "strategy action-1 origin drift"
.assert strategy_action_finalize_2 - selector5_start = $37d7, error, "strategy action-2 origin drift"
.assert strategy_action_offset_from_link - selector5_start = $37da, error, "strategy link-offset action origin drift"
.assert strategy_action_front_end - strategy_action_finalize_1 = $001d, error, "strategy action front size drift"

; First phase of the next action handler. It searches for a command target,
; optionally synthesizes high-bit M, updates the linked object, or records a
; found type-$0D target before finalizing. Later phases begin at $A14C.
strategy_action_acquire_type0d:
    lda $6100,x
    cmp #$04
    bcs strategy_action_advance_primary
    ldy $605c,x
    cpy #$01
    bne strategy_action_phase2_entry
    lda $605a,x
    cmp #$03
    bne strategy_action_search_command_target
    jsr strategy_find_type0d_entry
    jmp strategy_action_check_target_result
strategy_action_search_command_target:
    jsr strategy_find_command_target_entry
strategy_action_check_target_result:
    bcs strategy_action_store_type0d_target
    lda $6110,x
    ora $60f1
    bne strategy_action_update_link
    ldy $60fa,x
    lda $6604,y
    cmp strategy_side
    beq strategy_action_queue_m
    lda $67a4,y
    bne strategy_action_advance_primary
strategy_action_queue_m:
    lda #$cd                    ; high-bit M
    sta $60f1
strategy_action_update_link:
    ldy $6106,x
    jsr strategy_update_link_entry
    jmp strategy_finalize_action_entry
strategy_action_advance_primary:
    jmp strategy_advance_primary_script
strategy_action_store_type0d_target:
    lda $60
    sta $6066,x
    lda #$0d
    sta $6068,x
    lda #$04
    sta $605c,x
    jmp strategy_finalize_action_entry

strategy_action_phase1_end:
.assert strategy_action_acquire_type0d - selector5_start = $37f1, error, "strategy type-0D action origin drift"
.assert strategy_action_store_type0d_target - selector5_start = $383a, error, "strategy type-0D target store origin drift"
.assert strategy_action_phase1_end - strategy_action_acquire_type0d = $005b, error, "strategy action phase 1 size drift"

strategy_action_phase2_entry:
    cpy #$02
    bne strategy_action_phase5_check
    lda #$04
    sta $6066,x
    jmp strategy_finalize_action_entry
strategy_action_phase5_check:
    cpy #$05
    bne strategy_action_phase7_check
    ldy $6066,x
    lda $6124,y
    cmp #$0d
    bne strategy_action_reset_phase
    lda $6394,y
    clc
    adc strategy_type0d_horizontal_low,x
    sta $6060,x
    lda $632c,y
    adc strategy_type0d_horizontal_high,x
    sta $6062,x
    jmp strategy_finalize_action_entry
strategy_action_phase7_check:
    cpy #$07
    bne strategy_action_finish_phase
strategy_action_reset_phase:
    lda #$00
    sta $605c,x
strategy_action_finish_phase:
    jmp strategy_finalize_action_entry

strategy_action_phase2_end:
.assert strategy_action_phase2_entry - selector5_start = $384c, error, "strategy action phase-2 origin drift"
.assert strategy_action_phase2_end - strategy_action_phase2_entry = $003c, error, "strategy action phase-2 size drift"

strategy_action_finalize_3:
    jmp strategy_finalize_action_entry

strategy_action_search_type40:
    lda $605c,x
    bne strategy_action_type40_finalize
    lda #$40
    jsr strategy_search_type_entry
    bcc strategy_action_type40_use_current
    inc $605c,x
strategy_action_type40_finalize:
    jmp strategy_finalize_action_entry
strategy_action_type40_use_current:
    ldy current_object
    lda $6394,y
    sta $6060,x
    lda $632c,y
    sta $6062,x
    jmp strategy_finalize_action_entry

; Find the side's type-$0E object, then continue in side-dependent list order
; until an opposing type-$06 object is found. Success returns A/carry set;
; failure returns carry clear and opposing-side Y. The $A1D8 BCC opcode again
; overlaps the following CLC byte as its unreachable operand.
strategy_find_opponent_candidate_entry:
find_opposing_type06_object:
    jsr find_side_type0e_object
    bcc find_opposing_type06_not_found
    tay
find_opposing_type06_next:
    lda strategy_side
    bne find_opposing_type06_forward
    lda $61f4,y
    bpl find_opposing_type06_test
    bmi find_opposing_type06_not_found
find_opposing_type06_forward:
    lda $625c,y
    bmi find_opposing_type06_not_found
find_opposing_type06_test:
    tay
    lda $6124,y
    cmp #$06
    bne find_opposing_type06_next
    lda $6604,y
    cmp strategy_side
    beq find_opposing_type06_next
    tya
    sec
    .byte $90                   ; unreachable BCC; operand is next CLC
find_opposing_type06_not_found:
    clc
    ldy strategy_opposing_side
    rts

strategy_action_type40_end:
.assert strategy_action_finalize_3 - selector5_start = $3888, error, "strategy finalize-3 origin drift"
.assert strategy_action_search_type40 - selector5_start = $388b, error, "strategy type-40 search action origin drift"
.assert find_opposing_type06_object - selector5_start = $38af, error, "strategy opposing type-06 scan origin drift"
.assert strategy_action_type40_end - strategy_action_finalize_3 = $0056, error, "strategy type-40/scan size drift"

; Validate the object named by $606A against its saved type. Phase zero copies
; that object/type into the active target slots; stale targets advance the
; primary script, and valid targets finalize directly.
strategy_action_track_saved_object:
    lda $605c,x
    beq strategy_action_initialize_saved_target
    ldy $606a,x
    lda $6124,y
    cmp $6068,x
    beq strategy_action_saved_target_finalize
    jmp strategy_advance_primary_script
strategy_action_initialize_saved_target:
    lda $606a,x
    sta $6066,x
    tay
    lda $6124,y
    sta $6068,x
strategy_action_saved_target_finalize:
    jmp strategy_finalize_action_entry

; In phase two, keep a valid saved target's side-offset coordinate current.
strategy_action_offset_saved_object:
    lda $605c,x
    beq strategy_action_initialize_saved_target
    cmp #$02
    bne strategy_action_offset_saved_finalize
    ldy $6066,x
    lda $6124,y
    cmp $6068,x
    bne strategy_action_offset_saved_advance
    lda $6394,y
    clc
    adc strategy_type0d_horizontal_low,x
    sta $6060,x
    lda $632c,y
    adc strategy_type0d_horizontal_high,x
    sta $6062,x
strategy_action_offset_saved_finalize:
    jmp strategy_finalize_action_entry
strategy_action_offset_saved_advance:
    jmp strategy_advance_primary_script

strategy_saved_object_actions_end:
.assert strategy_action_track_saved_object - selector5_start = $38de, error, "strategy saved-object action origin drift"
.assert strategy_action_offset_saved_object - selector5_start = $3901, error, "strategy saved-object offset origin drift"
.assert strategy_saved_object_actions_end - strategy_action_track_saved_object = $0050, error, "strategy saved-object actions size drift"

strategy_action_finalize_4:
    jmp strategy_finalize_action_entry

; Maintain a saved moving target. Early phases either finalize nearby targets
; or refresh the link when distance reaches 45 units. Later phases derive a
; vertical step count and transformed target motion before finalizing phase 2.
strategy_action_follow_moving_target:
    ldy $606a,x
    lda $6124,y
    cmp $6068,x
    bne strategy_follow_target_advance
    lda $605c,x
    beq strategy_follow_target_finalize
    cmp #$03
    bcs strategy_follow_target_trajectory
    ldx current_object
    jsr strategy_compute_delta_entry
    lda $61
    bne strategy_follow_target_refresh
    lda $60
    cmp #$2d
    bcc strategy_follow_target_trajectory
strategy_follow_target_refresh:
    ldx strategy_side
    jsr strategy_update_link_entry
    lda #$01
    sta $605c,x
strategy_follow_target_finalize:
    jmp strategy_finalize_action_entry
strategy_follow_target_advance:
    jmp strategy_advance_primary_script

strategy_follow_target_trajectory:
    ldx current_object
    lda $63fc,x
    sta $60
    lda $64cc,y
    asl a
    sta $64
    lda $6394,y
    sta $60cd
    lda $632c,y
    sta $60cc
    lda #$00
    sta $63
    lda #$dc
strategy_count_vertical_steps:
    cmp $60
    bcc strategy_vertical_steps_ready
    inc $63
    sbc $63
    bcs strategy_count_vertical_steps
strategy_vertical_steps_ready:
    lda $63
    jsr strategy_transform_motion_entry
    ldy current_object
    jsr strategy_compare_motion_entry
    lda $61
    bne strategy_follow_target_advance
    lda $60
    cmp #$07
    bcs strategy_store_follow_phase
    lda #$ff
    sta $60e6
strategy_store_follow_phase:
    lda $63
    lsr a
    sta $6066,x
    inc $6066,x
    asl a
    adc #$02
    ldy $606a,x
    jsr strategy_transform_motion_entry
    lda #$02
    sta $605c,x
    jmp strategy_finalize_action_entry

strategy_follow_action_end:
.assert strategy_action_finalize_4 - selector5_start = $392e, error, "strategy finalize-4 origin drift"
.assert strategy_action_follow_moving_target - selector5_start = $3931, error, "strategy moving-target action origin drift"
.assert strategy_follow_target_trajectory - selector5_start = $3966, error, "strategy moving-target trajectory origin drift"
.assert strategy_follow_action_end - strategy_action_finalize_4 = $0096, error, "strategy moving-target action size drift"

; A second moving-target action uses a wider 110-unit refresh threshold. Its
; late phase either promotes sentinel $FF to phase 5 or chooses a side-relative
; coordinate from the target's signed motion and marks low-altitude state.
strategy_action_follow_wide_target:
    ldy $606a,x
    lda $6124,y
    cmp $6068,x
    bne strategy_wide_target_advance
    lda $605c,x
    cmp #$03
    bcs strategy_wide_target_late_phase
    lda #$00
    sta $6066,x
    ldx current_object
    jsr strategy_compute_delta_entry
    lda $61
    bne strategy_wide_target_refresh
    lda $60
    cmp #$6e
    bcc strategy_wide_target_late_phase
strategy_wide_target_refresh:
    ldx strategy_side
    jsr strategy_update_link_entry
    lda #$01
    sta $605c,x
    jmp strategy_finalize_action_entry
strategy_wide_target_advance:
    jmp strategy_advance_primary_script

strategy_wide_target_late_phase:
    ldx strategy_side
    lda $6066,x
    cmp #$ff
    bne strategy_wide_target_choose_coordinate
    lda #$05
    sta $605c,x
    sta $6066,x
    jmp strategy_finalize_action_entry
strategy_wide_target_choose_coordinate:
    ldy $606a,x
    lda #$c9
    sta $60
    lda #$ff
    sta $61
    lda $64cc,y
    bpl strategy_wide_target_apply_coordinate
    lda #$37
    sta $60
    inc $61
strategy_wide_target_apply_coordinate:
    lda $6394,y
    clc
    adc $60
    sta $6060,x
    lda $632c,y
    adc $61
    sta $6062,x
    lda #$02
    sta $6066,x
    sta $605c,x
    ldy current_object
    lda $63fc,y
    cmp #$da
    bcc strategy_wide_target_finalize
    lda #$ff
    sta $60e5
strategy_wide_target_finalize:
    jmp strategy_finalize_action_entry

strategy_wide_target_action_end:
.assert strategy_action_follow_wide_target - selector5_start = $39c4, error, "strategy wide-target action origin drift"
.assert strategy_wide_target_late_phase - selector5_start = $39fc, error, "strategy wide-target late phase origin drift"
.assert strategy_wide_target_action_end - strategy_action_follow_wide_target = $008e, error, "strategy wide-target action size drift"

; Refresh the opposing-player link when its signed relative position requires
; it; inactive or nonnegative same-page cases advance the primary script.
strategy_action_refresh_opponent_link:
    ldy strategy_opposing_side
    lda $6104,y
    beq strategy_opponent_link_active
strategy_opponent_link_advance:
    jmp strategy_advance_primary_script
strategy_opponent_link_active:
    lda $6112,y
    tay
    ldx current_object
    jsr strategy_compute_delta_entry
    lda $61
    bne strategy_opponent_link_refresh
    lda $60
    bpl strategy_opponent_link_advance
strategy_opponent_link_refresh:
    ldx strategy_side
    jsr strategy_update_link_entry
    lda #$01
    sta $605c,x
strategy_opponent_link_finalize:
    jmp strategy_finalize_action_entry

strategy_opponent_link_action_end:
.assert strategy_action_refresh_opponent_link - selector5_start = $3a52, error, "strategy opponent-link action origin drift"
.assert strategy_opponent_link_action_end - strategy_action_refresh_opponent_link = $002b, error, "strategy opponent-link action size drift"

; Gate an action on opposing-player activity plus campaign/resource state.
strategy_action_opponent_resource_gate:
    ldy strategy_opposing_side
    lda $6104,y
    beq strategy_opponent_resource_active
strategy_opponent_resource_advance:
    jmp strategy_advance_primary_script
strategy_opponent_resource_active:
    lda $05
    cmp #$01
    beq strategy_opponent_resource_stock
    lda $6102,x
    bne strategy_opponent_resource_finalize
strategy_opponent_resource_stock:
    lda $60f4,x
    beq strategy_opponent_resource_advance
strategy_opponent_resource_finalize:
    jmp strategy_finalize_action_entry

; Select a primary strategy action and dispatch its current script phase.
strategy_apply_action_entry:
select_primary_strategy_action:
    ldx strategy_side
    sta $6056,x
    lda #$00
    sta $6058,x
strategy_apply_primary_entry:
dispatch_primary_strategy_action:
    ldx strategy_side
    ldy $6056,x
    lda strategy_primary_script_offsets,y
    tay
    lda strategy_primary_script_values,y
    sta $6054,x
    tya
    sec
    adc $6058,x
    tay
    lda strategy_primary_script_values,y
    sta $605a,x
    lda #$00
    sta $605c,x
    lda $6056,x
    asl a
    tay
    lda strategy_primary_handler_pointers,y
    sta $60
    lda strategy_primary_handler_pointers+1,y
    sta $61
    jmp ($60)

strategy_primary_dispatch_end:
.assert strategy_action_opponent_resource_gate - selector5_start = $3a7d, error, "strategy opponent-resource gate origin drift"
.assert select_primary_strategy_action - selector5_start = $3a9b, error, "primary strategy selection origin drift"
.assert dispatch_primary_strategy_action - selector5_start = $3aa6, error, "primary strategy dispatcher origin drift"
.assert strategy_primary_dispatch_end - strategy_action_opponent_resource_gate = $005c, error, "strategy gate/primary dispatch size drift"

; Advance the selected primary script. A negative phase value returns to the
; shared decision engine; otherwise dispatch the newly selected primary phase.
advance_and_dispatch_primary_strategy:
    ldx strategy_side
    ldy $6056,x
    lda strategy_primary_script_offsets,y
    sec
    adc $6058,x
    tay
    lda strategy_primary_script_values,y
    bpl strategy_store_primary_phase
    jmp strategy_resume_entry
strategy_store_primary_phase:
    sta $605a,x

; Dispatch the current secondary phase through its pointer table.
strategy_apply_secondary_entry:
dispatch_secondary_strategy_phase:
    ldx strategy_side
    lda $605a,x
    asl a
    tay
    lda strategy_secondary_handler_pointers,y
    sta $60
    lda strategy_secondary_handler_pointers+1,y
    sta $61
    jmp ($60)

; Advance a secondary script. Negative values advance the primary script;
; nonnegative values are stored and dispatched through the first handler table.
strategy_finalize_action_entry:
advance_and_dispatch_secondary_strategy:
    ldx strategy_side
    ldy $605a,x
    lda strategy_secondary_script_offsets,y
    clc
    adc $605c,x
    tay
    lda strategy_secondary_script_values,y
    bpl strategy_store_secondary_phase
    jmp strategy_advance_primary_script
strategy_store_secondary_phase:
    sta $605e,x
strategy_dispatch_first_handler:
    ldx strategy_side
    lda $605e,x
    asl a
    tay
    lda strategy_first_handler_pointers,y
    sta $60
    lda strategy_first_handler_pointers+1,y
    sta $61
    jmp ($60)

strategy_phase_dispatch_end:
.assert advance_and_dispatch_primary_strategy - selector5_start = $3ad9, error, "primary strategy advance origin drift"
.assert dispatch_secondary_strategy_phase - selector5_start = $3af2, error, "secondary strategy dispatch origin drift"
.assert advance_and_dispatch_secondary_strategy - selector5_start = $3b07, error, "secondary strategy advance origin drift"
.assert strategy_dispatch_first_handler - selector5_start = $3b20, error, "first strategy handler dispatch origin drift"
.assert strategy_phase_dispatch_end - advance_and_dispatch_primary_strategy = $005c, error, "strategy phase dispatch size drift"

; Convert the signed 16-bit horizontal distance from the current object to the
; saved strategy target into desired velocity. Same-page distances below 28
; use a table; larger positive/negative distances clamp to +7/-7. Negative
; one-page distances index the contiguous table through its $AA63 wrap base.
strategy_prepare_entry:
prepare_strategy_horizontal_velocity:
    ldx strategy_side
    ldy current_object
    lda $6060,x
    sec
    sbc $6394,y
    sta $60cd
    lda $6062,x
    sbc $632c,y
    bmi strategy_prepare_negative_distance
    bne strategy_prepare_positive_clamp
    ldy $60cd
    cpy #$1c
    bcs strategy_prepare_positive_clamp
    lda strategy_positive_velocity_table,y
    sta desired_horizontal_velocity
    rts
strategy_prepare_positive_clamp:
    lda #$07
    sta desired_horizontal_velocity
    rts
strategy_prepare_negative_distance:
    cmp #$ff
    bne strategy_prepare_negative_clamp
    ldy $60cd
    cpy #$e5
    bcc strategy_prepare_negative_clamp
    lda strategy_negative_velocity_table,y
    sta desired_horizontal_velocity
    rts
strategy_prepare_negative_clamp:
    lda #$f9
    sta desired_horizontal_velocity
    rts

strategy_action_enable_motion:
    lda #$01
    sta $606c,x
    jmp advance_and_dispatch_primary_strategy

; On phase one, copy the opposing side's candidate object coordinates. A
; missing candidate falls through to the next table-selected action at $A4A4.
strategy_action_copy_opponent_candidate:
    lda $6058,x
    cmp #$01
    bne strategy_copy_opponent_candidate_done
    lda strategy_opposing_side
    asl a
    tay
    lda $60be,y
    bmi strategy_action_random_target_entry
    tay
    lda $6394,y
    sta $6060,x
    lda $632c,y
    sta $6062,x
strategy_copy_opponent_candidate_done:
    jmp advance_and_dispatch_primary_strategy

strategy_steering_and_actions_end:
.assert prepare_strategy_horizontal_velocity - selector5_start = $3b35, error, "strategy horizontal steering origin drift"
.assert strategy_action_enable_motion - selector5_start = $3b7b, error, "strategy enable-motion action origin drift"
.assert strategy_action_copy_opponent_candidate - selector5_start = $3b83, error, "strategy opponent-candidate action origin drift"
.assert strategy_steering_and_actions_end - prepare_strategy_horizontal_velocity = $006f, error, "strategy steering/action size drift"

strategy_action_random_target_entry:
    lda $60e7
    sta $6060,x
    and #$07
    sta $60
    lda strategy_opposing_side
    asl a
    asl a
    asl a
    ora $60
    sta $6062,x
    jmp advance_and_dispatch_primary_strategy

strategy_random_target_action_end:
.assert strategy_action_random_target_entry - selector5_start = $3ba4, error, "strategy random-target action origin drift"
.assert strategy_random_target_action_end - strategy_action_random_target_entry = $0018, error, "strategy random-target action size drift"

strategy_action_type0e_candidate_entry:
    lda $6058,x
    cmp #$01
    bne strategy_type0e_candidate_phase2
    jsr find_side_type0e_object
    bcc strategy_type0e_candidate_restart
    sta $606a,x
strategy_type0e_candidate_advance:
    jmp advance_and_dispatch_primary_strategy
strategy_type0e_candidate_phase2:
    cmp #$02
    bne strategy_type0e_candidate_advance
    ldy $606a,x
    lda $6124,y
    cmp #$0e
    bne strategy_type0e_candidate_restart
    lda $6604,y
    cmp strategy_side
    beq strategy_type0e_candidate_advance
strategy_type0e_candidate_restart:
    jmp strategy_resume_entry

strategy_type0e_candidate_action_end:
.assert strategy_action_type0e_candidate_entry - selector5_start = $3bbc, error, "strategy type-0E candidate action origin drift"
.assert strategy_type0e_candidate_action_end - strategy_action_type0e_candidate_entry = $002b, error, "strategy type-0E candidate action size drift"

strategy_action_offset_any_object_entry:
    ldy $606a,x
    lda $6124,y
    bne strategy_offset_any_object_valid
    jmp strategy_resume_entry
strategy_offset_any_object_valid:
    lda $6394,y
    clc
    adc strategy_object_offset_low,x
    sta $6060,x
    lda $632c,y
    adc strategy_object_offset_high,x
    sta $6062,x
    jmp advance_and_dispatch_primary_strategy

strategy_offset_any_object_action_end:
.assert strategy_action_offset_any_object_entry - selector5_start = $3be7, error, "strategy object-offset action origin drift"
.assert strategy_offset_any_object_action_end - strategy_action_offset_any_object_entry = $0021, error, "strategy object-offset action size drift"

strategy_action_boundary_gate_entry:
    lda $6058,x
    bne strategy_boundary_gate_phase
    ldy current_object
    lda $632c,y
    ldx strategy_side
    bne strategy_boundary_gate_right
    cmp #$04
    bcs strategy_boundary_gate_enter
strategy_boundary_gate_advance:
    jmp advance_and_dispatch_primary_strategy
strategy_boundary_gate_right:
    cmp #$0c
    bcs strategy_boundary_gate_advance
strategy_boundary_gate_enter:
    inc $6058,x
    lda #$01
strategy_boundary_gate_phase:
    cmp #$01
    bne strategy_boundary_gate_phase2
    jsr strategy_find_boundary_target_entry
    bcs strategy_boundary_gate_store_target
    ldy strategy_opposing_side
    lda $6104,y
    bne strategy_boundary_choose_action1
    lda $60f4,x
    bne strategy_boundary_choose_action5
    lda $05
    cmp #$01
    beq strategy_boundary_choose_action1
    lda $6102,x
    beq strategy_boundary_gate_restart
strategy_boundary_choose_action5:
    lda #$05
    jmp strategy_apply_action_entry
strategy_boundary_choose_action1:
    lda #$01
    jmp strategy_apply_action_entry
strategy_boundary_gate_store_target:
    tya
    sta $606a,x
    lda $6124,y
    sta $6068,x
    jmp advance_and_dispatch_primary_strategy
strategy_boundary_gate_phase2:
    cmp #$02
    bne strategy_boundary_gate_finish
    ldy $606a,x
    lda $6124,y
    cmp $6068,x
    bne strategy_boundary_gate_restart
    sta $60
    ldy #$03
    lda $05
    cmp #$05
    bcs strategy_boundary_store_primary_phase
    lda $60f6,x
    beq strategy_boundary_store_primary_phase
    ldy #$05
    lda $60f4,x
    beq strategy_boundary_store_primary_phase
    lda $60
    ldy #$03
    cmp #$0e
    beq strategy_boundary_store_primary_phase
    ldy #$05
strategy_boundary_store_primary_phase:
    tya
    sta $6058,x
strategy_boundary_gate_finish:
    jmp advance_and_dispatch_primary_strategy
strategy_boundary_gate_restart:
    jmp strategy_resume_entry

strategy_boundary_gate_action_end:
.assert strategy_action_boundary_gate_entry - selector5_start = $3c08, error, "strategy boundary-gate action origin drift"
.assert strategy_boundary_gate_action_end - strategy_action_boundary_gate_entry = $0091, error, "strategy boundary-gate action size drift"

strategy_action_opponent_gate2_entry:
    ldy strategy_opposing_side
    lda $6104,y
    beq strategy_opponent_gate2_active
strategy_opponent_gate2_restart:
    jmp strategy_resume_entry
strategy_opponent_gate2_active:
    lda $05
    cmp #$01
    beq strategy_opponent_gate2_stock
    lda $6102,x
    bne strategy_opponent_gate2_advance
strategy_opponent_gate2_stock:
    lda $60f4,x
    beq strategy_opponent_gate2_restart
strategy_opponent_gate2_advance:
    jmp advance_and_dispatch_primary_strategy

strategy_opponent_gate2_action_end:
.assert strategy_action_opponent_gate2_entry - selector5_start = $3c99, error, "strategy opponent-gate-2 action origin drift"
.assert strategy_opponent_gate2_action_end - strategy_action_opponent_gate2_entry = $001e, error, "strategy opponent-gate-2 action size drift"

strategy_action_stage_delay_entry:
    lda $6058,x
    bne strategy_stage_delay_advance
    lda #$01
    ldx $05
    beq strategy_store_stage_delay
    lda #$05
    sec
    sbc $05
    asl a
strategy_store_stage_delay:
    sta $6068,x
    sta $6066,x
strategy_stage_delay_advance:
    jmp advance_and_dispatch_primary_strategy

strategy_stage_delay_action_end:
.assert strategy_action_stage_delay_entry - selector5_start = $3cb7, error, "strategy stage-delay action origin drift"
.assert strategy_stage_delay_action_end - strategy_action_stage_delay_entry = $001a, error, "strategy stage-delay action size drift"

strategy_find_type0d_entry:
; Scan type-$0D candidates in side-dependent active-list order. The optional
; owned type-$0E object supplies a side-offset reference coordinate; otherwise
; the default reference is $0800. Eligible type-$0D objects must have $67A4=0.
; A holds the collected count on return, X is restored to the strategy side,
; and $60/$60CC:$60CD retain the last candidate index/coordinate.
find_strategy_type0d_candidates:
    jsr find_side_type0e_object
    pha
    php
    lda #$04
    sec
    sbc $6100,x
    sta $60a7
    lda #$00
    sta $64
    lda #$08
    sta $65
    plp
    pla
    bcc strategy_type0d_reference_ready
    tay
    lda $6394,y
    sec
    sbc strategy_type0d_horizontal_low,x
    sta $64
    lda $632c,y
    sbc strategy_type0d_horizontal_high,x
    sta $65
strategy_type0d_reference_ready:
    ldx #$00
    lda strategy_side
    bne strategy_scan_type0d_reverse_start
    ldy $60df
strategy_scan_type0d_forward:
    lda $625c,y
    tay
    lda $632c,y
    cmp $65
    bcc strategy_test_forward_spacing
    bne strategy_type0d_forward_done
    lda $6394,y
    cmp $64
    bcs strategy_type0d_forward_done
strategy_test_forward_spacing:
    txa
    beq strategy_test_forward_candidate
    lda $6394,y
    sec
    sbc $62
    sta $61
    lda $632c,y
    sbc $63
    bne strategy_forward_spacing_large
    lda $61
    cmp #$50
    bcc strategy_test_forward_candidate
strategy_forward_spacing_large:
    cpx $60a7
    bcs strategy_type0d_return
    ldx #$00
strategy_test_forward_candidate:
    lda $6604,y
    bne strategy_scan_type0d_forward
    lda $6124,y
    cmp #$0d
    bne strategy_scan_type0d_forward
    lda $67a4,y
    bne strategy_scan_type0d_forward
    txa
    bne strategy_store_forward_candidate
    lda $632c,y
    sta $63
    lda $6394,y
    sta $62
strategy_store_forward_candidate:
    lda $6394,y
    sta $60cd
    lda $632c,y
    sta $60cc
    sty $60
    inx
    bne strategy_scan_type0d_forward
strategy_type0d_forward_done:
    clc
strategy_type0d_return:
    txa
    ldx strategy_side
    rts

strategy_scan_type0d_reverse_start:
    ldy $60e0
strategy_scan_type0d_reverse:
    lda $61f4,y
    tay
    lda $632c,y
    cmp $65
    bcc strategy_type0d_reverse_return
    bne strategy_test_reverse_spacing
    lda $6394,y
    cmp $64
    bcc strategy_type0d_reverse_return
strategy_test_reverse_spacing:
    txa
    beq strategy_test_reverse_candidate
    lda $62
    sec
    sbc $6394,y
    sta $61
    lda $63
    sbc $632c,y
    bne strategy_reverse_spacing_large
    lda $61
    cmp #$50
    bcc strategy_test_reverse_candidate
strategy_reverse_spacing_large:
    cpx #$04
    bcs strategy_type0d_reverse_return
    ldx #$00
strategy_test_reverse_candidate:
    lda $6604,y
    beq strategy_scan_type0d_reverse
    lda $6124,y
    cmp #$0d
    bne strategy_scan_type0d_reverse
    lda $67a4,y
    bne strategy_scan_type0d_reverse
    txa
    bne strategy_store_reverse_candidate
    lda $632c,y
    sta $63
    lda $6394,y
    sta $62
strategy_store_reverse_candidate:
    lda $6394,y
    sta $60cd
    lda $632c,y
    sta $60cc
    sty $60
    inx
    bne strategy_scan_type0d_reverse
strategy_type0d_reverse_done:
    clc
strategy_type0d_reverse_return:
    txa
    ldx strategy_side
    rts

strategy_type0d_candidate_scan_end:
.assert strategy_find_type0d_entry - selector5_start = $3cd1, error, "strategy type-0D scan origin drift"
.assert strategy_scan_type0d_reverse_start - selector5_start = $3d6f, error, "strategy reverse type-0D scan origin drift"
.assert strategy_type0d_candidate_scan_end - strategy_find_type0d_entry = $0108, error, "strategy type-0D scan size drift"

; Validate whether the selected primary action remains viable. Failed gates
; restart the shared decision engine and return carry set; viable actions
; return carry clear. Gates include linked-target distance, campaign/resource
; state, the shared link evaluator, fuel >=32, and integrity >=5.
validate_strategy_action_conditions:
    lda $6056,x
    cmp #$06
    beq strategy_action_conditions_valid
    ldy $6114,x
    bmi strategy_validate_action_resources
    lda $05
    cmp #$05
    bcc strategy_validate_link_distance
    lda $6100,x
    beq strategy_validate_action_resources
strategy_validate_link_distance:
    ldx current_object
    jsr strategy_compute_delta_entry
    ldx strategy_side
    lda $61
    bne strategy_validate_action_resources
    lda $60
    cmp #$c0
    bcs strategy_validate_action_resources
strategy_restart_action_with_carry:
    jsr strategy_resume_entry
    sec
    rts
strategy_validate_action_resources:
    lda $6056,x
    beq strategy_action_conditions_valid
    cmp #$05
    beq strategy_validate_action_fuel
    lda $05
    cmp #$05
    bcs strategy_validate_active_stock
    lda $60f6,x
    bne strategy_evaluate_action_link
strategy_validate_active_stock:
    lda $6102,x
    beq strategy_restart_action_with_carry
strategy_evaluate_action_link:
    jsr strategy_evaluate_link_entry
    bcs strategy_restart_action_with_carry
    ldx strategy_side
strategy_validate_action_fuel:
    lda $6108,x
    cmp #$20
    bcc strategy_restart_action_with_carry
    ldy current_object
    lda $659c,y
    cmp #$05
    bcc strategy_restart_action_with_carry
strategy_action_conditions_valid:
    clc
    rts

strategy_action_validation_end:
.assert validate_strategy_action_conditions - selector5_start = $3dd9, error, "strategy action validation origin drift"
.assert strategy_action_validation_end - validate_strategy_action_conditions = $0063, error, "strategy action validation size drift"

strategy_adjust_entry:
; Find the nearest same-page type-$08 object on either side of the current
; active-list position and derive a vertical target. A separation of 86 or
; more selects $BF; nearer objects generally select altitude-30, with one
; linked/high-altitude state using $6464+30 instead.
adjust_strategy_vertical_for_type08:
    lda #$ff
    sta $60
    ldy current_object
    lda $6394,y
    sta $60cd
    lda $632c,y
    sta $60cc
strategy_scan_type08_forward:
    lda $625c,y
    bmi strategy_scan_type08_reverse_start
    tay
    lda $6394,y
    sec
    sbc $60cd
    sta $61
    lda $632c,y
    sbc $60cc
    bne strategy_scan_type08_reverse_start
    lda $6124,y
    cmp #$08
    bne strategy_scan_type08_forward
    lda $61
    sta $60
    sty $62
strategy_scan_type08_reverse_start:
    ldy current_object
strategy_scan_type08_reverse:
    lda $61f4,y
    bmi strategy_choose_type08_distance
    tay
    lda $60cd
    sec
    sbc $6394,y
    sta $61
    lda $60cc
    sbc $632c,y
    bne strategy_choose_type08_distance
    lda $6124,y
    cmp #$08
    bne strategy_scan_type08_reverse
    sty $62
    lda $61
    cmp $60
    bcc strategy_type08_distance_ready
strategy_choose_type08_distance:
    lda $60
strategy_type08_distance_ready:
    cmp #$56
    bcc strategy_type08_near
    lda #$bf
    sta desired_vertical_position
    rts
strategy_type08_near:
    ldy $62
    lda $66d4,y
    bpl strategy_type08_check_second_link
strategy_type08_altitude_minus30:
    lda $63fc,y
    sec
    sbc #$1e
    sta desired_vertical_position
    rts
strategy_type08_check_second_link:
    lda $673c,y
    bpl strategy_type08_altitude_minus30
    lda $63fc,y
    cmp #$64
    bcc strategy_type08_altitude_minus30
    lda $6464,y
    clc
    adc #$1e
    sta desired_vertical_position
    rts

strategy_type08_vertical_adjust_end:
.assert strategy_adjust_entry - selector5_start = $3e3c, error, "strategy type-08 vertical adjust origin drift"
.assert strategy_type08_vertical_adjust_end - strategy_adjust_entry = $0093, error, "strategy type-08 vertical adjust size drift"

strategy_search_type_entry:
; Compare the nearest same-page opposing-side active object against the input
; distance threshold in A. Carry returns set when the nearest distance is below
; the threshold, clear otherwise.
strategy_opponent_within_distance:
    sta $62
    lda #$ff
    sta $60
    ldy current_object
    lda $6394,y
    sta $60cd
    lda $632c,y
    sta $60cc
strategy_scan_opponent_forward:
    lda $625c,y
    bmi strategy_scan_opponent_reverse_start
    tay
    lda $6394,y
    sec
    sbc $60cd
    sta $61
    lda $632c,y
    sbc $60cc
    bne strategy_scan_opponent_reverse_start
    lda $6604,y
    cmp strategy_opposing_side
    bne strategy_scan_opponent_forward
    lda $61
    sta $60
strategy_scan_opponent_reverse_start:
    ldy current_object
strategy_scan_opponent_reverse:
    lda $61f4,y
    bmi strategy_choose_opponent_distance
    tay
    lda $60cd
    sec
    sbc $6394,y
    sta $61
    lda $60cc
    sbc $632c,y
    bne strategy_choose_opponent_distance
    lda $6604,y
    cmp strategy_opposing_side
    bne strategy_scan_opponent_reverse
    lda $61
    cmp $60
    bcc strategy_nearest_opponent_distance_ready
strategy_choose_opponent_distance:
    lda $60
strategy_nearest_opponent_distance_ready:
    cmp $62
    bcc strategy_opponent_distance_within
    clc
    rts
strategy_opponent_distance_within:
    sec
    rts

strategy_opponent_distance_end:
.assert strategy_search_type_entry - selector5_start = $3ecf, error, "strategy opponent-distance origin drift"
.assert strategy_opponent_distance_end - strategy_search_type_entry = $006a, error, "strategy opponent-distance size drift"

strategy_find_boundary_target_entry:
; Score hostile active-list objects by absolute horizontal distance minus a
; type-ranked clearance value. Ineligible types have negative rank entries;
; inactive player-helicopter targets are also skipped. The smallest adjusted
; 16-bit distance wins, returning its index in Y with carry set, or carry clear
; when no eligible target exists.
find_best_strategy_hostile_target:
    ldy current_object
    lda $632c,y
    sta $60cc
    lda $6394,y
    sta $60cd
    lda #$ff
    sta $60
    sta $61
    sta $60a7
    ldy $60df
strategy_scan_hostile_target:
    lda $625c,y
    bmi strategy_hostile_target_scan_done
    tay
    lda $6604,y
    cmp strategy_side
    beq strategy_scan_hostile_target
    ldx $6124,y
    lda strategy_target_rank_by_type,x
    bmi strategy_scan_hostile_target
    sta $60a8
    tax
    lda $60cd
    sec
    sbc $6394,y
    sta $62
    lda $60cc
    sbc $632c,y
    sta $63
    bcs strategy_hostile_distance_absolute
    eor #$ff
    sta $63
    lda $62
    eor #$ff
    adc #$01
    sta $62
    bcc strategy_hostile_distance_absolute
    inc $63
strategy_hostile_distance_absolute:
    inc $63
    lda $62
    sec
    sbc strategy_target_clearance_by_rank,x
    sta $64
    lda $63
    sbc #$00
    sta $65
    cmp $61
    bcc strategy_hostile_target_closer
    bne strategy_scan_hostile_target
    lda $64
    cmp $60
    bcc strategy_hostile_target_closer
    bne strategy_scan_hostile_target
strategy_hostile_target_closer:
    lda $6124,y
    cmp #$02
    bne strategy_store_hostile_target
    ldx $6604,y
    lda $6104,x
    bne strategy_scan_hostile_target
strategy_store_hostile_target:
    lda $65
    sta $61
    lda $64
    sta $60
    sty $60a7
    jmp strategy_scan_hostile_target
strategy_hostile_target_scan_done:
    ldx strategy_side
    ldy $60a7
    bpl strategy_hostile_target_found
    clc
    rts
strategy_hostile_target_found:
    sec
    rts

strategy_hostile_target_scan_end:
.assert strategy_find_boundary_target_entry - selector5_start = $3f39, error, "strategy hostile-target scan origin drift"
.assert strategy_hostile_target_scan_end - strategy_find_boundary_target_entry = $009f, error, "strategy hostile-target scan size drift"

strategy_evaluate_link_entry:
; Return carry set when the opposing player is active and its linked object is
; on the same horizontal page within 128 units of the current object.
strategy_opponent_link_is_near:
    ldy strategy_opposing_side
    lda $6104,y
    bne strategy_opponent_link_not_near
    ldx $6112,y
    ldy current_object
    jsr strategy_compute_delta_entry
    lda $61
    bne strategy_opponent_link_not_near
    lda $60
    bmi strategy_opponent_link_not_near
    sec
    rts
strategy_opponent_link_not_near:
    clc
    rts

; Store the absolute 16-bit horizontal distance between objects Y and X in
; $61:$60.
strategy_compute_delta_entry:
compute_absolute_object_horizontal_distance:
    lda $6394,y
    sec
    sbc $6394,x
    sta $60
    lda $632c,y
    sbc $632c,x
    sta $61
    bcs strategy_absolute_distance_done
    eor #$ff
    sta $61
    lda $60
    eor #$ff
    adc #$01
    sta $60
    bcc strategy_absolute_distance_done
    inc $61
strategy_absolute_distance_done:
    rts

strategy_link_distance_helpers_end:
.assert strategy_evaluate_link_entry - selector5_start = $3fd8, error, "strategy opponent-link predicate origin drift"
.assert strategy_compute_delta_entry - selector5_start = $3ff5, error, "strategy absolute-distance origin drift"
.assert strategy_link_distance_helpers_end - strategy_evaluate_link_entry = $0041, error, "strategy link/distance helpers size drift"

strategy_update_link_entry:
; Store the signed midpoint between object Y and the current object into the
; side's saved strategy coordinate.
store_strategy_midpoint_to_object:
    lda $632c,y
    pha
    lda $6394,y
    ldy current_object
    sec
    sbc $6394,y
    sta $60
    pla
    sbc $632c,y
    sta $61
    clc
    bpl strategy_midpoint_rotate
    sec
strategy_midpoint_rotate:
    ror $61
    ror $60
    lda $60
    clc
    adc $6394,y
    sta $6060,x
    lda $61
    adc $632c,y
    sta $6062,x
    rts

; Store the absolute 16-bit distance between object Y and side X's saved
; strategy coordinate in $61:$60.
strategy_compare_motion_entry:
compute_distance_to_saved_strategy_coordinate:
    lda $6394,y
    sec
    sbc $6060,x
    sta $60
    lda $632c,y
    sbc $6062,x
    sta $61
    bcs strategy_saved_coordinate_distance_done
    eor #$ff
    sta $61
    lda $60
    eor #$ff
    adc #$01
    sta $60
    bcc strategy_saved_coordinate_distance_done
    inc $61
strategy_saved_coordinate_distance_done:
    rts

strategy_coordinate_helpers_end:
.assert strategy_update_link_entry - selector5_start = $4019, error, "strategy midpoint helper origin drift"
.assert strategy_compare_motion_entry - selector5_start = $4049, error, "strategy saved-coordinate distance origin drift"
.assert strategy_coordinate_helpers_end - strategy_update_link_entry = $0054, error, "strategy coordinate helpers size drift"

strategy_transform_motion_entry:
; Transform an eight-bit step mask using $64, add it to the base coordinate at
; $60CC:$60CD, then offset by half of object Y's horizontal size. The result is
; stored as the side's saved strategy coordinate.
transform_strategy_motion_coordinate:
    ldx #$fa
    stx $62
    ldx #$08
    eor #$ff
strategy_transform_next_bit:
    lsr a
    bcs strategy_transform_skip_add
    pha
    lda $62
    adc $64
    sta $62
    pla
strategy_transform_skip_add:
    dex
    bne strategy_transform_next_bit
    lda $62
    bpl strategy_transform_high_ready
    dex
strategy_transform_high_ready:
    clc
    adc $60cd
    pha
    txa
    adc $60cc
    ldx strategy_side
    sta $6062,x
    pla
    sta $6060,x
    lda $6124,y
    tay
    lda object_horizontal_sizes,y
    lsr a
    adc $6060,x
    sta $6060,x
    bcc strategy_transform_done
    inc $6062,x
strategy_transform_done:
    rts

strategy_motion_transform_end:
.assert strategy_transform_motion_entry - selector5_start = $406d, error, "strategy motion transform origin drift"
.assert strategy_motion_transform_end - strategy_transform_motion_entry = $0042, error, "strategy motion transform size drift"

strategy_find_command_target_entry:
; Find the nearest same-side type-$0D object before or after the current object
; in active-list order. Return its index in Y/$60 with carry set, or carry clear
; when neither direction supplies a candidate.
find_nearest_same_side_type0d:
    ldx current_object
    lda #$ff
    sta $62
    sta $63
    sta $64
    ldy current_object
strategy_find_type0d_forward:
    lda $625c,y
    bmi strategy_find_type0d_reverse_start
    tay
    lda $6604,y
    cmp strategy_side
    bne strategy_find_type0d_forward
    lda $6124,y
    cmp #$0d
    bne strategy_find_type0d_forward
    jsr strategy_compute_delta_entry
    lda $60
    sta $62
    lda $61
    sta $63
    sty $64
strategy_find_type0d_reverse_start:
    ldy current_object
strategy_find_type0d_reverse:
    lda $61f4,y
    bmi strategy_choose_nearest_type0d
    tay
    lda $6604,y
    cmp strategy_side
    bne strategy_find_type0d_reverse
    lda $6124,y
    cmp #$0d
    bne strategy_find_type0d_reverse
    jsr strategy_compute_delta_entry
    lda $61
    cmp $63
    bcc strategy_nearest_type0d_ready
    bne strategy_choose_nearest_type0d
    lda $60
    cmp $62
    bcc strategy_nearest_type0d_ready
strategy_choose_nearest_type0d:
    ldy $64
strategy_nearest_type0d_ready:
    cpy #$00
    clc
    bmi strategy_nearest_type0d_done
    sec
    sty $60
strategy_nearest_type0d_done:
    ldx strategy_side
    rts

; Set desired horizontal velocity to -1, 0, or +1 from the signed horizontal
; relation between object Y and the current object.
strategy_measure_target_entry:
set_strategy_direction_toward_object:
    ldx current_object
    lda $6394,y
    sec
    sbc $6394,x
    sta $60
    lda $632c,y
    sbc $632c,x
    sta $61
    bcc strategy_direction_negative
    bne strategy_direction_positive
    lda $60
    beq strategy_store_direction
strategy_direction_positive:
    lda #$01
    bne strategy_store_direction
strategy_direction_negative:
    lda #$ff
strategy_store_direction:
    sta desired_horizontal_velocity
    rts

; Clamp A to its signed direction: -1, 0, or +1.
clamp_strategy_direction_sign:
    cmp #$00
    beq strategy_direction_sign_done
    bpl strategy_direction_sign_positive
    lda #$ff
strategy_direction_sign_done:
    rts
strategy_direction_sign_positive:
    lda #$01
    rts

strategy_final_routines_end:
.assert strategy_find_command_target_entry - selector5_start = $40af, error, "strategy nearest type-0D origin drift"
.assert strategy_measure_target_entry - selector5_start = $4116, error, "strategy direction-to-object origin drift"
.assert clamp_strategy_direction_sign - selector5_start = $413c, error, "strategy direction clamp origin drift"
.assert strategy_final_routines_end - strategy_find_command_target_entry = $0099, error, "strategy final routines size drift"

; Primary action script values and per-action starting offsets.
strategy_primary_script_values:
    .byte $05,$02,$00,$01,$ff,$03,$03,$04,$05,$ff,$03,$03,$06,$05,$ff,$03
    .byte $0b,$07,$05,$ff,$01,$03,$06,$00,$09,$ff,$0a,$ff,$00,$0c,$0d,$ff
    .byte $02,$08,$ff
strategy_primary_script_offsets:
    .byte $00,$05,$0a,$0f,$14,$1c,$20

; Secondary phase stream and starting offsets used by the first handler family.
strategy_secondary_script_values:
    .byte $02,$ff,$00,$ff,$01,$04,$ff,$01,$04,$0b,$0c,$0a,$02,$09,$00,$ff
    .byte $01,$04,$ff,$02,$07,$ff,$01,$0a,$ff,$01,$0a,$ff,$01,$0d,$ff,$01
    .byte $04,$0b,$00,$ff,$01,$04,$08,$00,$ff,$0b,$ff,$01,$04,$00,$ff,$01
    .byte $0e,$0f,$ff
strategy_secondary_script_offsets:
    .byte $00,$02,$04,$07,$10,$13,$16,$19,$1c,$1f,$24,$07,$2b,$2f

; Seven 8-byte strategy progression rows plus a 16-byte residual/control row.
; Their consumers establish the row structure; individual semantic fields are
; retained without stronger names until all indirect state uses are classified.
strategy_auxiliary_progression_tables:
    .byte $00,$01,$02,$03,$04,$05,$06,$07
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$01,$01,$01,$01
    .byte $00,$00,$01,$01,$02,$02,$02,$02
    .byte $00,$01,$01,$02,$02,$03,$03,$03
    .byte $00,$01,$02,$02,$03,$03,$04,$04
    .byte $00,$01,$02,$03,$04,$04,$05,$05
    .byte $00,$01,$02,$03,$04,$05,$06,$06
    .byte $00,$01,$02,$03,$04,$05,$06,$07

; Seventeen first-stage handlers, selected by $605E.
strategy_first_handler_pointers:
    .word strategy_handle_input_gate,strategy_handle_object_altitude
    .word strategy_handle_service_altitude,strategy_handle_saved_altitude
    .word strategy_handle_low_horizontal_speed,strategy_handle_noop_1
    .word strategy_handle_noop_2,strategy_handle_grounded_command
    .word strategy_handle_type12_search,strategy_handle_type0d_proximity
    .word strategy_handle_tracked_object,strategy_handle_countdown_motion
    .word strategy_handle_mark_state,strategy_handle_linked_target
    .word strategy_handle_opposing_player,strategy_handle_opponent_pursuit
    .word strategy_handle_opponent_gate

; Fourteen secondary action handlers, selected by $605A.
strategy_secondary_handler_pointers:
    .word strategy_action_finalize_1,strategy_action_finalize_2
    .word strategy_action_offset_from_link,strategy_action_acquire_type0d
    .word strategy_action_finalize_3,strategy_action_search_type40
    .word strategy_action_track_saved_object,strategy_action_offset_saved_object
    .word strategy_action_finalize_4,strategy_action_follow_moving_target
    .word strategy_action_follow_wide_target,strategy_action_acquire_type0d
    .word strategy_action_refresh_opponent_link,strategy_action_opponent_resource_gate

; Seven primary action handlers, selected by $6056.
strategy_primary_handler_pointers:
    .word strategy_action_enable_motion,strategy_action_copy_opponent_candidate
    .word strategy_action_type0e_candidate_entry,strategy_action_offset_any_object_entry
    .word strategy_action_boundary_gate_entry,strategy_action_opponent_gate2_entry
    .word strategy_action_stage_delay_entry

strategy_pointer_table_residual:
    .byte $fa

; Negative values are addressed with base $AA63 and Y=$E5..$FF, wrapping into
; this physical span. The positive table begins at $AB63. Its final indexed
; byte overlaps the first side-specific type-$0D offset at $AB7E.
strategy_wrapped_negative_velocity_values:
    .byte $fa,$fa,$fa,$fa,$fa,$fa,$fb,$fb,$fb,$fb,$fb,$fb,$fc,$fc,$fc,$fc
    .byte $fc,$fd,$fd,$fd,$fd,$fe,$fe,$fe,$ff,$ff,$00
strategy_positive_velocity_table:
    .byte $01,$01,$02,$02,$02,$03,$03,$03,$03,$04,$04,$04,$04,$04,$05,$05
    .byte $05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06
strategy_type0d_horizontal_low:
    .byte $40,$c0
strategy_type0d_horizontal_high:
    .byte $00,$ff
strategy_object_offset_low:
    .byte $e0,$20
strategy_object_offset_high:
    .byte $ff,$00

strategy_auxiliary_flags:
    .byte $ff,$ff,$ff,$01,$01,$01,$ff,$00,$01,$00,$00,$00,$00,$01,$01,$00
    .byte $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    .byte $00,$00,$00,$00,$00

; Object-type eligibility/rank and the three rank-clearance values used by the
; hostile-target scoring scan.
strategy_target_rank_by_type:
    .byte $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$01,$ff
    .byte $02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
strategy_target_clearance_by_rank:
    .byte $00,$00,$00

strategy_command_table:
    .byte $c5,$c4,$c1,$d4,$cd       ; high-bit E/D/A/T/M
strategy_side:
    .byte $00
strategy_opposing_side:
    .byte $00
strategy_initialized_workspace:
    .res 45,$00

strategy_tables_source_end:
.assert strategy_primary_script_values - selector5_start = $4148, error, "primary strategy script table origin drift"
.assert strategy_primary_script_offsets - selector5_start = $416b, error, "primary strategy offset table origin drift"
.assert strategy_secondary_script_values - selector5_start = $4172, error, "secondary strategy script table origin drift"
.assert strategy_secondary_script_offsets - selector5_start = $41a5, error, "secondary strategy offset table origin drift"
.assert strategy_first_handler_pointers - selector5_start = $41fb, error, "first strategy handler table origin drift"
.assert strategy_secondary_handler_pointers - selector5_start = $421d, error, "secondary strategy handler table origin drift"
.assert strategy_primary_handler_pointers - selector5_start = $4239, error, "primary strategy handler table origin drift"
.assert strategy_wrapped_negative_velocity_values - selector5_start = $4248, error, "wrapped negative velocity table origin drift"
.assert strategy_positive_velocity_table - selector5_start = $4263, error, "positive velocity table origin drift"
.assert strategy_type0d_horizontal_low - selector5_start = $427e, error, "type-0D side-offset table origin drift"
.assert strategy_target_rank_by_type - selector5_start = $42ab, error, "strategy target-rank table origin drift"
.assert strategy_command_table - selector5_start = $42cc, error, "strategy command table origin drift"
.assert strategy_side - selector5_start = $42d1, error, "strategy side workspace origin drift"
.assert strategy_tables_source_end - strategy_primary_script_values = $01b8, error, "strategy table/workspace size drift"

; Public ACxx module entries. The first three initialization hooks are no-ops;
; the remaining entries expose object updating, destruction aftermath, and
; unlinking to the selector-5 main loop and collision handlers.
damage_module_init:
    jmp damage_return
damage_module_pass_init:
    jmp damage_return
damage_module_stage_init:
    jmp damage_return
damage_module_update:
    jmp $acbc
damage_module_destroy_aftermath:
    jmp dispatch_destruction_aftermath
damage_module_unlink:
    jmp unlink_destroyed_object

; Player-helicopter damage is suppressed while the shared $60A6 state is
; negative. All other objects fall through to the common integrity consumer.
dispatch_object_damage:
    ldy current_object
    lda $6124,y
    cmp #$02
    bne apply_object_damage
    lda $6604,y
    beq apply_object_damage
    lda $60a6
    bmi damage_return

damage_dispatch_source_end:
.assert damage_module_init - selector5_start = $4300, error, "damage module entry origin drift"
.assert damage_dispatch_source_end - damage_module_init = $0026, error, "damage dispatch size drift"

; Common integrity consumer. $60B3 is incoming damage; equality or underflow
; takes the destruction path, otherwise the reduced integrity is stored.
apply_object_damage:
    lda $659c,y
    beq damage_return
    bmi damage_return
    sec
    sbc $60b3
    beq destroy_damaged_object
    bcc destroy_damaged_object
    sta $659c,y
damage_return:
    rts

force_destroy_object:
    lda #$ff
    bmi store_destroyed_state
destroy_object_effect:
    ldy current_object
    lda #$02
    sec
    sbc $6604,y
    asl
    asl
    asl
    asl
    ldx $6124,y
    jmp $690c
destroy_damaged_object:
    jsr destroy_object_effect
    lda #$00
store_destroyed_state:
    ldy current_object
    sta $680c,y

damage_consumer_end:
.assert apply_object_damage - selector5_start = $4326, error, "damage consumer origin drift"
.assert damage_consumer_end - apply_object_damage = $0035, error, "damage consumer size drift"

; Destruction aftermath dispatcher. It emits the type-$11 visual selected by
; the destroyed object's type, creates table-controlled type-$0C batches, then
; dispatches any per-type cleanup handler before unlinking the object.
dispatch_destruction_aftermath:
    ldy current_object
    lda $6124,y
    beq destruction_aftermath_done
    pha
    lda $66d4,y
    sta $60e3
    jsr spawn_destruction_effect
    jsr spawn_destruction_type0c_batches
    pla
    asl
    tay
    lda destruction_handlers_by_object_type,y
    sta $60
    lda destruction_handlers_by_object_type+1,y
    sta $61
    ora $60
    beq unlink_destroyed_object
    jmp ($60)
destruction_aftermath_done:
    rts

destruction_aftermath_dispatch_end:
.assert dispatch_destruction_aftermath - selector5_start = $435b, error, "destruction aftermath origin drift"
.assert destruction_aftermath_dispatch_end - dispatch_destruction_aftermath = $002a, error, "destruction aftermath size drift"

unlink_destroyed_object:
    ldy current_object
    ldx $6124,y
    beq unlink_destroyed_done
    lda #$00
    sta $6124,y
    lda destruction_unlink_counts,x
    beq unlink_destroyed_from_active_list
    stx $60
    ora $6604,y
    tax
    dec $6118,x
    ldx $6604,y
    dec $6118,x
    ldx $60
unlink_destroyed_from_active_list:
    lda $6953,x
    beq unlink_destroyed_done
    ldx $61f4,y
    lda $625c,y
    sta $625c,x
    tay
    txa
    sta $61f4,y
unlink_destroyed_done:
    rts

unlink_destroyed_object_end:
.assert unlink_destroyed_object - selector5_start = $4385, error, "destroyed unlink origin drift"
.assert unlink_destroyed_object_end - unlink_destroyed_object = $0037, error, "destroyed unlink size drift"

; Traverse the active-object linked list and invoke the bounded collision scan
; for each live entry. Carry returns early when list mutation invalidates the
; saved predecessor; otherwise traversal continues through $625C links.
update_object_collisions:
    lda $60c6
    bne collision_update_done
    lda $60df
    sta $60c4
collision_outer_next:
    ldy $60c4
    sty $6087
collision_outer_link:
    ldx $625c,y
    stx $60c4
    lda $625c,x
    bmi collision_update_done
    jsr scan_object_collisions
    bcc collision_outer_next
    ldy $6087
    bpl collision_outer_link
collision_update_clear:
    clc
collision_update_done:
    rts

collision_update_dispatch_end:
.assert update_object_collisions - selector5_start = $43bc, error, "collision update origin drift"
.assert collision_update_dispatch_end - update_object_collisions = $0028, error, "collision update dispatch size drift"

; Build the current object's horizontal/vertical bounds, then walk later
; active-list entries until the X-ordered list is beyond the right edge.
; Candidate pairs that overlap vertically are dispatched through $AE41. Carry
; tells the outer traversal that collision handling invalidated an object.
scan_object_collisions:
    ldy $60c4
    lda $618c,y
    cmp #$01
    bne collision_update_clear
    sty $60c5
    ldx $6124,y
    cpx #$08
    beq collision_bounds_type08
    cpx #$02
    beq collision_bounds_player
collision_bounds_ordinary:
    lda $63fc,y
    sta $6084
    sec
    sbc $6935,x
    bne collision_store_upper_bound
collision_bounds_player:
    stx $60
    ldx $6604,y
    lda $6104,x
    bne collision_update_clear
    ldx $60
    bpl collision_bounds_ordinary
collision_bounds_type08:
    lda $6464,y
    sta $6084
    lda $63fc,y
collision_store_upper_bound:
    sta $6085
    lda $6394,y
    clc
    adc $6917,x
    sta $6083
    lda $632c,y
    adc #$00
    sta $6082
collision_candidate_restart:
    ldy $60c5
    sty $6088
collision_candidate_next:
    ldx $625c,y
    stx $60c5
    lda $625c,x
    bmi collision_scan_no_mutation
    lda $618c,x
    cmp #$02
    beq collision_candidate_restart
    lda $632c,x
    cmp $6082
    bcc collision_candidate_in_x_range
    bne collision_scan_no_mutation
    lda $6394,x
    cmp $6083
    bcc collision_candidate_in_x_range
    bne collision_scan_no_mutation
collision_candidate_in_x_range:
    jsr test_collision_vertical_overlap
    ldy $60c4
    ldx $6124,y
    beq collision_scan_mutated
    lda $6953,x
    beq collision_scan_mutated
    ldx $60c5
    ldy $6124,x
    beq collision_resume_predecessor
    lda $6953,y
    bne collision_candidate_restart
collision_resume_predecessor:
    ldy $6088
    bpl collision_candidate_next
collision_scan_no_mutation:
    clc
    rts
collision_scan_mutated:
    sec
    rts

; Check vertical overlap for candidate X against the current bounds in
; $6084/$6085. Type $08 uses $6464 as one bound; active player helicopters
; have an additional per-side state check before ordinary bounds are tested.
test_collision_vertical_overlap:
    ldy $6124,x
    cpy #$08
    beq collision_candidate_type08
    cpy #$02
    bne collision_candidate_ordinary
    stx $60
    lda $6604,x
    tax
    lda $6104,x
    bne collision_vertical_done
    ldx $60
collision_candidate_ordinary:
    lda $63fc,x
    cmp $6085
    bcc collision_vertical_done
    beq collision_dispatch_pair
    sbc $6935,y
    cmp $6084
    beq collision_dispatch_pair_direct
    bcs collision_vertical_done
collision_dispatch_pair_direct:
    cpy #$02
    beq collision_player_candidate_state
collision_dispatch_pair:
    jmp dispatch_collision_pair
collision_player_candidate_state:
    ldx $6604,y
    lda $6104,x
    beq collision_dispatch_pair
collision_vertical_done:
    rts
collision_candidate_type08:
    lda $63fc,x
    cmp $6084
    beq collision_dispatch_pair_direct
    bcs collision_vertical_done
    lda $6464,x
    cmp $6085
    bcs collision_dispatch_pair_direct
    rts

; Player-helicopter destruction cleanup. This clears the active state, linked
; companion type, carried-unit counts, missile link, and display/collision
; codes; side 1 can also advance the battle-exit counter in interactive play.
handle_destroyed_player_helicopter:
    ldy current_object
    ldx $6604,y
    lda $6104,x
    bne collision_vertical_done
    txa
    beq destroyed_helicopter_store_side
    lda $60b6
    ora $60c6
    bne destroyed_helicopter_store_side
    dec $60ab
    bne destroyed_helicopter_store_side
    inc $60b0
destroyed_helicopter_store_side:
    stx $60bd
    lda $63fc,y
    cmp #$d9
    bcs destroyed_helicopter_set_delay
    inc $610a,x
destroyed_helicopter_set_delay:
    lda #$30
    sta $6104,x
    lda $6118,x
    sec
    sbc $6100,x
    sta $6118,x
    lda $611e,x
    sbc $6100,x
    sta $611e,x
    lda #$ff
    sta $6114,x
    sta $62c4,y
    sta $666c,y
    ldx $66d4,y
    lda #$00
    sta $6124,x
    rts

; Preserve the pair selected by the scanner while the indirect per-type
; dispatcher at $AE41 is allowed to swap or mutate $60C4/$60C5.
dispatch_collision_pair:
    lda $60c4
    tay
    pha
    lda $60c5
    pha
    jsr dispatch_collision_handlers
    pla
    sta $60c5
    pla
    sta $60c4
    rts

collision_scanner_source_end:
.assert scan_object_collisions - selector5_start = $43e4, error, "collision scanner origin drift"
.assert collision_scanner_source_end - scan_object_collisions = $015d, error, "collision scanner size drift"

destroy_current_collision_object = $ac50

; Look up a collision handler for the first object type. If none exists, swap
; $60C4/$60C5 and try the other type before falling into the generic filters.
; Nonzero table pointers are tail-dispatched, so individual handlers retain
; full control over pair orientation and object destruction.
dispatch_collision_handlers:
    lda $6124,y
    asl
    tay
    lda collision_handlers_by_object_type+1,y
    beq collision_dispatch_swap
    sta $61
    lda collision_handlers_by_object_type,y
    sta $60
    jmp ($60)

collision_dispatch_swap:
    ldx $60c4
    ldy $60c5
    sty $60c4
    stx $60c5
    lda $6124,y
    asl
    tay
    lda collision_handlers_by_object_type+1,y
    beq collision_ignore
    sta $61
    lda collision_handlers_by_object_type,y
    sta $60
    jmp ($60)

; Collision-table handler for player helicopter type $02. It rejects benign
; infantry/debris and same-owner pairs, swaps orientation for types whose own
; handler must decide, and otherwise selects destruction or the shared resolver
; according to the candidate type and link-state fields.
handle_player_helicopter_collision:
    ldx $60c4
    ldy $60c5
    lda $6124,y
    cmp #$05
    beq player_collision_owner_check
    cmp #$16
    beq player_collision_link_check
    cmp #$17
    beq player_collision_link_check
    cmp #$04
    beq collision_dispatch_swap
    cmp #$18
    bne player_collision_other_type
collision_ignore:
    rts
player_collision_link_check:
    lda $66d4,y
    bmi destroy_collision_current
player_collision_owner_check:
    lda $6604,y
    cmp $6604,x
    beq collision_ignore
destroy_collision_current:
    stx current_object
    jmp destroy_current_collision_object
player_collision_other_type:
    cmp #$19
    beq collision_ignore
    cmp #$0d
    beq collision_ignore
    cmp #$0a
    bne player_collision_dispatch_types
player_collision_opponent_only:
    lda $6604,y
    cmp $6604,x
    beq collision_ignore
resolve_collision:
    jmp resolve_collision_pair
player_collision_dispatch_types:
    cmp #$12
    beq player_collision_opponent_only
    cmp #$1a
    beq player_collision_opponent_only
    cmp #$0b
    beq player_collision_swap
    cmp #$18
    beq player_collision_swap
    cmp #$14
    beq player_collision_swap
    cmp #$07
    beq player_collision_type07
    cmp #$08
    beq player_collision_type08
    cmp #$1b
    bne player_collision_opponent_only
player_collision_swap:
    jmp collision_dispatch_swap
player_collision_type07:
    lda $66d4,y
    ora $67a4,y
    bpl player_collision_opponent_only
    bmi resolve_collision
player_collision_type08:
    lda $66d4,y
    ora $673c,y
    bpl player_collision_opponent_only
    bmi resolve_collision

; Shared table handler for object types $12 and $1A. Headquarters and selected
; type-$05 pairs destroy the current object; hostile projectile/bomb pairs use
; the resolver, while remaining types continue through the common type checks.
handle_type12_type1a_collision:
    ldy $60c4
    ldx $60c5
    lda $6124,x
    cmp #$16
    beq destroy_collision_selected_y
    cmp #$17
    beq destroy_collision_selected_y
    cmp #$05
    beq type12_collision_type05
    cmp #$1b
    beq collision_handler_return
    lda $6124,y
    cmp #$1a
    beq type12_collision_owner_check
    lda $67a4,y
    ora $6464,y
    beq type12_collision_projectile_check
type12_collision_owner_check:
    lda $6604,y
    cmp $6604,x
    beq collision_handler_return
type12_collision_projectile_check:
    lda $6124,x
    cmp #$0b
    beq resolve_type12_collision
    cmp #$0a
    beq resolve_type12_collision
    bne collision_target_type_checks
collision_handler_return:
    rts
resolve_type12_collision:
    jmp resolve_collision_pair
type12_collision_type05:
    lda $67a4,y
    ora $6464,y
    beq destroy_collision_selected_y
    lda $6604,y
    cmp $6604,x
    beq collision_handler_return
destroy_collision_selected_y:
    sty current_object
    jmp destroy_current_collision_object

; Type-$1B handler. It ignores several object classes, halves type-$10 target
; integrity, then applies the common ownership/link/type filters. Branches into
; the already-authored damage-transfer and destruction entries are explicit.
handle_type1b_collision:
    ldy $60c5
    lda $6124,y
    cmp #$12
    beq collision_handler_return
    cmp #$0e
    beq collision_handler_return
    cmp #$1b
    beq collision_handler_return
    cmp #$10
    bne type1b_pair_ready
    lda $659c,y
    lsr
    sta $659c,y
type1b_pair_ready:
    ldy $60c4
    ldx $60c5
    lda $6124,x
    cmp #$0b
    beq collision_handler_return
    cmp #$07
    bne type1b_infantry_check
    lda $66d4,y
    ora $67a4,y
    bmi collision_load_target_type
    lda #$07
type1b_infantry_check:
    cmp #$0d
    beq type1b_bomb_check
    cmp #$19
    bne type1b_owner_check
type1b_bomb_check:
    lda $6124,y
    cmp #$0a
    beq transfer_projectile_damage
type1b_owner_check:
    lda $6124,y
    cmp #$1b
    beq collision_load_target_type
    lda $6604,y
    cmp $6604,x
    beq projectile_damage_done
collision_load_target_type:
    lda $6124,x
collision_target_type_checks:
    cmp #$17
    beq destroy_colliding_projectile
    cmp #$16
    beq destroy_colliding_projectile
    cmp #$08
    beq projectile_damage_done
    cmp #$1c
    beq destroy_collision_object
    cmp #$18
    beq destroy_collision_object
    cmp #$14
    beq destroy_collision_object
    cmp #$02
    bne type1b_damage_type_check
    ldy $60c4
    lda $6124,y
    cmp #$0b
    beq type1b_damage_type_check
    cmp #$1b
    beq type1b_damage_type_check
    jmp collision_dispatch_swap
type1b_damage_type_check:
    cmp #$12
    beq resolve_type1b_collision
    cmp #$1a
    bne transfer_projectile_damage
resolve_type1b_collision:
    jmp resolve_collision_pair

collision_dispatch_source_end:
.assert dispatch_collision_handlers - selector5_start = $4541, error, "collision dispatcher origin drift"
.assert handle_player_helicopter_collision - selector5_start = $4575, error, "player collision handler origin drift"
.assert handle_type12_type1a_collision - selector5_start = $45f4, error, "type-12/type-1A collision handler origin drift"
.assert handle_type1b_collision - selector5_start = $464b, error, "type-1B collision handler origin drift"
.assert collision_dispatch_source_end - dispatch_collision_handlers = $019b, error, "collision dispatcher size drift"

; Transfer a projectile's integrity/damage value to the common target-damage
; dispatcher, then destroy the projectile after the hit has been processed.
transfer_projectile_damage:
    lda $659c,x
    beq projectile_damage_done
    ldy $60c4
    lda $659c,y
    sta $60b3
    lda $60c5
    sta current_object
    lda $60c4
    pha
    jsr $ac12
    pla
    sta $60c4
destroy_colliding_projectile:
    lda $60c4
    sta current_object
    jmp $ac50
projectile_damage_done:
    rts

destroy_collision_object:
    lda $60c4
    sta current_object
    jmp $ac39

projectile_damage_transfer_end:
.assert transfer_projectile_damage - selector5_start = $46dc, error, "projectile damage transfer origin drift"
.assert projectile_damage_transfer_end - transfer_projectile_damage = $0032, error, "projectile damage transfer size drift"

; Object-type-$1C collision handler. Hostile type-$0D/$19 targets receive a
; fixed four integrity units of collision damage; type-$0B targets are
; destroyed directly, while bunker types delegate through swapped roles.
handle_type1c_collision:
    ldy $60c5
    ldx $60c4
    lda $6604,x
    cmp $6604,y
    beq special_collision_done
    lda $6124,y
    cmp #$16
    beq special_collision_swap
    cmp #$17
    beq special_collision_swap
    cmp #$0d
    beq apply_four_collision_damage
    cmp #$19
    bne special_collision_projectile
apply_four_collision_damage:
    sty current_object
    lda #$04
    sta $60b3
    jmp $ac12
special_collision_projectile:
    cmp #$0b
    bne special_collision_done
    sty current_object
    jmp $ac39
special_collision_done:
    rts
special_collision_swap:
    jmp $ae55

; Shared collision handler selected by object types $14 and $18. Helicopters
; are immune. Type-$0D/$19 targets receive the same fixed four damage only
; when their link state permits it; collided type-$0B projectiles are removed.
handle_type14_type18_collision:
    ldy $60c5
    ldx $60c4
    lda $6124,y
    cmp #$02
    beq special_collision_done
    cmp #$0d
    beq linked_collision_target
    cmp #$19
    bne special_collision_projectile
linked_collision_target:
    ldx $66d4,y
    bmi apply_four_collision_damage
    lda $6124,x
    cmp #$17
    beq special_collision_projectile
    cmp #$16
    beq special_collision_projectile
    bne apply_four_collision_damage

special_collision_handlers_end:
.assert handle_type1c_collision - selector5_start = $470e, error, "type-1C collision origin drift"
.assert special_collision_handlers_end - handle_type1c_collision = $0061, error, "special collision handler size drift"

; Destruction cleanup for barrage-balloon bunker type $06. Break both component
; links, subtract the object's stored count contribution, then unlink it.
cleanup_type06_destruction_links:
    ldy current_object
    lda #$ff
    ldx $66d4,y
    bmi type04_second_link
    sta $66d4,x
type04_second_link:
    ldx $673c,y
    bmi type04_adjust_counts
    sta $673c,x
type04_adjust_counts:
    ldx $6604,y
    lda $6118,x
    sec
    sbc $67a4,y
    sta $6118,x
    lda $611e,x
    sbc $67a4,y
    sta $611e,x
    jmp damage_module_unlink

; Type-$07 cleanup invalidates the back-links selected by $67A4 and $66D4.
cleanup_type07_destruction_links:
    ldy current_object
    lda #$ff
    ldx $67a4,y
    bmi type05_second_link
    sta $66d4,x
type05_second_link:
    ldx $66d4,y
    bmi type07_cleanup_done
    sta $66d4,x
type07_cleanup_done:
    jmp damage_module_unlink

; Type-$08 cleanup invalidates peer fields $67A4 and $673C through its two
; optional links before entering the common unlink path.
cleanup_type08_destruction_links:
    ldy current_object
    lda #$ff
    ldx $66d4,y
    bmi type06_second_link
    sta $67a4,x
type06_second_link:
    ldx $673c,y
    bmi type08_cleanup_done
    sta $673c,x
type08_cleanup_done:
    jmp damage_module_unlink

destruction_link_cleanup_end:
.assert cleanup_type06_destruction_links - selector5_start = $476f, error, "type-06 cleanup origin drift"
.assert cleanup_type07_destruction_links - selector5_start = $479d, error, "type-07 cleanup origin drift"
.assert cleanup_type08_destruction_links - selector5_start = $47b5, error, "type-08 cleanup origin drift"
.assert destruction_link_cleanup_end - cleanup_type06_destruction_links = $005e, error, "destruction cleanup size drift"

; Create one type-$11 destruction visual when the per-object effect table is
; nonzero and the object is in its ordinary destroyed state.
spawn_destruction_effect:
    ldx $6124,y
    stx $60cf
    lda destruction_effect_codes,x
    beq destruction_effect_done
    sta $10
    lda $680c,y
    bne destruction_effect_done
    cpx #$0e
    bne destruction_effect_position_ready
    ldx $6604,y
    beq destruction_effect_position_ready
    lda #$a1
    sta $10
destruction_effect_position_ready:
    lda $632c,y
    sta $60cc
    lda $6394,y
    sta $60cd
    lda $63fc,y
    sta $60ce
    lda #$11
    sta $60a7
    jmp object_constructor_jump
destruction_effect_done:
    rts

; Create the type-$0C batches selected by the destroyed object's control byte.
; The low seven bits are the first batch count. When bit 7 is clear, a second
; batch uses control/4 and passes bit 7 through $60A8 to the initializer.
spawn_destruction_type0c_batches:
    ldy current_object
    ldx $6124,y
    lda destruction_type0c_spawn_control,x
    beq destruction_type0c_done
    tax
    lda $680c,y
    bne destruction_type0c_done
    lda $64cc,y
    sta $60cf
    lda $6534,y
    sta $60d0
    lda $63fc,y
    sta $60ce
    cmp #$dc
    bcc destruction_type0c_position_ready
    lda $60d0
    bmi destruction_type0c_position_ready
    lda #$f9
    sta $60d0
destruction_type0c_position_ready:
    lda $632c,y
    sta $60cc
    lda $6394,y
    sta $60cd
    txa
    stx $60a8
    and #$7f
    jsr type0c_batch_jump
    lda $60a8
    bmi destruction_type0c_done
    lsr
    lsr
    ora #$80
    sta $60a8
    and #$7f
    jmp type0c_batch_jump
destruction_type0c_done:
    rts

destruction_spawn_routines_end:
.assert spawn_destruction_effect - selector5_start = $47cd, error, "destruction spawn origin drift"
.assert destruction_spawn_routines_end - spawn_destruction_effect = $0092, error, "destruction spawn size drift"

; Shared collision resolver selected above: destroy the $60C5 object first,
; restore $60C4 as current, then tail-destroy it as well.
resolve_collision_pair:
    lda $60c5
    sta current_object
    lda $60c4
    pha
    jsr destroy_current_collision_object
    pla
    sta current_object
    jmp destroy_current_collision_object

destruction_handler_indirect_trampoline:
    jmp ($60)

; Bomb type-$0A destruction handler, with an interior entry used by alternate
; projectile type $1A. The bomb entry is gated by the stage's $60ED flag. When
; low enough on screen, create type $1D seven horizontal units behind the
; object with a signed arithmetic-half velocity, then unlink.
spawn_stage_bomb_type1d_aftermath:
    lda $60ed
    beq type1d_spawn_cleanup
spawn_type1a_type1d_aftermath:
    ldy current_object
    lda $6124,y
    sta $60a8
    lda $63fc,y
    cmp #$d6
    bcc type1d_spawn_cleanup
    lda #$1d
    sta $60a7
    lda $6394,y
    sec
    sbc #$07
    sta $60cd
    lda $632c,y
    sbc #$00
    sta $60cc
    lda $64cc,y
    pha
    asl
    pla
    ror
    sta $60cf
    lda $6604,y
    sta $60bd
    jsr object_constructor_jump
type1d_spawn_cleanup:
    jmp damage_module_unlink

collision_resolution_cleanup_end:
.assert resolve_collision_pair - selector5_start = $485f, error, "collision resolver origin drift"
.assert destruction_handler_indirect_trampoline - selector5_start = $4873, error, "destruction trampoline origin drift"
.assert spawn_stage_bomb_type1d_aftermath - selector5_start = $4876, error, "stage bomb type-1D aftermath origin drift"
.assert spawn_type1a_type1d_aftermath - selector5_start = $487b, error, "type-1A type-1D aftermath origin drift"
.assert collision_resolution_cleanup_end - resolve_collision_pair = $0058, error, "collision resolution cleanup size drift"

; Dedicated type-$16/$17 bunker collision path for a hostile type-$1C
; object. This is distinct from the type-$10 demolition vehicle's arrival and
; victory handler at $8027; the precise semantic role of type $1C is retained
; as an object-type classification rather than inferred from this routine.
handle_bunker_type1c_collision:
    ldy $60c5
    ldx $60c4
    lda $6604,x
    cmp $6604,y
    beq bunker_type1c_collision_done
    lda $6124,y
    cmp #$1c
    beq bunker_type1c_hit
    jmp $ae55
bunker_type1c_hit:
    lda $67a4,x
    beq bunker_type1c_collision_done
    dec $67a4,x
    lda $6604,x
    tax
    ldy $60c4
    lda $6124,y
    cmp #$17
    beq destroy_type1c_collision_target
    dec $6118,x
    dec $611e,x
destroy_type1c_collision_target:
    stx current_object
    jmp $ac3d
bunker_type1c_collision_done:
    rts

bunker_type1c_collision_end:
.assert handle_bunker_type1c_collision - selector5_start = $48b7, error, "bunker type-1C collision origin drift"
.assert bunker_type1c_collision_end - handle_bunker_type1c_collision = $003b, error, "bunker type-1C collision size drift"

; Type-$12 destruction cleanup. If this object is the opposing side's linked
; type-$02 target, clear that link before entering the common unlink routine.
cleanup_type12_destruction_link:
    ldy current_object
    lda $673c,y
    cmp #$02
    bne type12_cleanup_unlink
    lda $6604,y
    eor #$01
    tax
    tya
    cmp $6114,x
    bne type12_cleanup_unlink
    lda #$ff
    sta $6114,x
type12_cleanup_unlink:
    jmp damage_module_unlink

; Collision-table handler for type $04. It destroys a colliding type-$02
; object when that helicopter belongs to the opposing side and the opposing
; side's $6106 link names the current type-$04 object. The final JMP operand
; overlaps collision-table byte $B22D, so only opcode/low byte are emitted here.
handle_type04_collision:
    ldy $60c5
    lda $6124,y
    cmp #$02
    bne collision_table_overlap_return
    lda $6604,y
    eor #$01
    tax
    lda $6106,x
    cmp $60c4
    bne collision_table_overlap_return
    sty current_object
    .byte $4c,$50              ; JMP $AC50; high byte is table byte at $B22D

late_cleanup_handlers_end:
.assert cleanup_type12_destruction_link - selector5_start = $48f2, error, "type-12 cleanup origin drift"
.assert handle_type04_collision - selector5_start = $4910, error, "type-04 collision origin drift"
.assert late_cleanup_handlers_end - cleanup_type12_destruction_link = $003b, error, "late cleanup handler size drift"

; Per-object collision handlers for types $00-$1D. The first low byte overlaps
; the high operand byte of the preceding JMP $AC50; the following $60 is both
; the first pointer's high byte and the preceding routine's RTS opcode.
collision_handlers_by_object_type:
    .word $60ac,$0000,handle_player_helicopter_collision,$0000,handle_type04_collision,$0000,$0000,$0000
    .word $0000,$0000,$af68,$af68,$0000,$0000,$0000,$0000
    .word $0000,$0000,handle_type12_type1a_collision,$0000,handle_type14_type18_collision,$0000
    .word handle_bunker_type1c_collision,handle_bunker_type1c_collision
    .word handle_type14_type18_collision,$0000,handle_type12_type1a_collision,handle_type1b_collision
destruction_handlers_by_object_type:
    .word handle_type1c_collision,$0000
collision_table_overlap_return = collision_handlers_by_object_type+1

collision_handler_table_end:
.assert collision_handlers_by_object_type - selector5_start = $492d, error, "collision handler table origin drift"
.assert collision_handler_table_end - collision_handlers_by_object_type = $003c, error, "collision handler table size drift"

; Per-object destruction cleanup handlers. The first two entries overlap the
; final two collision-table entries above. The final type-$1D pointer's high
; byte also serves as effect-table entry zero below.
    .word $add5,$0000,$0000,$0000,cleanup_type06_destruction_links
    .word cleanup_type07_destruction_links,cleanup_type08_destruction_links,$0000
    .word spawn_stage_bomb_type1d_aftermath,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    .word cleanup_type12_destruction_link,$0000,$0000,$0000,$0000,$0000,$0000,$0000
    .word spawn_type1a_type1d_aftermath,$0000,$0000
    .byte $00
destruction_effect_codes:
    .byte $00
destruction_handler_table_end:
.assert destruction_handlers_by_object_type - selector5_start = $4965, error, "destruction handler table origin drift"
.assert destruction_handler_table_end - destruction_handlers_by_object_type = $003c, error, "destruction handler table size drift"

; Type-$11 visual selector for each destroyed object type ($00-$1C).
    .byte $00,$4b,$00,$00,$4b,$4d,$4e,$00,$4a,$49,$49,$00,$49,$a0
    .byte $4b,$4c,$00,$00,$00,$00,$00,$00,$00,$00,$49,$00,$00,$00
destruction_effect_codes_end:

; Type-$0C destruction-spawn controls. Low seven bits give the first batch;
; values without bit 7 also create a second batch of control/4 objects.
destruction_type0c_spawn_control:
    .byte $00,$00,$14,$00,$00,$28,$0a,$05,$00,$04,$00,$00,$00,$84,$0a
    .byte $0a,$0a,$00,$06,$00,$00,$00,$00,$00,$00,$84,$0a,$00,$00
destruction_type0c_spawn_control_end:

; Per-type ownership/count adjustments consumed by the common unlink path.
destruction_unlink_counts:
    .byte $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$06,$08
    .byte $02,$0a,$00,$00,$00,$00,$00,$00,$00,$00,$06,$00,$00,$00
destruction_unlink_counts_end:

.assert destruction_effect_codes - selector5_start = $49a0, error, "destruction effect table origin drift"
.assert destruction_effect_codes_end - destruction_effect_codes = $001d, error, "destruction effect table size drift"
.assert destruction_type0c_spawn_control_end - destruction_type0c_spawn_control = $001d, error, "destruction spawn table size drift"
.assert destruction_unlink_counts_end - destruction_unlink_counts = $001d, error, "destruction unlink table size drift"

; One unclassified zero byte precedes a callable no-op and the display module.
display_module_leading_residual:
    .byte $00
display_module_noop:
    rts

; If A is three, run the strategy-side preparation hook before initializing
; display state. Other values reset the display workspace directly.
display_module_conditional_initialize:
    cmp #$03
    bne display_module_reset_jump
    jsr $a5c8
display_module_initialize_jump:
    jmp initialize_display_module
display_module_reset_jump:
    jmp reset_display_workspace
display_module_stage_jump:
    jmp initialize_display_stage
display_module_update_jump:
    jmp render_display_frame
display_module_page_sync_jump:
    jmp $b861
display_module_selector_prompt_jump:
    jmp $ba52

; Select HGR page one, clear the display tracking state, and initialize the
; two page/frame cadence bytes to 32.
initialize_display_module:
    lda #$40
    sta $00
    lda #$00
    sta $60ba
    sta $60ac
    bit $c054
initialize_display_stage:
    lda #$20
store_display_cadence:
    sta $60a2
    sta $60a3
    rts

; Render a complete battlefield frame. The caller's A selects whether the
; completed frame returns normally or transfers to the $D800 presentation
; path. Inline text records are consumed by the return-address text renderer.
render_display_frame:
    pha
    ldy $6111
    beq select_default_display_page
    ldy #$01
select_default_display_page:
    jsr $0500
    lda $04
    bne skip_auxiliary_frame_setup
    jsr $d400
skip_auxiliary_frame_setup:
    jsr $b7b6
    jsr $b653
    lda $60b6
    beq update_frame_effect
    lda $06
    beq update_frame_animation
    jsr $b619
    .byte $01,$0c,$14
    .byte $c2,$c1,$c4,$a0,$c4,$d2,$c9,$d6,$c5,$a0,$d3,$d0,$c5,$c5,$c4
    .byte $00                    ; high-bit "BAD DRIVE SPEED"
update_frame_animation:
    jsr $b893
update_frame_effect:
    dec $60ab
    jsr update_battlefield_hud
    inc $60ab
    jsr render_active_objects
    pla
    beq flip_display_page
    jmp $d800

; Toggle the HGR page base in zero page and select the matching soft switch.
flip_display_page:
    lda $00
    eor #$60
    sta $00
    bit $c054
    cmp #$20
    bne display_page_flip_done
    bit $c055
display_page_flip_done:
    rts

; Walk every live visible object and pass it to the object renderer. Stage 8
; progressively thins the set according to the two display cadence bytes.
render_active_objects:
    lda #$67
    sta current_object
    sta $60a1
    lda $05
    cmp #$08
    bne render_next_active_object
    lda $60a3
    beq suppress_stage8_object_rendering
    dec $60a2
    bne render_next_active_object
    dec $60a3
    lda $60a3
    sta $60a2
suppress_stage8_object_rendering:
    lda #$ff
    sta $60a1
render_next_active_object:
    ldy current_object
    lda $6124,y
    beq advance_active_object_renderer
    lda $618c,y
    beq advance_active_object_renderer
    bit $60a1
    bmi draw_active_object
    jsr render_object_status_marker
draw_active_object:
    jsr $b751
advance_active_object_renderer:
    dec current_object
    bpl render_next_active_object
    rts

; Reset display offsets, animation cadence, and related renderer workspace.
reset_display_workspace:
    lda #$00
    sta $03
    sta $6093
    sta $6095
    sta $609c
    lda #$80
    sta $6094
    lda #$03
    sta $609e
    lda #$20
    sta $609f
display_workspace_reset_done:
    rts

; Draw the object's compact status marker when its state, campaign stage, and
; vertical coordinate make the marker visible on the current HGR page.
render_object_status_marker:
    ldy current_object
    lda $666c,y
    bmi status_marker_done
    cpy $6112
    bne status_marker_eligible
    ldx $05
    cpx #$07
    bcs display_workspace_reset_done
status_marker_eligible:
    pha
    and #$07
    sta $0200
    lda $6394,y
    sta $11
    lda $632c,y
    asl $11
    rol a
    sta $60
    asl $11
    rol a
    asl $11
    rol a
    adc $60
    adc #$30
    sta $11
    lda $63fc,y
    sec
    sbc #$20
    bcc discard_status_marker_state
    lsr a
    lsr a
    lsr a
    lsr a
    lsr a
    sta $12
    jsr $0204
    pla
    cmp #$08
    bcc status_marker_done
    inc $12
    jmp $0204
discard_status_marker_state:
    pla
status_marker_done:
    rts

; Display battle-completion and pending-state feedback, then fall through to
; the fuel HUD so the public HUD call updates the whole status area.
update_battlefield_hud:
    lda $60c6
    beq check_pending_hud_feedback
    jsr $b619
    .byte $01,$0e,$12
    .byte $c2,$c1,$d4,$d4,$cc,$c5,$a0,$cf,$d6,$c5,$d2
    .byte $00                    ; high-bit "BATTLE OVER"
check_pending_hud_feedback:
    lda $60b6
    beq check_display_overlay_state
    lda $60b2
    beq check_display_overlay_state
    jsr $b619
    .byte $01,$27,$05,$a2,$00
check_display_overlay_state:
    lda $60ab
    bmi draw_display_overlay_marker
    lda $60c6
    cmp #$01
    bne update_fuel_hud
draw_display_overlay_marker:
    lda #$80
    sta $11
    lda #$66
    sta $12
    lda #$55
    jsr $b870

display_module_source_end:
.assert display_module_leading_residual - selector5_start = $49f7, error, "display module origin drift"
.assert display_module_initialize_jump - selector5_start = $4a00, error, "display module jump-table origin drift"
.assert initialize_display_module - selector5_start = $4a12, error, "display initializer origin drift"
.assert render_display_frame - selector5_start = $4a2a, error, "display frame renderer origin drift"
.assert render_active_objects - selector5_start = $4a87, error, "active-object renderer origin drift"
.assert reset_display_workspace - selector5_start = $4acb, error, "display reset origin drift"
.assert render_object_status_marker - selector5_start = $4ae8, error, "status-marker renderer origin drift"
.assert update_battlefield_hud - selector5_start = $4b38, error, "battlefield HUD origin drift"
.assert display_module_source_end - display_module_leading_residual = $0183, error, "display module source size drift"

; Render zero/low-fuel feedback, announce completed pad service, and emit the
; critical-fuel speaker tick below 16 units when $60B6 permits it.
update_fuel_hud:
    ldx $60b9
    lda $6108,x
    bne hud_check_low_fuel
    ldx #$74
    lda #$7e
    ldy #$53
    bne hud_draw_warning
hud_check_low_fuel:
    ldx $60b9
    lda $6104,x
    bne hud_check_pending_state
    lda $6108,x
    cmp #$22
    bcs hud_check_service_ready
    ldx #$71
    lda #$81
    ldy #$52
hud_draw_warning:
    stx $11
    pha
    lda #$80
    sta $12
    tya
    jsr $b870
    pla
    sta $11
    lda #$80
    sta $12
    lda #$54
    jsr $b870
hud_check_service_ready:
    ldx $60b9
    lda $60fc,x
    and $610c,x
    beq hud_check_pending_state
    lda #$02
    sta $0200
    jsr $b80a
hud_check_pending_state:
    lda $60b4
    beq hud_check_critical
    lda #$06
    sta $6093
    lda $60b5
    sta $6092
    lda #$00
    sta $60b4
hud_check_critical:
    ldy $6093
    bne update_fuel_indicator
    ldx $60b9
    lda $6108,x
    cmp #$10
    bcs fuel_hud_done
    jsr $b9f2
    lda $60b6
    bne fuel_hud_done
    bit $c030
fuel_hud_done:
    rts

fuel_hud_end:
.assert update_fuel_hud - selector5_start = $4b7a, error, "fuel HUD origin drift"
.assert fuel_hud_end - update_fuel_hud = $007f, error, "fuel HUD size drift"

; Select a stage-specific fuel/status source through a self-modified absolute-X
; load, then draw the corresponding two-character bar or block pattern.
update_fuel_indicator:
    lda $badb,y
    sta fuel_indicator_count_operand
    lda $bae1,y
    sta fuel_indicator_count_operand+1
    lda $60ee
    beq store_fuel_indicator_state
    ldx $60b9
    lda $60f6,x
store_fuel_indicator_state:
    sta $60a0
    .byte $ae
fuel_indicator_count_operand:
    .word $1234                 ; self-modified LDX absolute operand
    bne draw_fuel_indicator
    jsr reload_fuel_indicator_cadence
    jmp hud_check_critical

draw_fuel_indicator:
    lda #$00
    sta $01
    lda #$05
    sta $02
    ldy $60b9
    lda $60fc,y
    and $610c,y
    beq draw_critical_fuel_pattern
    jmp select_fuel_indicator_pattern
draw_critical_fuel_pattern:
    txa
    pha
    jsr $b9f2
    pla
    tax
select_fuel_indicator_pattern:
    ldy $6093
    cpy #$06
    bne load_fuel_indicator_pair
    jmp draw_wide_fuel_bar
load_fuel_indicator_pair:
    lda $bac9,y
    sta $609a
    lda $bace,y
    sta $609b
draw_next_fuel_indicator_pair:
    cpy #$01
    bne output_fuel_indicator_pair
    txa
    clc
    adc $60c1
    and #$03
    tay
    lda $bad4,y
    sta $609a
    lda $bad8,y
    sta $609b
    ldy #$01
    cpx #$14
    bcc output_fuel_indicator_pair
    ldx #$14
output_fuel_indicator_pair:
    lda $609a
    jsr output_display_byte_or_advance_column
    lda $609b
    jsr output_display_byte_or_advance_column
    dex
    bne draw_next_fuel_indicator_pair
    lda $60c1
    and #$03
    tax
    lda $bad4,x
    sta $baca
    lda $bad8,x
    sta $bacf
decrement_fuel_indicator_cadence:
    dec $6092
    bne fuel_indicator_done
reload_fuel_indicator_cadence:
    dec $6093
    lda $60b5
    sta $6092
fuel_indicator_done:
    rts

; The display output vector treats high-bit spaces as horizontal cursor moves;
; all other bytes are emitted normally.
output_display_byte_or_advance_column:
    cmp #$a0
    beq advance_display_column
    jmp $0080
advance_display_column:
    inc $01
    rts

; Render a capped-width bar using paired block glyphs and a one-to-three-column
; remainder, then share the normal cadence update.
draw_wide_fuel_bar:
    txa
    dec $02
    cmp #$30
    bcc fuel_bar_width_ready
    lda #$30
fuel_bar_width_ready:
    pha
    lsr a
    lsr a
    beq draw_fuel_bar_remainder
draw_next_full_fuel_block:
    pha
    lda #$ab
    jsr output_display_byte_or_advance_column
    lda #$ac
    jsr output_display_byte_or_advance_column
    inc $02
    dec $01
    dec $01
    lda #$ad
    jsr output_display_byte_or_advance_column
    lda #$ae
    jsr output_display_byte_or_advance_column
    inc $01
    dec $02
    pla
    sec
    sbc #$01
    bne draw_next_full_fuel_block
draw_fuel_bar_remainder:
    pla
    and #$03
    beq finish_wide_fuel_bar
    tay
    inc $02
    lda #$af
    jsr output_display_byte_or_advance_column
    dey
    beq finish_wide_fuel_bar
    jsr output_display_byte_or_advance_column
    dey
    beq finish_wide_fuel_bar
    dec $02
    dec $01
    dec $01
    jsr output_display_byte_or_advance_column
finish_wide_fuel_bar:
    jmp decrement_fuel_indicator_cadence

; Output A as two high-bit hexadecimal digits through the display vector.
output_display_hex_byte:
    pha
    lsr a
    lsr a
    lsr a
    lsr a
    jsr output_display_hex_nibble
    pla
output_display_hex_nibble:
    and #$0f
    ora #$b0
    cmp #$ba
    bcc output_display_hex_digit
    adc #$06
output_display_hex_digit:
    jmp $0080

display_indirect_jump:
    jmp ($60)

fuel_indicator_source_end:
.assert update_fuel_indicator - selector5_start = $4bf9, error, "fuel indicator origin drift"
.assert draw_wide_fuel_bar - selector5_start = $4cab, error, "wide fuel bar origin drift"
.assert output_display_hex_byte - selector5_start = $4d00, error, "display hex origin drift"
.assert display_indirect_jump - selector5_start = $4d16, error, "display indirect jump origin drift"
.assert fuel_indicator_source_end - update_fuel_indicator = $0120, error, "fuel indicator source size drift"

; Consume a zero-terminated inline record following the caller's JSR. Byte $01
; introduces new display column/row values; other bytes go to the output vector.
render_inline_display_record:
    pla
    sta $60
    pla
    sta $61
    ldy #$00
advance_inline_display_record:
    inc $60
    bne read_inline_display_byte
    inc $61
read_inline_display_byte:
    lda ($60),y
    beq return_after_inline_display_record
    cmp #$01
    beq load_inline_display_position
    jsr $0080
    jmp advance_inline_display_record
return_after_inline_display_record:
    lda $61
    pha
    lda $60
    pha
    rts
load_inline_display_position:
    inc $60
    bne load_inline_display_column
    inc $61
load_inline_display_column:
    lda ($60),y
    sta $01
    inc $60
    bne load_inline_display_row
    inc $61
load_inline_display_row:
    lda ($60),y
    sta $02
    jmp advance_inline_display_record

; Track either the player-associated object or the last saved view coordinate.
; Motion is capped by the tracked object's speed-derived step.
update_display_tracking:
    jsr select_display_tracking_object
    lda $6099
    beq evaluate_display_tracking_distance
    ldx #$00
    ldy $6098
    lda $64cc,y
    asl a
    sta $60
    asl a
    adc $60
    bpl add_tracking_object_position
    dex
add_tracking_object_position:
    clc
    adc $6394,y
    sta $60
    txa
    adc $632c,y
    sta $61
    lda $60
    sec
    sbc #$44
    sta $6097
    lda $61
    sbc #$00
    sta $6096
evaluate_display_tracking_distance:
    ldy $6098
    lda $6874,y
    beq snap_display_tracking_position
    lda $6097
    sec
    sbc $6095
    sta $60
    lda $6096
    sbc $6094
    bcs display_tracking_absolute_distance_ready
    lda $6095
    sec
    sbc $6097
    sta $60
    lda $6094
    sbc $6096
display_tracking_absolute_distance_ready:
    bne snap_display_tracking_position
    lda $60
    cmp #$a0
    bcc step_display_tracking_position
snap_display_tracking_position:
    lda $6096
    sta $6094
    lda $6097
    sta $6095
    rts

step_display_tracking_position:
    lda $6097
    sec
    sbc $6095
    sta $60
    lda $6096
    sbc $6094
    sta $61
    sta $63
    ldy $6098
    lda $64cc,y
    bpl display_tracking_step_magnitude
    eor #$ff
    clc
    adc #$01
display_tracking_step_magnitude:
    clc
    adc #$01
    sta $64
    lda $61
    bpl cap_display_tracking_step
    lda $60
    eor #$ff
    clc
    adc #$01
    sta $60
    lda $61
    eor #$ff
    adc #$00
    sta $61
cap_display_tracking_step:
    lda $61
    bne use_capped_display_tracking_step
    lda $60
    cmp $64
    bcc restore_display_tracking_step_sign
use_capped_display_tracking_step:
    lda $64
    sta $60
    lda #$00
    sta $61
restore_display_tracking_step_sign:
    lda $63
    bpl apply_display_tracking_step
    lda $60
    eor #$ff
    clc
    adc #$01
    sta $60
    lda $61
    eor #$ff
    adc #$00
    sta $61
apply_display_tracking_step:
    lda $6095
    clc
    adc $60
    sta $6095
    lda $6094
    adc $61
    sta $6094
    rts

; Prefer the player's linked object while grounded; otherwise retain the saved
; tracking-object index and mark its coordinate as externally supplied.
select_display_tracking_object:
    ldx $60b9
    ldy $6104,x
    beq use_player_tracking_object
    lda #$00
    sta $6099
    rts
use_player_tracking_object:
    lda $6112,x
    sta $6098
    lda #$01
    sta $6099
    rts

; Cull the current object against the horizontal view window and dispatch its
; ordinary, compound, or special sprite representation.
render_current_display_object:
    ldx current_object
    lda #$00
    sta $6874,x
    lda $6394,x
    sec
    sbc $6095
    sta $60
    lda $632c,x
    sbc $6094
    beq check_object_right_view_edge
    cmp #$ff
    beq check_object_left_view_edge
display_object_not_visible:
    rts
check_object_right_view_edge:
    lda $60
    cmp #$8c
    bcc display_object_visible
display_object_render_done:
    rts
check_object_left_view_edge:
    lda $60
    cmp #$e0
    bcc display_object_not_visible
display_object_visible:
    inc $6874,x
    clc
    adc #$3a
    sta $11
    lda $63fc,x
    sta $12
    lda $62c4,x
    cmp #$f0
    bcs render_special_display_object
    sta $10
    jmp $b86e
render_special_display_object:
    cmp #$ff
    beq display_object_render_done
    cmp #$f0
    bne render_compound_display_object
    lda $6464,x
    sta $14
    lda $6604,x
    ora #$02
    sta $0200
    jmp $020a
render_compound_display_object:
    lda $6464,x
    sta $0200
    jmp $0204

; Render the queued debug/status bytes as high-bit hexadecimal at row ten.
render_display_debug_row:
    ldy $60d3
    beq display_debug_row_done
    lda $60ba
    beq display_debug_row_done
    lda #$0a
    sta $02
    ldy #$00
    sty $01
render_next_display_debug_byte:
    lda $60d4,y
    jsr output_display_hex_byte
    inc $01
    iny
    cpy $60d3
    bne render_next_display_debug_byte
display_debug_row_done:
    rts

display_tracking_source_end:
.assert render_inline_display_record - selector5_start = $4d19, error, "inline display renderer origin drift"
.assert update_display_tracking - selector5_start = $4d53, error, "display tracking origin drift"
.assert select_display_tracking_object - selector5_start = $4e37, error, "tracking-object selector origin drift"
.assert render_current_display_object - selector5_start = $4e51, error, "display object renderer origin drift"
.assert render_display_debug_row - selector5_start = $4eb6, error, "display debug row origin drift"
.assert display_tracking_source_end - render_inline_display_record = $01be, error, "display tracking source size drift"

; Copy 32 pairs of 120-byte HGR blocks between the alternate and current page.
; The four high operand bytes are advanced once per block pair.
copy_alternate_display_page:
    lda $00
    sta copy_display_destination_top
    sta copy_display_destination_bottom
    eor #$60
    sta copy_display_source_top
    sta copy_display_source_bottom
    ldx #$20
copy_next_display_block_pair:
    ldy #$77
copy_next_display_block_byte:
    .byte $b9,$00
copy_display_source_top:
    .byte $20                    ; LDA $2000,Y, self-modified high operand
    .byte $99,$00
copy_display_destination_top:
    .byte $40                    ; STA $4000,Y, self-modified high operand
    .byte $b9,$80
copy_display_source_bottom:
    .byte $20                    ; LDA $2080,Y, self-modified high operand
    .byte $99,$80
copy_display_destination_bottom:
    .byte $40                    ; STA $4080,Y, self-modified high operand
    dey
    bpl copy_next_display_block_byte
    inc copy_display_destination_top
    inc copy_display_source_top
    inc copy_display_destination_bottom
    inc copy_display_source_bottom
    dex
    bne copy_next_display_block_pair
    rts

; Fill four corresponding HGR rows with a selected pair of pattern bytes.
fill_display_status_rows:
    ldy $0200
    lda $baba,y
    sta $60
    lda $bac2,y
    sta $61
    ldx #$26
    lda $00
    cmp #$20
    bne fill_page2_status_rows
fill_page1_status_rows:
    lda $60
    sta $2480,x
    sta $2c80,x
    sta $3480,x
    sta $3c80,x
    lda $61
    sta $2481,x
    sta $2c81,x
    sta $3481,x
    sta $3c81,x
    dex
    dex
    bpl fill_page1_status_rows
    rts
fill_page2_status_rows:
    lda $60
    sta $4480,x
    sta $4c80,x
    sta $5480,x
    sta $5c80,x
    lda $61
    sta $4481,x
    sta $4c81,x
    sta $5481,x
    sta $5c81,x
    dex
    dex
    bpl fill_page2_status_rows
    rts

; Copy and flip only when the current display base is not already page two.
synchronize_display_page:
    lda #$40
    cmp $00
    beq display_page_already_synchronized
    jsr copy_alternate_display_page
    jmp flip_display_page
display_page_already_synchronized:
    rts

; Map the compact display code in A (or $10) to the sprite address convention
; expected by the common renderer at $0201.
render_compact_display_sprite:
    lda $10
render_compact_display_sprite_a:
    ldx #$00
    ldy #$e0
    cmp #$49
    bcc store_compact_sprite_address
    sbc #$49
    cmp #$4e
    bcc use_compact_sprite_page19
    sbc #$4e
    ldx #$00
    ldy #$d0
    bne store_compact_sprite_address
use_compact_sprite_page19:
    ldx #$00
    ldy #$19
store_compact_sprite_address:
    stx $15
    sty $16
    sta $10
    jmp $0201

; Dispatch the current presentation phase through an overlapping low/high
; pointer table, then advance its 32-frame cadence and wrap phases 1..7.
update_presentation_phase:
    ldx $609e
    lda $bae7,x
    sta presentation_call_operand
    lda $baee,x
    sta presentation_call_operand+1
    .byte $20
presentation_call_operand:
    .word $1234                 ; self-modified JSR target
    dec $609f
    bne presentation_phase_done
    lda #$20
    sta $609f
    dec $609e
    bne presentation_phase_done
    lda #$07
    sta $609e
presentation_phase_done:
    rts

; Draw the five default high-score records loaded by selector 1 from track 0,
; sector 15. Names occupy five 16-byte slots at $0400; their corresponding
; two-byte packed-BCD values at $0450 are 8727, 8689, 7447, 1523, and 1245.
; Records are visited 4..0 but placed on rows 12..8, so the screen reads in
; descending score order from top to bottom.
display_high_scores:
    jsr render_inline_display_record
    ; (14,6) "HIGH SCORES"
    .byte $01,$0e,$06,$c8,$c9,$c7,$c8,$a0,$d3,$c3,$cf,$d2,$c5,$d3,$00
    lda #$04
display_next_high_score:
    pha
    clc
    adc #$08
    sta $02
    lda #$09
    sta $01
    pla
    pha
    asl a
    sta $60
    asl a
    asl a
    asl a
    tay
    ldx #$10
display_next_high_score_name_byte:
    lda default_high_score_names,y
    jsr output_display_byte_or_advance_column
    iny
    dex
    bne display_next_high_score_name_byte
    ldy $60
    lda default_high_score_values,y
    sta $61
    lda default_high_score_values+1,y
    sta $60
    inc $01
    ldx #$03
    stx $62
display_next_high_score_nibble:
    lda #$00
    asl $60
    rol $61
    rol a
    asl $60
    rol $61
    rol a
    asl $60
    rol $61
    rol a
    asl $60
    rol $61
    rol a
    bne output_high_score_nibble
    bit $62
    bmi output_high_score_nibble
    cpx #$00
    beq output_high_score_nibble
    inc $01
    bpl advance_high_score_nibble
output_high_score_nibble:
    ora #$b0
    sta $62
    jsr $0080
advance_high_score_nibble:
    dex
    bpl display_next_high_score_nibble
    pla
    sec
    sbc #$01
    bpl display_next_high_score
    rts

; Draw compact sprites $3F and $40 side by side. The emulator capture confirms
; that these are the left/right halves of the graphical RESCUE RAIDERS logo.
display_rescue_raiders_logo:
    lda #$64
    sta $11
    pha
    lda #$30
    sta $12
    pha
    lda #$3f
    jsr render_compact_display_sprite_a
    pla
    sta $12
    pla
    clc
    adc #$1b
    sta $11
    lda #$40
    jmp render_compact_display_sprite_a

display_hello_herrb:
    jsr render_inline_display_record
    ; (12,2) "  HELLO HERRB   " ($E0 is a visible blank in this renderer)
    .byte $01,$0c,$02,$e0,$e0,$c8,$c5,$cc,$cc,$cf,$e0,$c8,$c5,$d2,$d2,$c2
    .byte $e0,$e0,$e0,$00
    rts

display_presentation_message:
    jsr render_inline_display_record
    ; (3,2) " THIS MESSAGE BROUGHT TO YOU BY  "
    .byte $01,$03,$02,$e0,$d4,$c8,$c9,$d3,$e0,$cd,$c5,$d3,$d3,$c1,$c7,$c5
    .byte $e0,$c2,$d2,$cf,$d5,$c7,$c8,$d4,$e0,$d4,$cf,$a0,$d9,$cf,$d5,$a0
    .byte $c2,$d9,$e0,$e0,$00
    rts

display_creator_names:
    jsr render_inline_display_record
    ; (10,2) " DARRELL AND JON   "
    .byte $01,$0a,$02,$e0,$c4,$c1,$d2,$d2,$c5,$cc,$cc,$e0,$c1,$ce,$c4,$e0
    .byte $ca,$cf,$ce,$e0,$e0,$e0,$00
    rts

display_last_score:
    jsr render_inline_display_record
    ; (11,2) "LAST SCORE ", followed by last_score_digits (initially "   0")
    .byte $01,$0b,$02,$cc,$c1,$d3,$d4,$a0,$d3,$c3,$cf,$d2,$c5,$a0,$00
    ldy #$00
display_next_last_score_byte:
    lda last_score_digits,y
    jsr $0080
    iny
    cpy #$04
    bne display_next_last_score_byte
    rts

display_proudly_presents:
    ; Compact sprite $96 is the graphical SIR-TECH logo; the inline record
    ; places "PROUDLY PRESENTS" beneath it at column 16, row 3.
    lda #$61
    sta $11
    lda #$30
store_presentation_sprite_row:
    sta $12
    lda #$96
    jsr render_compact_display_sprite_a
    jsr render_inline_display_record
    .byte $01,$10,$03,$d0,$d2,$cf,$d5,$c4,$cc,$d9,$a0,$d0,$d2,$c5,$d3,$c5
    .byte $ce,$d4,$d3,$00
    rts

presentation_source_end:
.assert copy_alternate_display_page - selector5_start = $4ed7, error, "display page copy origin drift"
.assert fill_display_status_rows - selector5_start = $4f0a, error, "display row fill origin drift"
.assert synchronize_display_page - selector5_start = $4f61, error, "display page sync origin drift"
.assert render_compact_display_sprite - selector5_start = $4f6e, error, "compact sprite renderer origin drift"
.assert update_presentation_phase - selector5_start = $4f93, error, "presentation phase origin drift"
.assert display_high_scores - selector5_start = $4fba, error, "high-score display origin drift"
.assert display_rescue_raiders_logo - selector5_start = $5034, error, "RESCUE RAIDERS logo origin drift"
.assert display_hello_herrb - selector5_start = $5051, error, "HELLO HERRB record origin drift"
.assert display_presentation_message - selector5_start = $5069, error, "presentation message origin drift"
.assert display_creator_names - selector5_start = $5092, error, "creator names origin drift"
.assert display_last_score - selector5_start = $50ad, error, "last-score display origin drift"
.assert display_proudly_presents - selector5_start = $50cd, error, "PROUDLY PRESENTS origin drift"
.assert presentation_source_end - copy_alternate_display_page = $021b, error, "presentation source size drift"

; Paint a 32-byte vertical fuel gauge on three HGR bands. Filled rows use $7F;
; exhausted rows alternate $AA/$D5 through two self-modified immediate values.
draw_fuel_gauge_pattern:
    ldx $60b9
    lda $6108,x
    lsr a
    lsr a
    tax
    lda #$7f
    sta fuel_gauge_fill_operand
    lda fuel_gauge_band1_page_operand
    and #$1f
    ora $00
    sta fuel_gauge_band1_page_operand
    lda fuel_gauge_band2_page_operand
    and #$1f
    ora $00
    sta fuel_gauge_band2_page_operand
    lda fuel_gauge_band3_page_operand
    and #$1f
    ora $00
    sta fuel_gauge_band3_page_operand
    ldy #$00
    sty fuel_gauge_xor_operand
draw_next_fuel_gauge_row:
    dex
    bpl write_fuel_gauge_row
    .byte $a9
fuel_gauge_checker_operand:
    .byte $aa                    ; self-modified LDA immediate operand
    sta fuel_gauge_fill_operand
    lda #$7f
    sta fuel_gauge_xor_operand
    tax
write_fuel_gauge_row:
    .byte $a9
fuel_gauge_fill_operand:
    .byte $00                    ; self-modified LDA immediate operand
    .byte $99,$84
fuel_gauge_band1_page_operand:
    .byte $28                    ; STA $2884,Y high operand
    .byte $99,$84
fuel_gauge_band2_page_operand:
    .byte $30                    ; STA $3084,Y high operand
    .byte $99,$84
fuel_gauge_band3_page_operand:
    .byte $38                    ; STA $3884,Y high operand
    lda fuel_gauge_fill_operand
    .byte $49
fuel_gauge_xor_operand:
    .byte $00                    ; self-modified EOR immediate operand
    sta fuel_gauge_fill_operand
    lda fuel_gauge_checker_operand
    eor #$7f
    sta fuel_gauge_checker_operand
    iny
    cpy #$20
    bne draw_next_fuel_gauge_row
    rts

; Draw the battle/score presentation on the alternate page, including the
; campaign number, four-byte score, and decorative footer, then flip pages.
display_battle_score_prompt:
    jsr copy_alternate_display_page
    jsr render_inline_display_record
    .byte $01,$0c,$0a,$c0,$a1,$db,$a1,$db,$a1,$db,$a1,$db,$a1,$db,$a1,$db
    .byte $a3,$01,$0c,$0b,$a4,$a0,$a0,$c2,$c1,$d4,$d4,$cc,$c5,$a0,$00
    lda $05
    ora #$b0
    jsr $0080
    jsr render_inline_display_record
    .byte $a0,$a0,$a8,$01,$0c,$0c,$a4,$a0,$d3,$c3,$cf,$d2,$c5,$a0,$00
    jsr selector5_counter_format_jump
    ldy #$00
display_next_battle_score_byte:
    lda $60,y
    jsr $0080
    iny
    cpy #$04
    bne display_next_battle_score_byte
    jsr render_inline_display_record
    .byte $a0,$a8,$01,$0c,$0d,$bf,$be,$bc,$be,$bc,$be,$bc,$be,$bc,$be,$bc,$be
    .byte $bc,$bd,$00
    jmp flip_display_page

; Pair patterns for fill_display_status_rows. The second table's eighth byte
; overlaps the first byte of the following fuel-indicator glyph stream.
display_fill_pattern_low:
    .byte $00,$7f,$2a,$55,$80,$ff,$aa,$d5
display_fill_pattern_high:
    .byte $00,$7f,$55,$2a,$80,$ff,$d5

; Overlapping glyph tables used by update_fuel_indicator. Their consumers use
; fixed bases and indices, so labels intentionally begin inside prior spans.
fuel_indicator_left_glyphs:
    .byte $aa,$a5,$aa,$de,$a7
fuel_indicator_right_glyphs:
    .byte $ba,$a6,$a0,$a0,$a0,$a0
fuel_indicator_animation_left:
    .byte $dc,$a5,$a5,$dc
fuel_indicator_animation_right:
    .byte $df,$df,$a6
fuel_indicator_count_address_low:
    .byte $a6,$ab,$a0,$01,$03,$f5
fuel_indicator_count_address_high:
    .byte $17,$60,$60,$61,$61,$60

; Low/high presentation callback bases overlap by one byte. Index zero is
; unused. Indices 1..7 select Sir-Tech/presents, high scores, last score,
; creator names, message, greeting, and the two-part RESCUE RAIDERS logo.
; The phase counter runs downward and wraps, matching the captured display
; sequence when observed from phase 1: publisher, game logo, greeting, message,
; creators, last score, then high scores.
presentation_callback_low:
    .byte $61,$cd,$ba,$ad,$92,$69,$51
presentation_callback_high:
    .byte $34,$b9,$b8,$b9,$b9,$b9,$b9,$b9

display_trailing_workspace:
    .res 8,$00
display_trailing_constants:
    .byte $0f,$09

selector5_display_source_end:
.assert draw_fuel_gauge_pattern - selector5_start = $50f2, error, "fuel gauge pattern origin drift"
.assert display_battle_score_prompt - selector5_start = $5152, error, "battle score prompt origin drift"
.assert display_fill_pattern_low - selector5_start = $51ba, error, "display fill table origin drift"
.assert display_fill_pattern_high - selector5_start = $51c2, error, "display fill high table origin drift"
.assert fuel_indicator_left_glyphs - selector5_start = $51c9, error, "fuel indicator glyph origin drift"
.assert fuel_indicator_right_glyphs - selector5_start = $51ce, error, "fuel indicator right glyph origin drift"
.assert fuel_indicator_animation_left - selector5_start = $51d4, error, "fuel indicator animation origin drift"
.assert fuel_indicator_animation_right - selector5_start = $51d8, error, "fuel indicator animation right origin drift"
.assert fuel_indicator_count_address_low - selector5_start = $51db, error, "fuel indicator count-low origin drift"
.assert fuel_indicator_count_address_high - selector5_start = $51e1, error, "fuel indicator count-high origin drift"
.assert presentation_callback_low - selector5_start = $51e7, error, "presentation callback-low origin drift"
.assert presentation_callback_high - selector5_start = $51ee, error, "presentation callback-high origin drift"
.assert selector5_display_source_end - draw_fuel_gauge_pattern = $010e, error, "final display source size drift"

selector5_end:
.assert selector5_end - selector5_start = $5200, error, "selector-5 image must be $5200 bytes"
