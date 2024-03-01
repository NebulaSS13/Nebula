/decl/flooring/chlorine
	name = "chlorine marsh"
	icon = 'icons/turf/flooring/water_still.dmi'
	desc = "A pool of noxious liquid chlorine. It's full of silt and plant matter."
	color = "#d2e0b7"
	icon_base = "water"
	can_engrave = FALSE

/turf/exterior/chlorine_sand
	name = "chlorinated sand"
	icon = 'icons/turf/flooring/chlorine_sand.dmi'
	icon_state = "chlorine"
	dirt_color = "#d2e0b7"
	flooring_layers = /decl/flooring/chlorine_sand

/decl/flooring/chlorine_sand
	name = "chlorinated sand"
	desc = "Sand that has been heavily contaminated by chlorine."
	color = "#d2e0b7"
	icon = 'icons/turf/flooring/chlorine_sand.dmi'
	icon_base = "chlorine"
	icon_edge_layer = EXT_EDGE_CHLORINE_SAND
	footstep_type = /decl/footsteps/sand
	has_base_range = 11
	can_engrave = FALSE

/turf/exterior/chlorine_sand/marsh
	name = "chlorine marsh"
	desc = "A pool of noxious liquid chlorine. It's full of silt and plant matter."
	reagent_type = /decl/material/gas/chlorine
	height = -(FLUID_SHALLOW)

