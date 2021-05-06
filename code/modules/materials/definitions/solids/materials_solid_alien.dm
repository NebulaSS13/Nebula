/decl/material/solid/metal/aliumium
	name = "alien alloy"
	icon_base = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	hidden_from_codex = TRUE
	value = 2.5
	default_solid_form = /obj/item/stack/material/cubes

/decl/material/solid/metal/aliumium/New()
	icon_base = 'icons/turf/walls/metal.dmi'
	color = rgb(rand(10,150),rand(10,150),rand(10,150))
	explosion_resistance = rand(25,40)
	brute_armor = rand(10,20)
	burn_armor = rand(10,20)
	hardness = rand(15,100)
	reflectiveness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,11000)
	..()

/decl/material/solid/metal/aliumium/place_dismantled_girder(var/turf/target, var/decl/material/reinf_material)
	return