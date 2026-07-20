# Battlefield definitions

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-BATTLEFIELD-001`, `E-STAGE-WEAPON-001`, `E-STAGE-BOMB-001`, `E-STAGE-PARAM-001`, `E-STRUCTURE-001`, `E-STRUCTURE-ROLE-001`, `E-OBJECT-CATALOG-001`

The stage loader reads track 0, sector `stage + 6` into `$4000-$40FF`. The export retains each complete sector as hex while decoding only consumer-backed fields.

## Layout

- `$4000-$401F` and `$4020-$403F` are parallel 256-position bitfields for type `$06` barrage-balloon bunkers and type `$09` stationary guns.
- `$4040-$405F` supplies the owner bit at each occupied position.
- Grid position `n` maps to original horizontal coordinate `$0200 + 12*n`; the last grid position is `$0DF4`.
- `$4060-$4063` gate one type `$04` and three type `$16` objects at fixed coordinates.
- `$4068` switches bomb ground aftermath from the ordinary type-`$11` effect in battles 1-3 to a type-`$1D`/`$18` transition in battles 4-8. `$4069` selects the ordinary machine-gun model in battles 1-4 and the six-shot type-`$1A` alternate model in battles 5-8.
- `$406D` supplies the initial type-`$06` stored-infantry count: 0 in stage 1 and 1 in stages 2-8. `$4064-$4067/$406A-$406B` are dead copied stores, while `$406C` and `$406E-$40FF` are not copied/read by selector 5; they remain raw non-consumed metadata/padding rather than invented gameplay parameters.

## Campaign formations

Selector-5 tables at `$792D-$79FA` add stage-specific demolition vehicles, tanks, infantry groups, and AA missile carriers. The JSON records both compact source records and every resulting object position.

| Stage | Layout `$06` | Layout `$09` | Optional | Formation records | Formation objects | Bomb aftermath | Player gun model |
| ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |
| 1 | 8 | 4 | 0 | 0 | 0 | standard_type_11 | type_0B_machine_gun_64_internal_shot_units |
| 2 | 8 | 4 | 1 | 0 | 0 | standard_type_11 | type_0B_machine_gun_64_internal_shot_units |
| 3 | 9 | 7 | 2 | 12 | 24 | standard_type_11 | type_0B_machine_gun_64_internal_shot_units |
| 4 | 5 | 8 | 2 | 15 | 27 | type_1D_to_18 | type_0B_machine_gun_64_internal_shot_units |
| 5 | 9 | 4 | 2 | 16 | 31 | type_1D_to_18 | type_1A_alternate_6_shots |
| 6 | 6 | 10 | 2 | 14 | 29 | type_1D_to_18 | type_1A_alternate_6_shots |
| 7 | 9 | 9 | 3 | 17 | 35 | type_1D_to_18 | type_1A_alternate_6_shots |
| 8 | 5 | 15 | 3 | 18 | 36 | type_1D_to_18 | type_1A_alternate_6_shots |

Coordinates are original 12-bit game units, not demake pixels.
