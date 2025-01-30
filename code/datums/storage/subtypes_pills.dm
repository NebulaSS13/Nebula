/datum/storage/pillbottle
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 21
	can_hold = list(
		/obj/item/chems/pill,
		/obj/item/dice,
		/obj/item/paper
	)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/effects/storage/pillbottle.ogg'

/datum/storage/pillbottle/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	. = ..()
	if(. && istype(holder, /obj/item/pill_bottle/foil_pack))
		var/obj/item/pill_bottle/foil_pack/pop = holder
		if(pop.pop_sound)
			playsound(get_turf(pop), pop.pop_sound, 50)

/datum/storage/pillbottle/foil/can_be_inserted(obj/item/W, mob/user, stop_messages = 0, click_params = null)
	return FALSE

/datum/storage/pillbottle/foil/remove_from_storage(mob/user, obj/item/W, atom/new_location, skip_update)
	. = ..()
	if(. && W.loc != holder && istype(W, /obj/item/pill_bottle/foil_pack))
		var/obj/item/pill_bottle/foil_pack/pop = holder
		if(pop.pill_positions)
			pop.pill_positions -= W
			pop.update_icon()
