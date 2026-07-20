; Keyboard/paddle input, hidden commands, helicopter control, weapons, service.

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

; ZIPPY cheat command Return, followed by a digit. In enabled cheat mode,
; accept 1-9, store digit-1 as the current campaign index, and prime the same
; battle-transition counters used by ordinary flow. The subsequent transition
; advances to the requested battlefield; 9 advances through the final gate.
cheat_select_campaign:
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

; ZIPPY J/K/L teleport the human player's helicopter horizontally. These are
; the exact 12-bit battlefield coordinates: J=$0260, K=$07F7 (the midpoint),
; and L=$0DA0. Only the horizontal coordinate changes; repairing active-list
; order makes the moved object visible to the normal update/render paths.
cheat_teleport_player_left:
    lda #$60
    ldx #$02
    bne cheat_teleport_player
cheat_teleport_player_middle:
    lda #$f7
    ldx #$07
    bne cheat_teleport_player
cheat_teleport_player_right:
    lda #$a0
    ldx #$0d
cheat_teleport_player:
    bit $6046
    bpl cheat_teleport_player_done
    ldy $6113
    sty current_object
    sta $6394,y
    txa
    sta $632c,y
    jmp finish_position_update
cheat_teleport_player_done:
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
    cmp cheat_enable_sequence_reversed,y
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
.assert cheat_select_campaign - selector5_start = $26c5, error, "cheat campaign selector origin drift"
.assert cheat_teleport_player_left - selector5_start = $26ee, error, "cheat player-left entry drift"
.assert cheat_teleport_player_middle - selector5_start = $26f4, error, "cheat player-middle entry drift"
.assert cheat_teleport_player_right - selector5_start = $26fa, error, "cheat player-right entry drift"
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

; ZIPPY / adds one reserve helicopter. The original byte increment has no cap.
cheat_add_reserve_helicopter:
    bit $6046
    bpl cheat_add_reserve_helicopter_done
    inc $60ab
cheat_add_reserve_helicopter_done:
    rts

; ZIPPY - toggles human-player helicopter damage suppression. The damage
; dispatcher tests this byte only for a type-$02 object whose owner is nonzero.
cheat_toggle_player_invulnerability:
    bit $6046
    bpl cheat_toggle_player_invulnerability_done
    lda $60a6
    eor #$ff
    sta $60a6
cheat_toggle_player_invulnerability_done:
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

; ZIPPY Ctrl-A toggles the row-ten hexadecimal diagnostic display. It remains
; invisible when the diagnostic byte count at $60D3 is zero.
cheat_toggle_hex_status_row:
    bit $6046
    bpl input_transition_counter_done
    lda $60ba
    eor #$ff
    sta $60ba
    rts

player_input_command_keys:
    ; M T A D E H Space C Esc Ctrl-R J K L / Return - Ctrl-A
    .byte $cd,$d4,$c1,$c4,$c5,$c8,$a0,$c3,$9b,$92,$ca,$cb,$cc,$af,$8d,$ad,$81
player_input_command_handlers:
    .word store_input_state_6042,store_input_state_6042,store_input_state_6042
    .word store_input_state_6042,store_input_state_6042,store_input_state_6042
    .word store_input_state_6042,increment_input_exit_counter
    .word wait_for_selector_key,request_battlefield_exit,cheat_teleport_player_left
    .word cheat_teleport_player_middle,cheat_teleport_player_right,cheat_add_reserve_helicopter
    .word cheat_toggle_player_invulnerability,cheat_select_campaign,cheat_toggle_hex_status_row

player_input_helpers_source_end:
.assert increment_player_smoke_counter - selector5_start = $2fba, error, "player smoke counter origin drift"
.assert spawn_player_falling_infantry - selector5_start = $2fc1, error, "falling infantry spawn origin drift"
.assert cheat_add_reserve_helicopter - selector5_start = $2fe6, error, "cheat helicopter increment origin drift"
.assert cheat_toggle_player_invulnerability - selector5_start = $2fef, error, "cheat invulnerability toggle origin drift"
.assert fire_type1a_alternate - selector5_start = $2ffd, error, "alternate weapon origin drift"
.assert increment_input_transition_counter - selector5_start = $3027, error, "input transition counter origin drift"
.assert cheat_toggle_hex_status_row - selector5_start = $302b, error, "cheat diagnostic-row toggle origin drift"
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

; Compared from the last byte toward the first. Entering ZIPPY toggles $6046;
; the J/K/L, /, Return, -, and Ctrl-A handlers test its negative flag.
cheat_enable_sequence_reversed:
    .byte $d9,$d0,$d0,$c9,$da       ; high-bit "YPPIZ" => entered as "ZIPPY"

cheat_enable_sequence_reversed_end:
.assert cheat_enable_sequence_reversed - selector5_start = $30a8, error, "cheat enable sequence origin drift"
.assert cheat_enable_sequence_reversed_end - cheat_enable_sequence_reversed = $0005, error, "cheat enable sequence size drift"

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
