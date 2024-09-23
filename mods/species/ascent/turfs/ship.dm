/decl/flooring/plating/ascent
	icon_base = "curvy"
	icon = 'icons/turf/flooring/alium.dmi'

/decl/flooring/tiling_ascent
	name           = "floor"
	desc           = "An odd jigsaw puzzle of alloy plates."
	icon           = 'icons/turf/flooring/alium.dmi'
	icon_base      = "jaggy"
	has_base_range = 6
	color          = COLOR_GRAY40
	flooring_flags = TURF_CAN_BREAK | TURF_CAN_BURN
	footstep_type  = /decl/footsteps/tiles
	constructed    = TRUE

/turf/wall/ascent
	color = COLOR_PURPLE

/turf/wall/ascent/on_update_icon()
	. = ..()
	color = COLOR_PURPLE

/turf/wall/r_wall/ascent
	color = COLOR_PURPLE

/turf/wall/r_wall/ascent/on_update_icon()
	. = ..()
	color = COLOR_PURPLE

/turf/floor/shuttle_ceiling/ascent
	color = COLOR_PURPLE
	icon_state = "jaggy"
	icon = 'icons/turf/flooring/alium.dmi'

/turf/floor/ascent
	name = "mantid plating"
	color = COLOR_GRAY20
	initial_gas = list(/decl/material/gas/methyl_bromide = MOLES_CELLSTANDARD * 0.5, /decl/material/gas/oxygen = MOLES_CELLSTANDARD * 0.5)
	_base_flooring = /decl/flooring/plating/ascent
	icon_state = "curvy"
	icon = 'icons/turf/flooring/alium.dmi'

/turf/floor/ascent/Initialize()
	. = ..()
	icon_state = "curvy[rand(0,6)]"

/turf/floor/tiled/ascent
	name = "mantid tiling"
	icon_state = "jaggy"
	icon = 'icons/turf/flooring/alium.dmi'
	color = COLOR_GRAY40
	initial_gas = list(/decl/material/gas/methyl_bromide = MOLES_CELLSTANDARD * 0.5, /decl/material/gas/oxygen = MOLES_CELLSTANDARD * 0.5)
	_flooring = /decl/flooring/tiling_ascent
