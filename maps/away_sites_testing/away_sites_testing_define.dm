
/datum/map/away_sites_testing
	name = "Away Sites Testing"
	full_name = "Away Sites Testing Land"
	path = "away_sites_testing"
	overmap_ids = list(OVERMAP_ID_SPACE)

	allowed_latejoin_spawns = list()
	default_spawn = null

// Set the observer spawn to include every flag so that CI flag checks pass.
/decl/spawnpoint/observer
	spawn_flags = (SPAWN_FLAG_GHOSTS_CAN_SPAWN | SPAWN_FLAG_JOBS_CAN_SPAWN | SPAWN_FLAG_PRISONERS_CAN_SPAWN | SPAWN_FLAG_PERSISTENCE_CAN_SPAWN)

/datum/map/away_sites_testing/build_away_sites()
	var/list/unsorted_sites = list_values(SSmapping.get_templates_by_category(MAP_TEMPLATE_CATEGORY_AWAYSITE))
	var/list/sorted_sites = sortTim(unsorted_sites, /proc/cmp_sort_templates_tallest_to_shortest)
	for (var/datum/map_template/A in sorted_sites)
		A.load_new_z(centered = FALSE)
		testing("Spawning [A] in [english_list(SSmapping.get_connected_levels(world.maxz))]")
		if(A.template_flags & TEMPLATE_FLAG_TEST_DUPLICATES)
			A.load_new_z(centered = FALSE)
			testing("Spawning [A] in [english_list(SSmapping.get_connected_levels(world.maxz))]")

/proc/cmp_sort_templates_tallest_to_shortest(var/datum/map_template/a, var/datum/map_template/b)
	return b.tallness - a.tallness
