
///Landmarks placed by random map generator
/obj/abstract/landmark/exoplanet_spawn
	name = "base exoplanet spawner"
	abstract_type = /obj/abstract/landmark/exoplanet_spawn

/obj/abstract/landmark/exoplanet_spawn/Initialize(ml)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/landmark/exoplanet_spawn/LateInitialize()
	. = ..()
	var/datum/planetoid_data/D = SSmapping.planetoid_data_by_z[z]
	if(istype(D))
		do_spawn(D)

/obj/abstract/landmark/exoplanet_spawn/proc/do_spawn(var/datum/planetoid_data/planet)
	CRASH("Implement do_spawn()")

////////////////////////////////////////////////////////////////////////////////
// Animal Spawner Landmark
////////////////////////////////////////////////////////////////////////////////
///Landmarks placed by random map generator
/obj/abstract/landmark/exoplanet_spawn/animal
	name = "spawn exoplanet animal"
	icon_state = "fauna_spawn"

/obj/abstract/landmark/exoplanet_spawn/animal/do_spawn(datum/planetoid_data/planet)
	if(!istype(planet))
		return
	planet.spawn_random_fauna(get_turf(src))

////////////////////////////////////////////////////////////////////////////////
// Megafauna Spawner Landmark
////////////////////////////////////////////////////////////////////////////////
/obj/abstract/landmark/exoplanet_spawn/megafauna
	name = "spawn exoplanet megafauna"
	icon_state = "megafauna_spawn"

/obj/abstract/landmark/exoplanet_spawn/megafauna/do_spawn(datum/planetoid_data/planet)
	if(!istype(planet))
		return
	planet.spawn_random_megafauna(get_turf(src))

/////////////////////////////////////////////////////////////////////////////////
// Flora Spawners Landmarks
/////////////////////////////////////////////////////////////////////////////////
// Landmarks placed by random map generator
/obj/abstract/landmark/exoplanet_spawn/plant
	name = "spawn exoplanet plant"
	icon_state = "flora_spawn"

/obj/abstract/landmark/exoplanet_spawn/plant/do_spawn(var/datum/planetoid_data/planet)
	if(!istype(planet) || !planet.has_flora())
		return
	planet.spawn_random_small_flora(get_turf(src))

/////////////////////////////////////////////////////////////////////////////////
// Large Flora Spawner Landmark
/////////////////////////////////////////////////////////////////////////////////
/obj/abstract/landmark/exoplanet_spawn/large_plant
	name = "spawn exoplanet large plant"
	icon_state = "bigflora_spawn"

/obj/abstract/landmark/exoplanet_spawn/large_plant/do_spawn(var/datum/planetoid_data/planet)
	if(!istype(planet) || !planet.flora)
		return
	planet.flora.spawn_random_big_flora(get_turf(src))