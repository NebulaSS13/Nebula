/decl/special_role/proc/can_become_antag(var/datum/mind/player, var/ignore_role)

	if(player.current)
		if(isliving(player.current) && player.current.stat)
			return 0
		if(jobban_isbanned(player.current, name))
			return 0
		if(player.current.faction != MOB_FACTION_NEUTRAL)
			return 0

	if(is_type_in_list(player.assigned_job, blacklisted_jobs))
		return 0

	if(!ignore_role)
		if(player.current && player.current.client)
			var/client/C = player.current.client
			// Limits antag status to clients above player age, if the age system is being used.
			if(C && config.use_age_restriction_for_jobs && isnum(C.player_age) && isnum(min_player_age) && (C.player_age < min_player_age))
				return 0
		if(is_type_in_list(player.assigned_job, restricted_jobs))
			return 0
		if(player.current && (player.current.status_flags & NO_ANTAG))
			return 0
	return 1

/decl/special_role/proc/antags_are_dead()
	for(var/datum/mind/antag in current_antagonists)
		if(mob_path && !istype(antag.current,mob_path))
			continue
		if(antag.current.stat==2)
			continue
		return 0
	return 1

/decl/special_role/proc/get_antag_count()
	return current_antagonists ? current_antagonists.len : 0

/decl/special_role/proc/get_active_antag_count()
	var/active_antags = 0
	for(var/datum/mind/player in current_antagonists)
		var/mob/living/L = player.current
		if(!L || L.stat == DEAD)
			continue //no mob or dead
		if(!L.client && !L.teleop)
			continue //SSD
		active_antags++
	return active_antags

/decl/special_role/proc/is_antagonist(var/datum/mind/player)
	if(player in current_antagonists)
		return 1

/decl/special_role/proc/is_votable()
	return (flags & ANTAG_VOTABLE)

/decl/special_role/proc/can_late_spawn()
	if(!SSticker.mode)
		return 0
	if(!(type in SSticker.mode.latejoin_antags))
		return 0
	return 1

/decl/special_role/proc/is_latejoin_template()
	return (flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))
