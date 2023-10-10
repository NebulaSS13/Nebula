/datum/unit_test/trader_subtypes_shall_have_all_needed_speech_values
	name = "TRADERS: Trader Subtypes Shall Have All Needed Speech Values"
	// Every trader must have these tokens defined.
	var/list/all_trader_speech_tokens = list(
		TRADER_HAIL_GENERIC,
		TRADER_HAIL_DENY,
		TRADER_NOT_ENOUGH,
		TRADER_TRADE_COMPLETE,
		TRADER_HOW_MUCH,
		TRADER_COMPLIMENT_DENY,
		TRADER_COMPLIMENT_ACCEPT,
		TRADER_INSULT_GOOD,
		TRADER_INSULT_BAD,
		TRADER_BRIBE_REFUSAL
	)
	// These tokens are situational and cannot be present if a given flag is on the datum.
	var/list/tokens_invalid_with_flag = list(
		TRADER_NO_MONEY       = TRADER_MONEY,
		TRADER_NO_GOODS       = TRADER_GOODS
	)
	// As above but only present with a flag.
	var/list/tokens_invalid_without_flag = list(
		TRADER_FOUND_UNWANTED = (TRADER_WANTED_ONLY|TRADER_WANTED_ALL),
		TRADER_BRIBE_ACCEPT   = TRADER_BRIBABLE
	)
	// We don't care if these tokens are in the list after the above tokens are weeded out.
	var/list/acceptable_additional_tokens = list(
		// This will default to generic if unset, doesn't matter.
		TRADER_HAIL_SILICON,
		// This token can be used to respond 'I don't want anything' which is valid.
		TRADER_WHAT_WANT,
		// This token has bespoke validity checking and can't go into any of the above lists.
		TRADER_NO_BLACKLISTED
	)

/datum/unit_test/trader_subtypes_shall_have_all_needed_speech_values/start_test()

	// Flagged tokens are handled outside of the general extraneous token list.
	for(var/token in tokens_invalid_with_flag)
		acceptable_additional_tokens |= token
	for(var/token in tokens_invalid_without_flag)
		acceptable_additional_tokens |= token

	// Custom species hails are fine and have no strict tokens associated.
	var/list/all_species = decls_repository.get_decls_of_subtype(/decl/species)
	for(var/species_type in all_species)
		var/decl/species/species = all_species[species_type]
		acceptable_additional_tokens |= "[TRADER_HAIL_START][species.name]"

	var/list/failures = list()
	for(var/trader_type in subtypesof(/datum/trader))
		var/datum/trader/trader = trader_type
		if(TYPE_IS_ABSTRACT(trader))
			continue
		trader = new trader

		if(trader.name_language && !ispath(trader.name_language, /decl/language))
			LAZYDISTINCTADD(failures[trader_type], "- non-/decl/language-subtype non-null name_language value")

		var/list/check_tokens = list()

		// Bespoke blacklist check because life is pain.
		var/has_token     = (TRADER_NO_BLACKLISTED in trader.speech)
		var/has_blacklist = length(trader.blacklisted_trade_items)
		if(has_token && !has_blacklist)
			LAZYDISTINCTADD(failures[trader_type], "- '[TRADER_NO_BLACKLISTED]' response is set but blacklisted_trade_items is empty")
		else if(!has_token && has_blacklist)
			LAZYDISTINCTADD(failures[trader_type], "- '[TRADER_NO_BLACKLISTED]' response is unset but blacklisted_trade_items is populated")

		for(var/token in trader.speech)

			// Simple validity checks.
			if(token in check_tokens)
				LAZYDISTINCTADD(failures[trader_type], "- duplicate speech token '[token]'")
			if(!istext(trader.speech[token]))
				LAZYDISTINCTADD(failures[trader_type], "- non-text speech value for token '[token]'")

			// Keep track of non-additional tokens seen so we can validate them against the general token list later.
			if(!(token in acceptable_additional_tokens))
				check_tokens |= token

		// Check for tokens that are contraindicated by trade flags.
		for(var/token in tokens_invalid_with_flag)
			var/has_flag  = (trader.trade_flags & tokens_invalid_with_flag[token])
			has_token = (token in trader.speech)
			if(has_token && has_flag)
				LAZYDISTINCTADD(failures[trader_type], "- cannot have flagged token '[token]' with current trade flags")
			else if(!has_token && !has_flag)
				LAZYDISTINCTADD(failures[trader_type], "- missing flagged token '[token]'")

		// Check for tokens that are required by trade flags.
		for(var/token in tokens_invalid_without_flag)
			var/has_flag  = (trader.trade_flags & tokens_invalid_without_flag[token])
			has_token = (token in trader.speech)
			if(has_token && !has_flag)
				LAZYDISTINCTADD(failures[trader_type], "- cannot have flagged token '[token]' with current trade flags")
			else if(!has_token && has_flag)
				LAZYDISTINCTADD(failures[trader_type], "- missing flagged token '[token]'")

		// Check for missing generic tokens.
		for(var/token in all_trader_speech_tokens)
			if(!(token in trader.speech))
				LAZYDISTINCTADD(failures[trader_type], "- missing speech value for token '[token]'")
			check_tokens -= token

		// Check for extraneous (probably malformed) tokens not caught by the above checks.
		if(length(check_tokens))
			LAZYDISTINCTADD(failures[trader_type], "- extraneous or incorrect tokens: [english_list(check_tokens)]")

	if(length(failures))
		var/list/fail_strings = list()
		for(var/failed_type in failures)
			fail_strings += "[failed_type]:\n[jointext(failures[failed_type], "\n")]"
		fail("[length(failures)] trader datum subtypes have issues:\n[jointext(fail_strings, "\n")]")
	else
		pass("All trader datum subtypes had valid speech tokens and values.")

	return 1