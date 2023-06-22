/obj/machinery/computer/design_console
	name = "design database console"
	desc = "A console for interfacing with a research and development design network."

	var/initial_network_id
	var/initial_network_key
	var/list/local_cache
	var/obj/item/disk/design_disk/disk
	var/obj/machinery/design_database/viewing_database
	var/showing_designs = FALSE

/obj/machinery/computer/design_console/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device, initial_network_id, initial_network_key, RECEIVER_STRONG_WIRELESS)

/obj/machinery/computer/design_console/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_network_id, map_hash)

/obj/machinery/computer/design_console/handle_post_network_connection()
	..()
	sync_network()

/obj/machinery/computer/design_console/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/disk/design_disk))
		if(disk)
			to_chat(user, SPAN_WARNING("\The [src] already has a disk inserted."))
			return
		if(user.try_unequip(I, src))
			visible_message("\The [user] slots \the [I] into \the [src].")
			disk = I
			return
	. = ..()

/obj/machinery/computer/design_console/proc/eject_disk(var/mob/user)
	if(disk)
		disk.dropInto(loc)
		if(user)
			if(!issilicon(user))
				user.put_in_hands(disk)
			if(Adjacent(user, src))
				visible_message(SPAN_NOTICE("\The [user] removes \the [disk] from \the [src]."))
		disk = null
		return TRUE
	return FALSE

/obj/machinery/computer/design_console/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/design_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/list/data = list()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	data["network_id"] = device.network_tag

	if(disk)
		data["disk_name"] = disk.name
		data["disk_tech"] = disk.blueprint ? disk.blueprint.name : "no design saved"
	else
		data["disk_name"] = "no disk loaded"

	if(viewing_database)
		data["go_back"] = TRUE
		data["showing_db"] = TRUE
		var/list/show_tech_levels = list()
		for(var/tech in viewing_database.tech_levels)
			var/decl/research_field/field = SSfabrication.get_research_field_by_id(tech)
			show_tech_levels += list(list("field" = field.name, "desc" = field.desc, "level" = "[viewing_database.tech_levels[tech]].0 GQ"))
		data["tech_levels"] = show_tech_levels

	else if(showing_designs)

		var/list/found_designs = list()
		for(var/datum/fabricator_recipe/design in SSfabrication.get_unlocked_recipes(null, get_network_tech_levels()))
			found_designs += list(list("name" = design.name, "ref" = "\ref[design]"))
		data["designs"] = found_designs

		data["go_back"] = TRUE
		data["showing_tech"] = TRUE

	else

		var/list/show_tech_levels = list()
		for(var/tech in local_cache)
			var/decl/research_field/field = SSfabrication.get_research_field_by_id(tech)
			show_tech_levels += list(list("field" = field.name, "level" = "[local_cache[tech]].0 GQ", "desc" = field.desc))
		data["tech_levels"] = show_tech_levels

		var/list/found_databases = list()
		for(var/obj/machinery/design_database/db in network?.get_devices_by_type(/obj/machinery/design_database, user.GetAccess()))
			var/list/database = list("name" = db.name, "ref" = "\ref[db]")
			if(db.stat & (BROKEN|NOPOWER))
				database["status"] = "Offline"
			else
				database["status"] = "Online"
				database["can_view"] = TRUE
			found_databases += list(database)
		data["connected_databases"] = found_databases

		var/list/found_analyzers = list()
		for(var/obj/machinery/destructive_analyzer/az in network?.get_devices_by_type(/obj/machinery/destructive_analyzer, user.GetAccess()))
			var/list/analyzer = list("name" = az.name, "ref" = "\ref[az]")
			if(az.stat & (BROKEN|NOPOWER))
				analyzer["status"] = "Offline"
			else if(az.loaded_item)
				analyzer["can_process"] = TRUE
				analyzer["status"] = az.loaded_item.name
			else
				analyzer["status"] = "Ready"
			found_analyzers += list(analyzer)
		data["connected_analyzers"] = found_analyzers

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "design_console.tmpl", "Design Console")
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/design_console/OnTopic(var/user, var/list/href_list)
	. = ..()
	if(!.)

		if(href_list["view_database"])
			viewing_database = locate(href_list["view_database"])
			if(!istype(viewing_database))
				viewing_database = null
			else
				showing_designs = FALSE
			return TOPIC_REFRESH

		if(href_list["wipe_cache"])
			local_cache = null
			return TOPIC_REFRESH

		if(href_list["view_summary"])
			showing_designs = FALSE
			viewing_database = null
			return TOPIC_REFRESH

		if(href_list["view_designs"])
			showing_designs = TRUE
			viewing_database = null
			return TOPIC_REFRESH

		if(href_list["process_analyzer"])
			process_analyzer(locate(href_list["process_analyzer"]))
			return TOPIC_REFRESH

		if(href_list["manual_sync"])
			sync_network()
			return TOPIC_REFRESH

		if(href_list["eject_disk"])
			eject_disk(user)
			return TOPIC_REFRESH

		if(href_list["save_design"])
			var/datum/fabricator_recipe/design = locate(href_list["save_design"])
			if(istype(design) && disk)
				disk.blueprint = design
				disk.SetName("[initial(disk.name)] ([disk.blueprint.name])")
			return TOPIC_REFRESH

		if(href_list["settings"])
			var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
			D.ui_interact(user)
			return TOPIC_REFRESH

/obj/machinery/computer/design_console/proc/process_analyzer(var/obj/machinery/destructive_analyzer/analyzer)
	if(!istype(analyzer))
		return
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	if(!(analyzer in network?.get_devices_by_type(/obj/machinery/destructive_analyzer)))
		return
	var/list/adding_to_cache = analyzer.process_loaded()
	if(length(adding_to_cache))
		LAZYINITLIST(local_cache)
		for(var/tech in adding_to_cache)
			var/current_level = local_cache[tech]     || 0
			var/new_level =     adding_to_cache[tech] || 0
			if(new_level == current_level)
				local_cache[tech] = current_level+1
			else
				local_cache[tech] = max(current_level, new_level)
		UNSETEMPTY(local_cache)
		if(length(local_cache))
			sync_network()

/obj/machinery/computer/design_console/proc/get_network_tech_levels()
	. = local_cache || list()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	for(var/obj/machinery/design_database/db in network?.get_devices_by_type(/obj/machinery/design_database))
		if(db.sync_policy & SYNC_PUSH_NETWORK)
			for(var/tech in db.tech_levels)
				if(.[tech] < db.tech_levels[tech])
					.[tech] = db.tech_levels[tech]

/obj/machinery/computer/design_console/proc/sync_network()
	var/list/techs = get_network_tech_levels()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	for(var/obj/machinery/design_database/db in network?.get_devices_by_type(/obj/machinery/design_database))
		if(db.sync_policy & SYNC_PULL_NETWORK)
			for(var/tech in db.tech_levels)
				if(techs[tech] > db.tech_levels[tech])
					db.tech_levels[tech] = techs[tech]
	update_fabricators()

/obj/machinery/computer/design_console/proc/update_fabricators()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	if(!istype(network))
		return
	var/list/techs = get_network_tech_levels()
	for(var/obj/machinery/fabricator/fab in network.get_devices_by_type(/obj/machinery/fabricator))
		fab.refresh_design_cache(techs)

/obj/machinery/computer/design_console/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/remove_disk/console)

/decl/interaction_handler/remove_disk/console
	expected_target_type = /obj/machinery/computer/design_console

/decl/interaction_handler/remove_disk/console/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		var/obj/machinery/computer/design_console/D = target
		. = !!D.disk

/decl/interaction_handler/remove_disk/console/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/machinery/computer/design_console/D = target
	D.eject_disk(user)
