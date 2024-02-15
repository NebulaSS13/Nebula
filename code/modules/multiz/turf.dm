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
// Open space
////////////////////////////////
/turf/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = FALSE
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS
	turf_flags = TURF_FLAG_BACKGROUND

/turf/open/flooded
	name = "open water"
	flooded = /decl/material/liquid/water

/turf/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall(oldloc)

// Called when thrown object lands on this turf.
/turf/open/hitby(var/atom/movable/AM)
	..()
	if(!QDELETED(AM))
		AM.fall()

// override to make sure nothing is hidden
/turf/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/turf/T = GetBelow(src); (istype(T) && T.is_open()); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

/turf/open/is_open()
	return TRUE

/turf/open/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/stack/material/rods))
		var/ladder = (locate(/obj/structure/ladder) in src)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE
		var/obj/structure/lattice/lattice = locate(/obj/structure/lattice, src)
		if(lattice)
			return lattice.attackby(C, user)
		var/obj/item/stack/material/rods/rods = C
		if (rods.use(1))
			to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(src, rods.material.type)
		return TRUE

	if (istype(C, /obj/item/stack/tile))
		var/obj/item/stack/tile/tile = C
		tile.try_build_turf(user, src)
		return TRUE

	//To lay cable.
	if(IS_COIL(C) && try_build_cable(C, user))
		return TRUE

	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attackby(C, user)

	return FALSE

/turf/open/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attack_hand_with_interaction_checks(user)
	return FALSE

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/open/is_plating()
	return TRUE

/turf/open/cannot_build_cable()
	return 0

/turf/open/drill_act()
	SHOULD_CALL_PARENT(FALSE)
	var/turf/T = GetBelow(src)
	if(istype(T))
		T.drill_act()
