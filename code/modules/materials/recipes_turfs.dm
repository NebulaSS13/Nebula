/datum/stack_recipe/turfs
	abstract_type = /datum/stack_recipe/turfs
	expected_product_type = /turf
	time = 3 SECONDS
	req_amount = 5 // Arbitrary value since turfs don't behave like objs in terms of material/matter

// See req_amount above.
/datum/stack_recipe/turfs/InitializeMaterials()
	return

/datum/stack_recipe/turfs/spawn_result(mob/user, location, amount)
	var/turf/build_turf = get_turf(location)
	if(!build_turf)
		return
	var/turf/result = build_turf.ChangeTurf(result_type)
	if(istype(result) && (use_material || use_reinf_material))
		result.set_turf_materials(use_material, use_reinf_material)
	return result

/datum/stack_recipe/turfs/wall
	abstract_type = /datum/stack_recipe/turfs/wall
	expected_product_type = /turf/simulated/wall

/datum/stack_recipe/turfs/wall/brick
	title = "brick wall"
	result_type = /turf/simulated/wall/brick

/datum/stack_recipe/turfs/wall/log
	title = "log wall"
	result_type = /turf/simulated/wall/log

/datum/stack_recipe/turfs/path
	abstract_type = /datum/stack_recipe/turfs/path
	expected_product_type = /turf/exterior

/datum/stack_recipe/turfs/path
	title = "cobble path"
	result_type = /turf/exterior/path

/datum/stack_recipe/turfs/path/herringbone
	title = "herringbone path"
	result_type = /turf/exterior/path/herringbone

/datum/stack_recipe/turfs/path/running_bond
	title = "running bond path"
	result_type = /turf/exterior/path/running_bond
