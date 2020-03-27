//ATTACK GHOST IGNORING PARENT RETURN VALUE
/obj/item/spirit_board/attack_ghost(var/mob/observer/ghost/user)
	if(GLOB.cult.max_cult_rating >= CULT_GHOSTS_2)
		spirit_board_pick_letter(user)
	return ..()