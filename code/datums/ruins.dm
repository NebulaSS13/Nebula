/datum/map_template/ruin
	name = null
	template_flags = 0 // No duplicates by default
	var/description
	var/cost = 0
	var/prefix
	var/suffixes

// Negative numbers will always be placed, with lower (negative) numbers being placed first; positive and 0 numbers will be placed randomly
/datum/map_template/get_template_cost()
	return cost

/datum/map_template/ruin/New()
	for (var/suffix in suffixes)
		LAZYADD(mappaths, "[prefix][suffix]")
	..()
