/obj/effect/overmap/visitable/proc/has_internet_connection(connecting_network)
	. = FALSE
	// Must have an active and operable PLEXUS repeater in the sector.
	var/found_repeater = FALSE
	for(var/obj/machinery/internet_repeater/repeater in global.internet_repeaters)
		if(!(get_z(repeater) in map_z))
			continue
		if(repeater.use_power == POWER_USE_ACTIVE && repeater.operable())
			found_repeater = TRUE
			break
	if(!found_repeater)
		return

	// Must have an operable internet uplink in range on the overmap. 
	for(var/obj/machinery/internet_uplink/uplink in global.internet_uplinks)
		if(uplink.use_power != POWER_USE_ACTIVE || !uplink.operable())
			continue
		if(uplink.restrict_networks && !(connecting_network in uplink.permitted_networks))
			continue

		// Ensure the sectors are within range.
		var/obj/effect/overmap/sector = uplink.get_owning_overmap_object()
		if(sector == src || (get_dist(get_turf(sector), get_turf(src)) <= uplink.overmap_range))
			return TRUE

// Helper to get nearby connections. Returns list(list(x, y) = allowed networks).
/obj/effect/overmap/visitable/proc/get_internet_connections()
	var/found = list()
	for(var/obj/machinery/internet_uplink/uplink in global.internet_uplinks)
		if(uplink.use_power != POWER_USE_ACTIVE || !uplink.operable())
			continue

		// Range check.
		var/obj/effect/overmap/sector = uplink.get_owning_overmap_object()
		if(sector == src || (get_dist(get_turf(sector), get_turf(src)) <= uplink.overmap_range))
			var/list/location = list(sector.x, sector.y)
			var/allowed = uplink.restrict_networks ? english_list(uplink.permitted_networks, nothing_text = "NO NETWORKS") : "ALL NETWORKS"
			found[location] = allowed
		
	return found