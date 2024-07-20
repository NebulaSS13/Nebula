/obj/item/ball
	name = "beach ball"
	icon = 'icons/obj/beachball.dmi'
	icon_state = ICON_STATE_WORLD
	density = FALSE
	anchored = FALSE
	w_class = ITEM_SIZE_HUGE
	throw_speed = 1
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	material = /decl/material/solid/organic/plastic
	_base_attack_force = 0

/obj/item/ball/afterattack(atom/target, mob/user)
	if(user.try_unequip(src))
		src.throw_at(target, throw_range, throw_speed, user)

/obj/item/ball/volleyball
	name = "volleyball"
	icon = 'icons/obj/volleyball.dmi'
	desc = "You can be my wingman anytime."
	w_class = ITEM_SIZE_LARGE

/obj/item/ball/basketball
	name = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	icon = 'icons/obj/basketball.dmi'
	w_class = ITEM_SIZE_LARGE
