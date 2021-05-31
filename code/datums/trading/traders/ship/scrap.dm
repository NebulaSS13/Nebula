//Shady drone-ship intended to drop off some scrap at low prices

/datum/trader/ship/generic/scrap
	name = "Scrap Trader"
	name_language = /decl/language/legal
	trade_flags = TRADER_MONEY

	typical_duration = 1 //catch them
	margin = 0.7

	possible_wanted_items = list()

//i processed the original speech through google translate to make it look crappy

	speech = list("hail_generic"    = "Regards, I am a MERCHANT, an artificial intelligence board ORIGIN, whose job is to trade goods against currency and supplies.",
				"hail_deny"         = "Sorry, your connection has been blacklisted. Have a nice day.",

				"trade_complete"    = "Thank you for your protection.",
				"trade_not_enough"  = "Unfortunately, your offer is not worth what you ask for.",
				"trade_blacklisted" = "You have submitted a blacklisted item. My laws do not allow me to engage in this trade.",
				"how_much"          = "ITEM will pay you approximately the VALUE of CURRENCY or something similar.",
				"what_want"         = "Cannot comply.",

				"compliment_deny"   = "I'm sorry, I can't let the compliments affect the trade.",
				"compliment_accept" = "Thanks, but it doesn’t change our business.",
				"insult_good"       = "I don’t understand, don’t we have good conditions?",
				"insult_bad"        = "I don't understand, are you hurting me?",

				"bribe_refusal"     = "The request cannot be processed.",
				)

/datum/trader/ship/generic/scrap/New()
	..()
	var/decl/language/L = GET_DECL(name_language)
	origin = L.get_random_name()