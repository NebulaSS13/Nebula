/decl/submap_archetype
	// TODO: use UID instead of name for pref saving.
	var/name = "generic ship archetype"
	var/list/whitelisted_species = list()
	var/list/blacklisted_species = list()
	var/call_webhook
	var/list/crew_jobs = list(
		/datum/job/submap
	)
	/// Used to order submaps on the occupation preference menu.
	var/sort_priority = 0
	/// Whether the job preferences for this submap archetype are collapsed by default.
	var/default_to_hidden = TRUE

/decl/submap_archetype/validate()
	. = ..()
	if(name)
		var/static/list/submaps_by_name = list( (global.using_map.name) = global.using_map.type)
		if(submaps_by_name[name])
			. += "name '[name]' ([type]) collides with submap type '[submaps_by_name[name]]'"
		else
			submaps_by_name[name] = type
	else
		. += "no name set"

// Generic ships to populate the list.
/decl/submap_archetype/derelict
	name = "drifting wreck"

/decl/submap_archetype/abandoned_ship
	name = "abandoned ship"
