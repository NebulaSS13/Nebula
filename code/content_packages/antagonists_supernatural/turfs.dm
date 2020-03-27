
//Cult wall
/turf/simulated/wall/cult
	icon_state = "cult"
	blend_turfs = list(/turf/simulated/wall)

/turf/simulated/wall/cult/Initialize(var/ml, var/reinforce)
	. = ..(ml, MAT_CULT, reinforce ? MAT_REINFORCED_CULT : null)

/turf/simulated/wall/cult/reinf/Initialize(var/ml)
	. = ..(ml, 1)

/turf/simulated/wall/cult/dismantle_wall()
	GLOB.cult.remove_cultiness(CULTINESS_PER_TURF)
	..()

/turf/simulated/wall/cult/can_join_with(var/turf/simulated/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return 1
	else if(istype(W, /turf/simulated/wall))
		return 1
	return 0

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
	GLOB.cult.remove_cultiness(CULTINESS_PER_TURF)

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

/turf/remove_cleanables()
	. = ..()
	for(var/obj/effect/decal/cleanable/rune/O in src)
		qdel(O)
