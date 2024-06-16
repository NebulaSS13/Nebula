/datum/trader/ship/vox
	typical_duration = 60
	origin = "UNREGISTERED VESSEL"
	name_language = /decl/language/vox
	compliment_increase = 0
	trade_flags = TRADER_GOODS | TRADER_BRIBABLE
	blacklisted_trade_items = null

	speech = list(
		TRADER_HAIL_GENERIC      = "SKREEE! We will trade good stuff, yes?",
		TRADER_HAIL_DENY         = "Trade closed, GO AWAY!",
		TRADER_TRADE_COMPLETE    = "Yes, kikikikikiki! You will not regret this trade!",
		TRADER_NO_MONEY          = "Money? It does not need money. GOODS! Give it GOODS!",
		TRADER_NOT_ENOUGH        = "It wants MORE for that. Give it more.",
		TRADER_HOW_MUCH          = "You give it something worth VALUE, yes?",
		TRADER_WHAT_WANT         = "It wants",
		TRADER_COMPLIMENT_DENY   = "No.",
		TRADER_COMPLIMENT_ACCEPT = "Kikikikiki! Trade is better than talk, yes?",
		TRADER_INSULT_GOOD       = "Bah! Why does it have to deal with you?",
		TRADER_INSULT_BAD        = "All you meat is the same! Fuck the off!",
		TRADER_BRIBE_ACCEPT      = "Skhhhhhk... fine. " + TRADER_TOKEN_TIME + " minutes, no more!",
		TRADER_BRIBE_REFUSAL     = "No! It is getting impatient with this meat!"
	)

	var/hailed_vox = FALSE //Whether we have been hailed by a vox. negatives mean pariah, positives mean regular.
	var/list/visited_vox_speech = list(
		TRADER_HAIL_GENERIC      = "SKREEEEE! You friend of the Shoal? You trade with, yes?",
		TRADER_HAIL_SILICON      = "YOU KNOW THE SHOAL? Yes is good, yes yes, " + TRADER_TOKEN_MOB + ". Trade GOOD!",
		TRADER_HAIL_DENY         = "Trade gone now. Goodbye.",
		TRADER_TRADE_COMPLETE    = "Yes... this is a good trade for the Shoal!",
		TRADER_NO_MONEY          = "You know as well as it that money is no good.",
		TRADER_NOT_ENOUGH        = "Ech, you insult it with such a trade? Respect it, make it equal.",
		TRADER_HOW_MUCH          = "Hmm.... VALUE. Something like that.",
		TRADER_WHAT_WANT         = "We need",
		TRADER_COMPLIMENT_DENY   = "You know better than that!",
		TRADER_COMPLIMENT_ACCEPT = "You butter it up? Should know better than that.",
		TRADER_INSULT_GOOD       = "Where this come from? Is trade no good?",
		TRADER_INSULT_BAD        = "If you say all this at home, you be dead!",
		TRADER_BRIBE_ACCEPT      = "It can stay for " + TRADER_TOKEN_TIME + " minutes, for most beloved kin as you.",
		TRADER_BRIBE_REFUSAL     = "Krrkkrhkkhh! You ask too much! It must be moving on."
	)
	possible_wanted_items = list(
		/obj/item                       = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/material        = TRADER_SUBTYPES_ONLY,
		/obj/item/stack/material/cyborg = TRADER_BLACKLIST_ALL,
		/obj/item/organ                 = TRADER_SUBTYPES_ONLY,
	)

	possible_trading_items = list(
		/obj/item/gun/projectile/dartgun/vox      = TRADER_SUBTYPES_ONLY,
		/obj/item/trash                           = TRADER_SUBTYPES_ONLY,
		/obj/item/remains                         = TRADER_ALL,
		/obj/item/clothing/armor_attachment/plate = TRADER_ALL,
		/obj/item/clothing/webbing                = TRADER_ALL,
		/obj/item/clothing/sensor                 = TRADER_ALL,
		/obj/item/robot_parts                     = TRADER_SUBTYPES_ONLY,
		/obj/item/robot_parts/robot_component     = TRADER_BLACKLIST
	)

	mob_transfer_message = "<span class='danger'>You are transported to " + TRADER_TOKEN_ORIGIN + ". When the transportation dizziness wears off, you find you are surrounded by cackling vox...</span>"

/datum/trader/ship/vox/New()
	speech[TRADER_HAIL_SILICON] = "Hello metal thing! You trade metal for things?"
	speech[TRADER_HAIL_START + SPECIES_HUMAN] = "Hello hueman! Kiikikikiki! " + TRADER_TOKEN_MOB + " trade with us, yes? Good!"
	visited_vox_speech[TRADER_HAIL_START + SPECIES_HUMAN] = "Friend of it is friend of all Shoal! " + TRADER_TOKEN_MOB + " you trade now!"
	visited_vox_speech[TRADER_HAIL_START + SPECIES_VOX] = "SKREEEE! May the Shoal make this trade good, " + TRADER_TOKEN_MOB + "!"
	..()

/datum/trader/ship/vox/hail(var/mob/user)
	if(ishuman(user))
		var/mob/living/human/H = user
		if(H.species)
			switch(H.species.name)
				if(SPECIES_VOX)
					disposition = 1000
					hailed_vox = TRUE
					speech = visited_vox_speech
	. = ..()

/datum/trader/ship/vox/can_hail()
	if(hailed_vox >= 0)
		return ..()
	return FALSE

/datum/trader/ship/vox/get_item_value(var/trading_num)
	. = ..()
	if(!hailed_vox)
		. *= 2

/datum/trader/ship/clothingshop/New()
	speech[TRADER_HAIL_START + SPECIES_VOX] = "Well hello, sir! I don't believe we have any clothes that fit you... but you can still look!"
	..()
