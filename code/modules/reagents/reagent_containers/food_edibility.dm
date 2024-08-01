/obj/item/food/get_edible_material_amount(mob/eater)
	return reagents?.total_volume

/obj/item/food/get_food_consumption_method(mob/eater)
	return EATING_METHOD_EAT

/obj/item/food/play_feed_sound(mob/user, consumption_method = EATING_METHOD_EAT)
	if(eat_sound)
		playsound(user, pick(eat_sound), rand(10, 50), 1)
		return
	return ..()

/obj/item/food/handle_eaten_by_mob(mob/user, mob/target)
	. = ..()
	if(. == EATEN_SUCCESS)
		bitecount++

/obj/item/food/get_food_default_transfer_amount(mob/eater)
	return eater?.get_eaten_transfer_amount(bitesize)

/obj/item/food/handle_consumed(mob/feeder, mob/eater, consumption_method = EATING_METHOD_EAT)

	if(isliving(eater))
		var/mob/living/living_eater = eater
		if(cooked_food == FOOD_COOKED)
			living_eater.add_stressor(/datum/stressor/ate_cooked_food, 15 MINUTES)
		else if(cooked_food == FOOD_RAW)
			living_eater.add_stressor(/datum/stressor/ate_raw_food, 15 MINUTES)

	var/atom/loc_ref = loc
	var/obj/item/plate_ref = plate
	var/trash_ref = trash
	. = ..()
	if(.)
		if(trash_ref)
			if(ispath(trash_ref, /obj/item))
				var/obj/item/trash_item = new trash_ref(loc_ref)
				if(feeder)
					feeder.put_in_hands(trash_item)
			else if(istype(trash_ref, /obj/item))
				var/obj/item/trash_item = trash_ref
				if(!QDELETED(trash_item))
					trash_item.dropInto(loc_ref)
					if(feeder)
						feeder.put_in_hands(trash_item)
		if(plate_ref && !QDELETED(plate_ref))
			plate_ref.dropInto(loc_ref)
			if(feeder)
				feeder.put_in_hands(plate_ref)
