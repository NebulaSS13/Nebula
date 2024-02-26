
/decl/loadout_option/uniform/pants
	name = "casual pants selection"
	path = /obj/item/clothing/pants/casual
	flags = GEAR_HAS_TYPE_SELECTION
	slot = slot_lower_body_str

/decl/loadout_option/uniform/pants/formal
	name = "formal pants selection"
	path = /obj/item/clothing/pants/formal
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/pants/formal/baggycustom
	name = "baggy suit pants, colour select"
	path = /obj/item/clothing/pants/baggy
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/pants/shorts
	name = "shorts selection"
	path = /obj/item/clothing/pants/shorts
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/pants/shorts/custom
	name = "athletic shorts, colour select"
	path = /obj/item/clothing/pants/shorts/athletic
	flags = GEAR_HAS_COLOR_SELECTION

/decl/loadout_option/uniform/pants/skirt
	name = "skirt selection"
	path = /obj/item/clothing/pants/skirt
	flags = GEAR_HAS_TYPE_SELECTION

/decl/loadout_option/uniform/pants/kilt
	name = "kilt"
	path = /obj/item/clothing/pants/kilt

/decl/loadout_option/uniform/pants/overalls
	name = "denim overalls"
	path = /obj/item/clothing/jumpsuit/overalls

/decl/loadout_option/uniform/pants/overalls/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path/specified_types_list])
	.[/datum/gear_tweak/path/specified_types_list] |= list(
		/obj/item/clothing/jumpsuit/overalls,
		/obj/item/clothing/jumpsuit/overalls/blue,
		/obj/item/clothing/jumpsuit/overalls/yellow,
		/obj/item/clothing/jumpsuit/overalls/laborer
	)
