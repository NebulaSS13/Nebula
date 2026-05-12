// Various fences
// Chain link sprites ported from /VG/
// Stone, stick, plank and palisade sprites by Doe.

#define CUT_TIME 10 SECONDS
#define CLIMB_TIME 5 SECONDS

///section is intact
#define NO_HOLE 0
///medium hole in the section - can climb through
#define MEDIUM_HOLE 1
///large hole in the section - can walk through
#define LARGE_HOLE 2
#define MAX_HOLE_SIZE LARGE_HOLE

/obj/structure/fence
	name = "fence"
	desc = "A fence. Not as effective as a wall, but generally it keeps people out."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/fence.dmi'
	icon_state = "straight"
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_ALL
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT

	var/decl/fence_type/fence_data = /decl/fence_type
	var/hole_size = NO_HOLE

/obj/structure/fence/Initialize(mapload)
	update_cut_status()
	if(ispath(fence_data))
		fence_data = GET_DECL(fence_data)
		SetName(fence_data.name)
		desc = (fence_data.desc)
	else if(!istype(fence_data))
		fence_data = null
	queue_icon_update()
	return ..()

/obj/structure/fence/update_icon()
	. = ..()
	if(!istype(fence_data))
		return
	update_fence_icon()

/obj/structure/fence/proc/update_fence_icon()

	// Find any adjacent fences.
	var/static/list/direct_adjacent = list(NORTH, SOUTH, EAST, WEST)
	var/connected_dirs = 0
	for(var/check_dir in direct_adjacent)
		var/turf/neighbor = get_step_resolving_mimic(get_turf(src), check_dir)
		if(!istype(neighbor) || !(locate(/obj/structure/fence) in neighbor))
			continue
		connected_dirs |= check_dir

	// End segments.
	if(check_dir == NORTH || check_dir == SOUTH || check_dir == EAST || check_dir == WEST)
		set_dir(global.reverse_dir[check_dir])
		set_icon_state(fence_data.end_state)
	// Straight segments.
	else if(check_dir == (NORTH | SOUTH) || check_dir == (EAST | WEST))
		if(check_dir & NORTH)
			set_dir(NORTH)
		else
			set_dir(EAST)
		switch(hole_size)
			if(MEDIUM_HOLE)
				set_icon_state("[fence_data.straight_state]-cut2")
			if(LARGE_HOLE)
				set_icon_state("[fence_data.straight_state]-cut3")
			else
				set_icon_state(fence_data.straight_state)

	// Corner segments.
	else if(check_dir in global.cornerdirs)
		set_icon_state(fence_data.corner_state)
		var/static/list/_corner_fence_to_state_mapping = alist(
			(NORTHWEST) = SOUTH,
			(NORTHEAST) = NORTH,
			(SOUTHWEST) = EAST,
			(SOUTHEAST) = WEST
		)
		set_dir(_corner_fence_to_state_mapping[check_dir])

	// Junction segments - not currently supported.


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
	if(cuttable && hole_size < MAX_HOLE_SIZE)
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
		if(!cuttable)
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
	if(!cuttable)
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
	name = "fence door"
	desc = "Not very useful without a real lock."
	icon_state = "door-closed"
	cuttable = FALSE
	var/open = FALSE
	var/locked = FALSE

/obj/structure/fence/door/Initialize(mapload)
	. = ..()
	update_door_status()

/obj/structure/fence/door/update_fence_icon()
	if(!istype(fence_data))
		return
	if(density)
		set_icon_state(fence_data.door_closed_state)
	else
		set_icon_state(fence_data.door_opened_state)

/obj/structure/fence/door/opened
	icon_state = "door-opened"
	open = TRUE
	density = TRUE

/obj/structure/fence/door/locked
	desc = "It looks like it has a strong padlock attached."
	locked = TRUE

/obj/structure/fence/door/attack_hand(mob/user, list/params)
	SHOULD_CALL_PARENT(FALSE)
	if(can_open(user))
		toggle(user)
	else
		to_chat(user, SPAN_WARNING("\The [src] is [!open ? "locked" : "stuck open"]."))
	return TRUE

/obj/structure/fence/door/proc/toggle(mob/user)
	switch(open)
		if(FALSE)
			visible_message(SPAN_NOTICE("\The [user] opens \the [src]."))
			open = TRUE
		if(TRUE)
			visible_message(SPAN_NOTICE("\The [user] closes \the [src]."))
			open = FALSE

	update_door_status()
	playsound(src, 'sound/machines/click.ogg', 100, 1)

/obj/structure/fence/door/proc/update_door_status()
	density = !open
	update_icon()

/obj/structure/fence/door/proc/can_open(mob/user)
	if(locked)
		return FALSE
	return TRUE

#undef CUT_TIME
#undef CLIMB_TIME

#undef NO_HOLE
#undef MEDIUM_HOLE
#undef LARGE_HOLE
#undef MAX_HOLE_SIZE

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
