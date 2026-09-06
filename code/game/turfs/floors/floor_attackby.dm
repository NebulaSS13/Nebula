/turf/floor/attack_hand(mob/user)

	// Collect snow or mud.
	var/decl/flooring/flooring = get_topmost_flooring()
	if(flooring?.handle_hand_interaction(src, user))
		return TRUE

	var/obj/item/hand = GET_EXTERNAL_ORGAN(user, user.get_active_held_item_slot())
	if(hand && try_graffiti(user, hand))
		return TRUE

	return ..()

/turf/floor/attackby(var/obj/item/used_item, var/mob/user)
	if(!used_item || !user)
		return FALSE
	if(istype(used_item, /obj/item/stack/tile/roof) || IS_COIL(used_item) || (has_flooring() && istype(used_item, /obj/item/stack/material/rods)))
		return ..()
	var/decl/flooring/top_flooring = get_topmost_flooring()
	if(istype(top_flooring) && top_flooring.handle_item_interaction(src, user, used_item))
		return TRUE
	if(try_backfill(used_item, user))
		return TRUE
	if(try_stack_build(used_item, user))
		return TRUE
	if(try_turf_repair_or_deconstruct(used_item, user))
		return TRUE
	return ..()

/turf/floor/proc/try_build_catwalk(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/stack/material/rods) && !get_supporting_platform())
		var/obj/item/stack/material/rods/R = used_item
		if (R.use(2))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/catwalk(src, R.material.type)
			return TRUE
	return FALSE

/turf/floor/proc/try_stack_build(var/obj/item/stack/S, var/mob/user)
	if(!istype(S))
		return FALSE

	if(is_floor_damaged())
		to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
		return TRUE

	if(try_build_catwalk(S, user))
		return TRUE

	var/decl/flooring/use_flooring
	for(var/decl/flooring/F as anything in decls_repository.get_decls_of_subtype_unassociated(/decl/flooring))
		if(!F.build_type)
			continue
		// If S.build_type is set, we expect an exact match. Otherwise, we do
		// an ispath on S.type. This is a shitty way to disambiguate carpet
		// types because they're in the ugly position of "same material, built
		// with a subtype" whereas with everything else, material + type
		// disambiguates well enough.
		if((S.build_type ? S.build_type == F.build_type : ispath(S.type, F.build_type)) && (isnull(F.build_material) || S.material?.type == F.build_material))
			use_flooring = F
			break
	if(!use_flooring)
		return FALSE

	// Do we have enough?
	if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
		to_chat(user, SPAN_WARNING("You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor]."))
		return TRUE
	// Stay still and focus...
	if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
		return TRUE
	if(has_flooring() || !S || !user || !use_flooring)
		return TRUE
	if(S.use(use_flooring.build_cost))
		set_flooring(use_flooring)
		playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
	return TRUE

/turf/floor/proc/try_backfill(obj/item/stack/material/used_item, mob/user)

	var/decl/flooring/flooring = get_topmost_flooring()
	if((istype(flooring) && flooring.constructed) || !istype(used_item) || !istype(user))
		return FALSE

	var/decl/flooring/base_flooring = get_base_flooring()
	if(istype(base_flooring) && base_flooring.constructed)
		return FALSE

	if(!istype(used_item, /obj/item/stack/material/ore) && !istype(used_item, /obj/item/stack/material/lump))
		return FALSE

	if(get_physical_height() >= 0)
		to_chat(user, SPAN_WARNING("\The [src] is flush with ground level and cannot be backfilled."))
		return TRUE

	if(!used_item.material?.can_backfill_floor_type)
		to_chat(user, SPAN_WARNING("You cannot use \the [used_item] to backfill \the [src]."))
		return TRUE

	var/can_backfill = islist(used_item.material.can_backfill_floor_type) ? is_type_in_list(flooring, used_item.material.can_backfill_floor_type) : istype(flooring, used_item.material.can_backfill_floor_type)
	if(!can_backfill)
		to_chat(user, SPAN_WARNING("You cannot use \the [used_item] to backfill \the [src]."))
		return TRUE

	var/obj/item/stack/stack = used_item
	if(!do_after(user, 1 SECOND, src) || user.get_active_held_item() != stack || get_physical_height() >= 0)
		return TRUE

	// At best, you get about 5 pieces of clay or dirt from digging the
	// associated turfs. So we'll make it cost 5 to put some back.
	// TODO: maybe make this use the diggable loot list.
	var/stack_depth = ceil((abs(get_physical_height()) / TRENCH_DEPTH_PER_ACTION) * 5)
	var/using_lumps = max(1, min(stack.amount, min(stack_depth, 5)))
	if(stack.use(using_lumps))
		set_physical_height(min(0, get_physical_height() + ((using_lumps / 5) * TRENCH_DEPTH_PER_ACTION)))
		playsound(src, 'sound/items/shovel_dirt.ogg', 50, TRUE)
		if(get_physical_height() >= 0)
			visible_message(SPAN_NOTICE("\The [user] backfills \the [src]!"))
		else
			visible_message(SPAN_NOTICE("\The [user] partially backfills \the [src]."))
	return TRUE

/turf/floor/proc/is_constructed_floor()
	var/decl/flooring/flooring = get_topmost_flooring()
	return flooring?.constructed

/turf/floor/proc/try_turf_repair_or_deconstruct(var/obj/item/used_item, var/mob/user)

	if(!is_constructed_floor())
		return FALSE

	if(IS_CROWBAR(used_item) && is_floor_damaged())
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
		visible_message(SPAN_NOTICE("\The [user] has begun prying off the damaged plating."))
		. = TRUE
		var/turf/T = GetBelow(src)
		if(T)
			T.visible_message(SPAN_DANGER("The ceiling above looks as if it's being pried off."))

		if(do_after(user, 10 SECONDS))
			if(!is_floor_damaged() || !(is_plating()))return
			visible_message(SPAN_DANGER("\The [user] has pried off the damaged plating!"))
			new /obj/item/stack/tile/floor(src)
			physically_destroyed()
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			if(T)
				T.visible_message(SPAN_DANGER("The ceiling above has been pried off!"))
		return TRUE

	if(IS_WELDER(used_item))
		var/obj/item/weldingtool/welder = used_item
		if(welder.isOn() && is_plating() && welder.weld(0, user))
			if(is_floor_damaged())
				to_chat(user, SPAN_NOTICE("You fix some damage to \the [src]."))
				playsound(src, 'sound/items/Welder.ogg', 80, 1)
				icon_state = "plating"
				set_floor_burned(skip_update = TRUE)
				set_floor_broken()
			else
				playsound(src, 'sound/items/Welder.ogg', 80, 1)
				visible_message(SPAN_NOTICE("\The [user] has started melting \the [src]'s reinforcements!"))
				if(do_after(user, 5 SECONDS) && welder.isOn() && welder_melt())
					visible_message(SPAN_NOTICE("\The [user] has melted \the [src]'s reinforcements! It should now be possible to pry it off."))
					playsound(src, 'sound/items/Welder.ogg', 80, 1)
			return TRUE

	if(istype(used_item, /obj/item/gun/energy/plasmacutter) && (is_plating()) && !is_floor_damaged())
		var/obj/item/gun/energy/plasmacutter/cutter = used_item
		if(cutter.slice(user))
			playsound(src, 'sound/items/Welder.ogg', 80, 1)
			visible_message(SPAN_NOTICE("\The [user] has started slicing through \the [src]'s reinforcements!"))
			. = TRUE
			if(do_after(user, 3 SECONDS) && welder_melt())
				visible_message(SPAN_NOTICE("\The [user] has sliced through \the [src]'s reinforcements! It should now be possible to pry it off."))
				playsound(src, 'sound/items/Welder.ogg', 80, 1)
			return TRUE

	return FALSE

/turf/floor/proc/welder_melt()
	if(!(is_plating()) || is_floor_damaged())
		return FALSE
	// if burned/broken is nonzero plating just chooses a random icon
	// so it doesn't really matter what we set this to as long as it's truthy
	// let's keep it a string for consistency with the other uses of it
	set_floor_burned(TRUE, skip_update = TRUE)
	remove_decals()
	return TRUE

/turf/floor/why_cannot_build_cable(var/mob/user, var/cable_error)
	switch(cable_error)
		if(0)
			return
		if(1)
			to_chat(user, SPAN_WARNING("Removing the tiling first."))
		if(2)
			to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
		else //Fallback
			. = ..()

/turf/floor/cannot_build_cable()
	if(is_floor_damaged())
		return 2
	if(!is_plating())
		return 1
