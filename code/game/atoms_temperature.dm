#define MIN_TEMPERATURE_COEFFICIENT 1
#define MAX_TEMPERATURE_COEFFICIENT 10

/atom
	var/temperature = T20C
	var/temperature_coefficient = MAX_TEMPERATURE_COEFFICIENT

/atom/movable/Entered(var/atom/movable/atom, var/atom/old_loc)
	. = ..()
	queue_temperature_atoms(atom)

/obj
	temperature_coefficient = null

/mob
	temperature_coefficient = null

/turf
	temperature_coefficient = MIN_TEMPERATURE_COEFFICIENT

/obj/Initialize(mapload)
	. = ..()
	temperature_coefficient = isnull(temperature_coefficient) ? clamp(MAX_TEMPERATURE_COEFFICIENT - w_class, MIN_TEMPERATURE_COEFFICIENT, MAX_TEMPERATURE_COEFFICIENT) : temperature_coefficient
	create_matter()
	//Only apply directional offsets if the mappers haven't set any offsets already
	if(!pixel_x && !pixel_y && !pixel_w && !pixel_z)
		update_directional_offset()

/obj/proc/HandleObjectHeating(var/obj/item/heated_by, var/mob/user, var/adjust_temp)
	if(ATOM_SHOULD_TEMPERATURE_ENQUEUE(src))
		visible_message(SPAN_NOTICE("\The [user] carefully heats \the [src] with \the [heated_by]."))
		var/diff_temp = (adjust_temp - temperature)
		if(diff_temp >= 0)
			var/altered_temp = max(temperature + (ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT * temperature_coefficient * diff_temp), 0)
			ADJUST_ATOM_TEMPERATURE(src, min(adjust_temp, altered_temp))

/mob/Initialize()
	. = ..()
	temperature_coefficient = isnull(temperature_coefficient) ? clamp(MAX_TEMPERATURE_COEFFICIENT - FLOOR(mob_size/4), MIN_TEMPERATURE_COEFFICIENT, MAX_TEMPERATURE_COEFFICIENT) : temperature_coefficient

/atom/proc/ProcessAtomTemperature()
	SHOULD_NOT_SLEEP(TRUE)

	// Get our location temperature if possible.
	// Nullspace is room temperature, clearly.
	var/adjust_temp = T20C
	if(isturf(loc))
		var/turf/T = loc
		var/datum/gas_mixture/environment = T.return_air()
		if(environment)
			adjust_temp = environment.temperature
	else if(loc)
		adjust_temp = loc.temperature

	var/diff_temp = adjust_temp - temperature
	if(abs(diff_temp) >= ATOM_TEMPERATURE_EQUILIBRIUM_THRESHOLD)
		var/altered_temp = max(temperature + (ATOM_TEMPERATURE_EQUILIBRIUM_CONSTANT * temperature_coefficient * diff_temp), 0)
		ADJUST_ATOM_TEMPERATURE(src, (diff_temp > 0) ? min(adjust_temp, altered_temp) : max(adjust_temp, altered_temp))
	else
		temperature = adjust_temp
		return PROCESS_KILL

#undef MIN_TEMPERATURE_COEFFICIENT
#undef MAX_TEMPERATURE_COEFFICIENT
