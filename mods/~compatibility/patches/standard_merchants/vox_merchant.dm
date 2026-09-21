/// A cheeky Vox merchant who sells mostly junk, in exchange for shiny things. They don't want cash.
/datum/merchant/transient/vox
	origin = "UNREGISTERED VESSEL"
	name_background = /decl/background_detail/heritage/vox
	merchant_languages = list(
		/decl/language/vox,
		/decl/language/human/common
	)
	positive_disposition_multiplier = 0
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 2.0,
		/decl/merchant_price_modifier/disposition = 0.8,
		/decl/merchant_price_modifier/percentage/vox = 2.0,
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 2.0
	)
	accepts_goods_as_payment = TRUE
	accepts_money_as_payment = FALSE
	speech = /decl/merchant_speech/vox
	supply_potential = list(/decl/merchant_potential_commodities/vox_supply)
	demand_potential = list(
		/decl/merchant_potential_commodities/vox_merchant_organs,
		/decl/merchant_potential_commodities/materials/vox_merchant_shinies
	)
	var/has_met_another_vox = FALSE

/datum/merchant/transient/vox/pre_hail(mob/user)
	var/decl/species/species = user.get_species()
	if(species?.uid == /decl/species/vox::uid && !has_met_another_vox)
		has_met_another_vox = TRUE
		supply_price_modifiers -= /decl/merchant_price_modifier/percentage/vox
		speech = /decl/merchant_speech/vox/fellow_vox
	..()

/datum/merchant/transient/vox/default_disposition(mob/user)
	if(!isliving(user))
		return ..()

	var/decl/species/species = user.get_species()
	if(species?.uid == /decl/species/vox::uid)
		return MAX_DISPOSITION_THRESHOLD
	return ..()


/decl/merchant_potential_commodities/vox_supply
	type_instructions = list(
		/obj/item/gun/projectile/dartgun/vox		= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/trash								= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/remains							= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/armor_attachment/plate	= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/webbing					= MERCHANT_INCLUDE_ALL,
		/obj/item/clothing/sensor					= MERCHANT_INCLUDE_ALL,
		/obj/item/robot_parts						= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/robot_parts/robot_component		= MERCHANT_EXCLUDE_ALL
	)

/decl/merchant_potential_commodities/vox_merchant_organs
	type_instructions = list(
		/obj/item/organ/internal/appendix = MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/brain = MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/eyes = MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/heart = MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/kidneys = MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/liver = MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/stomach = MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/materials/vox_merchant_shinies
	type_instructions = list(
		/decl/material/solid/metal/steel		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/uranium		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/gold			= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/silver		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/plasteel		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/titanium		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/copper		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/iron			= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/metal/lead			= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/solid/gemstone/diamond	= MERCHANT_INCLUDE_THIS_TYPE
	)
	instance_types = list(/obj/item/stack/material)


/decl/merchant_speech/vox
	hailed = "SKREEE! We will trade good stuff, yes?"
	hailed_by_synth = "Hello metal thing! You trade metal for things?"
	hailed_by_species = list(/decl/species/human::uid = "Hello hueman! Kiikikikiki! "+MERCHANT_TOKEN_PLAYER_NAME+" trade with us, yes? Good!")
	denied_hail = "Trade closed, GO AWAY!"
	no_common_language = "Speak real words!"
	trade_complete = "Yes, kikikikikiki! You will not regret this trade!"
	money_not_accepted = "Money? It does not need money. GOODS! Give it GOODS!"
	not_enough_value = "It wants MORE for that. Give it more."
	how_much = "You give it something worth VALUE, yes?"
	what_wanted_beginning  = "It wants"
	compliment_failure = "No."
	compliment_success = "Kikikikiki! Trade is better than talk, yes?"
	insult_high_opinion = "Bah! Why does it have to deal with you?"
	insult_low_opinion = "All you meat is the same! Fuck the off!"
	bribe_success = "Skhhhhhk... fine. "+MERCHANT_TOKEN_TIME+" minutes, no more!"
	bribe_failure = "No! It is getting impatient with this meat!"
	leaving_soon = MERCHANT_TOKEN_TIME+" minutes, no more!"
	mob_transfer_message = "You are transported to "+MERCHANT_TOKEN_ORIGIN+". When the transportation dizziness wears off, you find you are surrounded by cackling vox..."

/// Vox merchant switches to this when hailed by another Vox.
/decl/merchant_speech/vox/fellow_vox
	hailed = "SKREEEEE! You friend of the Shoal? You trade with, yes?"
	hailed_by_synth = "YOU KNOW THE SHOAL? Yes is good, yes yes, "+MERCHANT_TOKEN_PLAYER_NAME+". Trade GOOD!"
	hailed_by_species = list(
		/decl/species/human::uid = "Friend of it is friend of all Shoal! "+MERCHANT_TOKEN_PLAYER_NAME+" you trade now!",
		/decl/species/vox::uid = "SKREEEE! May the Shoal make this trade good, "+MERCHANT_TOKEN_PLAYER_NAME+"!"
	)
	denied_hail = "Trade gone now. Goodbye."
	no_common_language = "Speak real words!"
	trade_complete = "Yes... this is a good trade for the Shoal!"
	money_not_accepted = "You know as well as it that money is no good."
	not_enough_value = "Ech, you insult it with such a trade? Respect it, make it equal."
	how_much = "Hmm.... "+MERCHANT_TOKEN_VALUE+". Something like that."
	what_wanted_beginning = "We need"
	compliment_failure = "You know better than that!"
	compliment_success = "You butter it up? Should know better than that."
	insult_high_opinion = "Where this come from? Is trade no good?"
	insult_low_opinion = "If you say all this at home, you be dead!"
	bribe_success = "It can stay for "+MERCHANT_TOKEN_TIME+" minutes, for most beloved kin as you."
	bribe_failure = "Krrkkrhkkhh! You ask too much! It must be moving on."
	leaving_soon = "It can stay for "+MERCHANT_TOKEN_TIME+" minutes, for most beloved kin as you."


/decl/merchant_price_modifier/percentage/vox
	name = "Vox Markup"

/decl/merchant_speech/clothing_shop/Initialize()
	. = ..()
	var/index = /decl/species/vox::uid
	hailed_by_species[index] = "Well hello, [MERCHANT_TOKEN_PLAYER_HONORIFIC]! I don't believe we have any clothes that fit you... but you can still look!"
