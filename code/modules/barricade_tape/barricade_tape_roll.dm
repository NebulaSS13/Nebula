////////////////////////////////////////////////////////////////////
// Barricade Tape Roll
////////////////////////////////////////////////////////////////////
/obj/item/stack/tape_roll/barricade_tape
	name               = "barricade tape roll"
	desc               = "A roll of high visibility, non-sticky barricade tape. Used to deter passersby from crossing it."
	icon               = 'icons/policetape.dmi'
	icon_state         = "tape"
	w_class            = ITEM_SIZE_SMALL
	var/tmp/turf/start                             //The turf we started unrolling from
	var/tmp/weakref/unroller                       //The mob currently unrolling us
	var/decl/barricade_tape_template/tape_template //Template containing details on how the tape roll will look and behave, along with what it will place down

/obj/item/stack/tape_roll/barricade_tape/Initialize()
	. = ..()
	apply_template()

/obj/item/stack/tape_roll/barricade_tape/Destroy()
	stop_unrolling()
	return ..()

/**Update our appearence and data to match the specified tape template. */
/obj/item/stack/tape_roll/barricade_tape/proc/apply_template()
	if(ispath(tape_template))
		tape_template = GET_DECL(tape_template)
	if(!tape_template)
		return

	SetName("[tape_template.tape_kind] tape roll")
	desc = tape_template.roll_desc
	icon = tape_template.icon_file
	set_color(tape_template.tape_color)
	update_icon()

/obj/item/stack/tape_roll/barricade_tape/on_update_icon()
	. = ..()
	if(ismob(loc))
		add_overlay(overlay_image(icon, start? "stop" : "start", flags = RESET_COLOR))

/obj/item/stack/tape_roll/barricade_tape/dropped(mob/user)
	stop_unrolling()
	update_icon()
	return ..()

/obj/item/stack/tape_roll/barricade_tape/on_picked_up(mob/user, atom/old_loc)
	stop_unrolling()
	update_icon()
	return ..()

/obj/item/stack/tape_roll/barricade_tape/attack_hand()
	. = ..()
	if(. && !QDELETED(src))
		update_icon()

/**Callback used when whoever holds us moved to a new turf. */
/obj/item/stack/tape_roll/barricade_tape/proc/user_moved_unrolling(var/mob/M, var/atom/old_loc, var/atom/new_loc)
	if(QDELETED(src))
		return //Destructor will handle the rest
	if(QDELETED(M) || !can_use(1) || M.incapacitated())
		stop_unrolling()
		return

	if((old_loc.x != new_loc.x && old_loc.y != new_loc.y) || old_loc.z != new_loc.z)
		to_chat(M, SPAN_WARNING("\The [src] can only be laid horizontally or vertically."))
		stop_unrolling()
		return
	//Use a length of tape and place a barricade line
	if(!place_line(M, new_loc, get_dir(old_loc, new_loc)))
		stop_unrolling()
		return
	if(get_dist(start, new_loc) >= MAX_BARRICADE_TAPE_LENGTH)
		to_chat(M, SPAN_WARNING("You've stretched this line of tape to the maximum!"))
		stop_unrolling()
		return

/obj/item/stack/tape_roll/barricade_tape/proc/stop_unrolling()
	if(!start && !unroller)
		return
	var/mob/_uroller = unroller.resolve()
	if(_uroller)
		events_repository.unregister(/decl/observ/moved, _uroller, src, PROC_REF(user_moved_unrolling))
	unroller         = null
	start            = null
	slowdown_general = initial(slowdown_general)
	if(_uroller)
		to_chat(_uroller, SPAN_NOTICE("You stop unrolling \the [src]."))
	if(!QDELETED(src))
		update_icon()
	return TRUE

/obj/item/stack/tape_roll/barricade_tape/proc/start_unrolling(var/mob/user)
	if(start && unroller)
		return
	start    = get_turf(src)
	unroller = weakref(user)
	slowdown_general = initial(slowdown_general) + 2 //While unrolling you're slightly slower
	events_repository.unregister(/decl/observ/moved, user, src, PROC_REF(user_moved_unrolling))
	events_repository.register(/decl/observ/moved, user, src, PROC_REF(user_moved_unrolling))
	to_chat(user, SPAN_NOTICE("You start unrolling \the [src]."))
	//Place the first one immediately
	place_line(user, get_turf(user), user.dir)
	update_icon()
	return TRUE

/**Place a tape line on the current turf. */
/obj/item/stack/tape_roll/barricade_tape/proc/place_line(var/mob/user, var/turf/T, var/pdir)
	if(!T || T.is_open() || T.is_wall())
		to_chat(user, SPAN_WARNING("You can't place tape here!"))
		return
	if(locate(/obj/structure/tape_barricade) in T)
		return //Can't place 2 on the same tile!

	if(!can_use(1))
		to_chat(user, SPAN_WARNING("You are out of [tape_template.tape_kind] tape!"))
		return
	use(1)
	playsound(user, 'sound/effects/pageturn2.ogg', 50, TRUE)

	var/obj/structure/tape_barricade/barricade = tape_template.make_line_barricade(user, T, pdir)
	if(barricade)
		barricade.matter = matter_per_piece?.Copy()
		barricade.update_neighbors()
	return barricade

/obj/item/stack/tape_roll/barricade_tape/attack_self(mob/user)
	if(start)
		stop_unrolling()
		return
	if(!can_use(1))
		return //This shouldn't happen, but if it does, don't let them exploit it

	start_unrolling(user)

/obj/item/stack/tape_roll/barricade_tape/afterattack(var/atom/A, mob/user, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/door/airlock))
		if(!can_use(4))
			to_chat(user, SPAN_WARNING("There isn't enough [plural_name] in \the [src] to barricade \the [A]. You need at least 4 [plural_name]."))
			return

		var/obj/structure/tape_barricade/door/bar = tape_template.make_door_barricade(user, A)
		if(bar)
			bar.matter = matter_per_piece?.Copy()
			if(bar.matter)
				for(var/mat in bar.matter)
					bar.matter[mat] = round(bar.matter[mat] * 4)

		to_chat(user, SPAN_NOTICE("You finish placing \the [src]."))
		use(4)