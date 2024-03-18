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

	var/recycling_efficiency  = 0.65
	var/created_stack_type    = /obj/item/stack/material/cubes
	var/list/trace_matter     = list()
	var/obj/item/storage/internal/recycler_hopper/hopper

	// Stolen from fabricators.
	var/sound_id
	var/datum/sound_token/sound_token
	var/work_sound = 'sound/machines/fabricator_loop.ogg'

/obj/item/storage/internal/recycler_hopper
	name              = "recycler hopper"
	w_class           = ITEM_SIZE_STRUCTURE
	max_w_class       = ITEM_SIZE_GARGANTUAN
	max_storage_space = BASE_STORAGE_CAPACITY(ITEM_SIZE_NORMAL)

/obj/machinery/recycler/Initialize()
	hopper = new(src)
	sound_id = "[work_sound]"
	return ..()

/obj/machinery/recycler/Destroy()
	QDEL_NULL(hopper)
	QDEL_NULL(sound_token)
	return ..()

/obj/machinery/recycler/handle_mouse_drop(atom/over, mob/user, params)
	return hopper?.handle_storage_internal_mouse_drop(user, over, params) || ..()

/obj/machinery/recycler/update_use_power()
	. = ..()
	if(use_power == POWER_USE_ACTIVE)
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, work_sound, volume = 30)
	else
		QDEL_NULL(sound_token)

/obj/machinery/recycler/Process(wait, tick)
	..()
	if(use_power != POWER_USE_ACTIVE)
		return

	var/list/processing_items = hopper?.get_contained_external_atoms()
	if(!length(processing_items))
		visible_message("\The [src] disengages with a low clunk.")
		dump_trace_material()
		update_use_power(POWER_USE_IDLE)
		return

	// Combine our current leftover matter with an item to munch.
	// Trace matter will get written back if left over.
	var/obj/munching = processing_items[1]
	for(var/obj/item/thing in munching.get_contained_external_atoms())
		if(hopper.can_be_inserted(thing))
			hopper.handle_item_insertion(thing)
		else
			thing.dropInto(loc)

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

	for(var/mat in munched_matter)
		var/decl/material/material = GET_DECL(mat)
		switch(material.phase_at_temperature())
			if(MAT_PHASE_SOLID)

				// Dump the material out as a stack.
				var/obj/item/stack/material/cubestack = created_stack_type
				var/max_stack = initial(cubestack.max_amount)
				var/stack_amount = FLOOR(munched_matter[mat] / SHEET_MATERIAL_AMOUNT)

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
	// Parent call so we can interact with the machinery aspect
	// People can use the mousedrop storage UI to put wrenches and screwdrivers into the hopper if needed.
	. = ..() || (isobj(W) && hopper?.attackby(W, user))

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
		if(length(hopper?.get_contained_external_atoms()))
			user.visible_message("\The [user] engages \the [src].")
			update_use_power(POWER_USE_ACTIVE)
		else
			to_chat(user, SPAN_WARNING("\The [src]'s hopper is empty."))
		return TRUE
	if(use_power == POWER_USE_OFF || !operable())
		to_chat(user, SPAN_WARNING("\The [src]'s interface is unresponsive."))
		return TRUE
	return ..()

/obj/machinery/recycler/get_contained_external_atoms()
	. = ..()
	if(hopper)
		LAZYADD(., hopper.get_contained_external_atoms())
		LAZYREMOVE(., hopper)

/obj/item/scrap_material
	name = "scraps"
	desc = "Tailings and scraps left over from the recycling process."
	icon = 'icons/obj/melted_thing.dmi'
	icon_state = ICON_STATE_WORLD

/obj/machinery/recycler/proc/dump_trace_material(atom/forced_loc = loc)

	if(!length(trace_matter))
		return

	var/highest_mat
	var/last_highest = 0
	var/list/mat_names = list()
	for(var/mat in trace_matter)
		var/decl/material/material = GET_DECL(mat)
		mat_names += material.solid_name
		if(isnull(highest_mat) || trace_matter[mat] > last_highest)
			highest_mat = mat
			last_highest = trace_matter[mat]

	if(highest_mat)
		var/obj/item/scrap_material/remains = new(forced_loc, highest_mat)
		remains.matter = trace_matter?.Copy()
		remains.name = "[english_list(mat_names)] scraps"
		remains.color = remains.material.color

	trace_matter.Cut()

/obj/machinery/recycler/dump_contents(atom/forced_loc = loc, mob/user)
	dump_trace_material(forced_loc)
	hopper?.dump_contents(forced_loc)
	return ..()

/obj/machinery/recycler/emp_act(severity)
	hopper?.emp_act(severity)
	return ..()

/obj/machinery/recycler/RefreshParts()
	..()
	var/efficiency_rating = total_component_rating_of_type(/obj/item/stock_parts/manipulator) + total_component_rating_of_type(/obj/item/stock_parts/micro_laser)
	// 5% better return for each rating level.
	recycling_efficiency = clamp(initial(recycling_efficiency) + efficiency_rating * 0.05, 0, 0.95)
	// equivalent of one box per matter bin rating level.
	var/storage_rating = total_component_rating_of_type(/obj/item/stock_parts/matter_bin)
	hopper.max_storage_space = initial(hopper.max_storage_space)
	hopper.max_storage_space = clamp(hopper.max_storage_space * storage_rating, hopper.max_storage_space, BASE_STORAGE_CAPACITY(ITEM_SIZE_STRUCTURE))
