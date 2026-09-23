/// Used to direct how a particular commodity should be counted when a merchant is buying it.
/decl/merchant_quantity_method
	abstract_type = /decl/merchant_quantity_method
	var/unit_suffix = null

/decl/merchant_quantity_method/proc/get_quantity_of_instance(atom/movable/instance)
	CRASH("Unimplemented abstract proc")


/// Counts potential items by counting instances, and in the case of item stacks, how much is in that stack.
/// This is the default method, and should work in most cases.
/decl/merchant_quantity_method/instances

/decl/merchant_quantity_method/instances/get_quantity_of_instance(atom/movable/instance)
	if(istype(instance, /obj/item/stack))
		var/obj/item/stack/S = instance
		return S.amount
	return 1


/// Counts potential items by the total reagent volume inside of them.
/// This should be used if a merchant is intended to buy a certain amount of reagents, so they count what's inside the container and not the container itself.
/decl/merchant_quantity_method/reagent_units
	unit_suffix = "units of"

/decl/merchant_quantity_method/reagent_units/get_quantity_of_instance(atom/movable/instance)
	var/datum/reagents/reagents = instance.get_reagents()
	if(!reagents)
		return 0
	return REAGENT_TOTAL_VOLUME(reagents)


/// Counts potential items by the total amount of moles inside of them.
/// This should be used if a merchant is intended to buy a certain amount of gas, so they count what's inside the container and not the container itself.
/decl/merchant_quantity_method/moles
	unit_suffix = "moles of"

/decl/merchant_quantity_method/moles/get_quantity_of_instance(atom/movable/instance)
	var/datum/gas_mixture/gas_mix = instance.return_air()
	if(!gas_mix)
		return 0
	return gas_mix.get_total_moles()
