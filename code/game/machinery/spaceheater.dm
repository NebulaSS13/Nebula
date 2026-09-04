/obj/machinery/space_heater
	use_power = POWER_USE_OFF
	anchored = FALSE
	density = TRUE
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	name = "space heater"
	desc = "This heater is guaranteed not to set anything, or anyone, on fire."
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES

	atom_flags = ATOM_FLAG_CLIMBABLE
	movable_flags = MOVABLE_FLAG_WHEELED
	clicksound = "switch"

	light_power = 0.5

	construct_state = /decl/machine_construction/default/panel_closed
	stat_immune = 0
	uncreated_component_parts = null

	var/on = 0
	var/set_temperature = T0C + 20	//K
	var/active = 0
	var/heating_power = 40 KILOWATTS

/obj/machinery/space_heater/on_update_icon()
	. = ..()
	if(!on)
		icon_state = "sheater-off"
		set_light(0)
	else if(active > 0)
		icon_state = "sheater-heat"
		set_light(3, l_color = COLOR_SEDONA)
	else if(active < 0)
		icon_state = "sheater-cool"
		set_light(3, l_color = COLOR_DEEP_SKY_BLUE)
	else
		icon_state = "sheater-standby"
		set_light(0)
	if(panel_open)
		add_overlay("sheater-open")

/obj/machinery/space_heater/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += "\The [src] is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"]."
	var/obj/item/cell/cell = get_cell()
	if(panel_open)
		. += "The power cell is [cell ? "installed" : "missing"]."
	else
		. += "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"

/obj/machinery/space_heater/state_transition(decl/machine_construction/new_state, mob/user)
	. = ..()
	if(istype(new_state, /decl/machine_construction/default/panel_closed) || !CanInteract(user, DefaultTopicState()))
		SSnano.close_uis(src)
	else if(istype(new_state, /decl/machine_construction/default/panel_open))
		SSnano.update_uis(src)

/obj/machinery/space_heater/interface_interact(mob/user)
	if(panel_open)
		interact(user)
		return TRUE

/obj/machinery/space_heater/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = global.physical_no_access_topic_state)
	if(!panel_open)
		SSnano.close_uis(src) // should be handled in state_transition, but just in case
		return
	var/obj/item/cell/cell = get_cell()
	var/list/data = list(
		"has_cell" = !!cell,
		"cell_percent" = cell?.percent(),
		"set_temperature" = set_temperature,
	)
	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "space_heater.tmpl", "Space Heater Control Panel")
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/space_heater/physical_attack_hand(mob/user)
	if(!panel_open)
		on = !on
		user.visible_message(
			SPAN_NOTICE("[user] switches [on ? "on" : "off"] \the [src]."),
			SPAN_NOTICE("You switch [on ? "on" : "off"] \the [src]."),
			SPAN_NOTICE("You hear a [on ? "machine rumble to life" : "rumbling machine go silent"].")
		)
		update_icon()
		return TRUE
	return FALSE

// This machine has physical, mechanical buttons.
/obj/machinery/space_heater/DefaultTopicState()
	return global.physical_topic_state

/obj/machinery/space_heater/OnTopic(mob/user, href_list, state)
	if ((. = ..()))
		return
	if(href_list["adj_temp"])
		var/old_temperature = set_temperature
		set_temperature = clamp(round(set_temperature + text2num(href_list["adj_temp"])), T0C, 90 CELSIUS) // 90C is pretty damn hot but okay
		if(old_temperature != set_temperature)
			. = TOPIC_REFRESH

/obj/machinery/space_heater/power_change()
	. = ..()
	if(stat & NOPOWER)
		on = 0
		active = 0

/obj/machinery/space_heater/set_broken(new_state, cause)
	. = ..()
	if(stat & BROKEN)
		on = 0
		active = 0

/obj/machinery/space_heater/Process()
	if(on && !(stat & (BROKEN | NOPOWER)))
		var/datum/gas_mixture/env = loc.return_air()
		if(env && abs(env.temperature - set_temperature) <= 0.1)
			active = 0
		else
			var/transfer_moles = 0.25 * env.total_moles
			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)
				var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
				var/power_draw
				if(heat_transfer > 0)	//heating air
					heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

					removed.add_thermal_energy(heat_transfer)
					power_draw = heat_transfer
				else	//cooling air
					heat_transfer = abs(heat_transfer)

					//Assume the heat is being pumped into the hull which is fixed at 20 C
					var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
					heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power

					heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

					power_draw = abs(heat_transfer)/cop
				use_power_oneoff(power_draw)
				active = heat_transfer

			env.merge(removed)
		update_icon()