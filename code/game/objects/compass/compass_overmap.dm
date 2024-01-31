#define HEADER_SPEED_THRESHOLD 0.35

/obj/compass_holder/overmap
	compass_interval = 9
	var/image/compass_heading_marker
	var/obj/machinery/computer/ship/helm/owner

/obj/compass_holder/overmap/Initialize(mapload)

	owner = loc

	if(!istype(owner))
		PRINT_STACK_TRACE("Overmap compass initialized in non-helm atom: [type]")
		return INITIALIZE_HINT_QDEL

	var/owner_color = owner.linked?.color || COLOR_WHITE
	compass_heading_marker = new /image/compass_marker
	compass_heading_marker.maptext = STYLE_SMALLFONTS("<center>△</center>", 7, COLOR_WHITE)
	compass_heading_marker.add_filter("glow", 1, list(type = "drop_shadow", color = "[owner_color]aa", size = 2, offset = 1, x = 0, y = 0))
	compass_heading_marker.layer = HUD_BASE_LAYER
	compass_heading_marker.plane = HUD_PLANE
	compass_heading_marker.color = owner_color

	. = ..()

	var/turf/owner_turf = get_turf(owner.linked)
	if(!istype(owner_turf))
		hide_waypoints()
		return

	var/list/seen_waypoint_ids = list()
	for(var/key in owner.known_sectors)
		var/datum/computer_file/data/waypoint/R = owner.known_sectors[key]
		var/wp_id = "\ref[R]"
		set_waypoint(wp_id, uppertext(R.fields["name"]), R.fields["x"], R.fields["y"], owner_turf.z, R.fields["color"] || COLOR_SILVER)
		if(!R.fields["tracking"])
			hide_waypoint(wp_id)
		seen_waypoint_ids += wp_id
	for(var/id in compass_waypoints)
		if(!(id in seen_waypoint_ids))
			clear_waypoint(id)

/obj/compass_holder/overmap/Destroy()
	if(owner)
		if(owner.compass == src)
			owner.compass = null
		owner = null
	. = ..()

/obj/compass_holder/overmap/get_heading_strength()
	. = clamp(round(max(abs(owner.linked.speed[1]), abs(owner.linked.speed[2]))/(1/(20 SECONDS))), 0, 1)

/obj/compass_holder/overmap/get_heading_angle()
	return owner.linked.get_heading_angle()

/obj/compass_holder/overmap/get_string_from_angle(var/angle)
	return "[angle]"

/obj/compass_holder/overmap/get_compass_origin()
	return get_turf(owner.linked)

/obj/compass_holder/overmap/recalculate_heading(var/rebuild_icon = TRUE)
	var/heading_strength = get_heading_strength()
	if(heading_strength >= HEADER_SPEED_THRESHOLD)
		var/matrix/M = matrix()
		M.Translate(0, round((get_label_offset() - 35) * heading_strength))
		M.Turn(get_heading_angle())
		compass_heading_marker.transform = M
		compass_heading_marker.alpha = 255
	else
		compass_heading_marker.alpha = 0
	..()

/obj/compass_holder/overmap/on_update_icon()
	..()
	add_overlay(compass_heading_marker)

/obj/compass_holder/overmap/rebuild_overlay_lists(var/update_icon = FALSE)
	recalculate_heading(FALSE)
	. = ..()

// Don't show markers for stuff we are sitting on top of.
/obj/compass_holder/overmap/should_show(var/datum/compass_waypoint/wp)
	. = ..()
	if(.)
		var/turf/my_turf = get_compass_origin()
		var/turf/their_turf = locate(wp.x, wp.y, wp.z)
		return my_turf != their_turf

#undef HEADER_SPEED_THRESHOLD
