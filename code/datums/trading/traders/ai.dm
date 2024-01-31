/*

TRADING BEACON

Trading beacons are generic AI driven trading outposts.
They sell generic supplies and ask for generic supplies.
*/

/datum/trader/trading_beacon
	name = "AI"
	origin = "Trading Beacon"
	name_language = /decl/language/human/common
	trade_flags = TRADER_MONEY | TRADER_GOODS
	speech = list(
		TRADER_HAIL_GENERIC      = "Greetings, I am " + TRADER_TOKEN_MERCHANT + ", Artifical Intelligence onboard " + TRADER_TOKEN_ORIGIN + ", tasked with trading goods in return for " + TRADER_TOKEN_CURRENCY + " and supplies.",
		TRADER_HAIL_DENY         = "We are sorry, your connection has been blacklisted. Have a nice day.",
		TRADER_TRADE_COMPLETE    = "Thank you for your patronage.",
		TRADER_NOT_ENOUGH        = "I'm sorry, your offer is not worth what you are asking for.",
		TRADER_NO_BLACKLISTED    = "You have offered a blacklisted item. My laws do not allow me to trade for that.",
		TRADER_HOW_MUCH          = TRADER_TOKEN_ITEM + " will cost you roughly " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ", or something of equal worth.",
		TRADER_WHAT_WANT         = "I have logged need for",
		TRADER_COMPLIMENT_DENY   = "I'm sorry, I am not allowed to let compliments affect the trade.",
		TRADER_COMPLIMENT_ACCEPT = "Thank you, but that will not not change our business interactions.",
		TRADER_INSULT_GOOD       = "I do not understand, are we not on good terms?",
		TRADER_INSULT_BAD        = "I do not understand, are you insulting me?",
		TRADER_BRIBE_REFUSAL     = "You have given me money to stay, however, I am a station. I do not leave.",
	)
	possible_wanted_items = list(
		/obj/item                                          = TRADER_SUBTYPES_ONLY,
		/obj/item/assembly                                 = TRADER_BLACKLIST_ALL,
		/obj/item/assembly_holder                          = TRADER_BLACKLIST_ALL,
		/obj/item/encryptionkey/hacked                     = TRADER_BLACKLIST,
		/obj/item/tank/onetankbomb                         = TRADER_BLACKLIST,
		/obj/item/radio                                    = TRADER_BLACKLIST_ALL,
		/obj/item/modular_computer/pda                     = TRADER_BLACKLIST_SUB,
		/obj/item/uplink                                   = TRADER_BLACKLIST
	)
	possible_trading_items = list(
		/obj/item/storage/bag                              = TRADER_SUBTYPES_ONLY,
		/obj/item/storage/bag/cash/infinite                = TRADER_BLACKLIST,
		/obj/item/storage/backpack                         = TRADER_ALL,
		/obj/item/storage/backpack/cultpack                = TRADER_BLACKLIST,
		/obj/item/storage/backpack/holding                 = TRADER_BLACKLIST,
		/obj/item/storage/backpack/satchel/grey/withwallet = TRADER_BLACKLIST,
		/obj/item/storage/backpack/satchel/syndie_kit      = TRADER_BLACKLIST_ALL,
		/obj/item/storage/backpack/chameleon               = TRADER_BLACKLIST,
		/obj/item/storage/backpack/ert                     = TRADER_BLACKLIST_ALL,
		/obj/item/storage/backpack/dufflebag/syndie        = TRADER_BLACKLIST_SUB,
		/obj/item/storage/belt/champion                    = TRADER_THIS_TYPE,
		/obj/item/storage/briefcase                        = TRADER_THIS_TYPE,
		/obj/item/storage/box/fancy                        = TRADER_SUBTYPES_ONLY,
		/obj/item/storage/laundry_basket                   = TRADER_THIS_TYPE,
		/obj/item/storage/secure/briefcase                 = TRADER_THIS_TYPE,
		/obj/item/storage/plants                           = TRADER_THIS_TYPE,
		/obj/item/storage/ore                              = TRADER_THIS_TYPE,
		/obj/item/storage/toolbox                          = TRADER_ALL,
		/obj/item/storage/wallet                           = TRADER_THIS_TYPE,
		/obj/item/storage/photo_album                      = TRADER_THIS_TYPE,
		/obj/item/clothing/glasses                         = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/glasses/hud                     = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/glasses/blindfold/tape          = TRADER_BLACKLIST,
		/obj/item/clothing/glasses/chameleon               = TRADER_BLACKLIST
	)

	insult_drop = 0
	compliment_increase = 0

/datum/trader/trading_beacon/New()
	..()
	origin = "[origin] #[rand(100,999)]"

/datum/trader/trading_beacon/mine
	origin = "Mining Beacon"

	possible_trading_items = list(
		/obj/item/stack/material/ore                        = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/material/pane/mapped/glass          = TRADER_ALL,
		/obj/item/stack/material/pane/mapped/glass/fifty    = TRADER_BLACKLIST,
		/obj/item/stack/material/ingot/mapped/iron          = TRADER_THIS_TYPE,
		/obj/item/stack/material/brick/mapped/sandstone     = TRADER_THIS_TYPE,
		/obj/item/stack/material/brick/mapped/marble        = TRADER_THIS_TYPE,
		/obj/item/stack/material/gemstone/mapped/diamond    = TRADER_THIS_TYPE,
		/obj/item/stack/material/puck/mapped/uranium        = TRADER_THIS_TYPE,
		/obj/item/stack/material/panel/mapped/plastic       = TRADER_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/gold          = TRADER_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/silver        = TRADER_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/platinum      = TRADER_THIS_TYPE,
		/obj/item/stack/material/segment/mapped/mhydrogen   = TRADER_THIS_TYPE,
		/obj/item/stack/material/aerogel/mapped/tritium     = TRADER_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/osmium        = TRADER_THIS_TYPE,
		/obj/item/stack/material/sheet/mapped/steel         = TRADER_THIS_TYPE,
		/obj/item/stack/material/reinforced/mapped/plasteel = TRADER_THIS_TYPE,
		/obj/machinery/mining                               = TRADER_SUBTYPES_ONLY
	)

/datum/trader/trading_beacon/manufacturing
	origin = "Manifacturing Beacon"

	possible_trading_items = list(
		/obj/structure/aicore            = TRADER_THIS_TYPE,
		/obj/structure/girder            = TRADER_THIS_TYPE,
		/obj/structure/grille            = TRADER_THIS_TYPE,
		/obj/structure/mopbucket         = TRADER_THIS_TYPE,
		/obj/structure/ore_box           = TRADER_THIS_TYPE,
		/obj/structure/coatrack          = TRADER_THIS_TYPE,
		/obj/structure/bookcase          = TRADER_THIS_TYPE,
		/obj/item/bee_pack               = TRADER_THIS_TYPE,
		/obj/item/bee_smoker             = TRADER_THIS_TYPE,
		/obj/item/beehive_assembly       = TRADER_THIS_TYPE,
		/obj/item/glass_jar              = TRADER_THIS_TYPE,
		/obj/item/honey_frame            = TRADER_THIS_TYPE,
		/obj/item/target                 = TRADER_ALL,
		/obj/structure/tank_rack         = TRADER_SUBTYPES_ONLY,
		/obj/structure/filing_cabinet    = TRADER_THIS_TYPE,
		/obj/structure/safe              = TRADER_THIS_TYPE,
		/obj/structure/plushie           = TRADER_SUBTYPES_ONLY,
		/obj/structure/sign              = TRADER_SUBTYPES_ONLY,
		/obj/structure/sign/double       = TRADER_BLACKLIST_ALL,
		/obj/structure/sign/plaque/golden = TRADER_BLACKLIST_ALL,
		/obj/structure/sign/poster       = TRADER_BLACKLIST
	)