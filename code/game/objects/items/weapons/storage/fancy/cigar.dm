/*
 * Cigar
*/
/obj/item/box/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigpacket"
	icon = 'icons/obj/items/storage/cigarcase.dmi'
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/organic/wood/mahogany
	key_type = /obj/item/clothing/mask/smokable/cigarette/cigar
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE
	storage = /datum/storage/box/cigar

/obj/item/box/fancy/cigar/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/box/fancy/cigar/initialize_reagents(populate)
	create_reagents(10 * max(1, storage?.storage_slots))
	. = ..()

/obj/item/box/fancy/cigar/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/cigar = 6)
