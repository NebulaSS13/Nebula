SUBSYSTEM_DEF(trade)
	name = "Trade"
	wait = 1 MINUTE
	priority = SS_PRIORITY_TRADE
	init_order = SS_INIT_MISC_LATE

	var/list/trade_hubs = list()
	var/tmp/t_ind = 1
	var/tmp/list/processing_trade_hubs

/datum/controller/subsystem/trade/Initialize()
	. = ..()
	GLOB.using_map.create_trade_hubs()

/datum/controller/subsystem/trade/fire(resumed = FALSE)

	if(!resumed)
		processing_trade_hubs = trade_hubs.Copy()
		t_ind = 1

	while(t_ind <= processing_trade_hubs.len)
		var/datum/trade_hub/hub = processing_trade_hubs[t_ind++]
		hub.Process(resumed)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/trade/stat_entry()
	var/traders = 0
	for(var/datum/trade_hub/hub in trade_hubs)
		traders += length(hub.traders)
	..("Hubs: [length(trade_hubs)], traders: [traders]")
