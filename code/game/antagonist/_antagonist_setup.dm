/*
 MODULAR ANTAGONIST SYSTEM

 Attempts to centralize antag tracking code into its own system, which has the added bonus of making 
 the display procs consistent. Should be fairly self-explanatory with a review of the procs.

 To use:
	- Get the appropriate datum via the decls repository ie. 
	  var/decl/special_role/A = decls_repository.get_decl(/decl/special_role/traitor)
	- Call add_antagonist() on the desired target mind ie. A.add_antagonist(mob.mind)
	- To ignore protected roles, supply a positive second argument.
	- To skip equipping with appropriate gear, supply a positive third argument.
*/

// Global procs.
/proc/clear_antag_roles(var/datum/mind/player, var/implanted)
	var/list/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
	for(var/antag_type in all_antag_types)
		var/decl/special_role/antag = all_antag_types[antag_type]
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/proc/update_antag_icons(var/datum/mind/player)
	var/list/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
	for(var/antag_type in all_antag_types)
		var/decl/special_role/antag = all_antag_types[antag_type]
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/proc/player_is_antag(var/datum/mind/player, var/only_offstation_roles = 0)
	var/list/all_antag_types = decls_repository.get_decls_of_subtype(/decl/special_role)
	for(var/antag_type in all_antag_types)
		var/decl/special_role/antag = all_antag_types[antag_type]
		if(only_offstation_roles && !(antag.flags & ANTAG_OVERRIDE_JOB))
			continue
		if(player in antag.current_antagonists)
			return antag
		if(player in antag.pending_antagonists)
			return antag
	return 0
