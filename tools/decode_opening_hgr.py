#!/usr/bin/env python3
"""Extract matched Rescue Raiders opening/map screens from packed disk data."""

from __future__ import annotations

import argparse
import hashlib
import pathlib

try:
    from .decode_stage2_hgr import hgr_offset, write_pgm, write_png
except ImportError:  # Direct execution places tools/ rather than the repo on sys.path.
    from decode_stage2_hgr import hgr_offset, write_pgm, write_png


EXPECTED_IMAGE_SHA256 = "e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8"
TRACK_SIZE = 16 * 256
POINTER_TABLE_OFFSET = TRACK_SIZE
VISIBLE_SIZE = 192 * 40


def decode_stream(image: bytes, source_offset: int) -> tuple[bytes, int]:
    """Model the literal/run decoder at selector-0 $789E-$7913."""
    output = bytearray(0x2000)
    cursor = source_offset
    output_count = 0

    # The decoder draws columns right-to-left.  Its first call emits even
    # scanlines bottom-to-top; the second emits odd scanlines bottom-to-top.
    for start_x in (0xC0, 0xC1):
        for column in range(39, -1, -1):
            row_index = start_x
            while row_index >= 2:
                command = image[cursor]
                cursor += 1
                if command & 0x80:
                    count = command & 0x7F
                    for _ in range(count):
                        row_index -= 2
                        output[hgr_offset(row_index, column)] = image[cursor]
                        cursor += 1
                        output_count += 1
                else:
                    count = command or 256
                    value = image[cursor]
                    cursor += 1
                    for _ in range(count):
                        row_index -= 2
                        output[hgr_offset(row_index, column)] = value
                        output_count += 1
            if row_index != 0 and row_index != 1:
                raise ValueError("packed command crosses an HGR column boundary")

    if output_count != VISIBLE_SIZE:
        raise ValueError(f"decoded {output_count} bytes, expected {VISIBLE_SIZE}")
    return bytes(output), cursor - source_offset


def visible_bytes(hgr: bytes) -> bytes:
    return bytes(hgr[hgr_offset(y, x)] for y in range(192) for x in range(40))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("disk_image", type=pathlib.Path)
    parser.add_argument("output_dir", type=pathlib.Path)
    parser.add_argument(
        "--reference-dir",
        type=pathlib.Path,
        help="optional directory containing opening1.hgr and opening2.hgr",
    )
    args = parser.parse_args()

    image = args.disk_image.read_bytes()
    if hashlib.sha256(image).hexdigest() != EXPECTED_IMAGE_SHA256:
        raise ValueError("disk image hash does not match the canonical image")
    args.output_dir.mkdir(parents=True, exist_ok=True)

    screens = (
        (0, "opening1-decoded", "opening1.hgr"),
        (1, "opening2-decoded", "opening2.hgr"),
        (2, "campaign-map-base-decoded", "map.hgr"),
    )
    for selector, stem, reference_name in screens:
        table_offset = POINTER_TABLE_OFFSET + selector * 2
        relative_offset = image[table_offset] | image[table_offset + 1] << 8
        source_offset = POINTER_TABLE_OFFSET + relative_offset
        hgr, packed_size = decode_stream(image, source_offset)
        raw_path = args.output_dir / f"{stem}.hgr"
        pgm_path = args.output_dir / f"{stem}.pgm"
        png_path = args.output_dir / f"{stem}.png"
        raw_path.write_bytes(hgr)
        write_pgm(pgm_path, hgr)
        write_png(png_path, hgr)

        reference_result = ""
        if args.reference_dir:
            reference_path = args.reference_dir / reference_name
            reference = reference_path.read_bytes()
            if selector < 2:
                if visible_bytes(reference) != visible_bytes(hgr):
                    raise ValueError(f"visible bytes do not match {reference_path}")
                reference_result = f"; visible bytes match {reference_path}"
            else:
                differences = [
                    (y, x)
                    for y in range(192)
                    for x in range(40)
                    if reference[hgr_offset(y, x)] != hgr[hgr_offset(y, x)]
                ]
                # The capture adds centered "Cherbourg" at text row 23.  Its
                # eight glyph rows occupy HGR scanlines 184..191, columns 15..23.
                if not differences or any(
                    not (184 <= y <= 191 and 15 <= x <= 23)
                    for y, x in differences
                ):
                    raise ValueError(f"map base differs outside city text in {reference_path}")
                reference_result = (
                    f"; base matches {reference_path} outside "
                    f"{len(differences)} rendered city bytes"
                )

        track, within_track = divmod(source_offset, TRACK_SIZE)
        sector, within_sector = divmod(within_track, 256)
        print(
            f"{stem}: selector={selector}, offset=${source_offset:05X}, "
            f"track={track}, sector={sector}, within=${within_sector:02X}, "
            f"packed={packed_size}, hgr_sha256={hashlib.sha256(hgr).hexdigest()}"
            f"{reference_result}"
        )


if __name__ == "__main__":
    main()
