/// A teleporter pad which sends and receives objects to merchants.
/obj/machinery/merchant_pad
	name = "Teleportation Pad"
	desc = "Place things here to trade."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "tele0"
	anchored = TRUE
	density = FALSE

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed

/obj/machinery/merchant_pad/proc/get_target()
	var/turf/T = get_turf(src)
	for(var/a in T)
		if(!is_valid_target(a))
			continue
		return a

/obj/machinery/merchant_pad/proc/get_targets()
	. = list()
	var/turf/T = get_turf(src)
	for(var/a in T)
		if(!is_valid_target(a))
			continue
		. += a

/obj/machinery/merchant_pad/proc/is_valid_target(atom/movable/thing)
	if(!istype(thing))
		return FALSE
	if(thing == src)
		return FALSE
	return thing.is_valid_merchant_pad_target()


/atom/movable/proc/is_valid_merchant_pad_target()
	SHOULD_CALL_PARENT(TRUE)
	return simulated


/obj/is_valid_merchant_pad_target()
	if(anchored)
		return FALSE
	return ..()


/mob/living/exosuit/is_valid_merchant_pad_target()
	if(current_user)
		return FALSE
	return ..()


/obj/item/stock_parts/circuitboard/merchant_pad
	name = "circuitboard (merchant pad)"
	build_path = /obj/machinery/merchant_pad
	board_type = "machine"
	origin_tech = @'{"programming":6,"wormholes":6,"esoteric":1}'
	req_components = list(
		/obj/item/stack/cable_coil = 15,
		/obj/item/stock_parts/subspace/amplifier = 1,
		/obj/item/stock_parts/subspace/ansible = 1,
		/obj/item/stock_parts/subspace/crystal = 1,
		/obj/item/stock_parts/subspace/transmitter = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/keyboard = 1,
	)

/datum/fabricator_recipe/imprinter/circuit/merchant_pad
	path = /obj/item/stock_parts/circuitboard/merchant_pad