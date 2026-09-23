/// A traveling merchant who purchases dead fish, both from the water and space, and sells fishing supplies.
/// Some of the corpses of space carp that attacked earlier can become cash, thanks for this merchant.
/datum/merchant/transient/fishmonger
	name = "Fishmonger"
	possible_origins = list(
		"Astral Aquaculture",
		"Bounty of the Sea"
	)
	refuse_bribes = FALSE
	skill_level = SKILL_ADEPT
	speech = /decl/merchant_speech/fishmonger
	supply_potential = list(/decl/merchant_potential_commodities/fishmonger_supply)
	demand_potential = list(/decl/merchant_potential_commodities/fishmonger_demand)
	starting_cash_lower_bound = 700
	starting_cash_upper_bound = 1500


/decl/merchant_potential_commodities/fishmonger_supply
	type_instructions = list(
		/obj/item/food/butchery/meat/fish		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/mollusc						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/mollusc/barnacle/fished		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/mollusc/clam/fished/pearl		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/fishing_rod					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/fishing_rod/advanced			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/fishing_line					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/fishing_line/high_quality		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/worm						= MERCHANT_INCLUDE_THIS_TYPE
	)
	item_quantity_upper_bound = 10

/decl/merchant_potential_commodities/fishmonger_demand
	type_instructions = list(
		/mob/living/simple_animal/aquatic/fish			= MERCHANT_INCLUDE_ALL,
		/mob/living/simple_animal/hostile/carp			= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/carp/pike		= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/simple_animal/hostile/carp/shark	= MERCHANT_INCLUDE_THIS_TYPE
	)
	extra_requirements = list(/decl/merchant_commodity_requirement/mobs/is_alive = FALSE)
	item_quantity_upper_bound = 5


/decl/merchant_speech/fishmonger
	hailed = "Hey there! I got fresh fillets, ready to be cooked. I'll also buy some freshly caught fish you might have, whether they come from the water, or space."
	denied_hail = "I hope you'll be sleeping with the fishes soon."
	trade_complete = "Thanks."
	forbidden_offer = "That doesn't look like a fish to me..."
	found_unwanted = "I only want fish. Dead ones, too."
	goods_not_accepted = "Cash only."
	not_enough_value = "Gonna need more than that."
	how_much = "I'll sell you a "+MERCHANT_TOKEN_ITEM+" for "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	what_wanted_beginning = "Today I'll buy"
	what_wanted_ending = " from you."
	no_more_wanted = "I'm already packed to the gills with "+MERCHANT_TOKEN_ITEM+"." // I'm not sorry.
	too_many_items = "I only need "+MERCHANT_TOKEN_QUANTITY+" "+MERCHANT_TOKEN_ITEM+". Any more would just be a waste."
	compliment_failure = "Think you floundered on that one."
	compliment_success = "Now you're just acting koi."
	insult_high_opinion = "What the hell was that for?"
	insult_low_opinion = "If I could slap you with a fish right now, I would."
	bribe_success = "I guess I can stay for another "+MERCHANT_TOKEN_TIME+" minutes."
	bribe_failure = "Thanks, but I'll pass."
	leaving_soon = "Fresh fish doesn't exactly have a long shelf life, so I gotta move on in "+MERCHANT_TOKEN_TIME+" minutes."
