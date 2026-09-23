/// A non-descript pizzaria that somehow is able to sell pizza to spacefarers for a modest price.
/// Like other retail-themed merchants, prices cannot be influenced.
/datum/merchant/pizzaria
	name = "Pizza Shop Employee"
	origin = "Pizzeria"
	possible_origins = list(
		"Papa Joseph's",
		"Pizza Ship",
		"Dominator Pizza",
		"Little Kaezars",
		"Pizza Planet",
		"Cheese Louise",
		"Little Taste o' Neo-Italy",
		"Vivii's Pizza"
	)
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 1.2
	)
	supply_potential = list(/decl/merchant_potential_commodities/pizzaria)
	speech = /decl/merchant_speech/pizzaria
	refuse_bribes = FALSE
	refuse_haggling = TRUE
	skill_level = SKILL_BASIC

/decl/merchant_potential_commodities/pizzaria
	type_instructions = list(
		/obj/item/food/sliceable/pizza					= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/chems/drinks/cans/cola				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/drinks/cans/space_mountain_wind	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/drinks/cans/space_up			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/drinks/cans/dr_gibb				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/drinks/cans/starkist			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/drinks/cans/lemon_lime			= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/pizzaria
	hailed = "Hello! Welcome to "+MERCHANT_TOKEN_ORIGIN+", may I take your order?"
	denied_hail = "Beeeep... I'm sorry, your connection has been severed."
	trade_complete = "Thank you for choosing "+MERCHANT_TOKEN_ORIGIN+"!"
	goods_not_accepted = "I'm sorry but we only take cash."
	forbidden_offer = MERCHANT_TOKEN_PLAYER_HONORIFIC+" that's... highly illegal."
	not_enough_value = "Uhh... that's not enough money for pizza."
	how_much = "That pizza will cost you "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	compliment_failure = "That's a bit forward, don't you think?"
	compliment_success = "Thanks, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"! You're very nice!"
	insult_high_opinion = "Please stop that, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+"."
	insult_low_opinion = MERCHANT_TOKEN_PLAYER_HONORIFIC+", just because I'm contractually obligated to keep you on the line \
	for a minute doesn't mean I have to take this."
	bribe_success = "Uh... thanks for the cash, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+". As long as you're in the area, we'll be here..."
	staying_put = "As long as you're in the area, we'll be here..."
