#!/usr/bin/env python3
"""Compose the manual's game-screen diagram from recovered gameplay sprites."""

from __future__ import annotations

import json

from PIL import Image, ImageDraw, ImageFont

from export_sprites import ASSETS, MANUAL, SPRITES, load_part, render_parts


PAPER = "#f4f1e9"
INK = "#454b40"
SCREEN = "#0d120f"
WHITE = (239, 242, 234)
GREEN = (35, 221, 62)
VIOLET = (187, 51, 255)
ORANGE = (255, 133, 30)
SCREEN_ORIGIN = (176, 24)
OUTPUT = MANUAL / "images/game-screen.png"


def sprite_at(screen: Image.Image, banks: dict, code: int, x: int, y: int) -> None:
    """Place one descriptor at its game anchor, retaining its signed offsets."""
    part = load_part(banks, code, x, y)
    assert 0 <= part["x"] and part["x"] + part["width"] <= screen.width
    assert 0 <= part["y"] and part["y"] + part["height"] <= screen.height
    image = render_parts([part])
    # The game ORs sprite dots over the existing scene. Black source dots do
    # not erase the background or objects already drawn underneath them.
    mask = image.convert("L").point(lambda value: 255 if value else 0)
    screen.paste(image, (part["x"], part["y"]), mask)


def helicopter_at(screen: Image.Image, banks: dict, x: int, y: int) -> None:
    for code, offset_x, offset_y in SPRITES["helicopter"]:
        sprite_at(screen, banks, code, x + offset_x, y + offset_y)


def compose_scene(banks: dict) -> Image.Image:
    # One shared 280-by-192 dot grid keeps all game objects at the same scale.
    screen = Image.new("RGB", (280, 192), SCREEN)
    draw = ImageDraw.Draw(screen)

    # The tactical radar uses procedural color-coded markers, not the larger
    # play-area bitmaps. Helicopters are the larger white, two-row markers.
    draw.line((7, 7, 272, 7), fill=WHITE)
    draw.line((7, 16, 272, 16), fill=WHITE)
    for x, color in [(13, VIOLET), (25, VIOLET), (47, ORANGE), (61, VIOLET),
                     (98, GREEN), (118, GREEN), (157, GREEN), (185, GREEN),
                     (202, GREEN), (231, GREEN), (263, GREEN)]:
        draw.line((x, 13, x + 1, 13), fill=color)
    for x in (69, 173):
        draw.rectangle((x, 10, x + 1, 11), fill=WHITE)
    draw.point((135, 11), fill=VIOLET)

    # Ground and tether are procedural lines, as in the game's renderer.
    ground = 182
    draw.line((5, ground, 274, ground), fill=WHITE)
    draw.line((5, ground + 1, 274, ground + 1), fill=GREEN)
    draw.line((67, 123, 67, 166), fill=WHITE)

    # Match the original manual's composition: a bunker with a tethered
    # balloon at left, the player's helicopter centrally, parachuting infantry,
    # and tanks/missile carrier advancing along the ground.
    sprite_at(screen, banks, 0x2D, 4, ground)
    sprite_at(screen, banks, 0x14, 26, ground)
    sprite_at(screen, banks, 0x12, 29, 123)
    helicopter_at(screen, banks, 58, 96)
    sprite_at(screen, banks, 0x07, 30, 47)
    sprite_at(screen, banks, 0x0B, 35, 37)
    for code, x, y in [(0xA2, 65, 148), (0x5E, 74, 157),
                       (0xA3, 81, 145), (0x5E, 111, 137)]:
        sprite_at(screen, banks, code, x, y)
    sprite_at(screen, banks, 0x3A, 57, 130)
    sprite_at(screen, banks, 0x25, 52, ground)
    sprite_at(screen, banks, 0x27, 57, ground)
    sprite_at(screen, banks, 0x2D, 79, ground)
    sprite_at(screen, banks, 0x2E, 101, ground)
    sprite_at(screen, banks, 0x34, 122, ground)
    return screen


def main() -> None:
    manifest = json.loads((ASSETS / "manifest.json").read_text())
    banks = {b["name"]: b for b in manifest["gameplay_sprites"]["effective_banks"]}
    screen = compose_scene(banks)
    scale = 2
    diagram = Image.new("RGB", (760 * scale, 432 * scale), PAPER)
    origin = tuple(value * scale for value in SCREEN_ORIGIN)
    # Integer nearest-neighbor scaling preserves the actual sprite dots.
    enlarged = screen.resize((280 * 2 * scale, 192 * 2 * scale),
                             Image.Resampling.NEAREST)
    diagram.paste(enlarged, origin)
    draw = ImageDraw.Draw(diagram)
    font = ImageFont.truetype(
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 20 * scale)
    for label, native_y in [("RADAR", 12), ("PLAY AREA", 94), ("GROUND", 182)]:
        y = (SCREEN_ORIGIN[1] + native_y * 2) * scale
        draw.text((20 * scale, y), label, font=font, fill=INK, anchor="lm")
        end_x = origin[0] - 2 * scale
        draw.line((146 * scale, y, end_x, y), fill=INK, width=scale)
        draw.line((end_x - 6 * scale, y - 5 * scale, end_x, y,
                   end_x - 6 * scale, y + 5 * scale), fill=INK, width=scale)
    draw.rectangle((origin[0] - 1, origin[1] - 1,
                    origin[0] + enlarged.width, origin[1] + enlarged.height),
                   outline="#9a9d8e", width=1)
    diagram.save(OUTPUT, optimize=True)
    print(f"Wrote {OUTPUT.relative_to(MANUAL)} ({diagram.width}x{diagram.height}).")


if __name__ == "__main__":
    main()
