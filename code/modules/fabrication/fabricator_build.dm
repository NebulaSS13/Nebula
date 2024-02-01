#define MAX_QUEUED_ORDERS 100
/obj/machinery/fabricator/proc/update_current_build(var/spend_time)

	if(!istype(currently_building) || !is_functioning())
		return

	// Decrement our current build timer.
	currently_building.remaining_time -= max(1, max(1, spend_time * build_time_multiplier))
	if(currently_building.remaining_time > 0)
		return

	// Print the item.
	do_build(currently_building)
	QDEL_NULL(currently_building)
	get_next_build()
	update_icon()

/obj/machinery/fabricator/proc/do_build(var/datum/fabricator_build_order/order)
	. = order.target_recipe.build(get_turf(src), order)
	if(output_dir)
		for(var/atom/movable/product in .)
			step(product, output_dir)

/obj/machinery/fabricator/proc/start_building()
	if(is_functioning())
		update_use_power(POWER_USE_ACTIVE)

/obj/machinery/fabricator/proc/stop_building()
	update_use_power(POWER_USE_IDLE)

/obj/machinery/fabricator/power_change()
	. = ..()
	if(.)
		if(stat & (BROKEN|NOPOWER))
			stop_building()
		else if(!currently_building)
			get_next_build()
		else
			start_building()

/obj/machinery/fabricator/update_use_power()
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		fab_status_flags |= FAB_BUSY
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, fabricator_sound, volume = 30)
		if(!currently_building)
			get_next_build()
	else
		fab_status_flags &= ~FAB_BUSY
		QDEL_NULL(sound_token)
		// This is to allow people to fix the fab when it
		// gets stuck building a recipe during power loss.
		if(istype(currently_building))
			queued_orders.Insert(1, currently_building)
		currently_building = null

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

	// Check if sufficient resources exist.
	for(var/material in recipe.resources)
		if(stored_material[material] < round(recipe.resources[material] * mat_efficiency) * multiplier)
			return

	//Ask subclass if its okay to print
	if(!can_build(recipe, multiplier))
		return

	var/amount_queued = 1
	if(!ispath(recipe.path, /obj/item/stack) && multiplier > 1)
		// For non-stacks, multipliers just queue more orders.
		amount_queued = multiplier
		multiplier = 1
	// Generate and track the new order(s).
	amount_queued = min(amount_queued, MAX_QUEUED_ORDERS - length(queued_orders))
	for(var/i in 1 to amount_queued)
		var/datum/fabricator_build_order/order = make_order(recipe, multiplier)
		queued_orders += order

		// Remove/earmark resources.
		for(var/material in recipe.resources)
			var/removed_mat = round(recipe.resources[material] * mat_efficiency) * multiplier
			stored_material[material] = max(0, stored_material[material] - removed_mat)
			order.earmarked_materials[material] = removed_mat

	if(!currently_building)
		get_next_build()
	else
		start_building()

//Allow storing more details in the order for fabricator subclasses
/obj/machinery/fabricator/proc/make_order(var/datum/fabricator_recipe/recipe, var/multiplier)
	var/datum/fabricator_build_order/order = new
	order.remaining_time = recipe.build_time
	order.target_recipe =  recipe
	order.multiplier =     multiplier
	return order

//Override this to add more conditions to printing an object
/obj/machinery/fabricator/proc/can_build(var/datum/fabricator_recipe/recipe, var/multiplier)
	return TRUE

#undef MAX_QUEUED_ORDERS