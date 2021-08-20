/obj/machinery/fabricator/OnTopic(user, href_list, state)
	if(href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in SSfabrication.get_categories(fabricator_class)|"All"
		if(!choice || !CanUseTopic(user, state))
			return TOPIC_HANDLED
		show_category = choice
		. = TOPIC_REFRESH
	
	if(href_list["make"])
		try_queue_build(locate(href_list["make"]), text2num(href_list["multiplier"]))
		. = TOPIC_REFRESH
	
	if(href_list["cancel"])
		try_cancel_build(locate(href_list["cancel"]))
		. = TOPIC_REFRESH
	
	if(href_list["eject_mat"])
		try_dump_material(href_list["eject_mat"])
		. = TOPIC_REFRESH
	
	if(href_list["settings"])
		var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(user)
		. = TOPIC_REFRESH

	if(href_list["color_select"])
		var/choice
		if(get_color_list())
			choice = input(user, "What color do you want to select?") as null|anything in get_color_list()
		else
			choice = input(user, "What do you want to select?") as null|color
		if(!choice)
			return TOPIC_HANDLED
		selected_color = choice
		. = TOPIC_REFRESH

	if(href_list["set_filter"])
		var/new_filter_string = sanitize(input(user, "Enter a new filter string.", "Fabricator Filter") as text|null)
		if(CanInteract(user, DefaultTopicState()))
			filter_string = new_filter_string
			. = TOPIC_REFRESH

/obj/machinery/fabricator/proc/try_cancel_build(var/datum/fabricator_build_order/order)
	if(istype(order) && currently_building != order && is_functioning())
		if(order in queued_orders)
			// Refund some mats.
			for(var/mat in order.earmarked_materials)
				stored_material[mat] = min(stored_material[mat] + (order.earmarked_materials[mat] * 0.9), storage_capacity[mat])
			queued_orders -= order
		qdel(order)

/obj/machinery/fabricator/proc/try_dump_material(var/mat_name)
	mat_name = lowertext(mat_name)
	for(var/mat_path in stored_substances_to_names)
		if(stored_substances_to_names[mat_path] == mat_name && stored_material[mat_path] > SHEET_MATERIAL_AMOUNT)
			var/sheet_count = FLOOR(stored_material[mat_path]/SHEET_MATERIAL_AMOUNT)
			stored_material[mat_path] -= sheet_count * SHEET_MATERIAL_AMOUNT
			SSmaterials.create_object(mat_path, get_turf(src), sheet_count)
			break
