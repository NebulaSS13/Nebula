/obj/item/clothing/sensor/vitals
	name = "vitals sensor"
	desc = "A small sensor used to read the biometrics and vital signs of the wearer."
	icon = 'icons/clothing/accessories/vitals_sensor.dmi'
	var/sensors_locked = FALSE
	var/sensor_mode
	var/static/list/sensor_modes = list(
		"Off",
		"Binary sensors",
		"Vitals tracker",
		"Tracking beacon"
	)

/obj/item/clothing/sensor/vitals/get_vitals_sensor()
	return src

/obj/item/clothing/sensor/vitals/Initialize()
	. = ..()
	if(isnull(sensor_mode) || sensor_mode < VITALS_SENSOR_OFF || sensor_mode > VITALS_SENSOR_TRACKING)
		set_sensor_mode(rand(VITALS_SENSOR_OFF, VITALS_SENSOR_TRACKING))
	update_removable()

/obj/item/clothing/sensor/vitals/proc/toggle_sensors_locked()
	set_sensors_locked(!get_sensors_locked())

/obj/item/clothing/sensor/vitals/proc/get_sensors_locked()
	return sensors_locked

/obj/item/clothing/sensor/vitals/proc/set_sensors_locked(new_state)
	if(get_sensors_locked() != new_state)
		sensors_locked = new_state
		update_removable()

/obj/item/clothing/sensor/vitals/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	switch(sensor_mode)
		if(VITALS_SENSOR_OFF)
			. += "It appears to be disabled."
		if(VITALS_SENSOR_BINARY)
			. += "Its binary life tracker appear to be enabled."
		if(VITALS_SENSOR_VITAL)
			. += "Its vital tracker appears to be enabled."
		if(VITALS_SENSOR_TRACKING)
			. += "Its vital tracker and tracking beacon appear to be enabled."

/obj/item/clothing/sensor/vitals/on_attached(var/obj/item/clothing/holder, var/mob/user)
	. = ..()
	update_removable()

/obj/item/clothing/sensor/vitals/on_accessory_removed(mob/user)
	. = ..()
	update_removable()

/obj/item/clothing/sensor/vitals/proc/update_removable()
	var/obj/item/clothing/clothes = loc
	if(istype(clothes) && (src in clothes.accessories))
		accessory_removable = !sensors_locked
	else
		accessory_removable = TRUE

/obj/item/clothing/sensor/vitals/proc/set_sensor_mode(var/new_sensor_mode)
	if(sensor_mode != new_sensor_mode)
		sensor_mode = new_sensor_mode
		update_icon()

/obj/item/clothing/sensor/vitals/on_update_icon()
	. = ..()
	cut_overlays()
	var/image/I = image(icon, "[icon_state]-indicator")
	I.appearance_flags |= RESET_COLOR
	switch(sensor_mode)
		if(VITALS_SENSOR_OFF)
			I.color = COLOR_GRAY15
		if(VITALS_SENSOR_BINARY)
			I.color = COLOR_AMBER
		if(VITALS_SENSOR_VITAL)
			I.color = COLOR_YELLOW
		if(VITALS_SENSOR_TRACKING)
			I.color = COLOR_LIME
		else
			I.color = COLOR_RED
	add_overlay(I)

/obj/item/clothing/sensor/vitals/attack_self(mob/user)
	user_set_sensors(user)
	return TRUE

/obj/item/clothing/sensor/vitals/proc/user_set_sensors(mob/user)
	if(sensors_locked)
		to_chat(user, "The controls are locked.")
		return FALSE
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", sensor_modes[sensor_mode + 1]) in sensor_modes
	if(user.incapacitated())
		return
	if(loc != user && loc?.loc != user && !Adjacent(user))
		to_chat(user, "You have moved too far away.")
		return
	set_sensor_mode(sensor_modes.Find(switchMode) - 1)
	var/mob/wearer = (ismob(loc) ? loc : (ismob(loc?.loc) ? loc.loc : null))
	if (wearer == user) // accessory or inhand
		var/user_message
		switch(sensor_mode)
			if(VITALS_SENSOR_OFF)
				user_message = "You disable your remote vitals sensor."
			if(VITALS_SENSOR_BINARY)
				user_message = "Your vitals sensor will now report whether you are live or dead."
			if(VITALS_SENSOR_VITAL)
				user_message = "Your vitals sensor will now report your vital lifesigns."
			if(VITALS_SENSOR_TRACKING)
				user_message = "Your vitals sensor will now report your vital lifesigns as well as your coordinate position."
		if(user_message)
			var/decl/pronouns/pronouns = user.get_pronouns()
			user.visible_message( \
				SPAN_NOTICE("\The [user] adjusts [pronouns.his] vitals sensor."),
				SPAN_NOTICE(user_message)
			)
		return
	if(wearer)
		if(sensor_mode == 0)
			user.visible_message(
				SPAN_DANGER("\The [user] disables \the [wearer]'s vitals sensor."),
				SPAN_DANGER("You disable \the [wearer]'s vitals sensor.")
			)
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] adjusts \the [wearer]'s vitals sensor."),
				SPAN_NOTICE("You adjust \the [wearer]'s vitals sensor.")
			)
		return
	user.visible_message(
		SPAN_NOTICE("\The [user] adjusts \the [src]"),
		SPAN_NOTICE("You adjust \the [src].")
	)

/obj/item/clothing/sensor/vitals/emp_act(var/severity)
	..()
	switch(severity)
		if(1)
			set_sensor_mode(pick(75;VITALS_SENSOR_OFF, 15;VITALS_SENSOR_BINARY, 10;VITALS_SENSOR_VITAL))
		if(2)
			set_sensor_mode(pick(50;VITALS_SENSOR_OFF, 25;VITALS_SENSOR_BINARY, 20;VITALS_SENSOR_VITAL, 5;VITALS_SENSOR_TRACKING))
		else
			set_sensor_mode(pick(25;VITALS_SENSOR_OFF, 35;VITALS_SENSOR_BINARY, 30;VITALS_SENSOR_VITAL, 10;VITALS_SENSOR_TRACKING))
