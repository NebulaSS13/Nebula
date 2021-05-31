//Trading ship/freighter. Trades.. literally everything.

/datum/trader/ship/generic
	name = "Generic Trader Ship"
	name_language = /decl/language/human/common
	trade_flags = TRADER_MONEY | TRADER_GOODS | TRADER_WANTED_ONLY

	typical_duration = 10

	possible_wanted_items = list(/obj/item = TRADER_SUBTYPES_ONLY)
	possible_trading_items = list(/obj/item = TRADER_SUBTYPES_ONLY)

	speech = list("hail_generic"    = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN, tasked with trading goods in return for CURRENCY and supplies.",
				"hail_deny"         = "We are sorry, your connection has been blacklisted. Have a nice day.",

				"trade_complete"    = "Thank you for your patronage.",
				"trade_not_enough"  = "I'm sorry, your offer is not worth what you are asking for.",
				"trade_blacklisted" = "You have offered a blacklisted item. My laws do not allow me to trade for that.",
				"how_much"          = "ITEM will cost you roughly VALUE CURRENCY, or something of equal worth.",
				"what_want"         = "I have logged need for",

				"compliment_deny"   = "I'm sorry, I am not allowed to let compliments affect the trade.",
				"compliment_accept" = "Thank you, but that will not not change our business interactions.",
				"insult_good"       = "I do not understand, are we not on good terms?",
				"insult_bad"        = "I do not understand, are you insulting me?",

				"bribe_refusal"     = "Cannot process request.",
				)

/datum/trader/ship/generic/New()
	..()
	var/obj/first_trading = trading_items[1]
	origin = "[pick("Mobile","Movable","Portable","Cruising")] [capitalize(lowertext(initial(first_trading.name)))] [pick("Stock","Stockpile","Storage","Vault","Shed","Warehouse","Garage")] #[rand(1000,9999)]"