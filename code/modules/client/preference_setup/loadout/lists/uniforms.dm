/decl/loadout_category/uniform
	name = "Uniform"
	
/decl/loadout_option/uniform
	slot = slot_w_uniform_str
	category = /decl/loadout_category/uniform

/decl/loadout_option/uniform/jumpsuit
	name = "jumpsuit, colour select"
	path = /obj/item/clothing/under/color
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/shortjumpskirt
	name = "short jumpskirt, colour select"
	path = /obj/item/clothing/under/shortjumpskirt
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/blackjumpshorts
	name = "black jumpsuit shorts"
	path = /obj/item/clothing/under/color/blackjumpshorts

/decl/loadout_option/uniform/suit
	name = "clothes selection"
	path = /obj/item/clothing/under

/decl/loadout_option/uniform/suit/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/lawyer/blue,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/female,
		/obj/item/clothing/under/gentlesuit,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/under/lawyer/purpsuit,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/scratch,
		/obj/item/clothing/under/lawyer/bluesuit,
		/obj/item/clothing/under/internalaffairs/plain,
		/obj/item/clothing/under/blazer,
		/obj/item/clothing/under/blackjumpskirt,
		/obj/item/clothing/under/kilt,
		/obj/item/clothing/under/dress/dress_hr,
		/obj/item/clothing/under/det,
		/obj/item/clothing/under/det/black,
		/obj/item/clothing/under/det/grey
	)

/decl/loadout_option/uniform/dress
	name = "dress selection"
	path = /obj/item/clothing/under

/decl/loadout_option/uniform/dress/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/under/sundress_white,
		/obj/item/clothing/under/dress,
		/obj/item/clothing/under/dress/dress_green,
		/obj/item/clothing/under/dress/dress_orange,
		/obj/item/clothing/under/dress/dress_pink,
		/obj/item/clothing/under/dress/dress_purple,
		/obj/item/clothing/under/sundress
	)

/decl/loadout_option/uniform/cheongsam
	name = "cheongsam, colour select"
	path = /obj/item/clothing/under/cheongsam
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/abaya
	name = "abaya, colour select"
	path = /obj/item/clothing/under/abaya
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/skirt
	name = "skirt selection"
	path = /obj/item/clothing/under/skirt
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/skirt_c
	name = "short skirt, colour select"
	path = /obj/item/clothing/under/skirt_c
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/skirt_c/dress
	name = "simple dress, colour select"
	path = /obj/item/clothing/under/skirt_c/dress
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/casual_pants
	name = "casual pants selection"
	path = /obj/item/clothing/pants/casual
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/formal_pants
	name = "formal pants selection"
	path = /obj/item/clothing/pants/formal
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/formal_pants/baggycustom
	name = "baggy suit pants, colour select"
	path = /obj/item/clothing/pants/baggy
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/shorts
	name = "shorts selection"
	path = /obj/item/clothing/pants/shorts
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/shorts/custom
	name = "athletic shorts, colour select"
	path = /obj/item/clothing/pants/shorts/athletic
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/turtleneck
	name = "sweater, colour select"
	path = /obj/item/clothing/under/psych/turtleneck/sweater
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/kimono
	name = "kimono, colour select"
	path = /obj/item/clothing/under/kimono
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/frontier
	name = "frontier clothes"
	path = /obj/item/clothing/under/frontier 
