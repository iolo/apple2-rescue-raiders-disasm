; Rescue Raiders selector-0 opening/title execution and timed-event slices.
.setcpu "6502"
.segment "SELECTOR0_OPENING"

title_event_time_low  = $13e1
title_event_time_high = $13e2
title_exit_flag       = $14ae
title_delay_index     = $14b0
title_delay_value     = $14b1
title_frame_update    = $0be3

selector0_opening_start:
    jmp title_module_entry

; One delay value is selected after each matching timed-event record.
title_delay_table:
    .byte $f8,$36,$36,$01,$01,$01,$01,$c4,$c4,$c4,$f0,$01,$a5,$00

; With A carrying the active HGR page bits and $12A6 selecting a scanline,
; return its address in $64/$65.
compute_title_hgr_row_pointer:
    ldy $12a6
    ora hgr_scanline_high,y
    sta $65
    lda hgr_scanline_low,y
    sta $64
    rts

; Fill one HGR row with an alternating pair of mask bytes selected by $12A9.
; Rows outside the 192-line HGR domain are ignored.
fill_title_pattern_row:
    ldy $12a6
    cpy #$c0
    bcs title_pattern_row_done
    lda hgr_scanline_low,y
    sta $64
    lda hgr_scanline_high,y
    ora $00
    sta $65
    lda $12a9
    and #$07
    tax
    lda title_bit_masks,x
    ldy #$26
fill_title_even_columns:
    sta ($64),y
    dey
    dey
    bpl fill_title_even_columns
    lda title_bit_masks+8,x
    ldy #$27
fill_title_odd_columns:
    sta ($64),y
    dey
    dey
    bpl fill_title_odd_columns
title_pattern_row_done:
    rts

title_front_block_end:
.assert title_delay_table - selector0_opening_start = $0003, error, "title delay table origin drift"
.assert compute_title_hgr_row_pointer - selector0_opening_start = $0011, error, "title HGR pointer origin drift"
.assert fill_title_pattern_row - selector0_opening_start = $001f, error, "title pattern fill origin drift"
.assert title_front_block_end - selector0_opening_start = $004f, error, "title front block size drift"

; Selector-0's direct $0800 path enters here. It initializes both high-resolution
; pages, runs the timed title animation until ESC or the terminal event makes
; $14AE negative, selects scene mode 2, renders one final frame, and returns.
title_module_entry:
    jsr initialize_title_graphics
    jsr run_title_animation
    jsr title_final_update
    rts

initialize_title_graphics:
    lda #$40
    sta $00
    jsr title_graphics_clear
    bit $c050                   ; graphics on
    bit $c052                   ; full-screen graphics
    bit $c055                   ; page 2
    bit $c057                   ; high resolution
    jsr flip_title_page
    jsr title_graphics_clear
    lda #$c0
    sta $12ab
    rts

flip_title_page:
    lda $00
    eor #$60
    sta $00
    bit $c054
    cmp #$20
    bne title_page_ready
    bit $c055
title_page_ready:
    rts

run_title_animation:
    jsr initialize_title_animation
title_animation_loop:
    jsr title_frame_update
    jsr title_scene_update
    jsr title_sprite_update
    lda $c000
    cmp #$9b                    ; high-bit ESC
    bne title_delay
    dec title_exit_flag
    bit $c010
title_delay:
    ldy title_delay_value
    sec
title_delay_outer:
    lda #$0a
title_delay_inner:
    sbc #$01
    bne title_delay_inner
    dey
    bne title_delay_outer
    bit title_exit_flag
    bpl title_animation_loop
    lda #$02
    sta $1298
    jsr title_sprite_update
    rts

title_entry_source_end:
.assert title_module_entry - selector0_opening_start = $004f, error, "title entry origin drift"
.assert title_entry_source_end - title_module_entry = $006e, error, "title entry size drift"

; Indirect call target used by the timed-event scanner. The scanner reaches
; this JMP through JSR, so the selected event's RTS returns to the scanner.
title_event_trampoline:
    jmp ($0066)

; Clear both interleaved halves of the currently selected HGR page. The page
; byte in $00 is installed into the high byte of both self-modifying stores.
title_graphics_clear:
    lda $00
    sta title_clear_first_half+2
    sta title_clear_second_half+2
    ldx #$20
    lda #$00
title_clear_page_loop:
    ldy #$77
title_clear_row_loop:
title_clear_first_half:
    sta $4000,y
title_clear_second_half:
    sta $4080,y
    dey
    bpl title_clear_row_loop
    inc title_clear_first_half+2
    inc title_clear_second_half+2
    dex
    bne title_clear_page_loop
    jsr initialize_title_background
    rts

; Composite the selected bitmap into HGR memory. The descriptor indexed from
; $1700 supplies row width and height; the scanline tables at $0FB9/$1079
; select each HGR destination row. Three absolute indexed instructions are
; patched with the descriptor data pointer and destination address.
draw_title_bitmap:
    lda $12a5
    lsr
    lda $12aa
    rol
    asl
    tay
    lda $1700,y
    adc #$00
    sta $66
    lda $1701,y
    adc #$17
    sta $67
    ldy #$00
    lda ($66),y
    sta $68
    inc $66
    bne draw_bitmap_pointer_second_byte
    inc $67
draw_bitmap_pointer_second_byte:
    lda ($66),y
    sta $69
    inc $66
    bne draw_bitmap_pointer_ready
    inc $67
draw_bitmap_pointer_ready:
    lda $12a6
    pha
    lda $66
    sta draw_bitmap_source+1
    lda $67
    sta draw_bitmap_source+2
    lda $12a5
    clc
    adc $68
    sta $66
    dec $66
draw_bitmap_row:
    ldx $12a6
    cpx $12ab
    bcs draw_bitmap_done
    lda hgr_scanline_low,x
    sta draw_bitmap_destination+1
    sta draw_bitmap_merge+1
    lda hgr_scanline_high,x
    ora $00
    sta draw_bitmap_destination+2
    sta draw_bitmap_merge+2
    ldx $68
    dex
    ldy $66
draw_bitmap_column:
    cpy #$28
    bcs draw_bitmap_skip_column
draw_bitmap_source:
    lda $1234,x
draw_bitmap_merge:
    ora $1234,y
draw_bitmap_destination:
    sta $1234,y
draw_bitmap_skip_column:
    dey
    dex
    bpl draw_bitmap_column
    lda draw_bitmap_source+1
    clc
    adc $68
    sta draw_bitmap_source+1
    bcc draw_bitmap_source_advanced
    inc draw_bitmap_source+2
draw_bitmap_source_advanced:
    inc $12a6
    dec $69
    bne draw_bitmap_row
draw_bitmap_done:
    pla
    sta $12a6
    rts

; Erase the selected bitmap's rectangular HGR footprint. It uses the same
; descriptor and scanline tables as the compositor but writes zero bytes.
erase_title_bitmap:
    lda $12a5
    lsr
    lda $12aa
    rol
    asl
    tay
    lda $1700,y
    adc #$00
    sta $66
    lda $1701,y
    adc #$17
    sta $67
    ldy #$00
    lda ($66),y
    sta $68
    adc $12a5
    tax
    iny
    lda ($66),y
    sta $69
    dex
    stx $66
    lda $12a6
    pha
erase_bitmap_row:
    ldx $12a6
    cpx $12ab
    bcs erase_bitmap_done
    lda hgr_scanline_low,x
    sta erase_bitmap_destination+1
    lda hgr_scanline_high,x
    ora $00
    sta erase_bitmap_destination+2
    ldx $68
    ldy $66
    lda #$00
erase_bitmap_column:
    cpy #$28
    bcs erase_bitmap_skip_column
erase_bitmap_destination:
    sta $1234,y
erase_bitmap_skip_column:
    dey
    dex
    bne erase_bitmap_column
    inc $12a6
    dec $69
    bne erase_bitmap_row
erase_bitmap_done:
    pla
    sta $12a6
    rts

; Print A and then X as hexadecimal bytes through the monitor ROM routine at
; $FDDA. The first JSR returns at TXA; the shared tail prints the second byte.
print_accumulator_and_x_hex:
    jsr print_hex_byte
    txa
print_hex_byte:
    jmp $fdda

title_graphics_helpers_end:
.assert title_event_trampoline - selector0_opening_start = $00bd, error, "title event trampoline origin drift"
.assert title_graphics_clear - selector0_opening_start = $00c0, error, "title graphics clear origin drift"
.assert draw_title_bitmap - selector0_opening_start = $00e4, error, "title bitmap compositor origin drift"
.assert erase_title_bitmap - selector0_opening_start = $0176, error, "title bitmap eraser origin drift"
.assert print_accumulator_and_x_hex - selector0_opening_start = $01d7, error, "title hex helper origin drift"
.assert title_graphics_helpers_end - title_event_trampoline = $0121, error, "title graphics helper span size drift"

; Reset the title's clock, exit flag, delay-stream state, and sprite/scene
; subsystems before acknowledging any stale keyboard latch.
initialize_title_animation:
    lda #$00
    sta title_event_time_low
    sta title_event_time_high
    sta title_exit_flag
    sta title_delay_index
    sta title_delay_value
    sta $14b2
    inc title_delay_value
    jsr initialize_title_composite_state
    jsr initialize_title_sprite_state
    jsr initialize_title_particles
    jsr initialize_title_bitmap_objects
    jsr initialize_title_entropy_pointer
    jsr initialize_title_text_stream
    bit $c010
    rts

title_animation_init_end:
.assert initialize_title_animation - selector0_opening_start = $01de, error, "title initialization origin drift"
.assert title_animation_init_end - initialize_title_animation = $002d, error, "title initialization size drift"

initialize_title_entropy_pointer:
    lda #$b6
    sta $13e6
    lda #$00
    sta $13e5
    rts

; Reset the four-part composite sprite state and its initial screen position.
initialize_title_composite_state:
    lda #$00
    sta $12b2
    sta $12b3
    sta $12b4
    sta $12b7
    sta $12b1
    sta $12bd
    sta $13e4
    lda #$ec
    sta $12b5
    lda #$9d
    sta $12b6
    rts

; Reset the independently double-buffered title sprite state.
initialize_title_sprite_state:
    lda #$00
    sta $1299
    sta $129d
    sta $12a1
    lda #$9d
    sta $129b
    lda #$0c
    sta $129a
    rts

; Invoke the opaque $081F background primitive ten times on adjacent rows.
initialize_title_background:
    lda #$06
    sta $12a9
    lda #$bf
    sta $12a6
    lda #$0a
title_background_pass:
    pha
    jsr fill_title_pattern_row
    dec $12a6
    pla
    sec
    sbc #$01
    bne title_background_pass
    rts

; Erase the previous four-piece composite, advance the current/previous state
; buffers, and draw the requested composite with per-piece frame offsets.
update_title_composite:
    lda #$b6
    sta $12ab
    lda $12bd
    beq composite_previous_erased
    lda $12bb
    sta $12a5
    lda $12bc
    sta $12a6
    cmp $12b6
    bne erase_previous_composite
    lda $12b5
    cmp $12a5
    beq erase_previous_composite_tail
erase_previous_composite:
    lda #$04
    sta $12aa
    jsr erase_title_bitmap
erase_previous_composite_tail:
    lda $12a6
    clc
    adc #$12
    sta $12a6
    lda #$05
    sta $12aa
    jsr erase_title_bitmap
    lda $12a5
    clc
    adc #$0e
    sta $12a5
    lda #$08
    sta $12aa
    jsr erase_title_bitmap
    lda $12a5
    clc
    adc #$04
    sta $12a5
    lda #$0b
    sta $12aa
    jsr erase_title_bitmap
composite_previous_erased:
    lda $12b1
    sta $12bd
    lda $12af
    sta $12bb
    lda $12b0
    sta $12bc
    lda $12b7
    sta $12b1
    beq title_composite_done
    lda $12b5
    sta $12a5
    sta $12af
    lda $12b6
    sta $12a6
    sta $12b0
    lda #$04
    sta $12aa
    jsr draw_title_bitmap
    lda #$05
    clc
    adc $12b2
    sta $12aa
    lda $12a6
    clc
    adc #$12
    sta $12a6
    jsr draw_title_bitmap
    lda $12a5
    clc
    adc #$0e
    sta $12a5
    lda #$08
    clc
    adc $12b3
    sta $12aa
    jsr draw_title_bitmap
    lda $12a5
    clc
    adc #$04
    sta $12a5
    lda #$0b
    clc
    adc $12b4
    sta $12aa
    jsr draw_title_bitmap
title_composite_done:
    rts

; Erase the previously displayed single sprite, rotate its double-buffered
; state, and draw the new sprite plus its adjacent shadow/detail bitmap.
update_title_sprite_buffers:
    lda #$9d
    sta $12ab
    lda $12a1
    beq previous_title_sprite_erased
    lda $12a2
    sta $12a5
    lda $12a3
    sta $12a6
    lda $12a0
    sta $12aa
    jsr erase_title_bitmap
    lda $12a5
    cmp $129a
    bne erase_title_sprite_detail
    lda $12a6
    cmp $129b
    beq previous_title_sprite_erased
erase_title_sprite_detail:
    inc $12a6
    lda #$03
    sta $12aa
    jsr erase_title_bitmap
previous_title_sprite_erased:
    lda $129d
    sta $12a1
    beq title_sprite_history_rotated
    lda $129e
    sta $12a2
    lda $129f
    sta $12a3
    lda $129c
    sta $12a0
title_sprite_history_rotated:
    lda $1299
    sta $129d
    beq title_sprite_buffers_done
    lda $129a
    sta $12a5
    sta $129e
    lda $129b
    sta $12a6
    sta $129f
    ldx $1298
    lda title_sprite_frames,x
    sta $12aa
    sta $129c
    jsr draw_title_bitmap
    inc $12a6
    lda #$03
    sta $12aa
    jsr draw_title_bitmap
title_sprite_buffers_done:
    rts

; Mix keyboard, pointer, banked-memory, scene-state, X, and Y values into the
; two-byte entropy state. Callers deliberately supply A and carry as inputs.
stir_title_entropy:
    adc $c000
    adc $66
    adc $67
    adc $d000,x
    adc $e000,y
    adc $12a5
    adc $12a6
    adc $12bf
    adc $12c0
    sta $12bf
    inc $12c0
    rts

title_support_block_end:
.assert initialize_title_entropy_pointer - selector0_opening_start = $020b, error, "title entropy initializer origin drift"
.assert initialize_title_composite_state - selector0_opening_start = $0216, error, "title composite initializer origin drift"
.assert initialize_title_sprite_state - selector0_opening_start = $0238, error, "title sprite initializer origin drift"
.assert initialize_title_background - selector0_opening_start = $024e, error, "title background initializer origin drift"
.assert update_title_composite - selector0_opening_start = $0268, error, "title composite update origin drift"
.assert update_title_sprite_buffers - selector0_opening_start = $033a, error, "title sprite buffer update origin drift"
.assert stir_title_entropy - selector0_opening_start = $03c3, error, "title entropy mixer origin drift"
.assert title_support_block_end - initialize_title_entropy_pointer = $01d8, error, "title support block size drift"

; Advance the 16-bit animation clock and scan four-byte records consisting of
; little-endian trigger time followed by a routine pointer. Matching records
; are called through the $08BD JMP ($66) trampoline. A zero timestamp ends the
; table; any match also advances the frame-delay stream at $0803.
; The event scanner is also the first per-frame update called by the title loop.
scan_title_events:
    lda #$00
    sta $14af
    inc title_event_time_low
    bne title_event_clock_ready
    inc title_event_time_high
title_event_clock_ready:
    lda #<title_event_table
    sta $62
    lda #>title_event_table
    sta $63
title_event_next:
    ldy #$00
    lda ($62),y
    cmp title_event_time_low
    bne title_event_advance
    iny
    lda ($62),y
    cmp title_event_time_high
    bne title_event_advance
    inc $14af
    jsr load_and_call_title_event
title_event_advance:
    ldy #$00
    lda ($62),y
    iny
    ora ($62),y
    beq title_event_scan_done
    lda $62
    clc
    adc #$04
    sta $62
    bne title_event_next
    inc $63
    bne title_event_next
title_event_scan_done:
    lda $14af
    beq title_event_return
    ldy title_delay_index
    lda title_delay_table,y
    sta title_delay_value
    inc title_delay_index
title_event_return:
    rts

load_and_call_title_event:
    iny
    lda ($62),y
    sta $66
    iny
    lda ($62),y
    sta $67
    jsr title_event_trampoline
    rts

title_event_scanner_end:
.assert scan_title_events - selector0_opening_start = $03e3, error, "title event scanner origin drift"
.assert title_event_scanner_end - scan_title_events = $0062, error, "title event scanner size drift"

; The entry at $0C45 performs the final page-gated composition pass. Normal
; animation frames enter at $0C4B and update particles, buffered bitmap
; objects, the single sprite, and the four-part composite before page flip.
title_final_update:
    lda $00
    cmp #$40
    beq title_compositor_done
title_sprite_update:
    jsr update_title_particles
    jsr update_title_bitmap_objects
    jsr update_title_sprite_buffers
    jsr update_title_composite
    jsr flip_title_page
title_compositor_done:
    rts

; Rotate and redraw 32 one-byte particle slots. Previous particles are erased
; through a self-modifying HGR store; new particles OR one of eight masks into
; their scanline address and become the next previous-state buffer.
update_title_particles:
    ldx #$1f
title_particle_slot:
    lda $1381,x
    beq previous_particle_erased
    ldy $13c1,x
    lda hgr_scanline_low,y
    sta title_particle_erase_store+1
    lda hgr_scanline_high,y
    ora $00
    sta title_particle_erase_store+2
    lda #$00
    ldy $13a1,x
title_particle_erase_store:
    sta $1234,y
previous_particle_erased:
    lda $1321,x
    sta $1381,x
    beq particle_history_rotated
    lda $1341,x
    sta $13a1,x
    lda $1361,x
    sta $13c1,x
particle_history_rotated:
    lda $12c1,x
    sta $1321,x
    beq title_particle_next
    ldy $1301,x
    tya
    sta $1361,x
    lda hgr_scanline_low,y
    sta $64
    lda hgr_scanline_high,y
    ora $00
    sta $65
    sty $12a6
    jsr stir_title_entropy
    and #$07
    tay
    lda title_particle_masks,y
    ldy $12e1,x
    ora ($64),y
    sta ($64),y
    tya
    sta $1341,x
title_particle_next:
    dex
    bpl title_particle_slot
    rts

; Erase, rotate, and draw 16 buffered bitmap objects using the common title
; bitmap helpers. Object frame numbers are offset by $0D in descriptor space.
update_title_bitmap_objects:
    lda #$b6
    sta $12ab
    lda #$0f
    sta $14a7
title_bitmap_object_slot:
    ldx $14a7
    lda $1467,x
    beq previous_bitmap_object_erased
    lda $1477,x
    sta $12a5
    lda $1487,x
    sta $12a6
    lda $1497,x
    sta $12aa
    jsr erase_title_bitmap
    ldx $14a7
previous_bitmap_object_erased:
    lda $1427,x
    sta $1467,x
    beq bitmap_object_history_rotated
    lda $1437,x
    sta $1477,x
    lda $1447,x
    sta $1487,x
    lda $1457,x
    sta $1497,x
bitmap_object_history_rotated:
    lda $13e7,x
    sta $1427,x
    beq title_bitmap_object_next
    lda $13f7,x
    sta $12a5
    sta $1437,x
    lda $1407,x
    sta $12a6
    sta $1447,x
    lda $1417,x
    clc
    adc #$0d
    sta $12aa
    sta $1457,x
    jsr draw_title_bitmap
title_bitmap_object_next:
    dec $14a7
    bpl title_bitmap_object_slot
    rts

title_compositor_block_end:
.assert title_final_update - selector0_opening_start = $0445, error, "title final compositor origin drift"
.assert title_sprite_update - selector0_opening_start = $044b, error, "title frame compositor origin drift"
.assert update_title_particles - selector0_opening_start = $045b, error, "title particle updater origin drift"
.assert update_title_bitmap_objects - selector0_opening_start = $04c5, error, "title bitmap object updater origin drift"
.assert title_compositor_block_end - title_final_update = $00f3, error, "title compositor block size drift"

; Reset the current and two historical generations of all 32 particle slots.
initialize_title_particles:
    lda #$00
    sta $13e3
    ldy #$1f
clear_title_particle_slot:
    sta $12c1,y
    sta $1321,y
    sta $1381,y
    dey
    bpl clear_title_particle_slot
    rts

; Reset the current and two historical generations of 16 bitmap-object slots.
initialize_title_bitmap_objects:
    ldx #$0f
    lda #$00
clear_title_bitmap_object_slot:
    sta $13e7,x
    sta $1427,x
    sta $1467,x
    dex
    bpl clear_title_bitmap_object_slot
    rts

enable_title_particles:
    lda #$ff
    sta $13e3
    rts

disable_title_particles:
    lda #$00
    sta $13e3
    rts

; Advance every scene producer. Rendering happens later through the page's
; particle, bitmap-object, sprite, and composite buffer consumers.
title_scene_update:
    jsr update_title_particle_lifetimes
    jsr update_title_sprite_motion
    jsr update_title_composite_motion
    jsr update_title_trailing_objects
    jsr update_title_background_reveal
    jsr update_title_text_stream
    rts

; Once enabled by a timed event, reveal two adjacent background rows per frame
; until the row cursor reaches $C2.
update_title_background_reveal:
    bit $13e5
    bpl title_background_reveal_done
    lda $13e6
    cmp #$c2
    beq title_background_reveal_done
    sta $12a6
    lda #$00
    sta $12a9
    jsr fill_title_pattern_row
    dec $12a6
    jsr fill_title_pattern_row
    inc $13e6
title_background_reveal_done:
    rts

; Move the active four-part composite horizontally and select its three
; animated component frames from a packed two-bit table entry.
update_title_composite_motion:
    lda $12b7
    bne title_composite_is_active
    rts
title_composite_is_active:
    lda $12b5
    clc
    adc $12be
    sta $12b5
    lda $12be
    beq title_composite_frame_tick
    dec $13e4
title_composite_frame_tick:
    dec $13e4
    bpl title_composite_frame_ready
    jsr stir_title_entropy
    and #$0f
    clc
    adc #$10
    sta $13e4
title_composite_frame_ready:
    ldx $13e4
    lda title_composite_animation,x
    pha
    and #$03
    sta $12b2
    pla
    lsr
    lsr
    pha
    and #$03
    sta $12b3
    pla
    lsr
    lsr
    sta $12b4
    rts

title_scene_noop:
    rts

; Move the single title sprite vertically and cycle its five animation frames.
update_title_sprite_motion:
    lda $129b
    clc
    adc $12a4
    sta $129b
    dec $1298
    bpl title_sprite_motion_done
    lda #$04
    sta $1298
title_sprite_motion_done:
    rts

; Periodically create a trailing bitmap object behind the active composite,
; then count each active object's frame down until its slot is released.
update_title_trailing_objects:
    lda $12b7
    beq update_trailing_object_slots
    lda title_event_time_low
    and #$07
    bne update_trailing_object_slots
    jsr stir_title_entropy
    and #$03
    beq update_trailing_object_slots
    ldx #$0f
find_free_trailing_object:
    lda $13e7,x
    beq initialize_trailing_object
    dex
    bpl find_free_trailing_object
    bmi update_trailing_object_slots
initialize_trailing_object:
    dec $13e7,x
    lda $12b5
    clc
    adc #$0e
    sta $13f7,x
    lda #$93
    sta $1407,x
    lda #$06
    sta $1417,x
update_trailing_object_slots:
    ldx #$0f
update_trailing_object_slot:
    lda $13e7,x
    beq trailing_object_next
    dec $1417,x
    bmi release_trailing_object
    ldy $1417,x
    jmp trailing_object_next
release_trailing_object:
    inc $13e7,x
trailing_object_next:
    dex
    bpl update_trailing_object_slot
    rts

; Age active particles, then optionally seed a free slot at a random column.
update_title_particle_lifetimes:
    ldx #$1f
update_title_particle_slot:
    lda $12c1,x
    beq title_particle_lifetime_next
    txa
    lsr
    bcc age_title_particle
    eor title_event_time_low
    lsr
    bcc title_particle_lifetime_next
age_title_particle:
    dec $12e1,x
    bpl title_particle_lifetime_next
    inc $12c1,x
title_particle_lifetime_next:
    dex
    bpl update_title_particle_slot
    bit $13e3
    bpl update_title_particle_lifetimes_done
    jsr stir_title_entropy
    and #$1f
    tax
    lda $12c1,x
    bne update_title_particle_lifetimes_done
    jsr stir_title_entropy
    cmp #$b6
    bcs update_title_particle_lifetimes_done
    sta $1301,x
    lda #$27
    sta $12e1,x
    dec $12c1,x
update_title_particle_lifetimes_done:
    rts

; Timed-event handlers referenced by the table at $1149.
start_title_composite_motion:
    lda #$ff
    sta $12b7
    lda #$01
    sta $12be
    rts

stop_title_composite_motion:
    lda #$00
    sta $12be
    rts

hide_title_composite:
    lda #$00
    sta $12b7
    rts

start_title_sprite_motion:
    lda #$ff
    sta $1299
    lda #$ff
    sta $12a4
    rts

stop_title_sprite_motion:
    lda #$00
    sta $12a4
    rts

start_title_background_reveal:
    lda #$ff
    sta $13e5
    rts

prepare_title_copyright_text:
    lda #$ff
    sta $14a8
    lda #$02
    sta $14ab
    lda #$00
    sta $14a9
    lda #$0e
    sta $14aa
    lda #<title_copyright_text
    sta $60
    lda #>title_copyright_text
    sta $61
    rts

title_scene_block_end:
.assert initialize_title_particles - selector0_opening_start = $0538, error, "title particle initializer origin drift"
.assert initialize_title_bitmap_objects - selector0_opening_start = $054c, error, "title bitmap object initializer origin drift"
.assert title_scene_update - selector0_opening_start = $0569, error, "title scene update origin drift"
.assert update_title_composite_motion - selector0_opening_start = $059d, error, "title composite motion origin drift"
.assert update_title_trailing_objects - selector0_opening_start = $05f7, error, "title trailing object update origin drift"
.assert update_title_particle_lifetimes - selector0_opening_start = $0645, error, "title particle lifetime update origin drift"
.assert start_title_composite_motion - selector0_opening_start = $0684, error, "title composite event origin drift"
.assert prepare_title_copyright_text - selector0_opening_start = $06b2, error, "title copyright event origin drift"
.assert title_scene_block_end - initialize_title_particles = $0197, error, "title scene block size drift"

initialize_title_text_stream:
    lda #$00
    sta $14a8
    rts

; Reveal the zero-terminated string at ($60) one byte every two frames. The
; source pointer and 40-column destination advance together, wrapping onto the
; next HGR text row. A nonzero following byte selects the $AA spacer glyph.
update_title_text_stream:
    lda $14a8
    bne title_text_stream_active
    rts
title_text_stream_active:
    lda $14a9
    sta $14ac
    lda $14aa
    sta $14ad
    ldy #$00
    lda ($60),y
    jsr draw_title_glyph
    iny
    lda ($60),y
    beq title_text_frame_done
    lda #$aa
    jsr draw_title_glyph
title_text_frame_done:
    dec $14ab
    bne title_text_stream_done
    lda #$02
    sta $14ab
    inc $14a9
    lda $14a9
    cmp #$28
    bne title_text_advance_source
    lda #$00
    sta $14a9
    inc $14aa
title_text_advance_source:
    inc $60
    bne title_text_test_terminator
    inc $61
title_text_test_terminator:
    ldy #$00
    lda ($60),y
    bne title_text_stream_done
    sta $14a8
title_text_stream_done:
    rts

; Render one eight-byte glyph column into HGR memory. A is a high-bit text
; byte; shifting it left three forms an offset into the font at $1500. The
; destination advances four pages per glyph row using patched absolute stores.
draw_title_glyph:
    pha
    asl
    asl
    asl
    sta title_glyph_source+1
    lda #>title_font_64x8
    adc #$00
    sta title_glyph_source+2
    tya
    pha
    txa
    pha
    ldy $14ad
    lda title_text_scanline_low,y
    sta title_glyph_destination+1
    lda title_text_scanline_high,y
    ora $00
    sta title_glyph_destination+2
    ldy $14ac
    ldx #$07
draw_title_glyph_row:
title_glyph_source:
    lda $1234,x
title_glyph_destination:
    sta $1234,y
    lda title_glyph_destination+2
    clc
    adc #$04
    sta title_glyph_destination+2
    dex
    bpl draw_title_glyph_row
    inc $14ac
    lda $14ac
    cmp #$28
    bne title_glyph_position_ready
    lda #$00
    sta $14ac
    inc $14ad
    lda $14ad
    cmp #$18
    bne title_glyph_position_ready
    dec $14ad
title_glyph_position_ready:
    pla
    tax
    pla
    tay
    pla
    rts

finish_title_animation:
    dec title_exit_flag
    rts

; HGR destination tables for the 24 rows accepted by the glyph renderer.
title_text_scanline_low:
    .byte $00,$80,$00,$80,$00,$80,$00,$80
    .byte $28,$a8,$28,$a8,$28,$a8,$28,$a8
    .byte $50,$d0,$50,$d0,$50,$d0,$50,$d0
title_text_scanline_high:
    .byte $00,$00,$01,$01,$02,$02,$03,$03
    .byte $00,$00,$01,$01,$02,$02,$03,$03
    .byte $00,$00,$01,$01,$02,$02,$03,$03

title_sprite_frames:
    .byte $02,$01,$00,$01,$02

; Low and relative-high HGR scanline bytes for all 192 graphics rows. The
; active page high byte in $00 is ORed into the relative-high entry.
hgr_scanline_low:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80
    .byte $28,$28,$28,$28,$28,$28,$28,$28,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$a8
    .byte $28,$28,$28,$28,$28,$28,$28,$28,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$a8
    .byte $28,$28,$28,$28,$28,$28,$28,$28,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$a8
    .byte $28,$28,$28,$28,$28,$28,$28,$28,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$a8
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0
    .byte $50,$50,$50,$50,$50,$50,$50,$50,$d0,$d0,$d0,$d0,$d0,$d0,$d0,$d0
hgr_scanline_high:
    .byte $00,$04,$08,$0c,$10,$14,$18,$1c,$00,$04,$08,$0c,$10,$14,$18,$1c
    .byte $01,$05,$09,$0d,$11,$15,$19,$1d,$01,$05,$09,$0d,$11,$15,$19,$1d
    .byte $02,$06,$0a,$0e,$12,$16,$1a,$1e,$02,$06,$0a,$0e,$12,$16,$1a,$1e
    .byte $03,$07,$0b,$0f,$13,$17,$1b,$1f,$03,$07,$0b,$0f,$13,$17,$1b,$1f
    .byte $00,$04,$08,$0c,$10,$14,$18,$1c,$00,$04,$08,$0c,$10,$14,$18,$1c
    .byte $01,$05,$09,$0d,$11,$15,$19,$1d,$01,$05,$09,$0d,$11,$15,$19,$1d
    .byte $02,$06,$0a,$0e,$12,$16,$1a,$1e,$02,$06,$0a,$0e,$12,$16,$1a,$1e
    .byte $03,$07,$0b,$0f,$13,$17,$1b,$1f,$03,$07,$0b,$0f,$13,$17,$1b,$1f
    .byte $00,$04,$08,$0c,$10,$14,$18,$1c,$00,$04,$08,$0c,$10,$14,$18,$1c
    .byte $01,$05,$09,$0d,$11,$15,$19,$1d,$01,$05,$09,$0d,$11,$15,$19,$1d
    .byte $02,$06,$0a,$0e,$12,$16,$1a,$1e,$02,$06,$0a,$0e,$12,$16,$1a,$1e
    .byte $03,$07,$0b,$0f,$13,$17,$1b,$1f,$03,$07,$0b,$0f,$13,$17,$1b,$1f

title_bit_masks:
    .byte $00,$7f,$2a,$55,$80,$ff,$aa,$d5
    .byte $00,$7f,$55,$2a,$80,$ff,$d5,$aa

title_text_and_tables_end:
.assert initialize_title_text_stream - selector0_opening_start = $06cf, error, "title text initializer origin drift"
.assert update_title_text_stream - selector0_opening_start = $06d5, error, "title text streamer origin drift"
.assert draw_title_glyph - selector0_opening_start = $0724, error, "title glyph renderer origin drift"
.assert finish_title_animation - selector0_opening_start = $0780, error, "title finish event origin drift"
.assert title_text_scanline_low - selector0_opening_start = $0784, error, "title text scanline table origin drift"
.assert title_sprite_frames - selector0_opening_start = $07b4, error, "title sprite frame table origin drift"
.assert hgr_scanline_low - selector0_opening_start = $07b9, error, "HGR scanline-low table origin drift"
.assert hgr_scanline_high - selector0_opening_start = $0879, error, "HGR scanline-high table origin drift"
.assert title_bit_masks - selector0_opening_start = $0939, error, "title bit-mask table origin drift"
.assert title_text_and_tables_end - initialize_title_text_stream = $027a, error, "title text/table span size drift"

; Timed title-animation calls. The final $0618 record invokes $0F80, which
; decrements $14AE and releases the loop at $088C.
title_event_table:
    .word $00c8,$0d5d
    .word $01f4,$0e84
    .word $0214,$0e8f
    .word $021c,$0e9b
    .word $023a,$0ea6
    .word $0258,$0e84
    .word $0276,$0e95
    .word $0280,$0e9b
    .word $02bc,$0ea6
    .word $02bc,$0eac
    .word $0384,$0d63
    .word $03e8,$0eb2
    .word $0618,finish_title_animation
    .word $0000

title_event_table_end:
.assert title_event_table - selector0_opening_start = $0949, error, "title event table origin drift"
.assert title_event_table_end - title_event_table = $0036, error, "title event table size drift"

; Particle pixels and packed two-bit frame selections consumed by the scene
; producers. Each composite-animation byte selects three component frames.
title_particle_masks:
    .byte $01,$02,$81,$82,$01,$02,$00,$00
title_composite_animation:
    .byte $02,$02,$01,$01,$00,$00,$00,$00
    .byte $08,$08,$04,$04,$00,$00,$10,$10
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00

; High-bit zero-terminated record streamed by the $03E8 timed event. Decoded:
; COPYRIGHT (C) 1984 ALL RIGHTS RESERVED  BY ARTHUR BRITTO II AND GREG HALE.
; THIS PROGRAM IS PROTECTED UNDER THE LAWS OF  THE UNITED STATES AND OTHER
; COUNTRIES   AND ILLEGAL DISTRIBUTION MAY RESULT IN  CIVIL LIABLITY AND
; CRIMINAL PROSECUTION.
title_copyright_text:
    .byte $c3,$cf,$d0,$d9,$d2,$c9,$c7,$c8,$d4,$a0,$a8,$c3,$a9,$a0,$b1,$b9
    .byte $b8,$b4,$a0,$c1,$cc,$cc,$a0,$d2,$c9,$c7,$c8,$d4,$d3,$a0,$d2,$c5
    .byte $d3,$c5,$d2,$d6,$c5,$c4,$a0,$a0,$c2,$d9,$a0,$c1,$d2,$d4,$c8,$d5
    .byte $d2,$a0,$c2,$d2,$c9,$d4,$d4,$cf,$a0,$c9,$c9,$a0,$c1,$ce,$c4,$a0
    .byte $c7,$d2,$c5,$c7,$a0,$c8,$c1,$cc,$c5,$ae,$a0,$d4,$c8,$c9,$d3,$a0
    .byte $d0,$d2,$cf,$c7,$d2,$c1,$cd,$a0,$c9,$d3,$a0,$d0,$d2,$cf,$d4,$c5
    .byte $c3,$d4,$c5,$c4,$a0,$d5,$ce,$c4,$c5,$d2,$a0,$d4,$c8,$c5,$a0,$cc
    .byte $c1,$d7,$d3,$a0,$cf,$c6,$a0,$a0,$d4,$c8,$c5,$a0,$d5,$ce,$c9,$d4
    .byte $c5,$c4,$a0,$d3,$d4,$c1,$d4,$c5,$d3,$a0,$c1,$ce,$c4,$a0,$cf,$d4
    .byte $c8,$c5,$d2,$a0,$c3,$cf,$d5,$ce,$d4,$d2,$c9,$c5,$d3,$a0,$a0,$a0
    .byte $c1,$ce,$c4,$a0,$c9,$cc,$cc,$c5,$c7,$c1,$cc,$a0,$c4,$c9,$d3,$d4
    .byte $d2,$c9,$c2,$d5,$d4,$c9,$cf,$ce,$a0,$cd,$c1,$d9,$a0,$d2,$c5,$d3
    .byte $d5,$cc,$d4,$a0,$c9,$ce,$a0,$a0,$c3,$c9,$d6,$c9,$cc,$a0,$cc,$c9
    .byte $c1,$c2,$cc,$c9,$d4,$d9,$a0,$c1,$ce,$c4,$a0,$c3,$d2,$c9,$cd,$c9
    .byte $ce,$c1,$cc,$a0,$d0,$d2,$cf,$d3,$c5,$c3,$d5,$d4,$c9,$cf,$ce,$ae
    .byte $00

title_opening_data_end:
.assert title_particle_masks - selector0_opening_start = $097f, error, "title particle mask origin drift"
.assert title_composite_animation - selector0_opening_start = $0987, error, "title composite animation origin drift"
.assert title_copyright_text - selector0_opening_start = $09a7, error, "title copyright record origin drift"
.assert title_opening_data_end - title_particle_masks = $0119, error, "title opening data span size drift"

; Initialized animation workspace. Active flags are cleared by the title's
; startup routines before their associated slots are consumed; the nonzero
; bytes in inactive coordinate/frame slots are retained exactly as loaded.
title_scalar_state:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00

particle_current_active:
    .byte $00,$00,$00,$00,$00,$2a,$9d,$00,$4f,$00,$00,$2a,$9d,$00,$01,$6a
    .byte $c2,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
particle_current_lifetime:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
particle_current_row:
    .byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
    .byte $ff,$ac,$96,$62,$25,$3c,$8c,$27,$9e,$8a,$85,$aa,$82,$54,$8c,$0e

particle_previous_active:
    .byte $36,$5f,$68,$18,$5e,$60,$95,$19,$b0,$02,$10,$5e,$2e,$9c,$08,$0b
    .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
particle_previous_column:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
particle_previous_row:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$ac,$96,$62,$25,$3c,$8c,$27,$9e,$8a,$85,$aa,$82,$54,$8c,$0e

particle_older_active:
    .byte $36,$5f,$68,$18,$5e,$60,$95,$19,$b0,$02,$10,$5e,$2e,$9c,$08,$0b
    .byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
particle_older_column:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
particle_older_row:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$ac,$96,$62,$25,$3c,$8c,$00,$00,$00,$00,$00,$00,$54,$8c,$0e

title_event_state:
    .byte $00,$00,$00,$00,$00,$00

bitmap_current_active:
    .byte $00,$00,$00,$00,$00,$5e,$2e,$9c,$08,$0b,$01,$92,$09,$00,$11,$ff
bitmap_current_x:
    .byte $c2,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
bitmap_current_y:
    .byte $00,$51,$2c,$20,$2e,$ab,$6d,$38,$2f,$08,$00,$14,$ff,$c2,$00,$00
bitmap_current_frame:
    .byte $37,$00,$00,$00,$00,$00,$00,$00,$93,$00,$00,$00,$00,$00,$15,$2c

bitmap_previous_active:
    .byte $93,$c0,$37,$03,$f0,$03,$20,$7b,$ff,$00,$00,$00,$00,$00,$00,$00
bitmap_previous_x:
    .byte $ff,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
bitmap_previous_y:
    .byte $00,$84,$ff,$00,$00,$00,$00,$00,$2f,$00,$00,$00,$00,$ff,$00,$00
bitmap_previous_frame:
    .byte $37,$00,$00,$00,$00,$00,$00,$00,$93,$00,$00,$00,$00,$00,$f4,$60

bitmap_older_active:
    .byte $93,$cf,$37,$d4,$c9,$ce,$c7,$a0,$0d,$00,$00,$00,$00,$00,$00,$00
bitmap_older_x:
    .byte $0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
bitmap_older_y:
    .byte $00,$c1,$0d,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
bitmap_older_frame:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

title_text_and_loop_state:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

title_workspace_end:
.assert title_scalar_state - selector0_opening_start = $0a98, error, "title scalar workspace origin drift"
.assert particle_current_active - selector0_opening_start = $0ac1, error, "title particle workspace origin drift"
.assert title_event_state - selector0_opening_start = $0be1, error, "title event workspace origin drift"
.assert bitmap_current_active - selector0_opening_start = $0be7, error, "title bitmap workspace origin drift"
.assert title_text_and_loop_state - selector0_opening_start = $0ca7, error, "title text workspace origin drift"
.assert title_workspace_end - title_scalar_state = $021b, error, "title workspace size drift"

; Unreferenced load-image residue between the active workspace and the font.
; Bytes $14E1-$14FF resemble a partial monitor-output helper, but no decoded
; title path calls it and its final branch operand overlaps the first font byte;
; preserve the region as data rather than asserting executable semantics.
title_residual_prefix:
    .byte $00,$00,$00,$00,$0d,$ff,$00,$00,$14,$02,$00,$14,$ff,$01,$0c,$01
    .byte $00,$93,$c5,$d2,$00,$c4,$0d,$ff,$00,$00,$14,$02,$00,$14,$ff,$01
    .byte $0c,$0d,$ff,$00,$00,$14,$02,$00,$14,$ff,$01,$0c,$01,$00,$ca,$30
    .byte $0e,$b1,$01,$e6,$01,$d0,$02,$e6,$02,$c9,$00,$d0,$f4,$f0,$ef,$b1
    .byte $01,$f0,$0b,$20,$f0,$fd,$e6,$01,$d0,$f5,$e6,$02,$d0

; Sixty-four eight-byte glyphs. High-bit text bytes are reduced to their low
; six-bit glyph number by the renderer's three ASLs, indexing this $200-byte,
; page-aligned font from @/A..Z punctuation through space/digits/punctuation.
title_font_64x8:
    .byte $00,$3e,$03,$3b,$3b,$33,$33,$1e,$00,$33,$33,$33,$3f,$33,$33,$1e
    .byte $00,$1f,$33,$33,$1f,$33,$33,$1f,$00,$1e,$33,$03,$03,$03,$33,$1e
    .byte $00,$1f,$33,$33,$33,$33,$33,$1f,$00,$3f,$03,$03,$1f,$03,$03,$3f
    .byte $00,$03,$03,$03,$0f,$03,$03,$3f,$00,$3e,$33,$33,$3b,$03,$03,$3e
    .byte $00,$33,$33,$33,$3f,$33,$33,$33,$00,$1e,$0c,$0c,$0c,$0c,$0c,$1e
    .byte $00,$1e,$33,$30,$30,$30,$30,$30,$00,$33,$33,$1b,$0f,$1b,$33,$33
    .byte $00,$3f,$03,$03,$03,$03,$03,$03,$00,$33,$33,$33,$3f,$3f,$3f,$33
    .byte $00,$33,$3b,$3b,$3f,$37,$37,$33,$00,$1e,$33,$33,$33,$33,$33,$1e
    .byte $00,$03,$03,$03,$1f,$33,$33,$1f,$00,$36,$1b,$33,$33,$33,$33,$1e
    .byte $00,$33,$33,$1b,$1f,$33,$33,$1f,$00,$1f,$30,$30,$1e,$03,$03,$3e
    .byte $00,$0c,$0c,$0c,$0c,$0c,$0c,$3f,$00,$1e,$33,$33,$33,$33,$33,$33
    .byte $00,$0c,$1e,$33,$33,$33,$33,$33,$00,$1e,$3f,$3f,$33,$33,$33,$33
    .byte $00,$33,$33,$1e,$0c,$1e,$33,$33,$00,$0c,$0c,$0c,$1e,$33,$33,$33
    .byte $00,$3f,$03,$06,$0c,$18,$30,$3f,$00,$3f,$03,$03,$03,$03,$03,$3f
    .byte $00,$30,$18,$18,$0c,$06,$06,$03,$00,$3f,$30,$30,$30,$30,$30,$3f
    .byte $00,$00,$00,$00,$00,$33,$1e,$0c,$00,$7f,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00,$18,$18,$18,$18,$18
    .byte $00,$00,$00,$00,$00,$00,$36,$36,$00,$36,$7f,$36,$36,$36,$7f,$36
    .byte $00,$0c,$1f,$2c,$1e,$0d,$3e,$0c,$00,$33,$33,$06,$0c,$18,$33,$33
    .byte $00,$1e,$33,$3b,$06,$03,$33,$1e,$00,$00,$00,$00,$00,$0c,$0c,$0c
    .byte $00,$0c,$06,$03,$03,$03,$06,$0c,$00,$0c,$18,$30,$30,$30,$18,$0c
    .byte $00,$1e,$3f,$3f,$3f,$3f,$3f,$1e,$00,$0c,$0c,$3f,$3f,$0c,$0c,$00
    .byte $0c,$18,$18,$00,$00,$00,$00,$00,$00,$00,$00,$3f,$3f,$00,$00,$00
    .byte $00,$1c,$1c,$00,$00,$00,$00,$00,$00,$03,$03,$06,$0c,$18,$30,$30
    .byte $00,$1e,$37,$37,$3f,$3b,$3b,$1e,$00,$0c,$0c,$0c,$0c,$0c,$0e,$0c
    .byte $00,$3f,$03,$06,$1c,$30,$33,$1e,$00,$1e,$33,$30,$18,$30,$33,$1e
    .byte $00,$18,$18,$3f,$1b,$1e,$1c,$18,$00,$1f,$30,$30,$1f,$03,$03,$3f
    .byte $00,$1e,$33,$33,$1f,$03,$06,$18,$00,$0c,$0c,$0c,$0c,$18,$30,$3f
    .byte $00,$1e,$33,$33,$1e,$33,$33,$1e,$00,$0c,$18,$30,$3e,$33,$33,$1e
    .byte $00,$18,$18,$00,$00,$18,$18,$00,$0c,$18,$18,$00,$00,$18,$18,$00
    .byte $00,$18,$0c,$06,$03,$06,$0c,$18,$00,$00,$00,$3f,$00,$3f,$00,$00
    .byte $00,$06,$0c,$18,$30,$18,$0c,$06,$00,$0c,$00,$0c,$18,$30,$33,$1e

title_font_end:
.assert title_residual_prefix - selector0_opening_start = $0cb3, error, "title residual prefix origin drift"
.assert title_font_64x8 - selector0_opening_start = $0d00, error, "title font origin drift"
.assert <title_font_64x8 = $00, error, "title font must remain page aligned"
.assert title_font_end - title_font_64x8 = $0200, error, "title font size drift"

    .include "title_bitmaps.inc"

selector0_opening_end:
.assert selector0_opening_end - selector0_opening_start = $1800, error, "selector-0 opening size drift"
