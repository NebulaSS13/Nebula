///Random map generator for exo planets
/datum/map_template/planetoid/random/exoplanet
	name                  = "random exoplanet"
	abstract_type         = /datum/map_template/planetoid/random/exoplanet
	template_parent_type  = /datum/map_template/planetoid/random/exoplanet
	template_categories   = list(MAP_TEMPLATE_CATEGORY_EXOPLANET)
	ruin_category         = MAP_TEMPLATE_CATEGORY_EXOPLANET_SITE
	tallness              = 1
	level_data_type       = /datum/level_data/planetoid/exoplanet
	prefered_level_data_per_z = list(
		/datum/level_data/planetoid/exoplanet,
	)
	possible_themes = list(
		/datum/exoplanet_theme = 30,
		/datum/exoplanet_theme/mountains = 100,
		/datum/exoplanet_theme/radiation_bombing = 10,
		/datum/exoplanet_theme/ruined_city = 5,
		/datum/exoplanet_theme/robotic_guardians = 10
	)
