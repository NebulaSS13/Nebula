/// A weird merchant who sells a mix of fantasy themed costumes and actual weapons, for whatever reason.
/datum/merchant/transient/replica_shop
	name = "Replica Store Owner"
	origin = "Replica Store"
	possible_origins = list(
		"Ye-Old Armory",
		"Knights and Knaves",
		"The Blacksmith",
		"Historical Human Apparel and Items",
		"The Pointy End",
		"Fight Knight's Knightly Nightly Knight Fights",
		"Elminster's Fine Steel",
		"The Arms of King Duordan",
		"Queen's Edict"
	)
	supply_potential = list(/decl/merchant_potential_commodities/replica_shop)
	speech = /decl/merchant_speech/replica_shop


/decl/merchant_potential_commodities/replica_shop
	type_instructions = list(
		/obj/item/clothing/head/wizard/magus			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/wizard/marisa			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/redcoat					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/powdered_wig			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/hasturhood				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/helmet/gladiator		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/head/plaguedoctorhat			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/glasses/eyepatch/monocle		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/mask/smokable/pipe			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/mask/gas/plaguedoctor		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/hastur					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/imperium_monk			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/judgerobe				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/wizrobe/magus			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/suit/wizrobe/marisa			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/costume/gladiator			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/costume/kilt					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/costume/redcoat				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/costume/soviet				= MERCHANT_INCLUDE_THIS_TYPE, // idk why this is here
		/obj/item/clothing/costume/savage_hunter		= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/costume/savage_hunter/female	= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/tunic					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/tunic/blue				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/tunic/green			= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/clothing/shirt/gambeson				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/shield/crafted/buckler				= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/harpoon								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sword									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sword/wood							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sword/katana							= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sword/katana/bamboo					= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/sword/katana/wood						= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/scythe								= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/star									= MERCHANT_INCLUDE_THIS_TYPE,
		/obj/item/baseball_bat							= MERCHANT_INCLUDE_THIS_TYPE
	)


/decl/merchant_speech/replica_shop
	hailed = "Greetings, traveler! You've the look of one with a keen hunger for human history. \
	Come in, and learn! Mayhaps even... buy?"
	denied_hail = "I shan't palaver with a man who thumbs his nose at the annals of history. Goodbye."
	trade_complete = "Thank you, mighty warrior. And remember - these may be replicas, but their edges \
	are honed to razor sharpness!"
	forbidden_offer = "Nay, we accept only the "+MERCHANT_TOKEN_CURRENCY_SINGULAR+". Or sovereigns of \
	the king's mint, of course."
	goods_not_accepted = "Nay, we accept only the "+MERCHANT_TOKEN_CURRENCY_SINGULAR+". Or sovereigns of \
	the king's mint, of course."
	not_enough_value = "Alas, traveler, my fine wares cost more than that."
	how_much = "For "+MERCHANT_TOKEN_VALUE+" "+MERCHANT_TOKEN_CURRENCY+", I can part with this finest of goods."
	what_wanted_beginning = "I have ever longed for"
	compliment_failure = "Oh ho ho! Aren't you quite the jester."
	compliment_success = "Why, thank you, traveler! Long have I slaved over the anvil to produce these goods."
	insult_high_opinion = "Hey, bro, I'm just tryin' to make a living here, okay? The Camelot schtick \
	is part of my brand."
	insult_low_opinion = "Man, fuck you, then."
	bribe_failure = "Alas, traveler - I could stay all eve, but I've an client in waiting, and they are \
	not known for patience."
	bribe_success = "Mayhaps I could set a spell longer, and rest my weary feet."
	leaving_soon = "I must depart in "+MERCHANT_TOKEN_TIME+" minutes."