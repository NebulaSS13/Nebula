/turf/exterior/concrete
	name = "concrete"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete"
	flooring_layers = /decl/flooring/concrete

/decl/flooring/concrete
	name = "concrete"
	icon_base = "concrete"
	desc = "A flat expanse of artificial stone-like material."
	icon = 'icons/turf/flooring/concrete.dmi'

/turf/exterior/concrete/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/exterior/concrete/reinforced
	name = "reinforced concrete"
	flooring_layers = /decl/flooring/concrete/reinforced

/decl/flooring/concrete/reinforced
	name = "reinforced concrete"
	desc = "Stone-like artificial material. It has been reinforced with an unknown compound."

/turf/exterior/concrete/reinforced/Initialize(ml)
	LAZYDISTINCTADD(decals, "hexacrete")
	. = ..()

/turf/exterior/concrete/reinforced/damaged
	_broken = "0"

/turf/exterior/concrete/reinforced/road
	name = "asphalt"
	color = COLOR_GRAY40
	flooring_layers = /decl/flooring/concrete/reinforced/road

/decl/flooring/concrete/reinforced/road
	name = "asphalt"
	color = COLOR_GRAY40
