
/datum/gear/accessory
	sort_category = "Accessories"
	category = /datum/gear/accessory
	slot = slot_tie

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

/datum/gear/accessory/tie/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue tie" =       /obj/item/clothing/accessory/blue,
		"red tie" =        /obj/item/clothing/accessory/red,
		"blue tie, clip" = /obj/item/clothing/accessory/blue_clip,
		"red long tie" =   /obj/item/clothing/accessory/red_long,
		"black tie" =      /obj/item/clothing/accessory/black,
		"yellow tie" =     /obj/item/clothing/accessory/yellow,
		"navy tie" =       /obj/item/clothing/accessory/navy,
		"horrible tie" =   /obj/item/clothing/accessory/horrible,
		"brown tie" =      /obj/item/clothing/accessory/brown
	)

/datum/gear/accessory/tie_color
	display_name = "colored tie"
	path = /obj/item/clothing/accessory
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie_color/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"tie" =         /obj/item/clothing/accessory,
		"striped tie" = /obj/item/clothing/accessory/long
	)

/datum/gear/accessory/locket
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/necklace
	display_name = "necklace, colour select"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/bowtie
	display_name = "bowtie, horrible"
	path = /obj/item/clothing/accessory/bowtie/ugly

/datum/gear/accessory/bowtie/color
	display_name = "bowtie, colour select"
	path = /obj/item/clothing/accessory/bowtie/color
	flags = GEAR_HAS_COLOR_SELECTION

//have to break up armbands to restrict access
/datum/gear/accessory/armband_security
	display_name = "security armband"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband_cargo
	display_name = "cargo armband"
	path = /obj/item/clothing/accessory/armband/cargo

/datum/gear/accessory/armband_medical
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/med

/datum/gear/accessory/armband_engineering
	display_name = "engineering armband"
	path = /obj/item/clothing/accessory/armband/engine

/datum/gear/accessory/ftupin
	display_name = "Free Trade Union pin"
	path = /obj/item/clothing/accessory/ftupin

/datum/gear/accessory/bracelet
	display_name = "bracelet, color select"
	path = /obj/item/clothing/accessory/bracelet
	cost = 1
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/charge_stick
	display_name = "charge stick"
	path = /obj/item/charge_stick
	cost = 1

/datum/gear/accessory/charge_stick/get_gear_tweak_options()
	. = ..() | /datum/gear_tweak/charge_stick