//Chain link fences
//Sprites ported from /VG/

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
	desc = "A chain link fence. Not as effective as a wall, but generally it keeps people out."
	density = TRUE
	anchored = TRUE

	icon = 'icons/obj/structures/fence.dmi'
	icon_state = "straight"

	material = /decl/material/solid/metal/steel
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT

	var/cuttable = TRUE
	var/hole_size = NO_HOLE

/obj/structure/fence/Initialize(mapload)
	update_cut_status()
	return ..()

/obj/structure/fence/examine(mob/user, dist)
	. = ..()

	switch(hole_size)
		if(MEDIUM_HOLE)
			to_chat(user, "There is a large hole in \the [src].")
		if(LARGE_HOLE)
			to_chat(user, "\The [src] has been completely cut through.")

	if(cuttable && hole_size < MAX_HOLE_SIZE)
		to_chat(user, "Use wirecutters to [hole_size > NO_HOLE ? "expand the":"cut a"] hole into the fence, allowing passage.")

/obj/structure/fence/end
	icon_state = "end"
	cuttable = FALSE

/obj/structure/fence/corner
	icon_state = "corner"
	cuttable = FALSE

/obj/structure/fence/post
	icon_state = "post"
	cuttable = FALSE

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
	if(hole_size == MEDIUM_HOLE && issmall(mover))
		return TRUE
	return ..()

/obj/structure/fence/can_repair(mob/user)
	if(hole_size > NO_HOLE)
		return TRUE
	return ..()

/obj/structure/fence/handle_repair(mob/user, obj/item/tool)
	var/obj/item/stack/stack = tool
	if(hole_size > NO_HOLE && istype(stack))
		to_chat(user, SPAN_NOTICE("You fit [stack.get_string_for_amount(1)] to damaged areas of \the [src]."))
		stack.use(1)
		hole_size = NO_HOLE
		update_cut_status()
		return TRUE
	return ..()


/obj/structure/fence/attackby(obj/item/tool, mob/user)
	if(IS_WIRECUTTER(tool))
		if(!cuttable)
			to_chat(user, SPAN_WARNING("This section of the fence can't be cut."))
			return
		var/current_stage = hole_size
		if(current_stage >= MAX_HOLE_SIZE)
			to_chat(user, SPAN_NOTICE("This fence has too much cut out of it already."))
			return

		if(tool.do_tool_interaction(TOOL_WIRECUTTERS, user, src, CUT_TIME, "cutting through", "cutting through", check_skill = FALSE) && current_stage == hole_size) // do_tool_interaction sleeps, so make sure it hasn't been cut more while we waited
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
	update_door_status()
	return ..()

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
	switch(open)
		if(FALSE)
			density = TRUE
			icon_state = "door-closed"
		if(TRUE)
			density = FALSE
			icon_state = "door-opened"

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