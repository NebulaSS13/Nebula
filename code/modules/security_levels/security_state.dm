/decl/security_state
	abstract_type = /decl/security_state
	/// Whether or not security level information should be shown to new players on login.
	var/show_on_login = TRUE
	// When defining any of these values type paths should be used, not instances. Instances will be acquired in /New()

	var/decl/security_level/severe_security_level // At which security level (and higher) the use of nuclear fission devices and other extreme measures are allowed. Defaults to the last entry in all_security_levels if unset.
	var/decl/security_level/high_security_level   // At which security level (and higher) transfer votes are disabled, ERT may be requested, and other similar high alert implications. Defaults to the second to last entry in all_security_levels if unset.
	// All security levels within the above convention: Low, Guarded, Elevated, High, Severe


	// Under normal conditions the crew may not raise the current security level higher than the highest_standard_security_level
	// The crew may also not adjust the security level once it is above the highest_standard_security_level.
	// Defaults to the second to last entry in all_security_levels if unset/null.
	// Set to FALSE/0 if there should be no restrictions.
	var/decl/security_level/highest_standard_security_level

	var/decl/security_level/current_security_level  // The current security level. Defaults to the first entry in all_security_levels if unset.
	var/decl/security_level/stored_security_level   // The security level that we are escalating to high security from - we will return to this level once we choose to revert.
	var/list/all_security_levels                    // List of all available security levels
	var/list/standard_security_levels               // List of all normally selectable security levels
	var/list/comm_console_security_levels           // List of all selectable security levels for the command and communication console - basically standard_security_levels - 1

/decl/security_state/Initialize()

	. = ..()

	// Setup the severe security level
	if(!(severe_security_level in all_security_levels))
		severe_security_level = all_security_levels[all_security_levels.len]
	severe_security_level = GET_DECL(severe_security_level)

	// Setup the high security level
	if(!(high_security_level in all_security_levels))
		high_security_level = all_security_levels[max(1, all_security_levels.len - 1)]
	high_security_level = GET_DECL(high_security_level)

	// Setup the highest standard security level
	if(highest_standard_security_level || isnull(highest_standard_security_level))
		if(!(highest_standard_security_level in all_security_levels))
			highest_standard_security_level = all_security_levels[max(1, all_security_levels.len - 1)]
		highest_standard_security_level = GET_DECL(highest_standard_security_level)
	else
		highest_standard_security_level = null

	// Setup the current security level
	if(current_security_level in all_security_levels)
		current_security_level = GET_DECL(current_security_level)
	else
		current_security_level = GET_DECL(all_security_levels[1])

	// Setup the full list of available security levels now that we no longer need to use "x in all_security_levels"
	var/list/security_level_instances = list()
	for(var/security_level_type in all_security_levels)
		security_level_instances += GET_DECL(security_level_type)
	all_security_levels = security_level_instances

	standard_security_levels = list()
	// Setup the list of normally selectable security levels
	for(var/security_level in all_security_levels)
		standard_security_levels += security_level
		if(security_level == highest_standard_security_level)
			break

	comm_console_security_levels = list()
	// Setup the list of selectable security levels available in the comm. console
	for(var/security_level in all_security_levels)
		if(security_level == highest_standard_security_level)
			break
		comm_console_security_levels += security_level

	// Now we ensure the high security level is not above the severe one (but we allow them to be equal)
	var/severe_index = all_security_levels.Find(severe_security_level)
	var/high_index = all_security_levels.Find(high_security_level)
	if(high_index > severe_index)
		high_security_level = severe_security_level

	// Finally switch up to the default starting security level.
	current_security_level.switching_up_to()

/decl/security_state/proc/can_change_security_level()
	return current_security_level in standard_security_levels

/decl/security_state/proc/can_switch_to(var/given_security_level)
	if(!can_change_security_level())
		return FALSE
	return given_security_level in standard_security_levels

/decl/security_state/proc/current_security_level_is_lower_than(var/given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index < given_index

/decl/security_state/proc/current_security_level_is_same_or_higher_than(var/given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index >= given_index

/decl/security_state/proc/current_security_level_is_higher_than(var/given_security_level)
	var/current_index = all_security_levels.Find(current_security_level)
	var/given_index   = all_security_levels.Find(given_security_level)

	return given_index && current_index > given_index

/decl/security_state/proc/set_security_level(var/decl/security_level/new_security_level, var/force_change = FALSE)
	if(new_security_level == current_security_level)
		return FALSE
	if(!(new_security_level in all_security_levels))
		return FALSE
	if(!force_change && !can_switch_to(new_security_level))
		return FALSE

	var/decl/security_level/previous_security_level = current_security_level
	current_security_level = new_security_level

	var/previous_index = all_security_levels.Find(previous_security_level)
	var/new_index      = all_security_levels.Find(new_security_level)

	if(new_index > previous_index)
		previous_security_level.switching_up_from()
		new_security_level.switching_up_to()
	else
		previous_security_level.switching_down_from()
		new_security_level.switching_down_to()

	log_and_message_admins("has changed the security level from [previous_security_level.name] to [new_security_level.name].")
	return TRUE
