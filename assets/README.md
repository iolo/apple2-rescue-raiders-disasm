# Recovered asset pipeline

Run `make assets` from the repository root to regenerate the currently
classified assets under `build/assets/`.

Authoritative lossless definitions live under `src/assets/`; their owning
selector sources and extracted battlefield banks provide the remaining native
inputs. The pipeline exports:

- the 512-byte font at `$1500-$16FF`, split into 64 eight-row glyph previews;
- the complete 2,304-byte title-bitmap region at `$1700-$1FFF`;
- all 38 pointer-defined width/height bitmap descriptors as raw fixtures and
  decoded PGM previews;
- the selector-5 battlefield loader's four exact disk spans, including the
  two-page `$E000-$E1FF` span overwritten before rendering;
- 165 gameplay sprite descriptors from the effective `$1900`, `$D000`, and
  `$E000` banks, split 78/14/73, as raw fixtures and PGM previews; and
- both indexed orders of the eight-entry procedural HGR fill vocabulary as 16
  raw pairs and PGM previews, plus the protection raster/seed and title
  animation tables; and
- a JSON manifest containing source addresses, dimensions, paths, sizes, and
  SHA-256 hashes.

Each packed byte supplies seven horizontal pixels, with bit 0 at the left. The
decoder immediately re-encodes every glyph and descriptor and rejects any byte
difference. The 68-byte `$1FBC-$1FFF` residual remains part of the lossless raw
region but is not presented as a decoded bitmap.

Gameplay descriptors contain signed X/Y offsets, packed-byte width, row height,
and a contiguous `width * height` payload. Their low seven bits use the same
left-to-right convention; bit 7 is retained as the Apple II HGR phase plane.
Every one of the 165 payloads is decoded and re-encoded with its phase bits, and
the three bank pointer tables and all descriptor boundaries must be contiguous.

Procedural graphics remain recipes instead of fabricated screenshots. The
title and battlefield display palettes are byte-identical; protection uses the
same eight pattern pairs in a different index order. All 16 indexed pairs
round-trip their visible bits and HGR phase plane. The protection package
preserves its 192-entry scanline pairs, 140-entry horizontal lookup pairs,
seven two-byte point masks, and eight moving-point seeds as a contiguous
726-byte fixture plus ten component fixtures. The manifest records the exact
address formulas and the 84-frame spoke and two 36-frame box paths. It also
exports the title's particle masks, packed composite frames, timed events,
delay stream, and five-frame sprite sequence, and describes the 32-row,
three-band procedural fuel gauge.

The manifest also classifies selector 5's two gameplay sound paths. They are
synthesized directly through `$C030`, not read from a note/sample stream:
ground-unit deployment performs 16 fixed-parameter toggles, while critical fuel
performs one toggle per eligible HUD update. Real-time duration remains `null`
until cadence is measured. This claim is deliberately limited to the complete
source-exact selector-5 load.

The companion shared/presentation inventory covers the boot page, stages 1-3,
and every decoded selector load. Its nine hashed fixtures preserve the active
selector-0/stage-2 transform loop, the invalid-input beep, the presentation
sweep and its tone engine, both copies of the `$6972` delay/toggle service, and
the duplicate stage-1/stage-3 workspace bytes. The manifest distinguishes nine
active-or-callable `$C030` accesses from two inert workspace matches. The three
bounded shared effects synthesize 1,456, 128, and 880 speaker toggles; their
durations remain `null`.

The known consumer-backed bitmap, procedural-HGR, battlefield-layout, and
synthesized-audio encodings in the decoded selector corpus are now packaged.
Visual placement against live screenshots remains conditional on
user-authorized emulator work, and future consumer discoveries must extend the
manifest rather than silently broadening these claim boundaries.
