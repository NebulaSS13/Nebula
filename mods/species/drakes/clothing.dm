/obj/item/backpack
	_drake_onmob_icon = 'mods/species/drakes/icons/clothing/backpack.dmi'
	_drake_hatchling_onmob_icon = 'mods/species/drakes/icons/clothing/hatchling_backpack.dmi'

/obj/item/card/id
	_drake_onmob_icon = 'mods/species/drakes/icons/clothing/id.dmi'
	_drake_hatchling_onmob_icon = 'mods/species/drakes/icons/clothing/hatchling_id.dmi'

/obj/item/bag
	_drake_onmob_icon = 'mods/species/drakes/icons/clothing/sack.dmi'
	_drake_hatchling_onmob_icon = 'mods/species/drakes/icons/clothing/hatchling_backpack.dmi'

/obj/item/backpack/drake_harness
	name = "animal harness"
	desc = "A tough hard-wearing harness with storage pouches, designed for some kind of quadrupedal animal."
	icon = 'mods/species/drakes/icons/drake_harness.dmi'
	material = /decl/material/solid/organic/leather
	material_alteration = MAT_FLAG_ALTERATION_ALL
	body_parts_covered = SLOT_UPPER_BODY
	_drake_onmob_icon = null

/obj/item/backpack/drake_harness/mob_can_equip(mob/user, slot, disable_warning = FALSE, force = FALSE, ignore_equipped = FALSE)
	. = ..() && (user.get_bodytype()?.bodytype_flag & BODY_EQUIP_FLAG_DRAKE)
