/decl/loadout_category/uniform
	name = "Uniform"

/decl/loadout_option/uniform
	slot = slot_w_uniform_str
	category = /decl/loadout_category/uniform
	abstract_type = /decl/loadout_option/uniform

/decl/loadout_option/uniform/jumpsuit
	name = "jumpsuit, color select"
	path = /obj/item/clothing/jumpsuit
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_jumpsuit"

/decl/loadout_option/uniform/jumpskirt
	name = "short jumpskirt, color select"
	path = /obj/item/clothing/jumpsuit/skirt/short
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_jumpskirt"

/decl/loadout_option/uniform/jumpskirt_selection
	name = "jumpskirt selection"
	path = /obj/item/clothing/jumpsuit/skirt
	uid = "gear_under_jumpskirt_misc"

/decl/loadout_option/uniform/jumpskirt_selection/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/jumpsuit/skirt,
		/obj/item/clothing/jumpsuit/skirt/roboticist
	)

/decl/loadout_option/uniform/blackjumpshorts
	name = "black jumpsuit shorts"
	path = /obj/item/clothing/jumpsuit/blackjumpshorts
	uid = "gear_under_jumpshorts"

/decl/loadout_option/uniform/shirt
	name = "shirt selection"
	path = /obj/item/clothing/shirt
	uid = "gear_under_shirt"

/decl/loadout_option/uniform/shirt/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/shirt/button,
		/obj/item/clothing/shirt/ubac,
		/obj/item/clothing/shirt/ubac/blue,
		/obj/item/clothing/shirt/ubac/tan,
		/obj/item/clothing/shirt/ubac/green,
		/obj/item/clothing/shirt/tunic,
		/obj/item/clothing/shirt/tunic/short
	)

/decl/loadout_option/uniform/suit
	name = "clothes selection"
	path = /obj/item/clothing/costume
	uid = "gear_under_clothes"

/decl/loadout_option/uniform/suit/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/costume/lawyer_blue,
		/obj/item/clothing/costume/oldman,
		/obj/item/clothing/costume/lawyer_red,
		/obj/item/clothing/costume/lawyer,
		/obj/item/clothing/costume/scratch,
		/obj/item/clothing/costume/lawyer_bluesuit
	)

/decl/loadout_option/uniform/dress_selection
	name = "dress selection"
	path = /obj/item/clothing/dress
	uid = "gear_under_dress"

/decl/loadout_option/uniform/dress_selection/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/dress,
		/obj/item/clothing/dress/green,
		/obj/item/clothing/dress/orange,
		/obj/item/clothing/dress/pink,
		/obj/item/clothing/dress/purple,
		/obj/item/clothing/dress/sun,
		/obj/item/clothing/dress/sun/white
	)

/decl/loadout_option/uniform/cheongsam
	name = "cheongsam, color select"
	path = /obj/item/clothing/dress/cheongsam
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_cheongsam"

/decl/loadout_option/uniform/abaya
	name = "abaya, color select"
	path = /obj/item/clothing/suit/robe/abaya
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_abaya"

/decl/loadout_option/uniform/skirt
	name = "skirt selection"
	path = /obj/item/clothing/skirt
	loadout_flags = GEAR_HAS_TYPE_SELECTION
	uid = "gear_under_skirt"

/decl/loadout_option/uniform/skirt/pleated
	name = "pleated skirt selection"
	path = /obj/item/clothing/skirt/pleated
	loadout_flags = (GEAR_HAS_COLOR_SELECTION | GEAR_HAS_TYPE_SELECTION)
	uid = "gear_under_skirt_pleated"

/decl/loadout_option/uniform/skirt/short
	name = "short skirt, color select"
	path = /obj/item/clothing/skirt/short
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_skirt_c"

/decl/loadout_option/uniform/dress_simple
	name = "short dress, colour select"
	path = /obj/item/clothing/dress/short
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
	path = /obj/item/clothing/shirt/sweater
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_sweater"

/decl/loadout_option/uniform/kimono
	name = "kimono, color select"
	path = /obj/item/clothing/dress/kimono
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_under_kimono"

/decl/loadout_option/uniform/nurse
	name = "dress, nurse"
	path = /obj/item/clothing/dress/nurse
	uid = "gear_under_nurse"
