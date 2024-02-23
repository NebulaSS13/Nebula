/datum/extension/storage/pillbottle
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

/datum/extension/storage/pillbottle/remove_from_storage(obj/item/W, atom/new_location, NoUpdate)
	. = ..()
	if(. && istype(holder, /obj/item/pill_bottle/foil_pack))
		var/obj/item/pill_bottle/foil_pack/pop = holder
		if(pop.pop_sound)
			playsound(get_turf(pop), pop.pop_sound, 50)

/datum/extension/storage/pillbottle/foil/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	return FALSE

/datum/extension/storage/pillbottle/foil/remove_from_storage(obj/item/W, atom/new_location, NoUpdate)
	. = ..()
	if(. && W.loc != holder && istype(W, /obj/item/pill_bottle/foil_pack))
		var/obj/item/pill_bottle/foil_pack/pop = holder
		if(pop.pill_positions)
			pop.pill_positions -= W
			pop.update_icon()
