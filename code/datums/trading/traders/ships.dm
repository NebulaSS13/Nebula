//Ships

/datum/trader/ship
	var/duration_of_stay = 0
	var/typical_duration = 20 //In minutes

/datum/trader/ship/New()
	..()
	duration_of_stay = rand(typical_duration,typical_duration * 2)

/datum/trader/ship/tick()
	..()
	if(prob(-disposition) || refuse_comms)
		duration_of_stay -= 5
	return --duration_of_stay > 0

/datum/trader/ship/bribe_to_stay_longer(var/amt)
	if(prob(-disposition))
		return get_response("bribe_refusal", "How about.... no?")

	var/staylength = round(amt/100)
	duration_of_stay += staylength
	. = get_response("bribe_accept", "Sure, I'll stay for TIME more minutes.")
	. = replacetext(., "TIME", staylength)