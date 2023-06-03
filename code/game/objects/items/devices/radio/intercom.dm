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
	obj_flags = OBJ_FLAG_CONDUCTIBLE | OBJ_FLAG_MOVES_UNSUPPORTED
	layer = ABOVE_WINDOW_LAYER
	cell = null
	power_usage = 0
	intercom = TRUE
	intercom_handling = TRUE
	directional_offset = "{'NORTH':{'y':-30}, 'SOUTH':{'y':20}, 'EAST':{'x':-22}, 'WEST':{'x':22}}"
	var/last_tick //used to delay the powercheck

/obj/item/radio/intercom/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/radio/intercom/wizard
	name = "enchanted intercom"
	desc = "Talk into this while you ponder your orb."

/obj/item/radio/intercom/ninja
	name = "stealth intercom"
	desc = "It's hiding in plain sight."

/obj/item/radio/intercom/raider
	name = "piratical intercom"
	desc = "Pirate radio, but not in the usual sense of the word."

/obj/item/radio/intercom/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/radio/intercom/attack_ai(mob/living/silicon/ai/user)
	return attack_self(user)

/obj/item/radio/intercom/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return attack_self(user)

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
	. = ..()
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
