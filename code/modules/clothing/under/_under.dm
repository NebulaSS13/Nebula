/obj/item/clothing/under
	name = "under"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit.dmi'
	icon_state = ICON_STATE_WORLD
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY
	w_class = ITEM_SIZE_NORMAL
	force = 0
	made_of_cloth = TRUE

	valid_accessory_slots = list(
		ACCESSORY_SLOT_UTILITY,
		ACCESSORY_SLOT_HOLSTER,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_DECOR,
		ACCESSORY_SLOT_MEDAL,
		ACCESSORY_SLOT_INSIGNIA,
		ACCESSORY_SLOT_OVER
		)

	restricted_accessory_slots = list(
		ACCESSORY_SLOT_UTILITY,
		ACCESSORY_SLOT_HOLSTER,
		ACCESSORY_SLOT_ARMBAND,
		ACCESSORY_SLOT_RANK,
		ACCESSORY_SLOT_DEPT,
		ACCESSORY_SLOT_OVER
		)

	var/has_sensor = SUIT_HAS_SENSORS //For the crew computer 2 = unable to change mode
	var/sensor_mode = 0
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = 1
	var/rolled_down = FALSE
	var/rolled_sleeves = FALSE

/obj/item/clothing/under/Initialize()
	. = ..()
	if(check_state_in_icon(lowertext("[BODYTYPE_HUMANOID]-[slot_w_uniform_str]-rolled"), icon))
		verbs |= /obj/item/clothing/under/proc/roll_down_clothes
	if(check_state_in_icon(lowertext("[BODYTYPE_HUMANOID]-[slot_w_uniform_str]-sleeves"), icon))
		verbs |= /obj/item/clothing/under/proc/roll_up_sleeves

/obj/item/clothing/under/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/I = ..()
	if(I && slot == slot_w_uniform_str)
		if(rolled_down && check_state_in_icon("[I.icon_state]-rolled", I.icon))
			I.icon_state = "[I.icon_state]-rolled"
		else
			if(check_state_in_icon("[I.icon_state]-[lowertext(user_mob.gender)]", I.icon))
				I.icon_state = "[I.icon_state]-[lowertext(user_mob.gender)]"
			if(rolled_sleeves && check_state_in_icon("[I.icon_state]-sleeves", I.icon))
				I.icon_state = "[I.icon_state]-sleeves"
	return I

/obj/item/clothing/under/proc/roll_down_clothes()

	set name = "Roll Down Uniform"
	set category = "IC"
	set src in usr

	if(!rolled_down && check_state_in_icon("[icon_state]-rolled", icon))
		to_chat(usr, SPAN_WARNING("You cannot roll down \the [src]."))
		verbs -= /obj/item/clothing/under/proc/roll_down_clothes
	else
		rolled_down = !rolled_down
		to_chat(usr, SPAN_NOTICE("You roll [rolled_down ? "down" : "up"] \the [src]."))
		update_clothing_icon()

/obj/item/clothing/under/proc/roll_up_sleeves()

	set name = "Roll Up Sleeves"
	set category = "IC"
	set src in usr

	if(!rolled_sleeves && check_state_in_icon("[icon_state]-sleeves", icon))
		to_chat(usr, SPAN_WARNING("You cannot roll up the sleeves of \the [src]."))
		verbs -= /obj/item/clothing/under/proc/roll_up_sleeves
	else
		rolled_sleeves = !rolled_sleeves
		to_chat(usr, SPAN_NOTICE("You roll [rolled_sleeves ? "up" : "down"] the sleeves of \the [src]."))
		update_clothing_icon()

/obj/item/clothing/under/attack_hand(var/mob/user)
	if(accessories && accessories.len)
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/update_clothing_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform(0)
		M.update_inv_wear_id()

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	switch(src.sensor_mode)
		if(0)
			to_chat(user, "Its sensors appear to be disabled.")
		if(1)
			to_chat(user, "Its binary life sensors appear to be enabled.")
		if(2)
			to_chat(user, "Its vital tracker appears to be enabled.")
		if(3)
			to_chat(user, "Its vital tracker and tracking beacon appear to be enabled.")

/obj/item/clothing/under/proc/set_sensors(mob/user)
	var/mob/M = user
	if (isobserver(M)) return
	if (user.incapacitated()) return
	if(has_sensor >= SUIT_LOCKED_SENSORS)
		to_chat(user, "The controls are locked.")
		return 0
	if(has_sensor <= SUIT_NO_SENSORS)
		to_chat(user, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(user, src) > 1)
		to_chat(user, "You have moved too far away.")
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == user)
		switch(sensor_mode)
			if(0)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "You disable your suit's remote sensing equipment.")
			if(1)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "Your suit will now report whether you are live or dead.")
			if(2)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "Your suit will now report your vital lifesigns.")
			if(3)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "Your suit will now report your vital lifesigns as well as your coordinate position.")

	else if (ismob(src.loc))
		if(sensor_mode == 0)
			user.visible_message("<span class='warning'>[user] disables [src.loc]'s remote sensing equipment.</span>", "You disable [src.loc]'s remote sensing equipment.")
		else
			user.visible_message("[user] adjusts the tracking sensor on [src.loc]'s [src.name].", "You adjust [src.loc]'s sensors.")
	else
		user.visible_message("[user] adjusts the tracking sensor on [src]", "You adjust the sensor on [src].")

/obj/item/clothing/under/emp_act(var/severity)
	..()
	var/new_mode
	switch(severity)
		if(1)
			new_mode = pick(75;SUIT_SENSOR_OFF, 15;SUIT_SENSOR_BINARY, 10;SUIT_SENSOR_VITAL)
		if(2)
			new_mode = pick(50;SUIT_SENSOR_OFF, 25;SUIT_SENSOR_BINARY, 20;SUIT_SENSOR_VITAL, 5;SUIT_SENSOR_TRACKING)
		else
			new_mode = pick(25;SUIT_SENSOR_OFF, 35;SUIT_SENSOR_BINARY, 30;SUIT_SENSOR_VITAL, 10;SUIT_SENSOR_TRACKING)

	sensor_mode = new_mode

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/under/Initialize()
	sensor_mode = pick(0,1,2,3)
	. = ..()

/obj/item/clothing/under/AltClick(var/mob/user)
	if(CanPhysicallyInteract(user))
		set_sensors(user)
