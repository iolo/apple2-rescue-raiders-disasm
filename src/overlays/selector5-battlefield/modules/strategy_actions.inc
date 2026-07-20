; Strategy decisions, actions, searches, and motion helpers.

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
