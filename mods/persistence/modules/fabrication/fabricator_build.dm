/datum/fabricator_build_order
	var/power_usage
	var/instability = 0
	var/last_instability_check

/obj/machinery/fabricator/update_current_build(var/spend_time)
	if(!istype(currently_building) || !is_functioning())
		return ..()
	if(currently_building.instability > 1 && (world.timeofday - currently_building.last_instability_check > 5 SECONDS))
		currently_building.last_instability_check = world.timeofday
		var/roll = currently_building.instability - rand(2, 100)
		if(roll > 80)
			// Explode
			explosion(loc, 2, 3, 2)
			queued_orders -= currently_building
			qdel(currently_building)
		else if (roll > 20)
			// Lose some time.
			currently_building.remaining_time += (roll - 1) / 10
		else if (roll > 0)
			// Throw some sparks.
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(3, 0, loc)
			sparks.start()

/obj/machinery/fabricator/start_building()
	. = ..()
	currently_building.last_instability_check = world.timeofday
	if(currently_building.power_usage)
		update_use_power(currently_building.power_usage)

/obj/machinery/fabricator/try_queue_build(var/datum/design, var/multiplier)
	if(istype(design, /datum/fabricator_recipe))
		return try_queue_build_design(design, multiplier)
	var/datum/computer_file/data/blueprint/blueprint = design
	// Do some basic sanity checking.
	if(!is_functioning() || !istype(blueprint))
		return
	multiplier = sanitize_integer(multiplier, 1, 100, 1)
	if(!ispath(blueprint.recipe, /obj/item/stack) && multiplier > 1)
		multiplier = 1

	// Check if sufficient resources exist.
	var/list/resources = blueprint.get_resources()
	for(var/material in resources)
		if(stored_material[material] < round(resources[material] * mat_efficiency) * multiplier)
			return

	// Generate and track a new order.
	var/datum/fabricator_build_order/order = new
	order.remaining_time = blueprint.get_build_time()
	order.target_recipe =  blueprint.recipe
	order.multiplier =     multiplier
	order.power_usage =    ceil(initial(active_power_usage) / blueprint.power_efficiency)
	order.instability =    blueprint.instability
	queued_orders +=       order

	// Remove/earmark resources.
	for(var/material in resources)
		var/removed_mat = round(resources[material] * mat_efficiency) * multiplier
		stored_material[material] = max(0, stored_material[material] - removed_mat)
		order.earmarked_materials[material] = removed_mat

	if(!currently_building)
		get_next_build()
	else
		start_building()

/obj/machinery/fabricator/proc/try_queue_build_design(var/datum/fabricator_recipe/recipe, var/multiplier)
		// Do some basic sanity checking.
	if(!is_functioning() || !istype(recipe))
		return
	multiplier = sanitize_integer(multiplier, 1, 100, 1)
	if(!ispath(recipe, /obj/item/stack) && multiplier > 1)
		multiplier = 1

	// Check if sufficient resources exist.
	for(var/material in recipe.resources)
		if(stored_material[material] < round(recipe.resources[material] * mat_efficiency) * multiplier)
			return

	// Generate and track a new order.
	var/datum/fabricator_build_order/order = new
	order.remaining_time = recipe.build_time
	order.target_recipe =  recipe
	order.multiplier =     multiplier
	queued_orders +=       order

	// Remove/earmark resources.
	for(var/material in recipe.resources)
		var/removed_mat = round(recipe.resources[material] * mat_efficiency) * multiplier
		stored_material[material] = max(0, stored_material[material] - removed_mat)
		order.earmarked_materials[material] = removed_mat

	if(!currently_building)
		get_next_build()
	else
		start_building()