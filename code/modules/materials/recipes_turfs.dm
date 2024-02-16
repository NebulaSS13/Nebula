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
	return build_turf.ChangeTurf(result_type)

/datum/stack_recipe/turfs/wall
	abstract_type = /datum/stack_recipe/turfs/wall
	expected_product_type = /turf/simulated/wall

/datum/stack_recipe/turfs/wall/spawn_result(mob/user, location, amount)
	var/turf/simulated/wall/wall = ..()
	if(istype(wall))
		wall.set_material(use_material, use_reinf_material)

/datum/stack_recipe/turfs/wall/brick
	title = "brick wall"
	result_type = /turf/simulated/wall/brick
