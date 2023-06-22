//Refreshes the icon and sets the luminosity
/obj/machinery/portable_atmospherics/hydroponics/on_update_icon()
	// Update name.
	if(seed)
		if(mechanical)
			name = "[base_name] ([seed.seed_name])"
		else
			name = "[seed.seed_name]"
	else
		SetName(initial(name))

	var/new_overlays = seed?.get_appearance(dead = dead, age = age, can_harvest = harvest)
	if(!islist(new_overlays))
		if(new_overlays)
			new_overlays = list(new_overlays)
		else
			new_overlays = list()

	//Updated the various alert icons.
	if(mechanical)
		//Draw the cover.
		if(closed_system)
			new_overlays += "hydrocover2"
		if(seed && plant_health <= (seed.get_trait(TRAIT_ENDURANCE) / 2))
			new_overlays += "over_lowhealth3"
		if(waterlevel <= 10)
			new_overlays += "over_lowwater3"
		if(nutrilevel <= 2)
			new_overlays += "over_lownutri3"
		if(weedlevel >= 5 || pestlevel >= 5 || toxins >= 40)
			new_overlays += "over_alert3"
		if(harvest)
			new_overlays += "over_harvest3"

	if((!density || !opacity) && seed && seed.get_trait(TRAIT_LARGE))
		if(!mechanical)
			set_density(1)
		set_opacity(1)
	else
		if(!mechanical)
			set_density(0)
		set_opacity(0)

	set_overlays(new_overlays)

	// Update bioluminescence.
	if(seed && seed.get_trait(TRAIT_BIOLUM))
		set_light(round(seed.get_trait(TRAIT_POTENCY)/10), l_color = seed.get_trait(TRAIT_BIOLUM_COLOUR))
	else
		set_light(0)
