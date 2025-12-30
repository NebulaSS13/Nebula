/turf/floor
	VAR_PROTECTED/decl/flooring/_base_flooring = /decl/flooring/plating
	VAR_PROTECTED/list/decl/flooring/_flooring
	VAR_PRIVATE/tmp/decl/flooring/_topmost_flooring

/turf/floor/proc/get_all_flooring()
	. = list()
	if(_flooring)
		if(islist(_flooring))
			for(var/floor in _flooring)
				. += RESOLVE_TO_DECL(floor)
		else if(!isnull(_flooring))
			. += RESOLVE_TO_DECL(_flooring)
	if(_base_flooring)
		. += get_base_flooring()

/turf/floor/proc/has_flooring()
	return !isnull(_flooring)

/turf/floor/proc/set_base_flooring(new_base_flooring, skip_update)
	// We can never have a null base flooring.
	new_base_flooring = RESOLVE_TO_DECL(new_base_flooring || initial(_base_flooring) || /decl/flooring/plating)
	if(_base_flooring == new_base_flooring)
		return
	_base_flooring = new_base_flooring
	update_from_flooring(skip_update)

/turf/floor/proc/get_base_flooring()
	RETURN_TYPE(/decl/flooring)
	if(ispath(_base_flooring))
		_base_flooring = GET_DECL(_base_flooring)
	return _base_flooring

/turf/floor/proc/get_topmost_flooring()
	RETURN_TYPE(/decl/flooring)

	if(isnull(_topmost_flooring))
		if(isnull(_flooring))
			_topmost_flooring = FALSE
		else
			var/flooring_length = length(_flooring)
			if(flooring_length) // no need to check islist, length is only nonzero for lists and strings, and strings are invalid here
				_topmost_flooring = RESOLVE_TO_DECL(_flooring[flooring_length])
			else
				_topmost_flooring = RESOLVE_TO_DECL(_flooring)
	return _topmost_flooring || get_base_flooring()

/turf/floor/proc/clear_flooring(skip_update = FALSE, place_product)
	if(isnull(_flooring))
		return FALSE
	if(islist(_flooring))
		for(var/floor in _flooring)
			remove_flooring(floor, TRUE, place_product)
	else if(_flooring)
		remove_flooring(_flooring, TRUE, place_product)
	if(!skip_update)
		update_from_flooring()
	return TRUE

/turf/floor/proc/remove_flooring(var/decl/flooring/flooring, skip_update, place_product)

	// Remove floor layers one by one.
	_topmost_flooring  = null
	if(islist(flooring))
		for(var/floor in UNLINT(flooring))
			if(remove_flooring(floor, TRUE, place_product))
				. = TRUE
		if(. && !skip_update)
			set_floor_broken(skip_update = TRUE)
			set_floor_burned(skip_update = TRUE)
			update_from_flooring()
		return

	// Validate our input.
	flooring = RESOLVE_TO_DECL(flooring)
	if(!istype(flooring))
		return

	// Remove this turf from the layer stack.
	var/was_topmost = (flooring == get_topmost_flooring())
	if(islist(_flooring))
		LAZYREMOVE(_flooring, flooring)
		if(LAZYLEN(_flooring) == 1)
			_flooring = _flooring[1]
	else if(_flooring == flooring)
		_flooring = null

	// If the turf was not the topmost turf, then we don't really need to care about it.
	if(!was_topmost)
		return

	LAZYCLEARLIST(decals)
	for(var/obj/effect/decal/writing/writing in src)
		qdel(writing)

	flooring.on_flooring_remove(src)

	if(flooring.build_type && place_product)
		// If build_type uses material stack, check for it
		// Because material stack uses different arguments
		// And we need to use build material to spawn stack
		if(ispath(flooring.build_type, /obj/item/stack/material))
			var/decl/material/M = GET_DECL(flooring.build_material)
			if(!M)
				CRASH("[src] at ([x], [y], [z]) cannot create stack because it has a bad build_material path: '[flooring.build_material]'")
			M.create_object(src, flooring.build_cost, flooring.build_type)
		else
			var/obj/item/stack/tile/new_tile = new flooring.build_type(src)
			if(flooring.can_paint && paint_color)
				new_tile.paint_color = paint_color

	if(flooring.has_environment_proc && is_processing)
		STOP_PROCESSING(SSobj, src)

	floor_icon_state_override = null

	if(!skip_update)
		set_floor_broken(skip_update = TRUE)
		set_floor_burned(skip_update = TRUE)
		update_from_flooring()

/turf/floor/proc/set_flooring(var/decl/flooring/newflooring, skip_update, place_product)

	_topmost_flooring = null

	// Clear this here to get it out of the way.
	floor_icon_state_override = null

	// If _flooring is unset, we can shortcut a lot of these steps.
	if(isnull(_flooring))

		if(isnull(newflooring))
			return FALSE

		if(islist(newflooring))
			_flooring = list()
			for(var/floor in UNLINT(newflooring))
				_flooring += RESOLVE_TO_DECL(floor)
		else if(newflooring)
			_flooring = RESOLVE_TO_DECL(newflooring)
		else
			return FALSE

		if(!skip_update)
			update_from_flooring()
		return TRUE


	// If we already have a flooring state, we need to do some cleanup and housekeeping.
	clear_flooring(skip_update = TRUE, place_product = place_product)
	if(!isnull(newflooring))
		add_flooring(newflooring, skip_update, place_product)
	if(!skip_update)
		update_from_flooring(skip_update)

/turf/floor/proc/add_flooring(decl/flooring/newflooring, skip_update)

	_topmost_flooring = null

	// Add floor layers one by one.
	if(islist(newflooring))
		for(var/floor in UNLINT(newflooring))
			if(add_flooring(floor, skip_update = FALSE))
				. = TRUE
		if(!skip_update)
			set_floor_broken(skip_update = TRUE)
			set_floor_burned(skip_update = TRUE)
			update_from_flooring()
		return

	// We only want to work with references.
	newflooring = RESOLVE_TO_DECL(newflooring)
	if(!newflooring)
		return FALSE

	// Check if the layer is already present.
	if(_flooring)
		if(islist(_flooring))
			if(newflooring in _flooring)
				return FALSE
		else if(newflooring == _flooring)
			return FALSE

	// Add our layer to the top of layers.
	if(isnull(_flooring))
		_flooring = newflooring
	else
		if(!islist(_flooring))
			_flooring = list(_flooring)
		_flooring |= newflooring

	// Update for the new top layer.
	if(!skip_update)
		set_floor_broken(skip_update = TRUE)
		set_floor_burned(skip_update = TRUE)
		update_from_flooring()

	return TRUE

/turf/floor/proc/update_from_flooring(skip_update)

	_topmost_flooring = null

	var/decl/flooring/copy_from = get_topmost_flooring()
	if(!istype(copy_from))
		return // this should never be the case

	update_floor_strings()

	set_gender(copy_from.gender)

	layer      = copy_from.floor_layer
	turf_flags = copy_from.turf_flags
	z_flags    = copy_from.z_flags

	if(copy_from.turf_light_range || copy_from.turf_light_power || copy_from.turf_light_color)
		set_light(copy_from.turf_light_range, copy_from.turf_light_power, copy_from.turf_light_color)
	else
		set_light(0)

	if(z_flags & ZM_MIMIC_BELOW)
		enable_zmimic(z_flags)
	else
		disable_zmimic()

	if(copy_from.has_environment_proc)
		if(!is_processing)
			START_PROCESSING(SSobj, src)
	else if(is_processing)
		STOP_PROCESSING(SSobj, src)

	levelupdate()

	for(var/obj/effect/footprints/print in src)
		qdel(print)

	if(!skip_update)
		lazy_update_icon()
		for(var/dir in global.alldirs)
			var/turf/neighbor = get_step_resolving_mimic(src, dir)
			if(istype(neighbor))
				neighbor.lazy_update_icon()
