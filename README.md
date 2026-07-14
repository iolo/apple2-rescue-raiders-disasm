# apple2-rescue-raiders-disasm

This directory contains the reproducible, static-first recovery described in
[`./DISASSEMLY.md`](./DISASSEMLY.md). The original disk image is never
modified. Generated files live under `build/`.

## Quick start

```sh
make -C disasm verify
```

Useful narrower targets are `doctor`, `fingerprint`, `extract`, `analyze`,
`disassemble`, `assets`, `rebuild`, `report`, `fresh-verify`, and `clean`.
`verify` is emulator-free and requires no network access. `fresh-verify` removes
only generated `build/` output before running the full check; it is the release
regeneration gate. `emulator-doctor`, `emulator-practice`, and `smoke` exist but
fail closed until apple2ts use is explicitly authorized.

`report` generates `build/reports/release-manifest.json`, which hashes every
other generated artifact with its canonical-image lineage and producing target;
`coverage.json` reports raw and deduplicated disk/source coverage separately;
and `completion-audit.md` preserves incomplete and approval-gated release gates.
`build/data/demake-export.json` is the versioned index for all nine mechanics
exports and states their original-unit/normalization policy.

`rebuild` starts from all 560 extracted stored-sector artifacts, reinserts the
assembled boot, stage 1, stage 3, selector-0, and selector-5 outputs at their
disk locations, and writes `build/rebuild/rescue-raiders-rebuilt.dsk`. Its
manifest records every replacement and requires the candidate to be byte-for-
byte identical to the pinned canonical image.

`assets` exports the selector-0 `$1500-$16FF` font and all 38 pointer-defined
title bitmaps as raw fixtures and PGM previews under `build/assets/`. It also
models selector 5's four fixed battlefield-asset reads and exports the effective
`$1900/$D000/$E000` banks as 165 sprite descriptors and previews. The manifest
records disk provenance, addresses, signed offsets, dimensions, hashes, and the
seven-visible-bit LSB-first encoding with bit 7 preserved as HGR phase data;
every decoded glyph and descriptor is re-encoded and compared with its source.
It also exports the two consumer-specific orders of the shared eight-pattern
HGR fill vocabulary as 16 round-tripped previews, the 726-byte protection
raster/seed region and its component tables, title particle/animation
sequences, and the runtime fuel-gauge transform recipe.
The same manifest records that selector-5 deployment and critical-fuel audio is
directly synthesized through `$C030`. It also classifies every literal `$C030`
operand in the boot/stage/decoded-selector corpus, exporting nine bounded raw
fixtures for the shared presentation effects, callable service copies, and two
inert overwrite-workspace false positives. No real-time duration is invented.

`build/data/battlefields.json` preserves all eight track-0 stage sectors and
expands their type-`$06/$09` layout, ownership, optional-object, and campaign
formation records to original 12-bit coordinates. Unclassified bytes remain in
the raw sector hex. `build/reports/battlefields.md` summarizes per-stage counts.
The stage-parameter boundary now distinguishes live `$4060-$4063/$4068/$4069/$406D`
consumers from copied dead stores and uncopied tail metadata. The generated
`strategy.json`/`strategy.md` package preserves the complete 7-primary,
14-secondary, 17-first-handler automated strategy script model.

The image is a 143,360-byte sector image (35 tracks, 16 sectors, 256 bytes).
The boot stage establishes DOS-logical file-sector ordering for track 0; this
does **not** establish a DOS filesystem. Three reversible permutations remain
available so later loader stages can be tested without silently forcing the
track-0 conclusion onto every region.

## Authored versus generated files

- Authored: `Makefile`, `config/`, `disk/`, `evidence/`, `src/`, `tools/`, and
  `tests/`.
- Generated: everything under `build/`.
- Canonical external input: `./rescue_raiders.dsk`, pinned by
  `original/checksums.txt`.

The initial boot listing uses the Apple II boot-page origin `$0800`. This is a
confirmed static address: operands in the sector refer back to `$08A0`, `$08AC`,
and `$08AD`, and the sector-count byte at `$0800` precedes executable code at
`$0801`. Labels beyond the source-exact boot page remain provisional.

`src/stage1/stage1_loader.s` promotes the complete `$BB00-$BD94` Disk II codec,
seek path, and high-level RWTS dispatcher; the `$BD95-$BFC7` work buffers,
translation/seek tables, and delay utility; and the `INTER`/`IOB` interface at
`$BFC8-$BFED` to labeled ca65 source/data. The build asserts their addresses and
reconstructs all of `$BA00-$BFFF` byte-for-byte. The `$BA00` copy reuses the
same source emitter as the independently rebuilt `$0800` boot page, and the
unreferenced `$BFEE-$BFFF` residual is explicitly bounded data. No `INCBIN`
remains in the module, which is now classified `source-exact`.

`src/stage3/stage3_stream.s` reconstructs all of `$4000-$43FF`: selector stream
setup, the self-modifying dispatcher and relocation paths, five opcode handlers,
seven pointer-defined streams, hardware/signature tables, and bounded residual
workspace data. The complete output compares byte-for-byte with no `INCBIN`, so
stage 3 is classified `source-exact`.

`build/reports/campaign-flow.md` and `build/data/campaign-flow.json` capture the
byte-checked demo-to-battle chain. High-bit `S` ends the demo pass, the outer
loop selects interactive mode and campaign index 1, selector 6 presents the
briefing and stage-indexed city, and its index-1 continuation dispatches
selector 5 back into the joystick/paddle-driven battlefield. The city pointer
table resolves all eight stages from Cherbourg through Antwerp.
`config/selector6.info` bounds the main load's executable ranges, two inline
high-bit message records, city pointer/name tables, workspace, and embedded
source-text tail. Three companion type maps cover the `$7800` disk/graphics
code and tables, the `$A000` glyph renderer/state/prompt, and the `$A100`
bitmap/font rows. Deterministic da65/ca65 encoders rebuild all 4,096 selector-6
bytes exactly with no `INCBIN`.
FLOW-30 is also statically confirmed: selector 0 entry `$6000` directly calls
the `$0800` high-resolution graphics/title animator, whose event scanner reads
the `$1149` timed table and exits through the `$0618 -> $0F80` record before
selector 1 is requested. The `$0EB2` event installs the copyright notice at
`$11A7` as the text-stream pointer; `$0ED5/$0F24` directly consume and render
its high-bit bytes.
`src/selector0/opening.s` and `entry.s` now promote that direct entry, graphics
initializer/animation loop, event initialization/scanner, complete timed table,
and selector-1 handoff to labeled source. Their complete `$0800-$1FFF` and
`$6000-$67FF` load artifacts rebuild byte-for-byte, making selector 0
fully `source-exact` with 8,192 authored bytes and no opaque bytes. The complete
`$0800-$1FFF` opening span now includes the indirect event trampoline, self-modifying HGR
page clear, descriptor-driven bitmap compositor/eraser, ROM hex helper,
animation-state initialization, double-buffered sprite/composite updates,
entropy mixing, timed-event scanning, page-gated frame composition, and the
32-slot particle/16-slot bitmap-object double buffers. It also includes the
scene producer coordinator, composite/sprite motion, randomized particle and
trailing-object creation, and the authored event-table handlers through the
copyright-text setup.
The same span now includes the text streamer/glyph renderer and typed text/HGR
scanline, sprite-frame, and mask tables through the complete timed-event table.
Particle masks, packed composite animation frames, and the full zero-terminated
high-bit copyright record are typed source data as well.
The leading jump, 14-byte event-delay stream, HGR row-pointer helper, and
alternating-mask row filler close the former `$0800-$084E` front gap.
The initialized scalar state, nine particle arrays, ten bitmap-object arrays,
event state, and text/loop controls are explicit source data through `$14B2`;
inactive-slot residual bytes remain byte-for-byte intact.
The page-aligned 64×8 font and all 38 width/height bitmap descriptors are typed
source data; their relative pointer table is symbolic, and the two unclassified
residual tails are retained explicitly. The opening artifact contains no
`INCBIN`. The separate `$6000-$67FF` entry load is also entirely authored: its
RWTS trampoline, entropy-selected protection paths, HGR compositor/clear,
eight-point perimeter motion, signed two-axis rasterizer, symmetric box paths,
page-copy logic, coordinate/mask/seed tables, workspace, and residual tail all
rebuild exactly without `INCBIN`.
The high-bit-`S` dispatch at `$90B8-$90C2` and its state-changing routine at
`$8F87-$8F92` are also promoted to labeled source in `selector5/flight.s`.
The adjacent `$697D-$6B5D` main-flow slice is now labeled as well: it covers
the alternating demo/interactive passes, update and exit gates, module
initialization, campaign-stage reset/setup, and the selector-6 briefing call.
The preceding `$6900-$697C` module jump table, overlapped type-size table,
vertical-size and active-list membership tables, and speaker-click delay are
also source-exact. The following `$6B5E-$6FC3` disk/RWTS, entropy, campaign
counter, typed core-table, object-module, active-list, and overlapping allocator
code/data is source-exact too. Together with player initialization, battlefield
layout decoding, the adjacent object/projectile constructor blocks, formation
decoding, active-list insertion/repair, the overlapping constructor/default and
formation tables, the `$7A00` object-update module, ground-unit/infantry update
and targeting paths, secondary/default handler data, and the secondary module's
disk verification/companion/target acquisition paths, and the early countdown/
spawn/effect handlers, side-specific active-list target selection, the keyboard
and pushbutton dispatcher, player state/animation/action coordinators, smart-
missile target search, smoke/input helpers, and the adjacent typed tables, this
makes `$6900-$BAFF` contiguous authored code/data. The overlay now has 20,992
authored bytes and zero opaque bytes. The
new tail types input/deployment tables and labels the strategy module front,
coordinator, resource-weighted command selection, motion reset, its first
17-entry handler family, tracked/opposing-object policies, script advancers,
shared resource/action decisions, candidate scans, saved/moving-target actions,
opponent/resource gates, primary/secondary pointer-table dispatch core, signed
target steering, candidate/boundary/resource actions, side-dependent type-`$0D`
scanning, action validation, type-`$08` avoidance, opponent-distance tests,
hostile-target scoring, linked-object and coordinate-distance helpers, motion-
coordinate transforms, nearest friendly type-`$0D` selection, signed direction
helpers, and complete typed strategy scripts, offsets, handler pointers,
velocity/eligibility tables, commands, and workspace.
The joined tail also labels the display-module jump table, page/frame setup,
active-object and compact-status rendering, inline high-bit feedback records,
battlefield HUD prelude, and its fall-through into the fuel HUD.
The final tail adds animated fuel bars/HGR gauge patterns, inline-text decoding,
camera and visible-object rendering, HGR page copying/filling, high-score and
presentation phases, battle/score output, explicit self-modifying operands,
overlapping callback tables, and trailing workspace.
The source preserves the overlap
between the final list-insertion JMP operand and the constructor pointer table
beginning at `$7875`.

`src/selector5/flight.s` promotes player initialization at `$6FC4-$70B3`, the
analog flight input at `$914C-$91C1`, signed-step limiter at `$94CA-$94D5`,
player-helicopter motion at
`$97AC-$9866`, field repair at `$925D-$9292`, pad service at `$96D0-$97AB`,
fuel drain/descent at `$934C-$93B9`, HUD warning feedback at `$B47A-$B4F8`,
and the signed target table at `$998E-$99A7` inside a byte-exact rebuild of
the complete `$6900-$BAFF` gameplay overlay. Selector 5 is fully `source-exact`
and contains no `INCBIN`.
The same module now labels smoke feedback at `$9867-$98B9` and the common
integrity/destroy consumer at `$AC26-$AC5A`. Player bomb and smart-missile
initializers at `$724C-$7285`/`$74DE-$7533`, the player weapon dispatcher and
firing paths at `$93BA-$94C9`/`$95F5-$964F`, and projectile damage transfer at
`$AFDC-$B00D` are also source-exact. The fixed non-player type-`$0B` projectile
producers at `$820C-$824D` and `$8B9C-$8BFC`, plus the pointer-table slices
that assign them to grounded infantry type `$0D` and armed-bunker type `$17`, are
source-exact as well. The tank type-`$0E` fixed/random damage dispatcher at
`$8146-$81E7` is also promoted;
the exported combat data records its `1..5/15` alternate damage set. The
purchase/deployment routine at `$9543-$95F4` and tables at `$996C-$9984` prove
that `M` men and `E` engineers share type `$0D`. The generated combat export also
records M/T/A/D/E costs 5/4/3/2/5, active-counter thresholds 26/6/7/8/29, and
deployment sizes 5/1/1/1/2. Men and engineers share counter offset 6, so their
26/29 limits are command-specific thresholds over the same type-`$0D` counter.
The export also captures the original cash pool: both sides start a new
battlefield pass at 15 bags, carry balances between stages, gain one bag every
56 object-update handler calls, and saturate at 255. Replacement helicopters
cost 20 bags; seconds remain cadence-gated (`E-ECONOMY-001`).
Constructor stores and the secondary lookup base at `$8467` additionally prove
initial integrity values 5/15/6/9/5 and handlers
`$7DF9/$7F1A/$7F76/$8027/$7DF9` for M/T/A/D/E. The authored pointer span begins
at `$8469` because the type-0 word overlaps the preceding instruction; accounting
for that overlap removes the former one-entry unit-role shift.
The same combat export records the shared ground-unit velocity selector and
12-bit integrator: all four ground object types move one original horizontal
coordinate unit on a completed wrapper that takes the movement path. It also
models falling infantry type `$19`: a zero entropy low nibble prevents parachute
opening, which is nominally 1/16 only under a uniform-nibble assumption. The
actual entropy distribution and all conversions to seconds remain `null`.
Stage byte `$4069`, copied to `$60EE`, closes one documented weapon-evolution
gap: battles 1-4 use the 64-internal-unit machine-gun model, while battles 5-8
replace it with six type-`$1A` shots carrying 21 damage. The export also records
the alternate projectile's signed acceleration, type-`$13` emissions, downward
counter gate, and eight-value pad-rearm gate (`E-STAGE-WEAPON-001`).
Stage byte `$4068`, copied to `$60ED`, changes grounded-bomb aftermath in
battles 4-8: it suppresses the ordinary type-`$11` effect and attempts a
type-`$1D` transition to collision-active type `$18`, preserving its exact
signed-half velocity and four-damage infantry interaction (`E-STAGE-BOMB-001`).
The handler at `$7DF9` is now correctly classified as grounded infantry type
`$0D`. Its exact type-`$06/$16/$17` structure search and resolver are exported
with capture/deposit behavior, integrity profiles, stage `$406D` stored-unit
values, type-`$06` repair/production, and raw capture delays
(`E-STRUCTURE-001`). Type `$09` is explicitly outside this capture search.
`build/data/object-type-catalog.json` now joins all 30 types `$00-$1D` across
their size/default, active-list, constructor, object/phase update, collision,
destruction, integrity, and aftermath tables. Its full-domain indexing corrects
the older gun classification: type `$08` runs balloon-mooring-line update
`$7C3A`, while independent 22-integrity type `$09` owns stationary-gun update
`$7D5F`; falling infantry `$19` owns `$8288` (`E-OBJECT-CATALOG-001`).
The constructor dispatcher, type-`$0C` fragment initializer, M/E infantry
constructor, T/A/D vehicle constructors, and their common vehicle tail are now
source-exact across `$72AF-$74A1`.
The linked type-`$06/$07/$08` bunker/balloon constructor at `$716F-$722D`,
type-`$09` stationary-gun constructor/update at `$722E-$724B`/`$7D5F-$7DF8`,
fixed armed-bunker registration at `$75C0-$75E9`, and distinct bunker/type-`$1C`
collision path at `$B1B7-$B1F1` establish those structure and weapon roles.
The fixed table and consumers further prove type `$04` is the launch/service
pad and type `$05` the DTV-destroyed time-machine objective
(`E-STRUCTURE-ROLE-001`).
The AC module entries/player damage gate at `$AC00-$AC25` and active-object
collision-list traversal at `$ACBC-$ACE3` are source-exact too.
The adjacent `$ACE4-$AE40` scanner now labels ordered candidate traversal,
table-sized bounds, vertical overlap tests, destroyed-player cleanup, and the
pair-preserving bridge into the per-type dispatcher at `$AE41`.
The dispatcher and its table-selected type-`$02`, type-`$12/$1A`, and
type-`$1B` handlers are now source-exact through `$AFDB`, including explicit
pair swapping and branches into the shared damage/destruction entries.
The associated cleanup islands at `$B06F-$B0CC` and `$B15F-$B1B6` are also
source-exact. Correcting for the two destruction-table pointers overlapped by
the preceding collision table assigns link cleanup to types `$06/$07/$08`,
smart-missile link cleanup to type `$12`, the guarded signed-half-speed
type-`$1D` aftermath to bomb `$0A`, and its interior entry to type `$1A`.
With the common unlinker at `$AC85-$ACBB` and late handlers at `$B1F2-$B22C`
promoted, the complete `$AC00-$B2F6` damage/collision/destruction block is now
contiguous source-exact ca65, including its instruction/table overlaps.
The shared type-`$0B` initializer at `$7286-$72AE` and update handler at
`$8D47-$8D81` now expose producer-supplied signed velocity/acceleration fields,
the `10 + acceleration` life counter, and vertical destruction boundaries.
The type-`$12` smart-missile update at `$8670-$87E2`, type-`$0A` bomb update at
`$8CB8-$8D46`, and signed smoke/machine-gun direction tables at `$99AD-$99E2`
are source-exact as well. The combat export records the machine gun's exact
signed velocity tables, bomb acceleration, and smart-missile steering/impact
behavior in original update units.
The special collision handlers at `$B00E-$B06E` and overlapping 30-entry
dispatch table at `$B22D-$B268` are source-exact. They recover the remaining
fixed four-damage collision path for types `$14/$18/$1C`, including target,
ownership, link-state, and direct type-`$0B` destruction exclusions.
Destruction aftermath is now source-exact at `$74A2-$74DD`, `$AC5B-$AC84`,
`$B0CD-$B15E`, and overlapping tables `$B265-$B2F6`. The export distinguishes
the type-`$11` visual and table-controlled type-`$0C` batches from weapon
damage: these bounded aftermath routines contain no immediate radial target
scan or incoming-damage write, so original weapon damage remains direct-hit.
Non-player type-`$0B` ballistics are source-exact at `$7CAD-$7D5E` and direction
tables `$84A3-$84A4`/`$8EE2-$8EE3`. Grounded infantry `$0D` and armed bunker `$17` use
horizontal `+/-2`, while tank `$0E` uses `+/-2` or `+/-4`; the shared lifetime yields nominal 20/40
original-unit travel. The independent type-`$09` gun instead computes predictive
target deltas divided by eight with vertical acceleration 1 and life 11.
The source-exact targeting slice at `$7D5F-$7DF8`, `$7F76-$7FF8`,
`$8327-$83D7`, and `$84F2-$84F5` recovers strict horizontal acquisition
thresholds: 96 for the stationary gun's helicopter branch and 256 for its
shared fire check and the missile carrier. Their counter periods are 2 and 4
update-wrapper values respectively; the carrier self-destructs after launch.

The generated helicopter exports preserve original representation units:
`build/data/helicopter-flight.json` covers input and motion, while
`build/data/helicopter-service.json` covers fuel, warnings, integrity, field
repair, and pad service. Their real-time update cadence is deliberately `null`
until the approval-gated dynamic measurement is performed.

`build/data/main-loop-timing.json` proves that `$60C1:$60C2` counts completed
update wrappers but leaves updates per second `null`. `build/data/helicopter-combat.json`
exports player weapon damage, the stage-5 alternate weapon transition,
integrity-feedback tiers, ground-unit mobility, and the qualified
parachute-failure model. The approval-gated
measurement needed to convert counter values to seconds is specified in
`evidence/dynamic-escalations.md`.

`build/data/scoring.json` exports the original four-digit packed-BCD score
model, all table-driven event adjustments, the 90-update-wrapper time penalty,
surviving-object values, and the eight stage bonuses. Its companion report is
`build/reports/scoring.md`.
