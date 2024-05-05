//Refreshes the icon and sets the luminosity
/obj/machinery/portable_atmospherics/hydroponics/on_update_icon()

	// Update name.
	if(seed)
		if(mechanical)
			name = "[base_name] ([seed.product_name])"
		else
			name = seed.product_name
	else
		SetName(initial(name))

	cut_overlays()

	var/image/plant_overlay = new /image
	plant_overlay.overlays = seed?.get_appearance(dead = dead, age = age, can_harvest = harvest)
	plant_overlay.layer = layer + 0.5
	plant_overlay.appearance_flags |= RESET_COLOR
	add_overlay(plant_overlay)

	//Updated the various alert icons.
	if(mechanical)
		//Draw the cover.
		if(closed_system)
			add_overlay("hydrocover2")
		if(seed && plant_health <= (seed.get_trait(TRAIT_ENDURANCE) / 2))
			add_overlay("over_lowhealth3")
		if(waterlevel <= 10)
			add_overlay("over_lowwater3")
		if(nutrilevel <= 2)
			add_overlay("over_lownutri3")
		if(weedlevel >= 5 || pestlevel >= 5 || toxins >= 40)
			add_overlay("over_alert3")
		if(harvest)
			add_overlay("over_harvest3")

	if((!density || !opacity) && seed && seed.get_trait(TRAIT_LARGE))
		if(!mechanical)
			set_density(1)
		set_opacity(1)
	else
		if(!mechanical)
			set_density(0)
		set_opacity(0)

	// Update bioluminescence.
	if(seed && seed.get_trait(TRAIT_BIOLUM))
		set_light(round(seed.get_trait(TRAIT_POTENCY)/10), l_color = seed.get_trait(TRAIT_BIOLUM_COLOUR))
	else
		set_light(0)
