#!/usr/bin/env python3
"""Decode Rescue Raiders' stage-2 packed HGR presentation screen.

The decoder is a direct model of $7000-$7059.  It emits the exact 8 KiB
Apple II HGR page plus a portable grayscale preview with square pixels.
"""

from __future__ import annotations

import argparse
import hashlib
import pathlib
import struct
import zlib


EXPECTED_STAGE2_SHA256 = "87982fdfbb4505480d088252fb63f561ec04d7bdd081169a2372f72cc6e56ed0"


def hgr_offset(y: int, x_byte: int) -> int:
    return (y & 7) * 0x400 + ((y >> 3) & 7) * 0x80 + (y >> 6) * 0x28 + x_byte


def decode(stage2: bytes) -> tuple[bytes, int]:
    if hashlib.sha256(stage2).hexdigest() != EXPECTED_STAGE2_SHA256:
        raise ValueError("stage-2 input hash does not match the canonical extraction")
    source = memoryview(stage2)[0x500:]
    cursor = 0
    values: list[int] = []
    while len(values) < 192 * 40:
        value = source[cursor]
        cursor += 1
        if value:
            values.append(value)
        else:
            count = source[cursor]
            value = source[cursor + 1]
            cursor += 2
            values.extend([value] * count)
    if len(values) != 192 * 40:
        raise ValueError("packed stream overruns the 192x40 HGR payload")

    output = bytearray(0x2000)
    # $04 selects odd/even scanlines, X walks 96 scanlines, and $02 advances
    # the byte column only after X wraps.  The packed stream is column-major.
    for index, value in enumerate(values):
        pass_index, within = divmod(index, 96 * 40)
        x_byte, half_y = divmod(within, 96)
        y = half_y * 2 + (1 if pass_index == 0 else 0)
        output[hgr_offset(y, x_byte)] = value
    return bytes(output), cursor


def write_pgm(path: pathlib.Path, hgr: bytes) -> None:
    # Double horizontal pixels to give the 280x192 Apple II display a roughly
    # square-pixel 560x192 inspection preview. Bit 7 is phase metadata.
    pixels = bytearray()
    for y in range(192):
        for x_byte in range(40):
            value = hgr[hgr_offset(y, x_byte)]
            for bit in range(7):
                pixel = 255 if value & (1 << bit) else 0
                pixels.extend((pixel, pixel))
    path.write_bytes(b"P5\n560 192\n255\n" + pixels)


def write_png(path: pathlib.Path, hgr: bytes) -> None:
    rows = []
    for y in range(192):
        row = bytearray((0,))  # PNG filter type 0
        for x_byte in range(40):
            value = hgr[hgr_offset(y, x_byte)]
            for bit in range(7):
                pixel = 255 if value & (1 << bit) else 0
                row.extend((pixel, pixel))
        rows.append(bytes(row))

    def chunk(kind: bytes, payload: bytes) -> bytes:
        body = kind + payload
        return struct.pack(">I", len(payload)) + body + struct.pack(">I", zlib.crc32(body))

    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(b"IHDR", struct.pack(">IIBBBBB", 560, 192, 8, 0, 0, 0, 0))
    png += chunk(b"IDAT", zlib.compress(b"".join(rows), 9))
    png += chunk(b"IEND", b"")
    path.write_bytes(png)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("stage2", type=pathlib.Path)
    parser.add_argument("output_dir", type=pathlib.Path)
    args = parser.parse_args()

    hgr, consumed = decode(args.stage2.read_bytes())
    args.output_dir.mkdir(parents=True, exist_ok=True)
    raw_path = args.output_dir / "stage2-presentation.hgr"
    pgm_path = args.output_dir / "stage2-presentation.pgm"
    png_path = args.output_dir / "stage2-presentation.png"
    raw_path.write_bytes(hgr)
    write_pgm(pgm_path, hgr)
    write_png(png_path, hgr)
    print(f"decoded 7680 visible bytes from {consumed} packed bytes")
    print(f"{raw_path}: sha256={hashlib.sha256(hgr).hexdigest()}")
    print(pgm_path)
    print(png_path)


if __name__ == "__main__":
    main()
