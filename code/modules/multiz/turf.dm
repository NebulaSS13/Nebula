/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/turf/space/CanZPass(atom/A, direction)
	if(locate(/obj/structure/catwalk, src))
		if(z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1

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

/turf/simulated/open/flooded
	name = "open water"
	flooded = TRUE

/turf/simulated/open/CanZPass(atom/A, direction)
	if(locate(/obj/structure/catwalk, src))
		if(z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1

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

	if(istype(C, /obj/item/grab))
		return ..()

	if (istype(C, /obj/item/stack/material/rods))

		var/ladder = (locate(/obj/structure/ladder) in src)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE

		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.attackby(C, user)
		var/obj/item/stack/material/rods/R = C
		if (R.use(1))
			to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z), R.material.type)
			return TRUE
		return

	if (istype(C, /obj/item/stack/tile))

		var/ladder = (locate(/obj/structure/ladder) in src)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE

		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (!S.use(1))
				return
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ChangeTurf(/turf/simulated/floor, keep_air = TRUE)
			qdel(L)
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))
		return TRUE

	//To lay cable.
	if(isCoil(C) && try_build_cable(C, user))
		return TRUE

	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attackby(C, user)

/turf/simulated/open/attack_hand(mob/user)
	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attack_hand(user)

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

/turf/exterior/open/CanZPass(atom/A, direction)
	if(locate(/obj/structure/catwalk, src))
		if(z == A.z)
			if(direction == DOWN)
				return 0
		else if(direction == UP)
			return 0
	return 1

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

	if (istype(C, /obj/item/stack/material/rods))
		var/ladder = (locate(/obj/structure/ladder) in src)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.attackby(C, user)
		var/obj/item/stack/material/rods/R = C
		if (R.use(1))
			to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z), R.material.type)
			return TRUE
		return

	if (istype(C, /obj/item/stack/tile))
		var/ladder = (locate(/obj/structure/ladder) in src)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (!S.use(1))
				return
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ChangeTurf(/turf/simulated/floor, keep_air = TRUE)
			qdel(L)
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))
		return TRUE

	//To lay cable.
	if(isCoil(C) && try_build_cable(C, user))
		return TRUE

	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attackby(C, user)

/turf/exterior/open/attack_hand(mob/user)
	for(var/atom/movable/M in below)
		if(M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
			return M.attack_hand(user)

/turf/exterior/open/cannot_build_cable()
	return 0
