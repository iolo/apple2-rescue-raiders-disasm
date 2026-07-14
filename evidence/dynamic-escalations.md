# Approval-gated dynamic escalations

No emulator request is authorized or performed by this document. It records the
smallest trace that could resolve a static blocker while preserving the
canonical disk and the static-first evidence boundary.

## DYN-TIMING-001: completed updates per second

Static evidence `E-TIMING-001` proves that `$60C1:$60C2` advances once after
the update/render wrapper at `$6A51` completes. It also proves that decoded
selector loads contain no direct `$C019` operand. Variable object and rendering
work prevents a defensible cycle-count conversion to seconds.

If the user approves a first game trace:

1. Confirm apple2ts remote control and debugging are enabled, then read machine
   and drive state before any mutation.
2. Preserve a reversible pre-trace state and mount only the pinned canonical
   image whose SHA-256 is
   `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`.
3. Reach `FLOW-80` without memory patches. Record machine model and speed mode.
4. Break/count only at `$6A6C`, the confirmed `$60C1` increment. Do not write
   registers or memory and do not bypass input, protection, or game logic.
5. Measure at least three non-overlapping wall-clock intervals in a quiet scene
   and three in a busy scene. Record counts and elapsed time separately rather
   than averaging away workload sensitivity.
6. Re-read machine state, remove the breakpoint, and verify the disk remains
   unmodified.

Acceptance requires repeatable raw observations with model, emulator speed,
scene conditions, interval duration, and breakpoint counts. A workload-varying
rate must remain a measured range; it must not be promoted to a universal
original constant. Until approved and observed, every generated `updates_per_second`
field remains `null`.
