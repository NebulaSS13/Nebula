/obj/item/clothing/skirt/research_director
	name = "chief science officer dress uniform"
	desc = "Feminine fashion for the style concious CSO. Its fabric provides minor protection from biological contaminants."
	icon = 'icons/clothing/dresses/dress_rd.dmi'
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
	)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS

/obj/item/clothing/skirt/research_director/outfit
	starting_accessories = list(
		/obj/item/clothing/shirt/blouse,
		/obj/item/clothing/neck/tie/green,
		/obj/item/clothing/suit/jacket/research_director
	)
