/datum/composite_sound/firecrackle
	start_sound = 'sound/ambience/firecrackle01.ogg'
	start_length = 10
	mid_sounds = list(
		'sound/ambience/firecrackle02.ogg',
		'sound/ambience/firecrackle03.ogg',
		'sound/ambience/firecrackle04.ogg',
		'sound/ambience/firecrackle05.ogg'
	)
	mid_length = 10
	end_sound = 'sound/ambience/firecrackle06.ogg'
	volume = 10

/atom
	var/fire_intensity = FIRE_INTENSITY_WILL_NOT_BURN

// How fast do we burn?
/atom/proc/get_accelerant_value()

	// Check if we have fuels to burn.
	var/list/fuels = get_flammable_material()
	if(!length(fuels))
		return 0

	// If we only have one, no further math needed.
	if(length(fuels) == 1)
		var/fuel_index = fuels[1]
		if(length(fuels[fuel_index]) == 1)
			var/decl/material/fuel_type = fuels[fuel_index][1]
			return fuel_type.accelerant_value

	// Otherwise get the average of the proportional fuel values for our fuel materials.
	. = 0
	var/total_material = 0
	var/discrete_fuels = list()
	for(var/fuel_index in fuels)
		for(var/decl/material/fuel_type in fuels[fuel_index])
			var/discrete_material = fuels[fuel_index][fuel_type]
			total_material += discrete_material
			discrete_fuels[fuel_type] += discrete_material
	for(var/decl/material/fuel_type as anything in discrete_fuels)
		. += (discrete_fuels[fuel_type] / total_material)
	. = max(1, CEILING(. / length(discrete_fuels)))

/atom/proc/get_surface_area()
	return 1

/atom/proc/process_fire()

	// We're not meant to be alight, put us out.
	if(fire_intensity <= 0)
		extinguish_fire()
		return 0

	// Consume some fuel. Hotter fires burn faster and vice-versa.
	var/accelerant = get_accelerant_value()
	// Null return indicates a runtime, zero values indicate nothing burned.
	var/list/exhaust = fire_consume(fire_intensity * get_surface_area() * FIRE_W_CLASS_BURN_CONSTANT * FIRE_CONSUME_CONSTANT * accelerant)
	if(!length(exhaust))
		extinguish_fire()
		return 0

	// Now dump the products.
	var/datum/gas_mixture/environment = loc?.return_air()
	if(environment)
		// Grab our burn temperature first.
		var/burn_energy = 0
		if(FIRE_BURN_TOTAL_INDEX in exhaust)
			burn_energy = max(burn_energy, exhaust[FIRE_BURN_TOTAL_INDEX]) * FIRE_THERMAL_ENERGY_CONSTANT
			exhaust -= FIRE_BURN_TOTAL_INDEX
		for(var/exhaust_type in exhaust)
			environment.adjust_gas(exhaust_type, MOLES_PER_MATERIAL_UNIT(exhaust[exhaust_type]), FALSE)
		environment.add_thermal_energy(burn_energy)
		environment.update_values()

	// The fire grows...
	set_fire_intensity(fire_intensity + (FIRE_INTENSITY_CONSTANT * accelerant))
	if(fire_intensity >= FIRE_SPREAD_THRESHOLD && loc)
		// The fire spreads...
		// Turf spreading is handled by SSfires, so we only try to spread to our loc's contents.
		var/spread_prob = fire_intensity * FIRE_SPREAD_CONSTANT
		var/list/spread_to_atoms = list(loc)
		spread_to_atoms |= loc.get_contained_external_atoms()
		while(length(spread_to_atoms))
			var/atom/spread_to = pick_n_take(spread_to_atoms)
			if(!istype(spread_to) || !spread_to.is_flammable() || spread_to.is_on_fire())
				continue
			if(!prob(spread_prob))
				break
			spread_to.ignite_fire()

// These procs work in fuel units, rather than discrete matter units.
// Returns an associative list of fuel material datum to multiplied fuel value.
// TODO: systematic updates/retrieval of matter (reagent holders?), caching
/atom/proc/get_flammable_material(var/ignition_temperature = INFINITY, var/return_on_first_hit = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(length(reagents?.reagent_volumes) && ATOM_IS_OPEN_CONTAINER(src))
		for(var/fuel_type in reagents.reagent_volumes)
			var/decl/material/fuel = GET_DECL(fuel_type)
			if(fuel.accelerant_value && !isnull(fuel.ignition_point) && ignition_temperature >= fuel.ignition_point)
				if(return_on_first_hit)
					return TRUE
				LAZYINITLIST(.)
				LAZYSET(.[FUEL_REAGENTS], fuel, round((REAGENT_VOLUME(reagents, fuel_type) / REAGENT_UNITS_PER_MATERIAL_UNIT) * fuel.accelerant_value))
	if(return_on_first_hit)
		return !!.

/atom/proc/is_flammable()
	return simulated && fire_intensity != FIRE_INTENSITY_WILL_NOT_BURN

// Called when the object is destroyed by fire.
/atom/proc/burn_up()
	physically_destroyed()

/atom/proc/is_on_fire()
	return fire_intensity > 0

// Consume `amount` number of fuel units from this
// atom's material fuel. Returns the amount of FU consumed.
/atom/proc/fire_consume(var/amount, var/list/produced_exhaust)

	// Check if we're flammable at all.
	var/list/fuel = get_flammable_material()
	if(!length(fuel))
		return produced_exhaust

	// This is our product tracking list; it persists across recursions.
	LAZYINITLIST(produced_exhaust)

	// Calculate the total amount of fuel we can provide from this object.
	var/total_units = 0
	for(var/fuel_index in fuel)
		for(var/fuel_type in fuel[fuel_index])
			total_units += fuel[fuel_type]

	// Take an equal number of fuel units from each flammable material.
	// In cases where a material is insufficient to meet the needs,
	// keep track of how much is left to provide, and recurse.
	. = 0
	var/fuel_left_over = FALSE
	var/residual_fuel_need = 0
	var/fuel_units_per_mat = CEILING(amount / length(fuel))
	for(var/fuel_index in fuel)
		for(var/decl/material/fuel_type as anything in fuel[fuel_index])
			// Remove the appropriate amount of matter.
			var/physical_amount =  CEILING(min(fuel[fuel_index][fuel_type], fuel_units_per_mat) / fuel_type.accelerant_value)
			var/could_not_remove = remove_fuel(fuel_type, fuel_index, physical_amount)
			if(could_not_remove > 0)
				physical_amount -= could_not_remove
				residual_fuel_need += could_not_remove
			else if(could_not_remove < 0)
				fuel_left_over = TRUE
			// If it has a burn product, track it for our return.
			if(physical_amount > 0)
				if(fuel_type.burn_product)
					produced_exhaust[fuel_type.burn_product] += physical_amount
				produced_exhaust[FIRE_BURN_TOTAL_INDEX] += physical_amount

	// If we're out of fuel, we burn up.
	if(!fuel_left_over)
		burn_up()

	// If we have residual fuel to supply, we go again.
	else if(residual_fuel_need)
		.(residual_fuel_need, produced_exhaust)
	return produced_exhaust

/atom/proc/dampen_fire(var/amount)
	if(fire_intensity <= amount)
		var/used = fire_intensity
		extinguish_fire()
		return used
	set_fire_intensity(fire_intensity-amount)
	return amount

/atom/proc/ignite_fire()
	if(!is_flammable() || is_on_fire())
		return
	if(!(locate(/atom/movable/fire_effects) in get_turf(src)))
		new /atom/movable/fire_effects(get_turf(src))
	set_fire_intensity(1)

/atom/proc/extinguish_fire()
	if(!is_on_fire())
		return

	set_fire_intensity(0)

	var/turf/host_turf = get_turf(src)
	if(!host_turf)
		return
	var/atom/movable/fire_effects/effect = locate() in host_turf
	if(!effect)
		return
	for(var/atom/thing as anything in host_turf)
		if(thing == src)
			continue
		if(thing.is_on_fire())
			return
	qdel(effect)

/atom/proc/get_fire_graphic(var/intensity)
	if(intensity <= 0)
		return null
	var/static/obj/effect/fire/_fire_object_small
	if(!_fire_object_small)
		_fire_object_small = new
	return _fire_object_small

/atom/proc/remove_fire_graphic(var/intensity)
	return

/atom/proc/add_fire_graphic(var/intensity)
	return

/atom/proc/update_flammability()
	if(is_on_fire()) // We're already on fire, let SSfires sort us out.
		return
	fire_intensity = get_flammable_material(return_on_first_hit = TRUE) ? 0 : FIRE_INTENSITY_WILL_NOT_BURN

/atom/proc/set_fire_intensity(var/new_intensity)

	// Bookkeeping and early return.
	if(!is_flammable() || new_intensity == fire_intensity)
		return FALSE
	var/old_intensity = fire_intensity
	fire_intensity = new_intensity
	if(!fire_intensity) // Good time to update based on fuel.
		update_flammability()

	// Handle igniting or snuffing out the fire.
	if(old_intensity)
		if(!fire_intensity)
			remove_fire_graphic(old_intensity)
			SSfires.burning_fires -= src
			return TRUE
	else if(fire_intensity)
		add_fire_graphic(fire_intensity)
		SSfires.burning_fires[src] = TRUE
		return TRUE
	// Update our fire graphic if needed.
	if(get_fire_graphic(old_intensity) == get_fire_graphic(fire_intensity))
		return TRUE
	remove_fire_graphic(old_intensity)
	add_fire_graphic(fire_intensity)
	return TRUE

// Removes `amount` units of actual physical material from the object.
// Uses matter units, not fuel units, hence needs conversion for
// reagents/gasses. Returns the amount of physical fuel unable to be
// removed, or -1 if excess fuel was left over.
/atom/proc/remove_fuel(var/decl/material/fuel_type, var/fuel_index, var/amount)
	SHOULD_CALL_PARENT(TRUE)
	. = amount
	if(fuel_index == FUEL_REAGENTS)
		var/removing = amount * REAGENT_UNITS_PER_MATERIAL_UNIT
		var/has_reagent = REAGENT_VOLUME(reagents, fuel_type.type)
		if(has_reagent < amount)
			reagents.remove_reagent(fuel_type.type, has_reagent)
			return CEILING((removing-has_reagent)/REAGENT_UNITS_PER_MATERIAL_UNIT)
		reagents.remove_reagent(fuel_type.type, amount)
		return (has_reagent > amount) ? -1 : 0 // We had excess fuel
