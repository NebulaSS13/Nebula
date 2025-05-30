/// A grocery store. In space, for reasons. They sell basic food and ingredients for cooking, such as eggs and milk.
/// Like other retail-themed merchants, their prices are static and they don't buy anything.
/datum/merchant/grocery
	name = "Grocer"
	possible_origins = list(
		"HyTee",
		"Kreugars",
		"Spaceway",
		"Privaxs",
		"FutureValue",
		"Phyvendyme",
		"Seller's Market"
	)
	refuse_haggling = TRUE
	refuse_bribes = FALSE
	skill_level = SKILL_BASIC
	supply_potential = list(/decl/merchant_potential_commodities/grocery)
	supply_price_modifiers = list(/decl/merchant_price_modifier/percentage = 1.2)


/decl/merchant_potential_commodities/grocery
	type_instructions = list(
		/obj/item/food						= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/food/processed_grown		= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/slice				= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/grown				= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/sliceable/braincake	= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/butchery/meat/human	= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/variable				= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/egg					= MERCHANT_EXCLUDE_SUBTYPES,
		/obj/item/chems/drinks/cans			= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/chems/drinks/bottle		= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/chems/drinks/bottle/small	= MERCHANT_EXCLUDE_ALL,
		/obj/item/box/fancy/donut			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/fancy/egg_box			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/fancy/crackers		= MERCHANT_INCLUDE_THIS_TYPE,
	)


/decl/merchant_speech/grocery
	hailed = "Hello, welcome to "+MERCHANT_TOKEN_ORIGIN+", grocery story of the future!"
	denied_hail = "I'm sorry, we've blacklisted your communications due to rude behavior."
	trade_complete = "Thank you for shopping at "+MERCHANT_TOKEN_ORIGIN+"!"
	forbidden_offer = "I... wow, that's... no, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+". No."
	goods_not_accepted = MERCHANT_TOKEN_ORIGIN+" only accepts cash, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"."
	not_enough_value = "That is not enough money, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"."
	how_much = MERCHANT_TOKEN_PLAYER_HONORIFIC+", that'll cost you "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+". Will that be all?"
	compliment_failure = MERCHANT_TOKEN_PLAYER_HONORIFIC+", this is a professional environment. Please don't make me get my manager."
	compliment_success = "Thank you, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"!"
	insult_high_opinion = MERCHANT_TOKEN_PLAYER_HONORIFIC+", please do not make a scene."
	insult_low_opinion = MERCHANT_TOKEN_PLAYER_HONORIFIC+", I WILL get my manager if you don't calm down."
	bribe_success = "Of course "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"! "+MERCHANT_TOKEN_ORIGIN+" is always here for you!"
	staying_put = MERCHANT_TOKEN_ORIGIN+" is always here for you!"