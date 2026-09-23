/// A rare merchant who trades rifles for 'long pork'.
/datum/merchant/transient/rare/severance
	name = "Unknown"
	origin = "SGS Severance"
	accepts_money_as_payment = FALSE
	accepts_goods_as_payment = TRUE
	demand_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 5.0,
		/decl/merchant_price_modifier/disposition = 1.2,
		/decl/merchant_price_modifier/legacy_skill_disparity/demand = 5.0
	)
	will_pay_with_money = FALSE
	speech = /decl/merchant_speech/severance
	supply_potential = list(/decl/merchant_potential_commodities/severance_rifles)
	demand_potential = list(
		/decl/merchant_potential_commodities/severance_meat,
		/decl/merchant_potential_commodities/severance_humanoids
	)
	forbidden_objects = list()


/decl/merchant_potential_commodities/severance_rifles
	type_instructions = list(
		/obj/item/gun/projectile/automatic/smg				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/automatic/assault_rifle	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/automatic/machine			= MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/severance_meat
	type_instructions = list(/obj/item/food/butchery/meat/human = MERCHANT_INCLUDE_THIS_TYPE)

/decl/merchant_potential_commodities/severance_humanoids
	item_quantity_lower_bound = 1
	item_quantity_upper_bound = 2

/decl/merchant_potential_commodities/severance_humanoids/create_datums()
	. = list()
	var/list/all_species = decls_repository.get_decls_of_subtype_unassociated(/decl/species)
	var/list/wanted_species = list()

	// In the interest of not wanting to make a compatibility patch for every optional species on Neb to add them to this merchant,
	// we're gonna iterate every species and try to exclude potential future weird species that might be seen as undesirable for the merchant to want to eat.
	for(var/decl/species/species as anything in all_species)
		if(species.hidden_from_codex)
			continue // Exclude secret species.

		if(!ispath(species.butchery_data, /decl/butchery_data/humanoid))
			continue // Exclude species which might not be butcherable.

		var/probably_edible = FALSE
		for(var/decl/bodytype/bodytype as anything in species.available_bodytypes)
			if(!ispath(bodytype.organ_material, /decl/material/solid/organic))
				continue // Exclude things made of stuff like crystal or metal.

			// Could add a way to determine if whether a particular species might be poisonous to eat by humans but that might be tricky with just some species/bodytype decls,
			// plus the merchant might not be privy to that information, and it might be too much effort for a rare gimmicky merchant.
			probably_edible = TRUE

		if(!probably_edible)
			continue

		wanted_species += species.type

	for(var/type_path in wanted_species)
		. += new /datum/merchant_commodity(list(/decl/merchant_commodity_requirement/mobs/species = list(type_path)), _item_quantity = assign_quantity())


/decl/merchant_speech/severance
	hailed = "H-hello. Can you hear me? G-good... I have... specific needs... I have a lot to t-trade \
	with you in return of course."
	denied_hail = "--CONNECTION SEVERED--"
	trade_complete = "Hahahahahahaha! Thankyouthankyouthankyou!"
	money_not_accepted = "I d-don't NEED cash."
	not_enough_value = "N-no, no no no. M-more than that... more..."
	found_unwanted = "I d-don't think you GET what I want, fr- from your offer."
	how_much = "Meat. I want meat. The kind they don't serve in the- the mess hall."
	what_wanted_beginning = "Long p-pork. Yes... that's what I want..."
	compliment_failure = "Your lies won't ch-change what I did."
	compliment_success = "Yes... I suppose you're right."
	insult_high_opinion = "I... probably deserve that."
	insult_low_opinion = "Maybe you should c-come here and say that. You'd be worth s-something then."
	bribe_success = "Okay. Fine. But... h-hurry. I can only stay another "+MERCHANT_TOKEN_TIME+" m-minutes."
	bribe_failure = "No! N-no, they're getting closer- I have to, I h-have to go soon."
	leaving_soon = "I can only stay another "+MERCHANT_TOKEN_TIME+" m-minutes."
	appraise_offer = "Y-Yes. I want this..."
	mob_transfer_message = "You are transported to "+MERCHANT_TOKEN_ORIGIN+", and with a sickening thud, \
	you fall unconscious, never to wake again."
