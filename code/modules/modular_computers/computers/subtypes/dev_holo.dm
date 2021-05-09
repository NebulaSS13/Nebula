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

	var/preset_text   = "" //Will contain text file with this text, if not empty.
	var/display_color = "#0a50ff"

/obj/item/modular_computer/holotablet/install_default_programs()
	..()
	if(preset_text)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
		var/obj/item/stock_parts/computer/hard_drive/D = assembly.get_component(/obj/item/stock_parts/computer/hard_drive)
		var/datum/computer_file/data/text/preset = new()

		preset.filename    = "temp[rand(1,100)]"
		preset.stored_data = preset_text

		D.store_file(preset)
		var/datum/computer_file/program/wordprocessor/word = D.find_file_by_name("wordprocessor")
		word.open_file   = preset.filename
		word.loaded_data = preset.stored_data

//Visual

/obj/item/modular_computer/holotablet/update_lighting()
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly && assembly.enabled)
		set_light(2, 4, display_color)
	else
		set_light(0)

/obj/item/modular_computer/holotablet/on_update_icon()
	overlays.Cut()
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly && assembly.enabled)
		var/image/A = image(icon,"[icon_state]-on")
		A.color     = display_color
		overlays   += A

		var/icon/I = icon(icon,"[icon_state]-screen")
		I.ColorTone(display_color)
		I.ChangeOpacity(0.5)
		I.AddAlphaMask(new/icon('icons/effects/effects.dmi', "scanline-1"))
		overlays += I
	update_lighting()

/obj/machinery/vending/games/Initialize()
	products[/obj/item/modular_computer/holotablet] = 5
	. = ..()

//Subtypes. It's not exactly.. well, presets, so i'll put it here for now.

/obj/item/modular_computer/holotablet/round
	name = "round holotablet"
	icon = 'icons/obj/modular_computers/holo/round.dmi'
	display_color = "#00ff00"

/obj/item/modular_computer/holotablet/curved
	name = "curved holotablet"
	icon = 'icons/obj/modular_computers/holo/curved.dmi'
	display_color = "#db2cb5"

/obj/item/modular_computer/holotablet/wide
	name = "wide holotablet"
	icon = 'icons/obj/modular_computers/holo/wide.dmi'
	display_color = "#f5b216"

/obj/item/modular_computer/holotablet/side
	name = "side holotablet"
	icon = 'icons/obj/modular_computers/holo/side.dmi'
	display_color = "#26fce7"