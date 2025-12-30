/obj/item/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/items/storage/matchbox.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	storage = /datum/storage/box/matches

/obj/item/box/matches/WillContain()
	return list(/obj/item/flame/match = 10)

/obj/item/box/matches/attackby(obj/item/used_item, mob/user)
	if(istype(used_item, /obj/item/flame/match))
		var/obj/item/flame/match/match = used_item
		if(match.light(null, no_message = TRUE))
			playsound(src.loc, 'sound/items/match.ogg', 60, 1, -4)
			user.visible_message(
				SPAN_NOTICE("[user] strikes [used_item] on \the [src]."),
				SPAN_NOTICE("You strike [used_item] on \the [src].")
			)
			used_item.update_icon()
			return TRUE
	return ..()
