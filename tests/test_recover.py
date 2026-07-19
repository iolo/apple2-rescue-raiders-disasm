import hashlib
import importlib.util
import pathlib
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("recover", ROOT / "tools" / "recover.py")
recover = importlib.util.module_from_spec(SPEC)
assert SPEC.loader
SPEC.loader.exec_module(recover)


class GeometryTests(unittest.TestCase):
    def test_coordinate_round_trip(self):
        for offset in (0, 255, 256, 4095, recover.IMAGE_SIZE - 1):
            track, sector, within = recover.offset_to_coordinate(offset)
            self.assertEqual(offset, recover.coordinate_to_offset(track, sector, within))

    def test_mappings_are_permutations(self):
        expected = list(range(recover.SECTORS))
        for mapping in recover.MAPPINGS.values():
            self.assertEqual(expected, sorted(mapping))

    def test_each_candidate_round_trips(self):
        data = bytes((i * 37 + i // 256) & 0xFF for i in range(recover.IMAGE_SIZE))
        for name in recover.MAPPINGS:
            logical = recover.to_logical(data, name)
            self.assertEqual(data, recover.from_logical(logical, name))

    def test_canonical_hash_if_present(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if image.exists():
            digest = hashlib.sha256(image.read_bytes()).hexdigest()
            self.assertEqual(recover.EXPECTED_SHA256, digest)

    def test_boot_stage_file_order_discriminator(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        data = image.read_bytes()
        linear_stage = data[: 6 * recover.SECTOR_SIZE]
        self.assertEqual(bytes.fromhex("86 4d 84 4e"), linear_stage[0x2FF:0x303])
        physical_projection = recover.to_logical(data, "physical-indexed-dos33")
        self.assertEqual(0x17, physical_projection[0x2FF])

    def test_stage1_source_anchors(self):
        source = (ROOT / "src" / "stage1" / "stage1_loader.s").read_text()
        self.assertIn("emit_rescue_raiders_boot_page", source)
        self.assertIn("RWTS0:", source)
        self.assertIn("encode_6_and_2:", source)
        self.assertIn("write_sector_data:", source)
        self.assertIn("write_nibble_clc:", source)
        self.assertIn("decode_6_and_2:", source)
        self.assertIn("read_sector_data:", source)
        self.assertIn("read_address_field:", source)
        self.assertIn("seek_track:", source)
        self.assertIn("rwts_dispatch:", source)
        self.assertIn("rwts_error_operand:", source)
        self.assertIn("reverse_translate_values:", source)
        self.assertIn("six_and_two_aux_initial:", source)
        self.assertIn("write_translate:", source)
        self.assertIn("dos_sector_translate:", source)
        self.assertIn("disk_delay:", source)
        self.assertIn("INTER:", source)
        self.assertIn("IOB:", source)
        self.assertIn("residual_sector_tail:", source)
        self.assertNotIn(".incbin", source.lower())

    def test_stage3_source_anchors(self):
        source = (ROOT / "src" / "stage3" / "stage3_stream.s").read_text()
        self.assertIn("stage3_entry:", source)
        self.assertIn("interpret_next:", source)
        self.assertIn("handler_call_operand:", source)
        self.assertIn("final_jump_operand:", source)
        self.assertIn("handler_probe_ram:", source)
        self.assertIn("handler_load_pages:", source)
        self.assertIn("handler_build_trampoline:", source)
        self.assertIn("opcode_handlers:", source)
        self.assertIn("selector6_stream:", source)
        self.assertIn("residual_workspace_initial:", source)
        self.assertNotIn(".incbin", source.lower())

    def test_selector5_flight_source_anchors(self):
        source = (ROOT / "src" / "selector5" / "flight.s").read_text()
        self.assertIn("initialize_player_helicopters:", source)
        self.assertIn("sample_player_paddles:", source)
        self.assertIn("scale_vertical:", source)
        self.assertIn("field_repair_and_service:", source)
        self.assertIn("update_fuel_and_motion:", source)
        self.assertIn("update_player_motion:", source)
        self.assertIn("update_helicopter_smoke:", source)
        self.assertIn("apply_object_damage:", source)
        self.assertIn("initialize_bomb_projectile:", source)
        self.assertIn("initialize_type0b_projectile:", source)
        self.assertIn("dispatch_object_constructor:", source)
        self.assertIn("initialize_type0c_batch:", source)
        self.assertIn("initialize_type0c_fragment:", source)
        self.assertIn("initialize_infantry:", source)
        self.assertIn("initialize_tank:", source)
        self.assertIn("initialize_missile_carrier:", source)
        self.assertIn("initialize_demolition_vehicle:", source)
        self.assertIn("initialize_ground_vehicle:", source)
        self.assertIn("initialize_smart_missile:", source)
        self.assertIn("initialize_type06_linked_structure:", source)
        self.assertIn("initialize_bunker_variant:", source)
        self.assertIn("dispatch_player_weapons:", source)
        self.assertIn("machine_gun_page_carry:", source)
        self.assertIn("fire_bomb:", source)
        self.assertIn("fire_smart_missile:", source)
        self.assertIn("transfer_projectile_damage:", source)
        self.assertIn("fire_damage_one_projectile:", source)
        self.assertIn("dispatch_tank_weapon:", source)
        self.assertIn("tank_random_damage:", source)
        self.assertIn("fire_type1c_projectile:", source)
        self.assertIn("deploy_ground_unit:", source)
        self.assertIn("ground_unit_keys:", source)
        self.assertIn("ground_unit_types:", source)
        self.assertIn("secondary_behavior_handlers_type01:", source)
        self.assertIn("fire_type17_projectile:", source)
        self.assertIn("update_type0b_projectile:", source)
        self.assertIn("update_bomb:", source)
        self.assertIn("update_smart_missile:", source)
        self.assertIn("update_type1a_alternate_projectile:", source)
        self.assertIn("update_ground_infantry:", source)
        self.assertIn("handle_ground_infantry_interactions:", source)
        self.assertIn("resolve_infantry_structure_interaction:", source)
        self.assertIn("capture_strategy_delays:", source)
        self.assertIn("machine_gun_horizontal_velocities:", source)
        self.assertIn("handle_type1c_collision:", source)
        self.assertIn("collision_handlers_by_object_type:", source)
        self.assertIn("initialize_destruction_effect:", source)
        self.assertIn("dispatch_destruction_aftermath:", source)
        self.assertIn("destruction_type0c_spawn_control:", source)
        self.assertIn("compute_stationary_gun_projectile:", source)
        self.assertIn("tank_projectile_direction:", source)
        self.assertIn("type17_projectile_velocity:", source)
        self.assertIn("update_type09_stationary_gun:", source)
        self.assertIn("update_missile_carrier:", source)
        self.assertIn("stationary_gun_find_helicopter:", source)
        self.assertIn("primary_update_handlers_type03:", source)
        self.assertIn("handle_bunker_type1c_collision:", source)
        self.assertIn("vertical_airborne:", source)
        self.assertIn("signed_step_clamp:", source)
        self.assertIn("service_player_helicopter:", source)
        self.assertIn("start_interactive_campaign:", source)
        self.assertIn("dispatch_demo_start_key:", source)
        self.assertIn("selector5_main_entry:", source)
        self.assertIn("selector5_main_jump:", source)
        self.assertIn("object_horizontal_sizes = selector5_entry_7+2", source)
        self.assertIn("object_vertical_sizes:", source)
        self.assertIn("object_active_list_flags:", source)
        self.assertIn("delay_with_speaker_click:", source)
        self.assertIn("initialize_battlefield_pass:", source)
        self.assertIn("reset_battlefield_state:", source)
        self.assertIn("damage_module_init:", source)
        self.assertIn("dispatch_object_damage:", source)
        self.assertIn("update_object_collisions:", source)
        self.assertIn("scan_object_collisions:", source)
        self.assertIn("test_collision_vertical_overlap:", source)
        self.assertIn("handle_destroyed_player_helicopter:", source)
        self.assertIn("dispatch_collision_pair:", source)
        self.assertIn("dispatch_collision_handlers:", source)
        self.assertIn("handle_player_helicopter_collision:", source)
        self.assertIn("handle_type12_type1a_collision:", source)
        self.assertIn("handle_type1b_collision:", source)
        self.assertIn("cleanup_type06_destruction_links:", source)
        self.assertIn("cleanup_type07_destruction_links:", source)
        self.assertIn("cleanup_type08_destruction_links:", source)
        self.assertIn("resolve_collision_pair:", source)
        self.assertIn("spawn_stage_bomb_type1d_aftermath:", source)
        self.assertIn("spawn_type1a_type1d_aftermath:", source)
        self.assertIn("unlink_destroyed_object:", source)
        self.assertIn("cleanup_type12_destruction_link:", source)
        self.assertIn("handle_type04_collision:", source)
        self.assertIn("collision_table_overlap_return = collision_handlers_by_object_type+1", source)
        self.assertIn("horizontal_target_table:", source)
        self.assertIn("player_animation_feedback_states:", source)
        self.assertIn("hidden_debug_sequence_reversed:", source)
        self.assertIn("player_input_command_handlers:", source)
        self.assertIn("find_smart_missile_target:", source)
        self.assertIn("update_strategy_state:", source)
        self.assertIn("select_strategy_resource_command:", source)
        self.assertIn("reset_strategy_motion:", source)
        self.assertIn("strategy_handle_opponent_pursuit:", source)
        self.assertIn("strategy_handle_tracked_object:", source)
        self.assertIn("strategy_advance_primary_script:", source)
        self.assertIn("strategy_resume_entry:", source)
        self.assertIn("find_side_type0e_object:", source)
        self.assertIn("find_opposing_type06_object:", source)
        self.assertIn("strategy_action_acquire_type0d:", source)
        self.assertIn("strategy_action_follow_moving_target:", source)
        self.assertIn("strategy_action_follow_wide_target:", source)
        self.assertIn("select_primary_strategy_action:", source)
        self.assertIn("dispatch_secondary_strategy_phase:", source)
        self.assertIn("prepare_strategy_horizontal_velocity:", source)
        self.assertIn("strategy_action_type0e_candidate_entry:", source)
        self.assertIn("strategy_action_boundary_gate_entry:", source)
        self.assertIn("strategy_action_stage_delay_entry:", source)
        self.assertIn("find_strategy_type0d_candidates:", source)
        self.assertIn("validate_strategy_action_conditions:", source)
        self.assertIn("adjust_strategy_vertical_for_type08:", source)
        self.assertIn("strategy_opponent_within_distance:", source)
        self.assertIn("find_best_strategy_hostile_target:", source)
        self.assertIn("compute_absolute_object_horizontal_distance:", source)
        self.assertIn("transform_strategy_motion_coordinate:", source)
        self.assertIn("find_nearest_same_side_type0d:", source)
        self.assertIn("strategy_primary_script_values:", source)
        self.assertIn("strategy_first_handler_pointers:", source)
        self.assertIn("display_module_initialize_jump:", source)
        self.assertIn("render_display_frame:", source)
        self.assertIn("render_active_objects:", source)
        self.assertIn("render_object_status_marker:", source)
        self.assertIn("update_battlefield_hud:", source)
        self.assertIn("update_fuel_hud:", source)
        self.assertIn("update_fuel_indicator:", source)
        self.assertIn("render_inline_display_record:", source)
        self.assertIn("copy_alternate_display_page:", source)
        self.assertIn("display_high_scores:", source)
        self.assertIn("display_rescue_raiders_logo:", source)
        self.assertIn("display_hello_herrb:", source)
        self.assertIn("display_presentation_message:", source)
        self.assertIn("display_creator_names:", source)
        self.assertIn("display_last_score:", source)
        self.assertIn("display_proudly_presents:", source)
        self.assertIn("default_high_score_names", source)
        self.assertIn("default_high_score_values", source)
        self.assertIn("draw_fuel_gauge_pattern:", source)
        self.assertIn("display_battle_score_prompt:", source)
        self.assertIn("presentation_callback_low:", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $3f39, $03c7", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $49f7, $0183", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $4bf9, $0607", source)
        self.assertNotIn(".incbin", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $2aba, $0110", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $25e4, $0268", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $0000, $06c4", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $30e3, $1243", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $4385, $0357", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $43e4, $02f8", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $4541, $019b", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $476f, $005e", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $485f, $0058", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $4385, $0037", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $48f2, $003b", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $09af, $01f3", source)
        self.assertNotIn(".incbin \"selector5-load00-6900-baff.bin\", $0000, $007d", source)

    def test_embedded_source_scanner_finds_protection_banner(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        data = image.read_bytes()
        blocks = recover.scan_tokenized_source(data)
        matching = [b for b in blocks if b["offset_start"] <= 0x1EE2C <= b["offset_end"]]
        self.assertEqual(1, len(matching))
        payload = b"".join(record["payload"] for record in matching[0]["records"])
        self.assertIn(b"Rescue Raiders", payload)
        self.assertTrue(all(0x0D not in record["payload"] for block in blocks for record in block["records"]))

    def test_briefing_runtime_text_maps_to_selector6(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        records = recover.flow_anchor_records(image.read_bytes())
        emergency = [r for r in records if r["text"] == "Emergency transmission>" and r["encoding"] == "apple-high-bit"]
        self.assertEqual(1, len(emergency))
        self.assertIn({"selector": 6, "address": 0x80EC}, emergency[0]["mappings"])
        terrorists = [r for r in records if r["text"] == "Terrorists have been found at" and r["encoding"] == "apple-high-bit"]
        action = [r for r in records if r["text"] == "Prepare for action" and r["encoding"] == "apple-high-bit"]
        self.assertEqual([0x8106], [r["mappings"][0]["address"] for r in terrorists])
        self.assertEqual([0x8131], [r["mappings"][0]["address"] for r in action])

    def test_demo_start_reaches_campaign_city_and_battlefield(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        flow = recover.campaign_flow_mechanics(image.read_bytes())
        self.assertEqual(
            ["Cherbourg", "Caen", "Saint-Lô", "Orléans", "Paris", "Verdun", "Brussels", "Antwerp"],
            [city["name"] for city in flow["campaign_cities"]],
        )
        self.assertEqual(["C061", "C062"], flow["battlefield_input"]["joystick_buttons"])
        self.assertEqual(["C064", "C065"], flow["battlefield_input"]["analog_paddles"])
        self.assertEqual(5, flow["battlefield_input"]["selector"])

    def test_selector0_directly_runs_opening_title_animation(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        selector = recover.decode_selector(image.read_bytes(), 0)
        payloads = {load["memory_start"]: payload for load, payload in selector["loads"]}
        entry = payloads[0x6000]
        opening = payloads[0x0800]
        self.assertEqual(bytes.fromhex("20 CC 63 20 00 08 20 18 60 20 C3 63 A9 01 4C C8 BF"), entry[:17])
        self.assertEqual(bytes.fromhex("4C 4F 08"), opening[:3])
        self.assertEqual(bytes.fromhex("20 59 08 20 89 08 20 45 0C 60"), opening[0x4F:0x59])
        self.assertEqual(bytes.fromhex("2C 50 C0 2C 52 C0 2C 55 C0 2C 57 C0"), opening[0x60:0x6C])
        self.assertEqual(bytes.fromhex("A9 49 85 62 A9 11 85 63"), opening[0x3F0:0x3F8])
        self.assertEqual(bytes.fromhex("18 06 80 0F"), opening[0x979:0x97D])
        self.assertTrue(opening[0x9A7:].startswith(bytes(value | 0x80 for value in b"COPYRIGHT (C) 1984 ALL RIGHTS RESERVED")))

    def test_selector0_opening_source_anchors(self):
        opening = (ROOT / "src" / "selector0" / "opening.s").read_text()
        bitmaps = (ROOT / "src" / "selector0" / "title_bitmaps.inc").read_text()
        entry = (ROOT / "src" / "selector0" / "entry.s").read_text()
        protection = (ROOT / "src" / "selector0" / "protection_tables.inc").read_text()
        self.assertIn("title_module_entry:", opening)
        self.assertIn("title_delay_table:", opening)
        self.assertIn("compute_title_hgr_row_pointer:", opening)
        self.assertIn("fill_title_pattern_row:", opening)
        self.assertIn("title_event_trampoline:", opening)
        self.assertIn("title_graphics_clear:", opening)
        self.assertIn("draw_title_bitmap:", opening)
        self.assertIn("erase_title_bitmap:", opening)
        self.assertIn("print_accumulator_and_x_hex:", opening)
        self.assertIn("initialize_title_animation:", opening)
        self.assertIn("initialize_title_composite_state:", opening)
        self.assertIn("initialize_title_sprite_state:", opening)
        self.assertIn("initialize_title_background:", opening)
        self.assertIn("update_title_composite:", opening)
        self.assertIn("update_title_sprite_buffers:", opening)
        self.assertIn("stir_title_entropy:", opening)
        self.assertIn("scan_title_events:", opening)
        self.assertIn("title_final_update:", opening)
        self.assertIn("title_sprite_update:", opening)
        self.assertIn("update_title_particles:", opening)
        self.assertIn("update_title_bitmap_objects:", opening)
        self.assertIn("initialize_title_particles:", opening)
        self.assertIn("initialize_title_bitmap_objects:", opening)
        self.assertIn("title_scene_update:", opening)
        self.assertIn("update_title_composite_motion:", opening)
        self.assertIn("update_title_trailing_objects:", opening)
        self.assertIn("update_title_particle_lifetimes:", opening)
        self.assertIn("start_title_composite_motion:", opening)
        self.assertIn("prepare_title_copyright_text:", opening)
        self.assertIn("initialize_title_text_stream:", opening)
        self.assertIn("update_title_text_stream:", opening)
        self.assertIn("draw_title_glyph:", opening)
        self.assertIn("finish_title_animation:", opening)
        self.assertIn("title_text_scanline_low:", opening)
        self.assertIn("hgr_scanline_low:", opening)
        self.assertIn("hgr_scanline_high:", opening)
        self.assertIn("title_bit_masks:", opening)
        self.assertIn("title_particle_masks:", opening)
        self.assertIn("title_composite_animation:", opening)
        self.assertIn("title_copyright_text:", opening)
        self.assertIn("title_scalar_state:", opening)
        self.assertIn("particle_current_active:", opening)
        self.assertIn("bitmap_current_active:", opening)
        self.assertIn("title_text_and_loop_state:", opening)
        self.assertIn("title_residual_prefix:", opening)
        self.assertIn("title_font_64x8:", opening)
        self.assertIn(".include \"title_bitmaps.inc\"", opening)
        self.assertIn("title_bitmap_descriptor_offsets:", bitmaps)
        self.assertIn("title_bitmap_descriptor_37:", bitmaps)
        self.assertIn("title_bitmap_residual_tail:", bitmaps)
        self.assertIn("title_event_table:", opening)
        self.assertIn(".word $0618,finish_title_animation", opening)
        self.assertIn("lda #<title_copyright_text", opening)
        self.assertIn("sta $60", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $00bd, $0121", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $020b, $01d8", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $0445, $0504", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $0538, $0411", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $06cf, $027a", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $097f, $0e81", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $0000, $004f", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $0a98, $0d68", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $0cb3, $0b4d", opening)
        self.assertNotIn(".incbin \"selector0-load03-0800-1fff.bin\", $0f00, $0900", opening)
        self.assertNotIn(".incbin", bitmaps.lower())
        self.assertIn("selector0_main_entry:", entry)
        self.assertIn("rwts_default_iob:", entry)
        self.assertIn("run_protection_animation:", entry)
        self.assertIn("draw_protection_pixel_pair:", entry)
        self.assertIn("clear_protection_hgr_page:", entry)
        self.assertIn("run_protection_path_one:", entry)
        self.assertIn("update_protection_points:", entry)
        self.assertIn("update_protection_point:", entry)
        self.assertIn("draw_protection_line:", entry)
        self.assertIn("rasterize_protection_line_case_a:", entry)
        self.assertIn("rasterize_protection_line_case_b:", entry)
        self.assertIn("initialize_protection_points:", entry)
        self.assertIn("draw_protection_spokes:", entry)
        self.assertIn("draw_protection_spoke:", entry)
        self.assertIn("run_protection_path_two:", entry)
        self.assertIn("run_protection_path_three:", entry)
        self.assertIn("draw_protection_box:", entry)
        self.assertIn("call_packed_hgr_overlay:", entry)
        self.assertIn("opening_picture_1", entry)
        self.assertIn("opening_picture_2", entry)
        self.assertIn("opening_multiband_reveal", entry)
        self.assertIn("finish_protection_animation:", entry)
        self.assertIn("restore_after_title:", entry)
        self.assertIn("clear_title_hgr_margins:", entry)
        self.assertIn("advance_protection_hgr_page:", entry)
        self.assertIn("copy_protection_hgr_page:", entry)
        self.assertIn(".include \"protection_tables.inc\"", entry)
        self.assertIn("protection_hgr_scanline_low:", protection)
        self.assertIn("protection_x_byte_offsets:", protection)
        self.assertIn("protection_initial_x_positions:", protection)
        self.assertIn("protection_residual_tail:", protection)
        self.assertIn("jsr $0800", entry)
        self.assertIn("lda #$01", entry)
        self.assertNotIn(".incbin \"selector0-load05-6000-67ff.bin\", $0011, $07ef", entry)
        self.assertNotIn(".incbin", entry.lower())
        self.assertNotIn(".incbin", protection.lower())

    def test_helicopter_flight_constants(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        flight = recover.helicopter_flight_mechanics(image.read_bytes())
        self.assertEqual([-7, 7], [min(flight["horizontal"]["target_velocity_signed"]), max(flight["horizontal"]["target_velocity_signed"])])
        self.assertEqual(1, flight["horizontal"]["acceleration_per_movement_update"])
        self.assertEqual([56, 230], flight["vertical"]["target_range_for_capped_sample"])
        self.assertEqual(221, flight["vertical"]["upper_clamp"])

    def test_helicopter_service_constants(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        service = recover.helicopter_service_mechanics(image.read_bytes())
        self.assertEqual(128, service["fuel"]["capacity"])
        self.assertEqual([34, 16], [service["fuel"]["low_warning_below"], service["fuel"]["critical_warning_below"]])
        self.assertEqual([15, 10, 2], [service["integrity"]["maximum"], service["weapons"]["bombs"]["capacity"], service["weapons"]["smart_missiles"]["capacity"]])
        self.assertIsNone(service["update_cadence"])

    def test_main_loop_counter_is_not_normalized(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        timing = recover.main_loop_timing(image.read_bytes())
        self.assertEqual(1, timing["increments_per_completed_update_wrapper"])
        self.assertEqual([], timing["direct_c019_operands_in_decoded_selector_loads"])
        self.assertIsNone(timing["updates_per_second"])

    def test_player_weapon_damage(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        combat = recover.helicopter_combat_mechanics(image.read_bytes())
        self.assertEqual([2, 7, 21], [combat["player_weapons"][name]["damage"] for name in ("machine_gun", "bomb", "smart_missile")])

    def test_late_campaign_alternate_weapon(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        combat = recover.helicopter_combat_mechanics(image.read_bytes())
        weapon = combat["player_weapons"]["late_campaign_alternate"]
        self.assertEqual([False] * 4 + [True] * 4, weapon["enabled_by_campaign_stage_1_8"])
        self.assertEqual(("1A", 21, 6), (weapon["object_type_hex"], weapon["damage"], weapon["ammunition_capacity"]))
        self.assertEqual([-1, -1, -1, 1, 1, 1, -1, 0, 1], weapon["initial_horizontal_velocity_by_aim_index_signed"])
        self.assertIsNone(weapon["updates_per_second"])

    def test_stage_bomb_aftermath(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        combat = recover.helicopter_combat_mechanics(image.read_bytes())
        aftermath = combat["player_weapons"]["bomb"]["stage_ground_aftermath"]
        self.assertEqual([False] * 3 + [True] * 5, aftermath["alternate_enabled_by_campaign_stage_1_8"])
        self.assertEqual("49", aftermath["ordinary_stages_1_3"]["standard_type11_effect_code_hex"])
        self.assertEqual("18", aftermath["type1D_transition"]["next_primary_update_converts_to_type_hex"])
        self.assertEqual(4, aftermath["type1D_transition"]["eligible_infantry_collision_damage"])
        self.assertIsNone(aftermath["updates_per_second"])

    def test_ground_unit_purchase_caps(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        combat = recover.helicopter_combat_mechanics(image.read_bytes())
        deployment = combat["ground_unit_deployment"]
        self.assertEqual(["M", "T", "A", "D", "E"], [item["key"] for item in deployment["commands"]])
        self.assertEqual([26, 6, 7, 8, 29], [item["active_cap"] for item in deployment["commands"]])
        self.assertEqual([5, 1, 1, 1, 2], [item["deployment_size"] for item in deployment["commands"]])
        self.assertEqual(["0D", "0E", "0F", "10", "0D"], [item["object_type_hex"] for item in deployment["commands"]])
        self.assertEqual([5, 15, 6, 9, 5], [item["initial_integrity"] for item in deployment["commands"]])
        self.assertEqual(["7DF9", "7F1A", "7F76", "8027", "7DF9"], [item["secondary_handler"] for item in deployment["commands"]])
        self.assertEqual([[5], [1, 2, 3, 4, 5, 15], [1], [4]], [item["damage_values"] for item in combat["other_observed_type_0B_projectiles"]])
        self.assertEqual(["stationary_gun_object_type_09", "tank_object_type_0E", "ground_infantry_object_type_0D", "fixed_armed_bunker_object_type_17"], [item["shooter_role"] for item in combat["other_observed_type_0B_projectiles"]])
        self.assertEqual("10 + vertical_acceleration", combat["type_0B_projectile_lifecycle"]["life_counter_initial"])
        self.assertEqual(["DC", "28"], [combat["type_0B_projectile_lifecycle"]["ground_clamp_hex"], combat["type_0B_projectile_lifecycle"]["upper_destroy_threshold_hex"]])
        self.assertEqual([-8, -8, -8, 8, 8, 8, -8, 0, 8], combat["player_weapons"]["machine_gun"]["horizontal_velocity_additions_signed"])
        self.assertEqual([2, 0, -2, 2, 0, -2, 0, 0, 0], combat["player_weapons"]["machine_gun"]["vertical_velocities_signed"])
        self.assertEqual(2, combat["player_weapons"]["bomb"]["vertical_velocity_delta_per_armed_update"])
        self.assertEqual("13", combat["player_weapons"]["smart_missile"]["impact_object_type_hex"])
        self.assertEqual([4, ["14", "18", "1C"]], [combat["special_collision_variants"]["fixed_damage"], combat["special_collision_variants"]["dispatch_object_types_hex"]])
        self.assertEqual(["11", False], [combat["destruction_aftermath"]["visual_object_type_hex"], combat["destruction_aftermath"]["immediate_radial_damage_scan"]])
        self.assertEqual([["02", 20, 5], ["05", 40, 10]], [[entry["object_type_hex"], entry["first_batch_count"], entry["second_batch_count"]] for entry in combat["destruction_aftermath"]["type_0C_spawn_batches"][:2]])
        self.assertEqual([-4, 4], combat["non_player_type_0B_ballistics"]["object_type_0E_tank"]["alternate_horizontal_velocities_signed"])
        self.assertEqual(1, combat["non_player_type_0B_ballistics"]["object_type_0D_ground_infantry"]["damage"])
        self.assertEqual([20, 11], [combat["non_player_type_0B_ballistics"]["object_type_17_fixed_armed_bunker"]["nominal_horizontal_travel_magnitude"], combat["non_player_type_0B_ballistics"]["object_type_09_stationary_gun"]["life_updates"]])
        self.assertEqual([96, 2, 256, 4], [combat["targeting_and_fire_gates"]["object_type_09_stationary_gun"]["helicopter_absolute_horizontal_range_strictly_below"], combat["targeting_and_fire_gates"]["object_type_09_stationary_gun"]["eligible_counter_period"], combat["targeting_and_fire_gates"]["object_type_0F_missile_carrier"]["absolute_horizontal_range_strictly_below"], combat["targeting_and_fire_gates"]["object_type_0F_missile_carrier"]["eligible_counter_period"]])
        self.assertEqual([8, 4], [combat["damage_feedback"]["smoke_counter_period"]["integrity_7_or_more"], combat["damage_feedback"]["smoke_counter_period"]["integrity_below_7"]])

    def test_capturable_structure_mechanics(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        structures = recover.helicopter_combat_mechanics(image.read_bytes())["capturable_structure_mechanics"]
        self.assertEqual(["06", "16", "17"], structures["structure_search"]["target_object_types_hex"])
        type06 = structures["structure_profiles"]["06_barrage_balloon_bunker"]
        self.assertEqual(47, type06["initial_integrity"])
        self.assertEqual([0, 1, 1, 1, 1, 1, 1, 1], type06["initial_stored_infantry_by_campaign_stage_1_8"])
        self.assertEqual([255, 180, 120, 84, 72, 60, 48, 24], structures["old_owner_strategy_delay_by_campaign_stage_1_8"])
        self.assertIsNone(structures["updates_per_second"])

    def test_campaign_economy(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        economy = recover.helicopter_combat_mechanics(image.read_bytes())["economy"]
        self.assertEqual([15, 15], economy["initial_cash_bags_by_side"])
        self.assertEqual([56, 1, 255], [economy["income_interval_completed_update_handler_calls"], economy["income_bags_per_side"], economy["maximum_cash_bags"]])
        self.assertEqual(20, economy["replacement_helicopter_cost_bags"])
        self.assertIsNone(economy["income_interval_seconds"])

    def test_strategy_scripts_and_stage_parameter_boundaries(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        data = image.read_bytes()
        strategy = recover.strategy_mechanics(data)
        self.assertEqual([7, 14, 17], [
            len(strategy["primary_scripts"]), len(strategy["secondary_scripts"]),
            len(strategy["handler_tables"]["first_phase"]),
        ])
        self.assertEqual(["E", "D", "A", "T", "M"], strategy["command_selection"]["decoded_ascii"])
        self.assertEqual(["engineers", "demolition_vehicle", "aa_missile_carrier", "tank", "men"], strategy["command_selection"]["decoded_roles"])
        self.assertEqual(["00", "0D", "0E", "10"], strategy["targeting"]["eligible_object_types_hex"])
        self.assertEqual(0x40, strategy["steering"]["positive_same_page_distance_0_27_raw"][-1])
        self.assertIsNone(strategy["coordinator"]["real_time_cadence"])
        battlefields = recover.battlefield_mechanics(data)
        self.assertEqual([0, 1, 2, 2, 2, 3, 4, 4], [
            stage["unconsumed_406C"]["raw_value"] for stage in battlefields["stages"]
        ])
        self.assertTrue(all(
            stage["unconsumed_406C"]["classification"] == "not copied and no selector-5 static consumer"
            for stage in battlefields["stages"]
        ))

    def test_object_type_catalog(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        catalog = recover.object_type_catalog(image.read_bytes())
        self.assertEqual(["00", "1D", 30], catalog["object_type_domain_hex"] + [catalog["entry_count"]])
        entries = catalog["entries"]
        self.assertEqual(["player_helicopter", "barrage_balloon_bunker", "ground_infantry_or_engineer", "fixed_armed_bunker"], [entries[index]["role"] for index in (2, 6, 13, 23)])
        self.assertEqual(["balloon_mooring_line", "stationary_gun"], [entries[index]["role"] for index in (8, 9)])
        self.assertEqual(["7C3A", "7D5F", "8288"], [entries[index]["object_update_handler_hex"] for index in (8, 9, 25)])
        self.assertEqual(["6FCF", "716F", "736E", "75C0", None], [entries[index]["constructor_address_hex"] for index in (2, 6, 13, 23, 27)])
        self.assertEqual([15, 47, 5, 128, 21], [entries[index]["integrity_initialization"].get("value") for index in (2, 6, 13, 23, 26)])
        self.assertEqual(23, sum(entry["active_list_member"] for entry in entries))

    def test_structure_role_mapping(self):
        image = ROOT.parent / "rescue_raiders.dsk"
        if not image.exists():
            self.skipTest("canonical image not present")
        roles = recover.helicopter_combat_mechanics(image.read_bytes())["structure_role_mapping"]
        self.assertEqual(
            [("17", "0230"), ("17", "0DD0"), ("05", "0278"), ("05", "0D88"), ("04", "0290"), ("04", "0D70")],
            [(item["object_type_hex"], item["horizontal_coordinate_hex"]) for item in roles["fixed_object_table"]],
        )
        self.assertEqual(
            ["04_helipad", "05_time_machine_objective", "06_bunker", "07_barrage_balloon", "08_balloon_mooring_line", "16_optional_bunker", "17_fixed_armed_bunker"],
            list(roles["roles"]),
        )


if __name__ == "__main__":
    unittest.main()
