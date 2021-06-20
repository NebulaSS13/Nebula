/decl/loadout_category/clothing
	name = "Clothing"

/decl/loadout_option/clothing
	category = /decl/loadout_category/clothing
	slot = slot_tie_str

/decl/loadout_option/clothing/flannel
	display_name = "flannel (colorable)"
	path = /obj/item/clothing/accessory/toggleable/flannel
	slot = slot_tie_str
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/scarf
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/toggleable/hawaii

/decl/loadout_option/clothing/hawaii/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue hawaii shirt" =           /obj/item/clothing/accessory/toggleable/hawaii,
		"red hawaii shirt" =            /obj/item/clothing/accessory/toggleable/hawaii/red,
		"random colored hawaii shirt" = /obj/item/clothing/accessory/toggleable/hawaii/random
	)

/decl/loadout_option/clothing/vest
	display_name = "suit vest, colour select"
	path = /obj/item/clothing/accessory/toggleable
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders

/decl/loadout_option/clothing/suspenders/colorable
	display_name = "suspenders, colour select"
	path = /obj/item/clothing/accessory/suspenders/colorable
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/wcoat
	display_name = "waistcoat, colour select"
	path = /obj/item/clothing/accessory/wcoat
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/zhongshan
	display_name = "zhongshan jacket, colour select"
	path = /obj/item/clothing/accessory/toggleable/zhongshan
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/dashiki
	display_name = "dashiki selection"
	path = /obj/item/clothing/accessory/dashiki
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/clothing/thawb
	display_name = "thawb"
	path = /obj/item/clothing/accessory/thawb

/decl/loadout_option/clothing/sherwani
	display_name = "sherwani, colour select"
	path = /obj/item/clothing/accessory/sherwani
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/qipao
	display_name = "qipao blouse, colour select"
	path = /obj/item/clothing/accessory/qipao
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/sweater
	display_name = "turtleneck sweater, colour select"
	path = /obj/item/clothing/accessory/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/tangzhuang
	display_name = "tangzhuang jacket, colour select"
	path = /obj/item/clothing/accessory/tangzhuang
	flags = GEAR_HAS_COLOR_SELECTION