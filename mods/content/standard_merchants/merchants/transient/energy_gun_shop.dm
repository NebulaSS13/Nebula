/// A merchant who sells some high tech weapons, and batteries, for some reason.
/datum/merchant/transient/energy_gun_shop
	name = "Energy Gun Shop Employee"
	origin = "EGun Shop"
	possible_origins = list(
		"The Emperor's Lasgun Shop",
		"Future Guns",
		"Solar Army",
		"Kiefer's Dependable Electric Arms",
		"Olympus Kingsport"
	)
	refuse_anonymous_comms = TRUE
	supply_potential = list(/decl/merchant_potential_commodities/energy_gun_shop)
	speech = /decl/merchant_speech/energy_gun_shop


/decl/merchant_potential_commodities/energy_gun_shop
	type_instructions = list(
		/obj/item/gun/energy/taser					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/xray					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/laser					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/gun					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/crap							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/high							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/super						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cell/hyper						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/webbing/holster			= MERCHANT_INCLUDE_ALL
	)


/decl/merchant_speech/energy_gun_shop
	hailed = "Welcome to the future of warfare! "+MERCHANT_TOKEN_ORIGIN+", your one-stop shop for energy weaponry!"
	denied_hail = "I'm sorry, your communication channel has been blacklisted."
	no_anonymous = "I'm sorry, but we require your name for marketing and analytics."
	trade_complete = "Thank you, your purchase has been logged and you have automatically liked our Spacebook page."
	forbidden_offer = "I'm sorry, is that a joke?"
	goods_not_accepted = "We deal in cash."
	not_enough_value = "State of the art weaponry costs more than that."
	how_much = "All our quality weapons are priceless, but I'd give that to you for "+MERCHANT_TOKEN_VALUE+"."
	compliment_failure = "If I was dumber I probably would have believed you."
	compliment_success = "Yes, I am very smart."
	insult_high_opinion = "Energy weapons are TWICE the gun kinetic guns are!"
	insult_low_opinion = "That's... very mean. I won't think twice about blacklisting your channel, so stop."
	bribe_success = "Look, I'm not supposed to, but I guess I can stay for "+MERCHANT_TOKEN_TIME+" minutes."
	bribe_failure = "Sorry, no can do. I'm on a tight schedule."
	leaving_soon = "I can stay for "+MERCHANT_TOKEN_TIME+" minutes."
