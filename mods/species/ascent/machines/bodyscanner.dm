/obj/machinery/body_scanconsole/ascent
	name = "mantid scanner console"
	desc = "Some kind of strange alien console technology."
	req_access = list(access_ascent)
	icon = 'mods/species/ascent/icons/ascent_sleepers.dmi'
	construct_state = /decl/machine_construction/default/no_deconstruct
	base_type = /obj/machinery/body_scanconsole

/obj/machinery/bodyscanner/ascent
	name = "mantid body scanner"
	desc = "Some kind of strange alien body scanning technology."
	icon = 'mods/species/ascent/icons/ascent_sleepers.dmi'
	construct_state = /decl/machine_construction/default/no_deconstruct
	base_type = /obj/machinery/bodyscanner

/obj/item/stock_parts/circuitboard/bodyscanner/ascent
	name = "circuitboard (ascent body scanner)"
	build_path = /obj/machinery/bodyscanner/ascent

/obj/item/stock_parts/circuitboard/body_scanconsole/ascent
	name = "circuitboard (ascent body scanner console)"
	build_path = /obj/machinery/body_scanconsole/ascent

/datum/fabricator_recipe/imprinter/circuit/bodyscanner/ascent
	path = /obj/item/stock_parts/circuitboard/bodyscanner/ascent

/datum/fabricator_recipe/imprinter/circuit/body_scanconsole/ascent
	path = /obj/item/stock_parts/circuitboard/body_scanconsole/ascent