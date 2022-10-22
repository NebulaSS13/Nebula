/obj/effect/overmap/visitable/sector/exoplanet/meat
	name = "organic exoplanet"
	desc = "An exoplanet made entirely of organic matter."
	color = "#ac4653"
	planetary_area = /area/exoplanet/meat
	rock_colors = list(COLOR_OFF_WHITE, "#f3ebd4", "#f3d4f0")
	plant_colors = list("#924585", "#f37474", "#eb9ee4", "#4e348b")
	map_generators = list(/datum/random_map/noise/exoplanet/meat, /datum/random_map/noise/ore/poor)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_HUMAN|RUIN_WATER
	surface_color = "#e2768d"
	water_color = "#c7c27c"
	water_material = /decl/material/liquid/acid/stomach
	ice_material =   /decl/material/liquid/acid/stomach
	flora_diversity = 3
	fauna_types = list(
		/mob/living/simple_animal/hostile/retaliate/jelly/alt,
		/mob/living/simple_animal/hostile/leech
	)
	spawn_weight = 10	// meat

/obj/effect/overmap/visitable/sector/exoplanet/meat/generate_map()
	lightlevel = rand(1,7)/10
	..()

/obj/effect/overmap/visitable/sector/exoplanet/meat/get_target_temperature()
	return T20C + rand(10, 20)

/obj/effect/overmap/visitable/sector/exoplanet/meat/select_strata()
	crust_strata = /decl/strata/sedimentary

/obj/effect/overmap/visitable/sector/exoplanet/meat/adapt_seed(var/datum/seed/S)
	..()
	S.set_trait(TRAIT_CARNIVOROUS,2)
	if(prob(75))
		S.get_trait(TRAIT_STINGS, 1)

	LAZYSET(S.chems, /decl/material/liquid/nutriment/protein, list(10,30))
	LAZYSET(S.chems, /decl/material/liquid/blood, list(5,10))
	LAZYSET(S.chems, /decl/material/liquid/acid/stomach, list(5,10))

	S.set_trait(TRAIT_PARASITE,1)

	if(prob(40))
		S.set_trait(TRAIT_SPREAD,2)
	else
		S.set_trait(TRAIT_SPREAD,1)

/datum/random_map/noise/exoplanet/meat
	descriptor = "meat exoplanet"
	smoothing_iterations = 3
	flora_prob = 5
	large_flora_prob = 0
	megafauna_spawn_prob = 2 //Remember to change this if more types are added.
	water_level_max = 3
	water_level_min = 2
	land_type = /turf/exterior/meat
	water_type = /turf/exterior/water/stomach

/area/exoplanet/meat
	forced_ambience = list("sound/ambience/spookyspace1.ogg", "sound/ambience/spookyspace2.ogg")
	base_turf = /turf/exterior/meat

/turf/exterior/meat
	name = "fleshy ground"
	icon = 'icons/turf/exterior/flesh.dmi'
	desc = "It's disgustingly soft to the touch. And warm. Too warm."
	dirt_color = "#c40031"
	footstep_type = /decl/footsteps/mud
	
/turf/exterior/water/stomach
	name = "juices"
	desc = "Half-digested chunks of vines are floating in the puddle of some liquid."
	gender = PLURAL
	icon = 'icons/turf/exterior/water_still.dmi'
	reagent_type = /decl/material/liquid/acid/stomach
	color = "#c7c27c"
	dirt_color = "#c40031"
