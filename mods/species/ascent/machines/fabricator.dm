/obj/machinery/fabricator/ascent
	name = "\improper Ascent nanofabricator"
	desc = "A squat, complicated fabrication system clad in purple polymer."
	icon = 'mods/species/ascent/icons/nanofabricator.dmi'
	icon_state = "nanofab"
	base_icon_state = "nanofab"
	req_access = list(access_ascent)
	base_type = /obj/machinery/fabricator
	construct_state = /decl/machine_construction/default/no_deconstruct
	species_variation = /decl/species/mantid

/obj/item/stock_parts/circuitboard/ascent_fabricator
	name = "circuitboard (ascent nanofabricator)"
	build_path = /obj/machinery/fabricator/ascent
	board_type = "machine"
	origin_tech = "{'engineering':2,'programming':2}"
	req_components = list(
							/obj/item/stock_parts/matter_bin = 3,
							/obj/item/stock_parts/manipulator = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/datum/fabricator_recipe/imprinter/circuit/ascent_fabricator
	path = /obj/item/stock_parts/circuitboard/ascent_fabricator
	species_locked = list(
		/decl/species/mantid
	)