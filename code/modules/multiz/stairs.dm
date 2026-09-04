/obj/structure/stairs
	name = "stairs"
	desc = "Stairs leading to another deck. Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	layer = RUNE_LAYER

/obj/structure/stairs/Initialize()
	for(var/turf/turf in locs)
		var/turf/above = GetAbove(turf)
		if(!istype(above))
			warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
			return INITIALIZE_HINT_QDEL
		if(!above.is_open())
			above.ChangeTurf(/turf/space) // This will be resolved to the appropriate open space type by ChangeTurf().
	. = ..()

/obj/structure/stairs/CheckExit(atom/movable/mover, turf/target)
	if((get_dir(loc, target) == dir) && (get_turf(mover) == loc))
		return FALSE
	return ..()

/obj/structure/stairs/Bumped(atom/movable/A)
	var/turf/myturf = get_turf(src)
	var/turf/target = get_step(GetAbove(A), dir)
	var/turf/source = get_turf(A)
	if(myturf.CanZPass(A, UP) && target.Enter(A, src))
		A.forceMove(target)
		if(isliving(A))
			var/mob/living/L = A
			for(var/obj/item/grab/grab as anything in L.get_active_grabs())
				grab.affecting.forceMove(target)
		if(ishuman(A))
			var/mob/living/human/H = A
			if(H.has_footsteps())
				playsound(source, 'sound/effects/stairs_step.ogg', 50)
				playsound(target, 'sound/effects/stairs_step.ogg', 50)
	else
		to_chat(A, SPAN_WARNING("Something blocks the path."))

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/stairs/catwalk
	name = "catwalk stairs"
	icon_state = "catwalk"

// type paths to make mapping easier.
/obj/structure/stairs/north
	dir = NORTH

/obj/structure/stairs/south
	dir = SOUTH

/obj/structure/stairs/east
	dir = EAST

/obj/structure/stairs/west
	dir = WEST

/obj/structure/stairs/long
	icon = 'icons/obj/stairs_64.dmi'
	bound_height = 64
	appearance_flags = /obj/structure/stairs::appearance_flags & ~TILE_BOUND

/obj/structure/stairs/long/north
	dir = NORTH
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs/long/east
	dir = EAST
	bound_width = 64
	bound_height = 32
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs/long/west
	dir = WEST
	bound_width = 64
	bound_height = 32

/obj/structure/stairs/long/catwalk
	name = "catwalk stairs"
	icon_state = "catwalk"

/obj/structure/stairs/long/catwalk/north
	dir = NORTH
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs/long/catwalk/east
	dir = EAST
	bound_width = 64
	bound_height = 32
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs/long/catwalk/west
	dir = WEST
	bound_width = 64
	bound_height = 32