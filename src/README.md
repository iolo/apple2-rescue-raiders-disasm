# Recovered source tree

This directory is the authoritative, human-maintained representation of the
program recovered from the canonical disk image. Files under `build/` are
disposable products: assembled binaries, mechanical comparison listings,
decoded previews, reports, and verification manifests.

The hierarchy follows the original loader architecture while adding semantic
names where they are confirmed:

```text
src/
  loader/       sequential boot and loader stages
  overlays/     stage-3 selector load sets
  assets/       lossless source representations of recovered assets
  platform/     shared Apple II symbols when they are factored out
```

`loader/stageN` means bootstrapping phase, not campaign battlefield number.
An overlay directory retains the original selector number because that number
is part of the on-disk load protocol. A semantic suffix describes its known
role without discarding that identity.

All source-backed regions are assembled during `make verify` and compared with
the bytes extracted from the canonical image. This comparison validates the
recovery; it does not make generated listings authoritative. Labels, comments,
and representations may be improved freely as long as the recovery branch
continues to emit the original bytes.

## Current overlay ownership

| Selector | Authoritative representation | Status |
| --- | --- | --- |
| 0 | `overlays/selector0-opening/` plus title/protection assets | Curated, source-exact opening overlay |
| 1 | `overlays/selector1-transition/` plus extracted supporting loads | Transition entry promoted; supporting asset/state loads remain to classify |
| 2 | `assets/maps/campaign_map_packed.s` | Complete native map load promoted as source asset |
| 3 | Extracted load set | Semantic promotion pending |
| 4 | Extracted load set | Semantic promotion pending |
| 5 | `overlays/selector5-battlefield/` | Curated, source-exact battlefield overlay |
| 6 | `overlays/selector6-briefing/` | Source-exact briefing/map overlay; labels are progressively curated |

Unknown or weakly classified bytes should remain explicit `.byte` data in a
source file when promoted. Promotion must not invent code boundaries or asset
semantics merely to eliminate a generated artifact.
