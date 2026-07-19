# Full-screen HGR image locations

The canonical disk does not store the opening/title, campaign map, or crack
screen as contiguous 8 KiB HGR files.  The custom loader has no filesystem,
and none of its decoded selector runs loads 32 pages directly at `$2000` or
`$4000`.  These screens are packed or composed at runtime.

## Crack presentation

The one recoverable, deterministic full-screen source is stage 2.  Its packed
stream occupies runtime `$6500-$6FC9` (2,762 bytes) inside the 17-page stage-2
load.  The decoder at `$7000-$7059` expands 7,680 visible bytes, column-major,
into HGR page 2 at `$4000-$5FFF`; the remaining 512 HGR hole bytes are not
displayed.  `$707C-$70A9` selects HGR mode and presents/transforms the result.

On disk, the packed stream is track 19, logical sectors 5 through 15.  Stage 2
loads those sectors at `$6500-$6FFF`.  The selector-0 `$D000-$FFFF` language-
card load later maps the same track-19 bytes at `$E500-$EFFF`, so this is a
duplicate mapping of the same disk data, not a second picture.

Run:

```sh
python3 tools/decode_stage2_hgr.py \
  build/extract/stage2-6000-70ff.bin \
  build/assets/decoded/full-screen
```

This emits an exact 8 KiB `stage2-presentation.hgr` and monochrome PGM/PNG
previews.  The decoded screen reads "The Racketeers Present: Cracked By: Rich
and Thanx: The Keptro ...".

## Opening/title

The two complete opening frames are stored consecutively (with one intervening
byte) in the selector-0/6 packed HGR format.  They are not raw 8 KiB
framebuffers:

| Frame | File offset | Disk location | Packed bytes | Exclusive end |
| --- | ---: | --- | ---: | ---: |
| `opening1` | `$0100A` | track 1, sector 0, byte `$0A` | 5,519 | `$02599` |
| `opening2` | `$0259A` | track 2, sector 5, byte `$9A` | 5,657 | `$03BB3` |

The pointer words at track 1/sector 0 are `$000A` and `$159A`, relative to
file offset `$1000`.  The `$7800-$7913` overlay loads the containing descending
disk spans at `$A000+`, then expands literal/run commands right-to-left and
bottom-to-top into the selected HGR page.  The decoder emits all 7,680 visible
bytes, then explicitly clears HGR page 2's 512 screen-hole bytes.  The supplied
captures came from page 1 after later copy/animation work, whose screen holes
can retain unrelated runtime residue because the reveal copies display bytes.

Each stream is a complete frame.  The decoder writes every visible byte, so
`opening2` is not a delta or bitwise patch over `opening1`, although 2,851 of
their 7,680 visible bytes happen to be equal.  The packed order is two parity
passes: all even scanlines, column 39 down to 0 and bottom-to-top within each
column, followed by the odd scanlines in the same order.  It is not stored as
four rectangular quadrants.

Run:

```sh
python3 tools/decode_opening_hgr.py \
  rescue_raiders.dsk build/assets/decoded/full-screen \
  --reference-dir original
```

The generated `opening1-decoded.hgr` and `opening2-decoded.hgr` have zeroed
screen holes; their visible bytes match the emulator captures exactly.

Selector 0 subsequently animates these base pictures.  Its `$0800-$1FFF`
module supplies a 64x8 font, 38 relative bitmap descriptors, particles, event
tables, and compositors.  The language-card `$D400-$D7F3` routines add graphics
to both pages, while `$D800-$D974` performs the animated page-2-to-page-1
reveal.  Thus later opening frames can differ from the two packed bases.
The reveal routine copies the four HGR address bands `$4000/$4800/$5000/$5800`
and their paired 20-byte horizontal offsets during the same loop.  Because HGR
scanlines are interleaved in memory, this can look like several screen pieces
appearing simultaneously even though the packed images are complete frames.

## Briefing and campaign map

Selector 6 loads its disk/graphics decoder at `$7800-$7AFF`.  `$7800-$7913`
reads packed, stage-selected disk spans and expands them into the currently
selected HGR page.  The `$8000-$87FF` coordinator then copies pages, renders the
briefing and city text, and adds map/progression marks.  The output only exists
as an HGR page after these routines run; it is not a contiguous disk block.

The packed-graphics pointer table is track 1, logical sector 0.  Its selectors
lead to descending disk spans beginning at track/sector `3/12`, `4/8`, `5/8`,
or `6/12`, with 24, 14, 18, or 22 pages respectively.  These are packed inputs
and overlays, not raw HGR pages.

The supplied `map.hgr` specifically resolves to packed selector 2 at file
offset `$03BB4` (2,932 packed bytes), followed by runtime rendering of the
centered `Cherbourg` record on text row 23.  Every map byte outside that
eight-scanline city region matches the decoded base.  The briefing strings,
all eight city records, and the location-dot animation are detailed in
[`briefing-presentation.md`](briefing-presentation.md).

## Other full-screen displays

The gameplay, high-score, battle-over, emergency briefing, and city screens are
also renderer outputs.  Selector 5 supplies sprites, battlefield records, HGR
copy/fill routines, and inline text; selector 6 supplies packed graphics and
text.  Their disk data should be catalogued as source assets and recipes rather
than mislabeled as 8 KiB screen dumps.

The captured demo presentation is now mapped in
[`demo-presentation.md`](demo-presentation.md).  In particular, `SIR-TECH` and
`RESCUE RAIDERS` are compact-sprite graphics, while the greeting, credits,
last-score line, and high-score table are renderer output.  Selector 1 loads the
default names and packed-BCD scores from track 0, sector 15 into `$0400`.
