/decl/loadout_category/tactical
	name = "Tactical"
	
/decl/loadout_option/tactical
	category = /decl/loadout_category/tactical
	slot = slot_tie_str

/decl/loadout_option/tactical/armor_deco
	display_name = "armor customization"
	path = /obj/item/clothing/accessory/armor/tag
	flags = GEAR_HAS_SUBTYPE_SELECTION

/decl/loadout_option/tactical/helm_covers
	display_name = "helmet covers"
	path = /obj/item/clothing/accessory/armor/helmcover
	flags = GEAR_HAS_SUBTYPE_SELECTION

/decl/loadout_option/tactical/kneepads
	display_name = "kneepads"
	path = /obj/item/clothing/accessory/kneepads

/decl/loadout_option/tactical/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/storage/holster
	cost = 3

/decl/loadout_option/tactical/holster/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= typesof(/obj/item/clothing/accessory/storage/holster) - typesof(/obj/item/clothing/accessory/storage/holster/machete)

/decl/loadout_option/tactical/sheath
	display_name = "machete sheath"
	path = /obj/item/clothing/accessory/storage/holster/machete

/decl/loadout_option/tactical/knife_sheath
	display_name = "knife sheath selection"
	description = "A leg strapped knife sheath."
	path = /obj/item/clothing/accessory/storage/holster/knife
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/tactical/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool
	slot = slot_w_uniform_str
