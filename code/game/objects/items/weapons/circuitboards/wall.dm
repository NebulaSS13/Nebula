// For wall machines, using the wall frame construction method.

/obj/item/stock_parts/circuitboard/fire_alarm
	name = T_BOARD("fire alarm")
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\"."
	build_path = /obj/machinery/firealarm
	board_type = "wall"
	origin_tech = "{'" + TECH_DATA + "':1,'" + TECH_ENGINEERING + "':1}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/air_alarm
	name = T_BOARD("air alarm")
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	build_path = /obj/machinery/alarm
	board_type = "wall"
	origin_tech = "{'" + TECH_DATA + "':1,'" + TECH_ENGINEERING + "':1}"
	req_components = list()
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)