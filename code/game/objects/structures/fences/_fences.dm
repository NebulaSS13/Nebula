// Various fences
// Chain link sprites ported from /VG/
// Stone, stick, plank and palisade sprites by Doe.


/obj/structure/fence
	name                   = "fence"
	desc                   = "A fence. Not as effective as a wall, but generally it keeps people out."
	density                = TRUE
	anchored               = TRUE
	icon                   = /decl/fence_type::fence_icon
	icon_state             = /decl/fence_type::straight_state
	material               = /decl/material/solid/metal/steel
	atom_flags             = ATOM_FLAG_CLIMBABLE
	material_alteration    = MAT_FLAG_ALTERATION_ALL
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT

	var/decl/fence_type/fence_data = /decl/fence_type
	var/hole_size                  = NO_HOLE
	var/connected_dirs             = 0

	var/const/CUT_TIME      = 10 SECONDS
	///section is intact
	var/const/NO_HOLE       = 0
	///medium hole in the section - can climb through
	var/const/MEDIUM_HOLE   = 1
	///large hole in the section - can walk through
	var/const/LARGE_HOLE    = 2
	var/const/MAX_HOLE_SIZE = LARGE_HOLE

/obj/structure/fence/Destroy()
	var/turf/prior_loc = loc
	. = ..()
	if(istype(prior_loc))
		for(var/check_dir in global.cardinal)
			for(var/obj/structure/fence/fence in get_step_resolving_mimic(prior_loc, check_dir))
				fence.update_icon()

/obj/structure/fence/Initialize(ml, _mat, _reinf_mat)
	if(ispath(fence_data))
		fence_data = GET_DECL(fence_data)
		set_icon(fence_data.fence_icon)
	else if(!istype(fence_data))
		fence_data = null
	. = ..()
	update_cut_status()
	if(ml)
		queue_icon_update()
	else
		return INITIALIZE_HINT_LATELOAD

/obj/structure/fence/LateInitialize()
	. = ..()
	update_icon()
	for(var/check_dir in global.cardinal)
		var/turf/neighbor = get_step_resolving_mimic(get_turf(src), check_dir)
		if(istype(neighbor))
			for(var/obj/structure/fence/fence in neighbor)
				if(fence_data == RESOLVE_TO_DECL(fence.fence_data))
					fence.update_icon()

/obj/structure/fence/update_material_name(override_name)
	override_name ||= fence_data.name
	. = ..()

/obj/structure/fence/update_material_desc(override_desc)
	override_desc ||= fence_data.desc
	. = ..()

/obj/structure/fence/on_update_icon()
	. = ..()
	if(istype(fence_data))
		update_fence_connections()
		update_fence_icon()

/obj/structure/fence/proc/is_fencepost()
	return FALSE // TODO: detect doors and junctions next to us.

/obj/structure/fence/proc/update_fence_connections()
	// Find any adjacent fences.
	connected_dirs = 0
	var/turf/my_turf = get_turf(src)
	for(var/check_dir in global.cardinal)
		var/turf/neighbor = get_step_resolving_mimic(my_turf, check_dir)
		if(!istype(neighbor))
			continue
		for(var/obj/structure/fence/fence in neighbor)
			if(fence_data == RESOLVE_TO_DECL(fence.fence_data))
				connected_dirs |= check_dir
				break

/obj/structure/fence/proc/update_fence_icon()

	// Standalone segment.
	if(!connected_dirs)
		set_icon_state(fence_data.single_state)

	// Four-way junction.
	else if(connected_dirs == (NORTH|SOUTH|EAST|WEST))
		set_icon_state(fence_data.four_way_state)

	// End segments.
	else if(connected_dirs == NORTH || connected_dirs == SOUTH || connected_dirs == EAST || connected_dirs == WEST)
		set_dir(connected_dirs)
		set_icon_state(fence_data.end_state)

	// Straight segments.
	else if(connected_dirs == (NORTH | SOUTH) || connected_dirs == (EAST | WEST))
		if(connected_dirs & NORTH)
			set_dir(NORTH)
		else
			set_dir(EAST)
		if(hole_size > 0)
			set_icon_state("[fence_data.straight_state]-cut[hole_size]")
		else if(is_fencepost())
			set_icon_state(fence_data.post_state)
		else
			set_icon_state(fence_data.straight_state)

	// Corner segments.
	else if(connected_dirs in global.cornerdirs)
		set_icon_state(fence_data.corner_state)
		var/static/list/_corner_fence_to_state_mapping = alist(
			(NORTHWEST) = SOUTH,
			(NORTHEAST) = NORTH,
			(SOUTHWEST) = EAST,
			(SOUTHEAST) = WEST
		)
		set_dir(_corner_fence_to_state_mapping[connected_dirs])

	// Junction segments.
	else
		set_icon_state(fence_data.three_way_state)
		for(var/check_dir in global.cardinal)
			if(!(connected_dirs & check_dir))
				set_dir(check_dir)
				break

/obj/structure/fence/proc/is_cuttable()
	return icon_state == fence_data.straight_state && hole_size < MAX_HOLE_SIZE

/obj/structure/fence/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	switch(hole_size)
		if(MEDIUM_HOLE)
			. += SPAN_DANGER("There is a large hole in \the [src].")
		if(LARGE_HOLE)
			. += SPAN_DANGER("\The [src] has been completely cut through.")

/obj/structure/fence/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	if(is_cuttable())
		LAZYADD(., SPAN_SUBTLE("Use wirecutters to [hole_size > NO_HOLE ? "expand the":"cut a"] hole into the fence, allowing passage."))

/obj/structure/fence/cut/medium
	icon_state = "straight-cut2"
	hole_size = MEDIUM_HOLE

/obj/structure/fence/cut/large
	icon_state = "straight-cut3"
	hole_size = LARGE_HOLE

// Projectiles can pass through fences.
/obj/structure/fence/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(mover?.checkpass(PASS_FLAG_TABLE))
		return TRUE
	if(hole_size >= MEDIUM_HOLE && issmall(mover))
		return TRUE
	return ..()

/obj/structure/fence/can_repair(mob/user)
	if(hole_size > NO_HOLE)
		return TRUE
	return ..()

/obj/structure/fence/handle_repair(mob/user, obj/item/used_item)
	var/obj/item/stack/stack = used_item
	if(hole_size > NO_HOLE && istype(stack))
		to_chat(user, SPAN_NOTICE("You fit [stack.get_string_for_amount(1)] to damaged areas of \the [src]."))
		stack.use(1)
		hole_size = NO_HOLE
		update_cut_status()
		return TRUE
	return ..()

/obj/structure/fence/attackby(obj/item/used_item, mob/user)
	if(IS_WIRECUTTER(used_item))
		if(!is_cuttable())
			to_chat(user, SPAN_WARNING("This section of the fence can't be cut."))
			return TRUE
		var/current_stage = hole_size
		if(current_stage >= MAX_HOLE_SIZE)
			to_chat(user, SPAN_NOTICE("This fence has too much cut out of it already."))
			return TRUE

		if(used_item.do_tool_interaction(TOOL_WIRECUTTERS, user, src, CUT_TIME, "cutting through", "cutting through", check_skill = FALSE) && current_stage == hole_size) // do_tool_interaction sleeps, so make sure it hasn't been cut more while we waited
			switch(++hole_size)
				if(MEDIUM_HOLE)
					user.visible_message(
						SPAN_NOTICE("\The [user] cuts into \the [src] some more."),
						SPAN_NOTICE("Someone could probably fit through that hole now, although climbing through would be much faster if it were even bigger.")
					)
				if(LARGE_HOLE)
					user.visible_message(
						SPAN_NOTICE("\The [user] completely cuts through \the [src]."),
						SPAN_NOTICE("The hole in \the [src] is now big enough to walk through.")
					)
			update_cut_status()
		return TRUE
	return ..()

/obj/structure/fence/proc/update_cut_status()
	if(!is_cuttable())
		return
	density = TRUE
	switch(hole_size)
		if(NO_HOLE)
			icon_state = initial(icon_state)
		if(MEDIUM_HOLE)
			icon_state = "[initial(icon_state)]-cut2"
		if(LARGE_HOLE)
			icon_state = "[initial(icon_state)]-cut3"
			density = FALSE

//FENCE DOORS
/obj/structure/fence/door
	name = "fence gate"
	desc = "Much like a regular door, but thinner."
	icon_state = "door-closed"

/obj/structure/fence/door/can_install_lock()
	return TRUE

/obj/structure/fence/door/update_material_name(override_name)
	override_name ||= fence_data.door_name
	. = ..()

/obj/structure/fence/door/update_material_desc(override_desc)
	override_desc ||= fence_data.door_desc
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/fence/door/update_fence_icon()
	if(!istype(fence_data))
		return
	if((connected_dirs & NORTH) || (connected_dirs & SOUTH))
		set_dir(NORTH)
	else
		set_dir(EAST)
	if(density)
		set_icon_state(fence_data.door_state_closed)
	else
		set_icon_state(fence_data.door_state_opened)

/obj/structure/fence/door/opened
	icon_state = "door-opened"
	density = TRUE

/obj/structure/fence/door/locked/Initialize(mapload)
	lock ||= "fence key #[random_id(type, 10000, 99999)]"
	. = ..()

/obj/structure/fence/door/attack_hand(mob/user, list/params)
	SHOULD_CALL_PARENT(FALSE)
	if(!density || can_open(user))
		density = !density
		visible_message(SPAN_NOTICE("\The [user] [density ? "opens" : "closes"] \the [src]."))
		playsound(src, 'sound/machines/click.ogg', 100, 1)
		update_icon()
	else
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
	return TRUE

/obj/structure/fence/door/proc/can_open(mob/user)
	return !lock || !lock.isLocked()

// Mapping/crafting helpers.
/obj/structure/fence/brick
	icon_state = /decl/fence_type/brick::straight_state
	fence_data = /decl/fence_type/brick

/obj/structure/fence/door/brick
	icon_state = /decl/fence_type/brick::door_state_closed
	fence_data = /decl/fence_type/brick

/obj/structure/fence/palisade
	icon_state = /decl/fence_type/palisade::straight_state
	fence_data = /decl/fence_type/palisade

/obj/structure/fence/door/palisade
	icon_state = /decl/fence_type/palisade::door_state_closed
	fence_data = /decl/fence_type/palisade

/obj/structure/fence/stick
	icon_state = /decl/fence_type/stick::straight_state
	fence_data = /decl/fence_type/stick

/obj/structure/fence/door/stick
	icon_state = /decl/fence_type/stick::door_state_closed
	fence_data = /decl/fence_type/stick

/obj/structure/fence/plank
	icon_state = /decl/fence_type/plank::straight_state
	fence_data = /decl/fence_type/plank

/obj/structure/fence/door/plank
	icon_state = /decl/fence_type/plank::door_state_closed
	fence_data = /decl/fence_type/plank
