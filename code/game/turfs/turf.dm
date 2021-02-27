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

	var/movement_delay

	var/fluid_can_pass
	var/obj/effect/flood/flood_object
	var/fluid_blocked_dirs = 0
	var/flooded // Whether or not this turf is absolutely flooded ie. a water source.
	var/footstep_type

	var/tmp/changing_turf

	var/prev_type // Previous type of the turf, prior to turf translation.

/turf/Initialize(mapload, ...)
	. = ..()
	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1
	RecalculateOpacity()

	if(mapload)
		queue_ao(TRUE)
		queue_icon_update()
		update_starlight()
	else
		regenerate_ao()
		for(var/thing in RANGE_TURFS(src, 1))
			var/turf/T = thing
			if(istype(T))
				T.update_starlight()
				T.queue_icon_update()
		SSair.mark_for_update(src)
	updateVisibility(src, FALSE)

	if (z_flags & ZM_MIMIC_BELOW)
		setup_zmimic(mapload)
	if(flooded && !density)
		fluid_update(FALSE)

/turf/on_update_icon()
	update_flood_overlay()
	queue_ao(FALSE)

/turf/proc/update_flood_overlay()
	if(is_flooded(absolute = TRUE))
		if(!flood_object)
			flood_object = new(src)
	else if(flood_object)
		QDEL_NULL(flood_object)

/turf/Destroy()

	if (!changing_turf)
		PRINT_STACK_TRACE("Improper turf qdel. Do not qdel turfs directly.")

	changing_turf = FALSE

	remove_cleanables()
	fluid_update()
	REMOVE_ACTIVE_FLUID_SOURCE(src)

	if (ao_queued)
		SSao.queue -= src
		ao_queued = 0

	if (z_flags & ZM_MIMIC_BELOW)
		cleanup_zmimic()

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	if(connections) 
		connections.erase_all()

	..()
	return QDEL_HINT_IWILLGC

/turf/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	return

/turf/proc/is_solid_structure()
	return 1

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

var/const/enterloopsanity = 100
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
	if(decals && decals.len)
		decals.Cut()
		decals = null

// Called when turf is hit by a thrown object
/turf/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	..()
	if(density)
		if(isliving(AM))
			var/mob/living/M = AM
			M.turf_collision(src, TT.speed)
			if(M.pinned)
				return
		addtimer(CALLBACK(src, /turf/proc/bounce_off, AM, TT.init_dir), 2)

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

/turf/proc/update_starlight()
	if(!config.starlight)
		return
	var/area/A = get_area(src)
	if(!A.show_starlight)
		return
	//Let's make sure not to break everything if people use a crazy setting.
	for(var/thing in RANGE_TURFS(src,1))
		if(istype(thing, /turf/simulated))
			var/turf/simulated/T = thing
			A = get_area(T)
			if(A?.dynamic_lighting)
				set_light(min(0.1*config.starlight, 1), 1, 3, l_color = SSskybox.background_color)
				return
	set_light(0)

/turf/proc/get_footstep_sound(var/mob/caller)
	return
