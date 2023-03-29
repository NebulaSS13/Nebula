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

	var/initial_network_id
	var/initial_network_key
	var/list/tech_levels
	var/need_disk_operation = FALSE
	var/obj/item/disk/tech_disk/disk
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
	if(disk)
		data["disk_name"] = disk.name
		var/list/tech_data = list()
		for(var/tech in disk.stored_tech)
			var/decl/research_field/field = SSfabrication.get_research_field_by_id(tech)
			tech_data += list(list("field" = field.name, "desc" = field.desc, "level" = "[disk.stored_tech[tech]].0 GQ"))
		data["disk_tech"] = tech_data
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
	if(disk && need_disk_operation)
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
	QDEL_NULL(disk)
	. = ..()

/obj/machinery/design_database/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/disk/tech_disk))
		if(disk)
			to_chat(user, SPAN_WARNING("\The [src] already has a disk inserted."))
			return
		if(user.try_unequip(I, src))
			visible_message("\The [user] slots \the [I] into \the [src].")
			visible_message(SPAN_NOTICE("\The [src]'s I/O light begins to blink."))
			disk = I
			need_disk_operation = TRUE
			return

	. = ..()

/obj/machinery/design_database/proc/eject_disk(var/mob/user)
	if(disk)
		disk.dropInto(loc)
		need_disk_operation = FALSE
		if(user)
			if(!issilicon(user))
				user.put_in_hands(disk)
			if(Adjacent(user, src))
				visible_message(SPAN_NOTICE("\The [user] removes \the [disk] from \the [src]."))
		disk = null
		return TRUE
	return FALSE

/obj/machinery/design_database/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/remove_disk/designs)

/decl/interaction_handler/remove_disk/designs
	expected_target_type = /obj/machinery/design_database

/decl/interaction_handler/remove_disk/designs/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		var/obj/machinery/design_database/D = target
		. = !!D.disk

/decl/interaction_handler/remove_disk/designs/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/machinery/design_database/D = target
	D.eject_disk(user)
