/decl/material/solid/metal/aliumium
	name = "alien alloy"
	uid = "solid_alien"
	icon_base = 'icons/turf/walls/metal.dmi'
	wall_flags = PAINT_PAINTABLE
	door_icon_base = "metal"
	icon_reinf = 'icons/turf/walls/reinforced_metal.dmi'
	hitsound = 'sound/weapons/smash.ogg'
	construction_difficulty = MAT_VALUE_VERY_HARD_DIY
	hidden_from_codex = TRUE
	value = 2.5
	default_solid_form = /obj/item/stack/material/cubes
	exoplanet_rarity_plant = MAT_RARITY_EXOTIC
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/metal/aliumium/Initialize()
	icon_base = 'icons/turf/walls/metal.dmi'
	wall_flags = PAINT_PAINTABLE
	color = rgb(rand(10,150),rand(10,150),rand(10,150))
	explosion_resistance = rand(25,40)
	brute_armor = rand(10,20)
	burn_armor = rand(10,20)
	hardness = rand(15,100)
	reflectiveness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,11000)
	. = ..()

/decl/material/solid/metal/aliumium/place_dismantled_girder(var/turf/target, var/decl/material/reinf_material)
	return