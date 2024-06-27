/obj/machinery/smartfridge/drying_oven
	name = "drying oven"
	desc = "A machine for drying plants."
	icon_state = "drying_rack"
	icon_base = "drying_rack"
	obj_flags = OBJ_FLAG_ANCHORABLE
	atom_flags = ATOM_FLAG_CLIMBABLE

/obj/machinery/smartfridge/drying_oven/accept_check(var/obj/item/O)
	return istype(O) && O.is_dryable()

/obj/machinery/smartfridge/drying_oven/Process()
	..()
	if(inoperable())
		return
	var/do_update = FALSE
	for(var/obj/item/thing in get_contained_external_atoms())
		var/obj/item/product = thing.dry_out(src, silent = TRUE)
		if(product)
			product.dropInto(loc)
			do_update = TRUE
			if(QDELETED(thing) || !(thing in contents))
				for(var/datum/stored_items/I in item_records)
					I.instances -= thing
	if(do_update)
		update_icon()

/obj/machinery/smartfridge/drying_oven/on_update_icon()
	..()
	var/has_items = FALSE
	for(var/datum/stored_items/I in item_records)
		if(I.get_amount())
			has_items = TRUE
			break
	if(inoperable())
		if(has_items)
			icon_state = "[icon_base]-plant-off"
		else
			icon_state = "[icon_base]-off"
	else if(has_items)
		icon_state = "[icon_base]-plant"
		if(!inoperable())
			icon_state = "[icon_base]-close"
	else
		icon_state = icon_base
