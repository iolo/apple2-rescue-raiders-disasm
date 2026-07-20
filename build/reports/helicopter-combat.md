# Helicopter combat and damage

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-COMBAT-001`, `E-COMBAT-002`, `E-COMBAT-003`, `E-ECONOMY-001`, `E-STAGE-WEAPON-001`, `E-STAGE-BOMB-001`, `E-STRUCTURE-001`, `E-STRUCTURE-ROLE-001`, `E-OBJECT-CATALOG-001`

- The common routine at `$AC26` subtracts `$60B3` from `$659C,Y`; equality or underflow destroys the target.
- A new battlefield pass initializes both side-indexed cash pools to 15 bags. Balances carry across stage transitions, gain one bag per side every 56 completed object-update handler calls, and saturate at 255. The seconds conversion remains unresolved.
- Replacement helicopters cost 20 bags on the interactive side-1 path. Ground-unit costs in M/T/A/D/E order are 5/4/3/2/5 bags.
- Ground-unit command caps in M/T/A/D/E order are 26/6/7/8/29. Men and engineers share the same type-`$0D` counter; purchases are rejected when that counter is already at or above the selected command threshold.
- M/T/A/D/E map to object types `$0D/$0E/$0F/$10/$0D`, initial integrity `5/15/6/9/5`, and secondary handlers `$7DF9/$7F1A/$7F76/$8027/$7DF9`. The dispatch lookup base is `$8467`; its type-0 word overlaps the preceding instruction.
- `$7DF9` is the grounded-infantry handler. It searches for capturable type `$06/$16/$17` structures exactly five horizontal units behind; type `$09` is not selected by this path.
- A type `$06` structure starts with integrity 47, linked type `$07/$08` components at 6/128, and stored infantry `0` in stage 1 or `1` in stages 2-8. Stored infantry enables repair toward 47; at two or more, an eight-count gate can consume one and attempt to produce a type `$0D` infantry object.
- Infantry can deplete an opposing occupied structure, capture an empty opposing structure, or deposit into an eligible friendly structure. Capture changes ownership and loads raw old-owner strategy delays `255/180/120/84/72/60/48/24` for stages 1-8; these are not normalized seconds.
- The fixed-object consumer chain identifies type `$04` as the helicopter launch/service pad and type `$05` as the time-machine objective. The DTV tests arrival at the opposing `$04` pad coordinate, destroys the linked `$05`, and sets battle completion. This corrects the earlier type-`$17` inference.
- The linked `$06/$07/$08` assembly is a capturable bunker, barrage balloon, and mooring line. Type `$16` is an optional bunker; fixed type `$17` is the occupied machine-gun bunker that emits the four-damage projectile.
- The player machine-gun projectile carries 2 damage units, the bomb 7, and the smart missile 21.
- These values are initialized on the exact player firing paths and transferred through projectile integrity by the collision dispatcher at `$AFDC`.
- Non-player type-`$0B` paths are the stationary gun `$09`, tank `$0E`, grounded men/engineers `$0D`, and fixed armed bunker `$17`. Their observed damage sets are `{5}`, `{1,2,3,4,5,15}`, `{1}`, and `{4}`.
- Shared type-`$0B` lifecycle fields are horizontal velocity `$64CC`, vertical velocity `$6534`, acceleration `$67A4`, and life `$673C`; life starts at `10 + acceleration`.
- Non-player fixed type-`$0B` fire uses horizontal velocity `+/-2` for grounded infantry `$0D` and armed bunker `$17`, `+/-2` or `+/-4` for tank `$0E`, zero vertical velocity/acceleration, and nominal unobstructed horizontal travel 20 or 40 original units. Type `$09` instead computes a predictive aimed velocity divided by eight with acceleration 1.
- The type `$09` gun's helicopter range is strictly below 96 horizontal units and its shared fire range below 256, gated every 2 counter values. The type `$0F` missile carrier checks a below-256 range every 4 values and self-destructs after its one launch.
- The player machine-gun direction table adds signed horizontal velocity `-8` or `+8` (with an unused zero entry) and selects vertical velocity `-2`, `0`, or `+2`; acceleration is zero.
- Battles 1-4 use that 64-internal-unit machine-gun model. In battles 5-8, stage byte `$4069` selects a six-shot type-`$1A` projectile carrying 21 damage; it accelerates horizontally from `-1/+1` toward `-10/+10`, attempts one type-`$13` effect creation per airborne update, and rearms once every 8 eligible counter values.
- The bomb inherits helicopter horizontal velocity, starts with zero vertical velocity, and adds 2 per armed update. The smart missile steers one circular angle step per update and creates type `$13` on impact.
- Bomb ground aftermath changes in battle 4: stages 1-3 use destroyed state `$00` and standard type-`$11` effect code `$49`; stages 4-8 use state `$FF`, suppress that effect, and attempt a type-`$1D` transition that becomes collision-active type `$18` with eligible-infantry damage 4.
- Collision-dispatched types `$14`, `$18`, and `$1C` contain the remaining fixed damage constant: 4 integrity units against ordinary type `$0D`/`$19` targets, subject to their handler-specific exclusions.
- Destruction aftermath creates a short-lived type `$11` visual and table-controlled type `$0C` batches, then runs per-type cleanup. It contains no immediate radial-damage scan or damage write; weapon damage is resolved by collision.
- Smoke size uses integrity tiers 10..15, 5..9, and 1..4. Its counter period is 8 above or equal to 7 integrity and 4 below 7.

Damage values are original integrity units. Smoke and firing cadence remain counter-relative because updates per second are unresolved.
