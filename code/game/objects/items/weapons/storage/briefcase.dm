/obj/item/briefcase
	name = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	icon = 'icons/obj/items/storage/briefcase.dmi'
	icon_state = ICON_STATE_WORLD
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	_base_attack_force = 8.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	material = /decl/material/solid/organic/leather/synth
	matter = list(/decl/material/solid/organic/plastic = MATTER_AMOUNT_SECONDARY)
	storage = /datum/storage/briefcase
