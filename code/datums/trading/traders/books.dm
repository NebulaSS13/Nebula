/datum/trader/books
	name = "strange book merchant"
	origin = "Uzed Buks"
	possible_origins = list(
		"Uzed Buks",
		"Ango & Mango (Still not a fruit shop stop wizh so many asking!)",
		"Prepipipi's Gently Used Books",
		"real-books.com.au",
		"We Sell Paper Wizh Words On",
		"Meeeena's Paper Recycling"
	)
	trade_flags = TRADER_MONEY
	possible_wanted_items = list()
	price_rng = 30

	possible_trading_items = list(
		/obj/item/book/skill/organizational/literacy  = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/organizational/finance   = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/general/eva              = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/general/mech             = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/general/pilot            = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/general/hauling          = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/general/computer         = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/service/botany           = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/service/cooking          = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/security/combat          = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/security/weapons         = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/security/forensics       = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/engineering/construction = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/engineering/electrical   = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/engineering/atmos        = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/engineering/engines      = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/research/devices         = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/research/science         = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/medical/chemistry        = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/medical/medicine         = TRADER_SUBTYPES_ONLY,
		/obj/item/book/skill/medical/anatomy          = TRADER_SUBTYPES_ONLY
	)

	speech = list(
		TRADER_HAIL_GENERIC      = "Yes hello hello! Many fine paperstacks for sale! Please buy!",
		TRADER_HAIL_DENY         = "Not in! I'm not here! Go away!!",
		TRADER_NO_GOODS          = "No! No no no! Not goods! MONEY!",
		TRADER_INSULT_GOOD       = "Zhat hurts friend!",
		TRADER_INSULT_BAD        = "Ohhhhhh!! Why you picking a fight?! You will lose!",
		TRADER_COMPLIMENT_ACCEPT = "You make my ears red you do! Hehehe!",
		TRADER_COMPLIMENT_DENY   = "Haha! Nice try, but I am not falling for zhe smoozhy talk zhe fourzh time today!",
		TRADER_HOW_MUCH          = "Hmmmmm, I give zhis to you for maybe... " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_TRADE_COMPLETE    = "Yesssss zhank you for transactionings!",
		TRADER_NO_BLACKLISTED    = "Aaaaaa! No want, no want! Go away!",
		TRADER_NOT_ENOUGH        = "Not enough! More! More!",
		TRADER_BRIBE_REFUSAL     = "Zhis is a station, stupid!"
	)
