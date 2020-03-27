/datum/trader/ship/unique
	trade_flags = TRADER_WANTED_ONLY|TRADER_GOODS
	want_multiplier = 5
	typical_duration = 40

/datum/trader/ship/unique/New()
	..()
	wanted_items = list()
	for(var/type in possible_wanted_items)
		var/status = possible_wanted_items[type]
		if(status & TRADER_THIS_TYPE)
			wanted_items += type
		if(status & TRADER_SUBTYPES_ONLY)
			wanted_items += subtypesof(type)
		if(status & TRADER_BLACKLIST)
			wanted_items -= type
		if(status & TRADER_BLACKLIST_SUB)
			wanted_items -= subtypesof(type)

/datum/trader/ship/unique/tick()
	if(prob(-disposition) || refuse_comms)
		duration_of_stay--
	return --duration_of_stay > 0

/datum/trader/ship/unique/what_do_you_want()
	return get_response("what_want", "I don't want anything!")

/datum/trader/ship/unique/severance
	name = "Unknown"
	origin = "SGS Severance"

	possible_wanted_items = list(
							/obj/item/chems/food/snacks/human                      = TRADER_SUBTYPES_ONLY,
							/obj/item/chems/food/snacks/meat/human                 = TRADER_THIS_TYPE,
							/mob/living/carbon/human                                                   = TRADER_ALL
							)

	possible_trading_items = list(/obj/item/gun/projectile/automatic                            = TRADER_SUBTYPES_ONLY
							)

	blacklisted_trade_items = null

	speech = list("hail_generic"     = "H-hello. Can you hear me? G-good... I have... specific needs... I have a lot to t-trade with you in return of course.",
				"hail_deny"          = "--CONNECTION SEVERED--",

				"trade_complete"     = "Hahahahahahaha! Thankyouthankyouthankyou!",
				"trade_no_money"     = "I d-don't NEED cash.",
				"trade_not_enough"   = "N-no, no no no. M-more than that... more...",
				"trade_found_unwanted" = "I d-don't think you GET what I want, fr- from your offer.",
				"how_much"           = "Meat. I want meat. The kind they don't serve in the- the mess hall.",
				"what_want"          = "Long p-pork. Yes... that's what I want...",

				"compliment_deny"    = "Your lies won't ch-change what I did.",
				"compliment_accept"  = "Yes... I suppose you're right.",
				"insult_good"        = "I... probably deserve that.",
				"insult_bad"         = "Maybe you should c-come here and say that. You'd be worth s-something then.",
				)
	mob_transfer_message = "<span class='danger'>You are transported to ORIGIN, and with a sickening thud, you fall unconscious, never to wake again.</span>"


/datum/trader/ship/unique/rock
	name = "Bobo"
	origin = "Floating rock"

	possible_wanted_items  = list(/obj/item/ore                        = TRADER_ALL)
	possible_trading_items = list(/obj/machinery/power/supermatter            = TRADER_ALL,
								/obj/item/aiModule                     = TRADER_SUBTYPES_ONLY)
	want_multiplier = 5000

	speech = list("hail_generic"     = "Blub am MERCHANT. Blub hunger for things. Boo bring them to blub, yes?",
				"hail_deny"          = "Blub does not want to speak to boo.",

				"trade_complete"     = "Blub likes to trade!",
				"trade_no_money"     = "Boo try to give Blub paper. Blub does not want paper.",
				"trade_not_enough"   = "Blub hungry for bore than that.",
				"trade_found_unwanted" = "Blub only wants bocks. Give bocks.",
				"trade_refuse"       = "No, Blub will not do that. Blub wants bocks, yes? Give bocks.",
				"how_much"           = "Blub wants bocks. Boo give bocks. Blub gives stuff blub found.",
				"what_want"          = "Blub wants bocks. Big bocks, small bocks. Shiny bocks!",

				"compliment_deny"    = "Blub is just MERCHANT. What do boo mean?",
				"compliment_accept"  = "Boo are a bood berson!",
				"insult_good"        = "Blub do not understand. Blub thought we were briends.",
				"insult_bad"         = "Blub feels bad now.",
				)
