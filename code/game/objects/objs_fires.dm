/obj/get_fire_graphic(var/intensity)
	if(intensity >= 20 && w_class >= ITEM_SIZE_STRUCTURE)
		var/static/obj/effect/fire/large/_fire_object_large
		if(!_fire_object_large)
			_fire_object_large = new
		return _fire_object_large
	if(intensity >= 10 && w_class >= ITEM_SIZE_LARGE)
		var/static/obj/effect/fire/medium/_fire_object_medium
		if(!_fire_object_medium)
			_fire_object_medium = new
		return _fire_object_medium
	return ..()

/obj/proc/update_matter()
	return

/obj/proc/update_matter_values()
	temperature_coefficient = isnull(temperature_coefficient) ? clamp(MAX_TEMPERATURE_COEFFICIENT - w_class, MIN_TEMPERATURE_COEFFICIENT, MAX_TEMPERATURE_COEFFICIENT) : temperature_coefficient
	update_flammability()

/obj/get_surface_area()
	return w_class

/obj/get_flammable_material(var/ignition_temperature = INFINITY, var/return_on_first_hit = FALSE)
	. = ..()
	if(!length(matter))
		return return_on_first_hit ? !!. : .
	for(var/material_type in matter)
		var/decl/material/fuel_type = GET_DECL(material_type)
		if(fuel_type.accelerant_value && !isnull(fuel_type.ignition_point) && ignition_temperature >= fuel_type.ignition_point)
			if(return_on_first_hit)
				return TRUE
			LAZYINITLIST(.)
			LAZYSET(.[FUEL_MATTER], fuel_type, matter[material_type] * fuel_type.accelerant_value)
	if(return_on_first_hit)
		return !!.

/obj/burn_up()
	if(length(matter))
		return
	new /obj/effect/decal/cleanable/ash(loc)
	..()

/obj/remove_fuel(var/decl/material/fuel_type, var/fuel_index, var/amount)
	amount = ..()
	if(amount > 0 && fuel_index == FUEL_MATTER)
		if(matter[fuel_type.type] > amount)
			matter[fuel_type.type] -= amount
			amount = -1
		else
			amount -= matter[fuel_type.type]
			matter -= fuel_type.type
		update_matter()
	return amount

// TODO: use matter_per_piece and consume via reducing stack amount
///obj/item/stack