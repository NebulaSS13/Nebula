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
			above.ChangeTurf(/turf/simulated/open)
	. = ..()

/obj/structure/stairs/CheckExit(atom/movable/mover, turf/target)
	if((get_dir(loc, target) == dir) && (get_turf(mover) == loc))
		return FALSE
	return ..()

/obj/structure/stairs/Bumped(atom/movable/A)
	var/turf/target = get_step(GetAbove(A), dir)
	var/turf/source = get_turf(A)
	var/turf/above = GetAbove(A)
	if(above.CanZPass(source, UP) && target.Enter(A, src))
		A.forceMove(target)
		if(isliving(A))
			var/mob/living/L = A
			for(var/obj/item/grab/G in L.get_active_grabs())
				G.affecting.forceMove(target)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.has_footsteps())
				playsound(source, 'sound/effects/stairs_step.ogg', 50)
				playsound(target, 'sound/effects/stairs_step.ogg', 50)
	else
		to_chat(A, SPAN_WARNING("Something blocks the path."))

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

// type paths to make mapping easier.

/obj/structure/stairs/long
	icon = 'icons/obj/stairs_64.dmi'
	bound_height = 64

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
