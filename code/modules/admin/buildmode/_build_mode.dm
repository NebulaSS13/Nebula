/datum/build_mode
	var/the_default = FALSE
	var/name
	var/icon_state
	var/datum/click_handler/build_mode/host
	var/mob/user
	var/list/click_interactions
	var/static/help_row_length = 80
	var/build_type

/datum/build_mode/New(var/host)
	..()
	src.host = host
	user = src.host.user
	for(var/click_type in click_interactions)
		click_interactions += GET_DECL(click_type)
		click_interactions -= click_type

/datum/build_mode/Destroy()
	host = null
	. = ..()

/datum/build_mode/proc/SetBuildType(var/atom_type)
	if(!atom_type || atom_type == build_type)
		return
	var/atom/atom_prototype = atom_type
	if(ispath(atom_type, /atom) && TYPE_IS_SPAWNABLE(atom_prototype))
		build_type = atom_type
		to_chat(user, SPAN_NOTICE("Will now construct instances of the type [atom_type]."))
	else
		to_chat(user, SPAN_WARNING("Cannot construct instances of type [atom_type]."))

/datum/build_mode/proc/OnClick(var/atom/A, var/list/parameters)
	if(!istype(A))
		return FALSE
	parameters = parameters || list()
	for(var/decl/build_mode_interaction/click_interaction in click_interactions)
		if(click_interaction.CanInvoke(src, A, parameters))
			return click_interaction.Invoke(src, A, parameters)
	return FALSE

/datum/build_mode/proc/Configurate()
	return

/datum/build_mode/proc/Help()
	var/asterisks = repeatstring("*", help_row_length)
	to_chat(user, SPAN_NOTICE(asterisks))
	if(length(click_interactions))
		for(var/decl/build_mode_interaction/click_interaction in click_interactions)
			to_chat(user, SPAN_NOTICE("[click_interaction.name][repeatstring(" ", help_row_length - (3+length_char(click_interaction.name)+length_char(click_interaction.description)))] = [click_interaction.description]"))
	else
		to_chat(user, SPAN_NOTICE("No click interactions for this mode!"))
	ShowAdditionalHelpText()
	to_chat(user, SPAN_NOTICE(asterisks))

/datum/build_mode/proc/ShowAdditionalHelpText()
	return

/datum/build_mode/proc/Selected()
	return

/datum/build_mode/proc/Unselected()
	return

/datum/build_mode/proc/TimerEvent()
	return

/datum/build_mode/proc/Log(message)
	log_admin("BUILD MODE - [name] - [key_name(usr)] - [message]")

/datum/build_mode/proc/Warn(message)
	to_chat(user, "BUILD MODE - [name] - [message])")

/datum/build_mode/proc/select_subpath(given_path, within_scope = /atom)
	var/desired_path = input("Enter full or partial typepath.","Typepath","[given_path]") as text|null
	if(!desired_path)
		return
	var/list/types = typesof(within_scope)
	var/list/matches = list()
	for(var/path in types)
		if(findtext("[path]", desired_path))
			matches += path
	if(!matches.len)
		alert("No results found. Sorry.")
		return
	if(matches.len==1)
		return matches[1]
	return (input("Select a type", "Select Type", matches[1]) as null|anything in matches)
