
/datum/gear/shoes
	sort_category = "Shoes and Footwear"
	slot = slot_shoes_str
	category = /datum/gear/shoes

/datum/gear/shoes/athletic
	display_name = "athletic shoes, colour select"
	path = /obj/item/clothing/shoes/athletic
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/boots
	display_name = "boot selection"
	path = /obj/item/clothing/shoes
	cost = 2

/datum/gear/shoes/boots/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/jackboots/duty,
		/obj/item/clothing/shoes/jackboots/jungleboots,
		/obj/item/clothing/shoes/jackboots/desertboots
	)

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes

/datum/gear/shoes/color/get_gear_tweak_options()
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

/datum/gear/shoes/flats
	display_name = "flats, colour select"
	path = /obj/item/clothing/shoes/flats
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/high
	display_name = "high tops selection"
	path = /obj/item/clothing/shoes/color/hightops
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/shoes/sandal
	display_name = "wooden sandals"
	path = /obj/item/clothing/shoes/sandal

/datum/gear/shoes/heels
	display_name = "high heels, colour select"
	path = /obj/item/clothing/shoes/heels
	flags = GEAR_HAS_COLOR_SELECTION