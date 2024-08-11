/obj/machinery/recycler
	name                      = "recycler"
	desc                      = "An advanced machine that breaks objects down into their constitute material. Click and drag it onto yourself to open the hopper."
	density                   = TRUE
	anchored                  = TRUE
	icon                      = 'icons/obj/machines/recycler.dmi'
	icon_state                = "recycler"
	idle_power_usage          = 10
	active_power_usage        = 2000
	clicksound                = "keyboard"
	clickvol                  = 30
	uncreated_component_parts = null
	stat_immune               = 0
//	wires                     = /datum/wires/recycler // No idea what wires should do for a recycler.
	base_type                 = /obj/machinery/recycler
	construct_state           = /decl/machine_construction/default/panel_closed
	storage                   = /datum/storage/hopper/industrial

	var/recycling_efficiency  = 0.65
	var/created_stack_type    = /obj/item/stack/material/cubes
	var/list/trace_matter     = list()

	// Stolen from fabricators.
	var/sound_id
	var/datum/sound_token/sound_token
	var/work_sound = 'sound/machines/fabricator_loop.ogg'

/obj/machinery/recycler/Initialize()
	sound_id = "[work_sound]"
	return ..()

/obj/machinery/recycler/Destroy()
	QDEL_NULL(sound_token)
	return ..()

/obj/machinery/recycler/update_use_power()
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, work_sound, volume = 30)
	else
		dump_trace_material()
		QDEL_NULL(sound_token)

/obj/machinery/recycler/Process(wait, tick)
	..()
	if(use_power != POWER_USE_ACTIVE)
		return

	var/list/processing_items = get_stored_inventory()
	if(!length(processing_items))
		visible_message("\The [src] disengages with a low clunk.")
		update_use_power(POWER_USE_IDLE)
		return

	// Combine our current leftover matter with an item to munch.
	// Trace matter will get written back if left over.
	var/obj/munching = processing_items[1]
	var/list/fell_out = list()
	for(var/obj/item/thing in munching.get_contained_external_atoms())
		thing.dropInto(loc)
		fell_out += thing

	var/list/munched_matter = munching.get_contained_matter()
	for(var/mat in munched_matter)
		// Lose some matter in the process of recycling.
		munched_matter[mat] = max(1, round(munched_matter[mat] * recycling_efficiency))
		// Add trace matter back in for this pass.
		if(trace_matter[mat])
			munched_matter[mat] += trace_matter[mat]
			trace_matter -= mat
	munching.clear_matter()
	qdel(munching)

	for(var/obj/item/thing in fell_out)
		if(storage?.can_be_inserted(thing))
			fell_out -= thing
			storage.handle_item_insertion(null, thing)

	if(length(fell_out))
		visible_message("[capitalize(english_list(fell_out))] fall out of \the overflowing [src]!")

	for(var/mat in munched_matter)
		var/decl/material/material = GET_DECL(mat)
		switch(material.phase_at_temperature())
			if(MAT_PHASE_SOLID)

				// Dump the material out as a stack.
				var/obj/item/stack/material/cubestack = created_stack_type
				var/max_stack = initial(cubestack.max_amount)
				var/stack_amount = floor(munched_matter[mat] / SHEET_MATERIAL_AMOUNT)

				// Keep track of any trace matter for the next run.
				munched_matter[mat] -= stack_amount * SHEET_MATERIAL_AMOUNT

				while(stack_amount >= max_stack)
					stack_amount -= max_stack
					new created_stack_type(get_turf(src), max_stack, mat)
				if(stack_amount > 0)
					var/obj/item/stack/last_stack = new created_stack_type(get_turf(src), stack_amount, mat)
					last_stack.add_to_stacks()

			if(MAT_PHASE_LIQUID)
				// TODO: dump to a reagent container.
				munched_matter -= mat
				continue
			if(MAT_PHASE_GAS)
				// TODO: dump to a gas container.
				munched_matter -= mat
				continue

		if(munched_matter[mat] > 0)
			trace_matter[mat] += munched_matter[mat] * recycling_efficiency

/obj/machinery/recycler/attackby(obj/item/W, mob/user)

	if(use_power == POWER_USE_ACTIVE)
		to_chat(user, SPAN_WARNING("\The [src] is currently processing, please wait for it to finish."))
		return TRUE

	if(W.storage && user.a_intent != I_HURT)

		var/emptied = FALSE
		for(var/obj/item/O in W.get_stored_inventory())
			if(storage.can_be_inserted(O))
				W.storage.remove_from_storage(null, O, loc, skip_update = TRUE)
				storage.handle_item_insertion(null, O, skip_update = TRUE)
				emptied = TRUE

		if(emptied)
			W.storage.finish_bulk_removal()
			storage.update_ui_after_item_insertion(user)
			if(length(W.get_stored_inventory()))
				to_chat(user, SPAN_NOTICE("You partially empty \the [W] into \the [src]'s hopper."))
			else
				to_chat(user, SPAN_NOTICE("You empty \the [W] into \the [src]'s hopper."))
			W.update_icon()
			return TRUE

	// Parent call so we can interact with the machinery aspect
	// People can use the mousedrop storage UI to put wrenches and screwdrivers into the hopper if needed.
	. = ..()

/obj/machinery/recycler/on_update_icon()
	icon_state = initial(icon_state)
	if(use_power == POWER_USE_OFF || !operable())
		icon_state = "[icon_state]_d"
	else if(use_power == POWER_USE_ACTIVE)
		icon_state = "[icon_state]_p"

/obj/machinery/recycler/attack_hand(mob/user)
	if(use_power == POWER_USE_ACTIVE)
		user.visible_message("\The [user] disengages \the [src].")
		update_use_power(POWER_USE_IDLE)
		return TRUE
	if(use_power == POWER_USE_IDLE)
		if(length(get_stored_inventory()))
			user.visible_message("\The [user] engages \the [src].")
			update_use_power(POWER_USE_ACTIVE)
		else
			to_chat(user, SPAN_WARNING("\The [src]'s hopper is empty."))
		return TRUE
	if(use_power == POWER_USE_OFF || !operable())
		to_chat(user, SPAN_WARNING("\The [src]'s interface is unresponsive."))
		return TRUE
	return ..()

/obj/item/scrap_material/attackby(obj/item/W, mob/user)

	if(W.type == type && user.try_unequip(W))

		LAZYINITLIST(matter)
		for(var/mat in W.matter)
			matter[mat] += W.matter[mat]
		UNSETEMPTY(matter)
		W.matter = null

		to_chat(user, SPAN_NOTICE("You combine \the [src] and \the [W]."))
		qdel(W)

		return TRUE

	return ..()

/obj/machinery/recycler/proc/dump_trace_material(atom/forced_loc = loc)

	if(!length(trace_matter))
		return

	var/obj/item/debris/scraps/remains = new(forced_loc)
	remains.matter = trace_matter?.Copy()
	remains.update_primary_material()
	trace_matter.Cut()

/obj/machinery/recycler/dump_contents(atom/forced_loc = loc, mob/user)
	dump_trace_material(forced_loc)
	return ..()

/obj/machinery/recycler/RefreshParts()
	..()
	var/efficiency_rating = total_component_rating_of_type(/obj/item/stock_parts/manipulator) + total_component_rating_of_type(/obj/item/stock_parts/micro_laser)
	// 5% better return for each rating level.
	recycling_efficiency = clamp(initial(recycling_efficiency) + efficiency_rating * 0.05, 0, 0.95)
	// equivalent of one box per matter bin rating level.
	var/storage_rating = total_component_rating_of_type(/obj/item/stock_parts/matter_bin)
	storage.max_storage_space = initial(storage.max_storage_space)
	storage.max_storage_space = clamp(storage.max_storage_space * storage_rating, storage.max_storage_space, BASE_STORAGE_CAPACITY(ITEM_SIZE_STRUCTURE))
