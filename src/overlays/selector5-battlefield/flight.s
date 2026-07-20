; Rescue Raiders selector-5 battlefield overlay: flight input, objects, combat,
; strategy, display, data, and player-helicopter motion.
.setcpu "6502"
.segment "SELECTOR5"

paddle_trigger = $c070
paddle_0       = $c064
paddle_1       = $c065

last_score_digits         = $01fc
default_high_score_names  = $0400 ; five 16-byte high-bit names, loaded from T0/S15
default_high_score_values = $0450 ; five two-byte packed-BCD scores
high_score_cutoff_bcd_hi  = default_high_score_values+8 ; $12 from fifth-place 1245
high_score_cutoff_bcd_lo  = default_high_score_values+9 ; $45

horizontal_target = $604d
vertical_target   = $604e
current_object    = $60c3
desired_horizontal_velocity = $60e3
desired_vertical_position   = $60e4
strategy_shared_update_entry = $9efb
strategy_negative_velocity_table = strategy_wrapped_negative_velocity_values-$e5

; Keep these includes in address order. Together they emit the original
; contiguous $6900-$BAFF selector-5 load; labels intentionally remain in one
; ca65 translation unit because the original modules call across boundaries.
.include "modules/battlefield_flow.inc"
.include "modules/object_construction.inc"
.include "modules/object_updates.inc"
.include "modules/secondary_behaviors.inc"
.include "modules/input_and_player.inc"
.include "modules/strategy_core.inc"
.include "modules/strategy_actions.inc"
.include "modules/strategy_data.inc"
.include "modules/damage_and_collisions.inc"
.include "modules/display.inc"
