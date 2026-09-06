
/obj/screen/warning/bodytemp
	name = "body temperature"
	icon = 'icons/mob/screen/styles/status_bodytemp.dmi'
	icon_state = "temp1"
	screen_loc = ui_temp

/obj/screen/warning/bodytemp/on_update_icon()
	. = ..()

	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner))
		return

	var/decl/species/my_species = owner.get_species()
	if(!my_species)
		switch(owner.bodytemperature) //310.055 optimal body temp
			if(370 to INFINITY)
				icon_state = "temp4"
			if(350 to 370)
				icon_state = "temp3"
			if(335 to 350)
				icon_state = "temp2"
			if(320 to 335)
				icon_state = "temp1"
			if(300 to 320)
				icon_state = "temp0"
			if(295 to 300)
				icon_state = "temp-1"
			if(280 to 295)
				icon_state = "temp-2"
			if(260 to 280)
				icon_state = "temp-3"
			else
				icon_state = "temp-4"
		return

	var/heat_1 = owner.get_mob_temperature_threshold(HEAT_LEVEL_1)
	var/cold_1 = owner.get_mob_temperature_threshold(COLD_LEVEL_1)

	//TODO: precalculate all of this stuff when the species datum is created
	var/base_temperature = my_species.body_temperature
	if(base_temperature == null) //some species don't have a set metabolic temperature
		base_temperature = (heat_1 + cold_1)/2

	if (owner.bodytemperature >= base_temperature)
		var/temp_step = (heat_1 - base_temperature)/4
		if (owner.bodytemperature >= heat_1)
			icon_state = "temp4"
		else if (owner.bodytemperature >= base_temperature + temp_step*3)
			icon_state = "temp3"
		else if (owner.bodytemperature >= base_temperature + temp_step*2)
			icon_state = "temp2"
		else if (owner.bodytemperature >= base_temperature + temp_step*1)
			icon_state = "temp1"
		else
			icon_state = "temp0"
	else if (owner.bodytemperature < base_temperature)
		var/temp_step = (base_temperature - cold_1)/4
		if (owner.bodytemperature <= cold_1)
			icon_state = "temp-4"
		else if (owner.bodytemperature <= base_temperature - temp_step*3)
			icon_state = "temp-3"
		else if (owner.bodytemperature <= base_temperature - temp_step*2)
			icon_state = "temp-2"
		else if (owner.bodytemperature <= base_temperature - temp_step*1)
			icon_state = "temp-1"
		else
			icon_state = "temp0"

/obj/screen/warning/bodytemp/handle_click(mob/user, params)
	switch(icon_state)
		if("temp4")
			to_chat(user, SPAN_DANGER("You are being cooked alive!"))
		if("temp3")
			to_chat(user, SPAN_DANGER("Your body is burning up!"))
		if("temp2")
			to_chat(user, SPAN_DANGER("You are overheating."))
		if("temp1")
			to_chat(user, SPAN_WARNING("You are uncomfortably hot."))
		if("temp-4")
			to_chat(user, SPAN_DANGER("You are being frozen solid!"))
		if("temp-3")
			to_chat(user, SPAN_DANGER("You are freezing cold!"))
		if("temp-2")
			to_chat(user, SPAN_WARNING("You are dangerously chilled!"))
		if("temp-1")
			to_chat(user, SPAN_NOTICE("You are uncomfortably cold."))
		else
			to_chat(user, SPAN_NOTICE("Your body is at a comfortable temperature."))
