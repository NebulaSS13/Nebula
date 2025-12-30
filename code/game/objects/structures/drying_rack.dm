/obj/structure/drying_rack
	name = "drying rack"
	desc = "A rack used to hold meat or vegetables for drying, or to stretch leather out and hold it taut during the tanning process."
	icon = 'icons/obj/drying_rack.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/metal/steel
	color = /decl/material/solid/metal/steel::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/obj/item/drying

/obj/structure/drying_rack/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/drying_rack/Destroy()
	QDEL_NULL(drying)
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

// SSObj fires ~every 2s , starting from wetness 30 takes ~1m
/obj/structure/drying_rack/Process()
	if(!drying)
		return

	if(isturf(loc))
		var/turf/my_turf = loc
		var/decl/state/weather/weather_state = my_turf.weather?.weather_system?.current_state
		if(istype(weather_state) && weather_state.is_liquid)
			return // can't dry in the rain
	if(loc?.is_flooded(TRUE))
		return // can't dry in the wet

	var/dry_product = drying?.dry_out(src)
	if(dry_product)
		if(drying != dry_product)
			if(drying && !QDELETED(drying))
				drying.dropInto(loc)
			drying = dry_product
			if(is_processing)
				STOP_PROCESSING(SSobj, src)
		if(drying)
			drying.forceMove(src)
	if(drying)
		drying.update_icon()
	update_icon()

/obj/structure/drying_rack/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(drying)
		. += "\The [drying] is [drying.get_dryness_text()]."

/obj/structure/drying_rack/on_update_icon()
	..()
	var/drying_state = drying?.get_drying_overlay(src)
	if(drying_state)
		add_overlay(drying_state)

/obj/structure/drying_rack/attackby(var/obj/item/used_item, var/mob/user)

	if(!drying && used_item.is_dryable())
		if(user.try_unequip(used_item))
			used_item.forceMove(src)
			drying = used_item
			if(!is_processing)
				START_PROCESSING(SSobj, src)
			update_icon()
		return TRUE

	return ..()

/obj/structure/drying_rack/attack_hand(var/mob/user)
	if(drying)
		drying.dropInto(loc)
		user.put_in_hands(drying)
		drying = null
		if(is_processing)
			STOP_PROCESSING(SSobj, src)
		update_icon()
	return ..()

/obj/structure/drying_rack/attack_robot(mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	return ..()
