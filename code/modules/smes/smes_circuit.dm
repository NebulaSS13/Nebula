/obj/item/stock_parts/circuitboard/smes
	name = "circuitboard (superconductive magnetic energy storage)"
	build_path = /obj/machinery/power/smes/buildable
	board_type = "machine"
	origin_tech = @'{"powerstorage":6,"engineering":4}'
	req_components = list(/obj/item/stock_parts/smes_coil = 1, /obj/item/stack/cable_coil = 30)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/shielding/electric = 1
	)

// And the fabricator recipe for the circuit
/datum/fabricator_recipe/imprinter/circuit/smes
	path = /obj/item/stock_parts/circuitboard/smes