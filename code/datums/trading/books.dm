/datum/trader/books
	name = "strange book merchant"
	origin = "Uzed Buks"
	possible_origins = list("Uzed Buks", "Ango & Mango (Still not a fruit shop stop wizh so many asking!)", "Prepipipi's Gently Used Books", "real-books.com.au", "We Sell Paper Wizh Words On", "Meeeena's Paper Recycling")
	trade_flags = TRADER_MONEY
	possible_wanted_items = list()
	price_rng = 30

	possible_trading_items = list(/obj/item/book/skill/organizational/literacy = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/organizational/finance = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/general/eva = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/general/mech = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/general/pilot = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/general/hauling = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/general/computer = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/service/botany = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/service/cooking = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/security/combat = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/security/weapons = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/security/forensics = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/engineering/construction = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/engineering/electrical = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/engineering/atmos = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/engineering/engines = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/research/devices = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/research/science = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/medical/chemistry = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/medical/medicine = TRADER_SUBTYPES_ONLY,
								/obj/item/book/skill/medical/anatomy = TRADER_SUBTYPES_ONLY)

	speech = list("hail_generic" = "Yes hello hello! Many fine paperstacks for sale! Please buy!",
					"hail_deny" = "Not in! I'm not here! Go away!!",
					"hail_yinglet" = "Books!  Paper stuffs!  Come and get 'em hot off za presses!  Can't read?  No problem!  Zhey burn oh so good!  Can read?  Great!  Don't want to read 'em even so?  Zhey STILL BURN!",

					"insult_good" = "Zhat hurts friend!",
					"insult_bad" = "Ohhhhhh!! Why you picking a fight?! You will lose!",
					"compliment_accept" = "You make my ears red you do! Hehehe!",
					"compliment_deny" = "Haha! Nice try, but I am not falling for zhe smoozhy talk zhe fourzh time today!",

					"how_much" = "Hmmmmm, I give zhis to you for maybe... VALUE CURRENCY.",
					"trade_complete" = "Yesssss zhank you for transactionings!!",
					"trade_refuse" = "No! No no no no!",
					"trade_blacklist" = "Aaaaaa! No want, no want! Go away!",
					"trade_found_unwanted" = "Hmmm, no. Do not want.",
					"trade_not_enough" = "Not enough! More! More!")
