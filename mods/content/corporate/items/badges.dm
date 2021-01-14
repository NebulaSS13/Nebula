/obj/item/storage/box/holobadgeNT
	name = "corporate holobadge box"
	desc = "A box containing corporate security holobadges."
	startswith = list(
		/obj/item/clothing/accessory/badge/holo/NT = 4,
		/obj/item/clothing/accessory/badge/holo/NT/cord = 2
	)

/obj/item/clothing/accessory/badge/nanotrasen
	name = "corporate badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a corporate executive."
	icon = 'icons/clothing/accessories/badges/detectivebadge.dmi'
	badge_string = "Corporate Executive Body"

/obj/item/clothing/accessory/badge/holo/NT
	name = "corporate holobadge"
	desc = "This glowing green badge marks the holder as a member of corporate security."
	icon = 'mods/content/corporate/icons/clothing/accessories/holobadge.dmi'
	color = null
	badge_string = "Corporate Security"
	badge_access = access_research

/obj/item/clothing/accessory/badge/holo/NT/cord
	icon = 'mods/content/corporate/icons/clothing/accessories/holobadge_cord.dmi'
	slot_flags = SLOT_FACE | SLOT_TIE
