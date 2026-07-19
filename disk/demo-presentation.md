# Demo presentation text and logos

`original/demo.txt` is an emulator-screen transcription of selector 5's
seven-phase presentation loop.  It ties the graphical compact-sprite calls and
the high-bit inline records to the text that is actually visible at runtime.

## Presentation sequence

`update_presentation_phase` at `$B893` dispatches through the overlapping
callback tables at `$BAE7/$BAEE`.  Each phase lasts 32 rendered frames; the
counter decrements from 7 to 1 and then wraps.  Starting at phase 1, as in the
capture, the visible sequence is:

| Phase | Callback | Captured output | Storage |
| ---: | --- | --- | --- |
| 1 | `$B9CD` `display_proudly_presents` | graphical `SIR-TECH`, then `PROUDLY PRESENTS` | compact sprite `$96`; inline high-bit text |
| 7 | `$B934` `display_rescue_raiders_logo` | graphical `RESCUE RAIDERS` | compact sprites `$3F` and `$40`, placed side by side |
| 6 | `$B951` `display_hello_herrb` | `HELLO HERRB` | inline high-bit text |
| 5 | `$B969` `display_presentation_message` | `THIS MESSAGE BROUGHT TO YOU BY` | inline high-bit text |
| 4 | `$B992` `display_creator_names` | `DARRELL AND JON` | inline high-bit text |
| 3 | `$B9AD` `display_last_score` | `LAST SCORE 0` initially | inline heading plus four bytes at `$01FC-$01FF` |
| 2 | `$B8BA` `display_high_scores` | heading, five names, and five scores | inline heading plus the T0/S15 data at `$0400-$0459` |

The two logo strings cannot be found as contiguous ASCII or high-bit text on
disk because they are graphics.  This explains why a text-only disk search
finds `PROUDLY PRESENTS` and `HIGH SCORES`, but not `SIR-TECH` or
`RESCUE RAIDERS`.

## Default high-score sector

The last load in `selector1_stream` reads track 0, logical sector 15 into
`$0400-$04FF`.  In the file-linear image this is raw offset `$00F00-$00FFF`.
The sector begins with five fixed-width, 16-byte Apple high-bit names followed
by five two-byte packed-BCD scores:

| RAM | Name | Score RAM | Packed BCD | Displayed score |
| --- | --- | --- | --- | ---: |
| `$0400-$040F` | `PAT PETE DARRELL` | `$0450-$0451` | `$87 $27` | 8727 |
| `$0410-$041F` | `PAT THE GREATER ` | `$0452-$0453` | `$86 $89` | 8689 |
| `$0420-$042F` | `PATRICK THE BEST` | `$0454-$0455` | `$74 $47` | 7447 |
| `$0430-$043F` | `PETER THE GREAT ` | `$0456-$0457` | `$15 $23` | 1523 |
| `$0440-$044F` | `PAT THE GREAT   ` | `$0458-$0459` | `$12 $45` | 1245 |

The renderer visits records 4 through 0 but places them on rows 12 through 8,
so they appear top-to-bottom in descending score order.  `$0458/$0459`, the
lowest stored score, is also the packed-BCD qualification threshold used by
`check_campaign_threshold`.

The remaining high-bit bytes at `$045A-$04E2` contain an undisplayed tampering
warning (including the original spellings `MODIFING` and `ARN'T`).  It is data
in the same sector, not one of the seven captured presentation screens.

## Encoding

Inline records use `$01,column,row` to reposition the display cursor and `$00`
to terminate.  Their text bytes have the Apple high bit set.  The high-score
names are fixed-width rather than zero-terminated, while their values are four
packed decimal nibbles rather than character digits.
