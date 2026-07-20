# Helicopter fuel, damage, and pad service

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-SERVICE-001`, `E-SERVICE-002`, `E-SERVICE-003`

## Fuel and warnings

- `$6108,X` starts at 128. While not in pad service, `$934C-$937E` subtracts one when `($60C1 & $0F) == 0`; at ground coordinate `$DD`, the extra `$1F` gate halves that drain rate.
- The HUD selects its low-fuel graphic below 34 (`$22`). Below 16 (`$10`) it also executes the critical sound path, which toggles the Apple II speaker at `$C030`.
- Zero fuel enters the forced descent/crash path. Real-time cadence is unresolved, so all periods are in `$60C1` counter values.

## Damage and service

- `$659C,Y` is integrity/health: 15 is full. Pad service restores one every 4 counter values.
- Field repair restores one every 8 counter values only at ground coordinate `$DD` with at least four carried men.
- Standard pad service restores fuel and internal gun ammunition by one per service pass, bombs by one every 4 counter values, and smart missiles by one every 16.
- Capacities are fuel 128, integrity 15, bombs 10, and smart missiles 2. The binary initializes 64 internal gun-shot units, while the manual says 50 rounds; both facts are retained as an unresolved representation discrepancy.
- `$610C,X` becomes ready only after a service pass changes none of the tracked stores; the HUD consumes it together with the active pad-service flag `$60FC,X`.

These are original state units and counter gates, not rates per second.
