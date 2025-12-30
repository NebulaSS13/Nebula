#define MAP_TEMPLATE_CATEGORY_FANTASY_GRASSLAND "template_fantasy_grassland"
#define MAP_TEMPLATE_CATEGORY_FANTASY_SWAMP     "template_fantasy_swamp"
#define MAP_TEMPLATE_CATEGORY_FANTASY_WOODS     "template_fantasy_woods"
#define MAP_TEMPLATE_CATEGORY_FANTASY_DOWNLANDS "template_fantasy_downlands"
#define MAP_TEMPLATE_CATEGORY_FANTASY_DUNGEON   "template_fantasy_dungeon"
#define MAP_TEMPLATE_CATEGORY_FANTASY_CAVERNS   "template_fantasy_caverns"

/datum/map_template/fantasy
	abstract_type = /datum/map_template/fantasy
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS
	area_usage_test_exempted_root_areas = list(
		/area/fantasy/outside/point_of_interest
	)
	var/cost = 1

/datum/map_template/fantasy/get_template_cost()
	return cost

/datum/map/New()
	LAZYSET(apc_test_exempt_areas, /area/fantasy, NO_SCRUBBER|NO_VENT|NO_APC)
	..()

/area/fantasy
	abstract_type = /area/fantasy
	allow_xenoarchaeology_finds = FALSE
	icon = 'mods/content/fantasy/icons/areas.dmi'
	icon_state = "area"
	base_turf = /turf/floor/rock/basalt
	sound_env = GENERIC
	ambience = list()

/area/fantasy/outside
	name = "\improper Wilderness"
	abstract_type = /area/fantasy/outside
	color = COLOR_GREEN
	is_outside = OUTSIDE_YES
	sound_env = PLAIN
	ambience = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/effects/wind/wind_4_2.ogg',
		'sound/effects/wind/wind_5_1.ogg'
	)
	interior_ambient_light_modifier = -0.4
	area_flags = AREA_FLAG_EXTERNAL | AREA_FLAG_IS_BACKGROUND

/area/fantasy/outside/point_of_interest
	name = "Point Of Interest"
	description = null
	area_blurb_category = /area/fantasy/outside/point_of_interest
