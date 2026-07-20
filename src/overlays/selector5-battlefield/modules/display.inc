; Battlefield HUD, object rendering, presentation screens, and display tables.

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
