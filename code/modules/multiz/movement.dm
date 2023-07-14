/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	move_up()

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	move_down()

/mob/proc/move_up()
	SelfMove(UP)

/mob/proc/move_down()
	SelfMove(DOWN)

/mob/living/carbon/human/move_up()
	var/turf/old_loc = loc
	..()
	if(loc != old_loc)
		return

	var/turf/simulated/open/O = GetAbove(src)
	var/atom/climb_target
	if(istype(O))
		for(var/turf/T in RANGE_TURFS(O, 1))
			if(!T.is_open() && T.is_floor())
				climb_target = T
			else
				for(var/obj/I in T)
					if(I.obj_flags & OBJ_FLAG_NOFALL)
						climb_target = I
						break
			if(climb_target)
				break

	if(climb_target)
		climb_up(climb_target)

/atom/proc/CanMoveOnto(atom/movable/mover, turf/target, height=1.5, direction = 0)
	//Purpose: Determines if the object can move through this
	//Uses regular limitations plus whatever we think is an exception for the purpose of
	//moving up and down z levles
	return CanPass(mover, target, height, 0) || (direction == DOWN && (atom_flags & ATOM_FLAG_CLIMBABLE))

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/carbon/human/can_overcome_gravity()
	//First do species check
	if(species && species.can_overcome_gravity(src))
		return 1
	else
		var/turf/T = loc
		if(((T.get_physical_height() + T.get_fluid_depth()) >= FLUID_DEEP) || T.get_fluid_depth() >= FLUID_MAX_DEPTH)
			if(can_float())
				return 1

		for(var/atom/a in src.loc)
			if(a.atom_flags & ATOM_FLAG_CLIMBABLE)
				return 1

		//Last check, list of items that could plausibly be used to climb but aren't climbable themselves
		var/list/objects_to_stand_on = list(
				/obj/item/stool,
				/obj/structure/bed,
			)
		for(var/type in objects_to_stand_on)
			if(locate(type) in src.loc)
				return 1
	return 0

/mob/proc/can_ztravel()
	return 0

/mob/living/carbon/human/can_ztravel()
	if(Process_Spacemove())
		return 1

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in RANGE_TURFS(src, 1))
			if(T.density)
				return 1

/mob/living/silicon/robot/can_ztravel()
	if(Process_Spacemove()) //Checks for active jetpack
		return 1

	for(var/turf/simulated/T in RANGE_TURFS(src, 1)) //Robots get "magboots"
		if(T.density)
			return 1

//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall(var/lastloc)
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	if(!has_gravity())
		return

	if(throwing)
		return

	if(can_fall())
		begin_falling(lastloc, below)

// We timer(0) here to let the current move operation complete before we start falling. fall() is normally called from
// Entered() which is part of Move(), by spawn()ing we let that complete.  But we want to preserve if we were in client movement
// or normal movement so other move behavior can continue.
/atom/movable/proc/begin_falling(var/lastloc, var/below)
	addtimer(CALLBACK(src, /atom/movable/proc/fall_callback, below), 0)

/atom/movable/proc/fall_callback(var/turf/below)
	if(!QDELETED(src))
		handle_fall(below)

/mob/fall_callback(var/turf/below)
	var/was_moving = moving
	..()
	if(was_moving)
		moving = FALSE

//For children to override
/atom/movable/proc/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = loc)
	if(!simulated)
		return FALSE

	if(anchored && !anchor_bypass)
		return FALSE

	//Override will make checks from different location used for prediction
	if(location_override)
		for(var/obj/O in location_override)
			if(O.obj_flags & OBJ_FLAG_NOFALL)
				return FALSE

		var/turf/below = GetBelow(location_override)
		for(var/atom/A in below)
			if(!A.CanPass(src, location_override))
				return FALSE

		//We cannot sink if we can swim
		if(location_override.get_fluid_depth() >= FLUID_DEEP && (below == loc))
			if(!(below.get_fluid_depth() >= 0.95 * FLUID_MAX_DEPTH)) //No salmon skipping up a stream of falling water
				return TRUE
			return !can_float()


	return TRUE

/obj/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = loc)
	return ..(anchor_fall)

/obj/effect/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = loc)
	return FALSE

/obj/effect/decal/cleanable/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = loc)
	return TRUE

/obj/item/pipe/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = loc)
	var/turf/simulated/open/below = loc
	below = below.below

	. = ..()

	if(anchored)
		return FALSE

	if((locate(/obj/structure/disposalpipe/up) in below) || locate(/obj/machinery/atmospherics/pipe/zpipe/up) in below)
		return FALSE

/mob/living/carbon/human/can_fall(var/anchor_bypass = FALSE, var/turf/location_override = loc)
	if(..())
		return species.can_fall(src)

/atom/movable/proc/protected_from_fall_damage(var/turf/landing)
	return !!(locate(/obj/structure/stairs) in landing)

/mob/protected_from_fall_damage(var/turf/landing)
	. = ..()
	if(!.)
		// This is very silly, but it can be refined and made more appropriate as our multiz turf system is expanded.
		var/obj/item/storage/backpack/parachute/parachute = get_equipped_item(slot_back_str)
		if(istype(parachute) && parachute.packed)
			parachute.packed = FALSE
			return TRUE

/atom/movable/proc/handle_fall(var/turf/landing)
	var/turf/previous = get_turf(loc)
	Move(landing, get_dir(previous, landing))
	if(protected_from_fall_damage(landing))
		return TRUE
	if(landing.get_fluid_depth() >= FLUID_DEEP)
		var/primary_fluid = landing.get_fluid_name()
		if(previous.get_fluid_depth() >= FLUID_DEEP) //We're sinking further
			visible_message(SPAN_NOTICE("\The [src] sinks deeper down into \the [primary_fluid]!"), SPAN_NOTICE("\The [primary_fluid] rushes around you as you sink!"))
			playsound(previous, pick(SSfluids.gurgles), 50, 1)
		else
			visible_message(SPAN_NOTICE("\The [src] falls into the [primary_fluid]!"), SPAN_NOTICE("What a splash!"))
			playsound(src,  'sound/effects/watersplash.ogg', 30, TRUE)
		return TRUE
	else
		handle_fall_effect(landing)

/atom/movable/proc/handle_fall_effect(var/turf/landing)
	SHOULD_CALL_PARENT(TRUE)
	if(istype(landing) && landing.is_open())
		visible_message("\The [src] falls through \the [landing]!", "You hear a whoosh of displaced air.")
	else
		visible_message("\The [src] slams into \the [landing]!", "You hear something slam into the [global.using_map.ground_noun].")
		var/fall_damage = fall_damage()
		if(fall_damage > 0)
			for(var/mob/living/M in landing.contents)
				if(M == src)
					continue
				visible_message("\The [src] hits \the [M.name]!")
				M.take_overall_damage(fall_damage)

/atom/movable/proc/fall_damage()
	return 0

/obj/fall_damage()
	if(w_class == ITEM_SIZE_TINY)
		return 0
	if(w_class >= ITEM_SIZE_NO_CONTAINER)
		return 100
	return BASE_STORAGE_COST(w_class)

/mob/living/carbon/human/apply_fall_damage(var/turf/landing)
	if(status_flags & GODMODE)
		return
	if(species && species.handle_fall_special(src, landing))
		return
	var/min_damage = 7
	var/max_damage = 14
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_HEAD, armor_pen = 50)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_CHEST, armor_pen = 50)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_GROIN, armor_pen = 75)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_LEG, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_LEG, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_FOOT, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_FOOT, armor_pen = 100)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_ARM, armor_pen = 75)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_ARM, armor_pen = 75)
	SET_STATUS_MAX(src, STAT_WEAK, 3)
	if(prob(skill_fail_chance(SKILL_HAULING, 40, SKILL_EXPERT, 2)))
		var/list/victims = list()
		for(var/tag in list(BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, tag)
			if(E && !E.is_dislocated() && (E.limb_flags & ORGAN_FLAG_CAN_DISLOCATE) && !BP_IS_PROSTHETIC(E))
				victims += E
		if(victims.len)
			var/obj/item/organ/external/victim = pick(victims)
			victim.dislocate()
			to_chat(src, "<span class='warning'>You feel a sickening pop as your [victim.joint] is wrenched out of the socket.</span>")
	updatehealth()

/mob/living/carbon/human/proc/climb_up(atom/A)
	if(!isturf(loc) || !bound_overlay || bound_overlay.destruction_timer || is_physically_disabled())	// This destruction_timer check ideally wouldn't be required, but I'm not awake enough to refactor this to not need it.
		return FALSE

	var/turf/T = get_turf(A)
	if(T.Adjacent(bound_overlay) && T.CanZPass(src, UP)) //Certain structures will block passage from below, others not
		if(loc.has_gravity() && !can_overcome_gravity())
			return FALSE

		visible_message("<span class='notice'>[src] starts climbing onto \the [A]!</span>", "<span class='notice'>You start climbing onto \the [A]!</span>")
		if(do_after(src, 50, A))
			visible_message("<span class='notice'>[src] climbs onto \the [A]!</span>", "<span class='notice'>You climb onto \the [A]!</span>")
			src.Move(T)
		else
			visible_message("<span class='warning'>[src] gives up on trying to climb onto \the [A]!</span>", "<span class='warning'>You give up on trying to climb onto \the [A]!</span>")
		return TRUE

/mob/living/verb/lookup()
	set name = "Look Up"
	set desc = "If you want to know what's above."
	set category = "IC"

	if(client && !is_physically_disabled())
		if(z_eye)
			reset_view(null)
			qdel(z_eye)
			z_eye = null
			return
		var/turf/above = GetAbove(src)
		if(istype(above) && TURF_IS_MIMICKING(above))
			z_eye = new /atom/movable/z_observer/z_up(src, src)
			to_chat(src, "<span class='notice'>You look up.</span>")
			reset_view(z_eye)
			return
		to_chat(src, "<span class='notice'>You can see \the [above ? above : "ceiling"].</span>")
	else
		to_chat(src, "<span class='notice'>You can't look up right now.</span>")

/mob/living/verb/lookdown()
	set name = "Look Down"
	set desc = "If you want to know what's below."
	set category = "IC"

	if(client && !is_physically_disabled())
		if(z_eye)
			reset_view(null)
			qdel(z_eye)
			z_eye = null
			return
		var/turf/T = get_turf(src)
		if(T && TURF_IS_MIMICKING(T) && HasBelow(T.z))
			z_eye = new /atom/movable/z_observer/z_down(src, src)
			to_chat(src, "<span class='notice'>You look down.</span>")
			reset_view(z_eye)
			return
		to_chat(src, "<span class='notice'>You can see \the [T ? T : "floor"].</span>")
	else
		to_chat(src, "<span class='notice'>You can't look below right now.</span>")

//Swimming and floating
/atom/movable/proc/can_float()
	return FALSE

/mob/living/can_float()
	return !is_physically_disabled()

/mob/living/simple_animal/can_float()
	return is_aquatic

/mob/living/carbon/human/can_float()
	return species.can_float(src)

/mob/living/silicon/can_float()
	return FALSE //If they can fly otherwise it will be checked first

/mob/living
	var/atom/movable/z_observer/z_eye

/atom/movable/z_observer
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE
	var/mob/living/owner

/atom/movable/z_observer/Initialize(mapload, var/mob/living/user)
	. = ..()
	owner = user
	follow()
	events_repository.register(/decl/observ/moved, owner, src, /atom/movable/z_observer/proc/follow)

/atom/movable/z_observer/proc/follow()

/atom/movable/z_observer/z_up/follow()
	forceMove(get_step(owner, UP))
	if(isturf(src.loc))
		var/turf/T = src.loc
		if(T && TURF_IS_MIMICKING(T))
			return
	owner.reset_view(null)
	owner.z_eye = null
	qdel(src)

/atom/movable/z_observer/z_down/follow()
	forceMove(get_step(owner, DOWN))
	var/turf/T = get_turf(owner)
	if(T && TURF_IS_MIMICKING(T))
		return
	owner.reset_view(null)
	owner.z_eye = null
	qdel(src)

/atom/movable/z_observer/Destroy()
	events_repository.unregister(/decl/observ/moved, owner, src, /atom/movable/z_observer/proc/follow)
	owner = null
	. = ..()

/atom/movable/z_observer/can_fall()
	return FALSE

/atom/movable/z_observer/explosion_act()
	SHOULD_CALL_PARENT(FALSE)
	return
