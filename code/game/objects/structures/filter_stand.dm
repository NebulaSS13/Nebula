/obj/structure/filter_stand
	name = "filtration stand"
	desc = "A frame suitable for fitting a sieve or filter into, for use in separating liquids and solids."
	icon = 'icons/obj/structures/sieve.dmi'
	icon_state = ICON_STATE_WORLD
	density = TRUE
	anchored = TRUE
	material = /decl/material/solid/organic/wood
	material_alteration = MAT_FLAG_ALTERATION_ALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	var/obj/item/chems/filter/filter
	var/obj/item/chems/glass/loaded

/obj/structure/filter_stand/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	initialize_reagents()

/obj/structure/filter_stand/initialize_reagents(populate)
	create_reagents(200)
	. = ..()

/obj/structure/filter_stand/mapped/Initialize(ml, _mat, _reinf_mat)
	filter = new(src)
	set_loaded_vessel(new /obj/item/chems/glass/handmade/jar(src))
	. = ..()

/obj/structure/filter_stand/attackby(obj/item/used_item, mob/user)

	if(istype(used_item, /obj/item/chems/filter))
		if(filter)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [filter] inserted."))
		else if(user.try_unequip(used_item, src))
			to_chat(user, SPAN_NOTICE("You insert \the [used_item] into \the [src]."))
			filter = used_item
			update_icon()
		return TRUE

	if(istype(used_item, /obj/item/chems/glass))
		if(loaded)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [loaded] inserted."))
		else if(user.try_unequip(used_item, src))
			to_chat(user, SPAN_NOTICE("You insert \the [used_item] into \the [src]."))
			set_loaded_vessel(used_item)
		return TRUE

	return ..()

/obj/structure/filter_stand/Exited(atom/movable/am, atom/new_loc)
	. = ..()
	if(am != loaded)
		return
	set_loaded_vessel(null, skip_loc_change = TRUE)
	if(ismob(new_loc))
		visible_message(SPAN_NOTICE("\The [new_loc] removes \the [am] from \the [src]."))

/obj/structure/filter_stand/proc/set_loaded_vessel(new_vessel, skip_loc_change)
	if(new_vessel == loaded)
		return
	if(loaded)
		loaded.vis_flags = initial(loaded.vis_flags)
		vis_contents -= loaded
		if(!skip_loc_change)
			loaded.dropInto(loc)
		loaded.appearance_flags = initial(loaded.appearance_flags)
		loaded = null
	loaded = new_vessel
	if(loaded)
		loaded.reset_offsets(anim_time = 0)
		loaded.pixel_z = -4
		loaded.vis_flags |= (VIS_INHERIT_LAYER | VIS_INHERIT_PLANE)
		loaded.appearance_flags |= RESET_COLOR
		vis_contents |= loaded

/obj/structure/filter_stand/attack_hand(mob/user)
	if(filter)
		filter.dropInto(loc)
		user.put_in_hands(filter)
		to_chat(user, SPAN_NOTICE("You remove \the [filter] from \the [src]."))
		filter = null
		update_icon()
		return TRUE
	return ..()

/obj/structure/filter_stand/on_update_icon()
	. = ..()
	if(istype(filter))
		add_overlay(filter.get_stand_overlay())
	add_overlay("[icon_state]-overlay")

// Pouring directly into the filter via attackby() is not working, so we just dump our reagents into our filter or the turf.
/obj/structure/filter_stand/on_reagent_change()
	. = ..()
	if(reagents?.total_volume <= 0)
		return
	if(filter?.reagents?.maximum_volume)
		var/taking = min(reagents?.total_volume, REAGENTS_FREE_SPACE(filter.reagents))
		if(taking > 0)
			reagents.trans_to_holder(filter.reagents, taking)
			if(reagents?.total_volume <= 0)
				return
	var/turf/my_turf = get_turf(src)
	if(istype(my_turf))
		reagents.trans_to_turf(my_turf, reagents.total_volume)

/obj/item/chems/filter
	name = "filter"
	desc = "A small square object used in a filtration stand to filter liquids and solids from each other."
	icon = 'icons/obj/items/sieve_filter.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_TINY
	material_alteration = MAT_FLAG_ALTERATION_ALL
	material = /decl/material/solid/organic/cloth
	volume = 100
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/chems/filter/on_reagent_change()
	. = ..()
	if(reagents?.total_liquid_volume)
		if(!is_processing)
			START_PROCESSING(SSobj, src)
	else
		if(is_processing)
			STOP_PROCESSING(SSobj, src)

/obj/item/chems/filter/Process()
	if(!reagents?.total_liquid_volume)
		return PROCESS_KILL

	var/dumping = 0
	var/dripping = min(reagents.total_liquid_volume, rand(3,5))
	var/obj/structure/filter_stand/stand = loc
	if(!istype(stand) || stand.filter != src || !stand.loaded?.reagents)
		dumping = dripping
		dripping = 0
	else
		var/use_loaded = min(dripping, REAGENTS_FREE_SPACE(stand.loaded.reagents))
		dripping -= use_loaded
		dumping = dripping
		dripping = use_loaded

	if(dripping)
		reagents.trans_to_holder(stand.loaded.reagents, dripping, transferred_phases = MAT_PHASE_LIQUID)
	if(dumping)
		var/turf/dump_turf = get_turf(stand)
		if(istype(dump_turf))
			reagents.trans_to_turf(dump_turf, dumping, transferred_phases = MAT_PHASE_LIQUID)

/obj/item/chems/filter/proc/get_stand_overlay()
	return list(overlay_image(icon, "[icon_state]-inserted", material?.color, RESET_COLOR))
