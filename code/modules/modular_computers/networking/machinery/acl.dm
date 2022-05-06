/obj/machinery/network/acl
	name = "network access controller"
	desc = "A mainframe that manages encryption keys tied to groups and their children on its parent network."
	icon = 'icons/obj/machines/tcomms/aas.dmi'
	icon_state = "aas"
	network_device_type =  /datum/extension/network_device/acl
	main_template = "network_acl.tmpl"
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/network/acl

	var/current_group				// The group currently being edited.
	var/list/preset_groups			// Dictionary of parent groups->list(child_groups)

/obj/machinery/network/acl/Initialize()
	. = ..()
	if(preset_groups)
		var/datum/extension/network_device/acl/D = get_extension(src, /datum/extension/network_device)
		D.add_groups(preset_groups)

/obj/machinery/network/acl/OnTopic(mob/user, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return
	var/datum/extension/network_device/acl/D = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/network = D.get_network()
	if(!network || network.access_controller != D)
		error = "NETWORK ERROR: Connection lost. Another access controller may be active on the network."
		return TOPIC_REFRESH

	if(href_list["back"])
		current_group = null
		return TOPIC_REFRESH
	
	if(href_list["create_group"])
		var/group_name = sanitize_for_group(input(usr, "Enter the name of the new group. Maximum 15 characters, only alphanumeric characters, _ and - are allowed:", "Create Group"))
		if(!length(group_name))
			return TOPIC_HANDLED
		if(!CanInteract(user, global.default_topic_state))
			return TOPIC_REFRESH
		
		var/output = D.add_group(group_name, current_group)
		if(group_name in D.all_groups)
			to_chat(user, SPAN_NOTICE(output))
		else // Failure!
			to_chat(user, SPAN_WARNING(output))
		return TOPIC_REFRESH

	if(href_list["remove_group"])
		var/group_name = href_list["remove_group"]
		var/removal_check = alert(user, "Are you sure you want to remove the group [group_name]?", "Group Removal", "No", "Yes")
		if(!CanInteract(user, global.default_topic_state))
			return TOPIC_REFRESH
		if(removal_check == "Yes")
			var/output = D.remove_group(group_name, current_group)
			if(group_name in D.all_groups) // Failure!
				to_chat(user, SPAN_WARNING(output))
			else
				to_chat(user, SPAN_NOTICE(output))
			return TOPIC_REFRESH
	
	if(href_list["toggle_submanagement"])
		D.toggle_submanagement()
		return TOPIC_REFRESH
	
	if(href_list["toggle_parent_account_creation"])
		D.toggle_parent_account_creation()
		return TOPIC_REFRESH
	
	if(href_list["view_child_groups"])
		var/parent_group = href_list["view_child_groups"]
		if(parent_group && (parent_group in D.group_dict))
			current_group = parent_group
		else
			current_group = null
		return TOPIC_REFRESH
	
	if(href_list["info"])
		switch(href_list["info"])
			if("submanagement")
				to_chat(user, SPAN_NOTICE("If parent group submanagement is toggled on, members of the parent group will be allowed to manage account membership in child groups. This may be useful for departmental heads."))
			if("parent_account_creation")
				to_chat(user, SPAN_NOTICE("If parent account creation is toggled on, members of any parent group will be allowed to create new user accounts. Otherwise, account creation requires access to an account server."))

/obj/machinery/network/acl/ui_data(mob/user, ui_key)
	. = ..()

	if(error)
		.["error"] = error
		return

	var/datum/extension/network_device/acl/D = get_extension(src, /datum/extension/network_device)
	if(!D.get_network())
		.["connected"] = FALSE
		return
	.["connected"] = TRUE
	.["allow_submanagement"] = D.allow_submanagement
	.["parent_account_creation"] = D.parent_account_creation

	// Modifying parent group, display child groups
	if(current_group)
		.["current_group"] = current_group
		var/list/child_groups[0]
		if(D.group_dict[current_group])
			for(var/child_group in D.group_dict[current_group])
				child_groups.Add(list(list(
					"group_name" = child_group,
				)))
		.["child_groups"] = child_groups
	else
		// We're looking at all parent groups.
		var/list/parent_groups[0]
		for(var/parent_group in D.group_dict)
			parent_groups.Add(list(list(
				"group_name" = parent_group,
			)))
		.["parent_groups"] = parent_groups