
/datum/map_template/planetoid/proc/generate_features(var/datum/planetoid_data/gen_data, var/list/created_level_data, var/whitelist = ruin_tags_whitelist, var/blacklist = ruin_tags_blacklist)
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

	for(var/datum/level_data/planetoid/LD in created_level_data)
		if(prob(25))
			continue //Skip features on a given zlevel randomly
		var/level_budget = rand(1, my_budget) //Distribute feature budget randomly across levels
		my_budget -= level_budget
		possible_subtemplates -= gen_data.subtemplates //Remove those we already spawned
		LAZYADD(gen_data.subtemplates, LD.seed_ruins(level_budget, possible_subtemplates)) //#TODO: dimensions and area have to be handled on a per level_data basis!!

