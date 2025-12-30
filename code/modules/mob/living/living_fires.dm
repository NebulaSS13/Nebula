/mob/living/is_on_fire()
	return _on_fire

/mob/living/set_fire_intensity(amount)
	_fire_intensity = amount

/mob/living/get_fire_intensity()
	return _fire_intensity

//Adjusting the amount of fire stacks we have on person
/mob/living/adjust_fire_intensity(amount)
	_fire_intensity = clamp(_fire_intensity + amount, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

/mob/living/can_ignite()
	return get_fire_intensity() > 0 && !is_on_fire()

/mob/living/ignite_fire()
	if(can_ignite())
		_on_fire = TRUE
		set_light(4, l_color = COLOR_ORANGE)
		update_fire()

/mob/living/extinguish_fire(mob/user, no_message = FALSE)
	if(is_on_fire())
		_on_fire = FALSE
		set_fire_intensity(0)
		set_light(0)
		update_fire()

/mob/living/proc/update_fire(var/update_icons=1)
	if(is_on_fire())
		var/decl/bodytype/mob_bodytype = get_bodytype()
		var/image/standing = overlay_image(mob_bodytype?.get_ignited_icon(src) || 'icons/mob/OnFire.dmi', mob_bodytype?.get_ignited_icon_state(src) || "Generic_mob_burning", RESET_COLOR)
		set_current_mob_overlay(HO_FIRE_LAYER, standing, update_icons)
	else
		set_current_mob_overlay(HO_FIRE_LAYER, null, update_icons)

/mob/living/proc/handle_fire()
	var/fire_level = get_fire_intensity()
	if(fire_level < 0)
		set_fire_intensity(min(0, ++fire_level)) //If we've doused ourselves in water to avoid fire, dry off slowly
		fire_level = get_fire_intensity()

	if(!is_on_fire())
		return TRUE
	if(fire_level <= 0)
		extinguish_fire() //Fire's been put out.
		return TRUE

	set_fire_intensity(max(0, fire_level - 0.2)) //I guess the fire runs out of fuel eventually

	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.get_by_flag(XGM_GAS_OXIDIZER) < 1)
		extinguish_fire() //If there's no oxygen in the tile we're on, put out the fire
		return TRUE

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)

	var/burn_temperature = fire_burn_temperature()
	var/thermal_protection = get_heat_protection(burn_temperature)

	if (thermal_protection < 1 && bodytemperature < burn_temperature)
		bodytemperature += round(BODYTEMP_HEATING_MAX*(1-thermal_protection), 1)

	var/species_heat_mod = 1

	var/protected_limbs = get_heat_protection_flags(burn_temperature)

	if(burn_temperature < get_mob_temperature_threshold(HEAT_LEVEL_2))
		species_heat_mod = 0.5
	else if(burn_temperature < get_mob_temperature_threshold(HEAT_LEVEL_3))
		species_heat_mod = 0.75

	burn_temperature -= get_mob_temperature_threshold(HEAT_LEVEL_1)

	if(burn_temperature < 1)
		return

	if(has_external_organs())
		for(var/obj/item/organ/external/E in get_external_organs())
			if(!(E.body_part & protected_limbs) && prob(20))
				E.take_damage(round(species_heat_mod * log(10, (burn_temperature + 10)), 0.1), BURN, inflicter = "fire")
	else // fallback for simplemobs
		take_damage(round(species_heat_mod * log(10, (burn_temperature + 10))), 0.1, BURN, DAM_DISPERSED)

/mob/living/proc/increase_fire_intensity(exposed_temperature)
	if(get_fire_intensity() <= 4 || fire_burn_temperature() < exposed_temperature)
		adjust_fire_intensity(2)

/mob/living/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	//once our fire_burn_temperature has reached the temperature of the fire that's giving fire intensity, stop adding them.
	//allow fire intensity to go up to 4 for fires cooler than 700 K, since are being immersed in flame after all.
	increase_fire_intensity(exposed_temperature)
	ignite_fire()
	return ..()