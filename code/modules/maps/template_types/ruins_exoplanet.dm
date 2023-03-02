/datum/map_template/ruin/exoplanet
	prefix = "maps/random_ruins/exoplanet_ruins/"
	template_categories = list(MAP_TEMPLATE_CATEGORY_EXOPLANET_SITE)
	template_parent_type = /datum/map_template/ruin/exoplanet
	var/list/ruin_tags

/datum/map_template/ruin/exoplanet/get_ruin_tags()
	return ruin_tags
