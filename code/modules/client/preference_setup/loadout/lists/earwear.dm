// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the BP_R_EAR  or BP_L_EAR as the slot, or else players will spawn with no headset.
/datum/gear/earrings
	display_name = "earrings"
	slot = BP_L_EAR
	path = /obj/item/clothing/ears/earring
	sort_category = "Earwear"

/datum/gear/earrings/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"stud, pearl" =      /obj/item/clothing/ears/earring/stud,
		"stud, glass" =      /obj/item/clothing/ears/earring/stud/glass,
		"stud, wood" =       /obj/item/clothing/ears/earring/stud/wood,
		"stud, iron" =       /obj/item/clothing/ears/earring/stud/iron,
		"stud, steel" =      /obj/item/clothing/ears/earring/stud/steel,
		"stud, silver" =     /obj/item/clothing/ears/earring/stud/silver,
		"stud, gold" =       /obj/item/clothing/ears/earring/stud/gold,
		"stud, platinum" =   /obj/item/clothing/ears/earring/stud/platinum,
		"stud, diamond" =    /obj/item/clothing/ears/earring/stud/diamond,
		"dangle, glass" =    /obj/item/clothing/ears/earring/dangle/glass,
		"dangle, wood" =     /obj/item/clothing/ears/earring/dangle/wood,
		"dangle, iron" =     /obj/item/clothing/ears/earring/dangle/iron,
		"dangle, steel" =    /obj/item/clothing/ears/earring/dangle/steel,
		"dangle, silver" =   /obj/item/clothing/ears/earring/dangle/silver,
		"dangle, gold" =     /obj/item/clothing/ears/earring/dangle/gold,
		"dangle, platinum" = /obj/item/clothing/ears/earring/dangle/platinum,
		"dangle, diamond" =  /obj/item/clothing/ears/earring/dangle/diamond
	)
