/obj/item/clothing/under
	name = "under"
	icon = 'icons/clothing/under/jumpsuits/jumpsuit.dmi'
	icon_state = ICON_STATE_WORLD
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_UPPER_BODY
	w_class = ITEM_SIZE_NORMAL
	force = 0

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

	var/has_sensor = SUIT_HAS_SENSORS
	var/sensor_mode = SUIT_SENSOR_OFF
	var/displays_id = 1
	var/rolled_down = FALSE
	var/rolled_sleeves = FALSE

/obj/item/clothing/under/Initialize()
	sensor_mode = pick(0,1,2,3)
	. = ..()
	if(check_state_in_icon("[BODYTYPE_HUMANOID]-[slot_w_uniform_str]-rolled", icon))
		verbs |= /obj/item/clothing/under/proc/roll_down_clothes
	if(check_state_in_icon("[BODYTYPE_HUMANOID]-[slot_w_uniform_str]-sleeves", icon))
		verbs |= /obj/item/clothing/under/proc/roll_up_sleeves

/obj/item/clothing/under/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && slot == slot_w_uniform_str)
		if(rolled_down && check_state_in_icon("[overlay.icon_state]-rolled", overlay.icon))
			overlay.icon_state = "[overlay.icon_state]-rolled"
		else
			var/mob/living/carbon/human/user_human = user_mob
			if(istype(user_human) && user_human.bodytype.uniform_state_modifier && check_state_in_icon("[overlay.icon_state]-[user_human.bodytype.uniform_state_modifier]", overlay.icon))
				overlay.icon_state = "[overlay.icon_state]-[user_human.bodytype.uniform_state_modifier]"
			if(rolled_sleeves && check_state_in_icon("[overlay.icon_state]-sleeves", overlay.icon))
				overlay.icon_state = "[overlay.icon_state]-sleeves"
	. = ..()

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
		var/user_message
		switch(sensor_mode)
			if(0)
				user_message = "You disable your suit's remote sensing equipment."
			if(1)
				user_message = "Your suit will now report whether you are live or dead."
			if(2)
				user_message = "Your suit will now report your vital lifesigns."
			if(3)
				user_message = "Your suit will now report your vital lifesigns as well as your coordinate position."

		if(user_message)
			var/decl/pronouns/G = user.get_pronouns()
			user.visible_message( \
				SPAN_NOTICE("\The [user] adjusts the tracking sensor on [G.his] [name]."), \
				SPAN_NOTICE(user_message))

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

/decl/interaction_handler/clothing_set_sensors
	name = "Set Sensors Level"
	expected_target_type = /obj/item/clothing/under

/decl/interaction_handler/clothing_set_sensors/invoked(var/atom/target, var/mob/user)
	var/obj/item/clothing/under/U = target
	U.set_sensors(user)

/obj/item/clothing/under/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/clothing_set_sensors)

// This stub is so the linter stops yelling about sleeping during Initialize()
// due to corpse props equipping themselves, which calls equip_to_slot, which
// calls attackby(), which sometimes sleeps due to input(). Yeah.
// Remove this if a better fix presents itself.
/obj/item/clothing/under/proc/try_attach_accessory(var/obj/item/accessory, var/mob/user)
	set waitfor = FALSE
	attackby(accessory, user)
