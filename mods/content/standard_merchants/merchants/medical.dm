/// An unscrupulous merchant with an alleged medical background. They sell a wide array of medical supplies,
/// and in return, ask for booze, tobacco, and occasionally organs.
/// They are often the only game in town when it comes to medicine, and their prices reflect that.
/datum/merchant/medical
	name = "Medical Supplier"
	origin = "Infirmary of CSV Iniquity"
	skill_level = SKILL_EXPERT
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 2.0,
		/decl/merchant_price_modifier/disposition = 0.8,
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 2.0
	)
	demand_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 1.2,
		/decl/merchant_price_modifier/disposition = 1.2,
		/decl/merchant_price_modifier/legacy_skill_disparity/demand = 2.0
	)
	accepts_goods_as_payment = TRUE
	refuse_bribes = FALSE
	possible_origins = list(
		"Dr.Krieger's Practice",
		"Legit Medical Supplies (No Refunds)",
		"Mom's & Pop's Addictive Opoids",
		"Legitimate Pharmaceutical Firm",
		"Designer Drugs by Lil Xanny"
	)
	speech = /decl/merchant_speech/krieger
	supply_potential = list(/decl/merchant_potential_commodities/krieger_supply)
	demand_potential = list(
		/decl/merchant_potential_commodities/krieger_demand,
		/decl/merchant_potential_commodities/reagents/boozehound
	)


/decl/merchant_potential_commodities/krieger_supply
	type_instructions = list(
		/obj/item/pill_bottle					= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/pill_bottle/foil_pack			= MERCHANT_EXCLUDE_THIS_TYPE,
		/obj/item/pill_bottle/dice				= MERCHANT_EXCLUDE_ALL,
		/obj/item/pill_bottle/dice_nerd			= MERCHANT_EXCLUDE_ALL,
		/obj/item/firstaid/fire					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/firstaid/toxin				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/firstaid/adv					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/bloodpacks				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/ivbag					= MERCHANT_INCLUDE_SUBTYPES,
		/obj/item/retractor						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/hemostat						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/cautery						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/surgicaldrill					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scalpel						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/incision_manager				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/circular_saw					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bonegel						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bonesetter					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/glass/bottle/stabilizer	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/glass/bottle/sedatives	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/chems/glass/bottle/antitoxin	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/bodybag/cryobag				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sign/diploma/fake				= MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/krieger_demand
	type_instructions = list(
		/obj/item/organ/internal/liver				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/kidneys			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/lungs				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/organ/internal/heart				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/fancy/cigarettes				= MERCHANT_INCLUDE_ALL,
		/obj/item/box/fancy/cigarettes/covert		= MERCHANT_EXCLUDE_ALL // Excluding these since they show up on the console as the regular cigarettes.
	)

/decl/merchant_potential_commodities/reagents/boozehound
	type_instructions = list(
		/decl/material/liquid/alcohol		= MERCHANT_INCLUDE_SUBTYPES,
		/decl/material/liquid/alcohol/pwine	= MERCHANT_EXCLUDE_THIS_TYPE
	)
	container_types = list(/obj/item/chems/drinks/bottle)


/decl/merchant_speech/krieger
	hailed = "Huh? How'd you get this number?! Oh well, if you wanna talk biz, I'm listening."
	denied_hail = "This is an automated message. Feel free to fuck the right off after the buzzer. *buzz*"
	trade_complete = "Good to have business with ya. Remember, no refunds."
	forbidden_offer = "Whoa whoa, I don't want this shit, put it away."
	found_unwanted = "What the hell do you expect me to do with this junk?"
	not_enough_value = "Sorry, pal, full payment upfront, I don't write the rules. Well, I do, \
	but that's beside the point."
	how_much = "Hmm, this is one damn fine item, but I'll part with it for "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+"."
	what_wanted_beginning = "I could always use some fucking"
	compliment_failure = "Haha, how nice of you. Why don't you go fall in an elevator shaft."
	compliment_success = "Damn right I'm awesome, tell me more."
	insult_high_opinion = "Damn, pal, no need to get snippy."
	insult_low_opinion = "*muffled laughter* Sorry, was that you trying to talk shit? Adorable."
	bribe_success = "It's your money, pal."
	staying_put = "Man I live here, I'm not leaving anytime soon."