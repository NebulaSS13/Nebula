var/global/list/default_initial_tech_levels
/proc/get_default_initial_tech_levels()
	if(!global.default_initial_tech_levels)
		global.default_initial_tech_levels = list()
		var/list/research_fields = decls_repository.get_decls_of_subtype(/decl/research_field)
		for(var/field in research_fields)
			var/decl/research_field/field_decl = research_fields[field]
			global.default_initial_tech_levels[field_decl.id] = field_decl.initial_tech_level
	return global.default_initial_tech_levels.Copy()

/obj/machinery/design_database
	name = "fabricator design database"
	icon = 'icons/obj/machines/tcomms/blackbox.dmi'
	icon_state = "blackbox"
	density = TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	maximum_component_parts = list(
		/obj/item/stock_parts/item_holder/disk_reader = 1,
		/obj/item/stock_parts = 15,
	)

	/// A cached reference to our disk reader part, if present.
	var/obj/item/stock_parts/item_holder/disk_reader/disk_reader
	var/initial_network_id
	var/initial_network_key
	var/list/tech_levels
	var/need_disk_operation = FALSE
	var/sync_policy = SYNC_PULL_NETWORK|SYNC_PUSH_NETWORK|SYNC_PULL_DISK

/obj/machinery/design_database/proc/toggle_sync_policy_flag(var/sync_flag)
	if(sync_policy & sync_flag)
		sync_policy &= ~sync_flag
	else
		sync_policy |= sync_flag

/obj/machinery/design_database/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	var/list/data = list()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	data["network_id"] = device.network_tag
	var/obj/item/disk/tech_disk/disk = try_get_disk()
	if(disk)
		data["disk_name"] = disk.name
		if(istype(disk))
			var/list/tech_data = list()
			for(var/tech in disk.stored_tech)
				var/decl/research_field/field = SSfabrication.get_research_field_by_id(tech)
				tech_data += list(list("field" = field.name, "desc" = field.desc, "level" = "[disk.stored_tech[tech]].0 GQ"))
			data["disk_tech"] = tech_data
		else
			data["disk_error"] = "invalid data format"
	else
		data["disk_name"] = "no disk loaded"

	var/list/show_tech_levels = list()
	for(var/tech in tech_levels)
		var/decl/research_field/field = SSfabrication.get_research_field_by_id(tech)
		show_tech_levels += list(list("field" = field.name, "desc" = field.desc, "level" = "[tech_levels[tech]].0 GQ"))
	data["tech_levels"] = show_tech_levels

	data["network_push"] = (sync_policy & SYNC_PUSH_NETWORK) ? "on" : "off"
	data["network_pull"] = (sync_policy & SYNC_PULL_NETWORK) ? "on" : "off"
	data["disk_push"]    = (sync_policy & SYNC_PUSH_DISK)    ? "on" : "off"
	data["disk_pull"]    = (sync_policy & SYNC_PULL_DISK)    ? "on" : "off"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "design_database.tmpl", "Design Database")
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/design_database/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/design_database/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(!.)
		if(href_list["toggle_sync_flag"])
			toggle_sync_policy_flag(text2num(href_list["toggle_sync_flag"]))
			return TOPIC_REFRESH
		if(href_list["eject_disk"])
			eject_disk(user)
			return TOPIC_REFRESH
		if(href_list["wipe_database"])
			tech_levels = get_default_initial_tech_levels()
			return TOPIC_REFRESH
		if(href_list["settings"])
			var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
			D.ui_interact(user)
			return TOPIC_REFRESH

/obj/machinery/design_database/Initialize()
	if(!tech_levels)
		tech_levels = get_default_initial_tech_levels()
	..()
	design_databases += src
	set_extension(src, /datum/extension/network_device, initial_network_id, initial_network_key, RECEIVER_STRONG_WIRELESS)
	update_icon()
	. = INITIALIZE_HINT_LATELOAD

/obj/machinery/design_database/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_network_id, map_hash)
	ADJUST_TAG_VAR(initial_network_key, map_hash)

/obj/machinery/design_database/handle_post_network_connection()
	..()
	sync_design_consoles()

/obj/machinery/design_database/proc/sync_design_consoles()
	var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = device.get_network()
	for(var/obj/machinery/computer/design_console/dc in network?.get_devices_by_type(/obj/machinery/computer/design_console))
		if(!(dc.stat & (BROKEN|NOPOWER)))
			dc.sync_network()
			return TRUE

/obj/machinery/design_database/Process()
	..()
	if((stat & BROKEN) || (stat & NOPOWER) || !use_power)
		return

	// Read or write from a loaded disk.
	var/obj/item/disk/tech_disk/disk = try_get_disk()
	if(disk && need_disk_operation)
		if(!istype(disk)) // wrong type of disk!
			visible_message(SPAN_WARNING("\The [src] whirrs and drones, before emitting an ominous grinding sound."))
		else
			if(sync_policy & SYNC_PULL_DISK)
				var/new_tech = FALSE
				for(var/tech in disk.stored_tech)
					if(tech_levels[tech] < disk.stored_tech[tech])
						tech_levels[tech] = disk.stored_tech[tech]
						new_tech = TRUE
				if(new_tech)
					visible_message(SPAN_NOTICE("\The [src] clicks and chirps as it reads from \the [disk]."))
					if((sync_policy & SYNC_PUSH_NETWORK) && !sync_design_consoles())
						visible_message(SPAN_WARNING("\The [src] flashes an error light from its network interface."))

			if(sync_policy & SYNC_PUSH_DISK)
				var/new_tech
				for(var/tech in tech_levels)
					if(tech_levels[tech] > LAZYACCESS(disk.stored_tech, tech))
						new_tech = TRUE
						LAZYSET(disk.stored_tech, tech, tech_levels[tech])
				if(new_tech)
					visible_message(SPAN_NOTICE("\The [src] whirrs and drones as it writes to \the [disk]."))
		visible_message("The I/O light on \the [src] stops blinking.")
		need_disk_operation = FALSE

/obj/machinery/design_database/on_update_icon()
	icon_state = initial(icon_state)
	if(panel_open)
		icon_state = "[icon_state]_o"
	if((stat & NOPOWER) || (stat & BROKEN) || !use_power)
		icon_state = "[icon_state]_off"

/obj/machinery/design_database/Destroy()
	design_databases -= src
	disk_reader = null
	. = ..()

/obj/machinery/design_database/proc/on_insert_disk(obj/item/disk/D, mob/user)
	visible_message(SPAN_NOTICE("\The [src]'s I/O light begins to blink."))
	need_disk_operation = TRUE
	update_ui()

/obj/machinery/design_database/proc/on_eject_disk(obj/item/disk/D, mob/user)
	need_disk_operation = FALSE
	update_ui()

/obj/machinery/design_database/RefreshParts()
	. = ..()
	disk_reader = get_component_of_type(/obj/item/stock_parts/item_holder/disk_reader)
	if(disk_reader)
		disk_reader.register_on_insert(CALLBACK(src, PROC_REF(on_insert_disk)))
		disk_reader.register_on_eject(CALLBACK(src, PROC_REF(on_eject_disk)))

/obj/machinery/design_database/proc/try_get_disk()
	return disk_reader?.get_inserted()

/obj/machinery/design_database/proc/update_ui()
	SSnano.update_uis(src)

// used for, specifically, removing a disk via the UI
/obj/machinery/design_database/proc/eject_disk(var/mob/user)
	if(!disk_reader)
		to_chat(user, SPAN_WARNING("\The [src] has no disk drive installed."))
		return FALSE
	. = !isnull(disk_reader.eject_item(user))
	update_ui()
