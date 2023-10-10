// Init optimization.

var/global/list/machine_path_to_circuit_type
/proc/get_circuit_by_build_path(var/circuit)
	if(!global.machine_path_to_circuit_type)
		global.machine_path_to_circuit_type = cache_circuits_by_build_path()
	return global.machine_path_to_circuit_type[circuit]

/proc/cache_circuits_by_build_path()
	. = list()
	for(var/board_path in subtypesof(/obj/item/stock_parts/circuitboard))
		var/obj/item/stock_parts/circuitboard/board = board_path //fake type
		if(initial(board.buildtype_select))
			board = new board_path()
			for(var/path in board.get_buildable_types())
				.[path] = board_path
			continue
		.[initial(board.build_path)] = board_path

// Code concerning machinery interaction with components/stock parts.

/obj/machinery/proc/populate_parts(var/full_populate) // Full populate creates a circuitboard and all needed components automatically.
	if(full_populate)
		var/path_to_check = base_type || type
		var/board_path = get_circuit_by_build_path(path_to_check)
		if(board_path)
			var/obj/item/stock_parts/circuitboard/board = install_component(board_path, refresh_parts = FALSE)
			var/list/req_components = board.spawn_components || board.req_components
			req_components = req_components.Copy()
			if(board.additional_spawn_components)
				req_components += board.additional_spawn_components
			if(LAZYLEN(req_components))
				LAZYINITLIST(uncreated_component_parts)
				for(var/type in req_components)
					uncreated_component_parts[type] += (req_components[type] || 1)
		if(initial_access && length(initial_access) > 0)
			for(var/access_list in initial_access)
				// Each part is an AND component.
				var/obj/item/stock_parts/network_receiver/network_lock/lock = install_component(/obj/item/stock_parts/network_receiver/network_lock/buildable, refresh_parts = FALSE)
				lock.groups = islist(access_list) ? access_list : list(access_list)

	// Create the parts we are supposed to have. If not full_populate, this is only hard-baked parts, and more will be added later.
	for(var/component_path in uncreated_component_parts)
		var/number = uncreated_component_parts[component_path] || 1
		LAZYREMOVE(uncreated_component_parts, component_path)
		for(var/i in 1 to number)
			install_component(component_path, refresh_parts = FALSE)

	// Apply presets. If not full_populate, this is done later.
	if(full_populate)
		apply_component_presets()

/obj/machinery/proc/apply_component_presets()
	if(!stock_part_presets)
		return

	var/list/processed_parts = list()
	for(var/path in stock_part_presets)
		var/decl/stock_part_preset/preset = GET_DECL(path)
		var/number = stock_part_presets[path] || 1
		for(var/obj/item/stock_parts/part in component_parts)
			if(processed_parts[part])
				continue // only apply one preset per part
			if(istype(part, preset.expected_part_type))
				preset.apply(src, part)
				processed_parts[part] = TRUE
				number--
				if(number == 0)
					break

// Returns the first valid preset decl for a given part, or null
/obj/machinery/proc/can_apply_preset_to(var/obj/item/stock_parts/part)
	if(!stock_part_presets)
		return
	for(var/path in stock_part_presets)
		var/decl/stock_part_preset/preset = GET_DECL(path)
		if(istype(part, preset.expected_part_type))
			return preset

// Applies the first valid preset to the given part. Returns preset applied, or null.
/obj/machinery/proc/apply_preset_to(var/obj/item/stock_parts/part)
	var/decl/stock_part_preset/preset = can_apply_preset_to(part)
	if(preset)
		preset.apply(null, part)
		return preset

// Returns a list of subtypes of the given component type, with associated value = number of that component.
/obj/machinery/proc/types_of_component(var/part_type, var/only_functional)
	. = list()
	for(var/obj/item/stock_parts/component in component_parts)
		if(istype(component, part_type))
			if(!only_functional || component.is_functional())
				.[component.type]++
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			.[path] += uncreated_component_parts[path]

// Returns a component instance of the given type, or null if no such type is present.
/obj/machinery/proc/get_component_of_type(var/part_type, var/strict = FALSE)
	if(strict)
		for(var/obj/component in component_parts)
			if(component.type == part_type)
				return component
		return force_init_component(part_type)

	. = locate(part_type) in component_parts
	if(.)
		return
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			return force_init_component(path)

/obj/machinery/proc/get_all_components_of_type(var/part_type, var/strict = FALSE)
	var/list/results
	for(var/obj/component in component_parts)
		if(istype(component, part_type))
			LAZYADD(results, component)
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			var/obj/component = force_init_component(path)
			while(component)
				LAZYADD(results, component)
				component = force_init_component(path)
	return results

/obj/machinery/proc/force_init_component(var/path)
	if(!LAZYACCESS(uncreated_component_parts, path))
		return
	uncreated_component_parts[path]-- //bookkeeping to make sure tally is correct.
	if(!uncreated_component_parts[path])
		LAZYREMOVE(uncreated_component_parts, path)
	return install_component(path, TRUE)

// Can be given a path or an instance. False will guarantee part creation.
// If an instance is given or created, it is returned, otherwise null is returned.
/obj/machinery/proc/install_component(var/obj/item/stock_parts/part, force = FALSE, refresh_parts = TRUE)
	if(ispath(part))
		if(force || !(ispath(part, /obj/item/stock_parts) && initial(part.part_flags) & PART_FLAG_LAZY_INIT))
			part = new part(src) // Forced to make, or we don't lazy-init, so create.

			if(istype(part, /obj/item/stack)) // Compatibility with legacy construction code
				var/obj/item/stack/stack = part
				stack.amount = 1

			. = part
	else
		part.forceMove(src) // Were given an instance to begin with.
		. = part

	if(istype(part))
		if(part in component_parts)
			CRASH("Tried to insert \a '[part]' twice in \the [src] ([x], [y], [z])!")
		LAZYADD(component_parts, part)
		part.on_install(src)
		events_repository.register(/decl/observ/destroyed, part, src, .proc/component_destroyed)
	else if(ispath(part))
		LAZYINITLIST(uncreated_component_parts)
		uncreated_component_parts[part] += 1
	else // Wrong type
		var/obj/item/stock_parts/building_material/material = get_component_of_type(/obj/item/stock_parts/building_material)
		if(!material)
			material = install_component(/obj/item/stock_parts/building_material, refresh_parts = FALSE)
		material.add_material(part)

	if(refresh_parts)
		RefreshParts()

// This will force-init components.
/obj/machinery/proc/uninstall_component(var/obj/item/stock_parts/part, refresh_parts = TRUE)
	if(ispath(part))
		part = get_component_of_type(part)
	else if(!(part in component_parts))
		return

	if(istype(part))
		part.on_uninstall(src)
		LAZYREMOVE(component_parts, part)
		if(refresh_parts)
			RefreshParts()
		if(QDELETED(part)) // unremovable stuff
			return
		part.dropInto(loc)
		events_repository.unregister(/decl/observ/destroyed, part, src)
		return part

/obj/machinery/proc/replace_part(mob/user, var/obj/item/storage/part_replacer/R, var/obj/item/stock_parts/old_part, var/obj/item/stock_parts/new_part)
	if(ispath(old_part))
		old_part = get_component_of_type(old_part, TRUE)
	old_part = uninstall_component(old_part)
	if(R)
		R.remove_from_storage(new_part, src)
		R.handle_item_insertion(old_part, 1)
		R.part_replacement_sound()
	install_component(new_part)
	to_chat(user, "<span class='notice'>[old_part.name] replaced with [new_part.name].</span>")

/obj/machinery/proc/component_destroyed(var/obj/item/component)
	events_repository.unregister(/decl/observ/destroyed, component, src)
	LAZYREMOVE(component_parts, component)
	LAZYREMOVE(processing_parts, component)
	power_components -= component

/obj/machinery/proc/total_component_rating_of_type(var/part_type)
	. = 0
	for(var/thing in component_parts)
		if(istype(thing, part_type))
			var/obj/item/stock_parts/part = thing
			if(part.is_functional())
				. += part.rating
	for(var/path in uncreated_component_parts)
		if(ispath(path, part_type))
			var/obj/item/stock_parts/comp = path
			. += initial(comp.rating) * uncreated_component_parts[path]

/obj/machinery/proc/number_of_components(var/part_type, var/only_functional)
	if(!ispath(part_type, /obj/item/stock_parts))
		var/obj/item/stock_parts/building_material/material = get_component_of_type(/obj/item/stock_parts/building_material)
		return material && material.number_of_type(part_type)
	var/list/comps = types_of_component(part_type, only_functional)
	. = 0
	for(var/path in comps)
		. += comps[path]

// Use to block interactivity if panel is not open, etc.
/obj/machinery/proc/components_are_accessible(var/path)
	if(ispath(path, /obj/item/stock_parts/access_lock) || ispath(path, /obj/item/stock_parts/item_holder))
		return TRUE
	return panel_open

// Installation. Returns number of such components which can be inserted, or 0.
/obj/machinery/proc/can_add_component(var/obj/item/stock_parts/component, var/mob/user)
	if(!istype(component)) // Random items. Only insert if actually needed.
		var/list/missing = missing_parts()
		for(var/path in missing)
			if(istype(component, path))
				return missing[path]
		return 0
	if(!(component.part_flags & PART_FLAG_HAND_REMOVE))
		return 0
	if(!components_are_accessible(component.type))
		to_chat(user, SPAN_WARNING("The insertion point for \the [component] is inaccessible!"))
		return 0
	for(var/path in maximum_component_parts)
		if(istype(component, path) && (number_of_components(path) == maximum_component_parts[path]))
			to_chat(user, SPAN_WARNING("There are too many parts of this type installed in \the [src] already!"))
			return 0
	return 1

// Hook to get updates.
/obj/machinery/proc/component_stat_change(var/obj/item/stock_parts/part, old_stat, flag)

/obj/machinery/attackby(obj/item/I, mob/user)
	if(component_attackby(I, user))
		return TRUE
	return ..()

/obj/machinery/proc/component_attackby(obj/item/I, mob/user)
	for(var/obj/item/stock_parts/part in component_parts)
		if(!components_are_accessible(part.type))
			continue
		if((. = part.attackby(I, user)))
			return
	return construct_state && construct_state.attackby(I, user, src)

/obj/machinery/proc/component_attack_hand(mob/user)
	for(var/obj/item/stock_parts/part in component_parts)
		if(!components_are_accessible(part.type))
			continue
		if((. = part.attack_hand(user)))
			return
	return construct_state?.attack_hand(user, src)

/*
Standard helpers for users interacting with machinery parts.
*/

/obj/machinery/proc/part_replacement(mob/user, obj/item/storage/part_replacer/R)
	for(var/obj/item/stock_parts/A in component_parts)
		if(!A.base_type)
			continue
		if(!(A.part_flags & PART_FLAG_HAND_REMOVE))
			continue
		for(var/obj/item/stock_parts/B in R.contents)
			if(istype(B, A.base_type) && B.rating > A.rating)
				replace_part(user, R, A, B)
				return TRUE
	for(var/path in uncreated_component_parts)
		var/obj/item/stock_parts/A = path
		if(!(initial(A.part_flags) & PART_FLAG_HAND_REMOVE))
			continue
		var/base_type = initial(A.base_type)
		if(base_type)
			for(var/obj/item/stock_parts/B in R.contents)
				if(istype(B, base_type) && B.rating > initial(A.rating))
					replace_part(user, R, A, B)
					return TRUE

/obj/machinery/proc/part_insertion(mob/user, obj/item/stock_parts/part) // Second argument may actually be an arbitrary item.
	if(!user.canUnEquip(part) && !isstack(part))
		return FALSE
	var/number = can_add_component(part, user)
	if(!number)
		return istype(part) // If it's not a stock part, we don't block further interactions; presumably the user meant to do something else.
	if(isstack(part))
		var/obj/item/stack/stack = part
		install_component(stack.split(number, TRUE))
	else
		user.try_unequip(part, src)
		install_component(part)
	user.visible_message(SPAN_NOTICE("\The [user] installs \the [part] in \the [src]!"), SPAN_NOTICE("You install \the [part] in \the [src]!"))
	return TRUE

/obj/machinery/proc/part_removal(mob/user)
	var/list/removable_parts = list()
	for(var/path in types_of_component(/obj/item/stock_parts))
		var/obj/item/stock_parts/part = path
		if(!(initial(part.part_flags) & PART_FLAG_HAND_REMOVE))
			continue
		var/obj/item/stock_parts/network_receiver/network_lock/lock = part
		if(istype(lock) && !allowed(user))
			continue
		if(components_are_accessible(path))
			removable_parts[initial(part.name)] = path
	if(length(removable_parts))
		var/input = input(user, "Which part would you like to uninstall from \the [src]?", "Part Removal") as null|anything in removable_parts
		if(!input || QDELETED(src) || !Adjacent(user) || user.incapacitated())
			return TRUE
		var/path = removable_parts[input]
		if(!path || !components_are_accessible(path))
			return TRUE
		remove_part_and_give_to_user(path, user)
		return TRUE

/obj/machinery/proc/remove_part_and_give_to_user(var/path, mob/user)
	var/obj/item/stock_parts/part = uninstall_component(get_component_of_type(path, TRUE))
	if(part)
		user.put_in_hands(part) // Already dropped at loc, so that's the fallback.
		user.visible_message(SPAN_NOTICE("\The [user] removes \the [part] from \the [src]."), SPAN_NOTICE("You remove \the [part] from \the [src]."))

/obj/machinery/proc/missing_parts(var/only_functional)
	if(!construct_state)
		return
	var/list/requirements = construct_state.get_requirements(src)
	if(LAZYLEN(requirements))
		for(var/required_type in requirements)
			var/needed = requirements[required_type]
			var/present = number_of_components(required_type, only_functional)
			if(present < needed)
				LAZYSET(., required_type, needed - present)
