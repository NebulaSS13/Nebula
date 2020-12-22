#define ANTAG_TYPE_RATIO 8

/datum/game_mode/calamity
	name = "Calamity"
	round_description = "This must be a Thursday. You never could get the hang of Thursdays..."
	extended_round_description = "All hell is about to break loose. Literally every antagonist type may spawn in this round. Hold on tight."
	config_tag = "calamity"
	required_players = 1
	votable = 0
	event_delay_mod_moderate = 0.5
	event_delay_mod_major = 0.75

/datum/game_mode/calamity/create_antagonists()

	var/list/antag_candidates = list()
	var/list/all_antagonist_datums = decls_repository.get_decls_of_subtype(/decl/special_role)
	for(var/antag_type in all_antagonist_datums)
		var/decl/special_role/antag = all_antagonist_datums[antag_type]
		if(!(antag.flags & ANTAG_RANDOM_EXCEPTED))
			antag_candidates += antag

	var/grab_antags = round(num_players()/ANTAG_TYPE_RATIO)+1
	while(length(antag_candidates) && length(associated_antags) < grab_antags)
		var/antag_type = pick(antag_candidates)
		antag_candidates -= antag_type
		associated_antags |= antag_type

	..()

#undef ANTAG_TYPE_RATIO
