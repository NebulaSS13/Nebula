/obj/structure/handrail
	name = "handrail"
	icon = 'icons/obj/structures/handrail.dmi'
	icon_state = "handrail"
	desc = "A safety railing with buckles to secure yourself to when floor isn't stable enough."
	density = FALSE
	anchored = TRUE
	can_buckle = TRUE
	buckle_sound = 'sound/effects/buckle.ogg'
	buckle_allow_rotation = TRUE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/structure/handrail/attack_hand(mob/user)
	if(!can_buckle || buckled_mob || !istype(user) || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	user_buckle_mob(user, user)
	return TRUE
