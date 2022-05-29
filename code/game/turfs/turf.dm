/turf
	icon = 'icons/turf/floors.dmi'
	level = 1

	layer = TURF_LAYER

	var/turf_flags

	var/holy = 0

	// Initial air contents (in moles)
	var/list/initial_gas

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old = null
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

	// Used for slowdown.
	var/movement_delay

	var/fluid_can_pass
	var/fluid_blocked_dirs = 0
	var/flooded // Whether or not this turf is absolutely flooded ie. a water source.
	var/footstep_type
	var/open_turf_type // Which turf to use when this turf is destroyed or replaced in a multiz context. Overridden by area.

	var/tmp/changing_turf
	var/tmp/prev_type // Previous type of the turf, prior to turf translation.
	var/tmp/obj/abstract/weather_system/weather
	var/tmp/is_outside = OUTSIDE_AREA

/turf/Initialize(mapload, ...)
	. = null && ..()	// This weird construct is to shut up the 'parent proc not called' warning without disabling the lint for child types. We explicitly return an init hint so this won't change behavior.

	// atom/Initialize has been copied here for performance (or at least the bits of it that turfs use has been)
	if(atom_flags & ATOM_FLAG_INITIALIZED)
		PRINT_STACK_TRACE("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_FLAG_INITIALIZED

	if(light_power && light_range)
		update_light()

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if (mapload && permit_ao)
		queue_ao()

	if (opacity)
		has_opaque_atom = TRUE

	if (!mapload)
		SSair.mark_for_update(src)

	updateVisibility(src, FALSE)

	if (z_flags & ZM_MIMIC_BELOW)
		setup_zmimic(mapload)

	if(flooded && !density)
		make_flooded(TRUE)

	initialize_ambient_light(mapload)

	return INITIALIZE_HINT_NORMAL

/turf/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(user && weather)
		weather.examine(user)

/turf/proc/initialize_ambient_light(var/mapload)
	return

/turf/proc/update_ambient_light(var/mapload)
	return

/turf/Destroy()

	if (!changing_turf)
		PRINT_STACK_TRACE("Improper turf qdel. Do not qdel turfs directly.")

	changing_turf = FALSE

	remove_cleanables()
	REMOVE_ACTIVE_FLUID_SOURCE(src)

	if (ao_queued)
		SSao.queue -= src
		ao_queued = 0

	if (z_flags & ZM_MIMIC_BELOW)
		cleanup_zmimic()

	if (mimic_proxy)
		QDEL_NULL(mimic_proxy)

	if(connections)
		connections.erase_all()

	if(weather)
		remove_vis_contents(src, weather.vis_contents_additions)
		weather = null

	..()
	return QDEL_HINT_IWILLGC

/turf/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/turf/proc/is_solid_structure()
	return 1

/turf/proc/get_base_movement_delay()
	return movement_delay

/turf/proc/get_movement_delay(var/travel_dir)
	. = get_base_movement_delay()
	if(weather)
		. += weather.get_movement_delay(return_air(), travel_dir)

/turf/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	if(user.restrained())
		return 0

	. = handle_hand_interception(user)

/turf/proc/handle_hand_interception(var/mob/user)
	var/datum/extension/turf_hand/THE
	for (var/A in src)
		var/datum/extension/turf_hand/TH = get_extension(A, /datum/extension/turf_hand)
		if (istype(TH) && TH.priority > THE?.priority) //Only overwrite if the new one is higher. For matching values, its first come first served
			THE = TH

	if (THE)
		return THE.OnHandInterception(user)

/turf/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

/turf/attackby(obj/item/W, mob/user)

	if(ATOM_IS_OPEN_CONTAINER(W) && W.reagents)
		var/obj/effect/fluid/F = locate() in src
		if(F && F.reagents?.total_volume >= FLUID_PUDDLE)
			var/taking = min(F.reagents?.total_volume, REAGENTS_FREE_SPACE(W.reagents))
			if(taking > 0)
				to_chat(user, SPAN_NOTICE("You fill \the [W] with [F.reagents.get_primary_reagent_name()] from \the [src]."))
				F.reagents.trans_to(W, taking)
				return TRUE

	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup && S.collection_mode)
			S.gather_all(src, user)
		return TRUE

	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if (G.affecting == G.assailant)
			return TRUE

		step(G.affecting, get_dir(G.affecting.loc, src))
		return TRUE

	return ..()

/turf/Enter(atom/movable/mover, atom/forget)

	..()

	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!

var/global/const/enterloopsanity = 100
/turf/Entered(var/atom/atom, var/atom/old_loc)

	..()

	QUEUE_TEMPERATURE_ATOMS(atom)

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/A = atom

	var/objects = 0
	if(A && (A.movable_flags & MOVABLE_FLAG_PROXMOVE))
		for(var/atom/movable/thing in range(1))
			if(objects > enterloopsanity) break
			objects++
			spawn(0)
				if(A)
					A.HasProximity(thing, 1)
					if ((thing && A) && (thing.movable_flags & MOVABLE_FLAG_PROXMOVE))
						thing.HasProximity(A, 1)
	return

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, exposed_temperature, exposed_volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/protects_atom(var/atom/A)
	return FALSE

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/turf/t in (RANGE_TURFS(src, 1) - src))
		if(check_blockage)
			if(!t.density)
				if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
					. += t
		else
			. += t

/turf/proc/CardinalTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/ad in AdjacentTurfs(check_blockage))
		var/turf/T = ad
		if(T.x == src.x || T.y == src.y)
			. += T

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			return 1
	return 0

/turf/proc/remove_cleanables()
	for(var/obj/effect/O in src)
		if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable))
			qdel(O)

/turf/proc/update_blood_overlays()
	return

/turf/proc/remove_decals()
	LAZYCLEARLIST(decals)

// Called when turf is hit by a thrown object
/turf/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	..()
	if(density)
		if(isliving(AM))
			var/mob/living/M = AM
			M.turf_collision(src, TT.speed)
			if(LAZYLEN(M.pinned))
				return
		addtimer(CALLBACK(src, /turf/proc/bounce_off, AM, TT.init_dir), 2)
	else if(isobj(AM))
		var/obj/structure/ladder/L = locate() in contents
		if(L)
			L.hitby(AM)

/turf/proc/bounce_off(var/atom/movable/AM, var/direction)
	step(AM, turn(direction, 180))

/turf/proc/can_engrave()
	return FALSE

/turf/proc/try_graffiti(var/mob/vandal, var/obj/item/tool)

	if(!tool.sharp || !can_engrave() || vandal.a_intent != I_HELP)
		return FALSE

	if(jobban_isbanned(vandal, "Graffiti"))
		to_chat(vandal, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
		return

	var/too_much_graffiti = 0
	for(var/obj/effect/decal/writing/W in src)
		too_much_graffiti++
	if(too_much_graffiti >= 5)
		to_chat(vandal, "<span class='warning'>There's too much graffiti here to add more.</span>")
		return FALSE

	var/message = sanitize(input("Enter a message to engrave.", "Graffiti") as null|text, trim = TRUE)
	if(!message)
		return FALSE
	if(!vandal || vandal.incapacitated() || !Adjacent(vandal) || !tool.loc == vandal)
		return FALSE
	message = vandal.handle_writing_literacy(vandal, message, TRUE)
	if(!message)
		return
	vandal.visible_message("<span class='warning'>\The [vandal] begins carving something into \the [src].</span>")

	if(!do_after(vandal, max(20, length(message)), src))
		return FALSE

	vandal.visible_message("<span class='danger'>\The [vandal] carves some graffiti into \the [src].</span>")
	var/obj/effect/decal/writing/graffiti = new(src)
	graffiti.message = message
	graffiti.author = vandal.ckey
	vandal.update_personal_goal(/datum/goal/achievement/graffiti, TRUE)

	if(lowertext(message) == "elbereth")
		to_chat(vandal, "<span class='notice'>You feel much safer.</span>")

	return TRUE

/turf/proc/is_wall()
	return FALSE

/turf/proc/is_open()
	return FALSE

/turf/proc/is_floor()
	return FALSE

/turf/proc/get_footstep_sound(var/mob/caller)
	return

/turf/proc/update_weather(var/obj/abstract/weather_system/new_weather)

	if(isnull(new_weather))
		new_weather = global.weather_by_z["[z]"]

	// We have a weather system and we are exposed to it; update our vis contents.
	var/old_weather = weather
	if(istype(new_weather) && is_outside())
		if(weather != new_weather)
			if(weather)
				remove_vis_contents(src, weather.vis_contents_additions)
			weather = new_weather
			add_vis_contents(src, weather.vis_contents_additions)

	// We are indoors or there is no local weather system, clear our vis contents.
	else if(weather)
		remove_vis_contents(src, weather.vis_contents_additions)
		weather = null

	// Propagate our weather downwards if we permit it.
	if(is_open() && old_weather != weather)
		var/turf/below = GetBelow(src)
		if(below)
			below.update_weather(new_weather)

/turf/proc/is_outside()

	if(density)
		return OUTSIDE_NO

	var/turf/above = GetAbove(src)
	if(above && above.is_open())
		return above.is_outside()

	if(is_outside != OUTSIDE_AREA)
		return is_outside
	var/area/A = get_area(src)
	if(A)
		return A.is_outside
	return OUTSIDE_NO

/turf/proc/set_outside(var/new_outside)
	if(is_outside != new_outside)
		is_outside = new_outside
		update_weather()
		return TRUE
	return FALSE

/turf/get_vis_contents_to_add()
	var/datum/gas_mixture/air = return_air()
	if(air && length(air.graphic))
		LAZYADD(., air.graphic)
	if(weather)
		LAZYADD(., weather)
	if(flooded)
		LAZYADD(., global.flood_object)

/**Whether we can place a cable here
 * If you cannot build a cable will return an error code explaining why you cannot.
*/
/turf/proc/cannot_build_cable()
	return 1

/**Sends a message to the user explaining why they can't build a cable here */
/turf/proc/why_cannot_build_cable(var/mob/user, var/cable_error)
	to_chat(user, SPAN_WARNING("You cannot place a cable here!"))

/**Place a cable if possible, if not warn the user appropriately */
/turf/proc/try_build_cable(var/obj/item/stack/cable_coil/C, var/mob/user)
	var/cable_error = cannot_build_cable(user)
	if(cable_error)
		why_cannot_build_cable(user, cable_error)
		return FALSE
	return C.turf_place(src, user)
