/turf/floor/carpet
	name        = "brown carpet"
	icon        = 'icons/turf/flooring/carpet.dmi'
	icon_state  = "brown"
	_flooring   = /decl/flooring/carpet

/turf/floor/carpet/broken
	_floor_broken = TRUE

/turf/floor/carpet/broken/Initialize()
	. = ..()
	var/setting_broken = _floor_broken
	_floor_broken = null
	set_floor_broken(setting_broken)

/turf/floor/carpet/blue
	name        = "blue carpet"
	icon_state  = "blue1"
	_flooring   = /decl/flooring/carpet/blue

/turf/floor/carpet/blue2
	name        = "pale blue carpet"
	icon_state  = "blue2"
	_flooring   = /decl/flooring/carpet/blue2

/turf/floor/carpet/blue3
	name        = "sea blue carpet"
	icon_state  = "blue3"
	_flooring   = /decl/flooring/carpet/blue3

/turf/floor/carpet/magenta
	name        = "magenta carpet"
	icon_state  = "magenta"
	_flooring   = /decl/flooring/carpet/magenta

/turf/floor/carpet/purple
	name        = "purple carpet"
	icon_state  = "purple"
	_flooring   = /decl/flooring/carpet/purple

/turf/floor/carpet/orange
	name        = "orange carpet"
	icon_state  = "orange"
	_flooring   = /decl/flooring/carpet/orange

/turf/floor/carpet/green
	name        = "green carpet"
	icon_state  = "green"
	_flooring   = /decl/flooring/carpet/green

/turf/floor/carpet/red
	name        = "red carpet"
	icon_state  = "red"
	_flooring   = /decl/flooring/carpet/red

/turf/floor/carpet/rustic
	name        = "rustic carpet"
	icon        = 'icons/turf/flooring/simple_carpet.dmi'
	icon_state  = "carpet"
	_flooring   = /decl/flooring/carpet/rustic
	paint_color = COLOR_CHESTNUT
	color       = COLOR_CHESTNUT