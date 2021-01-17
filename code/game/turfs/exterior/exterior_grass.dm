/turf/exterior/grass
	name = "grass"
	possible_states = 1
	icon = 'icons/turf/exterior/grass.dmi'
	footstep_type = /decl/footsteps/grass
	icon_edge_layer = EXT_EDGE_GRASS

/turf/exterior/wildgrass
	name = "wild grass"
	icon = 'icons/turf/exterior/wildgrass.dmi'
	icon_edge_layer = EXT_EDGE_GRASS_WILD
	icon_has_corners = TRUE
	color = "#799c4b"
	footstep_type = /decl/footsteps/grass

/turf/exterior/wildgrass/Initialize()
	. = ..()
	if(GLOB.using_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E) && E.grass_color)
			color = E.grass_color

	var/datum/extension/buried_resources/resources = get_or_create_extension(src, /datum/extension/buried_resources)
	if(prob(70))
		LAZYSET(resources.resources, /decl/material/solid/mineral/graphite, rand(3,5))
	if(prob(5))
		LAZYSET(resources.resources, /decl/material/solid/metal/uranium, rand(1,3))
	if(prob(2))
		LAZYSET(resources.resources, /decl/material/solid/gemstone/diamond,  1)
	if(!LAZYLEN(resources.resources))
		remove_extension(src, /datum/extension/buried_resources)

/turf/exterior/wildgrass/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((temperature > T0C + 200 && prob(5)) || temperature > T0C + 1000)
		melt()

/turf/exterior/wildgrass/melt()
	if(icon_state != "scorched")
		SetName("scorched ground")
		icon_state = "scorched"
		icon_edge_layer = -1
		footstep_type = /decl/footsteps/asteroid
		color = null
