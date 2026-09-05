/obj/item/clothing/mask/gas/vox
	name = "vox breathing mask"
	desc = "A small beak-worn oxygen filter clearly not designed for a human face. Useless for anyone who breathes a standard mix."
	icon = 'mods/species/vox/icons/clothing/mask_breath.dmi'
	flags_inv = 0
	body_parts_covered = 0
	filtered_gases = list(/decl/material/gas/oxygen)
	bodytype_equip_flags = BODY_EQUIP_FLAG_VOX

/obj/item/clothing/mask/gas/swat/vox
	name = "alien mask"
	desc = "A beaked facemask clearly not designed for human anatomy. Equipped with an oxygen filter, making it useless for anyone who breathes standard mix."
	icon = 'mods/species/vox/icons/clothing/mask.dmi'
	filtered_gases = list(
		/decl/material/gas/oxygen,
		/decl/material/gas/nitrous_oxide,
		/decl/material/gas/chlorine,
		/decl/material/gas/ammonia,
		/decl/material/gas/carbon_monoxide,
		/decl/material/gas/methyl_bromide,
		/decl/material/gas/methane
	)
	body_parts_covered = SLOT_EYES
	bodytype_equip_flags = BODY_EQUIP_FLAG_VOX
