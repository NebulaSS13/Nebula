///Picks all ruins and tries to spawn them on the levels that make up the planet.
/datum/map_template/planetoid/random/proc/generate_features(var/datum/planetoid_data/gen_data, var/list/created_level_data, var/whitelist = ruin_tags_whitelist, var/blacklist = ruin_tags_blacklist)
	var/my_budget = gen_data._budget_override || subtemplate_budget
	if(my_budget <= 0)
		return

	var/list/possible_subtemplates = list()
	var/list/ruins = SSmapping.get_templates_by_category(ruin_category)
	for(var/ruin_name in ruins)
		var/datum/map_template/ruin = ruins[ruin_name]
		var/ruin_tags = ruin.get_ruin_tags()
		if(whitelist && !(whitelist & ruin_tags))
			continue
		if(blacklist & ruin_tags)
			continue
		possible_subtemplates += ruin

	if(!length(possible_subtemplates))
		return //If we don't have any ruins, don't bother

	//#TODO: Properly handle generating ruins and sites on the various levels of the planet.
	var/datum/level_data/planetoid/surface_level = SSmapping.levels_by_id[gen_data.surface_level_id]
	//#TODO: dimensions and area have to be handled on a per level_data basis!!
	LAZYADD(gen_data.subtemplates, surface_level.seed_ruins(my_budget, possible_subtemplates))
