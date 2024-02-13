/mob/living/ignite_fire()
	if(!is_on_fire())
		mob_is_on_fire = TRUE
		set_light(4, l_color = COLOR_ORANGE)
		update_fire()

/mob/living/extinguish_fire()
	if(is_on_fire())
		mob_is_on_fire = FALSE
		fire_intensity = 0
		set_light(0)
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_intensity we have on person
	fire_intensity = clamp(fire_intensity + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

/mob/living/proc/handle_fire()
	if(fire_intensity < 0)
		fire_intensity = min(0, ++fire_intensity) //If we've doused ourselves in water to avoid fire, dry off slowly

	if(!is_on_fire())
		return 1
	else if(fire_intensity <= 0)
		extinguish_fire() //Fire's been put out.
		return 1

	fire_intensity = max(0, fire_intensity - 0.2) //I guess the fire runs out of fuel eventually

	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.get_by_flag(XGM_GAS_OXIDIZER) < 1)
		extinguish_fire() //If there's no oxygen in the tile we're on, put out the fire
		return 1

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)
