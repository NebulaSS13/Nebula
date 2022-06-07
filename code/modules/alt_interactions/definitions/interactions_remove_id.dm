/decl/interaction_handler/remove_id
	name = "Remove ID"

/decl/interaction_handler/remove_id/modular_computer
	expected_target_type = /obj/item/modular_computer

/decl/interaction_handler/remove_id/modular_computer/is_possible(atom/target, mob/user)
	. = ..()
	if(.)
		var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
		. = !!(assembly?.get_component(PART_CARD))

/decl/interaction_handler/remove_id/modular_computer/invoked(atom/target, mob/user)
	var/datum/extension/assembly/assembly = get_extension(target, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/card_slot/card_slot = assembly.get_component(PART_CARD)
	if(card_slot.stored_card)
		card_slot.eject_id(user)

/decl/interaction_handler/remove_id/wallet
	expected_target_type = /obj/item/storage/wallet

/decl/interaction_handler/remove_id/wallet/is_possible(atom/target, mob/user)
	. = ..() && ishuman(user)
	
/decl/interaction_handler/remove_id/wallet/invoked(atom/target, mob/user)
	var/obj/item/storage/wallet/W = target
	var/obj/item/card/id/id = W.GetIdCard()
	if (istype(id))
		W.remove_from_storage(id)
		user.put_in_hands(id)
