/datum/seed/proc/get_growing_appearance(var/growth_state)
	if(!growing_overlays)
		growing_overlays = list()
		for(var/overlay_stage = 1 to growth_stages)
			var/ikey = "\ref[src]-plant-[overlay_stage]"
			if(!SSplants.plant_icon_cache[ikey])
				SSplants.plant_icon_cache[ikey] = get_growth_stage_overlay(overlay_stage)
			growing_overlays["[overlay_stage]"] = SSplants.plant_icon_cache[ikey]
	if(growth_state > length(growing_overlays))
		log_error(SPAN_DANGER("Seed type [get_trait(TRAIT_PLANT_ICON)] cannot find a growth icon for state [growth_state]."))
	return growing_overlays["[clamp(growth_state, 1, length(growing_overlays))]"]

/datum/seed/proc/get_dead_appearance()
	if(!dead_overlay)
		var/ikey = "[get_trait(TRAIT_PLANT_ICON)]-dead"
		if(SSplants.plant_icon_cache[ikey])
			dead_overlay = SSplants.plant_icon_cache[ikey]
		else
			dead_overlay = image('icons/obj/hydroponics/hydroponics_growing.dmi', ikey)
			dead_overlay.color = DEAD_PLANT_COLOUR
			SSplants.plant_icon_cache[ikey] = dead_overlay
	return dead_overlay

/datum/seed/proc/get_harvest_appearance()
	if(!harvest_overlay)
		var/icon_state = get_trait(TRAIT_PRODUCT_ICON)
		var/ikey = "product-[icon_state]-[get_trait(TRAIT_PLANT_COLOUR)]"
		if(SSplants.plant_icon_cache[ikey])
			harvest_overlay = SSplants.plant_icon_cache[ikey]
		else
			harvest_overlay = image('icons/obj/hydroponics/hydroponics_products.dmi', icon_state)
			harvest_overlay.color = get_trait(TRAIT_PRODUCT_COLOUR)
			SSplants.plant_icon_cache[ikey] = harvest_overlay
	return harvest_overlay

/datum/seed/proc/get_overlay_stage(var/age)
	var/seed_maturation = get_trait(TRAIT_MATURATION)
	if(age >= seed_maturation)
		return growth_stages
	return max(1, round(age/max(seed_maturation/growth_stages, 1)))

/datum/seed/proc/get_appearance(var/dead = FALSE, var/age = INFINITY, var/growth_stage, var/can_harvest = FALSE)
	if(dead)
		var/dead_appearance = get_dead_appearance()
		if(dead_appearance)
			return list(dead_appearance)
	growth_stage = growth_stage || (age && get_overlay_stage(age))
	if(growth_stage > 0)
		var/growing_appearance = get_growing_appearance(growth_stage)
		if(growing_appearance)
			LAZYADD(., growing_appearance)
	if(can_harvest)
		var/harvest_appearance = get_harvest_appearance()
		if(harvest_appearance)
			LAZYADD(., harvest_appearance)
