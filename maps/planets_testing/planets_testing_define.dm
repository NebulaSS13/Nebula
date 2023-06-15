/datum/map/planet_testing
	name           = "Planets Testing"
	full_name      = "Planets Testing"
	path           = "planets_testing"
	overmap_ids    = list(OVERMAP_ID_SPACE)
	allowed_spawns = list()
	default_spawn  = null

/datum/map/planet_testing/build_planets()
	report_progress("Instantiating planets...")

	//Spawn all templates once
	spawn_planet_templates(list_values(get_all_planet_templates()))

	report_progress("Finished instantiating planets.")

