/turf/floor/holofloor
	abstract_type = /turf/floor/holofloor
	thermal_conductivity = 0

/turf/floor/holofloor/get_lumcount(var/minlum = 0, var/maxlum = 1)
	return 0.8

/turf/floor/holofloor/attackby(obj/item/used_item, mob/user)
	return TRUE
	// HOLOFLOOR DOES NOT GIVE A FUCK

/turf/floor/holofloor/carpet
	name          = "brown carpet"
	icon          = 'icons/turf/flooring/carpet.dmi'
	icon_state    = "brown"
	_flooring     = /decl/flooring/carpet

/turf/floor/holofloor/concrete
	name          = "brown carpet"
	icon          = 'icons/turf/flooring/carpet.dmi'
	icon_state    = "brown"
	_flooring     = /decl/flooring/carpet

/turf/floor/holofloor/concrete
	name          = "floor"
	icon          = 'icons/turf/flooring/misc.dmi'
	icon_state    = "concrete"
	_flooring     = null

/turf/floor/holofloor/tiled
	name          = "floor"
	icon          = 'icons/turf/flooring/tiles.dmi'
	icon_state    = "steel"
	_flooring     = /decl/flooring/tiling

/turf/floor/holofloor/tiled/dark
	name          = "dark floor"
	icon_state    = "dark"
	_flooring     = /decl/flooring/tiling/dark

/turf/floor/holofloor/tiled/stone
	name          = "stone floor"
	icon_state    = "stone"
	_flooring     = /decl/flooring/tiling/stone

/turf/floor/holofloor/lino
	name          = "lino"
	icon          = 'icons/turf/flooring/linoleum.dmi'
	icon_state    = "lino"
	_flooring     = /decl/flooring/linoleum

/turf/floor/holofloor/wood
	name          = "wooden floor"
	icon          = 'icons/turf/flooring/wood.dmi'
	icon_state    = "wood0"
	color         = WOOD_COLOR_CHOCOLATE
	_flooring     = /decl/flooring/wood

/turf/floor/holofloor/grass
	name          = "lush grass"
	icon          = 'icons/turf/flooring/fakegrass.dmi'
	icon_state    = "grass0"
	_flooring     = /decl/flooring/grass/fake

/turf/floor/holofloor/snow
	name          = "snow"
	icon          = 'icons/turf/flooring/snow.dmi'
	icon_state    = "snow0"
	_flooring     = /decl/flooring/snow/fake

/turf/floor/holofloor/space
	name          = "\proper space"
	icon          = 'icons/turf/flooring/fake_space.dmi'
	icon_state    = "space0"
	_flooring     = /decl/flooring/fake_space

/turf/floor/holofloor/reinforced
	name          = "reinforced holofloor"
	icon          = 'icons/turf/flooring/tiles.dmi'
	_flooring     = /decl/flooring/reinforced
	icon_state    = "reinforced"

/turf/floor/holofloor/beach
	desc          = "Uncomfortably gritty for a hologram."
	icon          = 'icons/misc/beach.dmi'
	_flooring     = /decl/flooring/sand/fake
	abstract_type = /turf/floor/holofloor/beach

/turf/floor/holofloor/beach/sand
	name          = "sand"
	icon_state    = "desert0"

/turf/floor/holofloor/beach/coastline
	name          = "coastline"
	icon          = 'icons/misc/beach2.dmi'
	icon_state    = "sandwater"
	_flooring     = /decl/flooring/sand/fake

/turf/floor/holofloor/beach/water
	name          = "water"
	icon_state    = "seashallow"
	_flooring     = /decl/flooring/fake_water

/turf/floor/holofloor/desert
	name          = "desert sand"
	desc          = "Uncomfortably gritty for a hologram."
	icon          = 'icons/turf/flooring/barren.dmi'
	icon_state    = "barren"
	_flooring     = /decl/flooring/sand/fake

/turf/floor/holofloor/desert/Initialize(var/ml)
	. = ..()
	if(prob(10))
		LAZYADD(decals, image('icons/turf/flooring/decals.dmi', "asteroid[rand(0,9)]"))