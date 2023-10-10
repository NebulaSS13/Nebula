/*** EXIT PORTAL ***/

/obj/effect/wormhole_exit
	name = "unstable wormhole"
	desc = "NO TIME TO EXPLAIN, JUMP IN!"
	icon = 'icons/obj/rift.dmi'
	icon_state = "rift"
	anchored = TRUE
	unacidable = TRUE
	pixel_x = -236
	pixel_y = -256
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER
	is_spawnable_type = FALSE
	var/const/transit_range = 6

/obj/effect/wormhole_exit/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	var/datum/extension/universally_visible/univis = get_or_create_extension(src, /datum/extension/universally_visible)
	univis.refresh()

/obj/effect/wormhole_exit/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/wormhole_exit/Process()
	for(var/atom/movable/AM in range(transit_range, src))
		transit_to_exit(AM)

/obj/effect/wormhole_exit/proc/transit_to_exit(const/atom/A)
	if(!A.simulated)
		return FALSE
	if (istype(A, /mob/living))

		var/mob/living/L = A
		if(!length(global.endgame_safespawns))
			to_chat(L, SPAN_NOTICE("You fall through the wormhole, and to safety, leaving behind the doom Universe that bore you..."))
			L.ghostize()
			QDEL_NULL(L.buckled)
			qdel(L)
			return

		var/atom/movable/AM = L.buckled
		do_teleport(L, pick(global.endgame_safespawns))
		if(istype(AM))
			AM.forceMove(L.loc)

	else if (isturf(A))
		var/turf/T = A
		var/dist = get_dist(T, src)
		if(dist <= transit_range && T.density)
			T.set_density(0)
		for(var/atom/movable/AM in T.contents)
			if (AM == src) // This is the snowflake.
				continue
			if (dist <= transit_range)
				transit_to_exit(AM)
			else if (dist > transit_range)
				if(AM.simulated)
					AM.singularity_pull(src, transit_range)
	return TRUE
