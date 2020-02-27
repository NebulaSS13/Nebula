/decl/content_package
	var/list/dreams                  // A list of strings to be added to the random dream proc.
	var/list/credits_other           // A list of strings that are used by the end of round credits roll.
	var/list/credits_adventure_names // As above.
	var/list/credits_crew_names      // As above.
	var/list/credits_holidays        // As above.
	var/list/credits_adjectives      // As above.
	var/list/credits_crew_outcomes   // As above.
	var/list/credits_topics          // As above.
	var/list/credits_nouns           // As above.
	var/list/worths                  // Associative (type = number) list that is added to the global item worth list.

/decl/content_package/proc/get_player_panel_options(var/mob/M)
