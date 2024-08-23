/turf
	icon = 'icons/turf/floors.dmi'
	level = LEVEL_BELOW_PLATING
	abstract_type = /turf
	is_spawnable_type = TRUE
	layer = TURF_LAYER
	temperature_sensitive = TRUE

	/// Will participate in ZAS, join zones, etc.
	var/zone_membership_candidate = FALSE
	/// Will participate in external atmosphere simulation if the turf is outside and no zone is set.
	var/external_atmosphere_participation = TRUE

	var/turf_flags

	// Initial air contents (in moles)
	var/list/initial_gas

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/pathweight = 1          // How much does it cost to pathfind over this turf?

	var/list/decals

	// Used for slowdown.
	var/movement_delay

	var/fluid_can_pass
	var/fluid_blocked_dirs = 0
	var/flooded // Whether or not this turf is absolutely flooded ie. a water source.
	var/footstep_type
	var/open_turf_type // Which open turf type to use by default above this turf in a multiz context. Overridden by area.

	var/tmp/changing_turf
	var/tmp/prev_type // Previous type of the turf, prior to turf translation.

	// Some quick notes on the vars below: is_outside should be left set to OUTSIDE_AREA unless you
	// EXPLICITLY NEED a turf to have a different outside state to its area (ie. you have used a
	// roofing tile). By default, it will ask the area for the state to use, and will update on
	// area change. When dealing with weather, it will check the entire z-column for interruptions
	// that will prevent it from using its own state, so a floor above a level will generally
	// override both area is_outside, and turf is_outside. The only time the base value will be used
	// by itself is if you are dealing with a non-multiz level, or the top level of a multiz chunk.

	// Weather relies on is_outside to determine if it should apply to a turf or not and will be
	// automatically updated on ChangeTurf set_outside etc. Don't bother setting it manually, it will
	// get overridden almost immediately.

	// TL;DR: just leave these vars alone.
	var/tmp/obj/abstract/weather_system/weather
	var/tmp/is_outside = OUTSIDE_AREA
	var/tmp/last_outside_check = OUTSIDE_UNCERTAIN

	///The cached air mixture of a turf. Never directly access, use `return_air()`.
	//This exists to store air during zone rebuilds, as well as for unsimulated turfs.
	//They are never deleted to not overwhelm the garbage collector.
	var/datum/gas_mixture/air
	///Whether this tile is willing to copy air from a previous tile through ChangeTurf, transfer_turf_properties etc.
	var/can_inherit_air = TRUE
	///Is this turf queued in the TURFS cycle of SSair?
	var/needs_air_update = 0

	///The turf's current zone.
	var/zone/zone
	///All directions in which a turf that can contain air is present.
	var/airflow_open_directions

	/// Used by exterior turfs to determine the warming effect of campfires and such.
	var/list/affecting_heat_sources

	// Fluid flow tracking vars
	var/last_slipperiness = 0
	var/last_flow_strength = 0
	var/last_flow_dir = 0
	var/atom/movable/fluid_overlay/fluid_overlay

	// Temporary list of weakrefs of atoms who should be excepted from falling into us
	var/list/skip_height_fall_for

/turf/Initialize(mapload, ...)
	. = null && ..()	// This weird construct is to shut up the 'parent proc not called' warning without disabling the lint for child types. We explicitly return an init hint so this won't change behavior.

	// atom/Initialize has been copied here for performance (or at least the bits of it that turfs use has been)
	if(atom_flags & ATOM_FLAG_INITIALIZED)
		PRINT_STACK_TRACE("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_FLAG_INITIALIZED

	if (light_range && light_power)
		update_light()

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	AMBIENCE_QUEUE_TURF(src)

	if (opacity)
		has_opaque_atom = TRUE

	if (!mapload)
		SSair.mark_for_update(src)
		update_weather(force_update_below = TRUE)
	else if (permit_ao)
		queue_ao()

	if(simulated)
		updateVisibility(src, FALSE)

	if (z_flags & ZM_MIMIC_BELOW)
		setup_zmimic(mapload)

	if(flooded)
		set_flooded(flooded, TRUE, skip_vis_contents_update = TRUE, mapload = mapload)
	update_vis_contents()

	if(simulated)
		var/area/A = get_area(src)
		if(istype(A) && (A.area_flags & AREA_FLAG_HOLY))
			turf_flags |= TURF_FLAG_HOLY
		levelupdate()

	return INITIALIZE_HINT_NORMAL

/turf/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(user && weather)
		weather.examine(user)

/turf/Destroy()

	if(zone)
		if(can_safely_remove_from_zone())
			c_copy_air()
			zone.remove(src)
		else
			zone.rebuild()

	if(LAZYLEN(affecting_heat_sources))
		for(var/thing in affecting_heat_sources)
			var/obj/structure/fire_source/heat_source = thing
			LAZYREMOVE(heat_source.affected_exterior_turfs, src)
		affecting_heat_sources = null

	if (!changing_turf)
		PRINT_STACK_TRACE("Improper turf qdel. Do not qdel turfs directly.")

	AMBIENCE_DEQUEUE_TURF(src)

	changing_turf = FALSE

	if (contents.len > !!lighting_overlay)
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
		remove_vis_contents(weather.vis_contents_additions)
		weather = null

	QDEL_NULL(fluid_overlay)

	..()

	return QDEL_HINT_IWILLGC

/turf/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1 || (severity == 2 && prob(70)))
		drop_diggable_resources()

/turf/proc/is_solid_structure()
	return !(turf_flags & TURF_FLAG_BACKGROUND) || locate(/obj/structure/lattice, src)

/turf/proc/get_base_movement_delay(var/travel_dir, var/mob/mover)
	return movement_delay

/turf/proc/get_terrain_movement_delay(var/travel_dir, var/mob/mover)
	. = get_base_movement_delay(travel_dir, mover)
	if(weather)
		. += weather.get_movement_delay(return_air(), travel_dir)
	// TODO: check user species webbed feet, wearing swimming gear
	if(reagents?.total_volume > FLUID_PUDDLE)
		. += (reagents.total_volume > FLUID_SHALLOW) ? 6 : 3

/turf/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	var/datum/extension/turf_hand/highest_priority_intercept
	for(var/atom/thing in contents)
		var/datum/extension/turf_hand/intercept = get_extension(thing, /datum/extension/turf_hand)
		if(intercept?.intercept_priority > highest_priority_intercept?.intercept_priority)
			highest_priority_intercept = intercept
	if(highest_priority_intercept)
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		var/atom/intercepting_atom = highest_priority_intercept.holder
		return intercepting_atom.attack_hand(user)
	return FALSE

/turf/attack_robot(var/mob/user)
	return attack_hand_with_interaction_checks(user)

/turf/attackby(obj/item/W, mob/user)

	if(is_floor())

		if(istype(W, /obj/item/stack/tile))
			var/obj/item/stack/tile/T = W
			T.try_build_turf(user, src)
			return TRUE

		if(IS_HOE(W) && can_dig_farm(W.material?.hardness))
			try_dig_farm(user, W)
			return TRUE

		if(IS_SHOVEL(W))

			if(!can_be_dug(W.material?.hardness))
				to_chat(user, SPAN_WARNING("\The [src] is too hard to be dug with \the [W]."))
				return TRUE

			if(user.a_intent == I_HELP && can_dig_pit(W.material?.hardness))
				try_dig_pit(user, W)
			else if(can_dig_trench(W.material?.hardness))
				try_dig_trench(user, W)
			else
				to_chat(user, SPAN_WARNING("You cannot dig anything out of \the [src] with \the [W]."))
			return TRUE

		var/decl/material/material = get_material()
		if(IS_PICK(W) && material)

			if(material?.hardness <= MAT_VALUE_FLEXIBLE)
				to_chat(user, SPAN_WARNING("\The [src] is too soft to be excavated with \the [W]. Use a shovel."))
				return TRUE

			// Let picks dig out hard turfs, but not dig pits.
			if(!can_be_dug(W.material?.hardness, using_tool = TOOL_PICK))
				to_chat(user, SPAN_WARNING("\The [src] is too hard to be excavated with \the [W]."))
				return TRUE

			if(can_dig_trench(W.material?.hardness, using_tool = TOOL_PICK))
				try_dig_trench(user, W, using_tool = TOOL_PICK)
			else
				to_chat(user, SPAN_WARNING("You cannot excavate \the [src] with \the [W]."))

			return TRUE

		if(W?.storage?.collection_mode && W.storage.gather_all(src, user))
			return TRUE

	if(istype(W, /obj/item) && storage && storage.use_to_pickup && storage.collection_mode)
		storage.gather_all(src, user)
		return TRUE

	if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		if (G.affecting != G.assailant)
			G.affecting.DoMove(get_dir(G.affecting.loc, src), user, TRUE)
		return TRUE

	if(IS_COIL(W) && try_build_cable(W, user))
		return TRUE

	if(reagents?.total_volume >= FLUID_PUDDLE)
		if(ATOM_IS_OPEN_CONTAINER(W) && W.reagents)
			var/taking = min(reagents.total_volume, REAGENTS_FREE_SPACE(W.reagents))
			if(taking > 0)
				to_chat(user, SPAN_NOTICE("You fill \the [W] with [reagents.get_primary_reagent_name()] from \the [src]."))
				reagents.trans_to(W, taking)
				return TRUE

		if(user.a_intent == I_HELP)
			user.visible_message(SPAN_NOTICE("\The [user] dips \the [W] into \the [reagents.get_primary_reagent_name()]."))
			W.fluid_act(reagents)
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

	// Check if they need to climb out of a hole.
	if(has_gravity())
		var/mob/mover_mob = mover
		if(!istype(mover_mob) || (!mover_mob.throwing && !mover_mob.can_overcome_gravity()))
			var/turf/old_turf  = mover.loc
			var/old_height     = old_turf.get_physical_height() + old_turf.reagents?.total_volume
			var/current_height = get_physical_height() + reagents?.total_volume
			if(abs(current_height - old_height) > FLUID_SHALLOW)
				if(current_height > old_height)
					return 0
				if(istype(mover_mob) && MOVING_DELIBERATELY(mover_mob))
					to_chat(mover_mob, SPAN_WARNING("You refrain from stepping over the edge; it looks like a steep drop down to \the [src]."))
					return 0

	return 1 //Nothing found to block so return success!

/turf/proc/adjacent_fire_act(turf/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	return

/turf/proc/is_plating()
	return FALSE

/turf/proc/protects_atom(var/atom/A)
	return FALSE

/turf/proc/levelupdate()
	if(is_open() || is_plating())
		for(var/obj/O in src)
			O.hide(FALSE)
	else if(is_wall())
		for(var/obj/O in src)
			O.hide(TRUE)
	else
		for(var/obj/O in src)
			O.hide(O.hides_under_flooring())

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
	for(var/obj/effect/decal/cleanable/cleanable in src)
		qdel(cleanable)

/turf/proc/remove_decals()
	LAZYCLEARLIST(decals)
	update_icon()

// Called when turf is hit by a thrown object
/turf/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	SHOULD_CALL_PARENT(FALSE) // /atom/hitby() applies damage to AM if it's a living mob.
	. = TRUE
	if(density)
		if(isliving(AM))
			var/mob/living/M = AM
			M.turf_collision(src, TT.speed)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/turf, bounce_off), AM, TT.init_dir), 2)
	else if(isobj(AM))
		var/obj/structure/ladder/L = locate() in contents
		if(L)
			L.hitby(AM)

/turf/proc/bounce_off(var/atom/movable/AM, var/direction)
	if(AM.anchored)
		return
	if(ismob(AM))
		var/mob/living/M = AM
		if(LAZYLEN(M.pinned))
			return
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

/turf/proc/update_weather(var/obj/abstract/weather_system/new_weather, var/force_update_below = FALSE)

	if(isnull(new_weather))
		new_weather = SSweather.weather_by_z[z]

	// We have a weather system and we are exposed to it; update our vis contents.
	if(istype(new_weather) && is_outside())
		if(weather != new_weather)
			weather = new_weather
			. = TRUE

	// We are indoors or there is no local weather system, clear our vis contents.
	else if(weather)
		weather = null
		. = TRUE

	if(.)
		update_vis_contents()

	// Propagate our weather downwards if we permit it.
	if(force_update_below || (is_open() && .))
		var/turf/below = GetBelow(src)
		if(below)
			below.update_weather(new_weather)

// Updates turf participation in ZAS according to outside status. Must be called whenever the outside status of a turf may change.
/turf/proc/update_external_atmos_participation()
	var/old_outside = last_outside_check
	last_outside_check = OUTSIDE_UNCERTAIN
	if(is_outside())
		if(zone && external_atmosphere_participation)
			if(can_safely_remove_from_zone())
				zone.remove(src)
			else
				zone.rebuild()
	else if(!zone && zone_membership_candidate && old_outside == OUTSIDE_YES)
		// Set the turf's air to the external atmosphere to add to its new zone.
		air = get_external_air(FALSE)

	SSair.mark_for_update(src)

/turf/is_outside()

	// Can't rain inside or through solid walls.
	// TODO: dense structures like full windows should probably also block weather.
	if(density)
		return OUTSIDE_NO

	if(last_outside_check != OUTSIDE_UNCERTAIN)
		return last_outside_check

	// What is our local outside value?
	// Some turfs can be roofed irrespective of the turf above them in multiz.
	// I have the feeling this is redundat as a roofed turf below max z will
	// have a floor above it, but ah well.
	. = is_outside
	if(. == OUTSIDE_AREA)
		var/area/A = get_area(src)
		. = A ? A.is_outside : OUTSIDE_NO

	// If we are in a multiz volume and not already inside, we return
	// the outside value of the highest unenclosed turf in the stack.
	if(HasAbove(z))
		. =  OUTSIDE_YES // assume for the moment we're unroofed until we learn otherwise.
		var/turf/top_of_stack = src
		while(HasAbove(top_of_stack.z))
			var/turf/next_turf = GetAbove(top_of_stack)
			if(!next_turf.is_open())
				return OUTSIDE_NO
			top_of_stack = next_turf
		// If we hit the top of the stack without finding a roof, we ask the upmost turf if we're outside.
		. = top_of_stack.is_outside()
	last_outside_check = . // Cache this for later calls.

/turf/proc/set_outside(var/new_outside, var/skip_weather_update = FALSE)
	if(is_outside == new_outside)
		return FALSE

	is_outside = new_outside
	update_external_atmos_participation()
	AMBIENCE_QUEUE_TURF(src)

	if(!skip_weather_update)
		update_weather()

	if(!HasBelow(z))
		return TRUE

	// Invalidate the outside check cache for turfs below us.
	var/turf/checking = src
	while(HasBelow(checking.z))
		checking = GetBelow(checking)
		if(!isturf(checking))
			break
		checking.update_external_atmos_participation()
		if(!checking.is_open())
			break
	return TRUE

/turf/proc/get_air_graphic()
	if(zone && !zone.invalid)
		return zone.air?.graphic
	if(external_atmosphere_participation && is_outside())
		var/datum/level_data/level = SSmapping.levels_by_z[z]
		return level.exterior_atmosphere.graphic
	var/datum/gas_mixture/environment = return_air()
	return environment?.graphic

/turf/get_vis_contents_to_add()
	var/air_graphic = get_air_graphic()
	if(length(air_graphic))
		LAZYDISTINCTADD(., air_graphic)
	if(length(weather?.vis_contents_additions))
		LAZYADD(., weather.vis_contents_additions)
	if(flooded)
		var/flood_object = get_flood_overlay(flooded)
		if(flood_object)
			LAZYADD(., flood_object)

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

/turf/singularity_act(S, current_size)
	if(!simulated || is_open())
		return 0
	var/base_turf_type = get_base_turf_by_area(src)
	if(type == base_turf_type)
		return 0
	ChangeTurf(base_turf_type)
	return 2

/turf/proc/resolve_to_actual_turf()
	return src

// Largely copied from stairs.
/turf/proc/can_move_up_ramp(atom/movable/AM, turf/above_wall, turf/under_atom, turf/above_atom)
	if(!istype(AM) || !istype(above_wall) || !istype(under_atom) || !istype(above_atom))
		return FALSE
	return under_atom.CanZPass(AM, UP) && above_atom.CanZPass(AM, DOWN) && above_wall.Enter(AM)

/turf/Bumped(var/atom/movable/AM)
	if(!istype(AM) || !HasAbove(z))
		return ..()
	var/turf/wall/natural/slope = AM.loc
	if(!istype(slope) || !slope.ramp_slope_direction || get_dir(src, slope) != slope.ramp_slope_direction)
		return ..()
	var/turf/above_wall = GetAbove(src)
	if(can_move_up_ramp(AM, above_wall, get_turf(AM), GetAbove(AM)))
		AM.forceMove(above_wall)
		if(isliving(AM))
			var/mob/living/L = AM
			for(var/obj/item/grab/G in L.get_active_grabs())
				G.affecting.forceMove(above_wall)
	else
		to_chat(AM, SPAN_WARNING("Something blocks the path."))
	return TRUE

/turf/clean(clean_forensics = TRUE)
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean(clean_forensics)
	. = ..()

//returns 1 if made bloody, returns 0 otherwise
/turf/add_blood(mob/living/M)
	if(!simulated || !..() || !ishuman(M))
		return FALSE
	var/mob/living/human/H = M
	var/unique_enzymes = H.get_unique_enzymes()
	var/blood_type     = H.get_blood_type()
	if(unique_enzymes && blood_type)
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!LAZYACCESS(B.blood_DNA, unique_enzymes))
				LAZYSET(B.blood_DNA, unique_enzymes, blood_type)
				LAZYSET(B.blood_data, unique_enzymes, REAGENT_DATA(H.vessel, H.species.blood_reagent))
				var/datum/extension/forensic_evidence/forensics = get_or_create_extension(B, /datum/extension/forensic_evidence)
				forensics.add_data(/datum/forensics/blood_dna, unique_enzymes)
	else
		blood_splatter(src, M, 1)
	return TRUE

/turf/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor=COLOR_BLOOD_HUMAN)
	if(!simulated)
		return
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

// Proc called in /turf/Entered() to supply an appropriate fluid overlay.
/turf/proc/get_movable_alpha_mask_state(atom/movable/mover)
	if(flooded)
		return null
	if(ismob(mover))
		var/mob/moving_mob = mover
		if(moving_mob.can_overcome_gravity())
			return null
	var/fluid_depth = get_fluid_depth()
	if(fluid_depth > FLUID_PUDDLE)
		if(fluid_depth <= FLUID_SHALLOW)
			return "mask_shallow"
		if(fluid_depth <= FLUID_DEEP)
			return "mask_deep"

/turf/spark_act(obj/effect/sparks/sparks)
	if(simulated)
		hotspot_expose(1000,100)
		for(var/atom/thing in contents)
			if(thing.simulated && prob(25))
				thing.spark_act(sparks)
		return TRUE
	return FALSE

/turf/proc/get_trench_name()
	if(check_fluid_depth(FLUID_SHALLOW))
		return get_fluid_name()
	return src

/turf/receive_mouse_drop(atom/dropping, mob/user, params)
	. = ..()
	if(!. && simulated && dropping == user && isturf(user.loc) && user.Adjacent(src))
		var/turf/other_turf = user.loc
		var/our_height = get_physical_height()
		var/their_height = other_turf.get_physical_height()
		if(abs(our_height-their_height) > FLUID_SHALLOW)
			. = TRUE
			if(our_height < their_height)
				user.visible_message(SPAN_NOTICE("\The [user] starts climbing down into \the [get_trench_name()]."))
			else
				user.visible_message(SPAN_NOTICE("\The [user] starts climbing out of \the [other_turf.get_trench_name()]."))
			if(!do_after(user, 2 SECONDS, src) || QDELETED(user) || user?.loc != other_turf || !user.Adjacent(src))
				return
			if(our_height < their_height)
				user.visible_message(SPAN_NOTICE("\The [user] climbs down into \the [get_trench_name()]."))
			else
				user.visible_message(SPAN_NOTICE("\The [user] climbs out of \the [other_turf.get_trench_name()]."))
			LAZYDISTINCTADD(skip_height_fall_for, weakref(user))
			user.dropInto(src)
			LAZYREMOVE(skip_height_fall_for, weakref(user))

/turf/proc/handle_universal_decay()
	return

/turf/proc/get_plant_growth_rate()
	return 0

/turf/proc/get_soil_color()
	return null

/turf/proc/get_fishing_result(obj/item/food/bait)
	var/area/A = get_area(src)
	return A.get_fishing_result(src, bait)

/turf/get_affecting_weather()
	return weather

/turf/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/show_turf_contents)
	if(user)
		var/obj/item/held = user.get_active_held_item()
		if(istype(held))
			if(IS_SHOVEL(held))
				if(can_dig_pit(held.material?.hardness))
					LAZYDISTINCTADD(., /decl/interaction_handler/dig/pit)
				if(can_dig_trench(held.material?.hardness))
					LAZYDISTINCTADD(., /decl/interaction_handler/dig/trench)
			if(IS_PICK(held) && can_dig_trench(held.material?.hardness, using_tool = TOOL_PICK))
				LAZYDISTINCTADD(., /decl/interaction_handler/dig/trench)
			if(IS_HOE(held) && can_dig_farm(held.material?.hardness))
				LAZYDISTINCTADD(., /decl/interaction_handler/dig/farm)

/decl/interaction_handler/show_turf_contents
	name = "Show Turf Contents"
	expected_user_type = /mob
	interaction_flags = 0

/decl/interaction_handler/show_turf_contents/invoked(atom/target, mob/user, obj/item/prop)
	target.show_atom_list_for_turf(user, get_turf(target))

/decl/interaction_handler/dig
	abstract_type = /decl/interaction_handler/dig
	expected_user_type = /mob
	expected_target_type = /turf
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_TURF

/decl/interaction_handler/dig/trench
	name = "Dig Trench"

/decl/interaction_handler/dig/trench/invoked(atom/target, mob/user, obj/item/prop)
	var/turf/T = get_turf(target)
	if(IS_SHOVEL(prop))
		if(T.can_dig_trench(prop?.material?.hardness))
			T.try_dig_trench(user, prop)
	else if(IS_PICK(prop))
		var/decl/material/material = T.get_material()
		if(material?.hardness > MAT_VALUE_FLEXIBLE && T.can_dig_trench(prop?.material?.hardness, using_tool = TOOL_PICK))
			T.try_dig_trench(user, prop, using_tool = TOOL_PICK)

/decl/interaction_handler/dig/pit
	name = "Dig Pit"

/decl/interaction_handler/dig/pit/invoked(atom/target, mob/user, obj/item/prop)
	var/turf/T = get_turf(target)
	if(T.can_dig_pit(prop?.material?.hardness))
		T.try_dig_pit(user, prop)

/decl/interaction_handler/dig/farm
	name = "Dig Farm Plot"

/decl/interaction_handler/dig/farm/invoked(atom/target, mob/user, obj/item/prop)
	var/turf/T = get_turf(target)
	if(T.can_dig_farm(prop?.material?.hardness))
		T.try_dig_farm(user, prop)
