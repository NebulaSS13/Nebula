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
	initial_gas = list(
		/decl/material/gas/oxygen = MOLES_O2STANDARD,
		/decl/material/gas/nitrogen = MOLES_N2STANDARD
	)
	zone_membership_candidate = TRUE

/turf/open/flooded
	name = "open water"
	flooded = /decl/material/liquid/water

/turf/open/Entered(var/atom/movable/mover, var/atom/oldloc)
	..()
	mover.fall(oldloc)

// Called when thrown object lands on this turf.
/turf/open/hitby(var/atom/movable/AM)
	. = ..()
	if(!QDELETED(AM))
		AM.fall()

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

	if(istype(C, /obj/item/grab))
		var/obj/item/grab/G = C
		if (G.affecting != G.assailant)
			G.affecting.DoMove(get_dir(G.affecting.loc, src), user, TRUE)
		return TRUE

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

/turf/open/airless
	initial_gas = null