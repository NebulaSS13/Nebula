/obj/machinery/fabricator/proc/update_current_build(var/spend_time)

	if(!istype(currently_building) || !is_functioning())
		return

	// Decrement our current build timer.
	currently_building.remaining_time -= max(1, max(1, spend_time * build_time_multiplier))
	if(currently_building.remaining_time > 0)
		return

	// Print the item.
	do_build(currently_building.target_recipe, currently_building.multiplier)
	QDEL_NULL(currently_building)
	get_next_build()
	update_icon()

/obj/machinery/fabricator/proc/do_build(var/datum/fabricator_recipe/recipe, var/amount)
	. = recipe.build(get_turf(src), amount)
	if(output_dir)
		for(var/atom/movable/product in .)
			step(product, output_dir)

/obj/machinery/fabricator/proc/start_building()
	if(!(fab_status_flags & FAB_BUSY) && is_functioning())
		fab_status_flags |= FAB_BUSY
		update_use_power(POWER_USE_ACTIVE)
		sound_token = play_looping_sound(src, sound_id, fabricator_sound, volume = 30)

/obj/machinery/fabricator/proc/stop_building()
	if(fab_status_flags & FAB_BUSY)
		fab_status_flags &= ~FAB_BUSY
		update_use_power(POWER_USE_IDLE)
		QDEL_NULL(sound_token)

/obj/machinery/fabricator/proc/get_next_build()
	currently_building = null
	if(length(queued_orders))
		currently_building = queued_orders[1]
		queued_orders -= currently_building
		start_building()
	else
		stop_building()
	updateUsrDialog()

/obj/machinery/fabricator/proc/try_queue_build(var/datum/fabricator_recipe/recipe, var/multiplier)

	// Do some basic sanity checking.
	if(!is_functioning() || !istype(recipe) || !(recipe in design_cache))
		return
	multiplier = sanitize_integer(multiplier, 1, 100, 1)
	if(!ispath(recipe.path, /obj/item/stack) && multiplier > 1)
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