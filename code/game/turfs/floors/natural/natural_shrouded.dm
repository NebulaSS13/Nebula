/turf/floor/natural/shrouded
	name = "packed sand"
	icon = 'icons/turf/flooring/shrouded.dmi'
	desc = "Sand that has been packed in to solid earth."
	dirt_color = "#3e3960"
	possible_states = 8
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	material = /decl/material/solid/sand
	is_fundament_turf = TRUE

/turf/floor/natural/shrouded/get_plant_growth_rate()
	return 0.5

/turf/floor/natural/shrouded/tar
	name = "tar"
	desc = "A pool of viscous and sticky tar."
	movement_delay = 12
	reagent_type = /decl/material/liquid/tar
	height = -(FLUID_SHALLOW)
