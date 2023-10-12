/datum/map/planet_testing
	name           = "Planets Testing"
	full_name      = "Planets Testing"
	path           = "planets_testing"
	overmap_ids    = list(OVERMAP_ID_SPACE)
	allowed_latejoin_spawns = list()
	default_spawn  = null

/datum/map/planet_testing/build_planets()
	report_progress("Instantiating planets...")

	//Spawn all templates once
	spawn_planet_templates(list_values(get_all_planet_templates()))
	// Place an observer landmark just to appease CI and on the off-chance that anyone ever wants to observer.
	new /obj/abstract/landmark/latejoin/observer(locate(round(world.maxx/2), round(world.maxy/2), world.maxz))
	report_progress("Finished instantiating planets.")

