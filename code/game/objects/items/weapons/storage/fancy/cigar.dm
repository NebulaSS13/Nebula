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
	max_w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_LOWER_BODY
	storage_slots = 7
	material = /decl/material/solid/organic/wood/mahogany
	key_type = /obj/item/clothing/mask/smokable/cigarette/cigar
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE

/obj/item/storage/box/fancy/cigar/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/storage/box/fancy/cigar/initialize_reagents(populate)
	create_reagents(10 * storage_slots)
	. = ..()

/obj/item/storage/box/fancy/cigar/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/cigar = 6)

/obj/item/storage/box/fancy/cigar/remove_from_storage(obj/item/W, atom/new_location)
	var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
	if(!istype(C))
		return
	reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	return ..()
