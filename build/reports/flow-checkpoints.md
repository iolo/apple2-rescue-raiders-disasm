# Flow checkpoint coverage

| Checkpoint | Status | Evidence | Static association |
| --- | --- | --- | --- |
| `FLOW-00` | `confirmed` | `E-BOOT-001` | Cold boot loads the first sector at $0800 and enters $0801. |
| `FLOW-10` | `confirmed` | `E-FLOW-010` | Boot code fills text page 1 with zero bytes (inverted @ glyphs) and writes high-bit R1.2 at $07D3. |
| `FLOW-20` | `unresolved-out-of-scope-wrapper` | — | The user-observed cracked-image prompt has no exact static text anchor; copy-protection and crack-wrapper reconstruction are out of scope. |
| `FLOW-30` | `confirmed` | `E-FLOW-030`, `E-FLOW-SOURCE-008` | Selector 0 entry $6000 directly calls the $0800 graphics/title animator; its timed event table streams and renders the copyright notice at $11A7, exits the opening, and then requests selector 1. |
| `FLOW-40` | `confirmed` | `E-FLOW-040` | Selector 5 directly passes BATTLE OVER, HIGH SCORES, and PROUDLY PRESENTS inline records to its text renderer. |
| `FLOW-50` | `confirmed` | `E-FLOW-050`, `E-FLOW-START-001` | High-bit S ends the demo pass, toggles into interactive mode, assigns campaign index 1, and admits the selector-6 briefing call. |
| `FLOW-60` | `confirmed` | `E-FLOW-060` | Selector 6 directly consumes the briefing strings after an inline-message call. |
| `FLOW-70` | `confirmed` | `E-FLOW-070`, `E-FLOW-START-001` | Selector 6 indexes an eight-entry city pointer table, centers the selected name, displays it after briefing, and waits for continue input. |
| `FLOW-80` | `confirmed` | `E-FLOW-080`, `E-FLOW-START-001` | At campaign index 1 selector 6 dispatches selector 5, whose battlefield input path reads joystick buttons and analog paddles. |
