/obj/item/bladed/axe
	abstract_type       = /obj/item/bladed/axe
	can_be_twohanded    = TRUE
	pickup_sound        = 'sound/foley/scrape1.ogg'
	drop_sound          = 'sound/foley/tooldrop1.ogg'
	w_class             = ITEM_SIZE_HUGE
	slot_flags          = SLOT_BACK
	hilt_material       = /decl/material/solid/organic/wood
	guard_material      = /decl/material/solid/organic/leather/gut
	pommel_material     = null
	attack_verb         = list("attacked", "chopped", "cleaved", "torn", "cut")
	_base_attack_force  = 30

// Discard pommel material.
/obj/item/bladed/axe/Initialize(ml, material_key, _hilt_mat, _guard_mat, _pommel_mat)
	return ..(ml, material_key, _hilt_mat, _guard_mat)

/obj/item/bladed/axe/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(proximity && A && is_held_twohanded())
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/vine))
			var/obj/effect/vine/P = A
			P.die_off()
