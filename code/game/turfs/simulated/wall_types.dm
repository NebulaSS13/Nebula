//Commonly used
/turf/simulated/wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall
	icon_state = "r_generic"

/turf/simulated/wall/r_wall/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/metal/plasteel,/decl/material/solid/metal/plasteel) //3strong

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
	icon_state = "titanium"

/turf/simulated/wall/titanium/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/metal/plasteel/titanium)

/turf/simulated/wall/r_titanium
	icon_state = "r_titanium"

/turf/simulated/wall/r_titanium/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/metal/plasteel/titanium, /decl/material/solid/metal/plasteel/titanium)

/turf/simulated/wall/ocp_wall
	icon_state = "r_ocp"

/turf/simulated/wall/ocp_wall/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/metal/plasteel/ocp, /decl/material/solid/metal/plasteel/ocp)

//Material walls

/turf/simulated/wall/r_wall/rglass_wall/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/glass, /decl/material/solid/metal/steel)
	icon_state = "r_generic"

/turf/simulated/wall/iron/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/metal/iron)

/turf/simulated/wall/uranium/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/metal/uranium)

/turf/simulated/wall/diamond/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/gemstone/diamond)

/turf/simulated/wall/gold/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/metal/gold)

/turf/simulated/wall/silver/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/metal/silver)

/turf/simulated/wall/sandstone/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/stone/sandstone)

/turf/simulated/wall/rutile/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/mineral/rutile)

/turf/simulated/wall/wood
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/wood/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/wood)

/turf/simulated/wall/mahogany
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/mahogany/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/wood/mahogany)

/turf/simulated/wall/maple
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/maple/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/wood/maple)

/turf/simulated/wall/ebony
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/ebony/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/wood/ebony)

/turf/simulated/wall/walnut
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/walnut/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/wood/walnut)

/turf/simulated/wall/golddiamond/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/metal/gold,/decl/material/solid/gemstone/diamond)

/turf/simulated/wall/silvergold/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/metal/silver,/decl/material/solid/metal/gold)

/turf/simulated/wall/sandstonediamond/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/stone/sandstone, /decl/material/solid/gemstone/diamond)

/turf/simulated/wall/crystal/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/gemstone/crystal)

/turf/simulated/wall/voxshuttle/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/metal/voxalloy)

/turf/simulated/wall/voxshuttle/attackby()
	return

/turf/simulated/wall/concrete
	floor_type = null

/turf/simulated/wall/concrete/Initialize(var/ml)
	. = ..(ml,/decl/material/solid/stone/concrete)

//Alien metal walls
/turf/simulated/wall/alium
	icon_state = "jaggy"
	floor_type = /turf/simulated/floor/fixed/alium
	list/blend_objects = newlist()

/turf/simulated/wall/alium/Initialize(var/ml)
	. = ..(ml, /decl/material/solid/metal/aliumium)

/turf/simulated/wall/alium/explosion_act(severity)
	SHOULD_CALL_PARENT(TRUE)
	if(prob(explosion_resistance))
		..()

//Cult wall
/turf/simulated/wall/cult
	icon_state = "cult"
	blend_turfs = list(/turf/simulated/wall)

/turf/simulated/wall/cult/Initialize(var/ml, var/reinforce)
	. = ..(ml, /decl/material/solid/stone/cult, reinforce ? /decl/material/solid/stone/cult/reinforced : null)

/turf/simulated/wall/cult/reinf/Initialize(var/ml)
	. = ..(ml, 1)

/turf/simulated/wall/cult/dismantle_wall()
	GLOB.cult.remove_cultiness(CULTINESS_PER_TURF)
	. = ..()

/turf/simulated/wall/cult/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return 1
	else if(istype(W, /turf/simulated/wall))
		return 1
	return 0