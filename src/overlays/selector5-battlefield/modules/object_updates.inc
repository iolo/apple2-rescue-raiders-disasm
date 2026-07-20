; Active-list maintenance and primary per-type object update behavior.

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
