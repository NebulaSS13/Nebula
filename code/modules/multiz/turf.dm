// Shared attackby behaviors that /turf/exterior/open also uses.
/proc/shared_open_turf_attackhand(var/turf/target, var/mob/user)
	for(var/atom/movable/M in target.below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attack_hand_with_interaction_checks(user)

/proc/shared_open_turf_attackby(var/turf/target, obj/item/thing, mob/user)

	if(istype(thing, /obj/item/stack/material/rods))
		var/ladder = (locate(/obj/structure/ladder) in target)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE
		var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, target)
		if(lattice)
			return lattice.attackby(thing, user)
		var/obj/item/stack/material/rods/rods = thing
		if (rods.use(1))
			to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
			playsound(target, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(target.x, target.y, target.z), rods.material.type)
		return TRUE

	if (istype(thing, /obj/item/stack/tile))
		var/obj/item/stack/tile/tile = thing
		tile.try_build_turf(user, target)
		return TRUE

	//To lay cable.
	if(IS_COIL(thing) && target.try_build_cable(thing, user))
		return TRUE

	for(var/atom/movable/M in target.below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attackby(thing, user)

	return FALSE

/// `direction` is the direction the atom is trying to leave by.
/turf/proc/CanZPass(atom/A, direction, check_neighbor_canzpass = TRUE)

	if(direction == UP)
		if(!HasAbove(z))
			return FALSE
		if(check_neighbor_canzpass)
			var/turf/T = GetAbove(src)
			if(!T.CanZPass(A, DOWN, FALSE))
				return FALSE

	else if(direction == DOWN)
		if(!is_open() || !HasBelow(z) || (locate(/obj/structure/catwalk) in src))
			return FALSE
		if(check_neighbor_canzpass)
			var/turf/T = GetBelow(src)
			if(!T.CanZPass(A, UP, FALSE))
				return FALSE

	// Hate calling Enter() directly, but that's where obstacles are checked currently.
	return Enter(A, A)

////////////////////////////////
// Open SIMULATED
////////////////////////////////
/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS
	turf_flags = TURF_FLAG_BACKGROUND

/turf/simulated/open/flooded
	name = "open water"
	flooded = TRUE

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall(oldloc)

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(var/atom/movable/AM)
	..()
	if(!QDELETED(AM))
		AM.fall()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/turf/T = GetBelow(src); (istype(T) && T.is_open()); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/simulated/open/is_open()
	return TRUE

/turf/simulated/open/attackby(obj/item/C, mob/user)
	return shared_open_turf_attackby(src, C, user)

/turf/simulated/open/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return shared_open_turf_attackhand(src, user)

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return TRUE

/turf/simulated/open/cannot_build_cable()
	return 0

////////////////////////////////
// Open EXTERIOR
////////////////////////////////
/turf/exterior/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = 0
	pathweight = 100000
	z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS

/turf/exterior/open/flooded
	name = "open water"
	flooded = TRUE

/turf/exterior/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall(oldloc)

/turf/exterior/open/hitby(var/atom/movable/AM)
	..()
	if(!QDELETED(AM))
		AM.fall()

/turf/exterior/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/turf/T = GetBelow(src); (istype(T) && T.is_open()); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/exterior/open/is_open()
	return TRUE

/turf/exterior/open/attackby(obj/item/C, mob/user)
	return shared_open_turf_attackby(src, C, user)

/turf/exterior/open/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return shared_open_turf_attackhand(src, user)

/turf/exterior/open/cannot_build_cable()
	return 0
