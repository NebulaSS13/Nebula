/obj/machinery/computer/central_atmos
	name = "\improper Central Atmospherics Computer"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "generic_key"
	icon_screen = "comm_logs"
	light_color = "#00b000"
	density = TRUE
	anchored = TRUE
	initial_access = list(list(access_engine_equip, access_atmospherics))
	base_type = /obj/machinery/computer/central_atmos
	var/list/monitored_alarm_ids = null
	var/datum/nano_module/atmos_control/atmos_control

// TODO: replace this with a modular computer at some point
/obj/machinery/computer/central_atmos/laptop
	name = "atmospherics laptop"
	desc = "A cheap laptop."
	icon_state = "laptop"
	icon_keyboard = "laptop_key"
	icon_screen = "atmoslaptop"
	density = FALSE
	construct_state = null
	base_type = /obj/machinery/computer/central_atmos/laptop

/obj/machinery/computer/central_atmos/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/central_atmos/ui_interact(var/mob/user)
	if(!atmos_control)
		atmos_control = new(src, monitored_alarm_ids)
		atmos_control.set_monitored_alarms(monitored_alarm_ids)
	atmos_control.ui_interact(user)
