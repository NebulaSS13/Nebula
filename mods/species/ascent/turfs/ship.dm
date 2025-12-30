/decl/flooring/plating/ascent
	icon_base      = "curvy"
	icon           = 'icons/turf/flooring/alium.dmi'
	burned_states  = null
	broken_states  = null
	uid            = "floor_ascent_plating"

/decl/flooring/tiling_ascent
	name           = "floor"
	desc           = "An odd jigsaw puzzle of alloy plates."
	icon           = 'icons/turf/flooring/alium.dmi'
	icon_base      = "jaggy"
	has_base_range = 6
	color          = COLOR_GRAY40
	footstep_type  = /decl/footsteps/tiles
	constructed    = TRUE
	burned_states  = null
	broken_states  = null
	uid            = "floor_ascent_tiled"

/turf/wall/ascent
	color          = COLOR_PURPLE

/turf/wall/ascent/on_update_icon()
	. = ..()
	color          = COLOR_PURPLE

/turf/wall/r_wall/ascent
	color          = COLOR_PURPLE

/turf/wall/r_wall/ascent/on_update_icon()
	. = ..()
	color          = COLOR_PURPLE

/turf/floor/shuttle_ceiling/ascent
	color          = COLOR_PURPLE
	icon_state     = "jaggy"
	icon           = 'icons/turf/flooring/alium.dmi'

/turf/floor/ascent
	name           = "mantid plating"
	color          = COLOR_GRAY20
	_base_flooring = /decl/flooring/plating/ascent
	icon_state     = "curvy"
	icon           = 'icons/turf/flooring/alium.dmi'
	initial_gas    = list(
		/decl/material/gas/methyl_bromide = MOLES_CELLSTANDARD * 0.5,
		/decl/material/gas/oxygen         = MOLES_CELLSTANDARD * 0.5
	)

/turf/floor/ascent/Initialize()
	. = ..()
	icon_state     = "curvy[rand(0,6)]"

/turf/floor/tiled/ascent
	name           = "mantid tiling"
	icon           = 'icons/turf/flooring/alium.dmi'
	icon_state     = "jaggy"
	color          = COLOR_GRAY40
	_flooring      = /decl/flooring/tiling_ascent
	initial_gas    = list(
		/decl/material/gas/methyl_bromide = MOLES_CELLSTANDARD * 0.5,
		/decl/material/gas/oxygen         = MOLES_CELLSTANDARD * 0.5
	)
