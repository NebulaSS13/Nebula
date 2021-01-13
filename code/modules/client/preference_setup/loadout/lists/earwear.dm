// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear_str or slot_l_ear_str as the slot, or else players will spawn with no headset.
/datum/gear/earrings
	display_name = "earrings"
	path = /obj/item/clothing/ears
	sort_category = "Earwear"

/datum/gear/earrings/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"stud, pearl" =      /obj/item/clothing/ears/stud,
		"stud, glass" =      /obj/item/clothing/ears/stud/glass,
		"stud, wood" =       /obj/item/clothing/ears/stud/wood,
		"stud, iron" =       /obj/item/clothing/ears/stud/iron,
		"stud, steel" =      /obj/item/clothing/ears/stud/steel,
		"stud, silver" =     /obj/item/clothing/ears/stud/silver,
		"stud, gold" =       /obj/item/clothing/ears/stud/gold,
		"stud, platinum" =   /obj/item/clothing/ears/stud/platinum,
		"stud, diamond" =    /obj/item/clothing/ears/stud/diamond,
		"dangle, glass" =    /obj/item/clothing/ears/dangle/glass,
		"dangle, wood" =     /obj/item/clothing/ears/dangle/wood,
		"dangle, iron" =     /obj/item/clothing/ears/dangle/iron,
		"dangle, steel" =    /obj/item/clothing/ears/dangle/steel,
		"dangle, silver" =   /obj/item/clothing/ears/dangle/silver,
		"dangle, gold" =     /obj/item/clothing/ears/dangle/gold,
		"dangle, platinum" = /obj/item/clothing/ears/dangle/platinum,
		"dangle, diamond" =  /obj/item/clothing/ears/dangle/diamond
	)
