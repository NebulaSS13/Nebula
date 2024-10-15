/decl/flooring/seafloor
	name            = "sea floor"
	desc            = "A thick layer of silt and debris from above."
	icon            = 'icons/turf/flooring/seafloor.dmi'
	icon_base       = "seafloor"
	icon_edge_layer = FLOOR_EDGE_SEAFLOOR
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/sand
	gender          = NEUTER

/decl/flooring/shrouded
	name            = "packed sand"
	desc            = "Packed-down sand forming a solid layer."
	icon            = 'icons/turf/flooring/shrouded.dmi'
	icon_base       = "shrouded"
	dirt_color      = "#3e3960"
	has_base_range  = 8
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/sand

/decl/flooring/meat
	name            = "fleshy ground"
	desc            = "It's disgustingly soft to the touch. And warm. Too warm."
	icon            = 'icons/turf/flooring/flesh.dmi'
	icon_base       = "meat"
	color           = "#c40031"
	has_base_range  = null
	footstep_type   = /decl/footsteps/mud
	force_material  = /decl/material/solid/organic/meat

/decl/flooring/barren
	name            = "ground"
	desc            = "A stretch of bare, barren sand."
	icon            = 'icons/turf/flooring/barren.dmi'
	icon_base       = "barren"
	color           = COLOR_WHITE
	footstep_type   = /decl/footsteps/asteroid
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH
	icon_edge_layer = FLOOR_EDGE_BARREN
	force_material  = /decl/material/solid/soil
	growth_value    = 0.1

/decl/flooring/clay
	name            = "clay"
	desc            = "A stretch of thick, claggy clay."
	icon            = 'icons/turf/flooring/clay.dmi'
	icon_base       = "clay"
	icon_edge_layer = FLOOR_EDGE_CLAY
	footstep_type   = /decl/footsteps/mud
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/clay
	growth_value    = 1.2

/decl/flooring/ice
	name            = "ice"
	desc            = "A hard, slippery layer of frozen water."
	icon            = 'icons/turf/flooring/ice.dmi'
	icon_base       = "ice"
	footstep_type   = /decl/footsteps/plating
	color           = COLOR_LIQUID_WATER
	force_material  = /decl/material/solid/ice

/decl/flooring/ice/update_turf_icon(turf/floor/target)
	. = ..()
	if(istype(target))
		var/image/I = image(icon, "[icon_base]_shine")
		I.appearance_flags |= RESET_COLOR
		target.add_overlay(I)
