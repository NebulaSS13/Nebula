/turf/exterior
	name = "ground"
	icon = 'icons/turf/flooring/barren.dmi'
	footstep_type = /decl/footsteps/asteroid
	icon_state = "barren"
	layer = PLATING_LAYER
	open_turf_type = /turf/open
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH
	zone_membership_candidate = TRUE
	var/dirt_color = "#7c5e42"
	var/decl/material/material

	/// Whether or not sand/clay has been dug up here.
	var/dug = FALSE
	var/reagent_type
	var/height = 0

/turf/exterior/clear_diggable_resources()
	dug = TRUE
	..()

/turf/exterior/has_been_dug()
	return dug

/turf/exterior/is_plating()
	return !density

/turf/exterior/can_engrave()
	return FALSE
