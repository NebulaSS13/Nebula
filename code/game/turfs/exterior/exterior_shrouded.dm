/turf/exterior/shrouded
	name = "packed sand"
	icon = 'icons/turf/flooring/shrouded.dmi'
	icon_state = "shrouded"
	dirt_color = "#3e3960"
	flooring_layers = /decl/flooring/shrouded

/decl/flooring/shrouded
	name = "packed sand"
	icon = 'icons/turf/flooring/shrouded.dmi'
	icon_base = "shrouded"
	desc = "Sand that has been packed into a solid surface."
	has_base_range = 8

/turf/exterior/shrouded/tar
	name = "tar"
	desc = "A pool of viscous and sticky tar."
	movement_delay = 12
	reagent_type = /decl/material/liquid/tar
	height = -(FLUID_SHALLOW)

