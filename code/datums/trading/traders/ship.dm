//Ships are on a time limit as far as being around goes.
//They are ALSO the only ones that can appear after round start
/datum/trader/ship
	abstract_type = /datum/trader/ship
	trade_flags = TRADER_MONEY | TRADER_BRIBABLE
	var/duration_of_stay = 0
	var/typical_duration = 20 //minutes (since trader processes only tick once a minute)

/datum/trader/ship/New()
	..()
	duration_of_stay = rand(typical_duration,typical_duration * 2)

/datum/trader/ship/tick()
	..()
	if(prob(-disposition) || refuse_comms)
		duration_of_stay -= 5
	return --duration_of_stay > 0

/datum/trader/ship/is_bribable()
	return ..() || prob(-disposition)

/datum/trader/ship/is_bribed(var/staylength)
	duration_of_stay += staylength
	. = get_response(TRADER_BRIBE_ACCEPT, "Sure, I'll stay for " + TRADER_TOKEN_TIME + " more minutes.")
	. = replacetext(., TRADER_TOKEN_TIME, staylength)
