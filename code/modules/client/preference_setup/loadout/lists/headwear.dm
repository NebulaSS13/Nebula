/datum/gear/head
	sort_category = "Hats and Headwear"
	slot = slot_head
	category = /datum/gear/head

/datum/gear/head/beret
	display_name = "beret, colour select"
	path = /obj/item/clothing/head/beret/plaincolor
	flags = GEAR_HAS_COLOR_SELECTION
	description = "A simple, solid color beret. This one has no emblems or insignia on it."

/datum/gear/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing

/datum/gear/head/bandana/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= typesof(/obj/item/clothing/mask/bandana) + typesof(/obj/item/clothing/head/bandana)

/datum/gear/head/beanie
	display_name = "beanie, color select"
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/bow
	display_name = "hair bow, colour select"
	path = /obj/item/clothing/head/hairflower/bow
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/flat_cap
	display_name = "flat cap, colour select"
	path = /obj/item/clothing/head/flatcap
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head

/datum/gear/head/cap/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"black cap" =   /obj/item/clothing/head/soft/black,
		"blue cap" =    /obj/item/clothing/head/soft/blue,
		"green cap" =   /obj/item/clothing/head/soft/green,
		"grey cap" =    /obj/item/clothing/head/soft/grey,
		"mailman cap" = /obj/item/clothing/head/mailman,
		"orange cap" =  /obj/item/clothing/head/soft/orange,
		"purple cap" =  /obj/item/clothing/head/soft/purple,
		"rainbow cap" = /obj/item/clothing/head/soft/rainbow,
		"red cap" =     /obj/item/clothing/head/soft/red,
		"white cap" =   /obj/item/clothing/head/soft/mime,
		"yellow cap" =  /obj/item/clothing/head/soft/yellow
	)

/datum/gear/head/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower

/datum/gear/head/hairflower/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue pin" =   /obj/item/clothing/head/hairflower/blue,
		"pink pin" =   /obj/item/clothing/head/hairflower/pink,
		"red pin" =    /obj/item/clothing/head/hairflower,
		"yellow pin" = /obj/item/clothing/head/hairflower/yellow
	)

/datum/gear/head/hardhat
	display_name = "hardhat selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/datum/gear/head/hardhat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue hardhat" =                                      /obj/item/clothing/head/hardhat/dblue,
		"orange hardhat" =                                    /obj/item/clothing/head/hardhat/orange,
		"red hardhat" =                                       /obj/item/clothing/head/hardhat/red,
		"light damage control helmet" =                       /obj/item/clothing/head/hardhat/EMS/DC_light,
		"Emergency Management Bureau helmet" =                /obj/item/clothing/head/hardhat/damage_control/EMB,
		"red ancient Emergency Management Bureau helmet" =    /obj/item/clothing/head/hardhat/damage_control/EMB_Ancient,
		"yellow ancient Emergency Management Bureau helmet" = /obj/item/clothing/head/hardhat/damage_control/EMB_Ancient/yellow,
		"white ancient Emergency Management Bureau helmet" =  /obj/item/clothing/head/hardhat/damage_control/EMB_Ancient/white
	)

/datum/gear/head/formalhat
	display_name = "formal hat selection"
	path = /obj/item/clothing/head

/datum/gear/head/formalhat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"boatsman hat" =   /obj/item/clothing/head/boaterhat,
		"bowler hat" =     /obj/item/clothing/head/bowler,
		"fedora" =         /obj/item/clothing/head/fedora,
		"feather trilby" = /obj/item/clothing/head/feathertrilby,
		"fez" =            /obj/item/clothing/head/fez,
		"top hat" =        /obj/item/clothing/head/that,
		"fedora, brown" =  /obj/item/clothing/head/det,
		"fedora, grey" =   /obj/item/clothing/head/det/grey,
	)

/datum/gear/head/informalhat
	display_name = "informal hat selection"
	path = /obj/item/clothing/head

/datum/gear/head/informalhat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"cowboy hat" = /obj/item/clothing/head/cowboy_hat,
		"ushanka" =    /obj/item/clothing/head/ushanka
	)

/datum/gear/head/hijab
	display_name = "hijab, colour select"
	path = /obj/item/clothing/head/hijab
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/kippa
	display_name = "kippa, colour select"
	path = /obj/item/clothing/head/kippa
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/turban
	display_name = "turban, colour select"
	path = /obj/item/clothing/head/turban
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/taqiyah
	display_name = "taqiyah, colour select"
	path = /obj/item/clothing/head/taqiyah
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/rastacap
	display_name = "rastacap"
	path = /obj/item/clothing/head/rastacap

/datum/gear/head/surgical
	display_name = "standard surgical caps"
	path = /obj/item/clothing/head/surgery
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/head/surgical/custom
	display_name = "surgical cap, colour select"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/welding
	display_name = "welding mask selection"
	path = /obj/item/clothing/head/welding

/datum/gear/head/welding/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/head/welding/demon,
		/obj/item/clothing/head/welding/engie,
		/obj/item/clothing/head/welding/fancy,
		/obj/item/clothing/head/welding/knight,
		/obj/item/clothing/head/welding/carp
	)

/datum/gear/head/tankccap
	display_name = "padded cap"
	path = /obj/item/clothing/head/tank

/datum/gear/tactical/balaclava
	display_name = "balaclava"
	path = /obj/item/clothing/mask/balaclava
