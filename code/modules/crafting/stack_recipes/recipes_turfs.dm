/decl/stack_recipe/turfs
	abstract_type = /decl/stack_recipe/turfs
	expected_product_type = /turf
	time = 3 SECONDS
	req_amount = 5 // Arbitrary value since turfs don't behave like objs in terms of material/matter

// See req_amount above.
/decl/stack_recipe/turfs/update_req_amount()
	return

/decl/stack_recipe/turfs/spawn_result(mob/user, location, amount)
	var/turf/build_turf = get_turf(location)
	if(!build_turf)
		return
	var/turf/result = build_turf.ChangeTurf(result_type)
	if(istype(result) && (use_material || use_reinf_material))
		result.set_turf_materials(use_material, use_reinf_material)
	return result

/decl/stack_recipe/turfs/wall
	abstract_type = /decl/stack_recipe/turfs/wall
	expected_product_type = /turf/simulated/wall

/decl/stack_recipe/turfs/wall/spawn_result(mob/user, location, amount)
	var/turf/simulated/wall/wall = ..()
	if(istype(wall))
		wall.set_material(use_material, use_reinf_material)
