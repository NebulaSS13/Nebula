// Shim for non-stock_parts machine components
/obj/item/stock_parts/building_material
	name = "building materials"
	desc = "Various standard wires, pipes, and other materials."
	gender = PLURAL
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	part_flags = PART_FLAG_QDEL
	max_health = ITEM_HEALTH_NO_DAMAGE
	var/list/materials

/obj/item/stock_parts/building_material/Destroy()
	QDEL_NULL_LIST(materials)
	. = ..()

/obj/item/stock_parts/building_material/proc/number_of_type(var/type)
	. = 0
	for(var/obj/item/thing in materials)
		if(istype(thing, type))
			if(isstack(thing))
				var/obj/item/stack/stack = thing
				. += stack.amount
			else
				.++

/obj/item/stock_parts/building_material/proc/add_material(var/obj/item/new_material)
	if(istype(new_material, /obj/item/stack))
		var/obj/item/stack/stack = new_material
		for(var/obj/item/stack/old_stack in materials)
			if(stack.transfer_to(old_stack) && QDELETED(stack))
				return
	LAZYADD(materials, new_material)
	new_material.forceMove(null)

// amount will cap the amount given in a stack, but may return less than amount specified.
/obj/item/stock_parts/building_material/proc/remove_material(material_type, amount, force_destination)
	if(ispath(material_type, /obj/item/stack))
		for(var/obj/item/stack/stack in materials)
			if(stack.stack_merge_type == material_type)
				var/stack_amount = stack.get_amount()
				if(stack_amount <= amount)
					materials -= stack
					if(force_destination)
						stack.forceMove(force_destination)
					else
						stack.dropInto(loc)
					amount -= stack_amount
					return stack
				var/obj/item/stack/new_stack = stack.split(amount)
				if(force_destination)
					new_stack.forceMove(force_destination)
				else
					new_stack.dropInto(loc)
				return new_stack
	for(var/obj/item/item in materials)
		if(istype(item, material_type))
			materials -= item
			if(force_destination)
				item.forceMove(force_destination)
			else
				item.dropInto(loc)
			return item

/obj/item/stock_parts/building_material/on_uninstall(var/obj/machinery/machine)
	for(var/obj/item/I in materials)
		I.dropInto(loc)
	materials = null
	..()

/obj/item/stock_parts/building_material/get_contained_matter(include_reagents = TRUE)
	. = ..()
	for(var/obj/item/thing in materials)
		var/list/costs = thing.get_contained_matter(include_reagents)
		for(var/key in costs)
			.[key] += costs[key]
