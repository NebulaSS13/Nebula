/datum/map
	/// All branches that exist on this map
	var/list/branches = list()
	/// Branches that a player can choose for spawning on this map, not including species restrictions.
	var/list/spawn_branches_ = list()
	/// Branches that a player can choose for spawning on this map, with species restrictions. Populated on an as-needed basis
	var/list/spawn_branches_by_species_ = list()

	/// list of branch datum paths for military branches available on this map
	var/list/branch_types
	var/list/spawn_branch_types                   // subset of above for branches a player can spawn in with

	var/list/species_to_branch_whitelist = list() // List of branches which are allowed, per species. Checked before the blacklist.
	var/list/species_to_branch_blacklist = list() // List of branches which are restricted, per species.

	var/list/species_to_rank_whitelist = list()   // List of ranks which are allowed, per branch and species. Checked before the blacklist.
	var/list/species_to_rank_blacklist = list()   // Lists of ranks which are restricted, per species.

// todo: this will need heavy reworking if we promote submaps from second to first class map status
/**
 *  Populate the map branches list
 */
/datum/map/proc/populate_branches()
	if(!(global.using_map.flags & MAP_HAS_BRANCH) && !(global.using_map.flags & MAP_HAS_RANK))
		branches  = null
		spawn_branches_ = null
		spawn_branches_by_species_ = null
		return 1

	branches  = list()
	spawn_branches_ = list()
	spawn_branches_by_species_ = list()
	for(var/branch_path in global.using_map.branch_types)
		if(!ispath(branch_path, /datum/mil_branch))
			PRINT_STACK_TRACE("populate_branches() attempted to instantiate object with path [branch_path], which is not a subtype of /datum/mil_branch.")
			continue

		var/datum/mil_branch/branch = new branch_path ()
		branches[branch.name] = branch

		if(branch_path in global.using_map.spawn_branch_types)
			spawn_branches_[branch.name] = branch

	return 1

/**
 *  Retrieve branch object by branch name
 */
/datum/map/proc/get_branch(var/branch_name)
	if(ispath(branch_name, /datum/mil_branch))
		var/datum/mil_branch/branch = branch_name
		branch_name = initial(branch.name)
	if(branch_name && branch_name != "None")
		return branches[branch_name]

/**
 *  Retrieve branch object by branch type
 */
/datum/map/proc/get_branch_by_type(var/branch_type)
	for(var/name in branches)
		if (istype(branches[name], branch_type))
			return branches[name]

/**
 *  Retrieve a rank object from given branch by name
 */
/datum/map/proc/get_rank(var/branch_name, var/rank_name)
	if(ispath(rank_name))
		var/datum/mil_rank/rank = rank_name
		rank_name = initial(rank.name)
	if(rank_name && rank_name != "None")
		var/datum/mil_branch/branch = get_branch(branch_name)
		if(branch)
			return branch.ranks[rank_name]

/**
 *  Return all spawn branches for the given input
 */
/datum/map/proc/spawn_branches(var/decl/species/S)
	if(!S)
		return spawn_branches_.Copy()
	. = LAZYACCESS(spawn_branches_by_species_, S)
	if(!.)
		. = list()
		LAZYSET(spawn_branches_by_species_, S, .)
		for(var/spawn_branch in spawn_branches_)
			if(!global.using_map.is_species_branch_restricted(S, spawn_branches_[spawn_branch]))
				. += spawn_branch

/**
 *  Return all spawn ranks for the given input
 */
/datum/map/proc/spawn_ranks(var/branch_name, var/decl/species/S)
	var/datum/mil_branch/branch = get_branch(branch_name)
	return branch && branch.spawn_ranks(S)

/**
 *  Return a true value if branch_name is a valid spawn branch key
 */
/datum/map/proc/is_spawn_branch(var/branch_name, var/decl/species/S)
	return (branch_name in spawn_branches(S))

/**
 *  Return a true value if rank_name is a valid spawn rank in branch under branch_name
 */
/datum/map/proc/is_spawn_rank(var/branch_name, var/rank_name, var/decl/species/S)
	var/datum/mil_branch/branch = get_branch(branch_name)
	if(branch && (rank_name in branch.spawn_ranks(S)))
		return TRUE
	else
		return FALSE

// The white, and blacklist are type specific, any subtypes (of both species and jobs) have to be added explicitly
/datum/map/proc/is_species_branch_restricted(var/decl/species/S, var/datum/mil_branch/MB)
	if(!istype(S) || !istype(MB))
		return TRUE

	var/list/whitelist = species_to_branch_whitelist[S.type]
	if(MB.type in whitelist)
		return FALSE

	var/list/blacklist = species_to_branch_blacklist[S.type]
	if(blacklist)
		return (MB.type in blacklist)

	return whitelist // not in the whitelist, no blacklist = bad, no whitelist or blacklist = fine

/datum/map/proc/is_species_rank_restricted(var/decl/species/S, var/datum/mil_branch/MB, var/datum/mil_rank/MR)
	if(!istype(S) || !istype(MB) || !istype(MR))
		return TRUE

	var/list/whitelist_by_branch = species_to_rank_whitelist[S.type]
	var/list/whitelist
	if(whitelist_by_branch)
		whitelist = whitelist_by_branch[MB.type]
		if(MR.type in whitelist)
			return FALSE

	var/list/blacklist_by_branch = species_to_rank_blacklist[S.type]
	if(blacklist_by_branch)
		var/list/blacklist = blacklist_by_branch[MB.type]
		if(blacklist)
			return MR.type in blacklist

	return whitelist
