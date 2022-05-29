/obj/item/clothing/head/helmet/space/void/skrell
	name = "alien helmet"
	icon = 'mods/species/bayliens/skrell/icons/clothing/head/skrell_helmet_white.dmi'
	desc = "Smoothly contoured and polished to a shine. Still looks like a fishbowl."
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_STRONG,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
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