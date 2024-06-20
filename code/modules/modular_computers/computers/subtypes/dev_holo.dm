/obj/item/modular_computer/holotablet
	name = "holotablet"
	desc = "An holoemitter-fitted device designed for writing reports and notes."
	icon = 'icons/obj/modular_computers/holo/basic.dmi'
	icon_state = ICON_STATE_WORLD

	material = /decl/material/solid/fiberglass
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass = MATTER_AMOUNT_TRACE
	)

	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	item_flags = ITEM_FLAG_NO_BLUDGEON

	interact_sounds = list('sound/machines/holo_click.ogg')
	interact_sound_volume = 20
	computer_type = /datum/extension/assembly/modular_computer/holo

	default_hardware = list(
		/obj/item/stock_parts/computer/hard_drive/micro,
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/battery_module/nano,
		/obj/item/stock_parts/computer/drive_slot
	)

	default_programs = list(/datum/computer_file/program/wordprocessor)

	light_strength = 2
	light_color = "#0a50ff"

	/// Will contain text file with this text, if not empty.
	var/preset_text
	/// Cached holo icon.
	var/icon/display_cache

/obj/item/modular_computer/holotablet/Destroy()
	QDEL_NULL(display_cache)
	. = ..()

/obj/item/modular_computer/holotablet/install_default_programs()
	..()
	if(preset_text)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
		var/obj/item/stock_parts/computer/hard_drive/D = assembly.get_component(/obj/item/stock_parts/computer/hard_drive)
		var/datum/computer_file/data/text/preset = new()

		preset.filename    = "temp[rand(1,100)]"
		preset.stored_data = preset_text

		D.store_file(preset, OS_DOCUMENTS_DIR)
		var/datum/computer_file/program/wordprocessor/word = D.find_file_by_name("wordprocessor", OS_PROGRAMS_DIR)
		word.open_file   = preset.filename
		word.loaded_data = preset.stored_data

// Visual.
/obj/item/modular_computer/holotablet/on_update_icon()
	. = ..()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly && assembly.enabled)
		var/mutable_appearance/M = mutable_appearance(icon,"[icon_state]-on")
		M.color = (assembly.bsod || os?.updating) ? "#0000ff" : light_color
		add_overlay(M)

		if(!display_cache || !isicon(display_cache))
			var/icon/I = icon(icon, "[icon_state]-screen")
			I.ColorTone((assembly.bsod || os?.updating) ? "#0000ff" : light_color)
			I.ChangeOpacity(0.5)
			I.AddAlphaMask(new /icon('icons/effects/effects.dmi', "scanline-1"))
			display_cache = I
		add_overlay(display_cache)

	update_lighting()

// Subtypes. It's not exactly... well, presets, so i'll put it here for now.

/obj/item/modular_computer/holotablet/round
	name = "round holotablet"
	icon = 'icons/obj/modular_computers/holo/round.dmi'
	light_color = "#00ff00"

/obj/item/modular_computer/holotablet/curved
	name = "curved holotablet"
	icon = 'icons/obj/modular_computers/holo/curved.dmi'
	light_color = "#db2cb5"

/obj/item/modular_computer/holotablet/wide
	name = "wide holotablet"
	icon = 'icons/obj/modular_computers/holo/wide.dmi'
	light_color = "#f5b216"

/obj/item/modular_computer/holotablet/side
	name = "side holotablet"
	icon = 'icons/obj/modular_computers/holo/side.dmi'
	light_color = "#26fce7"
