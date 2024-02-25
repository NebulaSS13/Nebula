// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/decl/flooring
	var/name
	var/desc
	var/icon
	var/icon_base
	var/color
	var/footstep_type = /decl/footsteps/blank

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_material  // Unbuildable if object material var is not set to this.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/remove_timer = 10
	var/can_paint
	var/can_engrave = TRUE

	var/movement_delay

	//How we smooth with other flooring
	var/decal_layer = DECAL_LAYER
	var/floor_smooth = SMOOTH_ALL
	/// Smooth with nothing except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_whitelist = list()
	/// Smooth with everything except the types in this list. Turned into a typecache for performance reasons.
	var/list/flooring_blacklist = list()

	//How we smooth with walls
	var/wall_smooth = SMOOTH_ALL
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_ALL
	//There are no lists for spaces
	var/z_flags //same z flags used for turfs, i.e ZMIMIC_DEFAULT etc

	var/height = 0

/decl/flooring/Initialize()
	. = ..()
	flooring_whitelist = typecacheof(flooring_whitelist)
	flooring_blacklist = typecacheof(flooring_blacklist)

/decl/flooring/proc/on_remove()
	return

/decl/flooring/proc/get_movement_delay(var/travel_dir, var/mob/mover)
	return movement_delay

/decl/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass
	can_engrave = FALSE
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	decal_layer = ABOVE_WIRE_LAYER

/decl/flooring/dirt
	name = "dirt"
	desc = "Extra dirty."
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "dirt"
	has_base_range = 3
	damage_temperature = T0C+80
	can_engrave = FALSE
	footstep_type = /decl/footsteps/grass

/decl/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null
	can_engrave = FALSE
	footstep_type = /decl/footsteps/asteroid

/decl/flooring/carpet
	name = "brown carpet"
	desc = "Comfy and fancy carpeting."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	can_engrave = FALSE
	footstep_type = /decl/footsteps/carpet
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/flooring/carpet/blue
	name = "blue carpet"
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpetblue

/decl/flooring/carpet/blue2
	name = "pale blue carpet"
	icon_base = "blue2"
	build_type = /obj/item/stack/tile/carpetblue2

/decl/flooring/carpet/blue3
	name = "sea blue carpet"
	icon_base = "blue3"
	build_type = /obj/item/stack/tile/carpetblue3

/decl/flooring/carpet/magenta
	name = "magenta carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpetmagenta

/decl/flooring/carpet/purple
	name = "purple carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpetpurple

/decl/flooring/carpet/orange
	name = "orange carpet"
	icon_base = "orange"
	build_type = /obj/item/stack/tile/carpetorange

/decl/flooring/carpet/green
	name = "green carpet"
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpetgreen

/decl/flooring/carpet/red
	name = "red carpet"
	icon_base = "red"
	build_type = /obj/item/stack/tile/carpetred

/decl/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2090's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	can_paint = 1
	build_type = /obj/item/stack/tile/linoleum
	flags = TURF_REMOVE_SCREWDRIVER
	footstep_type = /decl/footsteps/tiles

/decl/flooring/tiling
	name = "floor"
	desc = "A solid, heavy set of flooring plates."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "tiled"
	color = COLOR_DARK_GUNMETAL
	has_damage_range = 2
	has_burn_range = 2
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_type = /decl/footsteps/tiles

/decl/flooring/tiling/mono
	icon_base = "monotile"
	build_type = /obj/item/stack/tile/mono

/decl/flooring/tiling/mono/dark
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/mono/dark

/decl/flooring/tiling/mono/white
	icon_base = "monotile_light"
	color = COLOR_OFF_WHITE
	build_type = /obj/item/stack/tile/mono/white

/decl/flooring/tiling/white
	icon_base = "tiled_light"
	desc = "How sterile."
	color = COLOR_OFF_WHITE
	build_type = /obj/item/stack/tile/floor_white

/decl/flooring/tiling/dark
	desc = "How ominous."
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/floor_dark

/decl/flooring/tiling/dark/mono
	icon_base = "monotile"
	build_type = null

/decl/flooring/tiling/freezer
	desc = "Don't slip."
	icon_base = "freezer"
	color = null
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_freezer

/decl/flooring/tiling/tech
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_base = "techfloor_gray"
	build_type = /obj/item/stack/tile/techgrey
	color = null

/decl/flooring/tiling/tech/grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/techgrid

/decl/flooring/tiling/new_tile
	icon_base = "tile_full"
	color = null
	build_type = null

/decl/flooring/tiling/new_tile/cargo_one
	icon_base = "cargo_one_full"
	build_type = null

/decl/flooring/tiling/new_tile/kafel
	icon_base = "kafel_full"
	build_type = null

/decl/flooring/tiling/stone
	icon_base = "stone"
	build_type = /obj/item/stack/tile/stone

/decl/flooring/tiling/new_tile/techmaint
	icon_base = "techmaint"
	build_type = /obj/item/stack/tile/techmaint

/decl/flooring/tiling/new_tile/monofloor
	icon_base = "monofloor"
	color = COLOR_GUNMETAL

/decl/flooring/tiling/new_tile/steel_grid
	icon_base = "grid"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/grid

/decl/flooring/tiling/new_tile/steel_ridged
	icon_base = "ridged"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/ridge

/decl/flooring/wood
	name = "wooden floor"
	desc = "Polished wood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER
	footstep_type = /decl/footsteps/wood
	color = WOOD_COLOR_GENERIC

/decl/flooring/wood/mahogany
	color = WOOD_COLOR_RICH
	build_type = /obj/item/stack/tile/mahogany

/decl/flooring/wood/maple
	color = WOOD_COLOR_PALE
	build_type = /obj/item/stack/tile/maple

/decl/flooring/wood/ebony
	color = WOOD_COLOR_BLACK
	build_type = /obj/item/stack/tile/ebony

/decl/flooring/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	build_type = /obj/item/stack/tile/walnut

/decl/flooring/wood/bamboo
	color = WOOD_COLOR_PALE2
	build_type = /obj/item/stack/tile/bamboo

/decl/flooring/wood/yew
	color = WOOD_COLOR_YELLOW
	build_type = /obj/item/stack/tile/yew

/decl/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with a latticework on top of regular plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/material/sheet
	build_material = /decl/material/solid/metal/steel
	build_cost = 1
	build_time = 30
	can_paint = 1
	footstep_type = /decl/footsteps/plating

/decl/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint = 1
	can_engrave = FALSE

/decl/flooring/reinforced/circuit/green
	icon_base = "gcircuit"

/decl/flooring/reinforced/circuit/red
	icon_base = "rcircuit"
	flags = TURF_ACID_IMMUNE
	can_paint = 0

/decl/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint = null

/decl/flooring/reinforced/cult/on_remove()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.remove_cultiness(CULTINESS_PER_TURF)

/decl/flooring/reinforced/shuttle
	name = "floor"
	icon = 'icons/turf/shuttle.dmi'
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1
	can_engrave = FALSE

/decl/flooring/reinforced/shuttle/blue
	icon_base = "floor"

/decl/flooring/reinforced/shuttle/yellow
	icon_base = "floor2"

/decl/flooring/reinforced/shuttle/white
	icon_base = "floor3"

/decl/flooring/reinforced/shuttle/red
	icon_base = "floor4"

/decl/flooring/reinforced/shuttle/purple
	icon_base = "floor5"

/decl/flooring/reinforced/shuttle/darkred
	icon_base = "floor6"

/decl/flooring/reinforced/shuttle/black
	icon_base = "floor7"

/decl/flooring/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	color = "#00ffe1"

/decl/flooring/glass
	name = "glass flooring"
	desc = "A window to the world outside. Or the world beneath your feet, rather."
	icon = 'icons/turf/flooring/glass.dmi'
	icon_base = "glass"
	build_type = /obj/item/stack/material/pane
	build_material = /decl/material/solid/glass
	build_cost = 1
	build_time = 30
	damage_temperature = T100C
	flags = TURF_REMOVE_CROWBAR | TURF_ACID_IMMUNE
	can_engrave = FALSE
	color = GLASS_COLOR
	z_flags = ZM_MIMIC_DEFAULTS
	footstep_type = /decl/footsteps/plating

/decl/flooring/glass/boro
	name = "borosilicate glass flooring"
	build_material = /decl/material/solid/glass/borosilicate
	color = GLASS_COLOR_SILICATE
	damage_temperature = T0C + 4000

/decl/flooring/snow
	name = "snow"
	desc = "Let it sno-ow... Let it snow..."
	icon = 'icons/turf/snow.dmi'
	icon_base = "snow"
	has_base_range = 12
	flags = TURF_REMOVE_SHOVEL
	build_type = null
	can_engrave = FALSE
	footstep_type = /decl/footsteps/snow
	movement_delay = 2

/decl/flooring/snow/get_movement_delay(travel_dir, mob/mover)
	. = ..()
	if(mover)
		var/obj/item/clothing/shoes/shoes = mover.get_equipped_item(slot_shoes_str)
		if(shoes)
			. += shoes.snow_slowdown_mod
		var/decl/species/my_species = mover.get_species()
		if(my_species)
			. += my_species.snow_slowdown_mod
		. = max(., 0)

/decl/flooring/pool
	name = "pool floor"
	desc = "Sunken flooring designed to hold liquids."
	icon = 'icons/turf/flooring/pool.dmi'
	icon_base = "pool"
	build_type = /obj/item/stack/tile/pool
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR
	footstep_type = /decl/footsteps/tiles
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	height = -FLUID_OVER_MOB_HEAD - 50

/decl/flooring/pool/deep
	height = -FLUID_DEEP - 50