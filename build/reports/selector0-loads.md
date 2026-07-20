# Stage3 selector load scripts

The loader decrements buffer page and logical sector together; crossing sector 0 decrements the track and resumes at sector 15.

## Selector 0

Stream: `$423C`; terminal entry: `$6000`.

| # | Source start | Count | Destination |
| ---: | --- | ---: | --- |
| 0 | track 20, logical sector 15 | 48 | `$D000-$FFFF` |
| 1 | track 17, logical sector 15 | 2 | `$4400-$45FF` |
| 2 | track 11, logical sector 0 | 1 | `$0400-$04FF` |
| 3 | track 29, logical sector 7 | 24 | `$0800-$1FFF` |
| 4 | track 17, logical sector 13 | 3 | `$7800-$7AFF` |
| 5 | track 11, logical sector 12 | 8 | `$6000-$67FF` |

## Selector 1

Stream: `$4260`; terminal entry: `$6900`.

| # | Source start | Count | Destination |
| ---: | --- | ---: | --- |
| 0 | track 17, logical sector 15 | 2 | `$4400-$45FF` |
| 1 | track 11, logical sector 0 | 1 | `$0400-$04FF` |
| 2 | track 11, logical sector 4 | 2 | `$0200-$03FF` |
| 3 | track 11, logical sector 2 | 2 | `$0500-$06FF` |
| 4 | track 12, logical sector 9 | 1 | `$6900-$69FF` |
| 5 | track 33, logical sector 1 | 18 | `$0700-$18FF` |
| 6 | track 0, logical sector 15 | 1 | `$0400-$04FF` |

## Selector 2

Stream: `$4287`; terminal entry: `$8000`.

| # | Source start | Count | Destination |
| ---: | --- | ---: | --- |
| 0 | track 30, logical sector 3 | 4 | `$8000-$83FF` |

## Selector 3

Stream: `$428F`; terminal entry: `$8000`.

| # | Source start | Count | Destination |
| ---: | --- | ---: | --- |
| 0 | track 31, logical sector 6 | 7 | `$8000-$86FF` |
| 1 | track 18, logical sector 3 | 4 | `$A100-$A4FF` |
| 2 | track 11, logical sector 13 | 1 | `$A000-$A0FF` |
| 3 | track 7, logical sector 15 | 4 | `$9C00-$9FFF` |
| 4 | track 7, logical sector 3 | 4 | `$7C00-$7FFF` |

## Selector 4

Stream: `$42AB`; terminal entry: `$8000`.

| # | Source start | Count | Destination |
| ---: | --- | ---: | --- |
| 0 | track 33, logical sector 15 | 8 | `$8000-$87FF` |
| 1 | track 18, logical sector 3 | 4 | `$A100-$A4FF` |
| 2 | track 11, logical sector 13 | 1 | `$A000-$A0FF` |

## Selector 5

Stream: `$42BD`; terminal entry: `$0000`.

| # | Source start | Count | Destination |
| ---: | --- | ---: | --- |
| 0 | track 17, logical sector 10 | 82 | `$6900-$BAFF` |

## Selector 6

Stream: `$42C5`; terminal entry: `$8000`.

| # | Source start | Count | Destination |
| ---: | --- | ---: | --- |
| 0 | track 21, logical sector 15 | 8 | `$8000-$87FF` |
| 1 | track 18, logical sector 3 | 4 | `$A100-$A4FF` |
| 2 | track 17, logical sector 13 | 3 | `$7800-$7AFF` |
| 3 | track 11, logical sector 13 | 1 | `$A000-$A0FF` |
