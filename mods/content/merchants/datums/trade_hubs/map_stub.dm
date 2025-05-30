/// Called during init by the trade controller, to create trade hubs.
/// By default it makes a singleton trade hub, which can be accessed unconditionally.
/// Override it if you want to tailor it to a specific map or if you want to use overmap trade hubs.
/datum/map/proc/create_trade_hubs()
	new /datum/trade_hub/singleton