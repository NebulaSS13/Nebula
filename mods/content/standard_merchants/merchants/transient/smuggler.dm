/// A sneaky 'merchant' who requires a bribe for be tradeable (usually).
/// When that happens, they stop being a temporary merchant (temporarily), however they will instead leave quickly after completing any transaction.
/// This allows someone to form a plan in order to make a big sale, or accumulate enough cash to buy something coveted and presumably illegal.
/datum/merchant/transient/smuggler
	abstract_type = /datum/merchant/transient/smuggler
	possible_origins = list(
		"nondescript freighter",
		"nondescript salvager"
	)
	name_background = /decl/background_detail/heritage/human
	refuse_bribes = FALSE
	skill_level = SKILL_ADEPT
	speech = /decl/merchant_speech/smuggler/secretive
	supply_strategy = /decl/merchant_inventory_strategy/percentage/zero
	supply_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 0.8,
		/decl/merchant_price_modifier/disposition = 0.9,
		/decl/merchant_price_modifier/legacy_skill_disparity/supply = 1.2
	)
	demand_strategy = /decl/merchant_inventory_strategy/percentage/zero
	demand_price_modifiers = list(
		/decl/merchant_price_modifier/percentage = 2.5,
		/decl/merchant_price_modifier/disposition = 1.1,
		/decl/merchant_price_modifier/legacy_skill_disparity/demand = 1.2
	)
	forbidden_objects = list(
		/mob/living/human,
		/obj/machinery/nuclearbomb,
		/obj/item/disk/nuclear
	)
	starting_cash_lower_bound = 700
	starting_cash_upper_bound = 1200
	typical_duration_lower_bound = 10
	typical_duration_upper_bound = 15
	bribe_duration_divisor = 0
	var/secretive = TRUE /// Becomes FALSE upon receiving a bribe for the first time.

/datum/merchant/transient/smuggler/bribe(amount)
	. = ..()
	if(. && secretive)
		reveal_secret()

/datum/merchant/transient/smuggler/default_disposition(mob/user)
	if(!isliving(user))
		return ..()

	var/mob/living/L = user
	var/decl/background_detail/background = L.get_background_datum_by_flag(BACKGROUND_FLAG_IDEOLOGY)

	// Those with a criminal background have a chance to not need to bribe the smuggler first.
	if(prob(background.subversive_potential))
		return HIGH_DISPOSITION_THRESHOLD
	return ..()

/datum/merchant/transient/smuggler/pre_hail(mob/user)
	. = ..()

	if(get_disposition(user) >= HIGH_DISPOSITION_THRESHOLD && secretive)
		reveal_secret()

/// Causes the merchant to reveal their true nature as a shifty smuggler.
/datum/merchant/transient/smuggler/proc/reveal_secret()
	secretive = FALSE
	is_temporary_merchant = FALSE
	speech = /decl/merchant_speech/smuggler
	supply_strategy = GET_DECL(/decl/merchant_inventory_strategy/legacy)
	demand_strategy = GET_DECL(/decl/merchant_inventory_strategy/legacy)
	setup_inventory()

/// Causes the merchant to leave in a few minutes after a transaction.
/datum/merchant/transient/smuggler/proc/clean_getaway()
	is_temporary_merchant = TRUE
	duration_of_stay = rand(2, 3)

/datum/merchant/transient/smuggler/on_completed_transaction(mob/user, list/items, actual_value, turf/location)
	. = ..()
	if(!is_temporary_merchant)
		clean_getaway()


// Subtypes
/datum/merchant/transient/smuggler/gunrunner
	supply_potential = list(/decl/merchant_potential_commodities/gunrunner_supply)
	demand_potential = list(/decl/merchant_potential_commodities/gunrunner_demand)

/decl/merchant_potential_commodities/gunrunner_supply
	type_instructions = list(
		/obj/item/gun/projectile/pistol/holdout	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/ammo_magazine/pistol/small	= MERCHANT_INCLUDE_THIS_TYPE
	)
	item_quantity_upper_bound = 2

/decl/merchant_potential_commodities/gunrunner_demand
	type_instructions = list(
		/obj/item/gun/energy/gun							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/gun/nuclear					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/xray							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/laser							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/energy/ionrifle						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/shotgun/pump				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/automatic/smg				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/gun/projectile/automatic/assault_rifle	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/rig_module/mounted/egun					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/rig_module/mounted/lcannon				= MERCHANT_INCLUDE_THIS_TYPE
	)
	item_quantity_upper_bound = 2


/datum/merchant/transient/smuggler/hacker
	supply_potential = list(/decl/merchant_potential_commodities/hacker_regular_supply)
	demand_potential = list(
		/decl/merchant_potential_commodities/hacker_regular_demand,
		/decl/merchant_potential_commodities/hacker_law_boards
	)


/decl/merchant_potential_commodities/hacker_regular_supply
	type_instructions = list(
		/obj/item/stock_parts/computer/hard_drive/portable/merchant = MERCHANT_INCLUDE_THIS_TYPE
	)

/decl/merchant_potential_commodities/hacker_regular_demand
	// General stuff hackers might want.
	type_instructions = list(
		/obj/item/disk/survey							= MERCHANT_INCLUDE_THIS_TYPE, // Could add some other disks if they are ever made to have value scale with their contents.
		/obj/item/stock_parts/circuitboard/aiupload		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/borgupload	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/card/emag_broken						= MERCHANT_INCLUDE_THIS_TYPE
	)
	item_quantity_lower_bound = 1
	item_quantity_upper_bound = 1

/decl/merchant_potential_commodities/hacker_law_boards
	// One of the 'spicy' AI law boards.
	type_instructions = list(
		/obj/item/aiModule/freeform		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/aiModule/freeformcore	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/aiModule/purge		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/aiModule/oneHuman		= MERCHANT_INCLUDE_THIS_TYPE
	)
	item_quantity_lower_bound = 1
	item_quantity_upper_bound = 1
	max_distinct_types = 1



/datum/merchant/transient/smuggler/malpractice
	supply_potential = list(/decl/merchant_potential_commodities/malpractice_supply)
	demand_potential = list(/decl/merchant_potential_commodities/reagents/malpractice_drug_demand)



/decl/merchant_potential_commodities/malpractice_supply
	type_instructions = list(
		/obj/item/firstaid/surgery/ghetto			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/box/freezer						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/book/skill/medical/anatomy/basic	= MERCHANT_INCLUDE_THIS_TYPE
	)
	item_quantity_lower_bound = 1
	item_quantity_upper_bound = 1

/decl/merchant_potential_commodities/reagents/malpractice_drug_demand
	type_instructions = list(
		/decl/material/liquid/psychoactives					= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/accumulated/antidepressants	= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/accumulated/stimulants		= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/amphetamines					= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/narcotics						= MERCHANT_INCLUDE_THIS_TYPE,
		/decl/material/liquid/hallucinogenics				= MERCHANT_INCLUDE_THIS_TYPE
	)
	container_types = list(/obj/item/chems/pill)
	item_quantity_lower_bound = 30
	item_quantity_upper_bound = 60


/decl/merchant_speech/smuggler
	hailed = "Hey there. If you got cash and can keep a secret, we can do business."
	hailed_by_synth = "If you're one of those synths that can't keep secrets, disconnect now."
	denied_hail = "I only work with people I can trust."
	what_wanted_beginning = "I'm looking to score"
	what_wanted_ending = ". Tax free, of course, and a premium for discretion."
	no_more_wanted = "It's too risky to put another "+MERCHANT_TOKEN_ITEM+" on my ship."
	too_many_items = "I can only hide "+MERCHANT_TOKEN_QUANTITY+" more "+MERCHANT_TOKEN_TIME+" on my ship."
	forbidden_offer = "That's not the kind of business I'm in."
	found_unwanted = "Nope. Don't want that."
	not_enough_value = "High risk means I want a high reward. That ain't it."
	how_much = MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+", and that "+MERCHANT_TOKEN_ITEM+" is yours. \
	I'll have to leave soon after you buy it."
	appraise_offer = "I'll take those off your hands for... "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+". \
	I'll have to go dark after we finish trading."
	trade_complete = "If anybody asks, you never saw me. Also, hurry up if you're not done yet, I can't stay too long."
	bribe_success = "I mean, sure?"
	compliment_success = "I do run a smooth operation."
	compliment_failure = "Let's keep this strictly professional."
	insult_low_opinion = "What the hell is your problem?"
	insult_high_opinion = "Calm the fuck down, before somebody hears you."
	staying_put = "For now, I'm not going anywhere. We're just two people having a chat. Nobody's gonna bother us for that. \
	After we trade, I'll have to disappear real fast, so take your time and get everything set up before you pull the trigger. \
	Whatever happens after I'm gone is your problem."
	leaving_soon = "I'm leaving and going dark in "+MERCHANT_TOKEN_TIME+" minutes, no matter what. Make any last minute trades now."


/decl/merchant_speech/smuggler/secretive
	hailed = "What do you want? I'm not looking to trade."
	denied_hail = "Fuck off!"
	goods_not_accepted = "I don't care what you're selling, I'm not buying."
	leaving_soon = "That's private."
	bribe_success = "I guess I can cut you in."
