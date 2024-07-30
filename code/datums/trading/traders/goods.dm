/datum/trader/ship/toyshop
	name = "Toy Shop Employee"
	origin = "Toy Shop"
	trade_flags = TRADER_GOODS | TRADER_MONEY | TRADER_WANTED_ONLY | TRADER_BRIBABLE
	possible_origins = list(
		"Toys R Ours",
		"LET'S GO",
		"Kay-Cee Toys",
		"Build-a-Cat",
		"Magic Box",
		"The Positronic's Dungeon and Baseball Card Shop"
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Uhh... hello? Welcome to " + TRADER_TOKEN_ORIGIN + ", I hope you have a, uhh.... good shopping trip.",
		TRADER_HAIL_DENY         = "Nah, you're not allowed here. At all",
		TRADER_TRADE_COMPLETE    = "Thanks for shopping... here... at " + TRADER_TOKEN_ORIGIN + ".",
		TRADER_NO_BLACKLISTED    = "Uuuhhh.... no.",
		TRADER_FOUND_UNWANTED    = "Nah! That's not what I'm looking for. Something rarer.",
		TRADER_NOT_ENOUGH        = "Just 'cause they're made of cardboard doesn't mean they don't cost money...",
		TRADER_HOW_MUCH          = "Uhh... I'm thinking like... " + TRADER_TOKEN_VALUE + ". Right? Or something rare that complements my interest.",
		TRADER_WHAT_WANT         = "Ummmm..... I guess I want",
		TRADER_COMPLIMENT_DENY   = "Ha! Very funny! You should write your own television show.",
		TRADER_COMPLIMENT_ACCEPT = "Why yes, I do work out.",
		TRADER_INSULT_GOOD       = "Well, well, well. Guess we learned who was the troll here.",
		TRADER_INSULT_BAD        = "I've already written a nasty Spacebook post in my mind about you.",
		TRADER_BRIBE_REFUSAL     = "Nah. I need to get moving as soon as uhh... possible.",
		TRADER_BRIBE_ACCEPT      = "You know what, I wasn't doing anything for " + TRADER_TOKEN_TIME + " minutes anyways.",
	)

	possible_wanted_items = list(
		/obj/item/toy/figure             = TRADER_THIS_TYPE,
		/obj/item/toy/figure/ert         = TRADER_THIS_TYPE,
		/obj/item/toy/prize/honk         = TRADER_THIS_TYPE
	)

	possible_trading_items = list(
		/obj/item/toy/prize              = TRADER_SUBTYPES_ONLY,
		/obj/item/toy/prize/honk         = TRADER_BLACKLIST,
		/obj/item/toy/figure             = TRADER_SUBTYPES_ONLY,
		/obj/item/toy/figure/ert         = TRADER_BLACKLIST,
		/obj/item/toy/plushie            = TRADER_SUBTYPES_ONLY,
		/obj/item/sword/katana/toy       = TRADER_THIS_TYPE,
		/obj/item/energy_blade/sword/toy = TRADER_THIS_TYPE,
		/obj/item/toy/bosunwhistle       = TRADER_THIS_TYPE,
		/obj/item/board                  = TRADER_THIS_TYPE,
		/obj/item/box/checkers           = TRADER_ALL,
		/obj/item/deck                   = TRADER_SUBTYPES_ONLY,
		/obj/item/pack                   = TRADER_SUBTYPES_ONLY,
		/obj/item/dice                   = TRADER_ALL,
		/obj/item/dice/d20/cursed        = TRADER_BLACKLIST,
		/obj/item/gun/launcher/money     = TRADER_THIS_TYPE
	)

/datum/trader/ship/electronics
	name = "Electronic Shop Employee"
	origin = "Electronic Shop"
	possible_origins = list(
		"Best Sale",
		"Overstore",
		"Oldegg",
		"Circuit Citadel",
		"Silicon Village",
		"Positronic Solutions LLC",
		"Sunvolt Inc."
	)

	speech = list(
		TRADER_HAIL_GENERIC      = "Hello, sir! Welcome to " + TRADER_TOKEN_ORIGIN + ", I hope you find what you are looking for.",
		TRADER_HAIL_DENY         = "Your call has been disconnected.",
		TRADER_TRADE_COMPLETE    = "Thank you for shopping at " + TRADER_TOKEN_ORIGIN + ", would you like to get the extended warranty as well?",
		TRADER_NO_BLACKLISTED    = "Sir, this is a /electronics/ store.",
		TRADER_NO_GOODS          = "As much as I'd love to buy that from you, I can't.",
		TRADER_NOT_ENOUGH        = "Your offer isn't adequate, sir.",
		TRADER_HOW_MUCH          = "Your total comes out to " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_COMPLIMENT_DENY   = "Hahaha! Yeah... funny...",
		TRADER_COMPLIMENT_ACCEPT = "That's very nice of you!",
		TRADER_INSULT_GOOD       = "That was uncalled for, sir. Don't make me get my manager.",
		TRADER_INSULT_BAD        = "Sir, I am allowed to hang up the phone if you continue, sir.",
		TRADER_BRIBE_REFUSAL     = "Sorry, sir, but I can't really do that.",
		TRADER_BRIBE_ACCEPT      = "Why not! Glad to be here for a few more minutes.",
	)

	possible_trading_items = list(
		/obj/item/stock_parts/computer/battery_module          = TRADER_SUBTYPES_ONLY,
		/obj/item/stock_parts/circuitboard                     = TRADER_SUBTYPES_ONLY,
		/obj/item/stock_parts/circuitboard/unary_atmos         = TRADER_BLACKLIST,
		/obj/item/stock_parts/circuitboard/arcade              = TRADER_BLACKLIST,
		/obj/item/stock_parts/circuitboard/broken              = TRADER_BLACKLIST,
		/obj/item/stack/cable_coil                             = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/cable_coil/cyborg                      = TRADER_BLACKLIST,
		/obj/item/stack/cable_coil/random                      = TRADER_BLACKLIST,
		/obj/item/stack/cable_coil/cut                         = TRADER_BLACKLIST,
		/obj/item/stock_parts/circuitboard/air_alarm           = TRADER_THIS_TYPE,
		/obj/item/stock_parts/circuitboard/airlock_electronics = TRADER_ALL,
		/obj/item/cell                                         = TRADER_THIS_TYPE,
		/obj/item/cell/crap                                    = TRADER_THIS_TYPE,
		/obj/item/cell/high                                    = TRADER_THIS_TYPE,
		/obj/item/cell/super                                   = TRADER_THIS_TYPE,
		/obj/item/cell/hyper                                   = TRADER_THIS_TYPE,
		/obj/item/tracker_electronics                          = TRADER_THIS_TYPE
	)


/* Clothing stores: each a different type. A hat/glove store, a shoe store, and a jumpsuit store. */
/datum/trader/ship/clothingshop
	name = "Clothing Store Employee"
	origin = "Clothing Store"
	possible_origins = list(
		"Space Eagle",
		"Banana Democracy",
		"Forever 22",
		"Textiles Factory Warehouse Outlet",
		"Blocks Brothers"
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Hello, sir! Welcome to " + TRADER_TOKEN_ORIGIN + "!",
		TRADER_HAIL_DENY         = "We do not trade with rude customers. Consider yourself blacklisted.",
		TRADER_TRADE_COMPLETE    = "Thank you for shopping at " + TRADER_TOKEN_ORIGIN + ". Remember: We cannot accept returns without the original tags!",
		TRADER_NO_BLACKLISTED    = "Hm, how about no?",
		TRADER_NO_GOODS          = "We don't buy, sir. Only sell.",
		TRADER_NOT_ENOUGH        = "Sorry, " + TRADER_TOKEN_ORIGIN + " policy to not accept trades below our marked prices.",
		TRADER_HOW_MUCH          = "Your total comes out to " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_COMPLIMENT_DENY   = "Excuse me?",
		TRADER_COMPLIMENT_ACCEPT = "Aw, you're so nice!",
		TRADER_INSULT_GOOD       = "Sir.",
		TRADER_INSULT_BAD        = "Wow. I don't have to take this.",
		TRADER_BRIBE_REFUSAL     = TRADER_TOKEN_ORIGIN + " policy clearly states we cannot stay for more than the designated time.",
		TRADER_BRIBE_ACCEPT      = "Hm.... sure! We'll have a few minutes of 'engine troubles'.",
	)

	possible_trading_items = list(
		/obj/item/clothing/pants                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/pants/pj                        = TRADER_BLACKLIST,
		/obj/item/clothing/pants/shorts                    = TRADER_BLACKLIST,
		/obj/item/clothing/pants/chameleon                 = TRADER_BLACKLIST,
		/obj/item/clothing/shirt                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/shirt/chameleon                 = TRADER_BLACKLIST,
		/obj/item/clothing/shirt/pj                        = TRADER_BLACKLIST,
		/obj/item/clothing/skirt                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/dress                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/dress/wedding                   = TRADER_BLACKLIST,
		/obj/item/clothing/shirt                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/pants                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/skirt                           = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/jumpsuit                        = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/jumpsuit/chameleon              = TRADER_BLACKLIST,
		/obj/item/clothing/jumpsuit                        = TRADER_BLACKLIST,
		/obj/item/clothing/pants/mankini                   = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/jumpsuit/tactical               = TRADER_BLACKLIST
	)

/datum/trader/ship/clothingshop/shoes
	possible_origins = list(
		"Foot Safe",
		"Paysmall",
		"Popular Footwear",
		"Grimbly's Shoes",
		"Right Steps"
	)
	possible_trading_items = list(
		/obj/item/clothing/shoes                       = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/shoes/chameleon             = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/jackboots/swat/combat = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/clown_shoes           = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/cult                  = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/lightrig              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/shoes/magboots              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/shoes/jackboots/swat        = TRADER_BLACKLIST,
		/obj/item/clothing/shoes/syndigaloshes         = TRADER_BLACKLIST
	)

/datum/trader/ship/clothingshop/hatglovesaccessories
	possible_origins = list(
		"Baldie's Hats and Accessories",
		"The Right Fit",
		"Like a Glove",
		"Space Fashion"
	)
	possible_trading_items = list(
		/obj/item/clothing/neck                       = TRADER_ALL,
		/obj/item/clothing/suit/jacket                = TRADER_ALL,
		/obj/item/clothing/suit/robe                  = TRADER_ALL,
		/obj/item/clothing/shoes/legbrace             = TRADER_ALL,
		/obj/item/clothing/shoes/kneepads             = TRADER_ALL,
		/obj/item/clothing/armor_attachment/tag       = TRADER_ALL,
		/obj/item/clothing/armor_attachment/helmcover = TRADER_ALL,
		/obj/item/clothing/badge                      = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/medal                      = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/webbing                    = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/webbing/holster            = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves                     = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/gloves/lightrig            = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/rig                 = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/gloves/thick/swat          = TRADER_BLACKLIST,
		/obj/item/clothing/gloves/chameleon           = TRADER_BLACKLIST,
		/obj/item/clothing/head                       = TRADER_SUBTYPES_ONLY,
		/obj/item/clothing/head/HoS                   = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/bio_hood              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/bomb_hood             = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/caphat                = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/centhat               = TRADER_BLACKLIST,
		/obj/item/clothing/head/chameleon             = TRADER_BLACKLIST,
		/obj/item/clothing/head/collectable           = TRADER_BLACKLIST,
		/obj/item/clothing/head/helmet                = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/lightrig              = TRADER_BLACKLIST_ALL,
		/obj/item/clothing/head/radiation             = TRADER_BLACKLIST,
		/obj/item/clothing/head/warden                = TRADER_BLACKLIST,
		/obj/item/clothing/head/welding               = TRADER_BLACKLIST
	)

/*
Sells devices, odds and ends, and medical stuff
*/
/datum/trader/devices
	name = "Drugstore Employee"
	origin = "Drugstore"
	possible_origins = list(
		"Buy 'n Save",
		"Drug Carnival",
		"C&B",
		"Fentles",
		"Dr. Goods",
		"Beevees",
		"McGillicuddy's"
	)
	possible_trading_items = list(
		/obj/item/flashlight                      = TRADER_ALL,
		/obj/item/kit/paint                       = TRADER_SUBTYPES_ONLY,
		/obj/item/aicard                          = TRADER_THIS_TYPE,
		/obj/item/binoculars                      = TRADER_THIS_TYPE,
		/obj/item/cable_painter                   = TRADER_THIS_TYPE,
		/obj/item/flash                           = TRADER_THIS_TYPE,
		/obj/item/paint_sprayer                   = TRADER_THIS_TYPE,
		/obj/item/multitool                       = TRADER_THIS_TYPE,
		/obj/item/lightreplacer                   = TRADER_THIS_TYPE,
		/obj/item/megaphone                       = TRADER_THIS_TYPE,
		/obj/item/paicard                         = TRADER_THIS_TYPE,
		/obj/item/scanner/health                  = TRADER_THIS_TYPE,
		/obj/item/scanner/breath                  = TRADER_THIS_TYPE,
		/obj/item/scanner/gas                     = TRADER_ALL,
		/obj/item/scanner/spectrometer            = TRADER_ALL,
		/obj/item/scanner/reagent                 = TRADER_ALL,
		/obj/item/scanner/xenobio                 = TRADER_THIS_TYPE,
		/obj/item/suit_cooling_unit               = TRADER_THIS_TYPE,
		/obj/item/t_scanner                       = TRADER_THIS_TYPE,
		/obj/item/taperecorder                    = TRADER_THIS_TYPE,
		/obj/item/batterer                        = TRADER_THIS_TYPE,
		/obj/item/synthesized_instrument/violin   = TRADER_THIS_TYPE,
		/obj/item/hailer                          = TRADER_THIS_TYPE,
		/obj/item/uv_light                        = TRADER_THIS_TYPE,
		/obj/item/organ/internal/brain_interface  = TRADER_SUBTYPES_ONLY,
		/obj/item/robotanalyzer                   = TRADER_THIS_TYPE,
		/obj/item/chems/toner_cartridge           = TRADER_THIS_TYPE,
		/obj/item/camera_film                     = TRADER_THIS_TYPE,
		/obj/item/camera                          = TRADER_THIS_TYPE,
		/obj/item/destTagger                      = TRADER_THIS_TYPE,
		/obj/item/gps                             = TRADER_THIS_TYPE,
		/obj/item/measuring_tape                  = TRADER_THIS_TYPE,
		/obj/item/ano_scanner                     = TRADER_THIS_TYPE,
		/obj/item/core_sampler                    = TRADER_THIS_TYPE,
		/obj/item/depth_scanner                   = TRADER_THIS_TYPE,
		/obj/item/pinpointer/radio                = TRADER_THIS_TYPE,
		/obj/item/stack/medical                   = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/medical/ointment/crafted  = TRADER_BLACKLIST_ALL,
		/obj/item/stack/medical/bandage/crafted   = TRADER_BLACKLIST_ALL,
		/obj/item/stack/medical/splint/crafted    = TRADER_BLACKLIST_ALL,
		/obj/item/stack/medical/splint/improvised = TRADER_BLACKLIST_ALL
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Hello, hello! Bits and bobs and everything in between, I hope you find what you're looking for!",
		TRADER_HAIL_SILICON      = "Ah! Hello, robot. We only sell things that, ah.... people can hold in their hands, unfortunately. You are still allowed to buy, though!",
		TRADER_HAIL_DENY         = "Oh no. I don't want to deal with YOU.",
		TRADER_TRADE_COMPLETE    = "Thank you! Now remember, there isn't any return policy here, so be careful with that!",
		TRADER_NO_BLACKLISTED    = "Hm. Well that would be illegal, so no.",
		TRADER_NO_GOODS          = "I'm sorry, I only sell goods.",
		TRADER_NOT_ENOUGH        = "Gotta pay more than that to get that!",
		TRADER_HOW_MUCH          = "Well... I bought it for a lot, but I'll give it to you for " + TRADER_TOKEN_VALUE + ".",
		TRADER_COMPLIMENT_DENY   = "Uh... did you say something?",
		TRADER_COMPLIMENT_ACCEPT = "Mhm! I can agree to that!",
		TRADER_INSULT_GOOD       = "Wow, where was that coming from?",
		TRADER_INSULT_BAD        = "Don't make me blacklist your connection.",
		TRADER_BRIBE_REFUSAL     = "Well, as much as I'd love to say 'yes', you realize I operate on a station, correct?",
	)

/datum/trader/ship/robots
	name = "Robot Seller"
	origin = "Robot Store"
	possible_origins = list(
		"AI for the Straight Guy",
		"Mechanical Buddies",
		"Bot Chop Shop",
		"Omni Consumer Projects"
	)
	possible_trading_items = list(
		/obj/item/bot_kit = TRADER_THIS_TYPE,
		/obj/item/paicard = TRADER_THIS_TYPE,
		/obj/item/aicard  = TRADER_THIS_TYPE,
		/mob/living/bot   = TRADER_SUBTYPES_ONLY
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Welcome to " + TRADER_TOKEN_ORIGIN + "! Let me walk you through our fine robotic selection!",
		TRADER_HAIL_SILICON      = "Welcome to " + TRADER_TOKEN_ORIGIN + "! Let- oh, you're a synth! Well, your money is good anyway. Welcome, welcome!",
		TRADER_HAIL_DENY         = TRADER_TOKEN_ORIGIN + " no longer wants to speak to you.",
		TRADER_TRADE_COMPLETE    = "I hope you enjoy your new robot!",
		TRADER_NO_BLACKLISTED    = "I work with robots, sir. Not that.",
		TRADER_NO_GOODS          = "You gotta buy the robots, sir. I don't do trades.",
		TRADER_NOT_ENOUGH        = "You're coming up short on cash.",
		TRADER_HOW_MUCH          = "My fine selection of robots will cost you " + TRADER_TOKEN_VALUE + "!",
		TRADER_COMPLIMENT_DENY   = "Well, I almost believed that.",
		TRADER_COMPLIMENT_ACCEPT = "Thank you! My craftsmanship is my life.",
		TRADER_INSULT_GOOD       = "Uncalled for.... uncalled for.",
		TRADER_INSULT_BAD        = "I've programmed AI better at insulting than you!",
		TRADER_BRIBE_REFUSAL     = "I've got too many customers waiting in other sectors, sorry.",
		TRADER_BRIBE_ACCEPT      = "Hm. Don't keep me waiting too long, though.",
	)

/datum/trader/xeno_shop
	name = "Xenolife Collector"
	origin = "CSV Not a Poacher"
	trade_flags = TRADER_GOODS | TRADER_MONEY | TRADER_WANTED_ONLY | TRADER_WANTED_ALL
	possible_origins = list(
		"XenoHugs",
		"Exotic Specimen Acquisition",
		"Skinner Catering Reseller",
		"Corporate Companionship Division",
		"Lonely Pete's Exotic Companionship",
		"Space Wei's Exotic Cuisine"
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Welcome! We are always looking to acquire more exotic life forms.",
		TRADER_HAIL_DENY         = "We no longer wish to speak to you. Please contact our legal representative if you wish to rectify this.",
		TRADER_TRADE_COMPLETE    = "Remember to give them attention and food. They are living beings, and you should treat them like so.",
		TRADER_NO_BLACKLISTED    = "Legally I can't do that. Morally... well, I refuse to do that.",
		TRADER_FOUND_UNWANTED    = "I only want animals. I don't need food or shiny things. I'm looking for specific ones, at that. Ones I already have the cage and food for.",
		TRADER_NOT_ENOUGH        = "I'd give you this for free, but I need the money to feed the specimens. So you must pay in full.",
		TRADER_HOW_MUCH          = "This is a good choice. I believe it will cost you " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_WHAT_WANT         = "I have the facilities, currently, to support",
		TRADER_COMPLIMENT_DENY   = "According to customs on 34 planets I traded with, this constitutes sexual harassment.",
		TRADER_COMPLIMENT_ACCEPT = "Thank you. I needed that.",
		TRADER_INSULT_GOOD       = "No need to be upset, I believe we can do business.",
		TRADER_INSULT_BAD        = "I have traded dogs with more bark than that.",
		TRADER_BRIBE_REFUSAL     = "Uh, this is a station. I'm not going anywhere."
	)

	possible_wanted_items = list(
		/mob/living/simple_animal/tindalos                        = TRADER_THIS_TYPE,
		/mob/living/simple_animal/tomato                          = TRADER_THIS_TYPE,
		/mob/living/simple_animal/yithian                         = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/diyaab  = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/shantak = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/beast/samak   = TRADER_THIS_TYPE,
		/mob/living/simple_animal/hostile/carp                    = TRADER_THIS_TYPE
	)
	possible_trading_items = list(
		/mob/living/simple_animal/hostile/carp                    = TRADER_THIS_TYPE,
		/obj/item/dociler                                         = TRADER_THIS_TYPE,
		/obj/item/beartrap			                              = TRADER_THIS_TYPE,
		/obj/item/scanner/xenobio                                 = TRADER_THIS_TYPE
	)

/datum/trader/medical
	name = "Medical Supplier"
	origin = "Infirmary of CSV Iniquity"
	trade_flags = TRADER_GOODS | TRADER_MONEY | TRADER_WANTED_ONLY
	want_multiplier = 1.2
	margin = 2
	possible_origins = list(
		"Dr.Krieger's Practice",
		"Legit Medical Supplies (No Refunds)",
		"Mom's & Pop's Addictive Opoids",
		"Legitimate Pharmaceutical Firm",
		"Designer Drugs by Lil Xanny"
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Huh? How'd you get this number?! Oh well, if you wanna talk biz, I'm listening.",
		TRADER_HAIL_DENY         = "This is an automated message. Feel free to fuck the right off after the buzzer. *buzz*",
		TRADER_TRADE_COMPLETE    = "Good to have business with ya. Remember, no refunds.",
		TRADER_NO_BLACKLISTED    = "Whoa whoa, I don't want this shit, put it away.",
		TRADER_FOUND_UNWANTED    = "What the hell do you expect me to do with this junk?",
		TRADER_NOT_ENOUGH        = "Sorry, pal, full payment upfront, I don't write the rules. Well, I do, but that's beside the point.",
		TRADER_HOW_MUCH          = "Hmm, this is one damn fine item, but I'll part with it for " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_WHAT_WANT         = "I could always use some fucking",
		TRADER_COMPLIMENT_DENY   = "Haha, how nice of you. Why don't you go fall in an elevator shaft.",
		TRADER_COMPLIMENT_ACCEPT = "Damn right I'm awesome, tell me more.",
		TRADER_INSULT_GOOD       = "Damn, pal, no need to get snippy.",
		TRADER_INSULT_BAD        = "*muffled laughter* Sorry, was that you trying to talk shit? Adorable.",
		TRADER_BRIBE_REFUSAL     = "Man I live here, I'm not leaving anytime soon."
	)

	possible_wanted_items = list(
		/obj/item/chems/drinks/bottle    = TRADER_THIS_TYPE,
		/obj/item/organ/internal/liver   = TRADER_THIS_TYPE,
		/obj/item/organ/internal/kidneys = TRADER_THIS_TYPE,
		/obj/item/organ/internal/lungs   = TRADER_THIS_TYPE,
		/obj/item/organ/internal/heart   = TRADER_THIS_TYPE,
		/obj/item/box/fancy/cigarettes   = TRADER_ALL
	)

	possible_trading_items = list(
		/obj/item/pill_bottle                   = TRADER_SUBTYPES_ONLY,
		/obj/item/firstaid/fire                 = TRADER_THIS_TYPE,
		/obj/item/firstaid/toxin                = TRADER_THIS_TYPE,
		/obj/item/firstaid/adv                  = TRADER_THIS_TYPE,
		/obj/item/box/bloodpacks                = TRADER_THIS_TYPE,
		/obj/item/chems/ivbag                   = TRADER_SUBTYPES_ONLY,
		/obj/item/retractor                     = TRADER_THIS_TYPE,
		/obj/item/hemostat                      = TRADER_THIS_TYPE,
		/obj/item/cautery                       = TRADER_THIS_TYPE,
		/obj/item/surgicaldrill                 = TRADER_THIS_TYPE,
		/obj/item/scalpel                       = TRADER_THIS_TYPE,
		/obj/item/incision_manager              = TRADER_THIS_TYPE,
		/obj/item/circular_saw                  = TRADER_THIS_TYPE,
		/obj/item/bonegel                       = TRADER_THIS_TYPE,
		/obj/item/bonesetter                    = TRADER_THIS_TYPE,
		/obj/item/chems/glass/bottle/stabilizer = TRADER_THIS_TYPE,
		/obj/item/chems/glass/bottle/sedatives  = TRADER_THIS_TYPE,
		/obj/item/chems/glass/bottle/antitoxin  = TRADER_THIS_TYPE,
		/obj/item/bodybag/cryobag               = TRADER_THIS_TYPE,
		/obj/item/sign/diploma/fake             = TRADER_THIS_TYPE
	)

/datum/trader/mining
	name = "Rock'n'Drill Mining Inc"
	origin = "Automated Smelter AH-532"
	trade_flags = TRADER_GOODS | TRADER_MONEY | TRADER_WANTED_ONLY | TRADER_WANTED_ALL
	want_multiplier = 1.5
	margin = 2
	possible_origins = list(
		"Automated Smelter AH-532",
		"CMV Locust",
		"The Galactic Foundry Company",
		"Crucible LLC"
	)
	speech = list(
		TRADER_HAIL_GENERIC      = "Welcome to R'n'D Mining. Please place your order.",
		TRADER_HAIL_DENY         = "There is no response on the line.",
		TRADER_TRADE_COMPLETE    = "Transaction complete. Please use our services again",
		TRADER_NO_BLACKLISTED    = "Whoa whoa, I don't want this shit, put it away.",
		TRADER_FOUND_UNWANTED    = "Sorry, we are currently not looking to purchase these items.",
		TRADER_NOT_ENOUGH        = "Sorry, this is an insufficient sum for this purchase.",
		TRADER_HOW_MUCH          = "For ONE entry of " + TRADER_TOKEN_ITEM + " the price would be " + TRADER_TOKEN_VALUE + " " + TRADER_TOKEN_CURRENCY + ".",
		TRADER_WHAT_WANT         = "We are currently looking to procure",
		TRADER_COMPLIMENT_DENY   = "I am afraid this is beyond my competency.",
		TRADER_COMPLIMENT_ACCEPT = "Thank you.",
		TRADER_INSULT_GOOD       = "Alright, we will reconsider the terms.",
		TRADER_INSULT_BAD        = "This is not acceptable, please cease.",
		TRADER_BRIBE_REFUSAL     = "This facility is not mobile. Payment is unnecessary."
	)

	possible_wanted_items = list(
		/obj/item/stack/material/ore                                    = TRADER_SUBTYPES_ONLY,
		/obj/item/disk/survey                                           = TRADER_THIS_TYPE,
		/obj/item/stack/material/ore/slag                               = TRADER_BLACKLIST
	)

	possible_trading_items = list(
		/obj/machinery/mining/drill                                     = TRADER_THIS_TYPE,
		/obj/machinery/mining/brace                                     = TRADER_THIS_TYPE,
		/obj/machinery/floodlight                                       = TRADER_THIS_TYPE,
		/obj/item/box/greenglowsticks                                   = TRADER_THIS_TYPE,
		/obj/item/clothing/suit/space/void/engineering/salvage/prepared = TRADER_THIS_TYPE,
		/obj/item/stack/material/puck/mapped/uranium/ten                = TRADER_THIS_TYPE,
		/obj/item/stack/material/sheet/reinforced/mapped/plasteel/fifty = TRADER_THIS_TYPE,
		/obj/item/stack/material/sheet/mapped/steel/fifty               = TRADER_THIS_TYPE,
		/obj/item/stack/material/ingot/mapped/copper/fifty              = TRADER_THIS_TYPE
	)
