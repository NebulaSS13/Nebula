/area/shaded_hills
	abstract_type = /area/shaded_hills
	icon = 'maps/shaded_hills/areas/icons.dmi'
	icon_state = "area"

/area/shaded_hills/outside
	name = "Grasslands"
	color = COLOR_GREEN
	is_outside = OUTSIDE_YES
	ambience = list(
		'sound/effects/wind/wind_2_1.ogg',
		'sound/effects/wind/wind_2_2.ogg',
		'sound/effects/wind/wind_3_1.ogg',
		'sound/effects/wind/wind_4_1.ogg',
		'sound/effects/wind/wind_4_2.ogg',
		'sound/effects/wind/wind_5_1.ogg'
	)
	description = "Birds and insects call from the grasses, and a cool wind gusts from across the river."
	area_blurb_category = /area/shaded_hills/outside

/area/shaded_hills/outside/hills
	name = "Foothills"

/area/shaded_hills/outside/river
	name = "River"
	color = COLOR_BLUE
	description = "The soft susurration of running water mingles with the hum of insects and croak of frogs."
	area_blurb_category = /area/shaded_hills/outside/river

/area/shaded_hills/caves
	name = "Deep Tunnels"
	color = COLOR_GRAY40
	is_outside = OUTSIDE_NO
	description = "The deep dark brings distant, whispering echoes to your ears."
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	area_blurb_category = /area/shaded_hills/caves

/area/shaded_hills/caves/entrance
	name = "Surface Tunnels"
	color = COLOR_GRAY80

/area/shaded_hills/caves/unexplored
	name = "Trackless Deeps"
	color = COLOR_GRAY20
	ambience = list(
		'sound/ambience/ominous1.ogg',
		'sound/ambience/ominous2.ogg',
		'sound/ambience/ominous3.ogg',
	)

/area/shaded_hills/caves/river
	name = "Silent River"
	color = COLOR_GRAY20
	description = "The silent, black water catches whatever sparse light survives in the depths, glittering like a river of stars."
	area_blurb_category = /area/shaded_hills/caves/river
	ambience = list(
		'sound/ambience/ominous1.ogg',
		'sound/ambience/ominous2.ogg',
		'sound/ambience/ominous3.ogg',
	)
