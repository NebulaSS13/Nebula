/area/shaded_hills
	abstract_type = /area/shaded_hills
	icon = 'maps/shaded_hills/areas/icons.dmi'
	icon_state = "area"
/* Uncomment when fishing is merged.
	fishing_failure_prob = 10
	fishing_results = list(
		/obj/random/natural_debris                           = 10,
		/mob/living/simple_animal/aquatic/fish               = 10,
		/mob/living/simple_animal/aquatic/fish/grump         = 10,
		/obj/item/mollusc                                    = 5,
		/obj/item/mollusc/barnacle/fished                    = 5,
		/mob/living/simple_animal/aquatic/fish/large         = 5,
		/mob/living/simple_animal/aquatic/fish/large/bass    = 5,
		/mob/living/simple_animal/aquatic/fish/large/salmon  = 5,
		/mob/living/simple_animal/aquatic/fish/large/trout   = 5,
		/mob/living/simple_animal/aquatic/fish/large/pike    = 3,
		/mob/living/simple_animal/aquatic/fish/large/javelin = 3,
		/obj/item/mollusc/clam/fished/pearl                  = 3,
		/mob/living/simple_animal/aquatic/fish/large/koi     = 1
	)
*/

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
	interior_ambient_light_level = 0.2
	interior_ambient_light_color = "#f3e6ca"

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
	name = "Trackless Deeps - North"
	color = COLOR_GRAY20
	ambience = list(
		'sound/ambience/ominous1.ogg',
		'sound/ambience/ominous2.ogg',
		'sound/ambience/ominous3.ogg',
	)

// Area coherency test hates that the unexplored area is split by a tunnel.
/area/shaded_hills/caves/unexplored/south
	name = "Trackless Deeps - South"

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

// Swamp areas.
/area/shaded_hills/caves/river/swamp
	name = "Southern Silent River"

/area/shaded_hills/outside/swamp
	name = "Swamp"
	description = "The reek of stagnant water and the chirp of insects filter through the humid air."

/area/shaded_hills/outside/river/swamp
	name = "Swampy River"
	description = "Mud squelches underfoot as the river broadens and splits, feeding a broad expanse of swamp and still water."

/area/shaded_hills/caves/swamp
	name = "Southern Deep Tunnels"

/area/shaded_hills/caves/unexplored/swamp
	name = "Trackless Deeps - Far South"

// Woodland areas.
/area/shaded_hills/caves/river/woods
	name = "Northern Silent River"

/area/shaded_hills/outside/river/lake
	name = "Woodland Lake"

/area/shaded_hills/outside/woods
	name = "Woodlands"

/area/shaded_hills/outside/river/woods
	name = "Woodland River"

/area/shaded_hills/caves/woods
	name = "Northern Deep Tunnels"

/area/shaded_hills/caves/unexplored/woods
	name = "Trackless Deeps - Far North"
