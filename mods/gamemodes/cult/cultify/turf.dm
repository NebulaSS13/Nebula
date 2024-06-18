/turf/on_defilement()
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.add_cultiness(CULTINESS_PER_TURF)

/turf/proc/is_defiled()
	return (locate(/obj/effect/narsie_footstep) in src)

/turf/floor/on_defilement()
	if(flooring?.type != /decl/flooring/reinforced/cult)
		..()
		set_flooring(GET_DECL(/decl/flooring/reinforced/cult))

/turf/floor/is_defiled()
	return flooring?.type == /decl/flooring/reinforced/cult || ..()

/turf/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult

/turf/wall/on_defilement()
	var/new_material
	if(material?.type != /decl/material/solid/stone/cult)
		new_material = /decl/material/solid/stone/cult
	var/new_rmaterial
	if(reinf_material && reinf_material.type != /decl/material/solid/stone/cult/reinforced)
		new_rmaterial = /decl/material/solid/stone/cult/reinforced
	if(new_material || new_rmaterial)
		..()
		set_turf_materials(new_material, new_rmaterial)

/turf/wall/is_defiled()
	return material?.type == /decl/material/solid/stone/cult || reinf_material?.type == /decl/material/solid/stone/cult/reinforced || ..()

//Cult wall
/turf/wall/cult
	icon_state = "cult"
	color = COLOR_RED_GRAY
	material = /decl/material/solid/stone/cult

/turf/wall/cult/reinf
	icon_state = "reinforced_cult"
	reinf_material = /decl/material/solid/stone/cult/reinforced

/turf/wall/cult/dismantle_turf(devastated, explode, no_product, keep_air = TRUE)
	var/decl/special_role/cultist/cult = GET_DECL(/decl/special_role/cultist)
	cult.remove_cultiness(CULTINESS_PER_TURF)
	. = ..()

/turf/wall/cult/can_join_with(var/turf/wall/W)
	if(material && W.material && material.icon_base == W.material.icon_base)
		return FALSE
	else if(istype(W, /turf/wall))
		return TRUE
	return FALSE

/turf/wall/natural/on_defilement()
	ChangeTurf(/turf/wall/cult)

/turf/unsimulated/on_defilement()
	return