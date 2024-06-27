/datum/build_mode/room_builder
	name = "Room Builder"
	icon_state = "buildmode5"
	click_interactions = list(
		/decl/build_mode_interaction/room_builder/configure,
		/decl/build_mode_interaction/room_builder/set_corner/point_a,
		/decl/build_mode_interaction/room_builder/set_corner/point_b
	)
	var/turf/coordinate_A
	var/turf/coordinate_B
	var/floor_type = /turf/floor/plating
	var/wall_type  = /turf/wall

/datum/build_mode/room_builder/ShowAdditionalHelpText()
	to_chat(user, SPAN_NOTICE("As soon as both points have been selected, the room is created."))

/datum/build_mode/room_builder/Configurate()
	var/choice = alert("Would you like to set the floor or wall type?", name, "Floor", "Wall", "Cancel")
	switch(choice)
		if("Floor")
			floor_type = select_subpath(floor_type) || floor_type
			to_chat(user, SPAN_NOTICE("Floor type set to [floor_type]."))
		if("Wall")
			wall_type = select_subpath(wall_type) || wall_type
			to_chat(user, SPAN_NOTICE("Wall type set to [wall_type]."))

/datum/build_mode/room_builder/proc/make_rectangle(var/turf/A, var/turf/B, var/turf/wall_type, var/turf/floor_type)
	if(!A || !B) // No coords
		return
	if(A.z != B.z) // Not same z-level
		return

	var/height = A.y - B.y
	var/width = A.x - B.x
	var/z_level = A.z

	var/turf/lower_left_corner = null
	// First, try to find the lowest part
	var/desired_y = 0
	if(A.y <= B.y)
		desired_y = A.y
	else
		desired_y = B.y

	//Now for the left-most part.
	var/desired_x = 0
	if(A.x <= B.x)
		desired_x = A.x
	else
		desired_x = B.x

	lower_left_corner = locate(desired_x, desired_y, z_level)

	// Now we can begin building the actual room.  This defines the boundries for the room.
	var/low_bound_x = lower_left_corner.x
	var/low_bound_y = lower_left_corner.y

	var/high_bound_x = lower_left_corner.x + abs(width)
	var/high_bound_y = lower_left_corner.y + abs(height)

	for(var/i = low_bound_x, i <= high_bound_x, i++)
		for(var/j = low_bound_y, j <= high_bound_y, j++)
			var/turf/T = locate(i, j, z_level)
			if(i == low_bound_x || i == high_bound_x || j == low_bound_y || j == high_bound_y)
				if(ispath(wall_type, /turf))
					T.ChangeTurf(wall_type)
				else
					new wall_type(T)
			else
				if(ispath(floor_type, /turf))
					T.ChangeTurf(floor_type)
				else
					new floor_type(T)

/decl/build_mode_interaction/room_builder
	abstract_type = /decl/build_mode_interaction/room_builder

/decl/build_mode_interaction/room_builder/configure
	name        = "Right Click on Build Mode Button"
	description = "Change floor or wall type."
	dummy_interaction = TRUE

/decl/build_mode_interaction/room_builder/set_corner
	abstract_type = /decl/build_mode_interaction/room_builder/set_corner
	var/point_label

/decl/build_mode_interaction/room_builder/set_corner/Invoke(datum/build_mode/build_mode, atom/A, list/parameters)
	var/datum/build_mode/room_builder/room_mode = build_mode
	var/turf/click_turf = get_turf(A)
	if(istype(room_mode) && istype(click_turf))
		set_point(room_mode, click_turf)
		return TRUE
	return FALSE

/decl/build_mode_interaction/room_builder/set_corner/Initialize()
	description = "Select turf as [point_label]."
	return ..()

/decl/build_mode_interaction/room_builder/set_corner/proc/set_point(datum/build_mode/room_builder/room_mode, turf/point)
	to_chat(room_mode.user, SPAN_NOTICE("Defined [point] ([point.type]) as [point_label]."))
	if(!room_mode.coordinate_A || !room_mode.coordinate_B)
		return TRUE
	to_chat(room_mode.user, SPAN_NOTICE("Room coordinates set. Building room."))
	room_mode.make_rectangle(room_mode.coordinate_A, room_mode.coordinate_B, room_mode.wall_type, room_mode.floor_type)
	room_mode.Log("Created a room with wall type [room_mode.wall_type] and floor type [room_mode.floor_type] from [log_info_line(room_mode.coordinate_A)] to [log_info_line(room_mode.coordinate_B)]")
	room_mode.coordinate_A = null
	room_mode.coordinate_B = null
	return TRUE

/decl/build_mode_interaction/room_builder/set_corner/point_a
	point_label = "point A"
	trigger_params = list("left")

/decl/build_mode_interaction/room_builder/set_corner/point_a/set_point(datum/build_mode/room_builder/room_mode, turf/point)
	room_mode.coordinate_A = point
	return ..()

/decl/build_mode_interaction/room_builder/set_corner/point_b
	point_label = "point B"
	trigger_params = list("right")

/decl/build_mode_interaction/room_builder/set_corner/point_b/set_point(datum/build_mode/room_builder/room_mode, turf/point)
	room_mode.coordinate_B = point
	return ..()
