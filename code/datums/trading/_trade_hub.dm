/datum/trade_hub
	var/name = "Trading Hub"
	var/max_traders = 3
	var/list/traders = list()
	var/list/possible_trader_types

/datum/trade_hub/proc/get_initial_traders()
	return

/datum/trade_hub/proc/get_initial_trader_count()
	return max_traders

/datum/trade_hub/proc/is_accessible_from(var/turf/check)
	return FALSE

/datum/trade_hub/New()
	..()
	SStrade.trade_hubs += src
	for(var/trader_type in get_initial_traders())
		add_trader(trader_type)
	var/total_initial_traders = get_initial_trader_count()
	var/total_traders = total_initial_traders - length(traders)
	if(total_traders > 0)
		var/list/trader_types = get_possible_initial_trader_types()
		for(var/i in 1 to total_traders)
			generate_trader(trader_types)

/datum/trade_hub/Destroy(force)
	SStrade.trade_hubs -= src
	QDEL_NULL_LIST(traders)
	. = ..()
	
/datum/trade_hub/proc/get_possible_initial_trader_types()
	return subtypesof(/datum/trader) - typesof(/datum/trader/ship)

/datum/trade_hub/proc/get_possible_post_roundstart_trader_types()
	. = subtypesof(/datum/trader/ship)
	if(prob(95))
		. -= typesof(/datum/trader/ship/unique)

/datum/trade_hub/proc/generate_trader(var/list/use_trader_list)
	if(length(traders)+1 >= max_traders)
		return FALSE
	if(!use_trader_list)
		use_trader_list = get_possible_post_roundstart_trader_types()
	while(length(use_trader_list))
		var/trader_type = pick_n_take(use_trader_list)
		if(!(locate(trader_type) in traders))
			add_trader(trader_type)
			return TRUE

/datum/trade_hub/proc/add_trader(var/trader_type)
	traders += new trader_type(src)

/datum/trade_hub/Process(var/resumed)
	for(var/datum/trader/trader in traders)
		trader.tick()

// Stub for legacy/non-overmap purposes.
/datum/trade_hub/singleton
	max_traders = 10

/datum/trade_hub/singleton/is_accessible_from(var/turf/check)
	return TRUE

/datum/trade_hub/singleton/get_initial_trader_count()
	return rand(2, 3)
// End stub.
