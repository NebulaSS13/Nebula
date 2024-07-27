/datum/extension/network_device/acl
	var/list/group_dict = list()	// Groups on the network, stored as strings.
									// Parents groups with children have a list of child groups associated with the string key

	var/list/all_groups = list()	// All group strings, not sorted by parent or child group. Used for uniqueness checking.

	var/allow_submanagement = FALSE // If enabled, users who are members of a parent group will be able to manage membership of all child groups under that parent group,
									// Otherwise, assignment is strictly by access to the network access controller
	var/parent_account_creation = FALSE // If enabled, all users who are members of ANY parent group will be able to create new accounts.
										// Otherwise, account creation is restricted to those with access to the account server(s)

	has_commands = TRUE
	device_methods = list(
		/decl/public_access/public_method/add_group,
		/decl/public_access/public_method/remove_group,
		/decl/public_access/public_method/list_groups
	)

/datum/extension/network_device/acl/proc/get_group_dict()
	return group_dict

/datum/extension/network_device/acl/proc/get_all_groups()
	return all_groups

// Check if the passed user account can create new accounts by seeing if parent account creation is enabled, then checking
// if they are a member of a parent group. Otherwise, account creation permission is solely based on access to account servers.
/datum/extension/network_device/acl/proc/check_account_creation_auth(datum/computer_file/data/account/check_account)
	if(parent_account_creation && check_account)
		for(var/group in check_account.groups)
			if(group in group_dict)
				return TRUE
	return FALSE

/datum/extension/network_device/acl/proc/add_group(group_name, parent_group)
	group_name = sanitize_for_group("[group_name]")
	if(!length(group_name) || !istext(group_name) || (parent_group && !istext(parent_group)))
		return "Input Error"
	if(length(group_name) > 15)
		return "Maximum group name length is 15 characters."
	if(group_name in all_groups)
		return "Group name must be unique"

	// Adding a child group.
	if(parent_group)
		if(!(parent_group in group_dict))
			return "No parent group with name \"[parent_group]\" found."
		if(!group_dict[parent_group])
			group_dict[parent_group] = list()
		group_dict[parent_group] += group_name
	else
		group_dict += group_name

	all_groups += group_name
	return "Added [parent_group ? "child group" : "parent group"] \"[group_name]\"" + "[parent_group ? " to \"[parent_group]\"." : "."]"

/datum/extension/network_device/acl/proc/remove_group(group_name, parent_group)
	if(!istext(group_name) || (parent_group && !istext(parent_group)))
		return "Input Error"
	if(parent_group)
		if(!(parent_group in group_dict))
			return "No parent group with name \"[parent_group]\" found."
		if(!group_dict[parent_group] || !(group_name in group_dict[parent_group]))
			return "No child group with name \"[group_name]\" found in \"[parent_group]\""
		group_dict[parent_group] -= group_name
		if(!length(group_dict[parent_group])) // Cull the list until we add a new child group.
			group_dict[parent_group] = null
		all_groups -= group_name
		return "Removed child group \"[group_name]\" from parent group \"[parent_group]\"."
	if(group_name in group_dict)
		if(length(group_dict[group_name]))
			for(var/child_name in group_dict[group_name])
				all_groups -= child_name
		group_dict -= group_name
		all_groups -= group_name
		return "Removed parent group \"[group_name]\" and associated child groups."
	else
		return "No parent group with name \"[parent_group]\" found."

/datum/extension/network_device/acl/proc/toggle_parent_account_creation()
	parent_account_creation = !parent_account_creation
	var/datum/computer_network/network = get_network()
	if(network.access_controller == src)
		network.add_log("Access controller parent account creation toggled [parent_account_creation ? "ON" : "OFF"]", network_tag)


/datum/extension/network_device/acl/proc/toggle_submanagement()
	allow_submanagement = !allow_submanagement
	var/datum/computer_network/network = get_network()
	if(network.access_controller == src)
		network.add_log("Access controller submanagement toggled [allow_submanagement ? "ON" : "OFF"]", network_tag)

/datum/extension/network_device/acl/proc/get_group_listing(parent_group)
	if(parent_group && !istext(parent_group))
		return "Input Error"
	if(parent_group)
		if(!(parent_group in group_dict))
			return "No parent group with name \"[parent_group]\" found."
		return "[parent_group]: [english_list(group_dict[parent_group])]"
	return "Parent groups: [english_list(group_dict)]"

// Helper proc for adding multiple groups at once for preset ACLs etc.
/datum/extension/network_device/acl/proc/add_groups(list/preset_groups)
	for(var/parent_group in preset_groups)
		add_group(parent_group)
		var/list/child_groups = preset_groups[parent_group]
		if(islist(child_groups))
			for(var/child_group in child_groups)
				add_group(child_group, parent_group)

/decl/public_access/public_method/add_group
	name = "Add group"
	desc = "Adds a new group with the passed name. A parent group can be passed to add a child group."
	call_proc = TYPE_PROC_REF(/datum/extension/network_device/acl, add_group)
	forward_args = TRUE

/decl/public_access/public_method/remove_group
	name = "Remove group"
	desc = "Removes a group with the passed name. A parent group can be passed to remove a child group of that parent."
	call_proc = TYPE_PROC_REF(/datum/extension/network_device/acl, remove_group)
	forward_args = TRUE

/decl/public_access/public_method/list_groups
	name = "List groups"
	desc = "Lists groups on the group access controller. A parent group can be passed list children of that parent group."
	call_proc = TYPE_PROC_REF(/datum/extension/network_device/acl, get_group_listing)
	forward_args = TRUE