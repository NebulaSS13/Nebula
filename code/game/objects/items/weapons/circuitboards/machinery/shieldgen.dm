// New shields
/obj/item/stock_parts/circuitboard/shield_generator
	name = "circuitboard (advanced shield generator)"
	board_type = "machine"
	build_path = /obj/machinery/power/shield_generator
	origin_tech = "{'magnets':3,'powerstorage':4}"
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/micro_laser = 1,
							/obj/item/stock_parts/smes_coil = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/shield_diffuser
	name = "circuitboard (shield diffuser)"
	board_type = "machine"
	build_path = /obj/machinery/shield_diffuser
	origin_tech = "{'magnets':4,'powerstorage':2}"
	req_components = list(
							/obj/item/stock_parts/capacitor = 1,
							/obj/item/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/pointdefense
	name = "circuitboard (point defense battery)"
	board_type = "machine"
	desc = "Control systems for a Kuiper pattern point defense battery. Aim away from vessel."
	build_path = /obj/machinery/pointdefense
	origin_tech = "{'engineering':3,'combat':2}"
	req_components = list(
		/obj/item/mech_equipment/mounted_system/taser/laser = 1,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/capacitor = 2,
		
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/terminal/buildable = 1,
		/obj/item/stock_parts/power/battery/buildable/responsive = 1,
		/obj/item/cell/high = 1
	)

/obj/item/stock_parts/circuitboard/pointdefense_control
	name = "circuitboard (fire assist mainframe)"
	board_type = "machine"
	desc = "A control computer to synchronize point defense batteries."
	build_path = /obj/machinery/pointdefense_control
	origin_tech = "{'engineering':3,'combat':2}"