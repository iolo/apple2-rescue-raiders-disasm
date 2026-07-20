; Damage, collision traversal, destruction handlers, and aftermath tables.

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
