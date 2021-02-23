/datum/find
	var/decl/archaeological_find/find_type					//random according to the digsite type
	var/excavation_required = 0		//random 10 - 190
	var/view_range = 40				//how close excavation has to come to show an overlay on the turf
	var/clearance_range = 3			//how close excavation has to come to extract the item
									//if excavation hits var/excavation_required exactly, it's contained find is extracted cleanly without the ore
	var/prob_delicate = 90			//probability it requires an active suspension field to not insta-crumble
	var/dissonance_spread = 1		//proportion of the tile that is affected by this find
									//used in conjunction with analysis machines to determine correct suspension field type

/datum/find/New(var/digsite_type, var/exc_req)
	var/decl/xenoarch_digsite/digsite = GET_DECL(digsite_type)
	find_type = pickweight(digsite.find_types)
	excavation_required = exc_req
	clearance_range = rand(4, 12)
	dissonance_spread = rand(1500, 2500) / 100

/datum/find/proc/get_responsive_reagent()
	var/decl/archaeological_find/find = GET_DECL(find_type)
	return find.responsive_reagent

/datum/find/proc/spawn_find_item(location)
	var/decl/archaeological_find/find = GET_DECL(find_type)
	return find.create_find(location)
