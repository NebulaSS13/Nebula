/turf/floor/concrete
	name           = "concrete"
	icon           = 'icons/turf/flooring/concrete.dmi'
	icon_state     = "inset"
	_flooring      = /decl/flooring/concrete
	_base_flooring = /decl/flooring/dirt
	floor_material = /decl/material/solid/stone/concrete

/turf/floor/concrete/smooth
	icon_state = "concrete"

/turf/floor/concrete/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/floor/concrete/reinforced
	name = "reinforced concrete"
	icon_state = "hexacrete"
	_flooring = /decl/flooring/concrete/reinforced

/turf/floor/concrete/reinforced/damaged/LateInitialize()
	. = ..()
	set_floor_broken(TRUE)

/turf/floor/concrete/reinforced/road
	name = "asphalt"
	color = COLOR_GRAY40
	icon_state = "concrete"
	_flooring = /decl/flooring/concrete/asphalt
