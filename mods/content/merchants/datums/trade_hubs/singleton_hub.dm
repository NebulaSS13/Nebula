/// Used for legacy maps, maps without an overmap, or maps that don't want to use the overmap hubs.
/// It is unconditionally accessible anywhere on the map (overmap or otherwise).
/datum/trade_hub/singleton
	max_merchants = 10

/datum/trade_hub/singleton/is_accessible_from(turf/checked_turf)
	return TRUE

/// Spawns all merchants in one place.
/datum/trade_hub/singleton/debug
	name = "The Omni-Bazaar"
	max_merchants = 1000

/datum/trade_hub/singleton/debug/New()
	initial_merchant_types = get_non_abstract_types(/datum/merchant)
	..()