//UNDER

/decl/loadout_option/uniform/cyberpunkharness
	name = "cyberpunk strapped harness"
	path = /obj/item/clothing/outfit/cyberpunkharness
	uid = "gear_under_cyberpunkharness"

/decl/loadout_option/uniform/cyberpunkpants
	name = "cyberpunk split-side ensemble"
	path = /obj/item/clothing/outfit/cyberpunkpants
	uid = "gear_under_cyberpunkpants"

/decl/loadout_option/uniform/rippedpunk
	name = "ripped punk jeans ensemble"
	path = /obj/item/clothing/outfit/rippedpunk
	uid = "gear_under_rippedpunk"

/decl/loadout_option/uniform/magicalgirl
	name = "magical girl costume selection"
	description = "A selection of anime-accurate magical girl costumes."
	path = /obj/item/clothing/costume/magicalgirl
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_magicalgirl"

/decl/loadout_option/uniform/maid
	name = "maid uniform selection"
	description = "A selection of maid uniforms, of varying style and practicality."
	path = /obj/item/clothing/dress/maiduniform
	uid = "gear_under_maid"

/decl/loadout_option/uniform/maid/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/dress/maiduniform,
		/obj/item/clothing/dress/maidcostume,
		/obj/item/clothing/dress/maidproper,
		/obj/item/clothing/dress/maidsexy
	)

/decl/loadout_option/uniform/cheongsam_alt
	name = "cheongsam selection"
	description = "A selection of Chinese-style figure-fitting dresses, also known as qipao."
	path = /obj/item/clothing/dress/cheongsam_black
	uid = "gear_under_cheongsam_alt"

/decl/loadout_option/uniform/cheongsam_alt/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/dress/cheongsam_black,
		/obj/item/clothing/dress/cheongsam_blue,
		/obj/item/clothing/dress/cheongsam_darkblue,
		/obj/item/clothing/dress/cheongsam_darkred,
		/obj/item/clothing/dress/cheongsam_green,
		/obj/item/clothing/dress/cheongsam_purple,
		/obj/item/clothing/dress/cheongsam_red,
		/obj/item/clothing/dress/cheongsam_white,
		/obj/item/clothing/dress/qipao
	)

/decl/loadout_option/uniform/dress_selection_mid
	name = "dress selection (mid-length)"
	description = "A selection of dresses around knee to shin length."
	path = /obj/item/clothing/dress/blackgold
	uid = "gear_under_dress_mid"

/decl/loadout_option/uniform/dress_selection_mid/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/dress/blackgold,
		/obj/item/clothing/dress/flamenco,
		/obj/item/clothing/dress/festive,
		/obj/item/clothing/dress/floofy,
		/obj/item/clothing/dress/goldwrap,
		/obj/item/clothing/dress/gothiclolita,
		/obj/item/clothing/dress/icefairy,
		/obj/item/clothing/dress/sheerblue,
		/obj/item/clothing/dress/yellowswoop
	)

/decl/loadout_option/uniform/dress_selection_long
	name = "dress selection (long)"
	description = "A selection of dresses around ankle to floor length."
	path = /obj/item/clothing/dress/alpine
	uid = "gear_under_dress_long"

/decl/loadout_option/uniform/dress_selection_long/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/dress/alpine,
		/obj/item/clothing/dress/barmaid,
		/obj/item/clothing/dress/countess,
		/obj/item/clothing/dress/flower,
		/obj/item/clothing/dress/formalred,
		/obj/item/clothing/dress/goddess,
		/obj/item/clothing/dress/gothic,
		/obj/item/clothing/dress/lilac,
		/obj/item/clothing/dress/redeveninggown,
		/obj/item/clothing/dress/whitegown,
		/obj/item/clothing/dress/revealing,
		/obj/item/clothing/dress/western,
		/obj/item/clothing/dress/sarired,
		/obj/item/clothing/dress/sarigreen,
		/obj/item/clothing/dress/redswept,
		/obj/item/clothing/dress/tango_alt,
		/obj/item/clothing/dress/solara
	)


//SUIT

/decl/loadout_option/suit/costume
	name = "costume selection"
	description = "A selection of ridiculous costumes you probably shouldn't wear to work."
	path = /obj/item/clothing/suit
	cost = 2
	uid = "gear_suit_costume"

/decl/loadout_option/suit/costume/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/suit/lobster
	)

//HEAD

/decl/loadout_option/head/costume
	name = "costume selection"
	description = "A selection of ridiculous costume hats that are likely to elicit funny looks."
	path = /obj/item/clothing/head
	uid = "gear_head_costume"

/decl/loadout_option/head/costume/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/head/lobster
	)