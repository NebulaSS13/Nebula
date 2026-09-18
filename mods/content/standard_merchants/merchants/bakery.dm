/// A bakery that sells baked goods, such as cakes and pies.
/// Like most other retail-themed merchants, the price is static for everyone.
/datum/merchant/bakery
	name = "Pastry Chef"
	origin = "Bakery"
	possible_origins = list(
		"Cakes By Design",
		"Corner Bakery Local",
		"My Favorite Cake & Pastry Cafe",
		"Mama Joes Bakery",
		"Sprinkles and Fun",
		"Cakestrosity"
	)
	supply_potential = list(/decl/merchant_potential_commodities/bakery)
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 1.2
	)
	speech = /decl/merchant_speech/bakery
	refuse_haggling = TRUE


/decl/merchant_potential_commodities/bakery
	type_instructions = list(
		/obj/item/food/slice/birthdaycake/filled	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/carrotcake/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/cheesecake/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/chocolatecake/filled	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/lemoncake/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/limecake/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/orangecake/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/plaincake/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/pumpkinpie/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/slice/bananabread/filled		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/sliceable					= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/food/sliceable/pizza				= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/sliceable/xenomeatbread		= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/sliceable/unleaveneddough	= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/sliceable/flatdough			= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/sliceable/braincake			= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/dough						= MERCHANT_EXCLUDE_ALL,
		/obj/item/food/bananapie					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/applepie						= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/bakery
	hailed = "Hello, welcome to "+MERCHANT_TOKEN_ORIGIN+"! We serve baked goods, including pies, cakes, and anything sweet!"
	denied_hail = "Our food is a privilege, not a right. Goodbye."
	trade_complete = "Thank you for your purchase! Come again if you're hungry for more!"
	forbidden_offer = "We only accept money. Not... that."
	goods_not_accepted = "Cash for cakes! That's our business!"
	not_enough_value = "Our dishes are much more expensive than that, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"."
	how_much = "That lovely dish will cost you "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	compliment_failure = "Oh wow, how nice of you..."
	compliment_success = "You're almost as sweet as my pies!"
	insult_high_opinion = "My pies are NOT knockoffs!"
	insult_low_opinion = "Well, aren't you a sour apple?"
	bribe_failure = "Oh ho ho! I'd never think of taking "+MERCHANT_TOKEN_ORIGIN+" on the road!"
	staying_put = "Oh ho ho! I'd never think of taking "+MERCHANT_TOKEN_ORIGIN+" on the road!"