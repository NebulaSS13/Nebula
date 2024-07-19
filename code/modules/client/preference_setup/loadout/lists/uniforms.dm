/decl/loadout_category/uniform
	name = "Uniform"

/decl/loadout_option/uniform
	slot = slot_w_uniform_str
	category = /decl/loadout_category/uniform
	abstract_type = /decl/loadout_option/uniform

/decl/loadout_option/uniform/jumpsuit
	name = "jumpsuit, color select"
	path = /obj/item/clothing/under/color
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_jumpsuit"

/decl/loadout_option/uniform/shortjumpskirt
	name = "short jumpskirt, color select"
	path = /obj/item/clothing/under/shortjumpskirt
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_jumpskirt"

/decl/loadout_option/uniform/blackjumpshorts
	name = "black jumpsuit shorts"
	path = /obj/item/clothing/under/color/blackjumpshorts
	uid = "gear_under_jumpshorts"

/decl/loadout_option/uniform/suit
	name = "clothes selection"
	path = /obj/item/clothing/under
	uid = "gear_under_clothes"

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
	uid = "gear_under_dress"

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
	name = "cheongsam, color select"
	path = /obj/item/clothing/under/cheongsam
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_cheongsam"

/decl/loadout_option/uniform/abaya
	name = "abaya, color select"
	path = /obj/item/clothing/under/abaya
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_abaya"

/decl/loadout_option/uniform/skirt
	name = "skirt selection"
	path = /obj/item/clothing/under/skirt
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_skirt"

/decl/loadout_option/uniform/skirt_c
	name = "short skirt, color select"
	path = /obj/item/clothing/under/skirt_c
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_skirt_c"

/decl/loadout_option/uniform/skirt_c/dress
	name = "simple dress, color select"
	path = /obj/item/clothing/under/skirt_c/dress
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_simple_dress"

/decl/loadout_option/uniform/casual_pants
	name = "casual pants selection"
	path = /obj/item/clothing/pants/casual
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_pants"

/decl/loadout_option/uniform/formal_pants
	name = "formal pants selection"
	path = /obj/item/clothing/pants/formal
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_pants_formal"

/decl/loadout_option/uniform/formal_pants/baggycustom
	name = "baggy suit pants, color select"
	path = /obj/item/clothing/pants/baggy
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_pants_baggy"

/decl/loadout_option/uniform/shorts
	name = "shorts selection"
	path = /obj/item/clothing/pants/shorts
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_shorts"

/decl/loadout_option/uniform/shorts/custom
	name = "athletic shorts, color select"
	path = /obj/item/clothing/pants/shorts/athletic
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_shorts_athletic"

/decl/loadout_option/uniform/turtleneck
	name = "sweater, color select"
	path = /obj/item/clothing/under/psych/turtleneck/sweater
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_sweater"

/decl/loadout_option/uniform/kimono
	name = "kimono, color select"
	path = /obj/item/clothing/under/kimono
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_kimono"

/decl/loadout_option/uniform/frontier
	name = "frontier clothes"
	path = /obj/item/clothing/under/frontier
	uid = "gear_under_frontier"
