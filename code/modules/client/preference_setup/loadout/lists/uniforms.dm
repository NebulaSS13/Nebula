/decl/loadout_category/uniform
	name = "Uniform"

/decl/loadout_option/uniform
	slot = slot_w_uniform_str
	category = /decl/loadout_category/uniform
	abstract_type = /decl/loadout_option/uniform

/decl/loadout_option/uniform/jumpsuit
	name = "jumpsuit, colour select"
	path = /obj/item/clothing/jumpsuit
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/jumpskirt
	name = "short jumpskirt, colour select"
	path = /obj/item/clothing/jumpsuit/skirt/short
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/jumpskirt_selection
	name = "jumpskirt selection"
	path = /obj/item/clothing/jumpsuit/skirt

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

/decl/loadout_option/uniform/shirt
	name = "shirt selection"
	path = /obj/item/clothing/shirt

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
	name = "cheongsam, colour select"
	path = /obj/item/clothing/dress/cheongsam
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/abaya
	name = "abaya, colour select"
	path = /obj/item/clothing/suit/robe/abaya
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/skirt
	name = "skirt selection"
	path = /obj/item/clothing/skirt
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/skirt/short
	name = "short skirt, colour select"
	path = /obj/item/clothing/skirt/short
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/dress_simple
	name = "short dress, colour select"
	path = /obj/item/clothing/dress/short
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/casual_pants
	name = "casual pants selection"
	path = /obj/item/clothing/pants/casual
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/formal_pants
	name = "formal pants selection"
	path = /obj/item/clothing/pants/formal
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/formal_pants/baggycustom
	name = "baggy suit pants, colour select"
	path = /obj/item/clothing/pants/baggy
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/shorts
	name = "shorts selection"
	path = /obj/item/clothing/pants/shorts
	loadout_flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/shorts/custom
	name = "athletic shorts, colour select"
	path = /obj/item/clothing/pants/shorts/athletic
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/turtleneck
	name = "sweater, colour select"
	path = /obj/item/clothing/shirt/sweater
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/kimono
	name = "kimono, colour select"
	path = /obj/item/clothing/dress/kimono
	loadout_flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/nurse
	name = "dress, nurse"
	path = /obj/item/clothing/dress/nurse
