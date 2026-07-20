# Packed-BCD scoring

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-SCORE-001`

- The four-digit score is packed BCD in `$0F:$0E`; `$9000-$9999` is interpreted as ten's-complement negative state.
- Every 90 completed update wrappers, the live score loses one point while its high byte remains below `$90`. This period is not converted to seconds.
- Object create/destroy events select one of nine adjustment groups and one of three overlapping state banks rooted at `$6E2F/$6E37`.
- Battle-end accumulation adds each surviving object's type-specific high-nibble score value and a campaign bonus `100 + 50 × (stage − 1)`.
- The same object byte's low nibble is added to the saturating `$6117` count.

The JSON export preserves all 30 type groups, all three 9-value event banks, all 31 final object values, and stage bonuses 100..450.
