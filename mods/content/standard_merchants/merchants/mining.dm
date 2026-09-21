/// An AI-managed smelting platform which buys ores and sells some material sheets and mining supplies.
/// Like other AI-themed merchants, they have a higher than average skill level, yet they do not change their prices based on disposition, and can't really get annoyed.
/datum/merchant/mining
	name = "Rock'n'Drill Mining Inc"
	origin = "Automated Smelter AH-532"
	possible_origins = list(
		"Automated Smelter AH-532",
		"CMV Locust",
		"The Galactic Foundry Company",
		"Crucible LLC",
		"Stoney Rock"
	)
	merchant_languages = list(
		/decl/language/human/common,
		/decl/language/machine,
		/decl/language/binary
	)
	refuse_anonymous_comms = TRUE
	accepts_money_as_payment = TRUE
	accepts_goods_as_payment = TRUE
	positive_disposition_multiplier = 0
	negative_disposition_multiplier = 0
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 2.0,
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 2.0
	)
	demand_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 1.5,
		/decl/merchant_price_modifier/legacy_skill_disparity/demand = 1.5
	)
	skill_level = SKILL_PROF
	speech = /decl/merchant_speech/mining_store
	supply_potential = list(/decl/merchant_potential_commodities/mining_store_supply)
	demand_potential = list(
		/decl/merchant_potential_commodities/mining_store_demand,
		/decl/merchant_potential_commodities/materials/all_mineable_ores
	)

/decl/merchant_potential_commodities/mining_store_supply
	type_instructions = list(
		/obj/machinery/mining_drill										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/structure/drill_brace										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/machinery/floodlight										= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/greenglowsticks									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/space/void/engineering/salvage/prepared = MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/puck/mapped/uranium/ten				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/fifty	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/sheet/mapped/steel/fifty				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/copper/fifty				= MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/mining_store_demand
	type_instructions = list(/obj/item/disk/survey = MERCHANT_INCLUDE_THIS_TYPE)

/decl/merchant_speech/mining_store
	hailed = "Welcome to R'n'D Mining. Please place your order."
	denied_hail = "There is no response on the line."
	no_anonymous = "Sorry, it is illegal to do business without knowing our customers."
	trade_complete = "Transaction complete. Please use our services again."
	forbidden_offer = "Whoa whoa, I don't want this shit, put it away."
	found_unwanted = "Sorry, we are currently not looking to purchase these items."
	not_enough_value = "Sorry, this is an insufficient sum for this purchase."
	how_much = "For ONE entry of "+MERCHANT_TOKEN_ITEM+" the price would be "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	what_wanted_beginning = "We are currently looking to procure"
	compliment_failure = "I am afraid this is beyond my competency."
	compliment_success = "Thank you."
	insult_high_opinion = "Alright, we will reconsider the terms."
	insult_low_opinion = "This is not acceptable, please cease."
	bribe_failure = "That is unnecessary."
	staying_put = "This facility is not mobile."