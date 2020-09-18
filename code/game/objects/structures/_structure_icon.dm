GLOBAL_LIST_INIT(default_blend_objects,   list(/obj/machinery/door, /turf/simulated/wall))
GLOBAL_LIST_INIT(default_noblend_objects, list(/obj/machinery/door/window, /obj/machinery/door/firedoor, /obj/machinery/door/blast))

/obj/structure
	var/handle_generic_blending

/obj/structure/on_update_icon()
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		update_material_colour()
	overlays.Cut()

/obj/structure/proc/can_visually_connect()
	return anchored && handle_generic_blending

/obj/structure/proc/can_visually_connect_to(var/obj/structure/S)
	return istype(S, src)

/obj/structure/proc/clear_connections()
	return

/obj/structure/proc/set_connections(dirs, other_dirs)
	return

/obj/structure/proc/refresh_neighbors()
	for(var/thing in RANGE_TURFS(src, 1))
		var/turf/T = thing
		T.update_icon()

/obj/structure/proc/find_blendable_obj_in_turf(var/turf/T, var/propagate)
	if(is_type_in_list(T, GLOB.default_blend_objects))
		if(propagate && istype(T, /turf/simulated/wall))
			for(var/turf/simulated/wall/W in RANGE_TURFS(T, 1))
				W.wall_connections = null
				W.other_connections = null
				W.queue_icon_update()
		return TRUE
	for(var/obj/O in T)
		if(!is_type_in_list(O, GLOB.default_blend_objects))
			continue
		if(is_type_in_list(O, GLOB.default_noblend_objects))
			continue
		return TRUE
	return FALSE

/obj/structure/proc/update_connections(propagate = 0)

	if(!can_visually_connect())
		clear_connections()
		return FALSE

	var/list/dirs
	var/list/other_dirs
	for(var/direction in GLOB.alldirs)
		var/turf/T = get_step(src, direction)
		if(T)
			for(var/obj/structure/S in T)
				if(can_visually_connect_to(S) && S.can_visually_connect())
					if(propagate)
						S.update_connections()
						S.update_icon()
					LAZYADD(dirs, direction)
			if((direction in GLOB.cardinal) && find_blendable_obj_in_turf(T, propagate))
				LAZYDISTINCTADD(dirs, direction)
				LAZYADD(other_dirs, direction)

	refresh_neighbors()
	set_connections(dirs, other_dirs)
	return TRUE