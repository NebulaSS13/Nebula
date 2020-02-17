/datum/job/submap
	whitelisted_species = list(SPECIES_HUMAN, SPECIES_YINGLET)
	
/decl/submap_archetype
	whitelisted_species = list(SPECIES_HUMAN, SPECIES_YINGLET)

/datum/map/tradeship
	lobby_tracks = list(/music_track/zazie)
	potential_theft_targets = list(
		"the tradehouse accounting documents"	= /obj/item/documents/tradehouse/account,
		"the tradehouse personnel data"			= /obj/item/documents/tradehouse/personnel,
		"the Captain's spare ID"				= /obj/item/card/id/captains_spare,
		"the ship's blueprints"					= /obj/item/blueprints,
		"the Matriarch's robes"					= /obj/item/clothing/under/yinglet/matriarch,
		"a jetpack"								= /obj/item/tank/jetpack/,
		"a pump action shotgun"					= /obj/item/gun/projectile/shotgun/pump/,
		"a health analyzer"						= /obj/item/scanner/health,
		"the integrated circuit printer"		= /obj/item/integrated_circuit_printer,
		"a whole uneaten mollusc"				= /obj/item/mollusc
	)

/datum/computer_file/program/merchant //wild capitalism
	required_access = null

/datum/map/tradeship/setup_map()
	..()
	SStrade.traders += new /datum/trader/xeno_shop
	SStrade.traders += new /datum/trader/medical
	SStrade.traders += new /datum/trader/mining
	SStrade.traders += new /datum/trader/books

/datum/trader/books
	name = "Yinglet book merchant"
	origin = "Uzed Buks"
	possible_origins = list("Uzed Buks", "Ango & Mango (Still not a fruit shop stop wizh so many asking!)", "Prepipipi's Gently Used Books", "real-books.com.au", "We Sell Paper Wizh Words On", "Meeeena's Paper Recycling")
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ALL
	wanted_items = list(/obj/item/mollusc/clam = TRUE)
	possible_wanted_items = list(/obj/item/mollusc = TRADER_ALL,
								/obj/item/chems/food/snacks/fish/mollusc = TRADER_ALL)
	want_multiplier = 50 // pay good money for clam
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
					"what_want" = "Give clam! Clam clem clom. Soslimy, soyum. Gimme",
					"trade_blacklist" = "Aaaaaa! No want, no want! Go away!",
					"trade_found_unwanted" = "Hmmm, no. Do not want.",
					"trade_not_enough" = "Not enough! More! More!")
