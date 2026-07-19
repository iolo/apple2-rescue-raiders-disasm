# Emergency briefing and campaign map

`original/brief.txt` captures two selector-6 screens reached after pressing
high-bit `S` (`$D3`) during the demo.  The first is a composed briefing; the
second is the packed campaign map with a rendered city name and animated
location marker.

The capture's `Emergeny transmission>` is a transcription typo.  The runtime
record and the earlier embedded ASCII source both spell it
`Emergency transmission>`.

## Briefing composition

`present_emergency_briefing` at `$80C4` establishes the HGR background and
passes an inline command stream at `$80E8` to `render_inline_message`.  Values
below `$0A` are controls; `$01,column,row` changes the text position and `$00`
terminates the record.  Apple high-bit character bytes are drawn through the
selector-6 `$A000` glyph renderer.

| Runtime address | Position | Visible content |
| --- | --- | --- |
| `$80EC` | column 0, row 0 | `Emergency transmission>` |
| `$8106` | column 6, row 6 | `Terrorists have been found at` |
| stage record | centered, row 9 | `Cherbourg` for campaign index 1 |
| `$8131` | column 11, row 12 | `Prepare for action` |

The city renderer reads `$05` as the one-based campaign index, follows the
split low/high pointer tables at `$86A8/$86B0`, and centers the selected
length-prefixed record.  The same routine is reused by the map screen.

## Campaign city records

| Index | Address | Displayed name | Stored high-bit glyph bytes |
| ---: | --- | --- | --- |
| 1 | `$86B8` | Cherbourg | `C3 E8 E5 F2 E2 EF F5 F2 E7` |
| 2 | `$86C2` | Caen | `C3 E1 E5 EE` |
| 3 | `$86C7` | Saint-Lô | `D3 E1 E9 EE F4 AD CC C0` |
| 4 | `$86D0` | Orléans | `CF F2 EC A3 E1 EE F3` |
| 5 | `$86D8` | Paris | `D0 E1 F2 E9 F3` |
| 6 | `$86DE` | Verdun | `D6 E5 F2 E4 F5 EE` |
| 7 | `$86E5` | Brussels | `C2 F2 F5 F3 F3 E5 EC F3` |
| 8 | `$86EE` | Antwerp | `C1 EE F4 F7 E5 F2 F0` |

The accented letters use the game's glyph encoding rather than ordinary
high-bit ASCII: the final two bytes of Saint-Lô and `$A3` in Orléans select
custom glyphs.

## Map framebuffer recipe

`present_campaign_city` at `$81E0` calls `load_campaign_map_base` (`$82A0`),
which selects packed-HGR image 2 in the shared `$7800` decoder.  Its stream is:

| Selector | File offset | Disk location | Packed bytes | Exclusive end |
| ---: | ---: | --- | ---: | ---: |
| 2 | `$03BB4` | track 3, sector 11, byte `$B4` | 2,932 | `$04728` |

The decoded base matches all of `original/map.hgr` except 52 bytes in HGR
scanlines 184–191, columns 15–23.  Those are exactly the centered nine-character
`Cherbourg` record rendered at text row 23.  Thus `map.hgr` is the packed map
base plus runtime city text, not a raw 8 KiB disk image.

After composing both HGR pages, `$82C4-$833D` updates eight coordinates around
the stage position.  Together with the fixed center marker in the map this is
the observed nine-dot location animation.  Stages 2–8 first add progression
marks through the selector-3/selector-4 map variants.

Run the shared extractor with the emulator captures as references:

```sh
python3 tools/decode_opening_hgr.py \
  rescue_raiders.dsk build/assets/decoded/full-screen \
  --reference-dir original
```

It emits `campaign-map-base-decoded.hgr` and preview images, verifies both
opening frames exactly, and verifies that the map differs only in the rendered
city region.
