; Object allocation, player/layout initialization, constructors, formations.

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
