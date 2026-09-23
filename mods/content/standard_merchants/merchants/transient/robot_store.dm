/// A traveling merchant who sells basic robotics.
/datum/merchant/transient/robot_seller
	name = "Robot Seller"
	origin = "Robot Store"
	possible_origins = list(
		"Mechanical Buddies",
		"Bot Chop Shop",
		"Omni Consumer Projects"
	)
	supply_potential = list(/decl/merchant_potential_commodities/robot_store)
	speech = /decl/merchant_speech/robot_store


/decl/merchant_potential_commodities/robot_store
	type_instructions = list(
		/obj/item/bot_kit					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/paicard					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/aicard					= MERCHANT_INCLUDE_THIS_TYPE,
		/mob/living/bot						= MERCHANT_INCLUDE_SUBTYPES,
		/mob/living/bot/floorbot/premade	= MERCHANT_EXCLUDE_ALL,
		/mob/living/bot/farmbot/premade		= MERCHANT_EXCLUDE_ALL,
		/mob/living/bot/secbot/beepsky		= MERCHANT_EXCLUDE_ALL
	)


/decl/merchant_speech/robot_store
	hailed = "Welcome to "+MERCHANT_TOKEN_ORIGIN+"! Let me walk you through our fine robotic selection!"
	hailed_by_synth = "Welcome to "+MERCHANT_TOKEN_ORIGIN+"! Let- oh, you're a synth! \
	Well, your money is good anyway. Welcome, welcome!"
	denied_hail = MERCHANT_TOKEN_ORIGIN+" no longer wants to speak to you."
	trade_complete = "I hope you enjoy your new robot!"
	forbidden_offer = "I work with robots, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+". Not that."
	goods_not_accepted = "You gotta buy the robots, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+". I don't do trades."
	not_enough_value = "You're coming up short on cash."
	how_much = "My fine selection of robots will cost you "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"!"
	compliment_failure = "Well, I almost believed that."
	compliment_success = "Thank you! My craftsmanship is my life."
	insult_high_opinion = "Uncalled for.... uncalled for."
	insult_low_opinion = "I've programmed AI better at insulting than you!"
	bribe_failure = "I've got too many customers waiting in other sectors, sorry."
	bribe_success = "Hm. Don't keep me waiting too long, though."
	leaving_soon = "I can stay for another "+MERCHANT_TOKEN_TIME+" minutes."
