# Provisional memory and module atlas

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`

## boot-page

Verification: `source-exact`

Memory ranges:

- `$0800-$08FF` (confirmed)
- `$BA00-$BAFF` (confirmed) — reloaded as logical sector 0

Entry points:

- `$0801` `boot_entry` (confirmed)
- `$BAB0` `stage1_entry_bab0` (confirmed)

Evidence: `E-BOOT-001`, `E-BOOT-002`, `E-BOOT-003`

## stage1

Verification: `source-exact`

Memory ranges:

- `$BA00-$BFFF` (confirmed)

Entry points:

- `$BAB0` `stage1_handoff_bab0` (confirmed)

Evidence: `E-BOOT-003`, `E-ORDER-001`, `E-STAGE1-SOURCE-001`, `E-STAGE1-SOURCE-002`, `E-STAGE1-SOURCE-003`, `E-STAGE1-SOURCE-004`, `E-STAGE1-SOURCE-005`, `E-SOUND-002`

## battlefield-stage-records

Verification: `opaque-exact`

Memory ranges:

- `$4000-$40FF` (confirmed)

Entry points:


Evidence: `E-BATTLEFIELD-001`, `E-STAGE-PARAM-001`

## stage2-main

Verification: `source-exact`

Memory ranges:

- `$6000-$70FF` (confirmed)

Entry points:

- `$707C` `stage2_entry_707c` (confirmed)

Evidence: `E-LOAD-001`, `E-SOUND-002`, `E-STAGE2-SOURCE-001`

## stage3-4000

Verification: `source-exact`

Memory ranges:

- `$4000-$43FF` (confirmed)

Entry points:

- `$4000` `stage3_entry_4000` (confirmed)

Evidence: `E-LOAD-002`, `E-LOAD-003`, `E-STAGE3-SOURCE-001`, `E-STAGE3-SOURCE-002`, `E-SOUND-002`

## selector0-loadset

Verification: `source-exact`

Memory ranges:

- `$D000-$FFFF` (confirmed)
- `$4400-$45FF` (confirmed)
- `$0400-$04FF` (confirmed)
- `$0800-$1FFF` (confirmed)
- `$7800-$7AFF` (confirmed)
- `$6000-$67FF` (confirmed)

Entry points:

- `$6000` `selector0_entry_6000` (confirmed)

Evidence: `E-LOAD-004`, `E-FLOW-030`, `E-FLOW-SOURCE-003`, `E-FLOW-SOURCE-004`, `E-FLOW-SOURCE-005`, `E-FLOW-SOURCE-006`, `E-FLOW-SOURCE-007`, `E-FLOW-SOURCE-008`, `E-FLOW-SOURCE-009`, `E-FLOW-SOURCE-010`, `E-FLOW-SOURCE-011`, `E-FLOW-SOURCE-012`, `E-FLOW-SOURCE-013`, `E-FLOW-SOURCE-014`, `E-FLOW-SOURCE-015`, `E-FLOW-SOURCE-016`, `E-ASSET-SOURCE-001`, `E-ASSET-SOURCE-003`, `E-SOUND-002`

## main-loop-6900

Verification: `source-exact`

Memory ranges:

- `$6900-$69FF` (confirmed)

Entry points:

- `$6900` `main_jump_table` (observed)
- `$697D` `main_entry_697d` (confirmed)
- `$6991` `main_loop_6991` (confirmed)

Evidence: `E-MAIN-001`, `E-SOUND-002`

## briefing-overlay-selector6

Verification: `source-exact`

Memory ranges:

- `$8000-$87FF` (confirmed)
- `$A100-$A4FF` (confirmed)
- `$7800-$7AFF` (confirmed)
- `$A000-$A0FF` (confirmed)

Entry points:

- `$8000` `briefing_entry_8000` (confirmed)
- `$80C4` `present_emergency_briefing_80c4` (confirmed)
- `$81E0` `present_campaign_city_81e0` (confirmed)

Evidence: `E-LOAD-005`, `E-FLOW-060`, `E-FLOW-070`, `E-FLOW-START-001`, `E-SELECTOR6-SOURCE-001`

## gameplay-overlay-selector5

Verification: `source-exact`

Memory ranges:

- `$6900-$BAFF` (confirmed)

Entry points:

- `$6991` `main_loop_6991` (confirmed)
- `$8F0C` `input_dispatch_jump_8f0c` (confirmed)
- `$9014` `input_dispatch_9014` (confirmed)

Evidence: `E-LOAD-005`, `E-FLOW-040`, `E-FLOW-050`, `E-FLOW-080`, `E-FLOW-START-001`, `E-FLOW-SOURCE-001`, `E-FLOW-SOURCE-002`, `E-CORE-SOURCE-001`, `E-CORE-SOURCE-002`, `E-CORE-SOURCE-003`, `E-CORE-SOURCE-004`, `E-CORE-SOURCE-005`, `E-CORE-SOURCE-006`, `E-CORE-SOURCE-007`, `E-CORE-SOURCE-008`, `E-CORE-SOURCE-009`, `E-CORE-SOURCE-010`, `E-CORE-SOURCE-011`, `E-CORE-SOURCE-012`, `E-CORE-SOURCE-013`, `E-CORE-SOURCE-014`, `E-CORE-SOURCE-015`, `E-CORE-SOURCE-016`, `E-CORE-SOURCE-017`, `E-CORE-SOURCE-018`, `E-CORE-SOURCE-019`, `E-CORE-SOURCE-020`, `E-CORE-SOURCE-021`, `E-CORE-SOURCE-022`, `E-CORE-SOURCE-023`, `E-CORE-SOURCE-024`, `E-CORE-SOURCE-025`, `E-CORE-SOURCE-026`, `E-ASSET-SOURCE-002`, `E-ASSET-SOURCE-003`, `E-SOUND-001`, `E-SCORE-001`, `E-FLIGHT-001`, `E-FLIGHT-002`, `E-FLIGHT-SOURCE-001`, `E-FLIGHT-SOURCE-002`, `E-SERVICE-001`, `E-SERVICE-002`, `E-SERVICE-003`, `E-SERVICE-SOURCE-001`, `E-SERVICE-SOURCE-002`, `E-SERVICE-SOURCE-003`, `E-SERVICE-SOURCE-004`, `E-SERVICE-SOURCE-005`, `E-TIMING-001`, `E-COMBAT-001`, `E-COMBAT-002`, `E-COMBAT-003`, `E-COMBAT-004`, `E-COMBAT-005`, `E-COMBAT-006`, `E-COMBAT-007`, `E-COMBAT-008`, `E-COMBAT-009`, `E-COMBAT-010`, `E-COMBAT-011`, `E-COMBAT-012`, `E-UNIT-PROFILE-001`, `E-MOBILITY-001`, `E-PARACHUTE-001`, `E-STAGE-WEAPON-001`, `E-STAGE-BOMB-001`, `E-STRUCTURE-001`, `E-STRUCTURE-ROLE-001`, `E-OBJECT-CATALOG-001`, `E-STRATEGY-001`, `E-STAGE-PARAM-001`, `E-UNIT-SOURCE-001`, `E-COMBAT-SOURCE-001`, `E-COMBAT-SOURCE-002`, `E-COMBAT-SOURCE-003`, `E-COMBAT-SOURCE-004`, `E-COMBAT-SOURCE-005`, `E-COMBAT-SOURCE-006`, `E-COMBAT-SOURCE-007`, `E-COMBAT-SOURCE-008`, `E-COMBAT-SOURCE-009`, `E-COMBAT-SOURCE-010`, `E-COMBAT-SOURCE-011`, `E-COMBAT-SOURCE-012`, `E-COMBAT-SOURCE-013`, `E-COMBAT-SOURCE-014`, `E-COMBAT-SOURCE-015`, `E-COMBAT-SOURCE-016`, `E-COMBAT-SOURCE-017`, `E-COMBAT-SOURCE-018`, `E-COMBAT-SOURCE-019`
