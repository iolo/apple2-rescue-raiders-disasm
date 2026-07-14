# Rescue Raiders Disassembly and Recovery Plan

## Mission

Recover a reproducible, commented Apple II 6502 source tree and binary asset set
from `rescue_raiders.dsk`. Use the recovered program to answer the gameplay
questions in `MECHANICS_MATRIX.md` and produce typed data compatible with
`GAME_DATA_SCHEMA.md`.

The project is complete only when another contributor can start from the
canonical image, regenerate every derived artifact, rebuild a bootable image,
and link each exported gameplay value back to reproducible evidence.

Primary deliverables:

- Buildable ca65 source with stable labels, module boundaries, memory maps, and
  comments describing behavior rather than merely restating instructions.
- Raw and decoded assets with lossless extraction and transformation recipes.
- A loader and address/module map that accounts for relocation, overlays, and
  self-modifying code, with uncertainty stated explicitly.
- A mechanics evidence ledger linking code paths and tables to game behavior.
- Automated extraction, assembly, disk construction, and verification.
- A bootable rebuild, with byte-exact regions distinguished from functionally
  equivalent regions.

## Scope and Non-Goals

In scope:

- The current `rescue_raiders.dsk` as the canonical v1.2 research target.
- Boot, loader, runtime code, data, graphics, sound, battle definitions, and
  gameplay constants needed by the demake.
- Conditional, narrowly targeted emulator runs only when approved static
  escalation criteria are satisfied.
- Incremental source reconstruction using opaque binary regions where necessary.

Not initially required:

- Recovering original symbol names or reproducing the original build system.
- Rewriting every data byte as assembly before a functional rebuild exists.
- Treating the incomplete XNA remake as authoritative evidence.
- Optimizing or modernizing recovered 6502 code.

Explicitly out of scope:

- Recovering, analyzing, or recreating copy protection. The canonical image is
  accepted as an already-cracked research input.

## Canonical Inputs and Baseline

Canonical input:

- `rescue_raiders.dsk`: the image under investigation.

Reference inputs:

- `rescue_raiders.pdf`: official manual.
- `rescue_raiders_docs.txt`: manual transcription and community notes.
- `rescue_raiders.txt`: concise controls and player observations.
- `MECHANICS_MATRIX.md`: confirmed, decided, missing, and conflicting mechanics.
- `GAME_DATA_SCHEMA.md`: target shape for recovered demake data.
- `rescueraiders-remake-source-archive/`, when present: non-authoritative hints.

Current baseline observation:

- The working image is a cracked, normalized 143,360-byte sector image with
  SHA-256
  `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`.
- Its size matches 35 tracks x 16 sectors x 256 bytes. Track/sector ordering and
  filesystem semantics still require verification; size and extension alone do
  not establish either one.
- With `a2kit 4.4.2`, `catalog` finds no recognized filesystem and `geometry`
  does not recognize the raw `.dsk` container. These are tool limitations or
  format clues, not evidence that the image is invalid.
- The first bytes decode plausibly as 6502 code, but that alone does not prove
  image sector order, filesystem type, load address, or entry point.

Current reproducible recovery status (2026-07-14):

- `make -C disasm verify` pins the canonical hash, extracts all 560 raw file
  sectors, and reconstructs the input byte-for-byte.
- Internal operands and a source-exact ca65 rebuild confirm the first raw sector
  at `$0800-$08FF`, with boot entry `$0801`.
- The boot table converts logical sectors to Disk II controller sector IDs. Raw
  track-0 file positions 0..5 are DOS-logical sectors 0..5; a routine spanning
  `$BCFF/$BD00` provides a static ordering discriminator.
- The boot stage reloads those six sectors at `$BA00-$BFFF` and enters the
  relocated sector-0 code at `$BAB0`.
- The relocated loader reconstructs track 19 sectors 0..15 at `$6000-$6FFF`
  and track 20 sector 12 at `$7000`, then enters at `$707C`.
- That entry reaches the loader at `$BFC8`, which loads track 21 sector 0 at
  `$4000`; the `$4000` module then loads sectors 1..3 at `$4100-$43FF`.
- The selector-0 stream at `$423C` now reconstructs six further load runs and a
  terminal `$6000` entry. Embedded tokenized source independently supplies the
  original loader symbols `RWTS0`, `INTER`, `IOB`, `SLT`, `TRK`, `SEC`, `BUFP`,
  and `CMD`; protection-specific logic remains out of scope.
- All seven stage3 selector streams are decoded into exact read manifests. Their
  terminal entries are `$6000`, `$6900`, `$8000`, `$8000`, `$8000`, `$0000`,
  and `$8000`; selector 1 is the next statically requested boot-path stream.
- Static checkpoint coverage now confirms `FLOW-10`, `FLOW-40` through
  `FLOW-80`. The byte-checked start chain follows high-bit `S` through the
  demo/interactive toggle, campaign-index initialization, selector-6 briefing
  and city presentation, and the selector-5 battlefield return. `FLOW-30` is
  now confirmed by selector 0's direct `$6000 -> $0800` graphics/animation
  call, timed event table, direct copyright-text streaming/rendering path, and
  terminal selector-1 request. `FLOW-20` remains an out-of-scope
  cracked-wrapper observation rather than an original-game module claim.
- Selector 0 is now fully `source-exact`: all 8,192 bytes across `$0800-$1FFF`
  and `$6000-$67FF` are authored ca65 code/data. The opening load contains the
  title entry, delay stream, HGR helpers, bitmap
  compositor/eraser, animation initialization, double-buffered sprite support,
  entropy mixer, timed-event scanner, particle/bitmap frame compositor, scene
  producers, event handlers, copyright streamer/glyph renderer, typed HGR and
  text scanline tables, the `$1149-$117E` timed table, particle/animation data,
  the directly rendered high-bit copyright record, and the complete initialized
  scalar/particle/bitmap/text workspace with residual slot bytes preserved,
  page-aligned 64×8 font, 38 relative bitmap descriptors, and bounded residual
  tails. The entry load labels the RWTS trampoline, entropy/path selection,
  three protection-animation paths, eight-point perimeter motion, signed
  two-axis line rasterizer, HGR page management, typed coordinate/mask/seed
  tables, initialized workspace, and an explicitly unclassified residual tail.
  Both load outputs rebuild byte-for-byte with zero opaque selector-0 bytes.
- Selector 5 now contains 20,992 authored ca65 bytes and zero opaque bytes
  across its exact `$5200`-byte rebuild. The authored set includes the complete
  contiguous `$6900-$BAFF` module entries, main flow, disk/RWTS helpers,
  campaign counter logic, core typed data, object-pool/list management, and
  player/layout/projectile/ground-unit constructors, formation decoding, and
  active-list insertion/repair, typed formation/default tables, object update
  dispatch, linked vertical handlers, ground-unit updates/interactions, infantry
  state transitions, targeting, secondary/default tables, disk integrity checks,
  companion rendering, opposing-player acquisition, effect update/emission,
  side-specific active-list target selection, the complete keyboard/button
  dispatcher, player helicopter state/animation/action coordinators, smart-
  missile target search, smoke/input helpers, and their typed command/motion
  tables, plus the strategy coordinator, resource-weighted command selection,
  strategy-motion reset, the complete first 17-entry strategy-handler family,
  tracked/opposing-object motion policies, two strategy-script advancers, the
  shared resource/action decision engine, side-dependent candidate scans, and
  the multi-phase saved/moving-target actions, opponent/resource gates, and
  the primary/secondary strategy script and handler dispatch core, signed
  target steering, adjacent candidate/boundary/resource actions, the complete
  side-dependent type-`$0D` scan, action validator, type-`$08` avoidance, and
  opposing-side distance test, hostile-target scoring, linked-object and
  coordinate-distance helpers, motion-coordinate transforms, nearest friendly
  type-`$0D` selection, signed direction helpers, and the complete strategy
  script/offset, handler-pointer, velocity, eligibility, command, and workspace
  tables;
  the high-bit-`S` transition,
  AC module damage
  entries, and `$ACBC-$ACE3` active-object collision traversal.
- The `$B2F7-$B479` display module is now source-exact, including its public
  jump table, page/frame setup, active-object and compact-status rendering,
  inline high-bit “BAD DRIVE SPEED” and “BATTLE OVER” records, battlefield HUD
  prelude, and direct fall-through into the authored fuel HUD at `$B47A`.
- The final `$B4F9-$BAFF` display tail is source-exact as well: animated fuel
  bars and HGR gauge patterns, return-address inline text, camera tracking,
  visible-object rendering, HGR page copying/filling, high-score and presentation
  phases, battle/score output, self-modifying operands, overlapping callback
  tables, and trailing workspace are all explicit ca65 source/data.
- `make -C disasm rebuild` now reconstructs all 560 stored sectors, reinserts
  the independently assembled boot, stage 1, stage 3, selector-0, and selector-5
  artifacts through explicit disk/page mappings, and emits
  `build/rebuild/rescue-raiders-rebuilt.dsk`. The result is 143,360 bytes and
  byte-identical to the pinned canonical image; its generated manifest records
  every source-exact replacement (`E-REBUILD-001`).
- `make -C disasm assets` now exports the `$1500-$16FF` 64×8 title font and all
  38 pointer-defined `$1700-$1FFF` title bitmap descriptors as hashed raw fixtures
  and decoded PGM previews. Every glyph and descriptor round-trips through the
  documented seven-pixel, LSB-first encoding (`E-ASSET-SOURCE-001`).
- The same target reconstructs selector 5's fixed 24-page battlefield asset
  load and preserves all four disk spans, including the two-page `$E000-$E1FF`
  span overwritten by the final read. Its effective `$1900`, `$D000`, and
  `$E000` banks contain 78, 14, and 73 contiguous sprite descriptors. All 165
  are exported with signed offsets, dimensions, raw hashes, monochrome PGM
  previews, and phase-preserving HGR byte round trips (`E-ASSET-SOURCE-002`).
- Runtime-generated HGR graphics now have lossless recipes rather than being
  treated as missing bitmaps. The asset manifest preserves two indexed orders
  of the common eight-pattern fill vocabulary with 16 round-tripped previews,
  the 726-byte protection raster/seed region and formulas, title particle and
  animation sequencing, and the 32-row three-band fuel-gauge transform
  (`E-ASSET-SOURCE-003`).
- Selector 5's gameplay audio is now classified as synthesized rather than
  stream-backed: deployment uses 16 `$C030` toggles with fixed `$20/$10` loop
  parameters, and critical fuel emits one conditional toggle per eligible HUD
  update. Durations remain unnormalized (`E-SOUND-001`).
- The full boot/stage/decoded-selector corpus now has an exhaustive literal
  `$C030` inventory. Shared presentation code yields bounded 1,456-, 128-, and
  880-toggle effects with hashed raw fixtures; selector 1 exposes an otherwise
  unclaimed callable toggle service; and the stage-1/stage-3 matches are proven
  inert overwrite-workspace bytes rather than audio. Durations remain
  unnormalized (`E-SOUND-002`).
- All eight battlefield sectors are now exported losslessly from track 0,
  sectors 7-14. The decoded package expands the type-`$06` capturable linked
  structure, type-`$09` stationary-gun, ownership, and optional-object
  bitfields plus the
  selector-5 campaign formation stream into exact original-unit coordinates;
  unknown record bytes remain explicit (`E-BATTLEFIELD-001`).
- `build/data/scoring.json` now captures the exact four-digit packed-BCD score
  engine: all three overlapping event-adjustment banks, the one-point penalty
  every 90 completed update wrappers while nonnegative, surviving-object values,
  and stage bonuses 100 through 450 (`E-SCORE-001`).
- `build/data/helicopter-combat.json` now records the common ground-unit
  movement path as one original horizontal coordinate unit per completed update
  wrapper (`E-MOBILITY-001`). It also proves that type-`$19` parachute failure
  occurs for the single zero low-nibble entropy state: nominally 1/16 (6.25%)
  only if those states are uniform; the actual distribution remains unresolved
  (`E-PARACHUTE-001`).
- The adjacent `$ACE4-$AE40` collision scanner is now source-exact: it builds
  table-sized bounds, walks the X-ordered active list, handles the special
  player/type-`$08` vertical cases, preserves collision pairs across the
  `$AE41` dispatcher, and exposes the carry-based mutation contract.
- `$AE41-$AFDB` is now source-exact as well. It implements the two-sided
  per-type pointer lookup and collision-pair swap plus the player-helicopter
  type-`$02`, shared type-`$12/$1A`, and type-`$1B` filters that feed the
  authored damage/destruction entries.
- Destruction cleanup at `$B06F-$B0CC` and collision resolution at
  `$B15F-$B1B6` are now source-exact. Correctly accounting for the first two
  overlapping destruction-table pointers assigns cleanup to stationary-gun
  types `$06/$07/$08`, the guarded type-`$1D` aftermath entry to bomb `$0A`,
  and its interior entry to alternate projectile `$1A`.
- The final `$AC85-$ACBB` and `$B1F2-$B22C` gaps are now promoted, making the
  entire `$AC00-$B2F6` damage, collision, destruction, unlink, handler-table,
  and aftermath block contiguous source-exact ca65. The `$B22B-$B22D`
  instruction/table overlap is preserved explicitly.
- The source-exact M/T/A/D/E purchase path now exports costs 5/4/3/2/5,
  active-counter thresholds 26/6/7/8/29, and deployment sizes 5/1/1/1/2.
  Men and engineers share the type-`$0D` counter but apply different command
  thresholds, resolving the mechanics matrix's exact-cap gap.
- The economy path now exports the original campaign representation: a new
  battlefield pass initializes both `$6116/$6117` side pools to 15 bags,
  stage transitions preserve those balances, and `$6022` adds one bag to each
  side every 56 completed object-update handler calls with saturation at 255.
  The interactive replacement-helicopter path charges 20 bags. The manual's
  15-second income description remains separate from the unresolved static
  updates-per-second conversion (`E-ECONOMY-001`).
- Constructor and correctly based secondary-dispatch analysis now completes
  the deployed-unit profiles:

  | Key | Unit | Type | Initial integrity | Handler |
  | --- | --- | --- | ---: | --- |
  | `M` | men (five) | `$0D` | 5 | `$7DF9` |
  | `T` | tank | `$0E` | 15 | `$7F1A` |
  | `A` | AA missile carrier | `$0F` | 6 | `$7F76` |
  | `D` | demolition vehicle | `$10` | 9 | `$8027` |
  | `E` | engineers (two) | `$0D` | 5 | `$7DF9` |

  The secondary lookup base is `$8467`; the authored pointer span begins at
  `$8469` because the type-0 word overlaps the preceding instruction. This
  resolves an earlier one-entry classification shift. Men and engineers use
  type-`$0D` variant flags 0 and 1 respectively.
- The first gameplay vertical slice now exports original helicopter input and
  motion units: a signed horizontal target table `-7..+7`, acceleration of one
  unit per movement update, vertical target scale `$01BF`, error/8 response,
  and the observed position clamps. Real-time update cadence remains unknown.
- The same slice now exports fuel capacity 128, low/critical thresholds 34/16,
  integrity maximum 15, field-repair conditions, and pad repair/refuel/rearm
  counter gates. The binary's 64 internal gun-shot units conflict with the
  manual's 50-round claim, so that representation remains explicitly open.
- `$60C1:$60C2` is now proved to increment once per completed `$6A51`
  update/render wrapper. No decoded selector load directly addresses `$C019`,
  so the gates are loop-relative; variable work leaves updates per second
  unresolved and scoped for an approval-gated dynamic measurement.
- `build/data/strategy.json` now exports the automated decision engine's seven
  primary actions, fourteen secondary scripts, seventeen first-phase handlers,
  exact resource scores, E/D/A/T/M unit-command roles, target ranks, steering
  tables, and overlap behavior. Nine auxiliary progression rows and 37 flags
  remain raw rather than receiving invented tactical names (`E-STRATEGY-001`).
- The eight battlefield records now have a closed selector-5 parameter boundary:
  live optional-object, bomb, weapon, and stored-infantry fields are separated
  from copied dead stores and the uncopied `$406C/$406E-$40FF` tail
  (`E-STAGE-PARAM-001`).
- Player weapon damage is now exported in original integrity units: machine
  gun 2, bomb 7, and smart missile 21. The common `$AC26` consumer subtracts
  damage and destroys on equality or underflow; smoke feedback tiers are also
  statically recovered.
- Stage byte `$4069`, copied to `$60EE`, proves the manual's weapon-evolution
  rule: battles 1-4 use the 64-internal-unit machine-gun model, while battles
  5-8 replace it with a six-shot type-`$1A` projectile carrying 21 damage. Its
  signed acceleration, type-`$13` emission, vertical counter gate, and pad
  rearm period are exported without inventing a seconds conversion
  (`E-STAGE-WEAPON-001`).
- Stage byte `$4068`, copied to `$60ED`, changes bomb ground aftermath one
  battle earlier. Battles 1-3 retain standard type-`$11` effect code `$49`;
  battles 4-8 suppress it and attempt a signed-half-speed type-`$1D` object
  that converts to collision-active type `$18`, whose eligible-infantry damage
  is 4 (`E-STAGE-BOMB-001`).
- The `$7DF9` handler is grounded infantry type `$0D`, correcting its earlier
  stationary-gun classification. It searches capturable structure types
  `$06/$16/$17` exactly five horizontal units behind; infantry can deplete,
  capture, or deposit through the byte-exact `$80D6` resolver. Type `$06`
  begins at integrity 47 with linked `$07/$08` integrity 6/128, stores 0
  infantry in battle 1 and 1 in battles 2-8, repairs while occupied, and can
  consume stored capacity to attempt a type `$0D` spawn (`E-STRUCTURE-001`).
- A complete 30-type `$00-$1D` catalog now joins every constructor, object and
  phase update, collision, destruction-cleanup, size/default, integrity, and
  aftermath entry. This full-domain check corrects another earlier indexing
  error: type `$08` runs balloon-mooring-line update `$7C3A`, independent type
  `$09` is the 22-integrity stationary AA/AT gun at `$7D5F`, and falling
  infantry `$19` owns landing handler `$8288`. The type `$06/$07/$08` group is
  therefore the capturable bunker/balloon/line assembly, not the stationary gun
  (`E-OBJECT-CATALOG-001`).
- Fixed-structure roles are now consumer-proven rather than inferred from
  uniqueness: type `$04` is the helicopter launch/service pad and type `$05`
  is the time-machine objective destroyed by the DTV victory path. Type `$06`
  is the capturable bunker, linked `$07/$08` are its barrage balloon and
  mooring line, `$16` is an optional bunker variant, and fixed `$17` is the
  occupied armed bunker. This corrects the earlier type-`$17` time-machine
  classification (`E-STRUCTURE-ROLE-001`).
- Bunker durability is exported by exact behavior rather than forced manual
  category names: type `$06` begins at 47 integrity and accepts common weapon
  damage, while types `$16/$17` begin at `$80`, whose sign bit makes the common
  damage consumer return. Both `$16/$17` retain a separate hostile type-`$1C`
  destruction path.
- Player weapon motion is now source-exact: the machine gun's nine-way tables
  add signed horizontal velocity `-8/+8` and select vertical `-2/0/+2`, the
  bomb inherits horizontal motion and adds 2 vertical units per armed update,
  and the smart missile steers one circular angle step before spawning type
  `$13` on impact. These remain update-relative until cadence is measured.
- The complete collision pointer table identifies the remaining fixed damage
  constant: types `$14`, `$18`, and `$1C` have special handlers that apply 4
  integrity units to ordinary type-`$0D/$19` targets, with explicit helicopter,
  bunker-link, ownership, and direct projectile-destruction exclusions.
- Destruction aftermath is now separated from damage: a 29-entry table selects
  a short-lived type-`$11` visual, another controls one or two type-`$0C`
  batches, and an overlapping handler table performs cleanup. The bounded path
  has no immediate radial target scan or damage write; original weapon damage
  is direct-collision based rather than an invented numeric explosion radius.
- Non-player projectile ballistics are now exported in original units.
  Grounded infantry `$0D` and armed bunker `$17` fire horizontally at `±2`, while tank
  `$0E` uses `±2` or `±4`, producing
  nominal unobstructed travel 20/40 over their ten-update life. The independent
  type-`$09` gun computes predictive target deltas divided by eight and uses
  acceleration 1 with an eleven-update life.
- Target acquisition now has original numeric thresholds: the stationary gun
  acquires helicopters below 96 horizontal units and shares a below-256 fire
  check for its alternate target mode, eligible every two counter values. The
  one-shot type-`$0F` missile carrier locks below 256 every four values and self-destructs
  after launch. These periods remain update-relative, not seconds.
- The boot page and stage 1 are now `source-exact`. Stage 1's
  complete `$BB00-$BD94` Disk II codec, address reader, seek path, and RWTS
  dispatcher; `$BD95-$BFC7` work buffers, translation/seek tables, and delay
  utility; plus `$BFC8-$BFED` `INTER`/`IOB` interface are labeled ca65. Its
  `$BA00` boot-page copy shares the independently verified boot source emitter,
  and the unreferenced `$BFEE-$BFFF` residual is bounded data. The complete
  `$BA00-$BFFF` output compares byte-for-byte with no `INCBIN`. Stage 3 is also
  `source-exact`: `$4000-$43FF` labels selector setup, the self-modifying
  dispatcher and relocation paths, five opcode handlers, seven pointer-defined
  streams, hardware/signature tables, and bounded residual workspace data. Its
  complete output also compares byte-for-byte with no `INCBIN`.
- Selector 5 is now fully `source-exact`: the `$914C-$91C1` analog paddle
  sampler/target scaler, `$94CA-$94D5` signed-step limiter, `$97AC-$9866`
  player-helicopter motion path, and `$998E-$99A7` signed target table are
  labeled ca65 inside a byte-exact `$6900-$BAFF` rebuild. The source preserves
  the overlapping `$97E4/$97E5` branch-operand entry and the existing mechanics
  exports remain tied to these original-unit routines/data. All 20,992 bytes
  are authored ca65 code/data and the source contains no `INCBIN`.
- The adjacent `$96D0-$97AB` pad-service path is also labeled ca65. Its exact
  source exposes integrity/fuel/ammunition/bomb/missile capacity checks and
  modulo `$60C1` gates while retaining the unresolved `$60EE` mode distinction.
- `$925D-$9292` now labels grounded field repair and its bridge into smoke/pad
  service, including the preserved-carry increment used after the four-passenger
  and modulo-eight gates.
- `$6FC4-$70B3` now labels both player-helicopter initializers and linked-object
  creation, exposing starting integrity 15, fuel 128, bombs 10, missiles 2, and
  the `$60EE`-selected ammunition capacity in source-exact ca65.
- `$934C-$93B9` now labels in-flight/grounded fuel gates, service suppression,
  zero-fuel descent, and terminal object handling. `$B47A-$B4F8` labels zero,
  low (below 34), and critical (below 16) HUD/audio feedback, including the
  Apple II speaker soft switch at `$C030`.
- `$9867-$98B9` now labels smoke cadence, coordinate offsets, and integrity
  tiers. `$AC26-$AC5A` labels the common integrity subtraction/destruction
  consumer and its entry-state convention (Y already selects the object).
  No apple2ts run was needed for these findings.

`original/checksums.txt` must pin the accepted input before analysis.
Changing the canonical hash starts a new image lineage; evidence from different
lineages must never be silently combined.

## User-Observed Program Flow

The following is the initial screen sequence reported by the user. It defines
analysis checkpoints, not yet-confirmed code or load boundaries.

| ID | Screen/state | Observed content and transition |
| --- | --- | --- |
| `FLOW-00` | Reboot | Cold reboot begins the sequence |
| `FLOW-10` | Early text pages | Mostly inverted `@` characters representing zero, with some readable text at bottom-left |
| `FLOW-20` | Cracked-image prompt | Press any keyboard key to continue |
| `FLOW-30` | Opening | Copyright and animated title image |
| `FLOW-40` | Demo battlefield | Automatic battlefield play with high-score, logo, banner, money, missile, and helicopter text/icons |
| `FLOW-50` | Start transition | Press keyboard `S` during the demo to start a game |
| `FLOW-60` | Briefing room | `Emergency transmission...` text |
| `FLOW-70` | Map | Map screen before combat |
| `FLOW-80` | Battlefield | Interactive battle; joystick input requires user assistance |

Use these checkpoints first as static-analysis anchors for strings, graphics,
dispatch code, and state tables. Do not assume every visual transition is a new
overlay. If targeted dynamic validation becomes unavoidable, the autonomous demo
is the preferred first battlefield observation because it exercises gameplay
without synthetic joystick input. Keyboard automation may be used only for the
real `FLOW-20` and `FLOW-50` actions, with the transition verified.

## Operating Principles

1. Preserve before interpreting. All analysis begins with an immutable input
   hash and a lossless extraction path.
2. Separate observation from inference. A plausible disassembly is not proof
   that bytes are code or that they execute at the selected origin.
3. Exhaust static evidence first. Establish origins and module boundaries from
   boot conventions, loader operands, pointer relationships, cross-references,
   sector adjacency, and byte-exact reconstruction, while preserving confidence
   levels where proof is incomplete.
4. Use apple2ts only when a material ambiguity blocks further static progress.
   Each emulator run must answer one explicit question that cannot be answered
   by disk bytes, disassembly, rebuilds, documentation, or user observation.
5. Make transformations reversible. Every decoder must retain its raw input and
   support a byte-for-byte encode/decode round trip where the format permits.
6. Rebuild continuously. Source coverage grows by replacing opaque bytes in a
   working image, not by waiting for a complete disassembly.
7. Recover semantics in vertical slices. Follow one behavior from input through
   state update, rendering, and data tables instead of annotating disk order.
8. Preserve uncertainty. Unknown fields, competing hypotheses, and failed
   experiments are first-class artifacts.

## Evidence Model

Evidence has two independent dimensions.

Provenance:

- `disk`: bytes or geometry observed directly in the canonical image.
- `static`: control flow, operands, strings, or tables derived without running.
- `runtime`: debugger trace, memory snapshot, watchpoint, or controlled behavior.
- `manual`: official documentation or player-facing instructions.
- `user`: direct observations and actions reported by the user during this
  recovery project.
- `reference`: community notes or remake-source hints.
- `rebuild`: assembler, linker, encoder, disk, or emulator verification.

Confidence:

- `observed`: directly captured, with command/run ID and artifact hash.
- `confirmed`: reproduced independently or supported by converging evidence.
- `inferred`: best current explanation with stated assumptions.
- `speculative`: useful lead that has not survived a discriminating test.
- `rejected`: retained with the evidence that falsified it.

Every nontrivial claim must record an ID, image hash, provenance, confidence,
source location or run ID, interpretation, and next test. Promotion to
`confirmed` requires either two independent observations or one deterministic
observation plus a successful rebuild/behavior check. Reference-only claims may
guide experiments but may not populate final gameplay data.

Keep the ledger machine-readable in `evidence/evidence.jsonl`; generate a
human-readable report from it. Stable claim IDs should be cited in assembly
comments and recovered-data files.

## Hypothesis Discipline

Track competing explanations in `evidence/hypotheses.jsonl`. Each record
must contain:

- The claim and its assumptions.
- Expected observations if true.
- Observations that would reject it.
- The cheapest discriminating experiment.
- Dependencies on other hypotheses.
- Current status and replacement hypothesis, if rejected.

High-priority initial hypotheses include logical sector ordering, boot origin
and entry point, loader parameter semantics, decoded versus raw load pages,
relocation, and overlay lifetime. Rank static discriminants before proposing a
dynamic experiment.
Never encode a hypothesis into filenames or authoritative symbols as if it were
already established.

## Toolchain

Required:

- `a2kit`: disk inspection, filesystem probes, and reproducible conversion where
  supported. It is not the authority for raw-sector mapping when it rejects the
  container.
- `da65`, `ca65`, and `ld65`: information-file-driven disassembly, assembly,
  linking, and byte comparison.
- `make`: stable extraction, reporting, rebuilding, and verification entry
  points.
- `python3`: deterministic raw-sector mapping, report generation, and format
  tooling not covered by standard utilities.
- Small deterministic tools under `tools/` for formats or trace
  operations the standard tools cannot express, including a tested raw-sector
  mapper for this image.

Conditional dynamic validation:

- `apple2ts`: use only for an unavoidable, predeclared question after the
  qualification in `APPLE2TS_REMOTE_CONTROL.md` passes. It has no joystick API;
  joystick-dependent experiments use the manual user-assisted protocol.

Supporting inspection:

- `xxd`, `cmp`, and `sha256sum` for focused inspection and exact comparison.
- Repeated user observations for behavior that cannot be automated reliably.

Tool versions and invocation parameters belong in generated manifests. Emulator
automation is considered fragile until a run proves machine model, ROM identity,
slot/drive configuration, reset mode, mounted-image hash, and repeatability.

## Repository and Artifact Design

```text
README.md
Makefile
original/                 # immutable inputs and checksums
config/                   # tool versions, da65 info, linker configs
disk/                     # authored geometry and loader notes
evidence/                 # claims, hypotheses, experiments, run manifests
src/
  boot/
  loader/
  runtime/
  data/
  hardware.inc
  memory.inc
  symbols.inc
assets/
  raw/
  decoded/
  manifests/
data/
  raw/
  decoded/
  mechanics/
  exports/
traces/
  boot/
  gameplay/
tools/
tests/
build/                    # generated, disposable artifacts and reports
```

Hand-authored source, configuration, notes, manifests, and evidence are retained
as project inputs.
Extracted sectors, object files, dumps, reports, and rebuilt images are generated
under `build/` unless they are small canonical fixtures. A fresh workspace
containing only canonical inputs and hand-authored files must regenerate them
without relying on prior analyst state.

Each recovered module needs a small manifest containing its source disk ranges,
transform chain, candidate address ranges with confidence, overlay hypotheses,
entry points, callers, outgoing references, unresolved regions, and verification
status. Address-based module identity is preferred over disk adjacency once the
static address map is coherent enough to support it.

## Build Interface

The Makefile should expose narrow, composable targets:

```text
make -C disasm doctor       # verify tools and record versions
make -C disasm emulator-doctor   # read-only API consistency preflight
make -C disasm emulator-practice # disposable breakpoint/input qualification
make -C disasm fingerprint  # hash and characterize canonical inputs
make -C disasm extract      # lossless image/logical extraction
make -C disasm analyze      # regenerate manifests and static reports
make -C disasm disassemble  # regenerate da65/ca65 sources
make -C disasm assets       # decode and round-trip assets/data
make -C disasm rebuild      # assemble and construct candidate image
make -C disasm verify       # deterministic, emulator-free checks
make -C disasm smoke        # conditional user-approved emulator checkpoints
make -C disasm report       # coverage, evidence, and mechanics summaries
```

`verify` must fail on stale generated files, input hash drift, extraction
non-round-trips, assembly mismatches, overlapping memory regions, unresolved
symbol conflicts, or decoder round-trip failures. Emulator regressions belong
to `smoke` so deterministic verification remains runnable without a live
emulator.

## Execution Plan

### Conditional Gate: Qualify apple2ts Before Dynamic Use

This gate does not block static work. Before the first unavoidable dynamic
experiment, execute `APPLE2TS_REMOTE_CONTROL.md` in a dedicated scratch emulator
session. Exercise save-state rollback, breakpoint create/hit/delete, single-key
and text input, bounded polling, and cross-endpoint state validation. Do not use
Rescue Raiders as the practice fixture.

Exit gate:

- Three consecutive fresh-session practice runs pass with complete logs.
- Breakpoint hits are verified by paused PC/register state, not API acceptance.
- Key input is verified through keyboard-latch or fixture-memory transitions.
- Save-state import restores the original machine, drive, CPU, memory, and
  breakpoint invariants.

If this gate fails, continue static work and record the unresolved question.
Resolve the API problem with the user before any trace-dependent conclusion. Do
not invent an automated fallback.

### Phase 0: Establish a Reproducible Baseline

Tasks:

- Freeze the canonical image hash, size, and acquisition notes.
- Record versions of `a2kit`, cc65 tools, `python3`, and Make; record the emulator
  version only if conditional dynamic work is approved.
- Create a one-command clean build and a run-manifest schema.
- Define generated versus hand-authored files and ensure clean regeneration.
- Define stable checkpoint IDs and observable conditions for boot, title, battle
  start, active play, death/restart, and battle completion, beginning with
  `FLOW-00` through `FLOW-80` above.

Exit gate:

- `make doctor` and `make fingerprint` are deterministic on two fresh-workspace
  runs; the full `verify` target is not a Phase 0 gate.
- A generated manifest maps every artifact to the canonical image hash,
  producing command, and tool version.

### Phase 1: Resolve Disk Ordering and Geometry

Tasks:

- Confirm the 35-track, 16-sector, 256-byte geometry without modifying the
  original.
- Compare linear file order, DOS 3.3 sector skew, and ProDOS block interleave
  interpretations using structural evidence. Carry unresolved alternatives as
  hypotheses rather than forcing an early conclusion.
- Produce image-coordinate and loader-logical maps with offsets, hashes,
  duplicate groups, entropy, high-bit text, probable code, and blank regions.
- Model candidate logical orderings used by the loader and provide lossless
  sector extraction/reassembly paths for retained candidates.
- Attempt filesystem catalogs only as probes; lack of a catalog is not an error
  for a custom loader.

Exit gate:

- Extraction plus reassembly round-trips byte-for-byte for each retained
  candidate mapping. Any ambiguity is recorded as a Phase 2 hypothesis with
  static discriminants and, only if necessary, a later dynamic question.
- Image track/sector coordinates, loader-logical coordinates, and file offsets
  have explicit conversion functions and tests. Do not claim nibble-level
  physical geometry that a sector image cannot preserve.

### Phase 2: Recover the Boot and Loader Statically

Tasks:

- Disassemble the boot sector using Apple II boot conventions while keeping the
  origin provisional until internal operands and reconstruction support it.
- Recover loader control flow, disk parameter blocks, requested track/sector
  sequence, destination addresses, retries, and handoff targets symbolically.
- Correlate referenced sectors with strings, pointer tables, absolute operands,
  and expected destination-page relationships.
- Reimplement any decoding, relocation, decompression, or patching transform as
  an offline function with exact input/output fixtures.
- Map Disk II soft switches, vectors, zero page, language-card switches, and
  loader workspaces from static reads and writes.
- Model the successful boot-to-title loader path as a state machine and call
  graph. Analyze retry or failure paths only when they affect normal loading.
- List unresolved facts separately; do not trace merely to increase confidence.

Exit gate:

- A deterministic static load model maps disk bytes through transformations to
  candidate memory ranges and handoff entry points through the title path.
- Boot and loader source reproduce their source-backed bytes exactly. Offline
  transforms pass reversible or independently derived invariants; generated
  transformed bytes remain `inferred` unless independent evidence confirms them.
  Direct-copy destinations inherit their source-byte evidence but not an
  unproven address. Remaining origin or ordering ambiguities have explicit
  confidence and impact.

### Phase 3: Build the Static Memory and Module Atlas

Tasks:

- Classify disk ranges as code, immutable data, mutable-state templates, screen
  data, loader workspace, overlay candidates, assets, padding, or unknown.
- Build address hypotheses from absolute operands, zero-page use, pointer tables,
  branch integrity, strings, source fragments, and loader destinations.
- Recover JSR/JMP edges, interrupt vectors, jump tables, indirect-target
  candidates, and possible self-modifying writes statically.
- Associate `FLOW-10` through `FLOW-80` with strings, graphics, dispatch paths,
  and state tables without assuming observed runtime residency.
- Record overlapping address ranges as overlay hypotheses with confidence and
  evidence, not as confirmed lifetimes.
- Assign stable provisional symbols with confidence tags; confirmed runtime
  observation is not required to begin useful annotation.

Exit gate:

- Every nonblank disk region has a provisional role and prioritized work item.
- Candidate origins, module boundaries, overlays, and indirect targets are
  represented without converting uncertainty into fact.

### Phase 4: Produce Structured, Source-Exact Disassembly

Tasks:

- Seed `da65` information files from the static atlas, using provisional origins
  explicitly where origins are not yet confirmed.
- Use recursive control-flow traversal first; use linear sweep only for triage.
- Mark code/data boundaries, jump tables, pointer tables, strings, shapes,
  packed fields, and alignment explicitly.
- Model NMOS 6502 behavior and flag intentional undocumented opcodes if any.
- Name routines by demonstrated responsibility. Keep neutral names such as
  `sub_6A31` until behavior is known.
- Convert one module at a time to ca65, retaining `.incbin` for unknown
  spans so the linked range remains byte-identical.
- Add assertions for origins, sizes, page boundaries, table counts, and branch
  reach.

Exit gate:

- Recovered modules assemble to their source disk bytes or exact offline
  transformed bytes at stated origins.
- Every code label is statically reachable from an entry-point hypothesis or
  marked as an unresolved candidate.

### Phase 5: Recover Gameplay in Vertical Slices

Prioritize work by demake value rather than disk order:

1. Helicopter input, acceleration, velocity clamps, fuel, damage, and pad
   service.
2. Weapon creation, targeting, cadence, velocity, collision, damage, and ammo.
3. Ground-unit object layout, movement, targeting, health, and active limits.
4. Economy timers, prices, deployment, bunker ownership, and repair logic.
5. Battlefield definitions, structures, battle progression, and enemy strategy.
6. Scoring, death/replacement flow, victory/loss, and campaign transitions.

For each slice:

- Begin from known strings, input dispatch, object tables, or routines associated
  with a user-observed action or state transition.
- Follow callers, callees, state mutations, rendering/audio consumers, and data
  tables statically.
- Use cross-references, table shape, neighboring constants, manual behavior, and
  source-exact rebuilds to test the interpretation.
- Propose a targeted apple2ts observation only when competing interpretations
  have different demake consequences and static evidence cannot distinguish
  them.
- Record representation details: signedness, fixed-point scale, coordinate
  system, update cadence, overflow behavior, random-number use, and units.
- Distinguish stored constants from derived values and conversion formulas.
- Export confirmed values with evidence IDs; leave unresolved schema fields
  explicitly unknown rather than substituting guesses.

Exit gate:

- Each exported value has a disk location, candidate memory address when known,
  representation, static consumer, triggering conditions, confidence, and
  evidence IDs. Runtime observation is required only when static evidence cannot
  resolve a material ambiguity.

### Phase 6: Recover Assets and Encodings

Tasks:

- Locate shape tables, fonts, screen data, palettes, sound streams, maps, and
  text using static consumers, pointer tables, and user-observed screens as
  anchors.
- Preserve raw bytes and write deterministic decoders plus encoders.
- Document bit order, row stride, dimensions, masks, transparency, animation
  sequencing, pointer formats, and any runtime transformation.
- Generate contact sheets, wave previews, or map renders only as derived reports.
- Verify decoded asset dimensions and placement against emulator screenshots.

Exit gate:

- `encode(decode(raw))` reproduces raw bytes where encoding is understood.
- Each decoded asset is referenced by a static consumer or remains clearly
  labeled as a candidate.

### Phase 7: Incremental Rebuild

Use three distinct verification levels:

- `opaque-exact`: untouched bytes are included verbatim at known locations.
- `source-exact`: authored source or encoder reproduces original bytes exactly.
- `functional`: output differs intentionally but passes documented behavior
  checkpoints.

Tasks:

- Start with a lossless image reconstruction.
- Replace opaque runtime ranges with source-exact modules incrementally.
- Recreate any loader transforms and the established sector layout.
- Maintain byte-coverage reports by image region and runtime module; do not count
  `.incbin` bytes as disassembled source.
- When exact bytes are impractical because of layout constraints, isolate the
  difference and document why functional equivalence is the chosen gate.

Exit gate:

- A byte-exact candidate needs no emulator claim beyond exact reconstruction.
- If the candidate differs, all differences are classified, bounded, and
  intentional; user-approved smoke validation then becomes an unavoidable gate
  for calling the rebuild functional.

### Phase 8: Demake Integration

Tasks:

- Generate versioned TypeScript/JSON data matching `GAME_DATA_SCHEMA.md`.
- Include source image hash, evidence IDs, original representation, normalized
  units, and conversion notes alongside values.
- Update `MECHANICS_MATRIX.md` statuses only after the evidence promotion rules
  are satisfied.
- Add fixture tests that compare exported values with decoded source tables.
- Keep original quirks separate from deliberate demake design decisions.

Exit gate:

- No reverse-engineered number is duplicated as an unexplained literal in game
  logic, and every promoted mechanics entry links back to reproducible evidence.

## Dynamic Escalation Criteria

Apple2ts is a last-resort discriminator, not a routine source of coverage. Before
contacting it, add an evidence record containing:

- The exact unresolved question and why it matters to recovery or demake data.
- The competing interpretations and their existing static evidence.
- The static methods already attempted.
- The single observable result that would distinguish the interpretations.
- Why user observation or a source-exact rebuild cannot answer it more safely.

Do not use apple2ts to confirm facts already supported well enough for the next
static work item. A dynamic run is justified only when the answer changes module
boundaries, load transforms, control-flow interpretation, or a material gameplay
value and static progress is otherwise blocked.

## Conditional Dynamic Experiment Protocol

When escalation is approved, every trace run must have a manifest containing:

- Run ID, date, purpose, hypothesis IDs, and expected outcome.
- Canonical image hash and exact mounted byte range/format.
- Emulator build, machine/ROM, CPU mode, slot, drive, reset mode, and speed.
- Initial save state or proof of cold reset.
- Breakpoints, watchpoints, scripted input, stop conditions, and timeout.
- Register snapshots, memory dumps, screenshots, trace hashes, and conclusion.

Every run must begin with the read-only consistency preflight from
`APPLE2TS_REMOTE_CONTROL.md`. Mutating calls are serialized, breakpoint hits are
proved by CPU state, and gameplay keypresses are proved by a state transition.
Contradictory machine/drive responses abort the run; CPU and memory evidence is
read only after a confirmed pause. Record the original mounted DSK hash
separately from apple2ts's internal media name; its on-the-fly conversion may be
reported as `.woz`.

At the first surprising or unreasonable apple2ts response, stop, preserve the
last request and response, and ask the user before retrying or attempting another
endpoint. Fragility is expected; speculative diagnosis during a live session is
not allowed.

Joystick actions are explicit user-assisted trace steps. Arm and verify the
trace precondition, ask the user for one bounded joystick action, wait for
completion, then capture the result. Never emulate joystick input with PEEK/POKE,
debugger memory writes, soft-switch writes, or direct game-state mutation.

Runs used for confirmation must be repeatable from a cold start. A save state is
valid only when its emulator version, ROM, mounted image, and creation procedure
are pinned. If debugger timing changes disk behavior, stop and ask the user.

## Verification Matrix

| Layer | Required check |
| --- | --- |
| Input | Size and cryptographic hash match the pinned lineage |
| Extraction | Sector extraction and reassembly reproduce the image exactly |
| Geometry | Offset/track/sector conversions pass boundary and round-trip tests |
| Loader | Static read sequence is source-backed; offline transforms pass reversible or independently derived invariants |
| Disassembly | Source ranges assemble to expected bytes at stated origins with confidence recorded |
| Data/assets | Decoder/encoder round-trip and structural invariants pass |
| Disk build | Every changed byte is attributed to a module or declared patch |
| Boot | Source-exact boot/loader ranges and handoff invariants pass; smoke observation is conditional |
| Behavior | Static consumer relationships agree with documented behavior; targeted observation is conditional |
| Export | Generated schema values cite evidence and match decoded tables |

Use both exact and semantic comparisons. Exact comparison is required for raw
round trips, source-exact regions, and offline transforms. If dynamic escalation
occurs, checkpoints compare PC, selected memory invariants, screen hashes with
tolerances where necessary, and observable state rather than screenshots alone.

## Coverage and Progress Metrics

Report these separately so one easy metric cannot hide uncertainty:

- Disk bytes losslessly mapped.
- Disk bytes assigned to a candidate load event and address, with confidence.
- Static control-flow edges and unresolved indirect targets assigned to modules.
- Module bytes source-exact, opaque-exact, functional, or unresolved.
- Indirect branches with confirmed targets.
- Assets decoded and round-trip verified.
- `[MISSING]` mechanics with confirmed exports.
- User-observed flow checkpoints associated with static modules/data.
- Conditional dynamic questions proposed, approved, answered, or still blocked.
- Open, confirmed, and rejected hypotheses.

Coverage must exclude padding and `.incbin` from the source-recovered percentage.
Report duplicate stored bytes in both raw-byte coverage and deduplicated
unique-content coverage; do not omit duplicates in a way that inflates progress.

## Risk Register

| Risk | Mitigation |
| --- | --- |
| Wrong sector-order interpretation | Require lossless candidates and correlate static loader coordinates and referenced bytes |
| Static code/data misclassification | Combine recursive flow, pointer/xref evidence, table shape, and byte-exact rebuilds; retain uncertainty |
| Relocation, overlays, or self-modifying code | Model loader transforms and write targets statically; escalate only a blocking ambiguity |
| Debugger changes timing-sensitive behavior | Stop, preserve the observation, and ask the user before changing technique |
| Emulator/save-state nondeterminism | Pin all identities and reject unrepeatable captures as confirmation |
| `apple2ts` accepts commands without coherent state changes | Require the practice gate, cross-endpoint checks, and postcondition polling |
| Unexpected apple2ts behavior during a live run | Stop immediately, preserve the anomaly, and ask the user before any retry or diagnosis |
| No `apple2ts` joystick API | Use bounded user-assisted actions and record timing/analog uncertainty; never substitute memory writes |
| False semantics from source fragments or XNA code | Treat them as search hints until disk, cross-reference, and rebuild evidence converges |
| Byte-exact rebuild stalls progress | Keep opaque-exact regions and advance a functional vertical slice |
| Large volumes of generated reports obscure decisions | Store claims centrally and generate concise dashboards/worklists |
| Recovered constants lack units or context | Require representation, cadence, formula, and perturbation evidence |

## Milestones

- **M0: Baseline locked.** Input lineage, static tools, artifact rules, and clean
  regeneration are reproducible.
- **M1: Disk model proven.** Sector ordering and image/logical mapping round-trip
  without loss.
- **M2: Loader modeled.** Static boot reads, transforms, destination hypotheses,
  and handoff paths are byte-reproducible with uncertainty recorded.
- **M3: Static atlas usable.** Disk regions, candidate memory ranges, overlays,
  cross-references, and unresolved indirect targets are mapped.
- **M4: First source-exact slice.** One behaviorally meaningful module rebuilds
  exactly and integrates into the reconstructed image.
- **M5: Demake-critical data recovered.** Flight and weapon values are exported
  with confirmed evidence.
- **M6: Functional game rebuild.** Cold boot, title, battle start, active play,
  death/restart, and battle completion checkpoints pass.
- **M7: Recovery release.** The zero-opaque runtime-source status and remaining
  uncertainties are documented, reports regenerate cleanly, and contributor
  documentation is complete.

### Current Completion Audit

| Gate | Status | Authoritative evidence / remaining requirement |
| --- | --- | --- |
| M0 baseline | Complete | `make -C disasm verify`; pinned hash, toolchain report, deterministic generated artifacts |
| M1 disk model | Complete | 560-sector manifest and three exact mapping round trips |
| M2 loader model | Complete | Source-exact boot/stages 1/3, selector manifests, and verified load/page mappings |
| M3 static atlas | Complete for all decoded selector loads | `modules.json`, flow map, memory-map reports, and evidence-linked entry points |
| M4 source-exact slice | Complete | Complete selector-0/5/6 loads and stage 2 exceed the original one-slice gate |
| M5 flight/weapon exports | Complete in original representation units | Generated flight, service, combat, timing, and scoring JSON; real-time cadence intentionally remains `null` |
| Byte-exact disk rebuild | Complete | `make -C disasm rebuild`; `E-REBUILD-001`; rebuilt candidate equals the canonical image |
| Release regeneration | Complete | `make -C disasm fresh-verify` passes from an absent `build/`; two fresh runs produced identical release-manifest hash `acef92817b6c5b24ed941fc05d01342ce1fe36be6017b59583f130adc9999ed5` and canonical rebuilt-disk hash |
| Artifact lineage/coverage | Complete | Generated `release-manifest.json` hashes every non-manifest artifact with producer/toolchain/lineage; `coverage.json` reports raw and deduplicated disk/source metrics separately |
| Module manifest schema | Complete for current atlas entries | Every module records disk/memory ranges, transform chain, overlays, entry points, callers, outgoing references, unresolved regions, verification level, and evidence |
| Phase 6 static asset package | Complete | Title font, 38 title bitmaps, 165 gameplay sprites, procedural HGR palettes/raster/title/gauge recipes, all synthesized audio accesses, and all eight battlefield layouts are manifested and round-trip checked |
| Phase 6 screenshot placement | Approval-gated, not executed | Requires the apple2ts qualification gate and user authorization; static asset completion is not a screenshot-placement observation |
| Phase 8 demake integration | Partial | Versioned `demake-export.json` covers exact scoring/economy, the complete 30-type catalog, battlefield layouts/formations, structure roles and durability behavior, stage transitions, movement/parachute behavior, combat profiles, and strategy scripts. Real-time cadence, entropy distribution, machine-gun representation, complete joined combat profiles, and auxiliary tactical-field semantics remain explicit gaps |
| M6 runtime checkpoints | Approval-gated, not executed | Requires the apple2ts qualification gate and user authorization; static flow evidence is not a runtime smoke result |
| Remaining runtime source | Complete for the recovery-plan overlay set | Stage 2 (`$6000-$70FF`) and all four selector-6 loads (`$7800`, `$8000`, `$A000`, `$A100`) now have bounded, typed, deterministic source-exact encoders with zero `INCBIN` |
| M7 recovery release | In progress | Exact disk construction, clean regeneration, coverage, artifact lineage, module schema, static assets, and planned runtime-source recovery are complete; remaining mechanics fields and approval-gated runtime checks remain |

### Unconfirmed Original Metrics

This is the authoritative list of original-game measurement gaps exposed to the
demake. Recovered binary values remain valid in their native units; none of the
gaps below permits an undocumented conversion to seconds, pixels, or a uniform
probability.

| Gap | What is confirmed | What remains unconfirmed / consequence |
| --- | --- | --- |
| Completed update wrappers per real-time second | `$60C1:$60C2` advances once per completed `$6A51` update wrapper (`E-TIMING-001`) | The real-time rate. This gates seconds conversions for flight, fuel drain, repair/refuel/rearm, weapon and smoke cadence, strategy/capture delays, synthesized sound timing, and the relationship between the binary's 56-wrapper cash interval and the manual's 15 seconds. |
| Runtime entropy distribution | Parachute failure occurs only when the sampled low nibble is zero (`E-PARACHUTE-001`); strategy random branches and their conditional tests are source-exact (`E-STRATEGY-001`) | Whether entropy states are uniform or correlated in normal play. Parachute failure is nominally 1/16 only under a uniform low-nibble distribution, and actual strategy branch frequencies cannot be claimed statically. |
| Machine-gun ammunition representation | The manual states 50 rounds; stages 1-4 load 64 internal shot units; stages 5-8 instead load six type-`$1A` shots (`E-SERVICE-003`, `E-STAGE-WEAPON-001`) | The mapping, if any, between a displayed/manual round and an early-campaign internal shot unit. Do not replace either source value with the other. |
| Complete joined combat profiles | Many damage values, original-unit velocities, range gates, reload gates, acquisition rules, and collision paths are source-exact (`E-COMBAT-001` through `E-COMBAT-012`) | Player firing cadence and a complete range + acquisition + rate + collision-envelope profile for every unit/weapon pairing. Exact per-update motion also remains cadence-gated in real-time units. |
| Auxiliary strategy-field semantics | Nine 8-stage progression rows and 37 auxiliary flag bytes are bounded and preserved (`E-STRATEGY-001`) | Higher-level tactical names for those rows/flags. This is a semantic naming gap, not a missing table or numeric byte. |

The following are resolved and must not be reopened as unknowns without
contradictory evidence: bunker durability behavior; stage-layout and parameter
consumer boundaries; prices, deployment quantities, and active caps; the
30-type object/integrity catalog; recovered weapon damage; structure roles;
campaign cities; stage weapon transitions; scoring; and the source-confirmed
five-man helicopter capacity despite the stale four-man reference conflict.
Demake-only normalization and tuning choices are owned by the **Demake Metrics
and Normalization Policy** section of `PRD.md`.

This table is the release claim boundary. Exact reconstruction proves that the
candidate has the canonical disk behavior, but it does not fabricate runtime
checkpoint observations or fill unresolved mechanics units. M7 must not be
marked complete while any row above remains incomplete or approval-gated.

## Immediate Work Queue

1. Keep deterministic assets, the complete module-manifest schema, generated
   coverage, artifact lineage, and versioned demake export synchronized.
2. With user approval, execute the bounded cadence trace documented in
   `evidence/dynamic-escalations.md`; do not infer seconds statically.
3. Exercise the M6 cold-boot, title, battle-start, active-play, death/restart,
   and battle-completion checkpoints when emulator use is authorized.
4. Keep apple2ts untouched until the user authorizes the first game trace.

Static analysis proceeds without apple2ts. Disk ordering, all selector streams,
the complete module atlas, checkpoint map, and original-unit helicopter motion
export are complete and reproducible. Broad linear output remains triage-only;
promotions require bounded control flow, typed data, and byte-exact assembly.
Do not contact apple2ts merely to increase confidence or coverage.
