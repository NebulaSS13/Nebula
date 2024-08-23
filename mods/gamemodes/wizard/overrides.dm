/datum/trader/ship/unique/wizard/New()
	LAZYSET(possible_wanted_items, /mob/living/simple_animal/familiar,     TRADER_SUBTYPES_ONLY)
	LAZYSET(possible_wanted_items, /mob/living/simple_animal/familiar/pet, TRADER_BLACKLIST)
