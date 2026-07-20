; Rescue Raiders selector-0 terminal entry slice.
.setcpu "6502"
.segment "SELECTOR0_ENTRY"

rwts0 = $bb00
iob   = $bfe8

; The shared selector-0/6 overlay at $7800 loads one pointer-selected packed
; picture into $A000+ and expands all 7,680 visible bytes into HGR page 2.
; Selectors 0 and 1 resolve through the track-1/sector-0 pointer table to the
; two opening frames proven against emulator captures:
;   0: file $0100A, 5,519 packed bytes -> opening1
;   1: file $0259A, 5,657 packed bytes -> opening2
packed_hgr_overlay       = $7800
opening_multiband_reveal = $d800
opening_picture_1        = $00
opening_picture_2        = $01

protection_point_x_velocity = $670f
protection_point_y_velocity = $6717
protection_point_x_position = $671f
protection_point_y_position = $6727
protection_point_index      = $672f

protection_line_axis0_start = $6702
protection_line_axis0_end   = $6703
protection_line_axis1_start = $6704
protection_line_axis1_end   = $6705
protection_line_axis0_step  = $6709
protection_line_axis1_step  = $670a
protection_line_work_a_high = $670b
protection_line_work_b_high = $670c
protection_line_axis1_delta = $670d
protection_line_axis0_delta = $670e

selector0_entry_start:

; Clear display state, run the $0800 opening/title module, run the following
; protection/input stage, restore display state, then request selector 1.
selector0_main_entry:
    jsr clear_title_hgr_margins
    jsr $0800
    jsr run_protection_animation
    jsr restore_after_title
    lda #$01
    jmp $bfc8

selector0_entry_source_end:
.assert selector0_entry_source_end - selector0_main_entry = $0011, error, "selector-0 entry size drift"

; Enter the resident RWTS implementation with X/Y pointing at the stage-1 IOB.
rwts_default_iob:
    ldx #<iob
    ldy #>iob
    jmp rwts0

; Mix volatile input, banked-memory, and state bytes into a selector, initialize
; the display subsystem, then choose one of three bounded protection-animation
; paths. A zero selector is normalized to path one.
run_protection_animation:
    adc $6732
    adc $c060
    adc $c070
    adc $4e
    adc $4f
    adc $24
    adc $25
    adc $c000
    tax
    adc $d000,x
    tax
    adc $e000,x
    sta $6732
    jsr advance_protection_hgr_page
    lda #opening_picture_1
    jsr call_packed_hgr_overlay
    bit $c010
    lda $6732
    and #$03
    bne protection_path_ready
    lda #$01
protection_path_ready:
    tax
    dex
    bne protection_try_path_two
    jmp run_protection_path_one
protection_try_path_two:
    dex
    bne protection_path_three
    jmp run_protection_path_two
protection_path_three:
    jmp run_protection_path_three

protection_entry_front_end:
.assert rwts_default_iob - selector0_entry_start = $0011, error, "selector-0 RWTS trampoline origin drift"
.assert run_protection_animation - selector0_entry_start = $0018, error, "selector-0 protection entry origin drift"
.assert protection_entry_front_end - rwts_default_iob = $004a, error, "selector-0 protection front size drift"

; Composite a two-byte masked shape into both HGR pages at the current
; protection-animation coordinate. Tables at $642B/$64EB translate rows;
; $65AB/$6637 and the paired masks at $66C3/$66CA select the pixel pattern.
draw_protection_pixel_pair:
    ldy $6704
    lda $00
    ora protection_hgr_scanline_high,y
    sta $61
    eor #$60
    sta $63
    lda protection_hgr_scanline_low,y
    sta $60
    sta $62
    ldx $6702
    ldy protection_x_mask_indices,x
    lda protection_x_byte_offsets,x
    tax
    lda ($62),y
    and protection_first_byte_masks,x
    sta $6706
    lda protection_first_byte_masks,x
    eor #$ff
    and ($60),y
    ora $6706
    sta ($60),y
    iny
    lda ($62),y
    and protection_second_byte_masks,x
    sta $6706
    lda protection_second_byte_masks,x
    eor #$ff
    and ($60),y
    ora $6706
    sta ($60),y
    rts

; Clear all 32 pages of the HGR buffer selected by the high byte in $00.
; The active page is installed into the high byte of a self-modifying store.
clear_protection_hgr_page:
    ldx #$20
    lda $00
    sta clear_protection_store+2
    ldy #$00
    tya
clear_protection_page:
clear_protection_store:
    sta $1000,y
    iny
    bne clear_protection_page
    inc clear_protection_store+2
    dex
    bne clear_protection_page
    rts

; First visual path: initialize eight moving points and render 84 frames,
; allowing any latched key to leave through the shared cleanup at $63B5.
run_protection_path_one:
    jsr initialize_protection_points
    lda #$54
protection_path_one_frame:
    pha
    jsr draw_protection_spokes
    jsr update_protection_points
    lda $c000
    bpl protection_path_one_continue
    pla
    jmp finish_protection_animation
protection_path_one_continue:
    pla
    sec
    sbc #$01
    bne protection_path_one_frame
    jmp finish_protection_animation

protection_graphics_front_end:
.assert draw_protection_pixel_pair - selector0_entry_start = $005b, error, "protection pixel compositor origin drift"
.assert clear_protection_hgr_page - selector0_entry_start = $00a4, error, "protection HGR clear origin drift"
.assert run_protection_path_one - selector0_entry_start = $00bb, error, "protection path one origin drift"
.assert protection_graphics_front_end - draw_protection_pixel_pair = $007e, error, "protection graphics front size drift"

; Advance all eight perimeter points once.
update_protection_points:
    lda #$07
    sta protection_point_index
update_protection_point_loop:
    jsr update_protection_point
    dec protection_point_index
    bpl update_protection_point_loop
    rts

; Move one point around the rectangle bounded by X=$8C and Y=$C0. Exactly one
; axis velocity is active; reaching a boundary stops that axis and starts the
; other with direction selected from the orthogonal position.
update_protection_point:
    ldx protection_point_index
    lda protection_point_x_velocity,x
    beq protection_point_move_y
    clc
    adc protection_point_x_position,x
    cmp #$8c
    bcc protection_point_store_x
    lda #$00
    sta protection_point_x_velocity,x
    lda #$01
    sta protection_point_y_velocity,x
    lda protection_point_y_position,x
    beq protection_point_x_turn_done
    lda #$ff
    sta protection_point_y_velocity,x
protection_point_x_turn_done:
    rts
protection_point_store_x:
    sta protection_point_x_position,x
    rts
protection_point_move_y:
    lda protection_point_y_velocity,x
    clc
    adc protection_point_y_position,x
    cmp #$c0
    bcc protection_point_store_y
    lda #$00
    sta protection_point_y_velocity,x
    lda #$01
    sta protection_point_x_velocity,x
    lda protection_point_x_position,x
    beq protection_point_y_turn_done
    lda #$ff
    sta protection_point_x_velocity,x
protection_point_y_turn_done:
    rts
protection_point_store_y:
    sta protection_point_y_position,x
    rts

protection_point_motion_end:
.assert update_protection_points - selector0_entry_start = $00d9, error, "protection point-loop origin drift"
.assert update_protection_point - selector0_entry_start = $00e7, error, "protection point-update origin drift"
.assert protection_point_motion_end - update_protection_points = $005b, error, "protection point-motion size drift"

; Normalize signed endpoint deltas and dispatch one of two integer-error line
; walkers. Axis 0 is the coordinate consumed by the horizontal pixel tables;
; axis 1 selects the HGR scanline. The terminal endpoint becomes the next
; retained start point before the final pixel is emitted.
draw_protection_line:
    ldy #$01
    sty protection_line_axis0_step
    sty protection_line_axis1_step
    dey
    sty protection_line_work_a_high
    sty protection_line_work_b_high
    sty $65
    dey
    lda protection_line_axis1_end
    sec
    sbc protection_line_axis1_start
    bcs protection_axis1_delta_ready
    lda protection_line_axis1_start
    sec
    sbc protection_line_axis1_end
    sty protection_line_axis1_step
protection_axis1_delta_ready:
    sta protection_line_axis1_delta
    lda protection_line_axis0_end
    sec
    sbc protection_line_axis0_start
    bcs protection_axis0_delta_ready
    lda protection_line_axis0_start
    sec
    sbc protection_line_axis0_end
    sty protection_line_axis0_step
protection_axis0_delta_ready:
    sta protection_line_axis0_delta
    cmp protection_line_axis1_delta
    bcc protection_line_case_a
    jsr rasterize_protection_line_case_b
    jmp protection_line_finish
protection_line_case_a:
    jsr rasterize_protection_line_case_a
protection_line_finish:
    lda protection_line_axis0_end
    sta protection_line_axis0_start
    lda protection_line_axis1_end
    sta protection_line_axis1_start
    jmp draw_protection_pixel_pair

; First Bresenham-style error-accumulation case.
rasterize_protection_line_case_a:
    asl protection_line_axis0_delta
    rol protection_line_work_a_high
    lda protection_line_axis0_delta
    sec
    sbc protection_line_axis1_delta
    sta $64
    lda protection_line_work_b_high
    sbc protection_line_work_b_high
    sta $65
    ldy protection_line_axis1_delta
    asl protection_line_axis1_delta
    rol protection_line_work_b_high
    lda protection_line_axis0_delta
    sec
    sbc protection_line_axis1_delta
    sta protection_line_axis1_delta
    lda protection_line_work_a_high
    sbc protection_line_work_b_high
    sta protection_line_work_b_high
    tya
protection_line_case_a_loop:
    pha
    jsr draw_protection_pixel_pair
    lda $65
    bmi protection_line_case_a_add_axis0
    lda protection_line_axis0_start
    clc
    adc protection_line_axis0_step
    sta protection_line_axis0_start
    lda $64
    clc
    adc protection_line_axis1_delta
    sta $64
    lda $65
    adc protection_line_work_b_high
    sta $65
    jmp protection_line_case_a_advance_axis1
protection_line_case_a_add_axis0:
    lda $64
    clc
    adc protection_line_axis0_delta
    sta $64
    lda $65
    adc protection_line_work_a_high
    sta $65
protection_line_case_a_advance_axis1:
    lda protection_line_axis1_start
    clc
    adc protection_line_axis1_step
    sta protection_line_axis1_start
    pla
    sec
    sbc #$01
    bne protection_line_case_a_loop
    rts

; Second Bresenham-style error-accumulation case with the axes interchanged.
rasterize_protection_line_case_b:
    asl protection_line_axis1_delta
    rol protection_line_work_b_high
    lda protection_line_axis1_delta
    sec
    sbc protection_line_axis0_delta
    sta $64
    lda protection_line_work_b_high
    sbc protection_line_work_a_high
    sta $65
    ldy protection_line_axis0_delta
    asl protection_line_axis0_delta
    rol protection_line_work_a_high
    lda protection_line_axis1_delta
    sec
    sbc protection_line_axis0_delta
    sta protection_line_axis0_delta
    lda protection_line_work_b_high
    sbc protection_line_work_a_high
    sta protection_line_work_a_high
    tya
protection_line_case_b_loop:
    pha
    jsr draw_protection_pixel_pair
    lda $65
    bmi protection_line_case_b_add_axis1
    lda protection_line_axis1_start
    clc
    adc protection_line_axis1_step
    sta protection_line_axis1_start
    lda $64
    clc
    adc protection_line_axis0_delta
    sta $64
    lda $65
    adc protection_line_work_a_high
    sta $65
    jmp protection_line_case_b_advance_axis0
protection_line_case_b_add_axis1:
    lda $64
    clc
    adc protection_line_axis1_delta
    sta $64
    lda $65
    adc protection_line_work_b_high
    sta $65
protection_line_case_b_advance_axis0:
    lda protection_line_axis0_start
    clc
    adc protection_line_axis0_step
    sta protection_line_axis0_start
    pla
    sec
    sbc #$01
    bne protection_line_case_b_loop
    rts

protection_line_rasterizer_end:
.assert draw_protection_line - selector0_entry_start = $0134, error, "protection line entry origin drift"
.assert rasterize_protection_line_case_a - selector0_entry_start = $018f, error, "protection line case A origin drift"
.assert rasterize_protection_line_case_b - selector0_entry_start = $0207, error, "protection line case B origin drift"
.assert protection_line_rasterizer_end - draw_protection_line = $014b, error, "protection line rasterizer size drift"

; Load eight point positions and velocities from the tables at $66E1-$6700.
initialize_protection_points:
    ldx #$07
initialize_protection_point:
    lda protection_initial_x_positions,x
    sta protection_point_x_position,x
    lda protection_initial_y_positions,x
    sta protection_point_y_position,x
    lda protection_initial_x_velocities,x
    sta protection_point_x_velocity,x
    lda protection_initial_y_velocities,x
    sta protection_point_y_velocity,x
    dex
    bpl initialize_protection_point
    rts

; Draw all eight lines from the moving perimeter points to fixed center
; coordinate ($46,$60).
draw_protection_spokes:
    lda #$07
    sta protection_point_index
draw_protection_spoke_loop:
    jsr draw_protection_spoke
    dec protection_point_index
    bpl draw_protection_spoke_loop
    rts

draw_protection_spoke:
    ldx protection_point_index
    lda protection_point_x_position,x
    sta protection_line_axis0_start
    lda protection_point_y_position,x
    sta protection_line_axis1_start
    lda #$46
    sta protection_line_axis0_end
    lda #$60
    sta protection_line_axis1_end
    jmp draw_protection_line

protection_spoke_block_end:
.assert initialize_protection_points - selector0_entry_start = $027f, error, "protection point initializer origin drift"
.assert draw_protection_spokes - selector0_entry_start = $029d, error, "protection spoke loop origin drift"
.assert draw_protection_spoke - selector0_entry_start = $02ab, error, "protection spoke origin drift"
.assert protection_spoke_block_end - initialize_protection_points = $0048, error, "protection spoke block size drift"

; Draw one symmetric box frame twice with horizontal offsets 0 and $46.
draw_protection_symmetric_frame:
    lda #$00
    sta $6730
    jsr draw_protection_box_pair
    lda #$46
    sta $6730
    jsr draw_protection_box_pair
    rts

; Second and third visual paths traverse the same 36 box frames in opposite
; directions, with a keyboard escape into the shared cleanup.
run_protection_path_two:
    lda #$23
    sta protection_point_index
protection_path_two_frame:
    jsr draw_protection_symmetric_frame
    lda $c000
    bpl protection_path_two_continue
    jmp finish_protection_animation
protection_path_two_continue:
    dec protection_point_index
    bpl protection_path_two_frame
    jmp finish_protection_animation

run_protection_path_three:
    lda #$00
    sta protection_point_index
protection_path_three_frame:
    jsr draw_protection_symmetric_frame
    lda $c000
    bpl protection_path_three_continue
    jmp finish_protection_animation
protection_path_three_continue:
    inc protection_point_index
    lda protection_point_index
    cmp #$24
    bne protection_path_three_frame
    jmp finish_protection_animation

; Draw the box with vertical offsets 0 and $60.
draw_protection_box_pair:
    lda #$00
    sta $6731
    jsr draw_protection_box
    lda #$60
    sta $6731
    jsr draw_protection_box
    rts

protection_box_axis0_low:
    lda protection_point_index
    clc
    adc $6730
    rts

protection_box_axis0_high:
    lda #$45
    clc
    adc $6730
    sec
    sbc protection_point_index
    rts

protection_box_axis1_low:
    lda protection_point_index
    clc
    adc $6731
    rts

protection_box_axis1_high:
    lda #$5f
    sec
    sbc protection_point_index
    clc
    adc $6731
    rts

; Emit the four edges selected by the current frame and X/Y offsets.
draw_protection_box:
    jsr protection_box_axis0_low
    sta protection_line_axis0_start
    jsr protection_box_axis0_high
    sta protection_line_axis0_end
    jsr protection_box_axis1_low
    sta protection_line_axis1_start
    sta protection_line_axis1_end
    jsr draw_protection_line
    jsr protection_box_axis0_low
    sta protection_line_axis0_start
    jsr protection_box_axis0_high
    sta protection_line_axis0_end
    jsr protection_box_axis1_high
    sta protection_line_axis1_start
    sta protection_line_axis1_end
    jsr draw_protection_line
    jsr protection_box_axis0_low
    sta protection_line_axis0_start
    sta protection_line_axis0_end
    jsr protection_box_axis1_low
    sta protection_line_axis1_start
    jsr protection_box_axis1_high
    sta protection_line_axis1_end
    jsr draw_protection_line
    jsr protection_box_axis0_high
    sta protection_line_axis0_start
    sta protection_line_axis0_end
    jsr protection_box_axis1_low
    sta protection_line_axis1_start
    jsr protection_box_axis1_high
    sta protection_line_axis1_end
    jsr draw_protection_line
    rts

; Invoke the shared packed-HGR loader/decoder with A saved as its picture
; selector in $01. Force output to HGR page 2 ($4000-$5FFF), then restore the
; caller's active-page byte. After writing the 7,680 display bytes, the overlay
; clears page 2's 512 non-display HGR hole bytes.
call_packed_hgr_overlay:
    sta $01
    lda $00
    pha
    lda #$40
    sta $00
    jsr packed_hgr_overlay
    pla
    sta $00
    rts

finish_protection_animation:
    bit $c055
    lda #$20
    sta $00
    jsr copy_protection_hgr_page
    bit $c054
    rts

restore_after_title:
    lda #opening_picture_2
    jsr call_packed_hgr_overlay
    ; Copy page 2 to page 1 as an animated reveal. The resident language-card
    ; routine advances $4000/$4800/$5000/$5800 bands and both 20-byte screen
    ; halves together; Apple II HGR interleaving makes the pieces appear in
    ; parallel even though opening2 is independently packed, not a delta.
    jsr opening_multiband_reveal
    rts

; Clear the final eight bytes of both halves of every HGR page block. The high
; bytes of the two stores advance together across 32 pages.
clear_title_hgr_margins:
    ldx #$20
    lda #$00
clear_title_margin_page:
    ldy #$07
clear_title_margin_byte:
clear_title_margin_first_store:
    sta $4078,y
clear_title_margin_second_store:
    sta $40f8,y
    dey
    bpl clear_title_margin_byte
    inc clear_title_margin_first_store+2
    inc clear_title_margin_second_store+2
    dex
    bne clear_title_margin_page
    rts

protection_paths_and_cleanup_end:
.assert draw_protection_symmetric_frame - selector0_entry_start = $02c7, error, "protection symmetric frame origin drift"
.assert run_protection_path_two - selector0_entry_start = $02d8, error, "protection path two origin drift"
.assert run_protection_path_three - selector0_entry_start = $02f0, error, "protection path three origin drift"
.assert draw_protection_box_pair - selector0_entry_start = $030d, error, "protection box-pair origin drift"
.assert draw_protection_box - selector0_entry_start = $0344, error, "protection box origin drift"
.assert call_packed_hgr_overlay - selector0_entry_start = $03a5, error, "packed-HGR overlay call origin drift"
.assert finish_protection_animation - selector0_entry_start = $03b5, error, "protection cleanup origin drift"
.assert restore_after_title - selector0_entry_start = $03c3, error, "post-title restore origin drift"
.assert clear_title_hgr_margins - selector0_entry_start = $03cc, error, "title HGR margin clear origin drift"
.assert protection_paths_and_cleanup_end - draw_protection_symmetric_frame = $011e, error, "protection path/cleanup span size drift"

; On the initial $40 page, copy the opposite HGR page into it, toggle the page
; byte, and select visible page 1. Other page states return unchanged.
advance_protection_hgr_page:
    lda $00
    cmp #$40
    bne protection_hgr_page_return
    jsr copy_protection_hgr_page
    lda $00
    eor #$60
    sta $00
    bit $c054
advance_protection_page_done:
    rts

; Copy 32 paired 120-byte HGR bands from the opposite page to the page in $00.
; Four high-byte operands advance together across the HGR address space.
copy_protection_hgr_page:
    lda $00
    sta copy_protection_first_destination+2
    sta copy_protection_second_destination+2
    eor #$60
    sta copy_protection_first_source+2
    sta copy_protection_second_source+2
    ldx #$20
copy_protection_page_block:
    ldy #$77
copy_protection_page_byte:
copy_protection_first_source:
    lda $4000,y
copy_protection_first_destination:
    sta $2000,y
copy_protection_second_source:
    lda $4080,y
copy_protection_second_destination:
    sta $2080,y
    dey
    bpl copy_protection_page_byte
    inc copy_protection_first_source+2
    inc copy_protection_first_destination+2
    inc copy_protection_second_source+2
    inc copy_protection_second_destination+2
    dex
    bne copy_protection_page_block
protection_hgr_page_return:
    rts

protection_hgr_page_block_end:
.assert advance_protection_hgr_page - selector0_entry_start = $03e5, error, "protection page advance origin drift"
.assert copy_protection_hgr_page - selector0_entry_start = $03f8, error, "protection HGR copy origin drift"
.assert protection_hgr_page_block_end - advance_protection_hgr_page = $0046, error, "protection HGR page block size drift"

    .include "../../assets/protection/protection_tables.inc"

selector0_entry_end:
.assert selector0_entry_end - selector0_entry_start = $0800, error, "selector-0 entry load size drift"
