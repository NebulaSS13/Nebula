/obj/item/clothing/gloves/vox
	desc = "These bizarre gauntlets seem to be fitted for... bird claws?"
	name = "insulated gauntlets"
	icon = 'mods/species/vox/icons/clothing/gloves.dmi'
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	bodytype_restricted = list(BODYTYPE_VOX)

/obj/item/clothing/gloves/vox/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
