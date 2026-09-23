/// A _very_ eccentric merchant who sells a wide array of skill books.
/// Compared to most other merchants, they are quite bad at holding firm on a desired price point.
/// With a combination of financial acumen, shrewed negotiation, and sweet words, it's fairly simple to cheat them out of a lot of credits.
/datum/merchant/books
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
	supply_potential = list(/decl/merchant_potential_commodities/book_merchant)
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 1.2,
		/decl/merchant_price_modifier/disposition = 0.75, // Particularly susceptible to flattery. Allegedly this is lore accurate.
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 1.2
	)
	price_variance = 1.3
	haggling_refusal_threshold = 0.3
	refuse_bribes = FALSE
	skill_level = SKILL_BASIC
	positive_disposition_multiplier = 1.2
	speech = /decl/merchant_speech/book_merchant


/decl/merchant_potential_commodities/book_merchant
	type_instructions = list(
		/obj/item/book/skill/organizational/literacy  = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/organizational/finance   = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/general/eva              = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/general/mech             = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/general/pilot            = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/general/hauling          = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/general/computer         = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/service/botany           = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/service/cooking          = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/security/combat          = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/security/weapons         = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/security/forensics       = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/engineering/construction = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/engineering/electrical   = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/engineering/atmos        = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/engineering/engines      = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/research/devices         = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/research/science         = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/medical/chemistry        = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/medical/medicine         = MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/book/skill/medical/anatomy          = MERCHANT_INCLUDE_SUBTYPES
	)


/decl/merchant_speech/book_merchant
	hailed = "Yes hello hello! Many fine paperstacks for sale! Please buy!"
	denied_hail = "Not in! I'm not here! Go away!!"
	goods_not_accepted = "No! No no no! Not goods! MONEY!"
	insult_high_opinion = "Zhat hurts friend!"
	insult_low_opinion = "Ohhhhhh!! Why you picking a fight?! You will lose!"
	compliment_success = "You make my ears red you do! Hehehe!"
	compliment_failure = "Haha! Nice try, but I am not falling for zhe smoozhy talk zhe fourzh time today!"
	how_much = "Hmmmmm, I give zhis to you for maybe... "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	trade_complete = "Yesssss zhank you for transactionings!"
	forbidden_offer = "Aaaaaa! No want, no want! Go away!"
	not_enough_value = "Not enough! More! More!"
	bribe_success = "FREE MONEY!!"
	staying_put = "Zhis is a station, stupid!"
