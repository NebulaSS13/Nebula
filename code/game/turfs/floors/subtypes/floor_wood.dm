/turf/floor/wood
	name          = "wooden floor"
	icon          = 'icons/turf/flooring/wood.dmi'
	icon_state    = "wood0"
	color         = /decl/material/solid/organic/wood/oak::color
	_flooring     = /decl/flooring/wood

#define WOOD_FLOOR_SUBTYPE(BASE, WOOD) \
/turf/floor/##BASE/##WOOD { \
	color         = /decl/material/solid/organic/wood/##WOOD::color; \
	_flooring     = /decl/flooring/##BASE/##WOOD; \
}

/turf/floor/wood/broken
	icon_state    = "wood_broken0"
	_floor_broken = TRUE

/turf/floor/wood/broken/Initialize()
	. = ..()
	var/setting_broken = _floor_broken
	_floor_broken = null
	set_floor_broken(setting_broken)

/turf/floor/wood/broken/one
	icon_state    = "wood_broken1"
	_floor_broken = "broken1"

/turf/floor/wood/broken/two
	icon_state    = "wood_broken2"
	_floor_broken = "broken2"

/turf/floor/wood/broken/three
	icon_state    = "wood_broken3"
	_floor_broken = "broken3"

/turf/floor/wood/broken/four
	icon_state    = "wood_broken4"
	_floor_broken = "broken4"

WOOD_FLOOR_SUBTYPE(wood, mahogany)
WOOD_FLOOR_SUBTYPE(wood, maple)
WOOD_FLOOR_SUBTYPE(wood, ebony)
WOOD_FLOOR_SUBTYPE(wood, walnut)
WOOD_FLOOR_SUBTYPE(wood, bamboo)
WOOD_FLOOR_SUBTYPE(wood, yew)

// Rough wood floors; lower skill requirement, more wasteful to craft.
/turf/floor/wood/rough
	name          = "rough-hewn wooden floor"
	icon          = 'icons/turf/flooring/wood_alt.dmi'
	icon_state    = "wood_peasant0"
	color         = /decl/material/solid/organic/wood/oak::color
	_flooring     = /decl/flooring/wood

WOOD_FLOOR_SUBTYPE(wood/rough, mahogany)
WOOD_FLOOR_SUBTYPE(wood/rough, maple)
WOOD_FLOOR_SUBTYPE(wood/rough, ebony)
WOOD_FLOOR_SUBTYPE(wood/rough, walnut)
WOOD_FLOOR_SUBTYPE(wood/rough, bamboo)
WOOD_FLOOR_SUBTYPE(wood/rough, yew)

// Laminate floor; basically identical to wood, but uses older smoother icons.
/turf/floor/laminate
	name          = "wooden laminate floor"
	icon          = 'icons/turf/flooring/laminate.dmi'
	icon_state    = "wood"
	color         = /decl/material/solid/organic/wood/chipboard::color
	_flooring     = /decl/flooring/laminate

/turf/floor/laminate/broken
	icon_state    = "wood_broken0"
	_floor_broken = TRUE

/turf/floor/laminate/broken/Initialize()
	. = ..()
	var/setting_broken = _floor_broken
	_floor_broken = null
	set_floor_broken(setting_broken)

/turf/floor/laminate/broken/one
	icon_state    = "wood_broken1"
	_floor_broken = "broken1"

/turf/floor/laminate/broken/two
	icon_state    = "wood_broken2"
	_floor_broken = "broken2"

/turf/floor/laminate/broken/three
	icon_state    = "wood_broken3"
	_floor_broken = "broken3"

/turf/floor/laminate/broken/four
	icon_state    = "wood_broken4"
	_floor_broken = "broken4"

/turf/floor/laminate/mahogany
	color         = /decl/material/solid/organic/wood/chipboard/mahogany::color
	_flooring     = /decl/flooring/laminate/mahogany

/turf/floor/laminate/maple
	color         = /decl/material/solid/organic/wood/chipboard/maple::color
	_flooring     = /decl/flooring/laminate/maple

/turf/floor/laminate/ebony
	color         = /decl/material/solid/organic/wood/chipboard/ebony::color
	_flooring     = /decl/flooring/laminate/ebony

/turf/floor/laminate/walnut
	color         = /decl/material/solid/organic/wood/chipboard/walnut::color
	_flooring     = /decl/flooring/laminate/walnut

/turf/floor/laminate/yew
	color         = /decl/material/solid/organic/wood/chipboard/yew::color
	_flooring     = /decl/flooring/laminate/yew
