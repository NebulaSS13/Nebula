/obj/item/bladed/axe
	abstract_type  = /obj/item/bladed/axe
	can_be_twohanded = TRUE
	pickup_sound   = 'sound/foley/scrape1.ogg'
	drop_sound     = 'sound/foley/tooldrop1.ogg'
	w_class        = ITEM_SIZE_HUGE
	slot_flags     = SLOT_BACK

/obj/item/bladed/axe/fire
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	icon = 'icons/obj/items/tool/fireaxe.dmi'
	sharp = 1
	edge = 1
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	material = /decl/material/solid/metal/steel
	material_alteration = MAT_FLAG_ALTERATION_NAME

	_base_attack_force = 30

/obj/item/bladed/axe/fire/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_HATCHET = TOOL_QUALITY_DEFAULT))

/obj/item/bladed/axe/fire/afterattack(atom/A, mob/user, proximity)
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
