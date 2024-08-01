/decl/loadout_category/feet
	name = "Footwear"

/decl/loadout_option/shoes
	slot = slot_shoes_str
	category = /decl/loadout_category/feet
	abstract_type = /decl/loadout_option/shoes

/decl/loadout_option/shoes/athletic
	name = "athletic shoes, color select"
	path = /obj/item/clothing/shoes/athletic
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_shoes_athletic"

/decl/loadout_option/shoes/boots
	name = "boot selection"
	path = /obj/item/clothing/shoes
	cost = 2
	uid = "gear_shoes_boots"

/decl/loadout_option/shoes/boots/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/jackboots/duty,
		/obj/item/clothing/shoes/jackboots/jungleboots,
		/obj/item/clothing/shoes/jackboots/desertboots
	)

/decl/loadout_option/shoes/color
	name = "shoe selection"
	path = /obj/item/clothing/shoes
	uid = "gear_shoes_color"

/decl/loadout_option/shoes/color/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/shoes/color/black,
		/obj/item/clothing/shoes/color/blue,
		/obj/item/clothing/shoes/color/brown,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/shoes/dress/white,
		/obj/item/clothing/shoes/color/green,
		/obj/item/clothing/shoes/craftable,
		/obj/item/clothing/shoes/color/orange,
		/obj/item/clothing/shoes/color/purple,
		/obj/item/clothing/shoes/rainbow,
		/obj/item/clothing/shoes/color/red,
		/obj/item/clothing/shoes/color/white,
		/obj/item/clothing/shoes/color/yellow
	)

/decl/loadout_option/shoes/flats
	name = "flats, color select"
	path = /obj/item/clothing/shoes/flats
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_shoes_flats"

/decl/loadout_option/shoes/high
	name = "high tops selection"
	path = /obj/item/clothing/shoes/color/hightops
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_shoes_high_tops"

/decl/loadout_option/shoes/sandal
	name = "wooden sandals"
	path = /obj/item/clothing/shoes/sandal
	uid = "gear_shoes_sandals"

/decl/loadout_option/shoes/heels
	name = "high heels, color select"
	path = /obj/item/clothing/shoes/heels
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_shoes_heels"
