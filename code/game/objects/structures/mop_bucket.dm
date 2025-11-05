/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = TRUE
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER
	chem_volume = 180

/obj/structure/mopbucket/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 1)
		. += "\The [src] [html_icon(src)] contains [reagents.total_volume] unit\s of water!"

/obj/structure/mopbucket/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("\The [src] is out of water!"))
		else if(REAGENTS_FREE_SPACE(used_item.reagents) >= 5)
			reagents.trans_to_obj(used_item, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [used_item] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("\The [used_item] is saturated."))
		return TRUE
	return ..()
