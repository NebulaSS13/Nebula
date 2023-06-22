/obj/item/beach_ball
	icon = 'icons/misc/beach.dmi'
	icon_state = "ball"
	name = "beach ball"
	item_state = "beachball"
	density = 0
	anchored = 0
	w_class = ITEM_SIZE_HUGE
	force = 0.0
	throwforce = 0
	throw_speed = 1
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	material = /decl/material/solid/plastic

/obj/item/beach_ball/afterattack(atom/target, mob/user)
	if(user.try_unequip(src))
		src.throw_at(target, throw_range, throw_speed, user)