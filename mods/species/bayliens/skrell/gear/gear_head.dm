/obj/item/clothing/head/helmet/space/void/skrell
	name = "alien helmet"
	icon = 'mods/species/bayliens/skrell/icons/clothing/head/skrell_helmet_white.dmi'
	desc = "Smoothly contoured and polished to a shine. Still looks like a fishbowl."
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_STRONG,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
		)

/obj/item/clothing/head/helmet/space/void/skrell/mob_can_equip(mob/living/M, slot, disable_warning = 0, force = 0, ignore_equipped = 0)
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

/obj/item/clothing/head/helmet/skrell/mob_can_equip(mob/living/M, slot, disable_warning = 0, force = 0, ignore_equipped = 0)
	. = ..()
	var/mob/living/carbon/human/H = M
	if(. && istype(H) && H.bodytype.name != BODYTYPE_SKRELL)
		return FALSE