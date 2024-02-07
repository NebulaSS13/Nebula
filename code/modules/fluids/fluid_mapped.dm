
// Map helpers.
/obj/abstract/landmark/mapped_flood
	name = "mapped fluid area"
	alpha = FLUID_MAX_ALPHA
	icon_state = "ocean"
	color = COLOR_LIQUID_WATER
	var/fluid_type = /decl/material/liquid/water

/obj/abstract/landmark/mapped_flood/Initialize()
	..()
	var/turf/my_turf = get_turf(src)
	if(my_turf)
		my_turf.set_flooded(fluid_type)
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/mapped_fluid
	name = "mapped fluid area"
	alpha = FLUID_MIN_ALPHA
	icon_state = "shallow_still"
	color = COLOR_LIQUID_WATER

	var/fluid_type = /decl/material/liquid/water
	var/fluid_initial = FLUID_MAX_DEPTH

/obj/abstract/landmark/mapped_fluid/Initialize()
	..()
	var/turf/my_turf = get_turf(src)
	if(my_turf)
		my_turf.add_to_reagents(fluid_type, fluid_initial)
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/mapped_fluid/fuel
	name = "spilled fuel"
	fluid_type = /decl/material/liquid/fuel
	fluid_initial = 10
