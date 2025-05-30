/// A ship that suffered an unspecified incident and is willing to buy supplies, mainly engineering related, but also some medication.
/datum/merchant/transient/damaged_ship
	origin = "Damaged Ship"
	name_background = /decl/background_detail/heritage/human

	skill_level = SKILL_BASIC
	refuse_bribes = FALSE
	accepts_goods_as_payment = TRUE
	supply_potential = list(

	)
	demand_potential = list(
		/decl/merchant_potential_commodities/material_stacks/damaged_ship_basic_supplies,
		/decl/merchant_potential_commodities/material_stacks/damaged_ship_adv_supplies,
		/decl/merchant_potential_commodities/reagents/damaged_ship_medications,
		/decl/merchant_potential_commodities/gases/damaged_ship_gases
	)
	bribe_disposition_divisor = 15
	starting_cash_lower_bound = 500
	starting_cash_upper_bound = 700
	speech = /decl/merchant_speech/damaged_ship


/decl/merchant_potential_commodities/material_stacks/damaged_ship_basic_supplies
	type_instructions = list(
		/decl/material/solid/metal/steel		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/glass				= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/organic/plastic	= MERCHANT_INCLUDE_THIS_TYPE
	)
	stack_types = list(/obj/item/stack/material/sheet)
	item_quantity_lower_bound = 50
	item_quantity_upper_bound = 200

/decl/merchant_potential_commodities/material_stacks/damaged_ship_adv_supplies
	type_instructions = list(
		/decl/material/solid/metal/plasteel		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/glass/borosilicate	= MERCHANT_INCLUDE_THIS_TYPE
	)
	stack_types = list(/obj/item/stack/material/sheet)
	item_quantity_lower_bound = 15
	item_quantity_upper_bound = 30

/decl/merchant_potential_commodities/reagents/damaged_ship_medications
	type_instructions = list(
		/decl/material/liquid/antirads		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/burn_meds		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/antitoxins	= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/oxy_meds		= MERCHANT_INCLUDE_THIS_TYPE
	)
	item_quantity_lower_bound = 30
	item_quantity_upper_bound = 60

/decl/merchant_potential_commodities/gases/damaged_ship_gases
	type_instructions = list(
		/decl/material/gas/oxygen		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/gas/nitrogen		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/gas/hydrogen		= MERCHANT_INCLUDE_THIS_TYPE
	)
	gas_mixes = list(
		list(
			/decl/material/gas/oxygen	= O2STANDARD,
			/decl/material/gas/nitrogen	= N2STANDARD
			)
	)
	item_quantity_lower_bound = 800
	item_quantity_upper_bound = 2500


/decl/merchant_speech/damaged_ship
	hailed = "Hello? Thank goodness you're here. Our vessel had an... incident, and we're limping back to port. We're not in immediate danger, \
	but we lost some of our supplies. If you got any spares, we'll gladly buy them off of you."
	denied_hail = "Even with a hole in the hull, you're not worth talking to."
	trade_complete = "Thank you, this will help a lot."
	forbidden_offer = "No way!"
	found_unwanted = "That's not gonna help us, sorry."
	not_enough_value = "I don't think that would be a fair trade."
	how_much = "I can sell you a spare "+MERCHANT_TOKEN_ITEM+" for "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	what_wanted_beginning = "We could use"
	what_wanted_ending = " to recover from the incident."
	no_more_wanted = "We don't need more "+MERCHANT_TOKEN_ITEM+"."
	too_many_items = "We only need "+MERCHANT_TOKEN_QUANTITY+" "+MERCHANT_TOKEN_ITEM+" to fix up the vessel."
	compliment_failure = "I got bigger problems on my mind, sorry."
	compliment_success = "You're too kind."
	insult_high_opinion = "I swear it wasn't my fault!"
	insult_low_opinion = "It should be illegal to say that to someone in distress."
	bribe_success = "I guess we could buy supplies with that. Thanks, I guess."
	leaving_soon = "We expect to drift out of range in about "+MERCHANT_TOKEN_TIME+" minutes."

/decl/merchant_speech/damaged_ship/fixed
	leaving_soon = "We'll be on our way within "+MERCHANT_TOKEN_TIME+" minutes."

