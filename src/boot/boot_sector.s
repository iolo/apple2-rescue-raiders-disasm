; Rescue Raiders first stored sector, source-exact at $0800.
; The Disk II boot ROM supplies zero-page state and enters at boot_entry.
.setcpu "6502"
.segment "BOOT"

.include "boot_page.inc"
emit_rescue_raiders_boot_page
