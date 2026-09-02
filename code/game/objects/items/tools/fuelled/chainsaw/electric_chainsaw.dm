// Electric chainsaw! Rechargable, less damage, but generally silent when not actually cutting.

/obj/item/fuelled_tool/chainsaw/electric
	name                     = "electric chainsaw"
	desc                     = "A slightly less powerful chainsaw with the benefit of being rechargable."
	saw_time_multiplier      = 1.5
	inactive_force           = 6
	active_force             = 10
	paint_color              = COLOR_YELLOW_GRAY
	activate_sound           = 'sound/items/welderactivate.ogg'
	deactivate_sound         = 'sound/items/welderdeactivate.ogg'
	running_loop             = null
	tank                     = null
	var/fuel_cost_multiplier = 10

/obj/item/fuelled_tool/chainsaw/electric/Initialize()
	setup_power_supply()
	. = ..()

/obj/item/fuelled_tool/chainsaw/electric/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	loaded_cell_type = loaded_cell_type || /obj/item/cell/high
	return ..(loaded_cell_type, /obj/item/cell, /datum/extension/loaded_cell/unremovable, charge_value)

/obj/item/fuelled_tool/chainsaw/electric/perform_activation_check(mob/user)
	return TRUE

/obj/item/fuelled_tool/chainsaw/electric/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	var/obj/item/cell/cell = get_cell()
	if(cell)
		if(distance == 0)
			. += "It has [get_fuel()] [fuel_name] remaining."
		. += "\The [cell] is attached."
	else
		. += "There is no [fuel_name] source attached."

/obj/item/fuelled_tool/chainsaw/electric/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O, /obj/structure/reagent_dispensers/fueltank) && !running_state)
		to_chat(user, SPAN_WARNING("\The [src] runs on an internal charge and does not need to be refuelled."))
		return
	. = ..()

/obj/item/fuelled_tool/chainsaw/electric/get_cell()
	. = ..()
	if(!. && istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(istype(module.holder))
			. = module.holder.get_cell()

/obj/item/fuelled_tool/chainsaw/electric/get_fuel()
	var/obj/item/cell/cell = get_cell()
	return cell ? cell.charge : 0

/obj/item/fuelled_tool/chainsaw/electric/insert_tank(var/obj/item/chems/fuel_tank/T, var/mob/user, var/no_updates = FALSE, var/quiet = FALSE)
	return FALSE // No tanks!

/obj/item/fuelled_tool/chainsaw/electric/use_fuel(var/amount)
	var/obj/item/cell/cell = get_cell()
	if(cell)
		return cell.use(amount * CELLRATE * fuel_cost_multiplier) > 0
	return FALSE
