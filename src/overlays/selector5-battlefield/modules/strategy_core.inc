; Strategy module entry points, coordinator, and first-phase handlers.

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
