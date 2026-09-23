/// A merchant who seeks to collect alien lifeforms, and is willing to sell the supplies used to capture them.
/// They also might sell surplus space carp. The fish are untamed, so beware.
/// Any potential creatures that they ask for must be brought back alive.
/datum/merchant/xeno_shop
	name = "Xenolife Collector"
	origin = "CSV Not a Poacher"
	possible_origins = list(
		"XenoHugs",
		"Exotic Specimen Acquisition",
		"Skinner Catering Reseller",
		"Corporate Companionship Division",
		"Lonely Pete's Exotic Companionship",
		"Delicious Exotic Cuisine"
	)
	speech = /decl/merchant_speech/xeno_shop
	accepts_money_as_payment = TRUE
	accepts_goods_as_payment = TRUE
	refuse_bribes = FALSE
	supply_potential = list(/decl/merchant_potential_commodities/xeno_shop_supply)
	demand_potential = list(/decl/merchant_potential_commodities/xeno_shop_demand)


/decl/merchant_potential_commodities/xeno_shop_supply
	type_instructions = list(
		/mob/living/simple_animal/hostile/carp	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/dociler						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/beartrap						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scanner/xenobio				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/stasis_cage				= MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/xeno_shop_demand
	type_instructions = list(
		/mob/living/simple_animal/tindalos				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/tomato				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/yithian				= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/diyaab	= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/shantak	= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/samak	= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/carp 			= MERCHANT_INCLUDE_THIS_TYPE
	)
	extra_requirements = list(/decl/merchant_commodity_requirement/mobs/is_alive = TRUE)


/decl/merchant_speech/xeno_shop
	hailed = "Welcome! We are always looking to acquire more exotic life forms."
	denied_hail = "We no longer wish to speak to you. Please contact our legal representative if you wish to rectify this."
	trade_complete = "Remember to give them attention and food. They are living beings, and you should treat them like so."
	forbidden_offer = "Legally I can't do that. Morally... well, I refuse to do that."
	found_unwanted = "I only want animals. I don't need food or shiny things. I'm looking for specific ones, \
	at that. Ones I already have the cage and food for."
	not_enough_value = "I'd give you this for free, but I need the money to feed the specimens. So you must pay in full."
	how_much = "This is a good choice. I believe it will cost you "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	what_wanted_beginning = "I have the facilities, currently, to support"
	compliment_failure = "According to customs on 34 planets I traded with, this constitutes sexual harassment."
	compliment_success = "Thank you. I needed that."
	insult_high_opinion = "No need to be upset, I believe we can do business."
	insult_low_opinion = "I have traded dogs with more bark than that."
	bribe_success = "I'll accept your donation. It'll go towards feeding the specimens."
	staying_put = "Uh, this is a station. I'm not going anywhere."