; Secondary targeting, effects, projectile behavior, and dispatch tables.

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
