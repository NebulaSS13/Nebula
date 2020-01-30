//Commonly used
/turf/simulated/wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall/prepainted
	paint_color = COLOR_GUNMETAL

/turf/simulated/wall/r_wall
	icon_state = "r_generic"

/turf/simulated/wall/r_wall/New(var/newloc)
	..(newloc, MAT_PLASTEEL,MAT_PLASTEEL) //3strong

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

/turf/simulated/wall/titanium/New(var/newloc)
	..(newloc,MAT_TITANIUM)

/turf/simulated/wall/r_titanium
	icon_state = "r_titanium"

/turf/simulated/wall/r_titanium/New(var/newloc)
	..(newloc, MAT_TITANIUM,MAT_TITANIUM)

/turf/simulated/wall/ocp_wall
	icon_state = "r_ocp"

/turf/simulated/wall/ocp_wall/New(var/newloc)
	..(newloc, MAT_OSMIUM_CARBIDE_PLASTEEL, MAT_OSMIUM_CARBIDE_PLASTEEL)

//Material walls

/turf/simulated/wall/r_wall/rglass_wall/New(var/newloc)
	..(newloc, MAT_GLASS, MAT_STEEL)
	icon_state = "r_generic"

/turf/simulated/wall/iron/New(var/newloc)
	..(newloc,MAT_IRON)

/turf/simulated/wall/uranium/New(var/newloc)
	..(newloc,MAT_URANIUM)

/turf/simulated/wall/diamond/New(var/newloc)
	..(newloc,MAT_DIAMOND)

/turf/simulated/wall/gold/New(var/newloc)
	..(newloc,MAT_GOLD)

/turf/simulated/wall/silver/New(var/newloc)
	..(newloc,MAT_SILVER)

/turf/simulated/wall/phoron/New(var/newloc)
	..(newloc,MAT_PHORON)

/turf/simulated/wall/sandstone/New(var/newloc)
	..(newloc,MAT_SANDSTONE)

/turf/simulated/wall/rutile/New(var/newloc)
	..(newloc,MAT_RUTILE)

/turf/simulated/wall/wood
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/wood/New(var/newloc)
	..(newloc,MAT_WOOD)

/turf/simulated/wall/mahogany
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/mahogany/New(var/newloc)
	..(newloc,MAT_MAHOGANY)

/turf/simulated/wall/maple
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/maple/New(var/newloc)
	..(newloc,MAT_MAPLE)

/turf/simulated/wall/ebony
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/ebony/New(var/newloc)
	..(newloc,MAT_EBONY)

/turf/simulated/wall/walnut
	blend_turfs = list(/turf/simulated/wall/cult, /turf/simulated/wall)
	icon_state = "woodneric"

/turf/simulated/wall/walnut/New(var/newloc)
	..(newloc,MAT_WALNUT)

/turf/simulated/wall/ironphoron/New(var/newloc)
	..(newloc,MAT_IRON,MAT_PHORON)

/turf/simulated/wall/golddiamond/New(var/newloc)
	..(newloc,MAT_GOLD,MAT_DIAMOND)

/turf/simulated/wall/silvergold/New(var/newloc)
	..(newloc,MAT_SILVER,MAT_GOLD)

/turf/simulated/wall/sandstonediamond/New(var/newloc)
	..(newloc,MAT_SANDSTONE,MAT_DIAMOND)

/turf/simulated/wall/crystal/New(var/newloc)
	..(newloc,MAT_CRYSTAL)

/turf/simulated/wall/voxshuttle/New(var/newloc)
	..(newloc, MAT_VOX)

/turf/simulated/wall/voxshuttle/attackby()
	return

/turf/simulated/wall/concrete/New(var/newloc)
	..(newloc,MAT_CONCRETE)

//Alien metal walls
/turf/simulated/wall/alium
	icon_state = "jaggy"
	floor_type = /turf/simulated/floor/fixed/alium
	list/blend_objects = newlist()

/turf/simulated/wall/alium/New(var/newloc)
	..(newloc,MAT_ALIENALLOY)

/turf/simulated/wall/alium/ex_act(severity)
	if(prob(explosion_resistance))
		return
	..()

//Cult wall
/turf/simulated/wall/cult
	icon_state = "cult"
	blend_turfs = list(/turf/simulated/wall)

/turf/simulated/wall/cult/New(var/newloc, var/reinforce = 0)
	..(newloc, MAT_CULT, reinforce ? MAT_REINFORCED_CULT : null)

/turf/simulated/wall/cult/reinf/New(var/newloc)
	..(newloc, 1)

/turf/simulated/wall/cult/dismantle_wall()
	GLOB.cult.remove_cultiness(CULTINESS_PER_TURF)
	..()

/turf/simulated/wall/cult/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return 1
	else if(istype(W, /turf/simulated/wall))
		return 1
	return 0