/area
	var/fishing_failure_prob = 95
	// Hardcoding the contents of /obj/random/junk to avoid hacks for getting results from /obj/random.
	var/list/fishing_results = list(
		/obj/item/remains/mouse     = 1,
		/obj/item/remains/robot     = 1,
		/obj/item/paper/crumpled    = 1,
		/obj/item/inflatable/torn   = 1,
		/obj/item/shard             = 1,
		/obj/item/hand/missing_card = 1
	)

/area/proc/get_fishing_result(turf/origin, obj/item/food/bait)
	if(!length(fishing_results) || prob(fishing_failure_prob))
		return null
	return pickweight(fishing_results)
