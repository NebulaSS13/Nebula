/obj/structure/cask_rack
	name                = "cask rack"
	desc                = "A flat rack used to stop a cask from rolling around."
	icon                = 'icons/obj/structures/barrels/cask_rack.dmi'
	icon_state          = ICON_STATE_WORLD
	anchored            = TRUE
	opacity             = FALSE
	density             = FALSE // Recalculated when barrels added or removed
	w_class             = ITEM_SIZE_STRUCTURE
	material            = /decl/material/solid/organic/wood/oak
	color               = /decl/material/solid/organic/wood/oak::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	var/max_stack = 1

/obj/structure/cask_rack/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	if(isturf(loc))
		for(var/atom/movable/stackable in loc)
			if(try_stack_barrel(stackable) && length(contents) >= max_stack)
				return

/obj/structure/cask_rack/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(length(contents))
		. += SPAN_NOTICE("It contains [english_list(contents)].")

/obj/structure/cask_rack/handle_mouse_drop(atom/over, mob/user, params)
	if(isturf(over) && user.Adjacent(over) && Adjacent(over) && try_unstack_barrel(target = over, user = user))
		return
	return ..()

/obj/structure/cask_rack/receive_mouse_drop(atom/dropping, mob/user, params)
	. = ..()
	if(!. && user.Adjacent(src) && dropping.Adjacent(src) && user.Adjacent(dropping))
		return try_stack_barrel_timed(dropping, user)

/obj/structure/cask_rack/on_update_icon()
	. = ..()
	if(length(contents))
		// Workaround for base color getting applied to vis_contents.
		var/base_color = get_color()
		color = null
		var/image/I = image(icon, icon_state)
		I.color = base_color
		add_overlay(I)
		// Reposition/update our contents.
		var/i = 0
		var/list/stackable_types = get_stackable_barrel_types()
		for(var/atom/movable/barrel in contents)
			if(is_type_in_list(barrel, stackable_types))
				i++
				adjust_barrel_offsets(barrel, i)
	else
		color = get_color()
	compile_overlays() // Avoid wonky flickering on contents changes

/obj/structure/cask_rack/proc/adjust_barrel_offsets(atom/movable/barrel, barrel_position)
	barrel.reset_offsets(anim_time = 0)
	barrel.vis_flags |= (VIS_INHERIT_LAYER | VIS_INHERIT_PLANE)

/obj/structure/cask_rack/Entered(atom/movable/AM, atom/old_loc)
	. = ..()
	if(istype(AM) && !QDELETED(AM) && is_type_in_list(AM, get_stackable_barrel_types()))
		vis_contents |= AM
		recalculate_barrel_values()

/obj/structure/cask_rack/Exited(atom/movable/AM, atom/new_loc)
	. = ..()
	if(istype(AM) && is_type_in_list(AM, get_stackable_barrel_types()))
		vis_contents -= AM
		AM.vis_flags = initial(AM.vis_flags)
		AM.reset_offsets(anim_time = 0)
		recalculate_barrel_values()

/obj/structure/cask_rack/proc/recalculate_barrel_values()
	if(length(contents))
		density     =  TRUE
		anchored    =  TRUE
		obj_flags  &= ~OBJ_FLAG_ANCHORABLE
		atom_flags |=  ATOM_FLAG_CLIMBABLE
	else
		density     =  FALSE
		obj_flags  |=  OBJ_FLAG_ANCHORABLE
		atom_flags &= ~ATOM_FLAG_CLIMBABLE
	update_icon()

/obj/structure/cask_rack/proc/try_unstack_barrel(atom/movable/barrel, turf/target, mob/user)
	if(!loc)
		return FALSE
	if(!barrel)
		if(!length(contents))
			to_chat(user, SPAN_WARNING("\The [src] has nothing stacked on it."))
			return FALSE
		barrel = contents[length(contents)]
	if(!istype(barrel) || !barrel.simulated)
		return FALSE
	if(target && (!isturf(target) || !loc.Adjacent(target))) // TODO: Enter() or CanPass() checks instead of relying on step_towards() below.
		to_chat(user, SPAN_NOTICE("You cannot move \the [barrel] to \the [target]."))
		return FALSE
	if(user && !user.do_skilled(3 SECONDS, SKILL_HAULING, src))
		to_chat(user, SPAN_NOTICE("You stop moving \the [barrel] off of \the [src]."))
		return FALSE
	to_chat(user, SPAN_NOTICE("You move \the [barrel] off \the [src]."))
	barrel.dropInto(loc)
	if(target)
		step_towards(barrel, target)
	return TRUE

/obj/structure/cask_rack/proc/can_stack_barrel(atom/movable/barrel, mob/user)
	if(!istype(barrel) || !barrel.simulated || barrel.anchored)
		return FALSE
	if(length(contents) >= max_stack)
		to_chat(user, SPAN_WARNING("\The [src] is already stacked to capacity."))
		return FALSE
	var/list/stackable_types = get_stackable_barrel_types()
	if(!is_type_in_list(barrel, stackable_types))
		to_chat(user, SPAN_WARNING("\The [src] cannot hold \the [barrel]."))
		return FALSE
	return TRUE

/obj/structure/cask_rack/proc/try_stack_barrel(atom/movable/barrel, mob/user)
	if(!can_stack_barrel(barrel, user))
		return FALSE
	barrel.forceMove(src)
	return TRUE

/obj/structure/cask_rack/proc/try_stack_barrel_timed(atom/movable/barrel, mob/user)
	if(!can_stack_barrel(barrel, user))
		return FALSE
	if(user && !user.do_skilled(3 SECONDS, SKILL_HAULING, src))
		to_chat(user, SPAN_NOTICE("You stop stacking \the [barrel] onto \the [src]."))
		return FALSE
	if(try_stack_barrel(barrel, user))
		to_chat(user, SPAN_NOTICE("You stack \the [barrel] onto \the [src]."))
		return TRUE
	return FALSE

/obj/structure/cask_rack/proc/get_stackable_barrel_types()
	var/static/list/_stackable_barrel_types = list(
		/obj/structure/reagent_dispensers/barrel/cask
	)
	return _stackable_barrel_types

// A larger stack, used to arrange up to three casks.
/obj/structure/cask_rack/large
	name_prefix = "large"
	desc      = "A flat rack used to stop casks from rolling around."
	max_stack = 3
	w_class   = ITEM_SIZE_LARGE_STRUCTURE
	icon      = 'icons/obj/structures/barrels/cask_rack_large.dmi'

/obj/structure/cask_rack/large/adjust_barrel_offsets(atom/movable/barrel, barrel_position)
	..()
	switch(barrel_position)
		if(1)
			barrel.pixel_x -= 7
		if(2)
			barrel.pixel_x += 7
		if(3)
			barrel.pixel_y += 8

/obj/structure/cask_rack/large/mapped
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/cask_rack/large/mapped/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	try_stack_barrel(new /obj/structure/reagent_dispensers/barrel/cask/ebony/water)
	try_stack_barrel(new /obj/structure/reagent_dispensers/barrel/cask/ebony/beer)
	try_stack_barrel(new /obj/structure/reagent_dispensers/barrel/cask/ebony/wine)
