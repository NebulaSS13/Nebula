/*
 * Cigar
*/
/obj/item/storage/box/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigpacket"
	icon = 'icons/obj/items/storage/cigarcase.dmi'
	w_class = ITEM_SIZE_SMALL
	throwforce = 2
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/organic/wood/mahogany
	key_type = /obj/item/clothing/mask/smokable/cigarette/cigar
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE
	storage_type = /datum/extension/storage/box/cigar

/obj/item/storage/box/fancy/cigar/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/storage/box/fancy/cigar/initialize_reagents(populate)
	var/datum/extension/storage/storage = get_extension(src, /datum/extension/storage)
	create_reagents(10 * max(1, storage?.storage_slots))
	. = ..()

/obj/item/storage/box/fancy/cigar/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/cigar = 6)
