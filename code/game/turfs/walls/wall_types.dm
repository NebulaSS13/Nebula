//Commonly used
/turf/wall/prepainted
	color = COLOR_GUNMETAL
	paint_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_GUNMETAL
/turf/wall/r_wall/prepainted
	color = COLOR_GUNMETAL
	paint_color = COLOR_WALL_GUNMETAL
	stripe_color = COLOR_GUNMETAL

/turf/wall/r_wall
	color = "#a8a9b2"
	icon_state = "reinforced_solid"
	material = /decl/material/solid/metal/plasteel
	reinf_material = /decl/material/solid/metal/plasteel

/turf/wall/r_wall/hull
	name = "hull"
	color = COLOR_HULL
	paint_color = COLOR_HULL
	stripe_color = COLOR_HULL

/turf/wall/r_wall/hull/Initialize()
	. = ..()
	paint_color = color
	color = null //color is just for mapping
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in global.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
	update_icon()

/turf/wall/titanium
	color = COLOR_SILVER
	material = /decl/material/solid/metal/titanium

/turf/wall/r_titanium
	color = "#d1e6e3"
	icon_state = "reinforced_solid"
	material = /decl/material/solid/metal/titanium
	reinf_material = /decl/material/solid/metal/titanium

/turf/wall/ocp_wall
	color = COLOR_GUNMETAL
	material = /decl/material/solid/metal/plasteel/ocp
	reinf_material = /decl/material/solid/metal/plasteel/ocp

/turf/wall/iron
	color = "#5c5454"
	icon_state = "metal"
	material = /decl/material/solid/metal/iron

/turf/wall/plastic
	color = COLOR_EGGSHELL
	icon_state = "plastic"
	material = /decl/material/solid/organic/plastic

// A plastic wall with a plastic girder. Very flimsy but very easy to move or remove with just a crowbar.
/turf/wall/plastic/facade
	girder_material = /decl/material/solid/organic/plastic

/turf/wall/phoron
	color = "#e37108"
	icon_state = "stone"
	material = /decl/material/solid/phoron

/turf/wall/wood
	color = COLOR_BROWN
	icon_state = "wood"
	material = /decl/material/solid/organic/wood

/turf/wall/walnut
	color = COLOR_BROWN_ORANGE
	icon_state = "wood"
	material = /decl/material/solid/organic/wood/walnut

/turf/wall/raidershuttle
	color = COLOR_GREEN_GRAY
	icon_state = "metal"
	material = /decl/material/solid/metal/alienalloy

/turf/wall/raidershuttle/attackby()
	return

//Alien metal walls
/turf/wall/alium
	color = COLOR_BLUE_GRAY
	floor_type = /turf/floor/fixed/alium
	material = /decl/material/solid/metal/aliumium

/turf/wall/alium/explosion_act(severity)
	SHOULD_CALL_PARENT(TRUE)
	if(prob(explosion_resistance))
		..()

/turf/wall/shuttle
	material = /decl/material/solid/metal/titanium
	paint_color = COLOR_BEIGE
	stripe_color = COLOR_SKY_BLUE

/turf/wall/shuttle/get_wall_icon()
	return 'icons/turf/walls/solid.dmi'

/turf/wall/shuttle/dark
	paint_color = COLOR_GUNMETAL
	stripe_color = COLOR_MAROON
