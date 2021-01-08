//Commonly used
/turf/simulated/wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall
	icon_state = "reinforced_solid"
	material = /decl/material/solid/metal/plasteel
	reinf_material = /decl/material/solid/metal/plasteel

/turf/simulated/wall/r_wall/hull
	name = "hull"
	color = COLOR_HULL

/turf/simulated/wall/prepainted
	paint_color = COLOR_WALL_GUNMETAL
/turf/simulated/wall/r_wall/prepainted
	paint_color = COLOR_WALL_GUNMETAL

/turf/simulated/wall/r_wall/hull/Initialize()
	. = ..()
	paint_color = color
	color = null //color is just for mapping
	if(prob(40))
		var/spacefacing = FALSE
		for(var/direction in GLOB.cardinal)
			var/turf/T = get_step(src, direction)
			var/area/A = get_area(T)
			if(A && (A.area_flags & AREA_FLAG_EXTERNAL))
				spacefacing = TRUE
				break
		if(spacefacing)
			var/bleach_factor = rand(10,50)
			paint_color = adjust_brightness(paint_color, bleach_factor)
	update_icon()

/turf/simulated/wall/titanium
	color = COLOR_SILVER
	material = /decl/material/solid/metal/titanium

/turf/simulated/wall/r_titanium
	icon_state = "reinforced_solid"
	material = /decl/material/solid/metal/titanium
	reinf_material = /decl/material/solid/metal/titanium

/turf/simulated/wall/ocp_wall
	color = COLOR_GUNMETAL
	material = /decl/material/solid/metal/plasteel/ocp
	reinf_material = /decl/material/solid/metal/plasteel/ocp

/turf/simulated/wall/iron
	icon_state = "metal"
	material = /decl/material/solid/metal/iron

/turf/simulated/wall/sandstone
	color = COLOR_GOLD
	icon_state = "stone"
	material = /decl/material/solid/stone/sandstone

/turf/simulated/wall/wood
	color = COLOR_BROWN
	icon_state = "wood"
	material = /decl/material/solid/wood

/turf/simulated/wall/walnut
	color = COLOR_BROWN_ORANGE
	icon_state = "wood"
	material = /decl/material/solid/wood/walnut

/turf/simulated/wall/raidershuttle
	color = COLOR_GREEN_GRAY
	icon_state = "metal"
	material = /decl/material/solid/metal/alienalloy

/turf/simulated/wall/raidershuttle/attackby()
	return

//Alien metal walls
/turf/simulated/wall/alium
	color = COLOR_BLUE_GRAY
	floor_type = /turf/simulated/floor/fixed/alium
	material = /decl/material/solid/metal/aliumium

/turf/simulated/wall/alium/explosion_act(severity)
	SHOULD_CALL_PARENT(TRUE)
	if(prob(explosion_resistance))
		..()

//Cult wall
/turf/simulated/wall/cult
	icon_state = "cult"
	color = COLOR_RED_GRAY
	material = /decl/material/solid/stone/cult

/turf/simulated/wall/cult/reinf
	icon_state = "reinforced_cult"
	reinf_material = /decl/material/solid/stone/cult/reinforced

/turf/simulated/wall/cult/dismantle_wall()
	var/decl/special_role/cultist/cult = decls_repository.get_decl(/decl/special_role/cultist)
	cult.remove_cultiness(CULTINESS_PER_TURF)
	. = ..()

/turf/simulated/wall/cult/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return 1
	else if(istype(W, /turf/simulated/wall))
		return 1
	return 0