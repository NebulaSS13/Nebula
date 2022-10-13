/obj/item/clothing/head/helmet/space/void/skrell
	name = "alien helmet"
	icon = 'mods/species/bayliens/skrell/icons/clothing/head/skrell_helmet_white.dmi'
	desc = "Smoothly contoured and polished to a shine. Still looks like a fishbowl."
	armor = list(
		DEF_MELEE = ARMOR_MELEE_KNIVES,
		DEF_BULLET = ARMOR_BALLISTIC_PISTOL,
		DEF_LASER = ARMOR_LASER_MAJOR,
		DEF_ENERGY = ARMOR_ENERGY_STRONG,
		DEF_BOMB = ARMOR_BOMB_RESISTANT,
		DEF_BIO = ARMOR_BIO_SHIELDED,
		DEF_RAD = ARMOR_RAD_SHIELDED
		)

/obj/item/clothing/head/helmet/space/void/skrell/mob_can_equip(mob/living/M, slot, disable_warning = 0)
	. = ..()
	var/mob/living/carbon/human/H = M
	if(. && istype(H) && H.bodytype.name != BODYTYPE_SKRELL)
		return FALSE

/obj/item/clothing/head/helmet/space/void/skrell/black
	icon = 'mods/species/bayliens/skrell/icons/clothing/head/skrell_helmet_black.dmi'

/obj/item/clothing/head/helmet/skrell
	name = "skrellian helmet"
	desc = "A helmet built for use by a Skrell. This one appears to be fairly standard and reliable."
	icon = 'mods/species/bayliens/skrell/icons/clothing/head/helmet_skrell.dmi'

/obj/item/clothing/head/helmet/skrell/mob_can_equip(mob/living/M, slot, disable_warning = 0)
	. = ..()
	var/mob/living/carbon/human/H = M
	if(. && istype(H) && H.bodytype.name != BODYTYPE_SKRELL)
		return FALSE