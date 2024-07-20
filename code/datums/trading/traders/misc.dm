/datum/trader/ship/pet_shop
	name = "Pet Shop Owner"
	name_language = /decl/language/human/common
	origin = "Pet Shop"
	trade_flags = TRADER_GOODS | TRADER_MONEY | TRADER_WANTED_ONLY | TRADER_BRIBABLE
	possible_origins = list(
		"Paws-Out",
		"Pets-R-Smart",
		"Tentacle Companions",
		"Xeno-Pets and Assorted Goods",
		"Barks and Drools"
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Welcome to my xeno-pet shop! Here you will find many wonderful companions. Some a bit more... aggressive than others. But companions none the less. I also buy pets, or trade them.",
		TRADER_HAIL_DENY         = "I no longer wish to speak to you.",
		TRADER_TRADE_COMPLETE    = "Remember to give them attention and food. They are living beings, and you should treat them like so.",
		TRADER_NO_BLACKLISTED    = "Legally I can' do that. Morally, I refuse to do that.",
		TRADER_FOUND_UNWANTED    = "I only want animals. I don't need food or shiny things. I'm looking for specific ones at that. Ones I already have the cage and food for.",
		TRADER_NOT_ENOUGH        = "I'd give you the animal for free, but I need the money to feed the others. So you must pay in full.",
		TRADER_HOW_MUCH          = "This is a fine specimen. I believe it will cost you " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_WHAT_WANT         = "I have the facilities, currently, to support",
		TRADER_COMPLIMENT_DENY   = "That was almost charming.",
		TRADER_COMPLIMENT_ACCEPT = "Thank you. I needed that.",
		TRADER_INSULT_GOOD       = "I ask you to stop. We can be peaceful. I know we can.",
		TRADER_INSULT_BAD        = "My interactions with you are becoming less than fruitful.",
		TRADER_BRIBE_REFUSAL     = "I'm not going to do that. I have places to be.",
		TRADER_BRIBE_ACCEPT      = "Hm. It'll be good for the animals, so sure.",
	)

	possible_wanted_items = list(
		/mob/living/simple_animal/corgi                           = TRADER_THIS_TYPE,
		/mob/living/simple_animal/passive/cat                     = TRADER_THIS_TYPE,
		/mob/living/simple_animal/crab                            = TRADER_THIS_TYPE,
		/mob/living/simple_animal/lizard                          = TRADER_THIS_TYPE,
		/mob/living/simple_animal/passive/mouse                   = TRADER_THIS_TYPE,
		/mob/living/simple_animal/mushroom                        = TRADER_THIS_TYPE,
		/mob/living/simple_animal/tindalos                        = TRADER_THIS_TYPE,
		/mob/living/simple_animal/tomato                          = TRADER_THIS_TYPE,
		/mob/living/simple_animal/cow                             = TRADER_THIS_TYPE,
		/mob/living/simple_animal/chick                           = TRADER_THIS_TYPE,
		/mob/living/simple_animal/fowl/chicken                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/fowl/duck                       = TRADER_THIS_TYPE,
		/mob/living/simple_animal/yithian                         = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/diyaab  = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/bear                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/shantak = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/parrot        = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/samak   = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/goat          = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/carp                    = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/mob/living/simple_animal/corgi                           = TRADER_THIS_TYPE,
		/mob/living/simple_animal/passive/cat                     = TRADER_THIS_TYPE,
		/mob/living/simple_animal/crab                            = TRADER_THIS_TYPE,
		/mob/living/simple_animal/lizard                          = TRADER_THIS_TYPE,
		/mob/living/simple_animal/passive/mouse                   = TRADER_THIS_TYPE,
		/mob/living/simple_animal/mushroom                        = TRADER_THIS_TYPE,
		/mob/living/simple_animal/tindalos                        = TRADER_THIS_TYPE,
		/mob/living/simple_animal/tomato                          = TRADER_THIS_TYPE,
		/mob/living/simple_animal/cow                             = TRADER_THIS_TYPE,
		/mob/living/simple_animal/chick                           = TRADER_THIS_TYPE,
		/mob/living/simple_animal/fowl/chicken                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/fowl/duck                       = TRADER_THIS_TYPE,
		/mob/living/simple_animal/yithian                         = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/diyaab  = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/bear                    = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/shantak = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/parrot        = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/samak   = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/goat          = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/carp                    = TRADER_THIS_TYPE,
		/obj/item/dociler                                         = TRADER_THIS_TYPE,
		/obj/structure/dogbed                                     = TRADER_THIS_TYPE
	)

/datum/trader/ship/prank_shop
	name = "Prank Shop Owner"
	name_language = /decl/language/human/common
	origin = "Prank Shop"
	compliment_increase = 0
	insult_drop = 0
	possible_origins = list(
		"Yacks and Yucks Shop",
		"The Shop From Which I Sell Humorous Items",
		"The Prank Gestalt",
		"The Clown's Armory",
		"Uncle Knuckle's Chuckle Bunker",
		"A Place from Which to do Humorous Business"
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "We welcome you to our shop of humorous items. We invite you to partake in the divine experience of being pranked, and pranking someone else.",
		TRADER_HAIL_DENY         = "We cannot do business with you. We are sorry.",
		TRADER_TRADE_COMPLETE    = "We thank you for purchasing something. We enjoyed the experience of you doing so and we hope to learn from it.",
		TRADER_NO_BLACKLISTED    = "We are not allowed to trade for these goods. We are sorry.",
		TRADER_NO_GOODS          = "We are not allowed to trade for these goods. We are sorry.",
		TRADER_NOT_ENOUGH        = "We have sufficiently experienced giving away goods for free. We wish to experience getting money in return.",
		TRADER_HOW_MUCH          = "We believe that is worth " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_WHAT_WANT         = "We wish only for the experiences you give us, in all else we want",
		TRADER_COMPLIMENT_DENY   = "You are attempting to compliment us.",
		TRADER_COMPLIMENT_ACCEPT = "You are attempting to compliment us.",
		TRADER_INSULT_GOOD       = "You are attempting to insult us, correct?",
		TRADER_INSULT_BAD        = "We do not understand.",
		TRADER_BRIBE_REFUSAL     = "We are sorry, but we cannot accept.",
		TRADER_BRIBE_ACCEPT      = "We are happy to say that we accept this bribe.",
	)
	possible_trading_items = list(
		/obj/item/clothing/mask/gas/clown_hat      = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/gas/mime           = TRADER_THIS_TYPE,
		/obj/item/clothing/shoes/clown_shoes       = TRADER_THIS_TYPE,
		/obj/item/clothing/costume/clown           = TRADER_THIS_TYPE,
		/obj/item/stamp/clown                      = TRADER_THIS_TYPE,
		/obj/item/backpack/clown                   = TRADER_THIS_TYPE,
		/obj/item/bananapeel                       = TRADER_THIS_TYPE,
		/obj/item/gun/launcher/money               = TRADER_THIS_TYPE,
		/obj/item/food/pie                         = TRADER_THIS_TYPE,
		/obj/item/bikehorn                         = TRADER_THIS_TYPE,
		/obj/item/chems/spray/waterflower          = TRADER_THIS_TYPE,
		/obj/item/gun/launcher/pneumatic/small     = TRADER_THIS_TYPE,
		/obj/item/gun/projectile/revolver/capgun   = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/fakemoustache      = TRADER_THIS_TYPE,
		/obj/item/grenade/spawnergrenade/fake_carp = TRADER_THIS_TYPE
	)

/datum/trader/ship/replica_shop
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
	speech = list(
		TRADER_HAIL_GENERIC      = "Greetings, traveler! You've the look of one with a keen hunger for human history. Come in, and learn! Mayhaps even... buy?",
		TRADER_HAIL_DENY         = "I shan't palaver with a man who thumbs his nose at the annals of history. Goodbye.",
		TRADER_TRADE_COMPLETE    = "Thank you, mighty warrior. And remember - these may be replicas, but their edges are honed to razor sharpness!",
		TRADER_NO_BLACKLISTED    = "Nay, we accept only the " + TRADER_TOKEN_CUR_SINGLE + ". Or sovereigns of the king's mint, of course.",
		TRADER_NO_GOODS          = "Nay, we accept only the " + TRADER_TOKEN_CUR_SINGLE + ". Or sovereigns of the king's mint, of course.",
		TRADER_NOT_ENOUGH        = "Alas, traveler, my fine wares cost more than that.",
		TRADER_HOW_MUCH          = "For " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ", I can part with this finest of goods.",
		TRADER_WHAT_WANT         = "I have ever longed for",
		TRADER_COMPLIMENT_DENY   = "Oh ho ho! Aren't you quite the jester.",
		TRADER_COMPLIMENT_ACCEPT = "Why, thank you, traveler! Long have I slaved over the anvil to produce these goods.",
		TRADER_INSULT_GOOD       = "Hey, bro, I'm just tryin' to make a living here, okay? The Camelot schtick is part of my brand.",
		TRADER_INSULT_BAD        = "Man, fuck you, then.",
		TRADER_BRIBE_REFUSAL     = "Alas, traveler - I could stay all eve, but I've an client in waiting, and they are not known for patience.",
		TRADER_BRIBE_ACCEPT      = "Mayhaps I could set a spell longer, and rest my weary feet."
	)
	possible_trading_items = list(
		/obj/item/clothing/head/wizard/magus        = TRADER_THIS_TYPE,
		/obj/item/shield/buckler                    = TRADER_THIS_TYPE,
		/obj/item/clothing/head/redcoat             = TRADER_THIS_TYPE,
		/obj/item/clothing/head/powdered_wig        = TRADER_THIS_TYPE,
		/obj/item/clothing/head/hasturhood          = TRADER_THIS_TYPE,
		/obj/item/clothing/head/helmet/gladiator    = TRADER_THIS_TYPE,
		/obj/item/clothing/head/plaguedoctorhat     = TRADER_THIS_TYPE,
		/obj/item/clothing/glasses/eyepatch/monocle = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/smokable/pipe       = TRADER_THIS_TYPE,
		/obj/item/clothing/mask/gas/plaguedoctor    = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/hastur              = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/imperium_monk       = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/judgerobe           = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/wizrobe/magusred    = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/wizrobe/magusblue   = TRADER_THIS_TYPE,
		/obj/item/clothing/costume/gladiator          = TRADER_THIS_TYPE,
		/obj/item/clothing/costume/kilt               = TRADER_THIS_TYPE,
		/obj/item/clothing/costume/redcoat            = TRADER_THIS_TYPE,
		/obj/item/clothing/costume/soviet             = TRADER_THIS_TYPE,
		/obj/item/harpoon                           = TRADER_THIS_TYPE,
		/obj/item/sword                             = TRADER_ALL,
		/obj/item/scythe                            = TRADER_THIS_TYPE,
		/obj/item/star                              = TRADER_THIS_TYPE,
		/obj/item/baseball_bat             = TRADER_THIS_TYPE
	)