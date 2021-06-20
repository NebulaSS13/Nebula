/decl/loadout_category/head
	name = "Headwear"
	
/decl/loadout_option/head
	slot = slot_head_str
	category = /decl/loadout_category/head

/decl/loadout_option/head/beret
	display_name = "beret, colour select"
	path = /obj/item/clothing/head/beret/plaincolor
	flags = GEAR_HAS_COLOR_SELECTION
	description = "A simple, solid color beret. This one has no emblems or insignia on it."

/decl/loadout_option/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing

/decl/loadout_option/head/bandana/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= typesof(/obj/item/clothing/mask/bandana) + typesof(/obj/item/clothing/head/bandana)

/decl/loadout_option/head/beanie
	display_name = "beanie, color select"
	path = /obj/item/clothing/head/beanie
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/bow
	display_name = "hair bow, colour select"
	path = /obj/item/clothing/head/hairflower/bow
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/flat_cap
	display_name = "flat cap, colour select"
	path = /obj/item/clothing/head/flatcap
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head

/decl/loadout_option/head/cap/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"black cap" =   /obj/item/clothing/head/soft/black,
		"blue cap" =    /obj/item/clothing/head/soft/blue,
		"green cap" =   /obj/item/clothing/head/soft/green,
		"grey cap" =    /obj/item/clothing/head/soft/grey,
		"orange cap" =  /obj/item/clothing/head/soft/orange,
		"purple cap" =  /obj/item/clothing/head/soft/purple,
		"rainbow cap" = /obj/item/clothing/head/soft/rainbow,
		"red cap" =     /obj/item/clothing/head/soft/red,
		"white cap" =   /obj/item/clothing/head/soft/mime,
		"yellow cap" =  /obj/item/clothing/head/soft/yellow
	)

/decl/loadout_option/head/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower

/decl/loadout_option/head/hairflower/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue pin" =   /obj/item/clothing/head/hairflower/blue,
		"pink pin" =   /obj/item/clothing/head/hairflower/pink,
		"red pin" =    /obj/item/clothing/head/hairflower,
		"yellow pin" = /obj/item/clothing/head/hairflower/yellow
	)

/decl/loadout_option/head/hardhat
	display_name = "hardhat selection"
	path = /obj/item/clothing/head/hardhat
	cost = 2

/decl/loadout_option/head/hardhat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue hardhat" =                                      /obj/item/clothing/head/hardhat/dblue,
		"orange hardhat" =                                    /obj/item/clothing/head/hardhat/orange,
		"red hardhat" =                                       /obj/item/clothing/head/hardhat/red,
		"light damage control helmet" =                       /obj/item/clothing/head/hardhat/EMS/DC_light
	)

/decl/loadout_option/head/formalhat
	display_name = "formal hat selection"
	path = /obj/item/clothing/head

/decl/loadout_option/head/formalhat/get_gear_tweak_options()
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

/decl/loadout_option/head/informalhat
	display_name = "informal hat selection"
	path = /obj/item/clothing/head

/decl/loadout_option/head/informalhat/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"cowboy hat" = /obj/item/clothing/head/cowboy_hat,
		"ushanka" =    /obj/item/clothing/head/ushanka
	)

/decl/loadout_option/head/hijab
	display_name = "hijab, colour select"
	path = /obj/item/clothing/head/hijab
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/kippa
	display_name = "kippa, colour select"
	path = /obj/item/clothing/head/kippa
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/turban
	display_name = "turban, colour select"
	path = /obj/item/clothing/head/turban
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/taqiyah
	display_name = "taqiyah, colour select"
	path = /obj/item/clothing/head/taqiyah
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/rastacap
	display_name = "rastacap"
	path = /obj/item/clothing/head/rastacap

/decl/loadout_option/head/surgical
	display_name = "standard surgical caps"
	path = /obj/item/clothing/head/surgery
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/head/surgical/custom
	display_name = "surgical cap, colour select"
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/head/welding
	display_name = "welding mask selection"
	path = /obj/item/clothing/head/welding

/decl/loadout_option/head/welding/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/head/welding/demon,
		/obj/item/clothing/head/welding/engie,
		/obj/item/clothing/head/welding/fancy,
		/obj/item/clothing/head/welding/knight,
		/obj/item/clothing/head/welding/carp
	)

/decl/loadout_option/head/tankccap
	display_name = "padded cap"
	path = /obj/item/clothing/head/tank

/decl/loadout_option/tactical/balaclava
	display_name = "balaclava"
	path = /obj/item/clothing/mask/balaclava

/decl/loadout_option/head/earmuffs
	display_name = "earmuffs"
	path = /obj/item/clothing/head/earmuffs

/decl/loadout_option/head/headphones
	display_name = "headphones"
	path = /obj/item/clothing/head/headphones
