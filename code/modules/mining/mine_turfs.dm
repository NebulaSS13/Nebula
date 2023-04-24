/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = 1
	opacity = 1
	turf_flags = TURF_IS_HOLOMAP_OBSTACLE

/**********************Asteroid**************************/
// Setting icon/icon_state initially will use these values when the turf is built on/replaced.
// This means you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	base_name = "sand"
	base_desc = "Gritty and unpleasant."
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"
	footstep_type = /decl/footsteps/asteroid
	initial_flooring = null
	initial_gas = null
	temperature = TCMB
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH

	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug //#TODO: This should probably be generalised?
	var/overlay_detail

/turf/simulated/floor/asteroid/Initialize()
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"
	. = ..()
	var/datum/level_data/mining_level/level = SSmapping.levels_by_z[z]
	if(istype(level))
		LAZYADD(level.mining_turfs, src)

/turf/simulated/floor/asteroid/Destroy()
	var/datum/level_data/mining_level/level = SSmapping.levels_by_z[z]
	if(istype(level))
		LAZYREMOVE(level.mining_turfs, src)
	return ..()

/turf/simulated/floor/asteroid/explosion_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1 || (severity == 2 && prob(70)))
		gets_dug()

/turf/simulated/floor/asteroid/is_plating()
	return !density

//#TODO: This should probably be generalised?
/turf/simulated/floor/asteroid/attackby(obj/item/W, mob/user)
	if(!W || !user)
		return 0

	var/list/usable_tools = list(
		/obj/item/shovel,
		/obj/item/pickaxe/diamonddrill,
		/obj/item/pickaxe/drill,
		/obj/item/pickaxe/borgdrill
		)

	var/valid_tool
	for(var/valid_type in usable_tools)
		if(istype(W,valid_type))
			valid_tool = 1
			break

	if(valid_tool)
		if (dug)
			to_chat(user, "<span class='warning'>This area has already been dug</span>")
			return TRUE

		var/turf/T = user.loc
		if (!(istype(T)))
			return

		to_chat(user, "<span class='warning'>You start digging.</span>")
		playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)
		. = TRUE

		if(!do_after(user,40, src)) return

		to_chat(user, "<span class='notice'>You dug a hole.</span>")
		gets_dug()

	else if(istype(W,/obj/item/storage/ore)) //#FIXME: Its kinda silly to put this in a specific turf's subtype's attackby.
		var/obj/item/storage/ore/S = W
		if(S.collection_mode)
			for(var/obj/item/stack/material/ore/O in contents)
				return O.attackby(W,user)
	else if(istype(W,/obj/item/storage/bag/fossils))
		var/obj/item/storage/bag/fossils/S = W
		if(S.collection_mode)
			for(var/obj/item/fossil/F in contents)
				return F.attackby(W,user)

	else
		return ..(W,user)

//#TODO: This should probably be generalised?
/turf/simulated/floor/asteroid/proc/gets_dug()
	if(dug)
		return
	LAZYADD(., new /obj/item/stack/material/ore/glass(src, (rand(3) + 2)))
	dug = TRUE
	icon_state = "asteroid_dug"

//#TODO: This should probably be generalised?
/turf/simulated/floor/asteroid/proc/updateMineralOverlays(var/update_neighbors)

	overlays.Cut()

	var/list/step_overlays = list("n" = NORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)
	for(var/direction in step_overlays)

		if(isspaceturf(get_step(src, step_overlays[direction])))
			var/image/aster_edge = image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = step_overlays[direction])
			aster_edge.layer = DECAL_LAYER
			overlays += aster_edge

	if(overlay_detail)
		var/image/floor_decal = image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)
		floor_decal.layer = DECAL_LAYER
		overlays |= floor_decal

	if(update_neighbors)
		var/list/all_step_directions = list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
		for(var/direction in all_step_directions)
			var/turf/simulated/floor/asteroid/A
			if(istype(get_step(src, direction), /turf/simulated/floor/asteroid))
				A = get_step(src, direction)
				A.updateMineralOverlays()

//#TODO: This should probably be generalised?
/turf/simulated/floor/asteroid/Entered(atom/movable/M)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(R.module)
			if(istype(R.module_state_1,/obj/item/storage/ore))
				attackby(R.module_state_1,R)
			else if(istype(R.module_state_2,/obj/item/storage/ore))
				attackby(R.module_state_2,R)
			else if(istype(R.module_state_3,/obj/item/storage/ore))
				attackby(R.module_state_3,R)
			else
				return
