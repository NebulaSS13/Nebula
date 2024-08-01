/decl/loadout_category/eyes
	name = "Eyewear"

/decl/loadout_option/eyes
	category = /decl/loadout_category/eyes
	abstract_type = /decl/loadout_option/eyes
	slot = slot_glasses_str

/decl/loadout_option/eyes/eyepatch
	name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	uid = "gear_eyes_eyepatch"

/decl/loadout_option/eyes/eyepatch_colourable
	name = "eyepatch, colourable"
	path = /obj/item/clothing/glasses/eyepatch/colourable
	uid = "gear_eyes_eyepatch_colourable"

/decl/loadout_option/eyes/glasses
	name = "glasses selection"
	path = /obj/item/clothing/glasses
	uid = "gear_eyes_glasses"

/decl/loadout_option/eyes/glasses/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"prescription glasses" = /obj/item/clothing/glasses/prescription,
		"green glasses" =        /obj/item/clothing/glasses/prescription/gglasses,
		"hipster glasses" =      /obj/item/clothing/glasses/prescription/hipster,
		"pince-nez glasses" =    /obj/item/clothing/glasses/prescription/pincenez,
		"monocle" =              /obj/item/clothing/glasses/eyepatch/monocle
	)

/decl/loadout_option/eyes/shades
	name = "sunglasses selection"
	path = /obj/item/clothing/glasses/sunglasses
	cost = 3
	uid = "gear_eyes_shades"

/decl/loadout_option/eyes/shades/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"sunglasses, big" =         /obj/item/clothing/glasses/sunglasses/big,
		"sunglasses, presciption" = /obj/item/clothing/glasses/sunglasses/prescription
	)

/decl/loadout_option/eyes/blindfold
	name = "blindfold"
	path = /obj/item/clothing/glasses/blindfold
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_eyes_blindfold"
