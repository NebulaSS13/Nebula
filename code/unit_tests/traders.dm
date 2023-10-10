/datum/unit_test/trader_subtypes_shall_have_all_needed_speech_values
	name = "TRADERS: Trader Subtypes Shall Have All Needed Speech Values"
	var/list/all_trader_speech_tokens = list(
		TRADER_HAIL_GENERIC,
		TRADER_HAIL_SILICON,
		TRADER_HAIL_DENY,
		TRADER_NO_MONEY,
		TRADER_NO_GOODS,
		TRADER_NOT_ENOUGH,
		TRADER_NO_BLACKLISTED,
		TRADER_FOUND_UNWANTED,
		TRADER_TRADE_COMPLETE,
		TRADER_HOW_MUCH,
		TRADER_WHAT_WANT,
		TRADER_COMPLIMENT_DENY,
		TRADER_COMPLIMENT_ACCEPT,
		TRADER_INSULT_GOOD,
		TRADER_INSULT_BAD,
		TRADER_BRIBE_REFUSAL,
		TRADER_BRIBE_ACCEPT
	)

/datum/unit_test/trader_subtypes_shall_have_all_needed_speech_values/start_test()
	var/list/failures = list()
	for(var/trader_type in subtypesof(/datum/trader))
		var/datum/trader/trader = trader_type
		if(TYPE_IS_ABSTRACT(trader))
			continue
		trader = new trader
		var/list/check_tokens = list()
		for(var/token in trader.speech)
			if(token in check_tokens)
				LAZYDISTINCTADD(failures[trader_type], "- duplicate speech token '[token]'")
			check_tokens |= token
			if(!istext(trader.speech[token]))
				LAZYDISTINCTADD(failures[trader_type], "- non-text speech value for token '[token]'")

		for(var/token in all_trader_speech_tokens)
			if(!(token in trader.speech))
				LAZYDISTINCTADD(failures[trader_type], "- missing speech value for token '[token]'")
			check_tokens -= token
		if(length(check_tokens))
			LAZYDISTINCTADD(failures[trader_type], "- extraneous or incorrect tokens: [english_list(check_tokens)]")

	if(length(failures))
		var/list/fail_strings = list()
		for(var/failed_type in failures)
			fail_strings += "[failed_type]:\n[jointext(failures[failed_type], "\n")]"
		fail("[length(failures)] trader datum subtypes have issues: [jointext(fail_strings, "\n")]")
	else
		pass("All trader datum subtypes had valid speech tokens and values.")

	return 1