/obj/item/documents
	name = "private memos and faxes"
	desc = "\"Top Secret\" memos and faxes between the celebrities, officials and politicians. It's like a chat client ran on pure paperwork."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "docs_generic"
	item_state = "paper"
	w_class = ITEM_SIZE_TINY
	throw_range = 1
	material = /decl/material/solid/organic/paper
	_base_attack_force = 0
	var/description_antag = "These conversations contain a massive amount of dirt on major figures: drugs, sex, money..."

/obj/item/documents/examine(mob/user)
	. = ..()
	if(description_antag)
		to_chat(user, description_antag)
