# Embedded source fragments

The canonical image contains tokenized assembly-source material in addition to
executable bytes. These fragments are useful symbol hints, but must still match
the executing binary before promotion.

The generated extractor preserves every unknown tokenizer byte as `{HH}` and
adds mnemonic hints only for tokens independently identified from matching
instruction behavior. It does not silently turn a guessed token into source.

At raw image offsets `$1EE20-$1EF8B` (track 30, principally file sector 14), a
banner identifies `Rescue Raiders // PROTECTION` and defines:

```text
INTER  = $BFC8
IOB    = $BFE8
SLT    = IOB+1
TRK    = SLT+1
SEC    = TRK+1
BUFP   = SEC+1
CMD    = BUFP+1
RWTS0  = $BB00
```

The fragment's protection-specific logic is outside this recovery's scope. The
parameter symbols are promoted because the active loader independently reads
and writes those exact addresses with the matching slot, track, sector, buffer
page, and command roles. Other names in embedded source remain reference hints
until the same convergence exists.
