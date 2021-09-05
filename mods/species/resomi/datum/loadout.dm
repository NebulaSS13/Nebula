/decl/loadout_category/resomi
	name = "Resomi"

/decl/loadout_option/resomi
	category = /decl/loadout_category/resomi
	whitelisted   = list(SPECIES_RESOMI)
	category      = /decl/loadout_category/resomi
	slot          = slot_w_uniform_str

//Uniforms

/decl/loadout_option/resomi/uniform_selection
	name = "resomi uniform selection"
	path         = /obj/item/clothing/under/resomi

/decl/loadout_option/resomi/uniform_selection/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"grey smock"        = /obj/item/clothing/under/resomi/simple,
		"rainbow smock"     = /obj/item/clothing/under/resomi/rainbow,
		"engineering smock" = /obj/item/clothing/under/resomi/engine,
		"medical smock"     = /obj/item/clothing/under/resomi/medical,
		"security smock"    = /obj/item/clothing/under/resomi/security,
		"science smock"     = /obj/item/clothing/under/resomi/science,
		"command uniform"   = /obj/item/clothing/under/resomi/command,
		"stylish uniform"   = /obj/item/clothing/under/resomi/stylish_command,
		"gray uniform"      = /obj/item/clothing/under/resomi/gray_utility,
		"black uniform"     = /obj/item/clothing/under/resomi/black_utility
	)

/decl/loadout_option/resomi/uniform_color
	name = "colorable resomi jumpsuit"
	path         = /obj/item/clothing/under/resomi
	flags        = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/resomi/space
	name = "resomi pressure suit"
	path         = /obj/item/clothing/under/resomi/space

/decl/loadout_option/resomi/polychromic_cloak
	name = "resomi polychromic cloak"
	path         = /obj/item/clothing/suit/storage/hooded/polychromic
	flags        = GEAR_HAS_COLOR_SELECTION
	slot         = slot_wear_suit_str

/decl/loadout_option/resomi/shoes
	name = "resomi footwear selection"
	path         = /obj/item/clothing/shoes/resomi
	flags        = GEAR_HAS_COLOR_SELECTION
	slot         = slot_shoes_str

/decl/loadout_option/resomi/shoes/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"koishi"      = /obj/item/clothing/shoes/resomi/footwraps/socks_resomi,
		"footwraps"   = /obj/item/clothing/shoes/resomi/footwraps,
		"small shoes" = /obj/item/clothing/shoes/resomi
	)

//toys

/decl/loadout_option/plush_toy/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"resomi brown plush"  = /obj/item/toy/plushie/resomi_plush,
		"resomi black plush"  = /obj/item/toy/plushie/resomi_plush/black,
		"resomi yellow plush" = /obj/item/toy/plushie/resomi_plush/yellow,
		"resomi white plush"  = /obj/item/toy/plushie/resomi_plush/white,
		"resomi grey plush"   = /obj/item/toy/plushie/resomi_plush/grey
	)