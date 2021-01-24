/obj/item/clothing/under/vox
	has_sensor = 0

/obj/item/clothing/under/vox/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)

/obj/item/clothing/under/vox/vox_casual
	name = "alien clothing"
	desc = "This doesn't look very comfortable."
	icon = 'mods/species/vox/icons/clothing/under_clothing.dmi'
	body_parts_covered = SLOT_LEGS

/obj/item/clothing/under/vox/vox_robes
	name = "alien robes"
	desc = "Weird and flowing!"
	icon = 'mods/species/vox/icons/clothing/under_robes.dmi'
