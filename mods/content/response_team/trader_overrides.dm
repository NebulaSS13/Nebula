/datum/trader/trading_beacon/New()
	..()
	if(type == /datum/trader/trading_beacon) // don't affect subtypes. ugh, i hate that this is necessary
		possible_trading_items[/obj/item/backpack/ert] = TRADER_BLACKLIST_ALL