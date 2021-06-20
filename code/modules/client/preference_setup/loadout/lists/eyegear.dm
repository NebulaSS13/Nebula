/decl/loadout_category/eyes
	name = "Eyewear"
	
/decl/loadout_option/eyes
	category = /decl/loadout_category/eyes
	slot = slot_glasses_str

/decl/loadout_option/eyes/glasses
	display_name = "prescription glasses"
	path = /obj/item/clothing/glasses/prescription

/decl/loadout_option/eyes/eyepatch
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch

/decl/loadout_option/eyes/fashionglasses
	display_name = "glasses"
	path = /obj/item/clothing/glasses

/decl/loadout_option/eyes/fashionglasses/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"green glasses" =    /obj/item/clothing/glasses/prescription/gglasses,
		"hipster glasses" =  /obj/item/clothing/glasses/prescription/hipster,
		"monocle" =          /obj/item/clothing/glasses/eyepatch/monocle,
		"scanning goggles" = /obj/item/clothing/glasses/prescription/scanners
	)

/decl/loadout_option/eyes/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/decl/loadout_option/eyes/sciencegoggles/ipatch
	display_name = "HUDpatch, Science"
	path = /obj/item/clothing/glasses/eyepatch/hud/science
	cost = 2

/decl/loadout_option/eyes/sciencegoggles/prescription
	display_name = "Science Goggles, prescription"
	path = /obj/item/clothing/glasses/science/prescription

/decl/loadout_option/eyes/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security

/decl/loadout_option/eyes/security/prescription
	display_name = "Security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription

/decl/loadout_option/eyes/security/sunglasses
	display_name = "Security HUD Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/decl/loadout_option/eyes/security/aviators
	display_name = "Security HUD Aviators"
	path = /obj/item/clothing/glasses/sunglasses/sechud/toggle

/decl/loadout_option/eyes/security/ipatch
	display_name = "HUDpatch, Security"
	path = /obj/item/clothing/glasses/eyepatch/hud/security
	cost = 2

/decl/loadout_option/eyes/medical
	display_name = "Medical HUD"
	path = /obj/item/clothing/glasses/hud/health

/decl/loadout_option/eyes/medical/prescription
	display_name = "Medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription

/decl/loadout_option/eyes/medical/visor
	display_name = "Medical HUD, Visor"
	path = /obj/item/clothing/glasses/hud/health/visor
	cost = 2

/decl/loadout_option/eyes/medical/ipatch
	display_name = "HUDpatch, Medical"
	path = /obj/item/clothing/glasses/eyepatch/hud/medical
	cost = 2

/decl/loadout_option/eyes/welding
	display_name = "Welding Goggles"
	path = /obj/item/clothing/glasses/welding

/decl/loadout_option/eyes/shades/
	display_name = "sunglasses"
	path = /obj/item/clothing/glasses/sunglasses
	cost = 3

/decl/loadout_option/eyes/shades/sunglasses
	display_name = "sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 3

/decl/loadout_option/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 3

/decl/loadout_option/eyes/hudpatch
	display_name = "iPatch"
	path = /obj/item/clothing/glasses/eyepatch/hud

/decl/loadout_option/eyes/blindfold
	display_name = "blindfold"
	path = /obj/item/clothing/glasses/blindfold
	flags = GEAR_HAS_COLOR_SELECTION
