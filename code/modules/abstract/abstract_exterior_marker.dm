/obj/abstract/exterior_marker
	abstract_type = /obj/abstract/exterior_marker
	var/set_outside

/obj/abstract/exterior_marker/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/abstract/exterior_marker/LateInitialize()
	var/turf/T = loc
	if(istype(T))
		T.set_outside(set_outside)
	qdel(src)

/obj/abstract/exterior_marker/Initialize()
	..()
	var/turf/T = loc
	if(istype(T))
		T.set_outside(set_outside)
	return INITIALIZE_HINT_QDEL

/obj/abstract/exterior_marker/outside
	name = "Outside"
	set_outside = OUTSIDE_NO

/obj/abstract/exterior_marker/inside
	name = "Inside"
	set_outside = OUTSIDE_YES

/obj/abstract/exterior_marker/use_area
	name = "Use Area Outside"
	set_outside = OUTSIDE_AREA
