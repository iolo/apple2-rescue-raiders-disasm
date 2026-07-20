# Recovered assets

This directory contains authoritative lossless asset definitions used by the
recovered assembly source. It is distinct from `build/assets/`, which contains
regenerated raw slices, manifests, and visual previews.

Current source assets are:

- `fonts/title_font_64x8.inc`: the page-aligned 64-glyph title font.
- `title/title_bitmaps.inc`: all 38 pointer-defined title bitmap descriptors.
- `maps/campaign_map_packed.s`: selector 2's complete packed campaign-map base.
- `protection/protection_tables.inc`: HGR scanline, mask, seed, and retained
  protection workspace data consumed by selector 0.

An asset belongs here when it has a stable, lossless source representation.
PGM/PNG previews remain generated unless they preserve every native property
needed for round-trip encoding. Apple II HGR phase bits, packed descriptor
offsets, signed coordinates, and table overlaps must not be discarded in favor
of a visually convenient format.

Additional recovered assets should be organized by semantic role—fonts,
sprites, title graphics, maps, battlefields, text, and stored sound data—and
carry their original address/disk provenance. Synthesized sound remains code in
its owning overlay rather than being misclassified as a sample asset.
