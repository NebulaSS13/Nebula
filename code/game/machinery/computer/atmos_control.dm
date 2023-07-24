/obj/item/stock_parts/circuitboard/atmoscontrol
	name = "\improper Central Atmospherics Computer Circuitboard"
	build_path = /obj/machinery/computer/atmoscontrol

/obj/machinery/computer/atmoscontrol
	name = "\improper Central Atmospherics Computer"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "generic_key"
	icon_screen = "comm_logs"
	light_color = "#00b000"
	density = TRUE
	anchored = TRUE
	initial_access = list(list(access_engine_equip, access_atmospherics))
	var/list/monitored_alarm_ids = null
	var/datum/nano_module/atmos_control/atmos_control
	base_type = /obj/machinery/computer/atmoscontrol

/obj/machinery/computer/atmoscontrol/laptop
	name = "Atmospherics Laptop"
	desc = "A cheap laptop."
	icon_state = "laptop"
	icon_keyboard = "laptop_key"
	icon_screen = "atmoslaptop"
	density = FALSE

/obj/machinery/computer/atmoscontrol/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/atmoscontrol/ui_interact(var/mob/user)
	if(!atmos_control)
		atmos_control = new(src, monitored_alarm_ids)
		atmos_control.set_monitored_alarms(monitored_alarm_ids)
	atmos_control.ui_interact(user)
