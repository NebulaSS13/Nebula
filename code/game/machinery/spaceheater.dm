/obj/machinery/space_heater
	use_power = POWER_USE_OFF
	anchored = 0
	density = 1
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	name = "space heater"
	desc = "This heater is guaranteed not to set anything, or anyone, on fire."
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES

	var/on = 0
	var/set_temperature = T0C + 20	//K
	var/active = 0
	var/heating_power = 40 KILOWATTS
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	clicksound = "switch"

	construct_state = /decl/machine_construction/default/panel_closed
	stat_immune = 0
	uncreated_component_parts = null

/obj/machinery/space_heater/on_update_icon(var/rebuild_overlay = 0)
	if(!on)
		icon_state = "sheater-off"
		set_light(0)
	else if(active > 0)
		icon_state = "sheater-heat"
		set_light(0.7, 1, 2, 3, COLOR_SEDONA)
	else if(active < 0)
		icon_state = "sheater-cool"
		set_light(0.7, 1, 2, 3, COLOR_DEEP_SKY_BLUE)
	else
		icon_state = "sheater-standby"
		set_light(0)

	if(rebuild_overlay)
		overlays.Cut()
		if(panel_open)
			overlays  += "sheater-open"

/obj/machinery/space_heater/examine(mob/user)
	. = ..()

	to_chat(user, "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"].")
	var/obj/item/cell/cell = get_cell()
	if(panel_open)
		to_chat(user, "The power cell is [cell ? "installed" : "missing"].")
	else
		to_chat(user, "The charge meter reads [cell ? round(cell.percent(),1) : 0]%")

/obj/machinery/space_heater/state_transition(decl/machine_construction/new_state, mob/user)
	. = ..()
	if(istype(new_state, /decl/machine_construction/default/panel_open) && CanInteract(user, DefaultTopicState()))
		interact(user)

/obj/machinery/space_heater/interface_interact(mob/user)
	if(panel_open)
		interact(user)
		return TRUE

/obj/machinery/space_heater/interact(mob/user)
	if(panel_open)
		var/list/dat = list()
		var/obj/item/cell/cell = get_cell()
		dat += "Power cell: "
		if(cell)
			dat += "Installed<BR>"
		else
			dat += "Removed<BR>"

		dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

		dat += "Set Temperature: "

		dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"

		dat += " [set_temperature]K ([set_temperature-T0C]&deg;C)"
		dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><BR>"

		var/datum/browser/popup = new(usr, "spaceheater", "Space Heater Control Panel")
		popup.set_content(jointext(dat, null))
		popup.set_title_image(usr.browse_rsc_icon(src.icon, "sheater-standby"))
		popup.open()

/obj/machinery/space_heater/physical_attack_hand(mob/user)
	if(!panel_open)
		on = !on
		user.visible_message("<span class='notice'>[user] switches [on ? "on" : "off"] the [src].</span>","<span class='notice'>You switch [on ? "on" : "off"] the [src].</span>")
		update_icon()
		return TRUE

/obj/machinery/space_heater/Topic(href, href_list, state = GLOB.physical_state)
	if (..())
		show_browser(usr, null, "window=spaceheater")
		usr.unset_machine()
		return 1

	switch(href_list["op"])
		if("temp")
			var/value = text2num(href_list["val"])

			// limit to 0-90 degC
			set_temperature = dd_range(T0C, T0C + 90, set_temperature + value)

	updateDialog()

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