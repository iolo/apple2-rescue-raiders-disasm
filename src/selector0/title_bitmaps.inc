; Rescue Raiders selector-0 bitmap descriptor region at $1700-$1FFF.
; Included by opening.s; pointer words are offsets relative to $1700.

title_bitmap_descriptor_offsets:
    .word title_bitmap_descriptor_00 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_01 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_02 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_03 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_04 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_05 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_06 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_07 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_08 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_09 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_10 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_11 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_12 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_13 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_14 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_15 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_16 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_17 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_18 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_19 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_20 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_21 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_22 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_23 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_24 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_25 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_26 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_27 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_28 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_29 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_30 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_31 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_32 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_33 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_34 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_35 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_36 - title_bitmap_descriptor_offsets
    .word title_bitmap_descriptor_37 - title_bitmap_descriptor_offsets

title_bitmap_descriptor_00:
    .byte $11,$01 ; width, height
    .byte $7c,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $1f
.assert * - title_bitmap_descriptor_00 = $0013, error, "title bitmap descriptor 00 size drift"

title_bitmap_descriptor_01:
    .byte $11,$01 ; width, height
    .byte $78,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $3f
.assert * - title_bitmap_descriptor_01 = $0013, error, "title bitmap descriptor 01 size drift"

title_bitmap_descriptor_02:
    .byte $0f,$01 ; width, height
    .byte $00,$00,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
.assert * - title_bitmap_descriptor_02 = $0011, error, "title bitmap descriptor 02 size drift"

title_bitmap_descriptor_03:
    .byte $0f,$01 ; width, height
    .byte $00,$00,$7e,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
.assert * - title_bitmap_descriptor_03 = $0011, error, "title bitmap descriptor 03 size drift"

title_bitmap_descriptor_04:
    .byte $0b,$01 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$60,$7f,$7f,$7f,$03
.assert * - title_bitmap_descriptor_04 = $000d, error, "title bitmap descriptor 04 size drift"

title_bitmap_descriptor_05:
    .byte $0b,$01 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$40,$7f,$7f,$7f,$07
.assert * - title_bitmap_descriptor_05 = $000d, error, "title bitmap descriptor 05 size drift"

title_bitmap_descriptor_06:
    .byte $11,$10 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$3c,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$28,$41,$0a,$05,$0a,$14,$22,$05,$2a,$40,$02,$45,$0a,$54,$28
    .byte $41,$02,$6c,$65,$4e,$15,$2b,$16,$33,$07,$3b,$59,$4b,$65,$2e,$76
    .byte $6c,$65,$0a,$2c,$66,$42,$15,$2b,$16,$33,$01,$4b,$59,$4c,$65,$32
    .byte $16,$2c,$66,$0a,$2c,$66,$42,$1d,$3b,$16,$33,$01,$4b,$59,$4c,$65
    .byte $32,$16,$2c,$66,$0e,$2c,$66,$42,$05,$0b,$16,$33,$01,$4b,$59,$4c
    .byte $65,$32,$16,$2c,$66,$02,$2c,$61,$4a,$05,$0b,$16,$33,$05,$2b,$58
    .byte $4a,$65,$32,$56,$2c,$61,$02,$2c,$61,$4a,$15,$0b,$16,$33,$05,$2b
    .byte $58,$4a,$65,$32,$56,$2c,$61,$0a,$6c,$65,$0e,$16,$0b,$16,$33,$07
    .byte $3b,$59,$4b,$65,$32,$76,$6c,$05,$0b,$2c,$66,$02,$16,$0b,$16,$33
    .byte $01,$4b,$59,$4c,$65,$32,$16,$2c,$06,$0b,$2c,$66,$02,$16,$0b,$16
    .byte $33,$01,$4b,$59,$4c,$65,$32,$16,$2c,$06,$0b,$2c,$66,$02,$16,$0b
    .byte $16,$33,$01,$4b,$59,$4c,$65,$32,$16,$2c,$06,$0b,$2c,$66,$4a,$15
    .byte $2b,$16,$33,$05,$4b,$59,$4c,$65,$2a,$56,$2c,$66,$0a,$2c,$66,$4a
    .byte $15,$2b,$56,$32,$05,$4b,$59,$4c,$65,$2a,$56,$2c,$66,$0a,$2c,$66
    .byte $4a,$15,$2b,$56,$32,$05,$4b,$59,$4c,$65,$2a,$56,$2c,$66,$0a,$3c
    .byte $66,$0f,$1f,$3e,$7c,$73,$07,$4f,$79,$4c,$67,$3f,$7e,$3c,$46,$0f
.assert * - title_bitmap_descriptor_06 = $0112, error, "title bitmap descriptor 06 size drift"

title_bitmap_descriptor_07:
    .byte $11,$10 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$78,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$50,$02,$15,$0a,$14,$28,$44,$0a,$54,$00,$05,$0a,$15,$28,$51
    .byte $02,$05,$58,$4b,$1d,$2b,$56,$2c,$66,$0e,$76,$32,$17,$4b,$5d,$6c
    .byte $59,$4b,$15,$58,$4c,$05,$2b,$56,$2c,$66,$02,$16,$33,$19,$4b,$65
    .byte $2c,$58,$4c,$15,$58,$4c,$05,$3b,$76,$2c,$66,$02,$16,$33,$19,$4b
    .byte $65,$2c,$58,$4c,$1d,$58,$4c,$05,$0b,$16,$2c,$66,$02,$16,$33,$19
    .byte $4b,$65,$2c,$58,$4c,$05,$58,$42,$15,$0b,$16,$2c,$66,$0a,$56,$30
    .byte $15,$4b,$65,$2c,$59,$42,$05,$58,$42,$15,$2b,$16,$2c,$66,$0a,$56
    .byte $30,$15,$4b,$65,$2c,$59,$42,$15,$58,$4b,$1d,$2c,$16,$2c,$66,$0e
    .byte $76,$32,$17,$4b,$65,$6c,$59,$0b,$16,$58,$4c,$05,$2c,$16,$2c,$66
    .byte $02,$16,$33,$19,$4b,$65,$2c,$58,$0c,$16,$58,$4c,$05,$2c,$16,$2c
    .byte $66,$02,$16,$33,$19,$4b,$65,$2c,$58,$0c,$16,$58,$4c,$05,$2c,$16
    .byte $2c,$66,$02,$16,$33,$19,$4b,$65,$2c,$58,$0c,$16,$58,$4c,$15,$2b
    .byte $56,$2c,$66,$0a,$16,$33,$19,$4b,$55,$2c,$59,$4c,$15,$58,$4c,$15
    .byte $2b,$56,$2c,$65,$0a,$16,$33,$19,$4b,$55,$2c,$59,$4c,$15,$58,$4c
    .byte $15,$2b,$56,$2c,$65,$0a,$16,$33,$19,$4b,$55,$2c,$59,$4c,$15,$78
    .byte $4c,$1f,$3e,$7c,$78,$67,$0f,$1e,$73,$19,$4f,$7f,$7c,$79,$0c,$1f
.assert * - title_bitmap_descriptor_07 = $0112, error, "title bitmap descriptor 07 size drift"

title_bitmap_descriptor_08:
    .byte $14,$17 ; width, height
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $3f,$0c,$00,$00,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$3f,$0c,$00,$00,$3f,$55,$2f,$75,$2b,$75,$7f,$7f
    .byte $2b,$55,$2f,$55,$3f,$55,$2f,$5f,$3e,$4c,$2a,$01,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$3f,$4c,$2a,$05
    .byte $2f,$55,$2f,$75,$2b,$55,$7f,$7f,$2b,$55,$2f,$55,$2f,$55,$2f,$5f
    .byte $3e,$4c,$0a,$04,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$3f,$40,$0a,$04,$2f,$7f,$3f,$7d,$6b,$57,$7f,$7f
    .byte $3f,$7d,$2f,$7f,$2f,$7f,$2f,$55,$3e,$5c,$0a,$04,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$3f,$5c,$0a,$04
    .byte $3f,$75,$3f,$7d,$2b,$55,$3f,$55,$3f,$7d,$2f,$75,$2f,$7f,$2f,$55
    .byte $3e,$5c,$2a,$0d,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$3f,$5c,$2a,$0d,$7f,$57,$3f,$7d,$6b,$75,$7f,$7f
    .byte $3f,$7d,$2f,$7f,$2f,$7f,$2f,$5f,$3e,$5c,$7a,$0d,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$3f,$5c,$2a,$0d
    .byte $2f,$55,$2f,$75,$6b,$57,$7f,$7f,$3f,$7d,$2f,$55,$2f,$55,$2f,$5f
    .byte $3e,$5c,$7e,$0d,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$3f,$5c,$2a,$0d,$2f,$75,$2f,$75,$6b,$57,$7f,$7f
    .byte $3f,$7d,$2f,$55,$3f,$55,$2f,$5f,$3e,$5c,$7f,$0d,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$3f,$5c,$2a,$0d
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $3f,$5c,$2a,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$02,$04,$02,$38,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$06,$1c,$40,$7f,$02,$00,$02,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$7f,$00,$00
    .byte $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $40,$7f,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$40,$7f,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.assert * - title_bitmap_descriptor_08 = $01ce, error, "title bitmap descriptor 08 size drift"

title_bitmap_descriptor_09:
    .byte $14,$17 ; width, height
    .byte $7e,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$18,$00,$00,$7e,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$18,$00,$00,$7e,$2a,$5f,$6a,$57,$6a,$7f,$7f
    .byte $57,$2a,$5f,$2a,$7f,$2a,$5f,$3e,$7d,$18,$55,$02,$7e,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$18,$55,$0a
    .byte $5e,$2a,$5f,$6a,$57,$2a,$7f,$7f,$57,$2a,$5f,$2a,$5f,$2a,$5f,$3e
    .byte $7d,$18,$15,$08,$7e,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$00,$15,$08,$5e,$7e,$7f,$7a,$57,$2f,$7f,$7f
    .byte $7f,$7a,$5f,$7e,$5f,$7e,$5f,$2a,$7d,$38,$15,$08,$7e,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$38,$15,$08
    .byte $7e,$6a,$7f,$7a,$57,$2a,$7f,$2a,$7f,$7a,$5f,$6a,$5f,$7e,$5f,$2a
    .byte $7d,$38,$55,$1a,$7e,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$38,$55,$1a,$7e,$2f,$7f,$7a,$57,$6b,$7f,$7f
    .byte $7f,$7a,$5f,$7e,$5f,$7e,$5f,$3e,$7d,$38,$75,$1b,$7e,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$38,$55,$1a
    .byte $5e,$2a,$5f,$6a,$57,$2f,$7f,$7f,$7f,$7a,$5f,$2a,$5f,$2a,$5f,$3e
    .byte $7d,$38,$7d,$1b,$7e,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$38,$55,$1a,$5e,$6a,$5f,$6a,$57,$2f,$7f,$7f
    .byte $7f,$7a,$5f,$2a,$7f,$2a,$5f,$3e,$7d,$38,$7f,$1b,$7e,$7f,$7f,$7f
    .byte $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$38,$55,$1a
    .byte $7e,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byte $7f,$38,$55,$0a,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$04,$08,$04,$70,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$0c,$38,$00,$7f,$05,$00,$04,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7f,$01,$00
    .byte $04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$7f,$01,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$7f,$01,$00,$04,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
.assert * - title_bitmap_descriptor_09 = $01ce, error, "title bitmap descriptor 09 size drift"

title_bitmap_descriptor_10:
    .byte $03,$07 ; width, height
    .byte $00,$00,$00,$60,$03,$0f,$30,$46,$19,$58,$6d,$36,$58,$6d,$36,$30
    .byte $46,$19,$60,$03,$0f
.assert * - title_bitmap_descriptor_10 = $0017, error, "title bitmap descriptor 10 size drift"

title_bitmap_descriptor_11:
    .byte $03,$07 ; width, height
    .byte $00,$00,$00,$40,$07,$1e,$60,$0c,$33,$30,$5b,$6d,$30,$5b,$6d,$60
    .byte $0c,$33,$40,$07,$1e
.assert * - title_bitmap_descriptor_11 = $0017, error, "title bitmap descriptor 11 size drift"

title_bitmap_descriptor_12:
    .byte $03,$07 ; width, height
    .byte $00,$00,$0f,$60,$43,$19,$30,$66,$36,$58,$6d,$36,$58,$4d,$19,$30
    .byte $06,$0f,$60,$03,$00
.assert * - title_bitmap_descriptor_12 = $0017, error, "title bitmap descriptor 12 size drift"

title_bitmap_descriptor_13:
    .byte $03,$07 ; width, height
    .byte $00,$00,$1e,$40,$07,$33,$60,$4c,$6d,$30,$5b,$6d,$30,$1b,$33,$60
    .byte $0c,$1e,$40,$07,$00
.assert * - title_bitmap_descriptor_13 = $0017, error, "title bitmap descriptor 13 size drift"

title_bitmap_descriptor_14:
    .byte $03,$07 ; width, height
    .byte $60,$03,$00,$30,$06,$0f,$58,$4d,$19,$58,$6d,$36,$30,$66,$36,$60
    .byte $43,$19,$00,$00,$0f
.assert * - title_bitmap_descriptor_14 = $0017, error, "title bitmap descriptor 14 size drift"

title_bitmap_descriptor_15:
    .byte $03,$07 ; width, height
    .byte $40,$07,$00,$60,$0c,$1e,$30,$1b,$33,$30,$5b,$6d,$60,$4c,$6d,$40
    .byte $07,$33,$00,$00,$1e
.assert * - title_bitmap_descriptor_15 = $0017, error, "title bitmap descriptor 15 size drift"

title_bitmap_descriptor_16:
    .byte $03,$07 ; width, height
    .byte $00,$00,$00,$70,$41,$07,$18,$63,$0c,$6c,$36,$1b,$6c,$36,$1b,$18
    .byte $63,$0c,$70,$41,$07
.assert * - title_bitmap_descriptor_16 = $0017, error, "title bitmap descriptor 16 size drift"

title_bitmap_descriptor_17:
    .byte $03,$07 ; width, height
    .byte $00,$00,$00,$60,$03,$0f,$30,$46,$19,$58,$6d,$36,$58,$6d,$36,$30
    .byte $46,$19,$60,$03,$0f
.assert * - title_bitmap_descriptor_17 = $0017, error, "title bitmap descriptor 17 size drift"

title_bitmap_descriptor_18:
    .byte $03,$07 ; width, height
    .byte $00,$40,$07,$70,$61,$0c,$18,$33,$1b,$6c,$36,$1b,$6c,$66,$0c,$18
    .byte $43,$07,$70,$01,$00
.assert * - title_bitmap_descriptor_18 = $0017, error, "title bitmap descriptor 18 size drift"

title_bitmap_descriptor_19:
    .byte $03,$07 ; width, height
    .byte $00,$00,$0f,$60,$43,$19,$30,$66,$36,$58,$6d,$36,$58,$4d,$19,$30
    .byte $06,$0f,$60,$03,$00
.assert * - title_bitmap_descriptor_19 = $0017, error, "title bitmap descriptor 19 size drift"

title_bitmap_descriptor_20:
    .byte $03,$07 ; width, height
    .byte $70,$01,$00,$18,$43,$07,$6c,$66,$0c,$6c,$36,$1b,$18,$33,$1b,$70
    .byte $61,$0c,$00,$40,$07
.assert * - title_bitmap_descriptor_20 = $0017, error, "title bitmap descriptor 20 size drift"

title_bitmap_descriptor_21:
    .byte $03,$07 ; width, height
    .byte $60,$03,$00,$30,$06,$0f,$58,$4d,$19,$58,$6d,$36,$30,$66,$36,$60
    .byte $43,$19,$00,$00,$0f
.assert * - title_bitmap_descriptor_21 = $0017, error, "title bitmap descriptor 21 size drift"

title_bitmap_descriptor_22:
    .byte $02,$07 ; width, height
    .byte $00,$00,$70,$01,$18,$03,$6c,$06,$6c,$06,$18,$03,$70,$01
.assert * - title_bitmap_descriptor_22 = $0010, error, "title bitmap descriptor 22 size drift"

title_bitmap_descriptor_23:
    .byte $02,$07 ; width, height
    .byte $00,$00,$60,$03,$30,$06,$58,$0d,$58,$0d,$30,$06,$60,$03
.assert * - title_bitmap_descriptor_23 = $0010, error, "title bitmap descriptor 23 size drift"

title_bitmap_descriptor_24:
    .byte $02,$07 ; width, height
    .byte $70,$01,$18,$03,$6c,$06,$6c,$06,$18,$03,$70,$01,$00,$00
.assert * - title_bitmap_descriptor_24 = $0010, error, "title bitmap descriptor 24 size drift"

title_bitmap_descriptor_25:
    .byte $02,$07 ; width, height
    .byte $60,$03,$30,$06,$58,$0d,$58,$0d,$30,$06,$60,$03,$00,$00
.assert * - title_bitmap_descriptor_25 = $0010, error, "title bitmap descriptor 25 size drift"

title_bitmap_descriptor_26:
    .byte $02,$02 ; width, height
    .byte $00,$03,$00,$06
.assert * - title_bitmap_descriptor_26 = $0006, error, "title bitmap descriptor 26 size drift"

title_bitmap_descriptor_27:
    .byte $02,$02 ; width, height
    .byte $00,$06,$00,$0c
.assert * - title_bitmap_descriptor_27 = $0006, error, "title bitmap descriptor 27 size drift"

title_bitmap_descriptor_28:
    .byte $02,$04 ; width, height
    .byte $00,$00,$00,$00,$00,$30,$00,$38
.assert * - title_bitmap_descriptor_28 = $000a, error, "title bitmap descriptor 28 size drift"

title_bitmap_descriptor_29:
    .byte $02,$04 ; width, height
    .byte $00,$00,$00,$00,$00,$60,$00,$70
.assert * - title_bitmap_descriptor_29 = $000a, error, "title bitmap descriptor 29 size drift"

title_bitmap_descriptor_30:
    .byte $03,$05 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$03,$00,$40,$03,$00,$00,$03
.assert * - title_bitmap_descriptor_30 = $0011, error, "title bitmap descriptor 30 size drift"

title_bitmap_descriptor_31:
    .byte $03,$05 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$06,$00,$00,$07,$00,$00,$06
.assert * - title_bitmap_descriptor_31 = $0011, error, "title bitmap descriptor 31 size drift"

title_bitmap_descriptor_32:
    .byte $03,$06 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0c,$00,$00,$0e,$00
    .byte $00,$1c
.assert * - title_bitmap_descriptor_32 = $0014, error, "title bitmap descriptor 32 size drift"

title_bitmap_descriptor_33:
    .byte $03,$06 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$00,$00,$1c,$00
    .byte $00,$38
.assert * - title_bitmap_descriptor_33 = $0014, error, "title bitmap descriptor 33 size drift"

title_bitmap_descriptor_34:
    .byte $04,$08 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$60,$01,$00,$00,$60,$03,$00,$00,$40,$03
.assert * - title_bitmap_descriptor_34 = $0022, error, "title bitmap descriptor 34 size drift"

title_bitmap_descriptor_35:
    .byte $04,$08 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$40,$03,$00,$00,$40,$07,$00,$00,$00,$07
.assert * - title_bitmap_descriptor_35 = $0022, error, "title bitmap descriptor 35 size drift"

title_bitmap_descriptor_36:
    .byte $04,$09 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$07,$00,$00,$40,$0f
    .byte $00,$00,$00,$0f
.assert * - title_bitmap_descriptor_36 = $0026, error, "title bitmap descriptor 36 size drift"

title_bitmap_descriptor_37:
    .byte $04,$09 ; width, height
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$0f,$00,$00,$00,$1f
    .byte $00,$00,$00,$1e
.assert * - title_bitmap_descriptor_37 = $0026, error, "title bitmap descriptor 37 size drift"

; Bytes after the final valid descriptor are retained as unclassified residue.
title_bitmap_residual_tail:
    .byte $6f,$20,$1c,$3f,$4c,$0b,$3c,$ad,$5c,$22,$d0,$18,$a9,$77,$20,$1c
    .byte $3f,$20,$ad,$3c,$c9,$d2,$f0,$09,$c9,$d3,$d0,$f5,$a2,$01,$8d,$4f
    .byte $22,$20,$ed,$fd,$20,$3d,$21,$20,$56,$21,$ad,$5c,$22,$c9,$04,$d0
    .byte $26,$38,$a9,$00,$ed,$02,$71,$8d,$56,$22,$a9,$00,$ed,$03,$71,$8d
    .byte $57,$22,$38,$a9

title_bitmap_region_end:
.assert title_bitmap_descriptor_offsets - selector0_opening_start = $0f00, error, "title bitmap region origin drift"
.assert title_bitmap_residual_tail - selector0_opening_start = $17bc, error, "title bitmap residual origin drift"
.assert title_bitmap_region_end - title_bitmap_descriptor_offsets = $0900, error, "title bitmap region size drift"

