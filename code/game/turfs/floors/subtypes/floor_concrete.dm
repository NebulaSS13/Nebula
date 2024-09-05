/turf/floor/concrete
	name = "concrete"
	desc = "A flat expanse of artificial stone-like artificial material."
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "inset"
	initial_flooring = null
//	material = /decl/material/solid/stone/concrete

	base_name = "concrete"
	base_desc = "A flat expanse of artificial stone-like artificial material."
	base_icon = 'icons/turf/flooring/concrete.dmi'
	base_icon_state = "inset"

/turf/floor/concrete/smooth
	icon_state = "concrete"
	base_icon_state = "concrete"

/turf/floor/concrete/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/floor/concrete/reinforced
	name = "reinforced concrete"
	desc = "Stone-like artificial material. It has been reinforced with an unknown compound."
	icon_state = "hexacrete"
	base_name = "reinforced concrete"
	base_desc = "Stone-like artificial material. It has been reinforced with an unknown compound."
	base_icon_state = "hexacrete"

/turf/floor/concrete/reinforced/damaged/LateInitialize()
	. = ..()
	set_floor_broken(TRUE)

/turf/floor/concrete/reinforced/road
	name = "asphalt"
	color = COLOR_GRAY40
	icon_state = "concrete"
	base_color = COLOR_GRAY40
	base_icon_state = "concrete"
