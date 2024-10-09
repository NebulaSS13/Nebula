/turf/floor/barren
	name = "ground"
	icon = 'icons/turf/flooring/barren.dmi'
	icon_state = "barren"
	_base_flooring = /decl/flooring/barren

/turf/floor/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_state = "dirt"
	color = "#41311b"
	_base_flooring = /decl/flooring/dirt

/turf/floor/wood/walnut
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	color = /decl/material/solid/organic/wood/walnut::color
	_flooring = /decl/flooring/wood/walnut

/turf/floor/chlorine_sand
	name = "chlorinated sand"
	icon = 'icons/turf/flooring/chlorine_sand.dmi'
	icon_state = "chlorine0"
	_base_flooring = /decl/flooring/sand/chlorine

/turf/floor/chlorine_sand/marsh
	name = "chlorine marsh"
	fill_reagent_type = /decl/material/gas/chlorine
	_base_flooring = /decl/flooring/sand/chlorine/marsh
	height = -(FLUID_SHALLOW)

/turf/floor/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	_base_flooring = /decl/flooring/lava

/turf/floor/grass
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	color = "#5e7a3b"
	_flooring = /decl/flooring/grass
	_base_flooring = /decl/flooring/dirt

/turf/floor/grass/wild
	name = "wild grass"
	icon = 'icons/turf/flooring/wildgrass.dmi'
	icon_state = "wildgrass"
	_flooring = /decl/flooring/grass/wild
	_base_flooring = /decl/flooring/dirt

/turf/floor/ice
	name = "ice"
	icon = 'icons/turf/flooring/ice.dmi'
	icon_state = "ice"
	color = COLOR_LIQUID_WATER
	_flooring = /decl/flooring/ice
	_base_flooring = /decl/flooring/dirt

/turf/floor/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow0"
	_flooring = /decl/flooring/snow
	_base_flooring = /decl/flooring/dirt

/turf/floor/clay
	name = "clay"
	icon = 'icons/turf/flooring/clay.dmi'
	icon_state = "clay"
	_base_flooring = /decl/flooring/clay

/turf/floor/clay/flooded
	flooded = /decl/material/liquid/water

/turf/floor/mud
	name = "mud"
	icon = 'icons/turf/flooring/mud.dmi'
	icon_state = "mud"
	_base_flooring = /decl/flooring/mud

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
	_base_flooring = /decl/flooring/dry_mud

/turf/floor/rock/sand
	name = "sand"
	icon = 'icons/turf/flooring/sand.dmi'
	icon_state = "sand0"
	color = "#ae9e66"
	_flooring = /decl/flooring/sand

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
	_base_flooring = /decl/flooring/seafloor

/turf/floor/seafloor/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/floor/shrouded
	name = "packed sand"
	icon = 'icons/turf/flooring/shrouded.dmi'
	icon_state = "shrouded0"
	_base_flooring = /decl/flooring/shrouded

/turf/floor/shrouded/tar
	height = -(FLUID_SHALLOW)
	fill_reagent_type = /decl/material/liquid/tar
