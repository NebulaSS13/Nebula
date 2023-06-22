/datum/map_template/ruin/away_site
	prefix = "maps/away/"
	template_categories = list(MAP_TEMPLATE_CATEGORY_AWAYSITE)
	template_parent_type = /datum/map_template/ruin/away_site
	var/spawn_weight = 1

/datum/map_template/ruin/away_site/get_spawn_weight()
	return spawn_weight
