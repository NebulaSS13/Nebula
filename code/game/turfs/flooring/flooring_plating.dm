/decl/flooring/plating
	name           = "plating"
	desc           = "A layer of rough, undecorated steel plates."
	icon           = 'icons/turf/flooring/plating.dmi'
	icon_base      = "plating"
	floor_layer    = PLATING_LAYER
	force_material = /decl/material/solid/metal/steel
	constructed    = TRUE
	burned_states = list(
		"burned0",
		"burned1"
	)
	broken_states = list(
		"broken0",
		"broken1",
		"broken2",
		"broken3",
		"broken4"
	)
	uid            = "floor_plating"
