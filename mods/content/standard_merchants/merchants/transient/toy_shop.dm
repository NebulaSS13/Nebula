/// A merchant who sells games, plushies, and other toys.
/// They buck the trend with retail-themed merchants. They seek to complete their collection of action figures, and can be haggled with.
/datum/merchant/transient/toy_shop
	name = "Toy Shop Employee"
	origin = "Toy Shop"
	skill_level = SKILL_BASIC
	accepts_goods_as_payment = TRUE
	possible_origins = list(
		"Toys R Ours",
		"LET'S GO",
		"Kay-Cee Toys",
		"Build-a-Cat",
		"Magic Box",
		"The Positronic's Dungeon and Baseball Card Shop"
	)
	speech = /decl/merchant_speech/toy_shop
	supply_potential = list(/decl/merchant_potential_commodities/toy_shop_supply)
	demand_potential = list(/decl/merchant_potential_commodities/toy_shop_demand)


/decl/merchant_potential_commodities/toy_shop_supply
	type_instructions = list(
		/obj/item/toy/prize							= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/toy/prize/honk					= MERCHANT_EXCLUDE_THIS_TYPE,
		/obj/item/toy/figure						= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/toy/figure/ert					= MERCHANT_EXCLUDE_THIS_TYPE,
		/obj/item/toy/plushie						= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/toy/plushie/corgi/ribbon			= MERCHANT_EXCLUDE_THIS_TYPE,
		/obj/item/sword/katana/toy					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/launcher/foam/crossbow		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sword/cult_toy					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/large/foam_gun				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/large/foam_gun/burst			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/large/foam_gun/revolver		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toy/bosunwhistle					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toy/blink							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/board								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/checkers						= MERCHANT_INCLUDE_ALL,
		/obj/item/deck								= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/pack								= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/dice								= MERCHANT_INCLUDE_ALL,
		/obj/item/gun/launcher/money				= MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/toy_shop_demand
	type_instructions = list(
		/obj/item/toy/figure		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toy/figure/ert	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/toy/prize/honk	= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/toy_shop
	hailed = "Uhh... hello? Welcome to "+MERCHANT_TOKEN_ORIGIN+", I hope you have a, uhh.... good shopping trip."
	denied_hail = "Nah, you're not allowed here. At all."
	trade_complete = "Thanks for shopping... here... at "+MERCHANT_TOKEN_ORIGIN+"."
	forbidden_offer = "Uuuhhh.... no."
	found_unwanted = "Nah! That's not what I'm looking for. Something rarer."
	not_enough_value = "Just 'cause they're made of cardboard doesn't mean they don't cost money..."
	how_much = "Uhh... I'm thinking like... "+MERCHANT_TOKEN_VALUE+". Right? Or something rare that complements my interest."
	what_wanted_beginning = "Ummmm..... I guess I want"
	compliment_failure = "Ha! Very funny! You should write your own television show."
	compliment_success = "Why yes, I do work out."
	insult_high_opinion = "Well, well, well. Guess we learned who was the troll here."
	insult_low_opinion = "I've already written a nasty Spacebook post in my mind about you."
	bribe_failure = "Nah. I need to get moving as soon as uhh... possible."
	bribe_success = "You know what, I wasn't doing anything for "+MERCHANT_TOKEN_TIME+" minutes anyways."
	leaving_soon = "I'm planning to stay for another "+MERCHANT_TOKEN_TIME+" minutes."