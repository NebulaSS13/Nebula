/obj/structure/produce_bin
	name = "produce bin"
	desc = "A squat bin for storing produce."
	icon = 'icons/obj/structures/produce_bin.dmi'
	icon_state = ICON_STATE_WORLD
	anchored = TRUE
	density = TRUE
	color = /decl/material/solid/organic/wood/oak::color
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_ALL
	storage = /datum/storage/produce_bin

/obj/structure/produce_bin/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/produce_bin/LateInitialize(mapload, ...)
	..()
	if(mapload)
		for(var/obj/item/food/grown/produce in loc)
			if(!produce.simulated || produce.anchored)
				continue
			if(storage.can_be_inserted(produce, null))
				storage.handle_item_insertion(null, produce)

/obj/structure/produce_bin/attackby(obj/item/used_item, mob/user)

	if(user.check_intent(I_FLAG_HARM))
		return ..()

	if(used_item.storage)

		var/emptied = FALSE
		for(var/obj/item/food/grown/produce in used_item.get_stored_inventory())
			if(storage.can_be_inserted(produce))
				used_item.storage.remove_from_storage(null, produce, loc, skip_update = TRUE)
				storage.handle_item_insertion(null, produce, skip_update = TRUE)
				emptied = TRUE

		if(emptied)
			used_item.storage.finish_bulk_removal()
			storage.finish_bulk_insertion()
			if(length(used_item.get_stored_inventory()))
				to_chat(user, SPAN_NOTICE("You partially empty \the [used_item] into \the [src]'s hopper."))
			else
				to_chat(user, SPAN_NOTICE("You empty \the [used_item] into \the [src]'s hopper."))
			return TRUE

	return ..()

/obj/structure/produce_bin/on_update_icon()
	. = ..()
	var/storage_space_used = storage.storage_space_used()
	if(storage_space_used <= 0)
		return
	var/capacity = clamp(round(storage.storage_space_used() / storage.max_storage_space * 100, 20), 20, 100) // increments of 20%
	add_overlay(overlay_image(icon, "[icon_state]-fill-[capacity]", null, RESET_COLOR))

/obj/structure/produce_bin/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/produce_bin/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color