/decl/hud_element/condition/bodytemp
	screen_name = "body temperature"
	screen_object_type = /obj/screen/bodytemp
	hud_element_category = /decl/hud_element/condition/bodytemp
	screen_icon_state = "temp1"
	screen_loc = ui_temp

/decl/hud_element/condition/bodytemp/refresh_screen_object(var/datum/hud/hud, var/obj/screen/elem, var/datum/gas_mixture/environment)
	//TODO: precalculate all of this stuff when the species datum is created
	var/bodytemp = hud.mymob.bodytemperature
	var/base_temperature = hud.mymob.get_ideal_bodytemp()
	if (bodytemp >= base_temperature)
		var/heat_level_1 = hud.mymob.get_temperature_threshold(HEAT_LEVEL_1)
		var/temp_step = (heat_level_1 - base_temperature)/4
		if (bodytemp >= heat_level_1)
			elem.icon_state = "temp4"
		else if (bodytemp >= base_temperature + temp_step*3)
			elem.icon_state = "temp3"
		else if (bodytemp >= base_temperature + temp_step*2)
			elem.icon_state = "temp2"
		else if (bodytemp >= base_temperature + temp_step*1)
			elem.icon_state = "temp1"
		else
			elem.icon_state = "temp0"
	else if (bodytemp < base_temperature)
		var/cold_level_1 = hud.mymob.get_temperature_threshold(COLD_LEVEL_1)
		var/temp_step = (base_temperature - cold_level_1)/4
		if (bodytemp <= cold_level_1)
			elem.icon_state = "temp-4"
		else if (bodytemp <= base_temperature - temp_step*3)
			elem.icon_state = "temp-3"
		else if (bodytemp <= base_temperature - temp_step*2)
			elem.icon_state = "temp-2"
		else if (bodytemp <= base_temperature - temp_step*1)
			elem.icon_state = "temp-1"
		else
			elem.icon_state = "temp0"
