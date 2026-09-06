/obj/item/stock_parts/circuitboard/recharger
	name = "circuitboard (recharger)"
	build_path = /obj/machinery/recharger
	board_type = "machine"
	origin_tech = @'{"powerstorage":2,"engineering":2}'
	req_components = list(
		/obj/item/stock_parts/capacitor = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/recharger/wall
	name = "circuitboard (wall recharger)"
	build_path = /obj/machinery/recharger/wallcharger
	board_type = "wall"

/obj/item/stock_parts/circuitboard/cell_charger
	name = "circuitboard (cell charger)"
	build_path = /obj/machinery/cell_charger
	board_type = "machine"
	origin_tech = @'{"powerstorage":2,"engineering":2}'
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/power/battery/buildable/turbo = 1,
		/obj/item/stock_parts/power/apc/buildable = 1,
		/obj/item/stock_parts/capacitor = 6
	) // The apc part is to supply upkeep power, so it charges the battery instead of draining it. Capacitors make things go faster.

/obj/item/stock_parts/circuitboard/breaker
	name = "circuitboard (breaker box)"
	build_path = /obj/machinery/breakerbox
	board_type = "machine"
	origin_tech = @'{"powerstorage":4,"engineering":4}'
	req_components = list(
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/fuel_compressor
	name = "circuitboard (fuel compressor)"
	build_path = /obj/machinery/fuel_compressor
	board_type = "machine"
	origin_tech = @'{"powerstorage":2,"engineering":3,"materials":3}'
	req_components = list(
							/obj/item/stock_parts/manipulator = 2,
							/obj/item/stock_parts/matter_bin/super = 2,
							/obj/item/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/stock_parts/circuitboard/unary_atmos/stirling
	name = "circuit board (stirling engine)"
	build_path = /obj/machinery/atmospherics/binary/stirling
	board_type = "machine"
	origin_tech = @'{"engineering":2,"powerstorage":1}'
	req_components = list(
		/obj/item/stack/cable_coil = 20,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2
		)