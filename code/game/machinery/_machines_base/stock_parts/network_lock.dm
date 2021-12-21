/obj/item/stock_parts/network_receiver/network_lock
	name = "network access lock"
	desc = "An id-based access lock preventing tampering with a machine's hardware and software. Connects wirelessly to network."
	icon_state = "net_lock"
	part_flags = PART_FLAG_QDEL
	base_type = /obj/item/stock_parts/network_receiver/network_lock

	var/auto_deny_all								// Set this to TRUE to deny all access attempts if network connection is lost.
	var/initial_network_id							// The address to the network
	var/initial_network_key							// network KEY
	var/selected_parent_group						// Current selected parent_group for access assignment.
	
	var/list/groups									// List of groups whose members are permitted to access this device.
	var/OR_mode = FALSE								// Whether or not network locks will use AND or OR access.
	var/emagged										// Whether or not this has been emagged.
	var/error

	var/interact_sounds = list("keyboard", "keystroke")
	var/interact_sound_volume = 40
	var/static/legacy_compatibility_mode = TRUE     // Makes legacy access on ids play well with mapped devices with network locks. Override if your server is fully using network-enabled ids or has no mapped access.

/obj/item/stock_parts/network_receiver/network_lock/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_network_id, map_hash)

/obj/item/stock_parts/network_receiver/network_lock/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	if(istype(loc, /obj/machinery)) // Don't emag it outside; you can just cut access without it anyway.
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You slide the card into \the [src]. It flashes purple briefly, then disengages."))
		. = max(., 1)

// Override. This checks the network and builds a dynamic req_access list for the device it's attached to.
/obj/item/stock_parts/network_receiver/network_lock/get_req_access()
	. = get_default_access()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network()
	if(!network)
		return

	var/datum/extension/network_device/acl/access_controller = network.access_controller
	if(!access_controller)
		return

	LAZYINITLIST(groups)
	var/list/resulting_access = list()
	for(var/group in groups)
		if(!(group in access_controller.get_all_groups()))
			groups -= groups // This group doesn't exist anymore - delete it.
			continue
		resulting_access |= "[group].[D.network_id]"
	if(!resulting_access.len)
		return
	return OR_mode ? list(resulting_access) : resulting_access // List of lists is an OR type access configuration.

/obj/item/stock_parts/network_receiver/network_lock/proc/get_default_access()
	if(auto_deny_all)
		return list("NO_PERMISSIONS_DENY_ALL")
	return list()

/obj/item/stock_parts/network_receiver/network_lock/examine(mob/user)
	. = ..()
	if(emagged && user.skill_check_multiple(list(SKILL_FORENSICS = SKILL_EXPERT, SKILL_COMPUTER = SKILL_EXPERT)))
		to_chat(user, SPAN_WARNING("On close inspection, there is something odd about the interface. You suspect it may have been tampered with."))

/obj/item/stock_parts/network_receiver/network_lock/attack_self(var/mob/user)
	ui_interact(user)

/obj/item/stock_parts/network_receiver/network_lock/ui_data(mob/user, ui_key)
	var/list/data[0]
	. = data

	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!istype(D))
		error = "HARDWARE FAILURE: NETWORK DEVICE NOT FOUND"
		data["error"] = error
		return
	data["error"] = error
	data += D.ui_data(user, ui_key)

	var/datum/computer_network/network = D.get_network()
	if(!network)
		data["connected"] = FALSE
		return
	data["connected"] = TRUE
	data["default_state"] = auto_deny_all
	if(!network.access_controller)
		return
	var/list/group_dictionary = network.access_controller.get_group_dict()
	var/list/parent_groups_data
	var/list/child_groups_data
	if(selected_parent_group)
		if(!(selected_parent_group in group_dictionary))
			selected_parent_group = null
		else
			var/list/child_groups = group_dictionary[selected_parent_group]
			if(child_groups)
				child_groups_data = list()
				for(var/child_group in child_groups)
					child_groups_data.Add(list(list(
						"child_group" = child_group,
						"assigned" = (LAZYISIN(groups, child_group))
					)))
	if(!selected_parent_group) // Check again in case we ended up with a non-existent selected parent group instead of breaking the UI.
		parent_groups_data = list()
		for(var/parent_group in group_dictionary)
			parent_groups_data.Add(list(list(
				"parent_group" = parent_group,
				"assigned" = (LAZYISIN(groups, parent_group))
			)))
	data["parent_groups"] = parent_groups_data
	data["child_groups"] = child_groups_data
	data["OR_mode"] = OR_mode
	data["selected_parent_group"] = selected_parent_group

/obj/item/stock_parts/network_receiver/network_lock/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	. = TOPIC_HANDLED

	if(href_list["refresh"])
		error = null
		return TOPIC_REFRESH
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!D)
		return

	if(href_list["settings"])
		D.ui_interact(user)
		return TOPIC_REFRESH

	if(href_list["allow_all"])
		auto_deny_all = FALSE
		return TOPIC_REFRESH

	if(href_list["deny_all"])
		auto_deny_all = TRUE
		return TOPIC_REFRESH

	if(href_list["remove_group"])
		LAZYREMOVE(groups, href_list["remove_group"])
		return TOPIC_REFRESH

	if(href_list["assign_group"])
		LAZYDISTINCTADD(groups, href_list["assign_group"])
		return TOPIC_REFRESH

	if(href_list["select_parent_group"])
		selected_parent_group = href_list["select_parent_group"]
		return TOPIC_REFRESH

	if(href_list["toggle_OR_mode"])
		OR_mode = !OR_mode
		return TOPIC_REFRESH
	
	if(href_list["info"])
		switch(href_list["info"])
			if("OR_mode")
				to_chat(user, SPAN_NOTICE("While in OR MODE, the device will require membership in only one of the assigned groups in order to access the device."))
			if("parent_groups")
				to_chat(user, SPAN_NOTICE("Assigning a parent group to the access list will permit any member of its respective child groups to access the device."))

/obj/item/stock_parts/network_receiver/network_lock/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/data = ui_data(user)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "network_lock.tmpl", capitalize(name), 500, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/item/stock_parts/network_receiver/network_lock/CouldUseTopic(var/mob/user)
	..()
	if(LAZYLEN(interact_sounds) && CanPhysicallyInteract(user))
		playsound(src, pick(interact_sounds), interact_sound_volume)

/obj/item/stock_parts/network_receiver/network_lock/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/item/stock_parts/network_receiver/network_lock/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

// Prevent tampering with machinery you don't have access to.
/obj/machinery/cannot_transition_to(state_path, mob/user)
	var/decl/machine_construction/state = GET_DECL(state_path)
	if(state && !state.locked && construct_state && construct_state.locked)
		for(var/obj/item/stock_parts/network_receiver/network_lock/lock in get_all_components_of_type(/obj/item/stock_parts/network_receiver/network_lock))
			if(!lock.check_access(user))
				return SPAN_WARNING("\The [lock] flashes red! You lack the access to unlock this.")
	return ..()