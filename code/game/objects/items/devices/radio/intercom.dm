/obj/item/radio/intercom
	name = "intercom (General)"
	desc = "Talk through this."
	icon = 'icons/obj/items/device/radio/intercom.dmi'
	icon_state = "intercom"
	randpixel = 0
	anchored = 1
	w_class = ITEM_SIZE_STRUCTURE
	canhear_range = 2
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	layer = ABOVE_WINDOW_LAYER
	cell = null
	power_usage = 0
	intercom = TRUE
	var/number = 0
	var/last_tick //used to delay the powercheck

/obj/item/radio/intercom/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/radio/intercom/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/radio/intercom/attack_ai(mob/living/silicon/ai/user)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/radio/intercom/attack_hand(mob/user)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1

	return canhear_range

/obj/item/radio/intercom/Process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday
		var/old_on = on

		if(!src.loc)
			on = 0
		else
			var/area/A = get_area(src)
			if(!A)
				on = 0
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if (on != old_on)
			update_icon()

/obj/item/radio/intercom/on_update_icon()
	if(!on)
		icon_state = "intercom-p"
	else
		icon_state = "intercom_[broadcasting][listening]"

/obj/item/radio/intercom/toggle_broadcast()
	..()
	update_icon()

/obj/item/radio/intercom/toggle_reception()
	..()
	update_icon()

/obj/item/radio/intercom/broadcasting
	broadcasting = 1

/obj/item/radio/intercom/locked
	var/locked_frequency

/obj/item/radio/intercom/locked/set_frequency()
	..(locked_frequency)
