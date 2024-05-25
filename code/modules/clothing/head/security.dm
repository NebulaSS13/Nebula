/obj/item/clothing/head/det
	name = "fedora"
	desc = "A brown fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."
	icon = 'icons/clothing/head/detective.dmi'
	color = "#725443"
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR
		)
	siemens_coefficient = 0.9
	flags_inv = BLOCK_HEAD_HAIR
	markings_state_modifier = "band"
	markings_color = "#b2977c"
	material = /decl/material/solid/organic/leather
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/clothing/head/det/attack_self(mob/user)
	flags_inv ^= BLOCK_HEAD_HAIR
	to_chat(user, "<span class='notice'>[src] will now [flags_inv & BLOCK_HEAD_HAIR ? "hide" : "show"] hair.</span>")
	..()

/obj/item/clothing/head/det/grey
	color = COLOR_GRAY40
	markings_color = COLOR_SILVER
	desc = "A grey fedora - either the cornerstone of a detective's style or a poor attempt at looking cool, depending on the person wearing it."

/obj/item/clothing/head/det/wack
	color = COLOR_VIOLET
	markings_color = COLOR_YELLOW
	desc = "A colorful fedora - either the cornerstone of a detective's style or a poor attempt at looking disco, depending on the person wearing it."

/obj/item/clothing/head/HoS
	name = "Head of Security hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon = 'icons/clothing/head/hos.dmi'
	body_parts_covered = 0
	siemens_coefficient = 0.8
	material = /decl/material/solid/organic/leather

/obj/item/clothing/head/warden
	name = "warden's hat"
	desc = "It's a special helmet issued to the Warden of a security force."
	icon = 'icons/clothing/head/warden.dmi'
	body_parts_covered = 0
