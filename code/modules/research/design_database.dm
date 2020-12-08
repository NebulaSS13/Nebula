/obj/machinery/design_database
	name = "fabricator design database"
	icon = 'icons/obj/machines/tcomms/blackbox.dmi'
	icon_state = "blackbox"
	density = TRUE
	anchored = TRUE

	var/initial_network_id
	var/initial_network_key
	var/list/tech_levels = list(
		TECH_MATERIAL =      1,
		TECH_ENGINEERING =   1,
		TECH_EXOTIC_MATTER = 0,
		TECH_POWER =         1,
		TECH_WORMHOLES =     0,
		TECH_BIO =           0,
		TECH_COMBAT =        0,
		TECH_MAGNET =        1,
		TECH_DATA =          1,
		TECH_ESOTERIC =      0
	)

	var/need_disk_operation = FALSE
	var/obj/item/disk/tech_disk/disk
	var/sync_policy = SYNC_PULL_NETWORK|SYNC_PULL_DISK

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
			tech_data += list(list("field" = field.name, "level" = "[disk.stored_tech[tech]].0 GQ"))
		data["disk_tech"] = tech_data
	else
		data["disk_name"] = "no disk loaded"

	var/list/show_tech_levels = list()
	for(var/tech in tech_levels)
		var/decl/research_field/field = SSfabrication.get_research_field_by_id(tech)
		show_tech_levels += list(list("field" = field.name, "level" = "[tech_levels[tech]].0 GQ"))
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
			for(var/tech in tech_levels)
				tech_levels[tech] = 0
			return TOPIC_REFRESH
		if(href_list["settings"])
			var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
			D.ui_interact(user)
			return TOPIC_REFRESH

/obj/machinery/design_database/Initialize()
	. = ..()
	design_databases += src
	set_extension(src, /datum/extension/network_device, initial_network_id, initial_network_key, NETWORK_CONNECTION_WIRED)
	update_icon()

/obj/machinery/design_database/Process()
	..()
	if((stat & BROKEN) || (stat & NOPOWER) || !use_power || !powered())
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
				if(sync_policy & SYNC_PUSH_NETWORK)
					var/synced
					var/datum/extension/network_device/device = get_extension(src, /datum/extension/network_device)
					var/datum/computer_network/network = device.get_network()
					for(var/obj/machinery/computer/design_console/dc in network?.get_devices_by_type(/obj/machinery/computer/design_console))
						if(!(dc.stat & (BROKEN|NOPOWER)))
							dc.sync_network(tech_levels)
							synced = TRUE
							break
					if(!synced)
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
		if(user.unEquip(I, src))
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

/obj/machinery/design_database/AltClick(mob/user)
	if(disk)
		eject_disk(user)
	. = ..()
