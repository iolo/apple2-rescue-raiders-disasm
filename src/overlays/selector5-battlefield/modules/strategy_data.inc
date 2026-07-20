; Strategy scripts, dispatch tables, rankings, and initialized workspace.

strategy_primary_script_values:
    .byte $05,$02,$00,$01,$ff,$03,$03,$04,$05,$ff,$03,$03,$06,$05,$ff,$03
    .byte $0b,$07,$05,$ff,$01,$03,$06,$00,$09,$ff,$0a,$ff,$00,$0c,$0d,$ff
    .byte $02,$08,$ff
strategy_primary_script_offsets:
    .byte $00,$05,$0a,$0f,$14,$1c,$20

; Secondary phase stream and starting offsets used by the first handler family.
strategy_secondary_script_values:
    .byte $02,$ff,$00,$ff,$01,$04,$ff,$01,$04,$0b,$0c,$0a,$02,$09,$00,$ff
    .byte $01,$04,$ff,$02,$07,$ff,$01,$0a,$ff,$01,$0a,$ff,$01,$0d,$ff,$01
    .byte $04,$0b,$00,$ff,$01,$04,$08,$00,$ff,$0b,$ff,$01,$04,$00,$ff,$01
    .byte $0e,$0f,$ff
strategy_secondary_script_offsets:
    .byte $00,$02,$04,$07,$10,$13,$16,$19,$1c,$1f,$24,$07,$2b,$2f

; Seven 8-byte strategy progression rows plus a 16-byte residual/control row.
; Their consumers establish the row structure; individual semantic fields are
; retained without stronger names until all indirect state uses are classified.
strategy_auxiliary_progression_tables:
    .byte $00,$01,$02,$03,$04,$05,$06,$07
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$01,$01,$01,$01
    .byte $00,$00,$01,$01,$02,$02,$02,$02
    .byte $00,$01,$01,$02,$02,$03,$03,$03
    .byte $00,$01,$02,$02,$03,$03,$04,$04
    .byte $00,$01,$02,$03,$04,$04,$05,$05
    .byte $00,$01,$02,$03,$04,$05,$06,$06
    .byte $00,$01,$02,$03,$04,$05,$06,$07

; Seventeen first-stage handlers, selected by $605E.
strategy_first_handler_pointers:
    .word strategy_handle_input_gate,strategy_handle_object_altitude
    .word strategy_handle_service_altitude,strategy_handle_saved_altitude
    .word strategy_handle_low_horizontal_speed,strategy_handle_noop_1
    .word strategy_handle_noop_2,strategy_handle_grounded_command
    .word strategy_handle_type12_search,strategy_handle_type0d_proximity
    .word strategy_handle_tracked_object,strategy_handle_countdown_motion
    .word strategy_handle_mark_state,strategy_handle_linked_target
    .word strategy_handle_opposing_player,strategy_handle_opponent_pursuit
    .word strategy_handle_opponent_gate

; Fourteen secondary action handlers, selected by $605A.
strategy_secondary_handler_pointers:
    .word strategy_action_finalize_1,strategy_action_finalize_2
    .word strategy_action_offset_from_link,strategy_action_acquire_type0d
    .word strategy_action_finalize_3,strategy_action_search_type40
    .word strategy_action_track_saved_object,strategy_action_offset_saved_object
    .word strategy_action_finalize_4,strategy_action_follow_moving_target
    .word strategy_action_follow_wide_target,strategy_action_acquire_type0d
    .word strategy_action_refresh_opponent_link,strategy_action_opponent_resource_gate

; Seven primary action handlers, selected by $6056.
strategy_primary_handler_pointers:
    .word strategy_action_enable_motion,strategy_action_copy_opponent_candidate
    .word strategy_action_type0e_candidate_entry,strategy_action_offset_any_object_entry
    .word strategy_action_boundary_gate_entry,strategy_action_opponent_gate2_entry
    .word strategy_action_stage_delay_entry

strategy_pointer_table_residual:
    .byte $fa

; Negative values are addressed with base $AA63 and Y=$E5..$FF, wrapping into
; this physical span. The positive table begins at $AB63. Its final indexed
; byte overlaps the first side-specific type-$0D offset at $AB7E.
strategy_wrapped_negative_velocity_values:
    .byte $fa,$fa,$fa,$fa,$fa,$fa,$fb,$fb,$fb,$fb,$fb,$fb,$fc,$fc,$fc,$fc
    .byte $fc,$fd,$fd,$fd,$fd,$fe,$fe,$fe,$ff,$ff,$00
strategy_positive_velocity_table:
    .byte $01,$01,$02,$02,$02,$03,$03,$03,$03,$04,$04,$04,$04,$04,$05,$05
    .byte $05,$05,$05,$05,$06,$06,$06,$06,$06,$06,$06
strategy_type0d_horizontal_low:
    .byte $40,$c0
strategy_type0d_horizontal_high:
    .byte $00,$ff
strategy_object_offset_low:
    .byte $e0,$20
strategy_object_offset_high:
    .byte $ff,$00

strategy_auxiliary_flags:
    .byte $ff,$ff,$ff,$01,$01,$01,$ff,$00,$01,$00,$00,$00,$00,$01,$01,$00
    .byte $01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01
    .byte $00,$00,$00,$00,$00

; Object-type eligibility/rank and the three rank-clearance values used by the
; hostile-target scoring scan.
strategy_target_rank_by_type:
    .byte $00,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$00,$01,$ff
    .byte $02,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff
strategy_target_clearance_by_rank:
    .byte $00,$00,$00

strategy_command_table:
    .byte $c5,$c4,$c1,$d4,$cd       ; high-bit E/D/A/T/M
strategy_side:
    .byte $00
strategy_opposing_side:
    .byte $00
strategy_initialized_workspace:
    .res 45,$00

strategy_tables_source_end:
.assert strategy_primary_script_values - selector5_start = $4148, error, "primary strategy script table origin drift"
.assert strategy_primary_script_offsets - selector5_start = $416b, error, "primary strategy offset table origin drift"
.assert strategy_secondary_script_values - selector5_start = $4172, error, "secondary strategy script table origin drift"
.assert strategy_secondary_script_offsets - selector5_start = $41a5, error, "secondary strategy offset table origin drift"
.assert strategy_first_handler_pointers - selector5_start = $41fb, error, "first strategy handler table origin drift"
.assert strategy_secondary_handler_pointers - selector5_start = $421d, error, "secondary strategy handler table origin drift"
.assert strategy_primary_handler_pointers - selector5_start = $4239, error, "primary strategy handler table origin drift"
.assert strategy_wrapped_negative_velocity_values - selector5_start = $4248, error, "wrapped negative velocity table origin drift"
.assert strategy_positive_velocity_table - selector5_start = $4263, error, "positive velocity table origin drift"
.assert strategy_type0d_horizontal_low - selector5_start = $427e, error, "type-0D side-offset table origin drift"
.assert strategy_target_rank_by_type - selector5_start = $42ab, error, "strategy target-rank table origin drift"
.assert strategy_command_table - selector5_start = $42cc, error, "strategy command table origin drift"
.assert strategy_side - selector5_start = $42d1, error, "strategy side workspace origin drift"
.assert strategy_tables_source_end - strategy_primary_script_values = $01b8, error, "strategy table/workspace size drift"

; Public ACxx module entries. The first three initialization hooks are no-ops;
; the remaining entries expose object updating, destruction aftermath, and
; unlinking to the selector-5 main loop and collision handlers.
