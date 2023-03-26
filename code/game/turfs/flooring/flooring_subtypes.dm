/decl/flooring/plating
	name = "plating"
	desc = "The naked hull."
	icon = 'icons/turf/flooring/plating.dmi'
	icon_base = "plating"
	is_removable = FALSE

/decl/flooring/plating/can_have_additional_layers(var/decl/flooring/other)
	return TRUE




/decl/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_REMOVE_SHOVEL
	build_type = null
	can_engrave = FALSE
	footstep_type = /decl/footsteps/asteroid

/decl/flooring/carpet
	name = "brown carpet"
	desc = "Comfy and fancy carpeting."
	icon = 'icons/turf/flooring/carpet/carpet_brown.dmi'
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	can_engrave = FALSE
	footstep_type = /decl/footsteps/carpet
	wall_smooth = SMOOTH_SELF // Carpet has inner trim that should show against walls.

/decl/flooring/carpet/blue_orange
	name = "blue carpet"
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpetblue
	icon = 'icons/turf/flooring/carpet/carpet_blue_orange.dmi'

/decl/flooring/carpet/blue
	name = "pale blue carpet"
	icon_base = "blue2"
	icon = 'icons/turf/flooring/carpet/carpet_blue.dmi'
	build_type = /obj/item/stack/tile/carpetblue2

/decl/flooring/carpet/blue_green
	name = "sea blue carpet"
	icon_base = "blue3"
	build_type = /obj/item/stack/tile/carpetblue3
	icon = 'icons/turf/flooring/carpet/carpet_blue_green.dmi'

/decl/flooring/carpet/magenta
	name = "magenta carpet"
	icon_base = "magenta"
	build_type = /obj/item/stack/tile/carpetmagenta
	icon = 'icons/turf/flooring/carpet/carpet_magenta.dmi'

/decl/flooring/carpet/purple
	name = "purple carpet"
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpetpurple
	icon = 'icons/turf/flooring/carpet/carpet_purple.dmi'

/decl/flooring/carpet/orange
	name = "orange carpet"
	icon_base = "orange"
	build_type = /obj/item/stack/tile/carpetorange
	icon = 'icons/turf/flooring/carpet/carpet_orange.dmi'

/decl/flooring/carpet/green
	name = "green carpet"
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpetgreen
	icon = 'icons/turf/flooring/carpet/carpet_green.dmi'

/decl/flooring/carpet/red
	name = "red carpet"
	icon_base = "red"
	build_type = /obj/item/stack/tile/carpetred
	icon = 'icons/turf/flooring/carpet/carpet_red.dmi'

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
	icon = 'icons/turf/flooring/tiles/tile.dmi'
	icon_base = "tiled"
	color = COLOR_DARK_GUNMETAL
	has_damage_range = 4
	has_burn_range = 2
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_type = /decl/footsteps/tiles
	has_damage_range = 2

/decl/flooring/tiling/mono
	icon_base = "monotile"
	build_type = /obj/item/stack/tile/mono
	icon = 'icons/turf/flooring/tiles/tile_mono.dmi'
	has_damage_range = 2

/decl/flooring/tiling/mono/dark
	color = COLOR_DARK_GRAY
	icon_base = "monotiledark"
	build_type = /obj/item/stack/tile/mono/dark
	icon = 'icons/turf/flooring/tiles/tile_mono_dark.dmi'
	has_damage_range = 2

/decl/flooring/tiling/mono/white
	icon_base = "monotile_light"
	color = COLOR_OFF_WHITE
	build_type = /obj/item/stack/tile/mono/white
	icon = 'icons/turf/flooring/tiles/tile_mono_light.dmi'
	has_damage_range = 2

/decl/flooring/tiling/white
	icon_base = "tiled_light"
	desc = "How sterile."
	color = COLOR_OFF_WHITE
	build_type = /obj/item/stack/tile/floor_white
	icon = 'icons/turf/flooring/tiles/tile_white.dmi'
	has_damage_range = 2

/decl/flooring/tiling/dark
	desc = "How ominous."
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/floor_dark
	has_damage_range = 2

/decl/flooring/tiling/freezer
	desc = "Don't slip."
	icon_base = "freezer"
	color = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_freezer
	icon = 'icons/turf/flooring/tiles/tile_freezer.dmi'

/decl/flooring/tiling/tech
	icon = 'icons/turf/flooring/techfloor_gray.dmi'
	icon_base = "techfloor_gray"
	build_type = /obj/item/stack/tile/techgrey
	color = null
	has_damage_range = 2

/decl/flooring/tiling/tech/grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/techgrid
	icon = 'icons/turf/flooring/techfloor_grid.dmi'
	has_damage_range = 2

/decl/flooring/tiling/new_tile
	icon_base = "tile_full"
	color = null
	build_type = null
	icon = 'icons/turf/flooring/tiles/tile_full.dmi'

/decl/flooring/tiling/new_tile/cargo_one
	icon_base = "cargo_one_full"
	build_type = null
	icon = 'icons/turf/flooring/tiles/tile_cargo.dmi'
	has_damage_range = 2

/decl/flooring/tiling/new_tile/kafel
	icon_base = "kafel_full"
	build_type = null
	icon = 'icons/turf/flooring/tiles/tile_kafel.dmi'
	has_damage_range = 2

/decl/flooring/tiling/stone
	icon_base = "stone"
	build_type = /obj/item/stack/tile/stone
	icon = 'icons/turf/flooring/tiles/tile_stone.dmi'
	has_damage_range = 2

/decl/flooring/tiling/new_tile/techmaint
	icon_base = "techmaint"
	build_type = /obj/item/stack/tile/techmaint
	icon = 'icons/turf/flooring/tiles/tile_techmaint.dmi'
	has_damage_range = 2

/decl/flooring/tiling/new_tile/monofloor
	icon_base = "monofloor"
	color = COLOR_GUNMETAL
	icon = 'icons/turf/flooring/tiles/tile_monofloor.dmi'
	has_damage_range = 2

/decl/flooring/tiling/new_tile/steel_grid
	icon_base = "grid"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/grid
	icon = 'icons/turf/flooring/tiles/tile_steel_grid.dmi'
	has_damage_range = 2

/decl/flooring/tiling/new_tile/steel_ridged
	icon_base = "ridged"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/ridge
	icon = 'icons/turf/flooring/tiles/tile_steel_ridged.dmi'
	has_damage_range = 2

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
	icon = 'icons/turf/flooring/tiles/tile_reinforced.dmi'
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
	icon = 'icons/turf/flooring/circuit/circuit_blue.dmi'
	icon_base = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_WRENCH
	can_paint = 1
	can_engrave = FALSE

/decl/flooring/reinforced/circuit/green
	icon_base = "gcircuit"
	icon = 'icons/turf/flooring/circuit/circuit_green.dmi'

/decl/flooring/reinforced/circuit/red
	icon_base = "rcircuit"
	icon = 'icons/turf/flooring/circuit/circuit_red.dmi'
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

/decl/flooring/reinforced/cult/on_remove(var/turf/loc, var/place_build_product = FALSE)
	..()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.remove_cultiness(CULTINESS_PER_TURF)

/decl/flooring/reinforced/shuttle
	name = "floor"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1
	can_engrave = FALSE
	abstract_type = /decl/flooring/reinforced/shuttle

/decl/flooring/reinforced/shuttle/blue
	icon_base = "floor"
	icon = 'icons/turf/flooring/shuttle/blue.dmi'

/decl/flooring/reinforced/shuttle/yellow
	icon_base = "floor2"
	icon = 'icons/turf/flooring/shuttle/yellow.dmi'

/decl/flooring/reinforced/shuttle/white
	icon_base = "floor3"
	icon = 'icons/turf/flooring/shuttle/white.dmi'

/decl/flooring/reinforced/shuttle/red
	icon_base = "floor4"
	icon = 'icons/turf/flooring/shuttle/red.dmi'

/decl/flooring/reinforced/shuttle/purple
	icon_base = "floor5"
	icon = 'icons/turf/flooring/shuttle/purple.dmi'

/decl/flooring/reinforced/shuttle/darkred
	icon_base = "floor6"
	icon = 'icons/turf/flooring/shuttle/darkred.dmi'

/decl/flooring/reinforced/shuttle/black
	icon_base = "floor7"
	icon = 'icons/turf/flooring/shuttle/black.dmi'

/decl/flooring/crystal
	name = "crystal floor"
	icon = 'icons/turf/flooring/crystal.dmi'
	icon_base = "crystal"
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

/decl/flooring/pool
	name = "pool floor"
	desc = "Sunken flooring designed to hold liquids."
	icon = 'icons/turf/flooring/pool.dmi'
	icon_base = "pool"
	build_type = /obj/item/stack/tile/pool
	flags = TURF_REMOVE_CROWBAR
	footstep_type = /decl/footsteps/tiles
	height = -FLUID_OVER_MOB_HEAD - 50
	wall_smooth = SMOOTH_SELF // Pool has inner edging that should show against walls.

/decl/flooring/pool/deep
	height = -FLUID_DEEP - 50
