/turf/floor/barren
	name = "ground"
	icon = 'icons/turf/flooring/barren.dmi'
	icon_state = "barren"
	base_flooring = /decl/flooring/barren

/turf/floor/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_state = "dirt"
	color = "#41311b"
	base_flooring = /decl/flooring/dirt

/turf/floor/chlorine_sand
	name = "chlorinated sand"
	icon = 'icons/turf/flooring/chlorine_sand.dmi'
	icon_state = "chlorine0"
	base_flooring = /decl/flooring/sand/chlorine

/turf/floor/chlorine_sand/marsh
	name = "chlorine marsh"
	fill_reagent_type = /decl/material/gas/chlorine
	base_flooring = /decl/flooring/sand/chlorine/marsh
	height = -(FLUID_SHALLOW)

/turf/floor/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	base_flooring = /decl/flooring/lava

/turf/floor/grass
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	color = "#5e7a3b"
	flooring = /decl/flooring/grass
	base_flooring = /decl/flooring/dirt

/turf/floor/grass/wild
	name = "wild grass"
	icon = 'icons/turf/flooring/wildgrass.dmi'
	icon_state = "wildgrass"
	flooring = /decl/flooring/grass/wild
	base_flooring = /decl/flooring/dirt

/turf/floor/ice
	name = "ice"
	icon = 'icons/turf/flooring/ice.dmi'
	icon_state = "ice"
	color = COLOR_LIQUID_WATER
	flooring = /decl/flooring/ice
	base_flooring = /decl/flooring/dirt

/turf/floor/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow0"
	flooring = /decl/flooring/snow
	base_flooring = /decl/flooring/dirt

/turf/floor/clay
	name = "clay"
	icon = 'icons/turf/flooring/clay.dmi'
	icon_state = "clay"
	base_flooring = /decl/flooring/clay

/turf/floor/clay/flooded
	flooded = /decl/material/liquid/water

/turf/floor/mud
	name = "mud"
	icon = 'icons/turf/flooring/mud.dmi'
	icon_state = "mud"
	base_flooring = /decl/flooring/mud

/turf/floor/mud/water
	color = COLOR_SKY_BLUE
	fill_reagent_type = /decl/material/liquid/water
	height = -(FLUID_SHALLOW)

/turf/floor/mud/water/deep
	color = COLOR_BLUE
	height = -(FLUID_DEEP)

/turf/floor/mud/flooded
	flooded = /decl/material/liquid/water

/turf/floor/dry
	name = "dry mud"
	icon = 'icons/turf/flooring/seafloor.dmi'
	icon_state = "seafloor"
	base_flooring = /decl/flooring/dry_mud

/turf/floor/rock/sand
	name = "sand"
	icon = 'icons/turf/flooring/sand.dmi'
	icon_state = "sand0"
	color = "#ae9e66"
	flooring = /decl/flooring/sand

/turf/floor/rock/sand/water
	color = COLOR_SKY_BLUE
	fill_reagent_type = /decl/material/liquid/water
	height = -(FLUID_SHALLOW)

/turf/floor/rock/sand/water/deep
	color = COLOR_BLUE
	height = -(FLUID_DEEP)

/turf/floor/seafloor
	name = "sea floor"
	icon = 'icons/turf/flooring/seafloor.dmi'
	icon_state = "seafloor"
	base_flooring = /decl/flooring/seafloor

/turf/floor/seafloor/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/floor/shrouded
	name = "packed sand"
	icon = 'icons/turf/flooring/shrouded.dmi'
	icon_state = "shrouded0"
	base_flooring = /decl/flooring/shrouded

/turf/floor/shrouded/tar
	height = -(FLUID_SHALLOW)
	fill_reagent_type = /decl/material/liquid/tar
