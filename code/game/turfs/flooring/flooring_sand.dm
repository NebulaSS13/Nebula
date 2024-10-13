/decl/flooring/sand
	name            = "sand"
	desc            = "A fine layer of silica. It's coarse and gets everywhere."
	footstep_type   = /decl/footsteps/sand
	icon            = 'icons/turf/flooring/sand.dmi'
	icon_base       = "sand"
	icon_edge_layer = FLOOR_EDGE_SAND
	has_base_range  = 4
	turf_flags      = TURF_FLAG_BACKGROUND | TURF_IS_HOLOMAP_PATH | TURF_FLAG_ABSORB_LIQUID
	force_material  = /decl/material/solid/sand

/decl/flooring/sand/fire_act(turf/floor/target, datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((exposed_temperature > T0C + 1700 && prob(5)) || exposed_temperature > T0C + 3000)
		if(target.get_topmost_flooring() == src)
			target.set_flooring(/decl/flooring/melted_sand)
			. = TRUE
		if(target.get_base_flooring() == src)
			target.set_base_flooring(/decl/flooring/melted_sand)
			. = TRUE
	return . || ..()

/decl/flooring/sand/chlorine
	name            = "chlorinated sand"
	desc            = "Sand that has been heavily contaminated by chlorine."
	icon            = 'icons/turf/flooring/chlorine_sand.dmi'
	icon_base       = "chlorine"
	has_base_range  = 11
	icon_edge_layer = FLOOR_EDGE_CHLORINE_SAND
	color           = "#d2e0b7"
	dirt_color      = "#d2e0b7"
	footstep_type   = /decl/footsteps/sand

/decl/flooring/sand/chlorine/marsh
	name            = "chlorine marsh"
	desc            = "A pool of noxious liquid chlorine. It's full of silt and plant matter."

/decl/flooring/sand/fake
	name            = "holosand"
	desc            = "Uncomfortably coarse and gritty for a hologram."
	holographic     = TRUE

/decl/flooring/fake_space
	name            = "\proper space"
	desc            = "The final frontier."
	icon            = 'icons/turf/flooring/fake_space.dmi'
	icon_base       = "space"
	has_base_range  = 25
	holographic     = TRUE
	gender          = NEUTER

/decl/flooring/melted_sand
	name            = "molten silica"
	desc            = "A patch of sand that has been fused into glass by extreme temperature."
	icon            = 'icons/turf/flooring/sand.dmi'
	icon_base       = "glass"
	has_base_range  = null
	force_material  = /decl/material/solid/glass
