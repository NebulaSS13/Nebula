/turf/proc/cultify()
	return

/turf/simulated/floor/cultify()
	//todo: flooring datum cultify check
	cultify_floor()

/turf/simulated/shuttle/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cult/cultify()
	return

/turf/unsimulated/wall/cult/cultify()
	return

/turf/unsimulated/beach/cultify()
	return

/turf/unsimulated/wall/cultify()
	cultify_wall()

/turf/simulated/floor/proc/cultify_floor()
	set_flooring(decls_repository.get_decl(/decl/flooring/reinforced/cult))
	var/decl/special_role/cultist/cult = decls_repository.get_decl(/decl/special_role/cultist)
	cult.add_cultiness(CULTINESS_PER_TURF)

/turf/proc/cultify_wall()
	var/turf/simulated/wall/wall = src
	if(!istype(wall))
		return
	if(wall.reinf_material)
		ChangeTurf(/turf/simulated/wall/cult/reinf)
	else
		ChangeTurf(/turf/simulated/wall/cult)
	var/decl/special_role/cultist/cult = decls_repository.get_decl(/decl/special_role/cultist)
	cult.add_cultiness(CULTINESS_PER_TURF)
