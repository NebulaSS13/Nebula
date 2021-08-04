/mob/is_burnable()
	return simulated

/mob/living/carbon/human/fire_act(var/firelevel, var/last_temperature, var/pressure)
	
	..()

	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.

	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	var/holding = get_held_items()
	for(var/obj/item/clothing/C in src)
		if(C in holding)
			continue

		if( C.max_heat_protection_temperature >= last_temperature )
			if(C.body_parts_covered & SLOT_HEAD)
				head_exposure = 0
			if(C.body_parts_covered & SLOT_UPPER_BODY)
				chest_exposure = 0
			if(C.body_parts_covered & SLOT_LOWER_BODY)
				groin_exposure = 0
			if(C.body_parts_covered & SLOT_LEGS)
				legs_exposure = 0
			if(C.body_parts_covered & SLOT_ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel/vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(0.9*mx*head_exposure,  BURN, BP_HEAD,  used_weapon =  "Fire")
	apply_damage(2.5*mx*chest_exposure, BURN, BP_CHEST, used_weapon =  "Fire")
	apply_damage(2.0*mx*groin_exposure, BURN, BP_GROIN, used_weapon =  "Fire")
	apply_damage(0.6*mx*legs_exposure,  BURN, BP_L_LEG, used_weapon =  "Fire")
	apply_damage(0.6*mx*legs_exposure,  BURN, BP_R_LEG, used_weapon =  "Fire")
	apply_damage(0.4*mx*arms_exposure,  BURN, BP_L_ARM, used_weapon =  "Fire")
	apply_damage(0.4*mx*arms_exposure,  BURN, BP_R_ARM, used_weapon =  "Fire")

	//return a truthy value of whether burning actually happened
	return mx * (head_exposure + chest_exposure + groin_exposure + legs_exposure + arms_exposure)

/mob/living/ignite()
	if(fire_stacks > 0 && !on_fire)
		on_fire = 1
		set_light(4, l_color = COLOR_ORANGE)
		update_fire()

/mob/living/extinguish(var/mob/user, var/no_message)
	if(on_fire)
		on_fire = 0
		fire_stacks = 0
		set_light(0)
		update_fire()

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(add_fire_stacks) //Adjusting the amount of fire_stacks we have on person
	fire_stacks = Clamp(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

/mob/living/proc/handle_fire()
	if(fire_stacks < 0)
		fire_stacks = min(0, ++fire_stacks) //If we've doused ourselves in water to avoid fire, dry off slowly

	if(!on_fire)
		return 1
	else if(fire_stacks <= 0)
		extinguish() //Fire's been put out.
		return 1

	fire_stacks = max(0, fire_stacks - 0.2) //I guess the fire runs out of fuel eventually

	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.get_by_flag(XGM_GAS_OXIDIZER) < 1)
		extinguish() //If there's no oxygen in the tile we're on, put out the fire
		return 1

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)

/mob/living/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	//once our fire_burn_temperature has reached the temperature of the fire that's giving fire_stacks, stop adding them.
	//allow fire_stacks to go up to 4 for fires cooler than 700 K, since are being immersed in flame after all.
	if(fire_stacks <= 4 || fire_burn_temperature() < exposed_temperature)
		adjust_fire_stacks(2)
	ignite()

	var/mx = 5 * vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5*mx, BURN)
	return mx
