/area/fallout
	name = "Fallout Area"
	icon_state = "dark_blue"
	has_gravity =         TRUE
	requires_power =      FALSE


/area/fallout/outdoors
	name = "Wasteland"
	sound_env = PLAIN
	ambience = list(
		'sound/effects/wind/desert0.ogg',
		'sound/effects/wind/desert1.ogg',
		'sound/effects/wind/desert2.ogg',
		'sound/effects/wind/desert3.ogg',
		'sound/effects/wind/desert4.ogg',
		'sound/effects/wind/desert5.ogg'
	)
	is_outside = OUTSIDE_YES
	area_flags = AREA_FLAG_EXTERNAL | AREA_FLAG_IS_BACKGROUND
	interior_ambient_light_modifier = -0.3

	//BOS Areas
/area/fallout/brotherhood
	name = "Brotherhood of Steel"

/area/fallout/brotherhood/leisure
	name = "Brotherhood of Steel Leisure Area"

/area/fallout/brotherhood/medical
	name = "Brotherhood of Steel Medical Area"

/area/fallout/brotherhood/mining
	name = "Brotherhood of Steel Mining Area"

/area/fallout/brotherhood/offices1
	name = "Brotherhood of Steel 1st Floor Offices"

/area/fallout/brotherhood/offices2
	name = "Brotherhood of Steel 2nd Floor Offices"

/area/fallout/brotherhood/operations
	name = "Brotherhood of Steel Operations"

/area/fallout/brotherhood/reactor
	name = "Brotherhood of Steel Reactor"

/area/fallout/brotherhood/rnd
	name = "Brotherhood of Steel Research"

	//Not BOS areas
/area/fallout/ncr
	name = "New California Republic Camp"

/area/fallout/legion
	name = "Caesar's Legion Camp"

/area/fallout/tribal
	name = "Tribal Camp"

/area/fallout/town
	name = "Town"

/area/fallout/town/inner
	name = "Town Inner Wall"