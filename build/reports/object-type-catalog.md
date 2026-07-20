# Selector-5 object type catalog

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-OBJECT-CATALOG-001`

This catalog joins all 30 object types (`$00-$1D`) across the constructor, object-update, phase-update, collision, destruction-cleanup, size/default, and destruction-effect tables. Raw overlap bytes are retained, while non-callable or semantically inapplicable entries remain null.

| Type | Role | Integrity initialization | Constructor | Object update | Phase update | Collision | Destruction cleanup |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `$00` | `free_slot` | not applicable | — | — | — | — | — |
| `$01` | `active_list_sentinel` | not applicable | — | `$7B4F` | — | — | — |
| `$02` | `player_helicopter` | 15 | `$6FCF` | `$8F09` | `$855E` | `$AE75` | `$ADD5` |
| `$03` | `player_companion` | not initialized by constructor | `$707B` | `$850C` | `$858E` | — | — |
| `$04` | `helipad` | 0 | `$714B` | `$850C` | `$85E6` | `$B210` | — |
| `$05` | `time_machine_objective` | 128 | `$715D` | `$850C` | `$85F0` | — | — |
| `$06` | `barrage_balloon_bunker` | 47 | `$716F` | `$7B50` | `$8576` | — | `$B06F` |
| `$07` | `barrage_balloon` | 6 | `$7192` | `$7BC3` | `$8576` | — | `$B09D` |
| `$08` | `balloon_mooring_line` | 128 | `$71D0` | `$7C3A` | `$8576` | — | `$B0B5` |
| `$09` | `stationary_gun` | 22 | `$722E` | `$7D5F` | `$8576` | — | — |
| `$0A` | `player_bomb` | 7 | `$724C` | `$850C` | `$8CB8` | `$AF68` | `$B176` |
| `$0B` | `shared_projectile` | contextual projectile damage | `$7286` | `$850C` | `$8D4A` | `$AF68` | — |
| `$0C` | `randomized_fragment` | random 1..4 | `$72E9` | `$850C` | `$8D82` | — | — |
| `$0D` | `ground_infantry_or_engineer` | 5 | `$736E` | `$7DF9` | `$8576` | — | — |
| `$0E` | `tank` | 15 | `$73AC` | `$7F1A` | `$8576` | — | — |
| `$0F` | `anti_air_missile_carrier` | 6 | `$73DC` | `$7F76` | `$8576` | — | — |
| `$10` | `demolition_vehicle` | 9 | `$7402` | `$8027` | `$8576` | — | — |
| `$11` | `destruction_visual_or_stationary_target` | not initialized by constructor | `$74A2` | `$81E8` | `$8576` | — | — |
| `$12` | `smart_missile` | 21 | `$74DE` | `$850C` | `$8670` | `$AEF4` | `$B1F2` |
| `$13` | `projectile_impact_effect` | not initialized by constructor | `$754D` | `$850C` | `$87E3` | — | — |
| `$14` | `converted_collision_effect` | 128 | `$75FB` | `$850C` | `$880F` | `$B048` | — |
| `$15` | `smoke_effect` | not initialized by constructor | `$7591` | `$850C` | `$8863` | — | — |
| `$16` | `optional_bunker` | 128 | `$75C8` | `$850C` | `$8B51` | `$B1B7` | — |
| `$17` | `fixed_armed_bunker` | 128 | `$75C0` | `$850C` | `$8B9C` | `$B1B7` | — |
| `$18` | `collision_active_effect` | 128 | `$761D` | `$850C` | `$8DEC` | `$B048` | — |
| `$19` | `falling_infantry` | 3 | `$7644` | `$8288` | `$8576` | — | — |
| `$1A` | `late_campaign_player_projectile` | 21 | `$7690` | `$850C` | `$8BFD` | `$AEF4` | `$B17B` |
| `$1B` | `linked_falling_effect` | inherited on type conversion | — | `$850C` | `$8D99` | `$AF4B` | — |
| `$1C` | `tank_special_projectile` | 128 | `$75EA` | `$8318` | `$8576` | `$B00E` | — |
| `$1D` | `transitional_effect` | 128 | `$7616` | `$850C` | `$8E04` | — | — |

Fixed values describe the primary constructor path, not necessarily a repair maximum. Contextual, random, inherited, and uninitialized effect fields remain explicitly non-fixed.
