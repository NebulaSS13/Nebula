/turf/exterior/clay
	name = "clay"
	desc = "Thick, claggy clay."
	icon_state = "mud"
	icon = 'icons/turf/flooring/mud_light.dmi'
	flooring_layers = /decl/flooring/clay

/decl/flooring/clay
	name = "clay"
	desc = "Thick, claggy clay."
	icon_base = "mud"
	icon = 'icons/turf/flooring/mud_light.dmi'
	icon_edge_layer = EXT_EDGE_CLAY
	footstep_type = /decl/footsteps/mud
	diggable_resources = list(/obj/item/stack/material/ore/clay = list(3, 2))

/turf/exterior/clay/flooded
	flooded = /decl/material/liquid/water

/turf/exterior/mud
	name = "mud"
	desc = "Thick, waterlogged mud."
	icon = 'icons/turf/flooring/mud_dark.dmi'
	icon_state = "mud"
	flooring_layers = /decl/flooring/mud

/decl/flooring/mud
	name = "mud"
	desc = "Thick, claggy and waterlogged."
	icon = 'icons/turf/flooring/mud_dark.dmi'
	icon_base = "mud"
	icon_edge_layer = EXT_EDGE_MUD
	footstep_type = /decl/footsteps/mud
	diggable_resources = list(/obj/item/stack/material/ore/clay = list(3, 2))

/turf/exterior/mud/water
	color = COLOR_SKY_BLUE
	reagent_type = /decl/material/liquid/water
	height = -(FLUID_SHALLOW)

/turf/exterior/mud/water/deep
	color = COLOR_BLUE
	height = -(FLUID_DEEP)

/turf/exterior/mud/flooded
	flooded = /decl/material/liquid/water

/turf/exterior/dry

	name = "dry mud"
	dirt_color = "#ae9e66"
	icon_state = "seafloor"
	icon = 'icons/turf/flooring/seafloor.dmi'
	flooring_layers = /decl/flooring/dry_mud

/decl/flooring/dry_mud
	name = "dry mud"
	desc = "Should have stayed hydrated."
	icon_base = "seafloor"
	icon = 'icons/turf/flooring/seafloor.dmi'
