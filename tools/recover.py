#!/usr/bin/env python3
"""Deterministic static baseline tooling for the Rescue Raiders sector image."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
import pathlib
import shutil
import subprocess
import sys

TRACKS = 35
SECTORS = 16
SECTOR_SIZE = 256
IMAGE_SIZE = TRACKS * SECTORS * SECTOR_SIZE
EXPECTED_SHA256 = "e87a3807667347f4434a78260e7e2791a7e6e45c4193e90f63dcb6d7a94059e8"
MAPPINGS = {
    "file-linear": tuple(range(16)),
    "physical-indexed-dos33": (0, 13, 11, 9, 7, 5, 3, 1, 14, 12, 10, 8, 6, 4, 2, 15),
    "physical-indexed-prodos": (0, 2, 4, 6, 8, 10, 12, 14, 1, 3, 5, 7, 9, 11, 13, 15),
}
SOURCE_TOKEN_HINTS = {
    0xA5: "RTS", 0xC3: "BIT", 0xC4: "CMP", 0xC8: "EOR",
    0xCA: "JMP", 0xCB: "JSR", 0xCD: "LDA", 0xD0: "STA",
    0xD9: "EQU", 0xDA: "ORG", 0xDB: "OBJ",
}
FLOW_ANCHORS = {
    "FLOW-30": (
        "COPYRIGHT (C) 1984 ALL RIGHTS RESERVED",
    ),
    "FLOW-40": (
        "HIGH SCORES",
        "PROUDLY PRESENTS",
        "BATTLE OVER",
    ),
    "FLOW-60": (
        "Emergency transmission>",
        "Terrorists have been found at",
        "Prepare for action",
    ),
    "FLOW-70": (
        "Cherbourg",
        "Brussels",
        "Antwerp",
    ),
}


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def read_image(path: pathlib.Path) -> bytes:
    data = path.read_bytes()
    if len(data) != IMAGE_SIZE:
        raise ValueError(f"expected {IMAGE_SIZE} bytes, found {len(data)}")
    return data


def coordinate_to_offset(track: int, sector: int, within: int = 0) -> int:
    if not (0 <= track < TRACKS and 0 <= sector < SECTORS and 0 <= within < SECTOR_SIZE):
        raise ValueError("coordinate outside 35x16x256 image")
    return ((track * SECTORS) + sector) * SECTOR_SIZE + within


def offset_to_coordinate(offset: int) -> tuple[int, int, int]:
    if not 0 <= offset < IMAGE_SIZE:
        raise ValueError("offset outside image")
    sector_index, within = divmod(offset, SECTOR_SIZE)
    track, sector = divmod(sector_index, SECTORS)
    return track, sector, within


def to_logical(data: bytes, mapping_name: str) -> bytes:
    mapping = MAPPINGS[mapping_name]
    out = bytearray()
    for track in range(TRACKS):
        for stored_sector in mapping:
            start = coordinate_to_offset(track, stored_sector)
            out.extend(data[start : start + SECTOR_SIZE])
    return bytes(out)


def from_logical(data: bytes, mapping_name: str) -> bytes:
    if len(data) != IMAGE_SIZE:
        raise ValueError("logical image has wrong size")
    mapping = MAPPINGS[mapping_name]
    out = bytearray(IMAGE_SIZE)
    cursor = 0
    for track in range(TRACKS):
        for stored_sector in mapping:
            start = coordinate_to_offset(track, stored_sector)
            out[start : start + SECTOR_SIZE] = data[cursor : cursor + SECTOR_SIZE]
            cursor += SECTOR_SIZE
    return bytes(out)


def entropy(chunk: bytes) -> float:
    counts = [0] * 256
    for value in chunk:
        counts[value] += 1
    return -sum((n / len(chunk)) * math.log2(n / len(chunk)) for n in counts if n)


def backward_load(data: bytes, track: int, sector: int, page: int, count: int) -> tuple[bytes, list[dict[str, int]]]:
    """Model stage3 command 3 and return bytes ordered by ascending memory."""
    pages: dict[int, bytes] = {}
    reads = []
    for _ in range(count):
        if not (0 <= track < TRACKS and 0 <= sector < SECTORS and 0 <= page <= 0xFF):
            raise ValueError("loader script walks outside modeled disk or memory")
        start = coordinate_to_offset(track, sector)
        pages[page] = data[start : start + SECTOR_SIZE]
        reads.append({"track": track, "logical_sector": sector, "file_sector": sector, "page": page})
        page -= 1
        if sector == 0:
            track -= 1
            sector = 15
        else:
            sector -= 1
    ordered_pages = sorted(pages)
    if ordered_pages != list(range(ordered_pages[0], ordered_pages[-1] + 1)):
        raise ValueError("modeled load is not memory-contiguous")
    return b"".join(pages[p] for p in ordered_pages), reads


def decode_selector(data: bytes, selector: int) -> dict[str, object]:
    """Decode one stage3 stream selected by entry accumulator value 0..6."""
    if not 0 <= selector <= 6:
        raise ValueError("stage3 selector outside known pointer table")
    stage3_start = coordinate_to_offset(21, 0)
    stage3 = data[stage3_start : stage3_start + 4 * SECTOR_SIZE]
    pointer_offset = 0x422E - 0x4000 + selector * 2
    stream_address = stage3[pointer_offset] | (stage3[pointer_offset + 1] << 8)
    cursor = stream_address - 0x4000
    commands = []
    loads = []
    while True:
        opcode = stage3[cursor]
        cursor += 1
        if opcode == 0:
            break
        if opcode == 3:
            track, sector, page, count = stage3[cursor : cursor + 4]
            cursor += 4
            payload, reads = backward_load(data, track, sector, page, count)
            load = {
                "index": len(loads), "track": track, "sector": sector, "page": page,
                "count": count, "memory_start": min(r["page"] for r in reads) * 256,
                "memory_end": (max(r["page"] for r in reads) + 1) * 256 - 1,
                "reads": reads, "sha256": sha256(payload),
            }
            loads.append((load, payload))
            commands.append({"opcode": opcode, "kind": "backward_load", "load_index": load["index"]})
        elif opcode in (1, 2, 4):
            commands.append({"opcode": opcode, "kind": {1: "hardware_probe", 2: "initialize", 4: "relocate_or_install"}[opcode]})
        elif opcode == 5:
            expected = stage3[cursor]
            cursor += 1
            commands.append({"opcode": opcode, "kind": "conditional_next_load", "expected_hardware_flag": expected})
        else:
            raise ValueError(f"unsupported selector-{selector} opcode {opcode} at ${0x4000 + cursor - 1:04X}")
    entry = stage3[cursor] | (stage3[cursor + 1] << 8)
    return {"selector": selector, "stream_address": stream_address, "end_address": 0x4000 + cursor + 2, "entry_point": entry, "commands": commands, "loads": loads}


def decode_selector0(data: bytes) -> dict[str, object]:
    """Compatibility wrapper used by focused boot-path tests."""
    return decode_selector(data, 0)


def scan_tokenized_source(data: bytes, min_records: int = 3, min_bytes: int = 32) -> list[dict[str, object]]:
    """Find runs of length-prefixed, CR-terminated source records."""
    blocks = []
    position = 0
    while position < len(data):
        start = position
        records = []
        while position < len(data):
            length = data[position]
            if not 1 <= length <= 127 or position + length >= len(data) or data[position + length] != 0x0D:
                break
            payload = data[position + 1 : position + length]
            if 0x0D in payload:
                break
            records.append({"offset": position, "length": length, "payload": payload})
            position += length + 1
        if len(records) >= min_records and position - start >= min_bytes:
            blocks.append({"offset_start": start, "offset_end": position - 1, "records": records})
        else:
            position = start + 1
    return blocks


def render_source_payload(payload: bytes) -> str:
    parts = []
    for byte in payload:
        if 0x20 <= byte <= 0x7E:
            parts.append(chr(byte))
        elif byte in SOURCE_TOKEN_HINTS:
            parts.append(f"{{{byte:02X}:{SOURCE_TOKEN_HINTS[byte]}}}")
        else:
            parts.append(f"{{{byte:02X}}}")
    return "".join(parts)


def normalized_apple_text(data: bytes) -> bytes:
    return bytes((byte & 0x7F) if byte >= 0x80 else byte for byte in data)


def flow_anchor_records(data: bytes) -> list[dict[str, object]]:
    """Locate exact ASCII/high-bit flow anchors and map them through selectors."""
    normalized = normalized_apple_text(data)
    selectors = [decode_selector(data, index) for index in range(7)]
    records = []
    for flow_id, anchors in FLOW_ANCHORS.items():
        for anchor in anchors:
            needle = anchor.encode("ascii")
            position = 0
            while True:
                position = normalized.find(needle, position)
                if position < 0:
                    break
                raw = data[position : position + len(needle)]
                encoding = "ascii" if raw == needle else "apple-high-bit"
                track, file_sector, within = offset_to_coordinate(position)
                mappings = []
                for selector in selectors:
                    for load, _payload in selector["loads"]:
                        for read in load["reads"]:
                            if read["track"] == track and read["file_sector"] == file_sector:
                                mappings.append({"selector": selector["selector"], "address": read["page"] * 256 + within})
                records.append({
                    "flow_id": flow_id, "text": anchor, "encoding": encoding,
                    "offset": position, "track": track, "file_sector": file_sector,
                    "within_sector": within, "mappings": mappings,
                })
                position += 1
    return records


def campaign_flow_mechanics(data: bytes) -> dict[str, object]:
    """Export the statically bounded demo -> briefing/map -> battle chain."""
    selector5 = decode_selector(data, 5)
    load5, payload5 = selector5["loads"][0]
    selector6 = decode_selector(data, 6)
    load6, payload6 = selector6["loads"][0]
    if (load5["memory_start"], load5["memory_end"]) != (0x6900, 0xBAFF):
        raise ValueError("selector-5 gameplay overlay mapping drift")
    if (load6["memory_start"], load6["memory_end"]) != (0x8000, 0x87FF):
        raise ValueError("selector-6 briefing overlay mapping drift")

    def expect(payload: bytes, origin: int, address: int, expected: bytes, label: str) -> None:
        actual = payload[address - origin : address - origin + len(expected)]
        if actual != expected:
            raise ValueError(f"{label} drift at ${address:04X}")

    expect(payload5, 0x6900, 0x6991, bytes.fromhex("20dd69adb66049018db6604c9169"), "alternating demo/player loop")
    expect(payload5, 0x6900, 0x6AA2, bytes.fromhex("a9008d01608d00608dbc60"), "battlefield state reset")
    expect(payload5, 0x6900, 0x6B4F, bytes.fromhex("adb660d00a2cbb603005a90620c8bf"), "selector-6 briefing gate")
    expect(payload5, 0x6900, 0x8F87, bytes.fromhex("a9008dbb60eeb060eeb86060"), "S transition state change")
    expect(payload5, 0x6900, 0x90B8, bytes.fromhex("88c9d3d00620878f4cf690"), "high-bit S dispatch")
    expect(payload6, 0x8000, 0x8086, bytes.fromhex("a505c909f00c20908120c48020e0814c9b80"), "selector-6 presentation dispatch")
    expect(payload6, 0x8000, 0x80A0, bytes.fromhex("c901f007ada1808501a9fe1869044cc8bf"), "selector-6 continuation dispatch")
    expect(payload6, 0x8000, 0x81E0, bytes.fromhex("20a0822000d8a9008d53878d5987a9178502207082"), "map city presentation")
    expect(payload6, 0x8000, 0x8270, bytes.fromhex("a405b9a7868570b9af868571"), "city pointer consumer")

    city_names = ["Cherbourg", "Caen", "Saint-Lô", "Orléans", "Paris", "Verdun", "Brussels", "Antwerp"]
    city_records = []
    for stage, name in enumerate(city_names, 1):
        low = payload6[0x86A7 - 0x8000 + stage]
        high = payload6[0x86AF - 0x8000 + stage]
        address = low | (high << 8)
        length = payload6[address - 0x8000]
        encoded = payload6[address - 0x8000 + 1 : address - 0x8000 + 1 + length]
        city_records.append({
            "campaign_index": stage,
            "name": name,
            "address_hex": f"{address:04X}",
            "encoded_hex": encoded.hex().upper(),
        })

    return {
        "image_sha256": sha256(data),
        "evidence": ["E-FLOW-050", "E-FLOW-060", "E-FLOW-070", "E-FLOW-080", "E-FLOW-START-001"],
        "start_transition": [
            "$90B9 compares the demo keyboard byte with high-bit S ($D3).",
            "$8F87 clears $60BB and increments $60B0/$60B8, ending the current demo pass.",
            "$6991 toggles $60B6 from demo (1) to interactive (0).",
            "$6AA2 assigns campaign index $05 = 1; $6B4F then calls INTER with selector 6 because $60BB is nonnegative.",
        ],
        "selector6_sequence": [
            "$8190 prepares later-stage map progression when campaign index is at least 2.",
            "$80C4 presents the Emergency transmission briefing.",
            "$81E0 selects and displays the campaign city and waits for continue input.",
            "At campaign index 1, $80A0-$80B0 calls INTER selector 5, returning to battlefield setup.",
        ],
        "campaign_cities": city_records,
        "battlefield_input": {
            "selector": 5,
            "joystick_buttons": ["C061", "C062"],
            "analog_paddles": ["C064", "C065"],
            "paddle_timer_reset": "C070",
        },
    }


def helicopter_flight_mechanics(data: bytes) -> dict[str, object]:
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")
    table_bytes = payload[0x998E - 0x6900 : 0x998E - 0x6900 + 26]
    velocity_table = [byte if byte < 0x80 else byte - 0x100 for byte in table_bytes]
    expected = [-7, -7, -6, -5, -4, -3, -2, -2, -1, -1, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 5, 6, 7, 7, 7]
    if velocity_table != expected:
        raise ValueError("horizontal joystick table drift")
    return {
        "image_sha256": sha256(data),
        "evidence": ["E-FLIGHT-001", "E-FLIGHT-002"],
        "machine_assumption": "standard 6502-era Apple II game I/O: C064/C065 analog paddles, C070 timer reset",
        "update_cadence": None,
        "raw_sample_cap": 100,
        "horizontal": {
            "sample_address": "C064", "index_shift": 2, "table_address": "998E",
            "target_velocity_signed": velocity_table, "acceleration_per_movement_update": 1,
            "position_low_array": "6394,Y", "position_high_array": "632C,Y", "velocity_array": "64CC,Y",
            "lower_position_bound_hex": "0230", "upper_position_bound_hex": "0DD0",
        },
        "vertical": {
            "sample_address": "C065", "target_formula": "56 + floor(447 * raw_sample / 256)",
            "scale_hex": "01BF", "base": 56, "target_range_for_capped_sample": [56, 230],
            "response": "signed arithmetic shift-right of (target-current) by 3; positive sub-8 differences force +1",
            "position_array": "63FC,Y", "delta_array": "6534,Y", "upper_clamp": 221,
        },
    }


def helicopter_service_mechanics(data: bytes) -> dict[str, object]:
    """Export statically proved helicopter fuel, damage, and pad-service units."""
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")

    def expect(address: int, expected: bytes, label: str) -> None:
        start = address - 0x6900
        if payload[start : start + len(expected)] != expected:
            raise ValueError(f"{label} instruction sequence drift")

    expect(0x7011, bytes.fromhex("A9 0F 99 9C 65"), "integrity initialization")
    expect(0x704A, bytes.fromhex("A9 80 9D 08 61 A9 0A 9D F4 60 A9 40 9D F6 60"), "fuel and weapon initialization")
    expect(0x7063, bytes.fromhex("A9 02 9D 02 61"), "missile initialization")
    expect(0x9352, bytes.fromhex("BD 08 61 F0 3C BD FC 60 D0 24 AD C1 60 29 0F"), "fuel drain gate")
    expect(0x9363, bytes.fromhex("B9 FC 63 C9 DD D0 07 AD C1 60 29 1F"), "ground fuel drain gate")
    expect(0x9371, bytes.fromhex("DE 08 61 D0 0A FE 0A 61"), "fuel decrement")
    expect(0x9729, bytes.fromhex("BD 08 61 F0 D8 FE FC 60"), "pad service entry")
    expect(0x9751, bytes.fromhex("BD 08 61 C9 80 F0 05 FE 08 61"), "pad refuel")
    expect(0x977E, bytes.fromhex("BD F4 60 C9 0A F0 0C"), "pad bomb rearm")
    expect(0x9791, bytes.fromhex("BD 02 61 C9 02 F0 0C"), "pad missile rearm")
    expect(0xB492, bytes.fromhex("BD 08 61 C9 22"), "low-fuel warning")
    expect(0xB4E6, bytes.fromhex("BD 08 61 C9 10"), "critical-fuel warning")
    expect(0xB4F5, bytes.fromhex("2C 30 C0"), "critical-fuel speaker toggle")

    return {
        "image_sha256": sha256(data),
        "evidence": ["E-SERVICE-001", "E-SERVICE-002", "E-SERVICE-003"],
        "update_cadence": None,
        "counter_source": "60C1",
        "fuel": {
            "array": "6108,X", "capacity": 0x80,
            "airborne_drain": {"amount": 1, "counter_mask_hex": "0F", "period_counter_values": 16},
            "grounded_drain": {"amount": 1, "counter_mask_hex": "1F", "period_counter_values": 32},
            "pad_service_suppresses_drain": True,
            "low_warning_below": 0x22, "critical_warning_below": 0x10,
            "empty_value": 0, "critical_audio_soft_switch": "C030",
        },
        "integrity": {
            "array": "659C,Y", "maximum": 0x0F,
            "pad_repair": {"amount": 1, "counter_mask_hex": "03", "period_counter_values": 4},
            "field_repair": {
                "amount": 1, "counter_mask_hex": "07", "period_counter_values": 8,
                "requires_ground_coordinate_hex": "DD", "minimum_carried_men": 4,
            },
        },
        "weapons": {
            "machine_gun_internal": {
                "array": "60F6,X", "capacity": 0x40,
                "pad_rearm": {"amount": 1, "period_counter_values": 1},
                "manual_claimed_rounds": 50,
                "discrepancy": "The original binary initializes 64 internal shot units; the manual says 50 rounds.",
            },
            "bombs": {
                "array": "60F4,X", "capacity": 10,
                "pad_rearm": {"amount": 1, "counter_mask_hex": "03", "period_counter_values": 4},
            },
            "smart_missiles": {
                "array": "6102,X", "capacity": 2,
                "pad_rearm": {"amount": 1, "counter_mask_hex": "0F", "period_counter_values": 16},
            },
        },
        "pad_service": {
            "active_flag": "60FC,X", "ready_flag": "610C,X",
            "ready_condition": "a service pass changed none of integrity, fuel, gun ammunition, bombs, or missiles",
            "standard_mode": "60EE = 0",
            "alternate_mode_note": "When 60EE is nonzero, 60F6,X caps at 6 and increments only when (60C1 & 7) == 0.",
        },
    }


def main_loop_timing(data: bytes) -> dict[str, object]:
    """Export the proved relationship between the main loop and its counters."""
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")

    def expect(address: int, expected: bytes, label: str) -> None:
        start = address - 0x6900
        if payload[start : start + len(expected)] != expected:
            raise ValueError(f"{label} instruction sequence drift")

    expect(0x69DD, bytes.fromhex("20 75 6A 20 E3 6A 20 51 6A"), "main loop call sequence")
    expect(0x6A51, bytes.fromhex("20 09 7A AD 00 60 C9 04 F0 19"), "update wrapper entry")
    expect(0x6A69, bytes.fromhex("20 09 B3 EE C1 60 D0 03 EE C2 60 60"), "frame-counter increment")
    direct_vbl_operands = []
    for selector_number in range(7):
        for selector_load, selector_payload in decode_selector(data, selector_number)["loads"]:
            position = 0
            while True:
                position = selector_payload.find(b"\x19\xC0", position)
                if position < 0:
                    break
                direct_vbl_operands.append({
                    "selector": selector_number,
                    "load_index": selector_load["index"],
                    "address": selector_load["memory_start"] + position,
                })
                position += 1
    if direct_vbl_operands:
        raise ValueError("unexpected direct $C019 operand appeared")
    return {
        "image_sha256": sha256(data),
        "evidence": ["E-TIMING-001"],
        "main_loop_entry": "69DD",
        "update_wrapper": "6A51",
        "counter_low": "60C1",
        "counter_high": "60C2",
        "increments_per_completed_update_wrapper": 1,
        "counter_width_bits": 16,
        "direct_c019_operands_in_decoded_selector_loads": direct_vbl_operands,
        "cadence_classification": "completed-main-loop/update-wrapper relative",
        "hardware_synchronization": None,
        "updates_per_second": None,
        "limitation": "No direct $C019 vertical-blank operand exists in decoded selector loads, but variable-work loop paths prevent a static conversion to seconds.",
    }


def helicopter_combat_mechanics(data: bytes) -> dict[str, object]:
    """Export player-weapon damage and integrity feedback from selector 5."""
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")

    def expect(address: int, expected: bytes, label: str) -> None:
        start = address - 0x6900
        if payload[start : start + len(expected)] != expected:
            raise ValueError(f"{label} instruction sequence drift")

    def signed_table(address: int, length: int) -> list[int]:
        start = address - 0x6900
        return [value if value < 0x80 else value - 0x100 for value in payload[start : start + length]]

    def unsigned_table(address: int, length: int) -> list[int]:
        start = address - 0x6900
        return list(payload[start : start + length])

    stage_type06_stored_infantry = [
        data[coordinate_to_offset(0, stage + 6) + 0x6D]
        for stage in range(1, 9)
    ]
    fixed_object_types = unsigned_table(0x790B, 6)
    fixed_object_low = unsigned_table(0x7911, 6)
    fixed_object_high = unsigned_table(0x7917, 6)
    fixed_objects = [
        {
            "table_index": index,
            "side": index & 1,
            "object_type_hex": f"{fixed_object_types[index]:02X}",
            "horizontal_coordinate_hex": f"{(fixed_object_high[index] << 8) | fixed_object_low[index]:04X}",
        }
        for index in range(6)
    ]

    expect(0x6ADA, bytes.fromhex("A9 0F 8D 16 61 8D 17 61 60"), "campaign cash initialization")
    expect(0x7A15, bytes.fromhex("A9 37 8D 22 60 A9 5A 8D 23 60 60"), "economy and score timer initialization")
    expect(0x7A20, bytes.fromhex("CE 22 60 10 15 A9 37 8D 22 60 EE 16 61 D0 03 CE 16 61 EE 17 61 D0 03 CE 17 61"), "periodic saturating cash income")
    expect(0x950B, bytes.fromhex("C9 C8 D0 15 AD 17 61 E9 14 90 0E 8D 17 61 EE AB 60"), "replacement helicopter purchase")
    expect(0x724C, bytes.fromhex("A9 07 8D B3 60"), "bomb damage initialization")
    expect(0x7286, bytes.fromhex("20 B9 76 B0 23 A9 01 99 64 64 AD A8 60 99 A4 67 18 69 0A 99 3C 67"), "type-0B projectile lifecycle initialization")
    expect(0x716F, bytes.fromhex("A9 2F 8D B3 60 20 B9 76"), "stationary gun assembly initialization")
    expect(0x7177, bytes.fromhex("AD 6D 40 99 A4 67 38 7D 18 61 9D 18 61 AD 6D 40 7D 1E 61 9D 1E 61 FE 1C 61"), "stationary structure stored-infantry initialization")
    expect(0x722E, bytes.fromhex("A9 16 8D B3 60 AD BD 60 F0 08 A9 00 AE A7 60 20 0C 69 20 B9 76"), "type-09 layout structure initialization")
    expect(0x71D3, bytes.fromhex("A9 08 99 24 61"), "type-08 linked vertical component")
    expect(0x74DE, bytes.fromhex("A9 15 8D B3 60"), "smart-missile damage initialization")
    expect(0x74A2, bytes.fromhex("AD C3 60 85 60 20 90 6F B0 31 A9 11 99 24 61"), "destruction effect initialization")
    expect(0x7D5A, bytes.fromhex("A9 05 4C 43 82"), "type-09 aimed type-0B projectile tail")
    expect(0x7CAD, bytes.fromhex("BD 94 63 38 ED CD 60 85 60 BD 2C 63 ED CC 60 85 61"), "stationary gun aimed velocity")
    expect(0x7D5F, bytes.fromhex("B9 9C 65 C9 16 F0 0B AD C1 60 29 01 79 9C 65"), "stationary gun controller")
    expect(0x7DD0, bytes.fromhex("AD C1 60 4D C3 60 29 01 D0 A1"), "stationary gun firing gate")
    expect(0x7F76, bytes.fromhex("AD C1 60 4D C3 60 29 03 D0 71"), "missile carrier cadence gate")
    expect(0x736E, bytes.fromhex("A9 05 8D B3 60 AD E1 60 48 20 B9 76"), "infantry constructor")
    expect(0x73AC, bytes.fromhex("A9 0E 8D A7 60 A9 01 8D FB 79 A9 0F 8D B3 60"), "tank constructor")
    expect(0x73DC, bytes.fromhex("A9 0F 8D A7 60 A9 01 8D FB 79 A9 06 8D B3 60"), "missile carrier constructor")
    expect(0x7402, bytes.fromhex("A9 10 8D A7 60 A9 01 8D FB 79 A9 09 8D B3 60"), "demolition vehicle constructor")
    expect(0x7644, bytes.fromhex("A9 00 8D E1 60 20 6E 73 B0 41 AD CE 60 C9 DD F0 3A AC C3 60 99 FC 63 A9 19 99 24 61"), "falling infantry constructor")
    expect(0x7678, bytes.fromhex("AD CE 60 C9 AB AD E7 60 29 0F F0 08 29 07 90 02 29 03 69 03 99 A4 67"), "parachute countdown selection")
    expect(0x7690, bytes.fromhex("A9 15 8D B3 60 20 B9 76 B0 1B A9 03 99 64 64 A2 67 AD CF 60 99 CC 64 10 02 A2 6F 8A 99 C4 62 AD CE 60 99 FC 63 60"), "type-1A alternate weapon constructor")
    expect(0x75D8, bytes.fromhex("C9 17 D0 07 AE BD 60 98 9D FA 60"), "fixed armed-bunker registration")
    expect(0x75C0, bytes.fromhex("AD CC 60 4A 4A 4A 10 02 A9 00 8D BD 60 A9 80 8D B3 60 20 B9 76"), "type-16/type-17 bunker initialization")
    expect(0x7616, bytes.fromhex("AD A8 60 C9 1A F0 DE AD C3 60 85 60 A9 80 8D B3 60 20 B9 76 B0 17 A9 03 99 D4 66"), "type-1D transitional aftermath constructor")
    expect(0x7A85, bytes.fromhex("BE 04 66 BD A4 84 D0 06 BE 04 66 BD A3 84 99 CC 64"), "ground-unit side velocity selection")
    expect(0x7B50, bytes.fromhex("AD C1 60 4D C3 60 29 01 19 74 68 F0 12 B9 2C 63 4A 4A 29 02 19 04 66 49 03 18 69 14 99 C4 62"), "type-06 stored-infantry producer")
    expect(0x7DF9, bytes.fromhex("A9 00 8D AF 60 AE C3 60 BD FC 63 C9 DD F0 03 DE FC 63 BD 3C 67 F0 03 DE 3C 67 20 48 7E"), "ground infantry primary update")
    expect(0x819C, bytes.fromhex("A9 05 A2 D9 28 90 17 0E CF 60 20 06 69 29 70"), "tank variable type-0B projectile")
    expect(0x81AD, bytes.fromhex("A9 0F D0 07 AD E7 60 29 03 69 01"), "tank random damage selection")
    expect(0x8241, bytes.fromhex("A9 01 8D B3 60 A9 0B 8D A7 60"), "one-damage type-0B projectile")
    expect(0x82A6, bytes.fromhex("A9 0D 99 24 61"), "falling to grounded-infantry transition")
    expect(0x8288, bytes.fromhex("B9 FC 63 C9 DD D0 41 B9 A4 67 30 08 A9 00 99 0C 68 4C 0C AC"), "falling infantry ground outcome")
    expect(0x82D0, bytes.fromhex("A2 02 B9 A4 67 30 0E F0 0A 38 E9 01 D0 02 A9 FF 99 A4 67 A2 04"), "parachute descent state")
    expect(0x84A3, bytes.fromhex("01 FF"), "type-0D projectile direction table")
    expect(0x8473, bytes.fromhex("50 7B"), "type-06 producer handler pointer")
    expect(0x8477, bytes.fromhex("3A 7C"), "type-08 linked vertical-pair handler pointer")
    expect(0x8479, bytes.fromhex("5F 7D"), "type-09 stationary-gun handler pointer")
    expect(0x8481, bytes.fromhex("F9 7D"), "type-0D ground infantry handler pointer")
    expect(0x8327, bytes.fromhex("B9 04 66 49 01 AA BD 04 61 D0 2E BD 12 61 AA"), "stationary helicopter acquisition")
    expect(0x8358, bytes.fromhex("A5 60 C9 60 B0 02 38 60"), "stationary helicopter range")
    expect(0x84F2, bytes.fromhex("60 C4 00 FF"), "stationary type-0E search thresholds")
    expect(0x84F6, bytes.fromhex("01 FF B4 78 54 48 3C 30 18 00"), "capture strategy-delay table")
    expect(0x8BEA, bytes.fromhex("A9 04 8D B3 60 A9 D9 8D CE 60 A9 0B 8D A7 60"), "four-damage type-0B projectile")
    expect(0x8BFD, bytes.fromhex("B9 64 64 F0 06 AE C3 60 DE 64 64 B9 FC 63 C9 DC D0 03 4C FA 87 B9 CC 64 10 08 C9 F6 F0 0A E9 01 D0 06 C9 0A F0 02 69 01 99 CC 64"), "type-1A alternate weapon update")
    expect(0x8EE2, bytes.fromhex("FE 02"), "type-17 projectile velocity table")
    expect(0x8670, bytes.fromhex("B9 64 64 F0 06 AE C3 60 DE 64 64 BE D4 66"), "smart-missile update")
    expect(0x8CB8, bytes.fromhex("B9 A4 67 F0 07 38 E9 01 99 A4 67 60"), "bomb update")
    expect(0x8CE9, bytes.fromhex("A2 FF AD ED 60 D0 01 E8 8A 99 0C 68 4C 0C AC"), "stage-selected bomb ground aftermath state")
    expect(0x8D4A, bytes.fromhex("20 12 7A AC C3 60 B9 34 65 18 79 A4 67 99 34 65"), "type-0B projectile update")
    expect(0x8DEC, bytes.fromhex("AE C3 60 BD 3C 67 D0 0C DE D4 66 10 03 4C 0C AC DE C4 62 60 DE 3C 67 60"), "type-18 aftermath countdown")
    expect(0x8E04, bytes.fromhex("BE A4 67 A9 14 E0 1A F0 02 A9 18 99 24 61 48 20 12 6F AC C3 60 68 0A AA"), "type-1D aftermath conversion")
    expect(0x9476, bytes.fromhex("A9 0B 8D A7 60 A9 02 8D B3 60"), "player machine-gun projectile")
    expect(0x942A, bytes.fromhex("AD EE 60 F0 03 4C FD 98"), "stage weapon-mode firing branch")
    expect(0x94C1, bytes.fromhex("A9 0A 8D A7 60 4C 0C 6F"), "player bomb projectile")
    expect(0x9637, bytes.fromhex("DE 02 61 A9 03 9D 4B 60 A9 12 8D A7 60"), "player smart missile")
    expect(0xAC26, bytes.fromhex("B9 9C 65 F0 0D 30 0B 38 ED B3 60 F0 1D 90 1B 99 9C 65"), "common integrity subtractor")
    expect(0xAC5B, bytes.fromhex("AC C3 60 B9 24 61 F0 21 48 B9 D4 66 8D E3 60 20 CD B0 20 07 B1"), "destruction aftermath dispatch")
    expect(0xAFDC, bytes.fromhex("BD 9C 65 F0 23 AC C4 60 B9 9C 65 8D B3 60"), "collision damage transfer")
    expect(0xB1C5, bytes.fromhex("B9 24 61 C9 1C F0 03 4C 55 AE"), "bunker type-1C collision discriminator")
    expect(0xB1DE, bytes.fromhex("B9 24 61 C9 17 F0 06"), "type-17 armed-bunker collision branch")
    expect(0xB176, bytes.fromhex("AD ED 60 F0 39 AC C3 60 B9 24 61 8D A8 60 B9 FC 63 C9 D6 90 29 A9 1D 8D A7 60 B9 94 63 38 E9 07"), "stage-selected bomb type-1D aftermath")
    expect(0xB279, bytes.fromhex("76 B1"), "type-0A destruction handler pointer")
    expect(0xB299, bytes.fromhex("7B B1"), "type-1A destruction handler pointer")
    expect(0xB00E, bytes.fromhex("AC C5 60 AE C4 60 BD 04 66 D9 04 66 F0 28"), "type-1C collision handler")
    expect(0xB02F, bytes.fromhex("8C C3 60 A9 04 8D B3 60 4C 12 AC"), "fixed collision damage")
    expect(0x80A2, bytes.fromhex("B9 94 63 38 E9 05 85 60 B9 2C 63 E9 00 85 61 A2 67 BD 24 61 C9 06 F0 0D C9 16 F0 09 C9 17 F0 05"), "capturable structure search")
    expect(0x80D6, bytes.fromhex("AC C3 60 BD A4 67 F0 20 B9 04 66 DD 04 66 F0 45 DE A4 67 BD 04 66 AA DE 18 61 DE 1E 61 CE AF 60"), "infantry structure interaction resolver")
    expect(0xB22D, bytes.fromhex("AC 60 00 00 75 AE 00 00 10 B2"), "collision handler table")
    expect(0xB0CD, bytes.fromhex("BE 24 61 8E CF 60 BD A0 B2 F0 2E 85 10 B9 0C 68"), "destruction effect creation")
    expect(0xB107, bytes.fromhex("AC C3 60 BE 24 61 BD BD B2 F0 4C AA B9 0C 68"), "destruction type-0C spawning")
    expect(0xB2A0, bytes.fromhex("00 00 4B 00 00 4B 4D 4E 00 4A 49 49 00 49 A0 4B 4C 00 00 00 00 00 00 00 00 49 00 00 00"), "destruction effect codes")
    expect(0xB2BD, bytes.fromhex("00 00 14 00 00 28 0A 05 00 04 00 00 00 84 0A 0A 0A 00 06 00 00 00 00 00 00 84 0A 00 00"), "destruction type-0C controls")
    expect(0x9867, bytes.fromhex("AD C1 60 29 07 F0 0C BE 9C 65 E0 07"), "damage smoke cadence")
    expect(0x98A7, bytes.fromhex("B9 9C 65 C9 0A B0 06 E8 C9 05 B0 01 E8"), "damage smoke tiers")
    expect(0x98C1, bytes.fromhex("BC 12 61 8E BD 60 B9 94 63 18 69 05 8D CD 60 B9 2C 63 69 00 8D CC 60 B9 FC 63 8D CE 60 A9 19 8D A7 60"), "falling infantry spawner")
    expect(0x98FD, bytes.fromhex("BD E3 99 F0 28 8D CF 60 A9 05 18 79 94 63 8D CD 60 B9 2C 63 69 00 8D CC 60 B9 FC 63 38 E9 02 8D CE 60 A9 1A 8D A7 60 4C 0C 6F"), "type-1A alternate weapon firing path")
    expect(0x996C, bytes.fromhex("05 04 03 02 05 CD D4 C1 C4 C5 06 08 02 0A 06 1A 06 07 08 1D 0D 0E 0F 10 0D"), "ground-unit deployment tables")
    expect(0x99AD, bytes.fromhex("0A 09 0A 00 00 00 07 00 03 FA FE FF FA FE FF FE 00 FE FF FF FF 0B 0B 0B FF 00 0B FE FC F8 FE FC F8 FC 00 FC F8 F8 F8 08 08 08 F8 00 08 02 00 FE 02 00 FE 00 00 00"), "smoke and machine-gun direction tables")
    expect(0x99E3, bytes.fromhex("FF FF FF 01 01 01 FF 00 01"), "type-1A alternate weapon direction table")
    return {
        "image_sha256": sha256(data),
        "evidence": ["E-COMBAT-001", "E-COMBAT-002", "E-COMBAT-003", "E-COMBAT-007", "E-COMBAT-008", "E-COMBAT-009", "E-COMBAT-010", "E-ECONOMY-001", "E-UNIT-PROFILE-001", "E-MOBILITY-001", "E-PARACHUTE-001", "E-STAGE-WEAPON-001", "E-STAGE-BOMB-001", "E-STRUCTURE-001", "E-STRUCTURE-ROLE-001", "E-OBJECT-CATALOG-001"],
        "integrity": {
            "array": "659C,Y", "player_maximum": 15,
            "common_subtractor": "AC26-AC38",
            "rule": "if integrity <= damage, destroy the object; otherwise integrity := integrity - damage",
            "damage_operand": "60B3",
        },
        "economy": {
            "cash_array": "6116-6117",
            "side_order": [0, 1],
            "initial_cash_bags_by_side": [15, 15],
            "initialization": "6ADA-6AE2 during reset_battlefield_state for a new battlefield pass",
            "stage_transition_behavior": "initialize_battle_stage does not reset $6116/$6117, so balances carry across stage transitions within the pass",
            "income_timer": "6022",
            "income_timer_initial_and_reload_hex": "37",
            "income_interval_completed_update_handler_calls": 56,
            "income_bags_per_side": 1,
            "maximum_cash_bags": 255,
            "overflow_behavior": "an increment from 255 to 0 is immediately decremented back to 255",
            "replacement_helicopter_cost_bags": 20,
            "replacement_purchase_resource": "side-1 cash byte $6117 on the interactive replacement path",
            "income_interval_seconds": None,
        },
        "ground_unit_deployment": {
            "table_order": ["men", "tank", "aa_missile_carrier", "demolition_vehicle", "engineers"],
            "commands": [
                {"key": "M", "role": "men", "cost_bags": 5, "active_cap": 26, "counter_offset": 6, "object_type_hex": "0D", "deployment_size": 5, "initial_integrity": 5, "constructor": "736E-73AB", "secondary_handler": "7DF9", "infantry_variant_flag": 0},
                {"key": "T", "role": "tank", "cost_bags": 4, "active_cap": 6, "counter_offset": 8, "object_type_hex": "0E", "deployment_size": 1, "initial_integrity": 15, "constructor": "73AC-73DB", "secondary_handler": "7F1A"},
                {"key": "A", "role": "aa_missile_carrier", "cost_bags": 3, "active_cap": 7, "counter_offset": 2, "object_type_hex": "0F", "deployment_size": 1, "initial_integrity": 6, "constructor": "73DC-7401", "secondary_handler": "7F76"},
                {"key": "D", "role": "demolition_vehicle", "cost_bags": 2, "active_cap": 8, "counter_offset": 10, "object_type_hex": "10", "deployment_size": 1, "initial_integrity": 9, "constructor": "7402-7424", "secondary_handler": "8027"},
                {"key": "E", "role": "engineers", "cost_bags": 5, "active_cap": 29, "counter_offset": 6, "object_type_hex": "0D", "deployment_size": 2, "initial_integrity": 5, "constructor": "736E-73AB", "secondary_handler": "7DF9", "infantry_variant_flag": 1},
            ],
            "cap_rule": "purchase is rejected when the selected $6118 counter is greater than or equal to the command cap",
            "shared_counter_note": "men and engineers share counter offset 6 and object type $0D; their command-specific thresholds are 26 and 29",
            "addresses": {"routine": "9543-95F4", "tables": "996C-9984"},
        },
        "ground_unit_mobility": {
            "common_velocity_selector": "7A85-7A95",
            "common_integrator": "7A96-7ABA",
            "forward_horizontal_velocity_by_owner_signed": [1, -1],
            "reverse_horizontal_velocity_by_owner_signed": [-1, 1],
            "moving_horizontal_units_per_completed_update_wrapper": 1,
            "profiles": [
                {"roles": ["men", "engineers"], "object_type_hex": "0D", "moving_horizontal_units_per_completed_update_wrapper": 1},
                {"roles": ["tank"], "object_type_hex": "0E", "moving_horizontal_units_per_completed_update_wrapper": 1},
                {"roles": ["aa_missile_carrier"], "object_type_hex": "0F", "moving_horizontal_units_per_completed_update_wrapper": 1},
                {"roles": ["demolition_vehicle"], "object_type_hex": "10", "moving_horizontal_units_per_completed_update_wrapper": 1},
            ],
            "condition": "The common movement path advances one original horizontal coordinate unit. Collision clearance, targeting, firing, and interaction branches can stop or defer movement on a given wrapper.",
            "updates_per_second": None,
        },
        "structure_role_mapping": {
            "fixed_object_table": fixed_objects,
            "roles": {
                "04_helipad": {
                    "per_side_link_field": "6106,X",
                    "default_sprite_hex": "36",
                    "constructor": "714B-715C",
                    "proof": [
                        "pad service at $96D0 reads $6106,X and accepts a helicopter aligned 5..13 horizontal units from that object",
                        "the type-$04 collision handler keys hostile helicopter destruction through the opposing side's $6106 link",
                        "the fixed table places one beside each objective; an optional third pad is controlled by stage byte $4060",
                    ],
                },
                "05_time_machine_objective": {
                    "per_side_link_field": "60F2,X",
                    "default_sprite_hex": "31",
                    "constructor": "715D-716E",
                    "initial_integrity": 128,
                    "proof": [
                        "the type-$10 demolition vehicle tests arrival against the opposing $6106 pad coordinate, then destroys the opposing $60F2 type-$05 object",
                        "that path sets the battle-completion and winning-side fields",
                        "the manual identifies the DTV-only objective beside each helipad as the time machine",
                    ],
                },
                "06_bunker": {
                    "stored_infantry_field": "67A4,Y",
                    "initial_integrity": 47,
                    "proof": "capturable by grounded infantry, changes owner, stores infantry, repairs while occupied, and can produce grounded infantry",
                },
                "07_barrage_balloon": {
                    "initial_integrity": 6,
                    "initial_height_hex": "CD",
                    "default_runtime_sprites_hex": ["12", "13"],
                    "proof": "linked above type $06 and follows randomized vertical targets; hostile helicopter collision is lethal",
                },
                "08_balloon_mooring_line": {
                    "initial_integrity": 128,
                    "default_sprite_hex": "F0",
                    "vertical_size_sentinel_hex": "FF",
                    "proof": "tracks the type-$07 vertical position, maintains paired vertical endpoints, and has the separate hostile-helicopter line collision state",
                },
                "16_optional_bunker": {
                    "initial_integrity": 128,
                    "layout_gate_bytes": "4061-4063",
                    "proof": "optional fixed structures accepted by the same infantry capture/deposit resolver as types $06/$17",
                },
                "17_fixed_armed_bunker": {
                    "per_side_link_field": "60FA,X",
                    "initial_integrity": 128,
                    "proof": "one fixed per side; accepts infantry occupancy and fires a four-damage type-$0B machine-gun projectile only while occupied and target clearance is nonzero",
                },
            },
            "manual_corroboration": "The manual separately names time machines beside helipads, capturable bunker variants, machine-gun bunkers, and barrage balloons with lethal mooring lines.",
            "correction": "Earlier reports inferred type $17 as the time machine from unique per-side registration. The DTV consumer and fixed-object graphics instead prove type $05 is the time-machine objective; type $17 is the fixed armed bunker.",
        },
        "capturable_structure_mechanics": {
            "ground_infantry_object_type_hex": "0D",
            "ground_infantry_primary_handler": "7DF9-7F19",
            "structure_search": {
                "routine": "80A2-80D5",
                "target_object_types_hex": ["06", "16", "17"],
                "horizontal_relation": "structure coordinate equals infantry coordinate minus 5",
                "slot_scan_order": "103 down to 0; first exact match",
                "alignment_gate": "interaction search is eligible when ((infantry horizontal low byte - 1) & 3) == 0",
                "type09_stationary_gun_is_not_searched": True,
            },
            "structure_profiles": {
                "06_barrage_balloon_bunker": {
                    "initial_integrity": 47,
                    "linked_component_profiles": [
                        {"object_type_hex": "07", "initial_integrity": 6, "role": "barrage_balloon"},
                        {"object_type_hex": "08", "initial_integrity": 128, "role": "balloon_mooring_line"},
                    ],
                    "stored_infantry_field": "67A4",
                    "initial_stored_infantry_by_campaign_stage_1_8": stage_type06_stored_infantry,
                    "integrity_restore": "when stored infantry is nonzero, add 1 per type-$06 secondary-handler call up to 47",
                    "infantry_production": {
                        "minimum_stored_before_production": 2,
                        "eligibility": "(($60C1 XOR object slot) & 7) == 0",
                        "stored_infantry_consumed": 1,
                        "spawned_object_type_hex": "0D",
                        "spawn_horizontal_offset": 6,
                    },
                },
                "09_stationary_gun": {"initial_integrity": 22, "capturable_by_this_path": False, "object_update_handler": "7D5F-7DF8"},
                "16_optional_bunker": {"initial_integrity": 128, "initial_stored_infantry": 0, "primary_update": "no operation"},
                "17_fixed_armed_bunker": {"initial_integrity": 128, "initial_stored_infantry": 0, "primary_update": "four-damage type-$0B machine-gun fire when occupied and target clearance is nonzero"},
            },
            "full_integrity_infantry_selection": {
                "integrity_value": 5,
                "type06_friendly": "selected only when infantry state $67A4 is zero and stored infantry is zero",
                "type16_friendly": "selected only when infantry state $67A4 is zero and stored infantry is below 5",
                "type17_friendly": "selected only when stored infantry is zero",
                "opposing_owner": "selected subject to the type-specific state checks above",
                "damaged_infantry": "integrity other than 5 bypasses the full-integrity capacity gates",
            },
            "resolver": {
                "routine": "80D6-8145",
                "opposing_populated_structure": "decrement stored infantry and the old owner's $6118/$611E counts; consume the attacking infantry in destroyed state $00",
                "opposing_empty_structure": "change owner, decrement old-owner $6118/$611C, increment new-owner $6118/$611C, load the old owner's strategy delay, then increment stored infantry",
                "friendly_selected_structure": "increment stored infantry",
                "non_type17_deposit_counts": "increment the infantry owner's $6118/$611E counts",
                "infantry_result_after_deposit_or_capture": "consume the infantry in destroyed state $FF",
            },
            "old_owner_strategy_delay_by_campaign_stage_1_8": unsigned_table(0x84F7, 8),
            "strategy_delay_field": "60AD,old owner",
            "strategy_delay_units": "raw strategy countdown values; seconds conversion unresolved",
            "updates_per_second": None,
        },
        "falling_infantry_parachute": {
            "object_type_hex": "19",
            "constructor": "7644-768F",
            "update_handler": "8288-8317",
            "spawner": "98C1-98E5",
            "failure_trigger": "($60E7 & $0F) == 0",
            "failure_entropy_states": 1,
            "entropy_low_nibble_states": 16,
            "nominal_failure_fraction_if_low_nibble_uniform": "1/16",
            "nominal_failure_percent_if_low_nibble_uniform": 6.25,
            "actual_entropy_distribution": None,
            "fast_descent_vertical_units_per_update": 4,
            "open_parachute_vertical_units_per_update": 2,
            "countdown": {
                "initial_height_below_AB": {"formula": "($60E7 & 7) + 3", "range_inclusive": [3, 10]},
                "initial_height_at_or_above_AB": {"formula": "($60E7 & 3) + 4", "range_inclusive": [4, 7]},
            },
            "successful_landing": "negative/open state at ground converts type $19 to grounded infantry type $0D and restores integrity from 3 to 5",
            "failed_landing": "zero countdown state remains in fast descent and is destroyed at ground height $DD",
            "updates_per_second": None,
        },
        "player_weapons": {
            "machine_gun": {
                "object_type_hex": "0B", "damage": 2, "creation_path": "9476 -> 72AF -> 7286",
                "aim_indices": list(range(9)),
                "unused_firing_index": 7,
                "spawn_horizontal_offsets_signed": signed_table(0x99BF, 9),
                "spawn_vertical_offsets_signed": signed_table(0x99C8, 9),
                "horizontal_velocity_additions_signed": signed_table(0x99D1, 9),
                "vertical_velocities_signed": signed_table(0x99DA, 9),
                "vertical_acceleration": 0,
            },
            "bomb": {
                "object_type_hex": "0A", "damage": 7, "creation_path": "94C1 -> 72AF -> 724C",
                "update_handler": "8CB8-8D46", "initial_horizontal_velocity": "inherits player $64CC",
                "initial_vertical_velocity": 0, "vertical_velocity_delta_per_armed_update": 2,
                "ground_clamp_hex": "DC",
                "stage_ground_aftermath": {
                    "stage_parameter": "$4068 copied to $60ED",
                    "alternate_enabled_by_campaign_stage_1_8": [False, False, False, True, True, True, True, True],
                    "ordinary_stages_1_3": {
                        "destroyed_state_hex": "00",
                        "standard_type11_effect_code_hex": "49",
                        "type0C_batch_count": 0,
                        "type1D_creation_attempted": False,
                    },
                    "alternate_stages_4_8": {
                        "destroyed_state_hex": "FF",
                        "standard_type11_effect_suppressed": True,
                        "type0C_batch_count": 0,
                        "type1D_creation_attempted_when_source_height_at_least_hex": "D6",
                    },
                    "type1D_transition": {
                        "constructor": "7616-7643",
                        "spawn_handler": "B176-B1B6",
                        "horizontal_offset_signed": -7,
                        "vertical_position_hex": "DD",
                        "horizontal_velocity": "signed arithmetic shift right of the bomb velocity (floor division by two)",
                        "initial_integrity": 128,
                        "source_type_hex": "0A",
                        "next_primary_update_converts_to_type_hex": "18",
                        "converted_update_handler": "8DEC-8E03",
                        "eligible_infantry_collision_damage": 4,
                    },
                    "updates_per_second": None,
                },
            },
            "smart_missile": {
                "object_type_hex": "12", "damage": 21, "creation_path": "963F -> 72AF -> 74DE",
                "update_handler": "8670-87E2", "steering": "one circular angle step per update toward linked target",
                "lost_target_behavior": "vertical velocity increases by 2 per update until lower boundary DD",
                "impact_object_type_hex": "13",
            },
            "late_campaign_alternate": {
                "stage_parameter": "$4069 copied to $60EE",
                "enabled_by_campaign_stage_1_8": [False, False, False, False, True, True, True, True],
                "replaces": "player machine-gun firing path and its $60F6 ammunition/service model",
                "object_type_hex": "1A",
                "damage": 21,
                "ammunition_capacity": 6,
                "constructor": "7690-76B8",
                "firing_path": "98FD-9926",
                "update_handler": "8BFD-8C6C",
                "initial_horizontal_velocity_by_aim_index_signed": signed_table(0x99E3, 9),
                "horizontal_velocity_rule": "accelerates one unit away from zero per update to signed cap -10/+10",
                "vertical_velocity_rule": "adds one downward unit when ($60C1 & 3) == 0, then integrates altitude",
                "emitted_effect_object_type_hex": "13",
                "effect_creation_attempts_per_airborne_update": 1,
                "ground_height_hex": "DC",
                "pad_rearm_increment": 1,
                "pad_rearm_eligible_counter_period": 8,
                "updates_per_second": None,
            },
        },
        "other_observed_type_0B_projectiles": [
            {
                "creation_address": "7D5A", "damage_values": [5],
                "shooter_role": "stationary_gun_object_type_09",
                "dispatch_evidence": "object-update table base $8467: type $09 -> $7D5F -> $7CAD -> $7D5A",
            },
            {
                "creation_address": "819C-81BD", "damage_values": [1, 2, 3, 4, 5, 15],
                "shooter_role": "tank_object_type_0E",
                "dispatch_evidence": "secondary handler lookup base $8467: type $0E -> $7F1A -> $8146",
                "selection": "ordinary branch 5; alternate branch 15 when random & $70 is zero, otherwise (random & 3) + 1 + carry",
            },
            {
                "creation_address": "8241", "damage_values": [1],
                "shooter_role": "ground_infantry_object_type_0D",
                "dispatch_evidence": "secondary handler lookup base $8467: type $0D -> $7DF9 -> $820C",
            },
            {
                "creation_address": "8BEA", "damage_values": [4],
                "shooter_role": "fixed_armed_bunker_object_type_17",
                "dispatch_evidence": "primary handler table base $8E19: type $17 -> $8B9C",
            },
        ],
        "type_0B_projectile_lifecycle": {
            "initializer": "7286-72AE",
            "update_handler": "8D4A-8D81",
            "horizontal_velocity_source": "60CF -> 64CC,Y",
            "vertical_velocity_source": "60D0 -> 6534,Y",
            "vertical_acceleration_source": "60A8 -> 67A4,Y",
            "life_counter": "673C,Y",
            "life_counter_initial": "10 + vertical_acceleration",
            "ground_clamp_hex": "DC",
            "upper_destroy_threshold_hex": "28",
            "producer_velocities_are_original_signed_bytes": True,
        },
        "non_player_type_0B_ballistics": {
            "object_type_09_stationary_gun": {
                "horizontal_velocity": "(target_x - origin_x + target_width/2 + predicted_target_vx) / 8",
                "vertical_velocity": "(target_y - target_height/2 - 31 - origin_y + predicted_target_vy) / 8",
                "horizontal_target_velocity_prediction_scales": [0, 4, 8],
                "vertical_target_velocity_prediction_scales": [1, 4, 8],
                "vertical_acceleration": 1,
                "life_updates": 11,
                "damage": 5,
            },
            "object_type_0D_ground_infantry": {
                "horizontal_velocities_signed": [-2, 2], "vertical_velocity": 0,
                "vertical_acceleration": 0, "life_updates": 10,
                "nominal_horizontal_travel_magnitude": 20, "damage": 1,
            },
            "object_type_0E_tank": {
                "ordinary_horizontal_velocities_signed": [-2, 2],
                "alternate_horizontal_velocities_signed": [-4, 4],
                "vertical_velocity": 0, "vertical_acceleration": 0, "life_updates": 10,
                "nominal_horizontal_travel_magnitudes": [20, 40],
                "damage_values": [1, 2, 3, 4, 5, 15],
            },
            "object_type_17_fixed_armed_bunker": {
                "horizontal_velocities_signed": [-2, 2], "vertical_velocity": 0,
                "vertical_acceleration": 0, "life_updates": 10,
                "nominal_horizontal_travel_magnitude": 20, "damage": 4,
            },
            "travel_units": "original horizontal position units; nominal values exclude collision and boundary termination",
        },
        "targeting_and_fire_gates": {
            "object_type_09_stationary_gun": {
                "helicopter_absolute_horizontal_range_strictly_below": 96,
                "alternate_target_type_hex": "0E",
                "alternate_search_coordinate_offsets_signed": [96, -60],
                "shared_fire_absolute_horizontal_range_strictly_below": 256,
                "counter_gate": "(60C1 XOR object_slot) & 1 == 0",
                "eligible_counter_period": 2,
            },
            "object_type_0F_missile_carrier": {
                "target": "active opposing player helicopter with no linked missile",
                "absolute_horizontal_range_strictly_below": 256,
                "counter_gate": "(60C1 XOR object_slot) & 3 == 0",
                "eligible_counter_period": 4,
                "one_shot_self_destruction_after_launch": True,
            },
            "object_type_0D_and_0E_fire_cooldown_reload": 3,
            "object_type_17_counter_gate": "60C1 & 1 != 0",
            "object_type_17_eligible_counter_period": 2,
            "time_units": "completed update-wrapper counter values, not seconds",
        },
        "special_collision_variants": {
            "fixed_damage": 4,
            "dispatch_object_types_hex": ["14", "18", "1C"],
            "ordinary_damage_target_types_hex": ["0D", "19"],
            "type_1C_handler": "B00E-B047",
            "type_14_18_handler": "B048-B06E",
            "type_0B_collision_result": "destroy projectile directly",
            "notes": "type $14/$18 ignores player helicopters and applies link-state exclusions; type $1C delegates bunker collisions to their dedicated handler",
        },
        "destruction_aftermath": {
            "dispatcher": "AC5B-AC84",
            "visual_object_type_hex": "11",
            "visual_lifetime_updates": [2, 3],
            "visual_effect_codes_hex_by_object_type_00_1C": [f"{value:02X}" for value in payload[0xB2A0 - 0x6900 : 0xB2BD - 0x6900]],
            "type_0C_spawn_batches": [
                {
                    "object_type_hex": f"{object_type:02X}",
                    "control_hex": f"{control:02X}",
                    "first_batch_count": control & 0x7F,
                    "second_batch_count": 0 if control & 0x80 else control >> 2,
                    "second_batch_mode_bit_7": False if control & 0x80 else bool(control >> 2),
                }
                for object_type, control in enumerate(payload[0xB2BD - 0x6900 : 0xB2DA - 0x6900])
                if control
            ],
            "immediate_radial_damage_scan": False,
            "immediate_damage_write": False,
            "damage_model_note": "the aftermath dispatcher creates visual/type-$0C objects and cleanup effects; weapon damage itself is resolved by direct collision handlers",
        },
        "damage_feedback": {
            "smoke_size_tiers": [
                {"integrity_min": 10, "integrity_max": 15, "tier": 1},
                {"integrity_min": 5, "integrity_max": 9, "tier": 2},
                {"integrity_min": 1, "integrity_max": 4, "tier": 3},
            ],
            "smoke_counter_period": {"integrity_7_or_more": 8, "integrity_below_7": 4},
            "counter": "60C1",
        },
        "updates_per_second": None,
    }


def object_type_catalog(data: bytes) -> dict[str, object]:
    """Export the complete selector-5 object type and dispatch-table domain."""
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")

    def span(address: int, length: int) -> bytes:
        start = address - 0x6900
        return payload[start : start + length]

    def words(address: int, count: int = 30) -> list[int]:
        raw = span(address, count * 2)
        return [raw[index] | (raw[index + 1] << 8) for index in range(0, len(raw), 2)]

    constructor_pointers = words(0x7875)
    object_update_pointers = words(0x8467)
    phase_update_pointers = words(0x8E19)
    collision_pointers = words(0xB22D)
    destruction_pointers = words(0xB265)
    horizontal_sizes = list(span(0x6917, 30))
    vertical_sizes = list(span(0x6935, 30))
    active_flags = list(span(0x6953, 30))
    default_link_states = list(span(0x78B3, 30))
    default_update_states = list(span(0x78D0, 30))
    default_sprites = list(span(0x78ED, 30))
    destruction_effects = list(span(0xB2A0, 29))
    destruction_spawns = list(span(0xB2BD, 29))
    destruction_unlinks = list(span(0xB2DA, 29))

    roles = {
        0x00: "free_slot",
        0x01: "active_list_sentinel",
        0x02: "player_helicopter",
        0x03: "player_companion",
        0x04: "helipad",
        0x05: "time_machine_objective",
        0x06: "barrage_balloon_bunker",
        0x07: "barrage_balloon",
        0x08: "balloon_mooring_line",
        0x09: "stationary_gun",
        0x0A: "player_bomb",
        0x0B: "shared_projectile",
        0x0C: "randomized_fragment",
        0x0D: "ground_infantry_or_engineer",
        0x0E: "tank",
        0x0F: "anti_air_missile_carrier",
        0x10: "demolition_vehicle",
        0x11: "destruction_visual_or_stationary_target",
        0x12: "smart_missile",
        0x13: "projectile_impact_effect",
        0x14: "converted_collision_effect",
        0x15: "smoke_effect",
        0x16: "optional_bunker",
        0x17: "fixed_armed_bunker",
        0x18: "collision_active_effect",
        0x19: "falling_infantry",
        0x1A: "late_campaign_player_projectile",
        0x1B: "linked_falling_effect",
        0x1C: "tank_special_projectile",
        0x1D: "transitional_effect",
    }
    fixed_integrity = {
        0x02: 15, 0x04: 0, 0x05: 128, 0x06: 47, 0x07: 6, 0x08: 128,
        0x09: 22, 0x0A: 7, 0x0D: 5, 0x0E: 15, 0x0F: 6, 0x10: 9,
        0x12: 21, 0x14: 128, 0x16: 128, 0x17: 128, 0x18: 128,
        0x19: 3, 0x1A: 21, 0x1C: 128, 0x1D: 128,
    }

    def pointer_hex(value: int) -> str | None:
        return f"{value:04X}" if value else None

    entries = []
    for object_type in range(30):
        if object_type in fixed_integrity:
            integrity = {"kind": "fixed_on_primary_constructor_path", "value": fixed_integrity[object_type]}
        elif object_type == 0x0B:
            integrity = {"kind": "contextual_projectile_damage", "value": None}
        elif object_type == 0x0C:
            integrity = {"kind": "randomized", "range_inclusive": [1, 4]}
        elif object_type == 0x1B:
            integrity = {"kind": "inherited_on_type_conversion", "value": None}
        elif object_type in (0x03, 0x11, 0x13, 0x15):
            integrity = {"kind": "not_initialized_by_constructor", "value": None}
        else:
            integrity = {"kind": "not_applicable", "value": None}

        spawn_control = destruction_spawns[object_type] if object_type < 29 else None
        entry = {
            "object_type_hex": f"{object_type:02X}",
            "role": roles[object_type],
            "horizontal_size_raw": horizontal_sizes[object_type],
            "horizontal_size": None if object_type == 0 else horizontal_sizes[object_type],
            "vertical_size_raw": vertical_sizes[object_type],
            "vertical_size": None if object_type == 0 else vertical_sizes[object_type],
            "active_list_member": bool(active_flags[object_type]),
            "raw_constructor_pointer_hex": pointer_hex(constructor_pointers[object_type]),
            "constructor_address_hex": None if object_type in (0x00, 0x01, 0x1B) else pointer_hex(constructor_pointers[object_type]),
            "raw_object_update_handler_hex": pointer_hex(object_update_pointers[object_type]),
            "object_update_handler_hex": None if object_type == 0 else pointer_hex(object_update_pointers[object_type]),
            "raw_phase_update_handler_hex": pointer_hex(phase_update_pointers[object_type]),
            "phase_update_handler_hex": None if object_type in (0, 1) else pointer_hex(phase_update_pointers[object_type]),
            "raw_collision_handler_hex": pointer_hex(collision_pointers[object_type]),
            "collision_handler_hex": None if object_type in (0, 1) else pointer_hex(collision_pointers[object_type]),
            "raw_destruction_cleanup_handler_hex": pointer_hex(destruction_pointers[object_type]),
            "destruction_cleanup_handler_hex": None if object_type in (0, 1) else pointer_hex(destruction_pointers[object_type]),
            "raw_default_link_state_hex": f"{default_link_states[object_type]:02X}",
            "default_link_state_hex": None if object_type in (0x00, 0x01, 0x1B) else f"{default_link_states[object_type]:02X}",
            "raw_default_update_state_hex": f"{default_update_states[object_type]:02X}",
            "default_update_state_hex": None if object_type in (0x00, 0x01, 0x1B) else f"{default_update_states[object_type]:02X}",
            "raw_default_sprite_hex": f"{default_sprites[object_type]:02X}",
            "default_sprite_hex": None if object_type in (0x00, 0x01, 0x1B) else f"{default_sprites[object_type]:02X}",
            "integrity_initialization": integrity,
            "destruction_visual_effect_code_hex": None if object_type >= 29 or destruction_effects[object_type] == 0 else f"{destruction_effects[object_type]:02X}",
            "destruction_type0C_spawn": None if spawn_control is None or spawn_control == 0 else {
                "control_hex": f"{spawn_control:02X}",
                "first_batch_count": spawn_control & 0x7F,
                "second_batch_count": 0 if spawn_control & 0x80 else spawn_control >> 2,
            },
            "destruction_unlink_count": None if object_type >= 29 else destruction_unlinks[object_type],
        }
        entries.append(entry)

    return {
        "image_sha256": sha256(data),
        "evidence": ["E-OBJECT-CATALOG-001", "E-STRUCTURE-ROLE-001"],
        "object_type_domain_hex": ["00", "1D"],
        "entry_count": 30,
        "table_addresses": {
            "horizontal_sizes": "6917", "vertical_sizes": "6935", "active_list_flags": "6953",
            "constructor_pointers": "7875", "default_link_states": "78B3",
            "default_update_states": "78D0", "default_sprites": "78ED",
            "object_update_handlers": "8467", "phase_update_handlers": "8E19",
            "collision_handlers": "B22D", "destruction_cleanup_handlers": "B265",
            "destruction_effect_codes": "B2A0", "destruction_type0C_controls": "B2BD",
            "destruction_unlink_counts": "B2DA",
        },
        "overlap_notes": [
            "type $00 horizontal-size byte is the high operand byte of the preceding JMP and is retained as raw-only",
            "type $00 constructor/object-update and type $00/$01 phase/collision/destruction words include overlap or non-runtime sentinel domains; raw values are retained while semantic handler fields are null",
            "type $1D link/update defaults consume the first bytes of the following default tables",
            "the first two destruction-cleanup words overlap the final two collision-handler words",
            "destruction effect/spawn/unlink tables cover types $00-$1C; type $1D has no entry",
        ],
        "integrity_note": "Fixed values describe the primary constructor path, not necessarily a repair maximum. Contextual, random, inherited, and uninitialized effect fields remain explicitly non-fixed.",
        "entries": entries,
    }


def strategy_mechanics(data: bytes) -> dict[str, object]:
    """Export selector-5's table-driven automated strategy model."""
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")

    def span(address: int, length: int) -> bytes:
        start = address - 0x6900
        return payload[start : start + length]

    def words(address: int, count: int) -> list[int]:
        raw = span(address, count * 2)
        return [raw[index] | (raw[index + 1] << 8) for index in range(0, len(raw), 2)]

    primary_values = list(span(0xAA48, 35))
    primary_offsets = list(span(0xAA6B, 7))
    secondary_values = list(span(0xAA72, 51))
    secondary_offsets = list(span(0xAAA5, 14))
    progression = list(span(0xAAB3, 72))

    first_handler_names = [
        "input_gate", "object_altitude", "service_altitude", "saved_altitude",
        "low_horizontal_speed", "noop_1", "noop_2", "grounded_command",
        "type12_search", "type0d_proximity", "tracked_object", "countdown_motion",
        "mark_state", "linked_target", "opposing_player", "opponent_pursuit",
        "opponent_gate",
    ]
    secondary_handler_names = [
        "finalize_1", "finalize_2", "offset_from_link", "acquire_type0d",
        "finalize_3", "search_type40", "track_saved_object", "offset_saved_object",
        "finalize_4", "follow_moving_target", "follow_wide_target", "acquire_type0d",
        "refresh_opponent_link", "opponent_resource_gate",
    ]
    primary_handler_names = [
        "enable_motion", "copy_opponent_candidate", "type0e_candidate",
        "offset_any_object", "boundary_gate", "opponent_gate", "stage_delay",
    ]

    def handler_entries(address: int, names: list[str]) -> list[dict[str, object]]:
        pointers = words(address, len(names))
        return [
            {"index": index, "name": name, "address_hex": f"{pointer:04X}"}
            for index, (name, pointer) in enumerate(zip(names, pointers))
        ]

    first_handlers = handler_entries(0xAAFB, first_handler_names)
    secondary_handlers = handler_entries(0xAB1D, secondary_handler_names)
    primary_handlers = handler_entries(0xAB39, primary_handler_names)
    if [int(item["address_hex"], 16) for item in first_handlers] != [
        0x9BC2, 0x9BD0, 0x9BE6, 0x9C00, 0x9C19, 0x9C31, 0x9C32, 0x9C33,
        0x9C5C, 0x9C85, 0x9CF3, 0x9D46, 0x9D55, 0x9D5D, 0x9DAB, 0x9E3A, 0x9EEF,
    ]:
        raise ValueError("first strategy handler table drift")

    def terminated_record(values: list[int], offset: int) -> list[int]:
        try:
            end = values.index(0xFF, offset)
        except ValueError as error:
            raise ValueError("unterminated strategy script") from error
        return values[offset : end + 1]

    primary_scripts = []
    for action, offset in enumerate(primary_offsets):
        record = terminated_record(primary_values, offset)
        primary_scripts.append({
            "action": action,
            "offset_hex": f"{offset:02X}",
            "raw_record_hex": [f"{value:02X}" for value in record],
            "initial_state": record[0],
            "secondary_action_sequence": record[1:-1],
            "terminator_hex": "FF",
            "handler": primary_handlers[action],
        })

    secondary_scripts = []
    for script, offset in enumerate(secondary_offsets):
        record = terminated_record(secondary_values, offset)
        secondary_scripts.append({
            "script": script,
            "offset_hex": f"{offset:02X}",
            "first_handler_sequence": record[:-1],
            "first_handler_names": [first_handler_names[value] for value in record[:-1]],
            "terminator_hex": "FF",
            "handler": secondary_handlers[script],
        })

    negative_velocities = [value - 256 if value >= 128 else value for value in span(0xAB48, 27)]
    positive_velocity_view = list(span(0xAB63, 28))
    target_ranks = list(span(0xABAB, 30))
    target_clearances = list(span(0xABC9, 3))
    command_bytes = list(span(0xABCC, 5))
    commands = [chr(value & 0x7F) for value in command_bytes]
    command_roles = ["engineers", "demolition_vehicle", "aa_missile_carrier", "tank", "men"]
    if commands != ["E", "D", "A", "T", "M"]:
        raise ValueError("strategy command table drift")

    return {
        "image_sha256": sha256(data),
        "evidence": ["E-STRATEGY-001"],
        "module": {"memory_start_hex": "9A00", "memory_end_hex": "ABFF", "source": "selector5-load00-6900-baff"},
        "coordinator": {
            "routine": "9A15-9B2C",
            "side_field": "6604,current object",
            "saved_horizontal_velocity_fields": "606E-606F",
            "saved_vertical_target_fields": "6070-6071",
            "vertical_target_minimum_hex": "39",
            "close_opponent_weapon_gate": "stage is not 1, both helicopters eligible, vertical separation below 10, and $60C1 & $3F == 0",
            "real_time_cadence": None,
        },
        "command_selection": {
            "encoded_high_bit_hex": [f"{value:02X}" for value in command_bytes],
            "decoded_ascii": commands,
            "decoded_roles": command_roles,
            "role_evidence": "the bytes enter the same M/T/A/D/E input dispatcher exported by ground_unit_deployment",
            "resource_score_candidates": [
                {"index": 0, "source": "611E,side", "resource_role": "shared men/engineer count", "eight_bit_formula": "4 * value modulo 256"},
                {"index": 1, "source": "6122,side", "resource_role": "demolition vehicle count", "eight_bit_formula": "15 * value modulo 256"},
                {"index": 2, "source": "611A,side", "resource_role": "AA missile carrier count", "eight_bit_formula": "17 * value + original bit 4 modulo 256", "forced_hex_in_stages_1_2": "FF"},
                {"index": 3, "source": "6120,side", "resource_role": "tank count", "eight_bit_formula": "20 * value + original bit 4 modulo 256"},
            ],
            "selection": "strict minimum; equal scores retain the higher index because the scan runs 2 down to 0 from initial index 3",
            "index0_override": "if random_byte & $06 is nonzero, command index 0 is remapped to index 4 (M)",
            "foreign_hq_command": "T while a foreign linked HQ has zero capture delay; otherwise decrement $60AD,side once when ($60C1 & $0F) == 0",
            "direct_m_gate": "side ready, random-byte shift carry clear, count $6116 >= 10, and linked-HQ state permits it",
        },
        "primary_scripts": primary_scripts,
        "secondary_scripts": secondary_scripts,
        "handler_tables": {
            "first_phase": first_handlers,
            "secondary_action": secondary_handlers,
            "primary_action": primary_handlers,
        },
        "steering": {
            "positive_same_page_distance_0_27_raw": positive_velocity_view,
            "positive_overlap_note": "logical distance index 27 reads $40 at $AB7E, the first byte of the side-specific type-$0D offset table",
            "positive_distance_28_or_more": 7,
            "negative_same_page_low_byte_E5_FF_signed": negative_velocities,
            "negative_distance_outside_wrapped_table": -7,
            "direction_clamp_signed": [-1, 0, 1],
            "type0d_side_offsets_signed": [64, -64],
            "generic_object_side_offsets_signed": [-32, 32],
        },
        "targeting": {
            "rank_by_object_type_00_1D": [None if value == 0xFF else value for value in target_ranks],
            "eligible_object_types_hex": [f"{index:02X}" for index, value in enumerate(target_ranks) if value != 0xFF],
            "clearance_by_rank": target_clearances,
            "hostile_score": "absolute 16-bit horizontal distance minus rank clearance; smallest score wins",
            "type08_vertical_avoidance": {"near_distance_strictly_below": 86, "far_vertical_target_hex": "BF", "common_near_offset": -30},
        },
        "progression_tables": {
            "row_count": 9,
            "row_width": 8,
            "rows": [progression[index : index + 8] for index in range(0, 72, 8)],
            "semantic_boundary": "row structure is consumer-backed; individual auxiliary field roles remain unassigned",
        },
        "auxiliary_flags_raw_hex": span(0xAB86, 37).hex().upper(),
        "table_addresses": {
            "primary_values": "AA48-AA6A", "primary_offsets": "AA6B-AA71",
            "secondary_values": "AA72-AAA4", "secondary_offsets": "AAA5-AAB2",
            "progression_rows": "AAB3-AAFA", "first_handlers": "AAFB-AB1C",
            "secondary_handlers": "AB1D-AB38", "primary_handlers": "AB39-AB46",
            "negative_velocity": "AB48-AB62", "positive_velocity_logical_view": "AB63-AB7E",
            "target_ranks": "ABAB-ABC8", "target_clearances": "ABC9-ABCB",
            "commands": "ABCC-ABD0",
        },
        "uncertainty": [
            "auxiliary progression rows and flag bytes are retained without invented tactical labels",
            "random branch frequencies require the runtime entropy distribution",
            "all cadence is in completed update-counter values, not seconds",
        ],
    }


def scoring_mechanics(data: bytes) -> dict[str, object]:
    """Export the selector-5 packed-BCD score adjustment model."""
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")

    def span(address: int, length: int) -> bytes:
        start = address - 0x6900
        return payload[start : start + length]

    def signed_bcd(low: int, high: int) -> int:
        for nibble in (low & 0x0F, low >> 4, high & 0x0F, high >> 4):
            if nibble > 9:
                raise ValueError("score adjustment contains invalid packed BCD")
        value = (high >> 4) * 1000 + (high & 0x0F) * 100 + (low >> 4) * 10 + (low & 0x0F)
        return value - 10000 if value >= 9000 else value

    groups = list(span(0x6E11, 30))
    low_view = span(0x6E2F, 41)
    high_view = span(0x6E37, 41)
    banks = []
    for state_code, base in ((2, 0), (1, 16), (0, 32)):
        values = [signed_bcd(low_view[base + group], high_view[base + group]) for group in range(9)]
        banks.append({
            "object_state_code": state_code,
            "index_base_hex": f"{base:02X}",
            "adjustment_by_group_0_8": values,
        })

    final_values = []
    for object_type, raw in enumerate(span(0x6E6F, 31)):
        final_values.append({
            "object_type_hex": f"{object_type:02X}",
            "raw_hex": f"{raw:02X}",
            "saturating_count_increment": raw & 0x0F,
            "score_increment": raw >> 4,
            "adjustment_group": groups[object_type] if object_type < len(groups) else None,
        })

    return {
        "image_sha256": sha256(data),
        "evidence": ["E-SCORE-001"],
        "representation": "four-digit packed BCD in $0F:$0E; ten's-complement values $9000-$9999 are negative",
        "initial_value": 0,
        "time_penalty": {
            "amount": -1,
            "period_completed_update_wrappers": 90,
            "counter_address": "6023",
            "applies_while_high_bcd_byte_strictly_below_hex": "90",
            "updates_per_second": None,
        },
        "event_adjustments": {
            "routine": "6CCF-6CFD",
            "group_by_object_type_00_1D": groups,
            "zero_group_is_no_op": True,
            "logical_low_table": {"base": "6E2F", "indexed_length": 41},
            "logical_high_table": {"base": "6E37", "indexed_length": 41},
            "state_banks": banks,
            "creation_calls_use_index_base_hex": "00",
            "destruction_index_formula": "((2 - $6604,Y) << 4) + adjustment_group",
        },
        "battle_end_accumulation": {
            "routine": "6D18-6D76",
            "object_values_address": "6E6F",
            "object_type_values": final_values,
            "campaign_stage_bonus_formula": "100 + 50 * (stage - 1)",
            "campaign_stage_bonus_by_stage_1_8": [100 + 50 * index for index in range(8)],
        },
        "display": {
            "formatter": "6D77-6DC0",
            "digits": 4,
            "negative_marker_high_bit_hex": "BB",
            "last_score_bytes": "01FC-01FF",
        },
    }


def battlefield_mechanics(data: bytes) -> dict[str, object]:
    """Decode the eight stage sectors and selector-5 formation stream."""
    selector5 = decode_selector(data, 5)
    load, payload = selector5["loads"][0]
    if load["memory_start"] != 0x6900 or load["memory_end"] != 0xBAFF:
        raise ValueError("selector-5 gameplay overlay mapping drift")

    def span(address: int, length: int) -> bytes:
        start = address - 0x6900
        return payload[start : start + length]

    formation_stream = span(0x792D, 0xC5)
    formation_offsets = list(span(0x79F2, 9))
    if formation_offsets != [0x00, 0x00, 0x00, 0x01, 0x1A, 0x39, 0x5A, 0x78, 0x9E]:
        raise ValueError("campaign formation offset drift")
    formation_types = {
        0xD6: ("10", "demolition_vehicle", 1),
        0xD4: ("0E", "tank", 1),
        0xCD: ("0D", "infantry", 4),
        0xC1: ("0F", "aa_missile_carrier", 1),
    }

    fixed_objects = [
        {"object_type_hex": f"{object_type:02X}", "owner_code": index & 1, "horizontal_position": high * 256 + low}
        for index, (object_type, low, high) in enumerate(zip(
            (0x17, 0x17, 0x05, 0x05, 0x04, 0x04),
            (0x30, 0xD0, 0x78, 0x88, 0x90, 0x70),
            (0x02, 0x0D, 0x02, 0x0D, 0x02, 0x0D),
        ))
    ]
    optional_type16_positions = [0x04A8, 0x07F8, 0x0B68]
    stages = []
    for stage in range(1, 9):
        sector = stage + 6
        start = coordinate_to_offset(0, sector)
        record = data[start : start + SECTOR_SIZE]
        type06_bits = record[0x00:0x20]
        type09_bits = record[0x20:0x40]
        owner_bits = record[0x40:0x60]
        layout_objects = []
        for row in range(32):
            for bit_index in range(8):
                mask = 0x80 >> bit_index
                position_index = row * 8 + bit_index
                horizontal_position = 0x0200 + position_index * 12
                owner_code = 1 if owner_bits[row] & mask else 0
                if type06_bits[row] & mask:
                    layout_objects.append({
                        "object_type_hex": "06",
                        "role": "barrage_balloon_bunker",
                        "owner_code": owner_code,
                        "grid_index": position_index,
                        "horizontal_position": horizontal_position,
                    })
                if type09_bits[row] & mask:
                    layout_objects.append({
                        "object_type_hex": "09",
                        "role": "type_09_structure",
                        "owner_code": owner_code,
                        "grid_index": position_index,
                        "horizontal_position": horizontal_position,
                    })

        offset = formation_offsets[stage]
        formation_count = formation_stream[offset]
        formation_objects = []
        formation_records = []
        if formation_count:
            codes = formation_stream[offset + 1 : offset + 1 + formation_count]
            positions = formation_stream[offset + 1 + formation_count : offset + 1 + formation_count * 2]
            if len(codes) != formation_count or len(positions) != formation_count:
                raise ValueError(f"stage {stage} formation boundary drift")
            for index, (code, position_code) in enumerate(zip(codes, positions)):
                if code not in formation_types:
                    raise ValueError(f"stage {stage} unknown formation code ${code:02X}")
                object_type, role, unit_count = formation_types[code]
                base_position = 0x0200 + position_code * 12
                unit_positions = [base_position + unit_index * 3 for unit_index in range(unit_count)]
                formation_records.append({
                    "index": index,
                    "record_code_hex": f"{code:02X}",
                    "position_code_hex": f"{position_code:02X}",
                    "object_type_hex": object_type,
                    "role": role,
                    "unit_count": unit_count,
                    "horizontal_positions": unit_positions,
                })
                formation_objects.extend({
                    "object_type_hex": object_type,
                    "role": role,
                    "owner_code": 0,
                    "horizontal_position": position,
                    "formation_record": index,
                } for position in unit_positions)

        optional_objects = []
        if record[0x60]:
            optional_objects.append({"object_type_hex": "04", "owner_code": 0, "horizontal_position": 0x07F2, "flag_offset_hex": "60"})
        for index, position in enumerate(optional_type16_positions):
            if record[0x61 + index]:
                optional_objects.append({"object_type_hex": "16", "owner_code": 0, "horizontal_position": position, "flag_offset_hex": f"{0x61 + index:02X}"})

        copied_parameters = list(record[0x64:0x6C])
        stages.append({
            "stage": stage,
            "disk": {"track": 0, "file_sector": sector, "memory_start": 0x4000},
            "raw_sector_sha256": sha256(record),
            "raw_sector_hex": record.hex().upper(),
            "layout_objects": layout_objects,
            "layout_object_count": len(layout_objects),
            "layout_count_by_type": {
                "06": sum(item["object_type_hex"] == "06" for item in layout_objects),
                "09": sum(item["object_type_hex"] == "09" for item in layout_objects),
            },
            "optional_objects": optional_objects,
            "fixed_objects": fixed_objects,
            "formation_offset_hex": f"{offset:02X}",
            "formation_records": formation_records,
            "formation_record_count": len(formation_records),
            "formation_objects": formation_objects,
            "formation_object_count": len(formation_objects),
            "copied_parameters_4064_406B": copied_parameters,
            "known_parameter_effects": {
                "4068_to_60ED_alternate_bomb_aftermath_enabled": bool(record[0x68]),
                "4069_to_60EE_alternate_weapon_ammo_mode": bool(record[0x69]),
                "4069_player_weapon_profile": "type_1A_alternate_6_shots" if record[0x69] else "type_0B_machine_gun_64_internal_shot_units",
            },
            "unconsumed_406C": {
                "raw_value": record[0x6C],
                "classification": "not copied and no selector-5 static consumer",
            },
            "type06_initial_stored_infantry_406D": record[0x6D],
        })

    return {
        "image_sha256": sha256(data),
        "evidence": ["E-BATTLEFIELD-001", "E-STAGE-WEAPON-001", "E-STAGE-BOMB-001", "E-STAGE-PARAM-001", "E-STRUCTURE-001", "E-STRUCTURE-ROLE-001", "E-OBJECT-CATALOG-001"],
        "stage_loader": {
            "routine": "6B94-6BC3",
            "disk_track": 0,
            "sector_formula": "stage + 6",
            "destination": "4000-40FF",
        },
        "horizontal_coordinates": {
            "representation": "12-bit original object coordinate, modulo 4096",
            "domain_min": 0,
            "domain_max": 4095,
            "layout_grid_start": 0x0200,
            "layout_grid_stride": 12,
            "layout_grid_slots": 256,
            "layout_grid_last": 0x0DF4,
            "conversion_to_demade_pixels": None,
        },
        "record_layout": {
            "4000_401F": "32 bytes of type-$06 capturable-linked-structure bits",
            "4020_403F": "32 bytes of type-$09 stationary-gun bits",
            "4040_405F": "32 parallel ownership-bit bytes",
            "4060": "optional type-$04 flag at horizontal $07F2",
            "4061_4063": "three optional type-$16 flags at $04A8/$07F8/$0B68",
            "4064_4067": "four invariant bytes 30/5/5/5 copied to $60E9-$60EC; no static consumer in decoded selector loads",
            "4068": "copied to $60ED; stages 4-8 replace the bomb's ordinary ground type-$11 effect with a type-$1D to type-$18 aftermath transition",
            "4069": "copied to $60EE; zero selects the 64-unit machine-gun model, nonzero selects the six-shot type-$1A alternate weapon model",
            "406A_406B": "copied to $60EF-$60F0; no static consumer in decoded selector loads",
            "406C": "not copied and has no selector-5 static consumer; retained as non-consumed stage metadata/padding",
            "406D": "initial type-$06 stored-infantry count",
            "406E_40FF": "no selector-5 static consumer; retained verbatim as non-consumed sector tail",
        },
        "fixed_objects": fixed_objects,
        "formation_stream": {
            "address": "792D-79F1",
            "offset_table_address": "79F2-79FA",
            "record_codes": {f"{code:02X}": {"object_type_hex": value[0], "role": value[1], "unit_count": value[2]} for code, value in formation_types.items()},
            "position_formula": "$0200 + 12 * position_code; four-unit infantry records add 0/3/6/9",
        },
        "stages": stages,
    }


def write_json(path: pathlib.Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def command_version(command: str, *args: str) -> dict[str, object]:
    executable = shutil.which(command)
    if not executable:
        return {"available": False}
    run = subprocess.run([executable, *args], text=True, capture_output=True, check=False)
    output = (run.stdout or run.stderr).strip().splitlines()
    return {"available": True, "path": executable, "version": output[0] if output else "unknown"}


def normalize_da65_header(path: pathlib.Path) -> None:
    """Remove da65's wall-clock header so regenerated listings are stable."""
    lines = path.read_text().splitlines()
    lines = ["; Created:    reproducible build" if line.startswith("; Created:") else line for line in lines]
    path.write_text("\n".join(lines) + "\n")


def do_doctor(args: argparse.Namespace) -> None:
    result = {
        "python": {"available": True, "path": sys.executable, "version": sys.version.split()[0]},
        "a2kit": command_version("a2kit", "--version"),
        "ca65": command_version("ca65", "--version"),
        "da65": command_version("da65", "--version"),
        "ld65": command_version("ld65", "--version"),
        "make": command_version("make", "--version"),
    }
    missing = [name for name, value in result.items() if not value["available"]]
    write_json(args.output, result)
    if missing:
        raise SystemExit("missing required tools: " + ", ".join(missing))


def do_fingerprint(args: argparse.Namespace) -> None:
    data = read_image(args.image)
    digest = sha256(data)
    if digest != EXPECTED_SHA256:
        raise SystemExit(f"canonical hash mismatch: {digest}")
    check_text = args.checksums.read_text()
    if EXPECTED_SHA256 not in check_text:
        raise SystemExit("expected hash is not pinned in checksums file")
    write_json(args.output, {
        "path": str(args.image), "size": len(data), "sha256": digest,
        "geometry": {"tracks": TRACKS, "stored_sectors_per_track": SECTORS, "bytes_per_sector": SECTOR_SIZE},
    })


def do_extract(args: argparse.Namespace) -> None:
    data = read_image(args.image)
    stored = args.output / "stored"
    stored.mkdir(parents=True, exist_ok=True)
    manifest = []
    for track in range(TRACKS):
        for sector in range(SECTORS):
            start = coordinate_to_offset(track, sector)
            chunk = data[start : start + SECTOR_SIZE]
            rel = pathlib.Path("stored") / f"t{track:02d}_s{sector:02d}.bin"
            (args.output / rel).write_bytes(chunk)
            manifest.append({"track": track, "stored_sector": sector, "offset": start, "size": len(chunk), "sha256": sha256(chunk), "path": str(rel)})
    for name in MAPPINGS:
        logical = to_logical(data, name)
        (args.output / f"candidate-{name}.img").write_bytes(logical)
        rebuilt = from_logical(logical, name)
        if rebuilt != data:
            raise SystemExit(f"{name} mapping failed round trip")
    # The bootstrap's DOS translation converts logical 0..5 to controller
    # sector IDs. In a DOS-order sector image those logical sectors occupy raw
    # file positions 0..5; the coherent routine spanning $BCFF/$BD00 is the
    # static discriminator for this interpretation.
    stage1 = data[: 6 * SECTOR_SIZE]
    (args.output / "stage1-ba00-bfff.bin").write_bytes(stage1)
    stage2 = bytearray()
    for file_sector in range(16):
        start = coordinate_to_offset(19, file_sector)
        stage2.extend(data[start : start + SECTOR_SIZE])
    start = coordinate_to_offset(20, 12)
    stage2.extend(data[start : start + SECTOR_SIZE])
    (args.output / "stage2-6000-70ff.bin").write_bytes(stage2)
    start = coordinate_to_offset(21, 0)
    (args.output / "stage3-4000-43ff.bin").write_bytes(data[start : start + 4 * SECTOR_SIZE])
    for selector_number in range(7):
        selector = decode_selector(data, selector_number)
        load_manifest = []
        for load, payload in selector.pop("loads"):
            filename = f"selector{selector_number}-load{load['index']:02d}-{load['memory_start']:04x}-{load['memory_end']:04x}.bin"
            (args.output / filename).write_bytes(payload)
            load["path"] = filename
            load_manifest.append(load)
        selector["loads"] = load_manifest
        write_json(args.output / f"selector{selector_number}-loads.json", selector)
    source_dir = args.output / "source-fragments"
    source_dir.mkdir(parents=True, exist_ok=True)
    for stale in source_dir.glob("fragment-*.txt"):
        stale.unlink()
    source_manifest = []
    for index, block in enumerate(scan_tokenized_source(data)):
        filename = f"fragment-{index:02d}-{block['offset_start']:05x}.txt"
        text_lines = [
            f"# raw offsets ${block['offset_start']:05X}-${block['offset_end']:05X}",
            "# Token bytes are preserved as {HH}; confirmed hints use {HH:NAME}.",
            "",
        ]
        for record in block["records"]:
            text_lines.append(f"{record['offset']:05X}: {render_source_payload(record['payload'])}")
        (source_dir / filename).write_text("\n".join(text_lines) + "\n")
        source_manifest.append({
            "index": index, "offset_start": block["offset_start"], "offset_end": block["offset_end"],
            "record_count": len(block["records"]), "path": str(pathlib.Path("source-fragments") / filename),
        })
    write_json(source_dir / "manifest.json", {"image_sha256": sha256(data), "blocks": source_manifest})
    write_json(args.output / "manifest.json", {"image_sha256": sha256(data), "sectors": manifest, "mappings": {k: list(v) for k, v in MAPPINGS.items()}})


def do_analyze(args: argparse.Namespace) -> None:
    data = read_image(args.image)
    args.output.mkdir(parents=True, exist_ok=True)
    with (args.output / "sector-stats.csv").open("w", newline="") as handle:
        writer = csv.writer(handle)
        writer.writerow(["track", "stored_sector", "offset_hex", "sha256", "entropy", "zero_bytes", "high_bit_bytes", "distinct_bytes"])
        for track in range(TRACKS):
            for sector in range(SECTORS):
                start = coordinate_to_offset(track, sector)
                chunk = data[start : start + SECTOR_SIZE]
                writer.writerow([track, sector, f"0x{start:05x}", sha256(chunk), f"{entropy(chunk):.6f}", chunk.count(0), sum(b >= 128 for b in chunk), len(set(chunk))])
    boot = data[:SECTOR_SIZE]
    report = [
        "# Static baseline report", "",
        f"- Image SHA-256: `{sha256(data)}`", f"- Size: {len(data)} bytes", "- Geometry: 35 × 16 × 256 bytes",
        "- Filesystem probe: a2kit 4.4.2 reports no matching filesystem (probe only).", "",
        "## Boot-page observations", "",
        f"- `$0800` sector count: `{boot[0]}`; executable entry begins at `$0801`.",
        "- Absolute references to `$08A0`, `$08AC`, and `$08AD` anchor this sector at `$0800`.",
        "- `$08A0-$08AA`: `" + " ".join(f"{b:02X}" for b in boot[0xA0:0xAB]) + "`.",
        "- `JMP $BAB0` enters the relocated copy of sector offset `$B0` after logical sectors 0..5 load at `$BA00-$BFFF`.", "",
        "## Mapping candidates", "",
    ]
    for name, mapping in MAPPINGS.items():
        report.append(f"- `{name}` output-position→raw-file-position: `{','.join(str(n) for n in mapping)}` (round-trip exact)")
    report.extend(["", "The boot-stage discriminator confirms DOS-logical raw file order for track 0; this is not a filesystem conclusion.", ""])
    (args.output / "static-baseline.md").write_text("\n".join(report))
    root = pathlib.Path(__file__).resolve().parents[1]
    atlas = json.loads((root / "modules.json").read_text())
    write_json(args.output / "memory-map.json", atlas)
    lines = ["# Provisional memory and module atlas", "", f"Image: `{atlas['image_sha256']}`", ""]
    for module in atlas["modules"]:
        lines.extend([f"## {module['id']}", "", f"Verification: `{module['verification']}`", "", "Memory ranges:", ""])
        for region in module["memory_ranges"]:
            note = f" — {region['note']}" if "note" in region else ""
            lines.append(f"- `${region['start']:04X}-${region['end']:04X}` ({region['confidence']}){note}")
        lines.extend(["", "Entry points:", ""])
        for entry in module["entry_points"]:
            lines.append(f"- `${entry['address']:04X}` `{entry['name']}` ({entry['confidence']})")
        lines.extend(["", "Evidence: " + ", ".join(f"`{e}`" for e in module["evidence"]), ""])
    (args.output / "memory-map.md").write_text("\n".join(lines))
    load_lines = ["# Stage3 selector load scripts", "", "The loader decrements buffer page and logical sector together; crossing sector 0 decrements the track and resumes at sector 15.", ""]
    for selector_number in range(7):
        selector = decode_selector(data, selector_number)
        load_lines.extend([f"## Selector {selector_number}", "", f"Stream: `${selector['stream_address']:04X}`; terminal entry: `${selector['entry_point']:04X}`.", "", "| # | Source start | Count | Destination |", "| ---: | --- | ---: | --- |"])
        for load, _payload in selector["loads"]:
            load_lines.append(f"| {load['index']} | track {load['track']}, logical sector {load['sector']} | {load['count']} | `${load['memory_start']:04X}-${load['memory_end']:04X}` |")
        load_lines.append("")
    (args.output / "selector0-loads.md").write_text("\n".join(load_lines))
    source_blocks = scan_tokenized_source(data)
    source_lines = ["# Embedded tokenized-source index", "", "Detected length-prefixed, CR-terminated record runs. Token bytes remain undecoded.", "", "| # | Raw offsets | Records |", "| ---: | --- | ---: |"]
    for index, block in enumerate(source_blocks):
        source_lines.append(f"| {index} | `${block['offset_start']:05X}-${block['offset_end']:05X}` | {len(block['records'])} |")
    source_lines.append("")
    (args.output / "embedded-source-index.md").write_text("\n".join(source_lines))
    anchors = flow_anchor_records(data)
    write_json(args.output / "flow-anchor-map.json", {"image_sha256": sha256(data), "anchors": anchors})
    flow_lines = ["# Static flow-anchor map", "", "Exact text matches after optional Apple high-bit normalization. ASCII source records and high-bit runtime strings are listed separately.", "", "| Flow | Text | Encoding | Raw location | Loaded mappings |", "| --- | --- | --- | --- | --- |"]
    for record in anchors:
        mappings = ", ".join(f"selector {m['selector']} @ `${m['address']:04X}`" for m in record["mappings"]) or "not in decoded selector loads"
        escaped = record["text"].replace("|", "\\|")
        flow_lines.append(f"| `{record['flow_id']}` | {escaped} | {record['encoding']} | track {record['track']} sector {record['file_sector']} + `${record['within_sector']:02X}` | {mappings} |")
    flow_lines.append("")
    (args.output / "flow-anchor-map.md").write_text("\n".join(flow_lines))
    checkpoints = json.loads((root / "flow_checkpoints.json").read_text())
    checkpoint_lines = ["# Flow checkpoint coverage", "", "| Checkpoint | Status | Evidence | Static association |", "| --- | --- | --- | --- |"]
    for checkpoint in checkpoints["checkpoints"]:
        evidence = ", ".join(f"`{item}`" for item in checkpoint["evidence"]) or "—"
        checkpoint_lines.append(f"| `{checkpoint['id']}` | `{checkpoint['status']}` | {evidence} | {checkpoint['summary']} |")
    checkpoint_lines.append("")
    (args.output / "flow-checkpoints.md").write_text("\n".join(checkpoint_lines))
    campaign_flow = campaign_flow_mechanics(data)
    write_json(args.output.parent / "data" / "campaign-flow.json", campaign_flow)
    flow_report = [
        "# Demo-to-battle campaign flow", "",
        f"Image: `{campaign_flow['image_sha256']}`; evidence: " + ", ".join(f"`{item}`" for item in campaign_flow["evidence"]), "",
        "## Start transition", "",
    ]
    flow_report.extend(f"- {item}" for item in campaign_flow["start_transition"])
    flow_report.extend(["", "## Briefing, map, and battle", ""])
    flow_report.extend(f"- {item}" for item in campaign_flow["selector6_sequence"])
    flow_report.extend(["", "| Campaign index | City | Record address | Encoded bytes |", "| ---: | --- | --- | --- |"])
    for city in campaign_flow["campaign_cities"]:
        flow_report.append(f"| {city['campaign_index']} | {city['name']} | `${city['address_hex']}` | `{city['encoded_hex']}` |")
    flow_report.append("")
    (args.output / "campaign-flow.md").write_text("\n".join(flow_report))
    flight = helicopter_flight_mechanics(data)
    data_dir = args.output.parent / "data"
    write_json(data_dir / "helicopter-flight.json", flight)
    table = ", ".join(str(value) for value in flight["horizontal"]["target_velocity_signed"])
    flight_lines = [
        "# Helicopter flight mechanics", "",
        f"Image: `{flight['image_sha256']}`; evidence: " + ", ".join(f"`{item}`" for item in flight["evidence"]), "",
        "The routine at `$914C` resets the Apple II paddle timer at `$C070`, measures `$C064/$C065`, and caps each counter at 100.", "",
        "## Horizontal", "",
        f"- Raw input is divided by four and indexes `$998E`: `{table}`.",
        "- The selected value is a signed target velocity. `$981E-$9831` changes current velocity by −1, 0, or +1 per movement update until it reaches that target.",
        "- Position is 16-bit (`$632C,Y:$6394,Y`) and accepts movement within the statically observed `$0230-$0DD0` boundary checks.", "",
        "## Vertical", "",
        "- Target coordinate: `56 + floor(447 × raw / 256)` (`$01BF` scale), yielding 56..230 for capped samples.",
        "- `$97AC-$97D4` approaches the target by signed `(target-current) >> 3`; small positive differences force a +1 step.",
        "- The upper position clamp is `$DD` (221).", "",
        "Update cadence is unresolved, so these are original units per movement update—not pixels or seconds for the demake yet.", "",
    ]
    (args.output / "helicopter-flight.md").write_text("\n".join(flight_lines))
    service = helicopter_service_mechanics(data)
    write_json(data_dir / "helicopter-service.json", service)
    service_lines = [
        "# Helicopter fuel, damage, and pad service", "",
        f"Image: `{service['image_sha256']}`; evidence: " + ", ".join(f"`{item}`" for item in service["evidence"]), "",
        "## Fuel and warnings", "",
        "- `$6108,X` starts at 128. While not in pad service, `$934C-$937E` subtracts one when `($60C1 & $0F) == 0`; at ground coordinate `$DD`, the extra `$1F` gate halves that drain rate.",
        "- The HUD selects its low-fuel graphic below 34 (`$22`). Below 16 (`$10`) it also executes the critical sound path, which toggles the Apple II speaker at `$C030`.",
        "- Zero fuel enters the forced descent/crash path. Real-time cadence is unresolved, so all periods are in `$60C1` counter values.", "",
        "## Damage and service", "",
        "- `$659C,Y` is integrity/health: 15 is full. Pad service restores one every 4 counter values.",
        "- Field repair restores one every 8 counter values only at ground coordinate `$DD` with at least four carried men.",
        "- Standard pad service restores fuel and internal gun ammunition by one per service pass, bombs by one every 4 counter values, and smart missiles by one every 16.",
        "- Capacities are fuel 128, integrity 15, bombs 10, and smart missiles 2. The binary initializes 64 internal gun-shot units, while the manual says 50 rounds; both facts are retained as an unresolved representation discrepancy.",
        "- `$610C,X` becomes ready only after a service pass changes none of the tracked stores; the HUD consumes it together with the active pad-service flag `$60FC,X`.", "",
        "These are original state units and counter gates, not rates per second.", "",
    ]
    (args.output / "helicopter-service.md").write_text("\n".join(service_lines))
    timing = main_loop_timing(data)
    write_json(data_dir / "main-loop-timing.json", timing)
    timing_lines = [
        "# Main-loop timing", "",
        f"Image: `{timing['image_sha256']}`; evidence: `E-TIMING-001`", "",
        "- The main loop at `$69DD` calls the update/render wrapper at `$6A51` once on its normal iteration path.",
        "- `$6A6C` increments `$60C1`; overflow increments `$60C2`, forming a 16-bit completed-update counter.",
        "- No decoded selector load contains the operand bytes for `$C019`, so there is no direct vertical-blank status access in the recovered modules.",
        "- This proves counter-relative gates, not a fixed refresh rate: the update path has variable work and no static updates-per-second value is populated.", "",
    ]
    (args.output / "main-loop-timing.md").write_text("\n".join(timing_lines))
    combat = helicopter_combat_mechanics(data)
    write_json(data_dir / "helicopter-combat.json", combat)
    combat_lines = [
        "# Helicopter combat and damage", "",
        f"Image: `{combat['image_sha256']}`; evidence: `E-COMBAT-001`, `E-COMBAT-002`, `E-COMBAT-003`, `E-ECONOMY-001`, `E-STAGE-WEAPON-001`, `E-STAGE-BOMB-001`, `E-STRUCTURE-001`, `E-STRUCTURE-ROLE-001`, `E-OBJECT-CATALOG-001`", "",
        "- The common routine at `$AC26` subtracts `$60B3` from `$659C,Y`; equality or underflow destroys the target.",
        "- A new battlefield pass initializes both side-indexed cash pools to 15 bags. Balances carry across stage transitions, gain one bag per side every 56 completed object-update handler calls, and saturate at 255. The seconds conversion remains unresolved.",
        "- Replacement helicopters cost 20 bags on the interactive side-1 path. Ground-unit costs in M/T/A/D/E order are 5/4/3/2/5 bags.",
        "- Ground-unit command caps in M/T/A/D/E order are 26/6/7/8/29. Men and engineers share the same type-`$0D` counter; purchases are rejected when that counter is already at or above the selected command threshold.",
        "- M/T/A/D/E map to object types `$0D/$0E/$0F/$10/$0D`, initial integrity `5/15/6/9/5`, and secondary handlers `$7DF9/$7F1A/$7F76/$8027/$7DF9`. The dispatch lookup base is `$8467`; its type-0 word overlaps the preceding instruction.",
        "- `$7DF9` is the grounded-infantry handler. It searches for capturable type `$06/$16/$17` structures exactly five horizontal units behind; type `$09` is not selected by this path.",
        "- A type `$06` structure starts with integrity 47, linked type `$07/$08` components at 6/128, and stored infantry `0` in stage 1 or `1` in stages 2-8. Stored infantry enables repair toward 47; at two or more, an eight-count gate can consume one and attempt to produce a type `$0D` infantry object.",
        "- Infantry can deplete an opposing occupied structure, capture an empty opposing structure, or deposit into an eligible friendly structure. Capture changes ownership and loads raw old-owner strategy delays `255/180/120/84/72/60/48/24` for stages 1-8; these are not normalized seconds.",
        "- The fixed-object consumer chain identifies type `$04` as the helicopter launch/service pad and type `$05` as the time-machine objective. The DTV tests arrival at the opposing `$04` pad coordinate, destroys the linked `$05`, and sets battle completion. This corrects the earlier type-`$17` inference.",
        "- The linked `$06/$07/$08` assembly is a capturable bunker, barrage balloon, and mooring line. Type `$16` is an optional bunker; fixed type `$17` is the occupied machine-gun bunker that emits the four-damage projectile.",
        "- The player machine-gun projectile carries 2 damage units, the bomb 7, and the smart missile 21.",
        "- These values are initialized on the exact player firing paths and transferred through projectile integrity by the collision dispatcher at `$AFDC`.",
        "- Non-player type-`$0B` paths are the stationary gun `$09`, tank `$0E`, grounded men/engineers `$0D`, and fixed armed bunker `$17`. Their observed damage sets are `{5}`, `{1,2,3,4,5,15}`, `{1}`, and `{4}`.",
        "- Shared type-`$0B` lifecycle fields are horizontal velocity `$64CC`, vertical velocity `$6534`, acceleration `$67A4`, and life `$673C`; life starts at `10 + acceleration`.",
        "- Non-player fixed type-`$0B` fire uses horizontal velocity `+/-2` for grounded infantry `$0D` and armed bunker `$17`, `+/-2` or `+/-4` for tank `$0E`, zero vertical velocity/acceleration, and nominal unobstructed horizontal travel 20 or 40 original units. Type `$09` instead computes a predictive aimed velocity divided by eight with acceleration 1.",
        "- The type `$09` gun's helicopter range is strictly below 96 horizontal units and its shared fire range below 256, gated every 2 counter values. The type `$0F` missile carrier checks a below-256 range every 4 values and self-destructs after its one launch.",
        "- The player machine-gun direction table adds signed horizontal velocity `-8` or `+8` (with an unused zero entry) and selects vertical velocity `-2`, `0`, or `+2`; acceleration is zero.",
        "- Battles 1-4 use that 64-internal-unit machine-gun model. In battles 5-8, stage byte `$4069` selects a six-shot type-`$1A` projectile carrying 21 damage; it accelerates horizontally from `-1/+1` toward `-10/+10`, attempts one type-`$13` effect creation per airborne update, and rearms once every 8 eligible counter values.",
        "- The bomb inherits helicopter horizontal velocity, starts with zero vertical velocity, and adds 2 per armed update. The smart missile steers one circular angle step per update and creates type `$13` on impact.",
        "- Bomb ground aftermath changes in battle 4: stages 1-3 use destroyed state `$00` and standard type-`$11` effect code `$49`; stages 4-8 use state `$FF`, suppress that effect, and attempt a type-`$1D` transition that becomes collision-active type `$18` with eligible-infantry damage 4.",
        "- Collision-dispatched types `$14`, `$18`, and `$1C` contain the remaining fixed damage constant: 4 integrity units against ordinary type `$0D`/`$19` targets, subject to their handler-specific exclusions.",
        "- Destruction aftermath creates a short-lived type `$11` visual and table-controlled type `$0C` batches, then runs per-type cleanup. It contains no immediate radial-damage scan or damage write; weapon damage is resolved by collision.",
        "- Smoke size uses integrity tiers 10..15, 5..9, and 1..4. Its counter period is 8 above or equal to 7 integrity and 4 below 7.", "",
        "Damage values are original integrity units. Smoke and firing cadence remain counter-relative because updates per second are unresolved.", "",
    ]
    (args.output / "helicopter-combat.md").write_text("\n".join(combat_lines))
    strategy = strategy_mechanics(data)
    write_json(data_dir / "strategy.json", strategy)
    strategy_lines = [
        "# Automated strategy scripts", "",
        f"Image: `{strategy['image_sha256']}`; evidence: `E-STRATEGY-001`", "",
        "The selector-5 strategy module is table-driven: seven primary actions select fourteen secondary scripts, which dispatch seventeen first-phase handlers. The JSON preserves every script byte, offset, pointer, overlap, and statically proven gate.", "",
        "- The command table decodes through the common input dispatcher to engineers, demolition vehicles, AA missile carriers, tanks, and men (`E/D/A/T/M`).",
        "- Four eight-bit resource scores are compared by strict minimum, with ties retaining the higher index. Early stages force the third score to `$FF`, and index zero can be randomly remapped to `M`.",
        "- Same-page horizontal steering uses signed lookup tables and clamps farther targets to `+7/-7`. Logical positive index 27 deliberately overlaps the first type-`$0D` side-offset byte and therefore reads `$40`.",
        "- Hostile target scoring admits object types `$00/$0D/$0E/$10`, subtracts rank clearance, and chooses the smallest 16-bit horizontal score. Active-list structure makes type `$00` non-live in this scan.",
        "- Type-`$08` avoidance switches at 86 horizontal units; close-opponent firing uses a 10-unit vertical gate and a 64-counter cadence gate.",
        "- Nine 8-byte auxiliary progression rows and 37 flag bytes remain raw because their structure is proven but their higher-level tactical names are not.", "",
        "All cadence remains counter-relative, and random branch probabilities remain conditional on the unresolved entropy distribution.", "",
    ]
    (args.output / "strategy.md").write_text("\n".join(strategy_lines))
    catalog = object_type_catalog(data)
    write_json(data_dir / "object-type-catalog.json", catalog)
    catalog_lines = [
        "# Selector-5 object type catalog", "",
        f"Image: `{catalog['image_sha256']}`; evidence: `E-OBJECT-CATALOG-001`", "",
        "This catalog joins all 30 object types (`$00-$1D`) across the constructor, object-update, phase-update, collision, destruction-cleanup, size/default, and destruction-effect tables. Raw overlap bytes are retained, while non-callable or semantically inapplicable entries remain null.", "",
        "| Type | Role | Integrity initialization | Constructor | Object update | Phase update | Collision | Destruction cleanup |",
        "| --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for entry in catalog["entries"]:
        integrity = entry["integrity_initialization"]
        if integrity["kind"] == "fixed_on_primary_constructor_path":
            integrity_text = str(integrity["value"])
        elif integrity["kind"] == "randomized":
            integrity_text = "random 1..4"
        else:
            integrity_text = integrity["kind"].replace("_", " ")
        def cell(value: object) -> str:
            return "—" if value is None else f"`${value}`"
        catalog_lines.append(
            f"| `${entry['object_type_hex']}` | `{entry['role']}` | {integrity_text} | "
            f"{cell(entry['constructor_address_hex'])} | {cell(entry['object_update_handler_hex'])} | "
            f"{cell(entry['phase_update_handler_hex'])} | {cell(entry['collision_handler_hex'])} | "
            f"{cell(entry['destruction_cleanup_handler_hex'])} |"
        )
    catalog_lines.extend(["", catalog["integrity_note"], ""])
    (args.output / "object-type-catalog.md").write_text("\n".join(catalog_lines))
    scoring = scoring_mechanics(data)
    write_json(data_dir / "scoring.json", scoring)
    scoring_lines = [
        "# Packed-BCD scoring", "",
        f"Image: `{scoring['image_sha256']}`; evidence: `E-SCORE-001`", "",
        "- The four-digit score is packed BCD in `$0F:$0E`; `$9000-$9999` is interpreted as ten's-complement negative state.",
        "- Every 90 completed update wrappers, the live score loses one point while its high byte remains below `$90`. This period is not converted to seconds.",
        "- Object create/destroy events select one of nine adjustment groups and one of three overlapping state banks rooted at `$6E2F/$6E37`.",
        "- Battle-end accumulation adds each surviving object's type-specific high-nibble score value and a campaign bonus `100 + 50 × (stage − 1)`.",
        "- The same object byte's low nibble is added to the saturating `$6117` count.", "",
        "The JSON export preserves all 30 type groups, all three 9-value event banks, all 31 final object values, and stage bonuses 100..450.", "",
    ]
    (args.output / "scoring.md").write_text("\n".join(scoring_lines))
    battlefields = battlefield_mechanics(data)
    battlefields["bunker_durability"] = {
        "manual_scope_note": "The manual's informal durability categories are represented here by exact binary behavior rather than forced one-to-one names.",
        "types": {
            "06": {
                "role": "barrage_balloon_bunker",
                "initial_integrity": 47,
                "common_weapon_damage": "accepted while integrity is positive",
                "special_type_1C_destruction_path": False,
            },
            "16": {
                "role": "optional_bunker",
                "initial_integrity": 128,
                "common_weapon_damage": "ignored because the signed integrity byte is negative",
                "special_type_1C_destruction_path": True,
            },
            "17": {
                "role": "fixed_armed_bunker",
                "initial_integrity": 128,
                "common_weapon_damage": "ignored because the signed integrity byte is negative",
                "special_type_1C_destruction_path": True,
            },
        },
        "evidence": ["E-STRUCTURE-001", "E-STRUCTURE-ROLE-001", "E-OBJECT-CATALOG-001"],
    }
    write_json(data_dir / "battlefields.json", battlefields)
    battlefield_lines = [
        "# Battlefield definitions", "",
        f"Image: `{battlefields['image_sha256']}`; evidence: `E-BATTLEFIELD-001`, `E-STAGE-WEAPON-001`, `E-STAGE-BOMB-001`, `E-STAGE-PARAM-001`, `E-STRUCTURE-001`, `E-STRUCTURE-ROLE-001`, `E-OBJECT-CATALOG-001`", "",
        "The stage loader reads track 0, sector `stage + 6` into `$4000-$40FF`. "
        "The export retains each complete sector as hex while decoding only consumer-backed fields.", "",
        "## Layout", "",
        "- `$4000-$401F` and `$4020-$403F` are parallel 256-position bitfields for type `$06` barrage-balloon bunkers and type `$09` stationary guns.",
        "- `$4040-$405F` supplies the owner bit at each occupied position.",
        "- Grid position `n` maps to original horizontal coordinate `$0200 + 12*n`; the last grid position is `$0DF4`.",
        "- `$4060-$4063` gate one type `$04` and three type `$16` objects at fixed coordinates.",
        "- `$4068` switches bomb ground aftermath from the ordinary type-`$11` effect in battles 1-3 to a type-`$1D`/`$18` transition in battles 4-8. `$4069` selects the ordinary machine-gun model in battles 1-4 and the six-shot type-`$1A` alternate model in battles 5-8.",
        "- `$406D` supplies the initial type-`$06` stored-infantry count: 0 in stage 1 and 1 in stages 2-8. `$4064-$4067/$406A-$406B` are dead copied stores, while `$406C` and `$406E-$40FF` are not copied/read by selector 5; they remain raw non-consumed metadata/padding rather than invented gameplay parameters.", "",
        "## Campaign formations", "",
        "Selector-5 tables at `$792D-$79FA` add stage-specific demolition vehicles, tanks, infantry groups, and AA missile carriers. "
        "The JSON records both compact source records and every resulting object position.", "",
        "| Stage | Layout `$06` | Layout `$09` | Optional | Formation records | Formation objects | Bomb aftermath | Player gun model |", "| ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |",
    ]
    for stage in battlefields["stages"]:
        battlefield_lines.append(
            f"| {stage['stage']} | {stage['layout_count_by_type']['06']} | {stage['layout_count_by_type']['09']} | "
            f"{len(stage['optional_objects'])} | {stage['formation_record_count']} | {stage['formation_object_count']} | "
            f"{'type_1D_to_18' if stage['known_parameter_effects']['4068_to_60ED_alternate_bomb_aftermath_enabled'] else 'standard_type_11'} | "
            f"{stage['known_parameter_effects']['4069_player_weapon_profile']} |"
        )
    battlefield_lines.extend(["", "Coordinates are original 12-bit game units, not demake pixels.", ""])
    (args.output / "battlefields.md").write_text("\n".join(battlefield_lines))

    export_specs = [
        ("campaign_flow", "campaign-flow.json", campaign_flow),
        ("helicopter_flight", "helicopter-flight.json", flight),
        ("helicopter_service", "helicopter-service.json", service),
        ("main_loop_timing", "main-loop-timing.json", timing),
        ("helicopter_combat", "helicopter-combat.json", combat),
        ("strategy", "strategy.json", strategy),
        ("object_type_catalog", "object-type-catalog.json", catalog),
        ("scoring", "scoring.json", scoring),
        ("battlefields", "battlefields.json", battlefields),
    ]
    write_json(data_dir / "demake-export.json", {
        "schema_version": "1.0.0",
        "source_image_sha256": sha256(data),
        "representation_policy": {
            "default": "original binary units and signedness",
            "normalized_values": "present only where a statically proved conversion is documented",
            "real_time_cadence": None,
            "demake_pixel_conversion": None,
        },
        "exports": [
            {
                "id": export_id,
                "path": filename,
                "sha256": sha256((data_dir / filename).read_bytes()),
                "evidence": value["evidence"],
            }
            for export_id, filename, value in export_specs
        ],
        "unresolved": [
            "completed update wrappers per real-time second",
            "entropy distribution rather than conditional branch fractions",
            "higher-level tactical names for nine strategy progression rows and 37 auxiliary flag bytes",
        ],
    })


def do_disassemble(args: argparse.Namespace) -> None:
    data = read_image(args.image)
    args.output.mkdir(parents=True, exist_ok=True)
    boot = args.output / "boot-sector.bin"
    boot.write_bytes(data[:SECTOR_SIZE])
    info = pathlib.Path(__file__).resolve().parents[1] / "config" / "boot.info"
    listing = args.output / "boot-sector.da65.s"
    run = subprocess.run(["da65", "--cpu", "6502", "--start-addr", "0x0800", "--info", str(info), "--comments", "4", "-o", str(listing), str(boot)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    normalize_da65_header(listing)
    root = pathlib.Path(__file__).resolve().parents[1]
    source = root / "src" / "boot" / "boot_sector.s"
    obj = args.output / "boot-sector.o"
    include_dir = args.output.parent / "extract" / "stored"
    run = subprocess.run(["ca65", "--bin-include-dir", str(include_dir), "-o", str(obj), str(source)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    rebuilt = args.output / "boot-sector.rebuilt.bin"
    run = subprocess.run(["ld65", "-C", str(root / "config" / "boot.cfg"), "-o", str(rebuilt), str(obj)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    if rebuilt.read_bytes() != data[:SECTOR_SIZE]:
        raise SystemExit("source-exact boot-sector rebuild mismatch")
    stage1 = args.output.parent / "extract" / "stage1-ba00-bfff.bin"
    stage1_listing = args.output / "stage1-ba00-bfff.da65.s"
    run = subprocess.run(["da65", "--cpu", "6502", "--start-addr", "0xBA00", "--comments", "4", "-o", str(stage1_listing), str(stage1)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    normalize_da65_header(stage1_listing)
    stage1_source = root / "src" / "stage1" / "stage1_loader.s"
    stage1_obj = args.output / "stage1-ba00-bfff.o"
    stage1_include_dir = args.output.parent / "extract"
    run = subprocess.run(["ca65", "--bin-include-dir", str(stage1_include_dir), "-o", str(stage1_obj), str(stage1_source)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    stage1_rebuilt = args.output / "stage1-ba00-bfff.rebuilt.bin"
    run = subprocess.run(["ld65", "-C", str(root / "config" / "stage1.cfg"), "-o", str(stage1_rebuilt), str(stage1_obj)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    if stage1_rebuilt.read_bytes() != stage1.read_bytes():
        raise SystemExit("source-exact stage-1 rebuild mismatch")
    stage3_source = root / "src" / "stage3" / "stage3_stream.s"
    stage3_obj = args.output / "stage3-4000-43ff.o"
    run = subprocess.run(["ca65", "--bin-include-dir", str(stage1_include_dir), "-o", str(stage3_obj), str(stage3_source)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    stage3_rebuilt = args.output / "stage3-4000-43ff.rebuilt.bin"
    run = subprocess.run(["ld65", "-C", str(root / "config" / "stage3.cfg"), "-o", str(stage3_rebuilt), str(stage3_obj)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    if stage3_rebuilt.read_bytes() != (args.output.parent / "extract" / "stage3-4000-43ff.bin").read_bytes():
        raise SystemExit("source-exact stage-3 rebuild mismatch")
    for stem, source_name, config_name in (
        ("selector0-load03-0800-1fff", "opening.s", "selector0-opening.cfg"),
        ("selector0-load05-6000-67ff", "entry.s", "selector0-entry.cfg"),
    ):
        selector0_source = root / "src" / "selector0" / source_name
        selector0_obj = args.output / f"{stem}.o"
        run = subprocess.run(["ca65", "-I", str(selector0_source.parent), "--bin-include-dir", str(stage1_include_dir), "-o", str(selector0_obj), str(selector0_source)], text=True, capture_output=True)
        if run.returncode:
            raise SystemExit(run.stderr or run.stdout)
        selector0_rebuilt = args.output / f"{stem}.rebuilt.bin"
        run = subprocess.run(["ld65", "-C", str(root / "config" / config_name), "-o", str(selector0_rebuilt), str(selector0_obj)], text=True, capture_output=True)
        if run.returncode:
            raise SystemExit(run.stderr or run.stdout)
        if selector0_rebuilt.read_bytes() != (args.output.parent / "extract" / f"{stem}.bin").read_bytes():
            raise SystemExit(f"source-exact {stem} promoted-region rebuild mismatch")
    selector5_source = root / "src" / "selector5" / "flight.s"
    selector5_obj = args.output / "selector5-load00-6900-baff.o"
    run = subprocess.run(["ca65", "--bin-include-dir", str(stage1_include_dir), "-o", str(selector5_obj), str(selector5_source)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    selector5_rebuilt = args.output / "selector5-load00-6900-baff.rebuilt.bin"
    run = subprocess.run(["ld65", "-C", str(root / "config" / "selector5.cfg"), "-o", str(selector5_rebuilt), str(selector5_obj)], text=True, capture_output=True)
    if run.returncode:
        raise SystemExit(run.stderr or run.stdout)
    if selector5_rebuilt.read_bytes() != (args.output.parent / "extract" / "selector5-load00-6900-baff.bin").read_bytes():
        raise SystemExit("source-exact complete selector-5 rebuild mismatch")
    for filename, origin in (("stage2-6000-70ff.bin", "0x6000"), ("stage3-4000-43ff.bin", "0x4000"), ("selector0-load03-0800-1fff.bin", "0x0800"), ("selector0-load05-6000-67ff.bin", "0x6000"), ("selector1-load04-6900-69ff.bin", "0x6900"), ("selector2-load00-8000-83ff.bin", "0x8000"), ("selector5-load00-6900-baff.bin", "0x6900"), ("selector6-load00-8000-87ff.bin", "0x8000"), ("selector6-load01-a100-a4ff.bin", "0xA100"), ("selector6-load02-7800-7aff.bin", "0x7800"), ("selector6-load03-a000-a0ff.bin", "0xA000")):
        binary = args.output.parent / "extract" / filename
        target = args.output / filename.replace(".bin", ".da65.s")
        command = ["da65", "--cpu", "6502", "--start-addr", origin, "--comments", "4"]
        if filename == "stage2-6000-70ff.bin":
            command.extend(["--info", str(root / "config" / "stage2.info")])
        if filename == "selector6-load00-8000-87ff.bin":
            command.extend(["--info", str(root / "config" / "selector6.info")])
        selector6_companion_info = {
            "selector6-load01-a100-a4ff.bin": "selector6-load01.info",
            "selector6-load02-7800-7aff.bin": "selector6-load02.info",
            "selector6-load03-a000-a0ff.bin": "selector6-load03.info",
        }.get(filename)
        if selector6_companion_info:
            command.extend(["--info", str(root / "config" / selector6_companion_info)])
        command.extend(["-o", str(target), str(binary)])
        run = subprocess.run(command, text=True, capture_output=True)
        if run.returncode:
            raise SystemExit(run.stderr or run.stdout)
        normalize_da65_header(target)
        generated_source = {
            "stage2-6000-70ff.bin": ("STAGE2", "stage2.cfg", "stage-2"),
            "selector6-load00-8000-87ff.bin": ("SELECTOR6", "selector6.cfg", "selector-6 main-load"),
            "selector6-load01-a100-a4ff.bin": ("SELECTOR6A1", "selector6-load01.cfg", "selector-6 bitmap/font load"),
            "selector6-load02-7800-7aff.bin": ("SELECTOR678", "selector6-load02.cfg", "selector-6 disk/graphics load"),
            "selector6-load03-a000-a0ff.bin": ("SELECTOR6A0", "selector6-load03.cfg", "selector-6 renderer/prompt load"),
        }.get(filename)
        if generated_source:
            segment, config_name, description = generated_source
            listing = target.read_text()
            cpu_directive = '        .setcpu "6502"\n'
            if listing.count(cpu_directive) != 1:
                raise SystemExit(f"{description} generated-source CPU directive drift")
            target.write_text(listing.replace(
                cpu_directive,
                cpu_directive + f'        .segment "{segment}"\n',
            ))
            generated_obj = args.output / filename.replace(".bin", ".o")
            run = subprocess.run(["ca65", "-o", str(generated_obj), str(target)], text=True, capture_output=True)
            if run.returncode:
                raise SystemExit(run.stderr or run.stdout)
            generated_rebuilt = args.output / filename.replace(".bin", ".rebuilt.bin")
            run = subprocess.run([
                "ld65", "-C", str(root / "config" / config_name),
                "-o", str(generated_rebuilt), str(generated_obj),
            ], text=True, capture_output=True)
            if run.returncode:
                raise SystemExit(run.stderr or run.stdout)
            if generated_rebuilt.read_bytes() != binary.read_bytes():
                raise SystemExit(f"source-exact {description} rebuild mismatch")
    # ca65 embeds build-time metadata in object files. They are disposable
    # linker intermediates, so omit them from the deterministic artifact set.
    for object_path in args.output.glob("*.o"):
        object_path.unlink()


def do_rebuild(args: argparse.Namespace) -> None:
    canonical = read_image(args.image)
    if sha256(canonical) != EXPECTED_SHA256:
        raise SystemExit("input hash drift")

    extract_dir = args.build / "extract"
    disassembly_dir = args.build / "disassembly"
    extraction = json.loads((extract_dir / "manifest.json").read_text())
    sectors = extraction["sectors"]
    if extraction["image_sha256"] != EXPECTED_SHA256 or len(sectors) != TRACKS * SECTORS:
        raise SystemExit("invalid extraction manifest for rebuild")

    candidate = bytearray(IMAGE_SIZE)
    covered = bytearray(IMAGE_SIZE)
    for item in sectors:
        payload = (extract_dir / item["path"]).read_bytes()
        if len(payload) != SECTOR_SIZE or sha256(payload) != item["sha256"]:
            raise SystemExit(f"rebuild sector artifact drift: {item['path']}")
        start = item["offset"]
        end = start + SECTOR_SIZE
        if any(covered[start:end]):
            raise SystemExit(f"overlapping rebuild sector artifact: {item['path']}")
        candidate[start:end] = payload
        covered[start:end] = b"\x01" * SECTOR_SIZE
    if not all(covered):
        raise SystemExit("rebuild sector set does not cover the complete image")

    replacements: list[dict[str, object]] = []

    def replace_linear(replacement_id: str, artifact_name: str, image_offset: int) -> None:
        payload = (disassembly_dir / artifact_name).read_bytes()
        end = image_offset + len(payload)
        if end > IMAGE_SIZE:
            raise SystemExit(f"source replacement outside image: {replacement_id}")
        candidate[image_offset:end] = payload
        replacements.append({
            "id": replacement_id,
            "artifact": str(pathlib.Path("disassembly") / artifact_name),
            "image_offset_start": image_offset,
            "image_offset_end": end - 1,
            "size": len(payload),
            "sha256": sha256(payload),
        })

    def replace_selector_load(selector_number: int, load_index: int, artifact_name: str) -> None:
        selector = json.loads((extract_dir / f"selector{selector_number}-loads.json").read_text())
        matches = [load for load in selector["loads"] if load["index"] == load_index]
        if len(matches) != 1:
            raise SystemExit(f"selector-{selector_number} load {load_index} is not uniquely mapped")
        load = matches[0]
        payload = (disassembly_dir / artifact_name).read_bytes()
        if len(payload) != load["count"] * SECTOR_SIZE:
            raise SystemExit(f"source replacement size drift: {artifact_name}")
        touched = []
        for read in load["reads"]:
            payload_offset = read["page"] * SECTOR_SIZE - load["memory_start"]
            chunk = payload[payload_offset : payload_offset + SECTOR_SIZE]
            if len(chunk) != SECTOR_SIZE:
                raise SystemExit(f"source replacement page mapping drift: {artifact_name}")
            image_offset = coordinate_to_offset(read["track"], read["file_sector"])
            candidate[image_offset : image_offset + SECTOR_SIZE] = chunk
            touched.append({
                "track": read["track"],
                "file_sector": read["file_sector"],
                "page": read["page"],
                "image_offset": image_offset,
            })
        replacements.append({
            "id": f"selector{selector_number}-load{load_index:02d}",
            "artifact": str(pathlib.Path("disassembly") / artifact_name),
            "memory_start": load["memory_start"],
            "memory_end": load["memory_end"],
            "size": len(payload),
            "sha256": sha256(payload),
            "sectors": touched,
        })

    def replace_stage2(artifact_name: str) -> None:
        payload = (disassembly_dir / artifact_name).read_bytes()
        if len(payload) != 0x1100:
            raise SystemExit("stage-2 source replacement size drift")
        touched = []
        coordinates = [(19, sector) for sector in range(16)] + [(20, 12)]
        for index, (track, file_sector) in enumerate(coordinates):
            image_offset = coordinate_to_offset(track, file_sector)
            chunk = payload[index * SECTOR_SIZE : (index + 1) * SECTOR_SIZE]
            candidate[image_offset : image_offset + SECTOR_SIZE] = chunk
            touched.append({
                "track": track,
                "file_sector": file_sector,
                "page": 0x60 + index,
                "image_offset": image_offset,
            })
        replacements.append({
            "id": "stage2",
            "artifact": str(pathlib.Path("disassembly") / artifact_name),
            "memory_start": 0x6000,
            "memory_end": 0x70FF,
            "size": len(payload),
            "sha256": sha256(payload),
            "sectors": touched,
        })

    # Reinsert every complete source-exact disk-backed artifact. Stage 1
    # intentionally overlaps the boot sector; both are independently rebuilt.
    replace_linear("stage1", "stage1-ba00-bfff.rebuilt.bin", coordinate_to_offset(0, 0))
    replace_linear("boot-sector", "boot-sector.rebuilt.bin", coordinate_to_offset(0, 0))
    replace_stage2("stage2-6000-70ff.rebuilt.bin")
    replace_linear("stage3", "stage3-4000-43ff.rebuilt.bin", coordinate_to_offset(21, 0))
    replace_selector_load(0, 3, "selector0-load03-0800-1fff.rebuilt.bin")
    replace_selector_load(0, 5, "selector0-load05-6000-67ff.rebuilt.bin")
    replace_selector_load(5, 0, "selector5-load00-6900-baff.rebuilt.bin")
    replace_selector_load(6, 0, "selector6-load00-8000-87ff.rebuilt.bin")
    replace_selector_load(6, 1, "selector6-load01-a100-a4ff.rebuilt.bin")
    replace_selector_load(6, 2, "selector6-load02-7800-7aff.rebuilt.bin")
    replace_selector_load(6, 3, "selector6-load03-a000-a0ff.rebuilt.bin")

    rebuilt = bytes(candidate)
    args.output.mkdir(parents=True, exist_ok=True)
    image_path = args.output / "rescue-raiders-rebuilt.dsk"
    image_path.write_bytes(rebuilt)
    write_json(args.output / "manifest.json", {
        "source_image_sha256": EXPECTED_SHA256,
        "candidate_path": image_path.name,
        "candidate_size": len(rebuilt),
        "candidate_sha256": sha256(rebuilt),
        "byte_identical_to_canonical": rebuilt == canonical,
        "base_sector_count": len(sectors),
        "source_exact_replacements": replacements,
    })
    if rebuilt != canonical:
        raise SystemExit("source-exact rebuilt disk differs from canonical image")


def do_assets(args: argparse.Namespace) -> None:
    canonical = read_image(args.image)
    if sha256(canonical) != EXPECTED_SHA256:
        raise SystemExit("input hash drift")
    opening = (args.build / "disassembly" / "selector0-load03-0800-1fff.rebuilt.bin").read_bytes()
    if len(opening) != 0x1800:
        raise SystemExit("selector-0 opening artifact size drift for assets")

    if args.output.exists():
        shutil.rmtree(args.output)
    raw_dir = args.output / "raw"
    font_dir = args.output / "decoded" / "title-font"
    bitmap_dir = args.output / "decoded" / "title-bitmaps"
    descriptor_dir = raw_dir / "title-bitmap-descriptors"
    gameplay_span_dir = raw_dir / "gameplay-loader-spans"
    gameplay_bank_dir = raw_dir / "gameplay-sprite-banks"
    gameplay_descriptor_dir = raw_dir / "gameplay-sprite-descriptors"
    sound_dir = raw_dir / "synthesized-sound"
    procedural_raw_dir = raw_dir / "procedural-graphics"
    procedural_decoded_dir = args.output / "decoded" / "procedural-fill-patterns"
    gameplay_decoded_dir = args.output / "decoded" / "gameplay-sprites"
    for directory in (
        raw_dir, font_dir, bitmap_dir, descriptor_dir, gameplay_span_dir,
        gameplay_bank_dir, gameplay_descriptor_dir, sound_dir,
        procedural_raw_dir, procedural_decoded_dir, gameplay_decoded_dir,
    ):
        directory.mkdir(parents=True, exist_ok=True)

    def decode_rows(payload: bytes, width_bytes: int, height: int) -> list[list[int]]:
        if len(payload) != width_bytes * height:
            raise ValueError("packed HGR payload size does not match dimensions")
        rows = []
        for row in range(height):
            pixels = []
            for value in payload[row * width_bytes : (row + 1) * width_bytes]:
                pixels.extend((value >> bit) & 1 for bit in range(7))
            rows.append(pixels)
        return rows

    def encode_rows(rows: list[list[int]], width_bytes: int) -> bytes:
        encoded = bytearray()
        expected_width = width_bytes * 7
        for row in rows:
            if len(row) != expected_width:
                raise ValueError("decoded HGR row width drift")
            for column in range(0, expected_width, 7):
                value = 0
                for bit, pixel in enumerate(row[column : column + 7]):
                    if pixel not in (0, 1):
                        raise ValueError("decoded HGR pixel outside binary domain")
                    value |= pixel << bit
                encoded.append(value)
        return bytes(encoded)

    def decode_hgr_rows_with_phase(payload: bytes, width_bytes: int, height: int) -> tuple[list[list[int]], list[list[int]]]:
        if len(payload) != width_bytes * height:
            raise ValueError("packed HGR sprite payload size does not match dimensions")
        rows = []
        phases = []
        for row in range(height):
            pixels = []
            phase_row = []
            for value in payload[row * width_bytes : (row + 1) * width_bytes]:
                pixels.extend((value >> bit) & 1 for bit in range(7))
                phase_row.append((value >> 7) & 1)
            rows.append(pixels)
            phases.append(phase_row)
        return rows, phases

    def encode_hgr_rows_with_phase(rows: list[list[int]], phases: list[list[int]], width_bytes: int) -> bytes:
        if len(rows) != len(phases):
            raise ValueError("HGR sprite phase-plane height drift")
        encoded = bytearray()
        expected_width = width_bytes * 7
        for row, phase_row in zip(rows, phases):
            if len(row) != expected_width or len(phase_row) != width_bytes:
                raise ValueError("HGR sprite decoded dimensions drift")
            for byte_index, column in enumerate(range(0, expected_width, 7)):
                value = phase_row[byte_index] << 7
                for bit, pixel in enumerate(row[column : column + 7]):
                    if pixel not in (0, 1):
                        raise ValueError("decoded HGR sprite pixel outside binary domain")
                    value |= pixel << bit
                encoded.append(value)
        return bytes(encoded)

    def write_pgm(path: pathlib.Path, rows: list[list[int]]) -> None:
        height = len(rows)
        width = len(rows[0]) if rows else 0
        if not width or any(len(row) != width for row in rows):
            raise ValueError("invalid decoded image dimensions")
        pixels = bytes(255 if pixel else 0 for row in rows for pixel in row)
        path.write_bytes(f"P5\n{width} {height}\n255\n".encode("ascii") + pixels)

    font = opening[0x0D00:0x0F00]
    if len(font) != 64 * 8:
        raise SystemExit("title font asset boundary drift")
    font_raw_path = raw_dir / "title-font-64x8.bin"
    font_raw_path.write_bytes(font)
    glyphs = []
    for index in range(64):
        glyph_raw = font[index * 8 : (index + 1) * 8]
        rows = decode_rows(glyph_raw, 1, 8)
        if encode_rows(rows, 1) != glyph_raw:
            raise SystemExit(f"title font glyph {index} failed round trip")
        path = font_dir / f"glyph-{index:02d}.pgm"
        write_pgm(path, rows)
        glyphs.append({
            "index": index,
            "raw_offset": index * 8,
            "raw_size": len(glyph_raw),
            "raw_sha256": sha256(glyph_raw),
            "decoded_path": str(path.relative_to(args.output)),
            "decoded_width": 7,
            "decoded_height": 8,
        })

    bitmap_region = opening[0x0F00:0x1800]
    bitmap_raw_path = raw_dir / "title-bitmap-region.bin"
    bitmap_raw_path.write_bytes(bitmap_region)
    offsets = [bitmap_region[index * 2] | (bitmap_region[index * 2 + 1] << 8) for index in range(38)]
    if offsets[0] != 76 or offsets != sorted(offsets) or len(set(offsets)) != 38:
        raise SystemExit("title bitmap descriptor pointer table drift")
    descriptors = []
    for index, offset in enumerate(offsets):
        if offset + 2 > len(bitmap_region):
            raise SystemExit(f"title bitmap descriptor {index} outside region")
        width_bytes, height = bitmap_region[offset : offset + 2]
        end = offset + 2 + width_bytes * height
        next_offset = offsets[index + 1] if index + 1 < len(offsets) else end
        if end > len(bitmap_region) or (index + 1 < len(offsets) and end != next_offset):
            raise SystemExit(f"title bitmap descriptor {index} boundary drift")
        descriptor = bitmap_region[offset:end]
        payload = descriptor[2:]
        rows = decode_rows(payload, width_bytes, height)
        if encode_rows(rows, width_bytes) != payload:
            raise SystemExit(f"title bitmap descriptor {index} failed round trip")
        raw_path = descriptor_dir / f"descriptor-{index:02d}.bin"
        decoded_path = bitmap_dir / f"bitmap-{index:02d}.pgm"
        raw_path.write_bytes(descriptor)
        write_pgm(decoded_path, rows)
        descriptors.append({
            "index": index,
            "region_offset": offset,
            "memory_address": 0x1700 + offset,
            "width_bytes": width_bytes,
            "decoded_width": width_bytes * 7,
            "decoded_height": height,
            "raw_size": len(descriptor),
            "raw_sha256": sha256(descriptor),
            "raw_path": str(raw_path.relative_to(args.output)),
            "decoded_path": str(decoded_path.relative_to(args.output)),
        })

    # The selector-5 loader at $6BEC starts at track $18, sector $0F and
    # performs four consecutive backward loads. The third span is deliberately
    # overwritten by the fourth; retain it as provenance while exporting the
    # three effective descriptor banks left in memory.
    gameplay_span_specs = (
        ("d000-d3ff", 0xD3, 4, 0xD000),
        ("1900-1fff", 0x1F, 7, 0x1900),
        ("e000-e1ff-overwritten", 0xE1, 2, 0xE000),
        ("e000-eaff", 0xEA, 11, 0xE000),
    )
    track, sector = 0x18, 0x0F
    gameplay_spans = []
    effective_banks: dict[str, tuple[int, bytes, str]] = {}
    for name, page, count, memory_start in gameplay_span_specs:
        payload, reads = backward_load(canonical, track, sector, page, count)
        raw_path = gameplay_span_dir / f"{name}.bin"
        raw_path.write_bytes(payload)
        gameplay_spans.append({
            "name": name,
            "memory_start": memory_start,
            "memory_end": memory_start + len(payload) - 1,
            "page_count": count,
            "raw_path": str(raw_path.relative_to(args.output)),
            "raw_size": len(payload),
            "raw_sha256": sha256(payload),
            "reads": reads,
            "overwritten_before_render": name == "e000-e1ff-overwritten",
        })
        if name == "d000-d3ff":
            effective_banks["d000"] = (memory_start, payload, name)
        elif name == "1900-1fff":
            effective_banks["1900"] = (memory_start, payload, name)
        elif name == "e000-eaff":
            effective_banks["e000"] = (memory_start, payload, name)
        for _ in range(count):
            if sector == 0:
                track -= 1
                sector = 15
            else:
                sector -= 1

    expected_gameplay_counts = {"1900": 78, "d000": 14, "e000": 73}
    gameplay_banks = []
    for bank_name in ("1900", "d000", "e000"):
        memory_start, bank, source_span = effective_banks[bank_name]
        descriptor_count = bank[0]
        if descriptor_count != expected_gameplay_counts[bank_name]:
            raise SystemExit(f"gameplay sprite bank {bank_name} count drift")
        pointer_table_end = 3 + descriptor_count * 2
        pointers = [
            bank[3 + index * 2] | (bank[4 + index * 2] << 8)
            for index in range(descriptor_count)
        ]
        if pointers[0] != pointer_table_end or pointers != sorted(pointers) or len(set(pointers)) != descriptor_count:
            raise SystemExit(f"gameplay sprite bank {bank_name} pointer table drift")
        bank_raw_path = gameplay_bank_dir / f"bank-{bank_name}.bin"
        bank_raw_path.write_bytes(bank)
        bank_decoded_dir = gameplay_decoded_dir / bank_name
        bank_decoded_dir.mkdir(parents=True, exist_ok=True)
        bank_descriptors = []
        for index, offset in enumerate(pointers):
            if offset + 4 > len(bank):
                raise SystemExit(f"gameplay sprite {bank_name}:{index} header outside bank")
            x_raw, y_raw, width_bytes, height = bank[offset : offset + 4]
            end = offset + 4 + width_bytes * height
            next_offset = pointers[index + 1] if index + 1 < descriptor_count else end
            if not width_bytes or not height or end > len(bank) or end != next_offset:
                raise SystemExit(f"gameplay sprite {bank_name}:{index} boundary drift")
            descriptor = bank[offset:end]
            payload = descriptor[4:]
            rows, phase_rows = decode_hgr_rows_with_phase(payload, width_bytes, height)
            if encode_hgr_rows_with_phase(rows, phase_rows, width_bytes) != payload:
                raise SystemExit(f"gameplay sprite {bank_name}:{index} failed round trip")
            raw_path = gameplay_descriptor_dir / f"{bank_name}-{index:02d}.bin"
            decoded_path = bank_decoded_dir / f"sprite-{index:02d}.pgm"
            raw_path.write_bytes(descriptor)
            write_pgm(decoded_path, rows)
            bank_descriptors.append({
                "index": index,
                "bank_offset": offset,
                "memory_address": memory_start + offset,
                "x_offset_signed": x_raw - 256 if x_raw >= 128 else x_raw,
                "y_offset_signed": y_raw - 256 if y_raw >= 128 else y_raw,
                "width_bytes": width_bytes,
                "decoded_width": width_bytes * 7,
                "decoded_height": height,
                "phase_bit_count": sum(sum(row) for row in phase_rows),
                "raw_size": len(descriptor),
                "raw_sha256": sha256(descriptor),
                "raw_path": str(raw_path.relative_to(args.output)),
                "decoded_path": str(decoded_path.relative_to(args.output)),
            })
        residual_start = pointers[-1] + bank_descriptors[-1]["raw_size"]
        gameplay_banks.append({
            "name": bank_name,
            "memory_start": memory_start,
            "memory_end": memory_start + len(bank) - 1,
            "source_span": source_span,
            "header_count": descriptor_count,
            "header_metadata_hex": bank[1:3].hex().upper(),
            "pointer_table_start": 3,
            "pointer_table_end": pointer_table_end - 1,
            "raw_path": str(bank_raw_path.relative_to(args.output)),
            "raw_size": len(bank),
            "raw_sha256": sha256(bank),
            "descriptor_count": len(bank_descriptors),
            "descriptors": bank_descriptors,
            "residual_start": memory_start + residual_start,
            "residual_end": memory_start + len(bank) - 1,
        })

    # Every literal $C030 operand in the boot/stage/decoded-selector corpus was
    # classified before defining these fixtures.  Keep the byte ranges here so
    # the sound claims remain reproducible without assigning sample/note-stream
    # semantics to code that synthesizes speaker transitions directly.
    sound_artifacts = {
        "selector0-d000": ("extract/selector0-load00-d000-ffff.bin", 0xD000),
        "selector1-6900": ("extract/selector1-load04-6900-69ff.bin", 0x6900),
        "selector5-6900": ("extract/selector5-load00-6900-baff.bin", 0x6900),
        "stage1-ba00": ("extract/stage1-ba00-bfff.bin", 0xBA00),
        "stage2-6000": ("extract/stage2-6000-70ff.bin", 0x6000),
        "stage3-4000": ("extract/stage3-4000-43ff.bin", 0x4000),
    }
    sound_payloads = {
        name: (args.build / relative_path).read_bytes()
        for name, (relative_path, _) in sound_artifacts.items()
    }

    def export_sound_fixture(name: str, artifact: str, start: int, end: int, classification: str) -> dict:
        relative_source, origin = sound_artifacts[artifact]
        payload = sound_payloads[artifact]
        if start < origin or end < start or end >= origin + len(payload):
            raise SystemExit(f"synthesized-sound fixture boundary drift: {name}")
        raw = payload[start - origin : end - origin + 1]
        path = sound_dir / f"{name}.bin"
        path.write_bytes(raw)
        return {
            "name": name,
            "classification": classification,
            "source_artifact": relative_source,
            "memory_start": start,
            "memory_end": end,
            "raw_path": str(path.relative_to(args.output)),
            "raw_size": len(raw),
            "raw_sha256": sha256(raw),
        }

    shared_sound_fixtures = [
        export_sound_fixture(
            "graphics-transform-toggle-loop-selector0", "selector0-d000", 0xE0C1, 0xE104,
            "executed presentation/graphics transform with speaker side effect",
        ),
        export_sound_fixture(
            "graphics-transform-toggle-loop-stage2", "stage2-6000", 0x60C1, 0x6104,
            "byte-identical relocated execution copy",
        ),
        export_sound_fixture(
            "invalid-input-beep", "selector0-d000", 0xF323, 0xF338,
            "executed bounded input-error effect",
        ),
        export_sound_fixture(
            "paired-toggle-tone-engine", "selector0-d000", 0xF420, 0xF445,
            "executed parameterized synthesized-tone service",
        ),
        export_sound_fixture(
            "presentation-sweep", "selector0-d000", 0xF446, 0xF461,
            "executed bounded presentation effect",
        ),
        export_sound_fixture(
            "shared-delay-toggle-selector1", "selector1-6900", 0x6972, 0x697C,
            "callable shared service; no internal selector-1 call site claimed",
        ),
        export_sound_fixture(
            "shared-delay-toggle-selector5", "selector5-6900", 0x6972, 0x697C,
            "byte-identical gameplay-used copy also covered by E-SOUND-001",
        ),
        export_sound_fixture(
            "stage1-overwrite-workspace-false-positive", "stage1-ba00", 0xBED9, 0xBEEF,
            "inert initial RWTS scratch bytes; no recovered control-flow entry",
        ),
        export_sound_fixture(
            "stage3-overwrite-workspace-false-positive", "stage3-4000", 0x43D9, 0x43EF,
            "inert initial interpreter workspace bytes; no recovered control-flow entry",
        ),
    ]
    fixture_by_name = {item["name"]: item for item in shared_sound_fixtures}
    if fixture_by_name["graphics-transform-toggle-loop-selector0"]["raw_sha256"] != fixture_by_name["graphics-transform-toggle-loop-stage2"]["raw_sha256"]:
        raise SystemExit("relocated graphics-transform speaker loop drift")
    if fixture_by_name["shared-delay-toggle-selector1"]["raw_sha256"] != fixture_by_name["shared-delay-toggle-selector5"]["raw_sha256"]:
        raise SystemExit("shared delay/toggle routine copy drift")
    if fixture_by_name["stage1-overwrite-workspace-false-positive"]["raw_sha256"] != fixture_by_name["stage3-overwrite-workspace-false-positive"]["raw_sha256"]:
        raise SystemExit("duplicate overwrite-workspace bytes drift")

    selector0_entry = (args.build / "disassembly" / "selector0-load05-6000-67ff.rebuilt.bin").read_bytes()
    selector5 = (args.build / "disassembly" / "selector5-load00-6900-baff.rebuilt.bin").read_bytes()
    if len(selector0_entry) != 0x800 or len(selector5) != 0x5200:
        raise SystemExit("procedural-graphics source artifact size drift")

    procedural_sources = {
        "title": (opening, 0x0800, "disassembly/selector0-load03-0800-1fff.rebuilt.bin"),
        "protection": (selector0_entry, 0x6000, "disassembly/selector0-load05-6000-67ff.rebuilt.bin"),
        "display": (selector5, 0x6900, "disassembly/selector5-load00-6900-baff.rebuilt.bin"),
    }

    def export_procedural_region(name: str, source_name: str, start: int, end: int) -> dict:
        source, origin, relative_source = procedural_sources[source_name]
        raw = source[start - origin : end - origin + 1]
        if len(raw) != end - start + 1:
            raise SystemExit(f"procedural-graphics boundary drift: {name}")
        path = procedural_raw_dir / f"{name}.bin"
        path.write_bytes(raw)
        return {
            "name": name,
            "source_artifact": relative_source,
            "memory_start": start,
            "memory_end": end,
            "raw_path": str(path.relative_to(args.output)),
            "raw_size": len(raw),
            "raw_sha256": sha256(raw),
        }

    fill_palette_copies = [
        export_procedural_region("title-fill-palette", "title", 0x1139, 0x1148),
        export_procedural_region("protection-fill-palette", "protection", 0x66D1, 0x66E0),
        export_procedural_region("display-fill-palette", "display", 0xBABA, 0xBAC9),
    ]
    if fill_palette_copies[0]["raw_sha256"] != fill_palette_copies[2]["raw_sha256"]:
        raise SystemExit("title/display HGR fill palette copy drift")
    if fill_palette_copies[0]["raw_sha256"] == fill_palette_copies[1]["raw_sha256"]:
        raise SystemExit("protection-specific HGR fill palette order collapsed")
    fill_palettes = {
        "title-display": opening[0x1139 - 0x0800 : 0x1149 - 0x0800],
        "protection": selector0_entry[0x66D1 - 0x6000 : 0x66E1 - 0x6000],
    }
    fill_patterns = []
    for palette_name, fill_palette in fill_palettes.items():
        for index in range(8):
            raw = bytes((fill_palette[index], fill_palette[index + 8]))
            rows, phase_rows = decode_hgr_rows_with_phase(raw, 2, 1)
            if encode_hgr_rows_with_phase(rows, phase_rows, 2) != raw:
                raise SystemExit(f"procedural fill pattern {palette_name}:{index} failed round trip")
            raw_path = procedural_raw_dir / f"{palette_name}-fill-pattern-{index}.bin"
            decoded_path = procedural_decoded_dir / f"{palette_name}-fill-pattern-{index}.pgm"
            raw_path.write_bytes(raw)
            write_pgm(decoded_path, rows)
            fill_patterns.append({
                "palette": palette_name,
                "index": index,
                "bytes_hex": raw.hex().upper(),
                "decoded_width": 14,
                "decoded_height": 1,
                "phase_bits": phase_rows[0],
                "raw_path": str(raw_path.relative_to(args.output)),
                "raw_size": 2,
                "raw_sha256": sha256(raw),
                "decoded_path": str(decoded_path.relative_to(args.output)),
            })

    protection_table_specs = (
        ("hgr-scanline-low", 0x642B, 0x64EA),
        ("hgr-scanline-high", 0x64EB, 0x65AA),
        ("x-byte-offsets", 0x65AB, 0x6636),
        ("x-mask-indices", 0x6637, 0x66C2),
        ("first-byte-masks", 0x66C3, 0x66C9),
        ("second-byte-masks", 0x66CA, 0x66D0),
        ("initial-x-positions", 0x66E1, 0x66E8),
        ("initial-y-positions", 0x66E9, 0x66F0),
        ("initial-x-velocities", 0x66F1, 0x66F8),
        ("initial-y-velocities", 0x66F9, 0x6700),
    )
    protection_tables = [
        export_procedural_region(name, "protection", start, end)
        for name, start, end in protection_table_specs
    ]
    protection_region = export_procedural_region(
        "protection-raster-tables-and-seeds", "protection", 0x642B, 0x6700
    )
    protection_raw = selector0_entry[0x642B - 0x6000 : 0x6701 - 0x6000]
    scanline_low = protection_raw[0x000:0x0C0]
    scanline_high = protection_raw[0x0C0:0x180]
    x_byte_offsets = protection_raw[0x180:0x20C]
    x_mask_indices = protection_raw[0x20C:0x298]
    if scanline_low != bytes((((y >> 6) * 0x28) + (0x80 if y & 8 else 0)) for y in range(192)):
        raise SystemExit("protection HGR scanline-low formula drift")
    if scanline_high != bytes((((y & 7) << 2) + ((y >> 4) & 3)) for y in range(192)):
        raise SystemExit("protection HGR scanline-high formula drift")
    if x_byte_offsets != bytes(x % 7 for x in range(140)):
        raise SystemExit("protection X phase-index formula drift")
    if x_mask_indices != bytes(2 * (x // 7) for x in range(140)):
        raise SystemExit("protection X byte-address formula drift")

    title_animation_tables = [
        export_procedural_region("title-delay-sequence", "title", 0x0803, 0x0810),
        export_procedural_region("title-sprite-frame-sequence", "title", 0x0FB4, 0x0FB8),
        export_procedural_region("title-timed-event-table", "title", 0x1149, 0x117E),
        export_procedural_region("title-particle-masks", "title", 0x117F, 0x1186),
        export_procedural_region("title-composite-animation", "title", 0x1187, 0x11A6),
    ]
    title_delays = list(opening[0x003:0x011])
    title_sprite_frames = list(opening[0x7B4:0x7B9])
    title_event_raw = opening[0x949:0x97F]
    title_events = []
    for offset in range(0, 52, 4):
        trigger = title_event_raw[offset] | (title_event_raw[offset + 1] << 8)
        routine = title_event_raw[offset + 2] | (title_event_raw[offset + 3] << 8)
        title_events.append({"trigger_counter": trigger, "routine_address": routine})
    if title_event_raw[52:] != b"\x00\x00" or len(title_events) != 13:
        raise SystemExit("title timed-event table drift")
    title_particle_raw = opening[0x97F:0x987]
    title_particle_masks = []
    for index, value in enumerate(title_particle_raw):
        raw = bytes((value,))
        rows, phase_rows = decode_hgr_rows_with_phase(raw, 1, 1)
        if encode_hgr_rows_with_phase(rows, phase_rows, 1) != raw:
            raise SystemExit(f"title particle mask {index} failed round trip")
        raw_path = procedural_raw_dir / f"title-particle-mask-{index}.bin"
        decoded_path = procedural_decoded_dir / f"title-particle-mask-{index}.pgm"
        raw_path.write_bytes(raw)
        write_pgm(decoded_path, rows)
        title_particle_masks.append({
            "index": index,
            "byte_hex": f"{value:02X}",
            "decoded_width": 7,
            "decoded_height": 1,
            "phase_bit": phase_rows[0][0],
            "raw_path": str(raw_path.relative_to(args.output)),
            "raw_sha256": sha256(raw),
            "decoded_path": str(decoded_path.relative_to(args.output)),
        })
    title_composite_raw = opening[0x987:0x9A7]
    title_composite_frames = [
        {
            "index": index,
            "packed_hex": f"{value:02X}",
            "component_frame_offsets": [value & 3, (value >> 2) & 3, (value >> 4) & 3],
        }
        for index, value in enumerate(title_composite_raw)
    ]

    write_json(args.output / "manifest.json", {
        "image_sha256": EXPECTED_SHA256,
        "source_artifact": "disassembly/selector0-load03-0800-1fff.rebuilt.bin",
        "encoding": {
            "pixels_per_byte": 7,
            "bit_order": "least-significant-bit is leftmost",
            "decoded_format": "binary pixels stored as PGM P5 0/255",
        },
        "font": {
            "memory_start": 0x1500,
            "memory_end": 0x16FF,
            "raw_path": str(font_raw_path.relative_to(args.output)),
            "raw_size": len(font),
            "raw_sha256": sha256(font),
            "glyphs": glyphs,
        },
        "title_bitmaps": {
            "memory_start": 0x1700,
            "memory_end": 0x1FFF,
            "raw_path": str(bitmap_raw_path.relative_to(args.output)),
            "raw_size": len(bitmap_region),
            "raw_sha256": sha256(bitmap_region),
            "descriptor_count": len(descriptors),
            "descriptors": descriptors,
            "residual_start": 0x1700 + descriptors[-1]["region_offset"] + descriptors[-1]["raw_size"],
            "residual_end": 0x1FFF,
        },
        "gameplay_sprites": {
            "loader_routine": "selector5 $6BEC-$6C2C",
            "loader_start_track": 0x18,
            "loader_start_sector": 0x0F,
            "descriptor_format": [
                "signed x offset", "signed y offset", "width in packed bytes",
                "height in rows", "width*height packed pixel bytes",
            ],
            "encoding": {
                "visible_pixels_per_byte": 7,
                "bit_order": "least-significant visible bit is leftmost",
                "bit_7": "Apple II HGR phase bit; preserved in raw fixtures and round-trip metadata",
                "decoded_format": "visible binary pixels stored as PGM P5 0/255",
            },
            "loader_spans": gameplay_spans,
            "effective_banks": gameplay_banks,
            "descriptor_count": sum(bank["descriptor_count"] for bank in gameplay_banks),
        },
        "procedural_graphics": {
            "representation": "renderer-consumed HGR patterns and tables used to generate rows, gauges, spokes, and box frames at runtime",
            "indexed_fill_palettes": {
                "entry_count": 8,
                "unique_byte_orders": 2,
                "entry_format": "two adjacent Apple II HGR bytes; low seven bits are visible LSB-first pixels and bit 7 is phase",
                "copies": fill_palette_copies,
                "patterns": fill_patterns,
                "copy_relationship": "title and display orders are byte-identical; protection uses the same pattern vocabulary in a different index order",
                "consumers": [
                    {"routine": "selector0 fill_title_pattern_row $081F-$084E", "output": "one 40-byte HGR row"},
                    {"routine": "selector0 draw_protection_pixel_pair $605B-$60A3", "output": "masked two-byte raster point; paired masks use the same palette vocabulary"},
                    {"routine": "selector5 fill_display_status_rows $B80A-$B860", "output": "40 bytes on each of four corresponding HGR rows"},
                ],
            },
            "protection_rasterizer": {
                "raw_region": protection_region,
                "tables": protection_tables,
                "coordinate_domain": {"x_min": 0, "x_max": 139, "y_min": 0, "y_max": 191},
                "address_formulas": {
                    "scanline_low": "((y >> 6) * $28) + ($80 if y bit 3 is set else 0)",
                    "scanline_high_without_page": "((y & 7) << 2) + ((y >> 4) & 3)",
                    "two_byte_address_offset": "2 * floor(x / 7)",
                    "mask_pair_index": "x % 7",
                },
                "paths": [
                    {"name": "moving spokes", "frame_count": 84, "line_count_per_frame": 8, "center": [70, 96], "seed_count": 8},
                    {"name": "contracting symmetric boxes", "frame_count": 36, "direction": "index 35 down to 0"},
                    {"name": "expanding symmetric boxes", "frame_count": 36, "direction": "index 0 up to 35"},
                ],
                "consumers": ["draw_protection_pixel_pair $605B", "draw_protection_line $6134", "initialize_protection_points $627F"],
            },
            "title_animation": {
                "tables": title_animation_tables,
                "delay_sequence": title_delays,
                "sprite_frame_sequence": title_sprite_frames,
                "timed_events": title_events,
                "timed_event_terminator_hex": "0000",
                "particle_masks": title_particle_masks,
                "composite_frames": title_composite_frames,
                "composite_encoding": "bits 0-1, 2-3, and 4-5 select the three animated component-frame offsets",
                "consumers": [
                    "scan_title_events $0BE3",
                    "update_title_particles $0C5B",
                    "update_title_sprite_motion $0DC5",
                    "update_title_composite_motion $0D77",
                ],
            },
            "fuel_gauge_recipe": {
                "routine": "selector5 draw_fuel_gauge_pattern $B9F2-$BA51",
                "output": "32 one-byte rows repeated across three HGR bands",
                "filled_byte_hex": "7F",
                "exhausted_checker_bytes_hex": ["AA", "D5"],
                "filled_row_count": "floor(current fuel / 4), capped by the 32-row loop",
            },
            "scope_boundary": "static encodings and runtime transform recipes only; screen placement remains pending emulator screenshots",
            "evidence": ["E-ASSET-SOURCE-003"],
        },
        "selector5_sound": {
            "representation": "synthesized Apple II speaker toggles; no note or sample stream is consumed by these gameplay paths",
            "stream_count": 0,
            "effects": [
                {
                    "name": "ground-unit deployment cue",
                    "routine": "6972-697C",
                    "call_sites": ["95E4-95EA", "95EE-95F4"],
                    "inner_loop_parameter_hex": "20",
                    "speaker_toggle_count": 16,
                    "real_time_seconds": None,
                },
                {
                    "name": "critical-fuel tick",
                    "routine": "B4DD-B4F8",
                    "speaker_toggle_count_per_eligible_hud_update": 1,
                    "condition": "interactive-side fuel below $10 after fuel-gauge rendering",
                    "real_time_seconds": None,
                },
            ],
            "scope_boundary": "complete source-exact selector-5 load; shared/presentation accesses and inert workspace false positives are classified separately below",
            "evidence": ["E-SOUND-001"],
        },
        "shared_synthesized_sound": {
            "representation": "Apple II speaker toggles synthesized by executable code; no note, sample, or sound-data stream was found",
            "stream_count": 0,
            "corpus_boundary": "boot page, stages 1-3, and every decoded selector load; all literal $C030 instruction operands classified",
            "literal_access_count": 11,
            "active_or_callable_access_count": 9,
            "inert_workspace_access_count": 2,
            "access_sites": [
                {"artifact": "selector0-load00-d000-ffff.bin", "instruction": "E0E1 STA $C030", "classification": "executed graphics-transform speaker side effect"},
                {"artifact": "selector0-load00-d000-ffff.bin", "instruction": "F32A BIT $C030", "classification": "executed invalid-input beep"},
                {"artifact": "selector0-load00-d000-ffff.bin", "instruction": "F332 BIT $C030", "classification": "executed invalid-input beep"},
                {"artifact": "selector0-load00-d000-ffff.bin", "instruction": "F42C BIT $C030", "classification": "executed paired-toggle tone engine"},
                {"artifact": "selector0-load00-d000-ffff.bin", "instruction": "F435 BIT $C030", "classification": "executed paired-toggle tone engine"},
                {"artifact": "stage2-6000-70ff.bin", "instruction": "60E1 STA $C030", "classification": "byte-identical relocated graphics-transform speaker side effect"},
                {"artifact": "selector1-load04-6900-69ff.bin", "instruction": "6976 BIT $C030", "classification": "callable shared service; no internal selector-1 call site claimed"},
                {"artifact": "selector5-load00-6900-baff.bin", "instruction": "6976 BIT $C030", "classification": "executed deployment service; E-SOUND-001"},
                {"artifact": "selector5-load00-6900-baff.bin", "instruction": "B4F5 BIT $C030", "classification": "executed critical-fuel tick; E-SOUND-001"},
                {"artifact": "stage1-ba00-bfff.bin", "instruction": "BEE9 LDA $C030", "classification": "inert initial RWTS scratch bytes overwritten before use"},
                {"artifact": "stage3-4000-43ff.bin", "instruction": "43E9 LDA $C030", "classification": "inert initial interpreter workspace bytes cleared before use"},
            ],
            "effects": [
                {
                    "name": "graphics-transform speaker cue",
                    "routine_copies": ["E0C1-E104", "60C1-6104"],
                    "speaker_toggle_count": 1456,
                    "derivation": "13 outer iterations with 16*(1+2+...+13) copied chunks/toggles",
                    "real_time_seconds": None,
                },
                {
                    "name": "invalid-input beep",
                    "routine": "F323-F338",
                    "call_site": "F216",
                    "speaker_toggle_count": 128,
                    "derivation": "64 outer iterations, two speaker toggles each",
                    "real_time_seconds": None,
                },
                {
                    "name": "presentation sweep",
                    "tone_engine": "F420-F445",
                    "routine": "F446-F461",
                    "call_site": "F1C9",
                    "speaker_toggle_count": 880,
                    "derivation": "two toggles per tone-engine iteration across counts 80,72,...,8",
                    "real_time_seconds": None,
                },
            ],
            "fixtures": shared_sound_fixtures,
            "evidence": ["E-SOUND-002"],
        },
    })


def do_report(args: argparse.Namespace) -> None:
    data = read_image(args.image)
    build = args.output.parent.parent
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        "# Recovery baseline\n\n"
        f"Canonical image `{sha256(data)}` is pinned and all three candidate sector permutations round-trip exactly. "
        "See `static-baseline.md`, `sector-stats.csv`, and `../disassembly/boot-sector.da65.s`.\n"
    )

    rebuild = json.loads((build / "rebuild" / "manifest.json").read_text())
    extract = json.loads((build / "extract" / "manifest.json").read_text())
    toolchain = json.loads((build / "toolchain.json").read_text())
    source_sector_offsets: set[int] = set()
    for replacement in rebuild["source_exact_replacements"]:
        if "sectors" in replacement:
            source_sector_offsets.update(item["image_offset"] for item in replacement["sectors"])
        elif "image_offset_start" in replacement:
            source_sector_offsets.update(range(
                replacement["image_offset_start"], replacement["image_offset_end"] + 1, SECTOR_SIZE
            ))
    unique_sector_hashes = {item["sha256"] for item in extract["sectors"]}
    source_sector_hashes = {
        sha256(data[offset : offset + SECTOR_SIZE]) for offset in source_sector_offsets
    }
    modules = json.loads((pathlib.Path(__file__).resolve().parents[1] / "modules.json").read_text())["modules"]
    coverage = {
        "image_sha256": sha256(data),
        "disk": {
            "stored_bytes_losslessly_mapped": len(data),
            "stored_sector_count": len(extract["sectors"]),
            "unique_sector_payload_count": len(unique_sector_hashes),
            "deduplicated_unique_content_bytes": len(unique_sector_hashes) * SECTOR_SIZE,
            "source_exact_sector_count": len(source_sector_offsets),
            "source_exact_disk_bytes": len(source_sector_offsets) * SECTOR_SIZE,
            "source_exact_unique_sector_payload_count": len(source_sector_hashes),
            "source_exact_deduplicated_content_bytes": len(source_sector_hashes) * SECTOR_SIZE,
            "opaque_exact_disk_bytes": len(data) - len(source_sector_offsets) * SECTOR_SIZE,
        },
        "runtime_loads": {
            "stage2_source_exact_bytes": 0x1100,
            "selector0_source_exact_bytes": 0x2000,
            "selector5_source_exact_bytes": 0x5200,
            "selector6_source_exact_bytes": 0x1000,
            "source_exact_bytes_total": 0x9300,
            "incbin_bytes_in_source_exact_loads": 0,
        },
        "modules": {
            "count": len(modules),
            "verification_counts": {
                status: sum(module["verification"] == status for module in modules)
                for status in sorted({module["verification"] for module in modules})
            },
        },
        "assets": {
            "title_font_glyphs": 64,
            "title_bitmap_descriptors": 38,
            "gameplay_sprite_descriptors": 165,
            "battlefield_records": 8,
        },
        "dynamic": {
            "approved_questions": 0,
            "answered_questions": 0,
            "runtime_checkpoint_runs": 0,
        },
    }
    write_json(args.output.parent / "coverage.json", coverage)

    completion_rows = [
        ("Input lineage", "complete", "Pinned size/hash and toolchain manifest"),
        ("Extraction/geometry", "complete", "560 sectors and three reversible mappings"),
        ("Boot/loader model", "complete", "Source-exact boot and stages 1/2/3 handoffs"),
        ("Selector 0", "complete", "8,192 source-exact bytes, zero INCBIN"),
        ("Selector 5", "complete", "20,992 source-exact bytes, zero INCBIN"),
        ("Stage 2", "complete", "4,352 typed source-exact bytes, zero INCBIN"),
        ("Selector 6", "complete", "4,096 typed source-exact bytes across four loads, zero INCBIN"),
        ("Remaining runtime source", "complete", "All runtime overlays named by the recovery plan have source-exact encoders"),
        ("Static asset encodings", "complete", "All known decoded-selector assets have raw fixtures and round-trip checks"),
        ("Screenshot placement", "approval-gated", "Requires qualified, user-authorized apple2ts run"),
        ("Demake exports", "partial", "Versioned original-unit export exists; cadence and auxiliary tactical semantics remain unresolved"),
        ("M6 runtime checkpoints", "approval-gated", "No emulator qualification or game trace authorized"),
        ("Recovery release M7", "incomplete", "Static mechanics gaps, approval-gated runtime checkpoints, and contributor release gate remain open"),
    ]
    audit_lines = [
        "# Recovery completion audit", "",
        f"Canonical image: `{sha256(data)}`", "",
        "| Requirement | Status | Evidence / remaining work |",
        "| --- | --- | --- |",
    ]
    audit_lines.extend(f"| {name} | `{status}` | {detail} |" for name, status, detail in completion_rows)
    audit_lines.extend(["", "This report is generated and intentionally does not promote approval-gated runtime observations.", ""])
    (args.output.parent / "completion-audit.md").write_text("\n".join(audit_lines))

    def producing_target(path: pathlib.Path) -> str:
        relative = path.relative_to(build)
        if relative == pathlib.Path("toolchain.json"):
            return "make -C disasm doctor"
        if relative == pathlib.Path("fingerprint.json"):
            return "make -C disasm fingerprint"
        if relative.parts[0] == "extract":
            return "make -C disasm extract"
        if relative.parts[0] == "data" or relative.parts[0] == "reports" and relative.name not in {"baseline.md", "coverage.json", "completion-audit.md", "release-manifest.json"}:
            return "make -C disasm analyze"
        if relative.parts[0] == "disassembly":
            return "make -C disasm disassemble"
        if relative.parts[0] == "assets":
            return "make -C disasm assets"
        if relative.parts[0] == "rebuild":
            return "make -C disasm rebuild"
        return "make -C disasm report"

    manifest_path = args.output.parent / "release-manifest.json"
    artifacts = []
    for path in sorted(item for item in build.rglob("*") if item.is_file() and item != manifest_path):
        artifacts.append({
            "path": str(path.relative_to(build)),
            "size": path.stat().st_size,
            "sha256": sha256(path.read_bytes()),
            "source_image_sha256": sha256(data),
            "producing_command": producing_target(path),
        })
    write_json(manifest_path, {
        "schema_version": "1.0.0",
        "source_image_sha256": sha256(data),
        "toolchain": toolchain,
        "artifact_count_excluding_manifest": len(artifacts),
        "manifest_self_policy": "The manifest excludes itself because a file cannot contain its own stable cryptographic hash.",
        "artifacts": artifacts,
    })


def do_verify(args: argparse.Namespace) -> None:
    data = read_image(args.image)
    if sha256(data) != EXPECTED_SHA256:
        raise SystemExit("input hash drift")
    manifest = json.loads((args.build / "extract" / "manifest.json").read_text())
    if manifest["image_sha256"] != EXPECTED_SHA256 or len(manifest["sectors"]) != TRACKS * SECTORS:
        raise SystemExit("invalid extraction manifest")
    rebuilt = b"".join((args.build / "extract" / item["path"]).read_bytes() for item in manifest["sectors"])
    if rebuilt != data:
        raise SystemExit("stored-sector extraction does not reconstruct canonical image")
    for name in MAPPINGS:
        logical = (args.build / "extract" / f"candidate-{name}.img").read_bytes()
        if from_logical(logical, name) != data:
            raise SystemExit(f"candidate mapping {name} is not reversible")
    boot = (args.build / "disassembly" / "boot-sector.bin").read_bytes()
    if boot != data[:SECTOR_SIZE]:
        raise SystemExit("boot disassembly input drift")
    rebuilt_boot = (args.build / "disassembly" / "boot-sector.rebuilt.bin").read_bytes()
    if rebuilt_boot != boot:
        raise SystemExit("source-exact boot-sector rebuild mismatch")
    stage1 = (args.build / "extract" / "stage1-ba00-bfff.bin").read_bytes()
    rebuilt_stage1 = (args.build / "disassembly" / "stage1-ba00-bfff.rebuilt.bin").read_bytes()
    if rebuilt_stage1 != stage1 or len(rebuilt_stage1) != 0x600:
        raise SystemExit("source-exact stage-1 rebuild mismatch")
    stage2 = (args.build / "extract" / "stage2-6000-70ff.bin").read_bytes()
    rebuilt_stage2 = (args.build / "disassembly" / "stage2-6000-70ff.rebuilt.bin").read_bytes()
    if rebuilt_stage2 != stage2 or len(rebuilt_stage2) != 0x1100:
        raise SystemExit("source-exact stage-2 rebuild mismatch")
    stage3 = (args.build / "extract" / "stage3-4000-43ff.bin").read_bytes()
    rebuilt_stage3 = (args.build / "disassembly" / "stage3-4000-43ff.rebuilt.bin").read_bytes()
    if rebuilt_stage3 != stage3 or len(rebuilt_stage3) != 0x400:
        raise SystemExit("source-exact stage-3 rebuild mismatch")
    for stem, expected_length in (("selector0-load03-0800-1fff", 0x1800), ("selector0-load05-6000-67ff", 0x0800)):
        selector0 = (args.build / "extract" / f"{stem}.bin").read_bytes()
        rebuilt_selector0 = (args.build / "disassembly" / f"{stem}.rebuilt.bin").read_bytes()
        if rebuilt_selector0 != selector0 or len(rebuilt_selector0) != expected_length:
            raise SystemExit(f"source-exact {stem} promoted-region rebuild mismatch")
    selector5 = (args.build / "extract" / "selector5-load00-6900-baff.bin").read_bytes()
    rebuilt_selector5 = (args.build / "disassembly" / "selector5-load00-6900-baff.rebuilt.bin").read_bytes()
    if rebuilt_selector5 != selector5 or len(rebuilt_selector5) != 0x5200:
        raise SystemExit("source-exact complete selector-5 rebuild mismatch")
    selector6 = (args.build / "extract" / "selector6-load00-8000-87ff.bin").read_bytes()
    rebuilt_selector6 = (args.build / "disassembly" / "selector6-load00-8000-87ff.rebuilt.bin").read_bytes()
    if rebuilt_selector6 != selector6 or len(rebuilt_selector6) != 0x0800:
        raise SystemExit("source-exact selector-6 main-load rebuild mismatch")
    for stem, expected_length in (("selector6-load01-a100-a4ff", 0x0400), ("selector6-load02-7800-7aff", 0x0300), ("selector6-load03-a000-a0ff", 0x0100)):
        selector6_companion = (args.build / "extract" / f"{stem}.bin").read_bytes()
        rebuilt_companion = (args.build / "disassembly" / f"{stem}.rebuilt.bin").read_bytes()
        if rebuilt_companion != selector6_companion or len(rebuilt_companion) != expected_length:
            raise SystemExit(f"source-exact {stem} rebuild mismatch")
    rebuilt_disk = (args.build / "rebuild" / "rescue-raiders-rebuilt.dsk").read_bytes()
    rebuild_manifest = json.loads((args.build / "rebuild" / "manifest.json").read_text())
    if rebuilt_disk != data or len(rebuilt_disk) != IMAGE_SIZE:
        raise SystemExit("rebuilt disk does not reproduce canonical image")
    if rebuild_manifest["candidate_sha256"] != EXPECTED_SHA256 or not rebuild_manifest["byte_identical_to_canonical"]:
        raise SystemExit("rebuilt disk manifest drift")
    expected_replacements = {"stage1", "boot-sector", "stage2", "stage3", "selector0-load03", "selector0-load05", "selector5-load00", "selector6-load00", "selector6-load01", "selector6-load02", "selector6-load03"}
    actual_replacements = {item["id"] for item in rebuild_manifest["source_exact_replacements"]}
    if actual_replacements != expected_replacements:
        raise SystemExit("rebuilt disk source-replacement manifest drift")
    asset_manifest = json.loads((args.build / "assets" / "manifest.json").read_text())
    if asset_manifest["image_sha256"] != EXPECTED_SHA256:
        raise SystemExit("asset manifest lineage drift")
    if asset_manifest["font"]["raw_size"] != 0x200 or len(asset_manifest["font"]["glyphs"]) != 64:
        raise SystemExit("title font asset manifest drift")
    if asset_manifest["title_bitmaps"]["raw_size"] != 0x900 or asset_manifest["title_bitmaps"]["descriptor_count"] != 38:
        raise SystemExit("title bitmap asset manifest drift")
    gameplay_assets = asset_manifest["gameplay_sprites"]
    if gameplay_assets["descriptor_count"] != 165:
        raise SystemExit("gameplay sprite asset count drift")
    if [(bank["name"], bank["descriptor_count"], bank["raw_size"]) for bank in gameplay_assets["effective_banks"]] != [("1900", 78, 0x700), ("d000", 14, 0x400), ("e000", 73, 0xB00)]:
        raise SystemExit("gameplay sprite bank manifest drift")
    if [span["page_count"] for span in gameplay_assets["loader_spans"]] != [4, 7, 2, 11] or [span["overwritten_before_render"] for span in gameplay_assets["loader_spans"]] != [False, False, True, False]:
        raise SystemExit("gameplay sprite loader-span drift")
    procedural = asset_manifest["procedural_graphics"]
    palette = procedural["indexed_fill_palettes"]
    if (palette["entry_count"], palette["unique_byte_orders"]) != (8, 2) or len(palette["patterns"]) != 16 or len(palette["copies"]) != 3:
        raise SystemExit("procedural HGR fill-palette manifest drift")
    if (palette["copies"][0]["raw_sha256"] != palette["copies"][2]["raw_sha256"]
            or len({item["raw_sha256"] for item in palette["copies"]}) != 2):
        raise SystemExit("procedural HGR fill-palette copy hash drift")
    for item in (palette["copies"] + procedural["protection_rasterizer"]["tables"]
                 + [procedural["protection_rasterizer"]["raw_region"]]
                 + procedural["title_animation"]["tables"]):
        raw_path = args.build / "assets" / item["raw_path"]
        source_path = args.build / item["source_artifact"]
        origins = {
            "disassembly/selector0-load03-0800-1fff.rebuilt.bin": 0x0800,
            "disassembly/selector0-load05-6000-67ff.rebuilt.bin": 0x6000,
            "disassembly/selector5-load00-6900-baff.rebuilt.bin": 0x6900,
        }
        source = source_path.read_bytes()
        origin = origins[item["source_artifact"]]
        expected = source[item["memory_start"] - origin : item["memory_end"] - origin + 1]
        if (not raw_path.is_file() or raw_path.read_bytes() != expected
                or sha256(expected) != item["raw_sha256"]):
            raise SystemExit(f"procedural-graphics raw fixture drift: {item['name']}")
    for pattern in palette["patterns"]:
        raw_path = args.build / "assets" / pattern["raw_path"]
        decoded_path = args.build / "assets" / pattern["decoded_path"]
        if (not raw_path.is_file() or sha256(raw_path.read_bytes()) != pattern["raw_sha256"]
                or not decoded_path.is_file()):
            raise SystemExit(f"procedural fill-pattern asset drift: {pattern['index']}")
    title_animation = procedural["title_animation"]
    if (len(title_animation["delay_sequence"]), len(title_animation["sprite_frame_sequence"]),
            len(title_animation["timed_events"]), len(title_animation["particle_masks"]),
            len(title_animation["composite_frames"])) != (14, 5, 13, 8, 32):
        raise SystemExit("title procedural-animation manifest drift")
    if title_animation["sprite_frame_sequence"] != [2, 1, 0, 1, 2]:
        raise SystemExit("title sprite-frame sequence drift")
    for mask in title_animation["particle_masks"]:
        raw_path = args.build / "assets" / mask["raw_path"]
        decoded_path = args.build / "assets" / mask["decoded_path"]
        if (not raw_path.is_file() or sha256(raw_path.read_bytes()) != mask["raw_sha256"]
                or not decoded_path.is_file()):
            raise SystemExit(f"title particle-mask asset drift: {mask['index']}")
    selector5_sound = asset_manifest["selector5_sound"]
    if selector5_sound["stream_count"] != 0 or [effect["speaker_toggle_count"] for effect in selector5_sound["effects"][:1]] != [16] or selector5_sound["effects"][1]["speaker_toggle_count_per_eligible_hud_update"] != 1:
        raise SystemExit("selector-5 sound synthesis manifest drift")
    if any(effect["real_time_seconds"] is not None for effect in selector5_sound["effects"]):
        raise SystemExit("unproven selector-5 sound cadence was populated")
    shared_sound = asset_manifest["shared_synthesized_sound"]
    if shared_sound["stream_count"] != 0 or shared_sound["literal_access_count"] != 11:
        raise SystemExit("shared synthesized-sound inventory drift")
    if (shared_sound["active_or_callable_access_count"], shared_sound["inert_workspace_access_count"]) != (9, 2):
        raise SystemExit("shared synthesized-sound access classification drift")
    if [effect["speaker_toggle_count"] for effect in shared_sound["effects"]] != [1456, 128, 880]:
        raise SystemExit("shared synthesized-sound toggle-count drift")
    if any(effect["real_time_seconds"] is not None for effect in shared_sound["effects"]):
        raise SystemExit("unproven shared synthesized-sound cadence was populated")
    for fixture in shared_sound["fixtures"]:
        fixture_path = args.build / "assets" / fixture["raw_path"]
        source_path = args.build / fixture["source_artifact"]
        source_origin = next(
            origin for relative_path, origin in (
                ("extract/selector0-load00-d000-ffff.bin", 0xD000),
                ("extract/selector1-load04-6900-69ff.bin", 0x6900),
                ("extract/selector5-load00-6900-baff.bin", 0x6900),
                ("extract/stage1-ba00-bfff.bin", 0xBA00),
                ("extract/stage2-6000-70ff.bin", 0x6000),
                ("extract/stage3-4000-43ff.bin", 0x4000),
            ) if relative_path == fixture["source_artifact"]
        )
        source = source_path.read_bytes()
        expected = source[
            fixture["memory_start"] - source_origin : fixture["memory_end"] - source_origin + 1
        ]
        if (not fixture_path.is_file() or fixture_path.read_bytes() != expected
                or sha256(expected) != fixture["raw_sha256"]):
            raise SystemExit(f"synthesized-sound fixture drift: {fixture['name']}")
    for group in (asset_manifest["font"]["glyphs"], asset_manifest["title_bitmaps"]["descriptors"]):
        for item in group:
            decoded = args.build / "assets" / item["decoded_path"]
            if not decoded.is_file():
                raise SystemExit(f"missing decoded asset: {item['decoded_path']}")
    for bank in gameplay_assets["effective_banks"]:
        raw_bank = args.build / "assets" / bank["raw_path"]
        if not raw_bank.is_file() or sha256(raw_bank.read_bytes()) != bank["raw_sha256"]:
            raise SystemExit(f"gameplay sprite raw-bank drift: {bank['name']}")
        for item in bank["descriptors"]:
            raw_descriptor = args.build / "assets" / item["raw_path"]
            decoded = args.build / "assets" / item["decoded_path"]
            if not raw_descriptor.is_file() or sha256(raw_descriptor.read_bytes()) != item["raw_sha256"] or not decoded.is_file():
                raise SystemExit(f"gameplay sprite asset drift: {bank['name']}:{item['index']}")
    expected_stage2 = data[coordinate_to_offset(19, 0) : coordinate_to_offset(20, 0)]
    expected_stage2 += data[coordinate_to_offset(20, 12) : coordinate_to_offset(20, 12) + SECTOR_SIZE]
    if (args.build / "extract" / "stage2-6000-70ff.bin").read_bytes() != expected_stage2:
        raise SystemExit("stage2 extraction mismatch")
    expected_entries = (0x6000, 0x6900, 0x8000, 0x8000, 0x8000, 0x0000, 0x8000)
    for selector_number, expected_entry in enumerate(expected_entries):
        selector = json.loads((args.build / "extract" / f"selector{selector_number}-loads.json").read_text())
        if selector["entry_point"] != expected_entry:
            raise SystemExit(f"selector-{selector_number} loader entry drift")
        for load in selector["loads"]:
            payload = (args.build / "extract" / load["path"]).read_bytes()
            if sha256(payload) != load["sha256"] or len(payload) != load["count"] * SECTOR_SIZE:
                raise SystemExit(f"selector-{selector_number} load artifact mismatch: {load['index']}")
    source_manifest = json.loads((args.build / "extract" / "source-fragments" / "manifest.json").read_text())
    if source_manifest["image_sha256"] != EXPECTED_SHA256 or len(source_manifest["blocks"]) != 7:
        raise SystemExit("embedded source-fragment scan drift")
    source_dir = args.build / "extract" / "source-fragments"
    expected_source_files = {pathlib.Path(item["path"]).name for item in source_manifest["blocks"]}
    actual_source_files = {path.name for path in source_dir.glob("fragment-*.txt")}
    if actual_source_files != expected_source_files:
        raise SystemExit("stale or missing embedded source-fragment outputs")
    flow_map = json.loads((args.build / "reports" / "flow-anchor-map.json").read_text())
    high_bit_flow60 = [item for item in flow_map["anchors"] if item["flow_id"] == "FLOW-60" and item["encoding"] == "apple-high-bit"]
    if len(high_bit_flow60) != 3 or not all(any(mapping["selector"] == 6 for mapping in item["mappings"]) for item in high_bit_flow60):
        raise SystemExit("FLOW-60 anchor mapping drift")
    campaign_flow = json.loads((args.build / "data" / "campaign-flow.json").read_text())
    if [city["name"] for city in campaign_flow["campaign_cities"]] != ["Cherbourg", "Caen", "Saint-Lô", "Orléans", "Paris", "Verdun", "Brussels", "Antwerp"]:
        raise SystemExit("campaign city pointer table drift")
    if campaign_flow["battlefield_input"]["selector"] != 5 or campaign_flow["battlefield_input"]["analog_paddles"] != ["C064", "C065"]:
        raise SystemExit("demo-to-battle selector chain drift")
    flight = json.loads((args.build / "data" / "helicopter-flight.json").read_text())
    if flight["horizontal"]["target_velocity_signed"] != [-7, -7, -6, -5, -4, -3, -2, -2, -1, -1, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 5, 6, 7, 7, 7]:
        raise SystemExit("helicopter horizontal mechanics drift")
    if flight["update_cadence"] is not None:
        raise SystemExit("unproven helicopter update cadence was populated")
    service = json.loads((args.build / "data" / "helicopter-service.json").read_text())
    if service["fuel"]["capacity"] != 128 or service["fuel"]["low_warning_below"] != 34 or service["fuel"]["critical_warning_below"] != 16:
        raise SystemExit("helicopter fuel mechanics drift")
    if service["integrity"]["maximum"] != 15 or service["weapons"]["bombs"]["capacity"] != 10 or service["weapons"]["smart_missiles"]["capacity"] != 2:
        raise SystemExit("helicopter service mechanics drift")
    if service["update_cadence"] is not None:
        raise SystemExit("unproven helicopter service cadence was populated")
    timing = json.loads((args.build / "data" / "main-loop-timing.json").read_text())
    if timing["increments_per_completed_update_wrapper"] != 1 or timing["counter_width_bits"] != 16:
        raise SystemExit("main-loop counter mechanics drift")
    if timing["direct_c019_operands_in_decoded_selector_loads"] or timing["updates_per_second"] is not None:
        raise SystemExit("unproven main-loop timing was populated")
    combat = json.loads((args.build / "data" / "helicopter-combat.json").read_text())
    economy = combat["economy"]
    if economy["initial_cash_bags_by_side"] != [15, 15] or economy["income_interval_completed_update_handler_calls"] != 56:
        raise SystemExit("campaign economy initialization/cadence drift")
    if economy["income_bags_per_side"] != 1 or economy["maximum_cash_bags"] != 255 or economy["replacement_helicopter_cost_bags"] != 20:
        raise SystemExit("campaign economy amount/cap/cost drift")
    if economy["income_interval_seconds"] is not None:
        raise SystemExit("unproven campaign economy seconds cadence was populated")
    catalog = json.loads((args.build / "data" / "object-type-catalog.json").read_text())
    if catalog["entry_count"] != 30 or catalog["object_type_domain_hex"] != ["00", "1D"]:
        raise SystemExit("object type catalog domain drift")
    entries = catalog["entries"]
    if [entry["object_type_hex"] for entry in entries] != [f"{value:02X}" for value in range(30)]:
        raise SystemExit("object type catalog ordering drift")
    if sum(entry["active_list_member"] for entry in entries) != 23:
        raise SystemExit("object type active-list membership drift")
    if [entries[index]["constructor_address_hex"] for index in (0x02, 0x06, 0x0D, 0x17, 0x1B, 0x1D)] != ["6FCF", "716F", "736E", "75C0", None, "7616"]:
        raise SystemExit("object constructor catalog drift")
    if [entries[index]["object_update_handler_hex"] for index in (0x06, 0x0D, 0x0E, 0x0F, 0x10)] != ["7B50", "7DF9", "7F1A", "7F76", "8027"]:
        raise SystemExit("object update catalog drift")
    if [entries[index]["object_update_handler_hex"] for index in (0x08, 0x09, 0x19)] != ["7C3A", "7D5F", "8288"]:
        raise SystemExit("corrected linked-component/stationary-gun/falling-infantry handler indexing drift")
    if [entries[index]["integrity_initialization"].get("value") for index in (0x02, 0x06, 0x09, 0x0D, 0x17, 0x1A)] != [15, 47, 22, 5, 128, 21]:
        raise SystemExit("object integrity catalog drift")
    if entries[0x0C]["integrity_initialization"].get("range_inclusive") != [1, 4] or entries[0x1B]["integrity_initialization"]["kind"] != "inherited_on_type_conversion":
        raise SystemExit("object non-fixed integrity classification drift")
    if entries[0x1D]["destruction_visual_effect_code_hex"] is not None or entries[0x1D]["destruction_type0C_spawn"] is not None or entries[0x1D]["destruction_unlink_count"] is not None:
        raise SystemExit("type-1D out-of-domain destruction table fields were populated")
    deployment = combat["ground_unit_deployment"]
    if [item["active_cap"] for item in deployment["commands"]] != [26, 6, 7, 8, 29] or [item["cost_bags"] for item in deployment["commands"]] != [5, 4, 3, 2, 5]:
        raise SystemExit("ground-unit deployment table drift")
    if [item["deployment_size"] for item in deployment["commands"]] != [5, 1, 1, 1, 2]:
        raise SystemExit("ground-unit deployment size drift")
    if [item["object_type_hex"] for item in deployment["commands"]] != ["0D", "0E", "0F", "10", "0D"] or [item["initial_integrity"] for item in deployment["commands"]] != [5, 15, 6, 9, 5] or [item["secondary_handler"] for item in deployment["commands"]] != ["7DF9", "7F1A", "7F76", "8027", "7DF9"]:
        raise SystemExit("ground-unit constructor/profile drift")
    mobility = combat["ground_unit_mobility"]
    if mobility["forward_horizontal_velocity_by_owner_signed"] != [1, -1] or mobility["reverse_horizontal_velocity_by_owner_signed"] != [-1, 1]:
        raise SystemExit("ground-unit direction velocity drift")
    if mobility["moving_horizontal_units_per_completed_update_wrapper"] != 1 or any(profile["moving_horizontal_units_per_completed_update_wrapper"] != 1 for profile in mobility["profiles"]):
        raise SystemExit("ground-unit movement speed drift")
    if mobility["updates_per_second"] is not None:
        raise SystemExit("unproven ground-unit real-time cadence was populated")
    structures = combat["capturable_structure_mechanics"]
    if structures["structure_search"]["target_object_types_hex"] != ["06", "16", "17"] or not structures["structure_search"]["type09_stationary_gun_is_not_searched"]:
        raise SystemExit("capturable structure type/search drift")
    type06 = structures["structure_profiles"]["06_barrage_balloon_bunker"]
    if type06["initial_integrity"] != 47 or [item["initial_integrity"] for item in type06["linked_component_profiles"]] != [6, 128]:
        raise SystemExit("stationary structure integrity profile drift")
    if type06["initial_stored_infantry_by_campaign_stage_1_8"] != [0, 1, 1, 1, 1, 1, 1, 1]:
        raise SystemExit("stationary structure initial stored-infantry drift")
    if type06["infantry_production"]["minimum_stored_before_production"] != 2 or type06["infantry_production"]["spawn_horizontal_offset"] != 6:
        raise SystemExit("stationary structure infantry-production drift")
    if structures["structure_profiles"]["09_stationary_gun"] != {"initial_integrity": 22, "capturable_by_this_path": False, "object_update_handler": "7D5F-7DF8"}:
        raise SystemExit("type-09 stationary-gun profile drift")
    if structures["old_owner_strategy_delay_by_campaign_stage_1_8"] != [255, 180, 120, 84, 72, 60, 48, 24]:
        raise SystemExit("capture strategy-delay table drift")
    if structures["updates_per_second"] is not None:
        raise SystemExit("unproven structure interaction cadence was populated")
    structure_roles = combat["structure_role_mapping"]
    if [(item["object_type_hex"], item["horizontal_coordinate_hex"]) for item in structure_roles["fixed_object_table"]] != [("17", "0230"), ("17", "0DD0"), ("05", "0278"), ("05", "0D88"), ("04", "0290"), ("04", "0D70")]:
        raise SystemExit("fixed structure table role mapping drift")
    if list(structure_roles["roles"]) != ["04_helipad", "05_time_machine_objective", "06_bunker", "07_barrage_balloon", "08_balloon_mooring_line", "16_optional_bunker", "17_fixed_armed_bunker"]:
        raise SystemExit("structure role classification drift")
    if structure_roles["roles"]["05_time_machine_objective"]["per_side_link_field"] != "60F2,X" or structure_roles["roles"]["17_fixed_armed_bunker"]["per_side_link_field"] != "60FA,X":
        raise SystemExit("fixed structure side-link mapping drift")
    parachute = combat["falling_infantry_parachute"]
    if parachute["failure_trigger"] != "($60E7 & $0F) == 0" or (parachute["failure_entropy_states"], parachute["entropy_low_nibble_states"]) != (1, 16):
        raise SystemExit("parachute failure trigger drift")
    if parachute["nominal_failure_fraction_if_low_nibble_uniform"] != "1/16" or parachute["nominal_failure_percent_if_low_nibble_uniform"] != 6.25:
        raise SystemExit("parachute nominal failure fraction drift")
    if parachute["fast_descent_vertical_units_per_update"] != 4 or parachute["open_parachute_vertical_units_per_update"] != 2:
        raise SystemExit("parachute descent mechanics drift")
    if parachute["actual_entropy_distribution"] is not None or parachute["updates_per_second"] is not None:
        raise SystemExit("unproven parachute distribution or cadence was populated")
    if [combat["player_weapons"][name]["damage"] for name in ("machine_gun", "bomb", "smart_missile")] != [2, 7, 21]:
        raise SystemExit("player weapon damage drift")
    if [item["damage_values"] for item in combat["other_observed_type_0B_projectiles"]] != [[5], [1, 2, 3, 4, 5, 15], [1], [4]] or [item["shooter_role"] for item in combat["other_observed_type_0B_projectiles"]] != ["stationary_gun_object_type_09", "tank_object_type_0E", "ground_infantry_object_type_0D", "fixed_armed_bunker_object_type_17"]:
        raise SystemExit("non-player type-0B projectile classification drift")
    if combat["type_0B_projectile_lifecycle"]["life_counter_initial"] != "10 + vertical_acceleration" or combat["type_0B_projectile_lifecycle"]["ground_clamp_hex"] != "DC":
        raise SystemExit("type-0B projectile lifecycle drift")
    ballistics = combat["non_player_type_0B_ballistics"]
    if ballistics["object_type_0E_tank"]["alternate_horizontal_velocities_signed"] != [-4, 4] or ballistics["object_type_0D_ground_infantry"]["damage"] != 1 or ballistics["object_type_17_fixed_armed_bunker"]["nominal_horizontal_travel_magnitude"] != 20 or ballistics["object_type_09_stationary_gun"]["life_updates"] != 11:
        raise SystemExit("non-player type-0B ballistics drift")
    targeting = combat["targeting_and_fire_gates"]
    if targeting["object_type_09_stationary_gun"]["helicopter_absolute_horizontal_range_strictly_below"] != 96 or targeting["object_type_0F_missile_carrier"]["eligible_counter_period"] != 4 or not targeting["object_type_0F_missile_carrier"]["one_shot_self_destruction_after_launch"]:
        raise SystemExit("targeting and fire gates drift")
    machine_gun = combat["player_weapons"]["machine_gun"]
    if machine_gun["horizontal_velocity_additions_signed"] != [-8, -8, -8, 8, 8, 8, -8, 0, 8] or machine_gun["vertical_velocities_signed"] != [2, 0, -2, 2, 0, -2, 0, 0, 0]:
        raise SystemExit("machine-gun velocity table drift")
    if combat["player_weapons"]["bomb"]["vertical_velocity_delta_per_armed_update"] != 2 or combat["player_weapons"]["smart_missile"]["impact_object_type_hex"] != "13":
        raise SystemExit("bomb/smart-missile update mechanics drift")
    bomb_aftermath = combat["player_weapons"]["bomb"]["stage_ground_aftermath"]
    if bomb_aftermath["alternate_enabled_by_campaign_stage_1_8"] != [False, False, False, True, True, True, True, True]:
        raise SystemExit("stage bomb-aftermath gate drift")
    if bomb_aftermath["ordinary_stages_1_3"] != {"destroyed_state_hex": "00", "standard_type11_effect_code_hex": "49", "type0C_batch_count": 0, "type1D_creation_attempted": False}:
        raise SystemExit("ordinary bomb aftermath drift")
    if bomb_aftermath["alternate_stages_4_8"]["destroyed_state_hex"] != "FF" or not bomb_aftermath["alternate_stages_4_8"]["standard_type11_effect_suppressed"]:
        raise SystemExit("alternate bomb aftermath state drift")
    if (bomb_aftermath["type1D_transition"]["source_type_hex"], bomb_aftermath["type1D_transition"]["next_primary_update_converts_to_type_hex"], bomb_aftermath["type1D_transition"]["eligible_infantry_collision_damage"]) != ("0A", "18", 4):
        raise SystemExit("alternate bomb type-1D/type-18 transition drift")
    if bomb_aftermath["updates_per_second"] is not None:
        raise SystemExit("unproven bomb-aftermath cadence was populated")
    alternate_weapon = combat["player_weapons"]["late_campaign_alternate"]
    if alternate_weapon["enabled_by_campaign_stage_1_8"] != [False, False, False, False, True, True, True, True]:
        raise SystemExit("late-campaign alternate weapon stage gate drift")
    if (alternate_weapon["object_type_hex"], alternate_weapon["damage"], alternate_weapon["ammunition_capacity"]) != ("1A", 21, 6):
        raise SystemExit("late-campaign alternate weapon profile drift")
    if alternate_weapon["initial_horizontal_velocity_by_aim_index_signed"] != [-1, -1, -1, 1, 1, 1, -1, 0, 1] or alternate_weapon["pad_rearm_eligible_counter_period"] != 8:
        raise SystemExit("late-campaign alternate weapon motion/service drift")
    if alternate_weapon["updates_per_second"] is not None:
        raise SystemExit("unproven late-campaign alternate weapon cadence was populated")
    if combat["special_collision_variants"]["fixed_damage"] != 4 or combat["special_collision_variants"]["dispatch_object_types_hex"] != ["14", "18", "1C"]:
        raise SystemExit("special collision variant drift")
    aftermath = combat["destruction_aftermath"]
    if aftermath["visual_object_type_hex"] != "11" or aftermath["immediate_radial_damage_scan"] or [(entry["object_type_hex"], entry["first_batch_count"], entry["second_batch_count"]) for entry in aftermath["type_0C_spawn_batches"]][:2] != [("02", 20, 5), ("05", 40, 10)]:
        raise SystemExit("destruction aftermath mechanics drift")
    if combat["updates_per_second"] is not None:
        raise SystemExit("unproven combat cadence was populated")
    strategy = json.loads((args.build / "data" / "strategy.json").read_text())
    if (len(strategy["primary_scripts"]), len(strategy["secondary_scripts"])) != (7, 14):
        raise SystemExit("strategy script domain drift")
    if [len(strategy["handler_tables"][name]) for name in ("primary_action", "secondary_action", "first_phase")] != [7, 14, 17]:
        raise SystemExit("strategy handler-table domain drift")
    if strategy["command_selection"]["decoded_ascii"] != ["E", "D", "A", "T", "M"]:
        raise SystemExit("strategy command mapping drift")
    if strategy["command_selection"]["decoded_roles"] != ["engineers", "demolition_vehicle", "aa_missile_carrier", "tank", "men"]:
        raise SystemExit("strategy command role mapping drift")
    if strategy["steering"]["positive_same_page_distance_0_27_raw"][-1] != 0x40 or strategy["steering"]["negative_distance_outside_wrapped_table"] != -7:
        raise SystemExit("strategy overlapping velocity-table drift")
    if strategy["targeting"]["eligible_object_types_hex"] != ["00", "0D", "0E", "10"] or strategy["targeting"]["clearance_by_rank"] != [0, 0, 0]:
        raise SystemExit("strategy target-rank table drift")
    if strategy["progression_tables"]["row_count"] != 9 or any(len(row) != 8 for row in strategy["progression_tables"]["rows"]):
        raise SystemExit("strategy progression-row structure drift")
    if strategy["coordinator"]["real_time_cadence"] is not None:
        raise SystemExit("unproven strategy cadence was populated")
    scoring = json.loads((args.build / "data" / "scoring.json").read_text())
    if scoring["time_penalty"]["amount"] != -1 or scoring["time_penalty"]["period_completed_update_wrappers"] != 90:
        raise SystemExit("score time-penalty drift")
    if scoring["battle_end_accumulation"]["campaign_stage_bonus_by_stage_1_8"] != [100, 150, 200, 250, 300, 350, 400, 450]:
        raise SystemExit("score campaign bonus drift")
    score_banks = [bank["adjustment_by_group_0_8"] for bank in scoring["event_adjustments"]["state_banks"]]
    if score_banks != [[0, -1, -5, -2, -15, -3, 0, -21, 0], [100, -2, -1, 0, -5, 0, -25, 0, 1], [-100, 1, 5, 2, 15, 3, -25, 7, -1]]:
        raise SystemExit("score adjustment-bank drift")
    battlefields = json.loads((args.build / "data" / "battlefields.json").read_text())
    if battlefields["horizontal_coordinates"]["domain_max"] != 4095 or battlefields["horizontal_coordinates"]["layout_grid_last"] != 0x0DF4:
        raise SystemExit("battlefield coordinate model drift")
    stages = battlefields["stages"]
    if [stage["layout_count_by_type"]["06"] for stage in stages] != [8, 8, 9, 5, 9, 6, 9, 5]:
        raise SystemExit("battlefield type-06 layout count drift")
    if [stage["layout_count_by_type"]["09"] for stage in stages] != [4, 4, 7, 8, 4, 10, 9, 15]:
        raise SystemExit("battlefield type-09 layout count drift")
    if [stage["formation_object_count"] for stage in stages] != [0, 0, 24, 27, 31, 29, 35, 36]:
        raise SystemExit("battlefield formation object count drift")
    if [stage["known_parameter_effects"]["4069_to_60EE_alternate_weapon_ammo_mode"] for stage in stages] != [False, False, False, False, True, True, True, True]:
        raise SystemExit("battlefield weapon-mode parameter drift")
    if [stage["known_parameter_effects"]["4068_to_60ED_alternate_bomb_aftermath_enabled"] for stage in stages] != [False, False, False, True, True, True, True, True]:
        raise SystemExit("battlefield bomb-aftermath parameter drift")
    if [stage["known_parameter_effects"]["4069_player_weapon_profile"] for stage in stages] != ["type_0B_machine_gun_64_internal_shot_units"] * 4 + ["type_1A_alternate_6_shots"] * 4:
        raise SystemExit("battlefield weapon profile mapping drift")
    if [stage["unconsumed_406C"]["raw_value"] for stage in stages] != [0, 1, 2, 2, 2, 3, 4, 4]:
        raise SystemExit("battlefield non-consumed $406C byte drift")
    if any(stage["unconsumed_406C"]["classification"] != "not copied and no selector-5 static consumer" for stage in stages):
        raise SystemExit("battlefield $406C consumer classification drift")
    durability = battlefields["bunker_durability"]["types"]
    if ({key: (value["initial_integrity"], value["common_weapon_damage"], value["special_type_1C_destruction_path"])
            for key, value in durability.items()}
            != {
                "06": (47, "accepted while integrity is positive", False),
                "16": (128, "ignored because the signed integrity byte is negative", True),
                "17": (128, "ignored because the signed integrity byte is negative", True),
            }):
        raise SystemExit("bunker durability classification drift")
    for stage in stages:
        sector = stage["disk"]["file_sector"]
        raw = bytes.fromhex(stage["raw_sector_hex"])
        expected = data[coordinate_to_offset(0, sector) : coordinate_to_offset(0, sector) + SECTOR_SIZE]
        if raw != expected or sha256(raw) != stage["raw_sector_sha256"]:
            raise SystemExit(f"battlefield stage {stage['stage']} raw-sector drift")
    demake_export = json.loads((args.build / "data" / "demake-export.json").read_text())
    if demake_export["schema_version"] != "1.0.0" or demake_export["source_image_sha256"] != EXPECTED_SHA256:
        raise SystemExit("versioned demake export lineage/schema drift")
    if len(demake_export["exports"]) != 9 or demake_export["representation_policy"]["real_time_cadence"] is not None:
        raise SystemExit("demake export inventory or unresolved cadence drift")
    for item in demake_export["exports"]:
        export_path = args.build / "data" / item["path"]
        if not export_path.is_file() or sha256(export_path.read_bytes()) != item["sha256"] or not item["evidence"]:
            raise SystemExit(f"demake export fixture/evidence drift: {item['id']}")
    evidence_ids = set()
    evidence_path = pathlib.Path(__file__).resolve().parents[1] / "evidence" / "evidence.jsonl"
    for line_number, line in enumerate(evidence_path.read_text().splitlines(), 1):
        if not line.strip():
            continue
        record = json.loads(line)
        if record["id"] in evidence_ids:
            raise SystemExit(f"duplicate evidence id on line {line_number}: {record['id']}")
        evidence_ids.add(record["id"])
        if record["image_sha256"] != EXPECTED_SHA256:
            raise SystemExit(f"evidence lineage drift: {record['id']}")
    atlas = json.loads((pathlib.Path(__file__).resolve().parents[1] / "modules.json").read_text())
    required_module_fields = {
        "id", "disk_ranges", "memory_ranges", "entry_points", "transform_chain",
        "overlay_hypotheses", "callers", "outgoing_references", "unresolved_regions",
        "verification", "evidence",
    }
    for module in atlas["modules"]:
        missing_fields = sorted(required_module_fields - set(module))
        if missing_fields:
            raise SystemExit(f"module atlas schema drift for {module['id']}: " + ", ".join(missing_fields))
        if module["verification"] not in {"source-exact", "opaque-exact", "functional", "unresolved"}:
            raise SystemExit(f"invalid module verification state: {module['id']}")
    missing = sorted({item for module in atlas["modules"] for item in module["evidence"]} - evidence_ids)
    if missing:
        raise SystemExit("module atlas references missing evidence: " + ", ".join(missing))
    checkpoints = json.loads((pathlib.Path(__file__).resolve().parents[1] / "flow_checkpoints.json").read_text())
    checkpoint_missing = sorted({item for checkpoint in checkpoints["checkpoints"] for item in checkpoint["evidence"]} - evidence_ids)
    if checkpoint_missing:
        raise SystemExit("flow checkpoints reference missing evidence: " + ", ".join(checkpoint_missing))
    if [checkpoint["id"] for checkpoint in checkpoints["checkpoints"]] != [f"FLOW-{number:02d}" for number in range(0, 90, 10)]:
        raise SystemExit("flow checkpoint sequence drift")
    coverage = json.loads((args.build / "reports" / "coverage.json").read_text())
    if coverage["image_sha256"] != EXPECTED_SHA256 or coverage["disk"]["stored_bytes_losslessly_mapped"] != IMAGE_SIZE:
        raise SystemExit("release coverage lineage/disk metric drift")
    if (coverage["disk"]["source_exact_sector_count"], coverage["disk"]["source_exact_disk_bytes"],
            coverage["runtime_loads"]["source_exact_bytes_total"], coverage["runtime_loads"]["incbin_bytes_in_source_exact_loads"]) != (157, 0x9D00, 0x9300, 0):
        raise SystemExit("release source-exact coverage metric drift")
    if coverage["dynamic"] != {"approved_questions": 0, "answered_questions": 0, "runtime_checkpoint_runs": 0}:
        raise SystemExit("unapproved dynamic coverage was populated")
    release_manifest_path = args.build / "reports" / "release-manifest.json"
    release_manifest = json.loads(release_manifest_path.read_text())
    if release_manifest["schema_version"] != "1.0.0" or release_manifest["source_image_sha256"] != EXPECTED_SHA256:
        raise SystemExit("release manifest schema/lineage drift")
    manifested_paths = set()
    for artifact in release_manifest["artifacts"]:
        path = args.build / artifact["path"]
        if artifact["path"] in manifested_paths or not path.is_file():
            raise SystemExit(f"release manifest duplicate/missing artifact: {artifact['path']}")
        manifested_paths.add(artifact["path"])
        if (artifact["source_image_sha256"] != EXPECTED_SHA256
                or artifact["size"] != path.stat().st_size
                or artifact["sha256"] != sha256(path.read_bytes())
                or not artifact["producing_command"]):
            raise SystemExit(f"release artifact lineage/hash drift: {artifact['path']}")
    actual_paths = {
        str(path.relative_to(args.build)) for path in args.build.rglob("*")
        if path.is_file() and path != release_manifest_path
    }
    if manifested_paths != actual_paths or release_manifest["artifact_count_excluding_manifest"] != len(actual_paths):
        raise SystemExit("release manifest does not cover every generated artifact")
    print("verified: canonical hash, 560 sectors, 3 mapping round trips, source-exact boot/stages 1/2/3 and complete selector-0/5/6 loads, byte-exact rebuilt disk, title, 165 gameplay sprites, procedural-HGR asset round trips, eight battlefield definitions, synthesized sound, strategy scripts, and scoring tables")


def parser() -> argparse.ArgumentParser:
    result = argparse.ArgumentParser()
    sub = result.add_subparsers(dest="command", required=True)
    for name in ("doctor", "fingerprint", "extract", "analyze", "disassemble", "assets", "rebuild", "report", "verify"):
        cmd = sub.add_parser(name)
        cmd.add_argument("--image", type=pathlib.Path, required=True)
        if name in ("doctor", "fingerprint", "extract", "analyze", "disassemble", "assets", "rebuild", "report"):
            cmd.add_argument("--output", type=pathlib.Path, required=True)
        if name in ("fingerprint", "verify"):
            cmd.add_argument("--checksums", type=pathlib.Path, required=True)
        if name == "verify":
            cmd.add_argument("--build", type=pathlib.Path, required=True)
        if name == "rebuild":
            cmd.add_argument("--build", type=pathlib.Path, required=True)
        if name == "assets":
            cmd.add_argument("--build", type=pathlib.Path, required=True)
    return result


def main() -> None:
    args = parser().parse_args()
    globals()[f"do_{args.command}"](args)


if __name__ == "__main__":
    main()
