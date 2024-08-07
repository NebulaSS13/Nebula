#define PRINT_MULTIPLIER_DIVISOR 5

//Allows overriding the default window size of the fabricator
/obj/machinery/fabricator/proc/get_fabricator_window_size()
	return list("x" = 480, "y" = 410)

//Can be overriden to use a different nano template file
/obj/machinery/fabricator/proc/get_nano_template()
	return "fabricator.tmpl"

//Returns a list of templates with the format "name" = "file.tmpl" to be loaded in addition to the main template. Name is used to access in the tmpl files.
/obj/machinery/fabricator/proc/get_extra_templates()
	return list(
		"net_shared" = "network_shared.tmpl",     //Shared network UI stuff
		"fab_shared" = "fabricator_shared.tmpl",  //fab_shared should be included in all fabricator templates
		)

/obj/machinery/fabricator/proc/ui_fabricator_resource_data()
	var/material_storage =  list()
	for(var/material in storage_capacity)
		var/decl/material/mat = GET_DECL(material)
		var/list/material_data = list()
		var/is_solid = (mat.phase_at_temperature() == MAT_PHASE_SOLID)
		material_data["name"]      = capitalize(mat.use_name)
		material_data["stored"]    = stored_material[material] ? stored_material[material] : 0
		material_data["max"]       = storage_capacity[material]
		material_data["unit"]      = is_solid ? SHEET_UNIT : "ml"
		material_data["eject_key"] = "\ref[mat]"
		material_storage += list(material_data)
	return material_storage

/obj/machinery/fabricator/proc/ui_fabricator_current_build_data()
	var/list/current_build
	if(currently_building)
		current_build = list()
		current_build["name"] =       currently_building.target_recipe.name
		current_build["multiplier"] = currently_building.multiplier
		current_build["progress"] =   "[100-round((currently_building.remaining_time/currently_building.target_recipe.build_time)*100)]%"
	return current_build

/obj/machinery/fabricator/proc/ui_fabricator_build_queue_data()
	var/list/build_queue
	for(var/datum/fabricator_build_order/order in queued_orders)
		LAZYADD(build_queue, list(ui_fabricator_build_queue_entry_data(order)))
	return build_queue

/obj/machinery/fabricator/proc/ui_fabricator_build_queue_entry_data(var/datum/fabricator_build_order/order)
	var/list/order_data
	if(order)
		order_data = list()
		order_data["name"]       = order.target_recipe.name
		order_data["multiplier"] = order.multiplier
		order_data["reference"]  = "\ref[order]"
	return order_data

//Fill out the data for the displayed buildable designs
/obj/machinery/fabricator/proc/ui_fabricator_build_options_data()
	var/list/build_options
	for(var/datum/fabricator_recipe/R in design_cache)
		if(!R.is_available_to_fab(src))
			continue
		if(R.hidden && !(fab_status_flags & FAB_HACKED))
			continue
		if(show_category != "All" && show_category != R.category)
			continue
		if(filter_string && !findtextEx_char(lowertext(R.name), lowertext(filter_string)))
			continue
		LAZYADD(build_options, list(ui_fabricator_build_option_entry_data(R)))
	return build_options

//Fill out the data for a single build option
/obj/machinery/fabricator/proc/ui_fabricator_build_option_entry_data(var/datum/fabricator_recipe/R)
	var/list/build_option   = list()
	var/list/material_costs = ui_fabricator_build_option_cost_list(R)
	var/max_sheets
	build_option["name"]       = R.name
	build_option["reference"]  = "\ref[R]"
	build_option["illegal"]    = R.hidden

	if(material_costs)
		max_sheets = material_costs["max_sheets"]
		build_option["unavailable"] = !(material_costs["available"])
		var/list/mats = material_costs["materials"]
		build_option["materials"]  = length(mats) > 0? mats : null

	build_option["multiplier"] = ui_fabricator_build_option_entry_multiplier_data(R, max_sheets)
	return build_option

//Returns a list containing a boolean "available" to determine if we can build the recipe, and a list of resources costs ()
/obj/machinery/fabricator/proc/ui_fabricator_build_option_cost_list(var/datum/fabricator_recipe/R)
	//Make sure it's buildable and list required resources.
	var/list/material_components = list()

	var/max_sheets          = (!length(R.resources)) ? 100 : null
	var/has_missing_resource = FALSE
	for(var/material_path in R.resources)

		var/required_amount = round(R.resources[material_path] * mat_efficiency)
		var/sheets          = round(stored_material[material_path] / required_amount)
		var/has_enough      = TRUE

		var/decl/material/mat = GET_DECL(material_path)

		if(isnull(max_sheets) || max_sheets > sheets)
			max_sheets = sheets
		if(stored_material[material_path] < required_amount)
			has_missing_resource = TRUE
			has_enough = FALSE

		//Must make it a double list here or the fields are just overwriting eachothers
		material_components += list(list(
				"name"       = capitalize(mat.use_name),
				"amount"     = required_amount,
				"has_enough" = has_enough,
			))
	return list("available" = !has_missing_resource && ui_fabricator_build_option_is_available(R, max_sheets), "max_sheets" = max_sheets, "materials" = material_components)

//Override to add more checks to make a build option unavailable. EX: if the machine requires a setting to be set first
/obj/machinery/fabricator/proc/ui_fabricator_build_option_is_available(var/datum/fabricator_recipe/R, var/max_sheets)
	return TRUE

/obj/machinery/fabricator/proc/ui_fabricator_build_option_entry_multiplier_data(var/datum/fabricator_recipe/R, var/max_sheets)
	var/list/multiplier
	if(R.max_amount >= PRINT_MULTIPLIER_DIVISOR && max_sheets >= PRINT_MULTIPLIER_DIVISOR)
		multiplier = list()
		for(var/i = 1 to floor(min(R.max_amount, max_sheets)/PRINT_MULTIPLIER_DIVISOR))
			var/mult = i * PRINT_MULTIPLIER_DIVISOR
			multiplier += list(list("label" = "x[mult]", "multiplier" = mult))
	return multiplier

//
// UI sections data
//
/obj/machinery/fabricator/ui_data(mob/user, ui_key)
	var/list/data = ..()
	//Common fab data
	data += ui_data_status(user, ui_key) //status is still displayed when not working for convenience
	if(is_functioning())
		data += ui_data_resources(user, ui_key)
		data += ui_data_queue(user, ui_key)
		data += ui_data_config(user, ui_key)
		data += ui_data_filter(user, ui_key)
		data += ui_data_build_options(user, ui_key)
	return data

/obj/machinery/fabricator/proc/ui_data_status(mob/user, ui_key)
	var/list/data = list()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	data["network"]    = (D.network_id && D.network_tag)
	data["network_id"] = D.network_id
	data["functional"] = is_functioning()
	return data

/obj/machinery/fabricator/proc/ui_data_resources(mob/user, ui_key)
	var/list/data = list()
	data["expand_resources"] = ui_expand_resources
	data["material_storage"] = ui_fabricator_resource_data()
	return data

/obj/machinery/fabricator/proc/ui_data_queue(mob/user, ui_key)
	var/list/data = list()
	data["expand_queue"]  = ui_expand_queue
	data["current_build"] = ui_fabricator_current_build_data()
	data["build_queue"]   = ui_fabricator_build_queue_data()
	return data

//Handles populating config data, meant to be overriden
/obj/machinery/fabricator/proc/ui_data_config(mob/user, ui_key)
	var/list/data = list()
	data["expand_config"]    = ui_expand_config
	data["skip_config"]      = !ui_draw_config(user, ui_key) //Setting this to true just skip over drawing the config tab completely when its empty
	data["color_selectable"] = color_selectable
	data["color"]            = selected_color
	return data

/obj/machinery/fabricator/proc/ui_data_filter(mob/user, ui_key)
	var/list/data = list()
	data["category"]        = show_category
	data["filtering"]       = filter_string || "No filter set."
	data["hide_categories"] = ui_nb_categories <= 1 //Only show categories if we have more than one category of things
	return data

/obj/machinery/fabricator/proc/ui_data_build_options(mob/user, ui_key)
	var/list/data = list()
	data["build_options"] = ui_fabricator_build_options_data()
	return data

//Shouldn't need to override this in subclasses.
/obj/machinery/fabricator/ui_interact(mob/user, ui_key = "fab", datum/nanoui/ui=null, force_open=1, var/master_ui = null, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = ui_data(user, ui_key)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		var/list/window_size = get_fabricator_window_size()
		ui = new(user, src, ui_key, get_nano_template(), "[capitalize(name)]", window_size["x"], window_size["y"], state = state)
		ui.set_initial_data(data)

		//Add extra templates
		var/list/extratemplates = get_extra_templates()
		for(var/key in extratemplates)
			ui.add_template(key, extratemplates[key])

		ui.open()
		ui.set_auto_update(TRUE)

//Returns whether we should bother drawing the config tab. Meant to be overriden
/obj/machinery/fabricator/proc/ui_draw_config(mob/user, ui_key)
	return color_selectable //Only if we can pick a color by default

#undef PRINT_MULTIPLIER_DIVISOR