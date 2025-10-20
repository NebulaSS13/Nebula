/obj/item/laundry_basket
	name = "laundry basket"
	icon = 'icons/obj/items/storage/laundry.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "The peak of thousands of years of laundry evolution."
	w_class = ITEM_SIZE_GARGANTUAN
	storage = /datum/storage/laundry_basket
	material = /decl/material/solid/organic/plastic
	obj_flags = OBJ_FLAG_HOLLOW
	paint_color = COLOR_NAVY_BLUE

/obj/item/laundry_basket/attack_self(mob/user)
	var/turf/dump_loc = get_turf(user)
	if(length(contents) && dump_loc)
		to_chat(user, SPAN_NOTICE("You dump \the [src]'s contents onto \the [dump_loc]."))
		for(var/atom/movable/thing as anything in get_contained_external_atoms())
			thing.dropInto(dump_loc)
		return TRUE
	return ..()

/obj/item/laundry_basket/Entered(atom/movable/atom, atom/old_loc)
	. = ..()
	update_clothing_icon()

/obj/item/laundry_basket/Exited(atom/movable/atom, atom/old_loc)
	. = ..()
	update_clothing_icon()

/obj/item/laundry_basket/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	cut_overlays()
	if(length(contents))
		add_overlay(overlay_image(icon, "[icon_state]-full", COLOR_WHITE, RESET_COLOR))

/obj/item/laundry_basket/get_mob_overlay(mob/user_mob, slot, bodypart, use_fallback_if_icon_missing, skip_adjustment)
	var/image/res = ..()
	if(length(contents))
		res.overlays += overlay_image(res.icon, "[res.icon_state]-full", COLOR_WHITE, RESET_COLOR)
	return res
