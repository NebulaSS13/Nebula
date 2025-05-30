/datum/map/tradeship/create_trade_hubs()
	new /datum/trade_hub/singleton/tradeship

/datum/trade_hub/singleton/tradeship
	name = "Tradehouse Freight Network"

/datum/trade_hub/singleton/tradeship
	initial_merchant_types = list(
		/datum/merchant/xeno_shop,
		/datum/merchant/medical,
		/datum/merchant/mining,
		/datum/merchant/books
	)