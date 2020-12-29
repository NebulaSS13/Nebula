/obj/item/storage/box/holobadgeNT
	name = "corporate holobadge box"
	desc = "A box containing corporate security holobadges."
	startswith = list(/obj/item/clothing/accessory/badge/holo/NT = 4,
					  /obj/item/clothing/accessory/badge/holo/NT/cord = 2)

/obj/item/clothing/accessory/badge/nanotrasen
	name = "corporate badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a corporate executive."
	icon_state = "ntbadge"
	badge_string = "Corporate Executive Body"
	icon = 'mods/content/corporate/icons/obj/clothing/obj_accessories.dmi'
	accessory_icons = list(slot_w_uniform_str = 'mods/content/corporate/icons/mob/onmob_accessories.dmi', slot_wear_suit_str = 'mods/content/corporate/icons/mob/onmob_accessories.dmi')

/obj/item/clothing/accessory/badge/holo/NT
	name = "corporate holobadge"
	desc = "This glowing green badge marks the holder as a member of corporate security."
	icon_state = "ntholobadge"
	color = null
	badge_string = "Corporate Security"
	badge_access = access_research
	icon = 'mods/content/corporate/icons/obj/clothing/obj_accessories.dmi'
	accessory_icons = list(slot_w_uniform_str = 'mods/content/corporate/icons/mob/onmob_accessories.dmi', slot_wear_suit_str = 'mods/content/corporate/icons/mob/onmob_accessories.dmi')

/obj/item/clothing/accessory/badge/holo/NT/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_FACE | SLOT_TIE
