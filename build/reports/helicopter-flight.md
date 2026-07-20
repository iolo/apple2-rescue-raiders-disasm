# Helicopter flight mechanics

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-FLIGHT-001`, `E-FLIGHT-002`

The routine at `$914C` resets the Apple II paddle timer at `$C070`, measures `$C064/$C065`, and caps each counter at 100.

## Horizontal

- Raw input is divided by four and indexes `$998E`: `-7, -7, -6, -5, -4, -3, -2, -2, -1, -1, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 5, 6, 7, 7, 7`.
- The selected value is a signed target velocity. `$981E-$9831` changes current velocity by −1, 0, or +1 per movement update until it reaches that target.
- Position is 16-bit (`$632C,Y:$6394,Y`) and accepts movement within the statically observed `$0230-$0DD0` boundary checks.

## Vertical

- Target coordinate: `56 + floor(447 × raw / 256)` (`$01BF` scale), yielding 56..230 for capped samples.
- `$97AC-$97D4` approaches the target by signed `(target-current) >> 3`; small positive differences force a +1 step.
- The upper position clamp is `$DD` (221).

Update cadence is unresolved, so these are original units per movement update—not pixels or seconds for the demake yet.
