/obj/machinery/fabricator/pipe
	name = "pipe dispenser"
	icon = 'icons/obj/machines/pipe_dispenser.dmi'
	icon_state = "pipe_d"
	obj_flags = OBJ_FLAG_ANCHORABLE
	fabricator_class = FABRICATOR_CLASS_PIPE
	base_type = /obj/machinery/fabricator/pipe
	stat_immune = NOSCREEN//Doesn't need screen, just input for the parts wanted
	power_channel = EQUIP
	anchored = FALSE
	use_power = POWER_USE_OFF
	color_selectable = TRUE

/obj/machinery/fabricator/pipe/on_update_icon()
	return // no icons

/obj/machinery/fabricator/pipe/CanUseTopic(mob/user)
	if(!anchored)
		return STATUS_CLOSE
	return ..()

/obj/machinery/fabricator/pipe/wrench_floor_bolts(mob/user, delay = 2 SECONDS, obj/item/tool)
	..()
	update_use_power(anchored ? POWER_USE_IDLE : POWER_USE_OFF)

/obj/machinery/fabricator/pipe/Initialize()//for mapping purposes. Anchor them by map var edit if needed.
	. = ..()
	if(anchored)
		update_use_power(POWER_USE_IDLE)

/obj/machinery/fabricator/pipe/take_materials(var/obj/item/thing, var/mob/user)
	. = ..()
	// Pipe objects do not contain matter, and will not provide a refund on materials used to make them, but can be recycled to prevent clutter.
	if(istype(thing, /obj/item/pipe) && (. == SUBSTANCE_TAKEN_NONE))
		return SUBSTANCE_TAKEN_ALL

/obj/machinery/fabricator/pipe/make_order(datum/fabricator_recipe/recipe, multiplier)
	var/datum/fabricator_build_order/order = ..()
	order.set_data("selected_color", selected_color)
	return order

/obj/machinery/fabricator/pipe/do_build(datum/fabricator_build_order/order)
	. = order.target_recipe.build(get_turf(src), order)
	use_power_oneoff(500 * order.multiplier)

/obj/machinery/fabricator/pipe/disposal
	name = "disposal pipe dispenser"
	icon = 'icons/obj/machines/pipe_dispenser.dmi'
	icon_state = "pipe_d"
	fabricator_class = FABRICATOR_CLASS_DISPOSAL
	base_type = /obj/machinery/fabricator/pipe/disposal

//Allow you to drag-drop disposal pipes into it
/obj/machinery/fabricator/pipe/disposal/receive_mouse_drop(atom/dropping, mob/user, params)
	. = ..()
	if(!. && istype(dropping, /obj/structure/disposalconstruct))
		qdel(dropping)
		return TRUE
