/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	w_class = ITEM_SIZE_NORMAL
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_OPEN_CONTAINER


/obj/structure/mopbucket/Initialize()
	. = ..()
	create_reagents(180)

/obj/structure/mopbucket/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "[src] [html_icon(src)] contains [reagents.total_volume] unit\s of water!")

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("\The [src] is out of water!"))
		else if(REAGENTS_FREE_SPACE(I.reagents) >= 5)
			reagents.trans_to_obj(I, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [I] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("\The [I] is saturated."))
