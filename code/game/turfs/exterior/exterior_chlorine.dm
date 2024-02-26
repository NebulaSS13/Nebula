/turf/exterior/chlorine_sand
	name = "chlorinated sand"
	desc = "Sand that has been heavily contaminated by chlorine."
	icon = 'icons/turf/exterior/chlorine_sand.dmi'
	possible_states = 11
	icon_edge_layer = EXT_EDGE_CHLORINE_SAND
	dirt_color = "#d2e0b7"
	footstep_type = /decl/footsteps/sand

/turf/exterior/chlorine_sand/marsh
	name = "chlorine marsh"
	desc = "A pool of noxious liquid chlorine. It's full of silt and plant matter."
	reagent_type = /decl/material/gas/chlorine
	height = -(FLUID_SHALLOW)
