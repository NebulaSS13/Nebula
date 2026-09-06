/area/shaded_hills/outside/downlands
	name = "Downlands"

/area/shaded_hills/outside/downlands/poi
	name = "Deep Downlands"

/area/shaded_hills/inn
	name = "\improper Inn"
	fishing_failure_prob = 100
	fishing_results = list()
	sound_env = ROOM
	turf_initializer = /decl/turf_initializer/spiderwebs

/decl/turf_initializer/combo/kitchen_webs
	initialisers = list(
		/decl/turf_initializer/spiderwebs,
		/decl/turf_initializer/kitchen
	)

/area/shaded_hills/inn/kitchen
	name = "\improper Inn Kitchen"
	turf_initializer = /decl/turf_initializer/combo/kitchen_webs

/area/shaded_hills/inn/porch
	name = "\improper Inn Porch"
	interior_ambient_light_modifier = -0.4 // night is pitch-black on the porch
	sound_env = FOREST

/area/shaded_hills/stable
	name = "\improper Stable"
	fishing_failure_prob = 100
	fishing_results = list()
	sound_env = ROOM
	turf_initializer = /decl/turf_initializer/spiderwebs

/area/shaded_hills/farmhouse
	name = "\improper Farmhouse"
	fishing_failure_prob = 100
	fishing_results = list()
	sound_env = ROOM
	turf_initializer = /decl/turf_initializer/spiderwebs

/area/shaded_hills/farmhouse/porch
	name = "\improper Farmhouse Porch"
	interior_ambient_light_modifier = -0.4 // night is pitch-black on the porch
	sound_env = FOREST

/area/shaded_hills/slaughterhouse
	name = "\improper Slaughterhouse"
	fishing_failure_prob = 100
	fishing_results = list()
	sound_env = ROOM
	turf_initializer = /decl/turf_initializer/spiderwebs

/area/shaded_hills/storehouse
	name = "\improper Storehouse"
	fishing_failure_prob = 100
	fishing_results = list()
	sound_env = ROOM
	turf_initializer = /decl/turf_initializer/spiderwebs

/area/shaded_hills/general_store
	name = "\improper General Store"
	fishing_failure_prob = 100
	fishing_results = list()
	sound_env = ROOM
	turf_initializer = /decl/turf_initializer/spiderwebs

/area/shaded_hills/general_store/porch
	name = "\improper General Store Porch"
	interior_ambient_light_modifier = -0.4 // night is pitch-black on the porch
	sound_env = FOREST

/area/shaded_hills/shrine
	name = "\improper Shrine"
	fishing_failure_prob = 100
	fishing_results = list()
	area_flags = AREA_FLAG_HOLY
	sound_env = ROOM
	turf_initializer = /decl/turf_initializer/spiderwebs

/area/shaded_hills/shrine/kitchen
	name = "\improper Shrine Kitchen"
	turf_initializer = /decl/turf_initializer/combo/kitchen_webs

/area/shaded_hills/outside/shrine
	name = "\improper Shrine Grounds"

/area/shaded_hills/caves/dungeon
	name = "\improper Deep Dungeon"

/area/shaded_hills/caves/dungeon/inn
	name = "\improper Root Cellar"

/area/shaded_hills/caves/dungeon/poi
	name = "\improper Deepest Dungeon"
