# Demo-to-battle campaign flow

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-FLOW-050`, `E-FLOW-060`, `E-FLOW-070`, `E-FLOW-080`, `E-FLOW-START-001`

## Start transition

- $90B9 compares the demo keyboard byte with high-bit S ($D3).
- $8F87 clears $60BB and increments $60B0/$60B8, ending the current demo pass.
- $6991 toggles $60B6 from demo (1) to interactive (0).
- $6AA2 assigns campaign index $05 = 1; $6B4F then calls INTER with selector 6 because $60BB is nonnegative.

## Briefing, map, and battle

- $8190 prepares later-stage map progression when campaign index is at least 2.
- $80C4 composes Emergency transmission> at row 0 and Terrorists have been found at at row 6.
- $8124 centers the stage-indexed city at row 9 and adds Prepare for action at row 12.
- $81E0 decodes packed-HGR selector 2, renders the same city at row 23, animates the stage-location ring, and waits for continue input.
- At campaign index 1, $80A0-$80B0 calls INTER selector 5, returning to battlefield setup.

### Briefing text composition

| Address | Column | Row | Text |
| --- | ---: | ---: | --- |
| `$80EC` | 0 | 0 | Emergency transmission> |
| `$8106` | 6 | 6 | Terrorists have been found at |
| `$86B8-86EE` | centered | 9 | stage city record |
| `$8131` | 11 | 12 | Prepare for action |

| Campaign index | City | Record address | Encoded bytes |
| ---: | --- | --- | --- |
| 1 | Cherbourg | `$86B8` | `C3E8E5F2E2EFF5F2E7` |
| 2 | Caen | `$86C2` | `C3E1E5EE` |
| 3 | Saint-Lô | `$86C7` | `D3E1E9EEF4ADCCC0` |
| 4 | Orléans | `$86D0` | `CFF2ECA3E1EEF3` |
| 5 | Paris | `$86D8` | `D0E1F2E9F3` |
| 6 | Verdun | `$86DE` | `D6E5F2E4F5EE` |
| 7 | Brussels | `$86E5` | `C2F2F5F3F3E5ECF3` |
| 8 | Antwerp | `$86EE` | `C1EEF4F7E5F2F0` |
