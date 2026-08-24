/turf/proc/get_fishing_result(obj/item/food/bait)
	var/area/A = get_area(src)
	return A.get_fishing_result(src, bait)