; Rescue Raiders selector-0 protection tables/workspace at $642B-$67FF.
; Included by entry.s; the post-workspace tail is retained without runtime semantics.

protection_hgr_scanline_low:
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
.assert * - protection_hgr_scanline_low = $00c0, error, "protection_hgr_scanline_low size drift"

protection_hgr_scanline_high:
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
.assert * - protection_hgr_scanline_high = $00c0, error, "protection_hgr_scanline_high size drift"

protection_x_byte_offsets:
    .byte $00,$01,$02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06,$00,$01
    .byte $02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06,$00,$01,$02,$03
    .byte $04,$05,$06,$00,$01,$02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05
    .byte $06,$00,$01,$02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06,$00
    .byte $01,$02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06,$00,$01,$02
    .byte $03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06,$00,$01,$02,$03,$04
    .byte $05,$06,$00,$01,$02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06
    .byte $00,$01,$02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06,$00,$01
    .byte $02,$03,$04,$05,$06,$00,$01,$02,$03,$04,$05,$06
.assert * - protection_x_byte_offsets = $008c, error, "protection_x_byte_offsets size drift"

protection_x_mask_indices:
    .byte $00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$04,$04
    .byte $04,$04,$04,$04,$04,$06,$06,$06,$06,$06,$06,$06,$08,$08,$08,$08
    .byte $08,$08,$08,$0a,$0a,$0a,$0a,$0a,$0a,$0a,$0c,$0c,$0c,$0c,$0c,$0c
    .byte $0c,$0e,$0e,$0e,$0e,$0e,$0e,$0e,$10,$10,$10,$10,$10,$10,$10,$12
    .byte $12,$12,$12,$12,$12,$12,$14,$14,$14,$14,$14,$14,$14,$16,$16,$16
    .byte $16,$16,$16,$16,$18,$18,$18,$18,$18,$18,$18,$1a,$1a,$1a,$1a,$1a
    .byte $1a,$1a,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1e,$1e,$1e,$1e,$1e,$1e,$1e
    .byte $20,$20,$20,$20,$20,$20,$20,$22,$22,$22,$22,$22,$22,$22,$24,$24
    .byte $24,$24,$24,$24,$24,$26,$26,$26,$26,$26,$26,$26
.assert * - protection_x_mask_indices = $008c, error, "protection_x_mask_indices size drift"

protection_first_byte_masks:
    .byte $83,$8c,$b0,$c0,$80,$80,$80
.assert * - protection_first_byte_masks = $0007, error, "protection_first_byte_masks size drift"

protection_second_byte_masks:
    .byte $80,$80,$80,$81,$86,$98,$e0
.assert * - protection_second_byte_masks = $0007, error, "protection_second_byte_masks size drift"

protection_fill_even_masks:
    .byte $00,$55,$2a,$7f,$80,$d5,$aa,$ff
.assert * - protection_fill_even_masks = $0008, error, "protection_fill_even_masks size drift"

protection_fill_odd_masks:
    .byte $00,$2a,$55,$7f,$80,$aa,$d5,$ff
.assert * - protection_fill_odd_masks = $0008, error, "protection_fill_odd_masks size drift"

protection_initial_x_positions:
    .byte $46,$8b,$8b,$8b,$46,$00,$00,$00
.assert * - protection_initial_x_positions = $0008, error, "protection_initial_x_positions size drift"

protection_initial_y_positions:
    .byte $00,$0d,$60,$b3,$bf,$b3,$60,$0d
.assert * - protection_initial_y_positions = $0008, error, "protection_initial_y_positions size drift"

protection_initial_x_velocities:
    .byte $01,$00,$00,$00,$ff,$00,$00,$00
.assert * - protection_initial_x_velocities = $0008, error, "protection_initial_x_velocities size drift"

protection_initial_y_velocities:
    .byte $00,$01,$01,$01,$00,$ff,$ff,$ff
.assert * - protection_initial_y_velocities = $0008, error, "protection_initial_y_velocities size drift"

protection_table_padding:
    .byte $00
.assert * - protection_table_padding = $0001, error, "protection_table_padding size drift"

protection_initialized_workspace:
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$8d,$34,$0f
    .byte $a9,$15,$69,$00,$8d,$35,$0f,$98,$48,$8a,$48,$ac,$94,$14,$b9,$6b
    .byte $0f,$8d,$37,$0f,$b9,$83,$0f,$05,$00,$8d,$38,$0f,$ac,$00,$00,$00
    .byte $00
.assert * - protection_initialized_workspace = $0031, error, "protection_initialized_workspace size drift"

protection_residual_tail:
    .byte $bd,$34,$12,$99,$34,$12,$ad,$38,$0f,$18,$69,$04,$8d,$38,$0f,$ca
    .byte $10,$ee,$ee,$93,$14,$ad,$93,$14,$c9,$28,$d0,$12,$a9,$00,$8d,$93
    .byte $14,$ee,$94,$14,$ad,$94,$14,$c9,$18,$d0,$03,$ce,$94,$14,$68,$aa
    .byte $68,$a8,$68,$60,$ce,$95,$14,$60,$00,$80,$00,$80,$00,$80,$00,$80
    .byte $28,$a8,$28,$a8,$28,$a8,$28,$a8,$50,$d0,$50,$d0,$50,$d0,$50,$d0
    .byte $00,$00,$01,$01,$02,$02,$03,$03,$00,$00,$01,$01,$02,$02,$03,$03
    .byte $00,$00,$01,$01,$02,$02,$03,$03,$02,$01,$00,$01,$02,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$80,$80,$80,$80,$80,$80,$80,$80,$28,$28,$28
    .byte $28,$28,$28,$28,$28,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$28,$28,$28
    .byte $28,$28,$28,$28,$28,$a8,$a8,$a8,$a8,$a8,$a8,$a8,$a8
.assert * - protection_residual_tail = $00cd, error, "protection_residual_tail size drift"

protection_data_region_end:
.assert protection_hgr_scanline_low - selector0_entry_start = $042b, error, "protection data origin drift"
.assert protection_hgr_scanline_high - selector0_entry_start = $04eb, error, "protection HGR high table origin drift"
.assert protection_x_byte_offsets - selector0_entry_start = $05ab, error, "protection X-byte table origin drift"
.assert protection_x_mask_indices - selector0_entry_start = $0637, error, "protection X-mask table origin drift"
.assert protection_initial_x_positions - selector0_entry_start = $06e1, error, "protection point seeds origin drift"
.assert protection_initialized_workspace - selector0_entry_start = $0702, error, "protection workspace origin drift"
.assert protection_residual_tail - selector0_entry_start = $0733, error, "protection residual origin drift"
.assert protection_data_region_end - protection_hgr_scanline_low = $03d5, error, "protection data region size drift"

