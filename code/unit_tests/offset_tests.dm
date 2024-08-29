/datum/unit_test/wall_objs_shall_face_proper_dir
	name = "MAP: Wall mounted objects must face proper direction"
	var/static/list/exception_types = list(
		/obj/structure/sign/directions, // TODO: remove once directional/rotated subtypes have been created
		/obj/structure/emergency_dispenser // these are just kind of fucked, i'll leave it to someone else to make the presets match the directional offsets
	)

/datum/unit_test/wall_objs_shall_face_proper_dir/start_test()
	var/bad_objs = 0
	for(var/obj/structure in world) // includes machinery, structures, and anchored items
		if(QDELETED(structure))
			continue
		if(!isStationLevel(structure.z))
			continue
		if(is_type_in_list(structure, exception_types))
			continue
		if(!structure.anchored)
			continue
		if(!isturf(structure.loc))
			continue
		if(!length(structure.directional_offset)) // does not need to be offset
			continue
		var/list/diroff = cached_json_decode(structure.directional_offset)
		var/list/curoff = diroff["[uppertext(dir2text(structure.dir))]"]
		if(!curoff) // uh oh!
			continue
		// If the offset is unset or 0, it's allowed to be whatever.
		// If it's nonzero, it must match the sign.
		if(
			(curoff["x"] && (SIGN(curoff["x"]) != SIGN(structure.pixel_x))) || \
			(curoff["y"] && (SIGN(curoff["y"]) != SIGN(structure.pixel_y)))
		)
			bad_objs++
			log_bad("Incorrect offset direction: [log_info_line(structure)]")
			continue

	if(bad_objs)
		fail("Found [bad_objs] wall-mounted object\s with incorrect directions")
	else
		pass("All wall-mounted objects have correct directions")
	return TRUE

/datum/unit_test/wall_objs_shall_offset_onto_wall
	name = "MAP: Wall mounted objects must offset over walls"
	var/static/list/exception_types = list(
		/obj/machinery/light,
		/obj/machinery/camera,
		/obj/structure/lift/button/standalone,
		/obj/structure/hygiene/sink
	)

/datum/unit_test/wall_objs_shall_offset_onto_wall/start_test()
	var/bad_objs = 0
	for(var/obj/structure in world) // includes machinery, structures, and anchored items
		if(QDELETED(structure))
			continue
		if(!isStationLevel(structure.z))
			continue
		if(is_type_in_list(structure, exception_types))
			continue
		if(!structure.anchored)
			continue
		if(!isturf(structure.loc))
			continue
		if(!length(structure.directional_offset)) // does not need to be offset
			continue
		var/list/diroff = cached_json_decode(structure.directional_offset)
		var/list/curoff = diroff["[uppertext(dir2text(structure.dir))]"]
		if(!curoff) // structure is not offset in this dir at all
			continue
		if(structure.loc.density)
			bad_objs++
			log_bad("Wall-mounted object on dense turf: [log_info_line(structure)]")
			continue
		var/adj_x = structure.x + (abs(structure.pixel_x) > 12 ? SIGN(structure.pixel_x) : 0)
		var/adj_y = structure.y + (abs(structure.pixel_y) > 12 ? SIGN(structure.pixel_y) : 0)
		var/turf/adjusted_loc = locate(adj_x, adj_y, structure.z)
		if(!adjusted_loc.density)
			var/found_support = FALSE
			for(var/obj/structure/S in adjusted_loc)
				if(!S.density) // this will be way too forgiving with windows since it doesn't take into account directionality
					continue
				found_support = TRUE
			if(found_support)
				continue
			bad_objs++
			log_bad("Offset turf did not have a wall or window: [log_info_line(structure)]")

	if(bad_objs)
		fail("Found [bad_objs] wall-mounted object\s without a wall or window")
	else
		pass("All wall-mounted objects are on appropriate walls/windows")
	return TRUE