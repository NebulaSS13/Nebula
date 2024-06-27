/decl/loadout_category/clothing
	name = "Clothing"

/decl/loadout_option/clothing
	category = /decl/loadout_category/clothing
	abstract_type = /decl/loadout_option/clothing
	slot = slot_w_uniform_str

/decl/loadout_option/clothing/flannel
	name = "flannel (colorable)"
	path = /obj/item/clothing/shirt/flannel
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/scarf
	name = "scarf"
	path = /obj/item/clothing/neck/scarf
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/hawaii
	name = "hawaii shirt"
	path = /obj/item/clothing/shirt/hawaii

/decl/loadout_option/clothing/hawaii/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue hawaii shirt" =           /obj/item/clothing/shirt/hawaii,
		"red hawaii shirt" =            /obj/item/clothing/shirt/hawaii/red,
		"random colored hawaii shirt" = /obj/item/clothing/shirt/hawaii/random
	)

/decl/loadout_option/clothing/vest
	name = "suit vest, colour select"
	path = /obj/item/clothing/suit/jacket/vest
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	slot = slot_wear_suit_str

/decl/loadout_option/clothing/suspenders
	name = "suspenders"
	path = /obj/item/clothing/suspenders

/decl/loadout_option/clothing/suspenders/colorable
	name = "suspenders, colour select"
	path = /obj/item/clothing/suspenders/colorable
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/wcoat
	name = "waistcoat, colour select"
	path = /obj/item/clothing/suit/jacket/waistcoat
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	slot = slot_wear_suit_str

/decl/loadout_option/clothing/zhongshan
	name = "zhongshan jacket, colour select"
	path = /obj/item/clothing/suit/jacket/zhongshan
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	slot = slot_wear_suit_str

/decl/loadout_option/clothing/dashiki
	name = "dashiki selection"
	path = /obj/item/clothing/suit/dashiki
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	slot = slot_wear_suit_str

/decl/loadout_option/clothing/thawb
	name = "thawb"
	path = /obj/item/clothing/suit/robe/thawb
	slot = slot_wear_suit_str

/decl/loadout_option/clothing/sherwani
	name = "sherwani, colour select"
	path = /obj/item/clothing/suit/robe/sherwani
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	slot = slot_wear_suit_str

/decl/loadout_option/clothing/qipao
	name = "qipao blouse, colour select"
	path = /obj/item/clothing/shirt/qipao
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/sweater
	name = "turtleneck sweater, colour select"
	path = /obj/item/clothing/shirt/sweater
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/clothing/tangzhuang
	name = "tangzhuang jacket, colour select"
	path = /obj/item/clothing/suit/jacket/tangzhuang
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	slot = slot_wear_suit_str
