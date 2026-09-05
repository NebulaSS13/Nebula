//old style cart
/obj/structure/vehicle/janicart
	name = "janicart"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "pussywagon"
	color = null
	buckle_layer_above = TRUE
	material_alteration = MAT_FLAG_ALTERATION_NONE
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	chem_volume = 100
	key_type = /obj/item/janicart_key
	vehicle_name = "pimpin' ride"	//how do people refer to it?
	var/obj/item/bag/trash/mybag = null

/obj/structure/vehicle/janicart/Initialize()
	// Handled in init due to dirs needing to be stringified
	_buckle_pixel_shift = list(
		"[NORTH]" = list("x" =   0, "y" = 4, "z" = 0),
		"[SOUTH]" = list("x" =   0, "y" = 7, "z" = 0),
		"[EAST]"  = list("x" = -13, "y" = 7, "z" = 0),
		"[WEST]"  = list("x" =  13, "y" = 7, "z" = 0)
	)
	. = ..()

/obj/structure/vehicle/janicart/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "[html_icon(src)] This [vehicle_name || name] contains [REAGENT_TOTAL_VOLUME(reagents)] unit\s of water!"
		if(mybag)
			. += "\A [mybag] is hanging on the [vehicle_name || name]."

/obj/structure/vehicle/janicart/attackby(obj/item/used_item, mob/user)

	if(istype(used_item, /obj/item/mop))
		if(REAGENT_TOTAL_VOLUME(reagents) > 1)
			reagents.trans_to_obj(used_item, 2)
			to_chat(user, SPAN_NOTICE("You wet [used_item] in the [vehicle_name || name]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_NOTICE("This [vehicle_name || name] is out of water!"))
		return TRUE

	if(istype(used_item, /obj/item/bag/trash))
		if(!user.try_unequip(used_item, src))
			return TRUE
		to_chat(user, SPAN_NOTICE("You hook \the [used_item] onto the [vehicle_name || name]."))
		mybag = used_item
		return TRUE

	. = ..()

/obj/structure/vehicle/janicart/attack_hand(mob/user)
	if(!mybag || !user.check_dexterity(DEXTERITY_HOLD_ITEM, TRUE))
		return ..()
	user.put_in_hands(mybag)
	mybag = null
	return TRUE

/obj/structure/vehicle/janicart/bullet_act(var/obj/item/projectile/Proj)
	for(var/mob/buckle_mob in get_buckled_mobs())
		if(prob(85))
			return buckle_mob.bullet_act(Proj)
	visible_message(SPAN_WARNING("\The [Proj] ricochets off the [vehicle_name || name]!"))

/obj/item/janicart_key
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE)
