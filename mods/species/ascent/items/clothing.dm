/decl/hierarchy/outfit/job/ascent
	name = "Ascent - Gyne"
	mask =     /obj/item/clothing/mask/gas/ascent
	uniform =  /obj/item/clothing/under/ascent
	id_type =  /obj/item/card/id/ascent
	shoes =    /obj/item/clothing/shoes/magboots/ascent
	l_ear =    null
	pda_type = null
	pda_slot = 0
	flags =    0

/decl/hierarchy/outfit/job/ascent/attendant
	name = "Ascent - Attendant"
	back = /obj/item/rig/mantid

/decl/hierarchy/outfit/job/ascent/tech
	name = "Ascent - Technician"
	suit = /obj/item/clothing/suit/storage/ascent

/obj/item/clothing/mask/gas/ascent
	name = "mantid facemask"
	desc = "An alien facemask with chunky gas filters and a breathing valve."
	filter_water = TRUE
	icon = 'mods/species/ascent/icons/clothing/mask.dmi'
	sprite_sheets = list(
		BODYTYPE_SNAKE =        'mods/species/ascent/icons/clothing/mask_serpentid.dmi',
		BODYTYPE_MANTID_LARGE = 'mods/species/ascent/icons/clothing/mask_gyne.dmi'
	)
	bodytype_restricted = list(BODYTYPE_MANTID_SMALL, BODYTYPE_MANTID_LARGE)
	filtered_gases = list(
		/decl/material/gas/nitrous_oxide,
		/decl/material/gas/chlorine,
		/decl/material/gas/ammonia,
		/decl/material/gas/carbon_monoxide,
		/decl/material/gas/methane
	)
	flags_inv = 0

/obj/item/clothing/mask/gas/ascent/monarch
	name = "serpentid facemask"
	desc = "An alien facemask with chunky gas filters and a breathing valve."
	filtered_gases = list(
		/decl/material/gas/nitrous_oxide,
		/decl/material/gas/chlorine,
		/decl/material/gas/ammonia,
		/decl/material/gas/carbon_monoxide,
		/decl/material/gas/methyl_bromide,
		/decl/material/gas/methane
	)
	bodytype_restricted = list(BODYTYPE_SNAKE)

/obj/item/clothing/shoes/magboots/ascent
	name = "mantid mag-claws"
	desc = "A set of powerful gripping claws."
	icon = 'mods/species/ascent/icons/magboots/boots.dmi'
	bodytype_restricted = list(BODYTYPE_MANTID_SMALL, BODYTYPE_MANTID_LARGE)
	sprite_sheets = list(
		BODYTYPE_MANTID_LARGE = 'mods/species/ascent/icons/magboots/boots_gyne.dmi'
	)

/obj/item/clothing/under/ascent
	name = "mantid undersuit"
	desc = "A ribbed, spongy undersuit of some sort. It has a big sleeve for a tail, so it probably isn't for humans."
	bodytype_restricted = list(BODYTYPE_MANTID_LARGE, BODYTYPE_MANTID_SMALL)
	icon = 'mods/species/ascent/icons/clothing/under.dmi'
	color = COLOR_DARK_GUNMETAL
	sprite_sheets = list(
		BODYTYPE_MANTID_LARGE = 'mods/species/ascent/icons/clothing/under_gyne.dmi'
	)

/obj/item/clothing/suit/storage/ascent
	name = "mantid gear harness"
	desc = "A complex tangle of articulated cables and straps."
	bodytype_restricted = list(BODYTYPE_MANTID_LARGE, BODYTYPE_MANTID_SMALL, BODYTYPE_SNAKE)
	icon_state = ICON_STATE_WORLD
	icon = 'mods/species/ascent/icons/clothing/under_harness.dmi'
	sprite_sheets = list(
		BODYTYPE_MANTID_LARGE = 'mods/species/ascent/icons/clothing/under_harness_gyne.dmi',
		BODYTYPE_SNAKE =        'mods/species/ascent/icons/clothing/under_harness_serpentid.dmi'
	)
	body_parts_covered = 0
	slot_flags = SLOT_OVER_BODY | SLOT_LOWER_BODY
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/inflatable_dispenser,
		/obj/item/rcd
	)

/obj/item/clothing/suit/storage/ascent/Initialize()
	. = ..()
	for(var/tool in list(
		/obj/item/gun/energy/particle/small,
		/obj/item/multitool/mantid,
		/obj/item/clustertool,
		/obj/item/clustertool,
		/obj/item/weldingtool/electric/mantid,
		/obj/item/stack/medical/resin
	))
		allowed |= tool
		new tool(pockets)
	pockets.make_exact_fit()
	allowed |= /obj/item/chems/drinks/cans/waterbottle/ascent
	pockets.can_hold |= /obj/item/chems/drinks/cans/waterbottle/ascent
