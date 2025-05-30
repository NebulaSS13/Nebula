/datum/merchant/transient/rare/rock
	name = "Bobo"
	origin = "Floating rock"
	speech = /decl/merchant_speech/rock
	demand_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 5000,
		/decl/merchant_price_modifier/disposition = 1.2,
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 5000
	)
	will_pay_with_money = FALSE
	supply_potential = list(/decl/merchant_potential_commodities/bobo_supply)
	demand_potential = list(/decl/merchant_potential_commodities/material_stacks/all_mineable_ores)


/decl/merchant_potential_commodities/bobo_supply
	type_instructions = list(
		/obj/item/aiModule	= MERCHANT_INCLUDE_SUBTYPES
	)


/decl/merchant_speech/rock
	hailed = "Blub am "+MERCHANT_TOKEN_MERCHANT_NAME+". Blub hunger for things. Boo bring them to blub, yes?"
	denied_hail = "Blub does not want to speak to boo."
	trade_complete = "Blub likes to trade!"
	money_not_accepted = "Boo try to give Blub paper. Blub does not want paper."
	not_enough_value = "Blub hungry for bore than that."
	forbidden_offer = "Blub not want that! No!"
	found_unwanted = "Blub only wants bocks. Give bocks."
	how_much = "Blub wants bocks. Boo give bocks. Blub gives stuff blub found."
	what_wanted_beginning = "Blub wants bocks. Big bocks, small bocks. Shiny bocks!"
	compliment_failure = "Blub is just "+MERCHANT_TOKEN_MERCHANT_NAME+". What do boo mean?"
	compliment_success = "Boo are a bood berson!"
	insult_high_opinion = "Blub do not understand. Blub thought we were briends."
	insult_low_opinion = "Blub feels bad now."
	bribe_success = "Blub will stay for "+MERCHANT_TOKEN_TIME+" binutes bonger."
	bribe_failure = "Blub must go. Blub's beople beed blem."
	leaving_soon = "Blub will stay for "+MERCHANT_TOKEN_TIME+" binutes bonger."
