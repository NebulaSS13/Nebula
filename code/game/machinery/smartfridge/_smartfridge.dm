
/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/machines/smartfridges/science.dmi'
	icon_state = ICON_STATE_WORLD
	layer = BELOW_OBJ_LAYER
	density = TRUE
	anchored = TRUE
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	atmos_canpass = CANPASS_NEVER
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0

	var/overlay_contents_icon = 'icons/obj/machines/smartfridges/contents_chem.dmi'
	var/list/item_records = list()
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0

/obj/machinery/smartfridge/Initialize()
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)
	. = ..()
	queue_icon_update()

/obj/machinery/smartfridge/Destroy()
	for(var/datum/stored_items/S in item_records)
		qdel(S)
	item_records = null
	return ..()

/obj/machinery/smartfridge/get_req_access()
	if(!scan_id)
		return list()
	return ..()

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/stocking_item)
	if(istype(stocking_item,/obj/item/food/grown) || istype(stocking_item,/obj/item/seeds))
		return 1
	return 0

/obj/machinery/smartfridge/Process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()

/obj/machinery/smartfridge/on_update_icon()

	// Reset our icon_state and overlays.
	icon_state = initial(icon_state)
	cut_overlays() // Does not appear to be called lower down the chain, sadly.

	// Draw our side panel overlay (for access checking)
	var/draw_state
	if(is_secure)
		if(stat & BROKEN)
			draw_state = "[icon_state]-sidepanel-broken"
		else
			draw_state = "[icon_state]-sidepanel"
		if(check_state_in_icon(draw_state, icon))
			add_overlay(draw_state)

	// Draw our panel overlay.
	if(panel_open)
		draw_state = "[icon_state]-panel"
		if(check_state_in_icon(draw_state, icon))
			add_overlay(draw_state)

	// Fridge contents
	if(overlay_contents_icon)
		var/is_off = inoperable() ? "-off" : ""
		switch(contents.len - LAZYLEN(component_parts))
			if(0)
				draw_state = "empty[is_off]"
			if(1 to 2)
				draw_state = "1[is_off]"
			if(3 to 5)
				draw_state = "2[is_off]"
			if(6 to 8)
				draw_state = "3[is_off]"
			else
				draw_state = "4[is_off]"
		if(draw_state && check_state_in_icon(draw_state, icon))
			add_overlay(image(overlay_contents_icon, draw_state))

	// Fridge top
	if(stat & BROKEN)
		draw_state = "[draw_state]-top-broken"
	else
		draw_state = "[icon_state]-top"

	if(check_state_in_icon(draw_state, icon))
		var/image/overlay_image = image(icon, draw_state)
		overlay_image.pixel_z = 32
		overlay_image.layer = ABOVE_WINDOW_LAYER
		add_overlay(overlay_image)

	// Append our off state if needed.
	if(stat & BROKEN)
		icon_state = "[icon_state]-broken"
	else if(stat & NOPOWER)
		icon_state = "[icon_state]-off"

/obj/machinery/smartfridge/dismantle()
	for(var/datum/stored_items/stored_item in item_records)
		while(stored_item.amount > 0)
			stored_item.get_product(get_turf(src)) // They'd get dumped anyway, but this makes things GC properly.
	..()

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/state_transition(decl/machine_construction/new_state, mob/user)
	. = ..()
	update_icon()

/obj/machinery/smartfridge/attackby(var/obj/item/used_item, var/mob/user)
	if(accept_check(used_item))
		if(!user.try_unequip(used_item))
			return TRUE
		stock_item(used_item)
		user.visible_message("<span class='notice'>\The [user] has added \the [used_item] to \the [src].</span>", "<span class='notice'>You add \the [used_item] to \the [src].</span>")
		update_icon()
		return TRUE

	if(used_item.storage)
		var/plants_loaded = 0
		for(var/obj/G in used_item.storage.get_contents())
			if(accept_check(G) && used_item.storage.remove_from_storage(user, G, src, TRUE))
				plants_loaded++
				stock_item(G)
		used_item.storage.finish_bulk_removal()

		if(plants_loaded)
			user.visible_message("<span class='notice'>\The [user] loads \the [src] with the contents of \the [used_item].</span>", "<span class='notice'>You load \the [src] with the contents of \the [used_item].</span>")
			if(length(used_item.storage.get_contents()) > 0)
				to_chat(user, "<span class='notice'>Some items were refused.</span>")
		return TRUE
	return ..()

/obj/machinery/smartfridge/proc/stock_item(var/obj/item/stocking_item)
	for(var/datum/stored_items/stored_item in item_records)
		if(istype(stocking_item, stored_item.item_path) && stocking_item.name == stored_item.item_name)
			stock(stored_item, stocking_item)
			return

	var/datum/stored_items/stored_item = new/datum/stored_items(src, stocking_item.type, stocking_item.name)
	dd_insertObjectList(item_records, stored_item)
	stock(stored_item, stocking_item)

/obj/machinery/smartfridge/proc/stock(var/datum/stored_items/stored_item, var/obj/item/stocking_item)
	stored_item.add_product(stocking_item)
	SSnano.update_uis(src)

/obj/machinery/smartfridge/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure

	var/list/items[0]
	for (var/i=1 to length(item_records))
		var/datum/stored_items/stored_item = item_records[i]
		var/count = stored_item.get_amount()
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(stored_item.item_name)), "vend" = i, "quantity" = count)))

	if(items.len > 0)
		data["contents"] = items

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/smartfridge/OnTopic(mob/user, href_list)
	if((. = ..()))
		return

	if(href_list["close"])
		return TOPIC_CLOSE

	if(href_list["vend"])
		var/index = text2num(href_list["vend"])
		var/datum/stored_items/stored_item = item_records[index]
		var/count = stored_item.get_amount()
		var/amount = clamp(text2num(href_list["amount"]), 0, count)

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(amount <= 0)
			return TOPIC_REFRESH // you must be confused, we have none of that here!
		for(var/i = 1 to amount)
			stored_item.get_product(get_turf(src))
			update_icon()
			var/vend_state = "[icon_state]-vend"
			if (check_state_in_icon(vend_state, icon)) //Show the vending animation if needed
				flick(vend_state, src)
		return TOPIC_REFRESH
	return TOPIC_NOACTION

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/stored_items/stored_item in src.item_records)
		throw_item = stored_item.get_product(loc)
		if(!QDELETED(throw_item))
			break

	if(QDELETED(throw_item))
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	update_icon()
	return 1

