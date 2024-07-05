/atom
	/// What is this atom's current temperature?
	var/temperature = T20C

/atom/movable/Entered(var/atom/movable/atom, var/atom/old_loc)
	. = ..()
	queue_temperature_atoms(atom)

// If this is a simulated atom, adjust our temperature.
// This will eventually propagate to our contents via ProcessAtomTemperature()
/atom/proc/handle_external_heating(var/adjust_temp, var/obj/item/heated_by, var/mob/user)

	if(!ATOM_SHOULD_TEMPERATURE_ENQUEUE(src))
		return FALSE

	var/diff_temp = round(adjust_temp - temperature, 0.1)
	if(abs(diff_temp) <= 0.1)
		return FALSE

	// Show a little message for people heating beakers with welding torches.
	if(user && heated_by)
		visible_message(SPAN_NOTICE("\The [user] carefully heats \the [src] with \the [heated_by]."))
	// Update our own heat.
	var/altered_temp = max(temperature + (get_thermal_mass_coefficient() * diff_temp), 0)
	ADJUST_ATOM_TEMPERATURE(src, min(adjust_temp, altered_temp))
	return TRUE

// TODO: move mob bodytemperature onto this proc.
/atom/proc/ProcessAtomTemperature()
	SHOULD_NOT_SLEEP(TRUE)

	// Get our location temperature if possible.
	// Nullspace is room temperature, clearly.
	var/adjust_temp = T20C
	var/thermal_mass_coefficient = get_thermal_mass_coefficient()
	if(isturf(loc))
		var/turf/T = loc
		var/datum/gas_mixture/environment = T.return_air()
		adjust_temp = environment.temperature
		//scale the thermal mass coefficient so that 1atm = 1x, 0atm = 0x, 10atm = 10x
		thermal_mass_coefficient *= (environment.return_pressure() / ONE_ATMOSPHERE)
	else if(loc)
		adjust_temp = loc.temperature

	// Determine if our temperature needs to change.
	var/old_temp = temperature
	var/diff_temp = adjust_temp - temperature
	if(abs(diff_temp) >= (thermal_mass_coefficient * ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD))
		var/altered_temp = max(temperature + (thermal_mass_coefficient * diff_temp), 0)
		ADJUST_ATOM_TEMPERATURE(src, (diff_temp > 0) ? min(adjust_temp, altered_temp) : max(adjust_temp, altered_temp))
	else
		temperature = adjust_temp
		. = PROCESS_KILL

	// If our temperature changed, our contents probably want to know about it.
	if(temperature != old_temp)
		queue_temperature_atoms(get_contained_temperature_sensitive_atoms())
