/datum/storage/forge
	can_hold = list(
		/obj/item/stack/material/bar,
		/obj/item/billet
	)
	max_storage_space = ITEM_SIZE_NORMAL * 10 // Fairly spacious
	max_w_class       = ITEM_SIZE_LARGE

/datum/storage/forge/consolidate_stacks()
	return // We want to keep them as single bars.

/obj/structure/fire_source/forge
	name        = "forge fire"
	desc        = "A sturdy hearth used to heat metal bars for forging on an anvil."
	density     = TRUE
	icon        = 'mods/content/blacksmithy/icons/forge.dmi'
	icon_state  = "forge"
	storage     = /datum/storage/forge

/obj/structure/fire_source/forge/proc/get_forgable_contents()
	. = list()
	for(var/obj/item/thing in get_stored_inventory())
		if(thing.is_forgable() && (istype(thing, /obj/item/billet) || istype(thing, /obj/item/stack/material/bar)))
			. += thing

/obj/structure/fire_source/forge/attackby(obj/item/used_item, mob/user)

	var/item_is_forgable = used_item.is_forgable()
	// Raw materials.
	if(istype(used_item, /obj/item/stack/material/bar) && item_is_forgable)
		var/obj/item/stack/material/bar/bar = used_item
		if(used_item.material != material || current_health >= get_max_health())
			if(bar.get_amount() > 1)
				bar = bar.split(1)
			if(bar.loc == user)
				if(!user.try_unequip(bar, get_turf(src)))
					return TRUE
			else
				bar.dropInto(get_turf(src))
			qdel(bar)
			used_item = new /obj/item/billet(loc, used_item.material?.type)
			// Flows through to below.

	// Partially worked billets.
	if(istype(used_item, /obj/item/billet) && item_is_forgable)
		if(used_item.loc == user)
			user.try_unequip(used_item, loc)
		else
			used_item.dropInto(loc)
		if(storage.can_be_inserted(used_item, user))
			storage.handle_item_insertion(user, used_item)
			update_icon()
		return TRUE

	// Tongs holding bars or partially worked billets.
	if(istype(used_item, /obj/item/tongs) && !user.check_intent(I_FLAG_HARM))

		// Put whatever's in the tongs into storage.
		var/obj/item/tongs/tongs = used_item
		if(tongs.holding_bar)
			return attackby(tongs.holding_bar, user)

		// Check if we have any bars.
		var/list/bars = get_forgable_contents()
		if(!length(bars))
			to_chat(user, SPAN_WARNING("There are no bars in \the [src] to retrieve."))
			return TRUE

		// Get the hottest bar.
		var/obj/item/hottest_bar
		for(var/obj/item/bar in bars)
			if(!hottest_bar || bar.temperature > hottest_bar)
				hottest_bar = bar

		// Extract a single bar from the forge with the tongs.
		if(storage.remove_from_storage(user, hottest_bar, tongs))
			tongs.holding_bar = hottest_bar
		if(tongs.holding_bar)
			user.visible_message(SPAN_NOTICE("\The [user] pulls \the [tongs.holding_bar] from \the [src] with \the [tongs]."))
			tongs.update_icon()
		return TRUE

	return ..()
