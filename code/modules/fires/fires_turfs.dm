/turf/extinguish()
	return

/turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)
	if(is_on_fire())
		return 1
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < FLAMMABLE_GAS_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/igniting = 0
	if(air_contents.check_combustibility())
		igniting = 1
		create_fire(exposed_temperature)
	return igniting

/turf/proc/create_fire()
	return
