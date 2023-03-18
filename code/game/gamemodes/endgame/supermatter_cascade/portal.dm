/*** EXIT PORTAL ***/

/obj/effect/wormhole_exit
	name = "unstable wormhole"
	desc = "NO TIME TO EXPLAIN, JUMP IN!"
	icon = 'icons/obj/rift.dmi'
	icon_state = "rift"
	layer = LIGHTING_LAYER+2 // ITS SO BRIGHT
	is_spawnable_type = FALSE
	var/const/transit_range = 6

/obj/effect/wormhole_exit/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/wormhole_exit/Process()
	for(var/mob/M in global.player_list)
		if(M.client)
			M.see_rift(src)
	for(var/atom/movable/AM in range(transit_range, src))
		transit_to_exit(AM)

/obj/effect/wormhole_exit/proc/transit_to_exit(const/atom/A)
	if(!A.simulated)
		return FALSE
	if (istype(A, /mob/living) && length(global.endgame_safespawns))
		var/mob/living/L = A
		if(L.buckled && istype(L.buckled,/obj/structure/bed/))
			var/turf/O = L.buckled
			do_teleport(O, pick(global.endgame_safespawns))
			L.forceMove(O.loc)
		else
			do_teleport(L, pick(global.endgame_safespawns)) //dead-on precision
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
				if(AM.simulated && AM.invisibility <= INVISIBILITY_MAXIMUM)
					AM.singularity_pull(src, transit_range)
	return TRUE

/mob
	//thou shall always be able to see the rift
	var/image/riftimage = null

/mob/proc/see_rift(var/obj/effect/wormhole_exit/R)
	var/turf/T_mob = get_turf(src)
	if((R.z == get_z(T_mob)) && (get_dist(R,T_mob) <= (R.transit_range+10)) && !(R in view(T_mob)))
		if(!riftimage)
			riftimage = image('icons/obj/rift.dmi',T_mob,"rift",LIGHTING_LAYER+2,1)
			riftimage.mouse_opacity = 0
		var/new_x = 32 * (R.x - T_mob.x) + R.pixel_x
		var/new_y = 32 * (R.y - T_mob.y) + R.pixel_y
		riftimage.pixel_x = new_x
		riftimage.pixel_y = new_y
		riftimage.loc = T_mob
		direct_output(src, riftimage)
	else
		QDEL_NULL(riftimage)
