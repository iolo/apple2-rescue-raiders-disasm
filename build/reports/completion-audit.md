# Recovery completion audit

Canonical image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`

| Requirement | Status | Evidence / remaining work |
| --- | --- | --- |
| Input lineage | `complete` | Pinned size/hash and toolchain manifest |
| Extraction/geometry | `complete` | 560 sectors and three reversible mappings |
| Boot/loader model | `complete` | Source-exact boot and stages 1/2/3 handoffs |
| Selector 0 | `complete` | 8,192 source-exact bytes, zero INCBIN |
| Selector 1 transition | `partial` | 256-byte executable entry promoted; supporting loads remain to classify |
| Selector 2 map | `complete` | 1,024-byte packed map represented as native source asset |
| Selector 5 | `complete` | 20,992 source-exact bytes, zero INCBIN |
| Stage 2 | `complete` | 4,352 typed source-exact bytes, zero INCBIN |
| Selector 6 | `complete` | 4,096 typed source-exact bytes across four loads, zero INCBIN |
| Remaining runtime source | `partial` | Promoted loads under src/ contain zero INCBIN; selector-1 supporting loads and selector-3/4 load sets remain to promote |
| Static asset encodings | `complete` | All known decoded-selector assets have raw fixtures and round-trip checks |
| Screenshot placement | `approval-gated` | Requires qualified, user-authorized apple2ts run |
| Demake exports | `partial` | Versioned original-unit export exists; cadence and auxiliary tactical semantics remain unresolved |
| M6 runtime checkpoints | `approval-gated` | No emulator qualification or game trace authorized |
| Recovery release M7 | `incomplete` | Static mechanics gaps, approval-gated runtime checkpoints, and contributor release gate remain open |

This report is generated and intentionally does not promote approval-gated runtime observations.
