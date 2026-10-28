#!/usr/bin/env python3
"""Export manual illustrations from the game's recovered HGR descriptors.

Run from any directory after the repository's `make assets` target has produced
build/assets/. These PNGs are documentation previews, not native game assets.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

from PIL import Image


MANUAL = Path(__file__).resolve().parent
ROOT = MANUAL.parents[1]
ASSETS = ROOT / "build/assets"
BACKGROUND = (0, 0, 0)
WHITE = (255, 255, 255)
ICON_NATIVE_SIZE = (64, 48)
ICON_SCALE = 2
# Conventional six-color HGR preview. Parity is continuous across seven-bit
# byte boundaries. This is a fixed-alignment illustration, not an NTSC filter.
CHROMA = (((187, 51, 255), (35, 221, 62)),
          ((45, 133, 255), (255, 133, 30)))

# Compact display codes below $49 address E000; $49-$96 address 1900 after
# subtracting $49; codes at/above $97 address D000 after subtracting $97.
# See render_compact_display_sprite_a in selector5's modules/display.inc.
# Parts are (compact code, anchor X in game units, anchor Y in scanlines).
SPRITES = {
    "time-machine": [(0x31, 0, 0)],
    "helicopter-pad": [(0x36, 0, 0)],
    "bunker": [(0x14, 0, 0)],
    "barrage-balloon": [(0x12, 0, 0)],
    # Player frame 1 plus its separately rendered rotor/companion. The offsets
    # are companion_horizontal_offsets[1] and the -10 row companion adjustment.
    "helicopter": [(0x98, 0, 0), (0x09, 6, -10)],
    "tank": [(0x2D, 0, 0)],
    "soldier": [(0x25, 0, 0)],
    "missile-carrier": [(0x34, 0, 0)],
    "demolition-vehicle": [(0x43, 0, 0)],
    "missile": [(0x6F, 0, 0)],
    "bomb": [(0x3A, 0, 0)],
    "anti-aircraft-gun": [(0x18, 0, 0)],
}


def decode(payload: bytes, width: int, height: int) -> list[list[int]]:
    assert len(payload) == width * height
    return [[(payload[y * width + x // 7] >> (x % 7)) & 1
             for x in range(width * 7)] for y in range(height)]


def colorize(dots: list[list[int]], phases: list[list[int]]) -> Image.Image:
    height, width = len(dots), len(dots[0])
    image = Image.new("RGB", (width, height), BACKGROUND)
    pixels = image.load()
    for y, row in enumerate(dots):
        for x, dot in enumerate(row):
            left = row[x - 1] if x else 0
            right = row[x + 1] if x + 1 < width else 0
            if dot:
                pixels[x, y] = (WHITE if left or right
                                else CHROMA[phases[y][x]][x & 1])
            elif left and right:
                # Fill the gap between alternating dots of the same chroma.
                pixels[x, y] = CHROMA[phases[y][x - 1]][(x - 1) & 1]
    return image


def load_part(banks: dict, code: int, x: int, y: int) -> dict:
    bank, index = (("e000", code) if code < 0x49 else
                   ("1900", code - 0x49) if code < 0x97 else
                   ("d000", code - 0x97))
    item = banks[bank]["descriptors"][index]
    raw = (ASSETS / item["raw_path"]).read_bytes()
    assert hashlib.sha256(raw).hexdigest() == item["raw_sha256"]
    width, height = raw[2:4]
    dots = decode(raw[4:], width, height)
    # Independently compare with the recovery pipeline's binary pixel preview.
    with Image.open(ASSETS / item["decoded_path"]) as preview:
        assert preview.tobytes() == bytes(dot * 255 for row in dots for dot in row)
    return {"raw": raw, "width": width * 7, "height": height,
            "x": 2 * (x + item["x_offset_signed"]),
            "y": y + item["y_offset_signed"]}


def render_parts(parts: list[dict]) -> Image.Image:
    left = min(p["x"] for p in parts)
    top = min(p["y"] for p in parts)
    width = max(p["x"] + p["width"] for p in parts) - left
    height = max(p["y"] + p["height"] for p in parts) - top
    dots = [[0] * width for _ in range(height)]
    phases = [[0] * width for _ in range(height)]
    for part in parts:
        payload = part["raw"][4:]
        stride = part["width"] // 7
        for y in range(part["height"]):
            for x in range(part["width"]):
                value = payload[y * stride + x // 7]
                dx, dy = part["x"] - left + x, part["y"] - top + y
                if (value >> (x % 7)) & 1:
                    dots[dy][dx] = 1
                    phases[dy][dx] = value >> 7
    return colorize(dots, phases)


def save_icon(name: str, image: Image.Image) -> None:
    # Keep every illustration on one native dot grid. Fitting each sprite to
    # the box independently would make small objects' pixels much larger.
    bounds = image.getbbox()
    assert bounds is not None, f"Empty sprite: {name}"
    image = image.crop(bounds)
    width, height = ICON_NATIVE_SIZE
    assert image.width <= width and image.height <= height, f"Sprite does not fit: {name}"
    canvas = Image.new("RGB", ICON_NATIVE_SIZE, BACKGROUND)
    canvas.paste(image, ((width - image.width) // 2, (height - image.height) // 2))
    canvas = canvas.resize((width * ICON_SCALE, height * ICON_SCALE),
                           Image.Resampling.NEAREST)
    canvas.save(MANUAL / "images" / f"{name}.png", optimize=True)


def main() -> None:
    manifest = json.loads((ASSETS / "manifest.json").read_text())
    banks = {b["name"]: b for b in manifest["gameplay_sprites"]["effective_banks"]}
    for name, parts in SPRITES.items():
        save_icon(name, render_parts([load_part(banks, *p) for p in parts]))

    # Machine-gun fire is type $0B / display code $F1. It bypasses the bitmap
    # banks and calls $0204, which plots a two-dot marker using property/color 1.
    # Extract that marker from the actual renderer's two seven-position masks
    # and color tables, rather than substituting an unrelated weapon sprite.
    renderer = (ROOT / "build/extract/selector1-load02-0200-03ff.bin").read_bytes()
    assert renderer[4:7] == bytes.fromhex("4C EA 02")
    marker = bytes((renderer[0x1F] & renderer[0x10],
                    renderer[0x27] & renderer[0x17]))
    assert marker == bytes.fromhex("03 00")
    save_icon("machine-gun", render_parts([
        {"raw": bytes((0, 0, 2, 1)) + marker,
         "width": 14, "height": 1, "x": 0, "y": 0}]))
    print("Exported 13 native gameplay illustrations to docs/manual/images/.")


if __name__ == "__main__":
    main()
