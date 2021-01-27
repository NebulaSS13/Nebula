/datum/gear/mask/gas/vox
	display_name = "vox breathing mask"
	path = /obj/item/clothing/mask/gas/vox
	sort_category = "Xenowear"
	whitelisted = list(BODYTYPE_VOX)

/obj/item/clothing/mask/gas/vox
	name = "vox breathing mask"
	desc = "A small oxygen filter for use by Vox."
	icon = 'mods/species/vox/icons/clothing/mask_breath.dmi'
	flags_inv = 0
	body_parts_covered = 0
	filtered_gases = list(/decl/material/gas/oxygen)

/obj/item/clothing/mask/gas/vox/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
	
/obj/item/clothing/mask/gas/swat/vox
	name = "alien mask"
	desc = "Clearly not designed for a human face."
	icon = 'mods/species/vox/icons/clothing/mask.dmi'
	body_parts_covered = SLOT_EYES
	bodytype_restricted = list(BODYTYPE_VOX)
	filtered_gases = list(
		/decl/material/gas/oxygen,
		/decl/material/gas/nitrous_oxide,
		/decl/material/gas/chlorine,
		/decl/material/gas/ammonia,
		/decl/material/gas/carbon_monoxide,
		/decl/material/gas/methyl_bromide,
		/decl/material/gas/methane
	)

/obj/item/clothing/mask/gas/swat/vox/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
