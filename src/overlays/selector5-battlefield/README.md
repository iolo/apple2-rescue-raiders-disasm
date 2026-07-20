# Selector 5 battlefield overlay

`flight.s` is the assembly entry point for the complete `$6900-$BAFF`
selector-5 load. It defines shared hardware and workspace symbols, then includes
the following fragments in original address order:

| Include | Responsibility |
| --- | --- |
| `modules/battlefield_flow.inc` | Entry vectors, battlefield lifecycle, disk reads, counters, and scoring |
| `modules/object_construction.inc` | Object allocation, constructors, formations, and constructor tables |
| `modules/object_updates.inc` | Active-list maintenance and primary per-type object behavior |
| `modules/secondary_behaviors.inc` | Secondary targeting, effects, projectiles, and behavior tables |
| `modules/input_and_player.inc` | Keyboard/paddle input, hidden commands, helicopter control, weapons, service, and motion |
| `modules/strategy_core.inc` | Strategy entry points, coordinator, and first-phase handlers |
| `modules/strategy_actions.inc` | Strategy decisions, actions, searches, and movement helpers |
| `modules/strategy_data.inc` | Strategy scripts, dispatch tables, rankings, and workspace |
| `modules/damage_and_collisions.inc` | Damage, collision traversal, destruction handlers, and aftermath tables |
| `modules/display.inc` | Battlefield HUD, object rendering, presentation screens, and display tables |

These files are include fragments rather than independent object modules. They
share labels and one `SELECTOR5` segment, so their include order is part of the
byte-exact source representation. Run `make disassemble verify` after moving a
boundary or changing an include.
