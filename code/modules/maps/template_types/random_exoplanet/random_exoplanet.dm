///Random map generator for exo planets
/datum/map_template/planetoid/exoplanet
	name                 = "random exoplanet"
	template_categories  = list(MAP_TEMPLATE_CATEGORY_EXOPLANET)
	template_parent_type = /datum/map_template/planetoid
	level_data_type      = /datum/level_data/planetoid/exoplanet
	possible_themes      = list(
		/datum/exoplanet_theme = 30,
		/datum/exoplanet_theme/mountains = 100,
		/datum/exoplanet_theme/radiation_bombing = 10,
		/datum/exoplanet_theme/ruined_city = 5,
		/datum/exoplanet_theme/robotic_guardians = 10
	)

/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/effects/wind/wind_4_2.ogg',
		'sound/effects/wind/wind_5_1.ogg'
	)
	always_unpowered = TRUE
	area_flags = AREA_FLAG_IS_BACKGROUND | AREA_FLAG_EXTERNAL | AREA_FLAG_HIDE_FROM_HOLOMAP
	is_outside = OUTSIDE_YES