/obj/item/saddle
	name                = "saddle"
	desc                = "An arrangement of padding and straps used to make it easier to ride atop an animal."
	icon                = 'icons/obj/items/saddle.dmi'
	icon_state          = ICON_STATE_WORLD
	w_class             = ITEM_SIZE_HUGE
	slot_flags          = SLOT_BACK
	material            = /decl/material/solid/organic/leather
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/saddle/mob_can_equip(mob/user, slot, disable_warning, force, ignore_equipped)
	if(!istype(user, /mob/living/simple_animal/passive/horse))
		return FALSE
	return ..()

/obj/item/saddle/equipped(mob/user, slot)
	. = ..()
	if(user == loc && slot == slot_back_str)
		user.can_buckle = TRUE

/obj/item/saddle/dropped(mob/user)
	. = ..()
	if(user)
		user.can_buckle = initial(user.can_buckle)
