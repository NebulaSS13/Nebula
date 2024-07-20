/obj/item/bladed/polearm
	abstract_type    = /obj/item/bladed/polearm
	can_be_twohanded = TRUE
	pickup_sound     = 'sound/foley/scrape1.ogg'
	drop_sound       = 'sound/foley/tooldrop1.ogg'
	w_class          = ITEM_SIZE_HUGE
	slot_flags       = SLOT_BACK
	hilt_material    = /decl/material/solid/organic/wood
	guard_material   = /decl/material/solid/organic/leather/gut
	pommel_material  = null

// Discard pommel material.
/obj/item/bladed/polearm/Initialize(ml, material_key, _hilt_mat, _guard_mat, _pommel_mat)
	return ..(ml, material_key, _hilt_mat, _guard_mat, _pommel_mat)
