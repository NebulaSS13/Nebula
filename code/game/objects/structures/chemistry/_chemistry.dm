/obj/structure/fire_source/heater
	name                = "heater"
	desc                = "An small, squat burner, generally used for heating reagents."
	icon                = 'icons/obj/structures/alembic.dmi'
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/stone/pottery
	material_alteration = MAT_FLAG_ALTERATION_ALL

	var/obj/item/retort
	var/obj/item/vessel

/obj/structure/fire_source/heater/mapped/Initialize()
	set_retort(new /obj/item/chems/glass/retort(src))
	return ..()

/obj/structure/fire_source/heater/Destroy()
	QDEL_NULL(retort)
	QDEL_NULL(vessel)
	return ..()

/obj/structure/fire_source/heater/physically_destroyed(skip_qdel)
	if(retort)
		set_retort(null)
	if(vessel)
		set_vessel(null)
	return ..()

// Vessel is to the side, not on the flame.
/obj/structure/fire_source/heater/get_contained_temperature_sensitive_atoms()
	. = ..()
	if(LAZYLEN(.) && vessel)
		LAZYREMOVE(., vessel)

/obj/structure/fire_source/heater/proc/set_vessel(new_vessel, skip_loc_change)
	if(new_vessel == vessel)
		return
	if(vessel)
		vessel.vis_flags = initial(vessel.vis_flags)
		vis_contents -= vessel
		if(!skip_loc_change)
			vessel.dropInto(loc)
		vessel = null
	vessel = new_vessel
	if(vessel)
		vessel.reset_offsets(anim_time = 0)
		vessel.pixel_w = 7
		vessel.pixel_z = 2
		vessel.vis_flags |= (VIS_INHERIT_LAYER | VIS_INHERIT_PLANE)
		vis_contents |= vessel

/obj/structure/fire_source/heater/proc/set_retort(new_retort, skip_loc_change)
	if(new_retort == retort)
		return
	if(retort)
		retort.vis_flags = initial(retort.vis_flags)
		vis_contents -= retort
		if(!skip_loc_change)
			retort.dropInto(loc)
		retort = null
	retort = new_retort
	if(retort)
		retort.reset_offsets(anim_time = 0)
		retort.pixel_z = 6
		retort.vis_flags |= (VIS_INHERIT_LAYER | VIS_INHERIT_PLANE)
		vis_contents |= retort

/obj/structure/fire_source/heater/Exited(atom/movable/am, atom/new_loc)
	. = ..()
	if(am == vessel)
		set_vessel(null, skip_loc_change = TRUE)
	else if(am == retort)
		set_retort(null, skip_loc_change = TRUE)
	else
		return
	if(ismob(new_loc))
		visible_message(SPAN_NOTICE("\The [new_loc] removes \the [am] from \the [src]."))

/obj/structure/fire_source/heater/attackby(obj/item/thing, mob/user)

	if(istype(thing, /obj/item/chems/glass) && ATOM_IS_OPEN_CONTAINER(thing))
		if(retort && vessel)
			to_chat(user, SPAN_WARNING("\The [src] is already holding \a [retort] and \a [vessel]."))
			return TRUE
		if(user.try_unequip(thing, src))
			if(!retort)
				set_retort(thing)
				visible_message(SPAN_NOTICE("\The [user] places \the [retort] onto \the [src]."))
			else if(!vessel)
				set_vessel(thing)
				visible_message(SPAN_NOTICE("\The [user] places \the [vessel] under \the [src]."))
		return TRUE

	. = ..()

/obj/structure/fire_source/heater/take_vaporized_reagent(reagent, amount)
	if(!vessel || !vessel.reagents || REAGENTS_FREE_SPACE(vessel.reagents) <= 0)
		return ..()
	return vessel.take_vaporized_reagent(reagent, amount)
