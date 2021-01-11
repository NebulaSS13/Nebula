/datum/extension/ship_engine/ion_thruster
	expected_type = /obj/machinery/ion_thruster

/datum/extension/ship_engine/ion_thruster/burn(var/partial = 1)
	var/obj/machinery/ion_thruster/thruster = holder
	. = istype(thruster) && thruster.burn(partial)

/datum/extension/ship_engine/ion_thruster/get_exhaust_velocity()
	. = 300 // Arbitrary value based on being slightly less than a default configuration gas engine.

/datum/extension/ship_engine/ion_thruster/get_specific_wet_mass()
	. = 1.5 // Arbitrary value based on being slightly less than a default configuration gas engine.

/datum/extension/ship_engine/ion_thruster/has_fuel()
	var/obj/machinery/ion_thruster/thruster = holder
	. = istype(thruster) && thruster.powered() && !(thruster.stat & NOPOWER)

/datum/extension/ship_engine/ion_thruster/get_status()
	. = list()
	. += ..()
	var/obj/machinery/ion_thruster/thruster = holder
	if(!istype(thruster))
		. += "Hardware failure - check machinery."
	else if(!thruster.powered())
		. += "Insufficient power or hardware offline."
	else
		. += "Online."
	return jointext(.,"<br>")

/obj/machinery/ion_thruster
	name = "ion thruster"
	desc = "An advanced propulsion device, using energy and minutes amount of gas to generate thrust."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle2"
	power_channel = ENVIRON
	idle_power_usage = 100
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	use_power = POWER_USE_IDLE

	var/thrust_limit = 1
	var/burn_cost = 750
	var/generated_thrust = 2.5

/obj/machinery/ion_thruster/proc/burn(var/partial)
	if(!use_power || !powered())
		return 0
	use_power_oneoff(burn_cost)
	. = thrust_limit * generated_thrust

/obj/machinery/ion_thruster/on_update_icon()
	cut_overlays()
	if(!(stat & (NOPOWER | BROKEN)))
		add_overlay(image_repository.overlay_image(icon, "ion_glow", plane = EFFECTS_ABOVE_LIGHTING_PLANE, layer = ABOVE_LIGHTING_LAYER))

/obj/machinery/ion_thruster/power_change()
	. = ..()
	queue_icon_update()

/obj/machinery/ion_thruster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/ship_engine/ion_thruster, "ion thruster")

/obj/item/stock_parts/circuitboard/engine/ion
	name = T_BOARD("ion thruster")
	board_type = "machine"
	icon = 'icons/obj/modules/module_controller.dmi'
	build_path = /obj/machinery/ion_thruster
	origin_tech = "{'powerstorage':1,'engineering':2}"
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/capacitor = 2)
	matter = list(
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold =       MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/silver =     MATTER_AMOUNT_TRACE
	)
