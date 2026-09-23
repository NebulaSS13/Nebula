/// A chinese restaurant, in space.
/datum/merchant/transient/chinese_restaurant
	name = "Chinese Restaurant"
	possible_origins = list(
		"888 Shanghai Kitchen",
		"Mr. Lee's Greater Hong Kong",
		"The House of the Venerable and Inscrutable Colonel",
		"Lucky Dragon",
		"Captain Panda Bistro"
	)
	supply_potential = list(/decl/merchant_potential_commodities/chinese_restaurant)
	speech = /decl/merchant_speech/chinese_restauarant
	refuse_haggling = TRUE

	var/static/list/fortunes = list(
		"Today it's up to you to create the peacefulness you long for.",
		"If you refuse to accept anything but the best, you very often get it.",
		"A smile is your passport into the hearts of others.",
		"Hard work pays off in the future, laziness pays off now.",
		"Change can hurt, but it leads a path to something better.",
		"Hidden in a valley beside an open stream- This will be the type of place where you will find your dream.",
		"Never give up. You're not a failure if you don't give up.",
		"Love can last a lifetime, if you want it to.",
		"The love of your life is stepping into your planet this summer.",
		"Your ability for accomplishment will follow with success.",
		"Please help me, I'm trapped in a fortune cookie factory!"
	)

/datum/merchant/transient/chinese_restaurant/on_completed_transaction(mob/user, list/items, value, turf/location)
	. = ..()
	var/obj/item/food/fortunecookie/cookie = new(location)
	var/obj/item/paper/fortune_paper = new(cookie, null, pick(fortunes), "Fortune")
	cookie.trash = fortune_paper


/decl/merchant_potential_commodities/chinese_restaurant
	type_instructions = list(
		/obj/item/utensil/chopsticks					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/utensil/chopsticks/plastic			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/condiment/small/soysauce		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/condiment/capsaicin				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/chazuke							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/glass/bowl/mapped/curry/katsu	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/skewer/meat						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/boiledegg						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/boiledrice						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/ricepudding						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/food/stewedsoymeat					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/drinks/dry_ramen				= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/chinese_restauarant
	hailed = "There are two things constant in life, death and Chinese food. How may I help you?"
	denied_hail = "We do not take orders from rude customers."
	trade_complete = "Thank you, "+MERCHANT_TOKEN_PLAYER_HONORIFIC+", for your patronage."
	forbidden_offer = "No, that is very odd. Why would you trade that away?"
	goods_not_accepted = "I only accept money transfers."
	not_enough_value = "No, I am sorry, that is not possible. I need to make a living."
	how_much = "I give you "+MERCHANT_TOKEN_ITEM+" for "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+". No more, no less."
	compliment_failure = "That was an odd thing to say. You are very odd."
	compliment_success = "Good philosophy, see good in bad, I like."
	insult_high_opinion = "As a man said long ago, \"When anger rises, think of the consequences.\" Think on that."
	insult_low_opinion = "I do not need to take this from you."
	bribe_failure = "Hm... I'll think about it."
	bribe_success = "Oh yes! I think I'll stay a few more minutes, then."
	leaving_soon = "I think I will stay for "+MERCHANT_TOKEN_TIME+" more minutes."