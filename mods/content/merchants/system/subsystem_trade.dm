SUBSYSTEM_DEF(trade)
	name = "Trade"
	wait = 1 MINUTE
	priority = SS_PRIORITY_TRADE
	init_order = SS_INIT_MISC_LATE

	var/list/trade_hubs = list()
	var/tmp/current_index = 1
	var/tmp/list/processing_trade_hubs = null

/datum/controller/subsystem/trade/Initialize()
	. = ..()
	global.using_map.create_trade_hubs()

/datum/controller/subsystem/trade/fire(resumed = FALSE)

	if(!resumed)
		processing_trade_hubs = trade_hubs.Copy()
		current_index = 1

	while(current_index <= processing_trade_hubs.len)
		var/datum/trade_hub/hub = processing_trade_hubs[current_index++]
		hub.Process(resumed, times_fired)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/trade/stat_entry()
	var/merchants = 0
	for(var/datum/trade_hub/hub in trade_hubs)
		merchants += length(hub.merchants)
	..("Hubs: [length(trade_hubs)], Merchants: [merchants]")
