# Main-loop timing

Image: `e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8`; evidence: `E-TIMING-001`

- The main loop at `$69DD` calls the update/render wrapper at `$6A51` once on its normal iteration path.
- `$6A6C` increments `$60C1`; overflow increments `$60C2`, forming a 16-bit completed-update counter.
- No decoded selector load contains the operand bytes for `$C019`, so there is no direct vertical-blank status access in the recovered modules.
- This proves counter-relative gates, not a fixed refresh rate: the update path has variable work and no static updates-per-second value is populated.
