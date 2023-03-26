/turf/exterior/barren
	name = "ground"
	icon_state = "barren"
	flooring_layers = /decl/flooring/barren

/decl/flooring/barren
	name = "ground"
	icon_base = "barren"
	icon = 'icons/turf/flooring/barren.dmi'
	icon_edge_layer = EXT_EDGE_BARREN

/decl/flooring/barren/apply_appearance_to(var/turf/target)
	..()
	if(prob(20))
		return
	target.decals = list(image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))
