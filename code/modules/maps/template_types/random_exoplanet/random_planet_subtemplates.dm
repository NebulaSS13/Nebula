///Picks all ruins and tries to spawn them on the levels that make up the planet.
/datum/map_template/planetoid/random/proc/generate_features(var/datum/planetoid_data/gen_data, var/list/created_level_data, var/whitelist = template_tags_whitelist, var/blacklist = template_tags_blacklist)
	//#TODO: Properly handle generating ruins and sites on the various levels of the planet.
	var/datum/level_data/planetoid/surface_level = SSmapping.levels_by_id[gen_data.surface_level_id]
	//#TODO: dimensions and area have to be handled on a per level_data basis!!
	LAZYADD(gen_data.subtemplates, surface_level.spawn_subtemplates((gen_data._budget_override || subtemplate_budget), template_category, blacklist, whitelist))
