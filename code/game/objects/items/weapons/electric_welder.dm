/obj/item/weldingtool/electric
	name = "arc welder"
	desc = "A man-portable arc welding tool."
	icon = 'icons/obj/items/tool/welders/welder_arc.dmi'
	welding_resource = "stored charge"
	tank = null
	waterproof = TRUE
	lit_colour = COLOR_CYAN_BLUE
	_base_attack_force = 7
	var/fuel_cost_multiplier = 10

/obj/item/weldingtool/electric/Initialize()
	setup_power_supply()
	. = ..()

/obj/item/weldingtool/electric/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	loaded_cell_type = loaded_cell_type || /obj/item/cell/high
	return ..(loaded_cell_type, /obj/item/cell, /datum/extension/loaded_cell, charge_value)

/obj/item/weldingtool/electric/examine(mob/user, distance)
	. = ..()
	var/obj/item/cell/cell = get_cell()
	if(!cell)
		to_chat(user, "There is no [welding_resource] source attached.")
	else
		to_chat(user, (distance == 0 ? "It has [get_fuel()] [welding_resource] remaining. " : "") + "[cell] is attached.")

/obj/item/weldingtool/electric/afterattack(var/obj/O, var/mob/user, var/proximity)
	if(proximity && istype(O, /obj/structure/reagent_dispensers/fueltank) && !welding)
		to_chat(user, SPAN_WARNING("\The [src] runs on an internal charge and does not need to be refuelled."))
		return
	. = ..()

/obj/item/weldingtool/electric/get_cell()
	. = ..()
	if(!. && istype(loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(istype(module.holder))
			. = module.holder.get_cell()

/obj/item/weldingtool/electric/get_fuel()
	var/obj/item/cell/cell = get_cell()
	return cell ? cell.charge : 0

/obj/item/weldingtool/electric/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/material/rods) || istype(W, /obj/item/chems/welder_tank))
		return
	return ..()

/obj/item/weldingtool/electric/use_fuel(var/amount)
	var/obj/item/cell/cell = get_cell()
	if(cell)
		return cell.use(amount * CELLRATE * fuel_cost_multiplier) > 0
	return FALSE

/obj/item/weldingtool/electric/on_update_icon()
	. = ..()
	if(get_cell())
		add_overlay("[icon_state]-cell")
