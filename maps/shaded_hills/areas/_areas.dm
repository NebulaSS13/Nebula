/area/shaded_hills
	abstract_type = /area/shaded_hills
	icon = 'maps/shaded_hills/areas/icons.dmi'
	icon_state = "area"

/area/shaded_hills/outside
	name = "Grasslands"
	color = COLOR_GREEN
	is_outside = OUTSIDE_YES
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
	area_blurb_category = /area/shaded_hills/caves

/area/shaded_hills/caves/entrance
	name = "Surface Tunnels"
	color = COLOR_GRAY80

/area/shaded_hills/caves/unexplored
	name = "Trackless Deeps"
	color = COLOR_GRAY20

/area/shaded_hills/caves/river
	name = "Silent River"
	color = COLOR_GRAY20
	description = "The silent, black water catches whatever sparse light survives in the depths, glittering like a river of stars."
	area_blurb_category = /area/shaded_hills/caves/river
