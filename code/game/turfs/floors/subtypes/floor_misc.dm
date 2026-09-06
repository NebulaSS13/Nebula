/turf/floor/lino
	name           = "lino"
	icon           = 'icons/turf/flooring/linoleum.dmi'
	icon_state     = "lino"
	_flooring      = /decl/flooring/linoleum


/turf/floor/crystal
	name           = "crystal floor"
	icon           = 'icons/turf/flooring/crystal.dmi'
	icon_state     = "crystal"
	_flooring      = /decl/flooring/crystal

/turf/floor/glass
	name           = "glass floor"
	icon           = 'icons/turf/flooring/glass.dmi'
	icon_state     = "glass"
	_flooring      = /decl/flooring/glass

/turf/floor/glass/boro
	_flooring      = /decl/flooring/glass/boro

/turf/floor/pool
	name           = "pool floor"
	icon           = 'icons/turf/flooring/pool.dmi'
	icon_state     = "pool"
	height         = -(FLUID_OVER_MOB_HEAD) - 50
	_flooring      = /decl/flooring/pool

/turf/floor/pool/deep
	height         = -FLUID_DEEP - 50

/turf/floor/fake_grass
	name           = "grass patch"
	icon           = 'icons/turf/flooring/fakegrass.dmi'
	icon_state     = "grass0"
	_flooring      = /decl/flooring/grass/fake

/turf/floor/woven
	name           = "floor"
	icon           = 'icons/turf/flooring/woven.dmi'
	icon_state     = "woven"
	color          = COLOR_BEIGE
	_flooring      = /decl/flooring/woven

/turf/floor/straw
	name           = "loose straw"
	icon           = 'icons/turf/flooring/straw.dmi'
	icon_state     = "straw"
	color          = COLOR_WHEAT
	_flooring      = /decl/flooring/straw

// Defining this here as a dummy mapping shorthand so mappers can search for 'plating'.
/turf/floor/plating
	_base_flooring = /decl/flooring/plating // Setting here so overrides on /turf/floor do not impact explicitly typed plating turfs.

/turf/floor/plating/flooded
	flooded = /decl/material/liquid/water

// Dirt plating for Tradeship farms.
/turf/floor/plating/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_state = "dirt"
	color = "#41311b"
	_flooring = /decl/flooring/dirt

/turf/floor/plating/broken
	_floor_broken  = TRUE

/turf/floor/plating/broken/Initialize(ml, floortype)
	. = ..()
	var/setting_broken = _floor_broken
	_floor_broken = null
	set_floor_broken(setting_broken)

/turf/floor/plating/airless
	name           = "airless plating"
	initial_gas    = null
	temperature    = TCMB

/turf/floor/plating/airless/broken
	_floor_broken  = TRUE

/turf/floor/plating/airless/broken/Initialize(ml, floortype)
	. = ..()
	var/setting_broken = _floor_broken
	_floor_broken = null
	set_floor_broken(setting_broken)

/turf/floor/plating/broken/one
	_floor_broken  = "broken1"

/turf/floor/plating/broken/two
	_floor_broken  = "broken2"

/turf/floor/plating/broken/three
	_floor_broken  = "broken3"

/turf/floor/plating/broken/four
	_floor_broken  = "broken4"
