# Static baseline report

- Image SHA-256: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`
- Size: 143360 bytes
- Geometry: 35 × 16 × 256 bytes
- Filesystem probe: a2kit 4.4.2 reports no matching filesystem (probe only).

## Boot-page observations

- `$0800` sector count: `1`; executable entry begins at `$0801`.
- Absolute references to `$08A0`, `$08AC`, and `$08AD` anchor this sector at `$0800`.
- `$08A0-$08AA`: `00 0D 0B 09 07 05 03 01 0E 0C 0A`.
- `JMP $BAB0` enters the relocated copy of sector offset `$B0` after logical sectors 0..5 load at `$BA00-$BFFF`.

## Mapping candidates

- `file-linear` output-position→raw-file-position: `0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15` (round-trip exact)
- `physical-indexed-dos33` output-position→raw-file-position: `0,13,11,9,7,5,3,1,14,12,10,8,6,4,2,15` (round-trip exact)
- `physical-indexed-prodos` output-position→raw-file-position: `0,2,4,6,8,10,12,14,1,3,5,7,9,11,13,15` (round-trip exact)

The boot-stage discriminator confirms DOS-logical raw file order for track 0; this is not a filesystem conclusion.
