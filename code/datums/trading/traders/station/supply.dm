//Supply station! Literally everything what's in need for every ship to get up and running

/datum/trader/supply_station
	name = "Trading Supply Station"
	name_language = /decl/language/human/common
	trade_flags = TRADER_MONEY | TRADER_GOODS | TRADER_WANTED_ONLY

	margin = 1.1

	insult_drop = 0 //dumber than ships
	compliment_increase = 0

	possible_trading_items = list(/obj/item/tank/oxygen/yellow = TRADER_THIS_TYPE,
								/obj/item/tank/hydrogen = TRADER_THIS_TYPE,
								/obj/machinery/portable_atmospherics/canister/air = TRADER_THIS_TYPE,
								/obj/machinery/portable_atmospherics/canister/hydrogen = TRADER_THIS_TYPE,
								/obj/machinery/portable_atmospherics/canister/oxygen = TRADER_THIS_TYPE,
								/obj/machinery/portable_atmospherics/canister/carbon_dioxide = TRADER_THIS_TYPE,
								/obj/item/stack/material/puck/mapped/uranium/ten = TRADER_THIS_TYPE,
								/obj/item/stack/material/aerogel/mapped/deuterium/ten = TRADER_THIS_TYPE,
								/obj/structure/reagent_dispensers/watertank = TRADER_THIS_TYPE,
								/obj/structure/reagent_dispensers/fueltank = TRADER_THIS_TYPE,
								/obj/item/storage/toolbox/mechanical = TRADER_THIS_TYPE,
								/obj/item/storage/toolbox/repairs = TRADER_THIS_TYPE,
								/obj/item/multitool = TRADER_THIS_TYPE,
								/obj/item/gun/projectile/pistol/random = TRADER_THIS_TYPE,
								/obj/item/ammo_magazine/pistol = TRADER_THIS_TYPE,
								/obj/item/clothing/head/helmet/space/void/engineering = TRADER_THIS_TYPE,
								/obj/item/clothing/suit/space/void/engineering = TRADER_THIS_TYPE,
								/obj/item/stack/cable_coil/random = TRADER_THIS_TYPE,
								/obj/item/cell/high = TRADER_THIS_TYPE,
								/obj/item/storage/firstaid/regular = TRADER_THIS_TYPE,
								/obj/item/storage/firstaid/adv = TRADER_THIS_TYPE,
								/obj/item/chems/food/snacks/canned = TRADER_SUBTYPES_ONLY,
								/obj/item/chems/food/snacks/canned/caviar = TRADER_BLACKLIST_ALL,
								/obj/item/chems/food/drinks/cans/waterbottle = TRADER_THIS_TYPE
								)

	possible_wanted_items = list(/obj/item/trash = TRADER_SUBTYPES_ONLY)

	speech = list("hail_generic"    = "Greetings! This is automated trading unit speaking. It's a pleasure to receive a connection from you, our dear customer. We are also participating in a trash recycling program right now.",
				"hail_deny"         = "No signal.",

				"trade_complete"    = "Thank you! We hope you will enjoy using our goods.",
				"trade_not_enough"  = "There is not enough CURRENCY. Please supply a valid amount of it into your trading terminal.",
				"trade_blacklisted" = "We cannot process that order. Sorry for the inconvenience.",
				"how_much"          = "This wonderful ITEM will cost you only VALUE CURRENCY_SINGULAR! Payment type identifier: CURRENCY",
				"what_want"         = "We are currently looking for processing any sort of trash items. These may include:",

				"compliment_deny"   = "Ignoring social interaction. Code: 1001",
				"compliment_accept" = "Ignoring social interaction. Code: 1002",
				"insult_good"       = "Ignoring social interaction. Code: 9990",
				"insult_bad"        = "Ignoring social interaction. Code: 0000",

				"bribe_refusal"     = "Cannot process request. Entry \"station\" will not reposition.",
				)

/datum/trader/supply_station/New()
	..()
	origin = "Resupply Platform [pick("Alpha","Beta","Gamma","Delta","Epsilon","Zeta")]-[rand(1,90)]"