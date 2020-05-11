/obj/machinery/destructive_analyzer
	name = "destructive analyzer"
	desc = "Accessed by a connected design database console, it destroys and analyzes items and materials for later reproduction."
	icon = 'icons/obj/machines/destructive_analyzer.dmi'
	icon_state = "d_analyzer"
	idle_power_usage = 30
	active_power_usage = 2500
	construct_state = /decl/machine_construction/default/panel_closed
	density = TRUE
	anchored = TRUE

	var/initial_network_id
	var/initial_network_key
	var/busy = FALSE
	var/obj/item/loaded_item = null
	var/material_return_modifier = 0
	var/list/cached_materials = list()

/obj/machinery/destructive_analyzer/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device, initial_network_id, initial_network_key, NETWORK_CONNECTION_WIRED)

/obj/machinery/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/S in src)
		T += S.rating
	material_return_modifier = min(T * 0.05, 1)
	..()

/obj/machinery/destructive_analyzer/on_update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/destructive_analyzer/components_are_accessible(path)
	return !busy && ..()

/obj/machinery/destructive_analyzer/cannot_transition_to(state_path)
	if(busy)
		return SPAN_WARNING("\The [src] is busy. Please wait for completion of previous operation.")
	if(loaded_item)
		return SPAN_WARNING("There is something already loaded into \the [src]. You must remove it first.")
	return ..()

/obj/machinery/destructive_analyzer/physical_attack_hand(var/mob/user)
	if(loaded_item)
		loaded_item.dropInto(user?.loc || loc)
		if(istype(user) && user.Adjacent(loaded_item))
			user.put_in_hands(loaded_item)
		loaded_item = null
		update_icon()
		return TRUE

	var/list/dump_matter
	for(var/mat in cached_materials)
		var/amt = Floor(cached_materials[mat]/SHEET_MATERIAL_AMOUNT)
		if(amt > 0)
			LAZYSET(dump_matter, mat, amt)
	if(length(dump_matter))
		visible_message("\The [user] unloads \the [src]'s material hopper.")
		for(var/mat in dump_matter)
			var/material/M = SSmaterials.get_material_datum(mat)
			M.place_sheet(loc, dump_matter[mat])
			cached_materials[mat] -= dump_matter[mat] * SHEET_MATERIAL_AMOUNT
			if(cached_materials[mat] <= 0)
				cached_materials -= mat
		return TRUE

	. = ..()

/obj/machinery/destructive_analyzer/interface_interact(user)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	D.ui_interact(user)
	return TRUE

/obj/machinery/destructive_analyzer/attackby(var/obj/item/O, var/mob/user)

	if(isMultitool(O) && user.a_intent != I_HURT)
		var/datum/extension/local_network_member/fabnet = get_extension(src, /datum/extension/local_network_member)
		fabnet.get_new_tag(user)
		return TRUE

	if(isrobot(user))
		return
	if(busy)
		to_chat(user, SPAN_WARNING("\The [src] is busy right now."))
		return TRUE
	if(component_attackby(O, user))
		return TRUE
	if(loaded_item)
		to_chat(user, SPAN_WARNING("There is something already loaded into \the [src]."))
		return TRUE
	if(panel_open)
		to_chat(user, SPAN_WARNING("You can't load \the [src] while it's opened."))
		return TRUE
	if(!O.origin_tech)
		to_chat(user, SPAN_WARNING("Nothing can be learned from \the [O]."))
		return TRUE

	var/list/techlvls = json_decode(O.origin_tech)
	if(!length(techlvls) || O.holographic)
		to_chat(user, SPAN_WARNING("You cannot deconstruct this item."))
		return TRUE

	if(user.unEquip(O, src))
		busy = TRUE
		loaded_item = O
		to_chat(user, SPAN_NOTICE("You add \the [O] to \the [src]."))
		flick("d_analyzer_la", src)
		addtimer(CALLBACK(src, .proc/refresh_busy, 1 SECOND))
		return TRUE

/obj/machinery/destructive_analyzer/proc/refresh_busy()
	if(busy)
		update_icon()
		busy = FALSE

/obj/machinery/destructive_analyzer/proc/process_loaded()
	if(!loaded_item)
		return
	busy = TRUE
	if(loaded_item.origin_tech)
		. = json_decode(loaded_item.origin_tech)
		var/increase = (locate(/datum/event/brain_expansion) in SSevent.active_events) ? 2 : 1
		for(var/tech in .)
			.[tech] += increase
	else
		. = list()
	for(var/mat in loaded_item.matter)
		LAZYSET(cached_materials, mat, cached_materials[mat] + (loaded_item.matter[mat] * material_return_modifier))
	QDEL_NULL(loaded_item)
	flick("d_analyzer_process", src)
	addtimer(CALLBACK(src, .proc/refresh_busy, 2 SECONDS))

/obj/item/research
	name = "research debugging device"
	desc = "Instant research tool. For testing purposes only."
	icon = 'icons/obj/items/stock_parts/stock_parts.dmi'
	icon_state = "smes_coil"
	origin_tech = "{'materials':19,'engineering':19,'phorontech':19,'powerstorage':19,'bluespace':19,'biotech':19,'combat':19,'magnets':19,'programming':19,'esoteric':19}"
