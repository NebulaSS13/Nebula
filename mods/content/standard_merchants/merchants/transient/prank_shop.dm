/// A very calm merchant who sells things that clowns would enjoy, if they still existed.
/datum/merchant/transient/prank_shop
	name = "Prank Shop Owner"
	origin = "Prank Shop"
	name_background = /decl/background_detail/heritage/human
	positive_disposition_multiplier = 0
	negative_disposition_multiplier = 0
	possible_origins = list(
		"Yacks and Yucks Shop",
		"The Shop From Which I Sell Humorous Items",
		"The Prank Gestalt",
		"The Clown's Armory",
		"Uncle Knuckle's Chuckle Bunker",
		"A Place from Which to do Humorous Business"
	)
	supply_potential = list(/decl/merchant_potential_commodities/prank_shop)
	speech = /decl/merchant_speech/prank_shop


/decl/merchant_potential_commodities/prank_shop
	type_instructions = list(
		/obj/item/clothing/mask/gas/clown_hat		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/mask/gas/mime			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shoes/clown_shoes		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/costume/clown			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stamp/clown						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/backpack/clown					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bananapeel						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/launcher/money				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/bananapie					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bikehorn							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bikehorn/airhorn					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/megaphone							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/spray/waterflower			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/launcher/pneumatic/small		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/revolver/capgun	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/mask/fakemoustache		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/flashlight/party					= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/prank_shop
	hailed = "We welcome you to our shop of humorous items. We invite you to partake in the divine experience \
	of being pranked, and pranking someone else."
	denied_hail = "We cannot do business with you. We are sorry."
	trade_complete = "We thank you for purchasing something. We enjoyed the experience of you doing so and we \
	hope to learn from it."
	forbidden_offer = "We are not allowed to trade for these goods. We are sorry."
	goods_not_accepted = "We are not allowed to trade for these goods. We are sorry."
	not_enough_value = "We have sufficiently experienced giving away goods for free. We wish to experience \
	getting money in return."
	how_much = "We believe that is worth "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	what_wanted_beginning = "We wish only for the experiences you give us, in all else we want"
	compliment_failure = "You are attempting to compliment us."
	compliment_success = "You are attempting to compliment us."
	insult_high_opinion = "You are attempting to insult us, correct?"
	insult_low_opinion = "We do not understand."
	bribe_failure = "We are sorry, but we cannot accept."
	bribe_success = "We are happy to say that we accept this bribe."
	leaving_soon = "We are allowed to stay for another "+MERCHANT_TOKEN_TIME+" minutes."