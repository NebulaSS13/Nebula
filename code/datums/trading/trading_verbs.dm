/client/proc/list_traders()
	set category = "Debug"
	set name = "List Traders"
	set desc = "Lists all the current traders"

	for(var/datum/trade_hub/hub in SStrade.trade_hubs)
		to_chat(src, "<b>[hub.name]:</b>")
		for(var/a in hub.traders)
			var/datum/trader/T = a
			to_chat(src, "[T.name] <a href='?_src_=vars;Vars=\ref[T]'>\ref[T]</a>")

/client/proc/add_trader()
	set category = "Debug"
	set name = "Add Trader"
	set desc = "Adds a trader to the list."

	var/datum/trade_hub/hub = input(src, "Select a trade hub.", "Add Trade") as null|anything in SStrade.trade_hubs
	if(!hub || !(hub in SStrade.trade_hubs))
		return
	var/trader_type = input(src,"Choose a type to add.") as null|anything in hub.possible_trader_types
	if(trader_type && (hub in SStrade.trade_hubs) && (trader_type in hub.possible_trader_types) && !(locate(trader_type) in hub.traders))
		hub.add_trader(trader_type)

/client/proc/remove_trader()
	set category = "Debug"
	set name = "Remove Trader"
	set desc = "Removes a trader from the trader list."

	var/datum/trade_hub/hub = input(src, "Select a trade hub.", "Add Trade") as null|anything in SStrade.trade_hubs
	if(!hub || !(hub in SStrade.trade_hubs))
		return
	var/choice = input(src, "Choose a trader to remove.") as null|anything in hub.traders
	if(choice && (choice in hub.traders))
		qdel(choice)
