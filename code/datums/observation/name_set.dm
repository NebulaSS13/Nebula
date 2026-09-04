//	Observer Pattern Implementation: Name Set
//		Registration type: /atom
//
//		Raised when: An atom's name changes.
//
//		Arguments that the called proc should expect:
//			/atom/namee:  The atom that had its name set
//			/old_name: name before the change
//			/new_name: name after the change

/decl/observ/name_set
	name = "Name Set"
	expected_type = /atom
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS

/*********************
* Name Set Handling *
*********************/

/atom/proc/SetName(var/new_name)
	var/old_name = name
	if(old_name != new_name)
		name = new_name
		if(has_extension(src, /datum/extension/labels))
			var/datum/extension/labels/L = get_extension(src, /datum/extension/labels)
			name = L.AppendLabelsToName(name)
		if(event_listeners?[/decl/observ/name_set])
			raise_event_non_global(/decl/observ/name_set, old_name, new_name)
		update_above()