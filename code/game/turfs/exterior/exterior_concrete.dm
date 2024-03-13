/turf/floor/natural/concrete
	name = "concrete"
	desc = "A flat expanse of artificial stone-like artificial material."
	icon = 'icons/turf/exterior/concrete.dmi'
	material = /decl/material/solid/stone/concrete

/turf/floor/natural/concrete/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/floor/natural/concrete/reinforced
	name = "reinforced concrete"
	desc = "Stone-like artificial material. It has been reinforced with an unknown compound."

/turf/floor/natural/concrete/reinforced/Initialize(ml)
	LAZYDISTINCTADD(decals, "hexacrete")
	. = ..()

/turf/floor/natural/concrete/reinforced/damaged/LateInitialize()
	. = ..()
	set_floor_broken(TRUE)

/turf/floor/natural/concrete/reinforced/road
	name = "asphalt"
	color = COLOR_GRAY40
	base_color = COLOR_GRAY40
