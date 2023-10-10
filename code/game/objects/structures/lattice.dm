/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/structures/smoothlattice.dmi'
	icon_state = "lattice0"
	density = 0
	anchored = 1
	w_class = ITEM_SIZE_NORMAL
	layer = LATTICE_LAYER
	color = COLOR_STEEL
	material = /decl/material/solid/metal/steel
	obj_flags = OBJ_FLAG_NOFALL | OBJ_FLAG_MOVES_UNSUPPORTED
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/structure/lattice/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		DELETE_IF_DUPLICATE_OF(/obj/structure/lattice)
		if(!istype(material))
			return INITIALIZE_HINT_QDEL
		var/turf/T = loc
		if(!istype(T) || !T.is_open())
			return INITIALIZE_HINT_QDEL
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/lattice/LateInitialize()
	. = ..()
	update_neighbors()

/obj/structure/lattice/can_climb_from_below(var/mob/climber)
	return TRUE

/obj/structure/lattice/update_material_desc()
	if(material)
		desc = "A lightweight support [material.solid_name] lattice."
	else
		desc = "A lightweight support [material.solid_name] lattice."

/obj/structure/lattice/Destroy()
	var/turf/old_loc = get_turf(src)
	. = ..()
	if(istype(old_loc))
		update_neighbors(old_loc)
		for(var/atom/movable/AM in old_loc)
			AM.fall(old_loc)

/obj/structure/lattice/proc/update_neighbors(var/location = loc)
	for (var/dir in global.cardinal)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, get_step(location, dir))
		if(L)
			L.update_icon()

/obj/structure/lattice/explosion_act(severity)
	..()
	if(!QDELETED(src) && severity <= 2)
		physically_destroyed()

/obj/structure/lattice/proc/deconstruct(var/mob/user)
	to_chat(user, SPAN_NOTICE("Slicing lattice joints..."))
	physically_destroyed()

/obj/structure/lattice/attackby(obj/item/C, mob/user)

	if (istype(C, /obj/item/stack/tile))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if(IS_WELDER(C))
		var/obj/item/weldingtool/WT = C
		if(WT.weld(0, user))
			deconstruct(user)
		return
	if(istype(C, /obj/item/gun/energy/plasmacutter))
		var/obj/item/gun/energy/plasmacutter/cutter = C
		if(!cutter.slice(user))
			return
		deconstruct(user)
		return
	if (istype(C, /obj/item/stack/material/rods))

		var/ladder = (locate(/obj/structure/ladder) in loc)
		if(ladder)
			to_chat(user, SPAN_WARNING("\The [ladder] is in the way."))
			return TRUE

		var/obj/item/stack/material/rods/R = C
		if(locate(/obj/structure/catwalk) in get_turf(src))
			to_chat(user, SPAN_WARNING("There is already a catwalk here."))
			return
		else if(R.use(2))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/catwalk(src.loc, R.material.type)
			return
		else
			to_chat(user, SPAN_WARNING("You require at least two rods to complete the catwalk."))

/obj/structure/lattice/on_update_icon()
	..()
	var/dir_sum = 0
	for (var/direction in global.cardinal)
		var/turf/T = get_step(src, direction)
		if(locate(/obj/structure/lattice, T) || locate(/obj/structure/catwalk, T))
			dir_sum += direction
		else
			var/turf/O = get_step(src, direction)
			if(!istype(O) || !O.is_open())
				dir_sum += direction
	icon_state = "lattice[dir_sum]"