# Automated strategy scripts

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-STRATEGY-001`

The selector-5 strategy module is table-driven: seven primary actions select fourteen secondary scripts, which dispatch seventeen first-phase handlers. The JSON preserves every script byte, offset, pointer, overlap, and statically proven gate.

- The command table decodes through the common input dispatcher to engineers, demolition vehicles, AA missile carriers, tanks, and men (`E/D/A/T/M`).
- Four eight-bit resource scores are compared by strict minimum, with ties retaining the higher index. Early stages force the third score to `$FF`, and index zero can be randomly remapped to `M`.
- Same-page horizontal steering uses signed lookup tables and clamps farther targets to `+7/-7`. Logical positive index 27 deliberately overlaps the first type-`$0D` side-offset byte and therefore reads `$40`.
- Hostile target scoring admits object types `$00/$0D/$0E/$10`, subtracts rank clearance, and chooses the smallest 16-bit horizontal score. Active-list structure makes type `$00` non-live in this scan.
- Type-`$08` avoidance switches at 86 horizontal units; close-opponent firing uses a 10-unit vertical gate and a 64-counter cadence gate.
- Nine 8-byte auxiliary progression rows and 37 flag bytes remain raw because their structure is proven but their higher-level tactical names are not.

All cadence remains counter-relative, and random branch probabilities remain conditional on the unresolved entropy distribution.
