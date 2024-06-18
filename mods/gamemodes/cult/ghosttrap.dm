/decl/ghosttrap/cult_shade
	name = "shade"
	ghost_trap_message = "They are occupying a soul stone now."
	ban_checks = list(/decl/special_role/cultist)
	pref_check = "ghost_shade"
	can_set_own_name = FALSE

/decl/ghosttrap/cult_shade/welcome_candidate(var/mob/target)
	var/obj/item/soulstone/S = target.loc
	if(istype(S))
		if(S.is_evil)
			var/decl/special_role/cult = GET_DECL(/decl/special_role/cultist)
			cult.add_antagonist(target.mind)
			to_chat(target, "<b>Remember, you serve the one who summoned you first, and the cult second.</b>")
		else
			to_chat(target, "<b>This soultone has been purified. You do not belong to the cult.</b>")
			to_chat(target, "<b>Remember, you only serve the one who summoned you.</b>")

/decl/ghosttrap/cult_shade/forced(var/mob/user)
	var/obj/item/soulstone/stone = new(get_turf(user))
	stone.shade = new(stone)
	request_player(stone.shade, "The soul stone shade summon ritual has been performed. ")

#ifdef GAMEMODE_PACK_DEITY
/decl/ghosttrap/cult_shade/Initialize()
	ban_checks |= /decl/special_role/godcultist
	. = ..()
#endif