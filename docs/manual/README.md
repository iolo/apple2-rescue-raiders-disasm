# Rescue Raiders manual

Open [index.html](index.html) for the English Training Guide or
[index.ko.html](index.ko.html) for the Korean edition. Both editions work offline
and share the same `images/` folder; keep it alongside the HTML files.

The cover (`images/cover.jpg`) is a Marvel-inspired action-comics interpretation
of the Training Guide artwork, created with the built-in image generation tool.
The generation prompt is saved in `cover-prompt.txt`.

The command-room (`images/time-travel.jpg`), tank (`images/battlefield.jpg`),
helicopter (`images/air-combat.jpg`), and joystick (`images/joystick.jpg`)
illustrations use the cover as their style reference. They were redrawn with
the same built-in tool; their prompts are saved in `illustration-prompts.json`.
The joystick retains the original button positions and labels.

Game-element and weapon illustrations are PNG exports of the recovered gameplay
sprites. To regenerate them with Python and Pillow after `make assets`, run:

```sh
python3 docs/manual/export_sprites.py
```

The exporter reads the descriptor banks in `build/assets/` and verifies their
hashes and decoded pixels. It uses a conventional six-color HGR preview at fixed
horizontal alignment, including continuous dot parity and phase-bit color
selection; it does not simulate an NTSC display. Every illustration uses the same
2× native pixel scale on a black 128×96 canvas, preserving the objects' relative
sizes. Mobile layouts display the canvases at 64×48 for a shared 1× scale.
The helicopter body and rotor are composed from their original parts.
Machine-gun fire uses the game's two-dot projectile renderer rather than a bitmap.

| Illustration | Compact display code | Recovered bank / descriptor |
| --- | --- | --- |
| Time machine | `$31` | `e000 / 49` |
| Helicopter pad | `$36` | `e000 / 54` |
| Bunker | `$14` | `e000 / 20` |
| Barrage balloon | `$12` | `e000 / 18` |
| Helicopter | `$98` + `$09` | `d000 / 1` + `e000 / 9` |
| Tank | `$2D` | `e000 / 45` |
| Soldiers and engineers | `$25` | `e000 / 37` |
| Anti-aircraft missile carrier | `$34` | `e000 / 52` |
| Demolition team vehicle | `$43` | `e000 / 67` |
| Smart missile | `$6F` | `1900 / 38` |
| Bomb | `$3A` | `e000 / 58` |
| Machine-gun round | `$F1` | Procedural marker, renderer entry `$0204` |
| Anti-aircraft gun | `$18` | `e000 / 24` |

Mappings follow the constructors and animation code in the selector-5 overlay.
These files are documentation images; the native game sources are unchanged.

The How to Play diagram (`images/game-screen.png`) is a composed illustration
using the same recovered sprites on one 280-by-192 grid, with procedural radar
markers, a balloon tether, and ground lines. It is not an emulator capture.
Regenerate the labeled diagram with:

```sh
python3 docs/manual/draw_game_screen.py
```
