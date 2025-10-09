/**
 *  Datums for military branches and ranks
 *
 *  Map datums can optionally specify a list of /datum/mil_branch paths. These paths
 *  are used to initialize ranks for the map, which contains a list of
 *  branch objects used on the map. Each branch definition specifies a list of
 *  /datum/mil_rank paths, which are ranks available to that branch.
 *
 *  Which branches and ranks can be selected for spawning is specifed in global.using_map
 *  and each branch datum definition, respectively.
 */

/**
 *  A single military branch, such as Fleet or Marines
 */
/datum/mil_branch
	var/name = "Unknown"         // Longer name for branch, eg  "Grand High Nosepickers"
	var/name_short       		// Abbreviation of the name, eg "GHN"



	var/list/ranks // Associative list of full rank names to the corresponding
	               // /datum/mil_rank objects. These are all ranks available to the branch.

	var/list/spawn_ranks_            // Ranks which the player can choose for spawning, not including species restrictions
	var/list/spawn_ranks_by_species_ // Ranks which the player can choose for spawning, with species restrictions. Populated on a needed basis

	var/list/rank_types       // list of paths used to init the ranks list
	var/list/spawn_rank_types // list of paths used to init the spawn_ranks list. Subset of rank_types

	var/assistant_job

	var/list/min_skill

/datum/mil_branch/New()
	ranks = list()
	spawn_ranks_ = list()
	spawn_ranks_by_species_ = list()

	if(isnull(assistant_job))
		assistant_job = global.using_map.default_job_type

	for(var/rank_path in rank_types)
		if(!ispath(rank_path, /datum/mil_rank))
			PRINT_STACK_TRACE("[name]'s rank_types includes [rank_path], which is not a subtype of /datum/mil_rank.")
			continue
		var/datum/mil_rank/rank = new rank_path ()
		ranks[rank.name] = rank

		if(rank_path in spawn_rank_types)
			spawn_ranks_[rank.name] = rank

/datum/mil_branch/proc/spawn_ranks(var/decl/species/S)
	if(!S)
		return spawn_ranks_.Copy()
	. = spawn_ranks_by_species_[S]
	if(!.)
		. = list()
		spawn_ranks_by_species_[S] = .
		for(var/spawn_rank in spawn_ranks_)
			if(!global.using_map.is_species_rank_restricted(S, src, spawn_ranks_[spawn_rank]))
				. += spawn_rank

/**
 *  A military rank
 *
 *  Note that in various places "rank" is used to refer to a character's job, and
 *  so this is  "mil_rank" to distinguish it.
 */
/datum/mil_rank
	var/name = "Unknown"
	var/name_short // Abbreviation of the name. Should be null if the
	                       // rank doesn't usually serve as a prefix to the individual's name.
	var/list/accessory		//type of accesory that will be equipped by job code with this rank
	var/sort_order = 0 // A numerical equivalent of the rank used to indicate its order when compared to other datums: eg e-1 = 1, o-1 = 11

//Returns short designation (yes shorter than name_short), like E1, O3 etc.
/datum/mil_rank/proc/grade()
	return sort_order